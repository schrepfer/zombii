#!/usr/bin/env python2.6
#
# This script generates deltas between two exp lists.
#
# Written by Alexander C. Schrepfer (conglomo@zombiemud)
#

import logging
import optparse
import os
import re
import sys

PATTERN_LINES = (
    re.compile(r'^ *(?P<rank>\d+)\. +(?P<name>[A-Z][a-z]+) +(?P<level>\d+) *(?P<worth>(?: \d+[GMk])+)$'),
    re.compile(r'^\| *(?P<rank>\d+)\| (?P<name>[A-Z][a-z]+) +\| (?P<level>\d+) +\| (?P<worth>(?:\d+[GMk] )+) +\|$'),
    )

PATTERN_EXP = re.compile(r'^(?P<digit>\d+)(?P<multiplier>[GMk])$')

UNITS = (
    ('G', 1000000000),
    ('M', 1000000),
    ('k', 1000),
    )

class Error(Exception):
  """Standard errors."""


def toExpString(exp):
  """Converts an int to an exp string.

  Args:
    exp: Integer value of the exp.

  Returns:
    String in the form of 0G 000M 000k.
  """
  if exp < 0:
    sign = '-'
  else:
    sign = ''
  exp = abs(exp)
  result = []
  for unit, mult in UNITS:
    if exp > mult or result:
      if result:
        result.append('%03d' % (exp / mult) + unit)
      else:
        result.append('%d' % (exp / mult) + unit)
      exp = exp % mult
  if not result:
    return sign + '0'
  return sign + ' '.join(result)


def fromExpString(expString):
  """Converts an exp string to an int.

  Args:
    expString: String representation of an exp string.

  Returns:
    Integer value of the exp string.
  """
  result = 0
  parts = [x for x in expString.split(' ') if x]
  for part in parts:
    matcher = PATTERN_EXP.match(part)
    if matcher:
      for unit, mult in UNITS:
        if matcher.group(2) == unit:
          result += mult * int(matcher.group(1))
  return result


class Player(object):
  """Player instance which contains a name, rank, level and worth."""

  def __init__(self, name, rank, level, worth):
    self._name = name
    self._rank = rank
    self._level = level
    self._worth = worth

  def __getitem__(self, item):
    return getattr(self, item)

  @property
  def name(self):
    return self._name

  @property
  def rank(self):
    return self._rank

  @property
  def level(self):
    return self._level

  @property
  def worth(self):
    return self._worth

  def __cmp__(self, other):
    return cmp(other._rank, self._rank)  # swapped

  def __str__(self):
    return '%d. %s (%d) - %s' % (
        self.rank,
        self.name,
        self.level,
        self.worth)


class LowestPlayer(Player):
  """Player instance which has no name/level but can have worth/rank changed."""

  def __init__(self):
    self._name = None
    self._rank = 0
    self._level = 0
    self._worth = 0

  def setWorth(self, worth):
    self._worth = worth

  def setRank(self, rank):
    self._rank = rank


class Plaque(dict):
  """Plaque instance which contains Players."""

  def __init__(self, players):
    self.update(players)

  @classmethod
  def fromFile(cls, filename):
    players = {}
    try:
      with open(filename, 'r') as fileHandle:
        for line in fileHandle:
          line = line.strip()
          for pattern_line in PATTERN_LINES:
            matcher = pattern_line.match(line)
            if not matcher:
              continue
            rank = int(matcher.group('rank'))
            name = matcher.group('name')
            level = int(matcher.group('level'))
            worth = fromExpString(matcher.group('worth'))
            players[name] = Player(name, rank, level, worth)
      return cls(players)
    except IOError, e:
      raise Error(e)


class Delta(object):
  """Delta between two Player instances."""

  def __init__(self, old, new):
    self.old = old
    self.new = new

  def __getitem__(self, item):
    if item == 'worth':
      return toExpString(self.worth)
    return getattr(self, item)

  @property
  def name(self):
    return self.old.name or self.new.name

  @property
  def rank(self):
    if self.added and self.new.rank > self.old.rank:
      return 0
    rank = self.old.rank - self.new.rank
    if self.added:
      return rank + 1
    if self.removed:
      return rank - 1
    return rank

  @property
  def level(self):
    if self.added or self.removed:
      return 0
    return self.new.level - self.old.level

  @property
  def worth(self):
    worth = self.new.worth - self.old.worth
    if self.added:
      return max(0, worth)
    if self.removed:
      return min(0, worth)
    return worth

  @property
  def percent(self):
    return 100.0 * self.worth / self.old.worth

  @property
  def added(self):
    return isinstance(self.old, LowestPlayer)

  @property
  def removed(self):
    return isinstance(self.new, LowestPlayer)

  @property
  def status(self):
    return '+' if self.added else '-' if self.removed else ''


class DeltaPlaque(dict):
  """DeltaPlaque instance which contains Deltas."""

  def __init__(self, deltas):
    self.update(deltas)

  @classmethod
  def fromPlaques(cls, oldPlaque, newPlaque):
    deltas = {}
    oldLowest = LowestPlayer()
    newLowest = LowestPlayer()
    for name, old in oldPlaque.iteritems():
      if name in newPlaque:
        new = newPlaque[name]
        deltas[name] = Delta(old, new)
      else:
        deltas[name] = Delta(old, newLowest)
      if not oldLowest.rank or old < oldLowest:
        oldLowest.setWorth(old.worth)
        oldLowest.setRank(old.rank)
    for name, new in newPlaque.iteritems():
      if name not in oldPlaque:
        deltas[name] = Delta(oldLowest, new)
      if not newLowest.rank or new < newLowest:
        newLowest.setWorth(new.worth)
        newLowest.setRank(new.rank)
    return cls(deltas)

  def top(self, sorter, limit, reverse):
    return sorted(self.values(), key=sorter, reverse=reverse)[0:limit]


SORTERS = {
  'percent': (lambda x: x.percent, True),
  'worth': (lambda x: x.worth, True),
  #'level': (lambda x: x.level, True),
  'rank': (lambda x: x.rank, True),
  'name': (lambda x: x.name, False),
  }


def defineFlags():
  parser = optparse.OptionParser(version='%prog v0.0', description=__doc__)
  # See: http://docs.python.org/library/optparse.html
  parser.add_option(
      '-v', '--verbosity',
      action='store',
      default=20,
      dest='verbosity',
      metavar='LEVEL',
      type='int',
      help='the logging verbosity')
  parser.add_option(
      '-o', '--old',
      action='store',
      dest='old',
      metavar='FILE',
      type='string',
      help='The old file to compare.')
  parser.add_option(
      '-n', '--new',
      action='store',
      dest='new',
      metavar='FILE',
      type='string',
      help='The new file to compare.')
  parser.add_option(
      '-s', '--sort',
      action='store',
      default='worth',
      dest='sort',
      choices=SORTERS.keys(),
      metavar='SORT',
      type='choice',
      help='Column to sort results by.')
  parser.add_option(
      '-l', '--limit',
      action='store',
      default=50,
      dest='limit',
      metavar='NUM',
      type='int',
      help='Limit number of results to.')
  parser.add_option(
      '-r', '--reverse',
      action='store_true',
      default=False,
      dest='reverse',
      help='Sort results in reverse order.')
  return parser.parse_args()


def main(options, args):
  if not options.old:
    logging.error('-o --old is a required argument')
    return os.EX_DATAERR

  if not options.new:
    logging.error('-n --new is a required argument')
    return os.EX_DATAERR

  try:
    old = Plaque.fromFile(options.old)
    new = Plaque.fromFile(options.new)
  except Error, e:
    logging.error('%s', e)
    return os.EX_DATAERR

  delta = DeltaPlaque.fromPlaques(old, new)
  sorter, reversed = SORTERS[options.sort]

  print '%1s %-12s %5s %15s %9s' % ('?', 'Name', 'Rank', 'Worth', 'Percent')
  print '----------------------------------------------'
  for player in delta.top(sorter, options.limit, reversed ^ options.reverse):
    print '%(status)1s %(name)-12s %(rank)+5d %(worth)15s %(percent)8.2f%%' % player

  return os.EX_OK


if __name__ == '__main__':
  options, args = defineFlags()
  logging.basicConfig(
      level=options.verbosity,
      datefmt='%Y/%m/%d %H:%M:%S',
      format='[%(asctime)s] %(levelname)s: %(message)s')
  sys.exit(main(options, args))
