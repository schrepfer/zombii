# vim: syn=python

import abjurers_grove
reload(abjurers_grove)

import isthmas
reload(isthmas)

import mephala
reload(mephala)

import pagoda
reload(pagoda)

import shaolin
reload(shaolin)


SKIPS = (
  abjurers_grove.FILE[1]['skip'] +
  isthmas.FILE[1]['skip'] +
  pagoda.FILE[1]['skip'] +
  shaolin.FILE[1]['skip'] +
  mephala.FILE[1]['skip'] + 2)

FILE = (
  [
    {
      'name': 'Mellarnia',
      'announce': '1ne',
    },
  ] +
  abjurers_grove.FILE[1:-1] +
  isthmas.FILE[1:-1] +
  pagoda.FILE[1:-1] +
  shaolin.FILE[1:-1] +  # fire
  mephala.FILE[1:-1] +  # fire
  [
    {
      'name': 'Unknown',
    },
  ]
  )
