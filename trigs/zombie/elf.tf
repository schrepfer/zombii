;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ELF
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/elf.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/elf.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]


/def cseliendien = /run_path -d'20 e;20 se;12 se;20 e;20 e;20 e;20 e;11 e;enter' -b'eliendiencs'
/def eliendiencs = /run_path -d's;11 w;20 w;20 w;20 w;20 w;12 nw;20 nw;20 w'

; Adanessa nods and reaches into the basket of wild kittens, pulling one out.
; You ask Adanessa about adopting a young animal.
; You ask Minuialwen about adopting a young animal.
; Adanessa pats you on the head while pointing at Aranel.

/def -Fp5 -msimple -h'SEND @on_leave_game' on_leave_game_elf = \
  /kill fenn_ram_pid

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_elf = \
  /kill fenn_ram_pid%; \

/test fenn_ram_cooldown := trunc(6:00:00)

/def -Fp5 -msimple -t'You feel weary, yet proud as you end the ritual and rise, knowing your homeland is safe.' fenn_ram_start = \
  /timer -t%{fenn_ram_cooldown} -n1 -p'fenn_ram_pid' -k -- /fenn_ram_ready

/def fenn_ram_ready = \
  /say -d'status' -- It is time to go back to Eliendien and cast Fenn Ram!

/def -Fp5 -mglob -t'You ask * about adopting a young animal.' elf_adopt_pet

/def -Fp5 -aBCwhite,Cbggreen -msimple -t'The great forest looks weary here, as though in desperate need of care.' urgent_need_of_care
