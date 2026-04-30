## Adapter that compiles logging calls away.

template trace*(eventName: static[string], props: varargs[untyped]) =
  discard

template debug*(eventName: static[string], props: varargs[untyped]) =
  discard

template info*(eventName: static[string], props: varargs[untyped]) =
  discard

template notice*(eventName: static[string], props: varargs[untyped]) =
  discard

template warn*(eventName: static[string], props: varargs[untyped]) =
  discard

template error*(eventName: static[string], props: varargs[untyped]) =
  discard

template fatal*(eventName: static[string], props: varargs[untyped]) =
  discard
