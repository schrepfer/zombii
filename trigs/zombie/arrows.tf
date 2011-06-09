;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ARROW MAKING TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/arrows.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/arrows.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def arrows_faint = 1
/def arrows_very_weak = 2
/def arrows_weak = 3
/def arrows_moderate = 4
/def arrows_strong = 5
/def arrows_very_strong = 6
/def arrows_bright = 7
/def arrows_very_bright = 8
/def arrows_brilliant = 9

;;;;
;;
;; Get a numeric value associated with the arrow description.
;;
;; @param description The arrow description.
;; @return A number associated with the description.
;;
/def get_arrow_level = \
  /if ({*} =~ 'faint') \
    /result ${arrows_faint}%; \
  /elseif ({*} =~ 'very weak') \
    /result ${arrows_very_weak}%; \
  /elseif ({*} =~ 'weak') \
    /result ${arrows_weak}%; \
  /elseif ({*} =~ 'moderate') \
    /result ${arrows_moderate}%; \
  /elseif ({*} =~ 'strong') \
    /result ${arrows_strong}%; \
  /elseif ({*} =~ 'very strong') \
    /result ${arrows_very_strong}%; \
  /elseif ({*} =~ 'bright') \
    /result ${arrows_bright}%; \
  /elseif ({*} =~ 'very bright') \
    /result ${arrows_very_bright}%; \
  /elseif ({*} =~ 'brilliant') \
    /result ${arrows_brilliant}%; \
  /endif%; \
  /result 0

/def -Fp5 -ag -mregexp -t'^Str: (\\d+), Con: (\\d+), Dex: (\\d+), Int: (\\d+), Wis: (\\d+), Cha: (\\d+), Size: (\\d+)$' arrow_stats = \
  /if ({P4} + {P5} >= 800) \
    /set arrows_goal=${arrows_brilliant}%; \
  /else \
    /set arrows_goal=${arrows_very_bright}%; \
  /endif

/def rmarrows = \
  /set arrow=0%; \
  /set arrow_removing=1%; \
  /arrow_next

/def -Fp5 -msimple -t'You see nothing special.' arrow_last = \
  /set arrow_removing=0

/set sphere=1

/def -Fp5 -mregexp -t'^It emits a ([a-z ]+) (blue|white|green|red) aura\\.$' arrow_aura = \
  /if (!arrow_removing) \
    /return%; \
  /endif%; \
  /if (get_arrow_level({P1}) >= arrows_goal) \
    !get arrow %{arrow} from sphere%; \
    !put arrow in quiver%; \
    /test --arrow%; \
  /endif%; \
  /arrow_next

/def arrow_next = \
  /test ++arrow%; \
  !look at arrow %{arrow} in sphere

;;;;
;;
;; The number of quivers that you are currently making. This setting is
;; automatically configured when you "count quiver". When one quiver is full it
;; will give the Nth quiver to yourself.
;;
/property -i quivers

/def -Fp5 -mregexp -t'^There (are|is) (\\d+) \'quiver\'s? in your inventory\\.$' quiver_count = \
  /set quivers=%{P2}

;;;;
;;
;; Are you currently making arrows? When enabled it automatically removes
;; brilliant arrows from the sphere and grabs "/asphere" when you are at 85%
;; sps.
;;
/property -b arrows

/def -Fp6 -mregexp -t'^hp: (-?\\d+)\\((\\d+)\\) sp: (-?\\d+)\\((\\d+)\\)$' arrow_sc = \
  /if (arrows & {P3} * 10.0 > {P4} * 8.5) \
    /runif -n'asphere' -t10 -- /grab /asphere%; \
  /endif

;;;;
;;
;; Push all of the arrows in the sphere and start casting 'enchant arrow'.
;;
/def asphere = \
  !put all in sphere%; \
  !cast 'enchant arrow' sphere

/def -Fp5 -msimple -t'The sphere returns to it\'s still form.' sphere_rested = \
  /if (arrows) \
    /rmarrows%; \
  /endif

/def -Fp5 -msimple -t'The quiver is full.' quiver_full = \
  /if (arrow_removing) \
    !give quiver %{quivers} to $[me()]%; \
    !put arrow in quiver%; \
  /endif

;;;;
;;
;; Remove all arrows from all %{quivers}.
;;
/def raq = /for i 1 %{quivers} !get all from quiver %%{i}

;;;;
;;
;; Attempt to put arrows in all %{quivers}.
;;
/def paq = /for i 1 %{quivers} !put all in quiver %%{i}

/def -ag -mregexp -t'The shaft of this arrow has been carefully carved out of ash tree,' gag_arrow_slim_0
/def -ag -mregexp -t'and the steel tip is well-sharpened and glints nastily as sunlight' gag_arrow_slim_1
/def -ag -mregexp -t'reflects off it. The feathers have been skillfully adjusted to' gag_arrow_slim_2
/def -ag -mregexp -t'make sure this arrow flies true and deadly.' gag_arrow_slim_3
/def -ag -mregexp -t'This is an arrow fit for the master marksman.' gag_arrow_slim_4

/def -ag -mregexp -t'Carved from the lithe branches of the oaks of Eliendien and flighted' gag_arrow_elven_0
/def -ag -mregexp -t'with the juvenile flight feathers of the great eagles, this arrow is' gag_arrow_elven_1
/def -ag -mregexp -t'a work of art indeed. It has been traced in silver elven script along' gag_arrow_elven_2
/def -ag -mregexp -t'its extremely thin shaft, and its center of balance is tested and true.' gag_arrow_elven_3
/def -ag -mregexp -t'The only arrow of choice for the elves of the land, for another creature\'s' gag_arrow_elven_4
/def -ag -mregexp -t'hand would surely clumsily snap its delicate form in two.' gag_arrow_elven_5


