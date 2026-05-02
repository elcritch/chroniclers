import std/unittest

import chroniclers

suite "chroniclers default backend":
  test "default backend is none without chronicles feature":
    check logBackend == "none"
    check chroniclersLogBackend == logBackend

  test "default backend does not evaluate fields":
    proc failIfEvaluated(): string =
      raise newException(AssertionDefect, "log field was evaluated")

    info "skipped", value = failIfEvaluated()

    check true
