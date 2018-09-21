# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1ne',
  },
  {
    'path': '4 n;2 ne;6 n;nw;2 n;ne;n;ne;path;where',
    'name': '__announce__',
    'announce': 'Isthmas: Gordin, Enard, Old man',
    'summary': True,
    'skip': 8,
  },
  {
    'path': '2 d;n;say friend',
    'commands': 'say friend',
    'skip': 6,
  },
  {
    'path': '2 e;se;ne;open east door;e',
    'target': 'gordin',
    'alignment': GOOD,
    'announce': 'Gordin 1m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'open west door;w;close east door;sw;nw;open south door;s',
    'target': 'enard',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Enard (A black steel key) 6.3m',
    'warnings': 'Locks door!',
    'out': 'n',
    'in': 's',
  },
  {
    'path': 'unlock north door with black steel key;open north door;n;close south door;lock south door with black steel key;w;2 n;2 e;2 s',
    'target': 'enard',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Enard 6.3m',
    'items': 'black steel key',
    'out': 'n',
    'in': 's',
  },
  {
    'path': '2 n;open north door;n',
    'target': 'man',
    'alignment': NEUTRAL,
    'announce': 'Old man 4.3m',
    'warnings': "Casts 'cryokinesis', 'molecular agitation'",
    'out': 's',
    'in': 'n',
  },
  {
    'path': 'open south door;s;close north door;2 w;2 s;w;sw;s;2 u',
    'announce': 'Isthmas',
  },
  {
    'path': 'out;sw;s;sw;2 s;se;6 s;2 sw;4 s',
    'name': '__announce__',
    'announce': '1ne',
  },
  {
    'name': 'Unknown',
  },
  ]
