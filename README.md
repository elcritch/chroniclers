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
requires "chroniclers[chronicles] >= 0.7.0"
```

### Using Install Features

For "middleware" type projects you can pass on the logging option like: 

```
requires "chroniclers"
feature "chronicles":
    requires "chroniclers[chronicles] >= 0.7.0"
```

Then users can use your project like:

```
requires "myawesomelib[chronicles]"
```


## Backends

Chroniclers ships with support for [Chronicles](https://github.com/status-im/nim-chronicles) and Nim's [std/logging](https://nim-lang.org/docs/logging.html). It defaults to an empty `none` backend.

Select a backend with a compile-time flag:

```sh
nim c -d:chroniclers.logBackendChronicles app.nim
nim c -d:chroniclers.logBackendStd app.nim
nim c -d:chroniclers.logBackendNone app.nim
nim c -d:chroniclers.logBackendCustom app.nim
```

Set only one backend flag. Backend flags take precedence over package features, so
`-d:chroniclers.logBackendNone` disables logging even when Chronicles is
enabled. Without a backend flag, `features.chroniclers.chronicles` takes
precedence over `features.chroniclers.std`.

The old string selectors `-d:chroniclers.logBackend=std` and
`-d:chroniclersLogBackend=std` now produce compile errors. With no selection,
logging uses the empty `none` backend. The exported `chroniclersLogBackend`
constant reports the selected backend.

### Custom Backends

Select `custom` and replace Chroniclers' empty `custom_backend` module with
your implementation. Add this to your application's `config.nims`:

```nim
patchFile("chroniclers", "custom_backend", "myapp/log_backend")
```

The replacement path is relative to the `config.nims` file. Then compile with
`-d:chroniclers.logBackendCustom`. The unpatched module reports an error
with the setup instructions.

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
