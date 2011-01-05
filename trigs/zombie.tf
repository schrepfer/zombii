;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BASIC ZOMBIEMUD TRIGGERS
;;
;; This file contains the base for Conglomo's tf/zombie trigs. Most of the
;; helper functions, macros, and triggers are contained within this file.
;; Specialized macros should be created in separate files.
;;
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-01-04 18:54:19 -0800 (Tue, 04 Jan 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie.tf $', 10, -2)]

/test version := substr('$LastChangedRevision: 1482 $', 22, -2)

/require textutil.tf
/require lisp.tf
/python import mail
/python reload(mail)
/python import util
/python reload(util)
/python import zombie.effects
/python reload(zombie.effects)
/python import zombie.runs
/python reload(zombie.runs)

;;
;; Basic MUD variable
;;
/set MUD=zombie

;;
;; RELOAD
;;
;; Purge all of the non-invisible triggers, macros, hooks and then reload the
;; main script-- either as parameter or from previous reload.
;;
;; Usage: /reload SCRIPT
;;
/def -i reload = \
  /if ({#} | strlen(_script) | strlen(world_info('name'))) \
    /set _script=%{*-%{_script-$[strcat(world_info('name'), '.tf')]}}%; \
    /purge%; \
    /load %{HOME}/.tfrc%; \
    /load %{_script}%; \
  /endif

;;
;; VERSION
;;
/def version = \
  /@version%; \
  /_echo % $(/zver)

/def zver = /_echo Conglomo's Zombii Trigs v1.0.%{version}

;;
;; TELL/COMMUNICATION BLOCKS
;;
;; This set of triggeres should catch most triggers before they accidentally set
;; off others that actually have some meaning.
;;

/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?You think . o O ' you_think
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?[A-Z][a-z]+ . o O ' somebody_thinks
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?You say \'' you_say
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?[A-Z][a-z]+ says \'' somebody_says
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?You emote: ' you_emote
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?\\*[A-Z][a-z]+ ' somebody_emotes
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?You emote \'' you_emote_to
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?From afar, [A-Z][a-z]+ ' somebody_emotes_to
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?([A-Z][a-z]+ (the toasted )?)?[\\[{<][a-z]+[>}\\]]: ' somebody_channels
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?You whisper to ' you_whisper
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?([A-Z][a-z]+|ghost of [a-z]+) whispers to you \'' somebody_whispers
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?You tell ' you_tell
/def -p9 -mregexp -t'^(\\d{2}:\\d{2} )?[A-Z][a-z]+ tells you,? ' somebody_tells
/def -p9 -mregexp -t'^>' somebodys_plan

;;
;; TRIM
;;
;; Trim's spaces from both ends of the given string.
;;
;; Usage: /trim STRING
;;        trim(STRING)
;;
/def trim = /result $$(/_echo %%{*})

;;
;; GENERATE GETOPTS
;;
;; Given the string of CHARS return a string of what the getopt would look
;; like.
;;
;; Usage: /gen_getopts CHARS
;;
/def gen_getopts = \
  /let _output=%; \
  /let _pool=%{1}%; \
  /while (strlen(_pool)) \
    /let _char=$[substr(_pool, 0, 1)]%; \
    /let _pool=$[substr(_pool, 1)]%; \
    /let _value=$[expr(strcat('opt_', _char))]%; \
    /if (_value) \
      /let _output=$[strcat(_output, ' -', _char)]%; \
    /endif%; \
  /done%; \
  /return trim(_output)

;;
;; UPDATE VALUE
;;
;; This macro updates the value of variables in a standard way.
;;
;; Usage: /update_value [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -b            Interpret the value as a boolean
;;   -c            Clear the value of the variable
;;   -f            Interpret the value as a float
;;   -g            Use the /grab macro to make command editable
;;   -i            Interpret the value as an integer
;;   -n NAME*      The name of the variable to update
;;   -p NAME       The proper name (if different) to echo
;;   -s            Use istrue() to clear variables that match false
;;   -t            Interpret the value as time
;;   -v VALUE      The value to give the variable
;;
/def update_value = \
  /if (!getopts('n:v:p:sbtifcg', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_n)) \
    /error -m'%{0}' -a'n' -- required attribute%; \
    /return%; \
  /endif%; \
  /let opt_v=$[strip_attr(opt_v)]%; \
  /if (opt_c | strlen(opt_v)) \
    /if (opt_c) \
      /let opt_v=%; \
    /endif%; \
    /if (opt_b) \
      /test %{opt_n} := opt_v ? 1 : 0%; \
    /elseif (opt_f) \
      /test %{opt_n} := round(abs(opt_v), 2)%; \
    /elseif (opt_i | opt_t) \
      /test %{opt_n} := trunc(abs(opt_v))%; \
    /elseif (opt_s & !istrue(opt_v)) \
      /set %{opt_n}=%; \
    /else \
      /test %{opt_n} := opt_v%; \
    /endif%; \
  /elseif (opt_b) \
    /test %{opt_n} := !expr(opt_n)%; \
  /endif%; \
  /print_value -n'$(/escape ' %{opt_n})' -p'$(/escape ' %{opt_p})' $[gen_getopts('btifg')]%; \
  @update_status

;;
;; PROPERTY
;;
;; Defines a setter with the NAME and variable.
;;
;; Usage: /property NAME -- [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -b            Interpret the value as a boolean
;;   -f            Interpret the value as a float
;;   -g            Use the /grab macro to make command editable
;;   -i            Interpret the value as an integer
;;   -s            Use istrue() to clear variables that match false
;;   -t            Interpret the value as time
;;   -v            Default value for this property
;;
/def property = \
  /if (!getopts('sbtifgv:', '') | !{#}) \
    /return%; \
  /endif%; \
  /let _macro=%{1}%; \
  /if (opt_b) \
    /test %{_macro} := opt_v ? 1 : 0%; \
  /elseif (opt_f) \
    /test %{_macro} := round(abs(opt_v), 2)%; \
  /elseif (opt_i | opt_t) \
    /test %{_macro} := trunc(abs(opt_v))%; \
  /else \
    /test %{_macro} := opt_v%; \
  /endif%; \
  /def %{_macro} = /update_value -n'$(/escape ' %{_macro})' -v'$$(/escape ' %%{*})' $[gen_getopts('sbtifg')]

;;
;; PRINT VALUE
;;
;; Prints the value of a variable in a standard way.
;;
;; Usage: /print_value [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -b            Print the value as a boolean
;;   -g            Grab the command back to the command line
;;   -i            Print the value as a float
;;   -i            Print the value as an integer
;;   -n NAME       The name of the variable to be printed
;;   -p NAME       The proper name (if different) to echo
;;   -t            Print the value as a time
;;   -v VALUE      Ignore the variable and use this value
;;
/def print_value = \
  /if (!getopts('n:p:btifv:g', '')) \
    /return%; \
  /endif%; \
  /if (strlen(opt_n)) \
    /let _value=$[expr(opt_n)]%; \
    /if (opt_g & strlen(_value)) \
      /grab /%{opt_n} %{_value}%; \
    /endif%; \
  /elseif (strlen(opt_v)) \
    /if (!strlen(opt_p)) \
      /error -m'%{0}' -a'v' -- -p is required%; \
      /return%; \
    /endif%; \
    /let _value=%{opt_v}%; \
  /else \
    /error -m'%{0}' -- either -v or -n are required%; \
    /return%; \
  /endif%; \
  /let _name={%{opt_p-$[replace('_', ' ', opt_n)]}}%; \
  /if (opt_b) \
    /say -d'status' -f'$[bool(_value)]' -- %{_name}%; \
  /elseif (opt_t) \
    /say -d'status' -f'$[to_dhms(_value)]' -- %{_name}%; \
  /elseif (opt_i) \
    /say -d'status' -f'$[trunc(_value)]' -- %{_name}%; \
  /elseif (opt_f) \
    /say -d'status' -f'$[round(_value, 2)]' -- %{_name}%; \
  /else \
    /say -d'status' -f'$(/escape ' $[strlen(_value) ? _value : "??"])' -- %{_name}%; \
  /endif

;;
;; ANNOUNCE CONSTANTS AND VARIABLES
;;

/def is_announce = /result isin({*}, 'default', 'echo', 'emote', 'other', 'party', 'say', 'status', 'think')

;;
;; DO ANNOUNCE
;;
;; The main trig interface to displaying messages. This macro will announce
;; the MESSAGE to the default medium unless otherwise specified. Will also
;; only delegate to the other announce_to macros when {announce} is true or
;; otherwise forced.
;;
;; Usage: /do_announce [OPTIONS] -- MESSAGE
;;
;;  OPTIONS:
;;
;;   -a            Announce regardless of the {announce} var's setting
;;   -b            Do not print customized brackets (party)
;;   -c COLOR      Prints the message with the color given
;;   -d DEST       The destination of the message. Without this it uses the
;;                 {announce_to} variable.
;;   -f FLAG       Prints a status for the message using separator
;;   -m            Only send messages to party IF there's more than one member (party)
;;   -n REPEATS    Number of times to repeat the message
;;   -t            Send messages if and only if you are the tank (party)
;;   -x            Never send messages to status when other channel fails
;;
/def say = /do_announce %{*}
/def do_announce = \
  /if (!getopts('abc:d:f:mn#tx', '') | !{#} | (opt_t & !is_me(tank))) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_d) | opt_d =~ 'default') \
    /let opt_d=%{announce_to}%; \
  /endif%; \
  /if (!quiet_mode & !is_away() & (party_members > 1 | !opt_m) & (announce | opt_a)) \
    /let _repeats=$[{opt_n-1} == 1 ? '' : strcat(opt_n, ' ')]%; \
    /if (opt_d =~ 'echo') \
      /if (strlen(opt_f)) \
        !%{_repeats}echo %{announce_echo_l}%{*}%{announce_echo_s}%{opt_f}%{announce_echo_r}%; \
      /else \
        !%{_repeats}echo %{announce_echo_l}%{*}%{announce_echo_r}%; \
      /endif%; \
      /return%; \
    /endif%; \
    /if (opt_d =~ 'emote') \
      /if (strlen(opt_f)) \
        !%{_repeats}emote %{announce_emote_l}%{*}%{announce_emote_s}%{opt_f}%{announce_emote_r}%; \
      /else \
        !%{_repeats}emote %{announce_emote_l}%{*}%{announce_emote_r}%; \
      /endif%; \
      /return%; \
    /endif%; \
    /if (opt_d =~ 'other') \
      /if (strlen(opt_f)) \
        !%{_repeats}%{announce_other_command} %{announce_other_l}%{*}%{announce_other_s}%{opt_f}%{announce_other_r}%; \
      /else \
        !%{_repeats}%{announce_other_command} %{announce_other_l}%{*}%{announce_other_r}%; \
      /endif%; \
      /return%; \
    /endif%; \
    /if (opt_d =~ 'party' & party_members) \
      /if (strlen(opt_c) & is_me(commander)) \
        /let _color=$[strcat(toupper(opt_c), '_COLOUR ')]%; \
      /else \
        /let _color=%; \
      /endif%; \
      /if (strlen(aide) & is_me(aide)) \
        /let _party_say=aide say%; \
      /else \
        /let _party_say=party say%; \
      /endif%; \
      /if (opt_b) \
        /if (strlen(opt_f)) \
          !%{_repeats}%{_party_say} %{_color}%{*}%{announce_party_s}%{opt_f}%; \
        /else \
          !%{_repeats}%{_party_say} %{_color}%{*}%; \
        /endif%; \
        /return%; \
      /endif%; \
      /if (strlen(opt_f)) \
        !%{_repeats}%{_party_say} %{_color}%{announce_party_l}%{*}%{announce_party_s}%{opt_f}%{announce_party_r}%; \
      /else \
        !%{_repeats}%{_party_say} %{_color}%{announce_party_l}%{*}%{announce_party_r}%; \
      /endif%; \
      /return%; \
    /endif%; \
    /if (opt_d =~ 'say') \
      /if (strlen(opt_f)) \
        !%{_repeats}say %{announce_say_l}%{*}%{announce_say_s}%{opt_f}%{announce_say_r}%; \
      /else \
        !%{_repeats}say %{announce_say_l}%{*}%{announce_say_r}%; \
      /endif%; \
      /return%; \
    /endif%; \
    /if (opt_d =~ 'think') \
      /if (strlen(opt_f)) \
        !%{_repeats}think %{announce_think_l}%{*}%{announce_think_s}%{opt_f}%{announce_think_r}%; \
      /else \
        !%{_repeats}think %{announce_think_l}%{*}%{announce_think_r}%; \
      /endif%; \
      /return%; \
    /endif%; \
  /endif%; \
  /if (!opt_x) \
    /if (strlen(opt_c)) \
      /let _attr=C%{opt_c}%; \
    /else \
      /let _attr=%{echo_attr}%; \
    /endif%; \
    /if (strlen(opt_f)) \
      /let _cmd=/echo -w -a%{_attr} -p -- %{prefix} @{B}%{announce_status_l}%{*}@{n}%{announce_status_s}@{B}%{opt_f}%{announce_status_r}%{n}%; \
    /else \
      /let _cmd=/echo -w -a%{_attr} -p -- %{prefix} @{B}%{announce_status_l}%{*}%{announce_status_r}%{n}%; \
    /endif%; \
    /repeat -S %{opt_n-1} /eval -s0 %%{_cmd}%; \
    /return%; \
  /endif

/property -b announce

;;
;; ANNOUNCE TO
;;
;; Changes where the {announce_to} variable sends messages. Without a
;; DESTINATION it will cycle through all of the known destinations. You can
;; also supply your own.
;;
;; Usage: /announce_to [DESTINATION]
;;
/def announce_to = \
  /if ({#} & !isin({*}, 'echo', 'emote', 'other', 'party', 'say', 'status', 'think')) \
    /error -m'%{0}' -- must be one of: echo, emote, other, party, say, status, think%; \
    /update_value -n'announce_to' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'announce_to' -v'$(/escape ' %{*})' -g

/set announce_to=party

/test announce_echo_l := '% '
/test announce_echo_s := ' --> '
/test announce_echo_r := ''

/test announce_emote_l := '## '
/test announce_emote_s := ' --> '
/test announce_emote_r := ''

/test announce_other_l := ''
/test announce_other_s := ' --> '
/test announce_other_r := ''

/test announce_party_l := ''
/test announce_party_s := ' --> '
/test announce_party_r := ''

/test announce_say_l := ''
/test announce_say_s := ' --> '
/test announce_say_r := ''

/test announce_status_l := ''
/test announce_status_s := ' --> '
/test announce_status_r := ''

/test announce_think_l := ''
/test announce_think_s := ' --> '
/test announce_think_r := ''

;;
;; ANNOUNCE OTHER COMMAND
;;
;; Updates the value of the {announce_other_command}.
;;
;; Usage: /announce_other_command [VALUE]
;;
/property -g announce_other_command

;;
;; PRINT BRACKETS
;;
;; Prints an example of all the brackets. Optionally prints them to specified
;; DESTINATION.
;;
;; Usage: /print_brackets [DESTINATION]
;;
/def print_brackets = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen -- %{prefix}%; \
  /endif%; \
  /execute %{_cmd} echo:%; \
  /execute %{_cmd}   left='%{announce_echo_l}'%; \
  /execute %{_cmd}   separator='%{announce_echo_s}'%; \
  /execute %{_cmd}   right='%{announce_echo_r}'%; \
  /execute %{_cmd} emote:%; \
  /execute %{_cmd}   left='%{announce_emote_l}'%; \
  /execute %{_cmd}   separator='%{announce_emote_s}'%; \
  /execute %{_cmd}   right='%{announce_emote_r}'%; \
  /execute %{_cmd} other [%{announce_other_command}]:%; \
  /execute %{_cmd}   left='%{announce_other_l}'%; \
  /execute %{_cmd}   separator='%{announce_other_s}'%; \
  /execute %{_cmd}   right='%{announce_other_r}'%; \
  /execute %{_cmd} party:%; \
  /execute %{_cmd}   left='%{announce_party_l}'%; \
  /execute %{_cmd}   separator='%{announce_party_s}'%; \
  /execute %{_cmd}   right='%{announce_party_r}'%; \
  /execute %{_cmd} say:%; \
  /execute %{_cmd}   left='%{announce_say_l}'%; \
  /execute %{_cmd}   separator='%{announce_say_s}'%; \
  /execute %{_cmd}   right='%{announce_say_r}'%; \
  /execute %{_cmd} status:%; \
  /execute %{_cmd}   left='%{announce_status_l}'%; \
  /execute %{_cmd}   separator='%{announce_status_s}'%; \
  /execute %{_cmd}   right='%{announce_status_r}'%; \
  /execute %{_cmd} think:%; \
  /execute %{_cmd}   left='%{announce_think_l}'%; \
  /execute %{_cmd}   separator='%{announce_think_s}'%; \
  /execute %{_cmd}   right='%{announce_think_r}'%; \
  /save_basic

;;
;; TEST BRACKETS
;;
;; Prints out a smell test with the brackets.
;;
;; Usage: /test_brackets
;;
/def test_brackets = \
  /say -d'status' -- status%; \
  /say -d'status' -f'???' -- status%; \
  /say -d'echo' -- echo%; \
  /say -d'echo' -f'???' -- echo%; \
  /say -d'emote' -- emote%; \
  /say -d'emote' -f'???' -- emote%; \
  /say -d'other' -- other%; \
  /say -d'other' -f'???' -- other%; \
  /say -d'party' -- party%; \
  /say -d'party' -f'???' -- party%; \
  /say -d'say' -- say%; \
  /say -d'say' -f'???' -- say%; \
  /say -d'think' -- think%; \
  /say -d'think' -f'???' -- think

;;
;; ERROR
;;
;; Prints out the error to screen in a standard format.
;;
;; Usage: /error [OPTIONS] -- MESSAGE
;;
;;  OPTIONS:
;;
;;   -a ARGUMENT   The argument that caused this error.
;;   -m MACRO      The macro which caused this error
;;
/def error = \
  /if (!getopts('m:a:') | !{#}) \
    /return%; \
  /endif%; \
  /let _message=%{*}%; \
  /if (strlen(opt_m)) \
    /if (strlen(opt_a)) \
      /let _message=-%{opt_a}: %{_message}%; \
    /endif%; \
    /let _message=%{opt_m}: %{_message}%; \
  /endif%; \
  /echo -w -a%{error_attr} -p -- %{prefix} @{B}error:@{n} %{_message}

;;
;; IGNORE MOVEMENT
;;
;; Toggles {ignore_movement} and sends that action to the mud.
;;
;; Usage: /ignore_movement [VALUE]
;;
/def ignore_movement = \
  /update_value -n'ignore_movement' -v'$(/escape ' %{*})' -b%; \
  /if (ignore_movement) \
    !ignore -m on%; \
  /else \
    !ignore -m off%; \
  /endif

;;
;; TANK/COMMANDER
;;

/def me = /result strlen(me) ? me : world_info('character')
/def is_me = /result tolower({1}) =~ tolower(me())

;;
;; UPDATE STATUS HOOKS
;;

/mapcar /status_rm @world @read @active @log @mail insert kbnum @clock

;;
;; ALIGN
;;
;; Returns the STRING align in an int form.
;;
;; Usage: /align STRING
;;
/def align = \
  /let _align=$[tolower({*})]%; \
  /if (_align =~ 'satanic') \
    /result -6%; \
  /elseif (_align =~ 'demonic') \
    /result -5%; \
  /elseif (_align =~ 'extremely evil') \
    /result -4%; \
  /elseif (_align =~ 'very evil') \
    /result -3%; \
  /elseif (_align =~ 'evil') \
    /result -2%; \
  /elseif (_align =~ 'slightly evil') \
    /result -1%; \
  /elseif (_align =~ 'slightly good') \
    /result 1%; \
  /elseif (_align =~ 'good') \
    /result 2%; \
  /elseif (_align =~ 'very good') \
    /result 3%; \
  /elseif (_align =~ 'extremely good') \
    /result 4%; \
  /elseif (_align =~ 'angelic') \
    /result 5%; \
  /elseif (_align =~ 'godly') \
    /result 6%; \
  /else \
    /result 0%; \
  /endif

;;
;; Prompt
;;
/def -Fp5 -agL -mregexp -t'^p: (-?\\d+) (-?\\d+) (-?\\d+) (-?\\d+) (-?\\d+) (-?\\d+) (-?\\d+) (-?\\d+) (-?\\d+) "([^"]*)" "([^"]*)" (.*)$' update_prompt = \
  /set status_prompt=1%; \
  /set p_hp=%{P1}%; \
  /set p_maxhp=%{P2}%; \
  /set p_sp=%{P3}%; \
  /set p_maxsp=%{P4}%; \
  /set p_exp=%{P5}%; \
  /set p_cash=%{P6}%; \
  /let _rooms=$[{P7} - p_expl]%; \
  /if (_rooms) \
    /say -- Found %{_rooms} New Room$[_rooms == 1 ? '' : 's']%; \
  /endif%; \
  /set p_expl=%{P7}%; \
  /set p_wgt=%{P8}%; \
  /set p_last_exp=%{P9}%; \
  /set p_scan=%{P10}%; \
  /set p_align=$[align({P11})]%; \
  /set p_party=%{P12}%; \
  /if (regmatch('^([A-Za-z,:\' -]+) is in (good shape)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_good_shape} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z,:\' -]+) is (slightly hurt)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_slightly_hurt} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z,:\' -]+) is (moderately hurt)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_moderately_hurt} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z,:\' -]+) is (not in a good shape)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_not_in_a_good_shape} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z,:\' -]+) is in (bad shape)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_bad_shape} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z,:\' -]+) is in (very bad shape)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_very_bad_shape} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z,:\' -]+) is (almost DEAD)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_almost_dead} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z,:\' -]+) is (DEAD MEAT)!$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_dead_meat} -d'$(/escape ' $[toupper({P2})])'%; \
  /endif%; \
  /if (!strlen(aide) | !is_me(aide)) \
    /if (regmatch('^@?<(\\d*)>$$', p_party)) \
      /set party_members=$[strlen({P1})]%; \
    /else \
      /set party_members=0%; \
    /endif%; \
    /if (party_members < 2) \
      /test tank := me()%; \
    /endif%; \
  /endif%; \
  @update_status

;;
;; exp command
;;
/def -Fp5 -mregexp -t'^Exp: (-?\\d+) \\([+-]?(\\d+)\\) Money: \\(in pocket: (\\d*\\.\\d+)\\) \\(in bank: (\\d*\\.\\d+)\\)$' update_prompt_exp = \
  /set p_exp=%{P1}%; \
  /set p_last_exp=%{P2}%; \
  /set p_cash=%{P3}%; \
  /set p_bank=%{P4}%; \
  @update_status

;;
;; old score
;;
/def -Fp5 -mregexp -t'^EXP: (\\d+) MONEY: (\\d*\\.\\d+) \\(Bank: (\\d*\\.\\d+)\\)  Level: (\\d+) TP: (\\d+)$' update_prompt_score_old  = \
  /set p_exp=%{P1}%; \
  /set p_cash=%{P2}%; \
  /set p_bank=%{P3}%; \
  /set p_level=%{P4}%; \
  /set p_tp=%{P5}%; \
  @update_status

;;
;; score report
;;
/def -Fp6 -mregexp -t'^hp: (-?\\d+)\\((\\d+)\\) sp: (-?\\d+)\\((\\d+)\\)$' update_prompt_score_report = \
  /set p_hp=%{P1}%; \
  /set p_maxhp=%{P2}%; \
  /set p_sp=%{P3}%; \
  /set p_maxsp=%{P4}%; \
  @update_status

;;
;; STATUS PROMPT
;;
;; Toggles the status prompt on/off.
;;
;; Usage: /status_prompt
;;
/def status_prompt = !prompt p: <hp> <maxhp> <sp> <maxsp> <exp> <cash> <expl> <wgt> <last_exp> "<scan>" "<align>" <party><newline>
/def plain_prompt = !prompt <plain>

/def -Fp5 -h'RESIZE' update_status_size = \
  /set status_width=%{1-$[columns()]}%; \
  /status_rm my_status%; \
  /status_add my_status:$[status_width - 15]

/test update_status_size(columns(), lines())

/def update_status_x = \
  /if (strlen(update_status)) \
    /set update_status=%{update_status} $[substr(status_pad, 0, 1)] %{*}%; \
  /else \
    /set update_status=%{*}%; \
  /endif

/def -Fp99 -msimple -h'SEND @update_status' update_status_99 = /unset update_status

/def -Fp0 -msimple -h'SEND @update_status' update_status = \
  /if (ticking & idle() < idle_time & tick_show & last_tick() <= tick_show) \
    /timer -t1 -n1 -p'update_status_pid' -k -- @update_status%; \
  /endif%; \
  /if (status_width != columns()) \
    /test update_status_size(columns(), lines())%; \
  /endif%; \
  /let _status=$[strcat(' ', update_status, ' ')]%; \
  /if (visual !~ 'on' & _status !~ my_status) \
    /_echo %{my_status}%; \
  /endif%; \
  /test my_status := _status

/unset my_status

;/def -Fp80 -msimple -h'SEND @update_status' update_status_80 = /return

/def -Fp70 -msimple -h'SEND @update_status' update_status_70 = \
  /update_status_x [%{fatigue},%{p_align}] hp:$[trunc(p_hp)]($[trunc(p_maxhp)]) sp:$[trunc(p_sp)]($[trunc(p_maxsp)]) exp:$[to_kmg(p_exp)] ($[to_kmg(p_last_exp)])

/def -Fp65 -msimple -h'SEND @update_status' update_status_65 = \
  /let _tick=$[last_tick()]%; \
  /if (_tick > tick_show) \
    /update_status_x >$[to_dhms(tick_show)]%; \
  /else \
    /update_status_x %{_tick}/%{tick_last}s%; \
  /endif

/def -Fp50 -msimple -h'SEND @update_status' update_status_50 = \
  /update_status_x {t=%{tank-??},h=%{healing-??}}

/def -Fp40 -msimple -h'SEND @update_status' update_status_40 = \
  /update_status_x <%{target-??}:%{target_name-??}>

/def -Fp10 -msimple -h'SEND @update_status' update_status_10 = \
  /update_status_x [$[away ? 'away' : 'here']]

/def -Fp3 -h'CONNECT' update_status_on_connect = @update_status

;;
;; UPDATE FATIGUE
;;
;; Takes the given fatigue and displays it if it has changed.
;;
;; Usage: /update_fatigue [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -d DESC*      The description of the current fatigue level
;;   -f LEVEL*     The current fatigue level
;;
/def update_fatigue = \
  /if (!getopts('f#d:', '') | !strlen(opt_d) | opt_f == fatigue) \
    /return%; \
  /endif%; \
  /if (opt_f < fatigue) \
    /ticked%; \
  /endif%; \
  /if (report_fatigue) \
    /say -d'think' -- %{opt_d} {$[delta_only(fatigue - opt_f)]}%; \
  /else \
    /say -d'status' -- %{opt_d} {$[delta_only(fatigue - opt_f)]}%; \
  /endif%; \
  /set fatigue=%{opt_f}%; \
  /set fatigue_desc=%{opt_d}%; \
  @update_status

/def fatigue_fully = 0
/def fatigue_almost = 1
/def fatigue_bit_tired = 2
/def fatigue_tired = 3
/def fatigue_exhausted = 4

/test fatigue := ${fatigue_fully}
/set fatigue_desc=Fully Rested

/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You feel fully rested\\.$' fatigue_0 = /update_fatigue -f${fatigue_fully} -d'Fully Rested'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You feel almost fully rested\\.$' fatigue_1 = /update_fatigue -f${fatigue_almost} -d'Almost Fully Rested'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You feel a bit tired\\.$' fatigue_2 = /update_fatigue -f${fatigue_bit_tired} -d'Bit Tired'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You feel tired\\.$' fatigue_3 = /update_fatigue -f${fatigue_tired} -d'Tired'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You are exhausted\\.$' fatigue_4 = /update_fatigue -f${fatigue_exhausted} -d'Exhausted'

;;
;; UPDATE TARGET SCAN
;;
;; Takes the given shape and displays it if it has changed.
;;
;; Usage: /update_target_scan [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -d DESC*      The description of the health level
;;   -s LEVEL*     The current health level
;;   -t TARGET*    The display name of the target
;;   -x            Do not show scan changes to status
;;

/def scan_good_shape = 100
/def scan_slightly_hurt = 90
/def scan_moderately_hurt = 75
/def scan_not_in_a_good_shape = 50
/def scan_bad_shape = 25
/def scan_very_bad_shape = 10
/def scan_almost_dead = 5
/def scan_dead_meat = 0

/def update_target_scan = \
  /if (!getopts('t:s#d:x', '') | !strlen(opt_d) | !strlen(opt_t)) \
    /return%; \
  /endif%; \
  /if (expr(strcat('scan_', textencode(opt_t))) == opt_s) \
    /return%; \
  /endif%; \
  /set scan_$[textencode(opt_t)]=%{opt_s}%; \
  /let _color=$[opt_s >= ${scan_slightly_hurt} ? 'green' : opt_s >= ${scan_not_in_a_good_shape} ? 'yellow' : 'red']%; \
  /if (target_name =~ opt_t) \
    /set target_shape=%{opt_s}%; \
  /endif%; \
  /if (report_scans & target_name =~ opt_t) \
    /say -c'%{_color}' -m$[opt_x ? ' -x' : ''] -- %{opt_d}%; \
  /elseif (!opt_x) \
    /say -d'status' -c'%{_color}' -- %{opt_d}%; \
  /endif

/def -Fp5 -aBCyellow -mregexp -t'^([A-Za-z,:\' -]+) is (in )?(good shape|slightly hurt|moderately hurt|not in a good shape|bad shape|very bad shape|almost DEAD|DEAD MEAT)[\\.!]$' scan = \
  /if ({P3} =~ 'good shape') \
    /let _shape=${scan_good_shape}%; \
  /elseif ({P3} =~ 'slightly hurt') \
    /let _shape=${scan_slightly_hurt}%; \
  /elseif ({P3} =~ 'moderately hurt') \
    /let _shape=${scan_moderately_hurt}%; \
  /elseif ({P3} =~ 'not in a good shape') \
    /let _shape=${scan_not_in_a_good_shape}%; \
  /elseif ({P3} =~ 'bad shape') \
    /let _shape=${scan_bad_shape}%; \
  /elseif ({P3} =~ 'very bad shape') \
    /let _shape=${scan_very_bad_shape}%; \
  /elseif ({P3} =~ 'almost DEAD') \
    /let _shape=${scan_almost_dead}%; \
  /elseif ({P3} =~ 'DEAD MEAT') \
    /let _shape=${scan_dead_meat}%; \
  /endif%; \
  /substitute -- %{*} [<= %{_shape}%%]%; \
  /if ({P1} =~ target_name) \
    /update_target_scan -t'$(/escape ' %{P1})' -s%{_shape} -d'$(/escape ' $[toupper({P3})])' -x%; \
  /endif

/def -Fp5 -mregexp -t'^[A-Z][a-z\' ]+: (#+)$' essence_eye_counter = \
  /substitute -p -- [@{B}$[pad(strlen({P1}), 2)]@{n}] %{*}

;;
;; CONNECTION VERIFICATION
;;

/def -Fp5 -mregexp -t'^You are ([A-Z][a-z]+)\\. You are connected in from ([A-Za-z0-9-.]+) \\(([^)]+)\\)\\.$' whoami = \
  /if (!is_me({P1})) \
    /error -m'%{0}' -- me() ($[me()]) does not match who ($[tolower({P1})]) you are%; \
    /send -- !ld%; \
    /dc%; \
  /endif

;;
;; BASIC REPORTING
;;

/def -Fp5 -msimple -t'You don\'t have enough spell points.' out_of_spell_points = \
  /if (class_caster) \
    /say -d'think' -x -- Out Of Spell Points!%; \
  /endif

;;
;; NIGHT BONUS
;;

/def -Fp5 -mregexp -t'^The bonus to party criticals due to low user amounts is currently (.+)\\.$' night_bonus = \
  /say -d'party' -f'$(/escape ' %{P1})' -- Night Bonus

;;
;; CASTING SPEED
;;

/def casting_speed_very_slow = -2
/def casting_speed_slow = -1
/def casting_speed_normal = 0
/def casting_speed_quick = 1
/def casting_speed_very_quick = 2

/test casting_speed := ${casting_speed_normal}

/def -Fp5 -mregexp -t'^Your casting (mode|speed) is (now )?\'(.+)\'\\.$' casting_speed = \
  /if ({P3} =~ 'very slow') \
    /set casting_speed=${casting_speed_very_slow}%; \
  /elseif ({P3} =~ 'slow') \
    /set casting_speed=${casting_speed_slow}%; \
  /elseif ({P3} =~ 'quick') \
    /set casting_speed=${casting_speed_quick}%; \
  /elseif ({P3} =~ 'very quick') \
    /set casting_speed=${casting_speed_very_quick}%; \
  /else \
    /set casting_speed=${casting_speed_normal}%; \
  /endif

;;
;; PARRY REPORTING
;;

/def -Fp5 -mregexp -t'^Your attack is set to (\\d+)\\.$' parry_attack = \
  /set parry_attack=%{P1}

/def -Fp5 -mregexp -t'^Your parry is set to (\\d+)\\.$' parry_parry = \
  /set parry_parry=%{P1}

/def -Fp5 -mregexp -t'^Your current defence factor modified by weight is: (\\d+)\\.$' parry_defence = \
  /set parry_defence=%{P1}%; \
  /say -d'party' -x -- Attack: %{parry_attack-0}, Parry: %{parry_parry-0}, Defence Factor: %{parry_defence-0}

;;
;; WIMPY REPORTING
;;

/def -Fp5 -mregexp -t'^\\(You will now wimpy at (\\d+) hps\\.\\)$' wimpy_change = \
  /if (is_me(tank)) \
    /say -f'$(/escape ' %{P1} hps)' -x -- Wimpy%; \
  /endif

/def -Fp5 -msimple -t'(You are in brave mode.)' wimpy_brave = \
  /if (is_me(tank)) \
    /say -f'off' -x -- Wimpy%; \
  /endif

;;
;; TICK
;;
;; Prints out the time of the last tick
;;
;; Usage: /tick
;;
/def tick = /say -d'status' -- Last tick was $[to_dhms(last_tick(), 1)] ago

/property -t -v'120' tick_show

/def last_tick = /result trunc(time() - tick_start)

;;
;; TICKED
;;
;; Called when you tick. Keeps track of time and optionally warns when the next
;; one should come using the {tick_time} variable.
;;
;; Usage: /ticked
;;

/property -s on_tick
/property -s on_sizzle
/property -s on_fully_healed

/def ticked = \
  /if (!ticking) \
    /return%; \
  /endif%; \
  /if (tick_start) \
    /let _time=$[last_tick()]%; \
    /let _last=%{tick_last}%; \
    /if (_time < 10) \
      /return%; \
    /endif%; \
    /if (_time < 180) \
      /if (report_ticks) \
        /say -d'think' -x -f'$(/escape ' %{_time}s (last %{_last}s))' -- Ticked%; \
      /endif%; \
      /say -d'status' -c'green' -f'$(/escape ' %{_time}s (last %{_last}s))' -- Ticked%; \
      /say -d'status' -c'yellow' -f'$(/escape ' %{_time}s (last %{_last}s))' -- Ticked%; \
      /say -d'status' -c'red' -f'$(/escape ' %{_time}s (last %{_last}s))' -- Ticked%; \
      /set tick_last=%{_time}%; \
    /else \
      /set tick_last=-1%; \
    /endif%; \
    /if (strlen(on_tick)) \
      /eval %{on_tick}%; \
      /unset on_tick%; \
    /endif%; \
  /endif%; \
  /test tick_start := time()%; \
  /timer -t%{tick_time} -n1 -p'tick_pid' -k -- /tick_timer 2%; \
  @on_tick%; \
  @update_status

/test tick_last := tick_last | -1

/property -i tick_sps
/property -t -v'20' tick_time
/property -b ticking

/def -Fp5 -msimple -t'You sizzle with magical energy.' sizzle = \
  /if (strlen(on_sizzle)) \
    /eval %{on_sizzle}%; \
    /unset on_sizzle%; \
  /endif

/def -Fp5 -msimple -t'You feel fully healed.' fully_healed = \
  /if (strlen(on_fully_healed)) \
    /eval %{on_fully_healed}%; \
    /unset on_fully_healed%; \
  /endif

;;
;; TICK TIMER
;;
;; Simple macro that prints out when your last tick was.
;;
;; Usage: /tick_timer [REPEATS]
;;
/def tick_timer = \
  /let _time=$[last_tick()]%; \
  /if (_time > 10) \
    /say -d'status' -f'last %{_time}s ago' -- Ticking Soon%; \
  /endif%; \
  /if ({1} > 0) \
    /timer -t%{tick_time} -n1 -p'tick_pid' -k -- /tick_timer $[{1} - 1]%; \
  /else \
    /unset tick_pid%; \
  /endif

;;
;; HP & SP REPORTING
;;

;;
;; This transforms the party score into a short score.
;;
/def -Fp10 -mregexp -t'^([A-Z][a-z]+) [\\[{<]party[>}\\]]: hp: (-?\\d+) \\((\\d+)\\) sp: (-?\\d+) \\((\\d+)\\) ?$' party_score_report = \
  /if (is_me({P1})) \
    /eval /substitute -- $$[strip_attr('hp: %{P2}(%{P3}) sp: %{P4}(%{P5})')]%; \
  /endif

;;
;; This captures the short score and then performs the actions to report.
;;
/def -Fp5 -mregexp -t'^hp: (-?\\d+)\\((\\d+)\\) sp: (-?\\d+)\\((\\d+)\\)$' score_report = \
  /let _hp=%{P1}%; \
  /let _maxhp=%{P2}%; \
  /let _sp=%{P3}%; \
  /let _maxsp=%{P4}%; \
  /if (report_hps & abs(_hp - report_hps_last) > _maxhp / 20) \
    /let _message=%{_hp} of %{_maxhp} hps ($[_hp * 100 / _maxhp]%%) $[_hp > report_hps_last ? '+' : '']$[_hp - report_hps_last]%; \
    /if (_hp < _maxhp / 2) \
      /let _color=red%; \
    /elseif (_hp < _maxhp * 3 / 4) \
      /let _color=yellow%; \
    /else \
      /let _color=green%; \
    /endif%; \
    /say -x -c'%{_color}' -- %{_message}%; \
    /set report_hps_last=%{_hp}%; \
  /endif%; \
  /if (report_sps & abs(_sp - report_sps_last) > _maxsp / 20) \
    /let _message=%{_sp} of %{_maxsp} sps ($[_sp * 100 / _maxsp]%%) $[_sp > report_sps_last ? '+' : '']$[_sp - report_sps_last]%; \
    /if (_sp < _maxsp / 2) \
      /let _color=red%; \
    /elseif (_sp < _maxsp * 3 / 4) \
      /let _color=yellow%; \
    /else \
      /let _color=green%; \
    /endif%; \
    /say -x -c'%{_color}' -- %{_message}%; \
    /set report_sps_last=%{_sp}%; \
  /endif%; \
  /let _time=$[last_tick()]%; \
  /substitute -aB -p -- hp: %{_hp}(%{_maxhp}) [$[_hp >= s_hp ? '@{BCgreen}+' : '@{BCred}']$[_hp - s_hp]@{n}] sp: %{_sp}(%{_maxsp}) [$[_sp >= s_sp ? '@{BCgreen}+' : '@{BCred}']$[_sp - s_sp]@{n}]$[ticking & _time < 1000 ? strcat(' (', _time, 's)') : '']%; \
  /if (tick_sps & _sp - tick_sps >= s_sp) \
    /ticked%; \
  /endif%; \
  /set s_hp=%{_hp}%; \
  /set s_maxhp=%{_maxhp}%; \
  /set s_sp=%{_sp}%; \
  /set s_maxsp=%{_maxsp}

;;
;; STATS TRIGGERS
;;

/def stat_cost = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen --%; \
    /let _echo=1%; \
  /endif%; \
  /execute %{_cmd} .-----------------------------------.%; \
  /execute %{_cmd} | Stat | Num |     Cost |      Need |%; \
  /execute %{_cmd} |-----------------------------------|%; \
  /execute %{_cmd} | $[pad('Str', 4, ' | ', 3, {stat_str_count-0}, 3, ' | ', 3, to_kmg(stat_str_cost), 8, ' | ', 3, p_exp < stat_str_cost ? to_kmg(stat_str_cost - p_exp) : '-', 9)] |%; \
  /execute %{_cmd} | $[pad('Con', 4, ' | ', 3, {stat_con_count-0}, 3, ' | ', 3, to_kmg(stat_con_cost), 8, ' | ', 3, p_exp < stat_con_cost ? to_kmg(stat_con_cost - p_exp) : '-', 9)] |%; \
  /execute %{_cmd} | $[pad('Dex', 4, ' | ', 3, {stat_dex_count-0}, 3, ' | ', 3, to_kmg(stat_dex_cost), 8, ' | ', 3, p_exp < stat_dex_cost ? to_kmg(stat_dex_cost - p_exp) : '-', 9)] |%; \
  /execute %{_cmd} | $[pad('Int', 4, ' | ', 3, {stat_int_count-0}, 3, ' | ', 3, to_kmg(stat_int_cost), 8, ' | ', 3, p_exp < stat_int_cost ? to_kmg(stat_int_cost - p_exp) : '-', 9)] |%; \
  /execute %{_cmd} | $[pad('Wis', 4, ' | ', 3, {stat_wis_count-0}, 3, ' | ', 3, to_kmg(stat_wis_cost), 8, ' | ', 3, p_exp < stat_wis_cost ? to_kmg(stat_wis_cost - p_exp) : '-', 9)] |%; \
  /execute %{_cmd} | $[pad('Cha', 4, ' | ', 3, {stat_cha_count-0}, 3, ' | ', 3, to_kmg(stat_cha_cost), 8, ' | ', 3, p_exp < stat_cha_cost ? to_kmg(stat_cha_cost - p_exp) : '-', 9)] |%; \
  /execute %{_cmd} |-----------------------------------|%; \
  /execute %{_cmd} | $[pad(strcat('Experience: ', to_kmg(p_exp)), -33)] |%; \
  /execute %{_cmd} '-----------------------------------'

/def -Fp5 -mregexp -t'^Con: (At max|(\\d+\\.\\d+[MG])) \\( ?(\\d+)\\) Cha: (At max|(\\d+\\.\\d+[MG])) \\( ?(\\d+)\\) Dex: (At max|(\\d+\\.\\d+[MG])) \\( ?(\\d+)\\) $' cost_ccd = \
  /set stat_con_cost=$[from_expstr({P2})]%; \
  /set stat_con_count=%{P3}%; \
  /set stat_cha_cost=$[from_expstr({P5})]%; \
  /set stat_cha_count=%{P6}%; \
  /set stat_dex_cost=$[from_expstr({P8})]%; \
  /set stat_dex_count=%{P9}%; \
  /save_basic

/def -Fp5 -mregexp -t'^Int: (At max|(\\d+\\.\\d+[MG])) \\( ?(\\d+)\\) Wis: (At max|(\\d+\\.\\d+[MG])) \\( ?(\\d+)\\) Str: (At max|(\\d+\\.\\d+[MG])) \\( ?(\\d+)\\) $' cost_iws = \
  /set stat_int_cost=$[from_expstr({P2})]%; \
  /set stat_int_count=%{P3}%; \
  /set stat_wis_cost=$[from_expstr({P5})]%; \
  /set stat_wis_count=%{P6}%; \
  /set stat_str_cost=$[from_expstr({P8})]%; \
  /set stat_str_count=%{P9}

/def -Fp5 -ag -mregexp -t'^Str: (\\d+), Con: (\\d+), Dex: (\\d+), Int: (\\d+), Wis: (\\d+), Cha: (\\d+), Size: (\\d+)$' my_stats = \
  /set my_stat_str_diff=$[{P1} - my_stat_str]%; \
  /set my_stat_str=%{P1}%; \
  /set my_stat_con_diff=$[{P2} - my_stat_con]%; \
  /set my_stat_con=%{P2}%; \
  /set my_stat_dex_diff=$[{P3} - my_stat_dex]%; \
  /set my_stat_dex=%{P3}%; \
  /set my_stat_int_diff=$[{P4} - my_stat_int]%; \
  /set my_stat_int=%{P4}%; \
  /set my_stat_wis_diff=$[{P5} - my_stat_wis]%; \
  /set my_stat_wis=%{P5}%; \
  /set my_stat_cha_diff=$[{P6} - my_stat_cha]%; \
  /set my_stat_cha=%{P6}%; \
  /set my_stat_siz_diff=$[{P7} - my_stat_siz]%; \
  /set my_stat_siz=%{P7}%; \
  /echo -w -p -aCgreen -- %{prefix} Str: $[pad(my_stat_str, 3)] [$[my_stat_str_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_str_diff > 0 ? '+' : '', my_stat_str_diff), 4)]@{n}] Con: $[pad(my_stat_con, 3)] [$[my_stat_con_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_con_diff > 0 ? '+' : '', my_stat_con_diff), 4)]@{n}] Dex: $[pad(my_stat_dex, 3)] [$[my_stat_dex_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_dex_diff > 0 ? '+' : '', my_stat_dex_diff), 4)]@{n}]%; \
  /echo -w -p -aCgreen -- %{prefix} Int: $[pad(my_stat_int, 3)] [$[my_stat_int_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_int_diff > 0 ? '+' : '', my_stat_int_diff), 4)]@{n}] Wis: $[pad(my_stat_wis, 3)] [$[my_stat_wis_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_wis_diff > 0 ? '+' : '', my_stat_wis_diff), 4)]@{n}] Cha: $[pad(my_stat_cha, 3)] [$[my_stat_cha_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_cha_diff > 0 ? '+' : '', my_stat_cha_diff), 4)]@{n}]

/def stats = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say --%; \
  /endif%; \
  /execute %{_cmd} Str: $[pad({my_stat_str-0}, 3)] [$[pad(strcat({my_stat_str_diff-0} > 0 ? '+' : '', {my_stat_str_diff-0}), 4)]] Con: $[pad({my_stat_con-0}, 3)] [$[pad(strcat({my_stat_con_diff-0} > 0 ? '+' : '', {my_stat_con_diff-0}), 4)]] Dex: $[pad({my_stat_dex-0}, 3)] [$[pad(strcat({my_stat_dex_diff-0} > 0 ? '+' : '', {my_stat_dex_diff-0}), 4)]]%; \
  /execute %{_cmd} Int: $[pad({my_stat_int-0}, 3)] [$[pad(strcat({my_stat_int_diff-0} > 0 ? '+' : '', {my_stat_int_diff-0}), 4)]] Wis: $[pad({my_stat_wis-0}, 3)] [$[pad(strcat({my_stat_wis_diff-0} > 0 ? '+' : '', {my_stat_wis_diff-0}), 4)]] Cha: $[pad({my_stat_cha-0}, 3)] [$[pad(strcat({my_stat_cha_diff-0} > 0 ? '+' : '', {my_stat_cha_diff-0}), 4)]]

;;
;; FOOD
;;

;;
;; Automatically eat food when you are hungry.
;;
/def -Fp5 -msimple -t'You are no longer satiated.' no_longer_satiated = \
  /say -- No Longer Satiated!%; \
  /eat

/def -Fp5 -mregexp -t'^(You are not satiated|You are hungry|You are starving|You are STARVING)\\.$' not_satiated = \
  /say -- Not Satiated!%; \
  /eat

/def -Fp5 -msimple -t'You are satiated.' satiated = \
  /say -- Satiated!

;;
;; HP/SP BOOSTING
;;

/def -Fp5 -msimple -t'You fail to reach the drink with your mouth.' moonshine_failed = \
  /if (is_me(tank)) \
    /say -c'red' -- Failed to Drink Alcohol!! HELP!!%; \
  /endif

/def -Fp5 -mregexp -t'^You feel too dizzy to (sip|quaff) the potion\\.$' potion_failed = \
  /if (is_me(tank)) \
    /say -c'red' -- Failed to $[toupper({P1}, 1)] Potion!! HELP!!%; \
  /endif

;;
;; ENTER, LEAVE, RETURN
;;

/property -s -g on_return_game

/def -Fp10 -mregexp -t'^[\\[{<](enemy|inform|friend)[>}\\]]: ([A-Z][a-z]+) recovers from link death\\.$' return_game = \
  /if (is_me({P2}) | !{#}) \
    /if (strlen(on_return_game)) \
      /eval %{on_return_game}%; \
    /endif%; \
    /party -f%; \
    /alias -f healing%; \
    /alias -f target%; \
    @on_return_game%; \
  /endif

/property -s -g on_enter_game

/def -Fp10 -mregexp -t'^[\\[{<](enemy|inform|friend)[>}\\]]: ([A-Z][a-z]+) enters the game\\.$' enter_game = \
  /if (!is_me({P2}) & {#}) \
    /return%; \
  /endif%; \
  /if (dead) \
    /test send('!echo Alive?')%; \
    /return%; \
  /endif%; \
  /set party_members=0%; \
  /test tank := me()%; \
  /test commander := me()%; \
  /unset aide%; \
  /if (strlen(on_enter_game)) \
    /eval %{on_enter_game}%; \
  /endif%; \
  /send ${status_prompt}%; \
  /rate -r%; \
  /update_title -f%; \
  /quiet_mode 0%; \
  /reset_run%; \
  /test send('!channels join z')%; \
  /test send('!equip')%; \
  @on_enter_game%; \
  /return_game

/property -s -g on_leave_game

/def -Fp10 -mregexp -t'^[\\[{<](enemy|inform|friend)[>}\\]]: ([A-Z][a-z]+) left the game\\.$' leave_game = \
  /if (!dead & is_me({P2})) \
    /kill cpo_timer_pid cps_timer_pid cpl_timer_pid%; \
    /if (strlen(on_leave_game)) \
      /eval %{on_leave_game}%; \
    /endif%; \
    @on_leave_game%; \
  /endif

;;
;; ALIAS
;;
;; Gets the value of the alias from the mud and sets the local copy.
;;
;; Usage: /alias [OPTIONS] -- NAME [VALUE]
;;
;;  OPTIONS:
;;
;;   -f            Force this request.
;;
/def alias = \
  /if (!getopts('f', '') | !regmatch('^[a-z_]+$$', {1})) \
    /return%; \
  /endif%; \
  /if ({#} > 1) \
    /let _cmd=!alias _%{1} %{-1}%; \
    /if (opt_f) \
      /test send(_cmd)%; \
    /else \
      %{_cmd}%; \
    /endif%; \
  /endif%; \
  /let _cmd=!echo Alias %{P0} = _%{P0}%; \
  /if (opt_f) \
    /test send(_cmd)%; \
  /else \
    %{_cmd}%; \
  /endif

/def -Fp5 -ag -mregexp -t'^(Adding|Replacing|Removing) alias _' alias_gag

/def -Fp5 -agL -mregexp -t'^Alias ([a-z_]+) = ' alias_value = \
  /update_value -n'%{P1}' -v'$(/escape ' %{PR})'

/property -g commander
/test commander := strlen(commander) ? commander : me()

/property -g tank
/test tank := strlen(tank) ? tank : me()

/property -g aide
/test aide := strlen(aide) ? aide : ''

/property -g -v'%' prefix
/property -b ld_at_boot
/property -b report_hps
/property -b report_sps
/property -b report_ticks
/property -b report_fatigue
/property -b report_kills
/property -b report_target
/property -b report_scans
/property -b report_prots
/property -b report_sksp
/property -b report_warnings
/property -b quiet_mode
/property -b scan_target
/property -b give_noeq_target
/property -b class_caster
/property -b class_fighter
/property -s -g my_party_name
/property -s -g my_party_color
/property -t -v'180' idle_time
/property -g -v'Ccyan' echo_attr
/property -g -v'Cred' error_attr
/property -g -v'r' status_attr
/property -g -v'_' status_pad

;;
;; LOGGING
;;

/set logging=1

/def logging = \
  /update_value -n'logging' -v'$(/escape ' %{*})' -b%; \
  /disconnect_log%; \
  /connect_log

/def -Fp5 -h'CONNECT' connect_log = \
  /if (logging) \
    /log -g $[logs_dir(strcat(ftime('%Y-%m-%d', time())))]%; \
  /endif

/def -Fp5 -h'DISCONNECT' disconnect_log = /log off

/def -Fp5 -mregexp -t'^Spell cost: +(\\d+) SPs$' help_spell_spell_cost = \
  /set help_spell_cost=%{P1}

/def -Fp5 -mregexp -t'^Maximum healing: +(\\d+) \\((\\d+) if protected\\)$' help_spell_maximum_healing = \
  /set help_spell_maximum_healing=%{P1}%; \
  /substitute -- %{*} ($[round(1.0 * help_spell_maximum_healing / help_spell_cost, 2)] heal/sp)

/def -Fp5 -mregexp -t'^Maximum damage: +(\\d+)$' help_spell_maximum_damage = \
  /set help_spell_maximum_damage=%{P1}%; \
  /substitute -- %{*} ($[round(1.0 * help_spell_maximum_damage / help_spell_cost, 2)] dam/sp)

;;
;; LOCK TARGET
;;
;; Picks out a random {target_emote} and then performs that action against the
;; target.
;;
;; Usage: /lock_target TARGET
;;
/property -g -v'wobble smooch truce drool french threaten surprise mercy disarm puppyeyes snuggle forbid applaud compliment bad fullmoon' target_emotes

/def lock_target = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _target=%{*}%; \
  /if (regmatch('^(.+) \\d+$$', _target)) \
    /let _target=%{P1}%; \
  /endif%; \
  !$(/random %{target_emotes}) %{_target}

;;
;; RANDOM
;;
;; Returns a random position parameter.
;;
;; Usage: /random VALUE VALUE ...
;;
/def random = /result {R}

;;
;; POS
;;
;; Returns the tf {POS} of the supplied string.
;;
/def pos = /result shift(), {%{1}}

/def -Fp5 -mregexp -t'^You yell in a high pitched voice at (.+)\\.$' set_target_name_yell = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You wobble (.+)\\.$' set_target_name_wobble = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You give (.+) a long and wet kiss\\.$' set_target_name_smooch = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You state \'Truce truce!\' (.+)\\.$' set_target_name_truce = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You drool on (.+)\\.$' set_target_name_drool = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You give (.+) a REAL kiss, it seems to last forever\\.$' set_target_name_french = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You threaten (.+)\\.$' set_target_name_threaten = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You surprise (.+)\\.$' set_target_name_surprise = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You beg (.+) for mercy\\.$' set_target_name_mercy = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You attempt to disarm (.+)\\.$' set_target_name_disarm = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You look at (.+) with great big sad eyes\\.$' set_target_name_puppyeyes = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You snuggle (.+)\\.$' set_target_name_snuggle = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You forbid (.+) of doing that\\.$' set_target_name_forbid = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You applaud at (.+)\\.$' set_target_name_applaud = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You compliment (.+)\\.$' set_target_name_compliment = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You hit (.+) with a newspaper and say, \'Bad (.+)! Bad!!\'\\.$' set_target_name_bad = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You pull down your pants and moon (.+)\\.$' set_target_name_fullmoon = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^You reveal your blackened row of saw blade-like teeth at (.+), grinning ' set_target_name_dgrin = /set target_name=%{P1}
/def -Fp5 -mregexp -t'^With sinister intentions in your mind you scowl at (.+), beating ' set_target_name_dchallenge = /set target_name=%{P1}

;;
;; Tests the target emotes.
;;
/def test_target_emotes = \
  /foreach %{target_emotes} = !%%{1} %{*-%{target}}

;;
;; PK MODE
;;

/property -s -g enemies
/property -g -v'amuse annoyed calm chicken burn care confuse curtsey duck grimace howl loathe beg moo pinch pity pretend sad whine why wtf zzz' enemy_emotes

/def fe = /find_enemies %{*}

/def find_enemies = /mapcar /find_enemy %{enemies}

/def find_enemy = \
  /if ({#}) \
    !$(/random %{enemy_emotes}) %{*}%; \
  /endif

/def -Fp5 -mregexp -t'^You try to amuse ([A-Z][a-z]+), failing miserably\\.$' enemy_target_amuse = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You look annoyed by ([A-Z][a-z]+)\\.$' enemy_target_annoyed = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You try to calm ([A-Z][a-z]+) down\\.$' enemy_target_calm = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You point at ([A-Z][a-z]+) and say \'Chicken\'\\.$' enemy_target_chicken = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You set fire to ([A-Z][a-z]+)\\.$' enemy_target_burn = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You could not care less about ([A-Z][a-z]+)\\.$' enemy_target_care = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You try to confuse ([A-Z][a-z]+)\\.$' enemy_target_confuse = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You curtsey before ([A-Z][a-z]+)\\.$' enemy_target_courtsey = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You duck beyond ([A-Z][a-z]+)\'s reach\\.$' enemy_target_duck = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You make an awful face at ([A-Z][a-z]+)\\.$' enemy_target_grimace = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You howl in pain at ([A-Z][a-z]+)\\.$' enemy_target_howl = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You loathe ([A-Z][a-z]+)\\.$' enemy_target_loathe = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You beg ([A-Z][a-z]+) for mercy\\.$' enemy_target_beg = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You moo at ([A-Z][a-z]+)\\.$' enemy_target_moo = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You pinch ([A-Z][a-z]+) on the cheek\\.$' enemy_target_pinch = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You feel sorry for ([A-Z][a-z]+)\\.$' enemy_target_pity = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You pretend not to see ([A-Z][a-z]+)\\.$' enemy_target_pretend = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You show a very sad face to ([A-Z][a-z]+)\\.$' enemy_target_sad = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You whine to ([A-Z][a-z]+)\\.$' enemy_target_whine = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You look to the heavens and sigh \'Why me?\'\\.$' enemy_target_why = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You stare at ([A-Z][a-z]+) and utter \'WTF?\'\\.$' enemy_target_wtf = /set_target_locally %{P1}
/def -Fp5 -mregexp -t'^You tiredly go \'ZzzZZzzZZzzZzz\' at ([A-Z][a-z]+)\\.$' enemy_target_zzz = /set_target_locally %{P1}

/def -Fp5 -ag -msimple -t'Missing person or misspelled word 2' missing_person

/def enemy_target = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _target=$[tolower({*})]%; \
  /if (_target !~ target & (isin(_target, enemies) | _target =~ 'bat')) \
    /set_target_locally %{_target}%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) (arrives|floats)( from the [a-z]+| in a puff of smoke)?\\.$' enemy_target_arrives = \
  /enemy_target %{P1}

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) hits you \\d+ times\\.$' enemy_target_hits = \
  /enemy_target %{P1}

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) starts concentrating on a spell\\.$' enemy_target_casts = \
  /enemy_target %{P1}

;;
;; SET TARGET
;;

/def set_target_locally = \
  /let _target=$[tolower(strip_attr({*-%{target}}))]%; \
  /if (target !~ _target) \
    /set target_name=%; \
    /set rounds=0%; \
  /endif%; \
  /set target=%{_target}%; \
  /set target_shape=${scan_good_shape}%; \
  @update_status

/def set_target_quietly = \
  /alias target %{*}%; \
  /set_target_locally %{*}%; \
  /if (scan_target) \
    !scan %{*}%; \
  /endif

/property -s -g on_set_target

/def set_target = \
  /set_target_quietly %{*}%; \
  /if (!quiet_mode) \
    /lock_target %{*}%; \
  /endif%; \
  /if (strlen(on_set_target)) \
    /eval %{on_set_target}%; \
  /endif%; \
  @on_set_target %{*}

;;
;; TARGET
;;
;; Sets the target and announces that value. Calls the set_target macro.
;;
;; Usage: /target [NAME]
;;
/def l = /target %{*}
/def t = /target %{*}
/def tgt = /target %{*}

/def target = \
  /set_target %{*-%{target}}%; \
  /if (!strlen(target)) \
    /error -m'%{0}' -- parameters required when {target} is null%; \
    /return%; \
  /endif%; \
  /if (report_target) \
    /say -d'party' -b -m -x -c'green' -- TARGET { %{target} }%; \
  /endif

/def st = !scan %{target}
/def gt = !give noeq to %{target}
/def lt = !look at %{target}
/def ct = !creator %{target}
/def kt = !kill %{target}
/def wt = !where %{target}
/def touch = !touch %{target}

;;
;; SET AUTO TARGET
;;
;; Usage: /set_auto_target [OPTIONS] -- TARGET
;;
;;  OPTIONS:
;;
;;   -t TANK       The tank announcing targets
;;
/def set_auto_target = \
  /if (getopts('t:', '') & {#} & !is_me(opt_t) & (tolower(opt_t) =~ tank | tolower(opt_t) =~ commander) & !is_party_member({*})) \
    /set_target_locally %{*}%; \
  /endif

;;
;; COMMON TANK AUTO TARGETS
;;

/def -Fp11 -mregexp -t'^([A-Z][a-z]+) [\\[{<]party[>}\\]]: ' tank_party = \
  /let _player=$[tolower({P1})]%; \
  /let _skills=smash|battlecry|bc|cleave|kiru|ki|suf|suff|suffoing|suffing|suffocation|suffo|flesh rot|rotting|charging lance|charging|rot|dancing blade|db|hew|kungfu|brawl|slash|backstab|strike|stab|stabbing|target|throw|skill|kill%; \
  /if (!is_me(_player) & (_player =~ tank | _player =~ commander) & regmatch(strcat('(?i)^(using|-+|=+)? *(', _skills, ')[!:]? *([-~=]*>|goes at|goes @|goes [-~=]*>|at|@| ) *'), {PR}) & !is_party_member({PR})) \
    /substitute -aB -- %{*}%; \
    /set_target_locally %{PR}%; \
  /endif

;;
;; ADD AUTO TARGET
;;
;; Usage: /add_auto_target [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -l LEFT       The text to the left of the target
;;   -n NUM        The number of auto targets tank has
;;   -r RIGHT      The text to the right of the target
;;   -t TANK       The tank announcing targets
;;
;;  EXAMPLES:
;;
;;   /add_auto_target -t'conglomo' -n0 -l'BC --> ' -r' <--'
;;
;;     Conglomo [party]: BC --> bob <--
;;
/def add_auto_target = \
  /if (!getopts('t:n#l:r:', '') | !strlen(opt_t) | (!strlen(opt_l) & !strlen(opt_r))) \
    /return%; \
  /endif%; \
  /let opt_t=$[tolower(opt_t)]%; \
  /let opt_n=$[opt_n ? opt_n : 0]%; \
  /let _trig=^$[toupper(opt_t, 1)] [\\[{<]party[>}\\]]: $[escape('\'', regescape(opt_l))](.+)$[escape('\'', regescape(opt_r))] ?$$%; \
  /def -Fp10 -aB -mregexp -t'%{_trig}' auto_target_%{opt_t}_%{opt_n} = \
    /set_auto_target -t'$(/escape ' %{opt_t})' -- %%{P1}

;;
;; LAG CHECKER
;;

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ (pings you|goes \'PING\')\\.' ping = /runif -t5 -n'ping' -- /lag think
/def -Fp10 -mregexp -t'^[\\[{<]([a-z]+)[>}\\]]: [A-Z][a-z]+ pings ([A-Z][a-z]+)\\.$' ping_channel = \
  /if (is_me({P2})) \
    /runif -t5 -n'ping_channel' -- /lag channels send %{P1}%; \
  /endif

;;
;; LAG
;;
;; Requests the lag time from the mud. Optionally takes a COMMAND for where to
;; report the lag time.
;;
;; Usage: /lag [COMMAND]
;;
/def lag = \
  /let _key=$[hex(time() * 100000)]%; \
  /if ({#}) \
    /set lag_%{_key}=%{*}%; \
  /else \
    /set lag_%{_key}=/say --%; \
  /endif%; \
  !echo Ping $[time()] %{_key}

/def -ag -p1 -mregexp -t'^Ping (\\d+\\.\\d*) ([0-9a-f]+)$' check_lag = \
  /let _time=$[time() - {P1}]%; \
  /let _var=lag_%{P2}%; \
  /let _cmd=$[expr(_var)]%; \
  /unset %{_var}%; \
  /if (!strlen(_cmd)) \
    /return%; \
  /endif%; \
  /execute %{_cmd} Lag: $[to_dhms(_time)]


/def -Fp5 -msimple -t'The sun lights up the daytime sky.' outside_daytime = \
  /say -d'party' -- Outside: Day!

/def -Fp5 -msimple -t'The sky is darkened with night.' outside_night = \
  /say -d'party' -- Outside: Night!

;;
;; PARTY LOCATIONS
;;
;; Checks the party locations and reports on who is missing.
;;
;; Usage: /plo
;;
/def plo = \
  /if (is_me(tank) | is_me(commander)) \
    /set plo_status=1%; \
    /set plo_search=0%; \
    /set plo_missing=0%; \
    /unset plo_tank%; \
  /endif%; \
  !party locations%; \
  /if (is_me(tank) | is_me(commander)) \
    !echo /plo start%; \
    !party locations%; \
    !echo /plo finish%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) +: (.*)$' plo_entry = \
  /if (plo_status) \
    /substitute -ag%; \
    /if (tolower({P1}) =~ tank) \
      /set plo_tank=%{P2}%; \
    /elseif (plo_search & strlen(plo_tank) & !is_me({P1}) & {P2} !~ 'Link Morgue ()' & plo_tank !~ {P2}) \
      !emoteto $[tolower({P1})] wishes you were here: %{plo_tank}%; \
      /set plo_missing=1%; \
    /endif%; \
  /endif

/def -Fp5 -ag -msimple -t'/plo start' plo_start = \
  /set plo_search=1

/def -Fp5 -ag -msimple -t'/plo finish' plo_finish = \
  /if (!plo_missing) \
    /say -d'party' -c'green' -- All members are here!%; \
  /endif%; \
  /set plo_status=0

;;
;; PARTY FOLLOW
;;
;; Forces each of the members to follow.
;;
;; Usage: /pf MEMBER MEMBER ...
;;
/def pf = \
  /while ({#}) \
    !party leader $[tolower({1})]%; \
    /shift%; \
  /done%; \
  !party leader $[me()]

;;
;; PARTY MEMBERS FOLLOWING
;;
;; Check which party members are following.
;;
;; Usage: /pfs OPTIONS
;;
;;  OPTIONS:
;;
;;   -f            Force the non-following members to follow
;;
/def pfs = \
  /if (!getopts('f', '')) \
    /return%; \
  /endif%; \
  /if (is_me(tank) | is_me(commander)) \
    /set pfs_status=1%; \
    /set pfs_force=%{opt_f}%; \
    /set pfs_stragglers=0%; \
  /endif%; \
  !party status%; \
  !echo /pfs

/def -Fp5 -ag -msimple -t'/pfs' pfs_message = \
  /if (pfs_force) \
    !party leader $[me()]%; \
  /elseif (pfs_status & !pfs_stragglers) \
    /say -d'status' -- All members following!%; \
  /endif%; \
  /set pfs_status=0

/def -Fp5 -mregexp -t'^<(.+)> \\d{2}:\\d{2}:\\d{2} \\([^\\)]+\\) EXP: (\\d+(\\.\\d+)?)([Mk]?), (\\d+(\\.\\d+)?)([Mk]?) xp/min, (\\d+(\\.\\d+)?)([Mk]?) xp/min/mbr$' party_status_header = \
  /quote -S /unset `/listvar -s party_member_*%; \
  /set party_name=%{P1}%; \
  /set party_exp=$[{P2} * get_multiplier({P4})]%; \
  /set party_rate=$[{P5} * get_multiplier({P7})]%; \
  /unset tank%; \
  /unset commander%; \
  /unset aide

/def -Fp5 -mregexp -t'^(\\d)\\. ([A-Z][a-z]+) +(ld|cmd|ldr|mbr): *(pf|-|off) hp:\\([^\\)]+\\) sp:\\([^\\)]+\\) lvl: *(\\d+) xp: (\\d+(\\.\\d+)?)([Mk]?)$' party_status_member = \
  /if (strlen({P2}) & {P1} == 1) \
    /set tank=$[tolower({P2})]%; \
  /endif%; \
  /if (strlen({P2}) & {P3} =~ 'cmd') \
    /set commander=$[tolower({P2})]%; \
  /endif%; \
  /set party_members=%{P1}%; \
  /set party_member_%{P1}=$[tolower({P2})]%; \
  /set party_member_%{P1}_exp=$[{P6} * get_multiplier({P8})]%; \
  /set party_member_%{P1}_lvl=%{P5}%; \
  /if (pfs_status & {P1} > 1 & {P3} =~ 'mbr' & {P4} !~ 'pf') \
    /if (pfs_force) \
      !party leader %{P2}%; \
    /else \
      !t $[tolower({P2})] pf%; \
      /set pfs_stragglers=1%; \
    /endif%; \
  /endif%; \
  @update_status

/def -Fp5 -mregexp -t'^   ([A-Z][a-z]+) +(ld|mbr): aid ' party_status_aide = \
  /set aide=$[tolower({P1})]

;;
;; PARTY
;;

/def party_members = \
  /let _members=%; \
  /let i=1%; \
  /while (i <= party_members) \
    /let _member=$[expr(strcat('party_member_', i))]%; \
    /let _members=%{_members} %{_member}%; \
    /test ++i%; \
  /done%; \
  /result trim(_members)

/def is_party_member = /result strchr({1}, ' ') == -1 & isin({1}, party_members())

;;
;; FOREACH
;;
;; Perform ACTION on each item in LIST. Use %1 as the item.
;;
;; Usage: /foreach LIST = ACTION
;;
/def foreach = \
  /while ({#} & {1} !~ '=') \
    /split %{*}%; \
    /eval -s2 %{P2}%; \
    /shift%; \
  /done

/def disband = \
  /foreach $[party_members()] = \
    /if (!is_me({1})) \
      !party kick %%{1}%%; \
    /endif%; \
  !party leave

/def party = \
  /if (!getopts('f', '')) \
    /return%; \
  /endif%; \
  /if (!party_members & strlen(my_party_name)) \
    /let _cmd=!party create %{my_party_name}%; \
    /if (opt_f) \
      /test send(_cmd)%; \
    /else \
      %{_cmd}%; \
    /endif%; \
    /if (strlen(my_party_color)) \
      /let _cmd=!party colour %{my_party_color}%; \
      /if (opt_f) \
        /test send(_cmd)%; \
      /else \
        %{_cmd}%; \
      /endif%; \
    /endif%; \
  /endif

/def party_status = \
  /if (!getopts('f', '')) \
    /return%; \
  /endif%; \
  /if (strlen(aide) & is_me(aide)) \
    /let _party_status=aide status%; \
  /else \
    /let _party_status=party status%; \
  /endif%; \
  /if (opt_f) \
    !%{_party_status}%; \
  /else \
    /runif -t1 -n'party_status' -- !%{_party_status}%; \
  /endif%; \

/def -Fp5 -msimple -t'New marching order set.' new_party_order = \
  /party_status

/def -Fp5 -msimple -t'Counters reset.' party_counters_reset = \
  /quote -S /unset `/listvar -s joined_party_*

; 1   35%
; 2-3 45%
; 4-5 50%
; 6-7 85%
; 8  100%

/def get_party_bonus = \
  /if ({1} >= 8) \
    /result 100%; \
  /elseif ({1} >= 6) \
    /result 85%; \
  /elseif ({1} >= 4) \
    /result 50%; \
  /elseif ({1} >= 2) \
    /result 45%; \
  /else \
    /result 35%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) is now acting (as an aide|member) of the party\\.$' joins_party = \
  /test joined_party_$[tolower({P1})] := time()%; \
  /if (is_me(commander)) \
    /say -d'party' -f'$[get_party_bonus(party_members + 1)]%%' -x -c'green' -- Party Unfamiliar Bonus%; \
  /endif%; \
  /party_status -f%; \
  @update_status

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ is now leader of the party!$' new_leader_party = \
  /party_status

/def -Fp5 -msimple -t'You are now the leader of the party!' me_leader_party = \
  /party_status

/def -Fp5 -msimple -t'No more active members. Party destroyed.' party_destroyed = \
  /test tank := me()%; \
  /set commander=%{tank}%; \
  /unset aide%; \
  /quote -S /unset `/listvar -s party_*%; \
  /set party_members=0%; \
  @on_leave_party %{P1}%; \
  @update_status

/def -Fp5 -msimple -t'You were the only member.' party_disbanded = \
  /party_destroyed

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) left the party\\.' leaves_party = \
  /if ({P1} =~ 'You') \
    /party_destroyed%; \
    /return%; \
  /endif%; \
  /if (is_me(commander)) \
    /say -d'party' -f'$[get_party_bonus(party_members - 1)]%%' -x -c'red' -- Party Unfamiliar Bonus%; \
  /endif%; \
  /party_status -f

/def -Fp5 -mregexp -t'^You created a party called (.+)\\.$' create_party = \
  /set my_party_name=%{P1}%; \
  /party_counters_reset%; \
  /party_status -f%; \
  /save_basic%; \
  @on_create_party %{P1}

/def -Fp5 -mregexp -t'^You are joined to the party of ([A-Z][a-z]+) as an aide\\.$' join_party_as_aide = \
  /substitute -- %{*} [$[ftime('%T')]]%; \
  /party_counters_reset%; \
  /test joined_party_$[tolower(me())] := time()%; \
  /test aide := me()%; \
  /party_status -f%; \
  @on_join_party %{P1}

/def -Fp5 -mregexp -t'^You are joined to the party of ([A-Z][a-z]+)\\.$' join_party = \
  /substitute -- %{*} [$[ftime('%T')]]%; \
  /party_counters_reset%; \
  /test joined_party_$[tolower(me())] := time()%; \
  /party_status -f%; \
  @on_join_party %{P1}

/def -Fp5 -msimple -t'You already are an aide to a party!' already_aide = \
  /party_status

/def -Fp5 -msimple -t'You already are in a party!' already_in_party = \
  /party_status

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) is already in a party\\.$' other_already_in_party = \
  /say -d'think' -- %{P1} already in party!

;;
;; PARTY SHARES
;;
;; Reports the party shares.
;;
;; Usage: /pss [COMMAND]
;;
/def pss = \
  /if (!party_members) \
    /return%; \
  /endif%; \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen --%; \
  /endif%; \
  /let i=1%; \
  /execute %{_cmd} .------------------------------------------------------.%; \
  /execute %{_cmd} | $[pad(party_name, -15)] $[pad(strcat(to_kmg(party_exp), ' at ', to_kmg(party_rate), '/min'), 36)] |%; \
  /execute %{_cmd} |------------------------------------------------------|%; \
  /while (i <= party_members) \
    /let _name=$[expr(strcat('party_member_', i))]%; \
    /if (strlen(_name) < 1) \
      /break%; \
    /endif%; \
    /let _exp=$[expr(strcat('party_member_', i, '_exp'))]%; \
    /let _level=$[expr(strcat('party_member_', i, '_lvl'))]%; \
    /let _percent=$[round(_exp * 100 / max(party_exp, 1), 2)]%; \
    /let _rate=$[_exp * party_rate / max(party_exp, 1)]%; \
    /execute %{_cmd} | $[pad(toupper(_name, 1), -12)] $[pad(_level, 3)] | $[pad(to_kmg(_exp), 8)] | $[pad(strcat(_percent, '%'), 7)] | $[pad(strcat(to_kmg(_rate), '/min'), 12)] |%; \
    /let i=$[i + 1]%; \
  /done%; \
  /execute %{_cmd} '------------------------------------------------------'

;;
;; UNFAMILIAR BONUSES
;;

/def -Fp5 -aCyellow -msimple -t'You learn a bit more slaying this slightly less common opponent.' unfam_bonus_10 = \
  /substitute -p -- %{*} [@{B}+10%%@{n}]

/def -Fp5 -aCgreen -msimple -t'You learn a fair deal more slaying this less familiar opponent.' unfam_bonus_20 = \
  /substitute -p -- %{*} [@{B}+20%%@{n}]

/def -Fp5 -aCcyan -msimple -t'You learn a good deal more slaying this unfamiliar opponent.' unfam_bonus_30 = \
  /substitute -p -- %{*} [@{B}+30%%@{n}]

/def -Fp5 -aCblue -msimple -t'You learn a great deal more than usual from the unfamiliar opponent.' unfam_bonus_40 = \
  /substitute -p -- %{*} [@{B}+40%%@{n}]

/def -Fp5 -aCblue -msimple -t'You learn a phenomenal deal more than usual from the unfamiliar opponent.' unfam_bonus_50 = \
  /substitute -p -- %{*} [@{B}+50%%@{n}]

;;
;; METHODS
;;

/property -g attack_command

/def attack_method = \
  /if ({#} & !isin({*}, 'cast', 'other', 'use')) \
    /error -m'%{0}' -- must be one of: cast, other, use%; \
    /update_value -n'attack_method' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'attack_method' -v'$(/escape ' %{*})' -g

/property -g attack_skill
/property -g attack_spell

/property -g heal_command

/def heal_method = \
  /if ({#} & !isin({*}, 'cast', 'other', 'use')) \
    /error -m'%{0}' -- must be one of: cast, other, use%; \
    /update_value -n'heal_method' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'heal_method' -v'$(/escape ' %{*})' -g

/property -g heal_skill
/property -g heal_spell

/property -g start_attack_command

/def start_attack_method = \
  /if ({#} & !isin({*}, 'cast', 'other', 'use')) \
    /error -m'%{0}' -- must be one of: cast, other, use%; \
    /update_value -n'start_attack_method' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'start_attack_method' -v'$(/escape ' %{*})' -g

/property -g start_attack_skill
/property -g start_attack_spell

;;
;; ACTIONS
;;

/def action_none = 0
/def action_heal = 1
/def action_attack = 2
/def action_stunned = 3

;;
;; HEAL METHODS
;;

/property -s -g on_start_heal

;;
;; DO HEAL
;;
;; The main interface for which to cast/use heals.
;;
;; Usage: /do_heal [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -a ACTION*    Either 'cast' or 'use'
;;   -d            Do not scan the target
;;   -n NAME       The proper name of this skill/spell
;;   -q            Do not announce the performing of action
;;   -s SKSP*      Name of the skill or spell to perform
;;   -t TARGET*    The name of the target on which to perform
;;   -x SPEED      Casting speed
;;
/def do_heal = \
  /if (!getopts('a:s:n:t:x:qd', '')) \
    /return%; \
  /endif%; \
  /if (opt_a !~ 'cast' & opt_a !~ 'use' & opt_a !~ 'other') \
    /error -m'%{0}' -a'a' must be one of 'cast', 'use', or 'other'%; \
    /return%; \
  /endif%; \
  /if (!strlen(opt_s)) \
    /error -m'%{0}' -a's' -- must be the name of a skill, spell or other%; \
    /return%; \
  /endif%; \
  /if (!strlen(opt_t)) \
    /error -m'%{0}' -a't' -- must be the name of a target%; \
    /return%; \
  /endif%; \
  /set action=${action_heal}%; \
  /if (opt_a =~ 'cast') \
    /if (!strlen(opt_x)) \
      /let opt_x=$[get_spell_speed(opt_s)]%; \
    /endif%; \
  /else \
    /unset opt_x%; \
  /endif%; \
  /if (opt_t =~ 'me') \
    /test opt_t := me()%; \
  /endif%; \
  /healing %{opt_t}%; \
  /if (strlen(on_start_heal)) \
    /eval %{on_start_heal}%; \
  /endif%; \
  @on_start_heal %{opt_t}%; \
  /if (!opt_d) \
    !scan %{opt_t}%; \
  /endif%; \
  /if (opt_a =~ 'other') \
    /let _cmd=%{opt_s}%; \
  /else \
    /let _cmd=%{opt_a} '%{opt_s}'%; \
  /endif%; \
  !%{_cmd} %{opt_t} $[strlen(opt_x) ? strcat('try ', opt_x) : '']%; \
  /if (report_sksp & !opt_q) \
    /say -f'$(/escape ' %{opt_t})' -- $[capitalize({opt_n-%{opt_s}})]%; \
  /else \
    /say -d'status' -f'$(/escape ' %{opt_t})' -- $[capitalize({opt_n-%{opt_s}})]%; \
  /endif%; \
  @update_status

/def -Fp5 -mregexp -t'^You heal .+ of (.+)\'s wounds\\.' scan_healing = \
  /if ({P1} !~ 'your') \
    !scan $[tolower({P1})]%; \
  /endif

;;
;; HEALING
;;
;; Sets the healing alias and sets local copy.
;;
;; Usage: /healing [TARGET]
;;
/def healing = /alias healing %{*}

;;
;; HEAL
;;
;; The basic heal macro that calls /do_heal with default settings.
;;
;; Usage: /h [TARGET]
;;
/def h = \
  /let _target=%{*-%{healing-%{tank}}}%; \
  /if (!strlen(_target)) \
    /error -m'%{0}' -- you passed no parameters while {healing} is null%; \
    /return%; \
  /endif%; \
  /if (heal_method =~ 'cast' & strlen(heal_spell)) \
    /let _sksp=%{heal_spell}%; \
  /elseif (heal_method =~ 'use' & strlen(heal_skill)) \
    /let _sksp=%{heal_skill}%; \
  /elseif (heal_method =~ 'other' & strlen(heal_command)) \
    /let _sksp=%{heal_command}%; \
  /else \
    /error -m'%{0}' -- {heal_method}, {heal_skill}, {heal_spell}, or {heal_command} are invalid%; \
    /return%; \
  /endif%; \
  /do_heal -a'%{heal_method}' -s'$(/escape ' %{_sksp})' -t'$(/escape ' %{_target})'

;;
;; HEAL TANK
;;
;; Sets the healing target to the current {tank}.
;;
;; Usage: /ht
;;
/def ht = /healing %{tank-$[me()]}

;;
;; ATTACK METHODS
;;

/property -s -g on_start_attack

;;
;; DO KILL
;;
;; The main interface for which to cast/use attacks.
;;
;; Usage: /do_kill [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -a ACTION*    Either 'cast' or 'use'
;;   -i            This is an initiator skill/spell
;;   -k            Kill the target as well as start skill/spell
;;   -m            Use kill all instead of kill
;;   -n NAME       The pretty name of the skill/spell
;;   -q            Do this attack as quietly as possible
;;   -s SKSP*      Name of the skill or spell to perform
;;   -t TARGET*    The name of the target on which to perform
;;   -v            Verbose. Announce always.
;;   -x SPEED      Casting speed
;;
/def do_kill = \
  /if (!getopts('a:mn:s:t:x:kqvi', '')) \
    /return%; \
  /endif%; \
  /if (opt_a !~ 'cast' & opt_a !~ 'use' & opt_a !~ 'other') \
    /error -m'%{0}' -a'a' must be one of 'cast', 'use', or 'other'%; \
    /return%; \
  /endif%; \
  /if (!strlen(opt_s)) \
    /error -m'%{0}' -a's' -- must be the name of a skill or spell%; \
    /return%; \
  /endif%; \
  /if (opt_a =~ 'cast') \
    /if (!strlen(opt_x)) \
      /let opt_x=$[get_spell_speed(opt_s)]%; \
    /endif%; \
  /else \
    /unset opt_x%; \
  /endif%; \
  /let opt_q=$[opt_q | quiet_mode]%; \
  /set action=${action_attack}%; \
  /if (!strlen(opt_t)) \
    /say -d'status' -- %{opt_a} '%{opt_s}'%; \
    /if (opt_a =~ 'other') \
      /let _cmd=%{opt_s}%; \
    /else \
      /let _cmd=%{opt_a} '%{opt_s}'%; \
    /endif%; \
    !%{_cmd} $[strlen(opt_x) ? strcat('try ', opt_x) : '']%; \
    /return%; \
  /endif%; \
  /if (opt_q) \
    /set_target_quietly %{opt_t}%; \
  /else \
    /set_target %{opt_t}%; \
    /if (opt_i & is_me(tank)) \
      !drop all corpse%; \
      /if (bag) \
        /if (p_cash > 0) \
          !put %{p_cash} gold in bag of holding%; \
        /endif%; \
        /if (stuff_bag) \
          !put noeq in bag of holding%; \
        /endif%; \
      /endif%; \
      /if (give_noeq_target) \
        !give noeq to %{opt_t}%; \
      /endif%; \
    /endif%; \
    /if (strlen(on_start_attack)) \
      /eval %{on_start_attack}%; \
    /endif%; \
    @on_start_attack %{opt_t}%; \
    /if (opt_k) \
      !kill $[opt_m ? 'all ' : '']%{opt_t}%; \
    /endif%; \
    /if (opt_v | (report_target & party_members > 1)) \
      /say -f'$(/escape ' %{opt_t})' -b -x -- $[capitalize({opt_n-%{opt_s}})]%; \
    /endif%; \
  /endif%; \
  /let _time=$[last_tick()]%; \
  /if (!opt_k & _time > tick_time / 2 & _time < tick_time * 2) \
    /tick%; \
  /endif%; \
  /say -d'status' -f'$(/escape ' %{opt_t})' -- $[opt_k ? 'Killing + ' : '']%{opt_s}%; \
  /if (opt_a =~ 'other') \
    /let _cmd=%{opt_s}%; \
  /else \
    /let _cmd=%{opt_a} '%{opt_s}'%; \
  /endif%; \
  !%{_cmd} $[opt_k & !opt_q ? '' : opt_t] $[strlen(opt_x) ? strcat('try ', opt_x) : '']

;;
;; KILL NOTHING
;;
;; Restarts the previous skill or spell without using a target.
;;
;; Usage: /kx
;;
/def kx = \
  /if (attack_method =~ 'cast' & strlen(attack_spell)) \
    /let _sksp=%{attack_spell}%; \
  /elseif (attack_method =~ 'use' & strlen(attack_skill)) \
    /let _sksp=%{attack_skill}%; \
  /elseif (attack_method =~ 'other' & strlen(attack_command)) \
    /let _sksp=%{attack_command}%; \
  /else \
    /error -m'%{0}' -- {attack_method}, {attack_skill}, {attack_spell}, or {attack_command} are invalid%; \
    /return%; \
  /endif%; \
  /do_kill -a'%{attack_method}' -s'$(/escape ' %{_sksp})'

;;
;; KILL WITH SKILL/SPELL
;;
;; Starts the default skill/spell at the TARGET.
;;
;; Usage: /k [TARGET]
;;
/def k = \
  /let _target=%{*-%{target}}%; \
  /if (!strlen(_target)) \
    /error -m'%{0}' -- you passed no parameters while {target} is null%; \
    /return%; \
  /endif%; \
  /if (attack_method =~ 'cast' & strlen(attack_spell)) \
    /let _sksp=%{attack_spell}%; \
  /elseif (attack_method =~ 'use' & strlen(attack_skill)) \
    /let _sksp=%{attack_skill}%; \
  /elseif (attack_method =~ 'other' & strlen(attack_command)) \
    /let _sksp=%{attack_command}%; \
  /else \
    /error -m'%{0}' -- {attack_method}, {attack_skill}, {attack_spell}, or {attack_command} are invalid%; \
    /return%; \
  /endif%; \
  /do_kill -a'%{attack_method}' -s'$(/escape ' %{_sksp})' -t'$(/escape ' %{_target})'

;;
;; KILL QUIETLY
;;
;; Like /k except that it doesn't use the target emote / announce TARGET.
;;
;; Usage: /kq [TARGET]
;;
/def kq = \
  /let _target=%{*-%{target}}%; \
  /if (!strlen(_target)) \
    /error -m'%{0}' -- you passed no parameters while {target} is null%; \
    /return%; \
  /endif%; \
  /if (attack_method =~ 'cast' & strlen(attack_spell)) \
    /let _sksp=%{attack_spell}%; \
  /elseif (attack_method =~ 'use' & strlen(attack_skill)) \
    /let _sksp=%{attack_skill}%; \
  /elseif (attack_method =~ 'other' & strlen(attack_command)) \
    /let _sksp=%{attack_command}%; \
  /else \
    /error -m'%{0}' -- {attack_method}, {attack_skill}, {attack_spell}, or {attack_command} are invalid%; \
    /return%; \
  /endif%; \
  /do_kill -a'%{attack_method}' -s'$(/escape ' %{_sksp})' -t'$(/escape ' %{_target})' -q

;;
;; KILL AND KILL
;;
;; Like /k except that it uses the kill command as well.
;;
;; Usage: /kk [TARGET]
;;
/def kk = \
  /let _target=%{*-%{target}}%; \
  /if (!strlen(_target)) \
    /error -m'%{0}' -- you passed no parameters while {target} is null%; \
    /return%; \
  /endif%; \
  /if (attack_method =~ 'cast' & strlen(attack_spell)) \
    /let _sksp=%{attack_spell}%; \
  /elseif (attack_method =~ 'use' & strlen(attack_skill)) \
    /let _sksp=%{attack_skill}%; \
  /elseif (attack_method =~ 'other' & strlen(attack_command)) \
    /let _sksp=%{attack_command}%; \
  /else \
    /error -m'%{0}' -- {attack_method}, {attack_skill}, {attack_spell}, or {attack_command} are invalid%; \
    /return%; \
  /endif%; \
  /do_kill -a'%{attack_method}' -s'$(/escape ' %{_sksp})' -t'$(/escape ' %{_target})' -k

;;
;; KILL START
;;
;; Like /k except it uses the {start_attack_skill{/{start_attack_spell} with -i.
;;
;; Usage: /ks [TARGET]
;;
/def ks = \
  /let _target=%{*-%{target}}%; \
  /if (!strlen(_target)) \
    /error -m'%{0}' -- You passed no parameters while {target} is null%; \
    /return%; \
  /endif%; \
  /if (start_attack_method =~ 'cast' & strlen(start_attack_spell)) \
    /let _sksp=%{start_attack_spell}%; \
  /elseif (start_attack_method =~ 'use' & strlen(start_attack_skill)) \
    /let _sksp=%{start_attack_skill}%; \
  /elseif (start_attack_method =~ 'other' & strlen(start_attack_command)) \
    /let _sksp=%{start_attack_command}%; \
  /else \
    /error -m'%{0}' -- {start_attack_method}, {start_attack_skill}, {start_attack_spell}, or {start_attack_command} are invalid%; \
    /return%; \
  /endif%; \
  /do_kill -a'%{start_attack_method}' -s'$(/escape ' %{_sksp})' -t'$(/escape ' %{_target})' -i

;;
;; KILL ALL
;;
;; Like /kk except it attacks all of a certain type of monster.
;;
;; Usage: /ka [TARGET]
;;
/def ka = \
  /let _target=%{*-%{target}}%; \
  /if (!strlen(_target)) \
    /error -m'%{0}' -- you passed no parameters while {target} is null%; \
    /return%; \
  /endif%; \
  /if (attack_method =~ 'cast' & strlen(attack_spell)) \
    /let _sksp=%{attack_spell}%; \
  /elseif (attack_method =~ 'use' & strlen(attack_skill)) \
    /let _sksp=%{attack_skill}%; \
  /elseif (attack_method =~ 'other' & strlen(attack_command)) \
    /let _sksp=%{attack_command}%; \
  /else \
    /error -m'%{0}' -- {attack_method}, {attack_skill}, {attack_spell}, or {attack_command} are invalid%; \
    /return%; \
  /endif%; \
  /do_kill -a'%{attack_method}' -s'$(/escape ' %{_sksp})' -t'$(/escape ' %{_target})' -k -m

;;
;; SWIMMING
;;

/def -Fp5 -msimple -t'You feel rested and ready to swim.' swim_ready = /say -- Ready to Swim!
/def -Fp5 -mglob -t'Try as you might, you are just too tired to swim *.' swim_fail = \
  /runif -n'drowning' -t5 -- /say -d'party' -m -x -c'red' -- ACK!! I'M DROWNING!!

;;
;; TITLE
;;

/property -g title

/def update_title = \
  /if (getopts('f', '')) \
    /test send(strcat('!title ', title))%; \
  /else \
    !title %{title}%; \
  /endif

/def -Fp5 -mregexp -t'^Title set to: \'(.+)\'\\.$' title_set = \
  /set title=%{P1}

/def -Fp5 -msimple -t'The balloon explodes in your face DRENCHING you! *POP*' title_drenched = \
  /update_title

; studying/training
;/def -Fp5 -ag -mregexp -t'^\| ([a-z0-9]+( [a-z0-9]+)*) +\| *(\\d+)\| *(\\d+)\| *(\\d+)\| *(\\d+(\\.\\d+)?[Mk]?)\| *(\\d+)\|$' sksp_highlite = /if ({P4} < {P5}) /echo -w -- %{*}%; /endif

;;
;; COMBAT
;;

/def -Fp5 -mregexp -t'^You are now hunted by (.+)\\.$' being_hunted = \
  /say -d'party' -t -m -x -c'red' -- Wimpied from %{P1}!

/def -Fp5 -mregexp -t'You feel (.+) didn\'t enjoy your presence\\.$' got_banished = \
  /if (!prot_count('kamikaze')) \
    /say -d'party' -n3 -t -m -x -c'red' -- WARNING!! $[toupper({P1})] BANISHED ME! RUN FOR THE HILLS!%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Za-z,:\' -]+) arrives(.*)\\.$' other_arrives = \
  /if ({P1} =~ target_name) \
    /say -d'party' -c'red' -t -m -x -- WARNING!! $[toupper({P1})] ARRIVED! WARNING!!%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Za-z,:\' -]+) leaves(.*)\\.$' other_leaves = \
  /if ({P1} =~ target_name) \
    /say -d'party' -t -m -x -- %{P1} Left the Room!%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Za-z,:\' -]+) staggers and reels from the blow!$' other_stunned = \
  /if (tolower({P1}) =~ tank) \
    /say -d'party' -m -x -c'red' -n3 -- $[toupper({P1})] STUNNED! ACK!%; \
  /endif%; \
  /if (party_members & strchr({P1}, ' ') < 0 & isin({P1}, party_members())) \
    /if (smelling_salt) \
      !revive $[tolower({P1})]%; \
    /endif%; \
    !count smelling salt%; \
  /endif%; \
  /if (report_warnings & {P1} =~ target_name) \
    /say -d'party' -m -x -- %{P1} is Dazed and Confused!%; \
  /endif

/def -Fp5 -mregexp -t'^There (are|is) (\\d+) \'smelling salt\'s? in your inventory\\.$' smelling_salt_count = \
  /set smelling_salt=%{P2}

/def -Fp5 -mregexp -t'^([A-Za-z,:\' -]+) seems to have regained control of [a-z]+!$' other_unstunned = \
  /if (report_warnings & {P1} =~ target_name) \
    /say -d'party' -c'red' -m -x -- $[toupper({P1})] Looks PISSED!%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Za-z,:\' -]+) starts concentrating on a spell\\.$' other_casting = \
  /if (report_warnings & {P1} =~ target_name) \
    /say -d'party' -c'red' -m -x -- Incoming spell from %{P1}!%; \
  /endif

/def -Fp5 -msimple -t'You are stunned and unable to fight.' stunned_round = \
  /set stunned_rounds=$[stunned_rounds + 1]%; \
  /substitute -aBCred -- *STUNNED ROUND %{stunned_rounds}*

/def -Fp5 -msimple -t'You break out from the stun.' unstunned = \
  /slash_stagger%; \
  /if (party_members > 1) \
    /say -d'party' -- FREE FROM STUN! (%{stunned_rounds} round$[stunned_rounds == 1 ? '' : 's'])%; \
  /endif%; \
  /set stunned_rounds=0

/property -s -g on_unstunned

/def -Fp5 -msimple -t'You stagger and see stars appear before your eyes, making you lose ' slash_stagger = \
  /if (action == ${action_attack}) \
    /kx%; \
  /endif%; \
  /if (strlen(on_unstunned)) \
    /eval %{on_unstunned}%; \
  /endif%; \
  @on_unstunned%; \

/def -Fp5 -mregexp -t'^[A-Za-z,:\' -]+ awesome slash breaks your concentration\\.$' slash_stun = /slash_stagger

/def -Fp5 -mregexp -t'^[A-Za-z,:\' -]+ breaks your concentration with his devastating assault\\.$' devastating_assault = /slash_stagger

/def -Fp5 -msimple -t'You can\'t use this skill while you or the target is fighting.' start_attack_interrupted = /slash_stagger

/def -Fp5 -mregexp -t'^[A-Z][a-z]+\'s taunting enrages you\\.$' taunted = /slash_stagger

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ moves with amazing speed and disarms you with a hurtful blow!$' disarmed = !slots

/def -Fp5 -mregexp -t'^[A-Z][a-z]+\'s attack breaks your concentration\\.$' concentration_broken = /slash_stagger

/def -Fp5 -mregexp -t'^You feel like ([A-Za-z]+) is looking over your shoulder\\.$' somebody_snooping = \
  /say -x -c'red' -- EEP! $[toupper({P1})] is snooping me!

;;
;; RIP AND CORPSING
;;

/def on_looted = \
  /update_value -n'on_looted' -v'$(/escape ' %{*})' -s -g%; \
  /update_autoloot

/def on_kill = \
  /update_value -n'on_kill' -v'$(/escape ' %{*})' -b%; \
  /update_autoloot

/def on_kill_loot = \
  /update_value -n'on_kill_loot' -v'$(/escape ' %{*})' -b%; \
  /update_autoloot

/def update_autoloot = \
  /if (on_kill & on_kill_loot & !strlen(on_looted)) \
    /if (autoloot !~ 'own') \
      !set autoloot own%; \
    /endif%; \
  /else \
    /if (autoloot !~ 'off') \
      !set autoloot off%; \
    /endif%; \
  /endif

/def -Fp5 -mregexp -t'^You set the value of variable autoloot to "(off|own|all)"\\.$' autoloot_set = \
  /set autoloot=%{P1}

/property -s -g on_kill_give_to

/def tin = \
  !tin corpse%; \
  /if (bag & stuff_bag) \
    !get all can to bag of holding%; \
  /endif%; \
  !get all can

/def on_kill_corpse = \
  /if ({#} & !isin({*}, 'carriage', 'dig', 'eat', 'get', 'leave', 'stuff', 'tin')) \
    /error -m'%{0}' -- must be one of: carriage, dig, eat, get, leave, stuff, tin%; \
    /update_value -n'on_kill_corpse' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'on_kill_corpse' -v'$(/escape ' %{*})' -g

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) takes ' looted = \
  /if (tolower({P1}) =~ on_looted) \
    /loot%; \
  /endif

/property -s -g on_enemy_killed

/def -Fp5 -mregexp -t'^([A-Za-z,:\' -]+) is DEAD, R\\.I\\.P\\.$' enemy_killed = \
  /if ({P1} =~ target_name) \
    !save%; \
    /let _time=$[time() - kill_time]%; \
    /let _stats=%{rounds} round$[rounds == 1 ? '' : 's'], $[to_dhms(_time > 60*60*24 ? -1 : _time)]%; \
    /substitute -- %{*} [%{_stats}]%; \
    /if (report_kills) \
      /say -d'party' -m -x -c'green' -- %{P1} BITES the DUST! (%{_stats})%; \
    /endif%; \
    /set kill_time=0%; \
    /set rounds=0%; \
    /if (strlen(on_enemy_killed)) \
      /eval %{on_enemy_killed}%; \
    /endif%; \
    @on_enemy_killed %{P1}%; \
    /if (on_kill & !strlen(on_looted)) \
      /loot%; \
    /endif%; \
  /endif

/def corpse = \
  /if (on_kill_corpse =~ 'eat') \
    !get corpse%; \
    !eat corpse%; \
  /elseif (on_kill_corpse =~ 'tin') \
    /tin%; \
  /elseif (on_kill_corpse =~ 'dig') \
    !dg%; \
  /elseif (on_kill_corpse =~ 'carriage') \
    !get all corpse%; \
    !put all in carriage%; \
  /elseif (on_kill_corpse =~ 'get') \
    !get all corpse%; \
  /elseif (on_kill_corpse =~ 'stuff') \
    !stuff corpse%; \
  /endif

/property -s -g on_loot

/def loot = \
  /if (on_kill_loot) \
    /if (bag & stuff_bag & (!strlen(on_kill_give_to) | (on_kill_give_to =~ 'tank' & is_me(tank)))) \
      !get all from corpse to bag of holding%; \
    /endif%; \
    !loot%; \
    /if (bag) \
      !put all scroll,all parchment,all key in bag of holding%; \
    /endif%; \
    !keep all scroll,all parchment,all key%; \
    !drop all box%; \
  /endif%; \
  /corpse%; \
  /if (strlen(on_loot)) \
    /eval %{on_loot}%; \
  /endif%; \
  @on_loot %{P1}%; \
  /if (strlen(on_kill_give_to)) \
    /if (on_kill_give_to =~ 'tank') \
      /if (!is_me(tank)) \
        !give noeq to %{tank}%; \
      /endif%; \
    /else \
      !give noeq to %{on_kill_give_to}%; \
    /endif%; \
  /endif%; \
  /if (on_kill_loot & bag) \
    /if (stuff_bag) \
      !put noeq in bag of holding%; \
    /endif%; \
    /if (p_cash > 0) \
      !put %{p_cash} gold in bag of holding%; \
    /endif%; \
  /endif

;;
;; CARRIAGE TRIGGERS
;;

/def -Fp5 -msimple -t'The carriage disappears in puff of smoke.' carriage_leaves = \
  /say -- Carriage Gone!%; \
  /set on_kill_corpse=leave%; \
  /unset carriage_type%; \
  /unset carriage_capacity%; \
  /unset carriage_time%; \
  @update_status

/def -Fp5 -mregexp -t'^You rent (an advanced|a normal) carriage of (\\d+) kg capacity for (\\d+) minutes\\.$' rent_carriage = \
  /set on_kill_corpse=carriage%; \
  /set carriage_type=%{P1}%; \
  /set carriage_capacity=%{P2}%; \
  /set carriage_time=%{P3}%; \
  /say -- Rented %{P1} Carriage (%{P2} kg, %{P3} min)%; \
  @update_status

;;
;; COMBAT
;;

/property -s -g on_new_round

/def -Fp5 -msimple -t'*NEW ROUND*' new_round = \
  /if (strlen(on_new_round)) \
    /eval %{on_new_round}%; \
  /endif%; \
  /if (action == ${action_stunned}) \
    /echo -w -aBCbgblue,Cwhite -- Use SKILL or cast SPELL again!%; \
  /elseif (action == ${action_attack}) \
    /if (time_sksp_end > time_sksp_start) \
      /if (time() - time_sksp_end > 60) \
        /echo -w -aBCbgblue,Cwhite -- Over 1m since SKILL or SPELL ended!%; \
      /elseif (time() - time_sksp_end > 12) \
        /echo -w -aBCbgblue,Cwhite -- Over 12s since SKILL or SPELL ended!%; \
      /endif%; \
    /else \
      /if (time() - time_sksp_start > 60) \
        /echo -w -aBCbgblue,Cwhite -- Over 1m since SKILL or SPELL started!%; \
      /elseif (time() - time_sksp_start > 12) \
        /echo -w -aBCbgblue,Cwhite -- Over 12s since SKILL or SPELL started!%; \
      /endif%; \
    /endif%; \
  /endif%; \
  /send%; \
  /if (!rounds) \
    /test kill_time := time()%; \
  /endif%; \
  /set rounds=$[rounds + 1]%; \
  /substitute -aBCred -- *ROUND %{rounds}*%; \
  @on_new_round

;;
;; DEATH
;;

/def -ag -Fp5 -msimple -t'Alive?' alive = \
  /set dead=0%; \
  /enter_game

/def -Fp5 -msimple -t'You die.' you_die = \
  /set dead=1

/property -s -g on_alive

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) appears in a solid form\\.$' resurrected = \
  /if (is_me({P1})) \
    /prayed%; \
  /endif

/def -Fp5 -msimple -t'You reappear in a more solid form.' prayed =  \
  /send ${status_prompt}%; \
  /if (strlen(on_alive)) \
    /eval %{on_alive}%; \
  /endif%; \
  /set dead=0

;;
;; SKILL/SPELL CASTING
;;

/property -s on_sksp

/def -Fp5 -mregexp -t'^You (start chanting|begin to weave your spell|start concentrating on the skill)\\.$' start_sksp = \
  /test time_sksp_start := time()

/def -Fp5 -mregexp -t'^You are (done with the chant|finished with your spell|prepared to do the skill)\\.$' done_sksp = \
  /let _time=$[time() - time_sksp_start]%; \
  /if (_time < 1000) \
    /let _time=$[round(abs(_time), 1)]%; \
    /substitute -- %{P0} [%{_time}s]%; \
  /endif%; \
  /test time_sksp_end := time()%; \
  /if (strlen(on_sksp)) \
    /eval %{on_sksp}%; \
    /unset on_sksp%; \
  /endif%; \
  /send


/def -Fp5 -mregexp -t'^(Use|Cast) .+ at who?$' sksp_at_who = \
  /test time_sksp_end := time()


;;
;; AWAY
;;
;; Sets away with MESSAGE or returns from away.
;;
;; Usage: /away [OPTIONS] -- [MESSAGE]
;;
;;  OPTIONS:
;;
;;   -q            Quietly return from away.
;;
/def away = \
  /if (!getopts('q', '')) \
    /return%; \
  /endif%; \
  /if (away) \
    /if ({#}) \
      /set away_message=%{*}%; \
      /say -d'status' -- Away re-set '%{away_message}'.%; \
      /return%; \
    /endif%; \
    /set away=0%; \
    /say -d'status' -- Back from '%{away_message}' after $[to_dhms(time() - away_time, 1)].%; \
    /if (!opt_q) \
      /let _message=is back from '%{away_message}' after $[to_dhms(time() - away_time, 1)].%; \
      /foreach %{away_tells} = !emoteto %%{1} %%{_message}%; \
    /endif%; \
    @update_status%; \
    /return%; \
  /endif%; \
  /if (!{#}) \
    /error -m'%{0}' -- mesage required%; \
    /return%; \
  /endif%; \
  /set away=1%; \
  /set away_message=%{*}%; \
  /test away_time := time()%; \
  /unset away_tells%; \
  /quote -S /unset `/listvar -s away_tell_*%; \
  /say -d'status' -- Away set '%{away_message}'.%; \
  @update_status

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) tells you,? ' away_tells = \
  /let _name=$[tolower({P1})]%; \
  /let _last=$[expr(strcat('away_tell_', _name))]%; \
  /if (away & time() - _last > 300) \
    /send -- !emoteto $[tolower({P1})] left $[to_dhms(time() - away_time, 1)] ago for '%{away_message}'.%; \
    /set away_tell_%{_name}=$[time()]%; \
    /set away_tells=$(/unique %{_name} %{away_tells})%; \
  /endif

/def -Fp0 -mglob -h'SEND *' do_send = \
  /if (regmatch('^@', {*})) \
    /return%; \
  /endif%; \
  /if (!is_away()) \
    /test send({*})%; \
  /elseif ({#}) \
    /echo -w -a%{echo_attr} -- [%{*}]%; \
  /endif

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ calls a blessing on you\\.$' blessing = \
  /def -n1 -Fp5 -mregexp -t'' blessing_type = \
    /if (regmatch('^You (.+)\\.', {*})) \
      !emote $$(/first %%{P1})s $$(/rest %%{P1})!%%; \
    /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) already has been blessed by ([A-Z][a-z]+)\\.$' already_bless = \
  !whisper $[tolower({P1})] %{P2} already blessed you.


;;
;; DO PROT
;;
;; The main interface where prots are cast. This keeps messages consistent.
;;
;; Usage: /do_prot [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -a ACTION     Either 'cast' or 'use'
;;   -n NAME       The proper name of this skill/spell
;;   -q            Do not announce the performing of action
;;   -s SKSP       The name of the skill/spell to perform
;;   -t TARGET     The target on which to perform action
;;   -x SPEED      Casting speed
;;
/def do_prot = \
  /if (!getopts('a:s:n:t:x:q', '')) \
    /return%; \
  /endif%; \
  /if (opt_a !~ 'cast' & opt_a !~ 'use') \
    /error -m'%{0}' -a'a' -- must be one of 'use' or 'cast'%; \
    /return%; \
  /endif%; \
  /if (!strlen(opt_s)) \
    /error -m'%{0}' -a's' -- must be the name of a spell%; \
    /return%; \
  /endif%; \
  /if (opt_a =~ 'cast') \
    /if (!strlen(opt_x)) \
      /let opt_x=$[get_spell_speed(opt_s)]%; \
    /endif%; \
  /else \
    /unset opt_x%; \
  /endif%; \
  /if (!strlen(opt_t)) \
    !%{opt_a} '%{opt_s}' $[strlen(opt_x) ? strcat('try ', opt_x) : '']%; \
    /if (report_sksp & !opt_q) \
      /say -- %{opt_n-%{opt_s}}%; \
    /else \
      /say -d'status' -- %{opt_n-%{opt_s}}%; \
    /endif%; \
    /return%; \
  /endif%; \
  /if (opt_t =~ 'me') \
    /let opt_t=$[me()]%; \
  /endif%; \
  !%{opt_a} '%{opt_s}' %{opt_t} $[strlen(opt_x) ? strcat('try ', opt_x) : '']%; \
  /if (report_sksp & !opt_q) \
    /say -f'$(/escape ' %{opt_t})' -- $[capitalize({opt_n-%{opt_s}})]%; \
  /else \
    /say -d'status' -f'$(/escape ' %{opt_t})' -- $[capitalize({opt_n-%{opt_s}})]%; \
  /endif

;;
;; SPELL SPEED
;;
;; Update/view the casting speeds for SPELLs.
;;
;; Usage: /spell_speed [OPTIONS] -- SPELL
;;
;;  OPTIONS:
;;
;;   -c            Clear all spell speeds
;;   -d            Reset the spell speed to default.
;;   -x SPEED      The speed at which to cast this spell
;;
/def try = /spell_speed %{*}
/def spell_speed = \
  /if (!getopts('x:dc', '')) \
    /return%; \
  /endif%; \
  /if (!{#}) \
    /let _cmd=/echo -w -p -aCgreen --%; \
    /execute %{_cmd} .--------------------------------.----------------------.%; \
    /execute %{_cmd} | SPELL                          |                SPEED |%; \
    /execute %{_cmd} |--------------------------------+----------------------|%; \
    /foreach %{spell_speed} = \
      /let _var=spell_speed_%%{1}%%; \
      /eval -s0 %%{_cmd} | $$[pad(textdecode({1}), -30)] | $$[pad(expr(_var), 20)] |%; \
    /execute %{_cmd} '--------------------------------'----------------------'%; \
    /return%; \
  /endif%; \
  /let _spell=%{*}%; \
  /let _key=$[textencode(_spell)]%; \
  /let _var=spell_speed_%{_key}%; \
  /if (opt_c) \
    /quote -S /unset `/listvar -s spell_speed_*%; \
    /unset spell_speed%; \
    /say -d'status' -- All spell speeds have been cleared%; \
    /return%; \
  /endif%; \
  /if (opt_d) \
    /unset %{_var}%; \
    /set spell_speed=$(/remove %{_key} %{spell_speed})%; \
  /elseif (strlen(opt_x)) \
    /test %{_var} := opt_x%; \
    /set spell_speed=$(/unique %{spell_speed} %{_key})%; \
  /endif%; \
  /let _speed=$[expr(_var)]%; \
  /if (!strlen(_speed)) \
    /let _speed=default%; \
  /endif%; \
  /say -d'status' -- Spell speed for '%{_spell}' is set to %{_speed}

;;
;; GET SPELL SPEED
;;
;; Returns the speed of the given SPELL.
;;
;; Usage: /get_spell_speed SPELL
;;
/def get_spell_speed = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /let _key=spell_speed_$[textencode({*})]%; \
  /result expr(_key)

;;
;; /1, /2 .. /100
;;
;; Repeat COMMAND n times.
;;
;; Usage: /n COMMAND
;;
/for i 1 100 /def %{i} = /repeat -S %{i} %%{*}

;;
;; Turns commands into order of 20. (23 x > 20 x, 3 x)
;;
/def -p5 -mregexp -h"SEND ^(\\d+) " ncommand = \
  /let _repeats=$[trunc({P1} / 20)]%; \
  /let _mod=$[mod({P1}, 20)]%; \
  /let _cmd=%{PR}%; \
  /if (_repeats) \
    /repeat -S %{_repeats} !20 %{_cmd}%; \
  /endif%; \
  /if (_mod) \
    !%{_mod} %{_cmd}%; \
  /endif

;;
;; CAST STOP
;;
;; Stops casting of spell and reports to party.
;;
;; Usage: /cs
;;
/def cs = \
  !cast stop%; \
  /if ((is_me(tank) | is_me(commander)) & party_members > 1) \
    /say -d'party' -m -x -c'red' -- STOP! HALT! CAST STOP!%; \
  /endif

;;
;; DRINK MOONSHINE
;;
;; Drinks moonshine.
;;
;; Usage: /dm
;;
/def dm = \
  /if (bag) \
    !get moonshine from bag of holding%; \
  /endif%; \
  !drink moonshine%; \
  /if (bag) \
    !put all moonshine in bag of holding%; \
  /endif%; \
  !keep all moonshine%; \
  !drop all bottle

;;
;; CHAIN
;;
;; Uses mud to define a chain loop. Use underscore instead of spaces for SKSP.
;;
;; Usage: /chain SKSP [SKSP] [...]
;;
/def chain = \
  /if (!getopts('t:', '') | !{#}) \
    /error -m'%{0}' -- need spells/skills to chain%; \
    /return%; \
  /endif%; \
  /let i=1%; \
  /let j=$(/length %{*})%; \
  /let _first=$(/first %{*})%; \
  /let _last=$(/last %{*})%; \
  /let _prev=%{_first}%; \
  /while (i < j) \
    /let _curr=$(/nth $[i + 1] %{*})%; \
    !chain $[replace('_', ' ', strcat(_prev, ':', _curr))]$[strlen(opt_t) ? strcat(':', opt_t) : '']%; \
    /let _prev=%{_curr}%; \
    /test ++i%; \
  /done%; \
  !chain $[replace('_', ' ', strcat(_last, ':', _first))]$[strlen(opt_t) ? strcat(':', opt_t) : '']

;;
;; REINC TAX
;;
;; Calculates your reinc tax.
;;
;; Usage: /reinc_tax [COMMAND]
;;
/def reinc_tax = \
  /if (!reinc_time) \
    /error -m'%{0}' -- {reinc_time} has not been set (type score2)%; \
    /return%; \
  /endif%; \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _days=$[trunc((time() - reinc_time) / (60 * 60 * 24))]%; \
  /let _weeks=$[trunc(_days / 7)]%; \
  /if (_days < 0) \
    /let _days=0%; \
  /endif%; \
  /let _maxdays=33%; \
  /let _maxtax=5%; \
  /if (_days > _maxdays) \
    /let _tax=1%; \
  /else \
    /let _tax=$[_maxtax - trunc(_days * (_maxtax - 1) / _maxdays)]%; \
  /endif%; \
  /let _tax=$[trunc(_tax)]%; \
  /execute %{_cmd} Reinced %{_weeks} week$[_weeks == 1 ? '' : 's'] (%{_days} day$[_days == 1 ? '' : 's']) ago on $[ftime("%B %d, %Y", reinc_time)]. The current tax is %{_tax} percent.

/def -Fp10 -mregexp -t'Reinced: ([A-Z][a-z]{2}) (\\d{1,2}) (\\d{4})' reinc_date = \
  /if ({P1} =~ 'Jan') \
    /let _month=1%; \
  /elseif ({P1} =~ 'Feb') \
    /let _month=2%; \
  /elseif ({P1} =~ 'Mar') \
    /let _month=3%; \
  /elseif ({P1} =~ 'Apr') \
    /let _month=4%; \
  /elseif ({P1} =~ 'May') \
    /let _month=5%; \
  /elseif ({P1} =~ 'Jun') \
    /let _month=6%; \
  /elseif ({P1} =~ 'Jul') \
    /let _month=7%; \
  /elseif ({P1} =~ 'Aug') \
    /let _month=8%; \
  /elseif ({P1} =~ 'Sep') \
    /let _month=9%; \
  /elseif ({P1} =~ 'Oct') \
    /let _month=10%; \
  /elseif ({P1} =~ 'Nov') \
    /let _month=11%; \
  /elseif ({P1} =~ 'Dec') \
    /let _month=12%; \
  /endif%; \
  /set reinc_time=$[mktime({P3}, _month, {P2} + 1) - 1]

/def -Fp5 -ag -mregexp -t'^Total worth exactly: (\\d+) exp$' estimate_worth_total = \
  /set estimate_worth_total=%{P1}

/def -Fp5 -mregexp -t'^After taxes about:   (\\d+) exp$' estimate_worth_taxes = \
  /set estimate_worth_taxes=%{P1}%; \
  /set estimate_worth_loss=$[estimate_worth_total - estimate_worth_taxes]%; \
  /set estimate_worth_percent=$[estimate_worth_loss * 100 / estimate_worth_total]%; \
  /substitute -- Worth: $[to_kmg(estimate_worth_total)], After: $[to_kmg(estimate_worth_taxes)], Loss: $[to_kmg(estimate_worth_loss)], Percent: $[round(min(100, max(0, estimate_worth_percent)), 1)]%%

;;
;; RATE
;;
;; An exp rate calculator which can optionally be appended to COMMAND.
;;
;; Usage: /rate [OPTIONS] -- [COMMAND]
;;
;;  OPTIONS:
;;
;;   -a            Announce the rate
;;   -c            Clear the counter
;;   -r            Reset counter
;;
/def rate = \
  /if (!getopts('rac', '')) \
    /return%; \
  /endif%; \
  /if (opt_c) \
    /unset rate_time%; \
    /unset rate_exp%; \
    /say -d'status' -- Rate counters have been cleared%; \
    /return%; \
  /endif%; \
  /if (opt_r) \
    /test rate_time := time()%; \
    /set rate_exp=%{p_exp}%; \
    /say -d'status' -- Rate counters have been reset%; \
    /return%; \
  /endif%; \
  /if (rate_time) \
    /if (opt_a) \
      /let _cmd=/say --%; \
    /elseif ({#}) \
      /let _cmd=%{*}%; \
    /else \
      /let _cmd=/say -d'status' --%; \
    /endif%; \
    /let _time=$[trunc(time() - rate_time)]%; \
    /let _minutes=$[trunc(_time / 60)]%; \
    /let _exp=$[p_exp - rate_exp]%; \
    /let _rate=$[_exp / (_minutes ? _minutes : 1)]%; \
    /execute %{_cmd} Making $[to_kmg(_rate)]/min for $[to_dhms(_time)], $[to_kmg(_exp)] exp total%; \
    /return%; \
  /endif%; \
  /error -m'%{0}' -- try '/rate -r' to initialize the variables

;;
;; EGG
;;
;; This is basic egg timer implementation.
;;
;; Usage: /egg [OPTIONS] -- MESSAGE
;;
;;  OPTIONS:
;;
;;   -r REPEATS    The number of times to repeat message
;;   -s            Stop the timer
;;   -t TIME       The number of minutes to set timer
;;   -x            This is run from a /repeat pid
;;
/def egg = \
  /if (!getopts('t#sr#xac', '')) \
    /return%; \
  /endif%; \
  /if (opt_t) \
    /if (!{#}) \
      /error -m'%{0}' -- a message is required%; \
      /return 0%; \
    /endif%; \
    /let opt_r=$[trunc(opt_r)]%; \
    /set egg_message=%{*}%; \
    /test egg_start := time()%; \
    /test egg_time := opt_t * 60%; \
    /test egg_repeats := opt_r%; \
    /timer -t%{egg_time} -n1 -p'egg_pid' -k -- /egg -c%; \
    /return 1%; \
  /endif%; \
  /if (opt_s) \
    /if (is_pid('egg_pid')) \
      /say -d'status' -- Egg timer stopped%; \
      /kill egg_pid%; \
    /endif%; \
    /return 1%; \
  /endif%; \
  /if (strlen(egg_message) & egg_time) \
    /if ({#}) \
      /let _cmd=%{*}%; \
    /elseif (opt_a) \
      /let _cmd=/say --%; \
    /else \
      /let _cmd=/say -d'status' --%; \
    /endif%; \
    /execute %{_cmd} Egg timer for '%{egg_message}' $[time() >= egg_start + egg_time ? 'has been ready for' : 'is ready in'] $[to_dhms(abs(time() - egg_start - egg_time))] [$[to_dhms(egg_time)] total]%; \
    /if (time() >= egg_start + egg_time) \
      /kill egg_pid%; \
      /if (opt_c & egg_repeats > 0) \
        /timer -t30 -n%{egg_repeats} -p'egg_pid' -- /egg -x%; \
      /elseif (!opt_x) \
        /unset egg_message%; \
      /endif%; \
    /endif%; \
  /else \
    /say -d'status' -- No previous egg timers have been started%; \
  /endif

;;
;; MAIL
;;
;; Send mail MESSAGE.
;;
;; Usage: /mail [OPTIONS] -- [MESSAGE]
;;
;;  OPTIONS:
;;
;;   -r RECIPIENT  The e-mail recipient (used instead of {email})
;;   -s SUBJECT*   The subject of the email
;;
/def mail = \
  /if (!getopts('s:r:', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_s)) \
    /error -m'%{0}' -a's' -- subject required%; \
    /return%; \
  /endif%; \
  /if (!{#}) \
    /error -m'%{0}' -- body required%; \
    /return%; \
  /endif%; \
  /if (!strlen(opt_r) & !strlen(email)) \
    /error -m'%{0}' -a'r' -- recipient or {email} required%; \
    /return%; \
  /endif%; \
  /python mail.Send('$(/escape ' %{opt_r-%{email}})', '$(/escape ' %{opt_s})', '$(/escape ' %{*})')

/property -g email

;;
;; VARIOUS COMMANDS
;;

/def f = !finger %{*-$[me()]}
/def hg = !hit ground
/def pv = !pull vine

/def train = \
  /let _skill=$[replace('_', ' ', {*})]%; \
  !echo Training: %{_skill}%; \
  !train %{_skill}

/def study = \
  /let _spell=$[replace('_', ' ', {*})]%; \
  !echo Studying: %{_spell}%; \
  !study %{_spell}

;;
;; DRINKING SHINES / POTIONS
;;

/def qpot = \
  /if (bag) \
    !get potion from bag of holding%; \
  /endif%; \
  !quaff potion%; \
  /if (bag) \
    !put all potion,all empty potion in bag of holding%; \
  /endif%; \
  !keep all potion

/def spot = \
  /if (bag) \
    !get potion from bag of holding%; \
  /endif%; \
  !sip potion%; \
  /if (bag) \
    !put all potion,all empty potion in bag of holding%; \
  /endif%; \
  !keep all potion

/def moonshine = \
  !2 e%;!s%;!e%; \
  /if (bag) \
		!get all gold from bag of holding%; \
  /endif%; \
  !%{1-10} buy moonshine%; \
  /if (bag) \
    !put all moonshine in bag of holding%; \
  /endif%; \
  !keep all moonshine%; \
  !w%;!n%;!2 w

;;
;; TRANSACTIONS
;;

/def da = \
  /if (trader & strlen(booth_dirs) & strlen(booth_dirs_back)) \
    /csbooth%; \
    /if (bag) \
      !get all gold from bag of holding%; \
    /endif%; \
    !deposit all%; \
    /boothcs%; \
  /else \
    !2 n%;!w%; \
    !deposit all%; \
    !e%;!2 s%; \
  /endif

/def wd = \
  /if (!{1}) \
    /return%; \
  /endif%; \
  /if (trader & strlen(booth_dirs) & strlen(booth_dirs_back)) \
    /csbooth%; \
    !withdraw %{1}%; \
    /if (bag) \
      !put %{1} gold in bag of holding%; \
    /endif%; \
    /boothcs%; \
  /else \
    !2 n%;!w%; \
    !withdraw %{1}%; \
    !e%;!2 s%; \
  /endif

/def si = \
  !3 n%;!e%;!s%; \
  !sell noeq%; \
  /if (bag & stuff_bag) \
    !get all flute from bag of holding%; \
    !sell all from bag of holding%; \
    !put all flute in bag of holding%; \
    !keep all flute%; \
  /endif%; \
  !n%;!w%;!2 s%;!e%; \
  !sell noeq%; \
  /if (bag & stuff_bag) \
    !sell all from bag of holding%; \
  /endif%; \
  !2 w%; \
  !sell noeq%; \
  /if (bag & stuff_bag) \
    /let _keep=all potion,all elixir,all salve,all key,tinning kit,all keg,all shuriken%; \
    !get %{_keep} from bag of holding%; \
    !sell all from bag of holding%; \
    !put %{_keep} in bag of holding%; \
    !keep %{_keep}%; \
  /endif%; \
  !e%; \
  !s%; \
  /if (bag & p_cash > 0) \
    !put %{p_cash} gold in bag of holding%; \
  /endif

/def si_corpse = \
  !get all corpse%; \
  !5 n%; \
  !4 w%; \
  !n%; \
  !drop all corpse%; \
  !loot%; \
  !%{1-20} sell corpse%; \
  !out%; \
  !4 e%; \
  !5 s

/def si_rk = \
  !6 w%;!2 n%;!e%; \
  !sell noeq%; \
  /if (bag & stuff_bag) \
    !get all flute from bag of holding%; \
    !sell all from bag of holding%; \
    !put all flute in bag of holding%; \
    !keep all flute%; \
  /endif%; \
  !w%;!2 n%;!e%; \
  !sell noeq%; \
  /if (bag & stuff_bag) \
    !sell all from bag of holding%; \
  /endif%; \
  !w%;!s%;!4 e%;!2 s%;!w%;  \
  !sell noeq%; \
  /if (bag & stuff_bag) \
    !get all potion,all elixir,all salve,all key,tinning kit,all keg from bag of holding%; \
    !sell all from bag of holding%; \
    !put all potion,all elixir,all salve,all key,tinning kit,all keg in bag of holding%; \
    !keep all potion,all elixir,all salve,all key,tinning kit,all keg%; \
  /endif%; \
  /if ({#}) \
    !e%;!n%;!w%; \
    /if (bag) \
      !get all gold from bag of holding%; \
    /endif%; \
    !deposit all%; \
    !e%;!2 s%;!2 e%; \
  /else \
    !e%;!s%;!2 e%; \
    /if (bag & p_cash > 0) \
      !put %{p_cash} gold in bag of holding%; \
    /endif%; \
  /endif

;;
;; KEYS
;;

/def lock = /door -a'lock' -d'$(/escape ' %{*})'
/def unlock = /door -a'unlock' -d'$(/escape ' %{*})'

/def door = \
  /if (!getopts('a:d:', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_d)) \
    /error -m'%{0}' -a'd' -- direction required%; \
    /return%; \
  /endif%; \
  /if (opt_a =~ 'lock') \
    !close %{opt_d} door%; \
  /elseif (opt_a !~ 'unlock') \
    /error -m'%{0}' -a'a' -- must be one of 'unlock' or 'lock'%; \
    /return%; \
  /endif%; \
  /set door=1%; \
  /set door_action=%{opt_a}%; \
  /set door_dir=%{opt_d}%; \
  /if (bag) \
    !get all key from bag of holding%; \
  /endif%; \
  !count key

/def -Fp5 -mregexp -t'^There (are|is) (\\d+) \'key\'s? in your inventory\\.$' door_key_count = \
  /set door_keys=%{P2}%; \
  /set door_key=0%; \
  /door_next

/def -Fp5 -mregexp -t'^The (.+) leading (.+) is open!$' door_open = \
  /if (door & door_action =~ 'unlock') \
    /set door=0%; \
  /endif

/def -Fp5 -mregexp -t'^The (.+) leading (.+) is already locked\\.$' door_locked = \
  /if (door & door_action =~ 'lock') \
    /set door=0%; \
  /endif

/def -Fp5 -mregexp -t'^A (.+) doesn\'t fit!' door_next = \
  /if (door) \
    /if (door_key < door_keys) \
      !%{door_action} %{door_dir} door with key $[++door_key]%; \
    /else \
      /set door=0%; \
      /say -- Could not find correct key!%; \
    /endif%; \
  /endif

/def -Fp5 -mregexp -t'^You (lock|unlock) (.+) door leading ([a-z]+)\\.$' door_unlocked = \
  /if (door & door_action =~ {P1}) \
    /set door=0%; \
    /if (door_action =~ 'unlock') \
      !open %{P3} door%; \
    /endif%; \
    /if (bag) \
      !put all key in bag of holding%; \
    /endif%; \
    /say -- Successfully %{door_action}ed the %{door_dir} door!%; \
  /endif

;;
;; CHESTING COMMANDS
;;

/property -g chest_dir
/property -g chest_dir_back

/set chest_start=1
/set chest_end=2

;;
;; UNLOCK CHEST
;;
;; Unlocks chests in range.
;;
;; Usage: /uc [START [END]]
;;
/def uc = \
  /if ({#}) \
    /if ({#} > 2) \
      /set chest_name=%{1}%; \
      /set chest_start=$[min(max({2}, 1), 100)]%; \
      /set chest_end=$[min(max({3}, chest_start), 100)]%; \
    /else \
      /unset chest_name%; \
      /set chest_start=$[min(max({1}, 1), 100)]%; \
      /set chest_end=$[min(max({2}, chest_start), 100)]%; \
    /endif%; \
  /endif%; \
  /say -d'status' -- Unlocking chests [%{chest_name-null}] %{chest_start}-%{chest_end}%; \
  /let i=%{chest_start}%; \
  /while (i <= chest_end) \
    /if (strlen(chest_name)) \
      !unlock chest %{chest_name} %{i}%; \
    /else \
      !unlock chest %{i}%; \
    /endif%; \
    /let i=$[i + 1]%; \
  /done

;;
;; OPEN CHEST
;;
;; Opens chests in range.
;;
;; Usage: /oc [START [END]]
;;
/def oc = \
  /if ({#}) \
    /if ({#} > 2) \
      /set chest_name=%{1}%; \
      /set chest_start=$[min(max({2}, 1), 100)]%; \
      /set chest_end=$[min(max({3}, chest_start), 100)]%; \
    /else \
      /unset chest_name%; \
      /set chest_start=$[min(max({1}, 1), 100)]%; \
      /set chest_end=$[min(max({2}, chest_start), 100)]%; \
    /endif%; \
  /endif%; \
  /say -d'status' -- Opening chests [%{chest_name-null}] %{chest_start}-%{chest_end}%; \
  /let i=%{chest_start}%; \
  /while (i <= chest_end) \
    /if (strlen(chest_name)) \
      !open chest %{chest_name} %{i}%; \
    /else \
      !open chest %{i}%; \
    /endif%; \
    /let i=$[i + 1]%; \
  /done

;;
;; SET KEYS OF CHEST
;;
;; Set the keys of chests in range.
;;
;; Usage: /sk [START [END]]
;;
/def sk = \
  /if ({#}) \
    /if ({#} > 2) \
      /set chest_name=%{1}%; \
      /set chest_start=$[min(max({2}, 1), 100)]%; \
      /set chest_end=$[min(max({3}, chest_start), 100)]%; \
    /else \
      /unset chest_name%; \
      /set chest_start=$[min(max({1}, 1), 100)]%; \
      /set chest_end=$[min(max({2}, chest_start), 100)]%; \
    /endif%; \
  /endif%; \
  /say -d'status' -- Settings keys for chests [%{chest_name-null}] %{chest_start}-%{chest_end}%; \
  /let i=%{chest_start}%; \
  /while (i <= chest_end) \
    /let _range=123456789%; \
    /let _combo=%; \
    /let j=3%; \
    /while (j > 0) \
      /let _digit=$[rand(strlen(_range))]%; \
      /let _combo=%{_combo}$[substr(_range, _digit, 1)]%; \
      /let _range=$[strcat(substr(_range, 0, _digit), substr(_range, _digit + 1))]%; \
      /let j=$[j - 1]%; \
    /done%; \
    /if (strlen(chest_name)) \
      !setkey chest %{chest_name} %{i} to %{_combo}%; \
    /else \
      !setkey chest %{i} to %{_combo}%; \
    /endif%; \
    /let i=$[i + 1]%; \
  /done

;;
;; LOOK AT CHEST
;;
;; Looks at chests in range.
;;
;; Usage: /lc [START [END]]
;;
/def lc = \
  /if ({#}) \
    /if ({#} > 2) \
      /set chest_name=%{1}%; \
      /set chest_start=$[min(max({2}, 1), 100)]%; \
      /set chest_end=$[min(max({3}, chest_start), 100)]%; \
    /else \
      /unset chest_name%; \
      /set chest_start=$[min(max({1}, 1), 100)]%; \
      /set chest_end=$[min(max({2}, chest_start), 100)]%; \
    /endif%; \
  /endif%; \
  /say -d'status' -- Looking at chests [%{chest_name-null}] %{chest_start}-%{chest_end}%; \
  /let i=%{chest_start}%; \
  /while (i <= chest_end) \
    /if (strlen(chest_name)) \
      !look at chest %{chest_name} %{i}%; \
    /else \
      !look at chest %{i}%; \
    /endif%; \
    /let i=$[i + 1]%; \
  /done

;;
;; CLOSE CHEST
;;
;; Closes chests in range.
;;
;; Usage: /cc [START [END]]
;;
/def cc = \
  /if ({#}) \
    /if ({#} > 2) \
      /set chest_name=%{1}%; \
      /set chest_start=$[min(max({2}, 1), 100)]%; \
      /set chest_end=$[min(max({3}, chest_start), 100)]%; \
    /else \
      /unset chest_name%; \
      /set chest_start=$[min(max({1}, 1), 100)]%; \
      /set chest_end=$[min(max({2}, chest_start), 100)]%; \
    /endif%; \
  /endif%; \
  /say -d'status' -- Closing chests [%{chest_name-null}] %{chest_start}-%{chest_end}%; \
  /let i=%{chest_start}%; \
  /while (i <= chest_end) \
    /if (strlen(chest_name)) \
      !close chest %{chest_name} %{i}%; \
    /else \
      !close chest %{i}%; \
    /endif%; \
    /let i=$[i + 1]%; \
  /done

;;
;; PUT ALL IN CHEST
;;
;; Puts all in chests in range.
;;
;; Usage: /pac [START [END]]
;;
/def pac = \
  /if ({#}) \
    /if ({#} > 2) \
      /set chest_name=%{1}%; \
      /set chest_start=$[min(max({2}, 1), 100)]%; \
      /set chest_end=$[min(max({3}, chest_start), 100)]%; \
    /else \
      /unset chest_name%; \
      /set chest_start=$[min(max({1}, 1), 100)]%; \
      /set chest_end=$[min(max({2}, chest_start), 100)]%; \
    /endif%; \
  /endif%; \
  /if (!strlen(chest_dir) | !strlen(chest_dir_back)) \
    /error -m'%{0}' -- {chest_dir} and {chest_dir_back} must be set%; \
    /return%; \
  /endif%; \
  /say -d'status' -- Putting all in chests [%{chest_name-null}] %{chest_start}-%{chest_end}%; \
  /if (strlen(samurai_sword_name)) \
    !keep all %{samurai_sword_name}%; \
  /endif%; \
  !%{chest_dir}%; \
  !drop all%; \
  !keep clear%; \
  !drop all flute%; \
  !get flute%; \
  !%{chest_dir_back}%; \
  !save%; \
  /if (strlen(samurai_sword_name)) \
    !keep all %{samurai_sword_name}%; \
  /endif%; \
  /if (bag) \
    !get flute,tinning kit from bag of holding%; \
  /endif%; \
  /if (strlen(pac_extra)) \
    /eval %{pac_extra}%; \
  /endif%; \
  /let i=%{chest_start}%; \
  /while (i <= chest_end) \
    /if (strlen(chest_name)) \
      !open chest %{chest_name} %{i}%; \
      !put all in chest %{chest_name} %{i}%; \
      !close chest %{chest_name} %{i}%; \
    /else \
      !open chest %{i}%; \
      !put all in chest %{i}%; \
      !close chest %{i}%; \
    /endif%; \
    !get all%; \
    /let i=$[i + 1]%; \
  /done%; \
  !keep all%; \
  !%{chest_dir}%; \
  !get all%; \
  !%{chest_dir_back}%; \
  !slots%; !i%; !eq%; !ll

/property -s -g pac_extra

;;
;; GET ALL IN CHEST
;;
;; Gets all from chests in range.
;;
;; Usage: /gac [START [END]]
;;
/def gac = \
  /if ({#}) \
    /if ({#} > 2) \
      /set chest_name=%{1}%; \
      /set chest_start=$[min(max({2}, 1), 100)]%; \
      /set chest_end=$[min(max({3}, chest_start), 100)]%; \
    /else \
      /unset chest_name%; \
      /set chest_start=$[min(max({1}, 1), 100)]%; \
      /set chest_end=$[min(max({2}, chest_start), 100)]%; \
    /endif%; \
  /endif%; \
  /if (!strlen(chest_dir) | !strlen(chest_dir_back)) \
    /error -m'%{0}' -- {chest_dir} and {chest_dir_back} must be set%; \
    /return%; \
  /endif%; \
  /say -d'status' -- Getting all from chests [%{chest_name-null}] %{chest_start}-%{chest_end}%; \
  /if (strlen(samurai_sword_name)) \
    !keep all %{samurai_sword_name}%; \
  /endif%; \
  !%{chest_dir}%; \
  !drop all%; \
  !%{chest_dir_back}%; \
  /let i=%{chest_start}%; \
  /while (i <= chest_end) \
    /if (strlen(chest_name)) \
      !open chest %{chest_name} %{i}%; \
      !get all from %{chest_name} %{i}%; \
    /else \
      !open chest %{i}%; \
      !get all from chest %{i}%; \
    /endif%; \
    /let i=$[i + 1]%; \
  /done%; \
  /if (bag) \
    !put all tinning kit,all flute in bag of holding%; \
  /endif%; \
  /if (strlen(gac_extra)) \
    /eval %{gac_extra}%; \
  /endif%; \
  /let i=%{chest_start}%; \
  /while (i <= chest_end) \
    /if (strlen(chest_name)) \
      !close chest %{chest_name} %{i}%; \
    /else \
      !close chest %{i}%; \
    /endif%; \
    /let i=$[i + 1]%; \
  /done%; \
  !drop all flute%; \
  !equip%; \
  !get all flute%; \
  !keep all%; \
  !%{chest_dir}%; \
  !get all%; \
  !%{chest_dir_back}%; \
  !slots%; !i%; !eq%; !ll%; !save

/property -s -g gac_extra

/def -Fp5 -mregexp -t'^A large wooden chest( labelled \'.+\')?( \\((open|unlocked)\\))?$' number_chests = \
  /set chest_number=$[chest_number + 1]%; \
  /substitute -p -- @{B}$[pad(chest_number, 2)]@{n}) %{*}%; \
  /def -Fp6 -mregexp -t'' number_chests_reset = \
    /if (!regmatch('^A large wooden chest', {*})) \
      /set chest_number=0%%; \
      /purgedef number_chests_reset%%; \
    /endif

/def dwield = \
  !unwield %{*}%; \
  !dwield %{*}%; \
  !keep %{*},%{*}

;;
;; RANGER BERRIES
;;

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ gives you [A-Z][a-z]* colorful berr(ies|y)\\.$' given_berries = \
  /if (bag) \
    !put all berry in bag of holding%; \
  /endif%; \
  !count berry

;/def -Fp5 -msimple -t'You have no \'berry\' to eat.' no_berries
;  /set berries=0

;There are 5 'berry's in your inventory.

;/def -Fp5 -mregexp -t'^There (are|is) (\\d+) \'berry\'s? in your inventory\\.$' berry_count = \
;  /set berries=%{P2}

/def eb = \
  /if (bag) \
    !get berry from bag of holding%; \
  /endif%; \
  !eat berry

/def bberry = \
  /if (bag) \
    !get brown berry from bag of holding%; \
  /endif%; \
  !rub brown berry

/def gberry = \
  /if (bag) \
    !get green berry from bag of holding%; \
  /endif%; \
  !squeeze green berry

/def pberry = \
  /if (bag) \
    !get purple berry from bag of holding%; \
  /endif%; \
  !eat purple berry

/def wberry = \
  /if (bag) \
    !get white berry from bag of holding%; \
  /endif%; \
  !slurp white berry

/def yberry = \
  /if (bag) \
    !get yellow berry from bag of holding%; \
  /endif%; \
  !throw yellow berry at %{*}

;;
;; DOORS
;;
/def cdo = !close door
/def oed = !open east door
/def ond = !open north door
/def osd = !open south door
/def owd = !open west door

;;
;; EXECUTE COMMANDS
;;
;; Executes COMMANDS separate by commas.
;;
;; Usage: /cmds COMMANDS
;;
/def cmds = /eval -s1 $[replace(',', '%;!', replace(', ', '%;!', {*}))]

;;
;; EXECUTE ZMUD COMMANDS
;;
;; Execute COMMANDS separated by semi-colons.
;;
;; Usage: /zmud COMMANDS
;;
/def z = /zmud %{*}
/def zmud = /eval -s1 $[replace(';', '%;', {*})]


;;
;; EXECUTE ZMUD COMMANDS
;;
;; Execute COMMANDS separated by semi-colons.
;;
;; Usage: /zsend COMMANDS
;;
/def zsend = /eval -s1 /send -- !$[replace(';', '%;/send -- !', {*})]%; \

;;
;; TELL
;;
;; Send tells to various players.
;;
;; Usage: /tell RECIPIENTS MESSAGE
;;
/def tell = \
  /let _recipients=$[replace(',', ' ', {1})]%; \
  /let _message=%{-1}%; \
  /let i=0%; \
  /let j=$(/length %{_recipients})%; \
  /while (i < j) \
    /let _recipient=$(/nth $[i + 1] %{_recipients})%; \
    !tell %{_recipient} %{_message}%; \
    /let i=$[i + 1]%; \
  /done

;;
;; MUD EXTENSION PROTOCOL
;;
;; Converts the text using the mud extension protocol, or MXP.
;;
;; Usage: /mxp [OPTIONS] -- [COMMAND]
;;
;;  OPTIONS:
;;
;;  -b              Make the message bold
;;  -c COLOR        Make the message COLOR
;;  -f FONT         Make the message FONT
;;  -h              Make the message highlighted
;;  -i              Make the message italic
;;  -m MESSAGE      Modify this MESSAGE
;;  -n SIZE         Make the message SIZE
;;  -s              Make the message strikeout
;;  -u              Make the message unerlined
;;
/def mxp = \
  /if (!getopts('biushc:f:n#m:', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_m)) \
    /error -m'%{0}' -a'm' -- missing message%; \
    /return%; \
  /endif%; \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/echo -w -p -aCgreen -- %{prefix}%; \
  /endif%; \
  /let _start=%; \
  /let _end=%; \
  /if (opt_b) \
    /let _start=%{_start}<b>%; \
    /let _end=</b>%{_end}%; \
  /endif%; \
  /if (opt_i) \
    /let _start=%{_start}<i>%; \
    /let _end=</i>%{_end}%; \
  /endif%; \
  /if (opt_u) \
    /let _start=%{_start}<u>%; \
    /let _end=</u>%{_end}%; \
  /endif%; \
  /if (opt_s) \
    /let _start=%{_start}<s>%; \
    /let _end=</s>%{_end}%; \
  /endif%; \
  /if (opt_h) \
    /let _start=%{_start}<h>%; \
    /let _end=</h>%{_end}%; \
  /endif%; \
  /if (strlen(opt_c) | strlen(opt_f) | opt_n) \
    /let _tmp=<font%; \
    /if (strlen(opt_f)) \
      /let _tmp=%{_tmp} face=%{opt_f}%; \
    /endif%; \
    /if (strlen(opt_c)) \
      /let _tmp=%{_tmp} color=%{opt_c}%; \
    /endif%; \
    /if (opt_n) \
      /let _tmp=%{_tmp} size=%{opt_n}%; \
    /endif%; \
    /let _tmp=%{_tmp}>%; \
    /let _start=%{_start}%{_tmp}%; \
    /let _end=</font>%{_end}%; \
  /endif%; \
  /execute %{_cmd} %{_start}%{opt_m}%{_end}

;;
;; BREAD
;;
;; Buy NUMBER x bread.
;;
;; Usage: /bread [NUMBER]
;;
/def bread = \
  /let _num=$[{1} | 10]%; \
  /wd $[340 * _num]%; \
  /if (bag) \
    !get all gold from bag of holding%; \
  /endif%; \
  !3 n%;!4 w%;!n%; \
  !%{_num} buy 3%; \
  /if (bag) \
    !put food in bag of holding%; \
  /endif%; \
  !keep food%; \
  !s%;!4 e%;!3 s

;;
;; EAT ALL
;;
;; Eats all of the food till you are satiated.
;;
/def eat = \
  /if (bag) \
    !get food from bag of holding%; \
  /endif%; \
  !drop all mushroom,all head,all egg%; \
  !eat all%; \
  /if (bag) \
    !put food in bag of holding%; \
  /endif

/def ea = /eat

;;
;; IN
;;
;; Enter battle, party follow, and attack!
;;
;; Usage: /in [DIRECTION]
;;
/def in = \
  /set in=%{*-%{in}}%; \
  /if (!strlen(in)) \
    /return%; \
  /endif%; \
  /eval -s1 !$[replace(';', '%;!', in)]%; \
  /if (party_members > 1 & !is_me(tank)) \
    !pf%; \
  /endif%; \
  /say -d'party' -m -x -t -b -c'green' -- IN { $[replace(';', ', ', in)] }%; \
  /kx

/def inx = \
  /set in=%{*-%{in}}%; \
  /if (!strlen(in)) \
    /return%; \
  /endif%; \
  /eval -s1 !$[replace(';', '%;!', in)]

/def sin = \
  /set in=%{*-%{in}}%; \
  /say -d'party' -m -x -t -b -c'yellow' -- IN SET { $[replace(';', ', ', in)] }

;;
;; OUT
;;
;; Leave out of battle
;;
;; Usage: /out [DIRECTION]
;;
/def out = \
  /set out=%{*-%{out}}%; \
  /if (!strlen(out)) \
    /return%; \
  /endif%; \
  /eval -s1 !$[replace(';', '%;!', out)]%; \
  /if (party_members > 1 & !is_me(tank)) \
    !pf%; \
  /endif%; \
  /say -d'party' -m -x -t -b -c'red' -- OUT { $[replace(';', ', ', out)] }

/def sout = \
  /set out=%{*-%{out}}%; \
  /say -d'party' -m -x -t -b -c'yellow' -- OUT SET { $[replace(';', ', ', out)] }

;;
;; DROP FOOD
;;
;; Drops food at the baker.
;;
/def df = \
  !3 n%;!4 w%;!n%; \
  !drop food%; \
  /if (bag) \
    !drop food from bag of holding%; \
  /endif%; \
  !s%;!4 e%;!3 s

;;
;; IS AWAY
;;
;; Returns true/false depending on whether we can send to mud
;;
;; Usage: is_away()
;;
/def is_away = /result away | !is_connected() | (idle() > idle_time & idle_time > 0)

;;
;; ENCODE URL
;;
/def urlencode = /result python('util.urlencode("$(/escape ' $(/escape " %{*}))")')
/def urldecode = /result python('util.urldecode("$(/escape ' $(/escape " %{*}))")')

;;
;; JOIN
;;
;; Joins WORDS by SEPARATOR.
;;
;; Usage: join(WORDS, SEPARATOR)
;;
/def join = /result python('util.join("$(/escape " %{1})", "%{2}")')

;/def wait = \
;  /if (getopts('n:w#r#', ''))

;;
;; IS TRUE
;;
;; Returns if the STRING should be evaluated as true. '', 0, off, false are
;; assumed to be 0.
;;
;; Usage: /istrue STRING
;;
/def istrue = \
  /if ({#} & strlen({*}) & strcmp({*}, '0') & tolower({*}) !~ 'off' & tolower({*}) !~ 'false') \
    /return 1%; \
  /else \
    /return 0%; \
  /endif

;;
;; PLURALIZE
;;
;; Pluralizes the STRING depending on the value of COUNT. If ENDING is not
;; given and COUNT is not equal to 1 then an 's' will be appended.
;;
;; Usage: /pluralize COUNT STRING [ENDING]
;;
/def pluralize = \
  /if ({#} < 2) \
    /result ''%; \
  /endif%; \
  /if ({1} == 1) \
    /result strcat({1-0}, ' ', {2})%; \
  /endif%; \
  /result strcat({1-0}, ' ', {2}, {3-s})

;;
;; DELTA ONLY
;;
;; If the CHANGE is positive prepend a + and then return number with LEFT and
;; RIGHT surrounding. Otherwise return nothing.
;;
;; Usage: delta_only(CHANGE, LEFT, RIGHT)
;;
/def delta_only = \
  /if ({#} & {1}) \
    /if ({1} > 0) \
      /result strcat({2}, '+', {1}, {3})%; \
    /else \
      /result strcat({2}, {1}, {3})%; \
    /endif%; \
  /endif

;;
;; REGULAR EXPRESSIONS ESCAPE
;;
;; Escapes regular expression's special characters.
;;
;; Usage: regescape(STRING)
;;
/def regescape = /result escape('\\*.+?|{}[]($$)^',  {*})

;;
;; TO DHMS
;;
;; Converts the SECONDS to a days, hours, minutes and seconds format.
;;
;; Usage: /to_dhms SECONDS
;;        to_dhms(SECONDS)
;;
/def to_dhms = \
  /if ({2}) \
    /let _short=False%; \
  /else \
    /let _short=True%; \
  /endif%; \
  /let _seconds=$[{1-0} * 1]%; \
  /result python('util.getPrettyTime(%{_seconds}, short=%{_short})')

;;
;; FROM DHMS
;;
;; Converts STRING to an int format of days/hours/minutes/seconds.
;;
;; Usage: /from_dhms STRING
;;
/def from_dhms = \
  /let _result=0%; \
  /while ({#}) \
    /let _end=$[substr({1}, -1)]%; \
    /let _count=$[trunc({1})]%; \
    /let _mult=0%; \
    /if (_end =~ 'd') \
      /let _mult=86400%; \
    /elseif (_end =~ 'h') \
      /let _mult=3600%; \
    /elseif (_end =~ 'm') \
      /let _mult=60%; \
    /elseif (_end =~ 's') \
      /let _mult=1%; \
    /endif%; \
    /test _result += (_mult * _count)%; \
    /shift%; \
  /done%; \
  /result _result

;;
;; TO KILOS, MEGS AND GIGS
;;
;; Return NUMBER in human readable format.
;;
;; Usage: /to_kmg NUMBER [DIGITS]
;;
/def to_kmg = /result python('util.getHumanReadableFormat(%{1-0}, digits=%{2-1})')

;;
;; TO EXP STRING
;;
;; Returns NUMBER as an exp string.
;;
;; Usage: /to_expstr NUMBER
;;
/def to_expstr = /result python('util.getExpStringFormat(%{1-0})')

;;
;; FROM EXP STRING
;;
;; Converts the exp STRING to a number.
;;
;; Usage: /from_expstr STRING
;;
/def from_expstr = \
  /let _result=0%; \
  /let i=1%; \
  /let j=$(/length %{*})%; \
  /while (i <= j) \
    /let _part=$(/nth %{i} %{*})%; \
    /let _left=$[substr(_part, 0, -1)]%; \
    /let _right=$[substr(_part, -1)]%; \
    /if (_right =~ 'k') \
      /test _result += _left * 1000%; \
    /elseif (_right =~ 'M') \
      /test _result += _left * 1000000%; \
    /elseif (_right =~ 'G') \
      /test _result += _left * 1000000000%; \
    /elseif (_right =~ 'T') \
      /test _result += _left * 1000000000000%; \
    /else \
      /test _result += _part%; \
    /endif%; \
    /test ++i%; \
  /done%; \
  /result _result

;;
;; TO NTH
;;
;; Convert the given INTEGER to a nth format.
;;
;; Usage: /to_nth INTEGER
;;
/def to_nth = \
  /let _num=$[trunc({1})]%; \
  /let _2=$[substr(_num, -2)]%; \
  /let _1=$[substr(_num, -1)]%; \
  /if (_1 == 1 & _2 != 11) \
    /let _end=st%; \
  /elseif (_1 == 2 & _2 != 12) \
    /let _end=nd%; \
  /elseif (_1 == 3 & _2 != 13) \
    /let _end=rd%; \
  /else \
    /let _end=th%; \
  /endif%; \
  /result strcat(_num, _end)

;;
;; ROUND
;;
;; Rounds the NUMBER to N decimal places.
;;
;; Usage: /round NUMBER N
;;
/def round = /result python('util.round(%{1-0}, %{2-2})')

;;
;; MIN
;;
;; Returns the minimum number in the group X Y Z ..
;;
;; Usage: /min X Y Z ..
;;
/def min = \
  /let _min=%{1-0}%;\
  /while (shift(), {#}) \
    /if ({1} < _min) \
      /let _min=%{1}%;\
    /endif%;\
  /done%;\
  /result _min

;;
;; MAX
;;
;; Returns the maximum number in the group X Y Z ..
;;
;; Usage: /max X Y Z ..
;;
/def max = \
  /let _max=%{1-0}%;\
  /while (shift(), {#}) \
    /if ({1} > _max) \
      /let _max=%{1}%;\
    /endif%;\
  /done%;\
  /result _max

;;
;; METER
;;
;; Prints out a meter.
;;
;; Usage: meter([NUMBER[, MAX[, SIZE[, PAD]]]])
;;
/def meter = \
  /let _num=%{1-0}%; \
  /let _max=%{2-100}%; \
  /let _size=%{3-%{2}}%; \
  /let _pad=%{4-#}%; \
  /result pad(strrep(_pad, trunc(min(_size, _num * _size / _max))), -(_size))

;;
;; STRING TOKENIZER
;;
;; With the given STRING and TOKEN returns the Nth group separated by TOKEN.
;;
;; Usage: strtok(STRING, N, TOKEN)
;;
/def strtok = \
  /if ({#} > 1) \
    /if (strlen({3})) \
      /let _tok=$[substr({3}, 0, 1)]%; \
    /else \
      /let _tok= %; \
    /endif%; \
    /let _str=%; \
    /let _start=0%; \
    /let _end=0%; \
    /let i=0%; \
    /while (i < {2} + 1) \
      /while (substr({1}, _start, 1) =~ _tok) \
        /let _start=$[_start + 1]%; \
      /done%; \
      /let _end=$[strchr({1}, _tok, _start + 1)]%; \
      /if (_end > -1) \
        /let _str=$[substr({1}, _start, _end - _start)]%; \
        /let _start=$[_end + 1]%; \
      /else \
        /let _str=$[substr({1}, _start)]%; \
        /let _start=$[strlen({1})]%; \
      /endif%; \
      /let i=$[i + 1]%; \
    /done%; \
    /result _str%; \
  /endif%; \
  /result ''

;;
;; GET MULTIPLIER
;;
;; Returns what the multiplier for this CHAR is.
;;
;; Usage: /get_multiplier CHAR
;;
/def get_multiplier = \
  /let _char=$[tolower({1})]%; \
  /if (_char =~ 'g') \
    /result 1000000000%; \
  /elseif (_char =~ 'm') \
    /result 1000000%; \
  /elseif (_char =~ 'k') \
    /result 1000%; \
  /else \
    /result 1%; \
  /endif

;;
;; CAPITALIZE
;;
;; Capitalize all words.
;;
;; Usage: /capitalize WORDS
;;
/def capitalize = \
  /result python('util.capitalize("$(/escape ' $(/escape " %{*}))")')

;;
;; BOOL
;;
;; Returns a boolean format of the given STRING.
;;
;; Usage: bool(STRING)
;;
/def bool = /result {1} ? 'true' : 'false'

;;
;; HEX
;;
;; Returns a hex version of the INTEGER
;;
;; Usage: /hex INTEGER [DIGITS]
;;
/def hex = \
  /result python('util.hex(%{1}, digits=%{2-0})')

;;
;; EXECUTE
;;
;; Executes the COMMAND and prepends a ! if it's not an internal command.
;;
;; Usage: /execute COMMAND
;;
/def execute = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /if (substr({*}, 0, 1) =~ '/') \
    /eval -s0 %{*}%; \
  /else \
    !%{*}%; \
  /endif

;;
;; RUN IF
;;
;; Runs the COMMAND if the pre-requisites have been meet.
;;
;; Usage: /runif [OPTIONS] -- COMMAND
;;
;;  OPTIONS:
;;
;; -t DELAY*       The delay between this commands (min)
;; -n NAME*        The name of this command (how we store state)
;;
/def runif = \
  /if (!getopts('t#n:', '') | !{#} | !regmatch('^[a-z0-9_]+$$', opt_n)) \
    /return%; \
  /endif%; \
  /let _var=runif_%{opt_n}%; \
  /let _value=$[expr(_var)]%; \
  /if (time() - _value > opt_t) \
    /eval %{*}%; \
    /set %{_var}=$[time()]%; \
  /endif

;;
;; IS IN
;;
;; Returns if KEY is in LIST.
;;
;; Usage: isin(KEY, LIST)
;;
/def isin = /result strstr({1}, ' ') == -1 & strlen({1}) & strlen({-1}) & {-1} =/ strcat('*{', {1}, '}*')

;;
;; KILL
;;
;; Kills a pid w/o the annoying error message
;;
;; Usage: /kill VAR [VAR [VAR..]]
;;
/def kill = \
  /while ({#}) \
    /let _var=%{1-0}%; \
    /let _pid=%{_var}%; \
    /if (!_pid) \
      /test _pid := %{_pid}%; \
      /unset %{_var}%; \
    /endif%; \
    /if (is_pid(_pid)) \
      /@kill %{_pid}%; \
    /endif%; \
    /shift%; \
  /done

;;
;; IS PID
;;
;; Returns if the given VARIABLE/PID is valid and alive.
;;
;; Usage: is_pid(PID|VARIABLE)
;;
/def is_pid = \
  /let _pid=%{1-0}%; \
  /if (!_pid) \
    /test _pid := %{_pid}%; \
  /endif%; \
  /result isin(_pid, $$(/ps -s))

;;
;; TIMER
;;
;; Use the repeat command to start a timer. This command differs in that it
;; keeps allows you to store the pid as a variable. The end result is
;; the COMMAND being executed at a later time.
;;
;; Usage: /timer [OPTIONS] -- COMMAND
;;
;;  OPTIONS:
;;
;;   -k            Kill previous pid with the same name
;;   -n REPEATS    The number of repeats
;;   -p PID        The name of the pid file
;;   -t DELAY      The delay between repeats
;;
/def timer = \
  /if (!getopts('t#n#p:k', '') | !{#}) \
    /return%; \
  /endif%; \
  /let opt_n=$[max(1, opt_n)]%; \
  /let opt_t=$[max(0, opt_t)]%; \
  /if (opt_k) \
    /kill %{opt_p}%; \
  /endif%; \
  /test timer_pid := repeat(strcat('-', opt_t, ' ', opt_n, ' ', {*}))%; \
  /if (strlen(opt_p)) \
    /test %{opt_p} := timer_pid%; \
  /endif

;;
;; RUN MACROS AND HELPERS
;;

/unset back
/def back = \
  /if (strlen(back)) \
    /%{back}%; \
  /endif

/def area = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /say -d'party' -x -b -c'yellow' -- At %{*}

/def area_cmds_zmud = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _trig=#REGEX "$[me()].type" {^$[toupper(me(), 1)] [\\[{<]party[>}\\]]: TYPE \\{ (.+) \\} ?$$} {#INPUT {%%replace(%%1, ", ", ";")}}%; \
  /execute %{_cmd} %{_trig}

/def area_cmds_tf = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _trig=/def -Fp10 -mregexp -t'^$[toupper(me(), 1)] [\\\\[{<]party[>}\\\\]]: TYPE \\\\{ (.+) \\\\} ?$$' $[me()]_type = /grab /eval -s1 !$$[replace(', ', '%%;!', {P1})]%; \
  /execute %{_cmd} %{_trig}

/def area_cmds = \
  /if ({#} & (is_me(tank) | is_me(commander))) \
    /say -d'party' -b -x -c'red' -- TYPE { $[replace(';', ', ', {*})] }%; \
  /endif

/def area_flags = \
  /if ({#}) \
    /pass%; \
  /endif

/def area_warning = \
  /if ({#} & (is_me(tank) | is_me(commander))) \
    /say -d'party' -b -x -c'yellow' -- -> %{*}%; \
  /endif

/def area_wimpy_cmds_zmud = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _trig=#REGEX "$[me()].wimpy" {^$[toupper(me(), 1)] [\\[{<]party[>}\\]]: WIMPY \\{ (.+) \\} ?$$} {#VARIABLE $[me()].wimpy {%%1}}%; \
  /let _macro=#ALIAS cw {#EXECUTE {%%replace(@$[me()].wimpy, ", ", ";")}}%; \
  /execute %{_cmd} %{_trig}%; \
  /execute %{_cmd} %{_macro}

/def area_wimpy_cmds_tf = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _trig=/def -Fp10 -mregexp -t'^$[toupper(me(), 1)] [\\\\[{<]party[>}\\\\]]: WIMPY \\\\{ (.+) \\\\} ?$$' $[me()]_wimpy = /set $[me()]_wimpy=%%{P1}%; \
  /let _macro=/def cw = /eval -s1 !$$[replace(', ', '%%;!', $[me()]_wimpy)]%; \
  /execute %{_cmd} %{_trig}%; \
  /execute %{_cmd} %{_macro}

/def area_wimpy_cmds = \
  /if ({#} & (is_me(tank) | is_me(commander))) \
    /say -d'party' -b -x -c'red' -- WIMPY { $[replace(';', ', ', {*})] }%; \
  /endif

/def dopath = \
  /while ({#}) \
    /if ({1} =/ '[0-9]*' & {#} >= 2) \
      /let _rep=$[trunc({1} / 20)]%; \
      /if (_rep) \
        /repeat -S %{_rep} !20 %{2}%; \
      /endif%; \
      /let _mod=$[mod({1}, 20)]%; \
      /if (_mod) \
        /if (_mod > 1) \
          !%{_mod} %{2}%; \
        /else \
          !%{2}%; \
        /endif%; \
      /endif%; \
      /shift 2%; \
    /else \
      !%{1}%; \
      /shift%; \
    /endif%; \
  /done

/def -Fp5 -msimple -t'Travelling along a well worn road (nw,n,ne,w,e,sw,s,se).' at_9w = \
  /set location=9w

/def -Fp5 -msimple -t'A well maintained section of road (nw,n,ne,w,e,s).' at_1n = \
  /set location=1n

/def -Fp5 -msimple -t'A well maintained section of road (nw,n,ne,w,e,sw,s,se).' at_1ne = \
  /set location=1ne

/def -Fp6 -mregexp -t'^([A-Za-z].*) \\([a-z]+(,[a-z]+)*\\)\\.$' a_room = \
  /unset location

;;
;; RUN PATH
;;
;; This does many actions with the supplied arguments. This lets you, for
;; example run to a monster, set the target, tell party members what they need
;; to type, let them know about various warnings, gets certain items from your
;; bag of holding, and optionally sets the macro that would take you back and
;; the sets the number of rooms one would skip if they skipped the area.
;;
;; Usage: /run_path OPTIONS
;;
;;  OPTIONS:
;;
;;   -A ALIGNMENT  Alignment of the target
;;   -E EXPR       Expression to check before executing.
;;   -F FLAGS      Flags
;;   -W MESSAGE    Are warning message.
;;   -a AREA       Name of the area, room.
;;   -b BACK       Name of macro to get reverse.
;;   -c COMMANDS   Commands that other members need to type.
;;   -d DIRS       zMUD style dirs (; separated).
;;   -f            Force sending of text to mud even if idle/away.
;;   -i ITEMS      Items needed from bag of holding.
;;   -n NAME       Name of the current path.
;;   -r NUMBER     The current room number.
;;   -s SKIP       Number of rooms to skip if you wish to not continue.
;;   -t TARGET     Target to set.
;;   -w DIRS       zMUD style wimpy dirs (; separated).
;;   -x DIRS       zMUD style opposite of wimpy dirs (; separated)
;;
/def run_path = \
  /if (!getopts('d:b:t:a:c:w:x:i:s#r#W:n:E:F:A:f', '')) \
    /return%; \
  /endif%; \
  /if (strlen(opt_E) & !expr(opt_E)) \
    /return%; \
  /endif%; \
  /if (strlen(opt_n)) \
    /set location=%{opt_n}%; \
  /else \
    /unset location%; \
  /endif%; \
  /if (strlen(opt_b)) \
    /set back=%{opt_b}%; \
  /else \
    /unset back%; \
  /endif%; \
  /if (strlen(opt_i) & bag) \
    !get %{opt_i} from bag of holding%; \
  /endif%; \
  /if (strlen(opt_d)) \
    /if (party_members > 1) \
      !ignore -m on%; \
    /endif%; \
    /plain_prompt%; \
    /leave_room%; \
    /if (opt_f) \
      /eval -s1 /send -- !$[replace(';', '%;/send -- !', opt_d)]%; \
    /else \
      /eval -s1 !$[replace(';', '%;!', opt_d)]%; \
    /endif%; \
    /if (party_members > 1 & !ignore_movement) \
      !ignore -m off%; \
    /endif%; \
    /status_prompt%; \
    /enter_room%; \
  /endif%; \
  /if (strlen(opt_i) & bag) \
    !put %{opt_i} in bag of holding%; \
  /endif%; \
  /if (strlen(opt_a)) \
    /let _area=%{opt_a}%; \
    /if (strlen(opt_A)) \
      /let _area=%{_area} (%{opt_A})%; \
    /endif%; \
    /if (opt_r) \
      /let _area=%{_area} [%{opt_r}]%; \
    /endif%; \
    /if (opt_s) \
      /let _area=%{_area} {SKIP:%{opt_s}}%; \
    /endif%; \
    /if (strlen(opt_F)) \
      /let _area=%{_area} <%{opt_F}>%; \
    /endif%; \
    /area %{_area}%; \
  /endif%; \
  /if (strlen(opt_F)) \
    /area_flags %{opt_F}%; \
  /endif%; \
  /if (strlen(opt_W)) \
    /area_warning %{opt_W}%; \
  /endif%; \
  /if (strlen(opt_c)) \
    /area_cmds %{opt_c}%; \
  /endif%; \
  /if (strlen(opt_w)) \
    /set out=%{opt_w}%; \
    /area_wimpy_cmds %{opt_w}%; \
  /else \
    /unset out%; \
  /endif%; \
  /if (strlen(opt_x)) \
    /set in=%{opt_x}%; \
  /else \
    /unset in%; \
  /endif%; \
  /if (opt_s) \
    /set skip=%{opt_s}%; \
  /else \
    /unset skip%; \
  /endif%; \
  /if (strlen(opt_t)) \
    /set_target_locally %{opt_t}%; \
    /area_target %{opt_t}%; \
    /if (scan_target) \
      !look at %{opt_t}%; \
    /endif%; \
  /endif%; \
  @update_status

/property -s -g on_leave_room

/def leave_room = \
  /if (strlen(on_leave_room)) \
    /eval %{on_leave_room}%; \
  /endif%; \
  @on_leave_room

/property -s -g on_enter_room

/def enter_room = \
  /if (strlen(on_enter_room)) \
    /eval %{on_enter_room}%; \
  /endif%; \
  @on_enter_room

;;
;; SHOOT
;;
;; Goes to the catapult and shoots x y.
;;
;; Usage: /shoot <home|x y>
;;
/def shoot = \
  /if ({#} > 1 | {*} =~ 'home') \
    /set shoot=%{*}%; \
    /run_path -d'7 s;10 e'%; \
    !shoot %{shoot}%; \
  /endif

/def -Fp5 -msimple -t'...  WHEEE . . . .. .. .  .' shoot_done = \
  /if (shoot =~ 'home') \
    !enter%; \
  /endif%; \
  /unset shoot

/def cshome = /shoot home

/def flute = \
  !sw%;!se%; \
  !need flute%; \
  !get flute%; \
  /if (bag) \
    !get flute from bag of holding%; \
  /endif%; \
  !nw%;!ne%; \
  !play flute%; \
  /if (bag) \
    !put all flute in bag of holding%; \
  /endif%; \
  !keep all flute%; \
  !n%;!E%; \
  /if ({#}) \
    !%{*}%; \
    !pf%; \
  /endif

/set runner_file=example

/def area_target = \
  /if ({#} & report_target & (is_me(tank) | is_me(commander))) \
    /say -d'party' -b -x -m -c'green' -- TARGET { %{*} }%; \
  /endif

/def load_run = \
  /set runner_file=%{*-%{runner_file}}%; \
  /python zombie.runs.inst.loadMovementsFromConfigFile('$(/escape ' $[runs_dir(runner_file)])')%; \
  @update_status

/def reset_run = \
  /python zombie.runs.inst.reset()

/def close_run = /unload_run %{*}

/def unload_run = \
  /python zombie.runs.inst.unload()

/def lpr = /rewind_run %{*}
/def rewind_run = \
  /for i 1 %{1-1} /python zombie.runs.inst.rewind()

/def lnr = /forward_run %{*}
/def forward_run = \
  /for i 1 %{1-1} /python zombie.runs.inst.forward()

/def dnr = /display_next_room %{*}
/def display_next_room = \
  /python zombie.runs.inst.display()

/def pr = /prev_room
/def prev_room = \
  /python zombie.runs.inst.rewind()%; \
  /next_room

/def nr = /next_room
/def next_room = \
  /python zombie.runs.inst.execute()%; \
  /python zombie.runs.inst.forward()

/def skip = \
  /python zombie.runs.inst.skip()


;;
;; PROTECTIONS AND EFFECTS
;;

/test prot_extra_l := '{'
/test prot_extra_r := '}'

;;
;; ANNOUNCE PROT
;;
;; When prots are up/down this is what's called to keep a standard look and
;; feel.
;;
;; Usage: /announce_prot [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -n REPEATS    Number of times to repeat the message
;;   -o OTHER      Other information related to the prot
;;   -p PROT       The prot you wish to print
;;   -s STATUS     Prints the message with the color given
;;
/def announce_prot = \
  /if (!getopts('p:s#o:n#', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_p)) \
    /error -m'%{0}' -a'p' -- must be the name of the prot%; \
    /result 0%; \
  /endif%; \
  /if (report_prots) \
    /if (strlen(opt_o)) \
      /say -c'$[opt_s ? "green" : "red"]' -f'$(/escape ' $[opt_s ? "ON" : "OFF"] %{prot_extra_l}%{opt_o}%{prot_extra_r})' -n%{opt_n-1} -- %{opt_p}%; \
    /else \
      /say -c'$[opt_s ? "green" : "red"]' -f'$[opt_s ? "ON" : "OFF"]' -n%{opt_n-1} -- %{opt_p}%; \
    /endif%; \
  /else \
    /if (strlen(opt_o)) \
      /say -d'status' -f'$(/escape ' $[opt_s ? "ON" : "OFF"] %{prot_extra_l}%{opt_o}%{prot_extra_r})' -n%{opt_n-1} -- %{opt_p}%; \
    /else \
      /say -d'status' -f'$[opt_s ? "ON" : "OFF"]' -n%{opt_n-1} -- %{opt_p}%; \
    /endif%; \
  /endif

/def -Fp4 -msimple -h'SEND @on_enter_game' on_enter_game_prots = \
  /python zombie.effects.inst.reset()

;;
;; DEFINE PROT GROUP
;;
;; Defines a prot group which you can use later with prots.
;;
;; Usage: /def_prot_group [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -g KEY*       The key which matches this group
;;   -n NAME*      The name of this group
;;
/def def_prot_group = \
  /if (!getopts('g:n:', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_g)) \
    /error -m'%{0}' -a'g' -- must be the name of the group key%; \
    /result%; \
  /endif%; \
  /if (!strlen(opt_n)) \
    /error -m'%{0}' -a'n' -- must be the name of the prot group%; \
    /result%; \
  /endif%; \
  /set prot_%{opt_g}=%{opt_n}%; \
  /set prot_groups=$(/unique %{prot_groups} %{opt_g})%; \
  /python zombie.effects.inst.addGroup(zombie.effects.EffectGroup('$(/escape ' %{opt_g})', '$(/escape ' %{opt_n})'))

;;
;; DEFINE PROT
;;
;; Defines a protection spell/skill.
;;
;; Usage: /def_prot [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -c COUNT      The number of times that this can be stacked
;;   -g GROUP      The group that this prot belongs to
;;   -n NAME*      The name of this prot
;;   -p KEY*       The key which matches this prot
;;   -s SHORT      The short name of this prot
;;
/def def_prot = \
  /if (!getopts('p:n:c#g:s:t:', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_p)) \
    /error -m'%{0}' -a'p' -- must be the name of the prot key%; \
    /result%; \
  /endif%; \
  /if (!strlen(opt_n)) \
    /error -m'%{0}' -a'n' -- must be the name of the prot%; \
    /result%; \
  /endif%; \
  /python zombie.effects.inst.add(zombie.effects.Effect('$(/escape ' %{opt_p})', '$(/escape ' %{opt_n})', short_name='$(/escape ' %{opt_s})', layers=$[max(1, opt_c)], groups='$(/escape ' %{opt_g})'))

;;
;; PROT ON
;;
;; Turns on the prot defined by the KEY.
;;
;; Usage: /prot_on KEY
;;
/def prot_on = \
  /python zombie.effects.inst.on('$(/escape ' %{1})')%; \
  @update_status

;;
;; PROT STATUS
;;
/def prot_count = /result python('zombie.effects.inst.count("$(/escape " %{1})")')
/def prot_duration = /result python('zombie.effects.inst.duration("$(/escape " %{1})")')
/def prot_layers = /result python('zombie.effects.inst.layers("$(/escape " %{1})")')
/def prot_name = /result python('zombie.effects.inst.name("$(/escape " %{1})")')
/def prot_short_name = /result python('zombie.effects.inst.short_name("$(/escape " %{1})")')

;;
;; PROT OFF
;;
;; Turns off the prot defined by KEY.
;;
;; Usage: /prot_off KEY
;;
/def prot_off = \
  /python zombie.effects.inst.off('$(/escape ' %{1})')%; \
  @update_status

/property -i -v'10' prots_cooldown

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) whispers to you \'prots\'' whisper_prots = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /runif -t%{prots_cooldown} -n'cpl_p' -- /cpl_p%; \
  /endif

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ attempts to seduce you\\.$' seduce_prots = \
  /if (is_me(tank) & party_members > 1) \
    /runif -t%{prots_cooldown} -n'cpo_p' -- /cpo_p%; \
  /endif

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) whispers to you \'proo+ts\'' whisper_proots = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /runif -t%{prots_cooldown} -n'cpm_p' -- /cpm_p%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) feels the urge to mate with you\\.$' mate_prots = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /runif -t%{prots_cooldown} -n'cpm_p' -- /cpm_p%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) nibbles on your ear\\.$' nibble_prots = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /runif -t%{prots_cooldown} -n'cpl_p' -- /cpl_p%; \
  /endif

/def cpo = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python zombie.effects.inst.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(status)15s |', online=True, offline=False)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python zombie.effects.inst.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(status)15s@{n} |', online=True, offline=False)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def cpo_p = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python zombie.effects.inst.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(status)15s', online=True, offline=False)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def cpo_timer = \
  /if (!{#}) \
    /if (is_pid('cpo_timer_pid')) \
      /error -m'%{0}' -- running as pid %{cpo_timer_pid}%; \
    /else \
      /error -m'%{0}' -- not running%; \
    /endif%; \
    /return%; \
  /endif%; \
  /kill cpo_timer_pid%; \
  /if ({1} > 0) \
    /timer -t%{*} -n1 -p'cpo_timer_pid' -- /cpo_timer %{*}%; \
    /if (party_members & is_me(tank) & (idle_time < 1 | idle() <= idle_time)) \
      /cpo_p%; \
    /endif%; \
  /else \
    /say -d'status' -- /cpo_timer not running%; \
  /endif

/property -s -g cpl_prots

/def cpm = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python zombie.effects.inst.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(status)15s |', keys='$(/escape ' %{cpl_prots})', online=False, offline=True)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python zombie.effects.inst.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(status)15s@{n} |', keys='$(/escape ' %{cpl_prots})', online=False, offline=True)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def cpm_p = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python zombie.effects.inst.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(status)15s', keys='$(/escape ' %{cpl_prots})', online=False, offline=True)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def cpl = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python zombie.effects.inst.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(status)15s |', keys='$(/escape ' %{cpl_prots})', online=True, offline=True)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python zombie.effects.inst.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(status)15s@{n} |', keys='$(/escape ' %{cpl_prots})', online=True, offline=True)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def cpl_p = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python zombie.effects.inst.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(status)15s', keys='$(/escape ' %{cpl_prots})', online=True, offline=True)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def cpl_timer = \
  /if (!{#}) \
    /if (is_pid('cpl_timer_pid')) \
      /say -d'status' -- /cpl_timer running as pid %{cpl_timer_pid}%; \
    /else \
      /say -d'status' -- /cpl_timer not running%; \
    /endif%; \
    /return%; \
  /endif%; \
  /kill cpl_timer_pid%; \
  /if ({1} > 0) \
    /timer -t%{*} -n1 -p'cpl_timer_pid' -- /cpl_timer %{*}%; \
    /if (party_members & is_me(tank) & idle() < idle_time) \
      /cpl_p%; \
    /endif%; \
  /else \
    /say -d'status' -- /cpl_timer not running%; \
  /endif

;;
;; fhelp
;;

/def fhelp_print = \
  /if (!getopts('k:d:', '') | !strlen(opt_k) | !strlen(opt_d)) \
    /return%; \
  /endif%; \
  /echo -w -p -- > @{BCyellow}$[pad(opt_k, 16)]@{n}: %{opt_d}

/def fhelp = @fhelp

/def fhelp_clear = /purgedef fhelp_key_*

/def fhelp_add = \
  /if (!getopts('k:d:', '') | !strlen(opt_k) | !strlen(opt_d)) \
    /return%; \
  /endif%; \
  /def -Fp5 -msimple -h'SEND @fhelp' fhelp_key_$[textencode(opt_k)] = \
    /fhelp_print -k'$$(/escape ' %{opt_k})' -d'$$(/escape ' %{opt_d})'

/def key_esc_home = /tick
/fhelp_add -k'meta_home' -d"Do '/tick' (time since last tick)"

/def key_esc_pgup = /in
/fhelp_add -k'meta_pageup' -d"Do '/in' (go %%in)"

/def key_esc_pgdn = /out
/fhelp_add -k'meta_pagedn' -d"Do '/out' (go %%out)"

/def key_f1 = \
  /say -d'party' -m -x -c'red' -- GOING OUT!%; \
  /say -d'party' -m -x -c'yellow' -- GOING OUT!

/fhelp_add -k'f1' -d"Send 'GOING OUT!' to party"

/def key_shift_f1 = \
  /say -d'party' -m -x -c'green' -- GOING IN!%; \
  /say -d'party' -m -x -c'yellow' -- GOING IN!

/fhelp_add -k'shift_f1' -d"Send 'GOING IN!' to party"

/def key_esc_f1 = /key_shift_f1
/def key_meta_f1 = /key_shift_f1
/def key_ctrl_f1 = /key_shift_f1

/def key_f2 = !party locations
/fhelp_add -k'f2' -d"Send 'party locations'"

/def key_shift_f2 = !party kills
/fhelp_add -k'shift_f2' -d"Send 'party kills'"

/def key_esc_f2 = /key_shift_f2
/def key_meta_f2 = /key_shift_f2
/def key_ctrl_f2 = /key_shift_f2

/def key_f3 = /party_status -f
/fhelp_add -k'f3' -d"Send 'party status'"

/def key_shift_f3 = /rate
/fhelp_add -k'shift_f3' -d"Do '/rate'"

/def key_esc_f3 = /key_shift_f3
/def key_meta_f3 = /key_shift_f3
/def key_ctrl_f3 = /key_shift_f3

/def key_f4 = /next_room
/fhelp_add -k'f4' -d"Run to the next room (/next_room)"

/def key_shift_f4 = /skip
/def key_esc_f4 = /key_shift_f4
/def key_meta_f4 = /key_shift_f4
/def key_f16 = /key_shift_f4
/fhelp_add -k'shift_f4' -d"Skip this area (/skip)"

/def key_f5 = /k
/fhelp_add -k'f5' -d"Do '/k' (default skill/spell @ target)"

/def key_shift_f5 = /kx
/fhelp_add -k'shift_f5' -d"Do '/kx' (default skill/spell)"

/def key_esc_f5 = /key_shift_f5
/def key_meta_f5 = /key_shift_f5
/def key_ctrl_f5 = /key_shift_f5

/def key_f6 = /kk
/fhelp_add -k'f6' -d"Do '/kk' (kill + default skill/spell @ target)"

/def key_shift_f6 = /ka
/fhelp_add -k'shift_f6' -d"Do '/ka' (kill all + default skill/spell @ target)"

/def key_esc_f6 = /key_shift_f6
/def key_meta_f6 = /key_shift_f6
/def key_ctrl_f6 = /key_shift_f6

/def key_f7 = /ks
/fhelp_add -k'f7' -d"Do '/ks' (start skill/spell @ target)"

/def key_shift_f7 = /kq
/fhelp_add -k'shift_f7' -d"Do '/kq' (default skill/spell @ target, silently)"

/def key_esc_f7 = /key_shift_f7
/def key_meta_f7 = /key_shift_f7
/def key_ctrl_f7 = /key_shift_f7

/def key_f8 = /h
/fhelp_add -k'f8' -d"Do '/h' (default heal skill/spell @ healing)"

/def key_shift_f8 = /h me
/fhelp_add -k'shift_f8' -d"Do '/h me' (default heal skill/spell @ me)"

/def key_esc_f8 = /key_shift_f8
/def key_meta_f8 = /key_shift_f8
/def key_ctrl_f8 = /key_shift_f8

/def key_f9 = /dm
/fhelp_add -k'f9' -d"Do '/dm' (drink moonshine)"

/def key_shift_f9 = /spot
/fhelp_add -k'shift_f9' -d"Do '/spot' (sip potion)"

/def key_esc_f9 = /key_shift_f9
/def key_meta_f9 = /key_shift_f9
/def key_ctrl_f9 = /key_shift_f9

/def key_f10 = /cpo
/fhelp_add -k'f10' -d"Do '/cpo' (Check prots online)"

/def key_shift_f10 = /cpo_p
/fhelp_add -k'shift_f10' -d"Do '/cpo_p' (Check prots online to party)"

/def key_esc_f10 = /key_shift_f10
/def key_meta_f10 = /key_shift_f10
/def key_ctrl_f10 = /key_shift_f10

/def key_f11 = /cpl
/fhelp_add -k'f11' -d"Do '/cpl' (Check prots list)"

/def key_shift_f11 = /cpl_p
/fhelp_add -k'shift_f11' -d"Do '/cpl_p' (Check prots list to party)"

/def key_esc_f11 = /key_shift_f11
/def key_meta_f11 = /key_shift_f11
/def key_ctrl_f11 = /key_shift_f11

/def key_f12 = !pull vine
/fhelp_add -k'f12' -d"Send 'pull vine'"

/def -Fp5 -msimple -t'Armageddon shouts \'The end of the world approaches you in 50 seconds\'' armageddon_50 = \
  /send -- !summary%; \
  /if (bag) \
    /send -- !get all gold from bag of holding%; \
  /endif

/def -Fp5 -msimple -t'Armageddon shouts \'The end of the world approaches you in 40 seconds\'' armageddon_40 = \
  /if (ld_at_boot & strlen(world_info('name'))) \
    /zsend save;ld%; \
    /dc%; \
    /let _time=80%; \
    /say -d'status' -- Going link dead for $[to_dhms(_time, 1)] for recoveries%; \
    /repeat -%{_time} 1 /world $[world_info('name')]%; \
  /endif

/def -Fp5 -msimple -t'Armageddon shouts \'The end of the world is near\'' armageddon_arrives = \
  /zsend i;eq;ll;slots;last tell

/def -Fp5 -msimple -h'SEND @save' save_basic = /mapcar /listvar \
  announce announce_echo_* announce_emote_* announce_other_* announce_party_* \
  announce_say_* announce_status_* announce_think_* announce_to attack_command \
  attack_method attack_skill attack_spell casting_speed chest_name chest_start chest_end \
  chest_dir chest_dir_back class_caster class_fighter cpl_prots echo_attr email \
  enemies error_attr gac_extra give_noeq_target heal_command heal_method heal_skill \
  heal_spell healing idle_time ignore_movement ld_at_boot logging my_party_color \
  my_party_name my_stat_str my_stat_dex my_stat_con my_stat_int my_stat_wis \
  my_stat_cha my_stat_siz on_alive on_kill on_enemy_killed on_kill_corpse \
  on_loot on_kill_give_to on_kill_loot on_start_attack on_start_heal \
  on_unstunned p_* pac_extra prefix prot_extra_* prots_cooldown quiet_mode \
  report_sksp report_fatigue report_hps report_kills report_prots report_scans \
  report_sps report_target report_ticks report_warnings runner_file scan_target \
  s_hp s_maxhp s_sp s_maxsp spell_speed spell_speed_* start_attack_command \
  start_attack_method start_attack_skill start_attack_spell stat_cha_cost \
  stat_cha_count stat_con_cost stat_con_count stat_dex_cost stat_dex_count stat_int_cost \
  stat_int_count stat_str_cost stat_str_count stat_wis_cost stat_wis_count \
  status_attr status_pad tank target target_emotes target_name tick_show \
  tick_sps tick_time ticking tinning title on_enter_game on_enter_room \
  on_leave_game on_leave_room on_return_game on_new_round \
  %| /writefile $[save_dir('basic')]

/def -Fp5 -h'DISCONNECT|SIGTERM|SIGHUP' disconnect_save = @save

/def quit = \
  @save%; \
  /@quit

/def save_timer = \
  @save%; \
  /timer -t$[save_interval * 60] -n1 -p'save_pid' -k -- /save_timer

/eval /load $[save_dir('basic')]
/save_timer
