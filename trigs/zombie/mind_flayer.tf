;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MIND_FLAYER
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-15 18:17:22 -0700 (Fri, 15 Oct 2010) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/mind_flayer.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/mind_flayer.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def mconsume = !mconsume %{*-%{target}}

; Psycapsulation
; Subjugate
; Energize Seal
; Shadow Shift
; Mind Blast
; Astral Traverse

/def ss = /shadow_shift %{*}

/def to_pod = /run_path -d'open door;enter;la symbols;fly up;open pod;enter pod;close pod' -b'fr_pod'
/def fr_pod = /run_path -d'open pod;exit pod;close pod;fly down;out;close door'

/def scan_neos = /scan_neothelids %{*}
/def scan_neothelids = /run_path -d'n;ne;5 walk up;3 n;nw;n;sw;w;s;w;se;e;ne;2 s;se;5 d;e;s;e;nw;w;walk down;sw;s'

/def cuu = /call_upon_unity %{*}
/def es = /energize_seal %{*}
/def mbl = /mind_blast %{*}
/def msc = /mindscream %{*}

/def -Fp5 -msimple -t'A fading note briefly sounds in your mind as you recover from the ' mindscream_reloaded = \
  /say -d'party' -x -c'green' -- Mindscream Reloaded!

/def -Fp5 -msimple -t'There is a slight tingle in your mind as you recover from your ' mind_blast_ready = \
  /say -d'party' -x -c'green' -- Mind Blast Reloaded!

/def -Fp5 -msimple -t'You have fully digested the previous ingestion of brainmatter.' mconsume_ready = \
  /say -d'party' -x -c'green' -- Ready to Consume!

/def -Fp5 -mglob -t'Satisfied, you let go of *.' mconsume_done = /kx
