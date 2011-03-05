#!/usr/bin/python
#
# This script generates deltas between two exp lists.
#
# Written by Alexander C. Schrepfer (conglomo@zombiemud)
#

import os
import re
from optparse import OptionParser

PATTERN_LINES = (
    re.compile(r'^ *(?P<rank>\d+)\. +(?P<name>[A-Z][a-z]+) +(?P<level>\d+) *(?P<worth>(?: \d+[GMk])+)$'),
    re.compile(r'^\| *(?P<rank>\d+)\| (?P<name>[A-Z][a-z]+) +\| (?P<level>\d+) +\| (?P<worth>(?:\d+[GMk] )+) +\|$'),
    )

PATTERN_EXP = re.compile(r'^(?P<digit>\d+)(?P<multiplier>[GMk])$')

UNITS = (('G', 1000000000),
         ('M', 1000000),
         ('k', 1000))

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
  parts = [ x for x in expString.split(' ') if x ]
  for part in parts:
    matcher = PATTERN_EXP.match(part)
    if matcher:
      for unit, mult in UNITS:
        if matcher.group(2) == unit:
          result += mult * int(matcher.group(1))
  return result

def updatePlayer(players, matcher):
    if not matcher:
      return False
    rank = int(matcher.group('rank'))
    name = matcher.group('name')
    level = int(matcher.group('level'))
    worth = fromExpString(matcher.group('worth'))
    players[name] = {
        'name': name,
        'rank': rank,
        'level': level,
        'worth': worth,
        }
    return True

def loadFile(filename):
  """Loads file into a dictionary of players.

  Args:
    filename: String path to file to load.

  Returns:
    Dictionary in the form:
    {
      'name': String,
      'rank': Integer,
      'level': Integer,
      'worth': Integer,
    }
  """
  players = {}
  fileHandle = open(filename, 'r')
  for line in fileHandle:
    line = line.strip()
    for pattern_line in PATTERN_LINES:
      if updatePlayer(players, pattern_line.match(line)):
        continue
  return players

SORT_BY = {
  'rank': -1,
  'name': 1,
  'level': -1,
  'worth': -1,
  'percent': -1,
}

def printPlayerDiffs(players, sortBy, limit, reverse):
  """Prints the player diffs from the given data.

  Args:
    players: Dictionary of players.
    sortBy: String key from SORT_BY, by which to sort this.
    limit: Integer number of results to show.
    reverse: Boolean; print in reverse order.
  """
  for key, order in SORT_BY.iteritems():
    if sortBy == key:
      if order > 0:
        players.sort(lambda x, y: cmp(x[key], y[key]))
      elif order < 0:
        players.sort(lambda x, y: cmp(y[key], x[key]))
  if reverse:
    players.reverse()
  print '%1s %-12s %4s %4s %15s %9s' % (
      '?', 'Name', 'Rank', 'Lvl', 'Worth', 'Percent')
  print '--------------------------------------------------'
  for player in players[0:limit]:
    if 'added' in player and player['added']:
      change = '+'
    elif 'removed' in player and player['removed']:
      change = '-'
    else:
      change = ''
    print '%1s %-12s %4d %4d %15s %8.2f%%' % (
        change,
        player['name'],
        player['rank'],
        player['level'],
        toExpString(player['worth']),
        player['percent'],
    )

def main():
  parser = OptionParser(version='ExpDiff v1.0.' + '$LastChangedRevision: 1317 $'[22:-2])

  parser.add_option('-o', '--old', action='store', type='string', dest='old',
      help='The old file to compare.', metavar='FILE')
  parser.add_option('-n', '--new', action='store', type='string', dest='new',
      help='The new file to compare.', metavar='FILE')
  parser.add_option('-s', '--sort', action='store', type='string', dest='sort',
      help='Sort by: ' + ', '.join(sorted(SORT_BY.keys())), metavar='SORT', default='worth')
  parser.add_option('-l', '--limit', action='store', type='int', dest='limit',
      help='Limit number of results to.', metavar='NUM', default=50)
  parser.add_option('-r', '--reverse', action='store_true', dest='reverse',
      help='Sort results in reverse order.', default=False)
  (options, args) = parser.parse_args()

  if not options.old or not os.path.exists(options.old):
    parser.error('-o --old doesn\'t exist')

  if not options.new or not os.path.exists(options.new):
    parser.error('-n --new doesn\'t exist')

  oldPlaque = loadFile(options.old)
  newPlaque = loadFile(options.new)

  diff = {}
  removed = {}
  oldHighestRank = None
  oldLowestWorth = None
  newHighestRank = None
  newLowestWorth = None

  for name, old in oldPlaque.iteritems():
    if name in newPlaque:
      new = newPlaque[name]
      rank = old['rank'] - new['rank']
      level = new['level'] - old['level']
      worth = new['worth'] - old['worth']
      percent = 100.0 * worth / old['worth']
      diff[name] = {
          'name': name,
          'rank': rank,
          'level': level,
          'worth': worth,
          'percent': percent,
      }
    else:
      removed[name] = old
    if not oldHighestRank or old['rank'] > oldHighestRank:
      oldHighestRank = old['rank']
    if not oldLowestWorth or old['worth'] < oldLowestWorth:
      oldLowestWorth = old['worth']

  for name, new in newPlaque.iteritems():
    if not name in diff:
      rank = max(0, (oldHighestRank + 1) - new['rank'])
      level = 0
      worth = max(0, new['worth'] - oldLowestWorth)
      percent = 100.0 * worth / oldLowestWorth
      diff[name] = {
          'name': name,
          'rank': rank,
          'level': level,
          'worth': worth,
          'percent': percent,
          'added': True,
      }
    if not newHighestRank or new['rank'] > newHighestRank:
      newHighestRank = new['rank']
    if not newLowestWorth or new['worth'] < newLowestWorth:
      newLowestWorth = new['worth']

  for name, old in removed.iteritems():
    rank = old['rank'] - (newHighestRank + 1)
    level = 0
    if old['worth'] < newLowestWorth:
      worth = 0
    else:
      worth = newLowestWorth - old['worth']
    percent = 100.0 * worth / old['worth']
    diff[name] = {
        'name': name,
        'rank': rank,
        'level': level,
        'worth': worth,
        'percent': percent,
        'removed': True,
    }


  if not options.sort in SORT_BY:
    parser.error('-s --sort isn\'t valid')

  printPlayerDiffs(diff.values(),
                   sortBy = options.sort,
                   limit = options.limit,
                   reverse = options.reverse)

if __name__ == '__main__':
  main()
