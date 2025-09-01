const
  App = "jwlFusion"
  Version = "1.13.0"
  Maturity = "stable"

#[  © 2025 Eryk J.
    This code is licensed under the Infiniti Noncommercial License.
    You may use and modify this code for personal, non-commercial purposes only.
    Sharing, distribution, or commercial use is strictly prohibited.
    See LICENSE for full terms.                                              ]#


import
  std/[json, os, random, strformat, strutils, times],
  nimcrypto, parseopt


when defined(windows):
  const
    libName = "jwlCore.dll"
    sep = r"\"
    mkdir = "mkdir "
    rmdir = "rmdir /S /Q "
elif defined(macosx):
  const
    libName = "libjwlCore.dylib"
    sep = "/"
    mkdir = "mkdir -p "
    rmdir = "rm -rf "
else: # linux
  const
    libName = "./libjwlCore.so"
    sep = "/"
    mkdir = "mkdir -p "
    rmdir = "rm -rf "


type ProgressCallback = proc(step: cint) {.cdecl.}

let
  spinner = ['\\', '|', '/', '-']

var
  spinIndex = 0
  fileCounter: int = 0


proc mergeDatabase(path1, path2: cstring): cint {.cdecl, dynlib: libName, importc.}
proc getCoreVersion(): cstring {.cdecl, dynlib: libName, importc.}
proc getZuluTime(): cstring {.cdecl, dynlib: libName, importc.}
proc getLastResult(): cstring {.cdecl, dynlib: libName, importc.}
proc setProgressCallback(cb: ProgressCallback) {.cdecl, dynlib: libName, importc.}


proc randomSuffix(length: int): string =
  const
    Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  random.randomize()
  result = newString(length)
  for i in 0 ..< length:
    result[i] = Chars[rand(Chars.high)]

proc sha256File(filename: string): string =
  let data = readFile(filename)
  var ctx: sha256
  ctx.init()
  ctx.update(data)
  let digest = ctx.finish()
  return digest.data.toHex(lowercase = true)

proc joinPaths(path, file: string): string =
  if path.endsWith(sep):
    return path[0..^2] & sep & file
  else:
    return path & sep & file


proc makeDir(dir: string) =
  if execShellCmd(mkdir & dir) != 0:
    echo "Failed to create directory: ", dir
    raise

proc removeDir(dir: string) =
  if execShellCmd(rmdir & dir) != 0:
    echo "Failed to remove directory: ", dir
    raise


proc zipUp(archive, dir: string) =
  let zip = &"zip -qj {archive} {dir}" & sep & "*"
  if execShellCmd(zip) != 0:
    echo "Failed to zip directory: ", dir
    raise

proc zipDown(archive, dir: string) =
  let unzip = &"unzip -qj {archive} -d {dir}"
  if execShellCmd(unzip) != 0:
    echo "Failed to unzip archive: ", archive
    raise


proc unzipArchive(archive, tmpDir: string): string =
  let path = joinPaths(tmpDir, fmt"{App}_{fileCounter}")
  inc(fileCounter)
  makeDir(path)
  zipDown(archive, path)

  var manifest: JsonNode
  let manifestFile = joinPaths(path, "manifest.json")
  manifest = parseFile(manifestFile)
  if manifest.hasKey("userDataBackup"):
    let userDataBackup = manifest["userDataBackup"]
    let schema = if userDataBackup.hasKey("schemaVersion"): userDataBackup["schemaVersion"].getInt else: 0
    if schema > 11:
      return path
  echo "Old schema version!"
  return ""

proc createArchive(source, destination, tz: string): string =
  try:
    let parts = destination.split(sep) 
    var manifest: JsonNode
    let manifestFile = joinPaths(source, "manifest.json")
    manifest = parseFile(manifestFile)
    manifest["name"] = %parts[^1]
    manifest["creationDate"] = %tz
    manifest["userDataBackup"]["deviceName"] = %fmt"{App}_v{Version}"
    manifest["userDataBackup"]["lastModifiedDate"] = %tz

    let dbFile = joinPaths(source, "userData.db")
    let hash = sha256File(dbFile)
    manifest["userDataBackup"]["hash"] = %hash
    manifest["userDataBackup"]["databaseName"] = %"userData.db"

    var file = open(manifestFile, fmWrite)
    file.write($manifest)
    file.close()

    for file in walkFiles(joinPaths(source, "*")):
      setFilePermissions(file, {fpUserRead, fpUserWrite, fpGroupRead, fpGroupWrite, fpOthersRead})
    zipUp(destination, source)

    return destination

  except Exception as e:
    echo &"ERROR creating archive:\n{e.msg}"
    raise


proc progressIndicator(step: cint) {.cdecl.} =
  stdout.write(spinner[spinIndex], "\b")
  stdout.flushFile()
  spinIndex = (spinIndex + 1) mod 4


proc main(inputFiles: seq[string], outputFile: string): bool =
  setProgressCallback(progressIndicator)
  let original = inputFiles[0]
  let workDir = "."
  let prefix = fmt"{App}_"
  var outArchive = outputFile
  if outArchive == "":
    outArchive = joinPaths(workDir, prefix) & now().format("yyyy-MM-dd") & ".jwlibrary"
  let tmpDir = joinPaths(".", fmt".{App}_" & randomSuffix(10))
  makeDir(tmpDir)
  var parts = original.split(sep) 
  stdout.write(fmt"   Original: {parts[^1]} ... ")
  let db1Path = unzipArchive(original, tmpDir)
  if db1Path == "":
    removeDir(tmpDir)
    return false
  echo "Unpacked"
  var status: cint
  var msg: cstring
  for archive in inputFiles[1..^1]:
    parts = archive.split(sep)
    stdout.write(fmt" + Merging:  {parts[^1]} ... ")
    stdout.flushFile()
    let db2Path = unzipArchive(archive, tmpDir)
    if db2Path == "":
      removeDir(tmpDir)
      return false
    status = mergeDatabase(db1Path.cstring, db2Path.cstring)
    msg = getLastResult()
    if status != 0:
      echo &"FAILED!\n   --> {msg}"
      removeDir(tmpDir)
      return false
    else:
      echo msg
  stdout.write(fmt" = Merged:   ")
  stdout.flushFile()
  let filename = createArchive(db1Path, outArchive, $getZuluTime())
  echo filename
  removeDir(tmpDir)
  return true

when isMainModule:
  let jwlCore = getCoreVersion()
  let
    t = cpuTime()
    t1 = epochTime()
    appName = getAppFilename().splitFile().name
    appHelp = unindent(fmt"""
      
      Merge one or more '.jwlibrary' archives.

      Usage: {appName} [-h | -v]  [-o:output] <original archive> <merge archive> [<merge archive>...]

      Options:
        -h, --help                        Show this help message and exit.
        -v, --version                     Show the version and exit.
        -o:<archive>, --output=<archive>  Specify the output archive (optional);
                                            if not provided, creates archive
                                            in working directory.
      """, 3, "  ")
  var
    inputFiles: seq[string]
    outputFile = ""
    showHelp = false
    showVersion = false

  for kind, key, val in getOpt():
    case kind
    of cmdArgument:
      if key.endsWith(".jwlibrary"):
        inputFiles.add(key)
      else:
        stderr.writeLine(fmt"Error: '{key}' is not a valid '.jwlibrary' archive name.")
        quit(1)
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h":
        showHelp = true
      of "version", "v":
        showVersion = true
      of "output", "o":
        if val == "":
          stderr.writeLine("Error: Missing output archive name.")
          quit(1)
        outputFile = val
        if not outputFile.endsWith(".jwlibrary"):
          outputFile &= ".jwlibrary"
      else:
        stderr.writeLine(fmt"Error: Unknown option '{key}'.")
        quit(1)
    of cmdEnd:
      discard

  if showHelp:
    echo appHelp
    quit(0)
  if showVersion:
    echo &"\n{App} {Maturity} v{Version}\n{$jwlCore}\n© 2025 Eryk J.\n"
    quit(0)

  if inputFiles.len < 2:
    echo appHelp
    quit(1)

  echo &"\n{appName} (v{Version})\n"
  if main(inputFiles, outputFile):
    echo &"\nTime: {epochTime() - t1:.1f}s (CPU: {cpuTime() - t:.1f}s)\n"
  else:
    echo &"\nErrors encountered! Process cancelled.\n"
