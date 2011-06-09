;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SKILL AND SPELL TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/sksp.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/sksp.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def -Fp5 -mregexp -t'^\\| ([a-z][a-z0-9\' ]*[a-z]) +\\| *(\\d+)\\|\\| ([a-z][a-z0-9\' ]*[a-z]) +\\| *(\\d+)\\|$' sksp_list_0 = \
  /let _left_spell=$(/escape ' %{P1})%; \
  /let _left_percent=$[{P2} + 0]%; \
  /let _right_spell=$(/escape ' %{P3})%; \
  /let _right_percent=$[{P4} + 0]%; \
  /update_sksp -s'%{_left_spell}' -p%{_left_percent}%; \
  /update_sksp -s'%{_right_spell}' -p%{_right_percent}

/def -Fp5 -mregexp -t'^\\| ([a-z][a-z0-9\' ]*[a-z]) +\\| *(\\d+)\\|\\|                              \\|   \\|$' sksp_list_1 = \
  /update_sksp -s'$(/escape ' %{P1})' -p$[{P2}+0]

/def sksp_reset = /quote -S /unset `/listvar -s sksp_*
/sksp_reset

/def update_sksp = \
  /if (!getopts('s:p#', '') | !strlen(opt_s) | !opt_p) \
    /return%; \
  /endif%; \
  /let _var=sksp_$[textencode(opt_s)]%; \
  /if (announce & report_sksp_changes) \
    /let _sksp=%{_var}%; \
    /test _sksp := %{_sksp}%; \
    /if (_sksp & _sksp != opt_p) \
      /if (opt_p > _sksp) \
        /let _color=green%; \
        /let _direction=up%; \
      /else \
        /let _color=red%; \
        /let _direction=down%; \
      /endif%; \
      /let _change=$[abs(opt_p - _sksp)]%; \
      /say -c'%{_color}' -x -- $[toupper(opt_s, 1)] went %{_direction} by %{_change} point$[_change == 1 ? '' : 's'] to %{opt_p} percent%; \
    /endif%; \
  /endif%; \
  /set %{_var}=%{opt_p}

;;;;
;;
;; Should percentual changes in your skills and spells be reported to those
;; around you? The skills/spells change from equipment, bards, talismen, tales,
;; masteries, etc. This reports how much your skills/spells changed.
;;
/property -b report_sksp_changes

;;
;; save settings
;;
/def -Fp5 -msimple -h'SEND @save' save_sksp = /mapcar /listvar sksp_* report_sksp_changes %| /writefile $[save_dir('sksp')]
/eval /load $[save_dir('sksp')]
