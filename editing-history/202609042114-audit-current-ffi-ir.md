# Audit calcit-fetch against current FFI Interface IR

- Raise the declared Calcit toolchain baseline from 0.13.70 to 0.13.76.
- Keep the existing native async lowering contract unchanged.
- Update the Interface IR CI assertion to cover the flexible options value,
  callback parameter, and host-managed `FfiTask` result as three exact,
  deterministic handwritten-adapter boundaries.
- Document the current Interface IR v2 behavior without changing the public
  Fetch API or its runtime cancellation contract.
