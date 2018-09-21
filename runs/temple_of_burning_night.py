# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '3 sw;w;2 sw;w;2 sw;w;sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;4 sw;w;11 sw;2 nw;w;nw;n;where',
    'name': '__announce__',
    'announce': 'Temple of Burning Night: Shalash, Chaos Warrior',
    'summary': True,
    'skip': 7,
  },
  {
    'target': 'shalash',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Shalash (A iron key) 1.2m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'cause critical wounds'",
    'flags': 'O',
    'skip': 5,
  },
  {
    'path': 'unlock north door with iron key',
    'announce': 'A Iron Door',
    'items': 'iron key',
  },
  {
    'path': 'open north door;3 n;w',
    'target': 'warrior',
    'alignment': VERY_EVIL,
    'announce': 'Chaos Warrior 1.7m',
    'out': 'e',
    'in': 'w',
    'skip': 2,
  },
  {
    'path': 'e;3 s;close north door;lock north door with iron key',
    'announce': 'A Iron Door',
    'items': 'iron key',
  },
  {
    'announce': 'Temple of Burning Night',
  },
  {
    'path': 's;se;e;2 se;11 ne;e;4 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;ne;e;2 ne;e;2 ne;e;3 ne',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
