;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; NPC WORTH
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-08-20 13:59:19 -0700 (Fri, 20 Aug 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/npc_worth.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/npc_worth.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def -Fp5 -mregexp -t'^\\d{2}:\\d{2} +(\\d+): ' party_kills = \
  /let _name=%{PR}%; \
  /let _worth=%{P1}%; \
  /set npc_worth_$[textencode(_name)]=%{_worth}%; \

/def -Fp5 -mregexp -t'' npc_worth = \
  /if (encode_attr({*}) =/ '@\\{Cmagenta\\}*@\\{n\\}') \
    /let _npc_worth=$[expr(strcat('npc_worth_', textencode({*})))]%; \
    /if (_npc_worth) \
      /substitute -- %{*} [$[to_expstr(_npc_worth)]]%; \
    /endif%; \
  /endif

/def -Fp5 -msimple -h'SEND @save' save_npc_worth = /mapcar /listvar npc_worth_* %| /writefile $[save_dir('npc_worth')]
/eval /load $[save_dir('npc_worth')]
