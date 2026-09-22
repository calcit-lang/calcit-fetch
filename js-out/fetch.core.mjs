
import * as $clt from "./calcit.core.mjs";
import { get_dylib_path } from "./fetch.util.mjs";
const _t_ = $clt.init_tags([]);

export function fetch(url, options, cb) {
  if (arguments.length !== 3) throw $clt._args_throw('fetch', 3, arguments.length);
  let tmp_AUTO_1 = (function _fn_(){
    let tmp_AUTO_2 = get_dylib_path("/dylibs/libcalcit_http");
    return $clt._$n_call_dylib_edn_fn(tmp_AUTO_2, "fetch", url, options, cb);
  })();
  return $clt.ffi_$o_task(tmp_AUTO_1)
}



