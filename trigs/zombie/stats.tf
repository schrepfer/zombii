;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; STATS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-06-09 13:36:55 -0700 (Thu, 09 Jun 2011) $
;; $HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/stats.tf $
;;
/eval /loaded $[substr('$HeadURL: file:///storage/subversion/projects/ZombiiTF/zombii/trigs/zombie/stats.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/python from trigs.zombie import stats
/python reload(stats)

;;;;
;;
;; Defines a stat group.
;;
;; @option f Force the add even if a group with the same name exists.
;; @option g:key* The key of this stat group.
;; @option n:name* The name of this stat.
;;
/def def_stat_group = \
  /if (!getopts('fg:n:', '')) \
    /return%; \
  /endif%; \
  /let opt_f=$[opt_f ? 'True' : 'False']%; \
  /python stats.inst.addGroup( \
      stats.StatGroup('$(/escape ' %{opt_g})', '$(/escape ' %{opt_n})'), force=%{opt_f})

;;;;
;;
;; Defines a stat.
;;
;; @option f Force the add even if a stat with the same name exists.
;; @option g:group* The group that this stat belongs to.
;; @option h Do not show this stat in display.
;; @option k:key* The key which matches this stat.
;; @option n:name* The name of this stat.
;; @option r#rank The rank when displaying this stat.
;; @option s This stat is special and is not counted in totals.
;;
/def def_stat = \
  /if (!getopts('fg:hn:k:r#s', '')) \
    /return%; \
  /endif%; \
  /if (!strlen(opt_k)) \
    /error -m'%{0}' -a'k' -- must be the key to the stat%; \
    /result%; \
  /endif%; \
  /if (!strlen(opt_g)) \
    /error -m'%{0}' -a'g' -- must be the name of the group key%; \
    /result%; \
  /endif%; \
  /if (!strlen(opt_n)) \
    /error -m'%{0}' -a'n' -- must be the name of the stat group%; \
    /result%; \
  /endif%; \
  /let opt_f=$[opt_f ? 'True' : 'False']%; \
  /let opt_h=$[opt_h ? 'True' : 'False']%; \
  /let opt_s=$[opt_s ? 'True' : 'False']%; \
  /python stats.inst.add('$(/escape ' %{opt_g})', \
      stats.Stat('$(/escape ' %{opt_k})', '$(/escape ' %{opt_n})', rank=%{opt_r}, special=%{opt_s}, hide=%{opt_h}), force=%{opt_f})

;;;;
;;
;; Update the value of a stat.
;;
;; @param group* The group that this stat belong to.
;; @param key* The key which matches this stat.
;; @param amount The amount to chnage the stat.
;;
/def stat_update = \
  /python stats.inst.update('$(/escape ' %{1})', '$(/escape ' %{2})', %{3-1})

;;;;
;;
;; Displays a table with all stat values.
;;
;; @param group* The group to display.
;; @param command
;;     Command used when displaying output. Useful for sending output to a
;;     channel, etc.
;;
/def stat_display = \
  /if ({#} < 2) \
    /let _cmd=/echo -aCgreen --%; \
  /else \
    /let _cmd=%{-1}%; \
  /endif%; \
  /python stats.inst.display('$(/escape ' %{1})', '$(/escape ' %{_cmd})')

;;;;
;;
;; Reset the session values for all stats.
;;
;; @param group* The group to reset.
;;
/def stat_reset = \
  /python stats.inst.reset('$(/escape ' %{1})')

;;;;
;;
;; Reset the session and total values for all stats.
;;
;; @param group* The group to reset.
;;
/def stat_reset_all = \
  /python stats.inst.resetAll('$(/escape ' %{1})')

;;;;
;;
;; Save the values of the stats.
;;
;; @param group* The group to be saved.
;; @param path* The location to save results to.
;;
/def stat_save = \
  /python stats.inst.save('$(/escape ' %{1})', '$(/escape ' %{2})')

;;;;
;;
;; Load the values of all the stats.
;;
;; @param group* The group to be loaded.
;; @param path* The location to load results from.
;;
/def stat_load = \
  /python stats.inst.load('$(/escape ' %{1})', '$(/escape ' %{2})')

;;;;
;;
;; Remove all values which are not currently defined.
;;
;; @param group* The group to be cleaned.
;;
/def stat_clean = \
  /python stats.inst.clean('$(/escape ' %{1})')

;;;;
;;
;; Remove all values and stats.
;;
;; @param group* The group to be purged.
;;
/def stat_purge = \
  /python stats.inst.purge('$(/escape ' %{1})')
