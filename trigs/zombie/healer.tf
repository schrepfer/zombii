;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; HEALER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/healer.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/healer.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set healer=1

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_healer = \
  /set heal_all_last=0%; \
  /set heal_all_start=0

/on_enter_game_healer

/def -Fp5 -msimple -t'There is not enough power present in the world.' heal_all_fail = \
  /if (time() - heal_all_last <= 1000) \
    /let _time=$[abs(time() - heal_all_last)]%; \
    /let _time=$[round(_time, 1)]%; \
    /substitute -- %{*} ($[to_dhms(_time)])%; \
  /endif

/property -t -v'30' heal_all_cast
/property -t -v'300' heal_all_wait

/def -Fp5 -mglob -t'You feel like * healed you a bit.' heal_all_other = \
  /heal_all_calc %{*}%; \
  /kill heal_all_pid%; \
  /if (heal_all_cast > 0 & heal_all_wait > 0) \
    /timer -t$[heal_all_wait - heal_all_cast] -n1 -p'heal_all_pid' -- /heal_all_timer%; \
  /endif

/def -Fp5 -mglob -t'You feel like you healed * people.' heal_all_self = \
  /heal_all_calc %{*}

/def heal_all_calc = \
  /if (time() - heal_all_last <= 1000) \
    /let _time=$[abs(time() - heal_all_last)]%; \
    /let _time=$[round(_time, 1)]%; \
    /substitute -- %{*} ($[to_dhms(_time)])%; \
  /endif%; \
  /test heal_all_last := time()

/def heal_all_timer = \
  /if (time() - heal_all_last > 1000) \
    /say -d'status' -- It has been longer than 1000s since the last heal all went off%; \
  /else \
    /let _time=$[abs(time() - heal_all_last)]%; \
    /let _time=$[round(_time, 1)]%; \
    /say -d'status' -- It has been $[to_dhms(_time)] (cast=$[to_dhms(heal_all_cast)], wait=$[to_dhms(heal_all_wait)]) since the last heal all went off%; \
  /endif

/def heal_all_cast_timer = \
  /if (time() - heal_all_start > 1000) \
    /say -d'status' -- It has been longer than 1000s since the last heal all started%; \
  /else \
    /let _time=$[abs(time() - heal_all_start)]%; \
    /let _time=$[round(_time, 1)]%; \
    /say -d'status' -- It has been $[to_dhms(_time)] (wait=$[to_dhms(heal_all_wait)]) since you started your last heal all%; \
  /endif

/def heal_all = \
  /do_prot -a'cast' -s'heal all' -n'Healing All!'%; \
  /test heal_all_start := time()%; \
  /kill heal_all_pid%; \
  /if (heal_all_wait > 0) \
    /timer -t%{heal_all_wait} -n1 -p'heal_all_pid' -k -- /heal_all_cast_timer%; \
  /endif

;; heals
/def gph = /greater_party_heal %{*}
/def hc = /healing_ceremony %{*}
/def hebo = /heal_body %{*}
/def hhand = /harmony_hand %{*}
/def lph = /lesser_party_heal %{*}
/def mdh = /major_distant_heal %{*}
/def mdt = /major_distant_transfer %{*}
/def mh = /major_heal %{*}
/def mph = /major_party_heal %{*}
/def tdh = /true_distant_heal %{*}
/def tdt = /true_distant_transfer %{*}
/def tm = /transfer_mana %{*}
/def tt = /true_transfer %{*}

;; other
/def cb = /cure_blindness %{*}
/def chp = /create_healing_potion %{*}
/def ppot = /prepare_potion %{*}
/def bup = /brain_unpain %{*}
/def smoke = /healing_smoke %{*}
/def sr = /stun_resistance %{*}
/def tup = /true_unpain %{*}
/def pha = /preparation_of_harmony %{*}
/def ha = /harmony_armour %{*}
/def hbar = /harmonious_barrier %{*}
/def ch = /cleansing_harmony %{*}
/def rh = /resist_heal %{*}

/def -Fp6 -msimple -t'You utter the magic words \'ON Selppa\'' resist_heal_up = \
  /def -Fp7 -n1 -mregexp -t'' resist_heal_up_fix = \
    /if ({-1} !~ 'looks unaffected by your spell.' & \
         {*} !~ 'You fail miserably.' & \
         {*} !~ 'You fail the spell.' & \
         {*} !~ 'You have trouble concentrating and fail the spell.' & \
         {*} !~ 'You lose your balance and stumble, ruining the spell.' & \
         {*} !~ 'You lose your concentration and fail the spell.' & \
         {*} !~ 'You poke yourself in the eye and the spell misfires.' & \
         {*} !~ 'Your spell just fizzles.' & \
         {*} !~ 'Your spell just sputters.' & \
         {*} !~ 'You scream with frustration as the spell utterly fails.' & \
         {*} !~ 'You stumble over the spell\\'s complexity and mumble the words.' & \
         {*} !~ 'You stutter the magic words and fail the spell.' & \
         {*} !~ 'You think of Leper and become too scared to cast your spell.') \
      /say -d'party' -c'green' -f'UP' -- Resist Heal%%; \
    /endif

/def -Fp5 -msimple -t'That would interfere with a previous resist heal spell.' resist_heal_already_up = \
  /say -d'party' -c'yellow' -- Resist Heal Already Up!

; potions
/def -Fp5 -msimple -t'You don\'t have an unprepared potion to prepare.' no_unprepared_potions = !cast stop
/def -Fp5 -msimple -t'You don\'t have an empty potion to use with the spell.' no_empty_potions = !cast stop

/def -Fp5 -msimple -h'SEND @save' save_healer = /mapcar /listvar heal_all_cast heal_all_wait %| /writefile $[save_dir('healer')]
/eval /load $[save_dir('healer')]
