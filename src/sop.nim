const doc = """
sop is safety operation.

usage:
  sop cp [--owner=<owner>] [--group=<group>] [--mode=<mode>] <srcFile> <dstFile>
  sop rm <file>...
  sop edit <editor> <file>...
  samp [options]

options:
  -o --owner=<owner>     set owner
  -g --group=<group>     set group
  -m --mode=<mode>       set mode
  <srcFile>              srcFile
  <dstFile>              dstFile

help options:
  -h --help         show this screen
  -v --version      show version
"""

import docopt
import os, posix, times, strformat, sequtils, strutils

const 
  passwdFile = "/etc/passwd"
  groupFile = "/etc/group"

type
  Passwd = object
    userName: string
    passwd: string
    uid: string
    loginShell: string
  
  Group = object
    groupName: string

proc fetchPasswd() =
  let f = passwdFile.open FileMode.fmRead
  defer: f.close
  var 
    line: string
    lines: seq[string]
  while f.readLine line:
    lines.add line
  echo lines.mapIt(string, it.split ":").map(proc (x: openArray[string]): Passwd = Passwd(userName: "1"))

proc backupFile(srcFile: string, fmtStr: string = "yyyy-MM-dd\'_\'HHmmss") =
  ## backupFile is copy file as backup
  if not srcFile.existsFile:
    return
  let currentTime = now().format(fmtStr)
  let bkFile = &"{srcFile}.{currentTime}"
  copyFile srcFile, bkFile

proc cmdCp(args: Table[string, Value]) =
  ## cmdCp is cp commadn.
  let
    srcFile = $args["<srcFile>"]
    dstFile = $args["<dstFile>"]
  backupFile dstFile
  copyFile srcFile, dstFile
  discard chown(dstFile, 0, 0)

proc cmdRm(args: Table[string, Value]) =
  for f in @(args["<file>"]):
    if not f.existsFile:
      continue
    backupFile f
    removeFile f

proc cmdEdit(args: Table[string, Value]) =
  discard

if isMainModule:
  let args = docopt(doc, version="v1.0.0")
  echo args
  
  if args["cp"]:
    cmdCp args
  elif args["rm"]:
    cmdRm args
  elif args["edit"]:
    cmdEdit args
  else:
    echo "NG"
