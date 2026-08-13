# Upgrade calcit-fetch to Calcit 0.13.15

- Migrated the generated snapshot to canonical `entries.default` and updated `deps.cirru`.
- Synchronized the native dylib with cirru_edn 0.8 and its `Edn::enum_value` API.
- Added explicit FFI/type metadata and CI check-only, warning, and static-analysis gates.
