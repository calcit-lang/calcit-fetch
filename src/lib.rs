use cirru_edn::Edn;

pub fn wrap_ok(x: Edn) -> Edn {
  Edn::List(vec![Edn::Keyword("ok".to_owned()), x])
}
pub fn wrap_err(x: Edn) -> Edn {
  Edn::List(vec![Edn::Keyword("err".to_owned()), x])
}

#[no_mangle]
pub fn fetch(args: Vec<Edn>) -> Result<Edn, String> {
  if args.len() == 2 {
    if let Edn::Str(name) = &args[0] {
      match reqwest::blocking::get(name) {
        Ok(res) => match res.text() {
          Ok(s) => Ok(wrap_ok(Edn::Str(s.to_string()))),
          Err(e) => Ok(wrap_err(Edn::Str(format!("{}", e)))),
        },
        Err(e) => Ok(wrap_err(Edn::Str(format!("{}", e)))),
      }
    } else {
      Err(format!("fetch expected 1 url, got {:?}", args))
    }
  } else {
    Err(format!("fetch expected 2 arguments, got {:?}", args))
  }
}
