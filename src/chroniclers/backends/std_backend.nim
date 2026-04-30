## Adapter for Nim's std/logging backend.

import std/logging as stdLogging

import chroniclers/backend_helpers

export stdLogging except debug, error, fatal, info, log, notice, warn

template trace*(eventName: static[string], props: varargs[untyped]) =
  stdLogging.debug(flattenLogMessage(eventName, props))

template debug*(eventName: static[string], props: varargs[untyped]) =
  stdLogging.debug(flattenLogMessage(eventName, props))

template info*(eventName: static[string], props: varargs[untyped]) =
  stdLogging.info(flattenLogMessage(eventName, props))

template notice*(eventName: static[string], props: varargs[untyped]) =
  stdLogging.notice(flattenLogMessage(eventName, props))

template warn*(eventName: static[string], props: varargs[untyped]) =
  stdLogging.warn(flattenLogMessage(eventName, props))

template error*(eventName: static[string], props: varargs[untyped]) =
  stdLogging.error(flattenLogMessage(eventName, props))

template fatal*(eventName: static[string], props: varargs[untyped]) =
  stdLogging.fatal(flattenLogMessage(eventName, props))
