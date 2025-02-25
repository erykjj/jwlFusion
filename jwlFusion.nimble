# Package

version       = "0.5.0"
author        = "Eryk J."
description   = "Merge one or more '.jwlibrary' archives"
license       = "Infiniti Noncommercial License"
srcDir        = "src"
bin           = @["jwlFusion"]


# Dependencies

requires "nim >= 2.2.0"
requires "nimcrypto >= 0.6.0"
requires "zippy >= 0.10.0"

# Tasks

task build, "Build jwlFusion":
  exec "nim c -d:release src/jwlFusion.nim"
