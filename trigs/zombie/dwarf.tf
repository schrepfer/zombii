;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; DWARF TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-03-11 15:33:39 -0800 (Fri, 11 Mar 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/dwarf.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/dwarf.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def -Fp5 -msimple -t'Standing fearless in the heat of battle, you care less and less' gained_drunk_point = \
  /say -c'red' -- Gained Mountain Dwarf DRUNK Point

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_dwarf = \
  /stats_swing reset%; \
  /set have_alcohol=0%; \
  /set drunk=0%; \
  /set kegs=0

/def -Fp5 -mglob -h'SEND @on_start_attack *' on_start_attack_dwarf = \
  /drink_with_check%; \
  /if (have_alcohol) \
    /check_berserk%; \
  /endif

/def -Fp5 -msimple -h'SEND @on_new_round' on_new_round_dwarf = \
  /drink_with_check

;/def -Fp5 -msimple -t'Egads! The keg is empty!' empty_keg = \
;  /set have_alcohol=0

/def -Fp5 -msimple -t'You lift the keg and take a big gulp of ale from it.' drink_tankard = \
  /set have_alcohol=1%; \
  /set drunk=1

/property -b have_alcohol
/property -b drunk
/property -i kegs

/def -Fp5 -mregexp -t'^There (are|is) (\\d+) \'keg\'s? in your inventory\\.$' count_keg = \
  /set kegs=%{P2}

/def -Fp5 -aCred -msimple -t'You suddenly become aware of how bright it is everywhere and how' sobering_up_0 = \
  /set drunk=0

/def -Fp5 -aCred -msimple -t'You feel the slow creepy crawl of being hungover as you sober up.' sobering_up_1 = \
  /sobering_up_0

/def -Fp5 -aCred -msimple -t'You begin to feel the tingles of pain from past fights all over your body,' sobering_up_2 = \
  /sobering_up_0

/def -Fp5 -aCred -msimple -t'All the recent fights rush through your head as the alcohol washes out of' sobering_up_3 = \
  /sobering_up_0

/def -Fp5 -aCred -msimple -t'Your mouth feels parched and uncomfortable and your head starts to clear up.' sobering_up_4 = \
  /sobering_up_0

/def -Fp5 -aCred -msimple -t'Your vision begins to clear up and you feel less certain of yourself.' sobering_up_5 = \
  /sobering_up_0

/def drink_with_check = \
  /if (have_alcohol & !drunk & effect_count('berserk')) \
    /drink%; \
  /endif

/def drink = \
  /if (bag) \
    !get keg %{1-%{kegs}} from bag of holding%; \
  /elseif (kegs > 1) \
    !keep keg %{kegs}%; \
    !give keg %{kegs} to $[me()]%; \
    !keep all keg%; \
  /endif%; \
  !drink%; \
  /if (bag) \
    !put keg in bag of holding%; \
  /endif

/def cskeg = \
  /let _count=%{1-1}%; \
  /wd $[_count * 2000]%; \
  /fr_cs%; \
  /to_uhruul%; \
  /z -q -- enter;d;2 e;n%; \
  /if (bag) \
    !get all gold from bag of holding%; \
  /endif%; \
  !%{_count} buy keg%; \
  !count keg%; \
  /if (bag) \
    !put all keg in bag of holding%; \
  /endif%; \
  !keep all keg%; \
  /z -q -- s;2 w;u;out%; \
  /fr_uhruul%; \
  /to_cs

/def csrefill = \
  /let _count=%{1-%{kegs}}%; \
  /wd $[_count * 1000]%; \
  /fr_cs%; \
  /to_uhruul%; \
  /z -q -- enter;d;2 e;n%; \
  /if (bag) \
    !get all gold from bag of holding%; \
  /endif%; \
  /let i=0%; \
  /while (i < _count) \
    /if (bag) \
      !get keg %{_count} from bag of holding%; \
    /else \
      !keep keg %{_count}%; \
      !give keg %{_count} to $[me()]%; \
    /endif%; \
    !refill%; \
    /if (bag) \
      !put keg in bag of holding%; \
    /endif%; \
    /test ++i%; \
  /done%; \
  !keep all keg%; \
  /z -q -- s;2 w;u;out%; \
  /fr_uhruul%; \
  /to_cs

/def si_dwarf = \
  /fr_cs%; \
  /to_uhruul%; \
  /z -q -- enter;3 d;e%; \
  !sell noeq%; \
  /if (bag & stuff_bag) \
    !get all flute from bag of holding%; \
    !sell all from bag of holding%; \
    !put all flute in bag of holding%; \
    !keep all flute%; \
  /endif%; \
  /z -q -- w;3 u;out%; \
  /fr_uhruul%; \
  /to_cs%; \
  /if (bag & p_cash > 0) \
    !put %{p_cash} gold in bag of holding%; \
  /endif

/def add_stats_swing = \
  /if ({#}) \
    /let _points=%{2-1}%; \
    /let _current=stats_swing_%{1}%; \
    /test _current := %{_current}%; \
    /set stats_swing_%{1}=$[_current + _points]%; \
    /let _total=stats_swing_%{1}_total%; \
    /test _total := %{_total}%; \
    /set stats_swing_%{1}_total=$[_total + _points]%; \
  /endif

/def init_stats_swing = \
  /while ({#}) \
    /set stats_swing_%{1}=0%; \
    /shift%; \
  /done

/def init_stats_swing_total = \
  /init_stats_swing %{*}%; \
  /while ({#}) \
    /init_stats_swing %{1}_total%; \
    /shift%; \
  /done

/def check_berserk = \
  /if (!effect_count('berserk')) \
    /echo -w -aBCblue You are not going Berserk!%; \
  /endif

/def -Fp5 -mglob -t'You let out a not so mighty yelp in an attempt to scare *' stats_swing_mighty_yelp = /add_stats_swing mighty_yelp%; /check_berserk
/def -Fp5 -mglob -t'Fearlessly you throw yourself right through *' stats_swing_fearlessly = /add_stats_swing fearlessly%; /check_berserk
/def -Fp5 -mglob -t'Running straight at * you make a powerful sweep *' stats_swing_powerful_sweep = /add_stats_swing powerful_sweep%; /check_berserk
/def -Fp5 -mglob -t'Pumping with adrenaline you release a furious kick *' stats_swing_ferocious_kick = /add_stats_swing ferocious_kick%; /check_berserk
/def -Fp5 -mglob -t'Pumped up with adrenaline you release a furious kick *' stats_swing_ferocious_kick_b = /add_stats_swing ferocious_kick%; /check_berserk
/def -Fp5 -mglob -t'Without fear for your own safety you drop all defenses, *' stats_swing_without_fear = /add_stats_swing without_fear%; /check_berserk
/def -Fp5 -mglob -t'Without any shred of fear for your own safety *' stats_swing_without_fear_b = /add_stats_swing without_fear%; /check_berserk
/def -Fp5 -mglob -t'You lash out wildly, *' stats_swing_lash_out_wildly = /add_stats_swing lash_out_wildly%; /check_berserk
/def -Fp5 -mglob -t'With a mighty ROAR you make *' stats_swing_mighty_roar = /add_stats_swing mighty_roar%; /check_berserk
/def -Fp5 -mglob -t'Your painful attack leaves * stunned and confused!' stats_swing_stun = /add_stats_swing stun
/def -Fp5 -mglob -t'Your fierce attack makes * forget what it was doing!' stats_swing_interrupt = /add_stats_swing interrupt

/def stats_swing = \
  /if ({#}) \
    /if ({*} =~ 'reset') \
      /init_stats_swing \
        mighty_yelp \
        fearlessly \
        powerful_sweep \
        ferocious_kick \
        without_fear \
        lash_out_wildly \
        mighty_roar \
        stun \
        interrupt%; \
      /return%; \
    /elseif ({*} =~ 'reset all') \
      /init_stats_swing_total \
        mighty_yelp \
        fearlessly \
        powerful_sweep \
        ferocious_kick \
        without_fear \
        lash_out_wildly \
        mighty_roar \
        stun \
        interrupt%; \
      /return%; \
    /endif%; \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen%; \
  /endif%; \
  /let stats_swing=$[\
      stats_swing_mighty_yelp + \
      stats_swing_fearlessly + \
      stats_swing_powerful_sweep + \
      stats_swing_ferocious_kick + \
      stats_swing_without_fear + \
      stats_swing_lash_out_wildly + \
      stats_swing_mighty_roar]%; \
  /let stats_swing_total=$[\
      stats_swing_mighty_yelp_total + \
      stats_swing_fearlessly_total + \
      stats_swing_powerful_sweep_total + \
      stats_swing_ferocious_kick_total + \
      stats_swing_without_fear_total + \
      stats_swing_lash_out_wildly_total + \
      stats_swing_mighty_roar_total]%; \
  /execute %{_cmd} .-------------------------------------------------------------------.%; \
  /execute %{_cmd} | Ferocious Swing Statistics:                                       |%; \
  /execute %{_cmd} |---------------------------.-------------------.-------------------|%; \
  /execute %{_cmd} |                           |      Session      |       Total       |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('mighty yelp', -25)] | $[pad(stats_swing_mighty_yelp, 8)] ($[pad(round(stats_swing_mighty_yelp * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_mighty_yelp_total, 8)] ($[pad(round(stats_swing_mighty_yelp_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('fearlessly', -25)] | $[pad(stats_swing_fearlessly, 8)] ($[pad(round(stats_swing_fearlessly * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_fearlessly_total, 8)] ($[pad(round(stats_swing_fearlessly_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('powerful sweep', -25)] | $[pad(stats_swing_powerful_sweep, 8)] ($[pad(round(stats_swing_powerful_sweep * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_powerful_sweep_total, 8)] ($[pad(round(stats_swing_powerful_sweep_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('ferocious kick', -25)] | $[pad(stats_swing_ferocious_kick, 8)] ($[pad(round(stats_swing_ferocious_kick * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_ferocious_kick_total, 8)] ($[pad(round(stats_swing_ferocious_kick_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('without fear', -25)] | $[pad(stats_swing_without_fear, 8)] ($[pad(round(stats_swing_without_fear * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_without_fear_total, 8)] ($[pad(round(stats_swing_without_fear_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('lash out wildly', -25)] | $[pad(stats_swing_lash_out_wildly, 8)] ($[pad(round(stats_swing_lash_out_wildly * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_lash_out_wildly_total, 8)] ($[pad(round(stats_swing_lash_out_wildly_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('mighty roar', -25)] | $[pad(stats_swing_mighty_roar, 8)] ($[pad(round(stats_swing_mighty_roar * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_mighty_roar_total, 8)] ($[pad(round(stats_swing_mighty_roar_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('stun', -25)] | $[pad(stats_swing_stun, 8)] ($[pad(round(stats_swing_stun * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_stun_total, 8)] ($[pad(round(stats_swing_stun_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} | $[pad('interrupt', -25)] | $[pad(stats_swing_interrupt, 8)] ($[pad(round(stats_swing_interrupt * 100.0 / (stats_swing ? stats_swing : 1), 1), 5)]%%) | $[pad(stats_swing_interrupt_total, 8)] ($[pad(round(stats_swing_interrupt_total * 100.0 / (stats_swing_total ? stats_swing_total : 1), 1), 5)]%%) |%; \
  /execute %{_cmd} |---------------------------+-------------------+-------------------|%; \
  /execute %{_cmd} | $[pad('total', -25)] | $[pad(trunc(stats_swing), 17)] | $[pad(trunc(stats_swing_total), 17)] |%; \
  /execute %{_cmd} '---------------------------'-------------------'-------------------'%; \
  /save_dwarf

/def dwarf_axe_pref = \
  /if ({1} =~ 'magical' | {1} =~ 'magic' | {1} =~ 'mag') \
    /result 0%; \
  /elseif ({1} =~ 'psionic' | {1} =~ 'psi') \
    /result 1%; \
  /elseif ({1} =~ 'fire') \
    /result 2%; \
  /elseif ({1} =~ 'cold') \
    /result 3%; \
  /elseif ({1} =~ 'electrical' | {1} =~ 'electric' | {1} =~ 'elec') \
    /result 4%; \
  /elseif ({1} =~ 'poison' | {1} =~ 'poi') \
    /result 5%; \
  /elseif ({1} =~ 'asphyxiation' | {1} =~ 'asp') \
    /result 6%; \
  /elseif ({1} =~ 'acid') \
    /result 7%; \
  /endif%; \
  /result -1

/def dwarf_axe = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _num=$[dwarf_axe_pref({1})]%; \
  /if (_num < 0) \
    /return%; \
  /endif%; \
  /let _moves=$[_num - dwarf_axe]%; \
  /if (_moves < 0) \
    /test _moves += 8%; \
  /endif%; \
  /if (_moves > 0) \
    !%{_moves} chant pahtuljak tohkohp%; \
  /endif

/def -Fp5 -msimple -t'As you complete the chant, the axe starts to glow faintly.' dwarf_axe_magical = \
  /substitute -p -- %{*} [@{BCmagenta}magical@{n}]%; \
  /set dwarf_axe=$[dwarf_axe_pref('magical')]

/def -Fp5 -msimple -t'As you complete the chant, images of heroic deeds fill your mind.' dwarf_axe_psionic = \
  /substitute -p -- %{*} [@{BCblue}psionic@{n}]%; \
  /set dwarf_axe=$[dwarf_axe_pref('psionic')]

/def -Fp5 -msimple -t'As you complete the chant, the axe suddenly feels warmer.' dwarf_axe_fire = \
  /substitute -p -- %{*} [@{BCred}fire@{n}]%; \
  /set dwarf_axe=$[dwarf_axe_pref('fire')]

/def -Fp5 -msimple -t'As you complete the chant, the axe suddenly feels colder.' dwarf_axe_cold = \
  /substitute -p -- %{*} [@{BCblue}cold@{n}]%; \
  /set dwarf_axe=$[dwarf_axe_pref('cold')]

/def -Fp5 -msimple -t'As you complete the chant, you feel a sizzling sensation.' dwarf_axe_electric = \
  /substitute -p -- %{*} [@{BCcyan}electric@{n}]%; \
  /set dwarf_axe=$[dwarf_axe_pref('electric')]

/def -Fp5 -msimple -t'As you complete the chant, you hear the hiss of a viper.' dwarf_axe_poison = \
  /substitute -p -- %{*} [@{BCyellow}poison@{n}]%; \
  /set dwarf_axe=$[dwarf_axe_pref('poison')]

/def -Fp5 -msimple -t'As you complete the chant, you feel like it is harder to breathe for a moment.' dwarf_axe_asphyxiation = \
  /substitute -p -- %{*} [@{BCwhite}asphyxiation@{n}]%; \
  /set dwarf_axe=$[dwarf_axe_pref('asphyxiation')]

/def -Fp5 -msimple -t'As you complete the chant, there is a strong smell of sulphur.' dwarf_axe_acid = \
  /substitute -p -- %{*} [@{Cgreen}acid@{n}]%; \
  /set dwarf_axe=$[dwarf_axe_pref('acid')]

/def -Fp5 -msimple -h'SEND @save' save_dwarf = /mapcar /listvar stats_swing_*_total %| /writefile $[save_dir('dwarf')]
/eval /load $[save_dir('dwarf')]
