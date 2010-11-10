#!/usr/bin/env python
#
# Copyright 2009. All Rights Reserved.

"""Effects."""

__author__ = 'schrepfer'

import os
import sys
import tf
import time
import util


class Effect(object):
  """An effect on your character.

  Attributes:
    count:
    key:
    name:
    short_name:
    groups:
    duration:
    last_duration:
  """

  def __init__(self, key, name, short_name=None, layers=1, groups=None):
    """Constructor.

    Args:
      key:
      name:
      short_name:
      layers:
      groups:
    """
    self._key = key
    self._name = name
    self._short_name = short_name
    self._layers = layers
    if isinstance(groups, str):
      self._groups = None if not groups else groups.split()
    elif isinstance(groups, list):
      self._groups = groups[:]
    else:
      self._groups = groups
    self._last_duration = -1
    self.reset()

  def copy(self):
    return Effect(
        self._key, self._name, short_name=self._short_name,
        layers=self._layers, groups=self._groups)

  def reset(self):
    """Reset the state of this effect."""
    self._state = []

  def __cmp__(self, other):
    return cmp(self._name, other._name)

  @property
  def count(self):
    return max(0, min(self._layers, len(self._state)))

  @property
  def key(self):
    return self._key

  @property
  def name(self):
    return self._name

  @property
  def short_name(self):
    return self._short_name

  @property
  def layers(self):
    return self._layers

  @property
  def groups(self):
    return self._groups

  @property
  def duration(self):
    if self._state:
      return time.time() - self._state[0]
    return -1

  @property
  def last_duration(self):
    return self._last_duration

  def on(self, quiet=False):
    """Turn this effect on and call back to tf extra information.

    Args:
      quiet:
    """
    self._state.append(time.time())
    self._state = self._state[-self._layers:]
    if quiet:
      return
    if self._layers > 1:
      tf.eval('/announce_prot -p%s -s1 -o%s' % (
          repr(self._name), repr('%d/%d' % (self.count, self._layers))))
    else:
      tf.eval('/announce_prot -p%s -s1' % repr(self._name))

  def off(self, quiet=False):
    """Turn this effect off and call back to tf extra information.

    Args:
      quiet:
    """
    duration = self.duration
    if self._state:
      self._last_duration = duration
      self._state = self._state[1:]
    if quiet:
      return
    tanking = tf.eval('/test is_me(tank)')
    if self._layers > 1:
      tf.eval('/announce_prot -p%s -s0 -o%s -n%d' % (
          repr(self._name),
          repr('%s, %d/%d' % (
              util.getPrettyTime(int(duration), short=True), self.count, self._layers)),
          3 if tanking else 1))
    else:
      tf.eval('/announce_prot -p%s -s0 -o%s -n%d' % (
          repr(self._name), repr(util.getPrettyTime(int(duration), short=True)),
          3 if tanking else 1))

  def stateDict(self, online=True, offline=True):
    """Return a dict containing the current state of this effect.

    Args:
      online:
      offline:

    Returns:
      A dict mapping keys to their respective values.
    """
    if self.count and (online or (self.count < self.layers and offline)):
      return {
          'name': self._name,
          'key': self._key,
          'count': '%d/%d' % (self.count, self._layers),
          'status': (
              '%d/%ds' % (self.duration, self._last_duration) if self._last_duration != -1
              else '%ds' % self.duration),
          'state': 'ON',
          'color': 'green' if self.count == self._layers else 'yellow',
          }
    if offline and not self.count:
      return {
          'name': self._name,
          'key': self._key,
          'count': '%d/%d' % (self.count, self._layers),
          'status': 'OFF',
          'state': 'OFF',
          'color': 'red',
          }


class EffectGroup(object):
  """A group of effects that are mutually exclusive.

  Attributes
    key:
    effect:
    count:
    name:
    short_name:
    layers:
  """

  def __init__(self, key, name, short_name=None):
    """Constructor.

    Args:
      key:
      name:
      short_description:
    """
    self._effects = {}
    self._key = key
    self._name = name
    self._short_name = short_name

  def __cmp__(self, other):
    return cmp(self._name, other._name)

  def copy(self):
    return EffectGroup(
        self._key, self._name, short_name=self._short_name)

  @property
  def key(self):
    return self._key

  @property
  def effect(self):
    for key, effect in self._effects.iteritems():
      if effect.count:
        return effect
    return None

  @property
  def count(self):
    effect = self.effect
    if effect is None:
      return 0
    return effect.count

  @property
  def name(self):
    effect = self.effect
    if effect is None:
      return self._name
    return effect.name

  @property
  def short_name(self):
    effect = self.effect
    if effect is None:
      return self._short_name
    return self._short_name

  @property
  def layers(self):
    effect = self.effect
    if effect is None:
      return 1
    return self._layers

  def add(self, effect):
    """Add an effect to this effect group.

    Args:
      effect:
    """
    self._effects[effect.key] = effect

  def remove(self, key):
    """Remove an effect from this effect group.

    Args:
      effect:
    """
    if key in self._effects:
      del self._effects[key]

  def stateDict(self, online=True, offline=True):
    """Return a dict containing the current state of this effect group.

    If the state of this effect group is on then we forward this call to that effect. Otherwise we
    return information about this effect group.

    Args:
      online:
      offline:

    Returns:
      A dict mapping keys to their respective values.
    """
    effect = self.effect
    if effect is not None:
      return effect.stateDict(online=online, offline=offline)

    if offline:
      return {
          'name': '%s (g)' % self._name,
          'key': self._key,
          'count': '-',
          'status': 'OFF',
          'state': 'OFF',
          'color': 'red',
          }


class Effects(object):
  """All of the effects associated with a particular world."""

  def __init__(self):
    self._effects = {}
    self._effect_groups = {}

  def copy(self):
    effects = Effects()
    for effect_group in self._effect_groups.values():
      effects.addGroup(effect_group.copy())
    for effect in self._effects.values():
      effects.add(effect.copy())
    return effects

  def reset(self):
    """Reset all of the effects."""
    for effect in self._effects.values():
      effect.reset()

  def __iter__(self):
    return self._effects.iteritems()

  def addGroup(self, effect_group):
    """Add an effect group.

    Args:
      effect_group:
    """
    if effect_group.key in self._effects:
      tf.err('effect.group.key is an effect: %s' % effect_group.key)
      return

    self._effect_groups[effect_group.key] = effect_group

  def add(self, effect):
    """Add an effect.

    Args:
      effect:
    """
    if effect.key in self._effect_groups:
      tf.err('effect.key is an effect group: %s' % effect.key)
      return

    self._effects[effect.key] = effect

    if not effect.groups:
      return

    for group in effect.groups:
      if group not in self._effect_groups:
        tf.err('effect.groups does not exist: %s' % group)
        continue
      self._effect_groups[group].add(effect)

  def removeGroup(self, key):
    """Remove an effect group with given key.

    Args:
      key:
    """
    if key in self._effect_groups:
      del self._effect_groups[key]

  def remove(self, key):
    """Remove an effect with the given key.

    Args:
      key:
    """
    if key in self._effects:
      del self._effects[key]
      for effect_group in self._effect_groups.values():
        effect_group.remove(key)

  def on(self, key, quiet=False):
    """Turn on the effect with the given key.

    Args:
      key:
      quiet:
    """
    if key in self._effects:
      self._effects[key].on(quiet=quiet)

  def off(self, key, quiet=False):
    """Turn off the effect with the given key.

    Args:
      key:
      quiet:
    """
    if key in self._effects:
      self._effects[key].off(quiet=quiet)

  def count(self, key):
    if key in self._effects:
      return self._effects[key].count
    return 0

  def name(self, key):
    if key in self._effects:
      return self._effects[key].name
    return ''

  def short_name(self, key):
    if key in self._effects:
      return self._effects[key].short_name
    return ''

  def layers(self, key):
    if key in self._effects:
      return self._effects[key].layers
    return 0

  def duration(self, key):
    if key in self._effects:
      return self._effects[key].duration
    return -1

  def last_duration(self, key):
    if key in self._effects:
      return self._effects[key].last_duration
    return -1

  def forall(self, template, keys=None, online=True, offline=True):
    """Apply template for each effect that matches the search criteria.

    Args:
      template:
      keys:
      online:
      offline:
    """
    if not template:
      return

    if keys is None:
      effects = sorted(self._effects.values())
    else:
      effects = []
      if isinstance(keys, str):
        keys = keys.split()
      for key in keys:
        if key in self._effect_groups:
          effects.append(self._effect_groups[key])
        elif key in self._effects:
          effects.append(self._effects[key])

    found = False
    for effect in effects:
      result = effect.stateDict(online=online, offline=offline)
      if result:
        found = True
        tf.eval(template % result)

    if not found:
      tf.eval(template % {
          'name': 'None',
          'key': '',
          'count': '-',
          'status': '-',
          'state': '-',
          'color': 'red'
          })

if __name__ != '__main__':
  inst = Effects()
