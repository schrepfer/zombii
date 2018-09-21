# vim: ft=python

from align import *

FILE = [
  {
    'announce': 'Ravenkall Crossing',
    'skip': 26,
  },
  {
    'path': 'e;s;2 se;3 s;open east gate;2 e;open east door;e;open cabinet;enter cabinet;search wall;push lever;tunnel;d;s;get crowbar;n;u;w;open cabinet;out;open west door;w;close east door;w;open west gate;w;close east gate;3 n;2 nw;n;w',
    'skip': 1,
    'name': "Gardener's Crowbar",
    'announce': 'Ravenkall Crossing',
  },
  {
    'path': '2 w;3 n;2 w;wield crowbar;open manhole;d',
    'announce': 'Ravenkall Sewers: 5x Vampire Cleric, 5x Peasant Ghost',
    'name': '__announce__',
    'summary': True,
    'skip': 23,
  },
  {
    'path': '4 se;2 s;sw;2 se;ne;n;d;2 s;2 nw;w',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m [west]',
    'skip': 21,
  },
  {
    'path': 'w',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': 'e;2 ne',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m [west]',
  },
  {
    'path': 'w',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': '3 e;2 n;2 e',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m [southeast]',
  },
  {
    'path': 'se',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m',
    'out': 'nw',
    'in': 'se',
  },
  {
    'path': 'nw;2 w;2 s;2 se',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m [west]',
  },
  {
    'path': 'w',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': '2 e;se;2 e',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m [east]',
  },
  {
    'path': 'e',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'w',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m [south]',
  },
  {
    'path': 's',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m',
    'out': 'n',
    'in': 's',
  },
  {
    'path': 'n;2 w;nw;4 w;3 s',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m [east]',
  },
  {
    'path': 'e',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': 'e',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m [south]',
  },
  {
    'path': 's',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m',
    'out': 'n',
    'in': 's',
  },
  {
    'path': '2 e;d;3 w',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m [west]',
  },
  {
    'path': 'w',
    'target': 'undead',
    'announce': 'Vampire Cleric (aggro) 1.9m',
    'out': 'e',
    'in': 'w',
  },
  {
    'path': '3 e;ne;e',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m [east]',
  },
  {
    'path': 'e',
    'target': 'undead',
    'announce': 'Peasant Ghost (aggro) 1.2m',
    'out': 'w',
    'in': 'e',
  },
  {
    'path': '2 w;s;u;w;nw;2 w;3 n;u;s;sw;2 nw;ne;2 n;4 nw',
    'announce': 'Ravenkall Sewers',
  },
  {
    'path': 'u;2 e;3 s;2 e',  # close manhole
    'name': '__announce__',
    'announce': 'Ravenkall Crossing',
  },
  {
    'name': 'Unknown',
  },
  ]
