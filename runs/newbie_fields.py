# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': 's;sw;s;sw;s;sw;s;sw;fields;where',
    'name': '__announce__',
    'announce': 'Newbie Fields: Alien Tentacle, Massive Corn',
    'summary': True,
    'skip': 6,
  },
  {
    'path': '2 e;s;2 sw;w;8 sw;6 se;2 sw',
    'target': 'alien',
    'alignment': VERY_EVIL,
    'announce': 'Alien Tentacle (aggro) 1.4m [2 southeast]',
    'skip': 4,
  },
  {
    'path': '2 se',
    'target': 'alien',
    'alignment': VERY_EVIL,
    'announce': 'Alien Tentacle (aggro) 1.4m',
    'out': '2 ne',
    'in': '2 sw',
  },
  {
    'target': 'corn',
    'alignment': EXTREMELY_EVIL,
    'announce': 'Massive Corn Soldier (aggro) 1.8m',
    'warnings': "Casts 'death fog'",
  },
  {
    'path': '4 n;6 nw;10 ne;e;n;2 w',
    'announce': 'Newbie Fields',
  },
  {
    'path': 'w;ne;n;ne;n;ne;n;ne;n',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
