## Calcit Fetch

> Fetch client for Calcit

Native requests are executed asynchronously through the fetch dylib. The public API returns a typed `FfiTask` and calls the callback with either `(:: :ok text)` or `(:: :err message)`.

### Usages

APIs:

```cirru.no-run
fetch.core/fetch |http://calcit-lang.org nil $ fn (result)
  match result
    (:ok text) (println text)
    (:err message) (eprintln message)
```

Demo of options:

```cirru.no-run
let
    task $ fetch.core/fetch |http://localhost:4000/demo
      {} (:method :POST) (:timeout-ms 30000)
        :headers $ {} (:a |b)
        :query $ [] ([] :a |b)
          [] :c |d
        :body "|Some body"
      fn (result)
        match result
          (:ok text) (println text)
          (:err message) (eprintln message)
  task.cancel-with :superseded
```

Supported option keys:

- `:method` - request method tag such as `:GET`, `:POST`, `:PUT`, `:PATCH`, `:DELETE`
- `:headers` - map from string/tag keys to string values
- `:query` - list of `[key value]` pairs, with key as string or tag and value as string
- `:body` - request body string
- `:timeout-ms` - total request timeout from 1 to 300000 milliseconds; default 30000

Keep the returned `FfiTask` while the request is relevant. `.cancel` or
`.cancel-with` interrupts the active network future, suppresses stale callback
delivery, and completes the task once native cleanup finishes.

Maintainers can run `bash scripts/check-cancel-ffi.sh` after copying the release
dylib into `dylibs/`; it exercises the public `FfiTask.cancel-with` path against
a deliberately slow local HTTP server and rejects any stale callback.

Install to `~/.config/calcit/modules/`, compile and provide `*.{dylib,so}` file with `./build.sh`.

The project uses the canonical `calcit.cirru` snapshot and keeps the Calcit/runtime
version in `deps.cirru`. Validate the snapshot with `calcit calcit.cirru --check-only`.

### 共享 FFI 基础层 / Shared FFI foundation

本模块使用 [`calcit_native_ffi`](https://github.com/calcit-lang/calcit-native-ffi)
维护 async descriptors、校验、Cirru EDN callback payload 和 backpressure
transport。HTTP options、request worker 与 `Result` payload 仍由本仓库维护。

This module uses
[`calcit_native_ffi`](https://github.com/calcit-lang/calcit-native-ffi) for
async descriptors, validation, Cirru EDN callback payloads, and backpressure
transport. HTTP options, request workers, and `Result` payload semantics remain
owned by this repository.

结果 `emit` 与 terminal 事件在 host queue 持续饱和时最多等待 5 秒，不再无限
占住 worker。网络请求使用 async `reqwest` future，并与模块注册的 cancel signal
执行 `select`；取消会 drop 请求 future、跳过陈旧 callback，再发送唯一 terminal。
`:timeout-ms` 默认 30 秒、最大 5 分钟，为未主动取消的请求提供有界退出。

模块要求 Calcit `0.13.67` 或更高版本，以提供 typed `FfiTask` 方法和当前
async lifecycle 语义。

Result `emit` and terminal publication wait at most five seconds when the host
queue remains saturated, rather than retaining the worker indefinitely. The
network operation is an async `reqwest` future selected against the registered
cancel signal. Cancellation drops the request future, suppresses stale callback
delivery, and then publishes one terminal event. `:timeout-ms` defaults to 30
seconds and is capped at five minutes for requests that are not cancelled.

The module requires Calcit `0.13.67` or newer for typed `FfiTask` methods and
the current async lifecycle semantics.

### Workflow

https://github.com/calcit-lang/dylib-workflow

For Result handling, backpressure, and request-lifecycle guidance, use
`calcit docs read "Asynchronous native Fetch" --module calcit-fetch` after
installation.

### License

MIT
