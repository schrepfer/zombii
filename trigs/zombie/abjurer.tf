;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ABJURER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/abjurer.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/abjurer.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]
/eval /require $[trigs_dir('zombie/effects')]

/set abjurer=1

;;
;; ATTACKS
;;
/def ee = /effusion_of_entity %{*}

;;
;; OTHER
;;
/def kya = /know_your_audience %{*}
/def aura = /aura_detection %{*}
/def amf = /anti_magic_field %{*}

;;
;; VULNERABILITIES
;;

;;;;
;;
;; The name of the macro (without leading /) you wish to use as your main vuln.
;; This is used by the "/v" command.
;;
/property -s -g vuln_cmd

;;;;
;;
;; Executes the macro defined by %{vuln_cmd}.
;;
;; @param target The target to vuln. Default is %{target}.
;;
/def vuln = /eval -s0 /%{vuln_cmd} %{*}
/def v = /vuln %{*}

/def ed = /elemental_disarray %{*}
/def re = /ray_of_enervation %{*}
/def v_phys = /fragile_frame %{*}
/def v_physical = /fragile_frame %{*}
/def v_mag = /mystic_impairment %{*}
/def v_magi = /mystic_impairment %{*}
/def v_magic = /mystic_impairment %{*}
/def v_fire = /incendiary_coating %{*}
/def v_cold = /deprive_warmth %{*}
/def v_acid = /vitriolic_bane %{*}
/def v_psi = /languished_soul %{*}
/def v_psio = /languished_soul %{*}
/def v_psionic = /languished_soul %{*}
/def v_asp = /labored_breathing %{*}
/def v_asph = /labored_breathing %{*}
/def v_asphyxiation = /labored_breathing %{*}
/def v_elec = /energetic_frailty %{*}
/def v_electric = /energetic_frailty %{*}
/def v_poi = /blemished_health %{*}
/def v_poio = /blemished_health %{*}
/def v_poison = /blemished_health %{*}

;;;;
;;
;; Clears all vulns.
;;
/def reset_vulns = \
  /unset vulns

;;;;
;;
;; Defines a vuln.
;;
;; @option v:key* The key which matches this vuln.
;; @option p:dtype* The damage types that the vuln affects.
;; @option n:name* The name of this vuln.
;; @option t#duration Duration of this vuln.
;;
/def def_vuln = \
  /if (!getopts('v:p:n:t#', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_v)) \
    /error -m'%{0}' -a'v' -- must be the name of the vuln key%; \
    /result%; \
  /endif%; \
  /if (!strlen(opt_n)) \
    /error -m'%{0}' -a'n' -- must be the name of the vuln%; \
    /result%; \
  /endif%; \
  /set vuln_%{opt_v}=%{opt_n}%; \
  /set vuln_%{opt_v}_pref=%{opt_p}%; \
  /set vuln_%{opt_v}_time=%{opt_t}%; \
  /set vulns=$(/unique %{vulns} %{opt_v})

;;;;
;;
;; Turns on the vuln specified.
;;
;; @param key The key of the vuln to enable.
;;
/def vuln_up = \
  /if (!isin({1}, vulns)) \
    /error -m'%{0}' -- key did not match a vuln%; \
    /return%; \
  /endif%; \
  /let _name=$[expr(strcat('vuln_', {1}))]%; \
  /let _pref=$[expr(strcat('vuln_', {1}, '_pref'))]%; \
  /let _time=$[expr(strcat('vuln_', {1}, '_time'))]%; \
  /say -d'party' -x -c'green' -f'UP' -- %{_name} (%{_pref} vuln)%; \
  /if (_time > 5) \
    /let _pid=vuln_falling_%{1}_pid%; \
    /timer -t$[_time - 5] -n1 -k -p'%{_pid}' -- /vuln_falling %{1} 5%; \
    /let _pid=vuln_down_%{1}_pid%; \
    /timer -t%{_time} -n1 -k -p'%{_pid}' -- /vuln_down %{1}%; \
  /endif

;;;;
;;
;; Warns when vuln is falling
;;
;; @param key The key of the vuln to warn for.
;; @param when The time when this vuln will fall.
;;
/def vuln_falling = \
  /if (!isin({1}, vulns) & {2}) \
    /error -m'%{0}' -- key did not match a vuln%; \
    /return%; \
  /endif%; \
  /let _name=$[expr(strcat('vuln_', {1}))]%; \
  /let _pref=$[expr(strcat('vuln_', {1}, '_pref'))]%; \
  /let _time=$[expr(strcat('vuln_', {1}, '_time'))]%; \
  /say -d'status' -c'yellow' -- %{_name} (%{_pref} vuln) falls in $[to_dhms({2}, 1)]!

;;;;
;;
;; Turns off the vuln specified.
;;
;; @param key The key of the vuln to disable.
;;
/def vuln_down = \
  /if (!isin({1}, vulns)) \
    /return%; \
  /endif%; \
  /let _name=$[expr(strcat('vuln_', {1}))]%; \
  /let _pref=$[expr(strcat('vuln_', {1}, '_pref'))]%; \
  /say -d'party' -x -c'red' -f'DOWN' -- %{_name} (%{_pref} vuln)

;;
;; Clear messages when it dies
;;
/def -Fp5 -mglob -h'SEND @on_enemy_killed *' on_enemy_killed_abjurer = \
  /foreach %{vulns} = \
    /kill vuln_falling_%%{1}_pid%%; \
    /kill vuln_down_%%{1}_pid

/def_vuln -v'elemental_disarray' -p'cold, mag, fire, asp, phys' -n'Elemental Disarray' -t32
/def -Fp5 -mglob -t'You reach out with your hands and focus the spell at *' elemental_disarray_up = /vuln_up elemental_disarray

/def_vuln -v'ray_of_enervation' -p'elec, acid, psi, poi, phys' -n'Ray of Enervation' -t26
/def -Fp5 -mglob -t'A colourful ray of immense power shoots from your hands towards *' ray_of_enervation_up = /vuln_up ray_of_enervation

/def_vuln -v'fragile_frame' -p'physical' -n'Fragile Frame' -t32
/def -Fp5 -msimple -t'You trace the rune of withering and an ashen dart launches ' fragile_frame_up = /vuln_up fragile_frame

/def_vuln -v'mystic_impairment' -p'magic' -n'Mystic Impairment' -t32
/def -Fp5 -msimple -t'You trace the rune of enervation and send a violet missile ' mystic_impairment_up = /vuln_up mystic_impairment

/def_vuln -v'incendiary_coating' -p'fire' -n'Incendiary Coating' -t32
/def -Fp5 -msimple -t'You trace the rune of burning and a scarlet stream of ' incendiary_coating_up = /vuln_up incendiary_coating

/def_vuln -v'deprive_warmth' -p'cold' -n'Deprive Warmth' -t32
/def -Fp5 -msimple -t'You trace the rune of frost and a single white snowflake ' deprive_warmth_up = /vuln_up deprive_warmth

/def_vuln -v'vitriolic_bane' -p'acid' -n'Vitriolic Bane' -t32
/def -Fp5 -mglob -t'You trace the rune of dissolving and *' vitriolic_bane_up = /vuln_up vitriolic_bane

/def_vuln -v'languished_soul' -p'psionic' -n'Languished Soul' -t32
/def -Fp5 -msimple -t'You trace the rune of dreaming and a bolt of viridian ' languished_soul_up = /vuln_up languished_soul

/def_vuln -v'labored_breathing' -p'asphyxiation' -n'Labored Breathing' -t32
/def -Fp5 -msimple -t'You trace the rune of constriction and an ebon cloud ' labored_breathing_up = /vuln_up labored_breathing

/def_vuln -v'energetic_frailty' -p'electric' -n'Energetic Frailty' -t32
/def -Fp5 -msimple -t'You trace the rune of lightning and an arc of lazuline ' energetic_frailty_up = /vuln_up energetic_frailty

/def_vuln -v'blemished_health' -p'poison' -n'Blemished Health' -t32
/def -Fp5 -msimple -t'You trace the rune of virulence and pinch your fingers. ' blemished_health_up = /vuln_up blemished_health

;;
;; INVULNERABILITIES
;;

/def gphys = /ward_of_steel %{*}
/def g_phys = /ward_of_steel %{*}
/def g_physical = /ward_of_steel %{*}
/def lphys = /ward_of_stone %{*}
/def l_phys = /ward_of_stone %{*}
/def l_physical = /ward_of_stone %{*}

/def g_mag = /arcane_bulwark %{*}
/def gmagi = /arcane_bulwark %{*}
/def g_magi = /arcane_bulwark %{*}
/def g_magic = /arcane_bulwark %{*}
/def l_mag = /mystic_bulwark %{*}
/def lmagi = /mystic_bulwark %{*}
/def l_magi = /mystic_bulwark %{*}
/def l_magic = /mystic_bulwark %{*}

/def gfire = /winters_rebuke %{*}
/def g_fire = /winters_rebuke %{*}
/def lfire = /rebuke_of_ice %{*}
/def l_fire = /rebuke_of_ice %{*}

/def gcold = /infernal_vestment %{*}
/def g_cold = /infernal_vestment %{*}
/def lcold = /vestment_of_flame %{*}
/def l_cold = /vestment_of_flame %{*}

/def gacid = /corrosive_opposition %{*}
/def g_acid = /corrosive_opposition %{*}
/def lacid = /caustic_opposition %{*}
/def l_acid = /caustic_opposition %{*}

/def g_psi = /psychic_aegis %{*}
/def gpsio = /psychic_aegis %{*}
/def g_psio = /psychic_aegis %{*}
/def g_psionic = /psychic_aegis %{*}
/def l_psi = /mental_aegis %{*}
/def lpsio = /mental_aegis %{*}
/def l_psio = /mental_aegis %{*}
/def l_psionic = /mental_aegis %{*}

/def g_asp = /resist_void %{*}
/def gasph = /resist_void %{*}
/def g_asph = /resist_void %{*}
/def g_asphyxiaton = /resist_void %{*}
/def l_asp = /endure_void %{*}
/def lasph = /endure_void %{*}
/def l_asph = /endure_void %{*}
/def l_asphyxiaton = /endure_void %{*}

/def gelec = /lightning_guard %{*}
/def g_elec = /lightning_guard %{*}
/def g_electric = /lightning_guard %{*}
/def lelec = /spark_shelter %{*}
/def l_elec = /spark_shelter %{*}
/def l_electric = /spark_shelter %{*}

/def g_poi = /venom_fend %{*}
/def gpois = /venom_fend %{*}
/def g_pois = /venom_fend %{*}
/def g_poison = /venom_fend %{*}
/def l_poi = /poison_fend %{*}
/def lpois = /poison_fend %{*}
/def l_pois = /poison_fend %{*}
/def l_poison = /poison_fend %{*}

/def ri = /remove_invulnerabilities %{*}

;;
;; KNOW YOUR AUDIENCE
;;

/def -Fp5 -mregexp -t'^([A-Za-z,-:\' ]+)\'s gender is: ([a-z]+)$' kya_gender = \
  /quote -S /unset `/listvar -s kya_*%; \
  /set kya_short=%{P1}%; \
  /set kya_gender=$[tolower({P2})]

/def -Fp5 -mregexp -t'^       race:                   ([a-z ]+)$' kya_race = \
  /set kya_race=$[tolower({P1})]

/def -Fp5 -mregexp -t'^       money:                  (\\d+)$' kya_money = \
  /set kya_money=%{P1}

/def -Fp5 -mregexp -t'^       armour class            (\\d+)$' kya_armour_class = \
  /set kya_armour_class=%{P1}

/def -Fp5 -mregexp -t'^       weapon class:           (\\d+)$' kya_weapon_class = \
  /set kya_weapon_class=%{P1}

/def -Fp5 -mregexp -t'^       Attacks/round:          (\\d+)$' kya_attacks_round = \
  /set kya_attacks_round=%{P1}

/def -Fp5 -mregexp -t'^       The target is at about (\\d+)% health\\.$' kya_health = \
  /set kya_health=%{P1}

/def -Fp5 -mregexp -t'^       resists the damage type ([a-z]+) the most\\.$' kya_resists_most = \
  /set kya_resists_most=$[tolower({P1})]

/def -Fp5 -mregexp -t'^       resists the damage type ([a-z]+) the least\\.$' kya_resists_least = \
  /set kya_resists_least=$[tolower({P1})]

/def -Fp5 -mregexp -t'^        All resistances are even\\.' kya_resists_even = \
  /set kya_resists_even=1

/def -Fp5 -mregexp -t'^([A-Za-z,-:\' ]+) is ([A-Z][a-z ]+)\\.$' kya_align = \
  /if ({P1} =~ kya_short) \
    /set kya_align=$[tolower({P2})]%; \
    /if (party_members > 1) \
      /kya_p%; \
    /endif%; \
  /endif

;;;;
;;
;; Announce the 'know your audience' result to party.
;;
/def kya_p = \
  /if (!strlen(kya_short)) \
    /error -m'%{0}' -- no data%; \
    /return%; \
  /endif%; \
  /say -d'party' -x -b -- ----------------------------------------%; \
  /say -d'party' -x -b -- $[pad(strcat(toupper(kya_short, 1), ' the ', toupper({kya_race-No Race}, 1), ' (', kya_gender =~ 'male' ? 'M' : kya_gender =~ 'female' ? 'F' : 'N', ',', align(kya_align), ')'), -34, strcat('[', {kya_health-??}, '%]'), 6)]%; \
  /if (!kya_resists_even) \
    /say -d'party' -x -b -- $[pad(toupper(strcat(kya_resists_least, ' least')), -20, tolower(strcat(kya_resists_most, ' most')), 20)]%; \
  /endif%; \
  /say -d'party' -x -b -- ----------------------------------------


;;
;; AURA
;;

/def do_aura_detection = \
  /let _effects=$[replace(' and ', ', ', trim({*}))]%; \
  /if (substr(_effects, -1) =~ '.') \
    /let _effects=$[substr(_effects, 0, -1)]%; \
  /endif%; \
  /let i=-1%; \
  /quote -S /unset `/listvar -s aura_effect_*%; \
  /python aura_effects.reset()%; \
  /while ((i := strchr(_effects, ',')) > -1 | (i := strlen(_effects), i > 0)) \
    /let _effect=$[substr(_effects, 0, i)]%; \
    /if ($(/first %{_effect}) =~ 'Two') \
      /let _count=2%; \
      /let _effect=$(/rest %{_effect})%; \
      /if (_effect =~ 'Shields of protection') \
        /let _effect=Shield of protection%; \
      /else \
        /let _effect=$[substr(_effect, 0, -1)]%; \
      /endif%; \
    /else \
      /let _count=1%; \
    /endif%; \
    /test _effect := python('util.sanitize("$(/escape " %{_effect})")')%; \
    /repeat -S %{_count} /python aura_effects.on('$(/escape ' %{_effect})', quiet=True)%; \
    /let _effects=$[trim(substr(_effects, i + 1))]%; \
  /done%; \
  /if (report_aura =~ 'list') \
    /if (report_aura_party) \
      /aura_effects_party%; \
    /else \
      /repeat -0 1 /aura_effects%; \
    /endif%; \
  /elseif (report_aura =~ 'online') \
    /if (report_aura_party) \
      /aura_effects_online_party%; \
    /else \
      /repeat -0 1 /aura_effects_online%; \
    /endif%; \
  /elseif (report_aura =~ 'missing') \
    /if (report_aura_party) \
      /aura_effects_missing_party%; \
    /else \
      /repeat -0 1 /aura_effects_missing%; \
    /endif%; \
  /endif

;;;;
;;
;; Check effects that are missing from %{aura_effects_list}.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
/def aura_effects_missing = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python aura_effects.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(state)15s |', keys='$(/escape ' %{aura_effects_list})', online=False, offline=True)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python aura_effects.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(state)15s@{n} |', keys='$(/escape ' %{aura_effects_list})', online=False, offline=True)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def adm = /aura_effects_missing %{*}

;;;;
;;
;; Check effects that are missing from %{aura_effects_list} and announce it to
;; party.
;;
/def aura_effects_missing_party = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python aura_effects.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(state)15s', keys='$(/escape ' %{aura_effects_list})', online=False, offline=True)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def adm_p = /aura_effects_missing_party %{*}

;;;;
;;
;; Check effects from %{aura_effects_list} and display their status.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
/def aura_effects = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python aura_effects.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(state)15s |', keys='$(/escape ' %{aura_effects_list})', online=True, offline=True)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python aura_effects.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(state)15s@{n} |', keys='$(/escape ' %{aura_effects_list})', online=True, offline=True)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def adl = /aura_effects %{*}

;;;;
;;
;; Check effects from %{aura_effects_list} and display their status to party.
;;
/def aura_effects_party = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python aura_effects.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(state)15s', keys='$(/escape ' %{aura_effects_list})', online=True, offline=True)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def adl_p = /aura_effects_party %{*}

;;;;
;;
;; Check effects that are online.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
/def aura_effects_online = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python aura_effects.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(state)15s |', online=True, offline=False)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python aura_effects.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(state)15s@{n} |', online=True, offline=False)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def ado = /aura_effects_online %{*}

;;;;
;;
;; Check effects that are online and announce it to party.
;;
/def aura_effects_online_party = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python aura_effects.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(state)15s', online=True, offline=False)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def ado_p = /aura_effects_online_party %{*}

/def -Fp5 -msimple -t'The target is not under the noticeable effect of any spells.' aura_detection_output_none = \
  /do_aura_detection

/def -Fp5 -mregexp -t'^The target is affected by ' aura_detection_output = \
  /if (substr({PR}, -1) !~ '.') \
    /set aura_detection_line=%{PR}%; \
    /def -Fp5 -mregexp -t'' aura_detection_output_more = \
      /set aura_detection_line=%%{aura_detection_line} %%{*}%%; \
      /if (substr({*}, -1) =~ '.') \
        /do_aura_detection %%{aura_detection_line}%%; \
        /purgedef aura_detection_output_more%%; \
      /endif%; \
  /else \
    /do_aura_detection %{PR}%; \
  /endif

;;;;
;;
;; List of effects that you care to see when typing "/aura_effects" or
;; "/aura_effects_missing". The format of each effect should be lower case, all
;; spaces should be converted to underscores and all other characters should be
;; removed. For example, something like "iron will" becomes "iron_will" and
;; "winter's rebuke" becomes "winters_rebuke". The format is exactly the same
;; as {{ effects_list }}.
;;
/property aura_effects_list = \
  /update_value -n'aura_effects_list' -v'$(/escape ' %{*})' -s -g%; \
  /save_abjurer

;;;;
;;
;; Should the result of aura detection automatically be reported to the party?
;; This calls "/aura_effects_party", "/aura_effects_online_party" or
;; "/aura_effects_missing_party" depending on the value of {{ report_aura }}.
;; If {{ report_aura }} is off then nothing is done.
;;
/property -b report_aura_party

/set report_aura=off

;;;;
;;
;; The format in which the aura should be repoted. Possible values include
;; "list" (shows all effects in your list), "missing" (shows just the effects
;; that are offline), "online" (shows all effects that are online) and "off".
;; When set to "list" or "missing" it is required that you set {{
;; aura_effects_list }}.
;;
/property report_aura = \
  /if ({#} & !isin({*}, 'list', 'off', 'missing', 'online')) \
    /error -m'%{0}' -- must be one of: list, off, online, missing%; \
    /update_value -n'report_aura' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'report_aura' -v'$(/escape ' %{*})' -g

/def init_aura_effects = /python aura_effects = effects.inst.copy()

/def -Fp5 -msimple -h'SEND @save' save_abjurer = /mapcar /listvar \
  aura_effects_list report_aura report_aura_party vuln_cmd %| /writefile $[save_dir('abjurer')]

/eval /load $[save_dir('abjurer')]

/init_aura_effects

;; Backwards Compatibility Hack
/test adl_effects := strlen(adl_effects) ? adl_effects : (strlen(adl_prots) ? adl_prots : '')
/test aura_effects_list := strlen(aura_effects_list) ? aura_effects_list : (strlen(adl_effects) ? adl_effects : '')
