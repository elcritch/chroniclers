## Compile-time selectable structured logging facade.
##
## The public logging templates intentionally mirror the common Chronicles call
## shape:
##
##   info "request complete", route = "/items/42", status = 200
##
## Select a built-in backend with `-d:chroniclers.logBackend=chronicles|std|none`.
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
  logBackend {.strdefine: "chroniclers.logBackend".} = "none"
  chroniclersLogBackend* = logBackend
  chroniclersBackendModule* {.strdefine.} = ""
  selectedBackendModule =
    when chroniclersBackendModule.len > 0:
      chroniclersBackendModule
    elif logBackend == "chronicles":
      "chroniclers/backends/chronicles_backend"
    elif logBackend == "std":
      "chroniclers/backends/std_backend"
    elif logBackend == "none":
      "chroniclers/backends/none_backend"
    else:
      {.
        error:
          "Unsupported chroniclers.logBackend. Use chronicles, std, none, or set chroniclersBackendModule."
      .}

macro importBackend(modulePath: static[string]): untyped =
  for ch in modulePath:
    if not (ch in {'a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '/'}):
      error("Invalid chroniclersBackendModule path: " & modulePath)

  parseStmt("import " & modulePath & " as chroniclersBackend")

static:
  echo "selectedBackendModule: ", selectedBackendModule
  echo "chroniclersBackendModule: ", chroniclersBackendModule
  echo "defined chroniclersBackendModule: ", $defined(chroniclersBackendModule)

when defined(chroniclersBackendModule):
  static: echo "BRANCH1"
  importBackend(chroniclersBackendModule)
elif chroniclers.logBackend == "none":
  static: echo "BRANCH1a"
  import ./chroniclers/backends/none_backend as chroniclersBackend
elif defined(features.chroniclers.chronicles):
  static: echo "BRANCH2"
  import ./chroniclers/backends/chronicles_backend as chroniclersBackend
elif defined(features.chroniclers.std):
  static: echo "BRANCH3"
  import ./chroniclers/backends/std_backend as chroniclersBackend
elif defined(chroniclers.logBackend):
  static: echo "BRANCH4"
  importBackend(selectedBackendModule)
else:
  static: echo "BRANCH5"
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
