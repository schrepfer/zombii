;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CHEST PICKING TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/picking.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://maddcow.us:65530/projects/ZombiiTF/zombii/trigs/zombie/picking.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/test combos_file := strlen(combos_file) ? combos_file : 'combos'

;;
;; LOAD COMBOS
;;
;; Opens a new strema of combos from FILE.
;;
;; Usage: /load_combos [FILE]
;;
/def load_combos = \
  /let _file=%{*-%{combos_file}}%; \
  /let _stream=$[tfopen(files_dir(strcat(combos_file, '.txt')), 'r')]%; \
  /if (_stream > 0) \
    /if (combos_stream > 0) \
      /test tfclose(combos_stream)%; \
      /say -d'status' -- Closed stream identified by: %{combos_stream}%; \
    /endif%; \
    /set combos_file=%{_file}%; \
    /set combos_stream=%{_stream}%; \
    /set combos_count=0%; \
    /unset combos_next%; \
    /unset combos_prev%; \
    /say -d'status' -- Successfully loaded combos: %{combos_file}%; \
    /load_next_combo%; \
  /else \
    /error -m'load_combos' -- failed to load combos: %{combos_file}%; \
  /endif%; \
  @update_status

;;
;; CLOSE COMBOS
;;
;; Closes the currently opened stream of combos.
;;
;; Usage: /close_combos
;;
/def close_combos = \
  /if (combos_stream > 0) \
    /test tfclose(combos_stream)%; \
    /say -d'status' -- Closed stream identified by: %{combos_stream}%; \
    /set combos_stream=0%; \
    /set combos_count=0%; \
    /unset combos_next%; \
    /unset combos_prev%; \
  /else \
    /error -m'close_combos' -- no open streams%; \
  /endif%; \

;;
;; LOAD NEXT COMBO
;;
;; Loads the next combination from the file.
;;
;; Usage: /load_next_combo [NUMBER]
;;
/def lnc = /load_next_combo %{*}
/def load_next_combo = \
  /if (combos_stream > 0) \
    /let _count=$[min(max({1}, 1), 1000)]%; \
    /let _bytes=0%; \
    /for i 1 %{_count} \
      /set combos_prev=%%{combos_next}%%; \
      /test _bytes := tfread(combos_stream, combos_next)%; \
    /set combos_count=$[combos_count + _count]%; \
    /if (_bytes < 1) \
      /unset combos_next%; \
    /endif%; \
    @update_status%; \
  /endif

;;
;; PICK
;;
;; The control in picking CHESTS. This macro is called to start, stop, and 
;; continue with the picking of chests.
;;
;; Usage: /pick [OPTIONS] -- [CHESTS]
;;
;;  OPTIONS:
;;
;;   -s            This flag starts the picking and uses CHESTS
;;   -x            This disables the picking
;;   -n            This picks with the next combo in the list
;;   -p            This picks with the previously used combination/chest
;;   -q            Run the commands in quiet mode (to be called from by timer)
;;
/def pick = \
  /if (!getopts('sxpnq', '')) \
    /return%; \
  /endif%; \
  /if (opt_x) \
    /set picking=0%; \
    /if (!opt_q) \
      /say -d'status' -- Picking has ended%; \
    /endif%; \
  /elseif (opt_s) \
    /set pick_chests=%{*-%{pick_chests}}%; \
    /if (!strlen(pick_chests)) \
      /error -m'pick' -a's' -- it's required that you enter chests to pick%; \
      /return%; \
    /endif%; \
    /set picking=1%; \
    /set pick_next=%{pick_chests}%; \
  /elseif (opt_p) \
    /set picking=1%; \
    /set pick_next=$(/unique %{pick_current} %{pick_next})%; \
  /elseif (opt_n) \
    /set picking=1%; \
  /else \
    /if (!opt_q) \
      /say -d'status' -- Picking is currently $[picking ? 'running' : 'disabled']%; \
    /endif%; \
    /return%; \
  /endif%; \
  /kill pick_pid%; \
  /if (!picking) \
    /return%; \
  /endif%; \
  /if (!strlen(combos_next)) \
    /error -m'pick' -- no combos have been loaded (see: /load_combos)%; \
    /return%; \
  /endif%; \
  /if (!opt_q) \
    /say -d'status' -- Picking (chests: $[join(pick_chests, '/')], next: $[join(pick_next, '/')], combo: %{combos_next})%; \
  /endif%; \
  /if (strlen(pick_next)) \
    /set pick_current=$(/first %{pick_next})%; \
    /set pick_next=$(/rest %{pick_next})%; \
    !turn chest %{pick_current} to %{combos_next}%; \
    /timer -t1 -n1 -p'pick_pid' -- /pick -x%; \
  /elseif (strlen(pick_chests)) \
    /set pick_current=%; \
    /set pick_next=%{pick_chests}%; \
    /load_next_combo%; \
    /if (strlen(combos_next)) \
      /let _wait=$[max(10, trunc(145 / $(/length %{pick_chests})))]%; \
      /timer -t$[min(1, _wait)] -n1 -p'pick_pid' -- /pick -n -q%; \
      /say -d'status' -- New combo loaded (number: %{combos_count}, combo: %{combos_next})%; \
    /endif%; \
  /else \
    /set picking=0%; \
    /say -d'status' -- All chests have been picked (see: /pick -s <chests>)%; \
  /endif

/def -Fp2 -mregexp -h'SEND ^!?turn chest ((.+) )?to (\\d+)' do_turn_chest = \
  /set chest_turn_name=%{P2-1}%; \
  /set chest_turn_combo=%{P3}

/def -Fp5 -mglob -h'SEND unlock {chest}*' do_unlock_chest = \
  /set chest_turn_name=%{-2-1}%; \
  /unset chest_turn_combo

/def -Fp5 -msimple -t'You start operating the lock.' pick_operating_lock = \
  /if (strlen(pick_current) & picking) \
    /timer -t15 -n1 -p'pick_pid' -k -- /pick -x%; \
    /if (strlen(chest_turn_name)) \
      /substitute -p -- @{B}[%{chest_turn_name}]@{n} %{*}%; \
    /endif%; \
  /endif

/def -Fp5 -msimple -t'The chest self-locked itself!' pick_wrong_0 = \
  /if (strlen(pick_current) & picking) \
    /timer -t15 -n1 -p'pick_pid' -k -- /pick -n -q%; \
    /if (strlen(chest_turn_name)) \
      /substitute -p -- @{B}[%{chest_turn_name}]@{n} %{*} [%{chest_turn_combo-??}]%; \
    /endif%; \
  /endif

/def -Fp5 -msimple -t'Your abilities in picking locks prevents the lock from jamming.' pick_wrong_1 = /pick_wrong_0 %{*}

/def -Fp5 -msimple -t'The combination mechanism clicks as it unlocks.' pick_unlocks = \
  /if (strlen(pick_current) & picking) \
    !open chest %{pick_current}%; \
    /set pick_chests=$(/remove %{pick_current} %{pick_chests})%; \
    /timer -t1 -n1 -p'pick_pid' -k -- /pick -n -q%; \
    /if (strlen(chest_turn_name)) \
      /substitute -p -- @{B}[%{chest_turn_name}]@{n} %{*} [%{chest_turn_combo-??}]%; \
    /endif%; \
  /endif

/def -Fp5 -msimple -t'The lock is jammed..wait a while.' pick_wait = \
  /if (strlen(pick_current) & picking) \
    /set pick_next=$(/unique %{pick_next} %{pick_current})%; \
    /set pick_current=%; \
    /let _wait=$[max(10, trunc(145 / $(/length %{pick_chests})))]%; \
    /timer -t%{_wait} -n1 -p'pick_pid' -k -- /pick -n -q%; \
    /if (strlen(chest_turn_name)) \
      /substitute -p -- @{B}[%{chest_turn_name}]@{n} %{*} [Sleeping $[to_dhms(_wait)]]%; \
    /endif%; \
  /endif

/def -Fp5 -mregexp -t'^You turn chest to: ' pick_turn = \
  /if (strlen(pick_current) & picking & strlen(chest_turn_name)) \
    /substitute -p -- @{B}[%{chest_turn_name}]@{n} %{*}%; \
  /endif
