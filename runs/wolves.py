# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1n',
  },
  {
    'path': '3 w;11 sw;enter;where',
    'name': '__announce__',
    'announce': "Sepe's Wolves: Methus",
    'summary': True,
    'skip': 8,
  },
  {
    'path': '2 ne;open enter door;enter;nw;n;open west door;w',
    'target': 'methus',
    'alignment': NEUTRAL,
    'announce': 'Methus 1.2m',
    'out': 'e',
    'in': 'w',
    'skip': 6,
  },
  {
    'path': 'n;search bed;s;open east door;e;close west door;3 e;n;stairs;say key',
    'announce': 'Strong Wooden Key',
  },
  {
    'path': 'stairs;s;w;s;sw;open out door;out;close enter door;2 w;open northwest door;nw;w;unlock north door',
    'announce': 'Strong Wooden Door',
  },
  {
    'path': 'open north door;n;say fabie',
    'target': 'fabie',
    'alignment': NEUTRAL,
    'announce': 'Fabie 2m',
    'out': 'open south door;s',
    'in': 'open north door;n',
    'items': 'vial',
    'skip': 2,
  },
  {
    'path': 'unlock south door;open south door;s;close north door;lock north door with key',
    'items': 'key',
    'announce': 'Strong Wooden Door',
  },
  {
    'path': 'e;open southeast door;se;2 s',
    'announce': "Sepe's Wolves",
  },
  {
    'path': 'gate;11 ne;3 e',
    'name': '__announce__',
    'announce': '1n',
  },
  {
    'name': 'Unknown',
  },
  ]
