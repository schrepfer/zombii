# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '9 nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;n;nw;n;nw;valley;where',
    'name': '__announce__',
    'announce': "Angarock: Kel'ba'rash",
    'summary': True,
    'skip': 4,
  },
  {
    'path': 'nw;n;2 nw;n;ne;2 u;icecave',
    'target': 'dragon',
    'alignment': EXTREMELY_EVIL,
    'announce': "Kel'ba'rash 6.5m",
    'warnings': "Casts 'blizzard storm', 'cold ray', 'frost arrow', 'banishment'",
    'flags': 'A',
    'in': 'icecave',
    'out': 'out',
    'skip': 2,
  },
  {
    'path': 'out;southwestdown;d;s;3 se;s;se',
    'announce': 'Angarock',
  },
  {
    'path': 'out;se;s;se;s;se;s;2 se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;9 se',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
