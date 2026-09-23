## Compile-time selectable structured logging facade.
##
## The public logging templates intentionally mirror the common Chronicles call
## shape:
##
##   info "request complete", route = "/items/42", status = 200
##
## Select a built-in backend with `-d:chroniclers.logBackend=chronicles|std|none`.
## To provide a custom backend, select `custom` and replace
## `chroniclers/backends/custom_backend` with `patchFile` in your config.nims.
## Custom backends must export templates named after the supported log levels
## with this shape:
##
##   template info*(eventName: static[string], props: varargs[untyped])
##
## When the value is not specified, the `chronicles` feature takes precedence
## over `std`; otherwise logging is compiled away.

const
  logBackend {.strdefine: "chroniclers.logBackend".} = ""
  legacyLogBackend {.strdefine: "chroniclersLogBackend", used.} = ""

when logBackend.len > 0:
  const chroniclersLogBackend* = logBackend
elif defined(features.chroniclers.chronicles):
  const chroniclersLogBackend* = "chronicles"
elif defined(features.chroniclers.std):
  const chroniclersLogBackend* = "std"
elif legacyLogBackend.len > 0:
  const chroniclersLogBackend* = legacyLogBackend
else:
  const chroniclersLogBackend* = "none"

when defined(chroniclersBackendModule):
  {.
    error:
      "chroniclersBackendModule is no longer supported; select the custom backend and use patchFile(\"chroniclers\", \"custom_backend\", \"path/to/backend\") in your config.nims"
  .}
elif logBackend.len > 0:
  when logBackend == "none":
    import ./chroniclers/backends/none_backend as chroniclersBackend
  elif logBackend == "std":
    import ./chroniclers/backends/std_backend as chroniclersBackend
  elif logBackend == "chronicles":
    import ./chroniclers/backends/chronicles_backend as chroniclersBackend
  elif logBackend == "custom":
    import ./chroniclers/backends/custom_backend as chroniclersBackend
  else:
    {.error: "Unknown chroniclers logging backend: " & logBackend.}
elif defined(features.chroniclers.chronicles):
  import ./chroniclers/backends/chronicles_backend as chroniclersBackend
elif defined(features.chroniclers.std):
  import ./chroniclers/backends/std_backend as chroniclersBackend
elif legacyLogBackend.len > 0:
  when legacyLogBackend == "none":
    import ./chroniclers/backends/none_backend as chroniclersBackend
  elif legacyLogBackend == "std":
    import ./chroniclers/backends/std_backend as chroniclersBackend
  elif legacyLogBackend == "chronicles":
    import ./chroniclers/backends/chronicles_backend as chroniclersBackend
  elif legacyLogBackend == "custom":
    import ./chroniclers/backends/custom_backend as chroniclersBackend
  else:
    {.error: "Unknown chroniclers logging backend: " & legacyLogBackend.}
else:
  import ./chroniclers/backends/none_backend as chroniclersBackend

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
