# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '8 sw;w;11 sw;s;sw;tower;where',
    'name': '__announce__',
    'announce': 'Yellow Tower: Yramas',
    'summary': True,
    'skip': 5,
  },
  {
    'path': 'stairs',
    'target': 'yramas',
    'alignment': DEMONIC,
    'announce': 'Yramas (aggro) 6.1m [north]',
    'warnings': "Casts 'killing cloud', 'brainstorm', 'creeping doom', Breaks spells",
    'flags': 'A',
    'skip': 3,
  },
  {
    'path': 'search statue;spin statue;n',
    'target': 'yramas',
    'alignment': DEMONIC,
    'announce': 'Yramas (aggro) 6.1m',
    'out': 's',
    'in': 'n',
    'warnings': "Casts 'killing cloud', 'brainstorm', 'creeping doom', Breaks spells",
    'flags': 'A',
  },
  {
    'path': 's;stairs',
    'announce': 'Yellow Tower',
  },
  {
    'path': 'out;ne;n;11 ne;e;8 ne',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
