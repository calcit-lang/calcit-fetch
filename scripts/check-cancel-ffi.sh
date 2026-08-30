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
  const server = http.createServer((_request, response) => {
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
  fetch.core :refer $ fetch

let
    task $ fetch |http://127.0.0.1:18082/slow
      {} (:timeout-ms 5000)
      fn (result)
        eprintln |unexpected-fetch-result result
  task.cancel-with :ffi-smoke-cancel
  , task' >"$calcit_log" 2>&1

if grep -q 'unexpected-fetch-result' "$calcit_log"; then
  cat "$calcit_log"
  echo "fetch callback fired after the task was cancelled" >&2
  exit 1
fi

cat "$calcit_log"
