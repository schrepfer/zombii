# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1n',
  },
  {
    'path': '9 n;nw;clearing;where',
    'name': '__announce__',
    'announce': 'Fireplane: HUGE Gorilla, Fire Giant, Spirit',
    'summary': True,
    'skip': 9,
  },
  {
    'path': 'sw;w;s;climb tree;swing liana',
    'target': 'gorilla',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'HUGE Gorilla (aggro) 2m [east]',
    'commands': 'climb tree;swing liana',
    'warnings': "If you can't climb, reloc!",
    'skip': 7,
  },
  {
    'path': 'e',
    'target': 'gorilla',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'HUGE Gorilla (aggro) 2m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'w;d;2 w;sw;cross river',
    'announce': 'Lava River',
    'commands': 'cross river',
    'warnings': '51+ DEX',
  },
  {
    'path': '2 w;2 s',
    'target': 'giant',
    'alignment': EVIL,
    'announce': 'Fire Giant 2m',
    'skip': -1,
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'fireball'",
  },
  {
    'path': 's;2 e',
    'target': 'spirit',
    'alignment': EVIL,
    'announce': 'Spirit 2m',
    'out': 'w',
    'in': 'e',
    'warnings': "Casts 'fireball', 'hellfire'",
  },
  {
    'path': '3 n;cross river',
    'announce': 'Lava River',
    'commands': 'cross river',
    'warnings': '51+ DEX',
  },
  {
    'path': 'ne;3 e;ne',
    'announce': 'Fireplane',
  },
  {
    'path': 'out;se;9 s',
    'name': '__announce__',
    'announce': '1n',
  },
  {
    'name': 'Unknown',
  },
  ]
