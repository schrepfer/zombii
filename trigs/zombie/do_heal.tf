;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; DO HEAL
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-09-08 09:40:09 -0700 (Wed, 08 Sep 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/do_heal.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/do_heal.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def ccw = /cure_critical_wounds %{*}
/def clw = /cure_light_wounds %{*}
/def csw = /cure_serious_wounds %{*}
/def hh = /half_heal %{*}

/def cure_critical_wounds = /do_heal -a'cast' -s'cure critical wounds' -t'$(/escape ' %{*-%{healing}})'
/def cure_light_wounds = /do_heal -a'cast' -s'cure light wounds' -t'$(/escape ' %{*-%{healing}})'
/def cure_serious_wounds = /do_heal -a'cast' -s'cure serious wounds' -t'$(/escape ' %{*-%{healing}})'
/def first_aid = /do_heal -a'use' -s'first aid' -t'$(/escape ' %{*-%{healing}})'
/def heal = /do_heal -a'cast' -s'heal' -t'$(/escape ' %{*-%{healing}})'
/def heal_body = /do_heal -a'cast' -s'heal body' -t'$(/escape ' %{*-%{healing}})'
/def harmony_hand = /do_heal -a'cast' -s'harmony hand' -t'$(/escape ' %{*-%{healing}})'
/def half_heal = /do_heal -a'cast' -s'half heal' -t'$(/escape ' %{*-%{healing}})'
/def major_distant_heal = /do_heal -a'cast' -s'major distant heal' -t'$(/escape ' %{*-%{healing}})' -d
/def major_distant_transfer = /do_heal -a'cast' -s'major distant transfer' -t'$(/escape ' %{*-%{healing}})' -d
/def major_heal = /do_heal -a'cast' -s'major heal' -t'$(/escape ' %{*-%{healing}})'
/def major_party_heal = /do_heal -a'cast' -s'major party heal' -t'$(/escape ' %{*-%{healing}})'
/def true_distant_heal = /do_heal -a'cast' -s'true distant heal' -t'$(/escape ' %{*-%{healing}})' -d
/def true_distant_transfer = /do_heal -a'cast' -s'true distant transfer' -t'$(/escape ' %{*-%{healing}})' -d
/def true_transfer = /do_heal -a'cast' -s'true transfer' -t'$(/escape ' %{*-%{healing}})'
