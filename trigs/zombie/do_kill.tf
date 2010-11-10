;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; DO KILL
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-09-21 00:55:32 -0700 (Tue, 21 Sep 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/do_kill.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/do_kill.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def mm = /magic_missile %{*}

/def acid_arrow = /do_kill -a'cast' -s'acid arrow' -t'$(/escape ' %{*-%{target}})'
/def ashes_to_ashes = /do_kill -a'cast' -s'ashes to ashes' -t'$(/escape ' %{*-%{target}})'

/def batter = /do_kill -a'use' -s'batter' -t'$(/escape ' %{*-%{target}})'
/def battlecry = /do_kill -a'use' -s'battlecry' -t'$(/escape ' %{*-%{target}})' -i
/def black_death = /do_kill -a'cast' -s'black death'
/def bladed_fury = /do_kill -a'use' -s'bladed fury' -t'$(/escape ' %{*-%{target}})'
/def blemished_health = /do_kill -a'cast' -s'blemished health' -n'Blemished Health (poison vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def brainstorm = /do_kill -a'cast' -s'brainstorm'
/def bright_light = /do_kill -a'cast' -s'bright light' -t'$(/escape ' %{*-%{target}})'

/def cellular_asphyxia = /do_kill -a'cast' -s'cellular asphyxia' -t'$(/escape ' %{*-%{target}})'
/def chain_lightning = /do_kill -a'cast' -s'chain lightning' -t'$(/escape ' %{*-%{target}})'
/def chaos_lance = /do_kill -a'cast' -s'chaos lance' -t'$(/escape ' %{*-%{target}})'
/def charging_lance = /do_kill -a'use' -s'charging lance' -t'$(/escape ' %{*-%{target}})'
/def choke = /do_kill -a'cast' -s'choke' -t'$(/escape ' %{*-%{target}})'
/def cleansing_harmony = /do_kill -a'cast' -s'cleansing harmony' -n'Cleansing Harmony' -t'$(/escape ' %{*-%{target}})' -v
/def cross_slash = /do_kill -a'use' -s'cross slash' -t'$(/escape ' %{*})'
/def cryokinesis = /do_kill -a'cast' -s'cryokinesis' -t'$(/escape ' %{*-%{target}})'

/def daggers_of_ice = /do_kill -a'cast' -s'daggers of ice' -t'$(/escape ' %{*-%{target}})'
/def dancing_blade = /do_kill -a'use' -s'dancing blade' -t'$(/escape ' %{*-%{target}})'
/def deceitful_blow = /do_kill -a'use' -s'deceitful blow' -t'$(/escape ' %{*})'
/def deliverance = /do_kill -a'cast' -s'deliverance' -t'$(/escape ' %{*-%{target}})'
/def deprive_warmth = /do_kill -a'cast' -s'deprive warmth' -n'Deprive Warmth (cold vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def disembowel = /do_kill -a'use' -s'disembowel' -t'$(/escape ' %{*})'
/def dismember = /do_kill -a'use' -s'dismember' -t'$(/escape ' %{*})'
/def dispel_evil = /do_kill -a'cast' -s'dispel evil' -t'$(/escape ' %{*-%{target}})'
/def downward_strike = /do_kill -a'use' -s'downward strike' -t'$(/escape ' %{*})'

/def earthslide = /do_kill -a'cast' -s'earthslide' -t'$(/escape ' %{*-%{target}})'
/def effusion_of_entity = /do_kill -a'cast' -s'effusion of entity' -t'$(/escape ' %{*-%{target}})'
/def elemental_disarray = /do_kill -a'cast' -s'elemental disarray' -n'Elemental Disarray (cold, mag, fire, asp, phys vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def energetic_frailty = /do_kill -a'cast' -s'energetic frailty' -n'Energetic Frailty (electric vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def energy_consumption = /do_kill -a'cast' -s'energy consumption' -t'$(/escape ' %{*-%{target}})'
/def epilepsy = /do_kill -a'cast' -s'epilepsy' -t'$(/escape ' %{*-%{target}})'

/def fast_blow = /do_kill -a'use' -s'fast blow' -t'$(/escape ' %{*})'
/def fatal_blow = /do_kill -a'use' -s'fatal blow' -t'$(/escape ' %{*})'
/def fear = /do_kill -a'cast' -s'fear' -t'$(/escape ' %{*-%{target}})'
/def flesh_rot = /do_kill -a'cast' -s'flesh rot' -t'$(/escape ' %{*-%{target}})' -i
/def force_of_nature = /do_kill -a'cast' -s'force of nature' -t'$(/escape ' %{*-%{target}})'
/def fragile_frame = /do_kill -a'cast' -s'fragile frame' -n'Fragile Frame (physical vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def frost_globe = /do_kill -a'cast' -s'frost globe' -t'$(/escape ' %{*-%{target}})'

/def headache = /do_kill -a'cast' -s'headache' -t'$(/escape ' %{*})'

/def immunal_disorder = /do_kill -a'cast' -s'immunal disorder' -t'$(/escape ' %{*-%{target}})'
/def incendiary_coating = /do_kill -a'cast' -s'incendiary coating' -n'Incendiary Coating (fire vuln)' -t'$(/escape ' %{*-%{target}})' -v

/def ki = /do_kill -a'use' -s'ki' -t'$(/escape ' %{*})' -i
/def kick = /do_kill -a'use' -s'kick' -t'$(/escape ' %{*-%{target}})'
/def kiru = /do_kill -a'use' -s'kiru' -t'$(/escape ' %{*-%{target}})' -i
/def kungfu = /do_kill -a'use' -s'kungfu' -t'$(/escape ' %{*})'

/def labored_breathing = /do_kill -a'cast' -s'labored breathing' -n'Labored Breathing (asphyxiation vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def languished_soul  = /do_kill -a'cast' -s'languished soul' -n'Languished Soul (psionic vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def lunge = /do_kill -a'use' -s'lunge' -t'$(/escape ' %{*})'

/def magic_missile = /do_kill -a'cast' -s'magic missile' -t'$(/escape ' %{*-%{target}})'
/def magical_storm = /do_kill -a'cast' -s'magical storm' -t'$(/escape ' %{*-%{target}})'
/def magical_transfixion = /do_kill -a'cast' -s'magical transfixion' -t'$(/escape ' %{*-%{target}})'
/def mangle = /do_kill -a'use' -s'mangle' -t'$(/escape ' %{*-%{target}})'
/def mental_illusions = /do_kill -a'cast' -s'mental illusions' -t'$(/escape ' %{*-%{target}})' -v
/def mind_blast = /do_kill -a'use' -s'mind blast' -t'$(/escape ' %{*-%{target}})' -n'Mind Blast' -v
/def mindscream = /do_kill -a'use' -s'mindscream' -t'$(/escape ' %{*-%{target}})' -n'Screaming' -v
/def missile_storm = /do_kill -a'cast' -s'missile storm' -t'$(/escape ' %{*-%{target}})'
/def molecular_agitation = /do_kill -a'cast' -s'molecular agitation' -t'$(/escape ' %{*-%{target}})'
/def mystic_impairment = /do_kill -a'cast' -s'mystic impairment' -n'Mystic Impairment (magic vuln)' -t'$(/escape ' %{*-%{target}})' -v

/def neural_internecion = /do_kill -a'cast' -s'neural internecion' -t'$(/escape ' %{*-%{target}})'

/def particle_collision = /do_kill -a'use' -s'particle collision' -t'$(/escape ' %{*-%{target}})'
/def piercing_blows = /do_kill -a'use' -s'piercing-blows' -t'$(/escape ' %{*})'
/def poison = /do_kill -a'cast' -s'poison' -t'$(/escape ' %{*-%{target}})' -q
/def power_kick = /do_kill -a'use' -s'power kick' -t'$(/escape ' %{*})'
/def power_word = /do_kill -a'cast' -s'power word' -t'$(/escape ' %{*-%{target}})'
/def psionic_blast = /do_kill -a'cast' -s'psionic blast' -t'$(/escape ' %{*-%{target}})'
/def psychic_crush = /do_kill -a'cast' -s'psychic crush' -t'$(/escape ' %{*-%{target}})'

/def quick_thrusts = /do_kill -a'use' -s'quick-thrusts' -t'$(/escape ' %{*})'

/def ray_of_enervation = /do_kill -a'cast' -s'ray of enervation' -n'Ray of Enervation (elec, acid, psi, poi, phys vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def resist_heal = /do_kill -a'cast' -s'resist heal' -t'$(/escape ' %{*-%{target}})' -v

/def shatter_limb = /do_kill -a'cast' -s'shatter limb' -t'$(/escape ' %{*-%{target}})'
/def skewer = /do_kill -a'use' -s'skewer' -t'$(/escape ' %{*})'
/def soulsuck = /do_kill -a'cast' -s'soulsuck' -t'$(/escape ' %{*-%{target}})'
/def strike = /do_kill -a'use' -s'strike' -t'$(/escape ' %{*-%{target}})'
/def suffocation = /do_kill -a'cast' -s'suffocation' -t'$(/escape ' %{*-%{target}})' -i
/def sweep = /do_kill -a'use' -s'sweep' -t'$(/escape ' %{*})'

/def terror = /do_kill -a'cast' -s'terror' -t'$(/escape ' %{*-%{target}})'
/def thermal_drain = /do_kill -a'cast' -s'thermal drain' -t'$(/escape ' %{*-%{target}})'
/def touch_of_darkness = /do_kill -a'cast' -s'touch of darkness' -t'$(/escape ' %{*-%{target}})'
/def transpierce = /do_kill -a'use' -s'transpierce' -t'$(/escape ' %{*})'
/def treecutting = /do_kill -a'use' -s'treecutting' -t'$(/escape ' %{*-%{target}})'

/def vitriolic_bane = /do_kill -a'cast' -s'vitriolic bane' -n'Vitriolic Bane (acid vuln)' -t'$(/escape ' %{*-%{target}})' -v
/def voids_of_life = /do_kill -a'cast' -s'voids of life' -t'$(/escape ' %{*-%{target}})'

/def watery_breath = /do_kill -a'cast' -s'watery breath' -t'$(/escape ' %{*-%{target}})'
/def wild_blow = /do_kill -a'use' -s'wild blow' -t'$(/escape ' %{*})'
/def wildfire = /do_kill -a'cast' -s'wildfire' -t'$(/escape ' %{*-%{target}})'
/def wrath_of_god = /do_kill -a'cast' -s'wrath of god' -t'$(/escape ' %{*-%{target}})'
