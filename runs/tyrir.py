# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '4 w;sw;w;4 sw;w;4 sw;5 w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;w;where',
    'name': '__announce__',
    'announce': 'Tyrir: 2x Guards, Yro, 2x Elite Guard, Borgan, Father Dunn',
    'summary': True,
    'skip': 9,
  },
  {
    'path': '2 n;gates;n;ne;n',
    'target': 'guard',
    'alignment': NEUTRAL,
    'announce': 'Guards (blocker, use skills) 18k',
    'skip': 7,
  },
  {
    'path': '2 n;u;2 n',
    'target': 'yro',
    'alignment': NEUTRAL,
    'announce': 'Yro 2.1m',
    'out': 's',
    'in': 'n',
  },
  {
    'path': '2 s;e',
    'target': 'guard',
    'alignment': UNKNOWN,
    'announce': '2x Elite Guard (blocker) 225k',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'e',
    'target': 'borgan',
    'alignment': UNKNOWN,
    'announce': 'Lord Borgan 3.1m',
    'out': 'w',
    'in': 'e',
    'skip': 2,
  },
  {
    'path': 'w',
    'target': 'guard',
    'alignment': UNKNOWN,
    'announce': '2x Elite Guard (blocker) 225k',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'w;s',
    'target': 'priest',
    'alignment': NEUTRAL,
    'announce': 'Father Dunn 3.5m',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'harm body'",
  },
  {
    'path': 'n;d;3 s;sw;s;gates;2 s',
    'announce': 'Tyrir',
  },
  {
    'path': 'e;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;5 e;4 ne;e;4 ne;e;ne;4 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
