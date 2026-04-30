## Compile-time selectable structured logging facade.
##
## The public logging templates intentionally mirror the common Chronicles call
## shape:
##
##   info "request complete", route = "/items/42", status = 200
##
## Select a backend with `-d:chroniclersLogBackend=chronicles|std|none`.
## When the value is not specified, Chronicles is used when the package's
## `chronicles` feature is enabled; otherwise Nim's `std/logging` is used.

import std/macros

const
  defaultBackend =
    when defined(feature.chroniclers.chronicles): "chronicles" else: "std"
  chroniclersLogBackend* {.strdefine.} = defaultBackend

when chroniclersLogBackend == "chronicles":
  import chronicles as chroniclesApi
  export chroniclesApi except debug, error, fatal, info, log, notice, trace, warn
elif chroniclersLogBackend == "std":
  import std/logging as stdLogging
  export stdLogging except debug, error, fatal, info, log, notice, warn
elif chroniclersLogBackend == "none":
  discard
else:
  {.error: "Unsupported chroniclersLogBackend. Use chronicles, std, or none.".}

macro flattenLogMessage(eventName: static[string], props: varargs[untyped]): untyped =
  ## Turns structured fields into a plain single-line message for non-structured
  ## logging backends.
  let msg = genSym(nskVar, "msg")
  result = newStmtList()
  result.add quote do:
    var `msg` = `eventName`

  for prop in props:
    case prop.kind
    of nnkAsgn, nnkExprEqExpr:
      let key = $prop[0]
      let value = prop[1]
      result.add quote do:
        `msg`.add(" ")
        `msg`.add(`key`)
        `msg`.add("=")
        `msg`.add($`value`)
    of nnkIdent, nnkSym:
      let key = $prop
      result.add quote do:
        `msg`.add(" ")
        `msg`.add(`key`)
        `msg`.add("=")
        `msg`.add($`prop`)
    else:
      result.add quote do:
        `msg`.add(" ")
        `msg`.add($`prop`)

  result.add msg

template trace*(eventName: static[string], props: varargs[untyped]) =
  when chroniclersLogBackend == "chronicles":
    chroniclesApi.trace eventName, props
  elif chroniclersLogBackend == "std":
    stdLogging.debug(flattenLogMessage(eventName, props))
  else:
    discard

template debug*(eventName: static[string], props: varargs[untyped]) =
  when chroniclersLogBackend == "chronicles":
    chroniclesApi.debug eventName, props
  elif chroniclersLogBackend == "std":
    stdLogging.debug(flattenLogMessage(eventName, props))
  else:
    discard

template info*(eventName: static[string], props: varargs[untyped]) =
  when chroniclersLogBackend == "chronicles":
    chroniclesApi.info eventName, props
  elif chroniclersLogBackend == "std":
    stdLogging.info(flattenLogMessage(eventName, props))
  else:
    discard

template notice*(eventName: static[string], props: varargs[untyped]) =
  when chroniclersLogBackend == "chronicles":
    chroniclesApi.notice eventName, props
  elif chroniclersLogBackend == "std":
    stdLogging.notice(flattenLogMessage(eventName, props))
  else:
    discard

template warn*(eventName: static[string], props: varargs[untyped]) =
  when chroniclersLogBackend == "chronicles":
    chroniclesApi.warn eventName, props
  elif chroniclersLogBackend == "std":
    stdLogging.warn(flattenLogMessage(eventName, props))
  else:
    discard

template error*(eventName: static[string], props: varargs[untyped]) =
  when chroniclersLogBackend == "chronicles":
    chroniclesApi.error eventName, props
  elif chroniclersLogBackend == "std":
    stdLogging.error(flattenLogMessage(eventName, props))
  else:
    discard

template fatal*(eventName: static[string], props: varargs[untyped]) =
  when chroniclersLogBackend == "chronicles":
    chroniclesApi.fatal eventName, props
  elif chroniclersLogBackend == "std":
    stdLogging.fatal(flattenLogMessage(eventName, props))
  else:
    discard
