# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '2 ne;10 e;2 ne;e;ne;e;ne;e;ne;village;where',
    'name': '__announce__',
    'announce': 'Harbour: Radalgus',
    'summary': True,
    'skip': 4,
  },
  {
    'path': '2 e;n',
    'target': 'radalgus',
    'alignment': VERY_GOOD,
    'announce': 'Radalgus 1.7m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'fireball'",
    'flags': 'A',
    'skip': 2,
  },
  {
    'path': 's;2 w',
    'announce': 'Harbour',
  },
  {
    'path': 'w;sw;w;sw;w;sw;w;2 sw;10 w;2 sw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
