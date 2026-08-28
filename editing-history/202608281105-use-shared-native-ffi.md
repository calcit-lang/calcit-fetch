# 使用共享 native FFI crate / Adopt the shared native FFI crate

## 中文

- 用 `calcit_native_ffi 0.1.0` 替换 async descriptors、校验、payload 与 backpressure 模板。
- 保留 fetch worker、HTTP 参数解析、公开 symbol 和 callback payload 语义。
- 补充共享 transport 与模块业务逻辑的职责文档。

## English

- Replace async descriptor, validation, payload, and backpressure templates with `calcit_native_ffi 0.1.0`.
- Preserve fetch workers, HTTP argument parsing, the public symbol, and callback payload semantics.
- Document the boundary between shared transport and module business logic.
