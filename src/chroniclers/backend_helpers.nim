## Shared helpers for chroniclers backend adapters.

import std/macros

macro flattenLogMessage*(eventName: static[string], props: varargs[untyped]): untyped =
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
