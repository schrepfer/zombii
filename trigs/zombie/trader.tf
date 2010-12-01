;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; TRADER TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/trader.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/trader.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/set trader=1

/property -g booth_dirs
/property -g booth_dirs_back
/property -b bag
/property -b stuff_bag

/def summon_bag = /summon_bag_of_holding %{*}

/def -Fp5 -ag -mregexp -t'^There (is|are) (\\d+) \'bag of holding\'s? in your inventory\\.$' count_bag = \
  /set bag=%{P2}

/def csbooth = /run_path -d'$(/escape ' %{booth_dirs})' -b'boothcs'
/def boothcs = /run_path -d'$(/escape ' %{booth_dirs_back})'

; bank trigs
/def check_booth = \
  /if (strlen(booth_dirs) & strlen(booth_dirs_back)) \
    /csbooth%; \
    !check%; \
    !read log%; \
    /boothcs%; \
    /save_trader%; \
  /endif

/def cb = \
  /if (bag & p_cash > 0) \
    !put %{p_cash} gold in bag of holding%; \
  /endif%; \

/def -Fp5 -msimple -t'You summon forth a bag of holding.' summoned_bag = \
  /set bag=1%; \
  @update_status

/def -Fp5 -mregexp -t'^\| Balance :  *(\\d+) \|$' booth_check = \
  /set booth_current=%{P1}%; \
  /save_trader

/def -Fp5 -mregexp -t'^You deposit (\\d+) gold to your booth\\.$' booth_deposit = \
  /set booth_current=$[booth_current+{P1}]%; \
  /save_trader

/def -Fp5 -mregexp -t'^You withdraw (\\d+) gold from your booth\\.$' booth_withdraw = \
  /set booth_current=$[booth_current-{P1}]%; \
  /save_trader

/def -Fp5 -msimple -h'SEND @on_return_game' on_return_game_trader = \
  /send !count bag of holding

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_trader = \
  /set booth_last=%{booth_current}%; \
  /on_return_game_trader

/def -ag -msimple -t'You use your bargain skills to improve the value.' gag_bargain

/def bgp = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /execute %{_cmd} You have $[to_kmg(booth_current)] gold in your booth and have $[booth_current >= booth_last ? 'gained' : 'lost'] $[to_kmg(abs(booth_current - booth_last))] gold this session

;;
;; save settings
;;
/def -Fp5 -msimple -h'SEND @save' save_trader = /mapcar /listvar booth_current booth_dirs booth_dirs_back bag stuff_bag %| /writefile $[save_dir('trader')]
/eval /load $[save_dir('trader')]

/test booth_last := booth_last ? booth_last : booth_current
