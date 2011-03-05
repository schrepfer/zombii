;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; PALADIN TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-08-29 17:40:24 -0700 (Sun, 29 Aug 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/paladin.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/paladin.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set paladin=1

;;
;; GET PALADIN RANK
;;
;; Usage: /get_paladin_rank LEVEL
;;
/def get_paladin_rank = \
  /if ({1} == 1) \
    /result 500%; \
  /elseif ({1} == 2) \
    /result 1303%; \
  /elseif ({1} == 3) \
    /result 2591%; \
  /elseif ({1} == 4) \
    /result 4660%; \
  /elseif ({1} == 5) \
    /result 7980%; \
  /elseif ({1} == 6) \
    /result 13310%; \
  /elseif ({1} == 7) \
    /result 21867%; \
  /elseif ({1} == 8) \
    /result 35604%; \
  /elseif ({1} == 9) \
    /result 57655%; \
  /elseif ({1} == 10) \
    /result 93054%; \
  /elseif ({1} == 11) \
    /result 149879%; \
  /elseif ({1} == 12) \
    /result 241102%; \
  /elseif ({1} == 13) \
    /result 387542%; \
  /elseif ({1} == 14) \
    /result 622623%; \
  /elseif ({1} == 15) \
    /result 1000000%; \
  /elseif ({1} == 16) \
    /result 1413342%; \
  /elseif ({1} == 17) \
    /result 1866076%; \
  /elseif ({1} == 18) \
    /result 2361957%; \
  /elseif ({1} == 19) \
    /result 2905097%; \
  /elseif ({1} == 20) \
    /result 3500000%; \
  /elseif ({1} == 21) \
    /result 4151598%; \
  /elseif ({1} == 22) \
    /result 4865296%; \
  /elseif ({1} == 23) \
    /result 5647011%; \
  /elseif ({1} == 24) \
    /result 6503225%; \
  /elseif ({1} >= 25) \
    /result 7441038%; \
  /else \
    /result 0%; \
  /endif

;;
;; Inquisitar
;;

/def en = /enlightenment %{*}
/def aog = /armour_of_god %{*}
/def sr = /stun_resistance %{*}
/def mup = /minor_unpain %{*}
/def aa = /ashes_to_ashes %{*}
/def ata = /ashes_to_ashes %{*}
/def a2a = /ashes_to_ashes %{*}
/def wog = /wrath_of_god %{*}
/def de = /dispel_evil %{*}

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_paladin = \
  /test paladin_shield_points_last := paladin_shield_points

/def -Fp5 -mregexp -t'^Rank: (\\d+)(st|nd|rd|th) Rank$' paladin_shield_rank = \
  /set paladin_shield_rank=%{P1}

/def -Fp5 -mregexp -t'^Status points: (\\d+)$' paladin_shield_points = \
  /set paladin_shield_points=%{P1}%; \
  /let _next=$[get_paladin_rank(paladin_shield_rank + 1)]%; \
  /if (_next > paladin_shield_points) \
    /let _need=need $[_next - paladin_shield_points]%; \
  /else \
    /let _need=maxed%; \
  /endif%; \
  /let _delta=$[paladin_shield_points - paladin_shield_points_last]%; \
  /substitute -p -- %{*} (@{B}%{_need}@{n}) [$[_delta >= 0 ? '@{BCgreen}+' : '@{BCred}']%{_delta}@{n}]

/def wu = \
  /mapcar !where \
    zombie \
    ghoul \
    spectre \
    heucuva \
    phantom

;/def -Fp5 -mregexp -t'^(Zombie|Ghoul|Spectre|Heucuva|Phantom): +The ([a-z]+) (wall|guardtower|passage)$' wu_report = \
;;  /test ++wu_$[tolower({P1})]
;;
;Zombie:
;Ghoul:
;Spectre:
;Heucuva:
;Phantom:
;No players in your sight.
;;
;;
;The western wall
;The northwest guardtower
;The northern passage
;The northeast guardtower
;The eastern wall
;The southeast guardtower
;The southern wall
;The southwest guardtower


/def glrun = /run_path -d'N;W;nw;N;ne;E;se;S;sw;W;E;ne;n;E;N;ne;E;se;S;sw;W;nw;se;2 e;S;E;se;S;sw;W;nw;N;ne;E;W;sw;s;W;S;sw;W;nw;N;ne;E;se;nw;2 w;3 n'

/def -Fp5 -msimple -h'SEND @save' save_paladin = /mapcar /listvar paladin_shield_points paladin_shield_rank %| /writefile $[save_dir('paladin')]
/eval /load $[save_dir('paladin')]

/test paladin_shield_points_last := paladin_shield_points_last ? paladin_shield_points_last : paladin_shield_points
