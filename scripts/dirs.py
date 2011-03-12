#!/usr/bin/env python
#
# This script basically follows another player and writes dirs.
#
# Written by Alexander C. Schrepfer (conglomo@zombiemud)
#

import os
import re
import sre_constants

from optparse import OptionParser

ABBREVIATION = {
  'north' : 'n',
  'south' : 's',
  'east' : 'e',
  'west' : 'w',
  'up' : 'u',
  'down' : 'd',
  'northwest' : 'nw',
  'northeast' : 'ne',
  'southeast' : 'se',
  'southwest' : 'sw',
}

def getDirectionAbbreviation(direction):
  """Get the appreviation for the given direction."

  Args:
    direction: String direction to abbreviate.

  Returns:
    The abbreviation for the given direction.
  """
  global ABBREVIATION
  if ABBREVIATION.has_key(direction):
    return ABBREVIATION[direction]
  return direction

def appendCommands(commands, command, count, maxCount=20):
  """Append command to commands with given count.

  Args:
    commands: List of commands to be modified.
    command: String command to append to the commands.
    count: The number of times command is added to commands.
    maxCount: The maximum number to append to the list before splitting.
  """
  while count > maxCount:
    commands.append('%d %s' % (maxCount, getDirectionAbbreviation(command)))
    count -= maxCount
  if count > 1:
    commands.append('%d %s' % (count, getDirectionAbbreviation(command)))
  elif count > 0:
    commands.append(getDirectionAbbreviation(command))

def parseLogFile(logFile, reMovement, reTarget, reStart=None, maxCount=20,
                 separator=';'):
  """Parse the log file and print dirs.

  Args:
    logFile: String path to the log file which is being parsed.
    reMovement: Compiled regular expression of the movement. At least 1 (group)
        required. That group will match the direction moved.
    reTarget: Compiled regular expression of the target. At least 1 (group)
        required. That group will match the target.
    reStart: Compiled regular expression of the start location.
    maxCount: Integer of the maximum number of directions to group together with
        a multiplier.
    separator: String to use to join the list of directions.
  """
  previousDirection = ''
  previousDirectionCount = 0
  currentCommands = []

  f = open(logFile, 'r')
  for line in f.xreadlines():

    match = reMovement.match(line)
    if match:
      if len(match.groups()):
        direction = match.group(len(match.groups())).strip()
      else:
        continue
      if direction == previousDirection:
        previousDirectionCount += 1
        while previousDirectionCount > maxCount:
          currentCommands.append('%d %s' % (
              maxCount, getDirectionAbbreviation(previousDirection)))
          previousDirectionCount -= maxCount
      else:
        appendCommands(currentCommands, previousDirection,
            previousDirectionCount, maxCount=maxCount)
        previousDirection = direction
        previousDirectionCount = 1

    match = reTarget.match(line)
    if match:
      if len(match.groups()):
        target = match.group(len(match.groups())).strip()
      else:
        target = 'Unknown'
      appendCommands(currentCommands, previousDirection, previousDirectionCount,
          maxCount=maxCount)
      if len(currentCommands):
        print(separator.join(currentCommands) + ' > ' + target)
      else:
        print('(same room)' + ' > ' + target)
      currentCommands = []
      previousDirection = ''
      previousDirectionCount = 0

    if reStart:
      match = reStart.match(line)
      if match:
        appendCommands(currentCommands, previousDirection,
            previousDirectionCount, maxCount=maxCount)
        if len(currentCommands):
          print(separator.join(currentCommands) + ' > START')
        currentCommands = []
        previousDirection = ''
        previousDirectionCount = 0

  f.close()

def main():
  parser = OptionParser(
      version='Path Tracker v1.1.%s' % '$LastChangedRevision: 1037 $'[22:-2])
  parser.add_option(
      '-m', '--movement',
      action='store',
      type='string',
      dest='movement',
      help=(
          'This is a regular expression that describes the format for leader '
          'movement messages. This expression must contain exactly one '
          'capturing group that will grab the direction in which the leader '
          'moves. For example \'^Conglomo leaves (.*)\\.$\' basically puts '
          'everything between \'leaves\' and the \'.\' in that group.'),
      metavar='EXPR')
  parser.add_option(
      '-t', '--target',
      action='store',
      type='string',
      dest='target',
      help=(
          'This is a regular expression that describes the format for when '
          'you\'ve set a new target (or are basically at your destination). This '
          'expression must contain exactly one capturing group that will grab '
          'the name of the target. For example \'^Conglomo pulls down her pants '
          'and moons (.*)\\.$\' is something that happens each time he attacks a '
          'new monster. You can use party says here as well.'),
      metavar='EXPR')
  parser.add_option(
      '-x', '--start',
      action='store',
      type='string',
      dest='start',
      help=(
          'This is a regular expression that describes a common location where '
          'all directions will be based. This is useful if you want to start '
          'fresh each time you hit Central square.  For example \'^Central '
          'square \' is the middle of ZombieCity and is somewhere that you\'d '
          'easily start your run macros from.'),
      metavar='EXPR')
  parser.add_option(
      '-f', '--logfile',
      action='store',
      type='string',
      dest='logfile',
      help=(
          'This is the file that contains the log file which you are going to '
          'parse. If you use TinyFugue this could be the file you created with '
          '\'/log\' or the file created using Zmud and \'#log\'.'),
      metavar='FILE')
  parser.add_option('-c',
      '--count',
      action='store',
      type='int',
      dest='count',
      help=(
          'This is the number of rooms you\'d like to limit the script from '
          'running per command.  In general muds will allow you to type \'5 e\' '
          'instead of typing \'e\' 5 times. A lot of times there\'s a limit of '
          'how many commands you can type at once. The default value here is '
          '20.'),
      metavar='MAX')
  parser.add_option('-s',
      '--separator',
      action='store',
      type='string',
      dest='separator',
      help=(
          'This is the separator used when you combine all of the commands '
          'together to make a run. The default is the Zmud style of \';\'.'),
      metavar='STRING')

  options, args = parser.parse_args()

  if not options.movement:
    parser.error('-m --movement is a required parameter')

  if not options.target:
    parser.error('-t --target is a required parameter')

  if not options.logfile:
    parser.error('-f --logfile is a required parameter')

  if not options.separator:
    options.separator = ';'

  if not options.count:
    options.count = 20

  if not os.path.exists(options.logfile):
    parser.error('-f --logfile could not be read: %s' % options.logfile)

  try:
    reMovement = re.compile(options.movement)
  except sre_constants.error:
    parser.error('-m --movement is a bad regular expression: %s' %
                 options.movement)

  try:
    reTarget = re.compile(options.target)
  except sre_constants.error:
    parser.error('-t --target is a bad regular expression: %s' % options.target)

  if options.start:
    try:
      reStart = re.compile(options.start)
    except sre_constants.error:
      parser.error('-x --start is a bad regular expression: %s' % options.start)
  else:
    reStart = None

  parseLogFile(options.logfile, reMovement, reTarget, reStart=reStart,
               maxCount=options.count, separator=options.separator)


if __name__ == '__main__':
  main()
