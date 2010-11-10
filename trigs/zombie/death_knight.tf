;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; DEATH KNIGHT TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/death_knight.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/death_knight.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set death_knight=1

/def xpray = /run_path -d'2 s;stairs;w;nw;2 n;ne;e;n;look at statue;press button;d;unlock north door with skull key;open north door;n;pray' -b'prayx' -i'skull key'
/def prayx = /run_path -d'unlock south door with skull key;open south door;s;close north door;lock north door with skull key;pull lever;u;s;w;sw;2 s;se;e;stairs;2 n' -i'skull key'
/def drequest = /run_path -d'2 s;stairs;e;ne;2 n;nw;w;stairs;e;se;s;e;request drayl;request paladin task;request elves;request priest;w;n;nw;w;stairs;e;se;2 s;sw;w;stairs;2 n;dquests'
/def xarena = /run_path -d'2 s;w;nw;2 n;out;7 w;enter' -b'arenax'
/def arenax = /run_path -d'out;7 e;enter;2 s;se;e;2 n'


/def find_skull_key = /run_path -d'2 s;stairs;w;nw;2 n;ne;listen through crack'

/def -Fp5 -mregexp -t'^You hear someone say \'I placed the key in ([A-Z][a-z]+ [A-Z][a-z]+)\'s niche\\.\'$' death_knight_niche = \
  /let _niche=%{P1}%; \
  /run_path -d'2 e'%; \
  !examine %{_niche}'s niche'%; \
  /run_path -d'se;2 s;sw'%; \
  !examine %{_niche}'s niche'%; \
  /run_path -d'2 w;nw'%; \
  !examine %{_niche}'s niche'%; \
  /run_path -d'2 n'%; \
  !examine %{_niche}'s niche'%; \
  /run_path -d'ne;e;stairs;e'%; \
  !examine %{_niche}'s niche'%; \
  /run_path -d'se;2 s;sw'%; \
  !examine %{_niche}'s niche'%; \
  /run_path -d'2 w'%; \
  !examine %{_niche}'s niche'%; \
  /run_path -d'nw;2 n;ne'%; \
  !examine %{_niche}'s niche'%; \
  /run_path -d'e;stairs;e;se;2 s;sw;w;stairs;2 n'


/def msac = \
  /run_path -d'3 n;4 w;enter;4 n;6 d;n;se;enter coffin'%; \
  !sacrifice $[me()]%; \
  /run_path -d'nw;s;6 u;4 s;out;4 e;3 s'

/def drain_start = \
  /set drain_round=0%; \
  /set drain_start=$[time()]

/def -Fp6 -msimple -t'You utter the magic words \'Haer haer sharakam dasta\'' cast_suffocation = \
  /drain_start

/def -Fp6 -msimple -t'You utter the magic words \'Plaguras zaram death shakaram\'' cast_flesh_rot = \
  /drain_start

/property -b report_drains

/def drain_round = \
  /test ++drain_round%; \
  /let _time=$[trunc(time() - drain_start)]%; \
  /substitute -- %{*} [%{drain_round} of 9]%; \
  /if (report_drains) \
    /if (drain_round < 4 | drain_round > 6) \
      /let _color=yellow%; \
    /else \
      /let _color=green%; \
    /endif%; \
    /say -d'party' -c'%{_color}' -- [$[meter(drain_round, 9)]] %{drain_round} of 9%; \
  /endif%; \
  @update_status

/def -Fp5 -aCred -mglob -t'The invisible bond stops choking *.' suffocation_end

/def -Fp5 -aCred -mregexp -t'^[A-Za-z,-:\' ]+ sighs in relief\\.$' flesh_rot_end

/def -Fp5 -aCbrightblue -mglob -t'You snicker evilly as you feel the power of * filling you.' suffocation_round = \
  /drain_round %{*}

/def -Fp5 -aCbrightblue -msimple -t'You pick up the slice of flesh for later use.' flesh_rot_round = \
  /drain_round %{*}%; \
  /let _recipient=me%; \
  /if (strlen(give_slices_to)) \
    /if (give_slices_to =~ 'tank') \
      /if (!is_me(tank)) \
        /let _recipient=%{tank}%; \
      /endif%; \
    /else \
      /let _recipient=%{give_slices_to}%; \
    /endif%; \
  /endif%; \
  /if (_recipient =~ 'me') \
    /slice_received%; \
  /else \
    !give slice to %{_recipient}%; \
  /endif

/property -i -v'300' slices_heal
/property -f -v'0.5' slices_fatigue

/def -Fp4 -msimple -h'SEND @on_new_round' eat_slices_if = \
  /if (!strlen(give_slices_to)) \
    /eat_slices $[max(trunc((p_maxhp - p_hp) / slices_heal), trunc((fatigue - 2) / slices_fatigue))]%; \
  /endif

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ gives you ([A-Z][a-z]*) slices? of flesh ' slice_received = \
  /if ({P1} =~ 'Two') \
    /let _count=2%; \
  /elseif ({P1} =~ 'Three') \
    /let _count=3%; \
  /elseif ({P1} =~ 'Four') \
    /let _count=4%; \
  /elseif ({P1} =~ 'Five') \
    /let _count=5%; \
  /elseif ({P1} =~ 'Six') \
    /let _count=6%; \
  /elseif ({P1} =~ 'Seven') \
    /let _count=7%; \
  /elseif ({P1} =~ 'Eight') \
    /let _count=8%; \
  /elseif ({P1} =~ 'Nine') \
    /let _count=9%; \
  /elseif ({P1} =~ 'Ten') \
    /let _count=10%; \
  /else \
    /let _count=1%; \
  /endif%; \
  !keep all slice%; \
  /test slices += _count%; \
  /eat_slices_if

/def es = /eat_slices %{*}
/def eat_slices = \
  /if (slices) \
    /let _count=$[min(slices, {1-%{slices}})]%; \
    /if (_count) \
      /runif -n'eat_slices' -t2 -- !$[_count > 1 ? strcat(_count, ' ') : '']eat slice%; \
    /endif%; \
  /endif

/def -Fp5 -mglob -t'You eat a piece of flesh from * body and gain some physical energy.' slice_eaten = \
  /test slices := max(slices - 1, 0)

/def -Fp5 -mglob -t'You give A slice of flesh from *' slice_given = \
  /slice_eaten

/def -Fp5 -msimple -t'The slice of flesh detoriates into nothingness.' slice_detoriates = \
  /slice_eaten

/def -Fp5 -msimple -t'You have no \'slice\' to eat.' no_slices = \
  /set slices=0

/def -Fp5 -mregexp -t'^There (are|is) (\\d+) \'slice\'s? in your inventory\\.$' slices_count = \
  /set slices=%{P2}

/property -s -g give_slices_to

;; Spells / Skills

/def munch = /munch_magic_item %{*}
/def munch_magic_item = \
  /let _target=%{*-%{munch}}%; \
  /alias munch %{_target}%; \
  /do_prot -a'use' -s'munch magic item' -n'Munching' -t'$(/escape ' %{_target})'

/def -Fp5 -msimple -t'The item must be on the ground.' munch_magic_item_done = !cast stop
/def -Fp5 -msimple -t'You don\'t need any magical energy right now.' munch_magic_item_done_1 = /munch_magic_item_done

/def cop = /circle_of_protection %{*}
/def circle_of_protection = \
  /let _target=%{1-me}%; \
  /if (_target =~ 'me') \
    /let _target=$[me()]%; \
  /endif%; \
  /let _pref=%{2-physical}%; \
  /let _amount=%{3-10}%; \
  /let _extra=%{-3}%; \
  /do_prot -a'cast' -s'circle of protection' -t'$(/escape ' %{_target},%{_pref},%{_amount} %{_extra})' -n'Circle of Protection'

/def ss = /shadow_shield %{*}

/def soor = /summon_orb_of_reflection %{*}

/def wob = /word_of_binding %{*}


/def cube = /chaos_cube %{*}

/def pw = /power_word %{*}

/def tod = /touch_of_darkness %{*}


/def suffo = /suffocation %{*}

/def rot = /flesh_rot %{*}

/def ec = /evaluate_corpse %{*}

/def -Fp5 -mregexp -t'^You evaluate the body of (.+) for useful parts\\.$' evaluate_corpse_start = \
  /set evaluate_corpse_name=%{P1}%; \
  /set evaluate_corpse_head=0%; \
  /set evaluate_corpse_torso=0%; \
  /set evaluate_corpse_arms=0%; \
  /set evaluate_corpse_legs=0

/def -Fp5 -mregexp -t'^[A-Za-z ]+ has suitable (head|torso|arms|legs) for you\\.$' evaluate_corpse_part

/def -Fp5 -mregexp -t'^(Head|Torso|Arms|Legs) has a quality of (\\d+)\\.$' evaluate_corpse_quality = \
  /say -d'party' -x -- $[toupper(evaluate_corpse_name, 1)]'s has %{P1} of quality %{P2}!%; \
  /let _part=$[tolower({P1})]%; \
  /set evaluate_corpse_%{_part}=%{P2}

/def -Fp5 -mregexp -t'^([A-Za-z ]+) has no useable parts\\.$' evaluate_corpse_none = \
  /say -d'party' -x -- $[toupper({P1}, 1)] is as useless dead as alive! No bodyparts!

/def -Fp5 -mregexp -t'^You remove (head|torso|arms|legs) from the corpse of (.+) with quality loss of (\\d+)\\.$' bodypart_removed = \
  /say -d'party' -x -- Removed $[toupper({P2}, 1)]'s %{P1}! Whee!%; \
  /set evaluate_corpse_%{P1}=0%; \
  /extract_bodypart

/def ebp = /extract_bodypart %{*}
/def extract_bodypart = \
  /if ({#}) \
    /do_prot -a'use' -s'extract bodypart' -t'corpse extract $(/escape ' %{1})' -q%; \
  /else \
    /if (evaluate_corpse_head > 0) \
      /extract_bodypart head%; \
    /elseif (evaluate_corpse_torso > 0) \
      /extract_bodypart torso%; \
    /elseif (evaluate_corpse_arms > 0) \
      /extract_bodypart arms%; \
    /elseif (evaluate_corpse_legs > 0) \
      /extract_bodypart legs%; \
    /else \
      !get corpse%; \
    /endif%; \
  /endif

/def mb = /modify_bodypart %{*}

/def build_body = \
  /if ({#}) \
    /do_prot -a'use' -s'build body' -t'$(/escape ' %{1},torso,head,arms,legs)'%; \
  /endif

/def -Fp19 -msimple -h'SEND @update_status' update_status_19 = \
  /update_status_x [drain:%{drain_round}/9]

/def -Fp5 -msimple -t'The week list of death knights:' death_knight_week_list_start = \
  /set week_list_sufferance=0%; \
  /set week_list_twilight=0%; \
  /set week_list_petals=0%; \
  /set week_list_none=0

/def -Fp5 -mregexp -t'^ +\\d{1,2}\\. ([A-Z][a-z]+) +\\d{1,3} +((\\d+[GMk] )+) +(Sufferance|Petals|Twilight|-)' death_knight_week_list = \
  /let _name=%{P1}%; \
  /let _exp=$[from_expstr({P2})]%; \
  /let _legion=$[tolower({P4})]%; \
  /if (_legion =~ '-') \
    /let _legion=none%; \
  /endif%; \
  /test week_list_%{_legion} += _exp

/def wls = /week_list_short %{*}
/def week_list_short = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _total=$[week_list_sufferance + week_list_twilight + week_list_petals + week_list_none]%; \
  /execute %{_cmd} Sufferance: $[to_kmg(week_list_sufferance)] ($[round(week_list_sufferance * 100 / (_total | 1), 1)]%%), Petals: $[to_kmg(week_list_petals)] ($[round(week_list_petals * 100 / (_total | 1), 1)]%%), Twilight: $[to_kmg(week_list_twilight)] ($[round(week_list_twilight * 100 / (_total | 1), 1)]%%), None: $[to_kmg(week_list_none)] ($[round(week_list_none * 100 / (_total | 1), 1)]%%), Total: $[to_kmg(_total)]

/def wl = /week_list %{*}
/def week_list = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen --%; \
  /endif%; \
  /let _total=$[week_list_sufferance + week_list_twilight + week_list_petals + week_list_none]%; \
  /execute %{_cmd} .------------------------------------------.%; \
  /execute %{_cmd} | legion      |       experience | percent |%; \
  /execute %{_cmd} |-------------+------------------+---------|%; \
  /execute %{_cmd} | sufferance  | $[pad(to_expstr(week_list_sufferance), 16)] | $[pad(round(week_list_sufferance * 100 / (_total | 1), 2), 6)]%% |%; \
  /execute %{_cmd} | petals      | $[pad(to_expstr(week_list_petals), 16)] | $[pad(round(week_list_petals * 100 / (_total | 1), 2), 6)]%% |%; \
  /execute %{_cmd} | twilight    | $[pad(to_expstr(week_list_twilight), 16)] | $[pad(round(week_list_twilight * 100 / (_total | 1), 2), 6)]%% |%; \
  /execute %{_cmd} | none        | $[pad(to_expstr(week_list_none), 16)] | $[pad(round(week_list_none * 100 / (_total | 1), 2), 6)]%% |%; \
  /execute %{_cmd} |-------------+------------------+---------|%; \
  /execute %{_cmd} | total       | $[pad(to_expstr(_total), 16)] | 100.00%% |%; \
  /execute %{_cmd} '------------------------------------------'

/def -aBCred -msimple -t'The vigorous combinations leave you tired and worn out.' color_lancer_tired

/def -aBCred -msimple -t'You leave combat.' lancer_leaving_combat = \
  /set dkc_count=0

/def -aBCcyan -msimple -t'You easily flow from one skill to the next.' color_lancer_flow = \
  /set dkc_flowing=1%; \
  /substitute -p -- %{*} [@{B}$[dkc_count + 1]%{n}]

/def -Fp6 -msimple -t'You are prepared to do the skill.' lancer_done_skill = \
  /if (dkc_flowing) \
    /test ++dkc_count%; \
  /else \
    /set dkc_count=1%; \
  /endif%; \
  /set dkc_flowing=0

;You start concentrating on the skill.


/def -aCcyan -mglob -t'You find a weak spot in * armour and drive your weapon home.' color_lancer_spot_weakness
/def -aCcyan -msimple -t'You drive your weapon home much more aggressively than usual.' color_lancer_aggressive

;;
;; DK Combos from Erase
;;

/def dkc = \
  /if (!getopts('pns', '')) \
    /return%; \
  /endif%; \
  /if (opt_p | opt_n) \
    /if (opt_p) \
      /let _num=$[dkc_count + 1]%; \
    /else \
      /let _num=$[dkc_count + 2]%; \
    /endif%; \
    /if (_num > $(/length %{dkc})) \
      /let _skill=$(/first %{dkc})%; \
    /else \
      /let _skill=$(/nth %{_num} %{dkc})%; \
    /endif%; \
    /if (!strlen(_skill)) \
      /error -m'%{0}' -a'n' -- could not determine the next skill%; \
    /endif%; \
    /do_kill -a'use' -s'$[replace('_', ' ', _skill)]'%; \
    /return%; \
  /endif%; \
  /if (opt_s) \
    /if (!{#}) \
      /error -m'%{0}' -a's' -- you must supply a variable with combos%; \
      /return%; \
    /endif%; \
    /let _skills=$[expr({1})]%; \
    /if (!strlen(_skills)) \
      /error -m'%{0}' -a's' -- could not expand expression: %{1}%; \
      /return%; \
    /endif%; \
    /set dkc=%{_skills}%; \
    /set dkc_count=0%; \
    /let _first=$[replace('_', ' ', $(/first %{_skills}))]%; \
    /set attack_skill=%{_first}%; \
    !chain suffocation:%{_first}%; \
    !chain flesh rot:%{_first}%; \
    /chain %{_skills}%; \
    /return%; \
  /endif%; \
  /if ({#} & trunc({1}) =~ {1}) \
    /if ({1} < 1 | {1} > $(/length %{dkc})) \
      /error -m'%{0}' -- number not in range 1 - $(/length %{dkc})%; \
      /return%; \
    /endif%; \
    /do_kill -a'use' -s'$[replace('_', ' ', $(/nth %{1} %{dkc}))]'%; \
    /return%; \
  /endif%; \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen --%; \
  /endif%; \
  /let i=0%; \
  /let j=$(/length %{dkc})%; \
  /execute %{_cmd} ,------------------------------.%; \
  /execute %{_cmd} |     SKILL               LAST |%; \
  /execute %{_cmd} |------------------------------|%; \
  /while (i < j) \
    /let _curr=$(/nth $[i + 1] %{dkc})%; \
    /execute %{_cmd} | $[pad(i + 1, 2)]. $[pad(toupper(replace('_', ' ', _curr)), -20)] $[i == dkc_count ? '<--' : '   '] |%; \
    /test ++i%; \
  /done%; \
  /execute %{_cmd} `------------------------------'

/set a2=fatal_blow dismember
/set a3=sweep fatal_blow dismember
/set a4=skewer sweep fatal_blow dismember
/set a5=deceitful_blow skewer sweep fatal_blow dismember
/set a6=disembowel deceitful_blow skewer sweep fatal_blow dismember
/set a7=downward_strike disembowel deceitful_blow skewer sweep fatal_blow dismember
/set a8=lunge downward_strike disembowel deceitful_blow skewer sweep fatal_blow dismember
/set a9=wild_blow lunge downward_strike disembowel deceitful_blow skewer sweep fatal_blow dismember
/set a13=wild_blow quick-thrusts lunge transpierce downward_strike disembowel piercing-blows skewer deceitful_blow cross_slash sweep fatal_blow dismember

/set b2=fatal_blow dismember
/set b3=sweep fatal_blow dismember
/set b4=cross_slash sweep fatal_blow dismember
/set b5=deceitful_blow cross_slash sweep fatal_blow dismember
/set b6=skewer deceitful_blow cross_slash sweep fatal_blow dismember
/set b7=disembowel skewer deceitful_blow cross_slash sweep fatal_blow dismember
/set b8=disembowel piercing-blows skewer deceitful_blow cross_slash sweep fatal_blow dismember
/set b9=downward_strike disembowel piercing-blows skewer deceitful_blow cross_slash sweep fatal_blow dismember
/set b10=transpierce downward_strike disembowel piercing-blows skewer deceitful_blow cross_slash sweep fatal_blow dismember
/set b11=lunge transpierce downward_strike disembowel piercing-blows skewer deceitful_blow cross_slash sweep fatal_blow dismember
/set b12=quick-thrusts lunge transpierce downward_strike disembowel piercing-blows skewer deceitful_blow cross_slash sweep fatal_blow dismember
/set b13=wild_blow quick-thrusts lunge transpierce downward_strike disembowel piercing-blows skewer deceitful_blow cross_slash sweep fatal_blow dismember

/def -Fp5 -msimple -h'SEND @save' save_death_knight = /mapcar /listvar give_slices_to report_drains %| /writefile $[save_dir('death_knight')]
/eval /load $[save_dir('death_knight')]
