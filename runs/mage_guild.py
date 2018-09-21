# vim: syn=python

from align import *

FILE = [
  {
    'announce': 'CS',
  },
  {
    'path': '4 s;e;n;pull lever;where',
    'name': '__announce__',
    'announce': 'Mage Guild: Xoth, Cemreet, Torturer, Vampire, Werewolf',
    'summary': True,
    'commands': 'pull lever',
    'skip': 8,
  },
  {
    'path': 's;pull torchholder;2 w;2 s;2 e;push barrel;e',
    'target': 'xoth',
    'alignment': GOOD,
    'announce': 'Xoth 1.3m',
    'out': 'w',
    'in': 'e',
    'warnings': "Casts 'cold ray'",
  },
  {
    'path': '6 w',
    'target': 'cemreet',
    'alignment': GOOD,
    'announce': 'Cemreet 1.7m',
    'out': 'e',
    'in': 'w',
    'warnings': "Casts 'fireball', 'golden arrow'",
    'flags': 'A',
  },
  {
    'path': '3 e;2 n;w;n',
    'target': 'vampire',
    'alignment': EVIL,
    'announce': 'Vampire (aggro, touch) 1.2m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'golden arrow'",
  },
  {
    'target': 'werewolf',
    'alignment': VERY_EVIL,
    'announce': 'Werewolf (aggro, touch) 1.3m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'golden arrow', 'cold ray'",
  },
  {
    'path': 'open gates;n;close gates;n;sit throne;2 w',
    'target': 'torturer',
    'alignment': EVIL,
    'announce': 'Torturer 1.3m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': 'e;pull lever;e;s;open gates;s;close gates;s;2 e;pull torchholder;e;n;enter hole',
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
