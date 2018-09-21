# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '5 w;3 nw;2 w;nw;w;2 nw;w;nw;w;nw;w;nw;w;where',
    'name': '__announce__',
    'announce': 'Towanda: 4x Centurion, Towanda Commander',
    'summary': True,
    'skip': 6,
  },
  {
    'path': '2 nw;gates;4 n;ne;nw',
    'target': 'centurion',
    'alignment': SLIGHTLY_GOOD,
    'announce': '2x Centurion (blocker) 170k',
    'out': 'se',
    'in': 'nw',
    'skip': 4,
  },
  {
    'path': 'n;ne;n;nw',
    'target': 'centurion',
    'alignment': SLIGHTLY_GOOD,
    'announce': '2x Centurion (blocker, duplicate) 170k',
    'out': 'se',
    'in': 'nw',
  },
  {
    'path': 'n;2 w;n',
    'target': 'commander',
    'alignment': UNKNOWN,
    'announce': 'Towanda Commander 6.8m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'earthquake'",
  },
  {
    'path': 's;2 e;s;se;s;sw;s;se;sw;5 s;2 se',
    'announce': 'Towanda',
  },
  {
    'path': 'e;se;e;se;e;se;e;2 se;e;se;2 e;3 se;5 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
