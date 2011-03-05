#!/usr/bin/env python
#
# This script basically just reverses a dir.
#
# Written by Alexander C. Schrepfer (conglomo@zombiemud)
#

import os
import re
import types

from optparse import OptionParser

# Globals
NORTH = 'n'
SOUTH = 's'
EAST = 'e'
WEST = 'w'
NORTHEAST = NORTH + EAST
NORTHWEST = NORTH + WEST
SOUTHEAST = SOUTH + EAST
SOUTHWEST = SOUTH + WEST
UP = 'u'
DOWN = 'd'

RE_COMMAND = re.compile('^([0-9]+) (.+)$')

REVERSE = (
    (NORTH, SOUTH),
    (EAST, WEST),
    (NORTHEAST, SOUTHWEST),
    (NORTHWEST, SOUTHEAST),
    (UP, DOWN))

def getReverseDirection(direction):
  """Returns the reverse of the supplied direction.

  Args:
    direction: String format of the direction.

  Returns:
    String format of the reverse direction.
  """
  for dir1, dir2 in REVERSE:
    if direction == dir1:
      return dir2
    if direction == dir2:
      return dir1
  return '(opposite of %s)' % direction

def getMultiplierAndCommand(command):
  """Returns the multiplier and command.

  Args:
    command: String containing a single command.

  Returns:
    Tuple with 2 elements; multiplier and command.
  """
  matcher = RE_COMMAND.match(command)

  if matcher:
    return (int(matcher.group(1)), matcher.group(2))

  return (1, command)

def getIdealCommand(multiplier, command):
  """Returns the ideal command given the multiplier and command.

  Args:
    multiplier: Integer which is the multiplier of command.
    command: String command which it to be multplied.

  Returns:
    String of the multiplier and command.
  """
  if multiplier > 1:
    return '%d %s' % (multiplier, command)
  else:
    return command

def reverse(commands):
  """Reverse the commands.

  Args:
    commands: String or Tuple containing a sequence of commands.

  Returns:
    Tuple of the reverse commands.
  """
  result = []

  commands = [x.strip() for x in commands]
  commands = [x for x in commands if x]

  for command in commands:
    (multiplier, command) = getMultiplierAndCommand(command)
    command = getReverseDirection(command)
    result.append(getIdealCommand(multiplier, command))

  result.reverse()
  return result

def reverseString(commands, separator=';'):
  """Reverse the commands using the given separator.

  Args:
    commands: String containing a sequence of commands.
    separator: Separator that separates the commands.

  Returns:
    String with the reverse commands.
  """
  return separator.join(reverse(commands.split(separator)))

def main():
  parser = OptionParser(version='Reverse It v1.1.' + '$LastChangedRevision: 1037 $'[22:-2])
  parser.add_option('-s', '--separator', action='store', type='string', dest='separator', help='This is the separator used when you combine all of the commands together to make a run. (default \';\')', metavar='STRING', default=';')
  parser.add_option('-p', '--path', action='store', type='string', dest='path', help='This is the path which is to be reversed. The commands should be separated by either your supplied separator or the deafult separator.', metavar='STRING')
  (options, args) = parser.parse_args()

  if not options.separator:
    parser.error('-s --separator is a required parameter')
  if not options.path:
    parser.error('-p --path is a required parameter')

  options.separator = options.separator

  print reverseString(options.path, options.separator)


if __name__ == '__main__':
  main()
