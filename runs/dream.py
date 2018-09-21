# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1n',
  },
  {
    'path': '20 w;6 w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;enter;where',
    'name': '__announce__',
    'announce': 'Dream: Senedar',
    'summary': True,
    'skip': 4,
  },
  {
    'path': '5 n',
    'target': 'man',
    'alignment': VERY_GOOD,
    'announce': 'Senedar 2m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'killing cloud', 'banishment', 'harm body'",
    'flags': 'AB',
    'skip': 2,
  },
  {
    'path': '5 s',
    'announce': 'Dream',
  },
  {
    'path': 'out;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;6 e;20 e',
    'name': '__announce__',
    'announce': '1n',
  },
  {
    'name': 'Unknown',
  },
  ]
