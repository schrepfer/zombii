# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '8 sw;w;20 sw;2 sw;w;sw;w;4 sw;w;sw;swamps;where',
    'name': '__announce__',
    'announce': 'Damorra Swamps: Alligator, 2x Toadman Guard, Keyholder, Lizard Guard',
    'summary': True,
    'skip': 11,
  },
  {
    'path': 'ne;2 n;ne;n;2 w;2 n;ne;2 e;2 n',
    'target': 'alligator',
    'alignment': NEUTRAL,
    'announce': 'Alligator (A small golden key) 660k',
    'flags': 'O',
    'skip': 9,
  },
  {
    'path': '2 s;2 w;sw;w;2 n;w;unlock west door with small golden key',
    'announce': 'Golden Door',
    'items': 'small golden key',
  },
  {
    'path': 'open west door;w',
    'target': 'guard',
    'alignment': UNKNOWN,
    'announce': '2x Toadman Guard (blocker) 1m',
    'out': 'e',
    'in': 'w',
    'warnings': "Casts 'poison' randomly, 'kurse', 'forget'",
    'flags': 'A',
    'skip': 3,
  },
  {
    'path': '4 s',
    'target': 'mah',
    'alignment': UNKNOWN,
    'announce': 'Keyholder (A tiny silver key) 2m',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'power blast'",
  },
  {
    'path': '3 n;unlock east door with small golden key;open east door;e;close west door;lock west door with small golden key',
    'announce': 'Golden Door',
    'items': 'small golden key',
  },
  {
    'path': 'e;3 s;e;2 s;e;2 s;sw;nw;s;unlock west door with tiny silver key',
    'announce': 'Silver Door',
    'items': 'tiny silver key',
  },
  {
    'path': 'open west door;w',
    'target': 'guard',
    'alignment': UNKNOWN,
    'announce': 'Lizard Guard 1.6m',
    'warnings': "Casts 'poison', 'firebolt', 'poison cloud'",
    'flags': 'A',
    'skip': 2,
  },
  {
    'path': 'unlock east door with tiny silver key;open east door;e;close west door;lock west door with tiny silver key',
    'announce': 'Silver Door',
    'items': 'tiny silver key',
  },
  {
    'path': 'n;se',
    'announce': 'Damorra Swamps',
  },
  {
    'path': 'out;ne;e;4 ne;e;ne;e;2 ne;20 ne;e;8 ne',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
