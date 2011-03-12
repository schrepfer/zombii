;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MONK TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-03-11 15:33:39 -0800 (Fri, 11 Mar 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/monk.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/monk.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set monk=1

; monk commands
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

/def add_stats_kungfu = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _var=stats_kungfu_%{1}%; \
  /test _var := %{_var}%; \
  /set stats_kungfu_%{1}=$[_var+1]%; \
  /let _var=stats_kungfu_%{1}_total%; \
  /test _var := %{_var}%; \
  /set stats_kungfu_%{1}_total=$[_var+1]

/def init_stats_kungfu = \
  /while ({#}) \
    /set stats_kungfu_%{1}=0%; \
    /shift%; \
  /done

/def init_stats_kungfu_total = \
  /init_stats_kungfu %{*}%; \
  /while ({#}) \
    /init_stats_kungfu %{1}_total%; \
    /shift%; \
  /done

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_monk = \
  /stats_kungfu reset

/def -Fp5 -msimple -t'You make some fancy martial arts maneuvers and fall flat on your face' stats_kungfu_kick_and_miss = /add_stats_kungfu kick_and_miss
/def -Fp5 -mglob -t'You do a vicious kick to * left arm hearing satisfying crush.' stats_kungfu_crush = /add_stats_kungfu crush
/def -Fp5 -mglob -t'You do a furious kick to * solar plexus knocking the wind out.' stats_kungfu_knock_wind_out = /add_stats_kungfu knock_wind_out
/def -Fp5 -mglob -t'Your roundhouse kick smashes * mouth knocking several teeth out.' stats_kungfu_knock_teeth_out = /add_stats_kungfu knock_teeth_out
/def -Fp5 -mglob -t'Front kick to * midsection doubles *, follow-up strike crushes nose.' stats_kungfu_crush_nose = /add_stats_kungfu crush_nose
/def -Fp5 -mglob -t'You do nasty simultaneous open palm strike rupturing * ears.' stats_kungfu_rupture_ears = /add_stats_kungfu rupture_ears
/def -Fp5 -mglob -t'You kick brutally to * head spraining neck and fracturing the jaw.' stats_kungfu_fracture_jaw = /add_stats_kungfu fracture_jaw
/def -Fp5 -mglob -t'Your wicked open-handed blow to * neck CRUSHES the windpipe!' stats_kungfu_crush_windpipe = /add_stats_kungfu crush_windpipe
/def -Fp5 -msimple -t'Your VICIOUS spear hand strike to stomach SMASHES a variety of ORGANS.' stats_kungfu_smash_organs = /add_stats_kungfu smash_organs
/def -Fp5 -mglob -t'Your sweep lays * out and a heel strike to chest CRUSHES the ribcage!' stats_kungfu_crush_ribcage = /add_stats_kungfu crush_ribcage
/def -Fp5 -mglob -t'Your awesome spear hand strike penetrates * solar plexus' stats_kungfu_explode_heart = /add_stats_kungfu explode_heart
/def -Fp5 -mglob -t'You SEVER * spine with a CRUEL strike, TEARING through * abdomen.' stats_kungfu_sever_spine = /add_stats_kungfu sever_spine
/def -Fp5 -mglob -t'You DECIMATE * face with a BRUTAL double palmstrike driving' stats_kungfu_decimate_face = /add_stats_kungfu decimate_face
/def -Fp5 -mglob -t'You stun * with your fierce attack.' stats_kungfu_stun = /add_stats_kungfu stun
/def -Fp5 -msimple -t'You relax and focus your blows with greater strength.' stats_kungfu_focus = /add_stats_kungfu focus

/def stats_kungfu = \
  /if ({#}) \
    /if ({*} =~ 'reset') \
      /init_stats_kungfu \
        kick_and_miss \
        crush \
        knock_wind_out \
        knock_teeth_out \
        crush_nose \
        rupture_ears \
        fracture_jaw \
        crush_windpipe \
        smash_organs \
        crush_ribcage \
        explode_heart \
        sever_spine \
        decimate_face \
        stun \
        focus%; \
      /return%; \
    /elseif ({*} =~ 'reset all') \
      /init_stats_kungfu_total \
        kick_and_miss \
        crush \
        knock_wind_out \
        knock_teeth_out \
        crush_nose \
        rupture_ears \
        fracture_jaw \
        crush_windpipe \
        smash_organs \
        crush_ribcage \
        explode_heart \
        sever_spine \
        decimate_face \
        stun \
        focus%; \
      /return%; \
    /endif%; \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen%; \
  /endif%; \
  /let stats_kungfu=$[\
      stats_kungfu_kick_and_miss + \
      stats_kungfu_crush + \
      stats_kungfu_knock_wind_out + \
      stats_kungfu_knock_teeth_out + \
      stats_kungfu_crush_nose + \
      stats_kungfu_rupture_ears + \
      stats_kungfu_fracture_jaw + \
      stats_kungfu_crush_windpipe + \
      stats_kungfu_smash_organs + \
      stats_kungfu_crush_ribcage + \
      stats_kungfu_explode_heart + \
      stats_kungfu_sever_spine + \
      stats_kungfu_decimate_face]%; \
  /let stats_kungfu_total=$[\
      stats_kungfu_kick_and_miss_total + \
      stats_kungfu_crush_total + \
      stats_kungfu_knock_wind_out_total + \
      stats_kungfu_knock_teeth_out_total + \
      stats_kungfu_crush_nose_total + \
      stats_kungfu_rupture_ears_total + \
      stats_kungfu_fracture_jaw_total + \
      stats_kungfu_crush_windpipe_total + \
      stats_kungfu_smash_organs_total + \
      stats_kungfu_crush_ribcage_total + \
      stats_kungfu_explode_heart_total + \
      stats_kungfu_sever_spine_total + \
      stats_kungfu_decimate_face_total]%; \
  /execute %{_cmd} .-------------------------------------------------------------------.%; \
  /execute %{_cmd} | Kungfu Statistics:                                                |%; \
  /execute %{_cmd} |---------------------------.-------------------.-------------------|%; \
  /execute %{_cmd} |                           |      Session      |       Total       |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('kick and miss', -25)] | $[pad(stats_kungfu_kick_and_miss, 8)] ($[pad(round(stats_kungfu_kick_and_miss * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_kick_and_miss_total, 8)] ($[pad(round(stats_kungfu_kick_and_miss_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('crush', -25)] | $[pad(stats_kungfu_crush, 8)] ($[pad(round(stats_kungfu_crush * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_crush_total, 8)] ($[pad(round(stats_kungfu_crush_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('knock wind out', -25)] | $[pad(stats_kungfu_knock_wind_out, 8)] ($[pad(round(stats_kungfu_knock_wind_out * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_knock_wind_out_total, 8)] ($[pad(round(stats_kungfu_knock_wind_out_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('knock teeth out', -25)] | $[pad(stats_kungfu_knock_teeth_out, 8)] ($[pad(round(stats_kungfu_knock_teeth_out * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_knock_teeth_out_total, 8)] ($[pad(round(stats_kungfu_knock_teeth_out_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('crush nose', -25)] | $[pad(stats_kungfu_crush_nose, 8)] ($[pad(round(stats_kungfu_crush_nose * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_crush_nose_total, 8)] ($[pad(round(stats_kungfu_crush_nose_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('rupture ears', -25)] | $[pad(stats_kungfu_rupture_ears, 8)] ($[pad(round(stats_kungfu_rupture_ears * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_rupture_ears_total, 8)] ($[pad(round(stats_kungfu_rupture_ears_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('fracture jaw', -25)] | $[pad(stats_kungfu_fracture_jaw, 8)] ($[pad(round(stats_kungfu_fracture_jaw * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_fracture_jaw_total, 8)] ($[pad(round(stats_kungfu_fracture_jaw_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('crush windpipe', -25)] | $[pad(stats_kungfu_crush_windpipe, 8)] ($[pad(round(stats_kungfu_crush_windpipe * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_crush_windpipe_total, 8)] ($[pad(round(stats_kungfu_crush_windpipe_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('smash organs', -25)] | $[pad(stats_kungfu_smash_organs, 8)] ($[pad(round(stats_kungfu_smash_organs * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_smash_organs_total, 8)] ($[pad(round(stats_kungfu_smash_organs_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('crush ribcage', -25)] | $[pad(stats_kungfu_crush_ribcage, 8)] ($[pad(round(stats_kungfu_crush_ribcage * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_crush_ribcage_total, 8)] ($[pad(round(stats_kungfu_crush_ribcage_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('explode heart', -25)] | $[pad(stats_kungfu_explode_heart, 8)] ($[pad(round(stats_kungfu_explode_heart * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_explode_heart_total, 8)] ($[pad(round(stats_kungfu_explode_heart_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('sever spine', -25)] | $[pad(stats_kungfu_sever_spine, 8)] ($[pad(round(stats_kungfu_sever_spine * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_sever_spine_total, 8)] ($[pad(round(stats_kungfu_sever_spine_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('decimate face', -25)] | $[pad(stats_kungfu_decimate_face, 8)] ($[pad(round(stats_kungfu_decimate_face * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_decimate_face_total, 8)] ($[pad(round(stats_kungfu_decimate_face_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('stun', -25)] | $[pad(stats_kungfu_stun, 8)] ($[pad(round(stats_kungfu_stun * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_stun_total, 8)] ($[pad(round(stats_kungfu_stun_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('focus', -25)] | $[pad(stats_kungfu_focus, 8)] ($[pad(round(stats_kungfu_focus * 100.0 / (stats_kungfu ? stats_kungfu : 1), 1), 5)]%%) | $[pad(stats_kungfu_focus_total, 8)] ($[pad(round(stats_kungfu_focus_total * 100.0 / (stats_kungfu_total ? stats_kungfu_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('total', -25)] | $[pad(trunc(stats_kungfu), 17)] | $[pad(trunc(stats_kungfu_total), 17)] |%; \
  /execute %{_cmd} '---------------------------'-------------------'-------------------'%; \
  /save_monk

;; House triggers

/def hph = /house_plan_help

/def house_plan_help = \
  !house say h' add [COUNT] <SKILL/level>%; \
  !house say    remove <POSITION>%; \
  !house say    insert [COUNT] <SKILL/level> <POSITION>%; \
  !house say    clear

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

;
; save settings
;
/def -Fp5 -msimple -h'SEND @save' save_monk = /mapcar /listvar house_owner monk_style monk_style_* stats_kungfu_*_total %| /writefile $[save_dir('monk')]
/eval /load $[save_dir('monk')]
