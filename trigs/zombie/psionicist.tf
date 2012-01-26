;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; PSIONICIST TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-04-05 00:35:38 -0700 (Tue, 05 Apr 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/psionicist.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/psionicist.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

;;
;; ATTACKS/OTHER
;;

/def hac = /headache %{*}
/def pc = /psychic_crush %{*}
/def pbl = /psionic_blast %{*}
/def cry = /cryokinesis %{*}
/def mol = /molecular_agitation %{*}
/def bs = /brainstorm %{*}
/def cho = /choke %{*}
/def mi = /mental_illusions %{*}

;;
;; PROTS
;;

/def mg = /mental_glance %{*}
/def md = /mind_development %{*}
/def pz = /phaze_shift %{*}
/def phaze = /phaze_shift %{*}
/def fs = /force_shield %{*}
/def mb = /mind_barrier %{*}

;;
;; OTHER
;;

/def -Fp5 -mregexp -t'^Mental illusions now haunt (.*)\\.$' mental_illusions_up = \
  /announce_effect -s1 -p'Mental Illusions' -o'$(/escape ' %{P1})'

/def -Fp5 -msimple -t'You create a blood red telekinetic barrier.' mind_barrier_up = \
  /say -d'party' -c'green' -- Mind Barrier Up

/def -Fp5 -msimple -t'The barrier vanishes.' mind_barrier_down = \
  /say -d'party' -c'red' -- Mind Barrier Down

/def -Fp5 -P1B;2BCgreen -mregexp -t'You gain (\\d+ points) of (green) mental energy\\.' psionicist_green_points
/def -Fp5 -P1B;2BCred -mregexp -t'You gain (\\d+ points) of (red) mental energy\\.' psionicist_red_points
/def -Fp5 -P1B;2BCblue -mregexp -t'You gain (\\d+ points) of (blue) mental energy\\.' psionicist_blue_points
/def -Fp5 -P1B;2BCyellow -mregexp -t'You gain (\\d+ points) of (yellow) mental energy\\.' psionicist_yellow_points
