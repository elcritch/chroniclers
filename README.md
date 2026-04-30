# Chroniclers

Chroniclers is a tiny structured logging facade for Nim. It keeps a
Chronicles-style call shape while letting applications choose the implementation
at compile time.

```nim
import chroniclers

info "request complete", route = "/items/42", status = 200, elapsedMs = 12.5
warn "request slow", route = "/items/42", elapsedMs = 450
```

Select the backend with:

```sh
nim c -d:chroniclersLogBackend=chronicles app.nim
nim c -d:chroniclersLogBackend=std app.nim
nim c -d:chroniclersLogBackend=none app.nim
```

If `chroniclersLogBackend` is not set, Chroniclers uses Chronicles when
`feature.chroniclers.chronicles` is enabled and falls back to Nim's
`std/logging` otherwise.

Structured fields are passed through to Chronicles. Non-structured backends
receive a flattened message such as:

```text
request complete route=/items/42 status=200 elapsedMs=12.5
```

## Development

Install dependencies with Atlas:

```sh
atlas install --feature:chronicles
```

Run tests:

```sh
nim test
```
