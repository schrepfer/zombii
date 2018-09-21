# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '8 s;sw;s;sw;s;2 sw;s;sw;s;sw;s;sw;forest;where',
    'name': '__announce__',
    'announce': 'Ranger Forest: Sandar, Thomas, Medicine man, 3x Shadowlord',
    'summary': True,
    'skip': 13,
  },
  {
    'path': 'w;n;enter;search bed;search floor;insert key into hole;say falcons fly far for fun',
    'target': 'sandar',
    'alignment': NEUTRAL,
    'announce': 'Sandar 5.5m',
    'out': 'out',
    'in': 'enter',
    'commands': 'enter',
    'skip': 11,
  },
  {
    'path': 'out;s;e;2 n;2 w;enter;n',
    'target': 'thomas',
    'alignment': GOOD,
    'announce': 'Thomas 3.6m',
    'out': 's',
    'in': 'n',
  },
  {
    'path': 's;out;e;n;enter',
    'target': 'shaman',
    'alignment': GOOD,
    'announce': 'Medicine man 4.1m',
    'out': 'out',
    'in': 'enter',
    'warnings': "Casts 'golden arrow'",
  },
  {
    'path': 'out;s;e;3 n;e;n;u;w;s',
    'target': 'child',
    'alignment': NEUTRAL,
    'announce': 'Kobold Child (bronze key) 2k',
    'flags': 'O',
  },
  {
    'path': 'n;e;3 u;unlock north door with A bronze key',
    'announce': 'Shadowlords Door',
    'items': 'A bronze key',
  },
  {
    'path': 'open north door;2 n;e;u;where',
    'announce': 'Shadowlords: Astaroth, Nosfentor, Faulinei',
    'summary': True,
    'skip': 5,
  },
  {
    'path': 'n',
    'target': 'shadowlord',
    'alignment': DEMONIC,
    'announce': 'Astaroth 5.4m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'power blast'",
  },
  {
    'path': 's;w',
    'target': 'shadowlord',
    'alignment': DEMONIC,
    'announce': 'Nosfentor 4.8m',
    'out': 'e',
    'in': 'w',
    'warnings': "Casts 'terror', 'harm body'",
    'flags': 'B',
  },
  {
    'path': '2 e',
    'target': 'shadowlord',
    'alignment': DEMONIC,
    'announce': 'Faulinei 4.3m',
    'out': 'w',
    'in': 'e',
    'warnings': "Casts 'harm body'",
  },
  {
    'path': 'w;d;w;s;unlock south door with A bronze key;open south door;s;close north door;lock north door with A bronze key',
    'announce': 'Shadowlords Door',
    'items': 'A bronze key',
  },
  {
    'path': '4 d;s;w;5 s',
    'announce': 'Ranger Forest',
  },
  {
    'path': 'se;ne;n;ne;n;ne;n;2 ne;n;ne;n;ne;8 n',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
