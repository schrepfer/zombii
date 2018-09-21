# vim: syn=python

import ravenkall_sewers
reload(ravenkall_sewers)

SKIPS = (
    ravenkall_sewers.FILE[0]['skip'] + 1)

FILE = (
  [
    {
      'name': 'Cantador',
      'announce': ravenkall_sewers.FILE[0]['announce'],
      'summary': True,
    },
  ] +
  ravenkall_sewers.FILE[1:-1] +
  [
    {
      'path': '2 e;6 n;2 w;3 n',
      'name': '__announce__',
      'announce': '1n',
    },
    {
      'name': 'Unknown',
    },
  ]
  )
