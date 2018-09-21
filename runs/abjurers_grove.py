# vim: syn=python

from align import *

FILE = [
  {
    'announce': '1ne',
  },
  {
    'path': '11 w;3 nw;sw;grove;where',
    'name': '__announce__',
    'announce': 'Abjurers Grove: Katalare, Slireistar, Alkinoyine, Hargris, Zoreil',
    'summary': True,
    'skip': 9,
  },
  {
    'path': '2 n;search barrels',
    'target': 'abjurer',
    'alignment': GOOD,
    'announce': 'Katalare 3m',
    'out': 's',
    'in': 'n',
    'flags': 'O',
    'skip': 7,
  },
  {
    'path': 'search barrels',
    'target': 'abjurer',
    'alignment': GOOD,
    'announce': 'Slireistar 3m',
    'out': 's',
    'in': 'n',
    'flags': 'O',
  },
  {
    'path': 'search barrels',
    'target': 'abjurer',
    'alignment': GOOD,
    'announce': 'Alkinoyine 3m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'poison'",
    'flags': 'O',
  },
  {
    'path': 'hut;press opal',
    'commands': 'press opal',
  },
  {
    'path': 'w;2 sw;e;d;s',
    'target': 'hargris',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Hargris Doc 2.8m',
    'out': 'n',
    'in': 's',
  },
  {
    'path': 'n;u;w;ne;w;press opal',
    'commands': 'press opal',
    'target': 'zoreil',
    'alignment': EVIL,
    'announce': 'Zoreil 1m',
    'out': 'n',
    'in': 's',
  },
  {
    'path': 'out;se;nw;n;2 nw;sw;grove',
    'announce': 'Abjurers Grove',
  },
  {
    'path': 's;ne;3 se;11 e',
    'name': '__announce__',
    'announce': '1ne',
  },
  {
    'name': 'Unknown',
  },
  ]
