# Package

version       = "1.3.0"
author        = "Eryk J."
description   = "Merge one or more '.jwlibrary' archives"
license       = "Infiniti Noncommercial License"


# Dependencies
requires "nim >= 2.2.0"
requires "nimcrypto >= 0.6.2"

# Tasks
task linux, "Build jwlFusion_linux_x86_64":
  exec "nim c -d:linux -d:strip -d:release --out:jwlFusion_linux_x86_64/jwlFusion src/jwlFusion.nim"
