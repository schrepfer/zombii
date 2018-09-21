# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1ne',
  },
  {
    'path': 'w;sw;8 s;se;enter;where',
    'name': '__announce__',
    'announce': 'Ancient Forest: Priest',
    'summary': True,
    'skip': 4,
  },
  {
    'target': 'priest',
    'alignment': VERY_GOOD,
    'announce': 'Priest 3.7m',
    'out': 'forest',
    'in': 'enter',
    'flags': 'O',
    'skip': 2,
  },
  {
    'announce': 'Ancient Forest',
  },
  {
    'path': 'forest;nw;8 n;ne;e',
    'name': '__announce__',
    'announce': '1n',
  },
  {
    'name': 'Unknown',
  },
  ]
