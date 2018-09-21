# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '2 se;5 e;4 se;6 e;se;e;se;city;where',
    'name': '__announce__',
    'announce': 'Minas Tirith: Craftman, Merri, Healer, Peregrin Tuk',
    'summary': True,
    'skip': 7,
  },
  {
    'path': 'gates;w;2 nw;s',
    'target': 'craftman',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Old Craftman 1.2m',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'acid arrow', 'icebolt', 'firebolt', 'meteor retort'",
    'skip': 5,
  },
  {
    'path': 'n;2 se;e;2 n;castle;5 n;nw;sw;se;u;e;s',
    'target': 'merri',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Meriadoc 1.2m',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'acid arrow', 'firebolt', 'icebolt'",
  },
  {
    'path': '2 s;2 w;nw;n;3 w;hut;3 w',
    'target': 'healer',
    'alignment': ANGELIC,
    'announce': 'Healer 1.2m',
    'out': 'e',
    'in': 'w',
    'warnings': "Casts 'terror', 'snowstorm'",
    'flags': 'AB',
  },
  {
    'path': '3 e;out;3 e;2 s',
    'target': 'hobbit',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Peregrin Tuk 1.2m',
    'out': 'n',
    'in': 's',
    'warnings': "Wanders",
    'flags': 'O',
  },
  {
    'path': 'n;se;2 e;3 n;w;d;nw;ne;se;5 s;out;2 s;out',
    'announce': 'Minas Tirith',
  },
  {
    'path': 'fields;nw;w;nw;6 w;4 nw;5 w;2 nw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
