# Make the FFI diagnostic guard order-independent

- Sort actual and expected `[code, path]` pairs before comparing them in CI.
- Retain the exact summary count, so duplicates, missing diagnostics, and new
  boundaries still fail the contract check without depending on output order.
