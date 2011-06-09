;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CLERIC TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-04-05 00:35:38 -0700 (Tue, 05 Apr 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/cleric.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/cleric.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]
/eval /require $[trigs_dir('zombie/stats')]

/set cleric=1

;; Shortcuts

/def bu = /banish_undead %{*}
/def cl = /channel_life %{*}
/def ew = /estimate_worth %{*}
/def habo = /harm_body %{*}
/def hwind = /healing_wind %{*}
/def hwis = /holy_wisdom %{*}
/def reinc = /reincarnation %{*}
/def res = /resurrect %{*}
/def sacr = /sacred_ritual %{*}
/def sg = /summon_ghost %{*}

; set heal target
/def -Fp5 -mregexp -t'^([A-Z][a-z]+) (floats in|fades in)( from the [a-z]+)?\\.$' cleric_ghost_floats_in = \
  /set cleric_target=$[strip_attr(tolower({P1}))]%; \
  @update_status

/def -Fp5 -mregexp -t'^ghost of ([a-z]+) whispers to you' cleric_ghost_whisper = \
  /set cleric_target=$[tolower({P1})]%; \
  @update_status

;/def -Fp5 -mregexp -t'^Ghost of ([a-z]+)$' heal_see_ghost = \
;  /set cleric_target=$[strip_attr(tolower({P1}))]%; \
;  @update_status

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) appears in a solid form\\.$' cleric_player_resurrected = \
; /if (tolower({P1}) =~ cleric_target) \
;   !cast stop%; \
; /endif%; \
  /set healing=$[tolower({P1})]

/def -Fp5 -msimple -t'You start chanting.' cleric_report_spell_reset = \
  /set cleric_report_spell=0

/def -Fp5 -mregexp -t'^([A-Z][a-z]+( [a-z]+)*): (#+)$' cleric_report_spells = \
  /if (!report_sksp) \
    /return%; \
  /endif%; \
  /let _rounds=$[strlen({P3})]%; \
  /if ({P1} =~ 'Sacred ritual' & ((_rounds <= 12 & cleric_report_spell == 0) | (_rounds <= 8 & cleric_report_spell == 1) | (_rounds <= 4 & cleric_report_spell == 2))) \
    /say -d'think' -- %{P1} in %{_rounds} round$[_rounds == 1 ? '' : 's'] [DO NOT IDLE]%; \
    /set cleric_report_spell=$[cleric_report_spell + 1]%; \
  /endif%; \
  /if ({P1} =~ 'Resurrect' & (_rounds <= 4 & cleric_report_spell == 0)) \
    /say -d'think' -- %{P1} in %{_rounds} round$[_rounds == 1 ? '' : 's'] [DO NOT IDLE]%; \
    /set cleric_report_spell=$[cleric_report_spell + 1]%; \
  /endif%; \
  /if ({P1} =~ 'Reincarnation' & ((_rounds <= 10 & cleric_report_spell == 0) | (_rounds <= 5 & cleric_report_spell == 1))) \
    /say -d'think' -- %{P1} in %{_rounds} round$[_rounds == 1 ? '' : 's']%; \
    /set cleric_report_spell=$[cleric_report_spell + 1]%; \
  /endif%; \
  /if (({P1} =~ 'Estimate worth' | {P1} =~ 'Remove scar') & (_rounds <= 2 & cleric_report_spell == 0)) \
    /say -d'think' -- %{P1} in %{_rounds} round$[_rounds == 1 ? '' : 's']%; \
    /set cleric_report_spell=$[cleric_report_spell + 1]%; \
  /endif

/def -Fp5 -ag -msimple -t'The tinker looks bored.' gag_tinker_rounds
/def -Fp5 -ag -msimple -t'The tinker twiddles his thumbs.' gag_tinker_1
/def -Fp5 -ag -msimple -t'The tinker says \'Only 34 more years and I can retire.\'' gag_tinker_2
/def -Fp5 -ag -msimple -t'The tinker asks \'Hi, what can I get for you?\'' gag_tinker_3

/def_stat_group -g'channel_life' -n'Channel Life'
/def_stat -g'channel_life' -k'sickly' -n'Sickly' -r0
/def_stat -g'channel_life' -k'faint' -n'Faint' -r1
/def_stat -g'channel_life' -k'weak' -n'Weak' -r2
/def_stat -g'channel_life' -k'bold' -n'Bold' -r3
/def_stat -g'channel_life' -k'bright' -n'Bright' -r4
/def_stat -g'channel_life' -k'glowing' -n'Glowing' -r5
/def_stat -g'channel_life' -k'burning' -n'Burning' -r6
/def_stat -g'channel_life' -k'sparkling' -n'Sparkling' -r7
/def_stat -g'channel_life' -k'blazing' -n'Blazing' -r8
/def_stat -g'channel_life' -k'brilliant' -n'Brilliant' -r9
/def_stat -g'channel_life' -k'radiant' -n'Radiant' -r10
/def_stat -g'channel_life' -k'dazzling' -n'Dazzling' -r11
/def_stat -g'channel_life' -k'resplendant' -n'Resplendant' -r12

/def -Fp5 -mregexp -t'^A (\\S+) crimson aura surrounds your hand\\.$' stats_channel_life_aura = \
  /stat_update channel_life %{P1} 1

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_cleric = \
  /stat_reset channel_life

/def stats_cl = /stats_channel_life %{*}
/def stats_channel_life = /stat_display channel_life %{*}

/def -Fp5 -msimple -h'SEND @save' save_cleric = \
  /stat_save channel_life $[stats_dir('channel_life')]

/eval /stat_load channel_life $[stats_dir('channel_life')]
