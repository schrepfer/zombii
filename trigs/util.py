#!/usr/bin/env python
#
# Copyright 2009. All Rights Reserved.

"""Utils."""

__author__ = 'schrepfer'

import hashlib
import locale
import os
import re
import sys
import urllib

def getPrettyTime(time, short=False):
  """Return the time in a pretty format.

  Args:
    time: Integer; Number of seconds in time to be formatted.
    short: Boolean; If True a short version will be returned.

  Returns:
    String; Time formatted in a pretty way.
  """
  negative = True if time < 0 else False
  time = abs(int(time * 1000))

  units = [
      (time / 604800000, 'week', 'w'),
      (time / 86400000 % 7, 'day', 'd'),
      (time / 3600000 % 24, 'hour', 'h'),
      (time / 60000 % 60, 'minute', 'm'),
      (time / 1000 % 60, 'second', 's'),
      (time % 1000, 'millisecond', 'ms'),
      ]

  results = []
  for count, long_name, short_name in units:
    if not count and (time or long_name != 'second'):
      continue
    if short:
      results.append('%d%s' % (count, short_name))
    else:
      results.append('%d %s%s' % (count, long_name, '' if count == 1 else 's'))

  if short:
    return '%s%s' % ('-' if negative else '', ' '.join(results))

  return '%s%s' % ('-' if negative else '', ', '.join(results))

KILO = 1000
MEGA = KILO * 1000
GIGA = MEGA * 1000
TERA = GIGA * 1000
PETA = TERA * 1000

PREFIX_MULTIPLIERS = [
    (PETA, 'P'),
    (TERA, 'T'),
    (GIGA, 'G'),
    (MEGA, 'M'),
    (KILO, 'K')]

def getHumanReadableFormat(number, digits=2):
  number = float(number)
  sign = '-' if number < 0 else ''
  number = abs(number)
  for multiplier, symbol in PREFIX_MULTIPLIERS:
    if number > multiplier:
      return ('%%s%%0.%df%%s' % digits) % (sign, number / multiplier, symbol)
  return ('%%s%%0.%df' % digits) % (sign, number)

def getExpStringFormat(number):
  output = []
  sign = '-' if number < 0 else ''
  number = abs(number)
  for multiplier, symbol in PREFIX_MULTIPLIERS:
    if number > multiplier:
      output.append(
          ('%03d%s' if output else '%d%s') % (number / multiplier % 1000, symbol))
  if not output:
    return '%s%s' % (sign, str(int(number)))
  return '%s%s' % (sign, ' '.join(output))

def getMD5(message):
  return hashlib.md5(message).hexdigest()

def getSHA1(message):
  return hashlib.sha1(message).hexdigest()

try:
  locale.setlocale(locale.LC_ALL, '')
except locale.Error:
  pass

def formatNumber(number):
  return locale.format('%d', number, grouping=True)

def round(float, digits):
  sign = '-' if float < 0 else ''
  float = abs(float)
  return ('%%s%%0.%df' % max(0, digits)) % (sign, float)

def join(words, separator):
  return separator.join(words.split())

def urlencode(url):
  return urllib.quote(url)

def urldecode(url):
  return urllib.unquote(url)

def capitalize(words):
  return ' '.join([word.capitalize() for word in words.split()])

def sanitize(name):
  return re.sub('[^a-z0-9]+', '_', name.lower())

def hex(number, digits=0):
  return ('%%0%dx' % digits) % number

def sort(words, separater=' '):
  return separater.join(sorted(words.split(separater)))

def unique(words, separater=' '):
  return separater.join(set(words.split(separater)))
