# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '20 nw;12 nw;n;2 nw;n;nw;n;nw;n;nw;path;where',
    'name': '__announce__',
    'announce': 'Obizuth: 3x Demon, Obizuth',
    'summary': True,
    'skip': 8,
  },
  {
    'path': '4 n;say fire;drawbridge;2 e',
    'target': 'demon',
    'alignment': EVIL,
    'announce': 'Demon 400k',
    'out': 'e',
    'in': 'w',
    'skip': 6,
  },
  {
    'path': 'u',
    'target': 'demon',
    'alignment': EVIL,
    'announce': 'Demon (duplicate) 400k',
    'out': 'd',
    'in': 'u',
  },
  {
    'path': 'u',
    'target': 'demon',
    'alignment': EVIL,
    'announce': 'Demon (duplicate) 400k',
    'out': 'd',
    'in': 'u',
  },
  {
    'target': 'obizuth',
    'alignment': UNKNOWN,
    'announce': 'Obizuth (aggro) 5.5m [northwest]',
    'warnings': "Casts 'hellfire', 'power blast'",
  },
  {
    'path': 'nw',
    'target': 'obizuth',
    'alignment': UNKNOWN,
    'announce': 'Obizuth (aggro) 5.5m',
    'out': 'se',
    'in': 'nw',
    'warnings': "Casts 'hellfire', 'power blast'",
  },
  {
    'path': 'se;2 d;2 w;out;4 s',
    'announce': 'Obizuth',
  },
  {
    'path': 'leave;se;s;se;s;se;s;2 se;s;12 se;20 se',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
