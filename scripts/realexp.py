#!/usr/bin/env python
#
# Copyright 2010. All Rights Reserved.

"""One-line description of the realexp module.

A detailed description of realexp.
"""

__author__ = 'schrepfer'

import logging
import optparse
import os
import re
import sys

import expdiff

RACE_PATTERN_LINE = \
    re.compile(r'^\| *(?P<rank>\d+)\| (?P<name>[A-Z][a-z]+) +\| (?P<level>\d+) +\|(?P<worth>(?: \d+[GMk])+) +\|$')
PATTERN_LINE = expdiff.PATTERN_LINE

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
      '-e', '--exp-plaque',
      action='store',
      dest='exp_plaque',
      metavar='FILE',
      type='string',
      help='path to the experience plaque')
  parser.add_option(
      '-r', '--race-plaque',
      action='store',
      dest='race_plaque',
      metavar='FILE',
      type='string',
      help='path to the race plaque')
  return parser.parse_args()


def loadRacePlaque(filename):
  """
  """
  players = {}
  fileHandle = open(filename, 'r')
  for line in fileHandle:
    matcher = RACE_PATTERN_LINE.match(line.strip())
    if matcher:
      rank = int(matcher.group('rank'))
      name = matcher.group('name')
      level = int(matcher.group('level'))
      worth = expdiff.fromExpString(matcher.group('worth'))
      players[name] = {
          'name': name,
          'rank': rank,
          'level': level,
          'worth': worth,
      }
  return players


def getUpdatedPlaque(original, additions):
  """
  """
  players = original.copy()
  for name, info in additions.iteritems():
    if name not in players:
      players[name] = info.copy()
    else:
      players[name]['worth'] += info['worth']
  return players


def printPlaque(plaque):
  """
  """
  sorter = lambda x: x[1]['worth']
  rank = 0
  try:
    print '%4s  %-12s %16s' % ('Rank', 'Name', 'Worth')
    print '-----------------------------------'
    for name, info in sorted(plaque.iteritems(), key=sorter, reverse=True):
      rank += 1
      print '%4d. %-12s %16s' % (rank, name, expdiff.toExpString(info['worth']))
  except IOError:
    pass


def main(options, args):
  exp_plaque = expdiff.loadFile(options.exp_plaque)
  race_plaque = loadRacePlaque(options.race_plaque)
  full_plaque = getUpdatedPlaque(exp_plaque, race_plaque)
  printPlaque(full_plaque)
  return os.EX_OK


if __name__ == '__main__':
  options, args = defineFlags()
  logging.basicConfig(
      level=options.verbosity,
      datefmt='%Y/%m/%d %H:%M:%S',
      format='[%(asctime)s] %(levelname)s: %(message)s')
  sys.exit(main(options, args))

