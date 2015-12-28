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
;; $LastChangedDate: 2012-03-08 19:18:10 -0800 (Thu, 08 Mar 2012) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie.tf $', 10, -2)]

/test version := substr('$LastChangedRevision: 1890 $', 22, -2)

/require textutil.tf
/require lisp.tf
/python from trigs import mail
/python reload(mail)
/python from trigs import util
/python reload(util)
/python from trigs.zombie import effects
/python reload(effects)
/python from trigs.zombie import runs
/python reload(runs)

;;;;
;;
;; Variable that keeps track of the current MUD.
;;
/set MUD=zombie

;;;;
;;
;; Global id generator. The id is an integer which starts at 0 and is
;; incremented each time that this macro is called.
;;
;; @return A unique id.
;;
/def id = /result ++id

;;;;
;;
;; Purge all of the non-invisible triggers, macros, hooks and then reload the
;; main script-- either as parameter or from previous reload.
;;
;; @param script
;;     The script to be reloaded. If no script is given then the WORLD.tf file
;;     is loaded.
;;
/def -i reload = \
  /if ({#} | strlen(_script) | strlen(world_info('name'))) \
    /set _script=%{*-%{_script-$[strcat(world_info('name'), '.tf')]}}%; \
    /purge%; \
    /unset _loaded_libs%; \
    /load %{HOME}/.tfrc%; \
    /load %{_script}%; \
  /endif

;;;;
;;
;; Display version information.
;;
/def version = \
  /@version%; \
  /_echo % $(/zver)

/def zver = /_echo Conglomo's Zombii Trigs v1.1.%{version}

;;
;; TELL/COMMUNICATION BLOCKS
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

;;;;
;;
;; Trim's spaces from both ends of the given string.
;;
;; @param string* The string that is to be trimmed.
;; @return The string after having leading/traling white space removed.
;;
/def trim = /result $$(/_echo %%{*})

;;;;
;;
;; Given the string of chars, return a string of what the getopt would look
;; like. For example, if you pass 'abc' then %{opt_a}, %{opt_b}, %{opt_c} will
;; be checked and if %{opt_a} and %{opt_c} evaluate to true then they will be
;; turned into '-a -c'.
;;
;; @param chars* The string of chars that are to be checked.
;; @return A string that looks like getopt parameters.
;;
/def generate_getopts = \
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

;;;;
;;
;; Update variables in a standard way. The various options are used to further
;; restrict the values set.
;;
;; @option b Interpret the value as a boolean.
;; @option c Clear the value of the variable.
;; @option f Interpret the value as a float.
;; @option g Use the /grab macro to make command editable.
;; @option i Interpret the value as an integer.
;; @option p:name The proper name (if different) to echo.
;; @option q Quiet mode.
;; @option s Use is_true() to clear variables that match false.
;; @option t Interpret the value as time.
;; @option v:value The value to give the variable.
;; @option n:name* The name of the variable to update.
;;
/def update_value = \
  /if (!getopts('n:v:p:qsbtifcg', '')) \
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
    /elseif (opt_s & !is_true(opt_v)) \
      /set %{opt_n}=%; \
    /else \
      /test %{opt_n} := opt_v%; \
    /endif%; \
  /elseif (opt_b) \
    /test %{opt_n} := !expr(opt_n)%; \
  /endif%; \
  /if (!opt_q) \
    /print_value -n'$(/escape ' %{opt_n})' -p'$(/escape ' %{opt_p})' $[generate_getopts('btifg')]%; \
  /endif%; \
  @update_status

;;;;
;;
;; Defines a property (setter) which is used to update variables in a standard
;; way. The property can also be defined exactly like a ''/def''. This is
;; useful for special properties which validate values before setting them.
;;
;; @param macro* The name of the macro to be defined.
;; @param =
;; @param body
;;
;; @option b Interpret the value as a boolean.
;; @option f Interpret the value as a float.
;; @option g Use the /grab macro to make command editable.
;; @option i Interpret the value as an integer.
;; @option s Use is_true() to clear variables that match false.
;; @option t Interpret the value as time.
;; @option v:value Default value for this property.
;;
/def property = \
  /if (!getopts('sbtifgv:', '') | !{#}) \
    /return%; \
  /endif%; \
  /if (strstr({*}, '=') > -1) \
    /def %{*}%; \
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
  /def %{_macro} = /update_value -n'$(/escape ' %{_macro})' -v'$$(/escape ' %%{*})' $[generate_getopts('sbtifg')]

;;;;
;;
;; Prints the value of a variable in a standard way.
;;
;; @option b Print the value as a boolean.
;; @option g Grab the command back to the command line.
;; @option f Print the value as a float.
;; @option i Print the value as an integer.
;; @option n:name The name of the variable to be printed.
;; @option p:name The proper name (if different) to echo.
;; @option t Print the value as a time.
;; @option v:variable Ignore the variable and use this value.
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

;;;;
;;
;; Returns whether or not the argument is a valid announce destination.
;;
;; @param destination* The announce destination that is checked.
;; @return A non-zero integer if the destination was valid. Zero otherwise.
;;
/def is_announce = \
    /result isin({*}, 'default', 'echo', 'emote', 'other', 'party', 'say', 'status', 'think')

;;;;
;;
;; The main trig interface to displaying messages. This macro will announce
;; the message to the default medium unless otherwise specified. Will also
;; only delegate to the other announce_to macros when %{announce} is true or
;; otherwise forced.
;;
;; @param message* The message that is to be announced.
;;
;; @option a Announce regardless of the %{announce} var's setting.
;; @option b Do not print customized brackets (party).
;; @option c:color Prints the message with the color given.
;; @option d:destination The destination of the message. Without this it uses the
;;     %{announce_to} variable.
;; @option f:status Prints a status for the message using separator.
;; @option m Only send messages to party IF there's more than one member (party).
;; @option n#repeats Number of times to repeat the message.
;; @option t Send messages if and only if you are the tank (party).
;; @option x Never send messages to status when other channel fails.
;;
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

/def say = /do_announce %{*}

;;;;
;;
;; Should announcements be sent? This is the overall setting that controls
;; announcements. When this is off all macros which use "/do_announce" will be
;; disabled.
;;
/property -b announce

;;;;
;;
;; The default place to send announcements. Possible values include: "echo",
;; "emote", "other", "party", "say", "status" and "think". Of these, "status"
;; is the only one that does not send anything to the mud. If no argument is
;; given then the current value is displayed.
;;
;; @type string
;; @grab
;;
/property announce_to = \
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

;;;;
;;
;; The command that is used when {{ announce_to }} is set to "other". This
;; command will prefix all announcements. This is useful for sending
;; announcements to another channel or specifically to somebody else.
;;
/property -g announce_other_command

;;;;
;;
;; Prints an example of all the brackets.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
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

;;;;
;;
;; Prints out a small test with the brackets.
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

;;;;
;;
;; Prints out the error to screen in a standard format.
;;
;; @param message* The error message to be printed.
;;
;; @option a:argument The argument that caused this error.
;; @option m:macro The macro which caused this error.
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

;;;;
;;
;; Toggles %{ignore_movement} and sends that action to the mud.
;;
;; @param value Value to set %{ignore_movement} to. If omitted then toggle the
;;     value between on and off.
;;
/def ignore_movement = \
  /update_value -n'ignore_movement' -v'$(/escape ' %{*})' -b%; \
  /if (ignore_movement) \
    !ignore -m on%; \
  /else \
    !ignore -m off%; \
  /endif

;;;;
;;
;; Returns the name of your character by looking at %{me} and finally at
;; ''world_info()''.
;;
;; @return The name of your character.
;;
/def me = /result strlen(me) ? me : world_info('character')

;;;;
;;
;; Returns whether or not the value matches your character name.
;;
;; @param value* The value to check against your characters name.
;; @return A non-zero integer if value does not match. Zero otherwise.
;;
/def is_me = /result tolower({1}) =~ tolower(me())

;;
;; Wipe default status.
;;

/mapcar /status_rm @world @read @active @log @mail insert kbnum @clock

;;;;
;;
;; Returns the align in an integer form.
;;
;; @param align* The alignment in string form.
;; @return An integer from -6 to +6 ranging from satanic to godly.
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
;; prompt output
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
  /if (regmatch('^([A-Za-z\' -]+) is in (good shape)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_good_shape} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z\' -]+) is (slightly hurt)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_slightly_hurt} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z\' -]+) is (moderately hurt)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_moderately_hurt} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z\' -]+) is (not in a good shape)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_not_in_a_good_shape} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z\' -]+) is in (bad shape)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_bad_shape} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z\' -]+) is in (very bad shape)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_very_bad_shape} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z\' -]+) is (almost DEAD)$$', p_scan)) \
    /update_target_scan -t'$(/escape ' %{P1})' -s${scan_almost_dead} -d'$(/escape ' $[toupper({P2})])'%; \
  /elseif (regmatch('^([A-Za-z\' -]+) is (DEAD MEAT)!$$', p_scan)) \
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
/def -Fp8 -mregexp -t'^hp: (-?\\d+)\\((\\d+)\\) sp: (-?\\d+)\\((\\d+)\\)$' update_prompt_score_report = \
  /set p_hp=%{P1}%; \
  /set p_maxhp=%{P2}%; \
  /set p_sp=%{P3}%; \
  /set p_maxsp=%{P4}%; \
  @update_status

;;;;
;;
;; Send the prompt command to the mud.
;;
/def status_prompt = !prompt p: <hp> <maxhp> <sp> <maxsp> <exp> <cash> <expl> <wgt> <last_exp> "<scan>" "<align>" <party><newline>

;;;;
;;
;; Clears the prompt on the mud.
;;
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
  /if (ticking & !is_idle() & tick_show & last_tick() <= tick_show) \
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

/def -Fp80 -msimple -h'SEND @update_status' update_status_80

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

;;;;
;;
;; Takes the given fatigue and displays it if it has changed.
;;
;; @option d:description* The description of the current fatigue level.
;; @option f#level* The current fatigue level.
;;
/def update_fatigue = \
  /if (!getopts('f#d:', '') | !strlen(opt_d) | opt_f == fatigue) \
    /return%; \
  /endif%; \
  /if (report_fatigue) \
    /say -d'think' -- %{opt_d} {$[delta_only(fatigue - opt_f)]}%; \
  /else \
    /say -d'status' -- %{opt_d} {$[delta_only(fatigue - opt_f)]}%; \
  /endif%; \
  /if (opt_f < fatigue) \
    /repeat -0 1 /ticked%; \
    /if (opt_f == ${fatigue_fully} & strlen(on_fully_rested)) \
      /eval %{on_fully_rested}%; \
      /unset on_fully_rested%; \
    /endif%; \
  /endif%; \
  /set fatigue=%{opt_f}%; \
  /set fatigue_desc=%{opt_d}%; \
  @update_status

/def fatigue_fully = 0
/def fatigue_almost = 1
/def fatigue_bit_tired = 2
/def fatigue_tired = 3
/def fatigue_exhausted = 4
/def fatigue_puuh = 5

/test fatigue := ${fatigue_fully}
/set fatigue_desc=Fully Rested

/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You feel fully rested\\.$' fatigue_0 = /update_fatigue -f${fatigue_fully} -d'Fully Rested'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You feel almost fully rested\\.$' fatigue_1 = /update_fatigue -f${fatigue_almost} -d'Almost Fully Rested'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You feel a bit tired\\.$' fatigue_2 = /update_fatigue -f${fatigue_bit_tired} -d'Bit Tired'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You feel tired\\.$' fatigue_3 = /update_fatigue -f${fatigue_tired} -d'Tired'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?You are exhausted\\.$' fatigue_4 = /update_fatigue -f${fatigue_exhausted} -d'Exhausted'
/def -Fp5 -ag -mregexp -t'^(Fatigue changed: )?Puuh... you are TIRED!$' fatigue_5 = /update_fatigue -f${fatigue_puuh} -d'TIRED'

/def scan_good_shape = 100
/def scan_slightly_hurt = 90
/def scan_moderately_hurt = 75
/def scan_not_in_a_good_shape = 50
/def scan_bad_shape = 25
/def scan_very_bad_shape = 10
/def scan_almost_dead = 5
/def scan_dead_meat = 0

;;;;
;;
;; Takes the given shape and displays it if it has changed.
;;
;; @option d:description* The description of the health level.
;; @option s#level* The current health level.
;; @option t:target* The display name of the target.
;; @option x Do not show scan changes to status.
;;
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

/def -Fp5 -aBCyellow -mregexp -t'^([A-Za-z\' -]+) is (in )?(good shape|slightly hurt|moderately hurt|not in a good shape|bad shape|very bad shape|almost DEAD|DEAD MEAT)[\\.!]$' scan = \
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

;;;;
;;
;; Change your spoken language to 'beastspeak', say the specified command, and
;; then return to the common speak.
;;
;; @param command* The command to send to your beast.
;;
/def beastspeak = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /if (speak !~ 'beastspeak') \
    !speak beastspeak%; \
  /endif%; \
  !say %{*}%; \
  /if (speak !~ 'beastspeak') \
    !speak %{speak}%; \
  /endif

/def bsay = /beastspeak %{*}

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

;;;;
;;
;; Prints out the time of the last tick
;;
/def tick = /say -d'status' -- Last tick was $[to_dhms(last_tick(), 1)] ago

;;;;
;;
;; The amount of time s since your last tick to show in the status bar. As long
;; as your tick is less than this setting your status bar will be updating
;; every second. After which your status will only be updated with events.
;;
/property -t -v'00:02:00' tick_show

;;;;
;;
;; Returns the number of seconds since your last tick.
;;
;; @return The number of seconds since your last stick.
;;
/def last_tick = /result trunc(time() - tick_start)

;;;;
;;
;; Extra commands that should be executed after your next tick. The most common
;; usage for this to re-enter combat immediately after you tick. This setting
;; is temporary and will only be executed once.
;;
;; @temporary
;;
/property -s on_tick

;;;;
;;
;; Extra commands that should be executed after your next tick warning. The
;; most common usage for this to leave combat just before you are about to
;; tick. This setting is temporary and will only be executed once.
;;
;; @temporary
;;
/property -s on_tick_warn

;;;;
;;
;; Extra commands that should be executed after you sizzle (full sps). This
;; setting is temporary and will only be executed once.
;;
;; @temporary
;;
/property -s on_sizzle

;;;;
;;
;; Extra commands that should be executed after you are fully healed. This
;; setting is temporary and will only be executed once.
;;
;; @temporary
;;
/property -s on_fully_healed

;;;;
;;
;; Extra commands that should be executed after you are fully rested. This
;; setting is temporary and will only be executed once.
;;
;; @temporary
;;
/property -s on_fully_rested

;;;;
;;
;; Called when you tick. Keeps track of time and optionally warns when the next
;; one should come using the %{tick_time} variable.
;;
;; @hook on_tick
;; @hook update_status
;;
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

;;;;
;;
;; The number of spell points to change before a tick is recognized. You will
;; want to keep this setting as close to your bare minimum as possible as you
;; will want to avoid having things that are not ticks be registered as such.
;;
/property -i -v'100' tick_sps

;;;;
;;
;; The time to wait before warning you about an incoming tick. A total of 2
;; warnings will be issued, the second of which will be this setting x2.
;;
/property -t -v'00:00:20' tick_time

;;;;
;;
;; Is your incarnation one which ticks? This states that you receive ticks and
;; all things tick related should be used. If you are a Death Knight you will
;; want to turn this off.
;;
/property -b -v'1' ticking

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

;;;;
;;
;; Simple macro that prints out when your last tick was. It will optionally
;; repeat if you missed your tick.
;;
;; @param repeats If set, it will create a timer based on %{tick_time} and run
;;     this macro again. The next call will decrease the reapts by one till it
;;     stops.
;;
/def tick_timer = \
  /let _time=$[last_tick()]%; \
  /if (_time > 10) \
    /say -d'status' -f'last %{_time}s ago' -- Ticking Soon%; \
  /endif%; \
  /if (strlen(on_tick_warn)) \
    /eval %{on_tick_warn}%; \
    /unset on_tick_warn%; \
  /endif%; \
  /if ({1} > 0) \
    /timer -t%{tick_time} -n1 -p'tick_pid' -k -- /tick_timer $[{1} - 1]%; \
  /else \
    /unset tick_pid%; \
  /endif

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
    /repeat -0 1 /ticked%; \
  /endif%; \
  /set s_hp=%{_hp}%; \
  /set s_maxhp=%{_maxhp}%; \
  /set s_sp=%{_sp}%; \
  /set s_maxsp=%{_maxsp}

;;;;
;;
;; Display information about the stats that you've trained and the amount of
;; exp needed for the next stat.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
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

/def -Fp5 -ag -mregexp -t'^Str: (\\d+), Con: (\\d+), Dex: (\\d+), Int: (\\d+), Wis: (\\d+), Cha: (\\d+), Size: (\\d+), Hpr: (\\d+), Spr: (\\d+)$' my_stats = \
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
  /set my_stat_hpr_diff=$[{P8} - my_stat_hpr]%; \
  /set my_stat_hpr=%{P8}%; \
  /set my_stat_spr_diff=$[{P9} - my_stat_spr]%; \
  /set my_stat_spr=%{P9}%; \
/echo -w -p -aCgreen -- %{prefix} Str: $[pad(my_stat_str, 3)] [$[my_stat_str_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_str_diff > 0 ? '+' : '', my_stat_str_diff), 4)]@{n}] Con: $[pad(my_stat_con, 3)] [$[my_stat_con_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_con_diff > 0 ? '+' : '', my_stat_con_diff), 4)]@{n}] Dex: $[pad(my_stat_dex, 3)] [$[my_stat_dex_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_dex_diff > 0 ? '+' : '', my_stat_dex_diff), 4)]@{n}]%; \
  /echo -w -p -aCgreen -- %{prefix} Int: $[pad(my_stat_int, 3)] [$[my_stat_int_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_int_diff > 0 ? '+' : '', my_stat_int_diff), 4)]@{n}] Wis: $[pad(my_stat_wis, 3)] [$[my_stat_wis_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_wis_diff > 0 ? '+' : '', my_stat_wis_diff), 4)]@{n}] Cha: $[pad(my_stat_cha, 3)] [$[my_stat_cha_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_cha_diff > 0 ? '+' : '', my_stat_cha_diff), 4)]@{n}]%; \
 /echo -w -p -aCgreen -- %{prefix} Hpr: $[pad(my_stat_hpr, 3)] [$[my_stat_hpr_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_hpr_diff > 0 ? '+' : '', my_stat_hpr_diff), 4)]@{n}] Spr: $[pad(my_stat_spr, 3)] [$[my_stat_spr_diff >= 0 ? '@{BCgreen}' : '@{BCred}']$[pad(strcat(my_stat_spr_diff > 0 ? '+' : '', my_stat_spr_diff), 4)]@{n}]

;;;;
;;
;; Display your current stats and the amount that they've changed since the
;; last time you checked.
;;
;; @param command
;;    Command used when displaying output. Useful for sending output to a
;;    channel, etc.
;;
/def stats = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say --%; \
  /endif%; \
  /execute %{_cmd} Str: $[pad({my_stat_str-0}, 3)] [$[pad(strcat({my_stat_str_diff-0} > 0 ? '+' : '', {my_stat_str_diff-0}), 4)]] Con: $[pad({my_stat_con-0}, 3)] [$[pad(strcat({my_stat_con_diff-0} > 0 ? '+' : '', {my_stat_con_diff-0}), 4)]] Dex: $[pad({my_stat_dex-0}, 3)] [$[pad(strcat({my_stat_dex_diff-0} > 0 ? '+' : '', {my_stat_dex_diff-0}), 4)]]%; \
  /execute %{_cmd} Int: $[pad({my_stat_int-0}, 3)] [$[pad(strcat({my_stat_int_diff-0} > 0 ? '+' : '', {my_stat_int_diff-0}), 4)]] Wis: $[pad({my_stat_wis-0}, 3)] [$[pad(strcat({my_stat_wis_diff-0} > 0 ? '+' : '', {my_stat_wis_diff-0}), 4)]] Cha: $[pad({my_stat_cha-0}, 3)] [$[pad(strcat({my_stat_cha_diff-0} > 0 ? '+' : '', {my_stat_cha_diff-0}), 4)]]%; \
  /execute %{_cmd} Hpr: $[pad({my_stat_hpr-0}, 3)] [$[pad(strcat({my_stat_hpr_diff-0} > 0 ? '+' : '', {my_stat_int_hpr-0}), 4)]] Spr: $[pad({my_stat_spr-0}, 3)] [$[pad(strcat({my_stat_spr_diff-0} > 0 ? '+' : '', {my_stat_spr_diff-0}), 4)]]

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

;;;;
;;
;; Extra commands that should be executed after you return to the game from
;; link death. These commands are also executed when entering the game.
;;
/property -s -g on_return_game

;;;;
;;
;; Execute all of the initialization commands when returning to the game. This
;; is automatically called when returning from link death.
;;
;; @hook on_return_game
;;
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

;;;;
;;
;; Extra commands that should be executed after you enter the game. If you have
;; {{ idle_time }} set and wish to have something like your
;; "bag of holding" summoned you should prefix the commands with "/send".
;;
/property -s -g on_enter_game

;;;;
;;
;; Execute all of the initialization commands when entering the game. This is
;; automatically called when entering the game after quitting. This is also
;; useful when using the triggers for the first time.
;;
;; @hook on_enter_game
;;
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

;;;;
;;
;; Extra commands that should be executed after you leave the game. These
;; commands are executed after you have quit so nothing can be sent to the mud.
;;
/property -s -g on_leave_game

;;;;
;;
;; Execute all of the de-initialization commands when leaving the game. This is
;; automatically executed after quitting the game.
;;
;; @hook on_leave_game
;;
/def -Fp10 -mregexp -t'^[\\[{<](enemy|inform|friend)[>}\\]]: ([A-Z][a-z]+) left the game\\.$' leave_game = \
  /if (!dead & is_me({P2})) \
    /kill cpo_timer_pid cps_timer_pid cpl_timer_pid%; \
    /if (strlen(on_leave_game)) \
      /eval %{on_leave_game}%; \
    /endif%; \
    @on_leave_game%; \
  /endif

;;;;
;;
;; Gets the value of the alias from the mud and sets the local copy.
;;
;; @param variable* The variable that you wish to retrieve or update. The
;;     variable is stored on the mud as the _variable alias.
;; @param value Value to set the variable to. If omitted then the value is
;;     retrieved from the mud.
;;
;; @option f Force this request even if idle/away.
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

;;;;
;;
;; The name of the current party commander. This setting is automatically
;; configured when typing "party status". If you are not in a party this
;; setting will be your character's name.
;;
/property -g commander
/test commander := strlen(commander) ? commander : me()

;;;;
;;
;; The name of the current party tank. This setting is automatically configured
;; when typing "party status". If you are not in a party this setting will be
;; your character's name.
;;
/property -g tank
/test tank := strlen(tank) ? tank : me()

;;;;
;;
;; The name of the current party aide (if any). This setting is automatically
;; configured when typing "party status".
;;
/property -g aide
/test aide := strlen(aide) ? aide : ''

;;;;
;;
;; Prefix for all messages that are echoed to the status.
;;
/property -g -v'%' prefix

;;;;
;;
;; Should your character go ld at boot to try and get crash recoveries? This
;; will cause your character to go link dead 40s before boot hits.
;;
/property -b ld_at_boot

;;;;
;;
;; Should your hit point changes be reported to those around you? This is
;; different than "sc party" in that it shows the actual changes and percents.
;;
/property -b report_hps

;;;;
;;
;; Should your spell point changes be reported to those around you? This is
;; different than "sc party" in that it shows the actual changes and percents.
;;
/property -b report_sps

;;;;
;;
;; Should your ticks be reported to those around you? This setting will report
;; to "think" the fact that you ticked and how many seconds it took for your
;; tick.
;;
/property -b report_ticks

;;;;
;;
;; Should fatigue changes be reported to those around you? This setting will
;; report any changes in your fatigue to "think". This is extremely useful for
;; smaller parties where your damage matters.
;;
/property -b report_fatigue

;;;;
;;
;; Should the killing of your locked target be announced to those around you?
;; This is useful for letting those not currently in the room know about combat
;; being completed.
;;
/property -b report_kills

;;;;
;;
;; Should offensive skills/spells be reported to those around you? This setting
;; is checked during "/do_kill" and reports the skill and the target you are
;; casting/using to "party". This is especially useful when leading a group as
;; you want to share the exact target.
;;
/property -b report_target

;;;;
;;
;; Should the current shape of your locked target be reported to those around
;; you? This is useful for letting those not currently in the room know how
;; close the target is to being killed.
;;
/property -b report_scans

;;;;
;;
;; Should the status of your effects be reported to those around you? This
;; displays the fact that some effect is comes up or has fallen.
;;
/property -b report_effects

;;;;
;;
;; Should skills/spells be reported to those around you? This setting is
;; checked during "/do_prot" and "/do_heal" and reports what you are
;; casting/using. This option is similar to {{ report_target }}.
;;
/property -b report_sksp

;;;;
;;
;; Should general warnings be reported to those around you? This setting will
;; report things such as incoming spells or the fact that the locked target has
;; arrived to "party". This is useful when leading a group of vulnerable
;; players.
;;
/property -b report_warnings

;;;;
;;
;; Should the client act as quietly as possible? This setting disables all
;; announcements, disables the target emotes and attempts to make your
;; character be as quiet as possible. This will not work normally when in this
;; mode and it's mostly useful for player killing.
;;
/property -b quiet_mode

;;;;
;;
;; Should your target be scanned? This setting used to control the new round
;; scan but that's been replaced with the prompt. This just controls whether or
;; not you scan/look at the target for other things such as "/run_path" or
;; "/set_target". This is useful for monsters that have specials that harm you
;; when scanning them such as the Lumberjack.
;;
/property -b scan_target

;;;;
;;
;; Should all of your non-kept inventory be given to target? This option is
;; checked for "initiator" skills, such as "battlecry", "kiru" or "ki". This is
;; also checked when using "/ks".
;;
/property -b give_noeq_target

;;;;
;;
;; Is your incarnation int/wis/spell based? This states that your character is
;; roughly of type "caster". The reporting of no spell points is enabled with
;; this option.
;;
/property -b class_caster

;;;;
;;
;; Is your incarnation str/dex/con/skill based? This states that your character
;; is roughly of type "fighter". Things like using the "kill" command to
;; initiate combat are defined with this setting.
;;
/property -b class_fighter

;;;;
;;
;; The name of the party to create when entering the game. This setting is
;; automatically configured when creating a party with "party create".
;;
/property -s -g my_party_name

;;;;
;;
;; If set this will set the "party colour" after creating a new party. Possible
;; options include: "red", "green" or "blue".
;;
/property -s -g my_party_color

;;;;
;;
;; The time after which triggers should stop sending data to the mud. This is
;; useful for preventing your character from unidling when you are not present.
;;
/property -t -v'00:03:00' idle_time

;;;;
;;
;; Attribute to use when echoing text to the status. See "/help attributes" for
;; more details.
;;
/property -g -v'Ccyan' echo_attr

;;;;
;;
;; Attribute to use when echoing errors to the status. See "/help attributes"
;; for more details.
;;
/property -g -v'Cred' error_attr

;;;;
;;
;; Attribute to use for your status bar. You will want it to be something that
;; stands out from the normal mud output. See "/help attributes" for more
;; details.
;;
/property -g -v'r' status_attr

;;;;
;;
;; The character that should be used to pad your status. This character will
;; populate all regions of your status not filled with other data. A character
;; such as "_" or "#" are recommended.
;;
/property -g -v'_' status_pad

;;
;; LOGGING
;;

/set logging=1

;;;;
;;
;; Should world output be logged? This will cause a daily log to appear in the
;; format of yyyy-mm-dd.log in your logs/WORLD directory.
;;
/property logging = \
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

;;;;
;;
;; List of emotes that should be used when locking a target. If more than one
;; is given then a random emote will be selected each time you lock your
;; target. Possible values include: "wobble", "smooch", "drool", "french",
;; "threaten", "surprise", "mercy", "disarm", "puppyeyes", "snuggle", "forbid",
;; "applaud", "compliment", "bad" and "fullmoon". As a Devil you can also use
;; "dchallenge" and "dgrin" which are particularly useful since they aren't
;; messed up with targets who also happen to be verbs.
;;
/property -g -v'wobble smooch truce drool french threaten surprise mercy disarm puppyeyes snuggle forbid applaud compliment bad fullmoon' target_emotes

;;;;
;;
;; Picks out a random %{target_emote} and then performs that action against the
;; %{target}.
;;
;; @param target The target you are trying to lock.
;;
/def lock_target = \
  /let _target=%{target}%; \
  /if (regmatch('^(.+) \\d+$$', _target)) \
    /let _target=%{P1}%; \
  /endif%; \
  !$(/random %{target_emotes}) %{_target}

;;;;
;;
;; Returns a random value from the list of values provided.
;;
;; @param value0..valueN* The list of values to select from.
;; @return A random value.
;;
/def random = /result {R}

;;;;
;;
;; Returns the tf {position} of the supplied string.
;;
;; @param position* The item at position you wish to retrieve.
;; @param value0..valueN* The list of values to select from.
;; @return The value at position.
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

;;;;
;;
;; Tests the target emotes.
;;
/def test_target_emotes = \
  /foreach %{target_emotes} = !%%{1} %{*-%{target}}

;;;;
;;
;; List of players who should automatically be targetted when entering the
;; room, casting a spell or hitting you. This is useful so you can quickly
;; retaliate without having to type their name.
;;
/property -s -g enemies

;;;;
;;
;; The emotes to use when searching for enemies with the "/find_enemies"
;; command. These emotes are used against your enemy in a way similar to <a
;; href="#target_emotes">/target_emotes</a>. If more than one is given then a
;; random emote will be selected each time you try to find your enemy. If an
;; emote works then your target will be set. Possible values include: "amuse",
;; "annoyed", "calm", "chicken", "burn", "care", "confuse", "curtsey", "duck",
;; "grimace", "howl", "loathe", "beg", "moo", "pinch", "pity", "pretend",
;; "sad", "whine", "why", "wtf" and "zzz".
;;
/property -g -v'amuse annoyed calm chicken burn care confuse curtsey duck grimace howl loathe moo pinch pity pretend sad whine why wtf zzz' enemy_emotes

;;;;
;;
;; Find players defined in %{enemies} by running the gambit of %{enemy_emotes}.
;;
/def find_enemies = /mapcar /find_enemy %{enemies}

/def fe = /find_enemies %{*}

;;;;
;;
;; Will use the %{enemy_emotes} and attempt to find the enemy specified.
;;
;; @param enemy*
;;     The enemy that you wish to search for.
;;
/def find_enemy = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  !$(/random %{enemy_emotes}) %{*}

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

;;;;
;;
;; Sets the %{target} if the argument is in %{enemies}. This is called by
;; movement, attacks, and other events.
;;
;; @param target The target to be checked against %{enemies}.
;;
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

;;;;
;;
;; Set the %{target} without sending anything to the mud. It also initializes
;; things such as the %{target_name}, %{rounds} and %{target_shape}. If no
;; target is given then the existing %{target} is used.
;;
;; @param target The target set set locally.
;;
/def set_target_locally = \
  /if ({#}) \
    /let _target=$[tolower(strip_attr({*}))]%; \
  /else \
    /let _target=%{target}%; \
  /endif%; \
  /if (target !~ _target) \
    /set target_name=%; \
    /set rounds=0%; \
  /endif%; \
  /set target=%{_target}%; \
  /set target_shape=${scan_good_shape}%; \
  @update_status

;;;;
;;
;; Sets the target quietly; meaning that it'll call {{ set_target_locally }}
;; and set target aliases. It also attemps to scan the target if %{scan_target}
;; is true.
;;
;; @param target The target to set quietly.
;;
/def set_target_quietly = \
  /set_target_locally %{*}%; \
  /alias target %{target}%; \
  /if (scan_target) \
    !scan %{target}%; \
  /endif

;;;;
;;
;; Extra commands that should be executed when you lock your target with
;; "/set_target".
;;
/property -s -g on_set_target

;;;;
;;
;; Sets the target; calling {{ set_target_quietly }}, {{ lock_target }} and evaluates the
;; on_set_target hook. No announcements are sent.
;;
;; @param target The name of the target to set. If omitted then %{target} is used.
;;
;; @hook on_set_target
;;
/def set_target = \
  /set_target_quietly %{*}%; \
  /if (!quiet_mode) \
    /lock_target%; \
  /endif%; \
  /if (strlen(on_set_target)) \
    /eval %{on_set_target}%; \
  /endif%; \
  @on_set_target %{target}

;;;;
;;
;; Sets the target and announces that value. Calls the {{ set_target }} macro.
;;
;; @param target The name of the target to set. If omitted then %{target} is used.
;;
/def target = \
  /set_target %{*}%; \
  /if (!strlen(target)) \
    /error -m'%{0}' -- parameters required when {target} is null%; \
    /return%; \
  /endif%; \
  /if (report_target) \
    /say -d'party' -b -m -x -c'green' -- TARGET { %{target} }%; \
  /endif

/def l = /target %{*}
/def t = /target %{*}
/def tgt = /target %{*}

;;;;
;;
;; Scan %{target}.
;;
/def shape_target = !scan %{target}
/def st = /shape_target %{*}

;;;;
;;
;; Give noeq to %{target}.
;;
/def give_noeq_to_target = !give noeq to %{target}
/def gt = /give_noeq_to_target %{*}

;;;;
;;
;; Look at %{target}.
;;
/def look_target = !look at %{target}
/def lt = /look_target %{*}

;;;;
;;
;; Lookup the creator of %{target}.
;;
/def creator_target = !creator %{target}
/def crt = /creator_target %{*}

;;;;
;;
;; Kill the %{target}.
;;
/def kill_target = !kill %{target}
/def kt = /kill_target %{*}

;;;;
;;
;; Look for %{target} in current area.
;;
/def where_target = !where %{target}
/def wt = /where_target %{*}

;;;;
;;
;; Touch the %{target}. (vampire/werewolf)
;;
/def touch_target = !touch %{target}
/def touch = /touch_target %{*}

;;;;
;;
;; Set the auto target. This is called from {{ def_auto_target }} macros. It
;; checks to make sure that the originator of this event is actually the
;; %{tank} or %{commander} and are actually a party member. It finally runs {{
;; set_target_locally }} when all those checks match.
;;
;; @param target The target to set if all matches are satisfied.
;; @option t:tank* The tank/commander announcing targets.
;;
/def set_auto_target = \
  /if (getopts('t:', '') & {#} & !is_me(opt_t) & (tolower(opt_t) =~ tank | tolower(opt_t) =~ commander) & !is_party_member({*})) \
    /set_target_locally %{*}%; \
    /if (beep_auto_target) \
      /beep%; \
    /endif%; \
  /endif

;;;;
;;
;; Beep whenever an auto target is set.
;;
/property -b beep_auto_target

;;;;
;;
;; Escapes regular expression's special characters.
;;
;; @param string The string to escape.
;; @return The string which has had all of its regular expression characters
;;     escaped.
;;
/def regescape = /result escape('\\*.+?|{}[]($$)^',  {*})

;;;;
;;
;; Define an auto target macro which is created as
;; ''auto_target_TANK_COUNT''. This automatically escapes all regular
;; expressions and makes it easier to add auto targets. It also allows you to
;; not worry about how to match the party strings.
;;
;; @option l:left The text to the left of the target.
;; @option n:count The number of auto targets tank has.
;; @option r:right The text to the right of the target.
;; @option t:tank The tank announcing targets.
;;
;; @example
;;     If your tank has messages that look like
;;     <code>Conglomo [party]: BC --&gt; bob &lt--</code>
;;     then you can create an auto target with the following command:
;;     <code>/def_auto_target -t'conglomo' -n0 -l'BC --&gt; ' -r'
;;     &lt;--'</code>
;;
/def def_auto_target = \
  /if (!getopts('t:n#l:r:', '') | (!strlen(opt_l) & !strlen(opt_r))) \
    /return%; \
  /endif%; \
  /let opt_n=$[opt_n ? opt_n : 0]%; \
  /if (strlen(opt_t)) \
    /let opt_t=$[tolower(opt_t)]%; \
    /let _trig=^$[toupper(opt_t, 1)] [\\[{<]party[>}\\]]: $[escape('\'', regescape(opt_l))](.+)$[escape('\'', regescape(opt_r))] ?$$%; \
    /def -Fp10 -aB -mregexp -t'%{_trig}' auto_target_%{opt_t}_%{opt_n} = \
      /set_auto_target -t'$(/escape ' %{opt_t})' -- %%{P1}%; \
  /else \
    /let _trig=^([A-Z][a-z]+) [\\[{<]party[>}\\]]: $[escape('\'', regescape(opt_l))](.+)$[escape('\'', regescape(opt_r))] ?$$%; \
    /def -Fp10 -aB -mregexp -t'%{_trig}' auto_target_all_%{opt_n} = \
      /set_auto_target -t'$$[tolower({P1})]' -- %%{P2}%; \
  /endif

/def add_auto_target = /def_auto_target %{*}

;;
;; COMMON TANK AUTO TARGETS
;;

/def_auto_target -l'TARGET { ' -r' }'

;;
;; LAG CHECKER
;;

;;;;
;;
;; Allow others to trigger your lag check via the "ping" command.
;;
/property -b -v'1' allow_pings

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ (pings you|goes \'PING\')\\.' ping = \
  /if (!allow_pings) \
    /return%; \
  /endif%; \
  /runif -t5 -n'ping' -- /lag think

/def -Fp10 -mregexp -t'^[\\[{<]([a-z]+)[>}\\]]: [A-Z][a-z]+ pings ([A-Z][a-z]+)\\.$' ping_channel = \
  /if (!allow_pings | !is_me({P2})) \
    /return%; \
  /endif%; \
  /runif -t5 -n'ping_channel' -- /lag channels send %{P1}

;;;;
;;
;; Requests the lag time from the mud. Optionally takes a command for where to
;; report the lag time.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
/def lag = \
  /let _key=$[hex(id())]%; \
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

;;;;
;;
;; Checks the party locations and reports on who is missing from your current
;; location.
;;
;; @option v Be verbose and announce missing members to party.
;;
/def plo = \
  /if (!getopts('v', '')) \
    /return%; \
  /endif%; \
  /if (is_me(tank) | is_me(commander)) \
    /set plo_status=1%; \
    /set plo_search=0%; \
    /set plo_verbose=%{opt_v}%; \
    /set plo_missing=%; \
    /unset plo_tank%; \
  /endif%; \
  !party locations%; \
  /if (is_me(tank) | is_me(commander)) \
    !echo /plo start%; \
    !party locations%; \
    !echo /plo finish%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) +: (.*)$' plo_entry = \
  /if (!plo_status) \
    /return%; \
  /endif%; \
  /substitute -ag%; \
  /if (tolower({P1}) =~ tank) \
    /set plo_tank=%{P2}%; \
  /elseif (plo_search & strlen(plo_tank) & !is_me({P1}) & plo_tank !~ {P2}) \
    /if (plo_tank =~ 'Link Morgue ()' | {P2} =~ 'Link Morgue ()') \
      /return%; \
    /endif%; \
    /if (plo_tank =~ 'Can\'t see a thing' | {P2} =~ 'Can\'t see a thing') \
      /return%; \
    /endif%; \
    !emoteto $[tolower({P1})] wishes you were here: %{plo_tank}%; \
    /set plo_missing=%{plo_missing} %{P1}%; \
  /endif

/def -Fp5 -ag -msimple -t'/plo start' plo_start = \
  /set plo_search=1

/def -Fp5 -ag -msimple -t'/plo finish' plo_finish = \
  /if (strlen(plo_missing)) \
    /if (plo_verbose) \
      /say -d'party' -c'yellow' -- Where are you? $[join(plo_missing, '? ')]? Come here!%; \
    /endif%; \
  /else \
    /say -d'status' -c'green' -- All members are here!%; \
  /endif%; \
  /set plo_status=

;;;;
;;
;; Forces each of the members to follow by making them the leader.
;;
;; @param member0..memberN The members to force follow.
;;
/def pf = \
  /while ({#}) \
    !party leader $[tolower({1})]%; \
    /shift%; \
  /done%; \
  !party leader $[me()]

;;;;
;;
;; Check which party members are following.
;;
;; @option f Force the non-following members to follow.
;; @option v Be verbose and announce missing members to party.
;;
/def pfs = \
  /if (!getopts('fv', '')) \
    /return%; \
  /endif%; \
  /if (is_me(tank) | is_me(commander)) \
    /set pfs_status=1%; \
    /set pfs_force=%{opt_f}%; \
    /set pfs_verbose=%{opt_v}%; \
    /set pfs_stragglers=%; \
  /endif%; \
  !party status%; \
  !echo /pfs

/def -Fp5 -ag -msimple -t'/pfs' pfs_message = \
  /if (!pfs_status) \
    /return%; \
  /endif%; \
  /if (pfs_force) \
    !party leader $[me()]%; \
  /elseif (strlen(pfs_stragglers)) \
    /if (pfs_verbose) \
      /say -d'party' -c'yellow' -- Follow me? $[join(pfs_stragglers, '! ')]!%; \
    /endif%; \
  /else \
    /say -d'status' -c'green' -- All members following!%; \
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
      /set pfs_stragglers=%{pfs_stragglers} %{P2}%; \
    /endif%; \
  /endif%; \
  @update_status

/def -Fp5 -mregexp -t'^   ([A-Z][a-z]+) +(ld|mbr): aid ' party_status_aide = \
  /set aide=$[tolower({P1})]

;;
;; PARTY
;;

;;;;
;;
;; Returns a list of the party members.
;;
;; @return A list of all the members in your party.
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

;;;;
;;
;; Perform action on each item in list. Use %1 as the item.
;;
;; @param item0..itemN* The items, separated by a space, to iterate over.
;; @param =*
;; @param action* The action to perform. Use %1 to refer to the current item.
;;
;; @example
;;     /foreach apple pear orange mango = !put %1 in barrel
;;
/def foreach = \
  /while ({#} & {1} !~ '=') \
    /split %{*}%; \
    /eval -s2 %{P2}%; \
    /shift%; \
  /done

;;;;
;;
;; Disband the party by kicking all members and then leaving it yourself.
;;
/def disband = \
  /foreach $[party_members()] = \
    /if (!is_me({1})) \
      !party kick %%{1}%%; \
    /endif%; \
  !party leave

;;;;
;;
;; Creates a party using %{my_party_name} and setting the color to
;; %{my_party_color} (if specified).
;;
;; @option f Force the creation of party even if you are idle/away.
;;
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

;;;;
;;
;; Get the status of your current party. This checks to see if you are an aide
;; and runs the appropriate command. This command also has a check to make sure
;; that the status isn't checked more than once/second.
;;
;; @option f Force the checking of status even if you just checked it.
;;
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
    /runif -t1 -n'party_status' -- %{_party_status}%; \
  /endif%; \

/def -Fp5 -msimple -t'New marching order set.' new_party_order = \
  /party_status

/def -Fp5 -msimple -t'Counters reset.' party_counters_reset = \
  /quote -S /unset `/listvar -s joined_party_*

;;;;
;;
;; Returns the party bonus based on the number of members.
;;
;; @param members* The number of members in the party.
;; @return The percentual bonus based on the number of members.
;;
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

;;;;
;;
;; Reports the party shares. It looks at the exp all members in the party have
;; gained since it was last reset and shows what percent of the total they
;; received. It also shows their effective rate.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
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

;;;;
;;
;; The command that is used when {{ attack_method }} is set to "other". This
;; command will be used in place of "use" or "cast". This is useful for Rangers
;; who use Bows where the command is "fire".
;;
/property -g attack_command

;;;;
;;
;; The method used when starting attacks with the basic: "/k", "/kk", "/kx" and
;; "/ka". Possible values include: "use", "cast" or "other".
;;
/property attack_method = \
  /if ({#} & !isin({*}, 'cast', 'other', 'use')) \
    /error -m'%{0}' -- must be one of: cast, other, use%; \
    /update_value -n'attack_method' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'attack_method' -v'$(/escape ' %{*})' -g

;;;;
;;
;; The skill to use when {{ attack_method }} is "use". This should be your
;; primary attack skill.
;;
/property -g attack_skill

;;;;
;;
;; The spell to cast when {{ attack_method }} is "cast". This should be your
;; primary attack spell.
;;
/property -g attack_spell

;;;;
;;
;; The command that is used when {{ heal_method }} is set to "other". This
;; command will be used in place of "use" or "cast". This is useful for using
;; special items that heal you.
;;
/property -g heal_command

;;;;
;;
;; The method used when starting heals with "/h". Possible values include:
;; "use", "cast" or "other".
;;
/property heal_method = \
  /if ({#} & !isin({*}, 'cast', 'other', 'use')) \
    /error -m'%{0}' -- must be one of: cast, other, use%; \
    /update_value -n'heal_method' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'heal_method' -v'$(/escape ' %{*})' -g

;;;;
;;
;; The skill to use when {{ heal_method }} is "use". This should be your
;; primary heal skill.
;;
/property -g heal_skill

;;;;
;;
;; The spell to cast when {{ heal_method }} is "cast". This should be your
;; primary heal spell.
;;
/property -g heal_spell

;;;;
;;
;; The command that is used when {{ start_attack_method }} is set to "other".
;; This command will be used in place of "use" or "cast".
;;
/property -g start_attack_command

;;;;
;;
;; The method used when starting attacks with the basic: "/ks". Possible values
;; include: "use", "cast" or "other".
;;
/property start_attack_method = \
  /if ({#} & !isin({*}, 'cast', 'other', 'use')) \
    /error -m'%{0}' -- must be one of: cast, other, use%; \
    /update_value -n'start_attack_method' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'start_attack_method' -v'$(/escape ' %{*})' -g

;;;;
;;
;; The skill to use when {{ start_attack_method }} is "use". This should be
;; your primary start attack skill such as "battlecry", "kiru" or "ki".
;;
/property -g start_attack_skill

;;;;
;;
;; The spell to cast when {{ start_attack_method }} is "cast". This should be
;; your primary start attack spell such as "mental illusions".
;;
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

;;;;
;;
;; Extra commands that should be exected when something is healed with
;; "/do_heal".
;;
/property -s -g on_start_heal

;;;;
;;
;; The main interface for which to cast/use heals.
;;
;; @option a:action* The action to perform. Must be one of 'cast', 'use' or
;;     'other'.
;; @option d Do not scan the target before healing.
;; @option n:name The proper name of this skill/spell.
;; @option q Do not announce that you are about to heal.
;; @option s:sksp* The skill or spell to perform.
;; @option t:target* The target to heal.
;; @option x:speed Casting speed. Must be one of 'very quick', 'quick',
;;     'normal', 'slow' or 'very slow'.
;;
;; @example /do_heal -a'cast' -s'heal body' -t'conglomo' -x'very quick'
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

;;;;
;;
;; Sets the healing alias and sets local copy.
;;
;; @param target Set the healing target/alias to this. If omitted then display
;;     the current healing target.
;;
/def healing = /alias healing %{*}

;;;;
;;
;; The basic heal macro that calls {{ do_heal }} with default settings. It uses
;; %{heal_method} to determine the action uses %{heal_spell}, %{heal_skill} or
;; %{heal_command} accordingly.
;;
;; @param target The healing target. If omitted then it'll attempt to ues
;;     %{healing}.
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

;;;;
;;
;; Sets the %{healing} target to the current %{tank} or to {{ me }} if you are
;; not in a party.
;;
/def ht = /healing %{tank-$[me()]}

;;
;; ATTACK METHODS
;;

;;;;
;;
;; Extra commands that should be exected when something is attacked with
;; "/do_kill". This is useful for playing Samurai where you can type
;; "skenjutsu", "sspirit" or "smwalk" before attacking.
;;
/property -s -g on_start_attack

;;;;
;;
;; The main interface for which to cast/use attacks.
;;
;; @option a:action* The action to perform. Must be one of 'cast', 'use' or
;;     'other'.
;; @option i Defines this as an initiator sksp and does some extra
;;     actions such as enabling %{give_noeq_target}.
;; @option k Kill the target as well as start skill/spell.
;; @option m Use kill all instead of kill when -k is enabled.
;; @option n:name The proper name of the skill/spell.
;; @option q Do this attack as quietly as possible.
;; @option s:sksp* Name of the skill or spell to perform.
;; @option t:target* The target to kill.
;; @option v Verbose. Announce always.
;; @option x:speed Casting speed. Must be one of 'very quick', 'quick',
;;     'normal', 'slow' or 'very slow'.
;;
;; @hook on_start_attack
;;
;; @example /do_kill -a'use' -s'ki' -k -i -t'giftah'
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
    /if (opt_v | (report_target & party_members > 1)) \
      /say -f'$(/escape ' %{opt_t})' -b -x -- $[capitalize({opt_n-%{opt_s}})]%; \
    /endif%; \
  /endif%; \
  /let _time=$[last_tick()]%; \
  /if (!opt_k & _time > tick_time / 2 & _time < tick_time * 2) \
    /tick%; \
  /endif%; \
  /if (strlen(on_start_attack)) \
    /eval %{on_start_attack}%; \
  /endif%; \
  @on_start_attack %{opt_t}%; \
  /if (opt_k) \
    !kill $[opt_m ? 'all ' : '']%{opt_t}%; \
  /endif%; \
  /say -d'status' -f'$(/escape ' %{opt_t})' -- $[opt_k ? 'Killing + ' : '']%{opt_s}%; \
  /if (opt_a =~ 'other') \
    /let _cmd=%{opt_s}%; \
  /else \
    /let _cmd=%{opt_a} '%{opt_s}'%; \
  /endif%; \
  !%{_cmd} $[opt_k & !opt_q ? '' : opt_t] $[strlen(opt_x) ? strcat('try ', opt_x) : '']

;;;;
;;
;; Restarts the previous skill or spell without using a target.
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

;;;;
;;
;; The basic attack macro that calls {{ do_kill }} with default settings. It
;; uses %{attack_method} to determine the action uses %{attack_spell},
;; %{attack_skill} or %{attack_command} accordingly.
;;
;; @param target The name of the target to set. If omitted then %{target} is used.
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

;;;;
;;
;; Like {{ k }} except that it calls {{ do_kill }} with the -q option, meaning
;; that it wont be announcing the target, moving items, or doing any of the
;; target emotes.
;;
;; @param target The name of the target to set. If omitted then %{target} is used.
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

;;;;
;;
;; Like {{ k }} except that it calls {{ do_kill }} with the -k option, meaning
;; that it will attempt to 'kill' the target before starting the action.
;;
;; @param target The name of the target to set. If omitted then %{target} is used.
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

;;;;
;;
;; Like {{ kk }} except that it calls {{ do_kill }} with the -m option, meaning
;; that it will attempt to 'kill all' of the specified target before starting
;; the action.
;;
;; @param target The name of the target to set. If omitted then %{target} is used.
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

;;;;
;;
;; The basic attack macro that calls {{ do_kill }} with default settings. It
;; uses %{start_attack_method} to determine the action uses
;; %{start_attack_spell}, %{start_attack_skill} or %{start_attack_command}
;; accordingly. It also calls {{ do_kill }} with the -i option, meaning that it
;; defines this as an initiator sksp.
;;
;; @param target The name of the target to set. If omitted then %{target} is used.
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
;; SWIMMING
;;

/def -Fp5 -msimple -t'You feel rested and ready to swim.' swim_ready = /say -- Ready to Swim!
/def -Fp5 -mglob -t'Try as you might, you are just too tired to swim *.' swim_fail = \
  /runif -n'drowning' -t5 -- /say -d'party' -m -x -c'red' -- ACK!! I'M DROWNING!!

;;
;; TITLE
;;

;;;;
;;
;; The title you wish your character to have. Some things like balloons cause
;; your title to change and this helps restore your title to your desired text.
;;
/property -g title

;;;;
;;
;; Updates your title to the stored value of %{title}.
;;
;; @option f Force sending of text to mud even if idle/away.
;;
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
  /if (!effect_count('kamikaze')) \
    /say -d'party' -n3 -t -m -x -c'red' -- WARNING!! $[toupper({P1})] BANISHED ME! RUN FOR THE HILLS!%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Za-z\' -]+) arrives(.*)\\.$' other_arrives = \
  /if ({P1} =~ target_name) \
    /say -d'party' -c'red' -t -m -x -- WARNING!! $[toupper({P1})] ARRIVED! WARNING!!%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Za-z\' -]+) leaves(.*)\\.$' other_leaves = \
  /if ({P1} =~ target_name) \
    /say -d'party' -t -m -x -- %{P1} Left the Room!%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Za-z\' -]+) staggers and reels from the blow!$' other_stunned = \
  /if (report_warnings & tolower({P1}) =~ tank) \
    /say -d'party' -m -x -c'red' -n2 -- $[toupper({P1})] STUNNED! ACK!%; \
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

/def -Fp5 -mregexp -t'^([A-Za-z\' -]+) seems to have regained control of [a-z]+!$' other_unstunned = \
  /if (report_warnings & {P1} =~ target_name) \
    /say -d'party' -c'red' -m -x -- $[toupper({P1})] Looks PISSED!%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Za-z\' -]+) starts concentrating on a spell\\.$' other_casting = \
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

;;;;
;;
;; Extra commands that should be exected after you are free from the
;; stun/interrupt.
;;
/property -s -g on_unstunned

/def -Fp5 -msimple -t'You stagger and see stars appear before your eyes, making you lose ' slash_stagger = \
  /if (action == ${action_attack}) \
    /kx%; \
  /endif%; \
  /if (strlen(on_unstunned)) \
    /eval %{on_unstunned}%; \
  /endif%; \
  @on_unstunned%; \

/def -Fp5 -msimple -t'The hard impact of the book makes you completely lose concentration.' book_interrupt = /slash_stagger

/def -Fp5 -mregexp -t'^[A-Za-z\' -]+ awesome slash breaks your concentration\\.$' slash_stun = /slash_stagger

/def -Fp5 -mregexp -t'^[A-Za-z\' -]+ breaks your concentration with his devastating assault\\.$' devastating_assault = /slash_stagger

/def -Fp5 -msimple -t'You can\'t use this skill while you or the target is fighting.' start_attack_interrupted = /slash_stagger

/def -Fp5 -mregexp -t'^[A-Z][a-z]+\'s taunting enrages you\\.$' taunted = /slash_stagger

/def -Fp5 -mregexp -t'^^[A-Za-z\' -]+ interupts your concentration\\.$' interrupted = /slash_stagger

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ moves with amazing speed and disarms you with a hurtful blow!$' disarmed = !slots

/def -Fp5 -mregexp -t'^[A-Z][a-z]+\'s attack breaks your concentration\\.$' concentration_broken = /slash_stagger

/def -Fp5 -msimple -t'Ground trembles and shakes!' sceptre_trembles = /slash_stagger

/def -Fp5 -mregexp -t'^You feel like ([A-Za-z]+) is looking over your shoulder\\.$' somebody_snooping = \
  /say -x -c'red' -- EEP! $[toupper({P1})] is snooping me!

/def -Fp5 -mregexp -t'^([A-Z][a-z]+)\'s skin becomes red and tender\\.$' molecular_agitation_party = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /say -d'party' -m -x -c'red' -- $[toupper({P1})]! $[toupper({P1})]! $[toupper({P1})]! $[toupper({P1})]!%; \
    /say -d'party' -m -x -c'red' -- YOUR SKIN IS BURNING! YOUR SKIN IS BURNING! MOVE NOW!%; \
  /endif

/def -Fp5 -mregexp -t'^The fiend\'s sharp tail pierces ([A-Z][a-z]+)\'s chest and momentarily$' fiend_poison = \
  /if (is_me(tank) & !is_me({P1}) & isin({P1}, party_members())) \
    /say -d'party' -m -x -c'red' -n2 -- HELP $[toupper({P1})]! POISONED!%; \
  /endif

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

;;;;
;;
;; Should the R.I.P. trigger be a loose match? When enabled the locked target
;; name is not checked and corpse triggers will be triggered on any "is DEAD,
;; R.I.P." message.
;;
/property -b on_kill_loose

;;;;
;;
;; Update the mud's autoloot setting depending on the state of %{on_kill},
;; %{on_kill_loot} and %{on_looted}, as well as the current value of
;; %{autoloot}. This only sends text to the mud if there's a change.
;;
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

;;;;
;;
;; The player/pet to give all loot to after looting a corpse. If set to "tank"
;; the value is automatically filled with whomever is the tank.
;;
/property -s -g on_loot_give_to

;;;;
;;
;; Tin the corpse and process the can. If you have a %{bag} and %{stuff_bag}
;; set then it'll grab the can to your bag of holding. Otherwise it'll just
;; take it.
;;
/def tin = \
  !tin corpse%; \
  /if (bag & stuff_bag) \
    !get all can to bag of holding%; \
  /endif%; \
  !get all can

/def on_kill_corpse = \
  /if ({#} & !isin({*}, 'carriage', 'dig', 'eat', 'get', 'leave', 'off', 'stuff', 'tin')) \
    /error -m'%{0}' -- must be one of: carriage, dig, eat, get, leave, stuff, tin%; \
    /update_value -n'on_kill_corpse' -g%; \
    /return%; \
  /endif%; \
  /update_value -n'on_kill_corpse' -v'$(/escape ' %{*})' -g

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) takes ' looted = \
  /if (tolower({P1}) =~ on_looted) \
    /loot%; \
  /endif

;;;;
;;
;; Extra commands that should be executed after your locked target is killed.
;; These commands are executed independent of the "/on_kill" setting and before
;; any possible loot/corpse actions are completed.
;;
/property -s -g on_enemy_killed

;;;;
;;
;; Executed actions after an enemy was killed. This is automatically called
;; after a locked target is killed or when %{on_kill_loose} is enabled.
;;
;; @hook on_enemy_killed
;;
/def -Fp5 -mregexp -t'^([A-Za-z\' -]+) is DEAD, R\\.I\\.P\\.$' enemy_killed = \
  /if (!on_kill_loose & {P1} !~ target_name) \
    /return%; \
  /endif%; \
  !save%; \
  /let _time=$[time() - kill_time]%; \
  /let _stats=%{rounds} round$[rounds == 1 ? '' : 's'], $[to_dhms(_time > 60*60*24 ? -1 : _time)]%; \
  /substitute -- %{*} [%{_stats}]%; \
  /if (report_kills) \
    /say -d'party' -m -x -c'green' -- %{P1} is DEAD! (%{_stats})%; \
  /endif%; \
  /set kill_time=0%; \
  /set rounds=0%; \
  /if (strlen(on_enemy_killed)) \
    /eval %{on_enemy_killed}%; \
  /endif%; \
  @on_enemy_killed %{P1}%; \
  /if (on_kill & !strlen(on_looted)) \
    /loot%; \
  /endif

;;;;
;;
;; Process the corpse according to %{on_kill_corpse}.
;;
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

;;;;
;;
;; Extra commands that should be exected after something is looted. This is
;; useful for giving arrows, shurikens or other items to other players.
;;
/property -s -g on_loot

;;;;
;;
;; Process all of the loot actions. This firstly checks the value of
;; %{on_kill_loot} and attempts to grab items items to inventory or bag of
;; holding. It then processes %{on_loot}. Lastly it checks
;; %{on_loot_give_to} and attempts to distribute items.
;;
;; @hook on_loot
;;
/def loot = \
  /if (on_kill_loot) \
    /if (bag & stuff_bag & (!strlen(on_loot_give_to) | (on_loot_give_to =~ 'tank' & is_me(tank)))) \
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
  /if (strlen(on_loot_give_to)) \
    /if (on_loot_give_to =~ 'tank') \
      /if (!is_me(tank)) \
        !give noeq to %{tank}%; \
      /endif%; \
    /else \
      !give noeq to %{on_loot_give_to}%; \
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

;;;;
;;
;; Extra commands that should be exected whenever a new combat round is
;; started. This is useful for spamming "party status" as a healer in eq.
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

;;;;
;;
;; Extra commands that should be executed after you are prayed or resurrected.
;; This is useful for healing yourself or resetting some other settings.
;;
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

;;;;
;;
;; Extra commands that should be executed after your next skill/spell
;; completes. This setting is temporary and will only be executed once. The
;; most common usage for this is to leave combat immediately after your
;; skill/spell completes.
;;
;; @temporary
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


;;;;
;;
;; Sets away, ensuring that most triggers will not send anything to the mud.
;; Any tells will be responded to with your away message and the amount of time
;; that you've been away.
;;
;; @param message The away message to set.
;;
;; @option q Quietly return from away.
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
      /let _first=$$(/first %%{P1})%%; \
      /if (_first =~ 'have') \
        /let _first=has%%; \
      /elseif (_first !~ 'can') \
        /let _first=%%{_first}s%%; \
      /endif%%; \
      !emote %%{_first} $$(/rest %%{P1})!%%; \
    /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) already has been blessed by ([A-Z][a-z]+)\\.$' already_bless = \
  !whisper $[tolower({P1})] %{P2} already blessed you.

;;;;
;;
;; The main interface for which to cast/use protective spells/skills.
;;
;; @option A:alias The mud alias to set when performing this action.
;; @option a:action* The action to perform. Must be one of 'cast' or 'use'.
;; @option d:destination The destination of the message. Without this it uses the
;;     %{announce_to} variable.
;; @option n:name The proper name of this skill/spell.
;; @option q Do not announce the performing of action.
;; @option s:sksp* The name of the skill/spell to perform.
;; @option t:target The target on which to perform action.
;; @option x:speed Casting speed. Must be one of 'very quick', 'quick',
;;     'normal', 'slow' or 'very slow'.
;;
/def do_prot = \
  /if (!getopts('A:a:d:s:n:t:x:q', '')) \
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
      /if (!is_announce(opt_d)) \
        /let opt_d=default%; \
      /endif%; \
    /else \
      /let opt_d=status%; \
    /endif%; \
    /say -d'$(/escape ' %{opt_d})' -- %{opt_n-%{opt_s}}%; \
    /return%; \
  /endif%; \
  /if (opt_t =~ 'me') \
    /let opt_t=$[me()]%; \
  /endif%; \
  /if (strlen(opt_A)) \
    /alias %{opt_A} %{opt_t}%; \
  /endif%; \
  !%{opt_a} '%{opt_s}' %{opt_t} $[strlen(opt_x) ? strcat('try ', opt_x) : '']%; \
  /if (report_sksp & !opt_q) \
    /if (!is_announce(opt_d)) \
      /let opt_d=default%; \
    /endif%; \
  /else \
    /let opt_d=status%; \
  /endif%; \
  /say -d'$(/escape ' %{opt_d})' -f'$(/escape ' %{opt_t})' -- $[capitalize({opt_n-%{opt_s}})]

;;;;
;;
;; Update/view the casting speeds for spells.
;;
;; @param spell The spell you wish to update.
;;
;; @option c Clear all spell speeds.
;; @option d Reset the spell speed to default.
;; @option x The speed at which to cast this spell.
;;
/def spell_speed = \
  /if (!getopts('x:dc', '')) \
    /return%; \
  /endif%; \
  /if (opt_c) \
    /quote -S /unset `/listvar -s spell_speed_*%; \
    /unset spell_speed%; \
    /say -d'status' -- All spell speeds have been cleared%; \
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
  /if (opt_d) \
    /unset %{_var}%; \
    /set spell_speed=$(/remove %{_key} %{spell_speed})%; \
  /elseif (strlen(opt_x)) \
    /test %{_var} := opt_x%; \
    /set spell_speed=$[sorted($(/unique %{spell_speed} %{_key}))]%; \
  /endif%; \
  /let _speed=$[expr(_var)]%; \
  /if (!strlen(_speed)) \
    /let _speed=default%; \
  /endif%; \
  /say -d'status' -- Spell speed for '%{_spell}' is set to %{_speed}

/def try = /spell_speed %{*}

;;;;
;;
;; Returns the speed of the given spell.
;;
;; @param spell The spell for which to retrieve the spell speed.
;;
;; @return The speed at which to 'try' for the given spell. If no setting is
;;     saved for the given spell then an empty string is returned.
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

;;;;
;;
;; Stops casting/using and report that to party if you are leading.
;;
/def cast_stop = \
  !cast stop%; \
  /if ((is_me(tank) | is_me(commander)) & party_members > 1) \
    /say -d'party' -m -x -c'red' -- STOP! HALT! CAST STOP!%; \
  /endif

/def cs = /cast_stop %{*}

;;;;
;;
;; Drinks moonshine. If you have a bag of holding then it attemps to take
;; moonshine from said bag.
;;
/def drink_moonshine = \
  /if (bag) \
    !get moonshine from bag of holding%; \
  /endif%; \
  !drink moonshine%; \
  /if (bag) \
    !put all moonshine in bag of holding%; \
  /endif%; \
  !keep all moonshine%; \
  !drop all bottle

/def dm = /drink_moonshine %{*}

;;;;
;;
;; Uses mud to define chains in a loop.
;;
;; @param sksp0..skspN List of skills/spells to chain in a loop. Use underscore
;;     instead of spaces in sksp names.
;;
;; @option t:target The target for the chains.
;;
;; @example /chain -t'_healing' shield_of_protection barkskin
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

;;;;
;;
;; Calculates your reinc tax from 'score2'. It assumes that the minimum reinc
;; tax is achieved in 34d and that the maximum tax is 5%.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
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
  /let _maxdays=34%; \
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

;;;;
;;
;; An exp rate calculator. It uses your current exp on hand %{p_exp} and
;; divides it by the time that this counter is started.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
;; @option a Announce the rate to your default %{announce_to} location.
;; @option c Clear the counter and do not track the rate.
;; @option r Reset counter and start a fresh calculation.
;;
/def rate = \
  /if (!getopts('acr', '')) \
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

;;;;
;;
;; This is basic egg timer implementation. It's used to setup small reminders.
;;
;; @param message The message to display when the egg timer goes off.
;;
;; @option a Announce the rate to your default %{announce_to} location.
;; @option c (ignore) Specifies that this is the initial setup of the egg and
;;     enables the ability to setup the repeats.
;; @option r#repeats The number of times to repeat message. Each repeat comes
;;     30 seconds after the previous.
;; @option s Stop the timer.
;; @option t@delay Set the delay for the timer.
;; @option x (ignore) This is run from a /repeat pid. It is used to distinguish
;;     between typing /egg and actually displaying the timer at the right time.
;;
;; @example /egg -t30 -r2 -- Take out the trash!
;;
/def egg = \
  /if (!getopts('t@sr#xac', '')) \
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
    /test egg_time := opt_t%; \
    /test egg_repeats := max(0, opt_r)%; \
    /timer -t%{egg_time} -n1 -p'egg_pid' -k -- /egg -c%; \
    /return%; \
  /endif%; \
  /if (opt_s) \
    /if (is_pid('egg_pid')) \
      /say -d'status' -- Egg timer stopped%; \
      /kill egg_pid%; \
    /endif%; \
    /return%; \
  /endif%; \
  /if (strlen(egg_message) & egg_time) \
    /if (opt_a) \
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

;;;;
;;
;; Send an email.
;;
;; @param body The body of the email.
;;
;; @option r:recipient The e-mail recipient to use instead of %{email}.
;; @option s:subject* The subject of the email.
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

;;;;
;;
;; The default e-mail address to use when using the "/mail" command. This is
;; useful when sending yourself notifications. Look at the "mail.cfg" in the
;; trigs folder for more settings.
;;
/property -g email

;;
;; VARIOUS COMMANDS
;;

;;;;
;;
;; Finger.
;;
;; @param player Finger this player. Defaults to {{ me }}.
;;
/def finger = !finger %{*-$[me()]}

/def f = /finger %{*}

;;;;
;;
;; Hit the ground (Sceptre of Tremors).
;;
/def hg = !hit ground

;;;;
;;
;; Pull vine.
;;
/def pv = !pull vine

;;;;
;;
;; Train a bunch of skills at once. This is useful for defining train macros.
;;
;; @param skill0..skill1 Train the following skills. Use underscore instead of
;;     spaces in skill names.
;;
;; @example /mapcar /train berserk ignore_pain battlecry
;;
/def train = \
  /let _skill=$[replace('_', ' ', {*})]%; \
  !echo Training: %{_skill}%; \
  !train %{_skill}

;;;;
;;
;; Study a bunch of spells at once. This is useful for defining train macros.
;;
;; @param spell0..spell1 Study the following spells. Use underscore instead of
;;     spaces in spell names.
;;
;; @example /mapcar /study iron_will psychic_crush
;;
/def study = \
  /let _spell=$[replace('_', ' ', {*})]%; \
  !echo Studying: %{_spell}%; \
  !study %{_spell}

;;
;; DRINKING SHINES / POTIONS
;;

;;;;
;;
;; Quaff the potion in your inventory or bag.
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

;;;;
;;
;; Sip the potion in your inventory or bag.
;;
/def spot = \
  /if (bag) \
    !get potion from bag of holding%; \
  /endif%; \
  !sip potion%; \
  /if (bag) \
    !put all potion,all empty potion in bag of holding%; \
  /endif%; \
  !keep all potion

;;;;
;;
;; From Central Square, get money and buy moonshines.
;;
;; @param count The number of moonshines to buy.
;;
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

;;;;
;;
;; Deposit all money into booth or bank. If you are a %{trader} and
;; %{booth_dirs} and %{booth_dirs_back} are set then it'll attempt to deposit
;; your money into a booth.
;;
/def deposit_all = \
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

/def da = /deposit_all %{*}

;;;;
;;
;; Withdraw money from booth or bank. If you are a %{trader} and %{booth_dirs}
;; and %{booth_dirs_back} are set then it'll attempt to withdraw your money
;; from a booth.
;;
;; @param amount The amount of gold you wish to withdraw.
;;
/def withdraw = \
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

/def wd = /withdraw %{*}

;;;;
;;
;; Sell all items in your inventory and bag. This command must be executed from
;; Central Square.
;;
/def sell_inventory = \
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
  !3 e%; \
  !s%; \
  /if (bag & stuff_bag) \
    !get copper,bronze,silver,gold,platinum,electrum from bag of holding%; \
  /endif%; \
  /foreach copper bronze silver gold platinum electrum = !sell %%{1}%; \
  !n%; \
  !3 w%; \
  /if (bag & p_cash > 0) \
    !put %{p_cash} gold in bag of holding%; \
  /endif

/def si = /sell_inventory %{*}

;;;;
;;
;; Sell all corpses in your inventory. This command must be executed from
;; Central Square.
;;
;; @param corpses The number of corpses to sell. Default is 20.
;;
/def sell_corpses = \
  !get all corpse%; \
  !5 n%; \
  !4 w%; \
  !n%; \
  !loot%; \
  !%{1-20} sell corpse%; \
  !out%; \
  !4 e%; \
  !5 s

/def si_corpse = /sell_corpses %{*}

;;;;
;;
;; Like {{ si }} except this command is run from Ravenkall Square.
;;
/def sell_inventory_rk = \
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

/def si_rk = /sell_inventory_rk %{*}

;;;;
;;
;; The direction (from your main chests) to move when chesting/unchesting. This
;; is used to dump all non-kept items from your inventory so that you do not
;; accidentally chest/equip the wrong items. This setting depends on {{
;; chest_dir_back }} to be set.
;;
/property -g chest_dir

;;;;
;;
;; The direction (to your main chests) to move when chesting/unchesting. This
;; should be the opposite path as {{ chest_dir }}.
;;
/property -g chest_dir_back

/set chest_start=1
/set chest_end=2

;;;;
;;
;; Unlocks chests in range. The %{chest_name}, %{chest_start} and %{chest_end}
;; so other chest commands can be executed without specifying this again.
;;
;; @param name The name of the chests to open. If no name is specified then the
;;     generic 'chest' will be used.
;; @param start The number at which to start opening chests.
;; @param end The number to which to end opening chests.
;;
;; @example /uc figsam 1 3
;;
/def unlock_chest = \
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

/def uc = /unlock_chest %{*}

;;;;
;;
;; Opens chests in range. The %{chest_name}, %{chest_start} and %{chest_end}
;; so other chest commands can be executed without specifying this again.
;;
;; @param name The name of the chests to open. If no name is specified then the
;;     generic 'chest' will be used.
;; @param start The number at which to start opening chests.
;; @param end The number to which to end opening chests.
;;
;; @example /oc figsam 1 3
;;
/def open_chest = \
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

/def oc = /open_chest %{*}

;;;;
;;
;; Sets keys of chests to a random number. The %{chest_name}, %{chest_start}
;; and %{chest_end} so other chest commands can be executed without specifying
;; this again.
;;
;; @param name The name of the chests to open. If no name is specified then the
;;     generic 'chest' will be used.
;; @param start The number at which to start opening chests.
;; @param end The number to which to end opening chests.
;;
;; @example /sk figsam 1 3
;;
/def setkey_chest = \
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

/def sk = /setkey_chest %{*}

;;;;
;;
;; Look at chests in range. The %{chest_name}, %{chest_start} and %{chest_end}
;; so other chest commands can be executed without specifying this again.
;;
;; @param name The name of the chests to open. If no name is specified then the
;;     generic 'chest' will be used.
;; @param start The number at which to start opening chests.
;; @param end The number to which to end opening chests.
;;
;; @example /lc figsam 1 3
;;
/def look_chest = \
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

/def lc = /look_chest %{*}

;;;;
;;
;; Closes chests in range. The %{chest_name}, %{chest_start} and %{chest_end}
;; so other chest commands can be executed without specifying this again.
;;
;; @param name The name of the chests to open. If no name is specified then the
;;     generic 'chest' will be used.
;; @param start The number at which to start opening chests.
;; @param end The number to which to end opening chests.
;;
;; @example /cc figsam 1 3
;;
/def close_chest = \
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

/def cc = /close_chest %{*}

;;;;
;;
;; Puts equipment away in chests in range. It uses %{chest_dir} and
;; %{chest_dir_back} to organize equipment before chesting; meaning that it
;; will attempt to drop all unkept items so that you do not accidentally chest
;; items that are junk. This command assumes that the chests are already
;; unlocked with {{ uc }}. This automatically closes chests after it is done.
;; The %{chest_name}, %{chest_start} and %{chest_end} so other chest commands
;; can be executed without specifying this again.
;;
;; @param name The name of the chests to open. If no name is specified then the
;;     generic 'chest' will be used.
;; @param start The number at which to start opening chests.
;; @param end The number to which to end opening chests.
;;
;; @example /pac figsam 1 3
;;
/def chest_equipment = \
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
  /if (strlen(pac_extra_pre)) \
    /eval %{pac_extra_pre}%; \
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
  /if (strlen(pac_extra_post)) \
    /eval %{pac_extra_post}%; \
  /endif%; \
  !slots%; !i%; !eq%; !ll

/def pac = /chest_equipment %{*}

;;;;
;;
;; Extra commands that should be executed with "/pac". These commands are
;; executed before dropping your non-kept inventory. You can stick commands
;; like "bunload all", or other commands that pull items out of containers
;; here.
;;
/property -s -g pac_extra_pre

;;;;
;;
;; Extra commands that should be executed with "/pac". These commands are
;; executed after dropping your non-kept inventory but before opening chests or
;; removing your equipment.
;;
/property -s -g pac_extra

;;;;
;;
;; Extra commands that should be executed with "/pac". These commands are
;; executed after all chesting has been completed.
;;
/property -s -g pac_extra_post

;;;;
;;
;; Gets equipment from chests in range. It uses %{chest_dir} and
;; %{chest_dir_back} to organize equipment before equipping; meaning that it
;; will attempt to drop all unkept items so that you do not accidentally wear
;; items that are junk. This command assumes that the chests are already
;; unlocked with {{ uc }}. This automatically closes chests after it is done.
;; The %{chest_name}, %{chest_start} and %{chest_end} so other chest commands
;; can be executed without specifying this again.
;;
;; @param name The name of the chests to open. If no name is specified then the
;;     generic 'chest' will be used.
;; @param start The number at which to start opening chests.
;; @param end The number to which to end opening chests.
;;
;; @example /gac figsam 1 3
;;
/def unchest_equipment = \
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
  /if (strlen(gac_extra_pre)) \
    /eval %{gac_extra_pre}%; \
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
  /if (strlen(gac_extra_post)) \
    /eval %{gac_extra_post}%; \
  /endif%; \
  !slots%; !i%; !eq%; !ll%; !save

/def gac = /unchest_equipment %{*}

;;;;
;;
;; Extra commands that should be executed with "/gac". These commands are
;; executed before dropping your non-kept inventory.
;;
/property -s -g gac_extra_pre

;;;;
;;
;; Extra commands that should be executed with "/gac". These commands are
;; executed after opening and getting everything from the chests, but before
;; wearing and closing the chests. You can stick commands which wear and then
;; re-chest your "Doomshell", or other commands to temporarily deal with items
;; that you wish to leave in chests.
;;
/property -s -g gac_extra

;;;;
;;
;; Extra commands that should be executed with "/gac". These commands are
;; executed after all of your items have been pulled from the chests. You can
;; stick commands like "bload all", or other commands that load up containers
;; here.
;;
/property -s -g gac_extra_post

/def -Fp5 -mregexp -t'^A large wooden chest( labelled \'.+\')?( \\((open|unlocked)\\))?$' number_chests = \
  /set chest_number=$[chest_number + 1]%; \
  /substitute -p -- @{B}$[pad(chest_number, 2)]@{n}) %{*}%; \
  /def -Fp6 -mregexp -t'' number_chests_reset = \
    /if (!regmatch('^A large wooden chest', {*})) \
      /set chest_number=0%%; \
      /purgedef number_chests_reset%%; \
    /endif

;;;;
;;
;; Unwields the current weapon and attemps to dwield it and add it to keep.
;;
/def dwield = \
  !unwield %{*}%; \
  !dwield %{*}%; \
  !keep %{*},%{*}

;;
;; RANGER BERRIES
;;

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ gives you [A-Z][a-z]* colorful berr(ies|y)\\.$' given_berries = \
  /if (bag) \
    !put all colorful berry in bag of holding%; \
  /endif%; \
  !count colorful berry%; \
  /if (strlen(on_berry)) \
    /eval %{on_berry}%; \
  /endif%; \

;;;;
;;
;; Extra commands that should be executed after finding or being given berries.
;;
/property -s -g on_berry

;;;;
;;
;; Eat berry.
;;
/def eat_berry = \
  /if (bag) \
    !get colorful berry from bag of holding%; \
  /endif%; \
  !eat colorful berry

/def eb = /eat_berry %{*}

;;;;
;;
;; Rub brown berry.
;;
/def brown_berry = \
  /if (bag) \
    !get brown berry from bag of holding%; \
  /endif%; \
  !rub brown berry

/def bberry = /brown_berry %{*}

;;;;
;;
;; Squeeze green berry.
;;
/def green_berry = \
  /if (bag) \
    !get green berry from bag of holding%; \
  /endif%; \
  !squeeze green berry

/def gberry = /green_berry %{*}

;;;;
;;
;; Eat purple berry.
;;
/def purple_berry = \
  /if (bag) \
    !get purple berry from bag of holding%; \
  /endif%; \
  !eat purple berry

/def pberry = /purple_berry %{*}

;;;;
;;
;; Slurp white berry.
;;
/def white_berry = \
  /if (bag) \
    !get white berry from bag of holding%; \
  /endif%; \
  !slurp white berry

/def wberry = /white_berry %{*}

;;;;
;;
;; Throw yellow berry.
;;
;; @param target* The target at whom to throw the berry.
;;
/def yellow_berry = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /if (bag) \
    !get yellow berry from bag of holding%; \
  /endif%; \
  !throw yellow berry at %{*}

/def yberry = /yellow_berry %{*}

;;;;
;;
;; Close the door.
;;
/def close_door = !close door
/def cdo = /close_door %{*}

;;;;
;;
;; Open the east door.
;;
/def open_east_door = !open east door
/def oed = /open_east_door %{*}

;;;;
;;
;; Open the north door.
;;
/def open_north_door = !open north door
/def ond = /open_north_door %{*}

;;;;
;;
;; Open the south door.
;;
/def open_south_door = !open south door
/def osd = /open_south_door %{*}

;;;;
;;
;; Open the west door.
;;
/def open_west_door = !open west door
/def owd = /open_west_door %{*}

;;;;
;;
;; Executes commands which are separate by commas.
;;
;; @param commands* Commands separated by a commas.
;;
/def cmds = /eval -s1 $[replace(',', '%;', replace(', ', '%;', {*}))]

;;;;
;;
;; Execute commands separated by semi-colons.
;;
;; @param commands* Zmud style commands which are separated by a semi-colons.
;;
/def zmud = /eval -s1 $[replace(';', '%;', {*})]
/def z = /zmud %{*}


;;;;
;;
;; Like {{ zmud }} except it uses send() to execute commands.
;;
;; @param commands* Zmud style commands which are separated by a semi-colons.
;;
/def zsend = /eval -s1 /send -- !$[replace(';', '%;/send -- !', {*})]%; \

;;;;
;;
;; Send tells to various players.
;;
;; Usage: /tell RECIPIENTS MESSAGE
;;
/def tell = \
  /let _recipients=$[replace(',', ' ', {1})]%; \
  /let _message=%{-1}%; \
  /foreach %{_recipients} = \
    !tell %%{1} %%{_message}

;;;;
;;
;; Converts the text using the mud extension protocol, or MXP.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
;; @option b Make the message bold.
;; @option c:color The color of the message.
;; @option f:font The font of the message.
;; @option h Make the message highlighted.
;; @option i Make the message italic.
;; @option m Modify this message.
;; @option n#size The size of the message.
;; @option s Make the message strikeout.
;; @option u Make the message unerlined.
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

;;;;
;;
;; From Central Square, buy bread.
;;
;; @param count The number of loafs to buy.
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

;;;;
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

/def ea = /eat %{*}

;;;;
;;
;; Enter battle, party follow, and attack using {{ kx }}.
;;
;; @param direction The direction to go. By default it reads %{in}.
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
  /say -d'party' -m -x -t -b -c'green' -- WENT { $[replace(';', ', ', in)] }%; \
  /kx

;;;;
;;
;; Like {{ in }} except do not follow or attack.
;;
;; @param direction The direction to go. By default it reads %{in}.
;;
/def inx = \
  /set in=%{*-%{in}}%; \
  /if (!strlen(in)) \
    /return%; \
  /endif%; \
  /eval -s1 !$[replace(';', '%;!', in)]

;;;;
;;
;; Set the value of %{in}. Used by {{ in }} and {{ inx }}.
;;
/def set_in = /set in=%{*-%{in}}
/def sin = /set_in %{*}

;;;;
;;
;; Leave out of battle and party follow.
;;
;; @param direction The direction to go. By default it reads %{out}.
;;
/def out = \
  /set out=%{*-%{out}}%; \
  /if (!strlen(out)) \
    /return%; \
  /endif%; \
  /eval -s1 !$[replace(';', '%;!', out)]%; \
  /if (party_members > 1 & !is_me(tank)) \
    !pf%; \
  /endif

;;;;
;;
;; Sets the value of %{out} and announces the direction. Used by {{ out }}.
;;
/def set_out = \
  /set out=%{*-%{out}}%; \
  /area_wimpy_cmds %{out}

/def sout = /set_out %{*}

;;;;
;;
;; Drops food at the baker.
;;
/def drop_food = \
  !3 n%;!4 w%;!n%; \
  !drop food%; \
  /if (bag) \
    !drop food from bag of holding%; \
  /endif%; \
  !s%;!4 e%;!3 s

/def df = /drop_food %{*}

;;;;
;;
;; Returns whether or not you are currently away.
;;
;; @return A non-zero integer if away, not connected or idle. Zero otherwise.
;;
/def is_away = /result away | !is_connected() | is_idle()

;;;;
;;
;; Returns whether or not you are currently idle.
;;
;; @return A non-zero integer if %{idle_time} is set and idle() is
;;     greater/equal. Zero otherwise.
;;
/def is_idle = /result idle_time > 0 & idle() >= idle_time

;;;;
;;
;; Encode the url with %hex strings. Opposite of {{ urldecode }}.
;;
;; @param string The string to encode.
;; @return The string with special characters replaced by their %hex code.
;;
/def urlencode = /result python('util.urlencode("$(/escape ' $(/escape " %{*}))")')

;;;;
;;
;; Deccode the url with %hex strings. Opposite of {{ urlencode }}.
;;
;; @param string The string to decode.
;; @return The string with %hex code replaced by actual characters.
;;
/def urldecode = /result python('util.urldecode("$(/escape ' $(/escape " %{*}))")')

;;;;
;;
;; Joins words by separator.
;;
;; @param words The words, separated by spaces, to be joined.
;; @param separator The separator to use when joining words.
;; @return The list of words joined by the specified separator.
;;
/def join = /result python('util.join("$(/escape " %{1})", "%{2}")')

;;;;
;;
;; Returns whether the string should be evaluated as true. '', 0, off, false are
;; assumed to be 0.
;;
;; @param string The string to be checked.
;; @return Zero if string is empty, 0, off or false. A non-zero otherwise.
;;
/def is_true = \
  /if ({#} & strlen({*}) & strcmp({*}, '0') & tolower({*}) !~ 'off' & tolower({*}) !~ 'false') \
    /return 1%; \
  /else \
    /return 0%; \
  /endif

;;;;
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

;;;;
;;
;; Show number only if there's a delta.
;;
;; @param delta* The delta to be compared.
;; @param left Prefix to the delta.
;; @param right Suffix to the delta.
;;
;; @return If the delta is zero then nothing is returned. Otherwise the left,
;;     delta and right are catented. The sign is always visible so positive
;;     numbers are prefixed with a plus, negative with a minus.
;;
/def delta_only = \
  /if ({#} & {1}) \
    /if ({1} > 0) \
      /result strcat({2}, '+', {1}, {3})%; \
    /else \
      /result strcat({2}, {1}, {3})%; \
    /endif%; \
  /endif

;;;;
;;
;; Converts the seconds a pretty format.
;;
;; @param seconds* The number of seconds to convert.
;; @param long Print the time in a long format.
;;
;; @return The seconds in days, hours, minutes and seconds format.
;;
/def to_dhms = \
  /if ({2}) \
    /let _short=False%; \
  /else \
    /let _short=True%; \
  /endif%; \
  /let _seconds=$[{1-0} * 1]%; \
  /result python('util.getPrettyTime(%{_seconds}, short=%{_short})')

;;;;
;;
;; Return number in human readable format by using K, M and G.
;;
;; @param number* The number to be converted.
;; @param digits The number of digits to show. Default is 1.
;;
;; @return The number converted into kilo, mega and giga.
;;
/def to_kmg = /result python('util.getHumanReadableFormat(%{1-0}, digits=%{2-1})')

;;;;
;;
;; Returns number as an exp string, similar to the experience plaque.
;;
;; @param number* The number to be converted.
;;
;; @return The number converted to the expstr format.
;;
/def to_expstr = /result python('util.getExpStringFormat(%{1-0})')

;;;;
;;
;; Converts the expstr to an integer.
;;
;; @param expstr* The expstring to be converted.
;;
;; @return The expstr converted into an integer.
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

;;;;
;;
;; Convert the given integer to a nth format.
;;
;; @param number* The number to be converted.
;;
;; @return The number appended with 'st', 'rd', 'th' accordingly.
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

;;;;
;;
;; Rounds the NUMBER to N decimal places.
;;
;; @param number* The number to be rounded.
;; @param digits The number of digits to round. Default is 2.
;;
;; @return The number after being rounded up/down.
;;
/def round = /result python('util.round(%{1-0}, %{2-2})')

;;;;
;;
;; Formats the number in the current locale.
;;
;; @param number* The number to be formatted.
;;
/def format_number = /result python('util.formatNumber(%{1-0})')

;;;;
;;
;; Formats the number as written text.
;;
;; @param number The number to be converted.
;;
;; @return The number as text.
;;
/def number_as_text = /result python('util.numberAsText(%{1-0})')

;;;;
;;
;; Returns the minimum number in the group.
;;
;; @param number0..numberN The numbers to compare.
;;
;; @return The lowest of the numbers.
;;
/def min = \
  /let _min=%{1-0}%;\
  /while (shift(), {#}) \
    /if ({1} < _min) \
      /let _min=%{1}%;\
    /endif%;\
  /done%;\
  /result _min

;;;;
;;
;; Returns the maximum number in the group.
;;
;; @param number0..numberN The numbers to compare.
;;
;; @return The highest of the numbers.
;;
/def max = \
  /let _max=%{1-0}%;\
  /while (shift(), {#}) \
    /if ({1} > _max) \
      /let _max=%{1}%;\
    /endif%;\
  /done%;\
  /result _max

;;;;
;;
;; Prints out a meter using the number. It is useful for having a visual
;; representation of the number.
;;
;; @param number* The number to be printed.
;; @param max The maximum that the number should be. Default is 100.
;; @param size The size of the meter. Default is max.
;; @param pad The character to pad with. Default is #.
;;
;; @return The number represented as a meter.
;;
/def meter = \
  /let _num=%{1-0}%; \
  /let _max=%{2-100}%; \
  /let _size=%{3-%{2}}%; \
  /let _pad=%{4-#}%; \
  /result pad(strrep(_pad, trunc(min(_size, _num * _size / _max))), -(_size))

;;;;
;;
;; Returns what the multiplier corresponding to the char prefix multiplier.
;;
;; @param char The character to get the multiplier for.
;;
;; @return An integer representing the char.
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

;;;;
;;
;; Capitalize all words in the given string.
;;
;; @param words A list of words separated by space.
;;
;; @return The words after having each of their first characters capitalized.
;;
/def capitalize = \
  /result python('util.capitalize("$(/escape ' $(/escape " %{*}))")')

;;;;
;;
;; Sort all words in the given string.
;;
;; @param words A list of words separated by space.
;;
;; @return The words in sorted order.
;;
/def sorted = \
  /result python('util.sort("$(/escape ' $(/escape " %{*}))")')

;;;;
;;
;; String representation of the given expression.
;;
;; @param expression An expression to be evaluated.
;;
;; @return String true/false depending on expression.
;;
/def bool = /result {1} ? 'true' : 'false'

;;;;
;;
;; Convert the integer to a hex string.
;;
;; @param integer The intger to be represented as hex.
;; @param digits The number of digits to represent.
;;
;; @return The hex string representation of integer.
;;
/def hex = \
  /result python('util.hex(%{1}, digits=%{2-0})')

;;;;
;;
;; Executes the command and prepends a ! if it's not an internal command.
;;
;; @param command The command to be executed.
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

;;;;
;;
;; Runs the command if the previous execution didn't occur within the specified
;; time. Used to prevent the running of commands too quickly together.
;;
;; @param command* The command to be executed.
;;
;; @option t@time* The minimum time between executing this command.
;; @option n:name* The name of this execution. Used to compare previous runs.
;;
;; @example /runif -t2 -n'party_status' -- !party status
;;
/def runif = \
  /if (!getopts('t@n:', '') | !{#} | !regmatch('^[a-z0-9_]+$$', opt_n)) \
    /return%; \
  /endif%; \
  /let _var=runif_%{opt_n}%; \
  /let _value=$[expr(_var)]%; \
  /if (time() - _value > opt_t) \
    /execute %{*}%; \
    /set %{_var}=$[time()]%; \
  /endif

;;;;
;;
;; Returns whether or not the key is contained within the list.
;;
;; @param key* The key to be checked.
;; @param list* The list of values that the key is checked against.
;;
;; @return A non-zero integer if the key is contained within the list. Zero
;;     otherwise.
;;
/def isin = \
  /result strstr({1}, ' ') == -1 & strlen({1}) & strlen({-1}) & {-1} =/ strcat('*{', {1}, '}*')

;;;;
;;
;; Kills a pid without the annoying error messages.
;;
;; @param process0..processN* The processes to be killed. Can either by the
;;     process id or a variable. If it's a variable then the value of said
;;     variable is expanded and killed.
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

;;;;
;;
;; Returns whether or not the pid exists.
;;
;; @param process* The process id or variable to be checked. If it's a variable
;;     then the value of said variable is expanded and checked.
;;
;; @return A non-zero integer if the process exists. Zero otherwise.
;;
/def is_pid = \
  /let _pid=%{1-0}%; \
  /if (!_pid) \
    /test _pid := %{_pid}%; \
  /endif%; \
  /result isin(_pid, $$(/ps -s))

;;;;
;;
;; Use the repeat command to start a timer. This command differs in that it
;; allows you to store the pid as a variable. The end result is the command
;; being executed at a later time.
;;
;; @param command* The command to be executed.
;;
;; @option k Kill previous pid with the same name.
;; @option n#repeats The number of times to repeat. Default is 1.
;; @option p:name The name of the pid file.
;; @option t@delay The delay between repeats. Default is 0.
;;
/def timer = \
  /if (!getopts('t@n#p:k', '') | !{#}) \
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

;;;;
;;
;; Execute the %{back} macro.
;;
/def back = \
  /if (strlen(back)) \
    /%{back}%; \
  /endif

;;;;
;;
;; Announce the current area in a standard format.
;;
;; @param area* The name of the current area.
;;
/def area = \
  /if (!{#}) \
    /return%; \
  /endif%; \
  /say -d'party' -x -b -c'yellow' -- At %{*}

;;;;
;;
;; Announce a Zmud style trig for {{ area_cmds }}.
;;
/def area_cmds_zmud = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _trig=#REGEX "$[me()].type" {^$[toupper(me(), 1)] .party.: TYPE \\{ (.+) \\} ?$$} {#EXE {~%%replace(~"~%%1~", ~", ~", ~";~")}}%; \
  /execute %{_cmd} %{_trig}

;;;;
;;
;; Announce a TinyFugue style trig for {{ area_cmds }}.
;;
/def area_cmds_tf = \
  /if ({#}) \
    /let _cmd=%{*}%; \
  /else \
    /let _cmd=/say -d'status' --%; \
  /endif%; \
  /let _trig=/def -Fp10 -mregexp -t'^$[toupper(me(), 1)] .party.: TYPE \\\\{ (.+) \\\\} ?$$' $[me()]_type = /eval -s1 !$$[replace(', ', '%%;!', {P1})]%; \
  /execute %{_cmd} %{_trig}

;;;;
;;
;; Announce commands that party members must type to get to your current
;; location. Nothing is displayed unless you are the tank or commander of the
;; party.
;;
;; @param commands* Commands, separated by semi-colons, that the party members
;;     need to type.
;;
/def area_cmds = \
  /if ({#} & (is_me(tank) | is_me(commander))) \
    /say -d'party' -b -x -c'red' -- TYPE { $[replace(';', ', ', {*})] }%; \
  /endif

;;;;
;;
;; Announce special flags or attributes about the current location.
;;
;; @param flags* Flags or attributes about the current location.
;;
/def area_flags = \
  /if (!{#}) \
    /return%; \
  /endif

;;;;
;;
;; Announce warnings about the current location or target. Nothing is displayed
;; unless you are the tank or commander of the party.
;;
;; @param warnings* Warnings about the current location or target.
;;
/def area_warning = \
  /if ({#} & (is_me(tank) | is_me(commander))) \
    /say -d'party' -b -x -c'yellow' -- -> %{*}%; \
  /endif

;;;;
;;
;; Announce the wimpy directions from the current location to somewhere safe.
;;
;; @param commands* Commands, separated by semi-colons, that the party members
;;     need to type.
;;
/def area_wimpy_cmds = \
  /if ({#} & (is_me(tank) | is_me(commander))) \
    /say -d'party' -b -x -c'red' -- WIMPY { $[replace(';', ', ', {*})] }%; \
  /endif

;;;;
;;
;; Old style /dopath from map.tf that has been modified to work better with
;; ZombieMUD by grouping commands in multiples of 20.
;;
;; @param path* A sequence of moments and counts to be executed.
;;
;; @example /dopath 10 n e d 2 w
;;
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

;;;;
;;
;; This does many actions with the supplied arguments. This lets you, for
;; example run to a monster, set the target, tell party members what they need
;; to type, let them know about various warnings, gets certain items from your
;; bag of holding, and optionally sets the macro that would take you back and
;; the sets the number of rooms one would skip if they skipped the area.
;;
;; @option A:alignment Alignment of the target.
;; @option E:expression Expression to check before executing.
;; @option F:flags Flags.
;; @option W:warnings Warning messages.
;; @option a:area Name of the area, room.
;; @option b:macro Name of macro to get reverse.
;; @option c:commands Commands that other members need to type.
;; @option d:dirs zMUD style dirs (; separated).
;; @option e:commands Extra commands that are evaluated after dirs are executed.
;; @option f Force sending of text to mud even if idle/away.
;; @option i:items Items needed from bag of holding.
;; @option n Name of the current path.
;; @option r#number The current room number.
;; @option s#skip Number of rooms to skip if you wish to not continue.
;; @option t:target Target to set.
;; @option w:dirs zMUD style wimpy dirs (; separated).
;; @option x:dirs zMUD style opposite of wimpy dirs (; separated).
;;
/def run_path = \
  /if (!getopts('d:b:t:a:c:w:x:i:s#r#W:n:E:F:A:fe:', '')) \
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
  /if (strlen(opt_e)) \
    /eval %{opt_e}%; \
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
    /area_wimpy_cmds %{out}%; \
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

;;;;
;;
;; Extra commands that should be executed before leaving room with "/run_path".
;; This is useful for picking up items, leaving breadcrumbs or giving yourself
;; party movement.
;;
/property -s -g on_leave_room

;;;;
;;
;; Execute by {{ run_path }} before leaving a location. It executes
;; %{on_leave_room}.
;;
;; @hook on_leave_room
;;
/def leave_room = \
  /if (strlen(on_leave_room)) \
    /eval %{on_leave_room}%; \
  /endif%; \
  @on_leave_room

;;;;
;;
;; Extra commands that should be executed after entering a room with
;; "/run_path". This is useful for dropping corpses or setting somebody else as
;; the party leader.
;;
/property -s -g on_enter_room

;;;;
;;
;; Executed by {{ run_path }} just after entering a location. It executes
;; %{on_enter_room}.
;;
;; @hook on_enter_room
;;
/def enter_room = \
  /if (strlen(on_enter_room)) \
    /eval %{on_enter_room}%; \
  /endif%; \
  @on_enter_room

;;;;
;;
;; Runs from Central Square to the HUGE catapult and shoots the directions
;; given or 'home'.
;;
;; @param x* The X coordinate.
;; @param y* The Y coordinate.
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

;;;;
;;
;; Runs from Central Square to the HUGE catapult and shoots home.
;;
/def cshome = /shoot home

/set runner_file=example

;;;;
;;
;; Announce the target in the current location. Nothing is displayed unless you
;; are the tank or commander of the party, or if %{report_target} is false.
;;
/def area_target = \
  /if ({#} & report_target & (is_me(tank) | is_me(commander))) \
    /say -d'party' -b -x -m -c'green' -- TARGET { %{*} }%; \
  /endif

;;;;
;;
;; Load a run into memory.
;;
;; @param runner_file The file to be loaded. If ommited then %{runner_file} is
;;     used.
;;
/def load_run = \
  /set runner_file=%{*-%{runner_file}}%; \
  /python runs.inst.loadMovementsFromConfigFile('$(/escape ' $[runs_dir(runner_file)])')%; \
  @update_status
/def lr = /load_run %{*}

;;;;
;;
;; Reset the run.
;;
/def reset_run = \
  /python runs.inst.reset()

;;;;
;;
;; Unload the run completely.
;;
/def unload_run = \
  /python runs.inst.unload()

/def close_run = /unload_run %{*}

;;;;
;;
;; Rewind the run.
;;
;; @param movements* The number of movements to rewind. Default is 1.
;;
/def rewind_run = \
  /for i 1 %{1-1} /python runs.inst.rewind()

/def lpr = /rewind_run %{*}

;;;;
;;
;; Forward the run.
;;
;; @param movements* The number of movements to forward. Default is 1.
;;
/def forward_run = \
  /for i 1 %{1-1} /python runs.inst.forward()

/def lnr = /forward_run %{*}

;;;;
;;
;; Display the next movement.
;;
/def display_next_movement = \
  /python runs.inst.display()

/def dnr = /display_next_movement %{*}
/def display_next_room = /display_next_movement %{*}

;;;;
;;
;; Rewind the run and execute movement again.
;;
/def prev_movement = \
  /python runs.inst.rewind()%; \
  /next_movement

/def pr = /prev_movement %{*}
/def prev_room = /prev_movement %{*}

;;;;
;;
;; Execute current movement and load the next.
;;
/def next_movement = \
  /python runs.inst.execute()%; \
  /python runs.inst.forward()

/def nr = /next_movement %{*}
/def next_room = /next_movement %{*}

;;;;
;;
;; Skip the current area.
;;
/def skip = \
  /python runs.inst.skip()


;;
;; EFFECTS
;;

/test effect_extra_l := '{'
/test effect_extra_r := '}'

;;;;
;;
;; Announce the status of an effect. If %{report_effects} is enabled then it
;; will be displayed to the default %{announce_to} location. Otherwise it'll
;; report to status.
;;
;; @option n#repeats Number of times to repeat the announcement.
;; @option o:other Other information related to the effect such as the uptime.
;; @option p:name* Name of the effect you wish to display.
;; @option s#status Prints the message with the color given.
;;
/def announce_effect = \
  /if (!getopts('p:s#o:n#', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_p)) \
    /error -m'%{0}' -a'p' -- must be the name of the effects%; \
    /result 0%; \
  /endif%; \
  /if (report_effects) \
    /if (strlen(opt_o)) \
      /say -c'$[opt_s ? "green" : "red"]' -f'$(/escape ' $[opt_s ? "ON" : "OFF"] %{effect_extra_l}%{opt_o}%{effect_extra_r})' -n%{opt_n-1} -- %{opt_p}%; \
    /else \
      /say -c'$[opt_s ? "green" : "red"]' -f'$[opt_s ? "ON" : "OFF"]' -n%{opt_n-1} -- %{opt_p}%; \
    /endif%; \
  /else \
    /if (strlen(opt_o)) \
      /say -d'status' -f'$(/escape ' $[opt_s ? "ON" : "OFF"] %{effect_extra_l}%{opt_o}%{effect_extra_r})' -n%{opt_n-1} -- %{opt_p}%; \
    /else \
      /say -d'status' -f'$[opt_s ? "ON" : "OFF"]' -n%{opt_n-1} -- %{opt_p}%; \
    /endif%; \
  /endif

/def -Fp4 -msimple -h'SEND @on_enter_game' on_enter_game_effects = \
  /python effects.inst.reset()

;;;;
;;
;; Defines an effect group which you can use later with effects.
;;
;; @option g:key* The key which matches the group.
;; @option n:name* The name of the group.
;;
/def def_effect_group = \
  /if (!getopts('g:n:', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_g)) \
    /error -m'%{0}' -a'g' -- must be the key to the group%; \
    /result%; \
  /endif%; \
  /if (!strlen(opt_n)) \
    /error -m'%{0}' -a'n' -- must be the name of the effect group%; \
    /result%; \
  /endif%; \
  /set effect_%{opt_g}=%{opt_n}%; \
  /set effect_groups=$(/unique %{effect_groups} %{opt_g})%; \
  /python effects.inst.addGroup(effects.EffectGroup('$(/escape ' %{opt_g})', '$(/escape ' %{opt_n})'))

;;;;
;;
;; Defines an effect.
;;
;; @option c#layers The number of times that this can be stacked.
;; @option g:group The group that this effect belongs to.
;; @option n:name* The name of this effect.
;; @option p:key* The key which matches this effect.
;; @option s:short The short name of this effect.
;;
/def def_effect = \
  /if (!getopts('p:n:c#g:s:t:', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_p)) \
    /error -m'%{0}' -a'p' -- must be the key to the effect%; \
    /result%; \
  /endif%; \
  /if (!strlen(opt_n)) \
    /error -m'%{0}' -a'n' -- must be the name of the effect%; \
    /result%; \
  /endif%; \
  /python effects.inst.add(effects.Effect('$(/escape ' %{opt_p})', '$(/escape ' %{opt_n})', short_name='$(/escape ' %{opt_s})', layers=$[max(1, opt_c)], groups='$(/escape ' %{opt_g})'))

;;;;
;;
;; Turns on the effect specified.
;;
;; @param key The key of the effect to turn on.
;;
;; @hook update_status
;;
/def effect_on = \
  /python effects.inst.on('$(/escape ' %{1})')%; \
  @update_status


;;;;
;;
;; Turns off the effect specified.
;;
;; @param key The key of the effect to turn off.
;;
;; @hook update_status
;;
/def effect_off = \
  /python effects.inst.off('$(/escape ' %{1})')%; \
  @update_status

;;
;; EFFECT STATUS
;;

;;;;
;;
;; Effect count.
;;
;; @param key The key of the effect to check.
;;
;; @return The number of layers currently on.
;;
/def effect_count = /result python('effects.inst.count("$(/escape " %{1})")')

;;;;
;;
;; Effect duration.
;;
;; @param key The key of the effect to check.
;;
;; @return The number of seconds that this effect has been on.
;;
/def effect_duration = /result python('effects.inst.duration("$(/escape " %{1})")')

;;;;
;;
;; Effect layers.
;;
;; @param key The key of the effect to check.
;;
;; @return The maximum number of layers for this effect.
;;
/def effect_layers = /result python('effects.inst.layers("$(/escape " %{1})")')

;;;;
;;
;; Effect name.
;;
;; @param key The key of the effect to check.
;;
;; @return The name of this effect.
;;
/def effect_name = /result python('effects.inst.name("$(/escape " %{1})")')

;;;;
;;
;; Effect short name.
;;
;; @param key The key of the effect to check.
;;
;; @return The short name of this effect.
;;
/def effect_short_name = /result python('effects.inst.short_name("$(/escape " %{1})")')

;;;;
;;
;; The amount of time that party members must wait between requesting your
;; currently active effects.
;;
/property -i -v'10' prots_cooldown

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) whispers to you \'prots\'' whisper_prots = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /runif -t%{prots_cooldown} -n'check_effects_party' -- /check_effects_party%; \
  /endif

/def -Fp5 -mregexp -t'^[A-Z][a-z]+ attempts to seduce you\\.$' seduce_prots = \
  /if (is_me(tank) & party_members > 1) \
    /runif -t%{prots_cooldown} -n'check_effects_online_party' -- /check_effects_online_party%; \
  /endif

/def -Fp10 -mregexp -t'^([A-Z][a-z]+) whispers to you \'proo+ts\'' whisper_proots = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /runif -t%{prots_cooldown} -n'check_effects_missing_party' -- /check_effects_missing_party%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) feels the urge to mate with you\\.$' mate_prots = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /runif -t%{prots_cooldown} -n'check_effects_missing_party' -- /check_effects_missing_party%; \
  /endif

/def -Fp5 -mregexp -t'^([A-Z][a-z]+) nibbles on your ear\\.$' nibble_prots = \
  /if (is_me(tank) & isin({P1}, party_members())) \
    /runif -t%{prots_cooldown} -n'check_effects_party' -- /check_effects_party%; \
  /endif

;;;;
;;
;; Check effects that are online.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
/def check_effects_online = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python effects.inst.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(status)15s |', online=True, offline=False)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python effects.inst.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(status)15s@{n} |', online=True, offline=False)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def cpo = /check_effects_online %{*}
/def ceo = /check_effects_online %{*}

;;;;
;;
;; Check effects that are online and announce it to party.
;;
/def check_effects_online_party = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python effects.inst.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(status)15s', online=True, offline=False)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def cpo_p = /check_effects_online_party %{*}
/def ceo_p = /check_effects_online_party %{*}

;;;;
;;
;; List of effects that you care to see when typing "/cpl" or "/cpm". The
;; format of each effect should be lower case, all spaces should be converted
;; to underscores and all other characters should be removed. For example,
;; something like "iron will" becomes "iron_will" and "winter's rebuke" becomes
;; "winters_rebuke".
;;
/property -s -g effects_list

;;;;
;;
;; Check effects that are missing from %{effects_list}.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
/def check_effects_missing = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python effects.inst.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(status)15s |', keys='$(/escape ' %{effects_list})', online=False, offline=True)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python effects.inst.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(status)15s@{n} |', keys='$(/escape ' %{effects_list})', online=False, offline=True)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def cpm = /check_effects_missing %{*}
/def cem = /check_effects_missing %{*}

;;;;
;;
;; Check effects that are missing from %{effects_list} and announce it to
;; party.
;;
/def check_effects_missing_party = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python effects.inst.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(status)15s', keys='$(/escape ' %{effects_list})', online=False, offline=True)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def cpm_p = /check_effects_missing_party %{*}
/def cem_p = /check_effects_missing_party %{*}

;;;;
;;
;; Check effects from %{effects_list} and display their status.
;;
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
/def check_effects = \
  /if ({#}) \
    /let _cmd=%{*}%; \
    /execute %{_cmd} .----------------------------------------------------------------.%; \
    /python effects.inst.forall('$(/escape ' %{_cmd}) | %%(name)-35s %%(count)10s %%(status)15s |', keys='$(/escape ' %{effects_list})', online=True, offline=True)%; \
    /execute %{_cmd} `----------------------------------------------------------------'%; \
    /return%; \
  /endif%; \
  /let _cmd=/echo -w -p -aCgreen --%; \
  /execute %{_cmd} .----------------------------------------------------------------.%; \
  /python effects.inst.forall('$(/escape ' %{_cmd}) | @{C%%(color)s}%%(name)-35s %%(count)10s %%(status)15s@{n} |', keys='$(/escape ' %{effects_list})', online=True, offline=True)%; \
  /execute %{_cmd} `----------------------------------------------------------------'

/def cpl = /check_effects %{*}
/def ce = /check_effects %{*}

;;;;
;;
;; Check effects from %{effects_list} and display their status to party.
;;
/def check_effects_party = \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------%; \
  /python effects.inst.forall('/say -d"party" -x -c"%%(color)s" -- %%(name)-35s %%(count)10s %%(status)15s', keys='$(/escape ' %{effects_list})', online=True, offline=True)%; \
  /say -d'party' -x -c'blue' -- --------------------------------------------------------------

/def cpl_p = /check_effects_party %{*}
/def ce_p = /check_effects_party %{*}

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

;;;;
;;
;; The time between automatically saving your settings.
;;
/property -t -v'00:15:00' save_interval

/def -Fp5 -msimple -h'SEND @save' save_basic = /mapcar /listvar \
  announce announce_echo_* announce_emote_* announce_other_* announce_party_* \
  announce_say_* announce_status_* announce_think_* announce_to attack_command \
  attack_method attack_skill attack_spell beep_auto_target casting_speed chest_name chest_start chest_end \
  chest_dir chest_dir_back class_caster class_fighter effects_list echo_attr email \
  enemies error_attr gac_extra* give_noeq_target heal_command heal_method heal_skill \
  heal_spell healing idle_time ignore_movement ld_at_boot logging my_party_color \
  my_party_name my_stat_str my_stat_dex my_stat_con my_stat_int my_stat_wis \
  my_stat_cha my_stat_siz on_alive on_berry on_enemy_killed on_kill on_kill_corpse \
  on_kill_loose on_kill_loot on_loot on_loot_give_to on_start_attack on_start_heal \
  on_unstunned p_* pac_extra* prefix effect_extra_* prots_cooldown quiet_mode \
  report_sksp report_fatigue report_hps report_kills report_effects report_scans \
  report_sps report_target report_ticks report_warnings runner_file scan_target \
  s_hp s_maxhp s_sp s_maxsp spell_speed spell_speed_* start_attack_command \
  start_attack_method start_attack_skill start_attack_spell stat_cha_cost \
  stat_cha_count stat_con_cost stat_con_count stat_dex_cost stat_dex_count stat_int_cost \
  stat_int_count stat_str_cost stat_str_count stat_wis_cost stat_wis_count \
  status_attr status_pad tank target target_emotes target_name tick_show \
  tick_sps tick_time ticking tinning title on_enter_game on_enter_room \
  on_leave_game on_leave_room on_return_game on_new_round save_interval \
  %| /writefile $[save_dir('basic')]

;; Save on connection failures, term, or hangup
/def -Fp5 -h'DISCONNECT|SIGTERM|SIGHUP' disconnect_save = @save

;; Save before quitting
/def quit = \
  @save%; \
  /@quit

/def save_timer = \
  @save%; \
  /timer -t%{save_interval} -n1 -p'save_pid' -k -- /save_timer

;; Load settings
/eval /load $[save_dir('basic')]

;; Start the first iteration of the save timer.
/save_timer

;; Backwards Compatibility Hack
/test cpl_effects := strlen(cpl_effects) ? cpl_effects : (strlen(cpl_prots) ? cpl_prots : '')
/test effects_list := strlen(effects_list) ? effects_list : (strlen(cpl_effects) ? cpl_effects : '')
/test on_loot_give_to := strlen(on_loot_give_to) ? on_loot_give_to : (strlen(on_kill_give_to) ? on_kill_give_to : '')
/test report_effects := report_effects | report_prots
