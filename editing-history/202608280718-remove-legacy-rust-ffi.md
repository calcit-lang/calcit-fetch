# Remove legacy Rust FFI exports / 删除遗留 Rust FFI 导出

## 中文

- 删除 `abi_version`、`edn_version` 和 Rust-layout `fetch` entry point。
- 产物从 Rust `dylib` 改为 `cdylib`，仅保留 C-safe async protocol v1 符号。
- 升级 Calcit 要求到 0.13.57，验证 core 删除 fallback 后的边界。
- CI 固定审计版本化 async C 符号，并拒绝旧裸导出。

## English

- Remove the `abi_version`, `edn_version`, and Rust-layout `fetch` entry point.
- Switch the artifact from a Rust `dylib` to a `cdylib`, retaining only C-safe async protocol v1 symbols.
- Upgrade the Calcit requirement to 0.13.57 and validate the boundary after core fallback removal.
- Gate the versioned async C symbols in CI and reject legacy bare exports.
