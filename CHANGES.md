# Changes

## 0.6.1

- Select Chronicles when the `chronicles` package feature is enabled, while
  preserving explicit backend overrides including `none`.
- Report the effective built-in backend through `chroniclersLogBackend`.

## 0.1.0

- Add `chronicles`, `std`, and `none` compile-time logging backends.
- Add Chronicles-style structured logging templates for common log levels.
- Add `chroniclersBackendModule` for user-provided backend adapters.
- Default to the `none` backend unless the Chronicles feature is enabled.
- Prefer `chroniclers.logBackend`, while keeping `chroniclersLogBackend` as a fallback.
