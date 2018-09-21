# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1ne',
  },
  {
    'path': '8 w;11 nw;w;3 nw;3 w;3 sw;s;sw;11 w;8 sw;w;sw;w;sw;2 w;sw;3 w;sw;2 w;sw;2 w;sw;4 w;sw;4 w;2 sw;s;entrance;where',
    'name': '__announce__',
    'announce': 'Shaolin: Old Librarian, Shang Hue, Purple Monk, Red Monk',
    'summary': True,
    'skip': 7,
  },
  {
    'path': 'ne;se',
    'target': 'librarian',
    'alignment': NEUTRAL,
    'announce': 'Old Librarian 1.7m',
    'out': 'nw',
    'in': 'se',
    'skip': 5,
    'warnings': "Uses 'kungfu'",
  },
  {
    'path': 'nw;ne',
    'target': 'shang',
    'alignment': VERY_GOOD,
    'announce': 'Shang Hue 3.8m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': '2 w;2 s',
    'target': 'purple',
    'alignment': GOOD,
    'announce': 'Purple Monk 2m',
    'warnings': 'Find it!',
  },
  {
    'target': 'red',
    'alignment': GOOD,
    'announce': 'Red Monk 1m',
    'warnings': 'Find it!',
  },
  {
    'announce': 'Shaolin',
  },
  {
    'path': 'out;n;2 ne;4 e;ne;4 e;ne;2 e;ne;2 e;ne;3 e;ne;2 e;ne;e;ne;e;8 ne;11 e;ne;n;3 ne;3 e;3 se;e;11 se;8 e',
    'name': '__announce__',
    'announce': '1ne',
  },
  {
    'name': 'Unknown',
  },
  ]
