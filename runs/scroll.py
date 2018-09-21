# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': 'n;2 ne;n;ne;n;ne;n;ne;village',
    'name': '__announce__',
    'announce': 'Village: Manservant, James',
  },
  {
    'path': '4 e;s',
    'target': 'servant',
    'announce': 'Manservant (aggro) 10k [here]',
  },
  {
    'path': 'pull rope',
    'target': 'servant',
    'announce': 'Manservant 10k, next James',
  },
  {
    'path': '3 s;unlock door;open door;2 s',
    'target': 'james',
    'announce': 'James 14k',
    'items': 'mansion key',
  },
  {
    'path': 's;u;n;w',
    'announce': 'Scroll, next Village Entrance',
  },
  {
    'path': 'e;s;d;7 n;4 w',
    'announce': 'Village, next 9w',
  },
  {
    'path': 'leave;sw;s;sw;s;sw;s;2 sw;s',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
]
