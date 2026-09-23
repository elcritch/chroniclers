import std/os

switch("mm", "arc")
switch("threads", "on")

task test, "run unit tests":
  exec(
    "nim c -r --skipParentCfg:on --skipProjCfg:on --path:src --path:tests " &
      quoteShell("tests/tdefault_backend.nim")
  )
  exec("nim c -r " & quoteShell("tests/tfeature_backend.nim"))
  exec(
    "nim c -r -d:chroniclers.logBackend=chronicles -d:expectedBackend=chronicles " &
      quoteShell("tests/tchroniclers.nim")
  )
  exec(
    "nim c -r -d:chroniclers.logBackend=std -d:expectedBackend=std " &
      quoteShell("tests/tchroniclers.nim")
  )
  exec(
    "nim c -r -d:chroniclers.logBackend=none -d:expectedBackend=none " &
      quoteShell("tests/tchroniclers.nim")
  )
  exec(
    "nim c -r -d:chroniclersLogBackend=std -d:expectedBackend=std " &
      quoteShell("tests/tchroniclers.nim")
  )
  exec(
    "nim c -r -d:chroniclers.logBackend=none -d:chroniclersBackendModule=tests/custom_backend " &
      quoteShell("tests/tcustom_backend.nim")
  )
