## Compile-time selectable structured logging facade.
##
## The public logging templates intentionally mirror the common Chronicles call
## shape:
##
##   info "request complete", route = "/items/42", status = 200
##
## Select a backend with `-d:chroniclers.logBackendChronicles`,
## `-d:chroniclers.logBackendStd`, `-d:chroniclers.logBackendCustom`,
## or `-d:chroniclers.logBackendNone`.
## To provide a custom backend, select the custom flag and replace
## `chroniclers/backends/custom_backend` with `patchFile` in your config.nims.
## Custom backends must export templates named after the supported log levels
## with this shape:
##
##   template info*(eventName: static[string], props: varargs[untyped])
##
## Without a backend flag, the `chronicles` feature takes precedence over
## `std`, followed by the empty backend.

from std/macros import warning

when defined(chroniclers.logBackend):
  {.
    error:
      "chroniclers.logBackend is no longer supported; use -d:chroniclers.logBackendStd, -d:chroniclers.logBackendChronicles, -d:chroniclers.logBackendCustom, or -d:chroniclers.logBackendNone"
  .}

when defined(chroniclersLogBackend):
  {.
    error:
      "chroniclersLogBackend is no longer supported; use -d:chroniclers.logBackendStd, -d:chroniclers.logBackendChronicles, -d:chroniclers.logBackendCustom, or -d:chroniclers.logBackendNone"
  .}

when defined(chroniclersBackendModule):
  {.
    error:
      "chroniclersBackendModule is no longer supported; use -d:chroniclers.logBackendCustom and patchFile(\"chroniclers\", \"custom_backend\", \"path/to/backend\") in your config.nims"
  .}

static:
  var cnt = 0
  if defined(chroniclers.logBackendChronicles):
    cnt.inc()
  if defined(chroniclers.logBackendStd):
    cnt.inc()
  if defined(chroniclers.logBackendCustom):
    cnt.inc()
  if defined(chroniclers.logBackendNone):
    cnt.inc()
  if cnt > 1:
    warning("Select only one chroniclers.logBackend* flag")

when defined(chroniclers.logBackendChronicles):
  const chroniclersLogBackend* = "chronicles"
  import ./chroniclers/backends/chronicles_backend as chroniclersBackend
elif defined(chroniclers.logBackendStd):
  const chroniclersLogBackend* = "std"
  import ./chroniclers/backends/std_backend as chroniclersBackend
elif defined(chroniclers.logBackendCustom):
  const chroniclersLogBackend* = "custom"
  import ./chroniclers/backends/custom_backend as chroniclersBackend
elif defined(chroniclers.logBackendNone):
  const chroniclersLogBackend* = "none"
  import ./chroniclers/backends/none_backend as chroniclersBackend
elif defined(features.chroniclers.chronicles):
  const chroniclersLogBackend* = "chronicles"
  import ./chroniclers/backends/chronicles_backend as chroniclersBackend
elif defined(features.chroniclers.std):
  const chroniclersLogBackend* = "std"
  import ./chroniclers/backends/std_backend as chroniclersBackend
else:
  const chroniclersLogBackend* = "none"
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
