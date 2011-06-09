;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; PROT TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/effects.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/effects.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

;/def_effect -p'spell' -n'Spell'
;/def -Fp5 -msimple -aCgreen -t'' spell_on = /effect_on spell
;/def -Fp5 -msimple -aCred -t'' spell_off = /effect_off spell

/def_effect_group -g'stun' -n'Stun Protection'

/def_effect -g'stun' -p'stun_resistance' -n'Stun Resistance' -s'sr'
/def -Fp5 -mregexp -aCgreen -t'^([A-Z][a-z]+) wobbles around a bit\\.$' stun_resistance_on = /if (is_me({P1})) /effect_on stun_resistance%; /endif
/def -Fp5 -msimple -aCred -t'Your stun resistance wears off.' stun_resistance_off = /effect_off stun_resistance

/def_effect -p'flight' -n'Flight'
/def -Fp5 -msimple -aCgreen -t'You become lighter than the air, wow you feel like you could fly!' flight_on = /effect_on flight
/def -Fp5 -msimple -aCred -t'You feel a bit heavier.' flight_off = /effect_off flight

/def_effect -p'preparation_of_harmony' -n'Prep. of Harmony'
/def -Fp5 -msimple -aCgreen -t'You feel like you might be ready for harmony.' preparation_of_harmony_on = /effect_on preparation_of_harmony
/def -Fp5 -msimple -aCred -t'You feel less prepared for harmony.' preparation_of_harmony_off = /effect_off preparation_of_harmony

/def_effect -p'harmonious_barrier' -n'Harmonious Barrier' -s'hbar'
/def -Fp5 -msimple -aCgreen -t'You feel enveloped in harmony.' harmonious_barrier_on = /effect_on harmonious_barrier
/def -Fp5 -msimple -aCred -t'You are no longer enveloped in harmony.' harmonious_barrier_off = /effect_off harmonious_barrier

/def_effect -p'harmony_armour' -n'Harmony Armour' -s'ha'
/def -Fp5 -msimple -aCgreen -t'You feel in complete harmony.' harmony_armour_on = /effect_on harmony_armour
/def -Fp5 -msimple -aCred -t'You no longer feel harmonious.' harmony_armour_off = /effect_off harmony_armour

/def_effect -p'barrier_of_the_mind' -n'Barrier of the Mind'
/def -Fp5 -msimple -aCgreen -t'You feel as if a protective barrier surrounds your fragile mind.' barrier_of_the_mind_on = /effect_on barrier_of_the_mind
/def -Fp5 -msimple -aCred -t'You feel a slight tingle somewhere deep inside your mind.' barrier_of_the_mind_off = /effect_off barrier_of_the_mind

/def_effect -g'stun' -p'iron_will' -n'Iron Will' -s'iw'
/def -Fp5 -mregexp -aCgreen -t'^[A-Z][a-z]+ stares deep into your eyes, bolstering your concentration greatly\\.$|^You turn your mind inwards, enchanting yourself with an aura of rigid concentration\\. $' iron_will_on = /effect_on iron_will
/def -Fp5 -msimple -aCred -t'Your Iron Will wears off.' iron_will_off = /effect_off iron_will

/def_effect -p'force_shield' -n'Force Shield' -s'fs'
/def -Fp5 -mregexp -aCgreen -t'^[A-Z][a-z]+ surrounds you with a telekinetic shield of force\\.$' force_shield_on = /effect_on force_shield
/def -Fp5 -msimple -aCred -t'The force shield dissipates.' force_shield_off = /effect_off force_shield

/def_effect_group -g'unpain' -n'Unpain'

/def_effect -g'unpain' -p'minor_unpain' -n'Minor Unpain' -s'mup'
/def -Fp5 -msimple -aCgreen -t'You feel more sturdy.' minor_unpain_on = /effect_on minor_unpain
/def -Fp5 -msimple -aCred -t'You feel a little like crap.' minor_unpain_off = /effect_off minor_unpain

/def_effect -g'unpain' -p'true_unpain' -n'True Unpain' -s'tup'
/def -Fp5 -msimple -aCgreen -t'You feel like you could carry the world.' true_unpain_on = /effect_on true_unpain
/def -Fp5 -msimple -aCred -t'You feel like crap.' true_unpain_off = /effect_off true_unpain

/def_effect -p'brain_unpain' -n'Brain Unpain' -s'bup'
/def -Fp5 -msimple -aCgreen -t'Your brain feels bigger.' brain_unpain_on = /effect_on brain_unpain
/def -Fp5 -msimple -aCred -t'Your brain feels smaller.' brain_unpain_off = /effect_off brain_unpain

/def_effect_group -g'monk_pref' -n'Monk Preference'

/def_effect -g'monk_pref' -p'call_for_thunder' -n'Call for Thunder'
/def -Fp5 -msimple -aCgreen -t'Suddenly your body flashes bright white inviting the lightning to strike' call_for_thunder_on = /effect_on call_for_thunder
/def -Fp5 -msimple -aCred -t'Your body doesnt seem to sizzle anymore' call_for_thunder_off = /if (effect_count('call_for_thunder')) /effect_off call_for_thunder%; /endif

/def_effect -g'monk_pref' -p'call_for_fire' -n'Call for Fire'
/def -Fp5 -msimple -aCgreen -t'Suddenly bright flames burst out from your toes and flash over your' call_for_fire_on = /effect_on call_for_fire
/def -Fp5 -msimple -aCred -t'The flames around you grow weaker and disappear' call_for_fire_off = /if (effect_count('call_for_fire')) /effect_off call_for_fire%; /endif

/def_effect -g'monk_pref' -p'call_for_ice' -n'Call for Ice'
/def -Fp5 -msimple -aCgreen -t'Suddenly your eyes freeze into two clear blocks of ice for a moment before they' call_for_ice_on = /effect_on call_for_ice
/def -Fp5 -msimple -aCred -t'You feel your body temperature rise back as ice melts' call_for_ice_off = /if (effect_count('call_for_ice')) /effect_off call_for_ice%; /endif

/def_effect -p'adrenaline_rush' -n'Adrenaline Rush'
/def -Fp5 -msimple -aCgreen -t'You are bursting with energy!!!' adrenaline_rush_on = /effect_on adrenaline_rush
/def -Fp5 -msimple -aCred -t'Exhaustion washes over you as the adrenaline begins to leave your bloodstream..' adrenaline_rush_off = /effect_off adrenaline_rush

/def_effect -p'berserk' -n'Berserk'
/def -Fp5 -msimple -aCgreen -t'You bellow in rage and you must kill!' berserk_on = /effect_on berserk
/def -Fp5 -msimple -aCred -t'You come out of your berserk!' berserk_off = /effect_off berserk

/def_effect -p'energy_hauberk' -n'Energy Hauberk' -s'eh'
/def -Fp5 -mregexp -aCgreen -t'^With a flash a shining hauberk of pure energy encases you\\.$|^hauberk around yourself\\.$' energy_hauberk_on = /effect_on energy_hauberk
/def -Fp5 -msimple -aCred -t'The energy surrounding your body dwindles away.' energy_hauberk_off = /effect_off energy_hauberk

/def_effect -p'inner_power' -n'Inner Power' -s'ip'
/def -Fp5 -msimple -aCgreen -t'You feel inner strength increasing.' inner_power_on = /effect_on inner_power
/def -Fp5 -msimple -aCred -t'You feel your inner power decreasing.' inner_power_off = /effect_off inner_power

/def_effect -p'blurred_image' -n'Blurred Image'
/def -Fp5 -msimple -aCgreen -t'You enchant the air around you, blurring your outlines.' blurred_image_on = /effect_on blurred_image
/def -Fp5 -mregexp -aCgreen -t'^[A-Z][a-z]+ enchants the air around you, blurring your figure\\.$' blurred_image_on_other = /blurred_image_on
/def -Fp5 -msimple -aCred -t'Your blur wears off.' blurred_image_off = /effect_off blurred_image

/def_effect -p'regeneration' -n'Regeneration'
/def -Fp5 -msimple -aCgreen -t'You feel your metabolism speed up.' regeneration_on = /effect_on regeneration
/def -Fp5 -msimple -aCred -t'Your metabolism slows back down.' regeneration_off = /effect_off regeneration

/def_effect -p'light' -n'Light'
/def -Fp5 -msimple -aCgreen -t'You summon a magical ball of light.' light_on = /effect_on light
/def -Fp5 -msimple -aCred -t'The light spell wears off.' light_off = /effect_off light

/def_effect -p'infravision' -n'Infravision' -s'infra'
/def -Fp5 -msimple -aCgreen -t'You feel like you can see in the dark.' infravision_on = /effect_on infravision
/def -Fp5 -msimple -aCred -t'Your vision is a bit less red.' infravision_off = /effect_off infravision

/def_effect -p'healing_smoke' -n'Healing Smoke'
/def -Fp5 -msimple -aCgreen -t'You breathe out a billowy cloud of harmonious smoke.' healing_smoke_on = /effect_on healing_smoke
/def -Fp5 -msimple -aCred -t'Your healing smoke disperses.' healing_smoke_off = /effect_off healing_smoke

/def_effect -p'heavy_weight' -n'Heavy Weight'
/def -Fp5 -msimple -aCgreen -t'You feel magically heavier.' heavy_weight_on = /effect_on heavy_weight
/def -Fp5 -msimple -aCred -t'You feel lighter.' heavy_weight_off = \
  /if ($(/recall -q /1) !~ strcat('You give ', toupper(me(), 1), ' an ability to avoid water.')) \
    /def -Fp6 -n1 -mregexp -t'' heavy_weight_off_fix = \
      /if ({*} !~ 'You feel lighter, but it doesn\\'t affect your weight?' & !(is_me({1}) & {-1} =~ 'looks a bit different.')) \
        /effect_off heavy_weight%%; \
      /endif%; \
  /endif

/def_effect -p'blind' -n'Blind'
/def -Fp5 -mregexp -aCgreen -t'^[A-Za-z,-:\' ]+ blinds you\\.$' blind_on = /effect_on blind
/def -Fp5 -msimple -aCred -t'You are able to see again.' blind_off = /effect_off blind

/def_effect -p'wall_of_steel' -n'Wall of Steel'
/def -Fp5 -msimple -aCgreen -t'You lift up your shield.' wall_of_steel_on = /effect_on wall_of_steel
/def -Fp5 -msimple -aCred -t'Your hand starts to ache, forcing you to lower your shield.' wall_of_steel_off = /effect_off wall_of_steel
/def -Fp5 -msimple -aCred -t'Your offensive maneuver proves out more demanding than you thought' wall_of_steel_off_lancer = /wall_of_steel_off

/def_effect_group -g'blade_enchant' -n'Blade Enchant'

/def_effect -g'blade_enchant' -p'ghorux_blade' -n'Ghorux Blade'
/def -Fp5 -msimple -aCgreen -t'You cast a ghorux blade spell at your sword.' ghorux_blade_on = /effect_on ghorux_blade
/def -Fp5 -msimple -aCred -t'Ghorux blade looses it\'s magical power.' ghorux_blade_off = /effect_off ghorux_blade

/def_effect -g'blade_enchant' -p'jigoku_blade' -n'Jigoku Blade'
/def -Fp5 -msimple -aCgreen -t'the spiritual forces of evil.' jigoku_blade_on = /effect_on jigoku_blade
/def -Fp5 -msimple -aCred -t'The dark spiritual forces of the Jigoku Blade twindle away.' jigoku_blade_off = /effect_off jigoku_blade

/def_effect -g'blade_enchant' -p'tenrai_blade' -n'Tenrai Blade'
/def -Fp5 -msimple -aCgreen -t'the spiritual forces of good.' tenrai_blade_on = /effect_on tenrai_blade
/def -Fp5 -msimple -aCred -t'The benign spiritual forces of the Tenrai Blade twindle away.' tenrai_blade_off = /effect_off tenrai_blade

/def_effect_group -g'blade_element' -n'Blade Element'

/def_effect -g'blade_element' -p'fire_blade' -n'Fire Blade'
/def -Fp5 -msimple -aCgreen -t'Your sword begins to glow with the faintest glow of elemental fire.' fire_blade_on = /effect_on fire_blade
/def -Fp5 -msimple -aCred -t'Your fireblade spell wears off.' fire_blade_off = /effect_off fire_blade

/def_effect -g'blade_element' -p'acid_blade' -n'Acid Blade'
/def -Fp5 -msimple -aCgreen -t'Your sword begins to glow with the faintest yellow light.' acid_blade_on = /effect_on acid_blade
/def -Fp5 -msimple -aCred -t'Your acidblade spell wears off.' acid_blade_off = /effect_off acid_blade

/def_effect -g'blade_element' -p'poison_blade' -n'Poison Blade'
/def -Fp5 -msimple -aCgreen -t'Your sword begins to glow with the dark green hue of poison.' poison_blade_on = /effect_on poison_blade
/def -Fp5 -msimple -aCred -t'Your poisonblade spell wears off.' poison_blade_off = /effect_off poison_blade

/def -Fp5 -msimple -t'Your spirit touches the blade, cleansing it of elemental powers.' neutralize_blade_on = \
  /if (effect_count('fire_blade')) \
    /effect_off fire_blade%; \
  /endif%; \
  /if (effect_count('acid_blade')) \
    /effect_off acid_blade%; \
  /endif%; \
  /if (effect_count('poison_blade')) \
    /effect_off poison_blade%; \
  /endif

/def_effect -p'slow_person' -n'Slow Person'
/def -Fp5 -msimple -aCgreen -t'You feel like lagged.' slow_person_on = /effect_on slow_person
/def -Fp5 -msimple -aCred -t'You no longer feel lagged.' slow_person_off = /effect_off slow_person

/def_effect -p'glue' -n'Glue'
/def -Fp5 -msimple -aCgreen -t'Your feet are covered with slimy matter.' glue_on = /effect_on glue
/def -Fp5 -msimple -aCred -t'You can move again.' glue_off = /effect_off glue

/def_effect -p'see_magic' -n'See Magic'
/def -Fp5 -msimple -aCgreen -t'Your vision seems more sensitive.' see_magic_on = /effect_on see_magic
/def -Fp5 -msimple -aCred -t'Your vision feels less sensitive.' see_magic_off = /if (effect_count('see_magic')) /effect_off see_magic%; /endif

/def_effect -p'shadow_shield' -n'Shadow Shield'
/def -Fp5 -mregexp -aCgreen -t'^[A-Z][a-z]+ draws a protective circle in the air and shadows cover your body\\.$' shadow_shield_on = /effect_on shadow_shield
/def -Fp5 -msimple -aCgreen -t'You draw a protective circle in the air around yourself and shadows' shadow_shield_on_self = /shadow_shield_on
/def -Fp5 -msimple -aCred -t'The shadows lift from your body.' shadow_shield_off = /effect_off shadow_shield

/def_effect -p'summon_orb_of_reflection' -n'Orb of Reflection'
/def -Fp5 -msimple -aCgreen -t'An orb of reflection appears in the room.' summon_orb_of_reflection_on = /effect_on summon_orb_of_reflection
/def -Fp5 -msimple -aCred -t'You banish the orb back to chaos-continuum.' summon_orb_of_reflection_off = /effect_off summon_orb_of_reflection

/def_effect -p'smwalk' -n'Magical Walking'
/def -Fp5 -msimple -aCgreen -t'You start walking magically.' smwalk_on = /effect_on smwalk
/def -Fp5 -msimple -aCred -t'Your magical walking wears off.' smwalk_off = /effect_off smwalk

/def_effect -p'sspirit' -n'Inner Spirit'
/def -Fp5 -aCgreen -msimple -t'You open your eyes with new found confidence.' sspirit_on = /effect_on sspirit
/def -Fp5 -aCred -msimple -t'The teachings of your ancestors fade from your mind as the aches and' sspirit_off = /effect_off sspirit

/def_effect -p'kamikaze' -n'Kamikaze'
/def -Fp5 -msimple -aCgreen -t'You start your Kamikaze attack!' kamikaze_on = /effect_on kamikaze
/def -Fp5 -msimple -aCred -t'You calm down.' kamikaze_off = /effect_off kamikaze

/def_effect -p'forget' -n'Forget'
/def -Fp5 -msimple -aCgreen -t'You feel stoopid.' forget_on = /effect_on forget
/def -Fp5 -msimple -aCgreen -t'Lich assaults your mind, you feel excruciating pain.' forget_on_lich = /forget_on
/def -Fp5 -msimple -aCred -t'For some reason or another.. you feel smarter.' forget_off = /effect_off forget

/def_effect -p'poison' -n'Poison'
/def -Fp5 -msimple -aCgreen -t'You shiver and suffer as the POISON takes effect!' poison_on = /if (!effect_count('poison')) /effect_on poison%; /endif
/def -Fp5 -mregexp -aCred -t'^[A-Z][a-z]+ neutralizes the poison in your veins\\.$' poison_off = /effect_off poison

/def_effect -p'water_breathing' -n'Water Breathing' -s'wb'
/def -Fp5 -mregexp -aCgreen -t'^[A-Z][a-z]+ puts a protective blue aura around your head\\.$' water_breathing_on = /effect_on water_breathing
/def -Fp5 -mregexp -aCgreen -t'You put a protective blue aura around your head\\.$' water_breathing_on_self = /water_breathing_on
/def -Fp5 -msimple -aCred -t'You are no longer able to breathe underwater.' water_breathing_off = /effect_off water_breathing

/def_effect -p'water_walking' -n'Water Walking' -s'ww'
/def -Fp5 -mregexp -aCgreen -t'^([A-Z][a-z]+) looks a bit different\\.$' water_walking_on = /if (is_me({P1})) /effect_on water_walking%; /endif
/def -Fp5 -mregexp -aCgreen -t'^You give ([A-Z][a-z]+) an ability to avoid water\\.$' water_walking_on_self = /if (is_me({P1})) /water_walking_on%; /endif
/def -Fp5 -msimple -aCred -t'You feel heavy.' water_walking_off = /effect_off water_walking

/def_effect -p'spirit_of_nature' -n'Spirit of Nature'
/def -Fp5 -mglob -aCgreen -t'You feel {strong|nimble|tough} as {a|an} {bear|eagle|drake} as the spirit of the {forest|mountain|desert} strenghtens you!' spirit_of_nature_on = /effect_on spirit_of_nature
/def -Fp5 -msimple -aCred -t'You suddenly feel cold as the presence leaves your body.' spirit_of_nature_off = /effect_off spirit_of_nature

/def_effect -p'eyes_of_the_marksman' -n'Eyes of the Marksman'
/def -Fp5 -msimple -aCgreen -t'Your eyes flash in silky colours.' eyes_of_the_marksman_on = /effect_on eyes_of_the_marksman
/def -Fp5 -msimple -aCred -t'You feel a pinch in your eyes.' eyes_of_the_marksman_off = /effect_off eyes_of_the_marksman

/def_effect -p'invisibility' -n'Invisibility'
/def -Fp5 -mregexp -aCgreen -t'^You turn invisible[.!]$' invisibility_on = /effect_on invisibility
/def -Fp5 -msimple -aCgreen -t'Your true mastery allows you to turn invisible!' smwalk_invisibility_on = /effect_on invisibility
/def -Fp5 -msimple -aCred -t'You turn visible again.' invisibility_off = /effect_off invisibility

/def_effect -p'transformation' -n'Transformation'
/def -Fp5 -msimple -aCgreen -t'You shriek in pain as your entire body begins to transform!' transformation_on = /effect_on transformation
/def -Fp5 -msimple -aCred -t'With a violent convulsion, you return to your normal form.' transformation_off = /effect_off transformation

;The Elixir of Wisdom drains from your system.

/def_effect -p'elixir_of_charisma' -n'Elixir of Charisma'
/def -Fp5 -msimple -aCred -t'The Elixir of Charisma drains from your system.' elixir_of_charisma_off = /effect_off elixir_of_charisma

/def_effect -p'elixir_of_constitution' -n'Elixir of Constitution'
/def -Fp5 -msimple -aCred -t'The Elixir of Constitution drains from your system.' elixir_of_constitution_off = /effect_off elixir_of_constitution

/def_effect -p'elixir_of_dexterity' -n'Elixir of Dexterity'
/def -Fp5 -msimple -aCred -t'The Elixir of Dexterity drains from your system.' elixir_of_dexterity_off = /effect_off elixir_of_dexterity

/def_effect -p'elixir_of_intelligence' -n'Elixir of Intelligence'
/def -Fp5 -msimple -aCred -t'The Elixir of Intelligence drains from your system.' elixir_of_intelligence_off = /effect_off elixir_of_intelligence

/def_effect -p'elixir_of_restoration' -n'Elixir of Restoration'
/def -Fp5 -msimple -aCred -t'The Elixir of Restoration drains from your system.' elixir_of_restoration_off = /effect_off elixir_of_restoration

/def_effect -p'elixir_of_stamina' -n'Elixir of Stamina'
/def -Fp5 -msimple -aCred -t'The Elixir of Stamina drains from your system.' elixir_of_stamina_off = /effect_off elixir_of_stamina

/def_effect -p'elixir_of_strength' -n'Elixir of Strength'
/def -Fp5 -msimple -aCred -t'The Elixir of Strength drains from your system.' elixir_of_strength_off = /effect_off elixir_of_strength

/def_effect -p'elixir_of_wisdom' -n'Elixir of Wisdom'
/def -Fp5 -msimple -aCred -t'The Elixir of Wisdom drains from your system.' elixir_of_wisdom_off = /effect_off elixir_of_wisdom

;^You drink the noxious liquid down in a single swallow\.  It\'s$
;^You slather the sweet smelling Salve over your skin\.  It\'s\.\.\.VERY sticky\.$

/def_effect -p'salve_of_physical_resistance' -n'Salve of Physical Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Physical Resistance dries up and flakes off.' salve_of_physical_resistance_off = /effect_off salve_of_physical_resistance

/def_effect -p'salve_of_magic_resistance' -n'Salve of Magic Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Magical Resistance dries up and flakes off.' salve_of_magic_resistance_off = /effect_off salve_of_magic_resistance

/def_effect -p'salve_of_fire_resistance' -n'Salve of Fire Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Fire Resistance dries up and flakes off.' salve_of_fire_resistance_off = /effect_off salve_of_fire_resistance

/def_effect -p'salve_of_cold_resistance' -n'Salve of Cold Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Cold Resistance dries up and flakes off.' salve_of_cold_resistance_off = /effect_off salve_of_cold_resistance

/def_effect -p'salve_of_acid_resistance' -n'Salve of Acid Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Acid Resistance dries up and flakes off.' salve_of_acid_resistance_off = /effect_off salve_of_acid_resistance

/def_effect -p'salve_of_psionic_resistance' -n'Salve of Psionic Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Psionic Resistance dries up and flakes off.' salve_of_psionic_resistance_off = /effect_off salve_of_psionic_resistance

/def_effect -p'salve_of_asphyxiation_resistance' -n'Salve of Asphyxiation Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Asphyxiation Resistance dries up and flakes off.' salve_of_asphyxiation_resistance_off = /effect_off salve_of_asphyxiation_resistance

/def_effect -p'salve_of_electrical_resistance' -n'Salve of Electrical Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Electrical Resistance dries up and flakes off.' salve_of_electrical_resistance_off = /effect_off salve_of_electrical_resistance

/def_effect -p'salve_of_poison_resistance' -n'Salve of Poison Resistance'
/def -Fp5 -msimple -aCred -t'The Salve of Poison Resistance dries up and flakes off.' salve_of_poison_resistance_off = /effect_off salve_of_poison_resistance

/def_effect -p'darkness' -n'Darkness'
/def_effect -p'light' -n'Light'
/def_effect -p'sharp_nails' -n'Sharp Nails'

/def_effect -p'resist_heal' -n'Resist Heal'
/def -Fp5 -msimple -aCgreen -t'You feel weird.' resist_heal_on = /effect_on resist_heal
/def -Fp5 -msimple -aCred -t'You feel normal again.' resist_heal_off = /effect_off resist_heal

/def_effect -p'mind_development' -n'Mind Development'
/def -Fp5 -msimple -aCgreen -t'You feel smart.' mind_development_on = /effect_on mind_development
/def -Fp5 -msimple -aCred -t'You feel stupid.' mind_development_off = /effect_off mind_development

/def_effect -p'enlightenment' -n'Enlightenment'
/def -Fp5 -msimple -aCgreen -t'You feel wiser.' enlightenment_on = /effect_on enlightenment
/def -Fp5 -msimple -aCred -t'You feel less wise.' enlightenment_off = /effect_off enlightenment

/def_effect -p'holy_wisdom' -n'Holy Wisdom'
/def -Fp5 -msimple -aCgreen -t'You feel wiser as holy wisdom expands your mind.' holy_wisdom_on = /effect_on holy_wisdom
/def -Fp5 -msimple -aCred -t'You feel the wisdom leaving you.' holy_wisdom_off = /effect_off holy_wisdom

/def_effect -p'viscous_flesh' -n'Viscious Flesh'
/def -Fp5 -msimple -aCgreen -t'You concentrate on your body, and its composition is revealed to your' viscous_flesh_on = /effect_on viscous_flesh
/def -Fp5 -msimple -aCred -t'The viscous black substance is absorbed by your skin, and so it disappears.' viscous_flesh_off = /effect_off viscous_flesh

/def_effect -p'mind_linked' -n'Mind Linked'
/def -Fp5 -msimple -aCgreen -t'You think that you\'re not alone in your head.' mind_linked_on = /effect_on mind_linked
/def -Fp5 -msimple -aCred -t'You feel alone in your head again.' mind_linked_off = /effect_off mind_linked

/def_effect -p'lions_heart' -n'Lion\'s Heart'
/def -Fp5 -msimple -aCgreen -t'Your heart is that of a Lion!' lions_heart_on = /effect_on lions_heart
/def -Fp5 -msimple -aCred -t'The Courage of the Lion leaves you.' lions_heart_off = /effect_off lions_heart

/def_effect_group -g'greater_shield' -n'Greater Shield'

/def_effect -g'greater_shield' -p'greater_elemental_shield' -n'Greater Elem Shield' -s'phys'
/def -Fp5 -mregexp -aCgreen -t'^An elemental shelter protecting ([A-Z][a-z]+) materializes\\.$' greater_elemental_shield_on = /if (is_me({P1})) /effect_on greater_elemental_shield%; /endif
/def -Fp5 -mregexp -aCred -t'^([A-Z][a-z]+) flashes brightly as energy escapes it\\.$' greater_elemental_shield_off = /if (is_me({P1})) /effect_off greater_elemental_shield%; /endif

/def_effect -g'greater_shield' -p'greater_magical_shield' -n'Greater Mag Shield' -s'mag'

/def_effect_group -g'lesser_shield' -n'Lesser Shield'

/def_effect -g'lesser_shield' -p'lesser_elemental_shield' -n'Lesser Elem Shield' -s'phys'

/def_effect -g'lesser_shield' -p'lesser_magical_shield' -n'Lesser Mag Shield' -s'mag'
/def -Fp5 -mregexp -aCgreen -t'^A magical shield protecting ([A-Z][a-z]+) materializes\\.$' lesser_magical_shield_on = /if (is_me({P1})) /effect_on lesser_magical_shield%; /endif
/def -Fp5 -mregexp -aCred -t'^([A-Z][a-z]+) twinkles softly as energy escapes it\\.$' lesser_magical_shield_off = /if (is_me({P1})) /effect_off lesser_magical_shield%; /endif

/def_effect_group -g'greater' -n'Greater'

/def_effect -g'greater' -p'infernal_vestment' -n'Infernal Vestment' -s'cold'
/def -Fp5 -msimple -aCgreen -t'burning with transcendental ardor.' infernal_vestment_on = /effect_on infernal_vestment
/def -Fp5 -msimple -aCred -t'A great chill washes over you as the magical warmth leaves you.' infernal_vestmentoff = /effect_off infernal_vestment

/def_effect -g'greater' -p'ward_of_steel' -n'Ward of Steel' -s'phys'
/def -Fp5 -msimple -aCgreen -t'you starts to waver vigorously.' ward_of_steel_on = /effect_on ward_of_steel
/def -Fp5 -msimple -aCgreen -t'The air around you starts to waver vigorously.' ward_of_steel_on_self = /ward_of_steel_on
/def -Fp5 -msimple -aCred -t'The air around you is calm once more as the wavering stops.' ward_of_steel_off = /effect_off ward_of_steel

/def_effect -g'greater' -p'venom_fend' -n'Venom Fend' -s'pois'
/def -Fp5 -msimple -aCgreen -t'an otherworldly fervor rushing through your veins.' venom_fend_on = /effect_on venom_fend
/def -Fp5 -msimple -aCgreen -t'Envisaging the arteries, you inject yourself with an arcane' venom_fend_on_self = /effect_on venom_fend
/def -Fp5 -msimple -aCred -t'The blazing fervor in your veins is gone.' venom_fend_off = /effect_off venom_fend

/def_effect -g'greater' -p'winters_rebuke' -n'Winter\'s Rebuke' -s'fire'
/def -Fp5 -msimple -aCgreen -t'feel the hand of winter gripping you gently.' winters_rebuke_on = /effect_on winters_rebuke
/def -Fp5 -msimple -aCred -t'The freezing grip of winter disappears and you feel comfortably warm again.' winters_rebuke_off = /effect_off winters_rebuke

/def_effect -g'greater' -p'corrosive_opposition' -n'Corrosive Opposition' -s'acid'
/def -Fp5 -msimple -aCgreen -t'substance that irritates your skin.' corrosive_opposition_on = /effect_on corrosive_opposition
/def -Fp5 -msimple -aCgreen -t'You clench your fist and manipulate the air around you' corrosive_opposition_on_self = /corrosive_opposition_on
/def -Fp5 -msimple -aCred -t'The irritating viscid substance on your skin disappears.' corrosive_opposition_off = /effect_off corrosive_opposition

/def_effect -g'greater' -p'psychic_aegis' -n'Psychic Aegis' -s'psi'
/def -Fp5 -msimple -aCgreen -t'form around your soul.' psychic_aegis_on = /effect_on psychic_aegis
/def -Fp5 -msimple -aCgreen -t'You place your hand on your forehead and a soothing barrier forms' psychic_aegis_on_self = /psychic_aegis_on
/def -Fp5 -msimple -aCred -t'The soothing void around your soul is no more.' psychic_aegis_off = /effect_off psychic_aegis

/def_effect -g'greater' -p'arcane_bulwark' -n'Arcane Bulwark' -s'mag'
/def -Fp5 -msimple -aCgreen -t'around you, cascading down in waves and back up again,' arcane_bulwark_on = /effect_on arcane_bulwark
/def -Fp5 -msimple -aCred -t'The swirling shell of effulgent magic around you vanishes.' arcane_bulwark_off = /effect_off arcane_bulwark

/def_effect -g'greater' -p'lightning_guard' -n'Lightning Guard' -s'elec'
/def -Fp5 -msimple -aCgreen -t'making you spasm as it settles into your body.' lightning_guard_on = /effect_on lightning_guard
/def -Fp5 -msimple -aCgreen -t'With a strong pulling motion of your outstreched hands an' lightning_guard_on_self = /lightning_guard_on
/def -Fp5 -msimple -aCred -t'The world flashes around you and with a quick spasm the magic in your body disappears.' lightning_guard_off = /effect_off lightning_guard

/def_effect -g'greater' -p'resist_void' -n'Resist Void' -s'asp'
/def -Fp5 -msimple -aCgreen -t'the magic is absorbed into your body.' resist_void_on = /effect_on resist_void
/def -Fp5 -msimple -aCgreen -t'You inhale hard and a gust of wind blows against your face, ' resist_void_on_self = /resist_void_on
/def -Fp5 -msimple -aCred -t'You gasp for air as a choking feeling passes over you.' resist_void_off = /effect_off resist_void

/def_effect_group -g'lesser' -n'Lesser'

/def_effect -g'lesser' -p'vestment_of_flame' -n'Vestment of Flame' -s'cold'
/def -Fp5 -msimple -aCgreen -t'slowly revolving around you. The magic settles finally on your' vestment_of_flame_on = /effect_on vestment_of_flame
/def -Fp5 -msimple -aCred -t'You feel cold and exposed as the magical warmth leaves you.' vestment_of_flame_off = /effect_off vestment_of_flame

/def_effect -g'lesser' -p'ward_of_stone' -n'Ward of Stone' -s'phys'
/def -Fp5 -mregexp -aCgreen -t'^[A-Z][a-z]+ eyes you attentively and the air around you starts to ripple\\.$' ward_of_stone_on = /effect_on ward_of_stone
/def -Fp5 -msimple -aCgreen -t'You concentrate your thoughts and channel a great amount of' ward_of_stone_on_self = /ward_of_stone_on
/def -Fp5 -msimple -aCred -t'The air around you is calm once more as the rippling stops.' ward_of_stone_off = /effect_off ward_of_stone

/def_effect -g'lesser' -p'poison_fend' -n'Poison Fend' -s'pois'
/def -Fp5 -msimple -aCgreen -t'feel an unnatural warmth coursing through your veins.' poison_fend_on = /effect_on poison_fend
/def -Fp5 -msimple -aCgreen -t'Envisaging the arteries, you inject yourself with a mystic' poison_fend_on_self = /poison_fend_on
/def -Fp5 -msimple -aCred -t'The warmth in your veins is gone.' poison_fend_off = /effect_off poison_fend

/def_effect -g'lesser' -p'rebuke_of_ice' -n'Rebuke of Ice' -s'fire'
/def -Fp5 -msimple -aCgreen -t'you feel a chill climbing up your spine.' rebuke_of_ice_on = /effect_on rebuke_of_ice
/def -Fp5 -msimple -aCgreen -t'You trace a circle in the air and a shining circumference of blue' rebuke_of_ice_on_self = /rebuke_of_ice_on
/def -Fp5 -msimple -aCred -t'The chill in your bones is gone and you feel comfortably warm again.' rebuke_of_ice_off = /effect_off rebuke_of_ice

/def_effect -g'lesser' -p'caustic_opposition' -n'Caustic Opposition' -s'acid'
/def -Fp5 -msimple -aCgreen -t'adhesive fluid that tickles your skin.' caustic_opposition_on = /effect_on caustic_opposition
/def -Fp5 -msimple -aCgreen -t'You close your fist and manipulate the air around you' caustic_opposition_on_self = /caustic_opposition_on
/def -Fp5 -msimple -aCred -t'The tickling adhesive fluid on your skin disappears.' caustic_opposition_off = /effect_off caustic_opposition

/def_effect -g'lesser' -p'mental_aegis' -n'Mental Aegis' -s'psi'
/def -Fp5 -msimple -aCgreen -t'emptiness settle in your mind.' mental_aegis_on = /effect_on mental_aegis
/def -Fp5 -msimple -aCgreen -t'You tap yourself lightly on the forehead and a relaxing shelter' mental_aegis_on_self = /mental_aegis_on
/def -Fp5 -msimple -aCred -t'The relaxing emptiness in your mind is no more.' mental_aegis_off = /effect_off mental_aegis

/def_effect -g'lesser' -p'mystic_bulwark' -n'Mystic Bulwark' -s'mag'
/def -Fp5 -msimple -aCgreen -t'you, spiralling up and down, like a whirlwind of stardust.' mystic_bulwark_on = /effect_on mystic_bulwark
/def -Fp5 -msimple -aCgreen -t'You point your index finger forward, and a sizzling stream' mystic_bulwark_on_self = /mystic_bulwark_on
/def -Fp5 -msimple -aCred -t'The whirlwind of protective magic around you vanishes.' mystic_bulwark_off = /effect_off mystic_bulwark

/def_effect -g'lesser' -p'spark_shelter' -n'Spark Shelter' -s'elec'
/def -Fp5 -msimple -aCgreen -t'energy leaps at you. The magic penetrates your chest, and' spark_shelter_on = /effect_on spark_shelter
/def -Fp5 -msimple -aCgreen -t'With a withdrawing motion of your outstreched hands a' spark_shelter_on_self = /spark_shelter_on
/def -Fp5 -msimple -aCred -t'Your surroundings flash and with a shiver the magic in your body disappears.' spark_shelter_off = /effect_off spark_shelter

/def_effect -g'lesser' -p'endure_void' -n'Endure Void' -s'asp'
/def -Fp5 -msimple -aCgreen -t'magic is absorbed into your body.' endure_void_on = /effect_on endure_void
/def -Fp5 -msimple -aCgreen -t'You breathe in and a light breeze brushes against your' endure_void_on_self = /endure_void_on
/def -Fp5 -msimple -aCred -t'You have trouble breathing for a moment.' endure_void_off = /effect_off endure_void

/def_effect -g'lesser greater' -p'armour_of_god' -n'Armour of God' -s'aog'
/def -Fp5 -mregexp -aCgreen -t'^A shining robe of glowing silver surrounds you\\.$|^Shining vestments of glowing silver surround you\\.$|^A shining suit of glowing silver mail surrounds you\\.$' armour_of_god_on = /effect_on armour_of_god
/def -Fp5 -msimple -aCred -t'The Armour of God surrounding you fades away.' armour_of_god_off = /effect_off armour_of_god

/def_effect -g'lesser greater' -p'protection_from_good' -n'Protection from Good'
/def -Fp5 -msimple -aCgreen -t'A sizzling red aura surrounds you.' protection_from_good_on = /effect_on protection_from_good
/def -Fp5 -msimple -aCred -t'The red aura surrounding you vanishes.' protection_from_good_off = /effect_off protection_from_good

/def_effect -p'fragile_frame' -n'Fragile Frame'
/def -Fp5 -msimple -aCgreen -t'weakened by a spell. ' fragile_frame_on = /effect_on fragile_frame
/def -Fp5 -msimple -aCred -t'You feel robust again as the spell ends.' fragile_frame_off = /effect_off fragile_frame

/def_effect -p'mystic_impairment' -n'Mystic Impairment'
/def -Fp5 -msimple -aCgreen -t'creating a magenta aura around you. ' mystic_impairment_on = /effect_on mystic_impairment
/def -Fp5 -msimple -aCred -t'The aura surrounding you snaps out of existence.' mystic_impairment_off = /effect_off mystic_impairment

/def_effect -p'incendiary_coating' -n'Incendiary Coating'
/def -Fp5 -msimple -aCgreen -t'incendiary coating on you. ' incendiary_coating_on = /effect_on incendiary_coating
/def -Fp5 -msimple -aCred -t'The incendiary substance on you evaporates.' incendiary_coating_off = /effect_off incendiary_coating

/def_effect -p'deprive_warmth' -n'Deprive Warmth'
/def -Fp5 -msimple -aCgreen -t'as you feel like you are naked in a blizzard storm. ' deprive_warmth_on = /effect_on deprive_warmth
/def -Fp5 -msimple -aCred -t'Your bodily temperature seems to be normal again.' deprive_warmth_off = /effect_off deprive_warmth

/def_effect -p'vitriolic_bane' -n'Vitriolic Bane'
/def -Fp5 -msimple -aCgreen -t'a strange tawny hue. ' vitriolic_bane_on = /effect_on vitriolic_bane
/def -Fp5 -msimple -aCred -t'Your skin feels thick and healthy again as the bane disappears.' vitriolic_bane_off = /effect_off vitriolic_bane

/def_effect -p'languished_soul' -n'Languished Soul'
/def -Fp5 -msimple -aCgreen -t'light lances at you. ' languished_soul_on = /effect_on languished_soul
/def -Fp5 -msimple -aCred -t'You snap out of your languid mood.' languished_soul_off = /effect_off languished_soul

/def_effect -p'labored_breathing' -n'Labored Breathing'
/def -Fp5 -msimple -aCgreen -t'feels arduous. ' labored_breathing_on = /effect_on labored_breathing
/def -Fp5 -msimple -aCred -t'The ebon cloud disappears and you feel relieved as breathing is easier.' labored_breathing_off = /effect_off labored_breathing

/def_effect -p'energetic_frailty' -n'Energetic Frailty'
/def -Fp5 -msimple -aCgreen -t'you crackles and electrifies. ' energetic_frailty_on = /effect_on energetic_frailty
/def -Fp5 -msimple -aCred -t'You feel grounded and comfortable again.' energetic_frailty_off = /effect_off energetic_frailty

/def_effect -p'blemished_health' -n'Blemished Health'
/def -Fp5 -msimple -aCgreen -t'breathe out turns miasmic and jade green. ' blemished_health_on = /effect_on blemished_health
/def -Fp5 -msimple -aCred -t'You feel healthy again as the mephitic bane is gone.' blemished_health_off = /effect_off blemished_health

/def_effect -p'multivuln' -n'Multivuln'
/def -Fp5 -msimple -aCgreen -t'You feel your resistances weakening.' multivuln_on = /effect_on multivuln
/def -Fp5 -msimple -aCred -t'You feel your resistances returning to normal.' multivuln_off = /effect_off multivuln

;/def_effect -p'spell' -n'Spell' -c2
;/def -Fp5 -msimple -aCgreen -t'' spell_on = /effect_on spell
;/def -Fp5 -msimple -aCred -t'' spell_off = /effect_off spell

/def_effect -p'amorphic_armour' -n'Amorphic Armour' -c2 -s'va'
/def -Fp5 -mregexp -aCgreen -t'^[A-Z][a-z]+ casts a protective spell on you\\.$' amorphic_armour_on = /effect_on amorphic_armour
/def -Fp5 -mregexp -aCgreen -t'^You cast a protective spell on (.+)\\.$' amorphic_armour_on_other = /if (is_me({P1})) /amorphic_armour_on%; /endif
/def -Fp5 -msimple -aCred -t'Your Amorphic Armour spell wears off.' amorphic_armour_off = /effect_off amorphic_armour

/def_effect_group -g'skin' -n'Skin'

/def_effect -g'skin' -p'stoneskin' -n'Stoneskin' -c2
/def -Fp5 -msimple -aCgreen -t'Granite plates form over your skin.' stoneskin_on = /effect_on stoneskin
/def -Fp5 -msimple -aCred -t'Your stoneskin crumbles and drops off.' stoneskin_off = /effect_off stoneskin

/def_effect -g'skin' -p'barkskin' -n'Barkskin' -c2 -s'bs'
/def -Fp5 -msimple -aCgreen -t'Your skin turns green and fissures, thickening into a layer of tough bark.' barkskin_on = /effect_on barkskin
/def -Fp5 -msimple -aCred -t'Your barkskin wears off.' barkskin_off = /effect_off barkskin

/def_effect -p'shield_of_protection' -n'Shield of Protection' -c2 -s'sop'
/def -Fp5 -msimple -aCgreen -t'You form a barrier of repulsive magic around yourself.' shield_of_protection_on = /effect_on shield_of_protection
/def -Fp5 -msimple -aCgreen -t'You are surrounded by a green glow.' shield_of_protection_on_other = /shield_of_protection_on
/def -Fp5 -msimple -aCred -t'Your protection spell wears off.' shield_of_protection_off = /effect_off shield_of_protection

/def_effect -p'displacement' -n'Displacement' -c2
/def -Fp5 -mregexp -aCgreen -t'^[A-Z][a-z]+ displaces your image\\.$' displacement_on = /effect_on displacement
/def -Fp5 -mregexp -aCgreen -t'^You displace ([A-Z][a-z]+)\'s image\\.$' displacement_on_self = /if (is_me({P1})) /displacement_on%; /endif
/def -Fp5 -msimple -aCred -t'Your displacement wears off.' displacement_off = /effect_off displacement
