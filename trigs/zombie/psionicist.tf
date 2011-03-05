;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; PSIONICIST TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-02-15 00:51:08 -0800 (Tue, 15 Feb 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/psionicist.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/psionicist.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

;;
;; ATTACKS/OTHER
;;

/def hac = /headache %{*}
/def pc = /psychic_crush %{*}
/def pbl = /psionic_blast %{*}
/def cry = /cryokinesis %{*}
/def mol = /molecular_agitation %{*}
/def bs = /brainstorm %{*}
/def cho = /choke %{*}
/def mi = /mental_illusions %{*}

;;
;; PROTS
;;

/def mg = /mental_glance %{*}
/def md = /mind_development %{*}
/def pz = /phaze_shift %{*}
/def phaze = /phaze_shift %{*}
/def fs = /force_shield %{*}
/def mb = /mind_barrier %{*}

;;
;; OTHER
;;

/def -Fp5 -mregexp -t'^Mental illusions now haunt (.*)\\.$' mental_illusions_up = \
  /announce_effect -s1 -p'Mental Illusions' -o'$(/escape ' %{P1})'

/def -Fp5 -msimple -t'You create a blood red telekinetic barrier.' mind_barrier_up = \
  /say -d'party' -c'green' -- Mind Barrier Up

/def -Fp5 -msimple -t'The barrier vanishes.' mind_barrier_down = \
  /say -d'party' -c'red' -- Mind Barrier Down

/def -Fp5 -P1B;2BCgreen -mregexp -t'You gain (\\d+ points) of (green) mental energy\\.' psionicist_green_points
/def -Fp5 -P1B;2BCred -mregexp -t'You gain (\\d+ points) of (red) mental energy\\.' psionicist_red_points
/def -Fp5 -P1B;2BCblue -mregexp -t'You gain (\\d+ points) of (blue) mental energy\\.' psionicist_blue_points
/def -Fp5 -P1B;2BCyellow -mregexp -t'You gain (\\d+ points) of (yellow) mental energy\\.' psionicist_yellow_points

/def -Fp5 -mregexp -t'^You gain (\\d+) points of (green|red|blue|yellow) mental energy\\.' add_psionicist_score = \
  /let _color=$[tolower({P2})]%; \
  /add_stats_psionicist %{_color} %{P1}

/def -Fp5 -mregexp -t'^(Green|Red|Blue|Yellow) \\((\\d+) points\\) \\(\\d+ of \\d+ stars\\)' psionicist_points = \
  /let _color=$[tolower({P1})]%; \
  /set stats_psionicist_%{_color}_total=%{P2}

/def add_stats_psionicist = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _points=%{2-1}%; \
  /let _current=stats_psionicist_%{1}%; \
  /test _current := %{_current}%; \
  /set stats_psionicist_%{1}=$[_current + _points]%; \
  /let _total=stats_psionicist_%{1}_total%; \
  /test _total := %{_total}%; \
  /set stats_psionicist_%{1}_total=$[_total + _points]

/def init_stats_psionicist = \
  /while ({#}) \
    /set stats_psionicist_%{1}=0%; \
    /shift%; \
  /done

/def init_stats_psionicist_total = \
  /init_stats_psionicist %{*}%; \
  /while ({#}) \
    /init_stats_psionicist %{1}_total%; \
    /shift%; \
  /done

/def -Fp5 -mglob -t'You hit * with your psychic crush.' stats_psionicist_psychic_crush = /add_stats_psionicist psychic_crush

/def -Fp5 -mglob -t'You keep agitating *\'s molecules.' stats_psionicist_molecular_agitation = /add_stats_psionicist molecular_agitation

/def -Fp5 -mglob -t'You keep suppressing molecular motion in *.' stats_psionicist_cryokinesis = /add_stats_psionicist cryokinesis

/def -Fp5 -msimple -t'You make a gesture and form a almost invisible pair of' stats_psionicist_choke = /add_stats_psionicist choke

/def -Fp5 -mregexp -t'^[A-Za-z,-:\' ]+ looks dazed and confused by the awesome force of your attack\\.$' stats_psionicist_stun = /add_stats_psionicist stun

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_psionicist = \
  /stats_psionicist reset

/def -Fp5 -mglob -h'SEND @on_target *' set_target_psionicist = \
  !probe all

/def stats_psi = /stats_psionicist %{*}

/def stats_psionicist = \
  /if ({#}) \
    /if ({*} =~ 'reset') \
      /init_stats_psionicist red green yellow blue stun psychic_crush molecular_agitation cryokinesis choke%; \
      /return%; \
    /elseif ({*} =~ 'reset all') \
      /init_stats_psionicist_total red green yellow blue stun psychic_crush molecular_agitation cryokinesis choke%; \
      /return%; \
    /endif%; \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen --%; \
  /endif%; \
  /execute %{_cmd} .-------------------------------------------------------------------.%; \
  /execute %{_cmd} | Psionicist Statistics:                                            |%; \
  /execute %{_cmd} |---------------------------.-------------------.-------------------|%; \
  /execute %{_cmd} |                           |     session       |       total       |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('psychic crush', -25)] | $[pad(trunc(stats_psionicist_psychic_crush), 17)] | $[pad(trunc(stats_psionicist_psychic_crush_total), 17)] |%; \
  /execute %{_cmd} | $[pad('molecular agitation', -25)] | $[pad(trunc(stats_psionicist_molecular_agitation), 17)] | $[pad(trunc(stats_psionicist_molecular_agitation_total), 17)] |%; \
  /execute %{_cmd} | $[pad('cryokinesis', -25)] | $[pad(trunc(stats_psionicist_cryokinesis), 17)] | $[pad(trunc(stats_psionicist_cryokinesis_total), 17)] |%; \
  /execute %{_cmd} | $[pad('choke', -25)] | $[pad(trunc(stats_psionicist_choke), 17)] | $[pad(trunc(stats_psionicist_choke_total), 17)] |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('stun', -25)] | $[pad(stats_psionicist_stun, 8)] ($[pad(round(stats_psionicist_stun * 100.0 / (stats_psionicist_psychic_crush ? stats_psionicist_psychic_crush : 1), 1), 5)]%%) | $[pad(stats_psionicist_stun_total, 8)] ($[pad(round(stats_psionicist_stun_total * 100.0 / (stats_psionicist_psychic_crush_total ? stats_psionicist_psychic_crush_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('red', -25)] | $[pad(trunc(stats_psionicist_red), 17)] | $[pad(trunc(stats_psionicist_red_total), 17)] |%; \
  /execute %{_cmd} | $[pad('blue', -25)] | $[pad(trunc(stats_psionicist_blue), 17)] | $[pad(trunc(stats_psionicist_blue_total), 17)] |%; \
  /execute %{_cmd} | $[pad('green', -25)] | $[pad(trunc(stats_psionicist_green), 17)] | $[pad(trunc(stats_psionicist_green_total), 17)] |%; \
  /execute %{_cmd} | $[pad('yellow', -25)] | $[pad(trunc(stats_psionicist_yellow), 17)] | $[pad(trunc(stats_psionicist_yellow_total), 17)] |%; \
  /execute %{_cmd} '---------------------------'-------------------'-------------------'%; \
  /save_psionicist

; 5 10 25 50 100 175 250 500 1000

/def -Fp5 -msimple -h'SEND @save' save_psionicist = /mapcar /listvar stats_psionicist_*_total %| /writefile $[save_dir('psionicist')]
/eval /load $[save_dir('psionicist')]
