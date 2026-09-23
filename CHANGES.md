# Changes

## 0.7.0

- Use direct imports for feature-selected backends and Nim's `patchFile` module
  replacement for custom backends. The old `chroniclersBackendModule` define
  now reports migration instructions.
- Add presence-only backend flags for static selection, followed by the Chronicles
  and `std` feature flags. Reject both old string selectors,
  `chroniclers.logBackend` and `chroniclersLogBackend`.

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
