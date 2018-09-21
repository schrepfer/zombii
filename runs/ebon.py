# vim: syn=python

from align import *

FILE = [
  {
    'announce': '9w',
  },
  {
    'path': '8 n;nw;n;2 nw;n;nw;n;nw;n;nw;e;where',
    'name': '__announce__',
    'announce': 'Ebon Stronghold: Witch, Keyholder, Fighter, Ebon Praetor',
    'summary': True,
    'skip': 11,
  },
  {
    'path': '2 n;ne;e;ne;e',
    'target': 'witch',
    'alignment': VERY_EVIL,
    'announce': 'The Witch (A iron key) 1m',
    'out': 'w',
    'in': 'e',
    'warnings': "Casts 'hellfire'",
    'skip': 9,
  },
  {
    'path': 'w;sw;w;sw;s;nw;s;pray praetor',
    'target': 'keyholder',
    'alignment': VERY_EVIL,
    'announce': 'Keyholder (Golden key) 2m',
    'commands': 'pray praetor',
    'out': 'portal',
    'in': 'pray praetor',
    'warnings': "Casts 'power blast'",
  },
  {
    'path': 'portal;n;se;n;unlock north door with iron key',
    'announce': 'Iron Door',
    'items': 'iron key',
  },
  {
    'path': 'open north door;n;nw;2 n;enter;ne;u;se;sw;u;nw;unlock east door with Golden key',
    'target': 'fighter',
    'alignment': UNKNOWN,
    'announce': 'Fighter (blocker, aggro) 3.5m [east]',
    'items': 'Golden key',
    'warnings': "Casts 'death fog', 'poison'",
    'skip': 5,
  },
  {
    'path': 'open east door;e',
    'target': 'fighter',
    'alignment': UNKNOWN,
    'announce': 'Fighter (blocker, aggro) 3.5m',
    'out': 'w',
    'in': 'e',
    'warnings': "Casts 'death fog', 'poison'",
  },
  {
    'target': 'praetor',
    'alignment': UNKNOWN,
    'announce': 'Ebon Praetor (aggro) 6m [up]',
    'warnings': "Casts 'hellfire', 'harm body', 'power blast', 'banishment'",
    'flags': 'B',
  },
  {
    'path': 'u',
    'target': 'praetor',
    'alignment': UNKNOWN,
    'announce': 'Ebon Praetor (aggro) 6m',
    'out': 'd;w',
    'in': 'e;u',
    'warnings': "Casts 'hellfire', 'harm body', 'power blast', 'banishment'",
    'flags': 'B',
  },
  {
    'path': 'd;unlock west door with Golden key;open west door;w;close east door;lock east door with Golden key;se;d;ne;nw;d;sw;out;2 s;se;unlock south door with iron key;open south door;s;close north door;lock north door with iron key',
    'announce': 'Iron Door',
    'items': 'iron key,Golden key',
  },
  {
    'path': '2 s',
    'announce': 'Ebon Stronghold',
  },
  {
    'path': 'w;se;s;se;s;se;s;2 se;s;se;8 s',
    'name': '__announce__',
    'announce': '9w',
  },
  {
    'name': 'Unknown',
  },
]
