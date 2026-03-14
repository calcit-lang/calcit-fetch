## fetch 开发说明

### 关键步骤

1. **升级依赖版本**
   - 在 `Cargo.toml` 中保持与当前 Calcit 运行时兼容：
     - `cirru_edn = "0.7.3"`
     - `cirru_parser = "0.2.3"`
   - 当前工程使用 `edition = "2024"`。

2. **保持 FFI 导出接口完整**
   - 所有导出函数使用 `#[unsafe(no_mangle)]`。
   - 至少导出以下函数：
     - `abi_version() -> String`
     - `edn_version() -> String`
   - `edn_version()` 需要返回：
     - `cirru_edn::version().to_string()`

3. **异步回调函数签名**
   - Calcit 侧通过 `&call-dylib-edn-fn` 调用 Rust 导出函数。
   - Rust 侧异步导出函数保持形如：
     - `pub fn fetch(args: Vec<Edn>, handler: Arc<dyn Fn(Vec<Edn>) -> Result<Edn, String> + Send + Sync + 'static>, finish: Box<dyn FnOnce() + Send + Sync + 'static>) -> Result<Edn, String>`
   - 回调返回值和错误都包装为 `Result<Edn, String>`。

4. **请求结果约定**
   - 成功结果包装为 `(:: :ok value)`。
   - 错误结果包装为 `(:: :err message)`。
   - 当前实现通过 `wrap_ok` / `wrap_err` 构造元组。

5. **构建动态库**
   - 在项目根目录执行：
     - `cargo build --release`
   - 产物位于 `target/release/`。

6. **刷新运行时 dylib 文件**
   - 清理并复制产物到 `dylibs/`：
     - `rm -rf dylibs/*`
     - `mkdir -p dylibs`
     - `cp target/release/*.* dylibs/`
   - Calcit 示例默认从 `dylibs/libcalcit_http` 加载动态库。

7. **运行 Calcit 示例验证**
   - 执行：
     - `cr compact.cirru`
   - 当前预期输出应包含：
     - `%%%% test for lib`
     - `sent request`
     - 以及来自远程请求的返回文本或错误信息

### 修改时的检查清单

- 修改导出函数后，先确认 Rust 侧可以成功编译。
- 如果运行 `cr compact.cirru` 报 `dlsym failed`：
  - 先检查是否漏导出了 `edn_version`
  - 再检查 `#[unsafe(no_mangle)]` 是否遗漏
  - 再确认 `dylibs/` 中已复制最新产物
- 如果请求回调没有结束，检查是否漏调用了 `finish()`。
- 如果只更新了 `target/release/` 但没有同步到 `dylibs/`，Calcit 仍会加载旧库。

### 推荐验证流程

按顺序执行：

1. 修改 `Cargo.toml` / `src/lib.rs`
2. `cargo build --release`
3. 复制 `target/release/*.*` 到 `dylibs/`
4. `cr compact.cirru`

### 当前已验证状态

- 依赖版本已升级到 `cirru_edn 0.7.3`、`cirru_parser 0.2.3`
- FFI 已补充 `edn_version()`
- Rust 2024 下导出属性已切换为 `#[unsafe(no_mangle)]`
- 项目已切换到 `compact.cirru + deps.cirru` 工作流
