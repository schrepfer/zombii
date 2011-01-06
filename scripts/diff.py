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

def loadFile(file_name):
  data = []
  localscope = {}
  try:
    execfile(file_name, localscope)
  except StandardError:
    fatal('Could not load file: %s' % file_name)
  if 'FILE' not in localscope:
    fatal('Could not find FILE in: %s' % file_name)
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

  file_one, file_two = sys.argv[1:3]

  if not file_one or not file_two:
    fatal('--input-one and --input-two required.')

  if not os.path.exists(file_one):
    fatal('Could not find file: %s' % file_one)

  if not os.path.exists(file_two):
    fatal('Could not find file: %s' % file_two)

  one = loadFile(file_one)
  two = loadFile(file_two)

  for i, line_in_one in enumerate(one):
    if 'announce' not in line_in_one:
      continue
    for j, line_in_two in enumerate(two):
      if 'announce' not in line_in_two:
        continue
      if line_in_one['announce'] == line_in_two['announce']:
        for key in ('target', 'announce', 'warnings', 'flags', 'alignment'):
          if key in line_in_one:
            if key in line_in_two:
              if line_in_one[key] != line_in_two[key]:
                print '%s:' % line_in_one['announce']
                print '< %4d: %12s: %s' % (i, key, line_in_one[key])
                print '> %4d: %12s: %s' % (j, key, line_in_two[key])
                print
            else:
              print '%s:' % line_in_one['announce']
              print '< %4d: %12s: %s' % (i, key, line_in_one[key])
              print '> %4d:' % j
              print
          else:
            if key in line_in_two:
              print '%s:' % line_in_one['announce']
              print '< %4d:' % i
              print '> %4d: %12s: %s' % (j, key, line_in_two[key])
              print

if __name__ == '__main__':
  main(sys.argv)
