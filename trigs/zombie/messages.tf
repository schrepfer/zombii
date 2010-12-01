;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; LOGGING TRIGGERS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-10-22 17:11:58 -0700 (Fri, 22 Oct 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/messages.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/messages.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]
/require lisp.tf

/set BOLD=1
/set CLEAR=2
/set TOP=4
/set RESET=8
/set BLINK=16
/set REVERSE=32
/set BLACK=64
/set RED=128
/set GREEN=256
/set YELLOW=512
/set BLUE=1024
/set MAGENTA=2048
/set CYAN=4096
/set WHITE=8192
/set DEFAULT=16384

/def ansi = \
  /let _result=%; \
  /while ({#}) \
    /if ({1} =~ 'bold') \
      /test _result := strcat(_result, '\033[1m')%; \
    /elseif ({1} =~ 'clear') \
      /test _result := strcat(_result, '\033[2J')%; \
    /elseif ({1} =~ 'underline') \
      /test _result := strcat(_result, '\033[4m')%; \
    /elseif ({1} =~ 'top') \
      /test _result := strcat(_result, '\033[0;0H')%; \
    /elseif ({1} =~ 'reset') \
      /test _result := strcat(_result, '\033[0m')%; \
    /elseif ({1} =~ 'blink') \
      /test _result := strcat(_result, '\033[5m')%; \
    /elseif ({1} =~ 'reverse') \
      /test _result := strcat(_result, '\033[7m')%; \
    /elseif ({1} =~ 'black') \
      /test _result := strcat(_result, '\033[30m')%; \
    /elseif ({1} =~ 'red') \
      /test _result := strcat(_result, '\033[31m')%; \
    /elseif ({1} =~ 'green') \
      /test _result := strcat(_result, '\033[32m')%; \
    /elseif ({1} =~ 'yellow') \
      /test _result := strcat(_result, '\033[33m')%; \
    /elseif ({1} =~ 'blue') \
      /test _result := strcat(_result, '\033[34m')%; \
    /elseif ({1} =~ 'magenta') \
      /test _result := strcat(_result, '\033[35m')%; \
    /elseif ({1} =~ 'cyan') \
      /test _result := strcat(_result, '\033[36m')%; \
    /elseif ({1} =~ 'white') \
      /test _result := strcat(_result, '\033[37m')%; \
    /elseif ({1} =~ 'default') \
      /test _result := strcat(_result, '\033[39m')%; \
    /endif%; \
    /shift%; \
  /done%; \
  /result _result


/def do_log = \
  /if (log_stream > 0) \
    /test tfwrite(log_stream, strcat(ansi('reset'), '[', ansi('bold'), ftime('%%H:%%M:%%S'), ansi('reset'), '] ', {*}))%; \
  /endif

/def -Fp5 -msimple -h'SEND @on_enter_game' on_enter_game_messages = \
  /if (log_stream > 0) \
    /test tfwrite(log_stream, strcat(ansi('green'), '======== [ ', ansi('red'), ftime('%%F, %%H:%%M:%%S'), ansi('green'), ' ] ================================================', ansi('reset')))%; \
  /endif

/def log_hour = \
  /if (log_stream > 0) \
    /test tfwrite(log_stream, strcat(ansi('green'), '======== [ ', ansi('blue'), ftime('%%F, %%H:%%M:%%S'), ansi('green'), ' ] ================================================', ansi('reset')))%; \
    /let _hour=$[ftime('%H')+1]%; \
    /if (_hour > 23) \
      /let _hour=$[_hour - 24]%; \
    /endif%; \
    /if (!log_next | _hour != log_next) \
      /at %{_hour}:00:00 /log_hour%; \
      /set log_next=%{_hour}%; \
    /endif%; \
  /endif

/def start_log = \
  /if (log_stream > 0) \
    /test tfclose(log_stream)%; \
  /endif%; \
  /test log_stream := tfopen(logs_dir('messages'), 'a')%; \
  /log_hour

/def stop_log = \
  /if (log_stream > 0) \
    /test tfclose(log_stream)%; \
  /endif%; \
  /set log_stream=0

/start_log

/def -Fp10 -mregexp -t'^(([A-Z][a-z0-9-]+) (the toasted )?| |)?([\\[{<]([a-z]+)[>}\\]]:) (.*)$' log_channel = \
  /if ({P5} =~ 'party') \
    /let _color=blue%; \
  /elseif ({P5} =~ 'sales') \
    /let _color=yellow%; \
  /elseif ({P5} =~ 'inform' | {P5} =~ 'info') \
    /let _color=red%; \
  /elseif ({P5} =~ 'mud' | {P5} =~ 'chat' | {P5} =~ 'alert') \
    /let _color=green%; \
  /else \
    /let _color=cyan%; \
  /endif%; \
  /if ((!strlen(log_channels) | isin({P5}, log_channels)) & (!is_me({P2}) | log_self)) \
    /do_log %{P1}$[ansi('bold', _color)]%{P4}$[ansi('reset')] %{P6}%; \
  /endif

/property -g log_channels
/property -g ignore_commands
/property -b log_self

/def -Fp10 -mregexp -t'^You whisper to ' log_whisper_to = \
  /if ((!isin('whisper', ignore_commands)) & log_self) \
    /do_log $[ansi('yellow')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^(ghost of )?[A-Za-z]+ whispers to you ' log_whisper = \
  /if (!isin('whisper', ignore_commands)) \
    /do_log $[ansi('bold', 'yellow')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^You shout ' log_shout_to = \
  /if ((!isin('shout', ignore_commands)) & log_self) \
    /do_log %{*}%; \
  /endif

/def -Fp10 -mregexp -t'^([A-Za-z,-:\\\' ]+) shouts ' log_shout = \
  /if (!isin('shout', ignore_commands)) \
    /do_log $[ansi('bold')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^You emote ' log_emoteto_to = \
  /if ((!isin('emoteto', ignore_commands)) & log_self) \
    /do_log $[ansi('green')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^From afar, ([A-Z][a-z]+) ' log_emoteto = \
  /if (!isin('emoteto', ignore_commands)) \
    /do_log $[ansi('bold', 'green')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^You tell ' log_tell_to = \
  /if ((!isin('tell', ignore_commands)) & log_self) \
    /do_log $[ansi('green')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) tells you' log_tell = \
  /if (!isin('tell', ignore_commands)) \
    /do_log $[ansi('bold', 'green')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^You (say|ask) \'' log_say_to = \
  /if ((!isin('say', ignore_commands)) & log_self) \
    /do_log $[ansi('yellow')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) (says|asks) \'' log_say = \
  /if (!isin('say', ignore_commands)) \
    /do_log $[ansi('bold', 'yellow')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^You emote: ' log_emote_to = \
  /if ((!isin('emote', ignore_commands)) & log_self) \
    /do_log $[ansi('yellow')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^\\*([A-Z][a-z]+) ' log_emote = \
  /if (!isin('emote', ignore_commands)) \
    /do_log $[ansi('bold', 'yellow')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^You think . o O ' log_think_to = \
  /if ((!isin('think', ignore_commands)) & log_self) \
    /do_log $[ansi('yellow')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) . o O ' log_think = \
  /if (!isin('think', ignore_commands)) \
    /do_log $[ansi('bold', 'yellow')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^You throw an iron bell at ' log_bell_to = \
  /if (!isin('bell', ignore_commands) & log_self) \
    /do_log $[ansi('red')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) throws an iron bell at you\\.  KLING!!!$$' log_bell = \
  /if (!isin('bell', ignore_commands)) \
    /do_log $[ansi('bold', 'red')]%{*}$[ansi('reset')]%; \
  /endif

/def -Fp10 -mregexp -t'^\\[([A-Z][a-z]+)\\] transfered (\\d+) gold\\.$' log_transfer = \
  /if (!isin('transfer', ignore_commands)) \
    /do_log $[ansi('bold', 'red')]%{*}$[ansi('reset')]%; \
  /endif

;;
;; save settings
;;
/def -Fp5 -msimple -h'SEND @save' save_messages = /mapcar /listvar log_channels ignore_commands log_self %| /writefile $[save_dir('messages')]
/eval /load $[save_dir('messages')]
