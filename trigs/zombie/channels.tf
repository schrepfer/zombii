;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CHANNELS TO MACROS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-08 18:06:03 -0700 (Wed, 08 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/channels.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/channels.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def add_channels_send = \
  /if ({#}) \
    /def -p5 -mglob -h'SEND %{1} *' channels_send_%{1} = !channels send %{1} %%{-1}%; \
  /endif

/def -Fp5 -mregexp -t'^\\| ([a-z]*) +\\[.\\]\\| ([a-z]*) +\\[.\\]\\| ([a-z]*) +\\[.\\]\\| ([a-z]*) +\\[.\\]\\|$' add_channels = \
  /add_channels_send %{P1}%; \
  /add_channels_send %{P2}%; \
  /add_channels_send %{P3}%; \
  /add_channels_send %{P4}
