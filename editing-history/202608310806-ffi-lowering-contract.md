# Complete calcit-fetch FFI lowering metadata

- Upgraded the Calcit snapshot and test dependency to the 0.13.70 generation.
- Declared the complete native `async-request` / `async-task-v1` lowering
  contract for `fetch.core/fetch`.
- Removed accidental FFI metadata from the compile-time `get-dylib-ext` macro.
- Documented the deliberate handwritten options and callback boundary in
  Interface IR v1.
- Added a CI assertion that guards both lowering metadata and the remaining
  explicit unsupported-type diagnostics.
