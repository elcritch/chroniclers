import std/os

switch("mm", "arc")
switch("threads", "on")

task test, "run unit tests":
  exec(
    "nim c -r --skipParentCfg:on --skipProjCfg:on --path:src --path:tests " &
      quoteShell("tests/tdefault_backend.nim")
  )
  exec(
    "nim c -r --skipParentCfg:on --skipProjCfg:on --path:src --path:tests " &
      "-d:features.chroniclers.std -d:expectedBackend=std " &
      quoteShell("tests/tchroniclers.nim")
  )
  exec("nim c -r " & quoteShell("tests/tfeature_backend.nim"))
  exec("nim c -r -d:features.chroniclers.std " & quoteShell("tests/tfeature_backend.nim"))
  exec(
    "nim c -r -d:chroniclers.logBackendChronicles " &
      "-d:expectedBackend=chronicles " &
      quoteShell("tests/tchroniclers.nim")
  )
  exec(
    "nim c -r -d:chroniclers.logBackendStd -d:expectedBackend=std " &
      quoteShell("tests/tchroniclers.nim")
  )
  exec(
    "nim c -r -d:chroniclers.logBackendNone -d:expectedBackend=none " &
      quoteShell("tests/tchroniclers.nim")
  )
  exec(
    "nim c -r -d:chroniclers.logBackendCustom " &
      quoteShell("tests/tcustom_backend.nim")
  )
