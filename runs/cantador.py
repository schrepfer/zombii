# vim: syn=python

import ancient_forest
reload(ancient_forest)

import black_mines
reload(black_mines)

import dream
reload(dream)

import fireplane
reload(fireplane)

import grimhildr
reload(grimhildr)

import kriesha
reload(kriesha)

import prison
reload(prison)

import ravenkall_crossing
reload(ravenkall_crossing)

import serpent_lake
reload(serpent_lake)

import stonemen
reload(stonemen)

import wolves
reload(wolves)


SKIPS = (
  ravenkall_crossing.FILE[0]['skip'] +
  prison.FILE[1]['skip'] +
  serpent_lake.FILE[1]['skip'] +
  ancient_forest.FILE[1]['skip'] +
  stonemen.FILE[1]['skip'] +
  black_mines.FILE[1]['skip'] +
  #fireplane.FILE[1]['skip'] +
  kriesha.FILE[1]['skip'] +
  dream.FILE[1]['skip'] +
  grimhildr.FILE[1]['skip'] +  # cold
  wolves.FILE[1]['skip'] + 1)

FILE = (
  [
    {
      'name': 'Cantador',
      'announce': ravenkall_crossing.FILE[0]['announce'],
      'summary': True,
    },
  ] +
  ravenkall_crossing.FILE[1:-1] +
  [
    {
      'path': '2 e;6 n;2 w;3 n',
      'name': '__announce__',
      'announce': '1n',
    },
  ] +
  prison.FILE[1:-1] +
  serpent_lake.FILE[1:-1] +
  ancient_forest.FILE[1:-1] +
  stonemen.FILE[1:-1] +
  black_mines.FILE[1:-1] +
  #fireplane.FILE[1:-1] +
  kriesha.FILE[1:-1] +
  dream.FILE[1:-1] +
  grimhildr.FILE[1:-1] +
  wolves.FILE[1:-1] +
  [
    {
      'path': '3 s;2 e;6 s;2 w',
      'name': '__announce__',
      'announce': 'Ravenkall Crossing',
    },
    {
      'name': 'Unknown',
    },
  ]
  )
