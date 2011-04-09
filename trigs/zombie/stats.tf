;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; STATS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2011-04-05 00:35:38 -0700 (Tue, 05 Apr 2011) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/stats.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/stats.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

/python from trigs.zombie import stats
/python reload(stats)

;;
;; DEFINE STAT GROUP
;;
;; Defines a stat group.
;;
;; Usage: /def_stat_group [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -f            Force the add even if a group with the same name exists
;;   -g KEY*       The key of this stat group.
;;   -n NAME*      The name of this stat
;;
/def def_stat_group = \
  /if (!getopts('fg:n:', '')) \
    /return%; \
  /endif%; \
  /let opt_f=$[opt_f ? 'True' : 'False']%; \
  /python stats.inst.addGroup( \
      stats.StatGroup('$(/escape ' %{opt_g})', '$(/escape ' %{opt_n})'), force=%{opt_f})

;;
;; DEFINE STAT
;;
;; Defines a stat.
;;
;; Usage: /def_stat [OPTIONS]
;;
;;  OPTIONS:
;;
;;   -f            Force the add even if a stat with the same name exists
;;   -g GROUP*     The group that this stat belongs to
;;   -h HIDE       Do not show this stat in display
;;   -k KEY*       The key which matches this stat
;;   -n NAME*      The name of this stat
;;   -r RANK       The rank when displaying this stat
;;   -s            This stat is special and is not counted in totals
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

/def stat_update = \
  /python stats.inst.update('$(/escape ' %{1})', '$(/escape ' %{2})', %{3-1})

/def stat_display = \
  /if ({#} < 2) \
    /let _cmd=/echo -aCgreen --%; \
  /else \
    /let _cmd=%{-1}%; \
  /endif%; \
  /python stats.inst.display('$(/escape ' %{1})', '$(/escape ' %{_cmd})')

/def stat_reset = \
  /python stats.inst.reset('$(/escape ' %{1})')

/def stat_reset_all = \
  /python stats.inst.resetAll('$(/escape ' %{1})')

/def stat_save = \
  /python stats.inst.save('$(/escape ' %{1})', '$(/escape ' %{2})')

/def stat_load = \
  /python stats.inst.load('$(/escape ' %{1})', '$(/escape ' %{2})')

/def stat_clean = \
  /python stats.inst.clean('$(/escape ' %{1})')

/def stat_purge = \
  /python stats.inst.purge('$(/escape ' %{1})')
