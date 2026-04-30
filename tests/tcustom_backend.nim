import std/unittest

import chroniclers
import custom_backend_state

suite "custom chroniclers backend":
  setup:
    resetMessages()

  test "custom backend receives logging calls":
    let
      status = 200
      elapsedMs = 12.5

    trace "request trace", route = "/health", status = status
    debug "request debug", route = "/health", status
    info "request complete", route = "/health", status = status
    notice "request noticed", route = "/health", elapsedMs = elapsedMs
    warn "request slow", route = "/health", elapsedMs = elapsedMs
    error "request failed", route = "/health", status = 500
    fatal "server stopped", reason = "test"

    check messages ==
      @[
        "trace request trace route=/health status=200",
        "debug request debug route=/health status=200",
        "info request complete route=/health status=200",
        "notice request noticed route=/health elapsedMs=12.5",
        "warn request slow route=/health elapsedMs=12.5",
        "error request failed route=/health status=500",
        "fatal server stopped reason=test",
      ]

  test "custom backend module overrides built-in backend selection":
    proc fieldValue(): string =
      "evaluated"

    info "custom selected", value = fieldValue()

    check messages == @["info custom selected value=evaluated"]
