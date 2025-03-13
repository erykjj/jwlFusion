# Package

version       = "0.7.0"
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

# task build, "Build jwlFusion_linux_x86_64":
#   exec "nim c -d:linux -d:strip -d:release --out:jwlFusion_linux_x86_64/jwlFusion src/jwlFusion.nim"
