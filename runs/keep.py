# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '14 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;woods;where',
    'name': '__announce__',
    'announce': 'Keep: Cooker, Lurker, Zombie, Math Teacher',
    'summary': True,
    'skip': 9,
  },
  {
    'path': '2 n;2 w;s;d;2 n;2 e;s;e',
    'target': 'cooker',
    'alignment': NEUTRAL,
    'announce': 'Cooker 1.4m',
    'out': 'w',
    'in': 'e',
    'warnings': "Casts 'killing cloud'",
    'flags': 'A',
    'skip': 7,
  },
  {
    'path': 'w;n;2 w;2 s;u;3 n',
    'target': 'lurker',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Lurker (aggro) 1.4m [east, north]',
    'warnings': "Casts 'poison'",
  },
  {
    'path': 'e;n',
    'target': 'lurker',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Lurker (aggro) 1.4m',
    'out': 's;w',
    'in': 'e;n',
    'warnings': "Casts 'poison'",
  },
  {
    'path': 's;w;2 s;e;n',
    'target': 'zombie',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Zombie (aggro) 1.2m [north]',
    'warnings': "Casts 'soul wrack'",
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
    'path': 'u;e;n;w;n',
    'target': 'teacher',
    'alignment': EVIL,
    'announce': 'Math Teacher 6.2m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'fireball', 'killing cloud', 'creeping doom'",
    'flags': 'A',
  },
  {
    'path': 's;e;s;w;d;2 s;e;2 s',
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
