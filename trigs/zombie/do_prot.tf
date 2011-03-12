;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; DO PROT
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-03-11 15:33:39 -0800 (Fri, 11 Mar 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/do_prot.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/do_prot.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def blurr = /blurred_image %{*}
/def eh = /energy_hauberk %{*}
/def eweap = /enlarge_weapon %{*}
/def fa = /first_aid %{*}
/def hw = /heavy_weight %{*}
/def infra = /infravision %{*}
/def ip = /inner_power %{*}
/def iw = /iron_will %{*}
/def regen = /regeneration %{*}
/def reloc = /relocate %{*}
/def rp = /remove_poison %{*}
/def rweap = /reduce_weapon %{*}
/def sop = /shield_of_protection %{*}
/def twe = /teleport_without_error %{*}
/def ww = /water_walking %{*}

/def acid_blade = /do_prot -a'cast' -s'acid blade' -n'Corroding Blade'
/def adrenaline_rush = /do_prot -a'use' -s'adrenaline rush' -n'Getting an Adrenaline Rush'
/def amorphic_armour = /do_prot -a'cast' -s'amorphic armour' -t'$(/escape ' %{*-%{healing}})'
/def anti_magic_field = /do_prot -a'cast' -s'anti-magic field' -n'Casting Anti-Magic Field'
/def arcane_bulwark = /do_prot -a'cast' -s'arcane bulwark' -t'$(/escape ' %{*-%{healing}})' -n'Arcane Bulwark (g_magic)'
/def armour_of_god = /do_prot -a'cast' -s'armour of god' -t'$(/escape ' %{*-%{healing}})'
/def aura_detection = /do_prot -a'cast' -s'aura detection' -t'$(/escape ' %{*-%{healing}})'

/def balance_axe = /do_prot -a'cast' -s'balance axe' -t'$(/escape ' %{*-axe})' -n'Balancing'
/def banish = /do_prot -a'cast' -s'banishment' -t'$(/escape ' %{*-%{target}})' -n'Banishment' -q
/def barkskin = /do_prot -a'cast' -s'barkskin' -t'$(/escape ' %{*-%{healing}})'
/def berserk = /do_prot -a'use' -s'berserk' -n'Going Berserk'
/def bless = /do_prot -a'use' -s'bless' -t'$(/escape ' %{*-%{healing}})' -n'Blessing'
/def blurred_image = /do_prot -a'cast' -s'blurred image' -t'$(/escape ' %{*-%{healing}})'
/def bond_of_fates = /do_prot -a'cast' -s'bond of fates' -t'$(/escape ' %{*})'
/def brain_unpain = /do_prot -a'cast' -s'brain unpain' -t'$(/escape ' %{*-%{healing}})'

/def call_for_fire = /do_prot -a'use' -s'call for fire' -n'Calling for Fire'
/def call_for_ice = /do_prot -a'use' -s'call for ice' -n'Calling for Ice'
/def call_for_thunder = /do_prot -a'use' -s'call for thunder' -n'Calling for Thunder'
/def call_upon_unity = /do_prot -a'use' -s'call upon unity' -t'$(/escape ' %{*-all})'
/def calm_down = /do_prot -a'use' -s'calm down' -n'Calming ($[pluralize(ignores, 'ignore')])'
/def cancellation = /do_prot -a'cast' -s'cancellation' -t'$(/escape ' %{*})'
/def cannibalize = /do_prot -a'use' -s'cannibalize' -t'$(/escape ' %{*-$[p_hp - 1]})'
/def caustic_opposition = /do_prot -a'cast' -s'caustic opposition' -t'$(/escape ' %{*-%{healing}})' -n'Caustic Opposition (l_acid)'
/def chaos_cube = /do_prot -a'cast' -s'chaos cube' -t'$(/escape ' %{*-%{target}})'
/def corrosive_opposition = /do_prot -a'cast' -s'corrosive opposition' -t'$(/escape ' %{*-%{healing}})' -n'Corrosive Opposition (g_acid)'
/def create_food = /do_prot -a'cast' -s'create food' -n'Creating Food'
/def create_healing_potion = /do_prot -a'cast' -s'create healing potion' -n'Creating Healing Potion'
/def create_money = /do_prot -a'cast' -s'create money' -n'Creating Money'
/def cure_blindness = /do_prot -a'cast' -s'cure blindness' -t'$(/escape ' %{*-%{healing}})'
/def cure_disease = /do_prot -a'cast' -s'cure disease' -t'$(/escape ' %{*-%{healing}})'
/def darkness = /do_prot -a'cast' -s'darkness' -t'$(/escape ' %{*-10})'
/def detect_alignment = /do_prot -a'cast' -s'detect alignment' -t'$(/escape ' %{*-%{target}})'
/def dimension_door = /do_prot -a'cast' -s'dimension door' -n'Calling up a Dimensional Door'
/def dispel_curse = /do_prot -a'cast' -s'dispel curse' -t'$(/escape ' %{*-%{healing}})'
/def displacement = /do_prot -a'cast' -s'displacement' -t'$(/escape ' %{*-%{healing}})'

/def electric_blade = /do_prot -a'cast' -s'electric blade' -n'Electrifying Blade'
/def endure_void = /do_prot -a'cast' -s'endure void' -t'$(/escape ' %{*-%{healing}})' -n'Endure Void (l_asphyxiaton)'
/def energize_seal = /do_prot -a'use' -s'energize seal' -n'Energizing Seal'
/def energy_hauberk = /do_prot -a'cast' -s'energy hauberk' -t'$(/escape ' %{*-%{healing}})'
/def enlarge_weapon = /do_prot -a'cast' -s'enlarge weapon' -t'$(/escape ' %{*})'
/def enlightenment = /do_prot -a'cast' -s'enlightenment' -t'$(/escape ' %{*-%{healing}})'
/def estimate_worth = /do_prot -a'cast' -s'estimate worth' -t'$(/escape ' %{*-%{cleric_target-%{healing}}})'
/def evaluate_corpse = /do_prot -a'use' -s'evaluate corpse' -t'$(/escape ' %{*-%{target}})' -q

/def feather_weight = /do_prot -a'cast' -s'feather weight' -t'$(/escape ' %{*-%{healing}})'
/def fire_blade = /do_prot -a'cast' -s'fire blade' -n'Burning Blade'
/def fire_building = /do_prot -a'use' -s'fire building' -n'Building a Fire'
/def flight = /do_prot -a'cast' -s'flight' -t'$(/escape ' %{*-%{healing}})'
/def floating_disc = /do_prot -a'cast' -s'floating disc' -n'Summoning Floating Disc'
/def floating_letters = /do_prot -a'cast' -s'floating letters' -t'$(/escape ' %{*-Hello!})' -n'Floating Letters' -q
/def foraging = /do_prot -a'use' -s'foraging' -n'Foraging for Berries'
/def force_shield = /do_prot -a'cast' -s'force shield' -t'$(/escape ' %{*-%{healing}})'
/def forget = /do_prot -a'cast' -s'forget' -t'$(/escape ' %{*-%{target}})' -q

/def greater_party_heal = /do_prot -a'cast' -s'greater party heal' -n'Casting Greater Party Heal'
/def harmonious_barrier = /do_prot -a'cast' -s'harmonious barrier' -t'$(/escape ' %{*-%{healing}})'
/def harmony_armour = /do_prot -a'cast' -s'harmony armour' -t'$(/escape ' %{*-%{healing}})'
/def healing_ceremony = /do_prot -a'cast' -s'healing ceremony' -n'Starting a Healing Ceremony'
/def healing_smoke = /do_prot -a'cast' -s'healing smoke' -n'Summoning Healing Smoke'
/def heavy_weight = /do_prot -a'cast' -s'heavy weight' -t'$(/escape ' %{*-%{healing}})'
/def hour_of_mercy = /do_prot -a'cast' -s'hour of mercy' -t'$(/escape ' %{*})'
/def hunting = /do_prot -a'use' -s'hunting'

/def ice_blade = /do_prot -a'cast' -s'ice blade' -n'Freezing Blade'
/def identify = /do_prot -a'cast' -s'identify' -t'$(/escape ' %{*-ring})'
/def infernal_vestment = /do_prot -a'cast' -s'infernal vestment' -t'$(/escape ' %{*-%{healing}})' -n'Infernal Vestment (g_cold)'
/def infravision = /do_prot -a'cast' -s'infravision' -t'$(/escape ' %{*-%{healing}})'
/def inner_power = /do_prot -a'cast' -s'inner power' -t'$(/escape ' %{*-%{healing}})'
/def introversion = /do_prot -a'use' -s'introversion' -t'$(/escape ' %{*-$[trunc(p_exp / 1000000)]})'
/def invis = /do_prot -a'cast' -s'invisibility' -t'$(/escape ' %{*-me})' -n'Invisibility' -q
/def iron_will = /do_prot -a'cast' -s'iron will' -t'$(/escape ' %{*-%{healing}})'

/def jigoku_blade = /do_prot -a'cast' -s'jigoku blade' -n'Casting Jigoku Blade'

/def kamikaze = /do_prot -a'use' -s'kamikaze' -n'Going Kamikaze!'
/def know_your_audience = /do_prot -a'cast' -s'know your audience' -t'$(/escape ' %{*-%{target}})'

/def lesser_party_heal = /do_prot -a'cast' -s'lesser party heal' -n'Casting Lesser Party Heal'
/def levitate_object = /do_prot -a'cast' -s'levitate object' -t'$(/escape ' %{*})'
/def light = /do_prot -a'cast' -s'light' -t'$(/escape ' %{*-10})' -n'Light' -q
/def lightning_guard = /do_prot -a'cast' -s'lightning guard' -t'$(/escape ' %{*-%{healing}})' -n'Lightning Guard (g_electric)'
/def lightsword = /do_prot -a'cast' -s'lightsword' -t'$(/escape ' %{*-999}) hit' -n'Casting Lightsword (+hit)' -q

/def mana_leech = /do_prot -a'cast' -s'mana leech' -n'Casting Mana Leech'
/def mental_aegis = /do_prot -a'cast' -s'mental aegis' -t'$(/escape ' %{*-%{healing}})' -n'Mental Aegis (l_psionic)'
/def mental_glance = /do_prot -a'cast' -s'mental glance' -t'$(/escape ' %{*-%{target}})' -n'Mental Glance' -q
/def mind_barrier = /do_prot -a'cast' -s'mind barrier' -n'Casting Mind Barrier'
/def mind_development = /do_prot -a'cast' -s'mind development' -t'$(/escape ' %{*-%{healing}})'
/def minor_unpain = /do_prot -a'cast' -s'minor unpain' -t'$(/escape ' %{*-%{healing}})'
/def mirror_image = /do_prot -a'cast' -s'mirror image' -t'$(/escape ' %{*-%{healing}})'
/def modify_bodypart = /do_prot -a'use' -s'modify bodypart' -t'$(/escape ' %{1}) modify towards $(/escape ' %{-1})' -q
/def mystic_bulwark = /do_prot -a'cast' -s'mystic bulwark' -t'$(/escape ' %{*-%{healing}})' -n'Mystic Bulwark (l_magic)'

/def phaze_shift = /do_prot -a'cast' -s'phaze shift' -t'$(/escape ' %{*-%{tank}})'
/def poison_blade = /do_prot -a'cast' -s'poison blade' -n'Poisoning Blade'
/def poison_fend = /do_prot -a'cast' -s'poison fend' -t'$(/escape ' %{*-%{healing}})' -n'Poison Fend (l_poison)'
/def preparation_of_harmony = /do_prot -a'cast' -s'preparation of harmony' -t'$(/escape ' %{*-%{healing}})'
/def prepare_potion = /do_prot -a'use' -s'prepare potion' -n'Preparing Potion'
/def psychic_aegis = /do_prot -a'cast' -s'psychic aegis' -t'$(/escape ' %{*-%{healing}})' -n'Psychic Aegis (g_psionic)'

/def razor_edge = /do_prot -a'cast' -s'razor edge' -t'$(/escape ' %{*-999}) dam' -n'Casting Razor Edge (+dam)' -q
/def rebuke_of_ice = /do_prot -a'cast' -s'rebuke of ice' -t'$(/escape ' %{*-%{healing}})' -n'Rebuke of Ice (l_fire)'
/def reduce_weapon = /do_prot -a'cast' -s'reduce weapon' -t'$(/escape ' %{*})'
/def regeneration = /do_prot -a'cast' -s'regeneration' -t'$(/escape ' %{*-%{healing}})'
/def reincarnation = /do_prot -a'cast' -s'reincarnation' -t'$(/escape ' %{*-%{cleric_target-%{healing}}})'
/def relocate = /do_prot -a'cast' -s'relocate' -t'$(/escape ' %{*-%{healing}})' -n'Relocate' -q
/def remove_elements = /do_prot -a'use' -s'remove elements' -n'Removing Elements'
/def remove_invulnerabilities = /do_prot -a'cast' -s'remove invulnerabilities' -t'$(/escape ' %{*-%{healing}})'
/def remove_poison = /do_prot -a'cast' -s'remove poison' -t'$(/escape ' %{*-%{healing}})'
/def remove_scar = /do_prot -a'cast' -s'remove scar' -t'$(/escape ' %{*-%{healing}})'
/def resist_void = /do_prot -a'cast' -s'resist void' -t'$(/escape ' %{*-%{healing}})' -n'Resist Void (g_asphyxiaton)'
/def restore_memory = /do_prot -a'cast' -s'restore memory' -t'$(/escape ' %{*})'
/def resurrect = /do_prot -a'cast' -s'resurrect' -t'$(/escape ' %{*-%{cleric_target-%{healing}}})'
/def reverie_shadow = /do_prot -a'cast' -s'reverie shadow' -t'$(/escape ' %{*-%{target}})'

/def sacred_ritual = /do_prot -a'cast' -s'sacred ritual' -n'Casting Sacred Ritual'
/def see_magic = /do_prot -a'cast' -s'see magic' -t'$(/escape ' %{*-%{healing}})'
/def sex_change = /do_prot -a'cast' -s'sex change' -t'$(/escape ' %{*-%{healing}})'
/def shadow_shield = /do_prot -a'cast' -s'shadow shield' -t'$(/escape ' %{*-%{healing}})'
/def shadow_shift = /do_prot -a'use' -s'shadow shift' -n'Shadow Shifting'
/def shelter = /do_prot -a'cast' -s'shelter' -n'Sheltering'
/def shield_of_protection = /do_prot -a'cast' -s'shield of protection' -t'$(/escape ' %{*-%{healing}})'
/def shizen = /do_prot -a'cast' -s'shizen' -t'%{*-$[min(p_sp, p_maxhp - p_hp)]}'
/def silver_sheen = /do_prot -a'cast' -s'silver sheen' -t'$(/escape ' %{*-999}) wc' -n'Casting Silver Sheen (+wc)' -q
/def spark_shelter = /do_prot -a'cast' -s'spark shelter' -t'$(/escape ' %{*-%{healing}})' -n'Spark Shelter (l_electric)'
/def spirit_of_nature = /do_prot -a'cast' -s'spirit of nature' -n'Casting Spirit of Nature'
/def stun_resistance = /do_prot -a'cast' -s'stun resistance' -t'$(/escape ' %{*-%{healing}})'
/def summon = /do_prot -a'cast' -s'summon' -t'$(/escape ' %{*-%{healing}})' -n'Summon' -q
/def summon_aide = /do_prot -a'use' -s'summon aide' -t'$(/escape ' %{*})'
/def summon_bag_of_holding = /do_prot -a'cast' -s'summon bag of holding' -n'Summoning Bag of Holding'
/def summon_ghost = /do_prot -a'cast' -s'summon ghost' -t'$(/escape ' %{*-%{cleric_target-%{healing}}})'
/def summon_orb_of_reflection = /do_prot -a'cast' -s'summon orb of reflection' -n'Summoning Orb of Reflection'
/def symmetry_in_body = /do_prot -a'cast' -s'symmetry in body' -t'$(/escape ' %{*-%{healing}})'

/def teleport_without_error = /do_prot -a'cast' -s'teleport without error' -n'Teleporting to Church'
/def tenrai_blade = /do_prot -a'cast' -s'tenrai blade' -n'Casting Tenrai Blade'
/def transfer_mana = /do_prot -a'cast' -s'transfer mana' -t'$(/escape ' %{*-%{healing}})' -n'Transfering Mana'
/def transformation = /do_prot -a'cast' -s'transformation' -t'$(/escape ' %{*-bird})' -n'Transforming' -q
/def transposition = /do_prot -a'use' -s'transposition' -n'Teleporting to Sorcerer Guild'
/def true_unpain = /do_prot -a'cast' -s'true unpain' -t'$(/escape ' %{*-%{healing}})'

/def venom_fend = /do_prot -a'cast' -s'venom fend' -t'$(/escape ' %{*-%{healing}})' -n'Venom Fend (g_poison)'
/def vestment_of_flame = /do_prot -a'cast' -s'vestment of flame' -t'$(/escape ' %{*-%{healing}})' -n'Vestiment of Flame (l_cold)'
/def viscous_flesh = /do_prot -a'cast' -s'viscous flesh' -n'Casting Viscous Flesh'
/def vortex_magica = /do_prot -a'cast' -s'vortex magica' -n'Vortexing'

/def wall_of_steel = /do_prot -a'use' -s'wall of steel' -n'Putting up a Wall of Steel'
/def ward_of_steel = /do_prot -a'cast' -s'ward of steel' -t'$(/escape ' %{*-%{healing}})' -n'Ward of Steel (g_physical)'
/def ward_of_stone = /do_prot -a'cast' -s'ward of stone' -t'$(/escape ' %{*-%{healing}})' -n'Ward of Stone (l_physical)'
/def water_walking = /do_prot -a'cast' -s'water walking' -t'$(/escape ' %{*-%{healing}})'
/def winters_rebuke = /do_prot -a'cast' -s'winter\\\'s rebuke' -t'$(/escape ' %{*-%{healing}})' -n'Winter\\\'s Rebuke (g_fire)'
/def word_of_binding = /do_prot -a'use' -s'word of binding' -t'$(/escape ' %{*})'
/def word_of_recall = /do_prot -a'cast' -s'word of recall' -n'Recalling Words'
