;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; RANGER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-01-07 00:07:40 -0800 (Fri, 07 Jan 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/ranger.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/ranger.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set ranger=1

/def forage = /foraging %{*}
/def fb = /fire_building %{*}
/def son = /spirit_of_nature %{*}
/def hunt = /hunting %{*}
/def tc = /treecutting %{*}
/def bf = /bladed_fury %{*}

/def summon_wild_cat = \
  /set ranger_pet_wild_cat=%{*-%{ranger_pet_wild_cat}}%; \
  /do_prot -a'cast' -s'summon wild cat' -t'$(/escape ' %{ranger_pet_wild_cat})' -n'Summoning Wild Cat'%; \
  /save_ranger

/def summon_wolf = \
  /set ranger_pet_wolf=%{*-%{ranger_pet_wolf}}%; \
  /do_prot -a'cast' -s'summon wolf' -t'$(/escape ' %{ranger_pet_wolf})' -n'Summoning Wolf'%; \
  /save_ranger

/def summon_eagle = \
  /set ranger_pet_eagle=%{*-%{ranger_pet_eagle}}%; \
  /do_prot -a'cast' -s'summon eagle' -t'$(/escape ' %{ranger_pet_eagle})' -n'Summoning Eagle'%; \
  /save_ranger

/def summon_bear = \
  /set ranger_pet_bear=%{*-%{ranger_pet_bear}}%; \
  /do_prot -a'cast' -s'summon bear' -t'$(/escape ' %{ranger_pet_bear})' -n'Summoning Bear'%; \
  /save_ranger

/def summon_fire_drake = \
  /set ranger_pet_fire_drake=%{*-%{ranger_pet_fire_drake}}%; \
  /do_prot -a'cast' -s'summon fire drake' -t'$(/escape ' %{ranger_pet_fire_drake})' -n'Summoning Fire Drake'%; \
  /save_ranger

/def -Fp5 -mregexp -t'^The (cat|wolf|bear|drake|eagle) nods friendly at you\\.$' pet_summoned = \
  /beastspeak follow me

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) speaks to you: I will now follow you\\.$' pet_speaks = \
  /set ranger_pet_name=%{P1}

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) speaks to you: If that\'s what you want I\'ll go find some food\\.$' pet_leaves = \
  /if ({P1} =~ ranger_pet_name) \
    /unset ranger_pet_name%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) speaks to you: Arghh! ' pet_dies = \
  /if ({P1} =~ ranger_pet_name) \
    /unset ranger_pet_name%; \
  /endif

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_ranger = \
  /unset ranger_pet_name

/def -Fp5 -msimple -t'You return to speaking the common language of Zombiemud.' speak_common = \
  /set speak=common

/def -Fp5 -mregexp -t'^You begin speaking ([a-z]+)\\.$' speak_other = \
  /set speak=%{P1}

/def bsay = /beastspeak %{*}

/def beastspeak = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /if (speak !~ 'beastspeak') \
    !speak beastspeak%; \
  /endif%; \
  !say %{*}%; \
  /if (speak !~ 'beastspeak') \
    !speak %{speak}%; \
  /endif

/def -Fp5 -mglob -h'SEND @on_enemy_killed *' on_enemy_killed_ranger = \
  /if (strlen(ranger_pet_name)) \
    !pet $[tolower(ranger_pet_name)]%; \
    /beastspeak eat all%; \
  /endif

/def -Fp5 -msimple -t'You find a good berry bush.' find_berry_bush = \
  /given_berries

/def -Fp5 -msimple -t'You find a colourful berry bush.' find_colorful_berry_bush = \
  /given_berries

;;
;; RANGER PATHS
;;

/def update_path = \
  /if (!getopts('n:p#l#', '') | !strlen(opt_n)) \
    /return%; \
  /endif%; \
  /test opt_n := textencode(opt_n)%; \
  /if (opt_p) \
    /set path_%{opt_n}_progress=%{opt_p}%; \
  /endif%; \
  /if (opt_l) \
    /set path_%{opt_n}_level=%{opt_l}%; \
  /endif

/def -Fp5 -mregexp -t'^You will advance in (axe fighting techniques|sword fighting techniques|archery|wilderness survival|beastmastery) (.+)\\.$' path_progress = \
  /if ({P2} =~ 'in a long time') \
    /let _progress=0%; \
  /elseif ({P2} =~ 'in a very long while') \
    /let _progress=1%; \
  /elseif ({P2} =~ 'in quite a long while') \
    /let _progress=2%; \
  /elseif ({P2} =~ 'in a long while') \
    /let _progress=3%; \
  /elseif ({P2} =~ 'in a while') \
    /let _progress=4%; \
  /elseif ({P2} =~ 'in a little while') \
    /let _progress=5%; \
  /elseif ({P2} =~ 'in a short while') \
    /let _progress=6%; \
  /elseif ({P2} =~ 'soon') \
    /let _progress=7%; \
  /elseif ({P2} =~ 'very soon') \
    /let _progress=8%; \
  /elseif ({P2} =~ 'extremely soon') \
    /let _progress=9%; \
  /else \
    /set _progress=0%; \
  /endif%; \
  /let _key=ranger_progress_$[textencode({P1})]%; \
  /let _delta=$[_progress - expr(_key)]%; \
  /substitute -p -- %{*} [%{_progress} of 10]$[delta_only(_delta, ' {', '}')]%; \
  /set %{_key}=%{_progress}%; \

;;
;; WEAPON SKILLS
;;

/def -Fp5 -mregexp -t'^You are completely clueless about ([a-z, ]+) which makes you a danger to others\\.$' path_weapons_1 = \
  /substitute -p -- %{*} [1 of 20]

/def -Fp5 -mregexp -t'^You have started learning about ([a-z ]+)\\.$' path_weapons_2 = \
  /substitute -p -- %{*} [2 of 20]

/def -Fp5 -mregexp -t'^You have a little knowledge in ([a-z ]+)\\.$' path_weapons_3 = \
  /substitute -p -- %{*} [3 of 20]

/def -Fp5 -mregexp -t'^You have learned a few basic facts about ([a-z ]+)\\.$' path_weapons_4 = \
  /substitute -p -- %{*} [4 of 20]

/def -Fp5 -mregexp -t'^You have newbie skills in ([a-z ]+)\\.$' path_weapons_5 = \
  /substitute -p -- %{*} [5 of 20]

/def -Fp5 -mregexp -t'^You have novice skills in ([a-z ]+)\\.$' path_weapons_6 = \
  /substitute -p -- %{*} [6 of 20]

/def -Fp5 -mregexp -t'^You are an apprentice in ([a-z ]+)\\.$' path_weapons_7 = \
  /substitute -p -- %{*} [7 of 20]

/def -Fp5 -mregexp -t'^You are a skilled apprentice in ([a-z ]+)\\.$' path_weapons_8 = \
  /substitute -p -- %{*} [8 of 20]

/def -Fp5 -mregexp -t'^You are very talented in ([a-z ]+)\\.$' path_weapons_9 = \
  /substitute -p -- %{*} [9 of 20]

/def -Fp5 -mregexp -t'^You are unusually talented in ([a-z ]+)\\.$' path_weapons_10 = \
  /substitute -p -- %{*} [10 of 20]

/def -Fp5 -mregexp -t'^You have honed your skills in ([a-z ]+)\\.$' path_weapons_11 = \
  /substitute -p -- %{*} [11 of 20]

/def -Fp5 -mregexp -t'^You are highly skilled in ([a-z ]+)\\.$' path_weapons_12 = \
  /substitute -p -- %{*} [12 of 20]

/def -Fp5 -mregexp -t'^You have exceptional skills in ([a-z ]+)\\.$' path_weapons_13 = \
  /substitute -p -- %{*} [13 of 20]

/def -Fp5 -mregexp -t'^Your talents in ([a-z ]+) are well known amongst the rangers\\.$' path_weapons_14 = \
  /substitute -p -- %{*} [14 of 20]

/def -Fp5 -mregexp -t'^Your talents in ([a-z ]+) are known by many\\.$' path_weapons_15 = \
  /substitute -p -- %{*} [15 of 20]

/def -Fp5 -mregexp -t'^Your talents in ([a-z ]+) are known throughout the world\\.$' path_weapons_16 = \
  /substitute -p -- %{*} [16 of 20]

/def -Fp5 -mregexp -t'^You are often feared for your skill in ([a-z ]+)\\.$' path_weapons_17 = \
  /substitute -p -- %{*} [17 of 20]

/def -Fp5 -mregexp -t'^You are a master in ([a-z ]+) and your enemies tremble at your name\\.$' path_weapons_18 = \
  /substitute -p -- %{*} [18 of 20]

/def -Fp5 -mregexp -t'^You are a grand master in ([a-z ]+) and everyone fears your awesome skills\\.$' path_weapons_19 = \
  /substitute -p -- %{*} [19 of 20]

/def -Fp5 -mregexp -t'^You are feared and revered throughout the world for your legendary skills in ([a-z ]+)\\.$' path_weapons_20 = \
  /substitute -p -- %{*} [20 of 20]

;;
;; WILDERNESS SURVIVAL
;;

/def -Fp5 -msimple -t'You couldn\'t light a fire with a flamethrower.' path_winderness_survival_1 = \
  /substitute -p -- %{*} [1 of 20]

/def -Fp5 -msimple -t'Bunny rabbits dance in front of you for kicks.' path_winderness_survival_2 = \
  /substitute -p -- %{*} [2 of 20]

/def -Fp5 -msimple -t'People mistake your campsites for rubbish heaps.' path_winderness_survival_3 = \
  /substitute -p -- %{*} [3 of 20]

/def -Fp5 -msimple -t'You once caught a lame baby mouse.' path_winderness_survival_4 = \
  /substitute -p -- %{*} [4 of 20]

/def -Fp5 -msimple -t'Your poison ivy itches amuse people.' path_winderness_survival_5 = \
  /substitute -p -- %{*} [5 of 20]

/def -Fp5 -msimple -t'You are sometimes found by search parties.' path_winderness_survival_6 = \
  /substitute -p -- %{*} [6 of 20]

/def -Fp5 -msimple -t'You once had to live off rats to survive.' path_winderness_survival_7 = \
  /substitute -p -- %{*} [7 of 20]

/def -Fp5 -msimple -t'You sometimes have to sleep under trees.' path_winderness_survival_8 = \
  /substitute -p -- %{*} [8 of 20]

/def -Fp5 -msimple -t'You probably won\'t poison yourself in the wilderness.' path_winderness_survival_9 = \
  /substitute -p -- %{*} [9 of 20]

/def -Fp5 -msimple -t'You know where to find food.' path_winderness_survival_10 = \
  /substitute -p -- %{*} [10 of 20]

/def -Fp5 -msimple -t'You construct snug hideaways.' path_winderness_survival_11 = \
  /substitute -p -- %{*} [11 of 20]

/def -Fp5 -msimple -t'Your campfires burn brightly.' path_winderness_survival_12 = \
  /substitute -p -- %{*} [12 of 20]

/def -Fp5 -msimple -t'You know enough to survive in the wilderness.' path_winderness_survival_13 = \
  /substitute -p -- %{*} [13 of 20]

/def -Fp5 -msimple -t'You can hunt silently and well.' path_winderness_survival_14 = \
  /substitute -p -- %{*} [14 of 20]

/def -Fp5 -msimple -t'People call on you when someone is lost.' path_winderness_survival_15 = \
  /substitute -p -- %{*} [15 of 20]

/def -Fp5 -msimple -t'You can live in the wilderness with ease.' path_winderness_survival_16 = \
  /substitute -p -- %{*} [16 of 20]

/def -Fp5 -msimple -t'Your campfires are skillfully constructed.' path_winderness_survival_17 = \
  /substitute -p -- %{*} [17 of 20]

/def -Fp5 -msimple -t'You have seen places no-one else will ever see.' path_winderness_survival_18 = \
  /substitute -p -- %{*} [18 of 20]

/def -Fp5 -msimple -t'You never get lost.' path_winderness_survival_19 = \
  /substitute -p -- %{*} [19 of 20]

/def -Fp5 -msimple -t'You are a master of wilderness survival.' path_winderness_survival_20 = \
  /substitute -p -- %{*} [20 of 20]


;;
;; BEASTMASTERY
;;

/def -Fp5 -msimple -t'Little girls say \'You, a beastmaster?\' and laugh.' path_beastmastery_1 = \
  /substitute -p -- %{*} [1 of 20]

/def -Fp5 -msimple -t'Your shoes are urinated on by hamsters.' path_beastmastery_2 = \
  /substitute -p -- %{*} [2 of 20]

/def -Fp5 -msimple -t'You have trouble controlling even your pet fishes.' path_beastmastery_3 = \
  /substitute -p -- %{*} [3 of 20]

/def -Fp5 -msimple -t'You have started your training at becoming a beastmaster.' path_beastmastery_4 = \
  /substitute -p -- %{*} [4 of 20]

/def -Fp5 -msimple -t'Animals have been known to mistake you for someone they know.' path_beastmastery_5 = \
  /substitute -p -- %{*} [5 of 20]

/def -Fp5 -msimple -t'You are occasionally addressed by beasts.' path_beastmastery_6 = \
  /substitute -p -- %{*} [6 of 20]

/def -Fp5 -msimple -t'You are sometimes helped by beasts if you ask very nicely.' path_beastmastery_7 = \
  /substitute -p -- %{*} [7 of 20]

/def -Fp5 -msimple -t'Animals sometimes enjoy your company.' path_beastmastery_8 = \
  /substitute -p -- %{*} [8 of 20]

/def -Fp5 -msimple -t'Animals find you interesting.' path_beastmastery_9 = \
  /substitute -p -- %{*} [9 of 20]

/def -Fp5 -msimple -t'You never get bitten by dogs anymore.' path_beastmastery_10 = \
  /substitute -p -- %{*} [10 of 20]

/def -Fp5 -msimple -t'Horses tell you their personal problems.' path_beastmastery_11 = \
  /substitute -p -- %{*} [11 of 20]

/def -Fp5 -msimple -t'Other rangers look to you for advice in taking care of beasts.' path_beastmastery_12 = \
  /substitute -p -- %{*} [12 of 20]

/def -Fp5 -msimple -t'You are approached by owls for advice.' path_beastmastery_13 = \
  /substitute -p -- %{*} [13 of 20]

/def -Fp5 -msimple -t'You can read the tracks of wild animals like a good book.' path_beastmastery_14 = \
  /substitute -p -- %{*} [14 of 20]

/def -Fp5 -msimple -t'You are sometimes asked to babysit for bears.' path_beastmastery_15 = \
  /substitute -p -- %{*} [15 of 20]

/def -Fp5 -msimple -t'When you call, animals answer you.' path_beastmastery_16 = \
  /substitute -p -- %{*} [16 of 20]

/def -Fp5 -msimple -t'You are one of the elite beastmasters.' path_beastmastery_17 = \
  /substitute -p -- %{*} [17 of 20]

/def -Fp5 -msimple -t'The fame of your knowledge has spread far.' path_beastmastery_18 = \
  /substitute -p -- %{*} [18 of 20]

/def -Fp5 -msimple -t'Even the mightiest of beasts acknowledge your beastmastery skills.' path_beastmastery_19 = \
  /substitute -p -- %{*} [19 of 20]

/def -Fp5 -msimple -t'You are one with the animal kingdom.' path_beastmastery_20 = \
  /substitute -p -- %{*} [20 of 20]


/def -Fp5 -msimple -h'SEND @save' save_ranger = /mapcar /listvar ranger_pet_* %| /writefile $[save_dir('ranger')]
/eval /load $[save_dir('ranger')]
