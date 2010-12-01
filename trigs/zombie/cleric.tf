;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CLERIC TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-15 18:17:22 -0700 (Fri, 15 Oct 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/cleric.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/cleric.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set cleric=1

; cleric only commands
/def ew = /estimate_worth %{*}
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
  /if (tolower({P1}) =~ cleric_target) \
    !cast stop%; \
  /endif%; \
  /set healing=$[tolower({P1})]

/def -Fp5 -msimple -t'You start chanting.' cleric_report_spell_reset = \
  /set cleric_report_spell=0

/def -Fp5 -mregexp -t'^([A-Z][a-z]+( [a-z]+)*): (#+)$' cleric_report_spells = \
  /if (report_casts) \
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
    /endif%; \
  /endif

/def -Fp5 -ag -msimple -t'The tinker looks bored.' gag_tinker_rounds
/def -Fp5 -ag -msimple -t'The tinker twiddles his thumbs.' gag_tinker_1
/def -Fp5 -ag -msimple -t'The tinker says \'Only 34 more years and I can retire.\'' gag_tinker_2
/def -Fp5 -ag -msimple -t'The tinker asks \'Hi, what can I get for you?\'' gag_tinker_3

