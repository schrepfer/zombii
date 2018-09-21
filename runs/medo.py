# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '16 s;2 se;sw;5 se;17 s;portal;where',
    'name': '__announce__',
    'announce': 'Medo: Mama, Governor, Bartender',
    'summary': True,
    'skip': 6,
  },
  {
    'path': 'portal;4 w;3 n;3 e;2 n;2 e;ne;3 n;w;shop',
    'target': 'mama',
    'alignment': VERY_GOOD,
    'announce': 'Mama 2.1m',
    'out': 'out',
    'in': 'shop',
    'skip': 4,
  },
  {
    'path': 'out;e;2 n;w;2 n;u',
    'target': 'governor',
    'alignment': GOOD,
    'announce': 'Governor 6.4m',
    'out': 'd',
    'in': 'u',
    'warnings': "Casts 'heal body'",
  },
  {
    'path': 'd;2 s;out;3 s;bar;say conglomo',
    'target': 'bartender',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Bartender 1.2m',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'meteor retort', 'acid arrow', 'icebolt', 'firebolt'",
  },
  {
    'path': 'n;s;leave;sw;2 w;2 s;3 w;3 s;4 e;portal',
    'announce': 'Medo',
  },
  {
    'path': 'leave;17 n;5 nw;ne;2 nw;16 n',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
