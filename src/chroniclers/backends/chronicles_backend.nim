## Adapter for the chronicles backend.

import chronicles as chroniclesApi

export chroniclesApi except debug, error, fatal, info, log, notice, trace, warn

template trace*(eventName: static[string], props: varargs[untyped]) =
  chroniclesApi.trace eventName, props

template debug*(eventName: static[string], props: varargs[untyped]) =
  chroniclesApi.debug eventName, props

template info*(eventName: static[string], props: varargs[untyped]) =
  chroniclesApi.info eventName, props

template notice*(eventName: static[string], props: varargs[untyped]) =
  chroniclesApi.notice eventName, props

template warn*(eventName: static[string], props: varargs[untyped]) =
  chroniclesApi.warn eventName, props

template error*(eventName: static[string], props: varargs[untyped]) =
  chroniclesApi.error eventName, props

template fatal*(eventName: static[string], props: varargs[untyped]) =
  chroniclesApi.fatal eventName, props
