# vim: ft=python

# See dump.py in the scripts/ directory. It has features for working with these
# runs.

from align import *

FILE = [
  {
    # An announcement...but there's more. Historically the 'skip' and 'name'
    # ('next') information was stored inside of the previous line. For example
    # you might be at CS, your 'skip' would be set to the size of the next
    # area, so you could skip it and be right where you had left off, at CS.
    # The --dash--separated--format-- still works this way. The reason this was
    # moved to the next element in the list was so you could easily reorder
    # areas. Always having the previous move know about the next got tedious
    # when you wanted to move an area about. Now the ', next X' and 'skip' is
    # all self contained. This 'announce' will be expanded to 'CS, next Cyndre'
    # and the 'skip' of 3 will be set on this current line. The summary just
    # says that this is a summary line and it should be printed when dumping
    # with --summary.
    'announce': 'CS',
    'summary': True,
  },
  {
    # A few dirs, a target, an announce, and the name/skip mentioned on the
    # previous example. The 'skip' equals how many elements in the list must be
    # skipped in order to nullify any movements contained in this group. If you
    # notice, the 3rd element (including this) says that you're back at CS,
    # which is the previous room. That is how you want this to work.
    'path': 'e;n',
    'target': 'cyndre',
    'name': 'Cyndre',
    'announce': 'Cyndre 3.5m',
    'skip': 3,
  },
  {
    # Here party members should type 'buy kit', %{in} and %{out} set so you can
    # type /in and /out.  The rest of the elements have been mentioned.
    'path': '2 s',
    'target': 'tinker',
    'announce': 'Tinker 2m',
    'commands': 'buy kit',
    'out': 'n',
    'in': 's',
  },
  {
    # Flags set to O (outdoors). Other supported flags include 'A' (areas) and
    # 'B' (banishes/boos).  No targets are set. If you notice in the next
    # element, 'name' is set to '__announce__', this only means that the 'name'
    # will be the prefix of 'announce'. That means anything before a
    # comma/colon will be used as the name.
    'path': 'n;w',
    'announce': 'CS: Janina',
    'summary': True,
    'flags': 'O',
  },
  {
    # Items needed from bag, 'flute', some warnings and alignment of target is
    # neutral. A warning is sent to the party; warnings are just extra info.
    'path': 's;w',
    'target': 'janina',
    'alignment': NEUTRAL,  # NEUTRAL is from the align.py script
    'name': '__announce__',
    'announce': 'Janina 3.5m',
    'out': 'e;fly',
    'in': 'd;w',
    'items': 'flute',
    'warnings': "Casts 'harmony hand', 'psychic crush'",
  },
  {
    'name': 'Unknown',
  },
  ]
