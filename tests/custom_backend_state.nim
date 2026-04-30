var messages*: seq[string]

proc resetMessages*() =
  messages.setLen(0)
