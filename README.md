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

Custom backends can be selected with `chroniclersBackendModule`:

```sh
nim c -d:chroniclersBackendModule=myapp/log_backend app.nim
```

The backend module must export templates for each supported level:

```nim
template trace*(eventName: static[string], props: varargs[untyped])
template debug*(eventName: static[string], props: varargs[untyped])
template info*(eventName: static[string], props: varargs[untyped])
template notice*(eventName: static[string], props: varargs[untyped])
template warn*(eventName: static[string], props: varargs[untyped])
template error*(eventName: static[string], props: varargs[untyped])
template fatal*(eventName: static[string], props: varargs[untyped])
```

For non-structured backends, import `chroniclers/backend_helpers` and use
`flattenLogMessage(eventName, props)` to format fields the same way as the
built-in `std/logging` adapter.

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
