const
  App = "jwlFusion"
  Version = "0.8.2"
  Maturity = "βητα"

#[  © 2025 Eryk J.
    This code is licensed under the Infiniti Noncommercial License.
    You may use and modify this code for personal, non-commercial purposes only.
    Sharing, distribution, or commercial use is strictly prohibited.
    See LICENSE for full terms.                                              ]#


import
  std/[json, os, random, strformat, strutils, tables, times],
  nimcrypto, parseopt, zippy/ziparchives


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
    rmdir = "rm -r "
else: # linux
  const
    libName = "./libjwlCore.so"
    sep = "/"
    mkdir = "mkdir -p "
    rmdir = "rm -r "

proc mergeDatabase(path1, path2: cstring) {.cdecl, dynlib: libName, importc.}
proc getCoreVersion(): cstring {.cdecl, dynlib: libName, importc.}
proc getZuluTime(): cstring {.cdecl, dynlib: libName, importc.}


var fileCounter: int = 0

proc randomSuffix(length: int): string =
  const
    Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  random.randomize()
  result = newString(length)
  for i in 0 ..< length:
    result[i] = Chars[rand(Chars.high)]

proc makeDir(dir: string) =
  # NOTE: createDir() doesn't work on macOS
  if execShellCmd(mkdir & dir) != 0:
    echo "Failed to create directory: ", dir
    raise

proc removeDir(dir: string) =
  # NOTE: removeDir() doesn't work on macOS
  if execShellCmd(rmdir & dir) != 0:
    echo "Failed to remove directory: ", dir
    raise

proc fileName(path: string): string =
  let lastSep = path.rfind(sep)
  if lastSep >= 0:
    return path[lastSep + 1 .. ^1]
  else:
    return path


proc unzipArchive(archive, tmpDir: string): string =
  try:
    let path = tmpDir & sep & fmt"{App}_{fileCounter}"
    inc(fileCounter)
    makeDir(path)
    var r = openZipArchive(archive)
    for entry in r.walkFiles():
      let fullPath = path & sep & entry
      writeFile(fullPath, r.extractFile(entry))
    return path
  except Exception as e:
    echo &"ERROR extracting '{archive}':\n{e.msg}"
    raise

proc createArchive(source, destination, tz: string): string =

  proc sha256File(filename: string): string =
    let data = readFile(filename)
    var ctx: sha256
    ctx.init()
    ctx.update(data)
    let digest = ctx.finish()
    return digest.data.toHex(lowercase = true)

  try:
    var manifest: JsonNode
    let manifestFile = source & sep & "manifest.json"
    manifest = parseFile(manifestFile)
    manifest["name"] = %App
    manifest["creationDate"] = %tz
    manifest["userDataBackup"]["deviceName"] = %fmt"{App}_{Version}"
    manifest["userDataBackup"]["lastModifiedDate"] = %tz

    let dbFile = source & sep & "userData.db"
    let hash = sha256File(dbFile)
    manifest["userDataBackup"]["hash"] = %hash
    manifest["userDataBackup"]["databaseName"] = %"userData.db"

    writeFile(manifestFile, $manifest)

    var entries: Table[string, string]
    for file in walkFiles(source & sep & "*"):
      let relativeFile = fileName(file)
      entries[relativeFile] = file.readFile
    let archive = createZipArchive(entries)
    writeFile(destination, archive)

    return destination

  except Exception as e:
    echo &"ERROR creating archive:\n{e.msg}"
    raise


proc main(inputFiles: seq[string], outputFile: string) =
  let original = inputFiles[0]
  let workDir = parentDir(original)
  let prefix = fmt"{App}_"
  var outArchive = outputFile
  if outArchive == "":
    outArchive = workDir & sep & prefix & now().format("yyyy-MM-dd") & ".jwlibrary"
  let tmpDir = "." & sep & fmt".{App}_" & randomSuffix(10)
  makeDir(tmpDir)
  let db1Path = unzipArchive(original, tmpDir)
  echo fmt"   Original: {original}"
  for archive in inputFiles[1..^1]:
    echo fmt" + Merging:  {archive}"
    mergeDatabase(db1Path.cstring, unzipArchive(archive, tmpDir).cstring)
  let filename = createArchive(db1Path, outArchive, $getZuluTime())
  echo fmt" = Merged:   {filename}"
  removeDir(tmpDir)


when isMainModule:
  let jwlCore = getCoreVersion()
  let
    t = cpuTime()
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

  echo &"\n{appName} ({Version})\n"
  main(inputFiles, outputFile)
  echo &"\nTime: {cpuTime() - t:.1f}s\n"
