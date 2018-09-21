# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1ne',
  },
  {
    'path': '8 w;11 nw;w;3 nw;3 w;3 sw;s;sw;19 w;nw;2 w;nw;2 w;3 sw;forest',
    'name': '__announce__',
    'announce': 'Pagoda: Osamu Kigoru, Kishiro Nara, Gardener',
    'summary': True,
    'skip': 6,
  },
  {
    'path': 'nw;w;nw;w;ne;e',
    'target': 'shopkeeper',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Osamu Kigoru 6.5m',
    'out': 'w',
    'in': 'e',
    'skip': 4,
  },
  {
    'path': 'w;sw;e;se;e;se;enter;ne;search wall;slide wall;e',
    'target': 'armourer',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Kishiro Nara 5m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'w;search wall;slide wall;n;w',
    'target': 'gardener',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Gardener 5m',
    'warnings': 'Wanders',
  },
  {
    'path': 'e;s;sw;out',
    'announce': 'Pagoda',
  },
  {
    'path': 'out;3 ne;2 e;se;2 e;se;19 e;ne;n;3 ne;3 e;3 se;e;11 se;8 e',
    'name': '__announce__',
    'announce': '1ne',
  },
  {
    'name': 'Unknown',
  },
  ]
