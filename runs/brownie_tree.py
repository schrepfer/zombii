# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '2 se;4 e;se;e;3 se;2 e;tree',
    'name': '__announce__',
    'announce': 'Brownie Tree: 2x Ghost',
    'summary': True,
    'skip': 5,
  },
  {
    'path': 'enter;d;2 n;search tunnels;tunnel',
    'target': 'undead',
    'alignment': DEMONIC,
    'announce': 'Ghost 2m',
    'out': 'out;2 s;u;2 out;w',
    'in': 'e;tree;enter;d;2 n;search tunnels;tunnel',
    'warnings': "Casts 'haunt', 'make scar', 'soul wrack'",
    'skip': 3,
  },
  {
    'path': 'n',
    'target': 'undead',
    'alignment': DEMONIC,
    'announce': 'Ghost 2m',
    'out': 's;out;2 s;u;2 out;w',
    'in': 'e;tree;enter;d;2 n;search tunnels;tunnel;n',
    'warnings': "Casts 'haunt', 'make scar', 'soul wrack'",
  },
  {
    'path': 's;out;2 s;u;out',
    'announce': 'Brownie Tree',
  },
  {
    'path': 'out;2 w;3 nw;w;nw;4 w;2 nw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
