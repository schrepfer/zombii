# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '16 s;2 se;sw;3 s;se;s;enter mists;where',
    'name': 'Ravenloft (to CS)',
    'announce': 'Ravenloft: Martyn, Andrei, Alexei, Vasili, Leonid',
    'summary': True,
    'commands': 'enter mists',
    'skip': 10,
  },
  {
    'path': 'sw;6 w;s',
    'target': 'martyn',
    'alignment': ANGELIC,
    'announce': 'Martyn 1.7m',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'fireball', 'lava storm', 'harm body', 'protection from evil', 'flamestrike'",
    'flags': 'A',
  },
  {
    'path': 'n;6 w;s',
    'target': 'andrei',
    'alignment': GOOD,
    'announce': 'Andrei 1.3m',
    'out': 'n',
    'in': 's',
  },
  {
    'target': 'alexei',
    'alignment': GOOD,
    'announce': 'Alexei (blocker) 1.7m',
    'out': 'n',
    'in': 's',
  },
  {
    'path': 'u;w;open north door;n',
    'target': 'vasili',
    'alignment': EVIL,
    'announce': 'Vasili 4.9m',
    'out': 'e',
    'in': 'w',
    'skip': 2,
    'warnings': "Casts 'fireball', 'power blast'",
  },
  {
    'path': 'open south door;s;close north door;e;d',
    'target': 'alexei',
    'alignment': GOOD,
    'announce': 'Alexei 1.7m',
    'out': 'n',
    'in': 's',
  },
  {
    'path': 'n;3 e;n;2 w',
    'target': 'leonid',
    'alignment': VERY_GOOD,
    'announce': 'Leonid 2m',
    'out': 'e',
    'in': 'w',
    'warnings': "Don't steal!",
  },
  {
    'path': 'e;s;11 w;3 n;e;enter;mists',
    'announce': 'Church',
    'commands': 'mists',
  },
  {
    'path': '4 e;3 s',
    'name': '__announce__',
    'announce': 'CS',
  },
  {
    'path': '9 w',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
