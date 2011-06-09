;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; _WORLD_
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-04-05 00:35:38 -0700 (Tue, 05 Apr 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/example.tf $
;;

;;
;; Variables
;;
/set me=_USERNAME_

;;
;; Load trigs
;;
/load zombie.tf

;;
;; Load extra trigs
;;
/load zombie/colors.tf
/load zombie/do_heal.tf
/load zombie/do_kill.tf
/load zombie/do_prot.tf
/load zombie/ac.tf
/load zombie/effects.tf
/load zombie/areas.tf
/load zombie/sksp.tf
/load zombie/quests.tf
/load zombie/help_spell.tf
/load zombie/casts.tf
/load zombie/hitter.tf
/load zombie/languages.tf
/load zombie/npc_worth.tf

;;
;; Load guild trigs
;;
;/load zombie/fighter.tf

;;
;; Personal variables
;;
/set kprefix=# 
/set kecho=1
/set isize=2

;;
;; Function keys
;;
;/def key_f3 = /skip
;/def key_f4 = /next_room
;/def key_f5 = /k
;/def key_f6 = /kk
