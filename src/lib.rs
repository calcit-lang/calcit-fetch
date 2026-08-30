mod ffi;

calcit_native_ffi::export_async_abi_v1!();

use cirru_edn::Edn;
use ffi::*;
use reqwest::{
  Method,
  header::{HeaderMap, HeaderName, HeaderValue},
};
use std::collections::HashMap;
use std::panic::{AssertUnwindSafe, catch_unwind};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{Arc, LazyLock, Mutex};
use std::thread::Builder;
use std::time::Duration;
use tokio::sync::Notify;

const DEFAULT_REQUEST_TIMEOUT_MS: u64 = 30_000;
const MAX_REQUEST_TIMEOUT_MS: u64 = 300_000;

pub fn wrap_ok(x: Edn) -> Edn {
  Edn::enum_value("ok", vec![x])
}
pub fn wrap_err(x: Edn) -> Edn {
  Edn::enum_value("err", vec![x])
}

#[derive(Debug)]
struct RequestSkeleton {
  method: Method,
  headers: HeaderMap,
  body: String,
  query: Vec<(Box<str>, Box<str>)>,
  timeout_ms: u64,
}

struct FetchControl {
  cancelled: AtomicBool,
  wake: Notify,
}

static NEXT_FETCH_CONTEXT: AtomicU64 = AtomicU64::new(1);
static FETCH_CONTROLS: LazyLock<Mutex<HashMap<u64, Arc<FetchControl>>>> = LazyLock::new(|| Mutex::new(HashMap::new()));

fn register_fetch_control() -> Result<(u64, Arc<FetchControl>), String> {
  let control = Arc::new(FetchControl {
    cancelled: AtomicBool::new(false),
    wake: Notify::new(),
  });
  let mut controls = FETCH_CONTROLS.lock().map_err(|_| "fetch control registry is poisoned".to_owned())?;
  loop {
    let context = NEXT_FETCH_CONTEXT.fetch_add(1, Ordering::Relaxed);
    if context != 0 && !controls.contains_key(&context) {
      controls.insert(context, Arc::clone(&control));
      return Ok((context, control));
    }
  }
}

fn remove_fetch_control(context: u64) {
  if let Ok(mut controls) = FETCH_CONTROLS.lock() {
    controls.remove(&context);
  }
}

unsafe extern "C" fn cancel_fetch(task_context: u64, _task_handle: u64, reason_ptr: *const u8, reason_len: usize) -> i32 {
  catch_unwind(AssertUnwindSafe(|| {
    if reason_ptr.is_null() && reason_len != 0 {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    }
    let control = match FETCH_CONTROLS.lock() {
      Ok(controls) => controls.get(&task_context).cloned(),
      Err(_) => return ASYNC_STATUS_INTERNAL_ERROR,
    };
    let Some(control) = control else {
      return ASYNC_STATUS_HANDLE_FINISHED;
    };
    control.cancelled.store(true, Ordering::Release);
    control.wake.notify_one();
    ASYNC_STATUS_OK
  }))
  .unwrap_or(ASYNC_STATUS_INTERNAL_ERROR)
}

fn publish_fetch_outcome_with_policy(
  host: CalcitFfiAsyncHostV1,
  task: CalcitFfiAsyncTaskV1,
  control: &FetchControl,
  outcome: Result<Option<Edn>, String>,
  emit_policy: calcit_native_ffi::BackpressurePolicy,
) -> i32 {
  let (terminal_kind, terminal_payload) = match outcome {
    Ok(None) => (ASYNC_EVENT_COMPLETE, b"&unit".to_vec()),
    Err(error) => (ASYNC_EVENT_FAIL, encode_failure(error)),
    Ok(Some(result)) => match encode_event_args(vec![result]) {
      Err(error) => (ASYNC_EVENT_FAIL, encode_failure(error)),
      Ok(payload) => {
        let status = enqueue_with_backpressure_until(host, task, ASYNC_EVENT_EMIT, &payload, emit_policy, || {
          !control.cancelled.load(Ordering::Acquire)
        });
        if status == ASYNC_STATUS_OK
          || (control.cancelled.load(Ordering::Acquire) && matches!(status, ASYNC_STATUS_HANDLE_CLOSING | ASYNC_STATUS_HANDLE_FINISHED))
        {
          (ASYNC_EVENT_COMPLETE, b"&unit".to_vec())
        } else {
          (
            ASYNC_EVENT_FAIL,
            encode_failure(format!("fetch task failed to publish its result with status {status}")),
          )
        }
      }
    },
  };
  enqueue_with_backpressure(host, task, terminal_kind, &terminal_payload)
}

fn publish_fetch_outcome(
  host: CalcitFfiAsyncHostV1,
  task: CalcitFfiAsyncTaskV1,
  control: &FetchControl,
  outcome: Result<Option<Edn>, String>,
) -> i32 {
  publish_fetch_outcome_with_policy(host, task, control, outcome, calcit_native_ffi::BackpressurePolicy::default())
}

async fn perform_fetch(url: Arc<str>, options: Edn) -> Edn {
  let result: Result<String, String> = async {
    let options = parse_request_options(&options)?;
    let client = reqwest::Client::new();
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
      .timeout(Duration::from_millis(options.timeout_ms))
      .send()
      .await
      .map_err(|error| format!("fetch failed: {error}"))?
      .text()
      .await
      .map_err(|error| format!("failed to turn body into text: {error}"))
  }
  .await;
  match result {
    Ok(text) => wrap_ok(Edn::str(text)),
    Err(error) => wrap_err(Edn::str(error)),
  }
}

fn run_fetch_request(url: Arc<str>, options: Edn, control: Arc<FetchControl>) -> Result<Option<Edn>, String> {
  let runtime = tokio::runtime::Builder::new_current_thread()
    .enable_all()
    .build()
    .map_err(|error| format!("failed to start fetch runtime: {error}"))?;
  Ok(runtime.block_on(async move {
    if control.cancelled.load(Ordering::Acquire) {
      return None;
    }
    tokio::select! {
      biased;
      _ = control.wake.notified() => None,
      result = perform_fetch(url, options) => Some(result),
    }
  }))
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
  if host.enqueue.is_none() {
    return ASYNC_STATUS_INVALID_PAYLOAD;
  }
  let (task_context, control) = match register_fetch_control() {
    Ok(value) => value,
    Err(_) => return ASYNC_STATUS_INTERNAL_ERROR,
  };
  let status = unsafe {
    configure(
      host.context,
      task.handle,
      ASYNC_TASK_ONE_SHOT,
      ASYNC_TASK_SERIAL_EVENTS,
      task_context,
      Some(cancel_fetch),
    )
  };
  if status != ASYNC_STATUS_OK {
    remove_fetch_control(task_context);
    return status;
  }
  let url = url.to_owned();
  let options = options.to_owned();
  let spawn_result = Builder::new().name("calcit-fetch-request".to_owned()).spawn(move || {
    let outcome = match catch_unwind(AssertUnwindSafe(|| run_fetch_request(url, options, Arc::clone(&control)))) {
      Ok(outcome) => outcome,
      Err(_) => Err("fetch worker panicked".to_owned()),
    };
    let status = publish_fetch_outcome(host, task, control.as_ref(), outcome);
    if status != ASYNC_STATUS_OK {
      eprintln!("fetch async task {} failed to terminate with status {status}", task.handle);
    }
    remove_fetch_control(task_context);
  });
  if spawn_result.is_err() {
    remove_fetch_control(task_context);
    return ASYNC_STATUS_INTERNAL_ERROR;
  }
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

fn parse_request_options(info: &Edn) -> Result<RequestSkeleton, String> {
  let mut req = RequestSkeleton {
    method: Method::GET,
    headers: HeaderMap::new(),
    body: "".to_owned(),
    query: vec![],
    timeout_ms: DEFAULT_REQUEST_TIMEOUT_MS,
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

      req.timeout_ms = match m.get(&Edn::tag("timeout-ms")) {
        None => DEFAULT_REQUEST_TIMEOUT_MS,
        Some(Edn::Number(value))
          if value.is_finite() && value.fract() == 0.0 && *value >= 1.0 && *value <= MAX_REQUEST_TIMEOUT_MS as f64 =>
        {
          *value as u64
        }
        Some(value) => {
          return Err(format!(
            "timeout-ms must be an integer from 1 to {MAX_REQUEST_TIMEOUT_MS}, got: {value}"
          ));
        }
      };
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
  use calcit_native_ffi::{AsyncResponseResolve, AsyncTaskCancel};
  use cirru_edn::EdnListView;
  use std::io::{Read, Write};
  use std::net::TcpListener;
  use std::ptr;
  use std::slice;
  use std::sync::{Condvar, LazyLock, Mutex, mpsc};
  use std::thread;
  use std::time::{Duration, Instant};

  type RecordedEvent = (u32, Vec<u8>);
  static EVENTS: LazyLock<Mutex<Vec<RecordedEvent>>> = LazyLock::new(|| Mutex::new(vec![]));
  static SATURATED_EVENTS: LazyLock<Mutex<Vec<RecordedEvent>>> = LazyLock::new(|| Mutex::new(vec![]));

  struct CancellationHost {
    configured: Mutex<Option<(u64, AsyncTaskCancel)>>,
    configured_ready: Condvar,
    events: Mutex<Vec<RecordedEvent>>,
    event_ready: Condvar,
  }

  impl CancellationHost {
    fn new() -> Self {
      Self {
        configured: Mutex::new(None),
        configured_ready: Condvar::new(),
        events: Mutex::new(Vec::new()),
        event_ready: Condvar::new(),
      }
    }

    fn wait_for_configuration(&self) -> (u64, AsyncTaskCancel) {
      let configured = self.configured.lock().expect("configuration lock");
      let (configured, timeout) = self
        .configured_ready
        .wait_timeout_while(configured, Duration::from_secs(2), |value| value.is_none())
        .expect("wait for configuration");
      assert!(!timeout.timed_out(), "fetch task was not configured");
      configured.expect("configured callback")
    }

    fn wait_for_terminal(&self) -> Vec<RecordedEvent> {
      let events = self.events.lock().expect("event lock");
      let (events, timeout) = self
        .event_ready
        .wait_timeout_while(events, Duration::from_secs(2), |events| {
          !events
            .iter()
            .any(|(kind, _)| matches!(*kind, ASYNC_EVENT_COMPLETE | ASYNC_EVENT_FAIL))
        })
        .expect("wait for terminal");
      assert!(!timeout.timed_out(), "cancelled fetch did not publish a terminal event");
      events.clone()
    }
  }

  unsafe fn cancellation_host(context: u64) -> &'static CancellationHost {
    // SAFETY: the integration test keeps the boxed state alive until the
    // worker publishes its terminal event and removes its control registry ID.
    unsafe { &*(context as *const CancellationHost) }
  }

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

  unsafe extern "C" fn saturated_enqueue(
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
    SATURATED_EVENTS.lock().expect("saturated event lock").push((kind, payload));
    if kind == ASYNC_EVENT_EMIT {
      calcit_native_ffi::status::QUEUE_FULL
    } else {
      ASYNC_STATUS_OK
    }
  }

  unsafe extern "C" fn cancellation_enqueue(
    context: u64,
    _task_handle: u64,
    kind: u32,
    _response_handle: u64,
    payload_ptr: *const u8,
    payload_len: usize,
  ) -> i32 {
    let host = unsafe { cancellation_host(context) };
    let payload = if payload_len == 0 {
      vec![]
    } else {
      // SAFETY: the fetch worker keeps the payload readable for this call.
      unsafe { slice::from_raw_parts(payload_ptr, payload_len) }.to_vec()
    };
    match host.events.lock() {
      Ok(mut events) => {
        events.push((kind, payload));
        host.event_ready.notify_all();
        ASYNC_STATUS_OK
      }
      Err(_) => ASYNC_STATUS_INTERNAL_ERROR,
    }
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

  unsafe extern "C" fn cancellation_configure(
    context: u64,
    _task_handle: u64,
    kind: u32,
    flags: u32,
    task_context: u64,
    cancel: Option<AsyncTaskCancel>,
  ) -> i32 {
    if kind != ASYNC_TASK_ONE_SHOT || flags != ASYNC_TASK_SERIAL_EVENTS {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    }
    let Some(cancel) = cancel else {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    };
    let host = unsafe { cancellation_host(context) };
    match host.configured.lock() {
      Ok(mut configured) => {
        *configured = Some((task_context, cancel));
        host.configured_ready.notify_all();
        ASYNC_STATUS_OK
      }
      Err(_) => ASYNC_STATUS_INTERNAL_ERROR,
    }
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
      protocol_version: calcit_native_ffi::ASYNC_PROTOCOL_VERSION,
      struct_size: std::mem::size_of::<CalcitFfiAsyncTaskV1>() as u32,
      handle: 7,
      kind: ASYNC_TASK_ONE_SHOT,
      flags: ASYNC_TASK_SERIAL_EVENTS,
    }
  }

  fn test_host() -> CalcitFfiAsyncHostV1 {
    CalcitFfiAsyncHostV1 {
      protocol_version: calcit_native_ffi::ASYNC_PROTOCOL_VERSION,
      struct_size: std::mem::size_of::<CalcitFfiAsyncHostV1>() as u32,
      context: 7,
      enqueue: Some(record_enqueue),
      configure_task: Some(accept_configure),
      open_response: Some(reject_open_response),
    }
  }

  fn saturated_host() -> CalcitFfiAsyncHostV1 {
    CalcitFfiAsyncHostV1::new(7, saturated_enqueue, accept_configure, reject_open_response)
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
    let control = FetchControl {
      cancelled: AtomicBool::new(false),
      wake: Notify::new(),
    };
    assert_eq!(
      publish_fetch_outcome(test_host(), test_task(), &control, Ok(Some(wrap_err(Edn::str("offline")))),),
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
  fn saturated_result_delivery_fails_once_then_publishes_one_terminal() {
    SATURATED_EVENTS.lock().expect("saturated event lock").clear();
    let control = FetchControl {
      cancelled: AtomicBool::new(false),
      wake: Notify::new(),
    };
    assert_eq!(
      publish_fetch_outcome_with_policy(
        saturated_host(),
        test_task(),
        &control,
        Ok(Some(wrap_ok(Edn::str("late")))),
        calcit_native_ffi::BackpressurePolicy::bounded(Duration::ZERO, 0),
      ),
      ASYNC_STATUS_OK
    );
    let events = SATURATED_EVENTS.lock().expect("saturated event lock").clone();
    assert_eq!(events.len(), 2);
    assert_eq!(events[0].0, ASYNC_EVENT_EMIT);
    assert_eq!(events[1].0, ASYNC_EVENT_FAIL);
    let failure = cirru_edn::parse(std::str::from_utf8(&events[1].1).expect("failure UTF-8")).expect("failure EDN");
    assert!(failure.to_string().contains("status 7"));
  }

  #[test]
  fn cancelling_a_slow_request_drops_the_network_future_and_completes_once() {
    let listener = TcpListener::bind("127.0.0.1:0").expect("bind slow HTTP server");
    let port = listener.local_addr().expect("slow HTTP address").port();
    let (request_seen_tx, request_seen_rx) = mpsc::channel();
    let (release_tx, release_rx) = mpsc::channel();
    let server = thread::spawn(move || {
      let (mut stream, _) = listener.accept().expect("accept fetch request");
      stream.set_read_timeout(Some(Duration::from_secs(2))).expect("set request timeout");
      let mut request = [0_u8; 2048];
      let read = stream.read(&mut request).expect("read fetch request");
      assert!(read > 0);
      request_seen_tx.send(()).expect("signal fetch request");
      release_rx.recv_timeout(Duration::from_secs(2)).expect("release slow server");
      let _ = stream.write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 4\r\nConnection: close\r\n\r\nlate");
    });

    let state = Box::new(CancellationHost::new());
    let host = CalcitFfiAsyncHostV1::new(
      (&*state as *const CancellationHost) as u64,
      cancellation_enqueue,
      cancellation_configure,
      reject_open_response,
    );
    let task = CalcitFfiAsyncTaskV1::new(91, ASYNC_TASK_ONE_SHOT, ASYNC_TASK_SERIAL_EVENTS);
    let request = cirru_edn::format(
      &Edn::List(EdnListView(vec![
        Edn::str(format!("http://127.0.0.1:{port}/slow")),
        Edn::map_from_iter([(Edn::tag("timeout-ms"), Edn::Number(5_000.0))]),
      ])),
      true,
    )
    .expect("encode fetch request");

    assert_eq!(
      unsafe { fetch_calcit_ffi_async_v1(request.as_ptr(), request.len(), &task, &host) },
      ASYNC_STATUS_OK
    );
    let (task_context, cancel) = state.wait_for_configuration();
    request_seen_rx
      .recv_timeout(Duration::from_secs(2))
      .expect("fetch reached slow server");
    let cancelled_at = Instant::now();
    assert_eq!(unsafe { cancel(task_context, task.handle, ptr::null(), 0) }, ASYNC_STATUS_OK);
    let events = state.wait_for_terminal();
    assert!(cancelled_at.elapsed() < Duration::from_secs(1));
    assert_eq!(events, vec![(ASYNC_EVENT_COMPLETE, b"&unit".to_vec())]);

    let deadline = Instant::now() + Duration::from_secs(1);
    loop {
      let status = unsafe { cancel(task_context, task.handle, ptr::null(), 0) };
      if status == ASYNC_STATUS_HANDLE_FINISHED {
        break;
      }
      assert_eq!(status, ASYNC_STATUS_OK);
      assert!(Instant::now() < deadline, "fetch control registry was not removed");
      thread::sleep(Duration::from_millis(1));
    }
    release_tx.send(()).expect("release slow server");
    server.join().expect("slow server thread");
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

  #[test]
  fn timeout_must_be_a_bounded_positive_integer() {
    for value in [Edn::Number(0.0), Edn::Number(300_001.0), Edn::Number(1.5), Edn::str("1000")] {
      let options = Edn::map_from_iter([(Edn::tag("timeout-ms"), value)]);
      assert!(parse_request_options(&options).unwrap_err().contains("timeout-ms"));
    }
    let options = Edn::map_from_iter([(Edn::tag("timeout-ms"), Edn::Number(1250.0))]);
    assert_eq!(parse_request_options(&options).expect("valid timeout").timeout_ms, 1250);
  }
}
