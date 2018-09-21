# vim: ft=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '16 s;2 sw;se;19 s;se;pyramid',
    'name': '__announce__',
    'announce': 'Pyramid: 2x Mummy, 2x Spirit',
    'summary': True,
    'skip': 11,
  },
  {
    'path': 'enter;stairs;ne;e;ne;e;n;search wall;examine stone;push stone;n;ladder;nw',
    'target': 'spirit',
    'alignment': VERY_EVIL,
    'announce': 'Spirit (aggro) 1m [southwest]',
    'skip': 9,
  },
  {
    'path': 'sw',
    'target': 'spirit',
    'alignment': VERY_EVIL,
    'announce': 'Spirit (aggro) 1m',
    'out': 'ne',
    'in': 'sw',
  },
  {
    'path': 'se;ne',
    'target': 'mummy',
    'alignment': VERY_EVIL,
    'announce': 'Mummy (aggro) 1.1m [northeast]',
  },
  {
    'path': 'ne',
    'target': 'mummy',
    'alignment': VERY_EVIL,
    'announce': 'Mummy (aggro) 1.1m',
    'out': 'sw',
    'in': 'ne',
  },
  {
    'path': 'se;sw;s;e',
    'target': 'spirit',
    'alignment': VERY_EVIL,
    'announce': 'Spirit (aggro) 1m [east]',
  },
  {
    'path': 'e',
    'target': 'spirit',
    'alignment': VERY_EVIL,
    'announce': 'Spirit (aggro) 1m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': '2 w;sw;2 w',
    'target': 'mummy',
    'alignment': VERY_EVIL,
    'announce': 'Mummy (aggro) 1.1m [south]',
  },
  {
    'path': 's',
    'target': 'mummy',
    'alignment': VERY_EVIL,
    'announce': 'Mummy (aggro) 1.1m',
    'out': 'n',
    'in': 's',
  },
  {
    'path': 'n;2 e;ne;n;nw;ladder;2 s;w;sw;w;ne;n;ne;stairs;2 s;se;e;n;ne;out',
    'announce': 'Pyramid',
  },
  {
    'path': 'leave;nw;19 n;nw;2 ne;16 n',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
