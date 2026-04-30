## Compile-time selectable structured logging facade.
##
## The public logging templates intentionally mirror the common Chronicles call
## shape:
##
##   info "request complete", route = "/items/42", status = 200
##
## Select a built-in backend with `-d:chroniclersLogBackend=chronicles|std|none`.
## To provide a custom backend, set `-d:chroniclersBackendModule=some/module`.
## Custom backends must export templates named after the supported log levels
## with this shape:
##
##   template info*(eventName: static[string], props: varargs[untyped])
##
## When the value is not specified, Chronicles is used when the package's
## `chronicles` feature is enabled; otherwise logging is compiled away.

import std/macros

const
  defaultBackend =
    when defined(feature.chroniclers.chronicles): "chronicles" else: "none"
  chroniclersLogBackend* {.strdefine.} = defaultBackend
  chroniclersBackendModule* {.strdefine.} = ""
  selectedBackendModule =
    when chroniclersBackendModule.len > 0:
      chroniclersBackendModule
    elif chroniclersLogBackend == "chronicles":
      "chroniclers/backends/chronicles_backend"
    elif chroniclersLogBackend == "std":
      "chroniclers/backends/std_backend"
    elif chroniclersLogBackend == "none":
      "chroniclers/backends/none_backend"
    else:
      {.
        error:
          "Unsupported chroniclersLogBackend. Use chronicles, std, none, or set chroniclersBackendModule."
      .}

macro importBackend(modulePath: static[string]): untyped =
  for ch in modulePath:
    if not (ch in {'a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '/'}):
      error("Invalid chroniclersBackendModule path: " & modulePath)

  parseStmt("import " & modulePath & " as chroniclersBackend")

importBackend(selectedBackendModule)
export chroniclersBackend except debug, error, fatal, info, log, notice, trace, warn

template trace*(eventName: static[string], props: varargs[untyped]) =
  chroniclersBackend.trace eventName, props

template debug*(eventName: static[string], props: varargs[untyped]) =
  chroniclersBackend.debug eventName, props

template info*(eventName: static[string], props: varargs[untyped]) =
  chroniclersBackend.info eventName, props

template notice*(eventName: static[string], props: varargs[untyped]) =
  chroniclersBackend.notice eventName, props

template warn*(eventName: static[string], props: varargs[untyped]) =
  chroniclersBackend.warn eventName, props

template error*(eventName: static[string], props: varargs[untyped]) =
  chroniclersBackend.error eventName, props

template fatal*(eventName: static[string], props: varargs[untyped]) =
  chroniclersBackend.fatal eventName, props
