;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; DWARF TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-28 14:34:09 -0700 (Tue, 28 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/dwarf.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/dwarf.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]
/eval /require $[trigs_dir('zombie/stats')]

/def -Fp5 -msimple -t'Standing fearless in the heat of battle, you care less and less' gained_drunk_point = \
  /say -c'red' -- Gained Mountain Dwarf DRUNK Point

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_dwarf = \
  /stat_reset cleave%; \
  /stat_reset ferocious_swing%; \
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

;;;;
;;
;; Does your character currently have alcohol to drink? When you have alcohol
;; it will automatically be consumed whenever you are sober and are in battle.
;; This setting is automatically set when you "drink" the first time; it is
;; disabled when your keg is empty.
;;
/property -b have_alcohol

;;;;
;;
;; Is your character currently drunk? This set is automatically set after
;; you've consumed a beverage; it is disabled when you sober up.
;;
/property -b drunk

;;;;
;;
;; The number of kegs to swap between. This setting is automatically set when
;; you "count keg".
;;
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
  /z !enter;!3 d;!e%; \
  !sell noeq%; \
  /if (bag & stuff_bag) \
    !get all flute from bag of holding%; \
    !sell all from bag of holding%; \
    !put all flute in bag of holding%; \
    !keep all flute%; \
  /endif%; \
  /z !w;!3 u;!out%; \
  /fr_uhruul%; \
  /to_cs%; \
  /if (bag & p_cash > 0) \
    !put %{p_cash} gold in bag of holding%; \
  /endif

/def check_berserk = \
  /if (!effect_count('berserk')) \
    /echo -w -aBCblue You are not going Berserk!%; \
  /endif


/def_stat_group -g'cleave' -n'Cleave'
/def_stat -g'cleave' -k'vertical_sweep' -n'Veritcal Sweep' -r4
/def_stat -g'cleave' -k'unexpected_sidestep' -n'Unexpected Sidestep' -r5
/def_stat -g'cleave' -k'fierce_battlecry' -n'Fierce Battlecry' -r6
/def_stat -g'cleave' -k'brutal_strength' -n'Brutal Strength' -r7
/def_stat -g'cleave' -k'disembowel' -n'Disembowel' -r8
/def_stat -g'cleave' -k'stun' -n'Stun' -r0 -s
/def_stat -g'cleave' -k'interrupt' -n'Interrupt' -r1 -s

/def -Fp5 -mglob -t'You strike out in a vertical sweep with your *' stats_cleave_vertical_sweep = \
  /stat_update cleave vertical_sweep 1

/def -Fp5 -mglob -t'With a small unexpected sidestep to the * you move *' stats_cleave_unexpected_sidestep = \
  /stat_update cleave unexpected_sidestep 1

/def -Fp5 -mglob -t'Letting out a fierce battlecry you charge against *' stats_cleave_fierce_battlecry = \
  /stat_update cleave fierce_battlecry 1

/def -Fp5 -mglob -t'Starting with your * in a low position *' stats_cleave_brutal_strength = \
  /stat_update cleave brutal_strength 1

/def -Fp5 -mglob -t'With an upwards swing, cutting into *' stats_cleave_disembowel = \
  /stat_update cleave disembowel 1

/def -Fp5 -mglob -t'Your fierce attack makes * forget what * was doing!' stats_cleave_interrupt = \
  /stat_update cleave interrupt 1

/def -Fp5 -mglob -t'Your painful attack leaves * stunned and confused!' stats_cleave_stun = \
  /stat_update cleave stun 1

/def stats_cleave = /stat_display cleave %{*}


/def_stat_group -g'ferocious_swing' -n'Ferocious Swing'
/def_stat -g'ferocious_swing' -k'mighty_yelp' -n'Mighty Yelp' -r0
/def_stat -g'ferocious_swing' -k'fearlessly' -n'Fearlessly' -r1
/def_stat -g'ferocious_swing' -k'powerful_sweep' -n'Powerful Sweep' -r2
/def_stat -g'ferocious_swing' -k'ferocious_kick' -n'Ferocious Kick' -r3
/def_stat -g'ferocious_swing' -k'ferocious_kick' -n'Ferocious Kick' -r4
/def_stat -g'ferocious_swing' -k'without_fear' -n'Without Fear' -r5
/def_stat -g'ferocious_swing' -k'without_fear' -n'Without Fear' -r6
/def_stat -g'ferocious_swing' -k'lash_out_wildly' -n'Lash Out Wildly' -r7
/def_stat -g'ferocious_swing' -k'mighty_roar' -n'Mighty Roar' -r8
/def_stat -g'ferocious_swing' -k'stun' -n'Stun' -r0 -s
/def_stat -g'ferocious_swing' -k'interrupt' -n'Interrupt' -r1 -s

/def -Fp5 -mglob -t'You let out a not so mighty yelp in an attempt to scare *' stats_swing_mighty_yelp = \
  /stat_update ferocious_swing mighty_yelp 1%; \
  /check_berserk

/def -Fp5 -mglob -t'Fearlessly you throw yourself right through *' stats_swing_fearlessly = \
  /stat_update ferocious_swing fearlessly 1%; \
  /check_berserk

/def -Fp5 -mglob -t'Running straight at * you make a powerful sweep *' stats_swing_powerful_sweep = \
  /stat_update ferocious_swing powerful_sweep 1%; \
  /check_berserk

/def -Fp5 -mglob -t'Pumping with adrenaline you release a furious kick *' stats_swing_ferocious_kick = \
  /stat_update ferocious_swing ferocious_kick 1%; \
  /check_berserk

/def -Fp5 -mglob -t'Pumped up with adrenaline you release a furious kick *' stats_swing_ferocious_kick_b = \
  /stat_update ferocious_swing ferocious_kick 1%; \
  /check_berserk

/def -Fp5 -mglob -t'Without fear for your own safety you drop all defenses, *' stats_swing_without_fear = \
  /stat_update ferocious_swing without_fear 1%; \
  /check_berserk

/def -Fp5 -mglob -t'Without any shred of fear for your own safety *' stats_swing_without_fear_b = \
  /stat_update ferocious_swing without_fear 1%; \
  /check_berserk

/def -Fp5 -mglob -t'You lash out wildly, *' stats_swing_lash_out_wildly = \
  /stat_update ferocious_swing lash_out_wildly 1%; \
  /check_berserk

/def -Fp5 -mglob -t'With a mighty ROAR you make *' stats_swing_mighty_roar = \
  /stat_update ferocious_swing mighty_roar 1%; \
  /check_berserk

/def -Fp5 -mglob -t'Your painful attack leaves * stunned and confused!' stats_swing_stun = \
  /stat_update ferocious_swing stun 1

/def -Fp5 -mglob -t'Your fierce attack makes * forget what it was doing!' stats_swing_interrupt = \
  /stat_update ferocious_swing interrupt 1

/def stats_swing = /stat_display ferocious_swing %{*}

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

/def -Fp5 -msimple -h'SEND @save' save_dwarf = \
  /stat_save ferocious_swing $[stats_dir('ferocious_swing')]

/eval /stat_load ferocious_swing $[stats_dir('ferocious_swing')]
