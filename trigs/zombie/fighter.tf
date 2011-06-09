;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; FIGHTER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-04-05 00:35:38 -0700 (Tue, 05 Apr 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/fighter.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/fighter.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]
/eval /require $[trigs_dir('zombie/stats')]

/set fighter=1

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_fighter = \
  /stat_reset mangle

;;
;; COMMANDS
;;

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

/def_stat_group -g'mangle' -n'Mangle'
/def_stat -g'mangle' -k'fast_slashes' -n'Fast Slashes' -r0
/def_stat -g'mangle' -k'dig' -n'Dig' -r1
/def_stat -g'mangle' -k'dazzling_accuracy' -n'Dazzling Accuracy' -r2
/def_stat -g'mangle' -k'powerful_swing' -n'Powerful Swing' -r3
/def_stat -g'mangle' -k'exploit' -n'Exploit' -r0 -s
/def_stat -g'mangle' -k'stun' -n'Stun' -r1 -s
/def_stat -g'mangle' -k'interrupt' -n'Interrupt' -r2 -s

/def -Fp5 -mglob -t'You manage to exploit a vulnerable spot in * defence.' stats_mangle_exploit = \
  /stat_update mangle exploit 1

/def -Fp5 -mglob -t'You perform a powerful downward swing which lands against *' stats_mangle_powerful_swing = \
  /stat_update mangle powerful_swing 1

/def -Fp5 -mglob -t'You operate with dazzling accuracy, cutting an arc shaped wound in *' stats_mangle_dazzling_accuracy = \
  /stat_update mangle dazzling_accuracy 1

/def -Fp5 -mglob -t'You dig your axe in * belly, sliding it smoothly through *' stats_mangle_dig = \
  /stat_update mangle dig 1

/def -Fp5 -mglob -t'You hack * left shoulder by delivering two fast slashes at it.' stats_mangle_fast_slashes = \
  /stat_update mangle fast_slashes 1

/def -Fp5 -mglob -t'Your attack makes * consciousness.' stats_mangle_stun = \
  /stat_update mangle stun 1

/def -Fp5 -mglob -t'Your attack interrupts * concentration.' stats_mangle_interrupt = \
  /stat_update mangle interrupt 1

/def stats_mangle = /stat_display mangle %{*}

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

/def -Fp5 -mregexp -t'^ 7th attack                      (\d+)' fig_skills_show_7th_attack = \
  /set fighter_mastery_7th_attack=%{P1}

/def -Fp5 -mregexp -t'^ Organ knowledge                 (\d+)' fig_skills_show_organ_knowledge = \
  /set fighter_mastery_organ_knowledge=%{P1}

/def -Fp5 -mregexp -t'^ Shield stun                     (\d+)' fig_skills_show_shield_stun = \
  /set fighter_mastery_shield_stun=%{P1}

/def -Fp5 -mregexp -t'^ Hell howl                       (\d+)' fig_skills_show_hell_howl = \
  /set fighter_mastery_hell_howl=%{P1}

/def -Fp5 -mregexp -t'^ Shield reflect                  (\d+)' fig_skills_show_shield_reflect = \
  /set fighter_mastery_shield_reflect=%{P1}

/def -Fp5 -mregexp -t'^ Disarm                          (\d+)' fig_skills_show_disarm = \
  /set fighter_mastery_disarm=%{P1}

/def -Fp5 -mregexp -t'^ Taunt                           (\d+)' fig_skills_show_taunt = \
  /set fighter_mastery_taunt=%{P1}

/def -Fp5 -mregexp -t'^ Master berserker                (\d+)' fig_skills_show_master_berserker = \
  /set fighter_mastery_master_berserker=%{P1}

/def -Fp5 -mregexp -t'^ Sword movement                  (\d+)' fig_skills_show_sword_movement = \
  /set fighter_mastery_sword_movement=%{P1}

/def -Fp5 -mregexp -t'^ Barbaric bashing                (\d+)' fig_skills_show_barbaric_bashing = \
  /set fighter_mastery_barbaric_bashing=%{P1}

/def -Fp5 -mregexp -t'^ Knowledge of ancient weapons    (\d+)' fig_skills_show_ancient_weapons = \
  /set fighter_mastery_ancient_weapons=%{P1}

/def -Fp5 -mregexp -t'^ Knowledge of ranged fighting    (\d+)' fig_skills_show_ranged_fighting = \
  /set fighter_mastery_ranged_fighting=%{P1}

/def fighter_mastery = \
  /result 0 + \
    fighter_mastery_7th_attack + \
    fighter_mastery_organ_knowledge + \
    fighter_mastery_shield_stun + \
    fighter_mastery_hell_howl + \
    fighter_mastery_shield_reflect + \
    fighter_mastery_disarm + \
    fighter_mastery_taunt + \
    fighter_mastery_master_berserker + \
    fighter_mastery_sword_movement + \
    fighter_mastery_barbaric_bashing + \
    fighter_mastery_ancient_weapons + \
    fighter_mastery_ranged_fighting + \
    fighter_points


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

/def -Fp5 -msimple -h'SEND @save' save_fighter = \
  /mapcar /listvar fighter_mastery_* fighter_points %| /writefile $[save_dir('fighter')]%; \
  /stat_save mangle $[stats_dir('mangle')]

/eval /load $[save_dir('fighter')]
/eval /stat_load mangle $[stats_dir('mangle')]
