import std/os

switch("mm", "arc")
switch("threads", "on")

task test, "run unit tests":
  exec("nim c -r -d:chroniclersLogBackend=chronicles " & quoteShell("tests/tchroniclers.nim"))
  exec("nim c -r -d:chroniclersLogBackend=std " & quoteShell("tests/tchroniclers.nim"))
  exec("nim c -r -d:chroniclersLogBackend=none " & quoteShell("tests/tchroniclers.nim"))
  exec(
    "nim c -r -d:chroniclersLogBackend=none -d:chroniclersBackendModule=tests/custom_backend " &
      quoteShell("tests/tcustom_backend.nim")
  )
