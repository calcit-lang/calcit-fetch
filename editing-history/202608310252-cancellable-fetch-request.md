# 2026-08-31：真正可取消的 Fetch 请求 / Truly cancellable Fetch requests

- Replaced blocking `reqwest` execution with an async request future selected against a registry-backed cancellation signal.
- Every accepted task now owns a C-safe registry ID and cancel callback; cancellation drops the active network future, suppresses stale result delivery, publishes one terminal event, and removes the registry entry.
- Added a bounded `:timeout-ms` option (30 seconds by default, 1–300000ms accepted) for requests that are not explicitly cancelled.
- Centralized terminal publication so persistent result `QUEUE_FULL` becomes one explicit failure terminal instead of leaving the accepted task unfinished.
- Added regressions for normal emit ordering, saturated result delivery, timeout validation, and cancellation of a real slow localhost request.
- Changed `fetch.core/fetch` to return typed `FfiTask`, made the callback `Result<String, String>`, replaced remaining `tag-match` examples with `match`, and added a real dylib `.cancel-with` smoke.
- Strengthened Actions with locked `caps` resolution, Node 24, canonical Snapshot diff checks, zero dynamic-method dispatch, executable examples, Markdown checks, and the real cancellation smoke.
- Kept a request-local current-thread runtime instead of introducing a general global executor; the release dylib is 3,532,656 bytes versus the previous 3,615,216-byte baseline (82,560 bytes / 2.3% smaller).

## 中文摘要

- 将 blocking `reqwest` 改为 async request future，并与 registry-backed cancel signal 执行 `select`。
- 每个已接受任务持有 C-safe registry ID 与 cancel callback；取消会 drop 活跃网络 future、抑制陈旧结果、发布唯一 terminal，再移除 registry。
- 新增有界 `:timeout-ms`：默认 30 秒，接受 1–300000ms，保证未主动取消的请求也有退出上限。
- 统一 terminal 发布逻辑；结果投递持续 `QUEUE_FULL` 时转为单个明确 failure terminal，不再遗留未完成任务。
- 回归覆盖正常 emit 顺序、饱和结果投递、timeout 校验与真实 localhost 慢请求取消。
- `fetch.core/fetch` 现在返回 typed `FfiTask`，callback 收紧为 `Result<String, String>`；示例由 `tag-match` 迁移到 `match`，并加入真实 dylib `.cancel-with` smoke。
- Actions 增加锁定 `caps` 解析、Node 24、Snapshot canonical diff、dynamic-method 0、可执行 examples、Markdown 检查与真实取消 smoke。
- 保持 request-local current-thread runtime，没有引入通用全局 executor；release dylib 从 3,615,216 bytes 降为 3,532,656 bytes，减少 82,560 bytes（约 2.3%）。
