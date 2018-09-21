# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '5 w;3 nw;5 w;3 nw;18 w;path;where',
    'name': '__announce__',
    'announce': 'Malbeth: Dandra, Dvork, Paladin Knight, 2x Guard, Malbeth, Portia',
    'summary': True,
    'skip': 11,
  },
  {
    'path': '2 s;sw;2 w;3 n;nw;n;enter;n;e',
    'target': 'dandra',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Dandra (blocker) 400k',
    'out': 'w',
    'in': 'e',
    'skip': 9,
  },
  {
    'path': 'e;d',
    'target': 'dvork',
    'alignment': GODLY,
    'announce': 'Dvork 3.8m',
    'out': 'u',
    'in': 'd',
    'warnings': "Casts 'dispel evil', 'flamestrike'",
  },
  {
    'path': '2 u',
    'target': 'knight',
    'alignment': GOOD,
    'announce': 'Paladin Knight (blocker) 300k',
  },
  {
    'path': 'u',
    'target': 'guard',
    'alignment': GOOD,
    'announce': '2x Guard (blocker, aggro) 1.3m [west]',
  },
  {
    'path': 'w',
    'target': 'guard',
    'alignment': GOOD,
    'announce': '2x Guard (blocker, aggro) 1.3m',
  },
  {
    'target': 'malbeth',
    'alignment': ANGELIC,
    'announce': 'Malbeth (aggro) 5m [west]',
    'warnings': "Casts 'glue', 'harm body', 'icebolt', 'banishment'",
    'flags': 'B',
  },
  {
    'path': 'w',
    'target': 'malbeth',
    'alignment': ANGELIC,
    'announce': 'Malbeth (aggro) 5m',
    'out': '2 e',
    'in': '2 w',
    'warnings': "Casts 'glue', 'harm body', 'icebolt', 'banishment'",
    'flags': 'B',
  },
  {
    'target': 'portia',
    'alignment': EXTREMELY_GOOD,
    'announce': 'Portia 2m',
    'out': '2 e',
    'in': '2 w',
  },
  {
    'path': '2 e;2 d;2 w;s;out;s;se;3 s;2 e;ne;2 n',
    'announce': 'Malbeth',
  },
  {
    'path': 'n;18 e;3 se;5 e;3 se;5 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
