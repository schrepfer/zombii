;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ABJURER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-02-15 00:51:08 -0800 (Tue, 15 Feb 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/abjurer.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/abjurer.tf $', 10, -2)]

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

/property -s -g vuln_cmd

/def v = /vuln %{*}
/def vuln = /eval -s0 /%{vuln_cmd} %{*}
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

;;
;; RESET VULNS
;;
;; Clears all vulns.
;;
;; Usage: /reset_vulns
;;
/def reset_vulns = \
  /unset vulns

;;
;; DEFINE VULN
;;
;; Defines a vuln.
;;
;; Usage: /def_vuln [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -v KEY*       The key which matches this vuln
;;   -p PREF*      The prefs the vuln affects
;;   -n NAME*      The name of this vuln
;;   -t SECS       Time that this vuln stays up for
;;
/def def_vuln = \
  /if (getopts('v:p:n:t#', '')) \
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
    /set vulns=$(/unique %{vulns} %{opt_v})%; \
  /endif

;;
;; VULN UP
;;
;; Turns on the vuln defined by the KEY.
;;
;; Usage: /vuln_up KEY
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

;;
;; VULN FALLING
;;
;; Warns when vuln is falling
;;
;; Usage: /vuln_falling KEY WHEN
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

;;
;; VULN DOWN
;;
;; Turns off the vuln defined by KEY.
;;
;; Usage: /vuln_down KEY
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
      /adl_p%; \
    /else \
      /repeat -0 1 /adl%; \
    /endif%; \
  /elseif (report_aura =~ 'online') \
    /if (report_aura_party) \
      /ado_p%; \
    /else \
      /repeat -0 1 /ado%; \
    /endif%; \
  /elseif (report_aura =~ 'missing') \
    /if (report_aura_party) \
      /adm_p%; \
    /else \
      /repeat -0 1 /adm%; \
    /endif%; \
  /endif

/def adm = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python aura_effects.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(state)15s |', keys='$(/escape ' %{adl_effects})', online=False, offline=True)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python aura_effects.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(state)15s@{n} |', keys='$(/escape ' %{adl_effects})', online=False, offline=True)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def adm_p = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python aura_effects.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(state)15s', keys='$(/escape ' %{adl_effects})', online=False, offline=True)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def adl = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python aura_effects.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(state)15s |', keys='$(/escape ' %{adl_effects})', online=True, offline=True)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python aura_effects.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(state)15s@{n} |', keys='$(/escape ' %{adl_effects})', online=True, offline=True)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def adl_p = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python aura_effects.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(state)15s', keys='$(/escape ' %{adl_effects})', online=True, offline=True)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def ado = \
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

/def ado_p = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python aura_effects.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(state)15s', online=True, offline=False)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

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

/def adl_effects = \
  /update_value -n'adl_effects' -v'$(/escape ' %{*})' -s -g%; \
  /save_abjurer

/property -b report_aura_party

/set report_aura=off
/def report_aura = \
  /if ({#} & !isin({*}, 'list', 'off', 'missing', 'online')) \
    /error -m'%{0}' -- must be one of: list, off, online, missing%; \
    /update_value -n'report_aura' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'report_aura' -v'$(/escape ' %{*})' -g

/def init_aura_effects = /python aura_effects = zombie.effects.inst.copy()

/def -Fp5 -msimple -h'SEND @save' save_abjurer = /mapcar /listvar \
  adl_effects report_aura report_aura_party vuln_cmd %| /writefile $[save_dir('abjurer')]

/eval /load $[save_dir('abjurer')]

/init_aura_effects

;; Backwards Compatibility Hack
/test adl_effects := strlen(adl_effects) ? adl_effects : (strlen(adl_prots) ? adl_prots : '')
