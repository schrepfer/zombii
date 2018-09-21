# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1n',
  },
  {
    'path': 'w;13 sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;11 w;3 s;8 sw;w;sw;w;2 sw;w;sw;4 w;sw;se;enter;where',
    'name': '__announce__',
    'announce': 'Grimhildr: Rsudk Tyr, Dugulk, Makanga, Torams Dazokn, 2x Kobold Guard',
    'summary': True,
    'skip': 8,
  },
  {
    'path': '3 s;search snow',
    'commands': 'search snow',
    'skip': 6,
  },
  {
    'path': 'ne',
    'target': 'armourer',
    'alignment': GOOD,
    'announce': 'Rsudk Tyr 1.2m',
    'out': 'n',
    'in': 's',
    'flags': 'O',
  },
  {
    'path': 'sw;s',
    'target': 'butcher',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Dugulk 1.2m',
    'out': 'n',
    'in': 's',
    'flags': 'O',
  },
  {
    'path': '3 e;enter',
    'target': 'makanga',
    'alignment': NEUTRAL,
    'announce': 'Makanga 7.9m',
    'out': 'out',
    'in': 'enter',
    'warnings': "Casts 'wall of thorns', Opens doors (drafty)",
  },
  {
    'path': 'out;2 n;ne',
    'target': 'weaponsmith',
    'alignment': EVIL,
    'announce': 'Torams Dazokn 1.2m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': '3 w;2 nw',
    'announce': 'Grimhildr',
  },
  {
    'path': 'leave;nw;ne;4 e;ne;e;2 ne;e;ne;e;8 ne;3 n;11 e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;13 ne;e',
    'name': '__announce__',
    'announce': '1n',
  },
  {
    'name': 'Unknown',
  },
  ]
