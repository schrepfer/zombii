;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CASTS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/casts.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/casts.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]
/eval /require $[trigs_dir('zombie/stats')]

/require textutil.tf
/require lisp.tf

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_casts = \
  /stat_purge casts%; \
  /def_stat -g'casts' -k'total' -n'Total' -r0 -h

;;;;
;;
;; Display casting statistics.
;;
/def casts = /stat_display casts %{*}

/def -Fp5 -mregexp -t'^(You start chanting|You begin to weave your spell)\\.$' casts_started = \
  /set casting=1

/def -Fp5 -msimple -t'You stop casting the spell.' casts_stopped = \
  /set casting=0

/def -Fp5 -msimple -t'Your movement prevents you from casting the spell.' casts_moved = \
  /casts_stopped

/def -Fp5 -mglob -t'Cast * at what?' casts_at_what = \
  /casts_stopped

/def_stat_group -g'casts' -n'Spell Casting'
/def_stat -g'casts' -k'total' -n'Total' -r0 -h

/def -Fp8 -mregexp -t'^(You are done with the chant|You are finished with your spell)\\.$' casts_done = \
  /casts_stopped%; \
  /let _key=$[textencode(last_spell_name)]%; \
  /def_stat -g'casts' -k'$(/escape ' %{_key})' -n'$(/escape ' $[capitalize(last_spell_name)])' -r0 -s%; \
  /stat_update casts %{_key} 1%; \
  /stat_update casts total 1

;;;;
;;
;; Should the last spell you started casting be reported when something dies?
;; This setting will report to "think" the name and the number of rounds left
;; before completing. This setting is useful when playing a supporting role
;; where you wish the tank of the party to know that they should not move yet.
;;
/property -b report_casts_on_rip

/def -Fp5 -mglob -h'SEND @on_enemy_killed *' on_enemy_killed_casts = \
  /if (report_casts_on_rip & casting) \
    /if (strlen(last_spell_target)) \
      /let _target= at %{last_spell_target}%; \
    /endif%; \
    /if (last_spell_rounds) \
      /let _rounds= [%{last_spell_rounds} round$[last_spell_rounds == 1 ? '' : 's'] left]%; \
    /endif%; \
    /say -d'think' -m -x -- Currently casting $[toupper(last_spell_name)]%{_target}!%{_rounds}%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z0-9 \'-]+): (#+)$' essence_eye = \
  /set last_spell_name=$[tolower({P1})]%; \
  /set last_spell_rounds=$[strlen({P2})]

/def -Fp2 -mregexp -h'SEND ^!?cast ' do_cast = \
  /let _name=$[trim({PR})]%; \
  /if (_name =~ 'stop') \
    /return%; \
  /endif%; \
  /if (regmatch(' try (very slow|slow|normal|quick|very quick)$$', _name)) \
    /let _name=%{PL}%; \
    /set last_spell_speed=%{P1}%; \
  /else \
    /set last_spell_speed=%; \
  /endif%; \
  /set last_spell_rounds=0%; \
  /if (regmatch('^\'([a-z0-9][a-z0-9 \']+[a-z0-9])\'( (.+))?$$', _name)) \
    /set last_spell_name=%{P1}%; \
    /set last_spell_target=%{P3}%; \
  /elseif (regmatch('^([a-z0-9][a-z0-9 \']+[a-z0-9]) at (.+)$$', _name)) \
    /set last_spell_name=%{P1}%; \
    /set last_spell_target=%{P2}%; \
  /elseif (regmatch('^[a-z0-9][a-z0-9 \']+[a-z0-9]$$', _name)) \
    /set last_spell_name=%{_name}%; \
    /set last_spell_target=%; \
  /else \
    /set last_spell_name=%; \
    /set last_spell_target=%; \
  /endif

/def -Fp5 -msimple -h'SEND @save' save_casts = \
  /mapcar /listvar casts report_casts_on_rip %| /writefile $[save_dir('casts')]%; \
  /stat_save casts $[stats_dir('casts')]

/eval /load $[save_dir('casts')]
/eval /stat_load casts $[stats_dir('casts')]
