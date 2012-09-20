#!/usr/bin/env python
#
# Copyright 2009. All Rights Reserved.

"""Runs."""

__author__ = 'schrepfer'

#
# FILE = [
#   {
#     'alignment': STRING,
#     'announce': STRING,
#     'commands': STRING,
#     'eval': STRING,
#     'flags': STRING,
#     'in': STRING,
#     'items': STRING,
#     'name': STRING,
#     'out': STRING,
#     'path': STRING,
#     'skip': INTEGER,
#     'target': STRING,
#     'warnings': STRING,
#   },
# ]
#

import os
import re
import sys

import tf

from trigs import util


class Movement(object):

  def __init__(self, **kwargs):
    self._previous = None
    self._next = None
    self._index = kwargs.get('index', 0)
    self._alignment = kwargs.get('alignment', '')
    self._announce = kwargs.get('announce', '')
    self._commands = kwargs.get('commands', '').split(';')
    self._eval = kwargs.get('eval', '')
    self._flags = kwargs.get('flags', '')
    self._in_commands = kwargs.get('in', '').split(';')
    self._items = kwargs.get('items', '')
    self._name = kwargs.get('name', '')
    self._out_commands = kwargs.get('out', '').split(';')
    self._path = kwargs.get('path', '').split(';')
    self._skip = max(0, kwargs.get('skip', 0))
    self._target = kwargs.get('target', '')
    self._warnings = kwargs.get('warnings', '')

  def __str__(self):
    return '%d: %s > %s' % (self._index, self._announce, ', '.join(self._path))

  @property
  def previous(self):
    return self._previous

  def setPrevious(self, previous):
    if self._previous is not None:
      self._previous._next = None
    if previous is not None:
      previous._next = self
    self._previous = previous

  @property
  def next(self):
    return self._next

  def setNext(self, next):
    if self._next is not None:
      self._next._previous = None
    if next is not None:
      next._previous = self
    self._next = next

  @property
  def index(self):
    return self._index

  @property
  def alignment(self):
    return self._alignment

  @property
  def announce(self):
    return self._announce

  @property
  def commands(self):
    return self._commands

  @property
  def eval(self):
    return self._eval

  @property
  def flags(self):
    return self._flags

  @property
  def in_commands(self):
    return self._in_commands

  @property
  def items(self):
    return self._items

  @property
  def name(self):
    return self._name

  @property
  def out_commands(self):
    return self._out_commands

  @property
  def path(self):
    return self._path

  @property
  def skip(self):
    return self._skip

  @property
  def next_skip(self):
    if self._next is not None:
      return max(0, self._next._skip)
    return 0

  @property
  def target(self):
    return self._target

  @property
  def warnings(self):
    return self._warnings

  def execute(self, announce_only=False):
    """
    """
    if announce_only:
      template = (
          '/run_path -a%(announce)s -A%(alignment)s -F%(flags)s -r%(index)d -s%(skip)d '
          '-t%(target)s -w%(out)s -W%(warnings)s -x%(in)s')
    else:
      template = (
          '/run_path -a%(announce)s -A%(alignment)s -c%(commands)s -d%(path)s -F%(flags)s '
          '-i%(items)s -r%(index)d -s%(skip)d -t%(target)s -w%(out)s -W%(warnings)s -x%(in)s '
          '-e%(eval)s')

    tf.eval(util.escape(template % {
        'alignment': repr(self._alignment),
        'announce': repr(self._announce),
        'commands': repr(';'.join(self._commands)),
        'eval': repr(self._eval),
        'flags': repr(self._flags),
        'in': repr(';'.join(self._in_commands)),
        'index': self._index,
        'items': repr(self._items),
        'out': repr(';'.join(self._out_commands)),
        'path': repr(';'.join(self._path)),
        'skip': self.next_skip,
        'target': repr(self._target),
        'warnings': repr(self._warnings),
        }))


class Run(object):

  def __init__(self, first=None):
    """
    """
    self._first = first
    self._current = first
    self._name = None
    self._path = None

  def loadMovements(self, first):
    self._first = first
    self._current = first

  def loadMovementsFromDictList(self, movement_dicts):
    previous = None
    first = None
    for movement_dict in movement_dicts:
      movement = Movement(**movement_dict)
      if first is None:
        first = movement
      movement.setPrevious(previous)
      previous = movement

    self.loadMovements(first)

  def getPrefix(self, line):
    """Get the prefix for the current line."""
    for char in (':', ','):
      if char in line:
        return line.split(char, 1)[0]
    return line

  def fixMovements(self, movements):
    """Fix movements by updating the name and announce attributes."""
    if not movements:
      return
    previous = None
    for index, current in enumerate(movements):
      current['index'] = index
      if previous is not None:
        if 'name' in current and 'announce' in previous:
          if current['name'] == '__announce__':
            if 'announce' in current:
              current['name'] = self.getPrefix(current['announce'])
            else:
              current['name'] = 'Unknown'
          previous['announce'] = '%s, next %s' % (previous['announce'], current['name'])
      previous = current

  @staticmethod
  def loadMovementsListFromConfigFile(path, basename):
    sys_path = sys.path
    try:
      sys.path = [path]
      try:
        module = reload(__import__(basename))
      except ImportError, e:
        tf.err('ImportError: %s' % e)
        return False
      except NameError, e:
        tf.err('NameError: %s' % e)
        return False
      except SyntaxError, e:
        tf.err('Syntax error on line %d: %s' % (e.lineno, e.filename))
        return False
    finally:
      sys.path = sys_path

    return getattr(module, 'FILE', [])

  def loadMovementsFromConfigFile(self, config_file):
    """Load movements from config file.

    Args:
      config_file: String

    Returns:
      Boolean
    """
    if (not os.path.isfile(config_file + '.py') and
        not os.path.isfile(config_file + '.pyc')):
      tf.err('Could not find file: %s [.py or .pyc]' % config_file)
      return False

    path, basename = os.path.split(config_file)
    movements = self.loadMovementsListFromConfigFile(path, basename)

    if not isinstance(movements, list):
      tf.err('The FILE attribute is not a list.')
      return False

    self.fixMovements(movements)
    self.loadMovementsFromDictList(movements)

    tf.eval('/say -d"party" -b -c"green" -- Loaded run from config: %s' % basename)

    self._name = basename
    self._path = config_file
    return True

  def name(self):
    return self._name

  def path(self):
    return self._path

  def unload(self):
    self._first = None
    self._current = None
    self._name = None
    self._path = None
    tf.eval('/say -d"party" -b -c"yellow" -- Unloaded run')

  def reset(self):
    self._current = self._first

  def first(self):
    return self._first

  def current(self):
    return self._current

  def display(self):
    tf.eval('/say -d"status" -- %s' % self._current)

  def forward(self):
    if self._current is not None:
      if self._current.next is None:
        self._current = self._first
      else:
        self._current = self._current.next
    return self._current

  def rewind(self):
    if self._current is not None:
      if self._current.previous is not None:
        self._current = self._current.previous
    return self._current

  def execute(self, announce_only=False):
    if self._current is None:
      tf.err('There is no movement to execute.')
      return
    self._current.execute(announce_only=announce_only)

  def skip(self):
    if self._current is not None:
      skip = self._current.skip
      if skip:
        tf.eval(
            '/say -d"party" -x -b -c"yellow" -- SKIPPING %d ROOM%s' % (
                skip, 'S' if skip != 1 else ''))
        for unused_i in xrange(skip - 1):
          self.forward()
        self.execute(announce_only=True)
        self.forward()
    return self._current


if __name__ != '__main__':
  inst = Run()
