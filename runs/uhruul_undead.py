# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '7 se;s;se;s;se;s;se;s;where',
    'name': '__announce__',
    'announce': 'Uhruul: 5x Wraith, 3x Massive Wraith',
    'summary': True,
    'skip': 23,
  },
  {
    'path': 'enter;d;2 s;se;sw;buy 15;keep rope,rope',
    'announce': 'Rope with Hooks',
    'items': '250 gold',
    'skip': 21,
  },
  {
    'path': 'ne;nw;2 n;2 d;2 w;2 sw;attach rope',
    'items': 'rope',
    'announce': 'Cliff',
  },
  {
    'path': 'climb down',
    'commands': 'climb down',
    'skip': 18,
  },
  {
    'path': '3 se;e;move rocks',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro) 1.2m [east]',
  },
  {
    'path': 'e',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro) 1.2m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'ne',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Massive Wraith (aggro) 2.7m [northeast]',
  },
  {
    'path': 'ne',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Massive Wraith (aggro) 2.7m',
    'out': 'sw',
    'in': 'ne',
  },
  {
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro, duplicate) 1.2m [east]',
  },
  {
    'path': 'e',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro, duplicate) 1.2m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'e',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro, duplicate) 1.2m [east]',
  },
  {
    'path': 'e',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro, duplicate) 1.2m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'e',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Massive Wraith (aggro) 2.7m [east]',
  },
  {
    'path': 'e',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Massive Wraith (aggro) 2.7m',
    'out': 'w',
    'in': 'e',
  },
  {
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro, duplicate) 1.2m [southwest]',
  },
  {
    'path': 'sw',
    'target': 'wraith',
    'announce': 'Wraith (aggro, duplicate) 1.2m',
    'out': 'sw',
    'in': 'ne',
  },
  {
    'path': 'sw;se',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro, duplicate) 1.2m [west]',
  },
  {
    'path': 'w',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Wraith (aggro, duplicate) 1.2m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': 'w;nw;3 w;se',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Massive Wraith (aggro, duplicate) 2.7m [southeast]',
  },
  {
    'path': 'se',
    'target': 'wraith',
    'alignment': DEMONIC,
    'announce': 'Massive Wraith (aggro, duplicate) 2.7m',
    'out': 'nw',
    'in': 'se',
  },
  {
    'path': '2 nw;2 w;3 nw;climb up',
    'commands': 'climb up',
    'announce': 'Cliff',
  },
  {
    'path': '2 ne;2 e;3 u;out',
    'announce': 'Uhruul',
  },
  {
    'path': 'n;nw;n;nw;n;nw;n;7 nw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
