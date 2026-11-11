## Calcit Fetch

> Fetch client for Calcit

### 使用者影响

候选模块 **0.0.36** 使用正式 Calcit **0.41.0**。请同步 `deps.cirru` 的工具链声明，并用锁定的 Cargo 依赖重建本机动态库。

新调用可以用 `fetch-request` 和 `default-options` 静态检查请求选项。原 `fetch` 继续接受 `nil` 或 Map。Rust 校验方法、请求头、查询参数和超时。缺省的 `:body` 发送空字符串，其他非字符串值按 EDN 文本转换。回调继续接收 `Result<String, String>`，任务句柄支持 `.cancel!` 和 `.cancel-with!`。该接口使用手写 native FFI 适配器，自动绑定仍受开放选项、回调和宿主管理任务三类边界限制。

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
    task $ fetch.core/fetch-request |http://localhost:4000/demo
      struct-with fetch.core/default-options
        :method $ fetch.core/RequestMethod :post
        :headers $ {} (:a |b) (|x-example |typed)
        :query $ []
          fetch.core/QueryParam :key :a :value |b
          fetch.core/QueryParam :key |c :value |d
        :body "|Some body"
      fn (result)
        match result
          (:ok text) (println text)
          (:err message) (eprintln message)
  task.cancel-with! :superseded
```

The typed entry accepts the five supported methods, String or Tag keys, String values, and a String body. Use `struct-with` on `default-options` to override only the fields you need.

Supported option keys on the original entry:

- `:method` - request method tag such as `:GET`, `:POST`, `:PUT`, `:PATCH`, `:DELETE`
- `:headers` - map from string/tag keys to string values
- `:query` - list of `[key value]` pairs, with key as string or tag and value as string
- `:body` - request body string, defaulting to empty. Non-string values are converted to their EDN display text.
- `:timeout-ms` - total request timeout from 1 to 300000 milliseconds; default 30000

Keep the returned `FfiTask` while the request is relevant. `.cancel!` or
`.cancel-with!` interrupts the active network future, suppresses stale callback
delivery, and completes the task once native cleanup finishes.

Maintainers can run `bash scripts/check-cancel-ffi.sh` after copying the release
dylib into `dylibs/`; it exercises the public `FfiTask.cancel-with!` path against
a deliberately slow local HTTP server and rejects any stale callback.

In the consuming project, first declare `calcit-lang/calcit-fetch` with a
compatible release tag under `deps.cirru :dependencies`. Run `caps --ci` to
install the declared modules, then compile and provide the `*.{dylib,so}` file
with `./build.sh` from the installed fetch module directory.

The project uses the canonical `calcit.cirru` snapshot and keeps the Calcit/runtime
version in `deps.cirru`. Validate the snapshot with `calcit calcit.cirru --check-only`.

CI 使用工具链匹配和全部四个命名空间的严格公开定义检查，
并保留 Rust 测试、C-safe 导出、示例、文档和 HTTP 取消集成测试。
默认入口显式声明 native target；空 reload hook 返回 Unit。
原生 `fetch` 保留开放 EDN 输入并交由 Rust 校验；`fetch-request` 使用具名请求类型。
正式 Action 标签可移动，只读权限和禁用凭据持久化不保证标签不可变。

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

模块当前固定使用正式 Calcit `0.41.0`，以提供 typed `FfiTask` 方法、当前
async lifecycle 语义与 versioned FFI Interface IR。

Result `emit` and terminal publication wait at most five seconds when the host
queue remains saturated, rather than retaining the worker indefinitely. The
network operation is an async `reqwest` future selected against the registered
cancel signal. Cancellation drops the request future, suppresses stale callback
delivery, and then publishes one terminal event. `:timeout-ms` defaults to 30
seconds and is capped at five minutes for requests that are not cancelled.

The module is pinned to formal Calcit `0.41.0` for typed `FfiTask` methods, the
current async lifecycle semantics, and versioned FFI Interface IR.

CI 复用完整 strict 和原有验证入口，不新增脚本、框架、类型预算或编译器规则。
CI 检查完整 strict、Rust 测试、原取消集成、原定义示例和文档。
既有 C-safe 符号和三个精确 FFI IR 诊断路径门禁保留，不以放宽边界换取通过。

`fetch.core/fetch` declares the native async lowering contract consumed by
`calcit ffi export`: `async-request` invocation over `async-task-v1`. Options,
the callback, and the host-managed `FfiTask` remain a deliberate handwritten
adapter boundary in Interface IR v3. CI guards all three exact diagnostic paths
so a future generator cannot silently erase one of these capabilities.

`fetch.core/fetch` 已声明供 `calcit ffi export` 使用的 native async lowering
合同，即通过 `async-task-v1` 承载 `async-request`。options、callback 与宿主
管理的 `FfiTask` 在 Interface IR v3 中仍是有意保留的手写 adapter 边界；CI
固定检查三个精确诊断路径，防止后续 generator 静默抹除这些 capability。

### Workflow

https://github.com/calcit-lang/dylib-workflow

For Result handling, backpressure, and request-lifecycle guidance, use
`calcit docs read "Asynchronous native Fetch" --module calcit-fetch` after
installation.

### License

MIT
