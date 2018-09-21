# vim: syn=python

from align import *

FILE = [
  {
    'announce': 'CS',
  },
  {
    'path': '4 s;e;n;pull lever;where',
    'name': '__announce__',
    'announce': 'Mage Guild: Vampire',
    'summary': True,
    'commands': 'pull lever',
    'skip': 4,
  },
  {
    'path': 's;pull torchholder;3 w;n',
    'target': 'vampire',
    'alignment': EVIL,
    'announce': 'Vampire (aggro, touch) 1.2m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'golden arrow'",
  },
  {
    'path': 's;2 e;pull torchholder;e;n;enter hole',
    'announce': 'Library',
    'commands': 'enter hole',
  },
  {
    'path': 's;w;4 n',
    'name': '__announce__',
    'announce': 'CS',
  },
  {
    'name': 'Unknown',
  },
  ]
