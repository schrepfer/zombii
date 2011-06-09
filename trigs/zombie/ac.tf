;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ARMOUR CLASS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-08-20 13:59:19 -0700 (Fri, 20 Aug 2010) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/ac.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/ac.tf $', 10, -2)]

/def -Fp5 -msimple -t'Your armour offers you not even a sense of protection against physical damage.' armour_class_neg = /substitute -p -- %{*} [@{B}neg@{n}]
/def -Fp5 -msimple -t'Your armour offers you no protection against physical damage.' armour_class_0 = /substitute -p -- %{*} [@{B}0@{n}]
/def -Fp5 -msimple -t'Your armour offers you barely existent protection against physical damage.' armour_class_1 = /substitute -p -- %{*} [@{B}1@{n}]
/def -Fp5 -msimple -t'Your armour offers you hardly perceivable protection against physical damage.' armour_class_2 = /substitute -p -- %{*} [@{B}2@{n}]
/def -Fp5 -msimple -t'Your armour offers you tiny amount of protection against physical damage.' armour_class_3 = /substitute -p -- %{*} [@{B}3@{n}]
/def -Fp5 -msimple -t'Your armour offers you wretched protection against physical damage.' armour_class_4 = /substitute -p -- %{*} [@{B}4@{n}]
/def -Fp5 -msimple -t'Your armour offers you pathetic protection against physical damage.' armour_class_5 = /substitute -p -- %{*} [@{B}5@{n}]
/def -Fp5 -msimple -t'Your armour offers you bad protection against physical damage.' armour_class_6 = /substitute -p -- %{*} [@{B}6@{n}]
/def -Fp5 -msimple -t'Your armour offers you little protection against physical damage.' armour_class_7 = /substitute -p -- %{*} [@{B}7@{n}]
/def -Fp5 -msimple -t'Your armour offers you feeble protection against physical damage.' armour_class_8 = /substitute -p -- %{*} [@{B}8@{n}]
/def -Fp5 -msimple -t'Your armour offers you poor protection against physical damage.' armour_class_9 = /substitute -p -- %{*} [@{B}9@{n}]
/def -Fp5 -msimple -t'Your armour offers you subtle protection against physical damage.' armour_class_10 = /substitute -p -- %{*} [@{B}10@{n}]
/def -Fp5 -msimple -t'Your armour offers you a mere trace of protection against physical damage.' armour_class_11 = /substitute -p -- %{*} [@{B}11@{n}]
/def -Fp5 -msimple -t'Your armour offers you weak protection against physical damage.' armour_class_12 = /substitute -p -- %{*} [@{B}12@{n}]
/def -Fp5 -msimple -t'Your armour offers you slight protection against physical damage.' armour_class_13 = /substitute -p -- %{*} [@{B}13@{n}]
/def -Fp5 -msimple -t'Your armour offers you quite low protection against physical damage.' armour_class_14 = /substitute -p -- %{*} [@{B}14@{n}]
/def -Fp5 -msimple -t'Your armour offers you low protection against physical damage.' armour_class_15 = /substitute -p -- %{*} [@{B}15@{n}]
/def -Fp5 -msimple -t'Your armour offers you inadequate protection against physical damage.' armour_class_16 = /substitute -p -- %{*} [@{B}16@{n}]
/def -Fp5 -msimple -t'Your armour offers you fair protection against physical damage.' armour_class_17 = /substitute -p -- %{*} [@{B}17@{n}]
/def -Fp5 -msimple -t'Your armour offers you mediocre protection against physical damage.' armour_class_18 = /substitute -p -- %{*} [@{B}18@{n}]
/def -Fp5 -msimple -t'Your armour offers you moderate protection against physical damage.' armour_class_19 = /substitute -p -- %{*} [@{B}19@{n}]
/def -Fp5 -msimple -t'Your armour offers you average protection against physical damage.' armour_class_20 = /substitute -p -- %{*} [@{B}20@{n}]
/def -Fp5 -msimple -t'Your armour offers you above average protection against physical damage.' armour_class_21 = /substitute -p -- %{*} [@{B}21@{n}]
/def -Fp5 -msimple -t'Your armour offers you almost proper protection against physical damage.' armour_class_22 = /substitute -p -- %{*} [@{B}22@{n}]
/def -Fp5 -msimple -t'Your armour offers you noticeable protection against physical damage.' armour_class_23 = /substitute -p -- %{*} [@{B}23@{n}]
/def -Fp5 -msimple -t'Your armour offers you adequate protection against physical damage.' armour_class_24 = /substitute -p -- %{*} [@{B}24@{n}]
/def -Fp5 -msimple -t'Your armour offers you decent protection against physical damage.' armour_class_25 = /substitute -p -- %{*} [@{B}25@{n}]
/def -Fp5 -msimple -t'Your armour offers you considerable amount of protection against physical damage.' armour_class_26 = /substitute -p -- %{*} [@{B}26@{n}]
/def -Fp5 -msimple -t'Your armour offers you good protection against physical damage.' armour_class_27 = /substitute -p -- %{*} [@{B}27@{n}]
/def -Fp5 -msimple -t'Your armour offers you nice protection against physical damage.' armour_class_28 = /substitute -p -- %{*} [@{B}28@{n}]
/def -Fp5 -msimple -t'Your armour offers you enviable protection against physical damage.' armour_class_29 = /substitute -p -- %{*} [@{B}29@{n}]
/def -Fp5 -msimple -t'Your armour offers you strong protection against physical damage.' armour_class_30 = /substitute -p -- %{*} [@{B}30@{n}]
/def -Fp5 -msimple -t'Your armour offers you very good protection against physical damage.' armour_class_31 = /substitute -p -- %{*} [@{B}31@{n}]
/def -Fp5 -msimple -t'Your armour offers you extremely good protection against physical damage.' armour_class_32 = /substitute -p -- %{*} [@{B}32@{n}]
/def -Fp5 -msimple -t'Your armour offers you great protection against physical damage.' armour_class_33 = /substitute -p -- %{*} [@{B}33@{n}]
/def -Fp5 -msimple -t'Your armour offers you excellent protection against physical damage.' armour_class_34 = /substitute -p -- %{*} [@{B}34@{n}]
/def -Fp5 -msimple -t'Your armour offers you incredible protection against physical damage.' armour_class_35 = /substitute -p -- %{*} [@{B}35@{n}]
/def -Fp5 -msimple -t'Your armour offers you awesome protection against physical damage.' armour_class_36 = /substitute -p -- %{*} [@{B}36@{n}]
/def -Fp5 -msimple -t'Your armour offers you partly impenetrable protection against physical damage.' armour_class_37 = /substitute -p -- %{*} [@{B}37@{n}]
/def -Fp5 -msimple -t'Your armour offers you close to perfect protection against physical damage.' armour_class_38 = /substitute -p -- %{*} [@{B}38@{n}]
/def -Fp5 -msimple -t'Your armour offers you nearly invincible protection against physical damage.' armour_class_39 = /substitute -p -- %{*} [@{B}39@{n}]
/def -Fp5 -msimple -t'Your armour offers you BEST protection against physical damage.' armour_class_40 = /substitute -p -- %{*} [@{B}40@{n}]
