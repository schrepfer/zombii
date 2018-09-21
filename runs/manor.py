# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '5 w;3 nw;w;11 nw;2 w;nw;9 w;nw;w;nw;valley;where',
    'name': '__announce__',
    'announce': 'Manor: Sentry, 3x Devil, Czchanectul',
    'summary': True,
    'skip': 11,
  },
  {
    'path': 'sw;open west door',
    'target': 'sentry',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Sentry (aggro, iron key) 150k [west]',
    'skip': 9,
  },
  {
    'path': 'w',
    'target': 'sentry',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Sentry (aggro) 150k',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': 'open east door;e;close west door;s;2 w;n;e',
    'announce': 'Waiting for Elevator',
  },
  {
    'path': 'open door;pull rope up;s',
    'announce': 'Riding Elevator',
    'skip': -1,
  },
  {
    'path': 'open door;n;3 e;unlock north door with iron key',
    'target': 'devil',
    'alignment': SLIGHTLY_EVIL,
    'announce': '3x Devil 32k',
    'items': 'iron key',
    'skip': -1,
  },
  {
    'path': 'open north door;n',
    'target': 'devil',
    'alignment': UNKNOWN,
    'announce': 'Czchanectul 1.3m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'brainstorm', 'psychic crush'",
    'flags': 'A',
  },
  {
    'path': 'unlock south door with iron key;open south door;s;close north door;lock north door with iron key;3 w',
    'announce': 'Waiting for Elevator',
    'items': 'iron key',
  },
  {
    'path': 'open door;pull rope down;s',
    'announce': 'Riding Elevator',
  },
  {
    'path': 'open door;n;w;s;2 e;n;ne',
    'announce': 'Manor',
  },
  {
    'path': 'uphill;se;e;se;9 e;se;2 e;11 se;e;3 se;5 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
