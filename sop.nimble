# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
binDir = "bin"

# Dependencies

requires "nim >= 0.19.0"
requires "docopt >= 0.6.7"

bin = @[ "sop" ]
skipDirs = @[ "tests", "util" ]
