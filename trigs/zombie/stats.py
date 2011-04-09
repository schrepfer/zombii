#!/usr/bin/env python
#
# Copyright 2009. All Rights Reserved.

"""Stats."""

__author__ = 'schrepfer'

import pickle
import os
import tf

from trigs import util


class Stat(object):

  def __init__(self, key, name, rank=0, special=False, hide=False):
    self._key = key
    self._name = name
    self._session = 0
    self._rank = rank
    self._special = special
    self._hide = hide
    self._total = 0

  def __cmp__(self, other):
    return cmp(self._rank, other._rank) or cmp(self._name, other._name)

  @property
  def key(self):
    return self._key

  @property
  def name(self):
    return self._name

  @property
  def session(self):
    return self._session

  @property
  def total(self):
    return self._total

  @property
  def special(self):
    return self._special

  @property
  def hide(self):
    return self._hide

  def update(self, amount):
    self._session += amount
    self._total += amount

  def reset(self):
    self._session = 0

  def set(self, session, total):
    self._session = session
    self._total = total


class StatGroup(object):

  def __init__(self, key, name):
    self._stats = {}
    self._key = key
    self._name = name
    self._totals = {}

  def __iter__(self):
    return iter(sorted(self._stats.values()))

  @property
  def key(self):
    return self._key

  @property
  def name(self):
    return self._name

  @property
  def session(self):
    return sum(t.session for t in self if not t.special)

  @property
  def total(self):
    return sum(t.total for t in self if not t.special)

  @property
  def totals(self):
    totals = {}
    for key, stat in self._stats.iteritems():
      totals[key] = stat.total
    self._totals.update(totals)
    return self._totals

  def add(self, stat, force=False):
    if not force and stat.key in self._stats:
      return
    self._stats[stat.key] = stat
    total = self._totals.get(stat.key, 0)
    stat.set(0, total)

  def update(self, key, amount):
    if key not in self._stats:
      tf.err('The key (%s) does not exist.' % key)
      return
    self._stats[key].update(amount)

  def reset(self):
    for stat in self:
      stat.reset()

  def resetAll(self):
    for stat in self:
      stat.set(0, 0)

  def display(self, command):
    session = self.session
    total = self.total
    output = [
        '.-----------------------------------------------------------------------------.',
        '| %s |' % self._name.center(75),
        '|-------------------------------.----------------------.----------------------|',
        '|                               |              SESSION |                TOTAL |',
        '|-------------------------------+----------------------+----------------------|',
        ]
    special = []
    found = False
    for stat in self:
      if stat.hide:
        continue
      if stat.special:
        special.append('| %-29s | %10s (%6.2f%%%%) | %10s (%6.2f%%%%) |' % (
            stat.name,
            util.formatNumber(stat.session),
            stat.session * 100.0 / (session or 1),
            util.formatNumber(stat.total),
            stat.total * 100.0 / (total or 1)))
        continue
      found = True
      output.append('| %-29s | %10s (%6.2f%%%%) | %10s (%6.2f%%%%) |' % (
          stat.name,
          util.formatNumber(stat.session),
          stat.session * 100.0 / (session or 1),
          util.formatNumber(stat.total),
          stat.total * 100.0 / (total or 1)))
    if found:
      output.append(
          '|-------------------------------+----------------------+----------------------|')
    if special:
      special.append(
          '|-------------------------------+----------------------+----------------------|')
    output.extend(special)
    output.append('|                               | %20s | %20s |' % (
        util.formatNumber(session),
        util.formatNumber(total)))
    output.append("'-------------------------------'----------------------'----------------------'")

    for line in output:
      tf.eval('%s %s' % (command, line))

  def load(self, path):
    if not os.path.isfile(path):
      tf.err('Could not find file: %s' % path)
      return False
    try:
      fh = open(path, 'r')
    except IOError, e:
      tf.err('IOError: %s' % e)
      return False
    try:
      totals = pickle.load(fh)
      for key, total in totals.iteritems():
        if key not in self._stats:
          continue
        self._stats[key].set(0, total)
      self._totals = totals
    except IOError, e:
      tf.err('IOError: %s' % e)
      return False
    finally:
      fh.close()
    return True

  def save(self, path):
    try:
      fh = open(path, 'w')
    except IOError, e:
      tf.err('IOError: %s' % e)
      return False
    try:
      pickle.dump(self.totals, fh, pickle.HIGHEST_PROTOCOL)
    except IOError, e:
      tf.err('IOError: %s' % e)
      return False
    finally:
      fh.close()
    return True

  def clean(self):
    for key in self._totals:
      if key not in self._stats:
        del self._totals[key]

  def purge(self):
    self.totals
    self._stats = {}


class Stats(object):

  def __init__(self):
    self._groups = {}

  def addGroup(self, group, force=False):
    if not force and group.key in self._groups:
      return
    self._groups[group.key] = group

  def add(self, group, stat, force=False):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].add(stat, force=force)

  def update(self, group, key, amount):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].update(key, amount)

  def reset(self, group):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].reset()

  def resetAll(self, group):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].resetAll()

  def display(self, group, command):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].display(command)

  def load(self, group, path):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].load(path)

  def save(self, group, path):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].save(path)

  def clean(self, group):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].clean()

  def purge(self, group):
    if group not in self._groups:
      tf.err('The group (%s) does not exist.' % group)
      return
    self._groups[group].purge()

if __name__ != '__main__':
  inst = Stats()
