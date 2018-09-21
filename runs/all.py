# vim: syn=python

import angarock
reload(angarock)

import azynya
reload(azynya)

import bard_guild
reload(bard_guild)

import brownie_fields
reload(brownie_fields)

import cantador
reload(cantador)

import castle_greenlight
reload(castle_greenlight)

import circus
reload(circus)

import cleric_guild
reload(cleric_guild)

import concordia
reload(concordia)

import damorra_swamps
reload(damorra_swamps)

import darkwater
reload(darkwater)

import deep_forest_ranger_outpost
reload(deep_forest_ranger_outpost)

import dragons
reload(dragons)

import dryads
reload(dryads)

import dusk
reload(dusk)

import harbour
reload(harbour)

import hemlock
reload(hemlock)

import hillside
reload(hillside)

import keep
reload(keep)

import maester
reload(maester)

import mage_guild
reload(mage_guild)

import malbeth
reload(malbeth)

import manor
reload(manor)

import medo
reload(medo)

import mellarnia
reload(mellarnia)

import minas_tirith
reload(minas_tirith)

import neckbreaker_desert
reload(neckbreaker_desert)

import newbie_fields
reload(newbie_fields)

import obizuth
reload(obizuth)

import ranger_forest
reload(ranger_forest)

import ravenloft
reload(ravenloft)

import revelstone
reload(revelstone)

import saurus
reload(saurus)

import temple_of_burning_night
reload(temple_of_burning_night)

import terray
reload(terray)

import towanda
reload(towanda)

import turre
reload(turre)

import tyrir
reload(tyrir)

import uhruul
reload(uhruul)

import valley_of_mystery
reload(valley_of_mystery)

import varalors
reload(varalors)

import yellow_tower
reload(yellow_tower)

import zombie_city
reload(zombie_city)


CITY_SKIPS = (
  zombie_city.FILE[0]['skip'] +
  cleric_guild.FILE[1]['skip'] +
  bard_guild.FILE[1]['skip'] +
  mage_guild.FILE[1]['skip'] + 1)

FILE = (
  [
    {
      'announce': '9w',
    },
    {
      'path': '9 e',
      'name': '__announce__',
      #'announce': 'ZombieCity',
      'announce': zombie_city.FILE[0]['announce'],
      'summary': True,
      'skip': (
        CITY_SKIPS +
        cantador.SKIPS +
        mellarnia.SKIPS - 1),
    },
  ] +
  zombie_city.FILE[1:-1] +
  cleric_guild.FILE[1:-1] +
  bard_guild.FILE[1:-1] +
  mage_guild.FILE[1:-1] +
  [
    {
      'path': '3 e;4 n;w;buy transport to ravenkall;where',
      'name': cantador.FILE[0]['name'],
      'announce': cantador.FILE[0]['announce'],
      'summary': True,
      'commands': 'buy transport to ravenkall',
      'items': 'all gold',
      'skip': cantador.SKIPS,
    },
  ] +
  cantador.FILE[1:-2] +
  [
    {
      'path': '6 n;ne;n;ne;n;2 ne;n;ne;n;ne;n;ne;enter;2 n;ne;2 nw;w;3 sw;4 w;sw;w;2 sw;w;nw;3 n;7 ne;2 n;climb;cs',
      'name': '__announce__',
      'announce': 'CS',
    },
    {
      'path': '3 e;4 n;w;buy transport to erend;where',
      'name': mellarnia.FILE[0]['name'],
      'announce': '1ne',
      'commands': 'buy transport to erend',
      'items': 'all gold',
      'skip': mellarnia.SKIPS,
    },
  ] +
  mellarnia.FILE[1:-1] +
  [
    {
      'path': 'sw;enter;buy transport to zombiecity',
      'name': '__announce__',
      'announce': 'CS',
      'commands': 'buy transport to zombiecity',
      'items': 'all gold',
    },
    {
      'path': '9 w',
      'name': '__announce__',
      'announce': '9w',
    },
  ] +
  revelstone.FILE[1:-1] + # cold
  uhruul.FILE[1:-1] +
  terray.FILE[1:-1] + # pois
  tyrir.FILE[1:-1] +
  dragons.FILE[1:-1] +
  towanda.FILE[1:-1] +
  yellow_tower.FILE[1:-1] +
  valley_of_mystery.FILE[1:-1] +
  turre.FILE[1:-1] + # psio
  varalors.FILE[1:-1] + # psio
  ranger_forest.FILE[1:-1] + # magi
  keep.FILE[1:-1] + # magi
  castle_greenlight.FILE[1:-1] + # magi
  obizuth.FILE[1:-1] + # fire
  neckbreaker_desert.FILE[1:-1] + # fire, banish
  malbeth.FILE[1:-1] + # banish
  azynya.FILE[1:-1] + # acid
  deep_forest_ranger_outpost.FILE[1:-1] +
  concordia.FILE[1:-1] +
  medo.FILE[1:-1] +
  ravenloft.FILE[1:-1] +
  angarock.FILE[1:-1] + # cold
  saurus.FILE[1:-1] + # psio
  dusk.FILE[1:-1] + # cold
  harbour.FILE[1:-1] +
  minas_tirith.FILE[1:-1] + # fire
  circus.FILE[1:-1] +
  dryads.FILE[1:-1] +
  brownie_fields.FILE[1:-1] +
  newbie_fields.FILE[1:-1] +
  hemlock.FILE[1:-1] +
  maester.FILE[1:-1] + # magi
  temple_of_burning_night.FILE[1:-1] +
  hillside.FILE[1:-1] + # fire
  darkwater.FILE[1:-1] +
  manor.FILE[1:-1] + # psio
  damorra_swamps.FILE[1:-1] +
  [
    {
      'name': 'Unknown',
    },
  ]
  )
