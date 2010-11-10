;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; KILL/UNFAMILIAR BONUS TRACKING
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-08-20 13:59:19 -0700 (Fri, 20 Aug 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/killed.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/killed.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def -Fp5 -mglob -h'SEND @on_enemy_killed *' on_enemy_killed_killed = \
  /let _key=$[strip_attr(textencode({-1}))]%; \
  /test killed_%{_key} := time()%; \
  /set killed=$(/unique %{_key} %{killed})

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_killed = \
  /unset killed

/def killed_worker = \
  /while ({#}) \
    /if (isin({1}, killed)) \
      /let _key=%{1}%; \
      /let _name=$[textdecode(_key)]%; \
      /let _time=$[expr(strcat('killed_', {1}))]%; \
      /let _diff=$[trunc(time() - _time)]%; \
      /if (_diff < 60*60*24) \
        /if (_diff < 60*60*1.75) \
          /let _stars=%; \
        /elseif (_diff < 60*60*2.50) \
          /let _stars=*%; \
        /elseif (_diff < 60*60*3.25) \
          /let _stars=**%; \
        /elseif (_diff < 60*60*4.00) \
          /let _stars=***%; \
        /else \
          /let _stars=****%; \
        /endif%; \
        /echo -aCgreen -p -- | $[pad(_name, 20)] | $[pad(_stars, 4)] | $[pad(to_dhms(_diff), 11)] |%; \
      /endif%; \
    /endif%; \
    /shift%; \
  /done

/def killed = \
  /echo -aCgreen -- .-------------------------------------------.%; \
  /echo -aCgreen -- |                  NPC |      |        TIME |%; \
  /echo -aCgreen -- |----------------------+------+-------------|%; \
  /killed_worker %{*-%{killed}}%; \
  /echo -aCgreen -- '-------------------------------------------'
