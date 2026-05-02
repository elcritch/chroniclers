# Chroniclers

Chroniclers is a tiny structured logging facade for Nim. It keeps a
Chronicles-style call shape while letting applications choose the implementation
at compile time.

```nim
import chroniclers

info "request complete", route = "/items/42", status = 200, elapsedMs = 12.5
warn "request slow", route = "/items/42", elapsedMs = 450
```

## Installtion

The normal Atlas/Nimble setup:

```sh
atlas use chroniclers
```

For applications it's handy to use the feature pattern to select your logger: 

```nim
requires "chroniclers[chronicles] >= 0.2.1"
```

### Using Install Features

For "middleware" type projects you can pass on the logging option like: 

```
requires "chroniclers"
feature "chronicles":
    requires "chroniclers[chronicles] >= 0.2.1"
```

Then users can use your project like:

```
requires "myawesomelib[chronicles]"
```


## Backends

Chroniclers ships with support for [Chronicles](https://github.com/status-im/nim-chronicles) and Nim's [std/logging](https://nim-lang.org/docs/logging.html). It defaults to an empty `none` backend.

Select the backend with compile time flags:

```sh
nim c -d:chroniclers.logBackend=chronicles app.nim
nim c -d:chroniclers.logBackend=std app.nim
nim c -d:chroniclers.logBackend=none app.nim
```

If `chroniclers.logBackend` is not set, Chroniclers uses Chronicles when
`feature.chroniclers.chronicles` is enabled and compiles logging calls away
otherwise.

The older `chroniclersLogBackend` define and exported constant are still
accepted as fallbacks.

### Custom Backends

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
