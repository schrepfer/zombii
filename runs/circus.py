# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '2 se;9 e;ne;5 e;se;circus;where',
    'name': '__announce__',
    'announce': 'Circus: Jack, Elmo, Sophia',
    'summary': True,
    'skip': 6,
  },
  {
    'path': 'tent',
    'target': 'jack',
    'alignment': SLIGHTLY_EVIL,
    'announce': 'Jack 1.2m',
    'out': 'out',
    'in': 'tent',
    'warnings': "Chains 'golden arrow'",
    'skip': 4,
  },
  {
    'path': 'wagon',
    'target': 'elmo',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Elmo 1.2m',
    'out': 'leave',
    'in': 'wagon',
    'warnings': "Uses 'strangle'",
  },
  {
    'path': 'leave;booth',
    'target': 'sophia',
    'alignment': SLIGHTLY_GOOD,
    'announce': 'Sophia 1.2m',
    'out': 'tent',
    'in': 'booth',
    'warnings': "Casts 'brainstorm', 'headache', 'mind melt'",
    'flags': 'A',
  },
  {
    'path': 'tent;out',
    'announce': 'Circus',
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
