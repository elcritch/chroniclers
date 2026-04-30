import std/[os, strutils]

switch("mm", "arc")
switch("threads", "on")

task test, "run unit tests":
  for testFile in listFiles("tests/"):
    if testFile.endsWith(".nim") and testFile.splitFile().name.startsWith("t"):
      if testFile.splitFile().name == "tchroniclers":
        for backend in ["chronicles", "std", "none"]:
          exec(
            "nim c -r -d:chroniclersLogBackend=" & backend & " " & quoteShell(testFile)
          )
      else:
        exec("nim c -r " & quoteShell(testFile))
