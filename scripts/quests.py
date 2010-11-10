#!/usr/bin/env python
#
# This script gives you quest hints.
#
# Written by Alexander C. Schrepfer (conglomo@zombiemud)
#

import sys, string
from optparse import OptionParser

parser = OptionParser(version='Quests v0.9.' + '$LastChangedRevision: 988 $'[22:-2], usage='usage: %prog [options] quest')
parser.add_option('', '--list', action='store_true', dest='list', help='list all of the quests', default=False)
parser.add_option('', '--xml', action='store_true', dest='xml', help='xml format of all of the quests', default=False)
parser.add_option('', '--print-all', action='store_true', dest='print_all', help='print all of the quests', default=False)

quests = {
  "Worship the statue of Tonto" : [
    "Go '4 e;4 s;worship statue'",
    "Back '4 n;4 w'",
  ],
  "Do a little dance..." : [
    "Go '3 n;2 w;2;w;dance on floor'",
    "Back 'e;s;out;2 e;3 s'",
  ],
  "Cultural centers of Zombie City" : [
    "Go '3 n;4 w;enter;out;e;3 s;w;2 s;e;n;s;2 e;s;n;e;2 s;e;n;s;w;4 n'",
  ],
  "Dive into the Marvin Gardens pond" : [
    "Go '5 w;3 s;dive in pond'",
    "Back 'surface;3 n;5 e'",
  ],
  "Reading is educational" : [
    "Go '4 s;e;n;pull lever;s;pull torchholder;2 w;2 s;3 w;read 1;q;read 2;q'",
    "Back '3 e;2 n;2 e;n;enter hole;s;w;4 n'",
  ],
  "Visit the Temple of Burning Night" : [
    "Go '9 w;20 sw;15 w;10 s;8 w;5 n'",
    "Back '5 s;8 e;10 n;15 e;20 ne;9 e'",
  ],
  "Newbie party" : [
    "Find 'A puny, young member of the City Guard' or 'A new member of the City Guard'",
    "Kill him",
  ],
  "Bring Lachesis one of the famous pies of Minda" : [
    "If Minda is alive:",
    "- Go '17 e;2 ne;field;buy pie'",
    "- Back 'leave;2 sw;17 w;3 n;2 w;s;se;give pie to lachesis'",
    "Else:",
    "- Go '17 e;2 ne;field;e;s'",
    "- Find 'Umbriel the brownie'",
    "- Get 'a goo-berry pie'",
    "- Back 'n;w;leave;2 sw;17 w'",
    "Finally 'give pie to lachesis'",
  ],
  "Seek Sawu the Magician" : [
    "Go '9 e;5 n;path;2 w;sw;get flask;W;search ruins;5 e;N'",
    "Kill 'A red fox'",
    "Go 'se;climb oak;climb up;enter hole;give root,tail,flask to sawu' and Wait",
    "Back 'out;2 climb down;w;S;2 e;ne;3 e;5 s;9 w'",
    "Finally 'give potion to lachesis'",
  ],
  "Get familiar with the Zombiecity's shop of Transportation" : [
    "Go '3 n;3 e;n;w;buy transport to ravenkall;2 e;2 n;2 e;s;buy transport to zombiecity'",
  ],
  "Thirsty taskmaster" : [
    "Go '3 e;s;e;buy ale;w;s;4 w;s;w;buy beer;e;3 n;w;3 n;e;s;se'",
  ],
  "Find missing reagent for Xoth's soup" : [
    "Go '4 s;e;n;pull lever;s;pull torchholder;2 w;n;stairs;3 ne;get egg;3 sw;stairs;3 s;2 e;push barrel;e;give egg to xoth'",
    "Back '3 w;2 n;2 e;n;travel hole;s;w;4 n'",
  ],
  "Mysterious fortunes" : [
    "Find '' and wait till she tells you a fortune.",
  ],
  "The writings on the wall" : [
    "Go '3 n;3 w;portal;hero_candidate;wield knife;church;4 e;3 s;4 e;2 s;carve Hi'",
    "Back '2 n;4 w'",
  ],
  "Scale the city wall" : [
    "Go '4 s;2 w;climb wall'",
    "Back 'e;6 n'",
  ],
  "Ailurophile" : [
    "Find 'A hyperactive curly-eared spaniel' and 'kick dog'",
    "Find 'A white kitten' and 'pet kitten'",
  ],
  "The back entrance to the Catacombs" : [
    "Go '5 w;4 n;ne;d;4 s;w;n;5 d;e;n'",
    "Back 's;w;5 u;s;e;4 n;u;sw;4 s;5 e'",
  ],
  "Golden pigeon" : [
    "Go '14 n;12 w;12 w;2 nw;gates;2 n'",
    "Solo kill 'A golden pigeon.'",
    "Back '3 s;2 se;12 e;12 e;14 s'",
  ],
  "Visit Kiord the famous keymaker" : [
    "Go '10 s;20 w;20 w;5 n;path;11 n;e;7 n;2 w;2 se;w;s;2 w;nw;s;nw;s;nw;s;nw;n;3 e;2 n;push plate;2 n'",
    "Back 'out;2 w;2 s;w;3 n;e;2 nw;2 e;7 s;w;12 s;5 s;20 e;20 e;10 n'",
  ],
  "Find Zandaramas the lich archmage" : [
    "Go '9 w;20 sw;20 w;s;4 w;3 climb;W;NW;N;e;SE;E;N;NW;4 n'",
    "Try 'w', 'n' and 'e' and look for 'Zandaramas the Lich Archmage (undead)'",
    "Back 'portal;S;SE;S;SE;N;E;N;E;S;SW;w;3 d;4 e;n;20 e;20 ne;9 e'",
  ],
  "The Imp's cloak" : [
    "Go '4 e;4 s;open manhole;d;crack;2 w;nw;n;e;pull lever;door'",
    "Back 'door;4 w;10 ne;6 e;3 n;e;s;se'",
    "Finally 'give cloak to lachesis''",
  ],
  "Escape from the Ancient pyramid" : [
    "Go '16 s;4 sw;11 s;11 s;se;pyramid;enter'",
    "Back 'stairs;2 ne;n;ne;stairs;3 s;se;e;n;ne;out;leave;nw;11 n;11 n;4 ne;16 n'",
  ],
  "Count the Obelisks" : [
    "Go '10 s;20 w;20 w;5 n;path;4 n;3 e;n;d;2 s;count'",
    "Back '2 n;u;s;3 w;10 s;20 e;20 e;10 n'",
  ],
  "Rescue the princess" : [
    "Go '17 e;2 ne;field;e;s;5 e;14 se;crack;2 e;dig;2 push stone;n;e;n;search ice;s;pull torch;say yes'",
    "Wait for 'The guard pulls on a hidden lever that drops a plank across the pit.'",
    "Go 's;give steak to dog;3 s;chamber'",
    "Kill 'Pixie Torturer' and 'free princess'",
    "Back '5 n;out;e;2 s;3 u;craig;d;14 nw;5 w;n;w;leave;2 sw;17 w'",
  ],
  "Visit the wise old man" : [
    "You are going to need 51 dex to complete this quest",
    "Go '3 n;3 e;n;w;buy transport to ravenkall;2 w;6 n;2 e;12 n;w;clearing;sw;3 w;sw;cross river;w;enter crack'",
    "Back 'out;e;cross river;ne;3 e;ne;out;e;12 s;2 e;4 s;2 e;s;buy transport to zombiecity;3 n;2 w;se'",
  ],
  "Try a delicious sausage inna bun" : [
    "Go '4 e;5 n;buy sausage'",
    "Back '5 s;4 w'",
  ],
  "Find the hidden treasure room of gnomes" : [
    "Go '3 n;3 e;n;w;buy transport to ravenkall;2 w;N;2 e;6 n;11 e;camp;2 n;e;open flap;3 e;ladder;2 n'",
    "Kill 'Gnome Guard'",
    "Finally 'push wall;N'",
    "Back 'S;u;4 w;2 s;out;11 w;6 s;2 e;4 s;2 e;s;buy transport to zombiecity'",
  ],
  "Zombie hunt" : [
    "Go '8 s;w;20 s;enter mists'",
    "Find and kill 'A rotting zombie (undead)'",
    "Back '6 w;n;11 w;n;e;enter;mists' Wait then '2 e;s;se'",
  ],
  "Clan McFaerun" : [
    "Check the 'The General Store' and buy either:",
    "- 'Prize Bull of Clan Frasier' (1000 gold)",
    "- 'The head of Frasier' (20 gold)",
    "Go '16 s;20 sw;20 w;3 sw;5 w;forest;enter;N;E;tale;n;NW;W;quest'",
    "If you have the bull type 'bull' or if you have the head type 'head'",
    "To get the head the long way:",
    "- Go 'E;ne;e;ne;4 e;se'",
    "- Kill '' and loot ''",
    "- Go 'nw;4 w;sw;w;sw;W'",
    "- Finally 'head'",
    "To get the bull the long way:",
    "- E;ne;e;ne;4 e;S;W;s;steal",
    "- Kill 'all human' and 'steal' again",
    "- Go 'n;2 e;N;4 w;sw;w;sw;W'",
    "- Finally 'head'",
    "Back 'E;SE;s;adv-guild;se'",
  ],
  "Find the Golden Kingdom" : [
    "Go '3 n;3 e;n;w;buy transport to ravenkall;2 w;N;2 e;2 n;20 w;20 w;18 n;path;ne;2 n;nw;w;enter tree;w;nw;n'",
    "Back 's;se;e;out;e;se;2 s;sw;out;18 s;20 e;20 e;2 s;2 e;4 s;2 e;s;buy transport to zombiecity'",
  ],
  "The Holy Avengers" : [
    "Go '10 w;3 nw;10 w;2 sw;18 w;5 n;path;2 s;sw;2 w;2 n;nw;n;enter;n;e'",
    "Kill 'Temple's High Entrantress Dandra'",
    "Then 'e;d;pray'",
    "Back '2 u;w;w;s;out;s;se;3 s;2 e;ne;3 n;5 s;18 e;2 ne;10 e;3 se;10 e'",
  ],
  "Visit the island tower" : [
    "Go '14 e;7 ne;village;3 e' and 'ring bell'",
    "Enter the ferry with 'enter ferry'",
    "Wait then 'out;2 w'",
    "If the boat is not there:",
    "- Go 'e;2 s;e;s' and talk to 'Nalrudil Menel the Elf innkeeper of Waterhome' with 'say boat'",
    "- Go 'n;w;2 n;e;n' and buy 3x 'a well crafted fishing rod' (1000 each)",
    "- Go 's;w;2 s;e;s' and 'give all rod to nalrudil'",
    "- Go back to the boat 'n;w;2 n;w'",
    "Enter the boat with 'enter boat' and 'row'",
    "Wait then 'out;e'",
    "Back 'w'",
    "Enter the boat with 'enter boat' and 'row'",
    "Wait then 'out;2 e' and 'ring bell'",
    "Enter the ferry with 'enter ferry'",
    "Wait then 'out;4 w;7 sw;14 w'",
  ],
  "Farming" : [
    "Go '9 w;20 sw;15 w;10 s;8 w;4 n;8 sw;6 w;road;4 n;3 e;enter gate'",
    "Inspect 'e;s;w;n'",
    "Back 'gate;3 w;5 s;6 e;8 ne;4 s;8 e;10 n;15 e;20 ne;9 e'",
  ],
  "Visit the Elven Sage" : [
    "Go ''",
    "Back ''",
  ],
  "Refill a tankard at the Uhruul Inn" : [
    "Go '10 s;7 se;s;enter;d;2 e;n;buy beer;drink beer;refill'",
    "Back 's;2 w;u;out;n;7 nw;10 n'",
  ],
  "Find the King Maple treant" : [
    "Get 'flight' ability",
    "Go '17 e;2 ne;field;e;s;e;18 se;climb;upwest;fly;3 nw;2 n;d;u;fly;ne;2 d;fly;e;3 se;2 s;sw;d;u;fly;2 w;nw;n;2 ne;e;2 se;s;sw;d;u;fly;w;nw;n;ne;d;u;fly;sw;se;ne;n;d;u'",
    "Back 'd;s;sw;nw;ne;d;sw;s;se;e;d;ne;n;2 nw;w;2 sw;s;se;2 e;d;ne;2 n;3 nw;w;u;sw;d;2 s;3 se;downeast;valley;18 nw;w;n;w;leave;2 sw;17 w'",
  ],
  "Visit the intact fortress of Highwall" : [
    "Make sure it's night 'look at sky'",
    "To check clock go '2 e;2 s;look at clock' and '2 n;2 w' to return",
    "Go '3 n;3 e;n;w;buy transport to ravenkall;2 w;N;2 e;15 n;20 w;20 w;20 w;10 w;12 s;13 e;ruins;n;enter portal;nw'",
    "Back 'se;enter portal;s;out;ne;20 e;20 e;16 e;4 s;2 e;4 s;2 e;s;buy transport to zombiecity'",
  ],
  "Find Lorain" : [
    "Go '12 n;20 nw;8 ne;e;path;ne;nw;4 n;open gate;3 n;3 e;open door;s'",
    "Kill or get a Death Knight to cube 'A ghost (undead)'",
    "Take key 'get key'",
    "Go 'stairs;e;unlock south door;open south door;s'",
    "Back 'n;w;stairs;n;3 w;2 s;open gate;5 s;se;sw;path;w;8 sw;20 se;12 s'",
  ],
  "Close the gate to Uhruul" : [
    "Go '10 s;7 se;s;enter;push lever'",
    "Wait and 'pull lever'",
    "Wait and back 'out;n;7 nw;10 n'",
  ],
  "Advanced target practice" : [
    "Go '6 s;3 se;10 s;4 se;gate'",
    "Check boat 'sw;u;look through tube;d;ne'",
    "To adjust the horizontal direction 'turn platform north' or 'turn platform south'",
    "- If the ship is to the left point the trebuchet 'to the south'",
    "- If the ship is to the right point the trebuchet 'to the north'",
    "- If the ship is in the middle point the trebuchet 'to the west'",
    "To adjust the vertical direction 'lengthen ropes' or 'shorten ropes'",
    "- There are 11 lengths for the rope, to center Go '10 lengthen ropes;5 shorten ropes'",
    "- If the ship is above horizontal line, you 'lengthen' it x notches",
    "- If the ship is below horizontal line, you 'shorten' it x notches",
    "To fire 'pull lever'",
    "Back 'gate;4 nw;10 n;3 nw;6 n'",
  ],
  "Rescue Fanis from the Vines" : [
    "Go '3 n;3 e;n;w;buy transport to ravenkall;2 w;N;2 e;2 n;8 w;15 sw;2 climb;e;swing vine;grab branch;e'",
    "Kill aggressive 'A huge vine' and get 'Vine root'",
    "Finally 'w;exit;w;2 d' and 'drop root'",
    "Back '15 ne;8 e;2 s;2 e;4 s;2 e;s;buy transport to zombiecity'",
  ],
  "Locate bandit lord Cronal Volsteads current whereabouts" : [
    "Go '3 n;3 e;n;w;buy transport to ravenkall;2 w;N;2 e;15 n;20 w;5 w;enter;7 e;5 n'",
    "If 'A brigand assaulting helpless peasant' are dead, check 'alert' channels's topic",
    "Else:",
    "- Wait for 'Victorr, the lesser war priest of Belinik' and kill him",
    "- 'The bandit tells you: 'Local bandit leader Cronal Volstead is in a backroom of",
    "-  inn, just say our code: 'NNNNN' to innkeeper and he will let you to meet",
    "-  Cronal, but member not to piss him off. Cronal can be very mean.'",
    "Finally '2 w;n;enter' and 'say NNNNN' (NNNNN = code)",
    "Back '2 out;5 w;6 s;leave;20 e;5 e;15 s;2 e;4 s;2 e;s;buy transport to zombiecity'",
  ],
  "The unholy guard" : [
    "Go '15 s;3 e;15 s;15 s;2 portal;4 w;3 n;ne;n;nw;n'",
    "Kill 'An old man'",
    "Go 'enter;2 n'",
    "Kill 'Ghost of the captain of the guards (undead)'",
    "Back '2 s;out;s;se;s;sw;3 s;4 e;portal;leave;15 n;15 n;3 w;15 n'",
  ],
  "Visit dreaded stone statue of Kali" : [
    "Go '9 w;4 sw;11 s;20 s;path;5 n;open north door;2 n'",
    "Kill 'Abdul M'Abdullih the Grand Priest of Sigoria' and loot 'A rusty iron key'",
    "Go 'unlock west door with key;open west door;open east door;w;search desk;2 e;ladder;pull rope;ladder;open hatch;d;s;search west wall;push west wall;2 w;unlock door with key;open west door;w'",
    "Back '2 e;push wall;east;n;up;w;s;open south door;6 s;leave;20 n;11 n;4 ne;9 e'",
  ],
  "Slay the Huge Slimy Creature" : [
    "Go '15 e;7 s;enter;s;3 d;s;e;se;dive;s;se'",
    "Bang gong 'bang gong' and kill 'Huge Slimy Creature'",
    "Teleport out to get back.",
  ],
}

def main():

  (options, args) = parser.parse_args()

  if options.list:
    keys = quests.keys()
    keys.sort()
    i = 0
    for quest in keys:
      i = i + 1
      print '%3d) %s' % (i, quest)
    sys.exit(0)

  if options.print_all:
    for quest, info in quests.items():
      print '-' * 80
      print quest
      print '-' * 80
      print string.join(info, "\n")
      print '-' * 80
      print
    sys.exit(0)

  if options.xml:
    print '<?xml version="1.0" encoding="iso-8859-1"?>'
    print '<?xml-stylesheet type="text/xsl" href="objectives.xsl"?>'
    print '<quests>'
    for quest, info in quests.items():
      print '  <quest name="%s">' % (quest)
      print '    <hint><![CDATA[%s]]></hint>' % string.join(info, "\n")
      print '  </quest>'
    print '</quests>'
    sys.exit(0)

  if not len(args):
    parser.print_usage()
    sys.exit(1)

  quest = string.join(args, ' ')

  if quests.has_key(quest):
    print string.join(quests[quest], "\n")
    sys.exit(0)

  parser.error('could not find quest')
  sys.exit(1)

if __name__ == "__main__":
  main()
