;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; HELP SPELL AND LOOKUP TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2012-02-12 02:40:39 -0800 (Sun, 12 Feb 2012) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/help_spell.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/help_spell.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def lookup = \
  /if (!getopts('d:', '')) \
    /return%; \
  /endif%; \
  /if (strlen(opt_d)) \
    /let _cmd=%{opt_d}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _words=%{*}%; \
  /let _time=$[time()]%; \
  /let _spell=$(/quote -S /_echo !wget -qO - 'http://z.maddcow.us/spells/lookup?q=$[urlencode(_words)]&f=spell')%; \
  /let _time=$[time() - _time]%; \
  /if (strlen(_spell) & _spell !~ 'From afar, Conglomo does not know that spell.') \
    /execute %{_cmd} Spell '%{_spell}' matches '%{_words}' [$[to_dhms(_time)]]%; \
  /else \
    /execute %{_cmd} Count not find the spell%; \
  /endif

/def -Fp5 -mregexp -t'^Help on spell: +([^ ].*)$' help_spell_name = \
  /mapcar /unset help_spell_type help_spell_pref%; \
  /set help_spell_name=$[tolower(strip_attr({P1}))]

/def -Fp5 -mregexp -t'^Spell type: +([^ ].*)$' help_spell_type = \
  /set help_spell_type=$[tolower(strip_attr({P1}))]

/def -Fp5 -mregexp -t'^Damage type: +([^ ].*)$' help_spell_pref = \
  /set help_spell_pref=$[tolower(strip_attr({P1}))]

/def -Fp5 -mregexp -t'^Spell words: +([^ ].*)$' help_spell_words = \
  /set help_spell_words=$[strip_attr({P1})]%; \
  /if (is_me('conglomo')) \
    /add_help_spell -n'$(/escape ' %{help_spell_name})' -w'$(/escape ' %{help_spell_words})' -t'$(/escape ' %{help_spell_type})' -p'$(/escape ' %{help_spell_pref})'%; \
  /endif

/def add_help_spell = \
  /if (getopts('n:t:p:w:', '') & strlen(opt_n) & strlen(opt_w)) \
    /let opt_n=$[urlencode(tolower(trim(opt_n)))]%; \
    /let opt_t=$[urlencode(tolower(trim(opt_t)))]%; \
    /let opt_p=$[urlencode(tolower(trim(opt_p)))]%; \
    /let opt_w=$[urlencode(trim(opt_w))]%; \
    /quote -S /pass !wget -qO - --post-data='n=%{opt_n}&t=%{opt_t}&p=%{opt_p}&w=%{opt_w}' 'http://z.maddcow.us/spells/update'%; \
  /endif

/def load_spells = \
  /quote -S /pass !wget -qO $[save_dir('help_spell')] http://z.maddcow.us/spells/spells.tf%; \
  /load $[save_dir('help_spell')]

/load_spells
