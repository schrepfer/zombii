/eval /require $[trigs_dir('zombie')]

/set death_knight=1


/def dksummon = !tell xinntagn summon
/def dkgate = !say gate to city
/def dkgsummon = !tell lloiyinn summon

;; TODO: Figure out if possible to use function form of substitute() to echo() leading spaces to dkinfo

;;; Rank
/def -Fp10 -mregexp -t'^           H([\s]*)a Carcass' dk_rank1 = /substitute -p -- _          %{*} [@{B}1/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Caitiff' dk_rank2 = /substitute -p -- _          %{*} [@{B}2/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Minion' dk_rank3 = /substitute -p -- _          %{*} [@{B}3/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Lurker' dk_rank4 = /substitute -p -- _          %{*} [@{B}4/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Disciple' dk_rank5 = /substitute -p -- _          %{*} [@{B}5/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Tomb Guard' dk_rank6 = /substitute -p -- _          %{*} [@{B}6/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Skirmisher' dk_rank7 = /substitute -p -- _          %{*} [@{B}7/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Necropolitan' dk_rank8 = /substitute -p -- _          %{*} [@{B}8/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Soldier' dk_rank9 = /substitute -p -- _          %{*} [@{B}9/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Malefactor' dk_rank10 = /substitute -p -- _          %{*} [@{B}10/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Marauder' dk_rank11 = /substitute -p -- _          %{*} [@{B}11/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Ravager' dk_rank12 = /substitute -p -- _          %{*} [@{B}12/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Slayer' dk_rank13 = /substitute -p -- _          %{*} [@{B}13/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Blackguard' dk_rank14 = /substitute -p -- _          %{*} [@{B}14/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)a Lurking terror' dk_rank15 = /substitute -p -- _          %{*} [@{B}15/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)The Tormentor' dk_rank16 = /substitute -p -- _          %{*} [@{B}16/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)the Reaver' dk_rank17 = /substitute -p -- _          %{*} [@{B}17/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)Nemesis' dk_rank18 = /substitute -p -- _          %{*} [@{B}18/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)The Deathbringer' dk_rank19 = /substitute -p -- _          %{*} [@{B}19/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)The Tomb Lord' dk_rank20 = /substitute -p -- _          %{*} [@{B}20/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)the Black Scourge' dk_rank21 = /substitute -p -- _          %{*} [@{B}21/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)the Deathless Master' dk_rank22 = /substitute -p -- _          %{*} [@{B}22/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)the Dark Lord' dk_rank23 = /substitute -p -- _          %{*} [@{B}23/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)The Death\'s Hand' dk_rank24 = /substitute -p -- _          %{*} [@{B}24/25@{n}]
/def -Fp10 -mregexp -t'^           H([\s]*)the Fell Archon' dk_rank25 = /substitute -p -- _          %{*} [@{B}25/25@{n}]

;;; Rank ministeps
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is indistinct.' dk_ministep0 = /substitute -p -- _          %{*} [@{B}0/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is extremely far away.' dk_ministep1 = /substitute -p -- _          %{*} [@{B}1/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is very distant.' dk_ministep2 = /substitute -p -- _          %{*} [@{B}2/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is distant.' dk_ministep3 = /substitute -p -- _          %{*} [@{B}3/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is quite distant.' dk_ministep4 = /substitute -p -- _          %{*} [@{B}4/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is approaching.' dk_ministep5 = /substitute -p -- _          %{*} [@{B}5/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is within sight.' dk_ministep6 = /substitute -p -- _          %{*} [@{B}6/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is quite near.' dk_ministep7 = /substitute -p -- _          %{*} [@{B}7/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is near.' dk_ministep8 = /substitute -p -- _          %{*} [@{B}8/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is very near.' dk_ministep9 = /substitute -p -- _          %{*} [@{B}9/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is nigh.' dk_ministep10 = /substitute -p -- _          %{*} [@{B}10/11@{n}]
/def -Fp10 -mregexp -t'^           M([\s]*)My advancement is inevitable.' dk_ministep11 = /substitute -p -- _          %{*} [@{B}11/11@{n}]
 
; Spectral Armour
/def_effect -p'spectral_armour' -n'Spectral Armour' -s'sa'
/def -Fp5 -mregexp -aCgreen -t'^You feel weightless as a strange sensation of non-corporeality descends upon you.$' spectral_on = /effect_on spectral_armour
/def -Fp5 -mregexp -aCred -t'^The eerie sensation of non-corporeality subsides.' spectral_off = /effect_off spectral_armour
 
; Eldritch Ward
/def_effect -p'eldritch_ward' -n'Eldritch Ward' -s'eldritch_ward'
/def -Fp5 -mregexp -aCgreen -t'^manifest around you. Quickly the aura spreads and gains focus until you are' eward_on = /effect_on eldritch_ward
/def -Fp5 -mregexp -aCred -t'^The ghostly aura of green fire enveloping you diminishes quickly to vanish.' eward_off = /effect_off eldritch_ward
 
; Profane Halo
/def_effect -p'profane_halo' -n'Profane Halo' -s'ph'
/def -Fp5 -mregexp -aCgreen -t'^A crackling nimbus of energy manifests around you, a billow' phalo_on = /effect_on profane_halo
/def -Fp5 -mregexp -aCred -t'^The nimbus of mist surrounding you dissipates suddenly' phalo_off = /effect_off profane_halo
 
; Desecrate Weapon
/def_effect -p'desecrate_weapon' -n'Desecrate Weapon' -s'dwep'
/def -Fp5 -mregexp -aCgreen -t'^With an eerie screech a flare of dark fire engulfs the weapon.$' desecrate_weapon_on = /effect_on desecrate_weapon
/def -Fp5 -mregexp -aCred -t'^The dark aura surrounding your' desecrate_weapon_off = /effect_off desecrate_weapon
 
; Vengeful Dead
/def_effect -p'the_vengeful_dead' -n'Vengeful Dead' -s'vdead'
/def -Fp5 -mregexp -aCgreen -t'^You can feel an otherworldly power seeping into you to.*' vengeful_dead_on = /effect_on the_vengeful_dead
/def -Fp5 -mregexp -aCred -t'^You can feel the otherworldly power departing your body.*' vengeful_dead_off = /effect_off the_vengeful_dead
 
; Reaping Stance
/def_effect -p'reaping_stance' -n'Reaping Stace' -s'rstance'
/def -Fp5 -mregexp -aCgreen -t'^You are prepared for the reaping.*' reaping_stance_on = /effect_on reaping_stance
/def -Fp5 -mregexp -aCred -t'^In this apathetic lull of idleness you relinquish the reaping.*' reaping_stance_off = /effect_off reaping_stance
