# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1n',
  },
  {
    'path': '20 w;17 w;nw;swim;where',
    'name': '__announce__',
    'announce': 'Serpent Lake: 4x Sea Serpent',
    'summary': True,
    'commands': 'swim',
    'skip': 12,
  },
  {
    'path': '2 w',
    'target': 'serpent',
    'alignment': NEUTRAL,
    'announce': 'Sea Serpent (aggro) ~3m [west]',
    'skip': 9,
  },
  {
    'path': 'w',
    'target': 'serpent',
    'alignment': NEUTRAL,
    'announce': 'Sea Serpent (aggro) ~3m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': 'n',
    'target': 'serpent',
    'alignment': NEUTRAL,
    'announce': 'Sea Serpent (aggro, duplicate) ~3m [west]',
  },
  {
    'path': 'w',
    'target': 'serpent',
    'alignment': NEUTRAL,
    'announce': 'Sea Serpent (aggro, duplicate) ~3m',
    'out': 'e',
    'in': 'w',
  },
  {
    'target': 'serpent',
    'alignment': NEUTRAL,
    'announce': 'Sea Serpent (aggro, duplicate) ~3m [northeast]',
  },
  {
    'path': 'ne',
    'target': 'serpent',
    'alignment': NEUTRAL,
    'announce': 'Sea Serpent (aggro, duplicate) ~3m',
    'out': 'sw',
    'in': 'ne',
  },
  {
    'target': 'serpent',
    'alignment': NEUTRAL,
    'announce': 'Sea Serpent (aggro, duplicate) ~3m [northeast]',
  },
  {
    'path': 'ne',
    'target': 'serpent',
    'alignment': NEUTRAL,
    'announce': 'Sea Serpent (aggro, duplicate) ~3m',
    'out': 'sw',
    'in': 'ne',
  },
  {
    'path': '2 sw;e;s;3 e',
    'announce': 'Serpent Lake',
  },
  {
    'path': 'swim',
    'announce': 'Outside Serpent Lake',
    'commands': 'swim',
  },
  {
    'path': 'se;17 e;20 e',
    'name': '__announce__',
    'announce': '1n',
  },
  {
    'name': 'Unknown',
  },
  ]
