;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; LANGUAGES
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/languages.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/languages.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

; Newbie -> Novice -> Journy -> Skilld -> Advncd -> Adept -> Master

/def -Fp5 -mregexp -t'^\\| ([a-z][a-z ]+[a-z]) +\\|([A-Z][a-z]+) ?\\| ([a-z][a-z ]+[a-z]) +\\|([A-Z][a-z]+) ?\\|$' languages_list_0 = \
  /let _left_language=$(/escape ' %{P1})%; \
  /let _left_progress=$(/escape ' %{P2})%; \
  /let _right_language=$(/escape ' %{P3})%; \
  /let _right_progress=$(/escape ' %{P4})%; \
  /update_languages -l'%{_left_language}' -p'%{_left_progress}'%; \
  /update_languages -l'%{_right_language}' -p'%{_right_progress}'

/def -Fp5 -mregexp -t'^\\| ([a-z][a-z ]+[a-z]) +\\|([A-Z][a-z]+) ?\\|                    \\|      \\|$' languages_list_1 = \
  /update_languages -l'$(/escape ' %{P1})' -p'$(/escape ' %{P2})'

/def languages_reset = /quote -S /unset `/listvar -s languages_*
/languages_reset

/def update_languages = \
  /if (getopts('l:p:', '') & strlen(opt_l) & strlen(opt_p)) \
    /let _var=languages_$[textencode(opt_l)]%; \
    /if (announce & report_languages) \
      /let _progress=$[expr(_var)]%; \
      /if (strlen(_progress) & _progress !~ opt_p) \
        /say -c'yellow' -x -- $[toupper(opt_l, 1)] changed from %{_progress} to %{opt_p}%; \
      /endif%; \
    /endif%; \
    /set %{_var}=%{opt_p}%; \
  /endif

/def report_languages = \
  /update_value -n'report_languages' -v'$(/escape ' %{*})' -b%; \
  /save_languages

;;
;; save settings
;;
/def -Fp5 -msimple -h'SEND @save' save_languages = /mapcar /listvar languages_* report_languages %| /writefile $[save_dir('languages')]
/eval /load $[save_dir('languages')]
