;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; LEPER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-08-20 13:59:19 -0700 (Fri, 20 Aug 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/leper.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/leper.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def -Fp10 -mregexp -t'^Leper <sales>: ' leper_sales = \
  /if (strlen(email) & is_away()) \
    /mail -s'Leper sales' -- %{PR}%; \
  /endif

/def -Fp10 -mregexp -t'^Leper shouts \'(.+)\'$' leper_shouts = \
  /if (strlen(email) & is_away()) \
    /mail -s'Leper shouts' -- %{P1}%; \
  /endif
