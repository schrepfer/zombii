# vim: ft=python

import brownie_tree
reload(brownie_tree)

import cantador_undead
reload(cantador_undead)

import castle_greenlight
reload(castle_greenlight)

import keep_undead
reload(keep_undead)

import maester_undead
reload(maester_undead)

import mage_guild_undead
reload(mage_guild_undead)

import pyramid
reload(pyramid)

import ravenkall_sewers
reload(ravenkall_sewers)

import uhruul_undead
reload(uhruul_undead)


CITY_SKIPS = (
  mage_guild_undead.FILE[1]['skip'])

FILE = (
  [
    {
      'announce': '9w',
    },
  ] +
  brownie_tree.FILE[1:-1] +
  castle_greenlight.FILE[1:-1] +
  uhruul_undead.FILE[1:-1] +
  maester_undead.FILE[1:-1] +
  [
    {
      'path': '9 e',
      'name': '__announce__',
      'announce': 'CS',
      'skip': (
        CITY_SKIPS +
        cantador_undead.SKIPS + 2),  # 9e+9w
    },
  ] +
  mage_guild_undead.FILE[1:-1] +
  [
    {
      'path': '3 e;4 n;w;buy transport to ravenkall;where',
      'name': cantador_undead.FILE[0]['name'],
      'announce': cantador_undead.FILE[0]['announce'],
      'commands': 'buy transport to ravenkall',
      'items': 'all gold',
      'skip': cantador_undead.SKIPS,
    },
  ] +
  cantador_undead.FILE[1:-1] +
  [
    {
      'path': '6 n;ne;n;ne;n;2 ne;n;ne;n;ne;n;ne;enter;2 n;ne;2 nw;w;3 sw;4 w;sw;w;2 sw;w;nw;3 n;7 ne;2 n;climb;cs',
      'name': '__announce__',
      'announce': 'CS',
    },
    {
      'path': '9 w',
      'name': '__announce__',
      'announce': '9w',
    },
  ] +
  keep_undead.FILE[1:-1] +
  [
    {
      'name': 'Unknown',
    },
  ]
  )
