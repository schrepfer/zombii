#!/usr/bin/env python
#
# This script just tries to order the bes guess for chest combos.
#
# Written by Alexander C. Schrepfer (conglomo@zombiemud)
#

combos = []
order = (5, 4, 6, 3, 7, 2, 8, 1, 9, 0)

def addCombo(combo):
  if not combo in combos:
    combos.append(combo)

def getCombo(x, y, z):
  i = x*100 + y*10 + z
  return getFormattedCombo(i)

def getFormattedCombo(i):
  if i < 0:
    i = 0
  elif i > 999:
    i = 999
  return '%03d' % (i)

def main():
  for i in order:
    addCombo(getCombo(i, i, i))

  for i in [ x for x in order if x > 0 and x+2 < 10 ]:
    addCombo(getCombo(i, i+1, i+2))

  for i in [ x for x in order if x-2 > 0 ]:
    addCombo(getCombo(i, i-1, i-2))

  for i in order:
    for j in order:
      addCombo(getCombo(i, j, j))
      addCombo(getCombo(j, j, i))
      addCombo(getCombo(j, i, j))

  for i in range(0, 500):
    addCombo(getFormattedCombo(500+i))
    addCombo(getFormattedCombo(500-i))

  for combo in combos:
    print combo


if __name__ == '__main__':
  main()
