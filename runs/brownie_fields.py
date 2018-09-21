# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '2 ne;12 e;ne;se;2 e;field;where',
    'name': '__announce__',
    'announce': 'Brownie Fields: Enfall',
    'summary': True,
    'skip': 4,
  },
  {
    'path': '4 n;e;se;s;4 e;4 ne;2 e;trace rixd',
    'target': 'enfall',
    'alignment': NEUTRAL,
    'announce': 'Enfall 1.3m',
    'commands': 'trace rixd',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'blindness', 'poison', 'power blast', 'brainstorm'",
    'flags': 'A',
    'skip': 2,
  },
  {
    'path': 'out;2 w;4 sw;4 w;n;nw;w;4 s',
    'announce': 'Brownie Fields',
  },
  {
    'path': 'leave;2 w;nw;sw;12 w;2 sw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
