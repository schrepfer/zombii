# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1ne',
  },
  {
    'path': '12 nw;w;12 nw;w;nw;4 w;7 nw;9 w;nw;w;nw;w;5 nw;w;nw;3 w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;2 w;nw;w;4 nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;2 w;3 nw;w;nw;w;nw;w;nw;forest',
    'name': '__announce__',
    'announce': 'Mephala: Fiend, Thief, 6x Demon, 2x Hellhound',
    'summary': True,
    'skip': 11,
  },
  {
    'target': 'fiend',
    'alignment': DEMONIC,
    'announce': 'Roaming Fiend (aggro) 3m',
    'warnings': 'Find it!',
    'skip': 9,
  },
  {
    'path': 'open hut door;hut',
    'target': 'thief',
    'alignment': EVIL,
    'announce': 'Thief 1.7m',
    'out': 'out',
    'in': 'hut',
    'skip': 8,
  },
  {
    'path': 'out;close hut door;n;w;nw',
    'target': 'demon',
    'alignment': DEMONIC,
    'announce': 'Large Demon 1.7m',
    'out': 'se',
    'in': 'nw',
    'flags': 'O',
  },
  {
    'path': 'ne;e;gates',
    'target': 'demon',
    'alignment': DEMONIC,
    'announce': '3x Muscular Demon (blocker) 1.1m',
    'out': 'out',
    'in': 'gates',
  },
  {
    'path': '4 n',
    'target': 'demon',
    'alignment': DEMONIC,
    'announce': 'Ethereal Demon 2m',
    'out': 's',
    'in': 'n',
  },
  {
    'path': '4 s;2 w',
    'target': 'hellhound',
    'alignment': DEMONIC,
    'announce': '2x Hellhound (blocker) 1.7m',
    'out': 'e',
    'in': 'w',
  },
  {
    'target': 'demon',
    'alignment': DEMONIC,
    'announce': 'Gigantic Demon (aggro, blocker) 2m [west]',
  },
  {
    'path': 'w',
    'target': 'demon',
    'alignment': DEMONIC,
    'announce': 'Gigantic Demon (aggro, blocker) 2m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': '3 e;out;3 s',
    'announce': 'Mephala',
  },
  {
    'path': 's;se;e;se;e;se;e;3 se;2 e;2 se;e;se;e;se;e;2 se;e;se;e;4 se;e;se;2 e;se;e;se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;3 e;se;e;5 se;e;se;e;se;9 e;7 se;4 e;se;e;12 se;e;12 se',
    'name': '__announce__',
    'announce': '1ne',
  },
  {
    'name': 'Unknown',
  },
  ]
