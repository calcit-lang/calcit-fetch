use cirru_edn::Edn;
use reqwest::{
  header::{HeaderMap, HeaderName, HeaderValue},
  Method,
};
use std::sync::Arc;
use std::thread::spawn;

pub fn wrap_ok(x: Edn) -> Edn {
  Edn::List(vec![Edn::Keyword("ok".to_owned()), x])
}
pub fn wrap_err(x: Edn) -> Edn {
  Edn::List(vec![Edn::Keyword("err".to_owned()), x])
}

struct RequestSkeleton {
  method: Method,
  headers: HeaderMap,
  body: String,
  query: Vec<(String, String)>,
}

#[no_mangle]
pub fn abi_version() -> String {
  String::from("0.0.1")
}

#[no_mangle]
pub fn fetch(
  args: Vec<Edn>,
  handler: Arc<dyn Fn(Vec<Edn>) -> Result<Edn, String> + Send + Sync + 'static>,
  finish: Box<dyn FnOnce() + Send + Sync + 'static>,
) -> Result<Edn, String> {
  if args.len() == 2 {
    if let Edn::Str(url_raw) = &args[0] {
      let a1 = args[1].to_owned();
      let url = url_raw.to_owned();
      spawn(move || {
        let client = reqwest::blocking::Client::new();
        let options = parse_request_options(&a1)?;
        let builder = match options.method {
          Method::GET => client.get(url),
          Method::POST => client.post(url),
          Method::PUT => client.put(url),
          Method::PATCH => client.patch(url),
          Method::DELETE => client.delete(url),
          a => return Err(format!("unexpected method: {}", a)),
        };

        let b = builder
          .body(options.body)
          .headers(options.headers)
          .query(&options.query);

        let ret = match b.send() {
          Ok(res) => match res.text() {
            Ok(s) => handler(vec![wrap_ok(Edn::Str(s.to_string()))]),
            Err(e) => handler(vec![wrap_err(Edn::Str(format!(
              "failed to turn body into text: {}",
              e
            )))]),
          },
          Err(e) => return Err(format!("fetch failed: {}", e)),
        };
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
      req.method = match m.get(&Edn::Keyword(String::from("method"))) {
        Some(Edn::Keyword(k)) => k.parse::<Method>().map_err(|x| x.to_string())?,
        None => Method::GET,
        Some(a) => return Err(format!("invalid method name: {}", a)),
      };
      req.body = match m.get(&Edn::Keyword(String::from("body"))) {
        Some(Edn::Str(s)) => s.to_owned(),
        None => "".to_owned(),
        Some(a) => a.to_string(),
      };
      match m.get(&Edn::Keyword(String::from("headers"))) {
        Some(Edn::Map(xs)) => {
          for (k, v) in xs {
            match (k, v) {
              (Edn::Str(k2), Edn::Str(v2)) | (Edn::Keyword(k2), Edn::Str(v2)) => {
                req.headers.insert(
                  k2.parse::<HeaderName>().unwrap(),
                  v2.parse::<HeaderValue>().unwrap(),
                );
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

      match m.get(&Edn::Keyword(String::from("query"))) {
        Some(Edn::List(xs)) => {
          for x in xs {
            if let Edn::List(ys) = x {
              if ys.len() == 2 {
                match (&ys[0], &ys[1]) {
                  (Edn::Str(k), Edn::Str(v)) | (Edn::Keyword(k), Edn::Str(v)) => {
                    req.query.push((k.to_owned(), v.to_owned()));
                    // quit jump to next call
                    continue;
                  }
                  (a, b) => return Err(format!("expected strings, got: {} {}", a, b)),
                }
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
