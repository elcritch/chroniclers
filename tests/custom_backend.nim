import chroniclers/backend_helpers
import custom_backend_state

template record(level, eventName: static[string], props: varargs[untyped]) =
  messages.add(level & " " & flattenLogMessage(eventName, props))

template trace*(eventName: static[string], props: varargs[untyped]) =
  record("trace", eventName, props)

template debug*(eventName: static[string], props: varargs[untyped]) =
  record("debug", eventName, props)

template info*(eventName: static[string], props: varargs[untyped]) =
  record("info", eventName, props)

template notice*(eventName: static[string], props: varargs[untyped]) =
  record("notice", eventName, props)

template warn*(eventName: static[string], props: varargs[untyped]) =
  record("warn", eventName, props)

template error*(eventName: static[string], props: varargs[untyped]) =
  record("error", eventName, props)

template fatal*(eventName: static[string], props: varargs[untyped]) =
  record("fatal", eventName, props)
