import std/unittest

import chroniclers

suite "chroniclers feature backend":
  test "chronicles feature selects Chronicles by default":
    check chroniclersLogBackend == "chronicles"

    var evaluated = false
    proc fieldValue(): string =
      evaluated = true
      "value"

    info "feature selected", value = fieldValue()

    check evaluated
