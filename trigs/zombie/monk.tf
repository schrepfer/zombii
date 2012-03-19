;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MONK TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/monk.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/monk.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]
/eval /require $[trigs_dir('zombie/stats')]

/set monk=1

;;
;; COMMANDS
;;

/def fb = /fast_blow %{*}
/def kf = /kungfu %{*}
/def pk = /power_kick %{*}

/def -Fp5 -msimple -t'This maneuver can only be done with degree of surprise not possible' ki_combat_fail = \
  /say -d'party' -c'red' -b -- :grr

/def -Fp5 -mglob -h'SEND @on_enemy_killed *' on_enemy_killed_monk = \
  /if (monk_style_martial_arts + monk_style_kungfu + monk_style_magic < 200) \
    /style_score quiet%; \
  /endif

/def style_score = \
  /let _key=$[hex(id())]%; \
  /if ({#}) \
    /set style_score_%{_key}=%{*}%; \
  /else \
    /set style_score_%{_key}=/say -d'status' --%; \
  /endif%; \
  !style_score%; \
  !echo /style_score %{_key}

/def -Fp5 -ag -mregexp -t'^You are following the style \'(.*)\'$' monk_set_style = /set monk_style=%{P1}

/def -Fp5 -ag -mregexp -t'^Art of the Martial Arts: (\\d+)$' monk_set_style_0 = \
  /let _1=%{P1}%; \
  /if (_1 > monk_style_martial_arts) \
    /say -c'red' -- Gained Martial Arts Point: %{_1}%; \
    !house say Gained Martial Arts Point: %{_1}%; \
  /endif%; \
  /set monk_style_martial_arts_last=%{monk_style_martial_arts}%; \
  /set monk_style_martial_arts=%{_1}

/def -Fp5 -ag -mregexp -t'^Art of the Kungfu: (\\d+)$' monk_set_style_1 = \
  /let _1=%{P1}%; \
  /if (_1 > monk_style_kungfu) \
    /say -c'red' -- Gained Kungfu Point: %{_1}%; \
    !house say Gained Kungfu Point: %{_1}%; \
  /endif%; \
  /set monk_style_kungfu_last=%{monk_style_kungfu}%; \
  /set monk_style_kungfu=%{_1}

/def -Fp5 -ag -mregexp -t'^Elemental and Magical Lore: (\\d+)$' monk_set_style_2 = \
  /let _1=%{P1}%; \
  /if (_1 > monk_style_magic) \
    /say -c'red' -- Gained Elemental and Magic Lore Point: %{_1}%; \
    !house say Gained Elemental and Magic Lore Point: %{_1}%; \
  /endif%; \
  /set monk_style_magic_last=%{monk_style_magic}%; \
  /set monk_style_magic=%{_1}

/def -Fp5 -ag -mregexp -t'^/style_score ([0-9a-f]+)$' style_score_message = \
  /let _var=style_score_%{P1}%; \
  /let _cmd=$[expr(_var)]%; \
  /unset %{_var}%; \
  /if (_cmd !~ 'quiet') \
    /if (!strlen(_cmd)) \
      /return%; \
    /endif%; \
    /execute %{_cmd} %{monk_style-Unknown Style} - Martial Arts: $[trunc(monk_style_martial_arts)], Kungfu: $[trunc(monk_style_kungfu)], Magic: $[trunc(monk_style_magic)]%; \
  /endif%; \
  /unset monk_style_kungfu_last%; \
  /unset monk_style_martial_arts_last%; \
  /unset monk_style_magic_last

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_monk = \
  /stat_reset kungfu

/def_stat_group -g'kungfu' -n'Kungfu'
/def_stat -g'kungfu' -k'kick_and_miss' -n'Kick and Miss' -r0
/def_stat -g'kungfu' -k'crush' -n'Crush' -r1
/def_stat -g'kungfu' -k'knock_wind_out' -n'Knock Wind Out' -r2
/def_stat -g'kungfu' -k'knock_teeth_out' -n'Knock Teeth Out' -r3
/def_stat -g'kungfu' -k'crush_nose' -n'Crush Nose' -r4
/def_stat -g'kungfu' -k'rupture_ears' -n'Rupture Ears' -r5
/def_stat -g'kungfu' -k'fracture_jaw' -n'Fracture Jaw' -r6
/def_stat -g'kungfu' -k'crush_windpipe' -n'Crush Windpipe' -r7
/def_stat -g'kungfu' -k'smash_organs' -n'Smash Organs' -r8
/def_stat -g'kungfu' -k'crush_ribcage' -n'Crush Ribcage' -r9
/def_stat -g'kungfu' -k'explode_heart' -n'Explode Heart' -r10
/def_stat -g'kungfu' -k'sever_spine' -n'Sever Spine' -r11
/def_stat -g'kungfu' -k'decimate_face' -n'Decimate Face' -r12
/def_stat -g'kungfu' -k'stun' -n'Stun' -r0 -s
/def_stat -g'kungfu' -k'focus' -n'Focus' -r1 -s

/def -Fp5 -msimple -t'You make some fancy martial arts maneuvers and fall flat on your face' stats_kungfu_kick_and_miss = \
  /stat_update kungfu kick_and_miss 1

/def -Fp5 -mglob -t'You do a vicious kick to * left arm hearing satisfying crush.' stats_kungfu_crush = \
  /stat_update kungfu crush 1

/def -Fp5 -mglob -t'You perform a furious kick to * solar plexus knocking the wind out of *!' stats_kungfu_knock_wind_out = \
  /stat_update kungfu knock_wind_out 1

/def -Fp5 -mglob -t'Your roundhouse kick smashes * mouth knocking several teeth out!' stats_kungfu_knock_teeth_out = \
  /stat_update kungfu knock_teeth_out 1

/def -Fp5 -mglob -t'Your swift front kick to * midsection doubles *, and the follow-up strike crushes * nose!' stats_kungfu_crush_nose = \
  /stat_update kungfu crush_nose 1

/def -Fp5 -mglob -t'You do nasty simultaneous open palm strike rupturing * ears.' stats_kungfu_rupture_ears = \
  /stat_update kungfu rupture_ears 1

/def -Fp5 -mglob -t'You kick brutally to * head spraining neck and fracturing the jaw.' stats_kungfu_fracture_jaw = \
  /stat_update kungfu fracture_jaw 1

/def -Fp5 -mglob -t'Your wicked open-handed blow to * neck CRUSHES the windpipe!' stats_kungfu_crush_windpipe = \
  /stat_update kungfu crush_windpipe 1

/def -Fp5 -msimple -t'Your VICIOUS spear hand strike to stomach SMASHES a variety of ORGANS.' stats_kungfu_smash_organs = \
  /stat_update kungfu smash_organs 1

/def -Fp5 -mglob -t'Your sweep lays * out and a heel strike to chest CRUSHES the ribcage!' stats_kungfu_crush_ribcage = \
  /stat_update kungfu crush_ribcage 1

/def -Fp5 -mglob -t'Your awesome spear hand strike penetrates * solar plexus' stats_kungfu_explode_heart = \
  /stat_update kungfu explode_heart 1

/def -Fp5 -mglob -t'You SEVER * spine with a CRUEL strike, TEARING through * abdomen.' stats_kungfu_sever_spine = \
  /stat_update kungfu sever_spine 1

/def -Fp5 -mglob -t'You DECIMATE * face with a BRUTAL double palmstrike driving' stats_kungfu_decimate_face = \
  /stat_update kungfu decimate_face 1

/def -Fp5 -mglob -t'You stun * with your fierce attack.' stats_kungfu_stun = \
  /stat_update kungfu stun 1

/def -Fp5 -msimple -t'You relax and focus your blows with greater strength.' stats_kungfu_focus = \
  /stat_update kungfu focus 1

/def stats_kungfu = /stat_display kungfu %{*}

;; House triggers

/def hph = /house_plan_help

/def house_plan_help = \
  !house say h' add [COUNT] <SKILL/level>%; \
  !house say    remove <POSITION>%; \
  !house say    insert [COUNT] <SKILL/level> <POSITION>%; \
  !house say    clear

;;;;
;;
;; Are you currently the owner of your house? If you are the house owner then
;; others will be able to update their house plans using "add", "remove",
;; "insert", "clear" and "help" on the "house" channel.
;;
/property -b house_owner

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) [\\[{]house[}\\]]: (add|remove|insert|clear|help)( |$)' house_plan = \
  /if (!house_owner) \
    /return%; \
  /endif%; \
  /let _player=$[tolower({P1})]%; \
  /let _action=%{P2}%; \
  /let _arguments=%{PR}%; \
  /if (_action =~ 'add' & strlen(_arguments)) \
    /if (regmatch('^(\\d+) (.+)$$', _arguments)) \
      /let _count=%{P1}%; \
      /let _skill=%{P2}%; \
    /else \
      /let _skill=%{_arguments}%; \
    /endif%; \
    /let _count=$[max(1, min(15, _count))]%; \
    /repeat -S %{_count} !house plan %{_player} add %{_skill}%; \
  /elseif (_action =~ 'remove' & strlen(_arguments)) \
    /if (regmatch('^\\d+$$', _arguments)) \
      /let _position=$[max(1, min(15, _arguments))]%; \
      !house plan %{_player} remove %{_position}%; \
    /endif%; \
  /elseif (_action =~ 'insert' & strlen(_arguments)) \
    /if (regmatch('^(\\d+) (.+) (\\d+)$$', _arguments)) \
      /let _count=%{P1}%; \
      /let _skill=%{P2}%; \
      /let _position=%{P3}%; \
    /elseif (regmatch('^(.+) (\\d+)$$', _arguments)) \
      /let _skill=%{P1}%; \
      /let _position=%{P2}%; \
    /else \
      /if (regmatch('^(\\d+) (.+)$$', _arguments)) \
        /let _count=%{P1}%; \
        /let _skill=%{P2}%; \
      /else \
        /let _skill=%{_arguments}%; \
      /endif%; \
      /let _count=$[max(1, min(15, _count))]%; \
      /repeat -S %{_count} !house plan %{_player} add %{_skill}%; \
      /return%; \
    /endif%; \
    /let _count=$[max(1, min(15, _count))]%; \
    /let _position=$[max(1, min(14, _position))]%; \
    /repeat -S %{_count} !house plan %{_player} insert %{_position} %{_skill}%; \
  /elseif (_action =~ 'clear' & !strlen(_arguments)) \
    !house plan %{_player} clear%; \
  /elseif (_action =~ 'help' & !strlen(_arguments)) \
    /house_plan_help%; \
  /endif

/def -Fp5 -mregexp -t'^You clear ([A-Z][a-z]+)\'s training plan\\.$' house_plan_clear = \
  !emoteto $[tolower({P1})] has cleared your training plan.

/def -Fp5 -mregexp -t'^You add \'(.+)\' to ([A-Z][a-z]+)\'s training plan\\.$' house_plan_add = \
  !emoteto $[tolower({P2})] has added '%{P1}' to your training plan.

/def -Fp5 -mregexp -t'^You remove entry #(\\d+) from ([A-Z][a-z]+)\'s training plan\\.$' house_plan_remove = \
  !emoteto $[tolower({P2})] has removed entry #%{P1} from your training plan.

;;
;; save settings
;;
/def -Fp5 -msimple -h'SEND @save' save_monk = \
  /mapcar /listvar house_owner monk_style monk_style_* stats_kungfu_*_total %| /writefile $[save_dir('monk')]%; \
  /stat_save kungfu $[stats_dir('kungfu')]

/eval /load $[save_dir('monk')]
/eval /stat_load kungfu $[stats_dir('kungfu')]
