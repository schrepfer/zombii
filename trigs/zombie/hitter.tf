;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; GENERIC HITTER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/hitter.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/hitter.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_hitter = \
  /stats_hitter reset

;;
;; HITTER STATISTICS
;;

/def add_stats_hitter = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _points=%{2-1}%; \
  /let _current=$[expr(strcat('stats_hitter_', {1}))]%; \
  /set stats_hitter_%{1}=$[_current + _points]%; \
  /let _total=$[expr(strcat('stats_hitter_', {1}, '_total'))]%; \
  /set stats_hitter_%{1}_total=$[_total + _points]

/def init_stats_hitter = \
  /while ({#}) \
    /set stats_hitter_%{1}=0%; \
    /shift%; \
  /done

/def init_stats_hitter_total = \
  /init_stats_hitter %{*}%; \
  /while ({#}) \
    /init_stats_hitter %{1}_total%; \
    /shift%; \
  /done

/def -Fp5 -mregexp -t'^You hit (.+) (\\d+) times\\.$' stats_hitter_hit = /add_stats_hitter %{P2}hit
/def -Fp5 -mglob -t'You STUN *.' stats_hitter_stun = /add_stats_hitter stun
/def -Fp5 -mglob -t'Your taunting enrages *.' stats_hitter_taunt = /add_stats_hitter taunt
/def -Fp5 -mglob -t'You reflect * skill aside.' stats_hitter_reflect = /add_stats_hitter reflect
/def -Fp5 -msimple -t'You score a CRITICAL hit!' stats_hitter_critical = /add_stats_hitter critical
/def -Fp5 -msimple -t'Your inebriated state augments your blows with deadly strength!' stats_hitter_inebriated = /add_stats_hitter inebriated
/def -Fp5 -msimple -t'You score an extra critical hit due to your organ knowledge.' stats_hitter_organ = /add_stats_hitter organ
/def -Fp5 -mregexp -t'^([A-Za-z,-:\' ]+) hits you (\\d+) times\\.$' stats_hitter_hits = /add_stats_hitter hits %{P2}
/def -Fp5 -mglob -t'You skillfully parry * hit.' stats_hitter_parry = /add_stats_hitter parry
/def -Fp5 -mglob -t'You nimbly dodge * hit.' stats_hitter_dodge = /add_stats_hitter dodge
/def -Fp5 -mglob -t'You tumble and avoid *\'s spell.' stats_hitter_tumble = /add_stats_hitter tumble
/def -Fp5 -msimple -t'You are stunned and unable to fight.' stats_hitter_stunned = /add_stats_hitter stunned
/def -Fp5 -mglob -h'SEND @on_enemy_killed *' on_enemy_killed_hitter = /add_stats_hitter kills

/def stats_hitter = \
  /if ({#}) \
    /if ({*} =~ 'reset') \
      /init_stats_hitter \
        stun \
        taunt \
        reflect \
        critical \
        inebriated \
        organ \
        hits \
        parry \
        dodge \
        stunned \
        tumble \
        kills \
        1hit \
        2hit \
        3hit \
        4hit \
        5hit \
        6hit \
        7hit%; \
      /return%; \
    /elseif ({*} =~ 'reset all') \
      /init_stats_hitter_total \
        stun \
        taunt \
        reflect \
        critical \
        inebriated \
        organ \
        hits \
        parry \
        dodge \
        stunned \
        tumble \
        kills \
        1hit \
        2hit \
        3hit \
        4hit \
        5hit \
        6hit \
        7hit%; \
      /return%; \
    /endif%; \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen --%; \
  /endif%; \
  /let stats_hitter_rounds=0.0%; \
  /let stats_hitter_rounds_total=0.0%; \
  /let stats_hitter_hit_calc=0.0%; \
  /let stats_hitter_hit_calc_total=0.0%; \
  /let i=1%; \
  /while (i <= 10) \
    /let _hits=$[expr(strcat('stats_hitter_', i, 'hit'))]%; \
    /test stats_hitter_hit_calc += _hits * i%; \
    /test stats_hitter_rounds += _hits%; \
    /let _hits=$[expr(strcat('stats_hitter_', i, 'hit_total'))]%; \
    /test stats_hitter_hit_calc_total += _hits * i%; \
    /test stats_hitter_rounds_total += _hits%; \
    /test ++i%; \
  /done%; \
  /execute %{_cmd} .-------------------------------------------------------------------.%; \
  /execute %{_cmd} | Hitter Statistics:                                                |%; \
  /execute %{_cmd} |---------------------------.-------------------.-------------------|%; \
  /execute %{_cmd} |                           |     session       |       total       |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /let i=1%; \
  /while (i <= 7) \
    /if (expr(strcat('stats_hitter_', i, 'hit_total'))) \
      /execute %{_cmd} | $[pad(strcat(i, 'x hit'), -25)] | $[pad(expr(strcat('stats_hitter_', i, 'hit')), 8)] ($[pad(round(expr(strcat('stats_hitter_', i, 'hit')) * 100.0 / (stats_hitter_rounds ? stats_hitter_rounds : 1), 1), 5)]%%) | $[pad(expr(strcat('stats_hitter_', i, 'hit_total')), 8)] ($[pad(round(expr(strcat('stats_hitter_', i, 'hit_total')) * 100.0 / (stats_hitter_rounds_total ? stats_hitter_rounds_total : 1), 1), 5)]%%) |%; \
    /endif%; \
    /let i=$[i + 1]%; \
  /done%; \
  /execute %{_cmd} | $[pad('rounds', -25)] | $[pad(trunc(stats_hitter_rounds), 17)] | $[pad(trunc(stats_hitter_rounds_total), 17)] |%; \
  /execute %{_cmd} | $[pad('hits / rounds', -25)] | $[pad(round(stats_hitter_hit_calc / (stats_hitter_rounds ? stats_hitter_rounds : 1), 2), 17)] | $[pad(round(stats_hitter_hit_calc_total / (stats_hitter_rounds_total ? stats_hitter_rounds_total : 1), 2), 17)] |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('critical', -25)] | $[pad(stats_hitter_critical, 8)] ($[pad(round(stats_hitter_critical * 100.0 / (stats_hitter_hit_calc ? stats_hitter_hit_calc : 1), 1), 5)]%%) | $[pad(stats_hitter_critical_total, 8)] ($[pad(round(stats_hitter_critical_total * 100.0 / (stats_hitter_hit_calc_total ? stats_hitter_hit_calc_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('inebriated', -25)] | $[pad(stats_hitter_inebriated, 8)] ($[pad(round(stats_hitter_inebriated * 100.0 / (stats_hitter_hit_calc ? stats_hitter_hit_calc : 1), 1), 5)]%%) | $[pad(stats_hitter_inebriated_total, 8)] ($[pad(round(stats_hitter_inebriated_total * 100.0 / (stats_hitter_hit_calc_total ? stats_hitter_hit_calc_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('stun', -25)] | $[pad(stats_hitter_stun, 8)] ($[pad(round(stats_hitter_stun * 100.0 / (stats_hitter_hit_calc ? stats_hitter_hit_calc : 1), 1), 5)]%%) | $[pad(stats_hitter_stun_total, 8)] ($[pad(round(stats_hitter_stun_total * 100.0 / (stats_hitter_hit_calc_total ? stats_hitter_hit_calc_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('organ knowledge', -25)] | $[pad(stats_hitter_organ, 8)] ($[pad(round(stats_hitter_organ * 100.0 / (stats_hitter_hit_calc ? stats_hitter_hit_calc : 1), 1), 5)]%%) | $[pad(stats_hitter_organ_total, 8)] ($[pad(round(stats_hitter_organ_total * 100.0 / (stats_hitter_hit_calc_total ? stats_hitter_hit_calc_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('tumble', -25)] | $[pad(trunc(stats_hitter_tumble), 17)] | $[pad(trunc(stats_hitter_tumble_total), 17)] |%; \
  /execute %{_cmd} | $[pad('taunt', -25)] | $[pad(trunc(stats_hitter_taunt), 17)] | $[pad(trunc(stats_hitter_taunt_total), 17)] |%; \
  /execute %{_cmd} | $[pad('reflect', -25)] | $[pad(trunc(stats_hitter_reflect), 17)] | $[pad(trunc(stats_hitter_reflect_total), 17)] |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('dodge', -25)] | $[pad(stats_hitter_dodge, 8)] ($[pad(round(stats_hitter_dodge * 100.0 / (stats_hitter_hits ? stats_hitter_hits : 1), 1), 5)]%%) | $[pad(stats_hitter_dodge_total, 8)] ($[pad(round(stats_hitter_dodge_total * 100.0 / (stats_hitter_hits_total ? stats_hitter_hits_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('parry', -25)] | $[pad(stats_hitter_parry, 8)] ($[pad(round(stats_hitter_parry * 100.0 / (stats_hitter_hits ? stats_hitter_hits : 1), 1), 5)]%%) | $[pad(stats_hitter_parry_total, 8)] ($[pad(round(stats_hitter_parry_total * 100.0 / (stats_hitter_hits_total ? stats_hitter_hits_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('hits total', -25)] | $[pad(trunc(stats_hitter_hits), 17)] | $[pad(trunc(stats_hitter_hits_total), 17)] |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('stunned / rnd', -25)] | $[pad(stats_hitter_stunned, 8)] ($[pad(round(stats_hitter_stunned * 100.0 / (stats_hitter_rounds ? stats_hitter_rounds : 1), 1), 5)]%%) | $[pad(stats_hitter_stunned_total, 8)] ($[pad(round(stats_hitter_stunned_total * 100.0 / (stats_hitter_rounds_total ? stats_hitter_rounds_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('kills', -25)] | $[pad(trunc(stats_hitter_kills), 17)] | $[pad(trunc(stats_hitter_kills_total), 17)] |%; \
  /execute %{_cmd} '---------------------------'-------------------'-------------------'%; \
  /save_hitter

;;
;; save settings
;;
/def -Fp5 -msimple -h'SEND @save' save_hitter = /mapcar /listvar stats_hitter_*_total %| /writefile $[save_dir('hitter')]
/eval /load $[save_dir('hitter')]
