# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '14 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;woods;where',
    'name': '__announce__',
    'announce': 'Keep: Zombie',
    'summary': True,
    'skip': 5,
  },
  {
    'path': '2 n;w;n',
    'target': 'zombie',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Zombie (aggro) 1.2m [north]',
    'warnings': "Casts 'soul wrack'",
    'skip': 3,
  },
  {
    'path': 'n',
    'target': 'zombie',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Zombie (aggro) 1.2m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'soul wrack'",
  },
  {
    'path': '2 s;e;2 s',
    'announce': 'Keep',
  },
  {
    'path': 's;se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;14 se',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
