;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SORCERER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-15 18:17:22 -0700 (Fri, 15 Oct 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/sorcerer.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/sorcerer.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set sorcerer=1

/def -Fp5 -mregexp -t'^You feel you have reached a higher understanding of (.+)\\.$' gained_sorcerer_point = \
  /say -c'red' -- Gained Sorcerer $[toupper({P1})] Point!

/def -Fp5 -mglob -t'Epilepsy is set loose upon * mind.' epilepsy_up = \
  /say -d'party' -x -m -c'green' -f'UP' -- Epilepsy

/def -Fp5 -mglob -t'You reach through space itself and bring forth the writhing power to negate.' vortex_magica_up = \
  /say -d'party' -x -m -c'green' -f'UP' -- Vortex Magica

;;
;; ATTACK SPELLS
;;

;;
;; Type: attack
;; Preference: cold
;; Duration: 1-2 rounds
;;
;thermal_drain

;;
;; Type:
;; Preference: 
;; Duration: 
;;
/def bd = /black_death %{*}
;black_death

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;cellular_asphyxia

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;chain_lightning

;;
;; Type: attack
;; Preference: acid, fire, magical, electrical
;; Duration: 1-4 rounds
;;
/def cl = /chaos_lance %{*}
;chaos_lance

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;daggers_of_ice

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;earthslide

;;
;; Type: modifier
;; Preference: none
;; Duration: 2 rounds
;; Other: makes the target extremely hungry
;;
;energy_consumption

;;
;; Type: attack
;; Preference: physical
;; Duration: 2 rounds
;; Other: causes the target to lose consciousness often
;;
;epilepsy
/def ep = /epilepsy %{*}

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;frost_globe

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;magical_storm

;;
;; Type: attack
;; Preference: electric, magic, fire
;; Duration: 1-4 rounds
;; Other: shoots many colorful missiles at target
;;
;missile_storm
/def ms = /missile_storm %{*}

;;
;; Type: attack
;; Preference: electric
;; Duration: 1 round
;;
;neural_internecion
/def ni = /neural_internecion %{*}

;;
;; Type: attack
;; Preference: physical
;; Duration: 1-2 rounds
;;
/def sl = /shatter_limb %{*}
;shatter_limb

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;voids_of_life

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;watery_breath

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;wildfire

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;magical_transfixion

;;
;; Type: attack
;; Preference: physical
;; Duration: 
;;
;force_of_nature
/def fn = /force_of_nature %{*}

;;
;; Alters resistances on the target
;; Type:
;; Preference: 
;; Duration: 
;;
;immunal_disorder

;;
;; Type: attack
;; Preference: electric
;; Duration: 1-3 rounds
;;
;particle_collision
/def pco = /particle_collision %{*}

;;
;; OTHER SPELLS
;;

;reverie_shadow

;;
;; Type: attack
;; Preference: physical
;; Duration: 
;; Other: Reduces the amount of magical damage done in room
;;
;vortex_magica
/def vortex = /vortex_magica %{*}

;;
;; Type: neutral
;; Duration: 
;; Other: Transforms caster into target (fish, bird)
;;
;transformation

;;
;; Type: teleport
;; Duration: 
;; Other: Teleports caster to sorcerers guild
;;
;transposition

;;
;; Type: defensive
;; Duration: 
;; Other: AC spell that can only be cast on yourself
;;
;viscous_flesh
/def vf = /viscous_flesh %{*}

;;
;; Type:
;; Preference: 
;; Duration: 
;;
;hour_of_mercy

;;
;; Type: heal
;; Duration: 1-2 rounds
;;
;symmetry_in_body

;;
;; Type: special
;; Duration: 
;; Other: This spell lets you bind equipment to the target
;;
;bond_of_fates

;;
;; Type: special
;; Duration: 
;; Other: Destroys bag of holding in target
;;
;cancellation

;;
;; Type: neutral
;; Duration: 
;; Other: Makes target object float in the air. Floating object will follow you.
;;
;levitate_object
/def lo = /levitate_object %{*}
