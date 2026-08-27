use cirru_edn::{Edn, EdnListView};
use reqwest::{
  Method,
  header::{HeaderMap, HeaderName, HeaderValue},
};
use std::panic::{AssertUnwindSafe, catch_unwind};
use std::sync::Arc;
use std::thread::{sleep, spawn};
use std::time::Duration;
use std::{ptr, slice};

const ASYNC_PROTOCOL_VERSION: u32 = 1;
const ASYNC_STATUS_OK: i32 = 0;
const ASYNC_STATUS_QUEUE_FULL: i32 = 7;
const ASYNC_STATUS_INVALID_PAYLOAD: i32 = 8;
const ASYNC_STATUS_INTERNAL_ERROR: i32 = 9;
const ASYNC_TASK_ONE_SHOT: u32 = 1;
const ASYNC_TASK_SERIAL_EVENTS: u32 = 1;
const ASYNC_EVENT_EMIT: u32 = 1;
const ASYNC_EVENT_COMPLETE: u32 = 2;
const ASYNC_EVENT_FAIL: u32 = 3;

type AsyncHostEnqueue = unsafe extern "C" fn(u64, u64, u32, u64, *const u8, usize) -> i32;
type AsyncTaskCancel = unsafe extern "C" fn(u64, u64, *const u8, usize) -> i32;
type AsyncResponseResolve = unsafe extern "C" fn(u64, u64, u32, *const u8, usize) -> i32;
type AsyncHostConfigure = unsafe extern "C" fn(u64, u64, u32, u32, u64, Option<AsyncTaskCancel>) -> i32;
type AsyncHostOpenResponse = unsafe extern "C" fn(u64, u64, u64, u64, Option<AsyncResponseResolve>, *mut u64) -> i32;

#[repr(C)]
#[derive(Clone, Copy)]
pub struct CalcitFfiAsyncTaskV1 {
  protocol_version: u32,
  struct_size: u32,
  handle: u64,
  kind: u32,
  flags: u32,
}

#[repr(C)]
#[derive(Clone, Copy)]
pub struct CalcitFfiAsyncHostV1 {
  protocol_version: u32,
  struct_size: u32,
  context: u64,
  enqueue: Option<AsyncHostEnqueue>,
  configure_task: Option<AsyncHostConfigure>,
  open_response: Option<AsyncHostOpenResponse>,
}

unsafe fn read_abi_header<T>(value: *const T) -> Result<(u32, u32), i32> {
  if value.is_null() {
    return Err(ASYNC_STATUS_INVALID_PAYLOAD);
  }
  let bytes = value.cast::<u8>();
  // SAFETY: every versioned descriptor begins with two readable u32 fields.
  let protocol_version = unsafe { ptr::read_unaligned(bytes.cast::<u32>()) };
  // SAFETY: the second header field begins four bytes after the first.
  let struct_size = unsafe { ptr::read_unaligned(bytes.add(std::mem::size_of::<u32>()).cast::<u32>()) };
  Ok((protocol_version, struct_size))
}

unsafe fn copy_task_descriptor(value: *const CalcitFfiAsyncTaskV1) -> Result<CalcitFfiAsyncTaskV1, i32> {
  // SAFETY: forwarded from the versioned descriptor contract.
  let (version, size) = unsafe { read_abi_header(value) }?;
  if version != ASYNC_PROTOCOL_VERSION || size < std::mem::size_of::<CalcitFfiAsyncTaskV1>() as u32 {
    return Err(ASYNC_STATUS_INVALID_PAYLOAD);
  }
  // SAFETY: the validated size covers every v1 field.
  Ok(unsafe { ptr::read_unaligned(value) })
}

unsafe fn copy_host_descriptor(value: *const CalcitFfiAsyncHostV1) -> Result<CalcitFfiAsyncHostV1, i32> {
  // SAFETY: forwarded from the versioned descriptor contract.
  let (version, size) = unsafe { read_abi_header(value) }?;
  if version != ASYNC_PROTOCOL_VERSION || size < std::mem::size_of::<CalcitFfiAsyncHostV1>() as u32 {
    return Err(ASYNC_STATUS_INVALID_PAYLOAD);
  }
  // SAFETY: the validated size covers every v1 field.
  Ok(unsafe { ptr::read_unaligned(value) })
}

pub fn wrap_ok(x: Edn) -> Edn {
  Edn::enum_value("ok", vec![x])
}
pub fn wrap_err(x: Edn) -> Edn {
  Edn::enum_value("err", vec![x])
}

struct RequestSkeleton {
  method: Method,
  headers: HeaderMap,
  body: String,
  query: Vec<(Box<str>, Box<str>)>,
}

#[unsafe(no_mangle)]
pub fn abi_version() -> String {
  String::from("0.0.9")
}

#[unsafe(no_mangle)]
pub fn edn_version() -> String {
  cirru_edn::version().to_string()
}

#[unsafe(no_mangle)]
pub extern "C" fn calcit_ffi_async_version() -> u32 {
  ASYNC_PROTOCOL_VERSION
}

fn encode_event_args(values: Vec<Edn>) -> Result<Vec<u8>, String> {
  cirru_edn::format(&Edn::List(EdnListView(values)), true)
    .map(String::into_bytes)
    .map_err(|error| format!("failed to encode fetch callback payload: {error}"))
}

fn encode_failure(message: impl Into<String>) -> Vec<u8> {
  let message = Edn::str(message.into());
  cirru_edn::format(&message, true)
    .unwrap_or_else(|_| "do |failed-to-encode-fetch-error".to_owned())
    .into_bytes()
}

fn enqueue_with_backpressure(host: CalcitFfiAsyncHostV1, task: CalcitFfiAsyncTaskV1, kind: u32, payload: &[u8]) -> i32 {
  let Some(enqueue) = host.enqueue else {
    return ASYNC_STATUS_INVALID_PAYLOAD;
  };
  loop {
    let status = unsafe { enqueue(host.context, task.handle, kind, 0, payload.as_ptr(), payload.len()) };
    if status != ASYNC_STATUS_QUEUE_FULL {
      return status;
    }
    sleep(Duration::from_millis(1));
  }
}

fn publish_fetch_result(host: CalcitFfiAsyncHostV1, task: CalcitFfiAsyncTaskV1, result: Edn) -> i32 {
  let payload = match encode_event_args(vec![result]) {
    Ok(payload) => payload,
    Err(error) => {
      let failure = encode_failure(error);
      return enqueue_with_backpressure(host, task, ASYNC_EVENT_FAIL, &failure);
    }
  };
  let status = enqueue_with_backpressure(host, task, ASYNC_EVENT_EMIT, &payload);
  if status != ASYNC_STATUS_OK {
    return status;
  }
  enqueue_with_backpressure(host, task, ASYNC_EVENT_COMPLETE, b"&unit")
}

unsafe fn decode_async_request(request_ptr: *const u8, request_len: usize) -> Result<Vec<Edn>, String> {
  if request_ptr.is_null() && request_len != 0 {
    return Err("fetch async request pointer is null".to_owned());
  }
  let request = if request_len == 0 {
    &[]
  } else {
    // SAFETY: the host keeps the request readable for this start call.
    unsafe { slice::from_raw_parts(request_ptr, request_len) }
  };
  let source = std::str::from_utf8(request).map_err(|error| format!("fetch async request is not UTF-8: {error}"))?;
  let data = cirru_edn::parse(source).map_err(|error| format!("fetch async request is not valid Cirru EDN: {error}"))?;
  let Edn::List(EdnListView(args)) = data else {
    return Err("fetch async request must be a Cirru EDN list".to_owned());
  };
  Ok(args)
}

fn perform_fetch(url: Arc<str>, options: Edn) -> Edn {
  let result = (|| -> Result<String, String> {
    let client = reqwest::blocking::Client::new();
    let options = parse_request_options(&options)?;
    let builder = match options.method {
      Method::GET => client.get(&*url),
      Method::POST => client.post(&*url),
      Method::PUT => client.put(&*url),
      Method::PATCH => client.patch(&*url),
      Method::DELETE => client.delete(&*url),
      method => return Err(format!("unexpected method: {method}")),
    };
    builder
      .body(options.body)
      .headers(options.headers)
      .query(&options.query)
      .send()
      .map_err(|error| format!("fetch failed: {error}"))?
      .text()
      .map_err(|error| format!("failed to turn body into text: {error}"))
  })();
  match result {
    Ok(text) => wrap_ok(Edn::str(text)),
    Err(error) => wrap_err(Edn::str(error)),
  }
}

unsafe fn start_fetch_async_v1(
  request_ptr: *const u8,
  request_len: usize,
  task: *const CalcitFfiAsyncTaskV1,
  host: *const CalcitFfiAsyncHostV1,
) -> i32 {
  let task = match unsafe { copy_task_descriptor(task) } {
    Ok(task) => task,
    Err(status) => return status,
  };
  let host = match unsafe { copy_host_descriptor(host) } {
    Ok(host) => host,
    Err(status) => return status,
  };
  let args = match unsafe { decode_async_request(request_ptr, request_len) } {
    Ok(args) => args,
    Err(_) => return ASYNC_STATUS_INVALID_PAYLOAD,
  };
  let [Edn::Str(url), options] = args.as_slice() else {
    return ASYNC_STATUS_INVALID_PAYLOAD;
  };
  let Some(configure) = host.configure_task else {
    return ASYNC_STATUS_INVALID_PAYLOAD;
  };
  let status = unsafe { configure(host.context, task.handle, ASYNC_TASK_ONE_SHOT, ASYNC_TASK_SERIAL_EVENTS, 0, None) };
  if status != ASYNC_STATUS_OK {
    return status;
  }
  let url = url.to_owned();
  let options = options.to_owned();
  spawn(move || {
    let status = match catch_unwind(AssertUnwindSafe(|| perform_fetch(url, options))) {
      Ok(result) => publish_fetch_result(host, task, result),
      Err(_) => {
        let failure = encode_failure("fetch worker panicked");
        enqueue_with_backpressure(host, task, ASYNC_EVENT_FAIL, &failure)
      }
    };
    if status != ASYNC_STATUS_OK {
      eprintln!("fetch async task {} failed to publish with status {status}", task.handle);
    }
  });
  ASYNC_STATUS_OK
}

/// Start one HTTP request through Calcit's C-safe async task protocol v1.
///
/// # Safety
///
/// Request bytes and both descriptors must remain readable for this call. The
/// function copies every value needed by the background request before it
/// returns.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn fetch_calcit_ffi_async_v1(
  request_ptr: *const u8,
  request_len: usize,
  task: *const CalcitFfiAsyncTaskV1,
  host: *const CalcitFfiAsyncHostV1,
) -> i32 {
  catch_unwind(AssertUnwindSafe(|| {
    // SAFETY: forwarded from the exported C contract above.
    unsafe { start_fetch_async_v1(request_ptr, request_len, task, host) }
  }))
  .unwrap_or(ASYNC_STATUS_INTERNAL_ERROR)
}

#[unsafe(no_mangle)]
pub fn fetch(
  args: Vec<Edn>,
  handler: Arc<dyn Fn(Vec<Edn>) -> Result<Edn, String> + Send + Sync + 'static>,
  finish: Box<dyn FnOnce() + Send + Sync + 'static>,
) -> Result<Edn, String> {
  if args.len() == 2 {
    if let Edn::Str(url_raw) = &args[0] {
      let options = args[1].to_owned();
      let url = url_raw.to_owned();
      spawn(move || {
        let result = perform_fetch(url, options);
        let ret = handler(vec![result]);
        finish();
        ret
      });

      Ok(Edn::Nil)
    } else {
      Err(format!("fetch expected 1 url, got {:?}", args))
    }
  } else {
    Err(format!("fetch expected 2 arguments, got {:?}", args))
  }
}

fn parse_request_options(info: &Edn) -> Result<RequestSkeleton, String> {
  let mut req = RequestSkeleton {
    method: Method::GET,
    headers: HeaderMap::new(),
    body: "".to_owned(),
    query: vec![],
  };

  match info {
    Edn::Map(m) => {
      req.method = match m.get(&Edn::tag("method")) {
        Some(Edn::Tag(k)) => k.ref_str().parse::<Method>().map_err(|x| x.to_string())?,
        None => Method::GET,
        Some(a) => return Err(format!("invalid method name: {}", a)),
      };
      req.body = match m.get(&Edn::tag("body")) {
        Some(Edn::Str(s)) => (*s).to_string(),
        None => "".to_owned(),
        Some(a) => a.to_string(),
      };
      match m.get(&Edn::tag("headers")) {
        Some(Edn::Map(xs)) => {
          for (k, v) in &xs.0 {
            match (k, v) {
              (Edn::Str(k2), Edn::Str(v2)) => {
                let name = k2
                  .parse::<HeaderName>()
                  .map_err(|error| format!("invalid header name {k2:?}: {error}"))?;
                let value = v2
                  .parse::<HeaderValue>()
                  .map_err(|error| format!("invalid value for header {k2:?}: {error}"))?;
                req.headers.insert(name, value);
              }
              (Edn::Tag(k2), Edn::Str(v2)) => {
                let name = k2
                  .ref_str()
                  .parse::<HeaderName>()
                  .map_err(|error| format!("invalid header name {k2}: {error}"))?;
                let value = v2
                  .parse::<HeaderValue>()
                  .map_err(|error| format!("invalid value for header {k2}: {error}"))?;
                req.headers.insert(name, value);
              }
              _ => return Err(format!("expected strings for headers: {}, {}", k, v)),
            }
          }
        }
        None => {
          // nothing
        }
        Some(a) => return Err(format!("expected list of pairs for queries: {}", a)),
      }

      match m.get(&Edn::tag("query")) {
        Some(Edn::List(xs)) => {
          for x in xs {
            if let Edn::List(ys) = x
              && ys.len() == 2
            {
              match (&ys.0[0], &ys.0[1]) {
                (Edn::Str(k), Edn::Str(v)) => {
                  req.query.push((Box::from(&**k), Box::from(&**v)));
                  // quit jump to next call
                  continue;
                }
                (Edn::Tag(k), Edn::Str(v)) => {
                  req.query.push((k.ref_str().into(), Box::from(&**v)));
                  // quit jump to next call
                  continue;
                }
                (a, b) => return Err(format!("expected strings, got: {} {}", a, b)),
              }
            }
            return Err(format!("invliad data for header: {}", x));
          }
        }
        None => {
          // nothing
        }
        Some(a) => return Err(format!("expected list of pairs for queries: {}", a)),
      }
    }
    Edn::Nil => {
      // use default
    }
    _ => return Err(format!("invalid options: {}", info)),
  }

  Ok(req)
}

#[cfg(test)]
mod tests {
  use super::*;
  use std::sync::{LazyLock, Mutex};

  type RecordedEvent = (u32, Vec<u8>);
  static EVENTS: LazyLock<Mutex<Vec<RecordedEvent>>> = LazyLock::new(|| Mutex::new(vec![]));

  unsafe extern "C" fn record_enqueue(
    _context: u64,
    _task_handle: u64,
    kind: u32,
    _response_handle: u64,
    payload_ptr: *const u8,
    payload_len: usize,
  ) -> i32 {
    let payload = if payload_len == 0 {
      vec![]
    } else {
      // SAFETY: the test caller keeps this payload readable for the call.
      unsafe { slice::from_raw_parts(payload_ptr, payload_len) }.to_vec()
    };
    EVENTS.lock().expect("event lock").push((kind, payload));
    ASYNC_STATUS_OK
  }

  unsafe extern "C" fn accept_configure(
    _context: u64,
    _task_handle: u64,
    _kind: u32,
    _flags: u32,
    _task_context: u64,
    _cancel: Option<AsyncTaskCancel>,
  ) -> i32 {
    ASYNC_STATUS_OK
  }

  unsafe extern "C" fn reject_open_response(
    _context: u64,
    _task_handle: u64,
    _response_context: u64,
    _timeout_ms: u64,
    _resolve: Option<AsyncResponseResolve>,
    _out_handle: *mut u64,
  ) -> i32 {
    ASYNC_STATUS_INVALID_PAYLOAD
  }

  fn test_task() -> CalcitFfiAsyncTaskV1 {
    CalcitFfiAsyncTaskV1 {
      protocol_version: ASYNC_PROTOCOL_VERSION,
      struct_size: std::mem::size_of::<CalcitFfiAsyncTaskV1>() as u32,
      handle: 7,
      kind: ASYNC_TASK_ONE_SHOT,
      flags: ASYNC_TASK_SERIAL_EVENTS,
    }
  }

  fn test_host() -> CalcitFfiAsyncHostV1 {
    CalcitFfiAsyncHostV1 {
      protocol_version: ASYNC_PROTOCOL_VERSION,
      struct_size: std::mem::size_of::<CalcitFfiAsyncHostV1>() as u32,
      context: 7,
      enqueue: Some(record_enqueue),
      configure_task: Some(accept_configure),
      open_response: Some(reject_open_response),
    }
  }

  #[test]
  fn async_protocol_version_and_layout_are_stable() {
    assert_eq!(calcit_ffi_async_version(), 1);
    assert_eq!(std::mem::size_of::<CalcitFfiAsyncTaskV1>(), 24);
    assert_eq!(std::mem::size_of::<CalcitFfiAsyncHostV1>(), 40);

    let mut short_task = test_task();
    short_task.struct_size = 8;
    assert!(matches!(
      unsafe { copy_task_descriptor(&short_task) },
      Err(ASYNC_STATUS_INVALID_PAYLOAD)
    ));
  }

  #[test]
  fn fetch_result_publishes_one_emit_then_explicit_unit_completion() {
    EVENTS.lock().expect("event lock").clear();
    assert_eq!(
      publish_fetch_result(test_host(), test_task(), wrap_err(Edn::str("offline"))),
      ASYNC_STATUS_OK
    );
    let events = EVENTS.lock().expect("event lock").clone();
    assert_eq!(events.len(), 2);
    assert_eq!(events[0].0, ASYNC_EVENT_EMIT);
    let emitted = cirru_edn::parse(std::str::from_utf8(&events[0].1).expect("emit UTF-8")).expect("emit EDN");
    let Edn::List(EdnListView(args)) = emitted else {
      panic!("expected callback argument list");
    };
    assert_eq!(args, vec![wrap_err(Edn::str("offline"))]);
    assert_eq!(events[1], (ASYNC_EVENT_COMPLETE, b"&unit".to_vec()));
  }

  #[test]
  fn async_start_rejects_invalid_pointer_and_missing_host_operations() {
    let task = test_task();
    let host = test_host();
    assert_eq!(
      unsafe { fetch_calcit_ffi_async_v1(std::ptr::null(), 1, &task, &host) },
      ASYNC_STATUS_INVALID_PAYLOAD
    );

    let request =
      cirru_edn::format(&Edn::List(EdnListView(vec![Edn::str("https://example.invalid"), Edn::Nil])), true).expect("format request");
    let mut incomplete_host = host;
    incomplete_host.configure_task = None;
    assert_eq!(
      unsafe { fetch_calcit_ffi_async_v1(request.as_ptr(), request.len(), &task, &incomplete_host,) },
      ASYNC_STATUS_INVALID_PAYLOAD
    );
  }

  #[test]
  fn invalid_header_data_returns_an_error_instead_of_panicking() {
    let options = Edn::map_from_iter([(
      Edn::tag("headers"),
      Edn::map_from_iter([(Edn::str("bad header"), Edn::str("value\nwith-newline"))]),
    )]);
    let error = match parse_request_options(&options) {
      Ok(_) => panic!("invalid headers must be rejected"),
      Err(error) => error,
    };
    assert!(error.contains("invalid header name"));
  }
}
