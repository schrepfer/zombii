# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '7 s;6 se;2 s;4 se;17 s;se;s;se;valley;where',
    'name': '__announce__',
    'announce': 'Azynya: Troll Chief, 2x Troll Guard, Troll King',
    'summary': True,
    'skip': 8,
  },
  {
    'path': 'valley;se;e;s;e;se;n;e;se;cave;ne;e;2 ne;e;s;e',
    'target': 'chief',
    'alignment': EVIL,
    'announce': 'Troll Chief (A small key) 1.5m',
    'out': 'w;n',
    'in': 's;e',
    'skip': 6,
  },
  {
    'path': 'w;n;w;2 sw;w;sw;unlock east door with A small key',
    'announce': 'Wooden Door',
    'items': 'A small key',
  },
  {
    'path': 'open east door;e;se',
    'target': 'guard',
    'alignment': SLIGHTLY_EVIL,
    'announce': '2x Troll Guard (blocker) 230k',
    'out': 'nw',
    'in': 'se',
    'skip': 3,
  },
  {
    'path': 'e',
    'target': 'king',
    'alignment': EVIL,
    'announce': 'Troll King 3.5m',
    'out': 'w',
    'in': 'e',
    'warnings': "Casts 'acid rain'",
  },
  {
    'path': 'w;nw;unlock west door with A small key;open west door;w;close east door;lock east door with A small key',
    'announce': 'Wooden Door',
    'items': 'A small key',
  },
  {
    'path': 'out;nw;w;s;nw;w;n;w;nw;out',
    'announce': 'Azynya',
  },
  {
    'path': 's;nw;n;nw;17 n;4 nw;2 n;6 nw;7 n',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
