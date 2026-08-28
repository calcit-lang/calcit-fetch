# 限制异步结果背压 / Bound async result backpressure

## 中文

- 升级已发布的 `calcit_native_ffi 0.1.3`，移除 1ms 无限 retry。
- fetch 结果与 terminal 发布使用默认 5 秒 deadline；明确 blocking 网络请求尚不可取消。

## English

- Upgrade to the published `calcit_native_ffi 0.1.3` and remove unlimited 1ms retries.
- Use the default five-second deadline for fetch result and terminal publication, while documenting that the blocking network request itself is not yet cancellable.
