use cirru_edn::Edn;

#[no_mangle]
pub fn fetch(args: Vec<Edn>) -> Result<Edn, String> {
  if args.len() == 2 {
    if let Edn::Str(name) = &args[0] {
      match reqwest::blocking::get(name) {
        Ok(res) => match res.text() {
          Ok(s) => Ok(Edn::Str(s.to_string())),
          Err(e) => Err(format!("failed parsing text: {}", e)),
        },
        Err(e) => Err(format!("failed request: {}", e)),
      }
    } else {
      Err(format!("fetch expected 1 url, got {:?}", args))
    }
  } else {
    Err(format!("fetch expected 2 arguments, got {:?}", args))
  }
}
