# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1n',
  },
  {
    'path': '9 w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;path;where',
    'name': '__announce__',
    'announce': 'Stonemen: 3x Stonemen, Troll Chief',
    'summary': True,
    'skip': 8,
  },
  {
    'path': 'ne;n',
    'target': 'stoneman',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Stoneman 2m',
    'out': 's',
    'in': 'n',
    'flags': 'O',
    'skip': 6,
  },
  {
    'path': 'n;w',
    'target': 'stoneman',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Stoneman 2m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': 'e;n',
    'target': 'stoneman',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Stoneman 2m',
    'out': 's',
    'in': 'n',
  },
  {
    'path': 's;nw;w;enter tree',
    'commands': 'enter tree',
  },
  {
    'path': 'w;sw;se;ne;n',
    'target': 'chief',
    'alignment': VERY_EVIL,
    'announce': 'Troll Chief 4m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'killing cloud', 'acid rain'",
    'flags': 'A',
  },
  {
    'path': 's;sw;nw;ne;e;out;e;se;2 s;sw',
    'announce': 'Stonemen',
  },
  {
    'path': 'out;se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;9 e',
    'name': '__announce__',
    'announce': '1n',
  },
  {
    'name': 'Unknown',
  },
  ]
