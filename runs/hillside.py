# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '16 n;2 nw;n;nw;n;nw;n;nw;hillside;where',
    'name': '__announce__',
    'announce': 'Hillside: Senior Cleric, Tahl-Sthor',
    'summary': True,
    'skip': 5,
  },
  {
    'path': 'd;7 e;ne',
    'target': 'cleric',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Senior Cleric (blocker) 670k',
    'out': 'sw',
    'in': 'ne',
    'warnings': "Casts 'firebolt', 'kurse'",
    'skip': 3,
  },
  {
    'path': 'd',
    'target': 'dragon',
    'alignment': EXTREMELY_EVIL,
    'announce': 'Tahl-Sthor 1.7m',
    'out': 'u',
    'in': 'd',
    'warnings': "Casts 'fireball', 'firebolt', 'kurse'",
    'flags': 'A',
  },
  {
    'path': 'u;sw;7 w;u',
    'announce': 'Hillside',
  },
  {
    'path': 'w;se;s;se;s;se;s;2 se;16 s',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
