#!/usr/bin/python
#
# This is a diff tool for Zombii run files.
#
# CONFIG FILE FORMAT:
#
# FILE = [
#   {
#     'path': STRING,
#     'target': STRING,
#     'announce': STRING,
#     'commands': STRING,
#     'out': STRING,
#     'in': STRING,
#     'items': STRING,
#     'skip': INTEGER,
#     'warnings': STRING,
#     'flags': STRING,
#     'alignment': STRING,
#   },
# ]
#
# Note: path, in, out and commands are each semi-colon separated
#

import os
import sys
import types

def fatal(message):
  print >> sys.stderr, message
  sys.exit(1)

def loadFile(filename):
  data = []
  localscope = {}
  try:
    execfile(filename, localscope)
  except StandardError:
    fatal('Could not load file: %s' % filename)
  if 'FILE' not in localscope:
    fatal('Could not find FILE in: %s' % filename)
  data = localscope['FILE']
  if type(data) != types.ListType:
    fatal('FILE must be a ListType')
  for key in ('path', 'commands', 'in', 'out'):
    if key in data:
      data[key] = [x for x in data[key].split(';') if x]
  return data

def main(args):
  version = 'RunDiff v1.0.%s' % '$LastChangedRevision: 1095 $'[22:-2]

  if len(sys.argv) != 3:
    fatal('Usage: %s <FILE> <FILE>' % sys.argv[0])

  fileOne, fileTwo = sys.argv[1:3]

  if not fileOne or not fileTwo:
    fatal('--input-one and --input-two required.')

  if not os.path.exists(fileOne):
    fatal('Could not find file: %s' % fileOne)

  if not os.path.exists(fileTwo):
    fatal('Could not find file: %s' % fileTwo)

  one = loadFile(fileOne)
  two = loadFile(fileTwo)

  for i, lineInOne in enumerate(one):
    if 'announce' not in lineInOne:
      continue
    for j, lineInTwo in enumerate(two):
      if 'announce' not in lineInTwo:
        continue
      if lineInOne['announce'] == lineInTwo['announce']:
        for key in ('target', 'announce', 'warnings', 'flags', 'alignment'):
          if key in lineInOne:
            if key in lineInTwo:
              if lineInOne[key] != lineInTwo[key]:
                print '%s:' % lineInOne['announce']
                print '< %4d: %12s: %s' % (i, key, lineInOne[key])
                print '> %4d: %12s: %s' % (j, key, lineInTwo[key])
                print
            else:
              print '%s:' % lineInOne['announce']
              print '< %4d: %12s: %s' % (i, key, lineInOne[key])
              print '> %4d:' % j
              print
          else:
            if key in lineInTwo:
              print '%s:' % lineInOne['announce']
              print '< %4d:' % i
              print '> %4d: %12s: %s' % (j, key, lineInTwo[key])
              print

if __name__ == '__main__':
  main(sys.argv)
