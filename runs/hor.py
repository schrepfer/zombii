# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '4 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;4 nw;2 w;nw;w;nw;w;nw;w;5 nw;3 w;path;where',
    'name': '__announce__',
    'announce': 'Hor: Security Guard, Blain',
    'summary': True,
    'skip': 7,
  },
  {
    'path': '5 n;3 w;4 d',
    'target': 'guard',
    'announce': 'Security Guard (blocker) 225k [north]',
    'skip': 5,
    'flags': 'O',
  },
  {
    'path': 'n',
    'target': 'guard',
    'announce': 'Security Guard (blocker, aggro) 225k',
    'out': 's',
    'in': 'n',
    'flags': 'O',
  },
  {
    'path': 'n;e',
    'target': 'blain',
    'announce': 'Blain (aggro) 3.2m [north]',
    'flags': 'AO',
    'warnings': "Casts 'hellfire'",
  },
  {
    'path': 'n',
    'target': 'blain',
    'announce': 'Blain (aggro) 3.2m',
    'out': 's',
    'in': 'n',
    'flags': 'AO',
    'warnings': "Casts 'hellfire'",
  },
  {
    'path': 's;w;2 s;4 u;3 e;5 s',
    'announce': 'Hor',
  },
  {
    'path': 'out;3 e;5 se;e;se;e;se;e;se;2 e;4 se;e;se;e;se;e;2 se;e;se;e;se;e;4 se',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
]
