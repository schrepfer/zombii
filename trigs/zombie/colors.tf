;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; COLORS & HIGHLIGHT TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-18 14:58:09 -0700 (Mon, 18 Oct 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/colors.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/colors.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def -Fp10 -aBCbgblue,Cwhite -msimple -t'You are no longer stunned.' color_unstunned_0
/def -Fp10 -aBCbgblue,Cwhite -msimple -t'You break out from the stun.' color_unstunned_1
/def -Fp10 -aBCbgblue,Cwhite -msimple -t'Your arm is no longer numb.' color_no_longer_numb
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You stagger and see stars appear before your eyes, making you lose ' color_slash_stagger_0
/def -Fp10 -aBCbgred,Cwhite -msimple -t'your concentration. ' color_slash_stagger_1
/def -Fp10 -aBCbgred,Cwhite -mregexp -t'^[A-Za-z,:\' -]+ awesome slash breaks your concentration\\.$' color_slash_stun
/def -Fp10 -aBCbgred,Cwhite -mregexp -t'^[A-Z][a-z]+ moves with amazing speed and disarms you with a hurtful blow!$' color_disarmed
/def -Fp10 -aBCbgred,Cwhite -mregexp -t'^[A-Z][a-z]+\'s attack breaks your concentration\\.$' color_concentration_broken
/def -Fp10 -aBCbgred,Cwhite -mregexp -t'^[A-Z][a-z]+\'s taunting enrages you\\.$' color_taunted
/def -Fp10 -aBCbgred,Cwhite -mregexp -t'^[A-Za-z,:\' -]+ tumbles and avoids your spell!$' color_tumble
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You fail miserably.' color_fail_spell_3
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You fail the spell.' color_fail_spell_4
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You have trouble concentrating and fail the spell.' color_fail_spell_0
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You lose your balance and stumble, ruining the spell.' color_fail_spell_5
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You lose your concentration and fail the spell.' color_fail_spell_10
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You poke yourself in the eye and the spell misfires.' color_fail_spell_2
/def -Fp10 -aBCbgred,Cwhite -msimple -t'Your spell just fizzles.' color_fail_spell_7
/def -Fp10 -aBCbgred,Cwhite -msimple -t'Your spell just sputters.' color_fail_spell_1
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You scream with frustration as the spell utterly fails.' color_fail_spell_6
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You stumble over the spell\'s complexity and mumble the words.' color_fail_spell_8
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You stutter the magic words and fail the spell.' color_fail_spell_11
/def -Fp10 -aBCbgred,Cwhite -msimple -t'You think of Leper and become too scared to cast your spell.' color_fail_spell_9
/def -Fp10 -aBCblack -mregexp -t'^[A-Za-z,:\' -]+ nimbly dodges your hit\\.$' color_they_dodge
/def -Fp10 -aBCblack -mregexp -t'^[A-Za-z,:\' -]+ skillfully parries your hit\\.$' color_they_parry
/def -Fp10 -aBCblue -mregexp -t'^[A-Za-z,:\' -]+ hits you \\d+ times\\.$' color_hits_1
/def -Fp10 -aBCblue -mregexp -t'^You hit [A-Za-z,:\' -]+ \\d+ times\\.$' color_hits_0
/def -Fp10 -aBCgreen -mregexp -t'^(You are done with the chant|You are finished with your spell|You are prepared to do the skill)\\.' color_done_sksp
/def -Fp10 -aBCgreen -msimple -t'You are done with the chant.' color_done_with_chant
/def -Fp10 -aBCgreen -msimple -t'You are prepared to do the skill.' color_done_with_skill
/def -Fp10 -aBCgreen -msimple -t'You begin to weave your spell.' color_weave
/def -Fp10 -aBCgreen -msimple -t'You break your skill attempt.' color_break_skill
/def -Fp10 -aBCgreen -msimple -t'You start chanting.' color_chant
/def -Fp10 -aBCgreen -msimple -t'You start concentrating on the skill.' color_use_skill
/def -Fp10 -aBCgreen -msimple -t'You start concentrating on the skill.' color_use_skill
/def -Fp10 -aBCred -mregexp -t'^[A-Z][a-z]+ breaks [a-z]+ concentration\\.$' color_other_break_chant
/def -Fp10 -aBCred -mregexp -t'^[A-Za-z,:\' -]+ inner strength helps (him|it|her) to avoid being stunned!$' color_inner_strength_other_0
/def -Fp10 -aBCred -mregexp -t'^[A-Za-z,:\' -]+ inner strength helps (him|it|her) to lessen the stun!$' color_inner_strength_other_1
/def -Fp10 -aBCred -mregexp -t'^[A-Za-z,:\' -]+ starts concentrating on a spell\\.$' color_other_chant
/def -Fp10 -aBCred -msimple -t'*NEW ROUND*' color_round
/def -Fp10 -aBCred -msimple -t'You don\'t have enough spell points.' color_out_of_spell_points
/def -Fp10 -aBCwhite -mregexp -t'^[A-Za-z,:\' -]+ utters the magic words \'$' color_cast_spell
/def -Fp10 -aBCyellow -mregexp -t'^[A-Za-z,:\' -]+ is almost DEAD\\.$' color_scan_6
/def -Fp10 -aBCyellow -mregexp -t'^[A-Za-z,:\' -]+ is DEAD, R\\.I\\.P\\.$' color_dead
/def -Fp10 -aBCyellow -mregexp -t'^[A-Za-z,:\' -]+ is in bad shape\\.$' color_scan_4
/def -Fp10 -aBCyellow -mregexp -t'^[A-Za-z,:\' -]+ is in good shape\\.$' color_scan_0
/def -Fp10 -aBCyellow -mregexp -t'^[A-Za-z,:\' -]+ is in very bad shape\\.$' color_scan_5
/def -Fp10 -aBCyellow -mregexp -t'^[A-Za-z,:\' -]+ is moderately hurt\\.$' color_scan_2
/def -Fp10 -aBCyellow -mregexp -t'^[A-Za-z,:\' -]+ is not in a good shape\\.$' color_scan_3
/def -Fp10 -aBCyellow -mregexp -t'^[A-Za-z,:\' -]+ is slightly hurt\\.$' color_scan_1
/def -Fp10 -aB -mregexp -t'^(Two|Three|Four|Five|Six|Seven|Eight|Nine|Ten|Many) times [A-Z][a-z]+ ' color_mirrors
/def -Fp10 -aCbgyellow,Cblack -mregexp -t'^[A-Z][a-z]+ focusses intently on you!$' color_bag_stealing
/def -Fp10 -aCbgyellow,Cblack -msimple -t'You feel like someone is looking over your shoulder.' color_somebody_snooping
/def -Fp10 -aCcyan -mglob -t'..seeking retribution, you launch a riposte at *, mangling * leg.' color_riposte
/def -Fp10 -aCcyan -mglob -t'You get STUNNED from the force of the attack.' color_get_stunned
/def -Fp10 -aCcyan -mglob -t'You nimbly dodge *\'s hit.' color_dodge
/def -Fp10 -aCcyan -mglob -t'You skillfully parry *\'s hit.' color_parry
/def -Fp10 -aCcyan -mregexp -t'^You STUN [A-Za-z,:\' -]+\\.$' color_stuns
/def -Fp10 -aCcyan -msimple -t'You feel fully healed.' color_full_hp
/def -Fp10 -aCcyan -msimple -t'Your inebriated state augments your blows with deadly strength!' color_inebriated
/def -Fp10 -aCcyan -msimple -t'Your inner strength helps you to avoid being stunned!' color_inner_strength_1
/def -Fp10 -aCcyan -msimple -t'Your inner strength helps you to lessen the stun!' color_inner_strength_0
/def -Fp10 -aCcyan -msimple -t'You score a CRITICAL hit!' color_criticals
/def -Fp10 -aCcyan -msimple -t'You score an extra critical hit due to your organ knowledge.' color_organ_knowledge
/def -Fp10 -aCcyan -msimple -t'You sizzle with magical energy.' color_full_sp
/def -Fp10 -aCgreen -mregexp -t'^[A-Za-z@0-9-]+ tells you,? [^\']*\'.*\'$' color_tells
/def -Fp10 -aCgreen -mregexp -t'^You attempt to tell ' color_failed_tells_to
/def -Fp10 -aCgreen -mregexp -t'^You tell ' color_tells_to
/def -Fp10 -aCred -mglob -t'[Bank]: *' color_bank
/def -Fp10 -aCred -mglob -t'Your taunting enrages *.' color_taunt
/def -Fp10 -aCred -mglob -t'You reflect * skill aside.' color_reflect
/def -Fp10 -aCred -mregexp -t'^A raven arrives in a cloud of black feathers\\.$' color_movement_10
/def -Fp10 -aCred -mregexp -t'^A raven flies in( from the [a-z]+)?\\.$' color_movement_8
/def -Fp10 -aCred -mregexp -t'^A silvery fish arrives in a whirlpool of bubbles\\.$' color_movement_12
/def -Fp10 -aCred -mregexp -t'^A silvery fish swims( from the [a-z]+)?\\.$' color_movement_14
/def -Fp10 -aCred -mregexp -t'^[A-Za-z,:\' -]+ (arrives|floats in|fades in|sneaks in|trudges in)( from the [a-z]+)?\\.$' color_movement_0
/def -Fp10 -aCred -mregexp -t'^[A-Z][A-Za-z,:\' -]+ attacks .+\\.$' color_attacks
/def -Fp10 -aCred -mregexp -t'^[A-Za-z,:\' -]+ (disappears|arrives) in a puff of smoke\\.$' color_movement_2
/def -Fp10 -aCred -mregexp -t'^[A-Za-z,:\' -]+ (leaves|floats|sneaks away|flies|flies from)( [a-z]+)?\\.$' color_movement_1
/def -Fp10 -aCred -mregexp -t'^([A-Za-z,:\' -]+) seems to have regained control of [a-z]+!$' color_other_unstunned
/def -Fp10 -aCred -mregexp -t'^([A-Za-z,:\' -]+) staggers and reels from the blow!$' color_other_stunned
/def -Fp10 -aCred -mregexp -t'^Heavenly Angel flies (in|off) to destroy evil( from the [a-z]+)?\\.$' color_movement_4
/def -Fp10 -aCred -mregexp -t'^Heavenly Angel (leaves|arrives) amidst a flutter of wings\\.$' color_movement_5
/def -Fp10 -aCred -mregexp -t'^Mind Flayer (leaves|arrives) in a puff of dark black smoke\\.$' color_movement_6
/def -Fp10 -aCred -mregexp -t'^Mind Flayer stalks (in|off) in search of brains( from the [a-z]+)?\\.$' color_movement_3
/def -Fp10 -aCred -mregexp -t'^The fish disappears into a whirlpool of bubbles\\.$' color_movement_11
/def -Fp10 -aCred -mregexp -t'^The fish flicks its tail and swims [a-z]+\\.$' color_movement_13
/def -Fp10 -aCred -mregexp -t'^The raven disappears into a cloud of black feathers\\.$' color_movement_9
/def -Fp10 -aCred -mregexp -t'^The raven flaps its wings and flies away [a-z]+\\.$' color_movement_7
/def -Fp10 -aCyellow -mregexp -t'^[A-Za-z,:\' -]+ is in vigorous combat with ([A-Za-z,:\' -]+)\\.' color_combat
/def -Fp10 -ag -mregexp -t'^[A-Z][a-z]+ hoists a drink to the King!$' gag_dwarf_3
/def -Fp10 -ag -mregexp -t'^[A-Z][a-z]+ lifts (his|hers|its) keg and takes a big gulp of ale from it\\.$' gag_dwarf_2
/def -Fp10 -ag -mregexp -t'^[A-Z][a-z]+ looks like he really enjoys (his|hers|its) drink\\.$' gag_dwarf_1
/def -Fp10 -ag -mregexp -t'^[A-Z][a-z]+ puts A wooden beer keg in bag\\.$' gag_dwarf_4
/def -Fp10 -ag -mregexp -t'^[A-Z][a-z]+ takes A wooden beer keg from bag\\.$' gag_dwarf_0
/def -Fp10 -ag -mregexp -t'^fd:' gag_socket_error_0
/def -Fp10 -ag -mregexp -t'^return value: \\d+ \\(compile time: \\d+ms\\)$' gag_zplc_1
/def -Fp10 -ag -mregexp -t'^socket_connect:' gag_socket_error_1
/def -Fp10 -ag -msimple -t'You are not in battle.' gag_errors_0
/def -Fp10 -ag -msimple -t'You are not in combat.' gag_errors_1
/def -Fp10 -ag -msimple -t'ZombieMud Programming Language Compiler v0.3' gag_zplc_0
/def -Fp10 -ar -mregexp -t'^[A-Z][a-z]+ throws an iron bell at you.  KLING!!!$' color_bell
/def -Fp10 -aBCred -mregexp -t'^\\[([A-Z][a-z]+)\\] transfered (\\d+) gold\\.$' color_transfer
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^[A-Z][a-z]+ BARBARICALLY screams \'BANZAI\' and KIRU at ' color_kiru_0
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^[A-Z][a-z]+ fiercily screams \'BANZAI\' and slash at ' color_kiru_1
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^[A-Z][a-z]+ fiercily shouts \'Kiaaaa\' and manages to DECIMATE ' color_ki_0
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^[A-Z][a-z]+ furiously shouts \'Kiaaaa\' and manages to massacre ' color_ki_1
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^[A-Z][a-z]+ lets out a ferocious roar and pins (his|her|its) opponent down\\.$' color_battlecry_2
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^[A-Z][a-z]+ passionately shouts \'Kiaaaa\' and manages to crush ' color_ki_2
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^[A-Z][a-z]+ sputters out a cheap roar and seems to surprise .*!$' color_battlecry_1
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^[A-Z][a-z]+ strongly screams \'BANZAI\' and kiru at ' color_kiru_2
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^Without reservation, [A-Z][a-z]+ unleashes a brutal scream!$' color_battlecry_0
/def -Fp10 -mregexp -aCblue,Cbgwhite -t'^Your blood curdles as you hear [A-Z][a-z]+\'s battlecry!$' color_battlecry_3
/def -Fp10 -mglob -aCbggreen,Cblack -t'You open the * leading *.' color_open
/def -Fp10 -mglob -aCbgmagenta,Cblack -t'You close the * leading *.' color_close
/def -Fp10 -mglob -aCbgred,Cblack -t'You lock the * leading *.' color_lock
/def -Fp10 -mglob -aCbgblue,Cblack -t'You unlock the * leading *.' color_unlock
/def -Fp10 -mglob -aCgreen -t'The * leading * is already open.' color_opened
/def -Fp10 -mglob -aCmagenta -t'The * leading * is already closed.' color_closed
/def -Fp10 -mglob -aCred -t'The * leading * is already locked.' color_locked
/def -Fp10 -mglob -aCblue -t'The * leading * is already unlocked.' color_unlocked

/def -Fp10 -mregexp -t'^(([A-Z][a-z]{2} \\d{2} )?\\d{2}:\\d{2} )?([A-Z][a-z0-9 -]+ | )?([\\[{<]{1,2}([a-z]+)[>}\\]]{1,2}:) (.*)$' color_channels = \
  /if ({P5} =~ 'party') \
    /substitute -p -- %{P1}%{P3}@{BCblue}%{P4}@{n} %{P6}%; \
  /elseif ({P5} =~ 'sales') \
    /substitute -p -- %{P1}%{P3}@{BCyellow}%{P4}@{n} %{P6}%; \
  /elseif ({P5} =~ 'inform' | {P5} =~ 'info') \
    /substitute -p -- %{P1}%{P3}@{BCred}%{P4}@{n} %{P6}%; \
  /elseif ({P5} =~ 'mud' | {P5} =~ 'chat' | {P5} =~ 'alert') \
    /substitute -p -- %{P1}%{P3}@{BCgreen}%{P4}@{n} %{P6}%; \
  /else \
    /substitute -p -- %{P1}%{P3}@{BCcyan}%{P4}@{n} %{P6}%; \
  /endif

/def -Fp10 -agL -mregexp -t'^A bubble in the slime around (you|[A-Z][a-z]+) pops, making a farting sound\\.$' gag_slime_0
/def -Fp10 -agL -mregexp -t'^Some slime begins to tickle you\\.  It feels nice\\.$' gag_slime_1
/def -Fp10 -agL -mregexp -t'^Some slime drips from (your|[A-Z][a-z]+\'s) body\\.$' gag_slime_2
/def -Fp10 -agL -mregexp -t'^Some slime drips into [A-Z][a-z]+\'s underwear, making (him|her|it) squirm\\.$' gag_slime_3
/def -Fp10 -agL -mregexp -t'^The slime covering (you|[A-Z][a-z]+) begins to STINK like ROTTEN CHEESE!$' gag_slime_4
/def -Fp10 -agL -mregexp -t'^The slime covering (you|[A-Z][a-z]+) begins to move and shift on its own!$' gag_slime_5
/def -Fp10 -agL -mregexp -t'^The slime covering (you|[A-Z][a-z]+) begins to smell like rotten cheese\\.$' gag_slime_6
/def -Fp10 -agL -mregexp -t'^The slime covering (you|[A-Z][a-z]+) emits the lovely odor of rotting fish\\.$' gag_slime_7
/def -Fp10 -agL -mregexp -t'^The slime on (you|[A-Z][a-z]+) emits the lovely odor of rotting fish\\.$' gag_slime_8
/def -Fp10 -agL -mregexp -t'^You are covered in foul piles of slime and goo!$' gag_slime_20
/def -Fp10 -agL -mregexp -t'^You are struck with a pile of the nasty slime\\.$' gag_slime_19
/def -Fp10 -agL -mregexp -t'^You freak out trying to rid yourself of the slime\\.$' gag_slime_9
/def -Fp10 -agL -mregexp -t'^You manage to rid yourself of the foul slime\\.$' gag_slime_10
/def -Fp10 -agL -mregexp -t'^You scratch irritably at some particularly annoying slime\\.$' gag_slime_11
/def -Fp10 -agL -mregexp -t'^You scream as the slime covering you begins to burn!$' gag_slime_12
/def -Fp10 -agL -mregexp -t'^You wave your arm, throwing bits of gross slime around\\.$' gag_slime_13
/def -Fp10 -agL -mregexp -t'^[A-Z][a-z]+ FREAKS OUT trying to get rid of the slime\\.$' gag_slime_14
/def -Fp10 -agL -mregexp -t'^[A-Z][a-z]+ is struck with a pile of the nasty slime\\.$' gag_slime_15
/def -Fp10 -agL -mregexp -t'^[A-Z][a-z]+ scratches irritiably at some particularly annoying slime\\.$' gag_slime_16
/def -Fp10 -agL -mregexp -t'^[A-Z][a-z]+ screams as the slime covering (him|her|it) begins to burn!$' gag_slime_17
/def -Fp10 -agL -mregexp -t'^[A-Z][a-z]+ waves (his|her|its) arm, throwing bits of gross slime around\\.$' gag_slime_18
/def -Fp10 -agL -msimple -t'It\'s night but you can still see.' gag_night_see
/def -Fp10 -msimple -t'A broken piece of a glowing weapon' araman_piece_0 = /substitute -p -- %{*} [@{B}Dehrait, Grytha@{n}]
/def -Fp10 -msimple -t'A glowing piece of a weapon' araman_piece_4 = /substitute -p -- %{*} [@{B}Graveyard@{n}]
/def -Fp10 -msimple -t'A piece of a weapon' araman_piece_1 = /substitute -p -- %{*} [@{B}Gelka@{n}]
/def -Fp10 -msimple -t'A piece of a weapon, glowing strongly' araman_piece_3 = /substitute -p -- %{*} [@{B}Mandok@{n}]
/def -Fp10 -msimple -t'A piece of an ancient weapon (glowing)' araman_piece_2 = /substitute -p -- %{*} [@{B}Leecher@{n}]
/def -Fp10 -msimple -t'It shines with brilliant red glow.' glow_brilliant = /substitute -p -- %{*} [@{B}8/8@{n}]
/def -Fp10 -msimple -t'It shines with shining red glow.' glow_shining = /substitute -p -- %{*} [@{B}7/8@{n}]
/def -Fp10 -msimple -t'It shines with vigorous red glow.' glow_vigorous = /substitute -p -- %{*} [@{B}6/8@{n}]
/def -Fp10 -msimple -t'It shines with strong red glow.' glow_strong = /substitute -p -- %{*} [@{B}5/8@{n}]
/def -Fp10 -msimple -t'It shines with red glow.' glow_red = /substitute -p -- %{*} [@{B}4/8@{n}]
/def -Fp10 -msimple -t'It shines with weak red glow.' glow_weak = /substitute -p -- %{*} [@{B}3/8@{n}]
/def -Fp10 -msimple -t'It shines with faint red glow.' glow_faint = /substitute -p -- %{*} [@{B}2/8@{n}]
/def -Fp10 -msimple -t'It shines with feeble red glow.' glow_feeble = /substitute -p -- %{*} [@{B}1/8@{n}]
/def -Fp10 -msimple -t'It shines with dull red glow.' glow_dull = /substitute -p -- %{*} [@{B}0/8@{n}]
