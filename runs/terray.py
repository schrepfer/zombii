# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '8 sw;w;11 sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;3 w;4 sw;valley;where',
    'name': '__announce__',
    'announce': "Terray: Tunnuk, Dubbit, Leegah, Klypsys, Sh'nah",
    'summary': True,
    'skip': 8,
  },
  {
    'path': 'path;3 e;3 ne;3 n;2 w;nw',
    'target': 'tunnuk',
    'alignment': GOOD,
    'announce': 'Tunnuk 1.2m',
    'out': 'se',
    'in': 'nw',
    'warnings': "Casts 'acid arrow', 'icebolt', 'meteor retort', 'firebolt'",
    'skip': 6,
  },
  {
    'path': 'se;w',
    'target': 'dubbit',
    'alignment': GOOD,
    'announce': 'Dubbit 1.2m',
    'out': 'e',
    'in': 'w',
    'warnings': "Casts 'meteor blast', 'acid arrow', 'icebolt', 'meteor retort', 'firebolt'",
  },
  {
    'path': 'e;s',
    'target': 'leegah',
    'alignment': GOOD,
    'announce': 'Leegah 1.2m',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'icebolt', 'acid arrow', 'firebolt'",
  },
  {
    'path': '2 n',
    'target': 'klypsys',
    'alignment': GOOD,
    'announce': 'Klypsys 1.2m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'power blast'",
  },
  {
    'path': 's;2 e;4 se;7 s;enter',
    'target': 'shaman',
    'alignment': NEUTRAL,
    'announce': "Sh'nah 6.6m",
    'out': 'out',
    'in': 'enter',
    'warnings': "Casts 'killing cloud'",
    'flags': 'OA',
  },
  {
    'path': 'out;2 n;3 nw;w;nw;sw;5 w',
    'announce': 'Terray',
  },
  {
    'path': 'out;4 ne;3 e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;11 ne;e;8 ne',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
