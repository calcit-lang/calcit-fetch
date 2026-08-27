# Async FFI descriptor size guard

- Read only the common two-u32 ABI header before validating task and host
  descriptor versions and `struct_size` values.
- Copy the full v1 descriptor only after its advertised size covers every v1
  field, using unaligned reads for foreign C callers.
- Added a regression assertion that rejects a descriptor advertising only the
  eight-byte header instead of reading beyond its declared extent.
