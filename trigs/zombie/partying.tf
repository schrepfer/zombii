;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; PARTYING
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-09-12 17:14:04 -0700 (Sun, 12 Sep 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/partying.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/partying.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def go = \
  /if (!strlen(go)) \
    /return%; \
  /endif%; \
  /run_path -d'$(/escape ' %{go})'

/def grab_go = \
  /grab /go

/def set_go = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /set go=%{*}%; \
  /clear_at%; \
  /grab_go

/def clear_go = \
  /unset go

/def set_at = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /set at=%{*}%; \
  /timer -t10 -n1 -p'at_pid' -k -- /clear_at

/def clear_at = \
  /unset at

;/def -Fp5 -msimple -t'' at_XXX = \
;  /set_at XXX
;
;/def -Fp5 -mregexp -t'^([A-Z][a-z]+)\\.$' at_XXX_command = \
;  /if (at =~ 'XXX' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
;    /set_go YYY%; \
;  /endif

/def -Fp5 -msimple -t'At the edge of a massive chasm within the mountain (ne,sw).' at_chasm = \
  /set_at chasm

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) climbs down into the chasm\\.$' at_chasm_command = \
  /if (at =~ 'chasm' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go climb down%; \
  /endif

/def -Fp5 -msimple -t'in the plains of ra (n,e,w,nw,ne,watch).' at_plains = \
  /set_at plains

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) jumps on the horse and rides away\\.$' at_plains_command = \
  /if (at =~ 'plains' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go whistle;ride horse to revelstone%; \
  /endif

/def -Fp5 -msimple -t'At the entrance to Revelstone (n).' at_revelstone = \
  /set_at revelstone

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) jumps on the horse and rides away\\.$' at_revelstone_command = \
  /if (at =~ 'revelstone' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go whistle;ride horse to plains%; \
  /endif

/def -Fp5 -msimple -t'A narrow road (w,ne).' at_narrow_road = \
  /set_at narrow_road

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) leaves away into the forest\\.$' at_narrow_road_command = \
  /if (at =~ 'narrow_road' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go follow path%; \
  /endif

/def -Fp5 -msimple -t'At the bottom of a massive crevice (nw,se).' at_crevice = \
  /set_at crevice

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) climbs up the cliff wall\\.$' at_crevice_command = \
  /if (at =~ 'crevice' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go climb up%; \
  /endif

/def -Fp5 -msimple -t'In the merchant square (w,s).' at_merchant_square = \
  /set_at merchant_square

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) leaves somewhere\\.$' at_merchant_square_command = \
  /if (at =~ 'merchant_square' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go push plate;2 n;pf%; \
  /endif

/def -Fp5 -msimple -t'The village gate (s,ne).' at_village_gate = \
  /set_at village_gate

/def -Fp5 -mregexp -t'^The dwarf pushes ([A-Z][a-z]+) through the gate\\.$' at_village_gate_command = \
  /if (at =~ 'village_gate' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go say friend%; \
  /endif

/def -Fp5 -msimple -t'A glacier near a stony rubble and a mountain (n).' at_grimhildr = \
  /set_at grimhildr

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) discovers a small passageway between the stony rubble and the mountain at south and decides to enter the passageway\\.$' at_grimhildr_command = \
  /if (at =~ 'grimhildr' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go search snow%; \
  /endif

/def -Fp5 -msimple -t'Library of ancient lore (s).' at_library = \
  /set_at library

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) pulls the lever with an audible KLONK, and is sent skyward by an unseen force\\.$' at_library_command = \
  /if (at =~ 'library' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go pull lever%; \
  /endif%; \

/def -Fp5 -msimple -t'The inner chambers of Mage guild (s).' at_mage_guild = \
  /set_at mage_guild

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) closes (her|his|its) eyes and steps through the gate\\.$' at_mage_guild_command = \
  /if (at =~ 'mage_guild' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go enter hole%; \
  /endif

/def -Fp5 -msimple -t'Swirling mists (n).' at_mists = \
  /set_at mists

/def -Fp5 -msimple -t'A Will o\' mist arrives.' at_mists_command = !mists

/def -Fp5 -msimple -t'Mushroom Patch (nw,ne,w,e,sw,se).' at_mushroom_patch = \
  /set_at mushroom_patch

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) plays something on a flute and wanders off\\.\\.\\.$' at_mushroom_patch_command = \
  /if (at =~ 'mushroom_patch' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /if (bag) \
      /set_go sw;se;need flute;get flute;get flute from bag of holding;nw;ne;play flute;put flute all bag of holding;keep all flute;n;E;n;pf%; \
    /else \
      /set_go sw;se;need flute;get flute;keep all flute;nw;ne;play flute;n;E;n;pf%; \
    /endif%; \
  /endif

/def -Fp5 -msimple -t'Crafts Room (s).' at_hileran = \
  /set_at hileran

/def -Fp5 -msimple -t'Verkle\'s Office (n).' at_verkle = \
  /set_at verkle

/def -Fp5 -msimple -t'Home of the Elder (leave).' at_elder = \
  /set_at elder

/def -Fp5 -msimple -t'You enter the passage behind the corpses.' at_passage = \
  /set_at passage

/def -Fp5 -msimple -t'The dump (e).' at_dump = \
  /set_at dump

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) enters the magical tree\\.$' at_dump_command = \
  /if (at =~ 'dump' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go enter tree;2 pf%; \
  /endif

/def -Fp5 -msimple -t'An underground cave (w,out).' at_underground_cave = \
  /set_at underground_cave

/def -Fp5 -msimple -t'The leader is not here!' at_no_leader_command = \
  /if (at =~ 'hileran') \
    /set_go 2 s;pf%; \
  /elseif (at =~ 'verkle') \
    /set_go n;leave;W;pf%; \
  /elseif (at =~ 'elder') \
    /set_go leave;2 e;7 n;pf%; \
  /elseif (at =~ 'passage') \
    /set_go stairs;e;pf%; \
  /elseif (at =~ 'underground_cave') \
    /set_go w;sw;se;ne;n;pf%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) leaves gate\\.' at_gate = \
  /if (tolower({P1}) =~ commander | tolower({P1}) =~ tank) \
    /set_at gate%; \
  /endif

/def -Fp5 -msimple -t'What ?' at_what_command = \
  /if (at =~ 'mists') \
    /set_go enter mists%; \
  /elseif (at =~ 'gate') \
    /set_go enter;s;enter tent;pf%; \
  /endif

/def -Fp5 -msimple -t'Lake (n,ne,e,se,s,sw,w,nw).' at_lake = \
  /set_at lake

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) leaves , diving into the river\\.$' at_lake_command = \
  /if (at =~ 'lake' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go swim%; \
  /endif

/def -Fp5 -msimple -t'In an underground river (w).' at_underground_river = \
  /set_at underground_river

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) leaves , diving deeper into the river\\.$' at_underground_river_command = \
  /if (at =~ 'underground_river' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go swim%; \
  /endif

/def -Fp5 -msimple -t'A food storage (e).' at_food_storage = \
  /set_at food_storage

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) enters the passage behind the corpses\\.' at_food_storage_command = \
  /if (at =~ 'food_storage' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go enter passage;2 pf%; \
  /endif

/def -Fp5 -msimple -t'Ye Olde Shoppe of Transportation (e).' at_zombiecity = \
  /set_at zombiecity

/def -Fp5 -msimple -t'Ye Olde Shoppe of Transportation (n).' at_ravenkall = \
  /set_at ravenkall

/def -Fp5 -mregexp -t'^When the smoke clears, ([A-Z][a-z]+) is gone\\.$' at_transport_command = \
  /if (tolower({P1}) !~ commander & tolower({P1}) !~ tank) \
    /return%; \
  /endif%; \
  /if (at =~ 'ravenkall') \
    /set_go 3 n;2 w;2 n;2 w;20 n;n;enter;cs;pf%; \
  /elseif (at =~ 'zombiecity') \
    /set_go buy transport to ravenkall%; \
  /endif

/def -Fp5 -msimple -t'Cliff (se,w).' at_cliff = \
  /set_at cliff

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) vanishes into thin air\\.$' at_cliff_command = \
  /if (at =~ 'cliff' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go trace rixd%; \
  /endif

/def -Fp5 -msimple -t'Within the Abjurer\'s Guild (out).' at_abjurers_guild = \
  /set_at abjurers_guild

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) vanishes into a cloud of dust!$' at_abjurers_guild_command = \
  /if (at =~ 'abjurers_guild' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go press opal%; \
  /endif

/def -Fp5 -msimple -t'Within a dark tunnel of solid rock (e,sw).' at_dark_tunnel = \
  /set_at dark_tunnel

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) leaves into the tower of Abjurers\\.$' at_dark_tunnel_command = \
  /if (at =~ 'dark_tunnel' & (tolower({P1}) =~ commander | tolower({P1}) =~ tank)) \
    /set_go press opal%; \
  /endif
