# vim: syn=python

from align import *

FILE = [
  {
    'announce': 'CS',
  },
  {
    'path': '4 s;3 e;n;inside;where',
    'name': '__announce__',
    'announce': 'Bard Guild: Cunning Stun Man',
    'summary': True,
    'skip': 5,
  },
  {
    'path': 'open north door;n;u;2 s',
    'target': 'fred',
    'alignment': GOOD,
    'announce': 'Cunning Stunt Man 4m',
    'out': 'n',
    'in': 's',
    'warnings': 'He moves!',
    'skip': 3,
  },
  {
    'path': '2 n;d;w',
    'target': 'fred',
    'alignment': GOOD,
    'announce': 'Cunning Stunt Man 4m',
    'out': 'n',
    'in': 's',
    'warnings': 'He moves!',
  },
  {
    'path': 'e;open south door;s;close north door',
    'announce': 'Bard Guild',
  },
  {
    'path': 'out;s;3 w;4 n',
    'name': '__announce__',
    'announce': 'CS',
  },
  {
    'name': 'Unknown',
  },
  ]
