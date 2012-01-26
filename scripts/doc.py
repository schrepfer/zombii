#!/usr/bin/env python
#
# Copyright 2011. All Rights Reserved.

"""Description of the help module."""

__author__ = 'schrepfer'

import logging
import optparse
import os
import sys
import re

from django import template
from django.conf import settings

settings.configure()
#GITHUB = 'https://github.com/schrepfer/zombii/blob/master/trigs/zombie.tf'

TYPE_MAP = {
  ':': 'string',
  '@': 'time',
  '#': 'integer',
  '': 'boolean',
  }

FLAG_MAP = {
  '': 'string',
  'b': 'boolean',
  'f': 'float',
  'i': 'integer',
  't': 'time',
  }

TEMPLATE_PATH = os.path.dirname(sys.argv[0])


class Option(object):

  def __init__(self, flag, type, argument, help, required):
    self._flag = flag
    self._type = type
    self._argument = argument
    self._help = help
    self._required = required

  def __cmp__(self, other):
    return cmp(self.flag, other.flag)

  @property
  def flag(self):
    return self._flag

  @property
  def type(self):
    return self._type

  @property
  def argument(self):
    return self._argument

  @property
  def help(self):
    return elementalize(self._help)

  @property
  def required(self):
    return self._required


class Param(object):

  def __init__(self, name, help, required):
    self._name = name
    self._help = help
    self._required = required

  def __cmp__(self, other):
    return cmp(self.name, other.name)

  @property
  def name(self):
    return self._name

  @property
  def help(self):
    return elementalize(self._help)

  @property
  def required(self):
    return self._required

  @property
  def usage(self):
    if not self._required:
      return '[%s]' % self._name
    return self._name


class Hook(object):

  def __init__(self, name, help):
    self._name = name
    self._help = help

  def __cmp__(self, other):
    return cmp(self.name, other.name)

  @property
  def name(self):
    return self._name

  @property
  def help(self):
    return elementalize(self._help)


class Definition(object):

  def __init__(self, name, line):
    self._name = name
    self._desc = None
    self._line = line

  def __cmp__(self, other):
    return cmp(self.name, other.name)

  @property
  def name(self):
    return self._name

  @property
  def desc(self):
    return elementalize(self._desc)


class Variable(Definition):

  def update(self, comments, start=0):
    for i, tag, text in getTags(comments):
      if tag is None:
        self._desc = text
      else:
        logging.error('%d: Unknown tag: %s', start + i, tag)


class Property(Definition):

  def __init__(self, name, line):
    super(Property, self).__init__(name, line)
    self._type = 'string'
    self._grab = False
    self._nullable = False
    self._default = None
    self._temporary = False

  @property
  def type(self):
    return self._type

  @property
  def grab(self):
    return self._grab

  @property
  def nullable(self):
    return self._nullable

  @property
  def default(self):
    return self._default

  @property
  def temporary(self):
    return self._temporary

  def update(self, comments, start=0):
    for i, tag, text in getTags(comments):
      if tag == 'type':
        self._type = text
      elif tag == 'grab':
        self._grab = True
      elif tag == 'nullable':
        self._nullable = True
      elif tag == 'temporary':
        self._temporary = True
      elif tag is None:
        self._desc = text
      else:
        logging.error('%d: Unknown tag: %s', start + i, tag)

  def updateFlags(self, flags, start=0):
    for flag, value in re.findall(r'-([a-zA-Z])(?:\'(.*?)\')?', flags):
      if flag in FLAG_MAP:
        self._type = FLAG_MAP[flag]
      elif flag == 'g':
        self._grab = True
      elif flag == 's':
        self._nullable = True
      elif flag == 'v':
        self._default = value
      else:
        logging.error('%d: Unknown flag: %s', start, flag)


class Macro(Definition):

  def __init__(self, name, line):
    super(Macro, self).__init__(name, line)
    self._params = []
    self._options = []
    self._hooks = []
    self._returns = None
    self._example = None
    self._deprecated = False
    self._aliases = []

  @property
  def params(self):
    return self._params

  @property
  def options(self):
    return sorted(self._options)

  @property
  def hooks(self):
    return sorted(self._hooks)

  @property
  def returns(self):
    return elementalize(self._returns)

  @property
  def example(self):
    return elementalize(self._example)

  @property
  def deprecated(self):
    return self._deprecated

  @property
  def aliases(self):
    return self._aliases

  def addAlias(self, alias):
    self._aliases.append(alias)

  def update(self, comments, start=0):
    for i, tag, text in getTags(comments):
      if tag == 'param':
        m = re.match(r'^(?P<name>[A-Za-z0-9_.=]+)(?P<required>\*)?\s*(?P<help>.*)$', text)
        if not m:
          logging.error('%d: %s error', start + i + 1, tag)
          continue
        groups = m.groupdict()
        self._params.append(Param(
            groups['name'],
            groups['help'],
            groups['required'] == '*'))
      elif tag == 'option':
        m = re.match(r'^(?P<flag>[a-zA-Z])(?:(?P<type>[:#@])(?P<argument>[A-Za-z]+))?(?P<required>\*)?\s*(?P<help>.*)$', text)
        if not m:
          logging.error('%d: %s error', start + i + 1, tag)
          continue
        groups = m.groupdict()
        if groups['type'] and groups['type'] not in TYPE_MAP:
          logging.error('%d: %s has bad type', start + i + 1, tag)
          continue
        self._options.append(Option(
            groups['flag'],
            groups['type'],
            groups['argument'],
            groups['help'],
            groups['required'] == '*'))
      elif tag == 'return':
        self._returns = text
      elif tag == 'example':
        self._example = text
      elif tag == 'deprecated':
        self._deprecated = True
      elif tag == 'hook':
        m = re.match(r'^(?P<name>[A-Za-z0-9_]+)\s*(?P<help>.*)$', text)
        if not m:
          logging.error('%d: %s error', start + i + 1, tag)
          continue
        groups = m.groupdict()
        self._hooks.append(Hook(
            groups['name'], groups['help']))
      elif tag is None:
        self._desc = text
      else:
        logging.error('%d: Unknown tag: %s', start + i, tag)

  @property
  def usage(self):
    return (
       ('[options] ' + ('-- ' if self._params else '') if self._options else '') +
       (' '.join(x.usage for x in self._params))).strip()


def elementalize(text):
  patterns = [
      (r'\[\[ *(?P<link>.*?) *\| *(?P<text>.*?) *\]\]', '<a href="%(link)s">%(text)s</a>'),
      (r'\[\[ *(?P<link>.*?) *\]\]', '<a href="%(link)s">%(link)s</a>'),
      (r'\{\{ *(?P<link>.*?) *\}\}', '<a href="#%(link)s">/%(link)s</a>'),
      (r'\'\' *(?P<text>.*?) *\'\'', '<i>%(text)s</i>'),
      (r'\* *(?P<text>.*?) *\*', '<i>%(text)s</i>'),
      (r'\%\{(?P<variable>[A-Za-z0-9_]+)\}', '<nobr><em>%%{%(variable)s}</em></nobr>'),
      ]
  for pattern, template in patterns:
    def sub(matcher):
      return template % matcher.groupdict()
    text = re.sub(pattern, sub, text)
  return text


def getTags(comments):
  tags = []
  tag = None
  text = []
  for i, line in enumerate(comments):
    if line.startswith('@'):
      tags.append((i, tag, ' '.join(text).strip()))
      if ' ' in line:
        tag, rest = line.split(None, 1)
      else:
        tag, rest = line, ''
      tag = tag[1:]
      rest = rest.strip()
      text = []
      if rest:
        text.append(rest)
    else:
      text.append(line)
  tags.append((i, tag, ' '.join(text).strip()))
  return tags


def parse(document):
  comments = None
  started = 0
  items = {}
  for i, line in enumerate(document):
    line = line.strip()
    if not line:
      continue
    if line == ';;;;':  # or not line:
      comments = []
      started = i
      continue
    m = re.match(r'^/def ([a-z0-9_]+) = /([a-z0-9_]+) \%\{\*\}$', line)
    if m:
      alias = m.group(1)
      name = m.group(2)
      if name in items:
        items[name].addAlias(alias)
      #else:
        #logging.error('Can not alias %s to a non-existent macro (%s)', alias, name)
      continue
    if not started or comments is None:
      continue
    if line.startswith(';;'):
      comments.append(line[2:].strip())
      continue
    if not comments:
      continue
    m = re.match(r'^/def .*\b([a-z0-9_]+)\b = ', line)
    if m:
      name = m.group(1)
      macro = Macro(name, i + 1)
      macro.update(comments, started)
      items[name] = macro
      started = 0
      continue
    m = re.match(r'^/property (.*)\b([a-z0-9_]+)\b($| = )', line)
    if m:
      flags = m.group(1)
      name = m.group(2)
      macro = Property(name, i + 1)
      macro.update(comments, started)
      macro.updateFlags(flags, started)
      items[name] = macro
      started = 0
      continue
    m = re.match(r'^/set ([A-Za-z0-9_]+)=', line)
    if m:
      name = m.group(1)
      variable = Variable(name, i + 1)
      variable.update(comments, started)
      items[name] = variable
      started = 0
      continue
  return items


def writeMacros(page, path):
  c = template.Context(autoescape=False)

  files = []
  for basename, macros in sorted(page.iteritems()):
    macros = sorted(p for p in macros.values() if isinstance(p, Macro))
    if not macros:
      continue
    files.append((basename, macros))

  c['files'] = files

  template_file = os.path.join(TEMPLATE_PATH, 'macros.tmpl')

  with open(template_file, 'r') as tmpl:
    t = template.Template(tmpl.read())
    with open(path, 'w') as fh:
      fh.write(t.render(c))


def writeProperties(page, path):
  c = template.Context(autoescape=False)

  files = []
  for basename, properties in sorted(page.iteritems()):
    properties = sorted(p for p in properties.values() if isinstance(p, Property))
    if not properties:
      continue
    files.append((basename, properties))

  c['files'] = files

  template_file = os.path.join(TEMPLATE_PATH, 'properties.tmpl')

  with open(template_file, 'r') as tmpl:
    t = template.Template(tmpl.read())
    with open(path, 'w') as fh:
      fh.write(t.render(c))


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
      '-o', '--output',
      action='store',
      default=os.getcwd(),
      dest='output',
      metavar='DIR',
      type='string',
      help='the output directory')
  return parser.parse_args()


def main(options, args):
  if not args:
    return os.EX_DATAERR

  page = {}

  for script in args:
    with open(script, 'r') as fh:
      relative = script.split('/trigs/')[-1]
      page[relative] = parse(fh)

  writeMacros(page, os.path.join(options.output, 'macros.html'))
  writeProperties(page, os.path.join(options.output, 'properties.html'))

  return os.EX_OK


if __name__ == '__main__':
  options, args = defineFlags()
  logging.basicConfig(
      level=options.verbosity,
      datefmt='%Y/%m/%d %H:%M:%S',
      format='[%(asctime)s] %(levelname)s: %(message)s')
  sys.exit(main(options, args))

