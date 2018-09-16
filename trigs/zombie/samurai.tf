;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SAMURAI TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2012-01-25 18:42:22 -0800 (Wed, 25 Jan 2012) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/samurai.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/samurai.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]
/eval /require $[trigs_dir('zombie/stats')]

/set samurai=1


;;
;; HOOKS
;;

;;;;
;;
;; The number of seconds to wait before executing "sdrain" on a corpse. This
;; setting is useful to allow others to "rend" or loot the corpse first.
;;
/property -f -v'0.75' samurai_sdrain_delay

/def samurai_sdrain = \
  /if ({#} & !isin({*}, 'off', 'always', 'needed')) \
    /error -m'%{0}' -- must be one of: off, always, needed%; \
    /update_value -n'samurai_sdrain' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'samurai_sdrain' -v'$(/escape ' %{*})' -g

/def -Fp5 -mglob -h'SEND @on_loot *' on_loot_samurai = \
  /sword_stats%; \
  /if (samurai_sdrain =~ 'always' | (samurai_sdrain =~ 'needed' & (glove_life_points < 5 | party_members < 2))) \
    /repeat -%{samurai_sdrain_delay} 1 !sdrain%; \
  /endif

;; auto clear settings at connect
/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_samurai = \
  /stat_reset throw%; \
  /set samurai_sword_summoned=0%; \
  /set samurai_sword_wielded=0%; \
  /set glove_life_points=0%; \
  /set glove_spell_points=0%; \
  /mapcar /unset daimyo_wc daimyo_hit daimyo_dam daimyo_element daimyo_special daimyo_wc_diff daimyo_hit_diff daimyo_dam_diff

;;;;
;;
;; Do you currently have your sword summoned? This setting is automatically
;; configured when you type "eq", "slots" or summon your sword.
;;
/property -b samurai_sword_summoned

;;;;
;;
;; Do you currently have your sword wielded? This setting is automatically
;; configured when you type "eq", "slots" or "wield" your sword.
;;
/property -b samurai_sword_wielded

;;
;; Kenjutsu
;;

/def -Fp5 -msimple -t'You turn inwards and focus on Tebukuro kenjutsu.' skenjutsu_start = \
  /set skenjutsu=0

/def -Fp5 -msimple -t'You focus on the art of Tebukuro kenjutsu!' skenjutsu = \
  /test ++skenjutsu%; \
  /substitute -p -- %{*} [@{Cred}%{skenjutsu}@{n}]

/def -Fp5 -mregexp -t'^[A-Za-z\' -]+ anticipates your movement and your attempt at Tebukuro kenjutsu fails!$' skenjutsu_fails

/def -Fp5 -msimple -t'Your body seems to have recovered from the previous Tebukuro-kenjutsu.' skenjutsu_ready = \
  /say -c'green' -- Tebukuro-kenjutsu Ready!

;;
;; SAMURAI STATISTICS
;;

/def -Fp5 -aCcyan -mglob -t'You HEADCUT at * neck with a HARD swing!' samurai_headcut
/def -Fp5 -aCcyan -mglob -t'Your sword glows magically and echoes to your mind:*' samurai_tameshivar
/def -Fp5 -aCcyan -mglob -t'You CUT a piece of meat from *' samurai_chunk
/def -Fp5 -aCcyan -msimple -t'Your jigoku blade tears into the good being\'s soul sapping its life force.' samurai_jigoku
/def -Fp5 -aCcyan -msimple -t'Your tenrai glows brightly and burns the evil being\'s soul.' samurai_tenrai

/def -Fp18 -msimple -h'SEND @update_status' update_status_18 = \
  /update_status_x [life:$[trunc(glove_life_points)],sps:$[trunc(glove_spell_points)]]

/def glove_points = \
  /say -d'status' -c'green' -- Life points: %{glove_life_points}, Spell Points: %{glove_spell_points}%; \
  @update_status

/def scharge = \
  /if (p_sp >= 500 & glove_life_points & glove_spell_points <= 500) \
    !scharge%; \
  /endif

/def -Fp5 -aCcyan -msimple -t'You charge your glove with mental energy.' samurai_scharge = \
  /set glove_spell_points=$[min(glove_spell_points + (samurai_mastery_scharge * 5), 1000)]%; \
  /set glove_life_points=$[max(glove_life_points - 1, 0)]%; \
  /glove_points

/def -Fp5 -aCcyan -mglob -t'You fail to drain life force from the corpse of *.' samurai_sdrain_fail
/def -Fp5 -aCcyan -mglob -t'You drain the life force from corpse of *.' samurai_sdrain_succeed

/def -Fp5 -aCcyan -msimple -t'You fail magical walking skill.' samurai_smwalk_fail = \
  /set glove_spell_points=$[max(glove_spell_points - 100, 0)]%; \
  /set glove_life_points=$[max(glove_life_points - 2, 0)]%; \
  /glove_points

/def -Fp4 -aCcyan -msimple -t'You start walking magically.' samurai_smwalk_succeed = \
  /set glove_spell_points=$[max(glove_spell_points - 100, 0)]%; \
  /set glove_life_points=$[max(glove_life_points - 2, 0)]%; \
  /glove_points

/def -Fp5 -aCcyan -msimple -t'You cast lightsword in your sword.' samurai_lightsword
/def -Fp5 -aCcyan -msimple -t'You cast razor edge in your sword.' samurai_razor_edge
/def -Fp5 -aCcyan -msimple -t'You cast silver sheen in your sword.' samurai_silver_sheen

/def -Fp5 -aCcyan -msimple -t'Your mastery in the ancient enchanting magic fortifies the spell.' samurai_senchant

/def -Fp5 -aCcyan -msimple -t'You cast a jigoku blade spell at your sword.' samurai_jigoku_blade
/def -Fp5 -aCcyan -msimple -t'You cast a tenrai blade spell at your sword.' samurai_tenrai_blade

;;;;
;;
;; Should scharge automatically be executed when you use life forces from the
;; glove and you have enough spell points? This makes the grinding of masteries
;; much more pleasant.
;;
/property -b samurai_auto_scharge

/def -Fp5 -ag -msimple -t'Your glove glows a moment and feels warm.' samurai_glove_warm = \
  /glove_points

/def -Fp5 -aCcyan -msimple -t'Your glove flashes for a moment.' samurai_glove = \
  /if (glove_spell_points >= 100) \
    /set glove_spell_points=$[glove_spell_points - 100]%; \
  /else \
    /set glove_life_points=$[max(glove_life_points - 1, 0)]%; \
  /endif%; \
  /if (samurai_auto_scharge) \
    /scharge%; \
  /endif%; \
  /glove_points

/def -Fp5 -msimple -t'You turn inwards and focus on Tebukuro kenjutsu.' samurai_skenjutsu = \
  /if (glove_spell_points >= 300) \
    /set glove_spell_points=$[glove_spell_points - 300]%; \
  /else \
    /set glove_life_points=$[max(glove_life_points - 3, 0)]%; \
  /endif%; \
  /glove_points

/def -Fp5 -aCcyan -msimple -t'You turn your mind inwards, and seek out the essence of your Warrior Spirit.' samurai_sspirit = \
  /if (glove_spell_points >= 500) \
    /set glove_spell_points=$[glove_spell_points - 500]%; \
  /else \
    /set glove_life_points=$[max(glove_life_points - 5, 0)]%; \
  /endif%; \
  /glove_points

/def -Fp5 -msimple -t'You can\'t carry anymore shurikens.' full_shuriken = /send !cast stop

/property -b throw_from_bag

/def -Fp5 -mglob -t'You throw a shuriken *' throw_bag  = \
  /if (bag & throw_from_bag) \
    !get shuriken from bag of holding%; \
  /endif

/def -Fp5 -mglob -h'SEND @on_start_attack *' on_start_attack_samurai = \
  /throw_bag

/def -Fp5 -msimple -t'You lose much face in the eyes of your ancestors, trying to throw an nonexistant shuriken.' throw_no_shuriken = \
  /throw_bag

/def -Fp5 -aCcyan -mregexp -t'^You make a shuriken( and put it in the belt)?\\.$' samurai_shuriken

/def -Fp5 -ag -msimple -t'The corpse disappears with a dry puff of dust.' corpse_disappears

/def -Fp5 -ag -mregexp -t'^Your glove now has ([1-5]) life points\\.$' glove_life_points = \
  /set glove_life_points=%{P1}

/def -Fp5 -ag -mregexp -t'^Your glove now has (\\d{1,3}) sp points\\.$' glove_spell_points = \
  /set glove_spell_points=%{P1}

/def_stat_group -g'throw' -n'Throw'
/def_stat -g'throw' -k'physical' -n'Physical' -r0
/def_stat -g'throw' -k'acid' -n'Acid' -r0
/def_stat -g'throw' -k'incendiary' -n'Incendiary' -r0
/def_stat -g'throw' -k'poison' -n'Poison' -r0
/def_stat -g'throw' -k'spot_weakness' -n'Spot Weakness' -r1 -s
/def_stat -g'throw' -k'critical' -n'Critical' -r1 -s
/def_stat -g'throw' -k'break' -n'Break' -r2 -s

/def -Fp5 -mglob -t'You throw a shuriken <acid> at *' throw_acid_shuriken = \
  /stat_update throw acid 1

/def -Fp5 -mglob -t'You throw a shuriken <incendiary> at *' throw_incendiary_shuriken = \
  /stat_update throw incendiary 1

/def -Fp5 -mglob -t'You throw a shuriken <poison> at *' throw_poison_shuriken = \
  /stat_update throw poison 1

/def -Fp5 -mglob -t'You throw a shuriken at *' throw_physical_shuriken = \
  /stat_update throw physical 1

/def -Fp5 -msimple -t'Your special training allows to exploit a weakness in your opponent\'s defenses.' throw_spot_weakness = \
  /stat_update throw spot_weakness 1

/def -Fp5 -aCcyan -mglob -t'The critical throw renders * weak and stunned!' throw_critical = \
  /stat_update throw critical 1

/def -Fp5 -aCred -mglob -t'The shuriken breaks upon impact.' throw_break = \
  /stat_update throw break 1

/def stats_throw = /stat_display throw %{*}

/def spunch = \
  !cast stop%; \
  !spunch %{*-%{target}}%; \
  /kx

/def -Fp5 -aBCred -msimple -t'The blade loses some of its magical ability.' samurai_blade_boost_falls = \
  /sword_stats

/def -Fp5 -msimple -t'You can\'t enchant sword just now.' samurai_can_not_boost = /sword_stats

/def -Fp5 -aBCyellow -msimple -t'This corpse doesn\'t have enough life power.' sdrain_failed = /tin

/def -Fp5 -aCcyan -mglob -t'You CUT a piece of meat from *' cut_meat = \
  /if (bag) \
    !get all chunk to bag of holding%; \
  /else \
    !get all chunk%; \
  /endif

;;
;; SAMURAI COMMANDS AND BOOSTING
;;

/def boost_sword_till = \
  /let _limit=%{1}%; \
  /if (daimyo_wc < _limit & daimyo_wc < samurai_sword_wc_max) \
    /ss_wc %{samurai_sword_wc_max}%; \
    /result 1%; \
  /elseif (daimyo_dam < _limit & daimyo_dam < samurai_sword_dam_max) \
    /ss_dam %{samurai_sword_dam_max}%; \
    /result 1%; \
  /elseif (daimyo_hit < _limit & daimyo_hit < samurai_sword_hit_max) \
    /ss_hit %{samurai_sword_hit_max}%; \
    /result 1%; \
  /endif%; \
  /result 0

/def bs = /boost_sword
/def boost_sword = \
  /if (!strlen(daimyo_element) | daimyo_element =~ 'physical') \
    /if (samurai_sword_element =~ 'fire') \
      /fire_blade%; \
      /return%; \
    /endif%; \
    /if (samurai_sword_element =~ 'acid') \
      /acid_blade%; \
      /return%; \
    /endif%; \
   /if (samurai_sword_element =~ 'cold') \
      /ice_blade%; \
      /return%; \
    /endif%; \
    /if (samurai_sword_element =~ 'poison') \
      /poison_blade%; \
      /return%; \
    /endif%; \
  /endif%; \
  /if (boost_sword_till(100)) \
    /return%; \
  /endif%; \
  /if (daimyo_special !~ samurai_sword_special) \
    /if (samurai_sword_special =~ 'jigoku') \
      /jigoku_blade%; \
      /return%; \
    /endif%; \
    /if (samurai_sword_special =~ 'tenrai') \
      /tenrai_blade%; \
      /return%; \
    /endif%; \
  /endif%; \
  /if (boost_sword_till(120) | boost_sword_till(130) | boost_sword_till(140) | boost_sword_till(150)) \
    /return%; \
  /endif

/def aa = /amorphic_armour %{*}

/def ss_dam = /razor_edge %{*}
/def ss_hit = /lightsword %{*}
/def ss_wc = /silver_sheen %{*}
/def ss_cold = /ice_blade %{*}
/def ss_poi = /poison_blade %{*}
/def ss_poison = /poison_blade %{*}
/def ss_acid = /acid_blade %{*}
/def ss_fire = /fire_blade %{*}
/def ss_elec = /electric_blade %{*}

/def neutralize_blade = \
  /set samurai_sword_name=%{*-%{samurai_sword_name}}%; \
  /do_prot -a'cast' -s'neutralize blade' -t'$(/escape ' %{samurai_sword_name})' -n'Neutralizing Blade'%; \
  /save_samurai

/def ss_good = /jigoku_blade %{*}
/def ss_jigoku = /jigoku_blade %{*}
/def ss_evil = /tenrai_blade %{*}
/def ss_tenrai = /tenrai_blade %{*}
/def kami = /kamikaze %{*}

/def call_for_sword = \
  /set samurai_sword_name=%{*-%{samurai_sword_name}}%; \
  /do_prot -a'cast' -s'call for sword' -t'$(/escape ' %{samurai_sword_name})' -n'Summoning Sword'%; \
  /save_samurai

;;
;; SAMURAI SWORD SUMMONED
;;

/def samurai_sword_name = \
  /set samurai_sword_name=%{*-%{samurai_sword_name}}%; \
  /print_value -n'samurai_sword_name'%; \
  /save_samurai

/def -Fp5 -msimple -t'Standing still, you whisper the sacred name of your blade to the wind.' called_for_sword = \
  /mapcar /unset daimyo_wc daimyo_hit daimyo_dam daimyo_element daimyo_wc_diff daimyo_hit_diff daimyo_dam_diff%; \
  /set samurai_sword_summoned=1%; \

/def -Fp5 -mregexp -t'^The spirit of The (.+) called \'(.+)\' screams with a cold and horrible tone: \'BANZAI!\'$' samurai_sword_banzai = \
  /if (!samurai_sword_summoned) \
    /return%; \
  /endif%; \
  /set samurai_sword_type=%{P1}%; \
  /set samurai_sword_name=%{P2}%; \
  !keep all %{samurai_sword_name}%; \
  !wield %{samurai_sword_name}%; \
  /save_samurai

/def -Fp5 -mregexp -t'^You wield The .+ called \'.+\'( <[A-Z][a-z]+>)? in your right hand\\.$' samurai_sword_wield = \
  /set samurai_sword_summoned=1%; \
  /set samurai_sword_wielded=1

/def -Fp5 -mregexp -t'^You stop wielding The .+ called \'.+\'( <[A-Z][a-z]+>)?\\.$' samurai_sword_unwield = \
  /set samurai_sword_wielded=0

/def -Fp5 -mregexp -t'^ right wield: The .+ called \'(.+)\'( <[A-Z][a-z]+>)? \\([1-2]h\\)( [<\\(]?\\*glowing\\*[>\\)]?)?$' samurai_sword_slots = \
  /samurai_sword_wield

/def -Fp5 -mregexp -t'^Wielded in right hand: The .+ called \'(.+)\'( <[A-Z][a-z]+>)? \\([1-2]h\\)( [<\\(]?\\*glowing\\*[>\\)]?)?( <!!>)?\\.$' samurai_sword_eq = \
  /if ({P1} =~ samurai_sword_name) \
    /samurai_sword_wield%; \
  /endif

/def -Fp5 -aBCred -msimple -t'The Four Winds gather and carry your blade away.' samurai_sword_gone = \
  /set samurai_sword_summoned=0%; \
  /set samurai_sword_wielded=0

;;
;; SAMURAI SWORD STATS
;;

/def ss = /sword_stats %{*}
/def sword_stats = \
  /if (samurai_sword_summoned) \
    /let _key=$[hex(id())]%; \
    /if ({#}) \
      /set sword_stats_%{_key}=%{*}%; \
    /else \
      /set sword_stats_%{_key}=/say -d'status' --%; \
    /endif%; \
    !daimyo%; \
    !echo /sword_stats %{_key}%; \
  /endif

/def -Fp5 -msimple -t'Your blade glimmers with a silver sheen.' boosted_silver_sheen = /sword_stats
/def -Fp5 -msimple -t'The blade shimmers with a cold blue light.' boosted_lightsword = /sword_stats
/def -Fp5 -msimple -t'The air about your blade hums against its razor-sharp edge.' boosted_razor_edge = /sword_stats

/def ss_wc_min = /samurai_sword_wc_min %{*}

;;;;
;;
;; The starting weapon class of your samurai blade. This is used to calculate
;; the percentage of your boost.
;;
/property -i -v'1' samurai_sword_wc_min

/def ss_hit_min = /samurai_sword_hit_min %{*}

;;;;
;;
;; The starting hit bonus of your samurai blade. This is used to calculate the
;; percentage of your boost.
;;
/property -i -v'0' samurai_sword_hit_min

/def ss_dam_min = /samurai_sword_dam_min %{*}
;;;;
;;
;; The starting damage of your samurai blade. This is used to calculate the
;; percentage of your boost.
;;
/property -i -v'0' samurai_sword_dam_min

/def ss_wc_max = /samurai_sword_wc_max %{*}

;;;;
;;
;; The maximum weapon class of your samurai blade. This is used to calculate
;; the percentage of your boost as well as used to prevent attempting to boost
;; something that is already at max.
;;
/property -i -v'120' samurai_sword_wc_max

/def ss_hit_max = /samurai_sword_hit_max %{*}

;;;;
;;
;; The maximum hit bonus of your samurai blade. This is used to calculate the
;; percentage of your boost as well as used to prevent attempting to boost
;; something that is already at max.
;;
/property -i -v'120' samurai_sword_hit_max

/def ss_dam_max = /samurai_sword_dam_max %{*}

;;;;
;;
;; The maximum damage of your samurai blade. This is used to calculate the
;; percentage of your boost as well as used to prevent attempting to boost
;; something that is already at max.
;;
/property -i -v'120' samurai_sword_dam_max

/def ss_element = /samurai_sword_element %{*}

;;;;
;;
;; The element (damage type) that you wish your sword to maintain. The
;; "/boost_sword" macro will try and set this element whenever it's down.
;; Possible values include: "fire", "acid", "cold" and "poison".
;;
/property -s -g -v'fire' samurai_sword_element

/def ss_special = /samurai_sword_special %{*}

;;;;
;;
;; The special that you wish your sword to maintain. The "/boost_sword" macro
;; will try and set this special whenever it's down. Possible values include
;; "jigoku" and "tenrai".
;;
/property -s -g -v'jigoku' samurai_sword_special

/def -Fp5 -mregexp -t'^Your (fire|acid|poison|ice)blade spell wears off\\.$' set_blade_element = \
  /set daimyo_element=physical

/def -Fp5 -msimple -t'Your spirit touches the blade, cleansing it of elemental powers.' clear_blade_element = \
  /set daimyo_element=physical

/def -Fp5 -msimple -t'Your sword begins to glow with the faintest glow of elemental fire.' set_fire_blade = \
  /set samurai_sword_element=fire%; \
  /set daimyo_element=%{samurai_sword_element}

/def -Fp5 -msimple -t'Your sword begins to glow with the faintest yellow light.' set_acid_blade = \
  /set samurai_sword_element=acid%; \
  /set daimyo_element=%{samurai_sword_element}

/def -Fp5 -msimple -t'Your sword begins to glow with the faintest glow of elemental ice.' set_ice_blade = \
  /set samurai_sword_element=cold%; \
  /set daimyo_element=%{samurai_sword_element}

/def -Fp5 -msimple -t'Your sword begins to glow with the dark green hue of poison.' set_poison_blade = \
  /set samurai_sword_element=poison%; \
  /set daimyo_element=%{samurai_sword_element}

/def -Fp5 -msimple -t'the spiritual forces of evil.' set_jigoku_blade = \
  /set samurai_sword_special=jigoku%; \
  /set daimyo_special=%{samurai_sword_special}

/def -Fp5 -msimple -t'the spiritual forces of good.' set_tenrai_blade = \
  /set samurai_sword_special=tenrai%; \
  /set daimyo_special=%{samurai_sword_special}

/def -Fp5 -mregexp -t'^The (dark|benign) spiritual forces of the (Jigoku|Tenrai) Blade twindle away\\.$' set_blade_special = \
  /unset daimyo_special

/def -Fp5 -ag -msimple -t'As you utter the sacred word \'daimyo\', you feel a pinch inside' daimyo_0 = \
  /mapcar /unset daimyo_element daimyo_special%; \
  /set samurai_sword_summoned=1

/def -Fp5 -ag -msimple -t'your mind.' daimyo_1 = \
  /def -n1 -Fp5 -ag -msimple -t''

/def -Fp5 -ag -msimple -t'The Spirit of the Blade informs you of its status:' daimyo_2 = \
  /def -Fp5 -ag -n1 -msimple -t'' daimyo_blank

/def -Fp5 -ag -mregexp -t'^Weapon class        : (\\d+)\\.$' daimyo_3 = \
  /if (daimyo_wc) \
    /set daimyo_wc_diff=$[{P1} - daimyo_wc]%; \
  /else \
    /set daimyo_wc_diff=0%; \
  /endif%; \
  /set daimyo_wc=%{P1}

/def -Fp5 -ag -mregexp -t'^Weapon hit bonus    : (\\d+)\\.$' daimyo_4 = \
  /if (daimyo_hit) \
    /set daimyo_hit_diff=$[{P1} - daimyo_hit]%; \
  /else \
    /set daimyo_hit_diff=0%; \
  /endif%; \
  /set daimyo_hit=%{P1}

/def -Fp5 -ag -mregexp -t'^Weapon damage bonus : (\\d+)\\.$' daimyo_5 = \
  /if (daimyo_dam) \
    /set daimyo_dam_diff=$[{P1} - daimyo_dam]%; \
  /else \
    /set daimyo_dam_diff=0%; \
  /endif%; \
  /set daimyo_dam=%{P1}

/def -Fp5 -ag -mregexp -t'^Weapon element      : (fire|acid|poison|cold|physical)( blade)?\\.$' daimyo_6 = \
  /set daimyo_element=%{P1}

/def -Fp5 -ag -mregexp -t'^Weapon special      : (jigoku|tenrai) blade\\.$' daimyo_7 = \
  /set daimyo_special=%{P1}

/def -Fp5 -ag -mregexp -t'^/sword_stats ([0-9a-f]+)$' sword_stats_message = \
  /if (!samurai_sword_summoned) \
    /return%; \
  /endif%; \
  /let _var=sword_stats_%{P1}%; \
  /let _cmd=$[expr(_var)]%; \
  /unset %{_var}%; \
  /if (!strlen(_cmd)) \
    /return%; \
  /endif%; \
  /execute %{_cmd} WC: %{daimyo_wc}$[delta_only(daimyo_wc_diff, ' (', ')')], Hit Bonus: %{daimyo_hit}$[delta_only(daimyo_hit_diff, ' (', ')')], Damage Bonus: %{daimyo_dam}$[delta_only(daimyo_dam_diff, ' (', ')')] [$[round((daimyo_wc - samurai_sword_wc_min + daimyo_hit - samurai_sword_hit_min + daimyo_dam - samurai_sword_dam_min) * 100 / (samurai_sword_wc_max - samurai_sword_wc_min + samurai_sword_hit_max - samurai_sword_hit_min + samurai_sword_dam_max - samurai_sword_dam_min), 1)]%%]%; \
  /if (strlen(daimyo_element)) \
    /execute %{_cmd} Weapon Element: %{daimyo_element}%; \
  /endif%; \
  /if (strlen(daimyo_special)) \
    /execute %{_cmd} Weapon Special: %{daimyo_special}%; \
  /endif

;;
;; SAMURAI MASTERIES
;;

/def -Fp5 -msimple -t'You advance in your understanding of the Samurai Arts.' gained_samurai_point = \
  !shelp

/def update_samurai_mastery = \
  /if (!getopts('m:n#', '') | !strlen(opt_m)) \
    /return%; \
  /endif%; \
  /let _last=samurai_mastery_%{opt_m}%; \
  /test _last := %{_last}%; \
  /if (opt_n > _last) \
    /let _change=$[opt_n - _last]%; \
    /say -c'red' -x -- Gained $[toupper(opt_m)] Samurai Point: %{opt_n}%; \
  /endif%; \
  /set samurai_mastery_%{opt_m}=%{opt_n}

/foreach sdrain scharge senchant smaking smwalk sspirit skenjutsu spunch swmastery stmastery tkmastery stessenjutsu sshinzui = \
  /set samurai_mastery_%{1}=0

/def -Fp5 -mregexp -t'^   Drain life force  - sdrain <corpse>          -  (\\d+)' shelp_sdrain = /update_samurai_mastery -m'sdrain' -n%{P1}
/def -Fp5 -mregexp -t'^   Charge glove      - scharge \\(always 500sp\\)   -  (\\d+)' shelp_scharge = /update_samurai_mastery -m'scharge' -n%{P1}
/def -Fp5 -mregexp -t'^   Improve enchants  - senchant \\(automatic\\)     -  (\\d+)' shelp_senchant = /update_samurai_mastery -m'senchant' -n%{P1}
/def -Fp5 -mregexp -t'^   Improve making    - smaking \\(automatic\\)      -  (\\d+)' shelp_smaking = /update_samurai_mastery -m'smaking' -n%{P1}
/def -Fp5 -mregexp -t'^   Magical walking   - smwalk                   -  (\\d+)' shelp_smwalk = /update_samurai_mastery -m'smwalk' -n%{P1}
/def -Fp5 -mregexp -t'^   Inner Spirit      - sspirit                  -  (\\d+)' shelp_sspirit = /update_samurai_mastery -m'sspirit' -n%{P1}
/def -Fp5 -mregexp -t'^   Tebukuro kenjutsu - skenjutsu                -  (\\d+)' shelp_skenjutsu = /update_samurai_mastery -m'skenjutsu' -n%{P1}
/def -Fp5 -mregexp -t'^   Punch             - spunch \\<target\\>          -  (\\d+)' shelp_spunch = /update_samurai_mastery -m'spunch' -n%{P1}
/def -Fp5 -mregexp -t'^   Weapon mastery    - swmastery \\(automatic\\)    -  (\\d+)' shelp_swmastery = /update_samurai_mastery -m'swmastery' -n%{P1}
/def -Fp5 -mregexp -t'^   Throwing mastery  - stmastery \\(automatic\\)    -  (\\d+)' shelp_stmastery = /update_samurai_mastery -m'stmastery' -n%{P1}
/def -Fp5 -mregexp -t'^   Tebukuro mastery  - tkmastery \\(automatic\\)    -  (\\d+)' shelp_tkmastery = /update_samurai_mastery -m'tkmastery' -n%{P1}
/def -Fp5 -mregexp -t'^   Tessenjutsu       - stessenjutsu \\(automatic\\) -  (\\d+)' shelp_stessenjutsu = /update_samurai_mastery -m'stessenjutsu' -n%{P1}
/def -Fp5 -mregexp -t'^   Shinzui Yochi     - sshinzui \\(automatic\\)     -  (\\d+)' shelp_sshinzui = /update_samurai_mastery -m'sshinzui' -n%{P1}

/def -Fp5 -mregexp -t'^   Spell points loaded in the glove:   (\\d+)' shelp_spell_points = \
  /set glove_spell_points=%{P1}

/def -Fp5 -mregexp -t'^   Life force points:                  (\\d+)' shelp_life_points = \
  /set glove_life_points=%{P1}%; \
  @update_status%; \
  /save_samurai

/def shelp = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen -- %{prefix}%; \
  /endif%; \
  /execute %{_cmd} $[samurai_mastery_sdrain + 0]/$[samurai_mastery_scharge + 0]/$[samurai_mastery_senchant + 0]/$[samurai_mastery_smaking + 0]/$[samurai_mastery_smwalk + 0]/$[samurai_mastery_sspirit + 0]/$[samurai_mastery_skenjutsu + 0]/$[samurai_mastery_swmastery + 0]/$[samurai_mastery_stmastery + 0]/$[samurai_mastery_tkmastery + 0]/$[samurai_mastery_sshinzui + 0] > $[samurai_mastery()]

/def samurai_mastery = \
  /result 0 + \
    samurai_mastery_sdrain + \
    samurai_mastery_scharge + \
    samurai_mastery_senchant + \
    samurai_mastery_smaking + \
    samurai_mastery_smwalk + \
    samurai_mastery_sspirit + \
    samurai_mastery_skenjutsu + \
    samurai_mastery_swmastery + \
    samurai_mastery_stmastery + \
    samurai_mastery_tkmastery + \
    samurai_mastery_sshinzui

;;
;; save the settings
;;
/def -Fp5 -msimple -h'SEND @save' save_samurai = \
  /mapcar /listvar samurai_auto_scharge samurai_sword_name stats_samurai_*_total samurai_mastery_* samurai_sdrain_delay samurai_sdrain samurai_sword_element samurai_sword_special samurai_sword_*_max samurai_sword_*_min throw_from_bag %| /writefile $[save_dir('samurai')]%; \
  /stat_save throw $[stats_dir('throw')]

/eval /load $[save_dir('samurai')]
/eval /stat_load throw $[stats_dir('throw')]
