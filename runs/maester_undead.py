# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '11 n;15 nw;5 ne;n;ne;n;ne;path;where',
    'name': '__announce__',
    'announce': 'Maester: Ghost of Rades, Dirke',
    'summary': True,
    'skip': 6,
  },
  {
    'path': 'nw;ne;4 n;open gates;n;close gates;10 n;open gates;n;close gates;4 n;2 e;2 n;open northeast door;ne;close southwest door;open upstairs door;upstairs;close downstairs door;3 w;open north door;n;close south door;ne;n;open north door;n',
    'target': 'advisor',
    'alignment': VERY_EVIL,
    'announce': 'Ghost of Rades 1.7m',
    'out': 's',
    'in': 'n',
    'skip': 4,
  },
  {
    'path': 'open south door;s;close north door;sw;s;open south door;s;close north door;3 w;2 s;open west door;w;close east door;search corpse;enter passage',
    'commands': 'enter passage',
  },
  {
    'path': 'stairs;open east door;e',
    'target': 'dirke',
    'alignment': EVIL,
    'announce': 'Dirke 1.3m',
    'out': 'w',
    'in': 'e',
    'warnings': "Casts 'poison', Uses 'thrust'",
  },
  {
    'path': 'open west door;w;close east door;stairs;n;open east door;e;close west door;2 n;6 e;open downstairs door;downstairs;close upstairs door;open southwest door;sw;close northeast door;2 s;2 w;4 s;open gates;s;close gates;10 s;open gates;s;close gates;4 s;sw;se',
    'announce': 'Maester',
  },
  {
    'path': 'path;sw;s;sw;s;5 sw;15 se;11 s',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
