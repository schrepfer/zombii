#!/usr/bin/env python
#
# ...
#
# Written by Alexander C. Schrepfer (conglomo@zombiemud)
#

# 'Area Name': {
#   'dirs': String,
#   'reverse_dirs': String?,
#   'stops': [
#     { 'name': String,
#       'short': String,
#       'target': String,
#       'align': Integer,
#       'size': Integer,
#       'spells': [
#         String,
#       ],
#       'skills': [
#         String,
#       ],
#       'aggressve': Boolean,
#       'dirs': String,
#       'reverse_dirs': String?,
#       'wimpy': String?,
#       'reverse_wimpy': String?,
#       'need': [
#         String,
#       ],
#     },
#   ],
# }

import reverse

EVIL = -1
NEUTRAL = 0
GOOD = 1

class Commands:

  def __init__(self, commands, separator=';'):
    if type(commands) == types.StringType:
      self.commands = commands.split(separator)
    elif type(commands) == types.TupleType:
      self.commands = commands[:]
    else:
      raise TypeError('this requires a String or Tuple')

  def asTuple(self):
    return commands[:]

  def asString(separator=';'):
    return separator.join(commands)

class Destination:

  def __init__(self, name, dirs, **kwargs):
    self.name = name
    self.dirs = Commands(dirs)
    if 'reverseDirs' in kwargs:
      self.reverseDirs = Commands(kwargs['reverseDirs'])
    else:
      self.reverseDirs = reverse.reverse(self.dirs.asTuple())

  def addDestination(self, destination):
    self.destinations.append(destination)

  def getDestination(self, number):
    return self.destinations[number]

  def setMonster(self, monster):
    self.monster = monster

  def getMonster(self):
    return self.monster

  def getDirs(self):
    return self.dirs

  def getReverseDirs(self):
    return self.reverseDirs

class Monster:

  def __init__(self, name):
    self.name = None
    self.aggressive = False
    self.size = 0
    self.specials = {}

  def setName(self, name):
    self.name = name

  def getName(self):
    return self.name

  def setAggressive(self, aggressive):
    this.aggressive = aggressive

  def isAggressive(self):
    return this.aggressive

  def setSize(self, size):
    self.size = size

  def getSize(self):
    return self.size

  def addSpecial(self, type, special, target):
    if not type in self.specials:
      self.specials[type] = []
    self.specials[type].append((special, target))

  def getSpecials(self, type=None):
    if type:
      return self.specials[type]
    return self.specials

  def setAlign(self, align):
    self.align = align

  def getAlign(self):
    return self.align


DATA = {
  'Cleric Guild': {
    'dirs': '5 w;n',
    'stops': [
      { 
        'name': 'Paladin commander',
        'short': 'Paladin commander',
        'target': 'paladin',
        'align': GOOD,
        'size': 1700,
        'spells': [
          'dispel evil',
        ],
        'aggressive': False,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n;e;se;2 e;se;2 sw;w;n;w;s',
        'reverse_dirs': 'N;e;s;e;2 ne;nw;2 w;nw;w;2 s;sw;2 s;w;5 u;s;e;4 n;u;sw;3 s',
        'wimpy': 'N',
      },
      {
        'name': 'Fiend',
        'short': 'A possessive fiend, searching for a victim to conquer',
        'target': 'fiend',
        'align': EVIL,
        'size': 1600,
        'spells': [
          'migraine',
          'psionic blast',
        ],
        'aggressive': True,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n;e;se;2 e;se;2 sw;w;sw',
        'wimpy': 'ne',
      },
      {
        'name': 'Fiend',
        'short': 'A devious looking fiend',
        'target': 'fiend',
        'align': EVIL,
        'size': 1600,
        'spells': [
          'psychic crush',
          'terror',
        ],
        'aggressive': False,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n;e;se;2 e;se;sw;se;s;nw',
        'wimpy': 'se',
      },
      {
        'name': 'Fiend',
        'short': 'A muscular looking fiend',
        'target': 'fiend',
        'align': EVIL,
        'size': 1600,
        'spells': [
          'poison',
        ],
        'aggressive': True,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n;e;se;2 e;n',
        'wimpy': 's',
      },
      {
        'name': 'Fiend',
        'short': 'An aggressive pit fiend mentalist',
        'target': 'fiend',
        'align': EVIL,
        'size': 1600,
        'spells': [
          'terror',
          'headache',
          'mindfist',
          'feeblemind',
          'choke',
          'brainstorm',
        ],
        'aggressive': True,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n;e;2 se',
        'wimpy': 'nw',
      },
      {
        'name': 'Fiend',
        'short': 'An aggressive pit fiend fencer',
        'target': 'fiend',
        'align': EVIL,
        'size': 1600,
        'skills': [
          'thrust',
        ],
        'aggressive': True,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n;e;2 se;e',
        'wimpy': 'w;nw',
      },
      {
        'name': 'Fiend',
        'short': 'An enormous hairy fiend, sewn-up from rotten flesh',
        'target': 'fiend',
        'align': EVIL,
        'size': 2000,
        'skills': [
          'migrane',
          'psychic crush',
        ],
        'aggressive': True,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n;e;se;sw;s',
        'wimpy': 'n',
      },
      {
        'name': 'Fiend',
        'short': 'An enormous hairy fiend, sewn-up from rotten flesh',
        'target': 'fiend',
        'align': EVIL,
        'size': 2000,
        'spells': [
          'migrane',
          'psychic crush',
        ],
        'aggressive': True,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n;e;se;sw;s',
        'wimpy': 'n',
      },
      {
        'name': 'Fiend',
        'short': 'A weak looking fiend',
        'target': 'fiend',
        'align': EVIL,
        'size': 1600,
        'spells': [
          'choke',
          'brainstorm',
        ],
        'aggressive': True,
        'dirs': '3 n;ne;d;4 s;w;n;5 d;e;2 n;ne;2 n',
        'wimpy': '2 s;sw;2 s;w;u',
      },
    ],
  },
}

def mungePaths(forwardPath, reversePath):
  forwardPath = forwardPath.split(';')
  middlePath = []
  reversePath = reversePath.split(';')
  reversePath.reverse()

  while len(forwardPath) and len(reversePath):
    (forwardMultiplier, forwardDirection) = reverse.getMultiplierAndCommand(forwardPath.pop())
    (reverseMultiplier, reverseDirection) = reverse.getMultiplierAndCommand(reversePath.pop())
    if reverseDirection == reverse.getReverseDirection(forwardDirection):
      multiplier = forwardMultiplier - reverseMultiplier
      if multiplier > 0:
        direction = forwardDirection
      elif multiplier < 0:
        direction = reverseDirection
      else:
        continue
      multiplier = abs(multiplier)
      middlePath = [ reverse.getIdealCommand(multiplier, direction), ]
    else:
      middlePath = [ reverse.getIdealCommand(forwardMultiplier, forwardDirection), 
                     reverse.getIdealCommand(reverseMultiplier, reverseDirection), ]
    break

  reversePath.reverse()
  return ';'.join([ x for x in forwardPath + middlePath + reversePath if x ])

def getJoinedNames(names):
  result = []
  count = 0
  previousName = None
  for name in names:
    if previousName:
      if name == previousName:
        count += 1
        continue
      else:
        if count == 1:
          result.append(previousName)
        else:
          result.append('%dx %s' % (count, previousName))
    previousName = name
    count = 1
  if previousName:
    if count == 1:
      result.append(previousName)
    else:
      result.append('%dx %s' % (count, previousName))
  return ', '.join(result)

def getRoomToRoom(reverseDirs, monster):
  dirs = mungePaths(reverseDirs, monster['dirs'])
  attributes = []
  if monster['aggressive']:
    attributes.append('aggro')
  if monster['align'] > 0:
    attributes.append('good')
  if monster['align'] < 0:
    attributes.append('evil')
  size = monster['size']
  if size > 1000:
    size = '%.1fm' % (float(size) / 1000)
  else:
    size = '%dk' % size
  attributes = '(' + ', '.join(attributes) + ')'
  return (dirs, monster['target'], monster['name'], attributes, size,)

def printArea(area, monsters):
  dirs = ''
  reverseDirs = ''
  monsterPreview = []
  paths = []
  for monster in monsters:
    monster_data = DATA[area]['monsters'][monster]
    dirs = mungePaths(reverseDirs, monster_data['dirs'])
    if 'reverse_dirs' in monster_data:
      reverseDirs = monster_data['reverse_dirs']
    else:
      reverseDirs = reverse.reverse(monster_data['dirs'], ';')
    attributes = []
    if monster_data['aggressive']:
      attributes.append('aggro')
    if monster_data['align'] > 0:
      attributes.append('good')
    if monster_data['align'] < 0:
      attributes.append('evil')
    size = monster_data['size']
    if size > 1000:
      size = '%.1fm' % (float(size) / 1000)
    else:
      size = '%dk' % size
    attributes = '(' + ', '.join(attributes) + ')'
    paths.append((dirs, monster_data['target'], monster_data['name'] + ' ' + attributes + ' ' + size, '', monster_data['wimpy']))
    monsterPreview.append(monster_data['name'])
  print '--'.join((DATA[area]['dirs'], '', area + ': ' + getJoinedNames(monsterPreview), '', '', '', '', str(len(paths) + 1)))
  for path in paths:
    print '--'.join(path)
  print '--'.join((reverseDirs, '', area + ', next CS'))
  if 'reverse_dirs' in DATA[area]:
    reverseDirs = DATA[area]['reverse_dirs']
  else:
    reverseDirs = reverse.reverse(DATA[area]['dirs'], ';')
  print '--'.join((reverseDirs, '', 'CS'))

RUN = (
  ('Cleric Guild', (8, 7, 6, 4, 5, 3, 2, 1), ),
  ('Cleric Guild', (0, 2, 3, 5, 6, 7, 8, 0), ),
  ('Cleric Guild', (1, 2, 3, 4, 5, 6, 7, 8), ),
  ('Cleric Guild', (0, ), ),
)
for area, monsters in RUN:
  printArea(area, monsters)
