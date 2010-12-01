;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CHANNELS TO MACROS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-08-20 13:59:19 -0700 (Fri, 20 Aug 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/channels.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/channels.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/def add_channels_send = \
  /if ({#}) \
    /def -p5 -mglob -h'SEND %{1} *' channels_send_%{1} = !channels send %{1} %%{-1}%; \
  /endif

/def -Fp5 -mregexp -t'^\\| ([a-z]*) +(\\[.\\])?\\| ([a-z]*) +(\\[.\\])?\\| ([a-z]*) +(\\[.\\])?\\| ([a-z]*) +(\\[.\\])?\\|$' add_channels = \
  /add_channels_send %{P1}%; \
  /add_channels_send %{P3}%; \
  /add_channels_send %{P5}%; \
  /add_channels_send %{P7}
