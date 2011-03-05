;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ARRAYS
;;
;; $LastChangedBy: schrepfer $
;; $LastChangedDate: 2010-08-20 13:59:19 -0700 (Fri, 20 Aug 2010) $
;; $HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/arrays.tf $
;;
/eval /loaded $[substr('$HeadURL: svn://wario.x.maddcow.us/projects/ZombiiTF/zombii/trigs/zombie/arrays.tf $', 10, -2)]

/eval /require $[trigs_dir('zombie')]

;;
;; ARRAY_CLEAR
;;
;; Deletes an array and all of it's contents and returns 1 for success and 0
;; for failure.
;;
;; Usage: /array_clear
;;        array_clear()
;;
/def array_clear = \
  /if ({#}) \
    /quote -S /unset `/listvar -s arr_%{1}*%; \
    /result 1%; \
  /endif%; \
  /result 0

;;
;; ARRAY_PUSH
;;
;; Appends an ITEM to the end of an ARRAY and returns the position.
;;
;; Usage: /array_push ARRAY ITEM
;;        array_push(ARRAY, ITEM)
;;
/def array_push = \
  /if ({#} > 1 & regmatch('^[a-z]+$$', {1})) \
    /let _0=arr_%{1}%; \
    /let _1=%{_0}%; \
    /test _1 := %{_1} | 0%; \
    /set %{_0}_%{_1}=%{2}%; \
    /set %{_0}=$[_1 + 1]%; \
    /result _1%; \
  /endif%; \
  /result -1

;;
;; ARRAY_CONTAINS
;;
;; Returns the position of ITEM in ARRAY. Returns -1 if not found.
;;
;; Usage: /array_contains ARRAY ITEM
;;        array_contains(ARRAY, ITEM)
;;
/def array_contains = \
  /if ({#} > 1) \
    /let i=0%; \
    /while (i < array_size({1})) \
      /if ({2} =~ array_get({1}, i)) \
        /result i%; \
      /endif%; \
      /let i=$[i + 1]%; \
    /done%; \
  /endif%; \
  /result -1

;;
;; ARRAY_WALK
;;
;; Walks down ARRAY and uses value from each element as a parameter for ACTION.
;; Returns 1 for success and 0 for failure.
;;
;; Usage: /array_walk ARRAY ACTION
;;        array_walk(ARRAY, ACTION)
;;
/def array_walk = \
  /if ({#} > 1) \
    /let i=0%; \
    /while (i < array_size({1})) \
      /eval %{-1} $$[array_get({1}, i)]%; \
      /let i=$[i + 1]%; \
    /done%; \
    /return 1%; \
  /endif%; \
  /return 0

;;
;; ARRAY_GET
;;
;; Returns the Nth element from ARRAY.
;;
;; Usage: /array_get ARRAY N
;;        array_get(ARRAY, N)
;;
/def array_get = \
  /if ({#} > 1) \
    /let _0=arr_%{1}%; \
    /let _1=%{_0}%; \
    /test _1 := %{_1} | 0%; \
    /let _2=$[{2} + 0]%; \
    /if (_2 < 0 | _2 + 1 > _1) \
      /result ''%; \
    /endif%; \
    /result %{_0}_%{_2}%; \
  /endif%; \
  /result ''

;;
;; ARRAY_SET
;;
;; Set the value of Nth element in ARRAY as ITEM and returns the position.
;;
;; Usage: /array_set ARRAY N ITEM
;;        array_set(ARRAY, N, ITEM)
;;
/def array_set = \
  /if ({#} > 2) \
    /let _0=arr_%{1}%; \
    /let _1=%{_0}%; \
    /test _1 := %{_1} | 0%; \
    /let _2=$[{2} + 0]%; \
    /if (_2 < 0 | _2 + 1 > _1) \
      /result -1%; \
    /endif%; \
    /set %{_0}_%{_2}=%{3}%; \
    /result _2%; \
  /endif%; \
  /result -1

;;
;; ARRAY_SIZE
;;
;; Returns the size of the ARRAY.
;;
;; Usage: /array_size ARRAY
;;        array_array(ARRAY)
;;
/def array_size = \
  /if ({#}) \
    /let _0=arr_%{1}%; \
    /result %{_0} > 0 ? %{_0} : 0%; \
  /endif%; \
  /result 0

;;
;; ARRAY_REMOVE
;;
;; Removes the Nth element from the ARRAY and returns it.
;;
;; Usage: /array_remove ARRAY N
;;        array_remove(ARRAY, N)
;;
/def array_remove = \
  /if ({#} > 1) \
    /let _0=arr_%{1}%; \
    /let _1=%{_0}%; \
    /test _1 := %{_1} | 0%; \
    /let _2=$[{2} + 0]%; \
    /if (_2 < 0 | _2 + 1 > _1) \
      /result ''%; \
    /endif%; \
    /let _3=%{_0}_%{_2}%; \
    /test _3 := %{_3}%; \
    /for i %{_2} $[_1 - 1] \
      /test %{_0}_%%{i} := %{_0}_$$[i + 1]%; \
    /unset %{_0}_$[_1 - 1]%; \
    /if (_1 - 1 > 0) \
      /set %{_0}=$[_1 - 1]%; \
    /else \
      /unset %{_0}%; \
    /endif%; \
    /result _3%; \
  /endif%; \
  /result ''

;;
;; ARRAY_POP
;;
;; Removes the last element from ARRAY and returns it.
;;
;; Usage: /array_pop ARRAY
;;        array_pop(ARRAY)
;;
/def array_pop = \
  /if ({#}) \
    /result array_remove({1}, array_size({1}) - 1)%; \
  /endif%; \
  /result ''

;;
;; ARRAY_INSERT
;;
;; Inserts ITEM at Nth position in ARRAY and returns position.
;;
;; Usage: /array_insert ARRAY N ITEM
;;        array_insert(ARRAY, N, ITEM)
;;
/def array_insert = \
  /if ({#} > 2) \
    /let _0=arr_%{1}%; \
    /let _1=%{_0}%; \
    /test _1 := %{_1}%; \
    /let _2=$[{2} + 0]%; \
    /if (_2 < 0 | _2 > _1) \
      /result -1%; \
    /endif%; \
    /let i=%{_1}%; \
    /while (i > _2) \
      /test %{_0}_%{i} := %{_0}_$[i - 1]%; \
      /let i=$[i - 1]%; \
    /done%; \
    /set %{_0}_%{_2}=%{3}%; \
    /set %{_0}=$[_1 + 1]%; \
    /result _2%; \
  /endif%; \
  /result -1

;;
;; ARRAY_UNSHIFT
;;
;; Inserts ITEM at the 0th position in array.
;;
;; Usage: /array_unshift ARRAY ITEM
;;        array_unshift(ARRAY, ITEM)
;;
/def array_unshift = \
  /if ({#} > 1) \
    /result array_insert({1}, 0, {2})%; \
  /endif%; \
  /result -1

;;
;; ARRAY_SHIFT
;;
;; Removes the 0th element in array and returns it.
;;
;; Usage: /array_shift ARRAY
;;        array_shift(ARRAY)
;;
/def array_shift = \
  /if ({#}) \
    /result array_remove({1}, 0)%; \
  /endif%; \
  /result ''
