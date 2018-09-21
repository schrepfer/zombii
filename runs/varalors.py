# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '6 ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;ne;portal;where',
    'name': '__announce__',
    'announce': 'Varalors: Hileran, Verkle, Varalor Elder, Seeker, Grand Tortue, Dust',
    'summary': True,
    'skip': 9,
  },
  {
    'path': 'need flute;get flute;ne;nw;play flute;n;3 e;n',
    'target': 'hileran',
    'alignment': NEUTRAL,
    'announce': 'Hileran 1.2m',
    'commands': 'sw;se;need flute;get flute;ne;nw;play flute;n;3 e;n;pf',
    'out': 's',
    'in': 'n',
    'items': 'flute',
    'warnings': "Casts 'acid arrow', 'meteor blast', 'firebolt', 'meteor retort'",
    'skip': 7,
  },
  {
    'path': '2 s',
    'target': 'verkle',
    'alignment': NEUTRAL,
    'announce': 'Verkle 1.2m',
    'out': 'n',
    'in': 's',
    'warnings': "Casts 'acid arrow'",
  },
  {
    'path': 'n;leave;5 w',
    'target': 'elder',
    'alignment': NEUTRAL,
    'announce': 'Varalor Elder 2m',
    'out': 'leave',
    'in': 'w',
    'warnings': "Casts 'killing cloud'",
    'flags': 'A',
  },
  {
    'path': 'leave;2 e;4 n;2 w',
    'target': 'seeker',
    'alignment': VERY_GOOD,
    'announce': 'Seeker 1.2m',
    'out': 'e',
    'in': 'w',
    'warnings': "Casts 'mindfist'",
  },
  {
    'path': 'e;3 n;e',
    'target': 'tortue',
    'alignment': ANGELIC,
    'announce': 'Grand Tortue 3.6m',
    'out': 's',
    'in': 'n',
    'items': 'flute',
    'warnings': "Casts 'psychic crush'",
  },
  {
    'path': 'e;s;2 e;2 n',
    'target': 'dust',
#   'alignment': UNKNOWN,
    'announce': 'Dust (no spells) 2m',
    'out': 's',
    'in': 'n',
  },
  {
    'path': '2 s;3 w;4 s;leave;2 s;leave;sw;se',
    'announce': 'Varalors',
  },
  {
    'path': 'out;sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;6 sw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
