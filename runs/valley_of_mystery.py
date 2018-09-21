# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '3 w;nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;7 w;nw;2 n;ne;e;where',
    'name': '__announce__',
    'announce': 'Valley of Mystery: Mishra, Troll, Merfolk',
    'summary': True,
    'skip': 9,
  },
  {
    'path': 'path;w;3 nw;w;5 nw;n;cave;get rock;out;7 s;2 se;w;swim;get drop;out;2 e;3 se;2 s;move stone;enter;s;say xor emocbu;give rock,drop to mishra',
    'announce': 'Altar',
    'skip': 7,
  },
  {
    'path': 'earth;5 e;ne;2 nw;2 w;2 nw;ne;4 e;se',
    'target': 'troll',
    'alignment': NEUTRAL,
    'announce': 'Troll (aggro, pray) 6.6m',
    'name': 'Earth',
    'out': 'nw',
    'in': 'se',
    'flags': 'O',
    'skip': 2,
  },
  {
    'path': 'nw;4 w;sw;2 se;2 e;2 se;sw;5 w;portal',
    'announce': 'Altar',
  },
  {
    'path': 'water;3 e;se',
    'target': 'merfolk',
    'alignment': UNKNOWN,
    'announce': 'Merfolk (aggro) 3.6m [east]',
    'name': 'Water',
    'skip': 3,
  },
  {
    'path': 'e',
    'target': 'merfolk',
    'alignment': UNKNOWN,
    'announce': 'Merfolk (aggro) 3.6m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'w;nw;3 w;portal',
    'target': 'mishra',
    'alignment': VERY_GOOD,
    'announce': 'Mishra 1.6m',
  },
  {
    'path': 'n;out;5 n;4 e;path',
    'announce': 'Valley of Mystery',
  },
  {
    'path': 'w;sw;2 s;se;7 e;se;e;se;e;2 se;e;se;e;se;e;se;3 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
