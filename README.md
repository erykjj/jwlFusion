<img src="res/dbFusion_wide.png" width=100%>
<img src="res/logo_tm.png">

Commandline/terminal **merge utility** for `.jwlibrary` backups created by the *JW Library* app[^1]

Keep your originals until you've confirmed all is well ;-)

By using this software you agree to abide by the terms of its [License](https://github.com/erykjj/jwlFusion#License-1-ov-file).

## Downloads

- [Linux (x86_64)](https://github.com/erykjj/jwlfusion/releases/latest/download/jwlFusion_linux_x86_64.tgz)
- [Linux (ARM64)](https://github.com/erykjj/jwlfusion/releases/latest/download/jwlFusion_linux_arm64.tgz)

- [macOS (x86_64)](https://github.com/erykjj/jwlfusion/releases/latest/download/jwlFusion_macos_x86_64.tar.gz)
- [macOS (ARM64)](https://github.com/erykjj/jwlfusion/releases/latest/download/jwlFusion_macos_arm64.tar.gz)

- [Windows (amd64)](https://github.com/erykjj/jwlfusion/releases/latest/download/jwlFusion_windows_amd64.zip)
- [Windows (ARM64)](https://github.com/erykjj/jwlfusion/releases/latest/download/jwlFusion_windows_arm64.zip)

## Usage

NOTE: The **macOS** binaries need to have all extended attributes (including the the Gatekeeper quarantine flag) removed:
```
> xattr -c jwlFusion
> xattr -c jwlCore.dylib
```

```
Usage: jwlFusion [-h | -v]  [-o:output] <original archive> <merge archive> [<merge archive>...]

Options:
  -h, --help                        Show this help message and exit.
  -v, --version                     Show the version and exit.
  -o:<archive>, --output=<archive>  Specify the output archive (optional);
                                      if not provided, creates archive
                                      in working directory.
```
Note that the archive provided later "over-writes" the previous, so the most "definitive" should be listed last. To illustrate, assume all archives have the same note but the note content has been modified in one of them. The last one will be the one that is used in the merged archive.

____
[![Static Badge](https://img.shields.io/badge/releases-orange?style=plastic&logo=rss&logoColor=orange&color=black)](https://github.com/erykjj/jwlFusion/releases.atom)

Feel free to get in touch and post any [issues and/or suggestions](https://github.com/erykjj/jwlFusion/issues).

My other *JW Library* projects: [**JWLManager**](https://github.com/erykjj/jwlmanager) & [**jwlFusion** (Android)](https://github.com/erykjj/jwlFusion-app)
____
#### Footnotes:
[^1]: [JW Library](https://www.jw.org/en/online-help/jw-library/) is a registered trademark of *Watch Tower Bible and Tract Society of Pennsylvania*
