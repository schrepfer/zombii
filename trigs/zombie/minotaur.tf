;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MINOTAUR TRIGGERS 
;;


;; Fame
/def -Fp10 -msimple -t' * You have just started to gather new fame.' mfame_0 = /substitute -p -- %{*} [@{B}0/4@{n}]
/def -Fp10 -msimple -t' * You have gathered some fame, but there is still much to gain.' mfame_1 = /substitute -p -- %{*} [@{B}1/4@{n}]
/def -Fp10 -msimple -t' * Your progress has been good. Some will recognize your fame.' mfame_2 = /substitute -p -- %{*} [@{B}2/4@{n}]
/def -Fp10 -msimple -t' * Many would recognize your fame, but more is needed.' mfame_3 = /substitute -p -- %{*} [@{B}3/4@{n}]
/def -Fp10 -msimple -t' * Soon everybody will recognize your fame.' mfame_1 = /substitute -p -- %{*} [@{B}4/4@{n}]

;; Rank
/def -Fp10 -msimple -t'      *==)============  Novice   ============(==*' mrank_1 = /substitute -p -- %{*} [@{B}1/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Recruit   ============(==*' mrank_2 = /substitute -p -- %{*} [@{B}2/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Apprentice   ============(==*' mrank_3 = /substitute -p -- %{*} [@{B}3/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Initiate   ============(==*' mrank_4 = /substitute -p -- %{*} [@{B}4/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Journeyman   ============(==*' mrank_5 = /substitute -p -- %{*} [@{B}5/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Adventurer   ============(==*' mrank_6 = /substitute -p -- %{*} [@{B}6/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Sword-for-hire   ============(==*' mrank_7 = /substitute -p -- %{*} [@{B}7/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Veteran   ============(==*' mrank_8 = /substitute -p -- %{*} [@{B}8/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Knight   ============(==*' mrank_9 = /substitute -p -- %{*} [@{B}9/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Master   ============(==*' mrank_10 = /substitute -p -- %{*} [@{B}10/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Grandmaster   ============(==*' mrank_11 = /substitute -p -- %{*} [@{B}11/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Hero   ============(==*' mrank_12 = /substitute -p -- %{*} [@{B}12/13@{n}]
/def -Fp10 -msimple -t'      *==)============  Lord   ============(==*' mrank_13 = /substitute -p -- %{*} [@{B}13/13@{n}]

;; Rage
/def -Fp10 -msimple -t' * You are absolutely calm.' mrage_0 = /substitute -p -- %{*} [@{B}0/5@{n}]
/def -Fp10 -msimple -t' * You have tasted the combat and are in the passion for more.' mrage_1 = /substitute -p -- %{*} [@{B}1/5@{n}]
/def -Fp10 -msimple -t' * You let the combat flow in you, dealing terrible blows.' mrage_2 = /substitute -p -- %{*} [@{B}2/5@{n}]
/def -Fp10 -msimple -t' * You bellow in the rage, fighting with primal instincts.' mrage_3 = /substitute -p -- %{*} [@{B}3/5@{n}]
/def -Fp10 -msimple -t' * Rage is flaring from your eyes, enemies will fall.' mrage_4 = /substitute -p -- %{*} [@{B}4/5@{n}]
/def -Fp10 -msimple -t' * Rage and adrenaline burn your veins. Slaughter and blood follows.' mrage_5 = /substitute -p -- %{*} [@{B}5/5@{n}]
