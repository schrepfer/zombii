;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CASTS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/casts.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/casts.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/require textutil.tf
/require lisp.tf

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_casts = \
  /casts reset

/def casts = \
  /if ({#}) \
    /if ({*} =~ 'reset') \
      /let _reset=1%; \
    /elseif ({*} =~ 'reset all') \
      /quote -S /unset `/listvar -s casts_*%; \
      /set casts=%; \
      /return%; \
    /endif%; \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen --%; \
    /let _color=1%; \
  /endif%; \
  /if (!_reset) \
    /execute %{_cmd} .-----------------------------------------------------.%; \
    /execute %{_cmd} | Casting Statistics:                                 |%; \
    /execute %{_cmd} |---------------------------------.---------.---------|%; \
    /execute %{_cmd} | spell                           | session |   total |%; \
    /execute %{_cmd} |---------------------------------+---------+---------|%; \
  /endif%; \
  /foreach %{casts} = \
    /if (_reset) \
      /set casts_%%{1}_count=0%%; \
      /return%%; \
    /endif%%; \
    /let _name=$$[textdecode({1})]%%; \
    /let _count=$$[expr(strcat('casts_', {1}, '_count'))]%%; \
    /let _total=$$[expr(strcat('casts_', {1}, '_total'))]%%; \
    /if (!_count) \
      /return%%; \
    /endif%%; \
    /eval -s0 %%{_cmd} | $$[pad(_name, -31)] | $$[pad(_count, 7)] | $$[pad(_total, 7)] |%; \
  /if (!_reset) \
    /execute %{_cmd} '---------------------------------'---------'---------'%; \
  /endif%; \

/def -Fp5 -mregexp -t'^(You start chanting|You begin to weave your spell)\\.$' casts_started = \
  /set casting=1

/def -Fp5 -msimple -t'You stop casting the spell.' casts_stopped = \
  /set casting=0

/def -Fp5 -msimple -t'Your movement prevents you from casting the spell.' casts_moved = \
  /casts_stopped

/def -Fp5 -mglob -t'Cast * at what?' casts_at_what = \
  /casts_stopped

/def -Fp6 -mregexp -t'^(You are done with the chant|You are finished with your spell)\\.$' casts_done = \
  /set casting=0%; \
  /let _key=$[textencode(last_spell_name)]%; \
  /set casts=$(/unique %{_key} %{casts})%; \
  /test ++casts_%{_key}_count%; \
  /test ++casts_%{_key}_total

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

/def -Fp5 -msimple -h'SEND @save' save_casts = /mapcar /listvar casts casts_* report_casts_on_rip %| /writefile $[save_dir('casts')]
/eval /load $[save_dir('casts')]
