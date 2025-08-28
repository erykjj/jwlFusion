const
  App = "jwlFusion"
  Version = "1.10.3-beta"
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
  try:
    let path = tmpDir & sep & fmt"{App}_{fileCounter}"
    inc(fileCounter)
    makeDir(path)
    # setFilePermissions(path, {fpUserRead, fpUserWrite, fpUserExec, 
    #                          fpGroupRead, fpGroupWrite, fpGroupExec,
    #                          fpOthersRead, fpOthersWrite, fpOthersExec})
    zipDown(archive, path)
    when defined(macosx):
      setFilePermissions(path.string & "/userData.db",
        {fpUserRead, fpUserWrite, fpUserExec, 
        fpGroupRead, fpGroupWrite, fpGroupExec,
        fpOthersRead, fpOthersWrite, fpOthersExec})

    return path
  except Exception as e:
    echo &"ERROR extracting '{archive}':\n{e.msg}"
    raise

proc createArchive(source, destination, tz: string): string =


  try:
    var manifest: JsonNode
    let manifestFile = source & sep & "manifest.json"
    manifest = parseFile(manifestFile)
    manifest["name"] = %App
    manifest["creationDate"] = %tz
    manifest["userDataBackup"]["deviceName"] = %fmt"{App}_v{Version}"
    manifest["userDataBackup"]["lastModifiedDate"] = %tz

    let dbFile = source & sep & "userData.db"
    let hash = sha256File(dbFile)
    manifest["userDataBackup"]["hash"] = %hash
    manifest["userDataBackup"]["databaseName"] = %"userData.db"

    var file = open(manifestFile, fmWrite)
    file.write($manifest)
    file.close()

    for file in walkFiles(source & sep & "*"):
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
    outArchive = workDir & sep & prefix & now().format("yyyy-MM-dd") & ".jwlibrary"
  let tmpDir = "." & sep & fmt".{App}_" & randomSuffix(10)
  makeDir(tmpDir)
  stdout.write(fmt"   Original: {original} ... ")
  let db1Path = unzipArchive(original, tmpDir)
  echo "Unpacked"
  var status: cint
  var msg: cstring
  for archive in inputFiles[1..^1]:
    stdout.write(fmt" + Merging:  {archive} ... ")
    stdout.flushFile()
    status = mergeDatabase(db1Path.cstring, unzipArchive(archive, tmpDir).cstring)
    msg = getLastResult()
    if status != 0:
      echo &"FAILED!\n   --> {msg}"
      removeDir(tmpDir)
      return false
    else:
      echo msg
  stdout.write(fmt"   Packing:  ")
  stdout.flushFile()
  let filename = createArchive(db1Path, outArchive, $getZuluTime())
  echo "Done"
  echo fmt" = Merged:   {filename}"
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
