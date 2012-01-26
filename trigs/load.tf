;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; LOAD THE VARIOUS INITIAL SCRIPTS... ONCE!
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-08-20 13:59:37 -0700 (Fri, 20 Aug 2010) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/load.tf $
;;

/def load_trigs = \
  /if (!_trigs_loaded & strlen(world_info('name'))) \
    /load $[trigs_dir(world_info('name'))]%; \
    /set _trigs_loaded=1%; \
  /endif

/load_trigs
