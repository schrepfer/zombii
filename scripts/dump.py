#!/usr/bin/python
#
# This is a converter for Zombii run files.
#
# CONFIG FILE FORMAT:
#
# FILE = [
#   {
#     'path': STRING,
#     'target': STRING,
#     'name': STRING,
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
# Note: Keys 'path', 'in', 'out' and 'commands' are each semi-colon separated. The key 'name' has a
#       special value of '__announce__' where by it's replaced with the prefix of 'announce'.
#
# EXAMPLES:
#
#  To dump a config file to the tf format:
#
#    ./dump.py -i some.py > some.txt
#
#  To reverse engineer the config file:
#
#    ./dump.py -p < some.txt > some.py
#
#  Dump the tf format to html:
#
#    ./dump.py --html < some.txt > some.html
#
#  Dump a column of path to python:
#
#    ./dump.py -i some.py -c path > other.py
#

import os
import sys
import types

from copy import deepcopy
from optparse import OptionParser

from trigs.zombie import runs

# This is the order that keys are printed. This is used in the Python and Text
# dump formats. It makes it easier to find where something is.
KEY_ORDER = (
  'path',
  'target',
  'alignment',
  'name',
  'announce',
  'summary',
  'commands',
  'out',
  'in',
  'items',
  'warnings',
  'flags',
  'skip',
)

# These are all of the sections that are used in the dump. Omitted sections are
# not used.
DUMP_SECTIONS = (
  'path',
  'target',
  'announce',
  'commands',
  'out',
  'in',
  'items',
  'skip',
  'warnings',
  'flags',
  'alignment',
)

# Separator used to separate sections
DUMP_SEPARATOR = '--'


def dirDict(line):
  """Returns a dictionary of the parsed line.

  Returns: Dict containing all sections from the line.
  """
  sections = line.strip().split(DUMP_SEPARATOR)
  result = {}
  if len(sections) >= 11 and sections[10]:
    result['alignment'] = sections[10]
  if len(sections) >= 10 and sections[9]:
    result['flags'] = sections[9]
  if len(sections) >= 9 and sections[8]:
    result['warnings'] = sections[8]
  if len(sections) >= 8 and sections[7]:
    result['skip'] = int(sections[7])
  if len(sections) >= 7 and sections[6]:
    result['items'] = sections[6]
  if len(sections) >= 6 and sections[5]:
    result['in'] = [ x for x in sections[5].split(';') if x ]
  if len(sections) >= 5 and sections[4]:
    result['out'] = [ x for x in sections[4].split(';') if x ]
  if len(sections) >= 4 and sections[3]:
    result['commands'] = [ x for x in sections[3].split(';') if x ]
  if len(sections) >= 3 and sections[2]:
    result['announce'] = sections[2]
  if len(sections) >= 2 and sections[1]:
    result['target'] = sections[1]
  if len(sections) >= 1 and sections[0]:
    result['path'] = [ x for x in sections[0].split(';') if x ]
  return result


def getFixedData(data):
  """Convert the convenience code to the real format. In the basic format,
  skips are contained within the section to be skipped instead of before. This
  converts this to that format. It also uses the name attribte and generates
  the 'X, next Y' lines.

  Args:
    data: Dict format of a run.

  Returns:
    Dict with the skips and announces updated.
  """
  data = deepcopy(data)
  prev = None
  for curr in data:
    if prev:
      if 'skip' in curr:
        prev['skip'] = curr['skip']
      if 'name' in curr and 'announce' in prev:
        if curr['name'] == '__announce__':
          if 'announce' in curr:
            curr['name'] = getPrefix(curr['announce'])
          else:
            curr['name'] = 'Unknown'
        prev['announce'] = '%s, next %s' % (prev['announce'], curr['name'])
    if 'skip' in curr:
      del curr['skip']
    prev = curr
  return data

def getPrefix(line):
  """Returns the prefix of the line.

  Args:
    line: String line to be inspected.

  Returns:
    String prefix of the given line.
  """
  for c in (':', ','):
    if c in line:
      return line[0:line.find(c)]
  return line


def checkSkips(data):
  """Scan through the data and print out skips that are incorrect.

  Args:
    data: List of dictionaries.

  Returns:
    True if there are no errors.
  """
  line = 0
  errors = False
  for curr in getFixedData(data):
    line += 1
    if 'skip' in curr and curr['skip'] > 0 and 'target' not in curr:
      if line + curr['skip'] > len(data):
        print 'Skip of %d on line %d is longer than the file.' % (curr['skip'], line)
        print
        errors = True
        continue
      skipTo = data[line - 1 + curr['skip']]
      if 'announce' not in curr or 'announce' not in skipTo or 'target' in skipTo:
        continue
      if getPrefix(curr['announce']) != getPrefix(skipTo['announce']):
        print 'Skip of %d on line %d does not match:' % (curr['skip'], line)
        print
        print '  %3d: %s' % (line, curr['announce'])
        print '  %3d: %s' % (line + curr['skip'], skipTo['announce'])
        print
        errors = True
        continue
  return not errors


def suggestSkips(data):
  """Scan through the data and suggest skips.

  Args:
    data: List of dictionaries.
  """
  i = 0
  data = getFixedData(data)
  for curr in data:
    i += 1
    if 'announce' not in curr:
      continue
    j = i
    for other in data[i:]:
      j += 1
      if 'announce' not in other:
        continue
      if getPrefix(curr['announce']) == getPrefix(other['announce']) and 'target' not in curr and \
          'target' not in other and ('skip' not in curr or curr['skip'] != -1):
        if 'skip' not in curr:
          print "%d can skip %d to %d" % (i, j - i, j)
          print
          print "  %3d: %s" % (i, curr['announce'])
          print "  %3d: %s" % (j, other['announce'])
          print
        elif curr['skip'] > j - i:
          print '%d currently skips %d but should maybe skip %d' % (i, curr['skip'], j - i)
          print
          print "  %3d: %s" % (i, curr['announce'])
          print "  %3d: %s" % (j, other['announce'])
          print
        break

def dumpZmud(data, field=None):
  """Dump the data to the default format.

  Args:
    data: List of dictionaries.
    field: String name of specific field to dump.
  """
  for curr in getFixedData(data):
    output = []
    for key in DUMP_SECTIONS:
      if key not in curr:
        continue
      value = curr[key]
      if not value or (key == 'skip' and value == -1):
        continue
      if type(value) is types.ListType:
        value = ';'.join(value)
      output.append('#var %s {%s}' % (key, value))
    if output:
      print ';'.join(output)

def dumpText(data, field=None, summary=False):
  """Dump the data to a Text format.

  Args:
    data: List of dictionaries.
    field: String name of specific field to dump.
    summary: Print only summaries
  """
  first = True
  i = 0
  for curr in data:
    i += 1
    if field:
      if field in curr:
        value = curr[field]
      else:
        value = ''
      if type(value) is types.ListType:
        print '%5d: %s' % (i, ';'.join(value))
      else:
        print '%5d: %s' % (i, value)
    elif summary:
      if 'summary' in curr and curr['summary'] and 'announce' in curr:
        print i, curr['announce']
    else:
      if not first:
        print DUMP_SEPARATOR
      for key in KEY_ORDER:
        if key not in curr:
          continue
        value = curr[key]
        if type(value) is types.ListType:
          print '%16s = %s' % (key, ';'.join(value))
        else:
          print '%16s = %s' % (key, value)
      first = False


def dumpPython(data, field=None):
  """Dump the data to a Python format.

  Args:
    data: List of dictionaries.
    field: String name of specific field to dump.
  """
  print '# vim: ft=python'
  if field:
    print '# %s' % field
  print
  print 'FILE = [ # len() = %d' % len(data)
  for curr in data:
    if field:
      print '  %s,' % (repr(curr[field]) if field in curr else None)
    else:
      print '  {'
      for key in KEY_ORDER:
        if key not in curr:
          continue
        value = curr[key]
        if type(value) == types.ListType:
          value = ';'.join(value)
        print '    %s: %s,' % (repr(key), repr(value))
      print '  },'
  print '  ]'


def dumpHtml(data, field=None):
  """Dump the data to an HTML format.

  Args:
    data: List of dictionaries.
    field: String name of specific field to dump.
  """
  print """
<html>
  <head>
    <title>Dump</title>
    <style>
      body {
        background-color: #000;
        font-family: monaco, courier;
        font-size: 12px;
      }
      div {
        white-space: nowrap;
      }
      .semicolon {
        color: #9ff;
      }
      .separator {
        color: #999;
      }
      .alignment {
        color: #f99;
      }
      .flags {
        color: #f00;
      }
      .warnings {
        color: #900;
      }
      .skip {
        color: #3c6;
      }
      .items {
        color: #f0f;
      }
      .in, .out, .path {
        color: #39f;
      }
      .commands {
        color: #96f;
      }
      .announce {
        color: #ff0;
      }
      .target {
        color: #f90
      }
    </style>
  </head>
  <body>
  """
  output = []
  for key in DUMP_SECTIONS:
    output.append('<span class="%s">%s</span>' % (key, key))
  print '    <div>%s</div>' % '<span class="separator">--</span>'.join(output)
  print '    <hr/>'
  for curr in getFixedData(data):
    output = []
    skipped = 0
    for key in DUMP_SECTIONS:
      if key in curr:
        value = curr[key]
        if not value or (key == 'skip' and value == -1):
          skipped += 1
          continue
        for unused_i in xrange(skipped):
          output.append('')
          skipped = 0
        if type(value) is types.ListType:
          value = '<span class="semicolon">;</span>'.join(value)
        output.append('<span class="%s">%s</span>' % (key, value))
      else:
        skipped += 1
    if output:
      print '    <div>%s</div>' % '<span class="separator">--</span>'.join(output)

  print """
  </body>
</html>
  """

def dump(data, field=None):
  """Dump the data to the default format.

  Args:
    data: List of dictionaries.
    field: String name of specific field to dump.
  """
  for curr in getFixedData(data):
    output = []
    skipped = 0
    for key in DUMP_SECTIONS:
      if key in curr:
        value = curr[key]
        if not value or (key == 'skip' and value == -1):
          skipped += 1
          continue
        for unused_i in xrange(skipped):
          output.append('')
          skipped = 0
        if type(value) is types.ListType:
          value = ';'.join(value)
        output.append('%s' % value)
      else:
        skipped += 1
    if output:
      print DUMP_SEPARATOR.join(output)


def main():
  parser = OptionParser(
      version='RunDump v1.0.%s' % '$LastChangedRevision: 1323 $'[22:-2])
  parser.add_option(
      '-c', '--column',
      action='store',
      type='string',
      dest='column',
      default=None,
      help='Dumps all of the data from the column specified.',
      metavar='FIELD')
  parser.add_option(
      '-p', '--python',
      action='store_const',
      const='python',
      dest='output',
      help='Dump the data to python code.')
  parser.add_option(
      '-x', '--html',
      action='store_const',
      const='html',
      dest='output',
      help='Dump the data to html.')
  parser.add_option(
      '-z', '--zmud',
      action='store_const',
      const='zmud',
      dest='output',
      help='Dump the data to zmud.')
  parser.add_option(
      '-t', '--text',
      action='store_const',
      const='text',
      dest='output',
      help='Dump the data to text.')
  parser.add_option(
      '-i', '--input',
      action='store',
      type='string',
      dest='input',
      default=False,
      help='Load code instead of stdin dump.',
      metavar='FILE')
  parser.add_option(
      '-s', '--summary',
      action='store_true',
      dest='summary',
      default=False,
      help='Print summaries.')
  parser.add_option(
      '-v', '--verify',
      action='store_true',
      dest='verify',
      default=False,
      help='Verify that the configs are setup correctly.')

  options, args = parser.parse_args()

  data = []

  if options.input:
    if not os.path.isfile(options.input):
      parser.error('Could not find file: %s' % options.input)
    path, ext = os.path.splitext(options.input)
    if ext not in ('.py', '.pyc', '.pyo'):
      parser.error('Could not find a valid file to import.')
    parent, basename = os.path.split(path)
    data = runs.Run.loadMovementsListFromConfigFile(parent, basename)
    if not isinstance(data, list):
      parser.error('FILE must be a ListType')
    for key in ('path', 'commands', 'in', 'out'):
      if key not in data:
        continue
      data[key] = [x for x in data[key].split(';') if x]
  else:
    prevSkip = 0
    for line in sys.stdin.xreadlines():
      curr = dirDict(line)
      if 'skip' in curr:
        currSkip = curr['skip']
        del curr['skip']
      else:
        currSkip = 0
      if prevSkip:
        curr['skip'] = prevSkip
      prevSkip = currSkip
      data.append(curr)

  if options.verify:
    if not checkSkips(data):
      sys.exit(1)
    suggestSkips(data)
    sys.exit(0)

  if options.summary:
    dumpText(data, summary=True)
    sys.exit(0)

  if options.output == 'python':
    dumpPython(data, field=options.column)
  elif options.output == 'html':
    dumpHtml(data, field=options.column)
  elif options.output == 'text':
    dumpText(data, field=options.column)
  elif options.output == 'zmud':
    dumpZmud(data, field=options.column)
  else:
    dump(data, field=options.column)


if __name__ == '__main__':
  main()
