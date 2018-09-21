# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '9 n;2 ne;n;ne;n;2 ne;n;forest;where',
    'name': '__announce__',
    'announce': 'Turre: Vargan, Sintk, Harum, Graks',
    'summary': True,
    'skip': 7,
  },
  {
    'path': '6 n;3 u',
    'target': 'vargan',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Vargan 1.8m',
    'out': 'd',
    'in': 'u',
    'warnings': "Casts 'cold ray', 'harm body'",
    'skip': 5,
  },
  {
    'path': '3 d;6 s;2 e;knock tree;enter;u',
    'target': 'sintk',
    'alignment': GOOD,
    'announce': 'Sintk 1.1m',
    'out': 'd',
    'in': 'u',
  },
  {
    'target': 'harum',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Harum 4m',
    'out': 'd',
    'in': 'u',
    'warnings': "Casts 'heal body', 'psychic crush'",
  },
  {
    'path': 'd;out;4 w',
    'target': 'graks',
    'alignment': NEUTRAL,
    'announce': 'Graks 5m',
    'out': 'e',
    'in': 'w',
    'warnings': 'Explodes on R.I.P.',
  },
  {
    'path': '2 e',
    'announce': 'Turre',
  },
  {
    'path': 'out;s;2 sw;s;sw;s;2 sw;9 s',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
