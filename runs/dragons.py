# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '5 w;3 nw;5 w;3 nw;20 w;4 w;2 nw;2 w;nw;6 w;sw;3 w;sw;w;sw;w;sw;path;where',
    'name': '__announce__',
    'announce': 'Dragons: 3x Monk, Ramlaar, High Priest, Trainer',
    'summary': True,
    'skip': 8,
  },
  {
    'path': '2 n',
    'target': 'guard',
    'alignment': NEUTRAL,
    'announce': 'Strong Monk (blocker) 2.1m',
    'out': 's',
    'in': 'n',
    'skip': 6,
    'flags': 'O',
  },
  {
    'path': 'enter;2 n',
    'target': 'guard',
    'alignment': NEUTRAL,
    'announce': '2x Powerful Monk 2.1m',
    'out': 's',
    'in': 'n',
  },
  {
    'path': 's;stairs;u;s',
    'target': 'ramlaar',
    'alignment': NEUTRAL,
    'announce': 'Ramlaar 2.1m',
    'out': 'n',
    'in': 's',
  },
  {
    'path': '3 search book;3 search scroll;n;d;s;w;nw;e',
    'target': 'priest',
    'alignment': GOOD,
    'announce': 'High Priest 3.7m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'w;se;e;2 n;w;sw;open north door;2 n;e',
    'target': 'trainer',
    'alignment': GOOD,
    'announce': 'Trainer 2m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'w;s;open south door;s;close north door;ne;e;s;out;s;out;2 s',
    'announce': 'Dragons',
  },
  {
    'path': 'out;ne;e;ne;e;ne;3 e;ne;6 e;se;2 e;2 se;4 e;20 e;3 se;5 e;3 se;5 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
