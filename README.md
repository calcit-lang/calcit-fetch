## Calcit Fetch

> Fetch client for Calcit

### 正式 0.32.1 配对：使用者影响

候选模块 **0.0.33** 要求正式 **Calcit 0.32.1**；下游同步 deps.cirru 的精确工具链要求并
保留 Caps strict。仅支持 native，没有 npm runtime / JS/WASM 配对或前端资源，不增加
COS/CDN，也不部署业务应用。候选号不等于已经发布。

已发布 **0.0.32** 配对 Calcit 0.32.0。本次只对齐候选版本和工具链声明，Snapshot 逐字节不变，Rust、Cargo 依赖/lock、Result payload、
async ABI v1 与取消行为保持；消费者应使用锁定 Cargo 依赖重建本机架构动态库。
原有灵活 options、callback 和宿主管理 FfiTask 仍是明确的手写 adapter 边界，不声称 bindgen
已支持或类型债务清零。本次只更新正式声明与说明，原 strict gate 和全部 CI 保持。
Cargo crate 保持0.0.29，不发布 crates.io 包。

Calcit 0.32.1 的 native `identical?` 对容器采用身份比较；需要结构值比较的下游应使用 `=`。
本模块的验收不替代消费者的语义检查。

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
        :headers $ {} $ :a |b
        :query $ [] ([] :a |b) ([] :c |d)
        :body "|Some body"
      fn (result)
        match result
          (:ok text) (println text)
          (:err message) (eprintln message)
  task.cancel-with! :superseded
```

Supported option keys:

- `:method` - request method tag such as `:GET`, `:POST`, `:PUT`, `:PATCH`, `:DELETE`
- `:headers` - map from string/tag keys to string values
- `:query` - list of `[key value]` pairs, with key as string or tag and value as string
- `:body` - request body string
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
HTTP options 的 Dynamic 是现有灵活原生 FFI 输入边界，由 Rust 校验；不代表类型债务清零。
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

模块当前固定使用正式 Calcit `0.32.1`，以提供 typed `FfiTask` 方法、当前
async lifecycle 语义与 versioned FFI Interface IR。

Result `emit` and terminal publication wait at most five seconds when the host
queue remains saturated, rather than retaining the worker indefinitely. The
network operation is an async `reqwest` future selected against the registered
cancel signal. Cancellation drops the request future, suppresses stale callback
delivery, and then publishes one terminal event. `:timeout-ms` defaults to 30
seconds and is capped at five minutes for requests that are not cancelled.

The module is pinned to formal Calcit `0.32.1` for typed `FfiTask` methods, the
current async lifecycle semantics, and versioned FFI Interface IR.

CI 复用完整 strict 和原有验证入口，不新增脚本、框架、类型预算或编译器规则。
正式 0.32.1 配对保留 9 个定义、完整 strict、Rust 7 项测试、原取消集成、2 个定义示例
与文档检查，验收以本次精确提交的 Linux CI 为准。
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
