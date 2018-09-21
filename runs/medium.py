# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '12 nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;n;nw;n;nw;enter;where',
    'name': '__announce__',
    'announce': 'Darkwater: Hag',
    'summary': True,
    'skip': 4,
  },
  {
    'path': '4 s;20 e;4 e;9 se;enter;kick bucket',
    'target': 'hag',
    'announce': 'Hag 100k',
    'skip': 2,
  },
  {
    'path': 'out;9 nw;20 w;4 w;4 n',
    'announce': 'Darkwater',
  },
  {
    'path': 'out;se;s;se;s;se;s;2 se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;2 se;s;se;s;12 se',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '8 sw;w;20 sw;2 sw;w;sw;w;4 sw;w;sw;swamps',
    'announce': 'Damorra Swamps: 2x Toadman Sergeant, 6x Alligator',
    'summary': True,
    'skip': 9,
  },
  {
    'path': 'ne;2 n;ne;e',
    'target': 'alligator',
    'announce': 'Alligator 260k',
    'skip': 7,
  },
  {
    'path': 'w;n;w',
    'target': 'sergeant',
    'announce': 'Toadman Sergeant 120k',
  },
  {
    'path': 'w;n',
    'target': 'sergeant',
    'announce': 'Toadman Sergeant 120k',
  },
  {
    'path': 'n;ne',
    'target': 'alligator',
    'announce': '2x Alligator 260k',
  },
  {
    'path': 'n',
    'target': 'alligator',
    'announce': '2x Alligator 260k',
  },
  {
    'path': '2 e;s',
    'target': 'alligator',
    'announce': 'Alligator 260k',
  },
  {
    'path': '2 w;sw;3 s;e;2 s;sw',
    'announce': 'Damorra Swamps',
  },
  {
    'path': 'out;ne;e;4 ne;e;ne;e;2 ne;20 ne;e;8 ne',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '2 se;5 e;4 se;6 e;se;e;se;city',
    'announce': 'Gondor: 2x Gate Guard',
    'summary': True,
    'skip': 4,
  },
  {
    'target': 'guard',
    'announce': '2x Gate Guard 100k',
    'skip': 2,
  },
  {
    'announce': 'Gondor',
  },
  {
    'path': 'fields;nw;w;nw;6 w;4 nw;5 w;2 nw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '6 w;sw;7 w;sw;3 w;sw;w;sw;w;sw;path',
    'announce': 'Druid Tower: Black Dragon',
    'summary': True,
    'skip': 4,
  },
  {
    'path': '3 s',
    'target': 'dragon',
    'announce': 'Black Dragon 100k',
    'skip': 2,
  },
  {
    'path': '3 n',
    'announce': 'Druid Tower',
  },
  {
    'path': 'path;ne;e;ne;e;ne;3 e;ne;7 e;ne;6 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '5 w;3 nw;5 w;3 nw;11 w;nw;w;nw;w;nw;w;2 nw;w;nw;trail',
    'announce': 'Sirros: Woman',
    'summary': True,
    'skip': 4,
  },
  {
    'path': '5 s;2 e;s;e',
    'target': 'woman',
    'announce': 'Woman 60k',
    'skip': 2,
  },
  {
    'path': 'w;n;2 w;5 n',
    'announce': 'Sirros',
  },
  {
    'path': 'path;se;e;2 se;e;se;e;se;e;se;11 e;3 se;5 e;3 se;5 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '6 w;sw;w;nw;n;enter',
    'announce': 'Greyhawk: Golem, 5x Ogre, Troll, 2x Bugbear',
    'summary': True,
    'skip': 11,
  },
  {
    'path': 'd;3 w;n;search se;se;search rug;d',
    'target': 'golem',
    'announce': 'Golem (blocker) 32k',
    'skip': 9,
  },
  {
    'path': 'n;ne;2 n;w',
    'target': 'ogre',
    'announce': 'Ogre 240k',
  },
  {
    'path': 'w',
    'target': 'ogre',
    'announce': 'Ogre 100k',
  },
  {
    'target': 'troll',
    'announce': 'Troll 100k',
  },
  {
    'path': '3 e',
    'target': 'ogre',
    'announce': 'Ogre 100k',
  },
  {
    'target': 'bugbear',
    'announce': 'Bugbear 130k',
  },
  {
    'path': 'e',
    'target': 'orc',
    'announce': 'Orc 100k',
  },
  {
    'target': 'bugbear',
    'announce': 'Bugbear 100k',
  },
  {
    'path': '2 w;2 s;sw;s;u;nw;s;3 e;u',
    'announce': 'Greyhawk',
  },
  {
    'path': 'out;s;se;e;ne;6 e',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '16 s;2 se;sw;5 se;17 s;portal',
    'announce': 'Medo: 4x Pirate, 2x Python, 2x Cobra, 2x Guard',
    'summary': True,
    'skip': 12,
  },
  {
    'path': 'portal;4 w;n;nw;2 w;2 u;w;u;w',
    'target': 'pirate',
    'announce': 'Pirate 100k',
    'skip': 10,
  },
  {
    'path': 'e;d;e;2 d;e;n',
    'target': 'python',
    'announce': 'Python 100k',
  },
  {
    'path': 's;e',
    'target': 'python',
    'announce': 'Python 100k',
  },
  {
    'path': 'e',
    'target': 'pirate',
    'announce': 'Pirate 100k',
  },
  {
    'path': 'ne;2 e;3 n;e',
    'target': 'cobra',
    'announce': 'Cobra 100k',
  },
  {
    'path': 's',
    'target': 'cobra',
    'announce': 'Cobra 100k',
  },
  {
    'path': 'e',
    'target': 'pirate',
    'announce': 'Pirate 100k',
  },
  {
    'path': 'ne',
    'target': 'pirate',
    'announce': 'Pirate 100k',
  },
  {
    'path': 'n',
    'target': 'guard',
    'announce': '2x Guard 100k',
  },
  {
    'path': 'leave;sw;w;n;w;3 s;2 w;sw;2 s;4 e;portal',
    'announce': 'Medo',
  },
  {
    'path': 'leave;17 n;5 nw;ne;2 nw;16 n',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '2 se;4 e;se;e;3 se;2 e;tree',
    'announce': 'Brownie Tree: Bimbela',
    'summary': True,
    'skip': 4,
  },
  {
    'path': 'enter;2 u;2 n;2 w;hut;s',
    'target': 'bimbella',
    'announce': 'Bimbella 100k',
    'skip': 2,
  },
  {
    'path': 'n;out;2 e;2 s;2 d;out',
    'announce': 'Brownie Tree',
  },
  {
    'path': 'out;2 w;3 nw;w;nw;4 w;2 nw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '2 se;9 e;ne;6 e;ne;e;e',
    'announce': 'Castle Concordia: 2x Treant, 8x Squire',
    'summary': True,
    'skip': 7,
  },
  {
    'target': 'treant',
    'announce': '2x Treant 160k',
    'skip': 5,
  },
  {
    'path': 's;5 e;4 s;3 e;6 s;6 w;2 s',
    'target': 'squire',
    'announce': '3x Squire 116k',
  },
  {
    'path': '3 n;2 w;s',
    'target': 'squire',
    'announce': '2x Squire 116k',
  },
  {
    'path': 'n;w',
    'target': 'squire',
    'announce': '3x Squire 116k',
  },
  {
    'path': '3 e;s;6 e;6 n;3 w;4 n;5 w;n',
    'announce': 'Castle Concordia',
  },
  {
    'path': 'w;w;sw;6 w;sw;9 w;2 nw',
    'announce': "9w",
  },
  {
    'name': '__announce__',
    'path': '8 ne;3 n;3 ne;path',
    'announce': "Saurus: 2x Unicorn",
    'summary': True,
    'skip': 4,
  },
  {
    'path': '3 w;4 n;e;n;e;n',
    'target': 'unicorn',
    'announce': "2x Unicorn 220k",
    'skip': 2,
  },
  {
    'path': 's;w;s;w;4 s;3 e',
    'announce': "Saurus",
  },
  {
    'path': 'path;3 sw;3 s;8 sw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '2 ne;12 e;ne;se;2 e;field',
    'announce': 'Brownie Fields: Minda',
    'summary': True,
    'skip': 4,
  },
  {
    'target': 'minda',
    'announce': 'Minda 240k',
    'skip': 2,
  },
  {
    'announce': 'Brownie Fields',
  },
  {
    'path': 'leave;2 w;nw;sw;12 w;2 sw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '2 se;9 e;ne;2 e;s',
    'announce': 'Mines: Dardel and Gremlin Chief',
    'summary': True,
    'skip': 5,
  },
  {
    'path': '5 s;w;n',
    'target': 'dardel',
    'announce': 'Dardel 270k',
    'skip': 3,
  },
  {
    'path': 's;e;enter;s;3 d;s;2 w',
    'target': 'chief',
    'announce': 'Gremlin Chief 210k',
  },
  {
    'path': '2 e;n;3 u;n;out;5 n',
    'announce': 'Mines',
  },
  {
    'path': 'out;2 w;sw;9 w;2 nw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': '__announce__',
    'path': '2 se;9 e;ne;5 e;se;circus',
    'announce': 'Circus: Lulu',
    'summary': True,
    'skip': 4,
  },
  {
    'path': 'tent',
    'target': 'lulu',
    'announce': 'Lulu 160k',
    'skip': 2,
  },
  {
    'path': 'out',
  },
  {
    'path': 'leave;nw;5 w;sw;9 w;2 nw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
]
