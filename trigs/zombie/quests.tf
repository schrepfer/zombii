;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; QUEST TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-03-11 15:33:39 -0800 (Fri, 11 Mar 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/quests.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/quests.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def aq = \
  /if (!strlen(quest_name)) \
    /return%; \
  /endif%; \
  /let _msg=Quest '%{quest_name}' worth %{quest_value} points is %{quest_percent} percent complete%; \
  /if ({#}) \
    !%{*} %{_msg}%; \
  /else \
    /say -d'party' -x -- %{_msg}%; \
  /endif

/def -Fp5 -msimple -t'You have been given the following quest:' new_quest = /set quest_new=1
/def -Fp5 -mregexp -t'^Name             : (.*)$' set_quest_name = /set quest_name=%{P1}
/def -Fp5 -mregexp -t'^Solved           : (.*)%$' set_quest_percent = /set quest_percent=%{P1}
/def -Fp5 -mregexp -t'^Quest point value: (.*)$' set_quest_value = /set quest_value=%{P1}
/def -Fp5 -msimple -t'Information      :' set_quest_information = \
  /if (quest_new) \
    /if (announce) \
      /aq%; \
    /endif%; \
    /unset quest_new%; \
  /endif

/def lq = \
  /if (!strlen(quest_name)) \
    /return%; \
  /endif%; \
  /say -d'party' -b -- %% $[toupper(quest_name)] [%{quest_value} points] (%{quest_percent}%%)%; \
  /say -d'party' -b -- %% %; \
  /quote -S /say -d\\'party\\' -b -- %% !wget -qO - 'http://www.zombii.org/quests/?q=$[urlencode(quest_name)]&f=hint'

/def -Fp5 -mglob -t'Congratulations! You have just solved the quest called *' quest_solved = \
  /set quest_percent=100%; \
  /if (announce) \
    /say -d'party' -x -- Solved '%{quest_name}' for %{quest_value} points%; \
  /endif

/def -Fp5 -mregexp -t'^inn, just say our code: \'(\\d{5})\'' set_cronal_code = \
  !channels topic alert %{P1}

/def -Fp5 -msimple -t'You can see a circular image of a landscape with a thin black cross ' advanced_target_practice = \
  /set advanced_target_practice=%{*}%; \
  /def -Fp5 -mregexp -t'' advanced_target_practice_more = \
    /set advanced_target_practice=%%{advanced_target_practice} %%{*}%%; \
    /if (substr({*}, -1) =~ '.') \
      /solve_advanced_target_practice %%{advanced_target_practice}%%; \
      /purgedef advanced_target_practice_more%%; \
    /endif

/def solve_advanced_target_practice = \
  /if ({*} =~ 'You can see a circular image of a landscape with a thin black cross over it. The vertical line of the cross is marked with five notches above the horizontal line and five notches below it.') \
    /say -d'party' -- Advanced target practice already solved%; \
    /return%; \
  /endif%; \
  /let _mult=5%; \
  /let _dir=0%; \
  /if (regmatch('Right around the (first|second|third|fourth|fifth) notch (above|below) the horizontal line,', {*})) \
    /if ({P1} =~ 'first') \
      /let _mult=4%; \
    /elseif ({P1} =~ 'second') \
      /let _mult=3%; \
    /elseif ({P1} =~ 'third') \
      /let _mult=2%; \
    /elseif ({P1} =~ 'fourth') \
      /let _mult=1%; \
    /elseif ({P1} =~ 'fifth') \
      /let _mult=0%; \
    /endif%; \
    /if ({P2} =~ 'above') \
      /let _dir=1%; \
    /else \
      /let _dir=-1%; \
    /endif%; \
  /elseif (!regmatch('Right around the horizontal line,', {*})) \
    /return%; \
  /endif%; \
  /if (_dir >= 0) \
    /let _cmd=10 lengthen ropes%; \
    /if (_mult > 0) \
      /let _cmd=%{_cmd};%{_mult} shorten ropes%; \
    /endif%; \
  /else \
    /let _cmd=10 shorten ropes%; \
    /if (_mult > 0) \
      /let _cmd=%{_cmd};%{_mult} lengthen ropes%; \
    /endif%; \
  /endif%; \
  /let _dir=0%; \
  /let _turns=1%; \
  /if (regmatch('slightly to the (left|right) of the vertical line,', {*})) \
    /let _turns=0%; \
    /if ({P1} =~ 'left') \
      /let _dir=1%; \
    /else \
      /let _dir=-1%; \
    /endif%; \
  /elseif (!regmatch('close to the vertical line,', {*})) \
    /return%; \
  /endif%; \
  /if (_dir >= 0) \
    /let _cmd=%{_cmd};2 turn platform south%; \
    /if (_turns > 0) \
      /let _cmd=%{_cmd};%{_turns} turn platform north%; \
    /endif%; \
  /else \
    /let _cmd=%{_cmd};2 turn platform north%; \
    /if (_turns > 0) \
      /let _cmd=%{_cmd};%{_turns} turn platform south%; \
    /endif%; \
  /endif%; \
  /let _cmd=%{_cmd};pull lever%; \
  /say -d'party' -- %{_cmd}
