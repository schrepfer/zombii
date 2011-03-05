;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; AREA AND RUN MACROS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-02-15 00:51:08 -0800 (Tue, 15 Feb 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/areas.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/areas.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def to_cow = /run_path -d'se;s;se;s;se;s;2 se;s;se;s;se;2 s;3 se;s;2 se;s;se;s;se;s;se' -b'fr_cow' -n'cow'
/def fr_cow = /run_path -d'nw;n;nw;n;nw;n;2 nw;n;3 nw;2 n;nw;n;nw;n;2 nw;n;nw;n;nw;n;nw' -b'to_cs' -n'9w'
/def to_air = /run_path -d'6 w;2 sw;w;sw;w;2 sw;w;sw;2 w;3 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;3 w;3 sw' -b'fr_air' -n'air'
/def fr_air = /run_path -d'3 ne;3 e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;3 ne;2 e;ne;e;2 ne;e;ne;e;2 ne;6 e' -b'to_cs' -n'9w'

/def cspal = /set cspal=1%; /csironledge
/def rpal = /set rpal=1%; /rironledge
/def csironledge = /run_path -d'11 w;20 s;20 s;20 s;20 s;20 s;20 s;20 sw;sw;5 w;nw;gates;knock' -b'ironledgecs'
/def rironledge = /fr_rk%; /to_ironledge%; /run_path -d'knock' -b'ironledger'
/def -Fp5 -msimple -E'cspal | rpal' -t'The massive gates swing open soundlessly.' cspal_0 = /grab /xcastle
/def xcastle = /run_path -d'3 n;3 e;ring bell'
/def -Fp5 -msimple -E'cspal | rpal' -t'Finally the gate is open enough to enter the castle.' cspal_1 = /grab /castlepal
/def castlepal = /run_path -d'castle;2 e' -b'$[cspal ? "palcs" : "palr" ]'%; /set cspal=0%; /set rpal=0
/def palcs = /set palcs=1%; /run_path -d'2 w;pull lever'
/def palr = /set palr=1%; /run_path -d'2 w;pull lever'


/def -Fp5 -msimple -E'palcs | palr' -t'Finally the gate is open enough to leave the castle.' palcs_0 = \
  /if (palcs) \
    /grab /eval /castlex%%; /ironledgecs%; \
  /else \
    /grab /eval /castlex%%; /ironledger%; \
  /endif

/def -Fp5 -msimple -E'palcs | palr' -t'The lever is down already.' palcs_2 = /palcs_0
/def castlex = /run_path -d'leave;valley;2 w;2 s'
/def ironledger = /fr_ironledge%; /to_rk%; /set back=rkcs_castle%; /set palr=0
/def ironledgecs = /run_path -d'leave;leave;se;5 e;20 ne;ne;20 n;20 n;20 n;20 n;20 n;20 n;11 e'%; /set palcs=0

/def to_cantador = /run_path -d'7 s;6 se;2 s;4 se;20 s;s;3 se;17 s;5 se;3 sw;13 s;se;s;se;s;2 se;s;se;s;se;s;se' -b'to_rk' -n'1n'
/def fr_cantador = /run_path -d'nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;13 n;3 ne;5 nw;17 n;3 nw;n;20 n;4 nw;2 n;6 nw;7 n' -b'to_cs' -n'9w'

/def to_mellarnia = /run_path -d'2 se;5 e;4 se;4 e;6 se;e;4 se;s;se;ne;20 e;20 e;19 e;ne;9 e;ne;2 e;se;2 e;se;e;3 se;ne;6 e;14 se;11 e;3 se;2 e;se;2 e;2 se;ne;20 e;13 e;4 ne;3 n;ne;e;2 ne;4 n;nw;3 ne;13 e;2 se;4 e;2 se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;2 se;12 e;se;e;7 se;11 e;7 se;4 e;se;e;20 se;3 se;e;se' -b'fr_mellarnia' -n'erenia'
/def fr_mellarnia = /run_path -d'nw;w;3 nw;20 nw;w;nw;4 w;7 nw;11 w;7 nw;w;nw;12 w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;4 w;2 nw;13 w;3 sw;se;4 s;2 sw;w;sw;3 s;4 sw;13 w;20 w;sw;2 nw;2 w;nw;2 w;3 nw;11 w;14 nw;6 w;sw;3 nw;w;nw;2 w;nw;2 w;sw;9 w;sw;19 w;20 w;20 w;sw;nw;n;4 nw;w;6 nw;4 w;4 nw;5 w;2 nw' -b'to_cs' -n'9w'

/def csrk = /fr_cs%; /to_cantador%; /to_rk
/def csrk_trans = /run_path -d'3 n;3 e;n;w;buy transport to ravenkall' -b'rkcs_spiders'
/def rkcs = /fr_rk%; /fr_cantador%; /to_cs
/def rkcs_water = /run_path -d'2 e;6 n;2 w;3 n;20 nw;3 nw;20 n;20 n;20 n;10 n;10 e'
/def rkcs_spiders = /run_path -d'2 e;6 n;2 w;14 n;7 ne;enter;2 n;ne;2 nw;w;3 sw;4 w;sw;w;2 sw;w;nw;3 n;7 ne;2 n;climb;cs'
/def rkcs_trans = /run_path -d'6 e;2 n;2 w;s;buy transport to zombiecity'
/def rkcs_castle = /run_path -d'2 e;6 n;2 w;N;enter;cs'

/def cserend_trans = /run_path -d'2 n;w;withdraw 2500;e;n;3 e;n;w;buy transport to erend'
/def erendcs_trans = /run_path -d'sw;enter;buy transport to zombiecity'

/def csbar = /run_path -d'3 n;3 e;n;w;buy transport to ravenkall;6 w;3 s;e;n' -b'barcs'
/def barcs = /run_path -d's;w;3 n;8 e;2 n;2 e;s;buy transport to zombiecity'
/def csmag = /run_path -d'4 s;e;n;pull lever' -b'magcs'
/def magcs = /run_path -d'enter hole;s;w;4 n'
/def cspsi = /run_path -d'11 n;8 ne;path;e;7 n;open door;3 n;u' -b'psics'
/def psics = /run_path -d'd;2 s;open door;8 s;w;path;8 sw;11 s'
/def cshea = /cserend_trans%; /to_healer%; /run_path -d's;se;sw' -b'heacs'
/def heacs = /run_path -d'ne;nw;n'%; /fr_healer%; /erendcs_trans
/def csmon = /cserend_trans%; /to_shaolin%; /run_path -d'4 n' -b'moncs'
/def moncs = /run_path -d'4 s'%; /fr_shaolin%; /erendcs_trans
/def csfig = /run_path -d'5 n;2 e;2 s' -b'figcs'
/def figcs = /run_path -d'2 n;2 w;5 s'
/def csfigdef = /fr_cs%; /to_fields%; /run_path -d'4 n;e;se;s;4 e;4 ne;2 e;trace rixd;n' -b'figdefcs'
/def figdefcs = /run_path -d's;out;2 w;4 sw;4 w;n;nw;w;4 s'%; /fr_fields%; /to_cs
/def to_figbla = /run_path -d'5 s;sw;6 s;3 se;cave;e;se;se;ne;e;ne;ne;e;e;se;s;s;e;se;s;se;e;e;ne;ne;d' -b'fr_figbla'
/def fr_figbla = /run_path -d'u;sw;sw;w;w;nw;n;nw;w;n;n;nw;w;w;sw;sw;w;sw;nw;nw;w;out;3 nw;6 n;ne;5 n'
/def csran = /fr_cs%; /to_rangers%; /run_path -d'w;s' -b'rancs'
/def rancs = /run_path -d'n;e'%; /fr_rangers%; /to_cs
/def csrandf = /fr_cs%; /to_forestrangers%; /run_path -b'randfcs'
/def randfcs = /fr_forestrangers%; /to_cs
/def csranfd = /fr_cs%; /to_desertrangers%; /run_path -b'ranfdcs'
/def ranfdcs = /fr_desertrangers%; /to_cs
/def csranhm = /fr_cs%; /to_mountainrangers%; -b'ranhmcs'
/def ranhmcs = /fr_mountainrangers%; /to_cs
/def cssam = /cserend_trans%; /to_pagoda%; /run_path -d'enter;ne;2 n;e' -b'samcs'
/def samcs = /run_path -d'w;2 s;sw;out'%; /fr_pagoda%; /erendcs_trans
/def cstra = /run_path -d's;e;u;w' -b'tracs'
/def tracs = /run_path -d'e;d;w;n'
/def csabj = /cserend_trans%; /to_abjurersgrove%; /run_path -d'2 n;hut' -b'abjcs'
/def abjcs = /run_path -d'out;2 s'%; /fr_abjurersgrove%; /erendcs_trans
/def cssorc = /run_path -d'20 e;e;s;20 e;9 se;20 e;10 e;12 e;3 s;enter;rift;17 n'
/def xopal = /run_path -d'press opal;w;sw;w;press opal;2 u' -b'opalx'
/def opalx = /run_path -d'2 d;out;se;nw;n;2 nw;sw;grove;2 n;hut' -b'abjcs'
/def csnav = /fr_cs%; /to_neckbreaker%; /run_path -d'4 n;3 e;n;d;2 s' -b'navcs'
/def navcs = /run_path -d'2 n;u;s;3 w;4 s'%; /fr_neckbreaker%; /to_cs
/def csdk = /fr_cs%; /to_dktower%; /run_path -b'dkcs'
/def dkcs = /fr_dktower%; /to_cs
/def cscle = /run_path -d'5 w;3 n' -b'clecs'
/def clecs = /run_path -d'3 s;5 e'
/def csnec = /run_path -d'5 n;5 w;n;open doors;enter mausoleum;open coffin;crawl into coffin;close coffin' -b'neccs'
/def neccs = /run_path -d'n;leave;s;5 e;5 s'
/def cswar = /run_path -d'16 s;20 w;20 w;2 w;20 sw;2 e;touch engravings;e;2 n;touch runes' -b'warcs'
/def warcs = /run_path -d'out;2 s;w;touch cave;2 w;20 ne;2 e;20 e;20 e;16 n'

/def plate = /run_path -d'push plate;2 n;pf' -c'push plate;2 n;pf'
/def cermak = /run_path -d'enter;s;enter tent;pf' -c'enter;s;enter tent;pf'
/def swing = /run_path -d'climb tree;swing liana;pf' -c'climb tree;swing liana;pf'

/def csgl = /run_path -d'12 n;11 nw;2 n;18 w;16 nw;16 nw;castle' -b'glcs'
/def glcs = /run_path -d's;16 se;16 se;18 e;2 s;11 se;12 s'
/def glga = \
  /if (bag) \
    /let _get=get all to bag of holding;get all%; \
  /else \
    /let _get=get all%; \
  /endif%; \
  /run_path -d'n;%{_get};n;%{_get};n;%{_get};w;%{_get};w;%{_get};nw;%{_get};n;%{_get};n;%{_get};ne;%{_get};e;%{_get};e;%{_get};e;%{_get};e;%{_get};se;%{_get};s;%{_get};s;%{_get};sw;%{_get};w;%{_get};e;ne;n;e;%{_get};e;%{_get};e;%{_get};e;%{_get};e;%{_get};e;%{_get};e;%{_get};e;%{_get};n;%{_get};ne;%{_get};e;%{_get};e;%{_get};e;%{_get};e;%{_get};se;%{_get};s;%{_get};s;%{_get};sw;%{_get};w;%{_get};w;%{_get};w;%{_get};w;%{_get};nw;%{_get};se;2 e;s;%{_get};s;%{_get};s;%{_get};s;%{_get};s;%{_get};s;%{_get};e;%{_get};e;%{_get};se;%{_get};s;%{_get};s;%{_get};sw;%{_get};w;%{_get};w;%{_get};w;%{_get};w;%{_get};nw;%{_get};n;%{_get};n;%{_get};ne;%{_get};e;%{_get};w;sw;s;w;%{_get};w;%{_get};w;%{_get};w;%{_get};w;%{_get};w;%{_get};w;%{_get};w;%{_get};s;%{_get};sw;%{_get};w;%{_get};w;%{_get};w;%{_get};w;%{_get};nw;%{_get};n;%{_get};n;%{_get};ne;%{_get};e;%{_get};e;%{_get};e;%{_get};e;%{_get};se;%{_get};nw;2 w;n;%{_get};n;%{_get};n;%{_get}' -b'xgl'

/def xgl = /run_path -d'd;e;2 s;e;3 s' -b'glcs'
/def glx = /run_path -d'3 n;w;2 n;w;staircase' -b'xgl'

/def cssecu = /run_path -d'2 s;w;s' -t'man' -w'n' -b'secucs'
/def secucs = /run_path -d'n;e;2 n'

/def csaki = /run_path -d'2 e;n' -t'akashia' -w's' -b'akics'
/def akics = /run_path -d's;2 w'

/def csfed = /fr_cs%; /to_neckbreaker%; /run_path -d'5 n;4 w;n;enter;portal;W;N;stairs' -b'fedcs' -t'fedaykin'
/def fedcs = /run_path -d'd;S;E;e;portal;out;4 e;4 s'%; /fr_neckbreaker%; /to_cs
/def fedga = \
  /if (bag) \
    /let _get=get all to bag of holding;get all%; \
  /else \
    /let _get=get all%; \
  /endif%; \
  /run_path -d'n;%{_get};n;%{_get};n;%{_get};n;%{_get};n;%{_get};n;%{_get};n;%{_get};n;%{_get};n;%{_get};n;%{_get};n;%{_get};se;%{_get};n;%{_get};e;%{_get};se;%{_get};s;%{_get};s;%{_get};N;%{_get};e;%{_get};e;%{_get};se;%{_get};sw;%{_get};se;%{_get};n;%{_get};N;%{_get};e;%{_get};e;%{_get};e;%{_get};s;%{_get};w;%{_get};s;%{_get};se;%{_get};s;%{_get};s;%{_get};s;%{_get};w;%{_get};w;%{_get};n;%{_get};w;%{_get};s;%{_get};w;%{_get};n;%{_get};w;%{_get};w;%{_get};w;%{_get};s;%{_get};e;%{_get};ne;se;E;N;nw;N;W;S;S' -b'fedcs'

/def csgiant = /fr_cs%; /to_angarock
/def giantcs = /fr_angarock%; /to_cs
/def giantga = \
  /if (bag) \
    /let _get=get all to bag of holding;get all%; \
  /else \
    /let _get=get all%; \
  /endif%; \
  /run_path -d'ne;e;ne;e;%{_get};e;%{_get};2 w;sw;w;nw;ne;%{_get};ne;%{_get};n;%{_get};e;ne;%{_get};w;n;%{_get};w;%{_get};ne;nw;%{_get};se;s;ne;%{_get};e;%{_get};w;sw;s;e;sw;w;s;2 sw;w;nw;%{_get};nw;2 n;%{_get};2 s;2 se;s;se' -b'giantcs'

/def csyra = /fr_cs%; /to_yellowtower%; /run_path -d'stairs;search statue;spin statue' -b'yracs' -t'yramas' -w's'
/def yracs = /run_path -d's;stairs'%; /fr_yellowtower%; /to_cs

/def csmt = /fr_cs%; /to_keep%; /run_path -d'2 n;e;2 n;u;w;n;w;n' -t'teacher' -w's' -b'mtcs'
/def mtcs = /run_path -d's;e;s;e;d;2 s;w;2 s'%; /fr_keep%; /to_cs

/def csbry = /fr_cs%; /to_uhruul%; /run_path -d'enter;3 d;2 w;4 sw;3 s;e;ne;open east gate;e' -b'brycs' -t'brynolf' -w'w'
/def brycs = /run_path -d'open west gate;w;close east gate;sw;w;3 n;4 ne;2 e;3 u;out'%; /fr_uhruul%; /to_cs

/def allga = \
  /fr_cs%; \
  /to_neckbreaker%; \
  /run_path -d'5 n;4 w;n;enter;portal;W;N;stairs'%; \
  /fedga%; \
  /run_path -d'd;S;E;e;portal;out;4 e;4 s'%; \
  /fr_neckbreaker%; \
  /to_angarock%; \
  /giantga%; \
  /fr_angarock%; \
  /to_greenlight%; \
  /run_path -d'3 n;w;2 n;w;staircase'%; \
  /glga%; \
  /run_path -d'd;e;2 s;e;3 s'%; \
  /fr_greenlight%; \
  /to_cs

;;
;; DESPAIR
;;

/def to_cs = /run_path -d'9 e' -b'fr_cs' -n'cs'
/def fr_cs = /run_path -d'9 w' -b'to_cs' -n'9w'
/def to_angarock = /run_path -d'9 nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;n;nw;n;nw;valley' -b'fr_angarock' -n'angarock'
/def fr_angarock = /run_path -d'out;se;s;se;s;se;s;2 se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;9 se' -b'to_cs' -n'9w'
/def to_angnor = /run_path -d'8 sw;w;3 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;forest' -b'fr_angnor' -n'angnor'
/def fr_angnor = /run_path -d'out;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;3 ne;e;8 ne' -b'to_cs' -n'9w'
/def to_azynya = /run_path -d'7 s;6 se;2 s;4 se;17 s;se;s;se;valley' -b'fr_azynya' -n'azynya'
/def fr_azynya = /run_path -d's;nw;n;nw;17 n;4 nw;2 n;6 nw;7 n' -b'to_cs' -n'9w'
/def to_barracks = /run_path -d'7 s;se;s;se;sw' -b'fr_barracks' -n'barracks'
/def fr_barracks = /run_path -d'ne;nw;n;nw;7 n' -b'to_cs' -n'9w'
/def to_bluetower = /run_path -d'8 ne;3 n;17 ne;n;ne;tower' -b'fr_bluetower' -n'bluetower'
/def fr_bluetower = /run_path -d'out;sw;s;17 sw;3 s;8 sw' -b'to_cs' -n'9w'
/def to_bog = /run_path -d'6 w;sw;6 w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;2 w;3 sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;path' -b'fr_bog' -n'bog'
/def fr_bog = /run_path -d'path;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;3 ne;2 e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;6 e;ne;6 e' -b'to_cs' -n'9w'
/def to_brownietree = /run_path -d'2 se;4 e;se;e;3 se;2 e;tree' -b'fr_brownietree' -n'brownietree'
/def fr_brownietree = /run_path -d'out;2 w;3 nw;w;nw;4 w;2 nw' -b'to_cs' -n'9w'
/def to_broxima = /run_path -d'5 n;ne;n;ne;n;ne;n' -b'fr_broxima' -n'broxima'
/def fr_broxima = /run_path -d's;sw;s;sw;s;sw;5 s' -b'to_cs' -n'9w'
/def to_castle = /run_path -d'2 se;9 e;se;e' -b'fr_castle' -n'castle'
/def fr_castle = /run_path -d'w;nw;9 w;2 nw' -b'to_cs' -n'9w'
/def to_caveofuhruul = /run_path -d'15 s;2 se;s;sw;4 se;cave' -b'fr_caveofuhruul' -n'caveofuhruul'
/def fr_caveofuhruul = /run_path -d'out;4 nw;ne;n;2 nw;15 n' -b'to_cs' -n'9w'
/def to_circus = /run_path -d'2 se;9 e;ne;5 e;se;circus' -b'fr_circus' -n'circus'
/def fr_circus = /run_path -d'leave;nw;5 w;sw;9 w;2 nw' -b'to_cs' -n'9w'
/def to_cliff = /run_path -d'11 n;15 nw;4 ne;7 n;8 ne;e;ne;cliff' -b'fr_cliff' -n'cliff'
/def fr_cliff = /run_path -d'out;sw;w;8 sw;7 s;4 sw;15 se;11 s' -b'to_cs' -n'9w'
/def to_cloudcity = /run_path -d'9 nw;w;nw;enter' -b'fr_cloudcity' -n'cloudcity'
/def fr_cloudcity = /run_path -d'out;se;e;9 se' -b'to_cs' -n'9w'
/def to_concordia = /run_path -d'2 se;9 e;ne;6 e;ne;e;e' -b'fr_concordia' -n'concordia'
/def fr_concordia = /run_path -d'w;w;sw;6 w;sw;9 w;2 nw' -b'to_cs' -n'9w'
/def to_cornfields = /run_path -d's;sw;s;sw;s;sw;s;sw;fields' -b'fr_cornfields' -n'cornfields'
/def fr_cornfields = /run_path -d'w;ne;n;ne;n;ne;n;ne;n' -b'to_cs' -n'9w'
/def to_damora = /run_path -d'8 sw;w;20 sw;2 sw;w;sw;w;4 sw;w;sw;swamps' -b'fr_damora' -n'damora'
/def fr_damora = /run_path -d'out;ne;e;4 ne;e;ne;e;2 ne;20 ne;e;8 ne' -b'to_cs' -n'9w'
/def to_darkwater = /run_path -d'12 nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;n;nw;n;nw;enter' -b'fr_darkwater' -n'darkwater'
/def fr_darkwater = /run_path -d'out;se;s;se;s;se;s;2 se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;2 se;s;se;s;12 se' -b'to_cs' -n'9w'
/def to_desertrangers = /run_path -d'16 s;2 se;sw;5 se;13 s;enter' -b'fr_desertrangers' -n'desertrangers'
/def fr_desertrangers = /run_path -d'out;13 n;5 nw;ne;2 nw;16 n' -b'to_cs' -n'9w'
/def to_ddocks = /run_path -d'7 s;6 se;2 s;4 se;19 s;se;s;se;s;se;docks' -b'fr_ddocks' -n'ddocks'
/def fr_ddocks = /run_path -d'exit;nw;n;nw;n;nw;19 n;4 nw;2 n;6 nw;7 n' -b'to_cs' -n'9w'
/def to_dktower = /run_path -d'18 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;tower' -b'fr_dktower' -n'dktower'
/def fr_dktower = /run_path -d'out;se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;18 se' -b'to_cs' -n'9w'
/def to_dragons = /run_path -d'5 w;3 nw;5 w;3 nw;20 w;4 w;2 nw;2 w;nw;6 w;sw;3 w;sw;w;sw;w;sw;path' -b'fr_dragons' -n'dragons'
/def fr_dragons = /run_path -d'out;ne;e;ne;e;ne;3 e;ne;6 e;se;2 e;2 se;4 e;20 e;3 se;5 e;3 se;5 e' -b'to_cs' -n'9w'
/def to_druids = /run_path -d'6 w;sw;7 w;sw;3 w;sw;w;sw;w;sw;path' -b'fr_druids' -n'druids'
/def fr_druids = /run_path -d'path;ne;e;ne;e;ne;3 e;ne;7 e;ne;6 e' -b'to_cs' -n'9w'
/def to_dryads = /run_path -d'2 se;3 e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;se;path' -b'fr_dryads' -n'dryads'
/def fr_dryads = /run_path -d'path;nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;3 w;2 nw' -b'to_cs' -n'9w'
/def to_dusk = /run_path -d'2 ne;e;ne;e;ne;e;ne;path' -b'fr_dusk' -n'dusk'
/def fr_dusk = /run_path -d'e;sw;w;sw;w;sw;w;2 sw' -b'to_cs' -n'9w'
/def to_dwarfvalley = /run_path -d'2 se;3 e;se;e;se;e;se;valley' -b'fr_dwarfvalley' -n'dwarfvalley'
/def fr_dwarfvalley = /run_path -d'hills;nw;w;nw;w;nw;3 w;2 nw' -b'to_cs' -n'9w'
/def to_ebon = /run_path -d'8 n;nw;n;2 nw;n;nw;n;nw;n;nw;e' -b'fr_ebon' -n'ebon'
/def fr_ebon = /run_path -d'w;se;s;se;s;se;s;2 se;s;se;8 s' -b'to_cs' -n'9w'
/def to_erinia = /run_path -d'3 sw;w;2 sw;w;sw;2 w;3 sw;w;sw;w;sw;w;2 sw;w;sw;w;4 sw;w;11 sw;10 w;2 sw;w;sw;w;sw;w;sw;road' -b'fr_erinia' -n'erinia'
/def fr_erinia = /run_path -d's;ne;e;ne;e;ne;e;2 ne;10 e;11 ne;e;4 ne;e;ne;e;2 ne;e;ne;e;ne;e;3 ne;2 e;ne;e;2 ne;e;3 ne' -b'to_cs' -n'9w'
/def to_fantasy = /run_path -d'4 s;sw;s;sw;s;sw;s;2 sw;s;sw;s;sw;s;2 sw;s;sw;s;2 sw;s;sw;s;sw;s;sw;opening' -b'fr_fantasy' -n'fantasy'
/def fr_fantasy = /run_path -d'forest;ne;n;ne;n;ne;n;2 ne;n;ne;n;2 ne;n;ne;n;ne;n;2 ne;n;ne;n;ne;n;ne;4 n' -b'to_cs' -n'9w'
/def to_farm = /run_path -d'3 nw;village' -b'fr_farm' -n'farm'
/def fr_farm = /run_path -d'fields;3 se' -b'to_cs' -n'9w'
/def to_fields = /run_path -d'2 ne;12 e;ne;se;2 e;field' -b'fr_fields' -n'fields'
/def fr_fields = /run_path -d'leave;2 w;nw;sw;12 w;2 sw' -b'to_cs' -n'9w'
/def to_forestrangers = /run_path -d'6 w;sw;7 w;sw;5 w;4 sw;6 w;sw;w;sw;enter' -b'fr_forestrangers' -n'forestrangers'
/def fr_forestrangers = /run_path -d'out;ne;e;ne;6 e;4 ne;5 e;ne;7 e;ne;6 e' -b'to_cs' -n'9w'
/def to_goblins = /run_path -d'4 se;e;se;path' -b'fr_goblins' -n'goblins'
/def fr_goblins = /run_path -d'path;nw;w;4 nw' -b'to_cs' -n'9w'
/def to_tirith = /run_path -d'2 se;5 e;4 se;6 e;se;e;se;city' -b'fr_tirith' -n'tirith'
/def fr_tirith = /run_path -d'fields;nw;w;nw;6 w;4 nw;5 w;2 nw' -b'to_cs' -n'9w'
/def to_greenlight = /run_path -d'20 nw;20 nw;4 nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;castle' -b'fr_greenlight' -n'greenlight'
/def fr_greenlight = /run_path -d's;se;e;se;e;se;e;2 se;e;se;e;2 se;e;4 se;20 se;20 se' -b'to_cs' -n'9w'
/def to_greentower = /run_path -d'20 nw;tower' -b'fr_greentower' -n'greentower'
/def fr_greentower = /run_path -d'out;20 se' -b'to_cs' -n'9w'
/def to_greyhawk = /run_path -d'6 w;sw;w;nw;n;enter' -b'fr_greyhawk' -n'greyhawk'
/def fr_greyhawk = /run_path -d'out;s;se;e;ne;6 e' -b'to_cs' -n'9w'
/def to_harbour = /run_path -d'2 ne;10 e;2 ne;e;ne;e;ne;e;ne;village' -b'fr_harbour' -n'harbour'
/def fr_harbour = /run_path -d'w;sw;w;sw;w;sw;w;2 sw;10 w;2 sw' -b'to_cs' -n'9w'
/def to_hemlock = /run_path -d'8 sw;w;15 sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;forest' -b'fr_hemlock' -n'hemlock'
/def fr_hemlock = /run_path -d'road;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;15 ne;e;8 ne' -b'to_cs' -n'9w'
/def to_hillside = /run_path -d'16 n;2 nw;n;nw;n;nw;n;nw;hillside' -b'fr_hillside' -n'hillside'
/def fr_hillside = /run_path -d'w;se;s;se;s;se;s;2 se;16 s' -b'to_cs' -n'9w'
/def to_hor = /run_path -d'4 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;4 nw;2 w;nw;w;nw;w;nw;w;5 nw;3 w;path' -b'fr_hor' -n'hor'
/def fr_hor = /run_path -d'out;3 e;5 se;e;se;e;se;e;se;2 e;4 se;e;se;e;se;e;2 se;e;se;e;se;e;4 se' -b'to_cs' -n'9w'
/def to_keep = /run_path -d'14 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;woods' -b'fr_keep' -n'keep'
/def fr_keep = /run_path -d's;se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;14 se' -b'to_cs' -n'9w'
/def to_kevins = /run_path -d'6 w;sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;climb' -b'fr_kevins' -n'kevins'
/def fr_kevins = /run_path -d'climb;ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;6 e' -b'to_cs' -n'9w'
/def to_maester = /run_path -d'11 n;15 nw;5 ne;n;ne;n;ne;path' -b'fr_maester' -n'maester'
/def fr_maester = /run_path -d'path;sw;s;sw;s;5 sw;15 se;11 s' -b'to_cs' -n'9w'
/def to_malbeth = /run_path -d'5 w;3 nw;5 w;3 nw;18 w;path' -b'fr_malbeth' -n'malbeth'
/def fr_malbeth = /run_path -d'n;18 e;3 se;5 e;3 se;5 e' -b'to_cs' -n'9w'
/def to_manor = /run_path -d'5 w;3 nw;w;11 nw;2 w;nw;9 w;nw;w;nw;valley' -b'fr_manor' -n'manor'
/def fr_manor = /run_path -d'uphill;se;e;se;9 e;se;2 e;11 se;e;3 se;5 e' -b'to_cs' -n'9w'
/def to_mansion = /run_path -d'14 s;enter' -b'fr_mansion' -n'mansion'
/def fr_mansion = /run_path -d'out;14 n' -b'to_cs' -n'9w'
/def to_pirateisland = /to_medo
/def fr_pirateisland = /fr_medo
/def to_medo = /run_path -d'16 s;2 se;sw;5 se;17 s;portal' -b'fr_medo' -n'medo'
/def fr_medo = /run_path -d'leave;17 n;5 nw;ne;2 nw;16 n' -b'to_cs' -n'9w'
/def to_megadeath = /run_path -d'8 ne;3 n;13 ne' -b'fr_megadeath' -n'megadeath'
/def fr_megadeath = /run_path -d'13 sw;3 s;8 sw' -b'to_cs' -n'9w'
/def to_mines = /run_path -d'2 se;9 e;ne;2 e;s' -b'fr_mines' -n'mines'
/def fr_mines = /run_path -d'out;2 w;sw;9 w;2 nw' -b'to_cs' -n'9w'
/def to_mountain = /run_path -d'5 w;3 nw;7 w;nw;w' -b'fr_mountain' -n'mountain'
/def fr_mountain = /run_path -d'e;se;7 e;3 se;5 e' -b'to_cs' -n'9w'
/def to_mountainrangers = /run_path -d'3 w;2 sw;w;sw;w;2 sw;w;4 sw;3 w;9 sw;w;11 sw;7 w;nw;w;nw;enter' -b'fr_mountainrangers' -n'mountainrangers'
/def fr_mountainrangers = /run_path -d'out;se;e;se;7 e;11 ne;e;9 ne;3 e;4 ne;e;2 ne;e;ne;e;2 ne;3 e' -b'to_cs' -n'9w'
/def to_mystery = /run_path -d'3 w;nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;7 w;nw;2 n;ne;e' -b'fr_mystery' -n'mystery'
/def fr_mystery = /run_path -d'w;sw;2 s;se;7 e;se;e;se;e;2 se;e;se;e;se;e;se;3 e' -b'to_cs' -n'9w'
/def to_neckbreaker = /run_path -d'6 w;sw;7 w;sw;8 w;2 nw;11 w;sw;path' -b'fr_neckbreaker' -n'neckbreaker'
/def fr_neckbreaker = /run_path -d's;ne;11 e;2 se;8 e;ne;7 e;ne;6 e' -b'to_cs' -n'9w'
/def to_oasis = /run_path -d'16 s;3 sw;15 s;sw;path' -b'fr_oasis' -n'oasis'
/def fr_oasis = /run_path -d'leave;ne;15 n;3 ne;16 n' -b'to_cs' -n'9w'
/def to_obizuth = /run_path -d'20 nw;12 nw;n;2 nw;n;nw;n;nw;n;nw;path' -b'fr_obizuth' -n'obizuth'
/def fr_obizuth = /run_path -d'leave;se;s;se;s;se;s;2 se;s;12 se;20 se' -b'to_cs' -n'9w'
/def to_orodruin = /run_path -d'11 se;3 e;se;2 e;se;e;se;s;sw;se;mountain' -b'fr_orodruin' -n'orodruin'
/def fr_orodruin = /run_path -d'plains;nw;ne;n;nw;w;nw;2 w;nw;3 w;11 nw' -b'to_cs' -n'9w'
/def to_outpost = /run_path -d'2 s;se;s;se;s;2 se;s;se;s;2 se;s;se;s;se;s;se;gate' -b'fr_outpost' -n'outpost'
/def fr_outpost = /run_path -d'gate;nw;n;nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;n;nw;2 n' -b'to_cs' -n'9w'
/def to_pyramid = /run_path -d'16 s;2 sw;se;19 s;se;pyramid' -b'fr_pyramid' -n'pyramid'
/def fr_pyramid = /run_path -d'leave;nw;19 n;nw;2 ne;16 n' -b'to_cs' -n'9w'
/def to_rangers = /run_path -d'8 s;sw;s;sw;s;2 sw;s;sw;s;sw;s;sw;forest' -b'fr_rangers' -n'rangers'
/def fr_rangers = /run_path -d'se;ne;n;ne;n;ne;n;2 ne;n;ne;n;ne;8 n' -b'to_cs' -n'9w'
/def to_ravenloft = /run_path -d'16 s;2 se;sw;3 s;se;s' -b'fr_ravenloft' -n'ravenloft'
/def fr_ravenloft = /run_path -d'n;nw;3 n;ne;2 nw;16 n' -b'to_cs' -n'9w'
/def to_redtower = /run_path -d'7 se;7 s;3 se;e;2 se;e;se;e;2 se;e;se;e;se;e;se;tower' -b'fr_redtower' -n'redtower'
/def fr_redtower = /run_path -d'out;nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;3 nw;7 n;7 nw' -b'to_cs' -n'9w'
/def to_saurus = /run_path -d'8 ne;3 n;3 ne;path' -b'fr_saurus' -n'saurus'
/def fr_saurus = /run_path -d'path;3 sw;3 s;8 sw' -b'to_cs' -n'9w'
/def to_savannah = /run_path -d'4 s;se;s;2 se;s;se;s;2 se;s;se;s;3 se;2 s;se;s;se;s;2 se;s;se;s;se;s;se;path' -b'fr_savannah' -n'savannah'
/def fr_savannah = /run_path -d'out;nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;2 n;3 nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;4 n' -b'to_cs' -n'9w'
/def to_sirros = /run_path -d'5 w;3 nw;5 w;3 nw;11 w;nw;w;nw;w;nw;w;2 nw;w;nw;trail' -b'fr_sirros' -n'sirros'
/def fr_sirros = /run_path -d'path;se;e;2 se;e;se;e;se;e;se;11 e;3 se;5 e;3 se;5 e' -b'to_cs' -n'9w'
/def to_stargrove = /run_path -d'6 w;sw;7 w;sw;3 w;sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;forest' -b'fr_stargrove' -n'stargrove'
/def fr_stargrove = /run_path -d's;ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;3 e;ne;7 e;ne;6 e' -b'to_cs' -n'9w'
/def to_temple = /run_path -d'3 sw;w;2 sw;w;2 sw;w;sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;4 sw;w;11 sw;2 nw;w;nw;n' -b'fr_temple' -n'temple'
/def fr_temple = /run_path -d's;se;e;2 se;11 ne;e;4 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;ne;e;2 ne;e;2 ne;e;3 ne' -b'to_cs' -n'9w'
/def to_terray = /run_path -d'8 sw;w;11 sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;3 w;4 sw;valley' -b'fr_terray' -n'terray'
/def fr_terray = /run_path -d'out;4 ne;3 e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;11 ne;e;8 ne' -b'to_cs' -n'9w'
/def to_towanda = /run_path -d'5 w;3 nw;2 w;nw;w;2 nw;w;nw;w;nw;w;nw;w' -b'fr_towanda' -n'towanda'
/def fr_towanda = /run_path -d'e;se;e;se;e;se;e;2 se;e;se;2 e;3 se;5 e' -b'to_cs' -n'9w'
/def to_turre = /run_path -d'9 n;2 ne;n;ne;n;2 ne;n;forest' -b'fr_turre' -n'turre'
/def fr_turre = /run_path -d'out;s;2 sw;s;sw;s;2 sw;9 s' -b'to_cs' -n'9w'
/def to_tyrir = /run_path -d'4 w;sw;w;4 sw;w;4 sw;5 w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;w' -b'fr_tyrir' -n'tyrir'
/def fr_tyrir = /run_path -d'e;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;5 e;4 ne;e;4 ne;e;ne;4 e' -b'to_cs' -n'9w'
/def to_uhruul = /run_path -d'7 se;s;se;s;se;s;se;s' -b'fr_uhruul' -n'uhruul'
/def fr_uhruul = /run_path -d'n;nw;n;nw;n;nw;n;7 nw' -b'to_cs' -n'9w'
/def to_island = /to_varalor
/def fr_island = /fr_varalor
/def fr_varalor = /run_path -d'out;sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;6 sw' -b'to_cs' -n'9w'
/def to_varalor = /run_path -d'6 ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;ne;portal' -b'fr_varalor' -n'varalor'
/def to_village = /run_path -d'n;2 ne;n;ne;n;ne;n;ne;village' -b'fr_village' -n'village'
/def fr_village = /run_path -d'leave;sw;s;sw;s;sw;s;2 sw;s' -b'to_cs' -n'9w'
/def to_vorlonmines = /run_path -d'16 s;2 se;sw;5 se;s;sw;w' -b'fr_vorlonmines' -n'vorlonmines'
/def fr_vorlonmines = /run_path -d'e;ne;n;5 nw;ne;2 nw;16 n' -b'to_cs' -n'9w'
/def to_wiztower = /run_path -d'5 w;3 nw;5 w;3 nw;w;sw;s' -b'fr_wiztower' -n'wiztower'
/def fr_wiztower = /run_path -d'n;ne;e;3 se;5 e;3 se;5 e' -b'to_cs' -n'9w'
/def to_wolfcity = /run_path -d'9 nw;w;nw;w;nw;w;2 nw;w;nw;3 w;4 nw;w;nw;e' -b'fr_wolfcity' -n'wolfcity'
/def fr_wolfcity = /run_path -d'w;se;e;4 se;3 e;se;e;2 se;e;se;e;se;e;9 se' -b'to_cs' -n'9w'
/def to_yellowtower = /run_path -d'8 sw;w;11 sw;s;sw;tower' -b'fr_yellowtower' -n'yellowtower'
/def fr_yellowtower = /run_path -d'out;ne;n;11 ne;e;8 ne' -b'to_cs' -n'9w'

;;
;; MELLARNIA
;;

/def to_abjurersgrove = /run_path -d'11 w;3 nw;sw;grove' -b'fr_abjurersgrove' -n'abjurersgrove'
/def fr_abjurersgrove = /run_path -d's;ne;3 se;11 e' -n'erenia'
/def to_abjurerstower = /run_path -d'10 w;sw;tower' -b'fr_abjurerstower' -n'abjurerstower'
/def fr_abjurerstower = /run_path -d'se;ne;10 e' -n'erenia'
/def to_dowdcastle = /run_path -d'13 nw;w;11 nw;w;nw;4 w;7 nw;9 w;nw;w;nw;w;5 nw;w;nw;3 w;nw;w;nw;enter' -b'fr_dowdcastle' -n'dowdcastle'
/def fr_dowdcastle = /run_path -d's;se;e;se;3 e;se;e;5 se;e;se;e;se;9 e;7 se;4 e;se;e;11 se;e;13 se' -n'erenia'
/def to_goblinswamps = /run_path -d'20 nw;13 nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;n;2 nw;n;ne' -b'fr_goblinswamps' -n'goblinswamps'
/def fr_goblinswamps = /run_path -d'sw;s;2 se;s;se;s;2 se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;se;s;13 se;20 se' -n'erenia'
/def to_healer = /run_path -d'4 n;2 nw;10 n;nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;4 n;nw;n;5 nw;n;2 nw;n;nw;n;2 nw;n;nw;n;nw;n;2 nw;n;nw;n;2 nw;n;nw;3 n;nw;w;spring' -b'fr_healer' -n'healer'
/def fr_healer = /run_path -d'nw;e;se;3 s;se;s;2 se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;2 se;s;5 se;s;se;4 s;2 se;s;se;s;se;s;2 se;s;se;s;se;s;2 se;s;se;s;se;10 s;2 se;4 s' -n'erenia'
/def to_isthmas = /run_path -d'4 n;2 ne;6 n;nw;2 n;ne;n;ne;path' -b'fr_isthmas' -n'isthmas'
/def fr_isthmas = /run_path -d'out;sw;s;sw;2 s;se;6 s;2 sw;4 s' -n'erenia'
;/def to_mellarnia = /run_path -d'sw;enter' -b'fr_mellarnia' -n'mellarnia'
;/def fr_mellarnia = /run_path -d'out;ne' -n'erenia'
/def to_royaloakinn = /run_path -d'4 n;2 ne;6 n;nw;18 n;2 ne;n;ne;2 n;ne;n;2 ne;3 n;nw;inn' -b'fr_royaloakinn' -n'royaloakinn'
/def fr_royaloakinn = /run_path -d'leave;se;3 s;2 sw;s;sw;2 s;sw;s;2 sw;18 s;se;6 s;2 sw;4 s' -n'erenia'
/def to_shaolin = /run_path -d'8 w;11 nw;w;3 nw;3 w;3 sw;s;sw;11 w;8 sw;w;sw;w;sw;2 w;sw;3 w;sw;2 w;sw;2 w;sw;4 w;sw;4 w;2 sw;s;entrance' -b'fr_shaolin' -n'shaolin'
/def fr_shaolin = /run_path -d'out;n;2 ne;4 e;ne;4 e;ne;2 e;ne;2 e;ne;3 e;ne;2 e;ne;e;ne;e;8 ne;11 e;ne;n;3 ne;3 e;3 se;e;11 se;8 e' -n'erenia'
/def to_mephala = /run_path -d'12 nw;w;12 nw;w;nw;4 w;7 nw;9 w;nw;w;nw;w;5 nw;w;nw;3 w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;2 w;nw;w;4 nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;2 w;3 nw;w;nw;w;nw;w;nw;forest' -b'fr_mephala' -n'mephala'
/def fr_mephala = /run_path -d's;se;e;se;e;se;e;3 se;2 e;2 se;e;se;e;se;e;2 se;e;se;e;4 se;e;se;2 e;se;e;se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;3 e;se;e;5 se;e;se;e;se;9 e;7 se;4 e;se;e;12 se;e;12 se' -n'erenia'
/def to_pagoda = /run_path -d'8 w;11 nw;w;3 nw;3 w;3 sw;s;sw;19 w;nw;2 w;nw;2 w;3 sw;forest' -b'fr_pagoda' -n'pagoda'
/def fr_pagoda = /run_path -d'out;3 ne;2 e;se;2 e;se;19 e;ne;n;3 ne;3 e;3 se;e;11 se;8 e' -n'erenia'

;;
;; CANTADOR
;;

/def to_rk = /run_path -d'3 s;2 e;6 s;2 w' -b'fr_rk' -n'rk'
/def fr_rk = /run_path -d'2 e;6 n;2 w;3 n' -b'to_rk' -n'1n'
/def to_anarforest = /run_path -d'20 w;20 w;12 w;nw;w;nw;w;sw;17 w;nw;w;nw;w;nw;w;nw;enter' -b'fr_anarforest' -n'anarforest'
/def fr_anarforest = /run_path -d'exit;se;e;se;e;se;e;se;17 e;ne;e;se;e;se;12 e;20 e;20 e' -b'to_rk' -n'1n'
/def to_areack = /run_path -d'4 w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;3 sw;w;sw;2 w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;6 sw;4 w;sw;w;2 sw;5 w;3 s;sw;2 w;2 sw;w;2 sw;w;sw;w;sw;w;sw;w;sw;w;sw;w;sw;mountains' -b'fr_areack' -n'areack'
/def fr_areack = /run_path -d'leave;ne;e;ne;e;ne;e;ne;e;ne;e;ne;e;2 ne;e;2 ne;2 e;ne;3 n;5 e;2 ne;e;ne;4 e;6 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;2 e;ne;e;3 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;4 e' -b'to_rk' -n'1n'
/def to_blackmines = /run_path -d'20 w;20 w;10 sw;4 w;nw;8 n;n' -b'fr_blackmines' -n'blackmines'
/def fr_blackmines = /run_path -d's;8 s;se;4 e;10 ne;20 e;20 e' -b'to_rk' -n'1n'
/def to_cdocks = /run_path -d'18 n;nw;2 n;nw;n;nw;docks' -b'fr_cdocks' -n'cdocks'
/def fr_cdocks = /run_path -d'exit;se;s;se;2 s;se;18 s' -b'to_rk' -n'1n'
/def to_dream = /run_path -d'20 w;6 w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;enter' -b'fr_dream' -n'dream'
/def fr_dream = /run_path -d'out;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;6 e;20 e' -b'to_rk' -n'1n'
/def to_clearing = /to_fireplane
/def fr_clearing = /fr_fireplane
/def to_fireplane = /run_path -d'9 n;nw;clearing' -b'fr_fireplane' -n'fireplane'
/def fr_fireplane = /run_path -d'out;se;9 s' -b'to_rk' -n'1n'
/def to_frozenplain = /run_path -d'w;12 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;10 w;3 s;7 sw;w;sw;w;sw;w;sw;enter' -b'fr_frozenplain' -n'frozenplain'
/def fr_frozenplain = /run_path -d'out;ne;e;ne;e;ne;e;7 ne;3 n;10 e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;12 ne;e' -b'to_rk' -n'1n'
/def to_gaydesert = /run_path -d'20 w;20 w;w;7 nw;3 w;nw;2 w;nw;2 w;3 nw;15 w;nw;w;nw;enter' -b'fr_gaydesert' -n'gaydesert'
/def fr_gaydesert = /run_path -d'out;se;e;se;15 e;3 se;2 e;se;2 e;se;3 e;7 se;e;20 e;20 e' -b'to_rk' -n'1n'
/def to_gnomeoutpost = /run_path -d'4 e;ne;e;ne;e;ne;e;ne;camp' -b'fr_gnomeoutpost' -n'gnomeoutpost'
/def fr_gnomeoutpost = /run_path -d'out;sw;w;sw;w;sw;w;sw;4 w' -b'to_rk' -n'1n'
/def to_grimhildr = /run_path -d'w;13 sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;11 w;3 s;8 sw;w;sw;w;2 sw;w;sw;4 w;sw;se;enter' -b'fr_grimhildr' -n'grimhildr'
/def fr_grimhildr = /run_path -d'leave;nw;ne;4 e;ne;e;2 ne;e;ne;e;8 ne;3 n;11 e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;13 ne;e' -b'to_rk' -n'1n'
/def to_highwall = /run_path -d'20 w;20 w;12 w;nw;w;nw;w;sw;ruins' -b'fr_highwall' -n'highwall'
/def fr_highwall = /run_path -d'out;ne;e;se;e;se;12 e;20 e;20 e' -b'to_rk' -n'1n'
/def to_hunters = /run_path -d'20 w;20 w;10 sw;18 w;sw;w;sw;w;sw;forest' -b'fr_hunters' -n'hunters'
/def fr_hunters = /run_path -d'leave;ne;e;ne;e;ne;18 e;10 ne;20 e;20 e' -b'to_rk' -n'1n'
/def to_hut = /run_path -d'20 w;2 w;sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;w;hut' -b'fr_hut' -n'hut'
/def fr_hut = /run_path -d'exit;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;2 ne;e;ne;e;ne;e;ne;2 e;20 e' -b'to_rk' -n'1n'
/def to_ironledge = /run_path -d'w;20 sw;14 sw;6 w;2 s;9 sw;s;sw;gates' -b'fr_ironledge' -n'ironledge'
/def fr_ironledge = /run_path -d'leave;ne;n;9 ne;2 n;6 e;14 ne;20 ne;e' -b'to_rk' -n'1n'
/def to_kriesha = /run_path -d'3 w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;enter' -b'fr_kriesha' -n'kriesha'
/def fr_kriesha = /run_path -d'leave;se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;3 e' -b'to_rk' -n'1n'
/def to_minetrail = /run_path -d'20 w;20 w;12 w;nw;w;nw;w;5 sw;trail' -b'fr_minetrail' -n'minetrail'
/def fr_minetrail = /run_path -d'hills;5 ne;e;se;e;se;12 e;20 e;20 e' -b'to_rk' -n'1n'
/def to_mistwalkers = /run_path -d'w;sw;8 s;se;enter' -b'fr_mistwalkers' -n'mistwalkers'
/def fr_mistwalkers = /run_path -d'forest;nw;8 n;ne;e' -b'to_rk' -n'1n'
/def to_prison = /run_path -d'18 w;nw;w;nw;w;nw;w;nw;prison' -b'fr_prison' -n'prison'
/def fr_prison = /run_path -d'out;se;e;se;e;se;e;se;18 e' -b'to_rk' -n'1n'
/def to_river = /run_path -d'20 w;17 w;nw;swim' -b'fr_river' -n'river'
/def fr_river = /run_path -d'swim;se;17 e;20 e' -b'to_rk' -n'1n'
/def to_spiderforest = /run_path -d'6 n;ne;n;ne;n;2 ne;n;ne;n;ne;n;ne;enter' -b'fr_spiderforest' -n'spiderforest'
/def fr_spiderforest = /run_path -d'out;sw;s;sw;s;sw;s;2 sw;s;sw;s;sw;6 s' -b'to_rk' -n'1n'
/def to_stone = /run_path -d'9 w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;nw;w;2 nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;path' -b'fr_stone' -n'stone'
/def fr_stone = /run_path -d'out;se;e;se;e;se;e;2 se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;e;2 se;e;se;e;se;9 e' -b'to_rk' -n'1n'
/def to_teros = /run_path -d'w;2 sw;s;2 sw;s;sw;s;sw;s;2 sw;s;sw;s;sw;s;2 sw;s;sw;s;2 sw;s;sw;s;sw;s;sw;temple' -b'fr_teros' -n'teros'
/def fr_teros = /run_path -d'out;ne;n;ne;n;ne;n;2 ne;n;ne;n;2 ne;n;ne;n;ne;n;2 ne;n;ne;n;ne;n;2 ne;n;2 ne;e' -b'to_rk' -n'1n'
/def to_tree = /run_path -d'w;6 sw;w;sw;w;2 sw;w;sw;w;2 sw;w;sw;w;sw;w;sw;climb' -b'fr_tree' -n'tree'
/def fr_tree = /run_path -d'd;ne;e;ne;e;ne;e;2 ne;e;ne;e;2 ne;e;ne;e;6 ne;e' -b'to_rk' -n'1n'
/def to_wolves = /run_path -d'w;9 sw;w;sw;w;sw;enter' -b'fr_wolves' -n'wolves'
/def fr_wolves = /run_path -d'gate;ne;e;ne;e;9 ne;e' -b'to_rk' -n'1n'
/def to_mindflayer = /run_path -d'20 w;20 w;12 w;nw;w;nw;w;sw;20 w;3 w;nw;w;nw;w;2 nw;w;nw;w;nw;w;nw;w' -b'fr_mindflayer' -n'mindflayer'
/def fr_mindflayer = /run_path -d'e;se;e;se;e;se;e;2 se;e;se;e;se;3 e;20 e;ne;e;se;e;se;12 e;20 e;20 e' -b'to_rk' -n'1n'
