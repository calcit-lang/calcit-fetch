#!/usr/bin/env bash

set -euo pipefail

smoke_dir="$(mktemp -d)"
server_log="$smoke_dir/server.log"
calcit_log="$smoke_dir/calcit.log"
server_pid=""
node_bin="${NODE_BIN:-node}"

cleanup() {
  if [[ -n "$server_pid" ]] && kill -0 "$server_pid" 2>/dev/null; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  rm -rf "$smoke_dir"
}
trap cleanup EXIT

"$node_bin" -e '
  const http = require("node:http");
  const server = http.createServer((request, response) => {
    if (request.url.startsWith("/typed")) {
      let body = "";
      request.setEncoding("utf8");
      request.on("data", (chunk) => { body += chunk; });
      request.on("end", () => {
        const matches = request.method === "POST"
          && request.url === "/typed?name=calcit"
          && request.headers["x-typed"] === "yes"
          && body === "sample";
        response.end(matches ? "typed-request-ok" : "typed-request-mismatch");
      });
      return;
    }
    setTimeout(() => {
      response.writeHead(200, { "content-type": "text/plain" });
      response.end("late");
    }, 5000);
  });
  server.listen(18082, "127.0.0.1", () => process.stdout.write("ready\n"));
' >"$server_log" 2>&1 &
server_pid="$!"

for _ in {1..50}; do
  if grep -q '^ready$' "$server_log"; then
    break
  fi
  sleep 0.1
done

if ! grep -q '^ready$' "$server_log"; then
  cat "$server_log"
  echo "slow HTTP smoke server did not start" >&2
  exit 1
fi

calcit calcit.cirru eval --dep ./ -- 'ns app.main $ :require
  fetch.core :refer $ fetch-request default-options RequestMethod QueryParam

fetch-request |http://127.0.0.1:18082/typed
  struct-with default-options
    :method $ RequestMethod :post
    :headers $ {} (:x-typed |yes)
    :query $ [] $ QueryParam :key |name :value |calcit
    :body |sample
  fn (result)
    match result
      (:ok text) (assert= |typed-request-ok text)
      (:err error) (raise error)'

calcit calcit.cirru eval --dep ./ -- 'ns app.main $ :require
  fetch.core :refer $ fetch-request default-options

let
    task $ fetch-request |http://127.0.0.1:18082/slow
      struct-with default-options $ :timeout-ms 5000
      fn (result)
        eprintln |unexpected-fetch-result result
  task.cancel-with! :ffi-smoke-cancel
  , task' >"$calcit_log" 2>&1

if grep -q 'unexpected-fetch-result' "$calcit_log"; then
  cat "$calcit_log"
  echo "fetch callback fired after the task was cancelled" >&2
  exit 1
fi

cat "$calcit_log"
