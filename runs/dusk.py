# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '2 ne;e;ne;e;ne;e;ne;path',
    'name': '__announce__',
    'announce': 'Dusk: Tobias, Chip Munk, Werner',
    'summary': True,
    'skip': 6,
  },
  {
    'path': '2 n;nw;n;w;sw',
    'target': 'tobias',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Tobias 1.4m',
    'out': 'out',
    'in': 'sw',
    'skip': 4,
  },
  {
    'path': 'out;e;2 n',
    'target': 'chip',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Chip Munk 800k',
    'out': 'out',
    'in': 'n',
  },
  {
    'path': 'out;s;2 e',
    'target': 'werner',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Werner',
    'out': 'out',
    'in': 'e',
    'warnings': "Uses 'kungfu'",
  },
  {
    'path': 'out;w;s;se;2 s',
    'announce': 'Dusk',
  },
  {
    'path': 'out;sw;w;sw;w;sw;w;2 sw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
