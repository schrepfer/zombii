;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SPRITE PRINCESS TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/princess.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/princess.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def add_princess_rescuer = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _rescuer=$[tolower({1})]%; \
  /let _var=princess_rescuer_%{_rescuer}%; \
  /let _value=%{_var}%; \
  /test _value := %{_value}%; \
  /set %{_var}=$[_value + 1]

/def -Fp5 -msimple -t'You free the princess from her shackles.' free_princess = \
  /if (princess_time) \
    /substitute -- %{*} ($[to_dhms(time() - princess_time)])%; \
  /endif%; \
  /princess -n900 -f3600

/def -Fp5 -msimple -t'The Sprite Princess thanks you and rubs her sore wrists.' princess_rescuer = \
  /set princess_rescuer=$[toupper(me(), 1)]%; \
  /add_princess_rescuer $[me()]

/def -Fp5 -mregexp -t'^The Sprite Princess shouts \'Praise ([A-Z][a-z]+) for rescuing me\'$' princess_shouts = \
  /set princess_rescuer=%{P1}%; \
  /free_princess %{*}%; \
  /add_princess_rescuer %{P1}

/def -Fp5 -msimple -t'Torturer Chamber (n).' princess_chamber = \
  /princess -n900 -r3600

/test princess_time := (princess_time | 0)
/test princess_next := (princess_next | 0)

;;
;; PRINCESS
;;
;; Manages and displays information on when the princess was last seen.
;;
;; Usage: /princess [OPTIONS] -- [DISPLAY COMMAND]
;;
;;  OPTIONS:
;;
;;   -n SECONDS    Next time to wait after ready
;;   -f SECONDS    Princess just freed, ready in n seconds
;;   -r SECONDS    Reset current timer, ready in n seconds
;;
/def princess = \
  /if (getopts('n#f#r#', '')) \
    /let opt_r=$[opt_f | opt_r]%; \
    /if (opt_r) \
      /if (opt_n) \
        /timer -t%{opt_r} -n1 -p'princess_pid' -k -- /princess -n%{opt_n}%; \
      /else \
        /timer -t%{opt_r} -n1 -p'princess_pid' -k -- /princess%; \
      /endif%; \
      /if (opt_f) \
        /set princess_time=$[time()]%; \
      /endif%; \
      /set princess_next=$[time() + opt_r]%; \
    /elseif (opt_n) \
      /timer -t%{opt_n} -n1 -p'princess_pid' -k -- /princess -n%{opt_n}%; \
    /endif%; \
    /if (!opt_r & ((is_connected() & opt_n) | !opt_n)) \
      /let _delta=$[trunc(time() - princess_next)]%; \
      /if (_delta > 0) \
        /let _message=Princess has been (at least should be) ready to be freed for $[princess_next ? to_dhms(_delta) : 'an unknown time']%; \
      /elseif (_delta < 0) \
        /let _message=Princess should be ready to be freed in $[princess_next ? to_dhms(-_delta) : 'an unknown time']%; \
      /else \
        /let _message=Princess should be ready to be freed%; \
      /endif%; \
      /let _message=%{_message} (Last freed $[princess_time ? to_dhms(time()-princess_time) : 'an unknown time'] ago by %{princess_rescuer-Unknown})%; \
      /if ({#}) \
        /let _cmd=%{*}%; \
      /else \
        /if (report_princess) \
          /let _cmd=/say --%; \
        /else \
          /let _cmd=/say -d'status' --%; \
        /endif%; \
      /endif%; \
      /execute %{_cmd} %{_message}%; \
    /endif%; \
  /endif

/def -Fp5 -msimple -h'SEND @on_leave_game' on_leave_game_princess = \
  /kill princess_pid

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_princess = \
  /kill princess_pid%; \
  /set princess_time=0%; \
  /set princess_next=0%; \
  /unset princess_rescuer

/def cssteak = /run_path -d'17 e;2 ne;field;e;s;5 e;14 se;crack;2 e;dig;2 push stone;n;e;n;search ice;s;e;2 s;3 u;craig;d;14 nw;5 w;n;w;leave;2 sw;17 w'
/def xsteak = \
  /run_path -d'castle goto 0;cs;17 e;2 ne;field;e;s;5 e;14 se;crack;2 e;dig;2 push stone;n;e;n;search ice;s;e;2 s;3 u;craig;d;14 nw;5 w;n;w;leave;2 sw;17 w'%; \
  /shoot home

/def csprincess = \
  /if (party_members > 1 & is_me(commander)) \
    /if ({#}) \
      !party leader %{*}%; \
    /endif%; \
    !party movement%; \
  /endif%; \
  /run_path -d'17 e;2 ne;field;e;s;5 e;14 se;crack;2 e' -b'princesscs' -t'torturer'%; \
  /grab /dp

/def princesscs = \
  /run_path -d'5 n;out;e;2 s;3 u;craig;d;14 nw;5 w;n;w;leave;2 sw;17 w'%; \
  /if (party_members > 1 & is_me(commander)) \
    !party movement%; \
    !party leader $[me()]%; \
  /endif

/def cavecs = /run_path -d'8 w;14 nw;n;w;leave;2 sw;17 w'

/def dp = \
  /run_path -d'dig;2 push stone;n;e;n;search ice;s;pull torch;say yes' -b'$(/escape ' %{back})' -t'torturer'%; \
  /princess_chamber

/def xprincess = \
  /run_path -d'castle goto 0;cs;17 e;2 ne;field;e;s;5 e;14 se;crack;2 e' -b'princessx' -t'torturer'%; \
  /grab /dp

/def princessx = \
  /run_path -d'5 n;out;e;2 s;3 u;craig;d;14 nw;5 w;n;w;leave;2 sw;17 w'%; \
  /shoot home

/def -Fp5 -msimple -t'The guard pulls on a hidden lever that drops a plank across the pit.' princess_platform_lowers = /grab /pp

/def pp = /run_path -d's;give steak to dog;3 s;chamber;spank all' -b'$(/escape ' %{back})'

/def -Fp5 -msimple -t'Something is tossed from the circle just before it vanishes.' princess_potion = \
  /if (bag) \
    !get potion to bag of holding%; \
  /else \
    !get potion%; \
    !keep potion%; \
  /endif%; \
  !drop fob

/property -b report_princess

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) tells you \'princess\'$' princess_tell = \
  /princess /send -- !emoteto $[tolower({P1})] thinks the

;;
;; save settings
;;
/def -Fp5 -msimple -h'SEND @save' save_princess = /mapcar /listvar princess_rescuer_* report_princess %| /writefile $[save_dir('princess')]
/eval /load $[save_dir('princess')]
