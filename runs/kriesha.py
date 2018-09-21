# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1n',
  },
  {
    'path': '3 w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;enter;where',
    'name': '__announce__',
    'announce': 'Kriesha: Eduard, Miklos, Priest',
    'summary': True,
    'skip': 6,
  },
  {
    'path': 'n;5 ne;enter',
    'target': 'eduard',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Eduard 2m',
    'out': 'out',
    'in': 'enter',
    'warnings': "Casts 'harm body'",
    'skip': 4,
  },
  {
    'path': 'e',
    'target': 'cook',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Miklos 1.1m',
  },
  {
    'path': 'w;out;4 e;4 ne;enter;open north door;n;2 w',
    'target': 'priest',
    'alignment': UNKNOWN,
    'announce': 'Priest 1.3m',
    'warnings': "Painmaster room",
  },
  {
    'path': '2 e;open south door;s;close north door;leave;10 sw;3 w',
    'announce': 'Kriesha',
  },
  {
    'path': 'leave;se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;3 e',
    'name': '__announce__',
    'announce': '1n',
  },
  {
    'name': 'Unknown',
  },
  ]
