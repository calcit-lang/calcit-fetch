# C-safe async FFI v1 migration

- Added `fetch_calcit_ffi_async_v1` and `calcit_ffi_async_version` exports for
  Calcit's versioned C-safe async task protocol. The fetch task configures
  itself as serialized one-shot work, emits one callback argument list, and
  terminates explicitly with `&unit`.
- Treat host queue saturation as backpressure, convert worker panics into
  protocol failures, and keep all unwind paths behind the C ABI boundary.
- Reused one request implementation for the new ABI and the legacy fallback.
  The fallback now always calls its finish hook after publishing a request
  result, including request and response errors.
- Replaced panicking HTTP header parsing with descriptive errors and added ABI,
  event-order, invalid-input, and malformed-header regression tests.
- Upgraded the project contract to Calcit 0.13.52, migrated
  `get-dylib-ext` to a strict phase-aware Macro schema with the required
  `:platform-read` capability, exposed `calcit.cirru` as reviewable source, and
  changed setup-calcit CI pinning from a commit hash to tag `v1.3.0`.
- Verified Rust formatting, tests and strict clippy; Calcit check-only,
  dynamic-method, type, weak-type and deprecated analysis; and a real local
  HTTP request through the 0.13.52 host and release dylib.
