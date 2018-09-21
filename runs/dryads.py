# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '2 se;3 e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;se;path;where',
    'name': '__announce__',
    'announce': 'Dryads: Baalzedub, Hobgoblin Chief',
    'summary': True,
    'skip': 8,
  },
  {
    'path': '3 s;e;3 s;2 e;n;enter',
    'target': 'hermit',
    'alignment': EVIL,
    'announce': 'Baalzedub (rusty metal key) 1m',
    'out': 'out',
    'in': 'enter',
    'warnings': "Casts 'firebolt', 'creeping doom', 'thorn spray'",
    'skip': 6,
  },
  {
    'path': 'out;e;enter;unlock east door with rusty metal key',
    'announce': 'Rusty Metal Door',
    'commands': 'enter',
    'items': 'rusty metal key',
  },
  {
    'path': 'open east door;e;2 s',
    'target': 'chief',
    'alignment': EVIL,
    'announce': 'Hobgoblin Chief (aggro) 1.2m [southeast]',
    'items': 'rusty metal key',
    'skip': 3,
  },
  {
    'path': 'se',
    'target': 'chief',
    'alignment': EVIL,
    'announce': 'Hobgoblin Chief (aggro) 1.2m',
    'out': 'nw',
    'in': 'se',
  },
  {
    'path': 'nw;2 n;unlock west door with rusty metal key;open west door;w;close east door;lock east door with rusty metal key',
    'announce': 'Rusty Metal Door',
    'items': 'rusty metal key',
  },
  {
    'path': 'leave;sw;2 w;3 n;w;3 n',
    'announce': 'Dryads',
  },
  {
    'path': 'path;nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;3 w;2 nw',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
  ]
