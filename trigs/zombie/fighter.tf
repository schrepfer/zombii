;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; FIGHTER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/fighter.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/fighter.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set fighter=1

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_fighter = \
  /stats_mangle reset

; fig commands
/def wos = /wall_of_steel %{*}
/def bc = /battlecry %{*}
/def cl = /charging_lance %{*}
/def db = /dancing_blade %{*}

/def -Fp5 -msimple -t'You gained an offensive point!' gained_offensive_point = \
  /set fighter_points=$[fighter_points + 1]%; \
  @update_status%; \
  !2 pigeon whee%; \
  /say -c'red' -- Gained Fighter OFFENSIVE Point!

/def -Fp5 -msimple -t'You gained a defensive point!' gained_defensive_point = \
  /set fighter_points=$[fighter_points + 1]%; \
  @update_status%; \
  !2 pigeon whee%; \
  /say -c'red' -- Gained Fighter DEFENSIVE Point!

;def -Fp5 -mregexp -t'^Your taunting enrages (.+)\\.$' taunt = \
;  /say -d'party' -c'red' -b -- *taunts %{P1}!*

/def -Fp5 -msimple -t'You bellow in rage and you must kill!' reset_ignores_0 = \
  /set ignores=0%; \
  @update_status

/def -Fp4 -msimple -t'You come out of your berserk!' reset_ignores_1 = \
  /reset_ignores_0

/def -Fp5 -msimple -t'You pray to the gods for more knowledge.' trained_fighter_point = \
  /set fighter_points=$[fighter_points - 1]%; \
  /if (fighter_points < 0) \
    /set fighter_points=0%; \
  /endif%; \
  @update_status

/def -Fp5 -msimple -t'You feel the red mist fading away.' berserk_falling = \
  /say -c'yellow' -- Berserk Falling! (%{ignores} ignore$[ignores == 1 ? '' : 's'])

/def -Fp5 -msimple -t'A seering pain shoots through your body, but you ignore it.' pain_ignored = \
  /set ignores=$[ignores + 1]%; \
  @update_status

/def -Fp5 -mregexp -t'^Defensive:    (\\d+)' defensive_points = \
  /set fighter_points=%{P1}

/def -Fp5 -mregexp -t'^Offensive:    (\\d+)' offensive_points  = \
  /set fighter_points=$[fighter_points + {P1}]

/def -Fp5 -msimple -t'You can\'t use this skill while you or the target is fighting.' bc_combat_fail = \
  /if (is_me(tank)) \
    /say -d'party' -c'red' -b -- :grr%; \
  /endif

/def -Fp20 -msimple -h'SEND @update_status' update_status_20 = \
  /update_status_x [ignores:$[trunc(ignores)],points:$[trunc(fighter_points)]]

/def add_stats_mangle = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _points=%{2-1}%; \
  /let _current=stats_mangle_%{1}%; \
  /test _current := %{_current}%; \
  /set stats_mangle_%{1}=$[_current + _points]%; \
  /let _total=stats_mangle_%{1}_total%; \
  /test _total := %{_total}%; \
  /set stats_mangle_%{1}_total=$[_total + _points]

/def init_stats_mangle = \
  /while ({#}) \
    /set stats_mangle_%{1}=0%; \
    /shift%; \
  /done

/def init_stats_mangle_total = \
  /init_stats_mangle %{*}%; \
  /while ({#}) \
    /init_stats_mangle %{1}_total%; \
    /shift%; \
  /done

/def -Fp5 -mglob -t'You manage to exploit a vulnerable spot in * defence.' stats_mangle_exploit = /add_stats_mangle exploit
/def -Fp5 -mglob -t'You perform a powerful downward swing which lands against *' stats_mangle_powerful_swing = /add_stats_mangle powerful_swing
/def -Fp5 -mglob -t'You operate with dazzling accuracy, cutting an arc shaped wound in *' stats_mangle_dazzling_accuracy = /add_stats_mangle dazzling_accuracy
/def -Fp5 -mglob -t'You dig your axe in * belly, sliding it smoothly through *' stats_mangle_dig = /add_stats_mangle dig
/def -Fp5 -mglob -t'You hack * left shoulder by delivering two fast slashes at it.' stats_mangle_fast_slashes = /add_stats_mangle fast_slashes
/def -Fp5 -mglob -t'Your attack makes * consciousness.' stats_mangle_stun = /add_stats_mangle stun
/def -Fp5 -mglob -t'Your attack interrupts * concentration.' stats_mangle_interrupt = /add_stats_mangle interrupt

/def stats_mangle = \
  /if ({#}) \
    /if ({*} =~ 'reset') \
      /init_stats_mangle \
        exploit \
        dazzling_accuracy \
        powerful_swing \
        dig \
        fast_slashes \
        stun \
        interrupt%; \
      /return%; \
    /elseif ({*} =~ 'reset all') \
      /init_stats_mangle_total \
        exploit \
        dazzling_accuracy \
        powerful_swing \
        dig \
        fast_slashes \
        stun \
        interrupt%; \
      /return%; \
    /endif%; \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen%; \
  /endif%; \
  /let stats_mangle=$[\
       stats_mangle_dazzling_accuracy + \
       stats_mangle_powerful_swing + \
       stats_mangle_dig + \
       stats_mangle_fast_slashes]%; \
  /let stats_mangle_total=$[\
       stats_mangle_dazzling_accuracy_total + \
       stats_mangle_powerful_swing_total + \
       stats_mangle_dig_total + \
       stats_mangle_fast_slashes_total]%; \
  /execute %{_cmd} .-------------------------------------------------------------------.%; \
  /execute %{_cmd} | Mangle Statistics:                                                |%; \
  /execute %{_cmd} |---------------------------.-------------------.-------------------|%; \
  /execute %{_cmd} |                           |      Session      |       Total       |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('powerful swing', -25)] | $[pad(stats_mangle_powerful_swing, 8)] ($[pad(round(stats_mangle_powerful_swing * 100.0 / (stats_mangle ? stats_mangle : 1), 1), 5)]%%) | $[pad(stats_mangle_powerful_swing_total, 8)] ($[pad(round(stats_mangle_powerful_swing_total * 100.0 / (stats_mangle_total ? stats_mangle_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('dazzling accuracy', -25)] | $[pad(stats_mangle_dazzling_accuracy, 8)] ($[pad(round(stats_mangle_dazzling_accuracy * 100.0 / (stats_mangle ? stats_mangle : 1), 1), 5)]%%) | $[pad(stats_mangle_dazzling_accuracy_total, 8)] ($[pad(round(stats_mangle_dazzling_accuracy_total * 100.0 / (stats_mangle_total ? stats_mangle_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('dig belly', -25)] | $[pad(stats_mangle_dig, 8)] ($[pad(round(stats_mangle_dig * 100.0 / (stats_mangle ? stats_mangle : 1), 1), 5)]%%) | $[pad(stats_mangle_dig_total, 8)] ($[pad(round(stats_mangle_dig_total * 100.0 / (stats_mangle_total ? stats_mangle_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('fast slashes', -25)] | $[pad(stats_mangle_fast_slashes, 8)] ($[pad(round(stats_mangle_fast_slashes * 100.0 / (stats_mangle ? stats_mangle : 1), 1), 5)]%%) | $[pad(stats_mangle_fast_slashes_total, 8)] ($[pad(round(stats_mangle_fast_slashes_total * 100.0 / (stats_mangle_total ? stats_mangle_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('exploit', -25)] | $[pad(stats_mangle_exploit, 8)] ($[pad(round(stats_mangle_exploit * 100.0 / (stats_mangle ? stats_mangle : 1), 1), 5)]%%) | $[pad(stats_mangle_exploit_total, 8)] ($[pad(round(stats_mangle_exploit_total * 100.0 / (stats_mangle_total ? stats_mangle_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('stun', -25)] | $[pad(stats_mangle_stun, 8)] ($[pad(round(stats_mangle_stun * 100.0 / (stats_mangle ? stats_mangle : 1), 1), 5)]%%) | $[pad(stats_mangle_stun_total, 8)] ($[pad(round(stats_mangle_stun_total * 100.0 / (stats_mangle_total ? stats_mangle_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('interrupt', -25)] | $[pad(stats_mangle_interrupt, 8)] ($[pad(round(stats_mangle_interrupt * 100.0 / (stats_mangle ? stats_mangle : 1), 1), 5)]%%) | $[pad(stats_mangle_interrupt_total, 8)] ($[pad(round(stats_mangle_interrupt_total * 100.0 / (stats_mangle_total ? stats_mangle_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('total', -25)] | $[pad(trunc(stats_mangle), 17)] | $[pad(trunc(stats_mangle_total), 17)] |%; \
  /execute %{_cmd} '---------------------------'-------------------'-------------------'%; \
  /save_fighter

;You mutilate Powell's left arm with mediocre force, creating a large dent
;on it, which immediately turns violet blue to your satisfaction.
;Powell puts on a stupid face, as if she had completely forgotten what
;she was doing.

;You swing your Soulcrusher at Powell, smashing it against its right knee
;with unseen force. Powell staggers and takes a few backward steps with
;a spanking new blue bruise.

;You mutilate Powell's right arm with impressive force, creating a large dent
;on it, which immediately turns violet blue to your satisfaction.

;You lower Soulcrusher to your knee, immediately bringing it up again
;against Powell's head. Your unseen hit is severe enough to fracture
;Powell's bones and to knock lose shards which penetrate its skin, cutting
;open numerous little wounds.
;You strike again by hitting your Soulcrusher between Powell's legs, damaging the
;organs vital to its procreation.

;Powell puts on a stupid face, as if she had completely forgotten what
;she was doing.

;Powell's eyes roll around in its head as its consciousness fades away.

/def -Fp5 -msimple -t'Even the blood in your veins seems to freeze!' battle_hardness_cold = \
  /substitute -p -- %{*} [@{Cblue}cold@{n}]

/def -Fp5 -msimple -t'Every muscle on your body seems to convulse!' battle_hardness_electric = \
  /substitute -p -- %{*} [@{BCcyan}electric@{n}]

/def -Fp5 -msimple -t'Your skin melts away to a gooey slush!' battle_hardness_acid = \
  /substitute -p -- %{*} [@{Cgreen}acid@{n}]

/def -Fp5 -msimple -t'Hellish fire sears your skin!' battle_hardness_fire = \
  /substitute -p -- %{*} [@{BCred}fire@{n}]

/def -Fp5 -msimple -t'Your whole existance wavers!' battle_hardness_magical = \
  /substitute -p -- %{*} [@{BCmagenta}magical@{n}]

/def -Fp5 -msimple -t'You suffer a massive system shock!' battle_hardness_physical = \
  /substitute -p -- %{*} [@{BCblack}physical@{n}]

/def -Fp5 -msimple -t'Your veins seem to be on fire!' battle_hardness_poison = \
  /substitute -p -- %{*} [@{Cyellow}poison@{n}]

/def -Fp5 -msimple -t'Your sanity seems to melt away!' battle_hardness_psionic = \
  /substitute -p -- %{*} [@{BCblue}psionic@{n}]

/def -Fp5 -msimple -t'Your lungs feel like they are about to explode!' battle_hardness_asphyxiation = \
  /substitute -p -- %{*} [@{BCwhite}asphyxiation@{n}]

/def -Fp5 -msimple -h'SEND @save' save_fighter = /mapcar /listvar stats_mangle_*_total %| /writefile $[save_dir('fighter')]
/eval /load $[save_dir('fighter')]
