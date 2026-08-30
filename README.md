## Calcit Fetch

> Fetch client for Calcit

Native requests are executed asynchronously through the fetch dylib. The public API calls the callback with either `(:: :ok text)` or `(:: :err message)`.

### Usages

APIs:

```cirru.no-run
fetch.core/fetch |http://calcit-lang.org nil $ fn (info)
  tag-match info
    (:ok text)
      println text
    (:err e)
      println "\"Err" e
```

Demo of options:

```cirru.no-run
fetch.core/fetch "\"http://localhost:4000/demo"
  {} (:method :POST)
    :headers $ {} (:a |b)
    :query $ [] ([] :a |b)
      [] :c |d
    :body "|Some body"
  fn (info)
    tag-match info
      (:ok text)
        println text
      (:err e)
        println "\"Err" e
```

Supported option keys:

- `:method` - request method tag such as `:GET`, `:POST`, `:PUT`, `:PATCH`, `:DELETE`
- `:headers` - map from string/tag keys to string values
- `:query` - list of `[key value]` pairs, with key as string or tag and value as string
- `:body` - request body string

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
占住 worker。当前网络请求由 blocking `reqwest` 执行且没有 cancel hook；有界
结果投递不等同于网络请求本身可取消。

Calcit `0.13.60` 或更高版本会把 Snapshot 标识键规范写为 symbol，同时继续
兼容读取旧 string 键。

Result `emit` and terminal publication wait at most five seconds when the host
queue remains saturated, rather than retaining the worker indefinitely. The
network operation currently uses blocking `reqwest` without a cancel hook;
bounded result delivery does not imply request-execution cancellation.

Calcit `0.13.60` or newer writes canonical symbol keys for Snapshot identifiers
while continuing to read legacy string keys.

### Workflow

https://github.com/calcit-lang/dylib-workflow

For Result handling, backpressure, and request-lifecycle guidance, use
`calcit docs read "Asynchronous native Fetch" --module calcit-fetch` after
installation.

### License

MIT
