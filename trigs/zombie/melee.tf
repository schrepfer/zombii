;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; GENERIC HITTER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-07-08 21:14:36 +0300 (Fri, 08 Jul 2011) $
;; $HeadURL: svn://maddcow.us:65530/users/schrepfer/zombii/trigs/zombie/melee.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/users/schrepfer/zombii/trigs/zombie/melee.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def -Fp5 -msimple -t'Your concentration starts to crack and its hard to keep your calm mind.' combat_trance_falling = \
  /say -c'yellow' -- Berserk Falling! (%{ignores} ignore$[ignores == 1 ? '' : 's'])
