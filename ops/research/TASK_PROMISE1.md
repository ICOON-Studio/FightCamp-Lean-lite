# TASK PROMISE1 - promises to a fighter: made, listed only when they bind, kept or broken, and what they lock (pure + test)

Status: OPEN (S486, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
R58 "a fighter leaves" is approved (Dola 7/7, map ops/research/R58_MAP_S439.md section 4 M5). A promise is one of the
five answers to a rival club's approach (APPROACH1, built beside this) and a lever of its own: each promise LOCKS
something in the game until it is kept or broken. Claude wires the locks into Bouts / Roster / Find a fighter after.
Pure rules only: the caller passes plain dictionaries; this module reads no game state.

## What to build: scripts/rules/Promises.gd (extends RefCounted; pure static; NO preload, NO class_name)
A promise is a Dictionary {fid:String, kind:String, by_day:int, wclass:String ("" unless kind no_signing),
state:String ("open" / "kept" / "broken"), made_day:int}. The list is an Array of those (the caller keeps it in the save).
Kinds and their constants:
- `SHOW_TOP := "show_top"` - "Top of our show on <date>": the fighter's next bout is the show's; broken if unfit, injured
  or not made weight on the night.
- `TURN_PRO := "turn_pro"` - "You turn pro when the offer comes": declining the pro offer is locked; kept when taken.
- `NO_SIGNING := "no_signing"` - "No signing in your class before <date>": the trial in that weight class is hidden;
  kept on the date.
- `KEPT := 10` (loyalty when kept), `BROKEN := -12` (Loyalty.MOVES promise_broken), `MADE := 4`.
- `PRO_NEAR := 2` (turn_pro listed only when the fighter is within 2 wins of a pro offer).

Functions:
1. `listed(kind: String, v: Dictionary) -> bool` - the promise is offered only when it binds something TODAY.
   v: {can_book:bool, bouts_open:int, wins_to_pro:int, scouted_in_class:bool}.
   show_top: can_book and bouts_open > 0. turn_pro: 0 <= wins_to_pro <= PRO_NEAR. no_signing: scouted_in_class.
   Unknown kind -> false.
2. `make(list: Array, fid: String, kind: String, by_day: int, day: int, wclass := "") -> Dictionary` - returns
   {ok:bool, why:String, list:Array (a NEW array; the input is not changed), promise:Dictionary}. Refused (ok false) when
   the fighter already has an OPEN promise of the same kind (why "already promised"), or by_day <= day for show_top /
   no_signing (why "the date has passed"). turn_pro takes by_day -1 (no date).
3. `open_for(list: Array, fid: String) -> Array` - the fighter's open promises, in list order.
4. `blocks_offer(list: Array, fid: String, day: int) -> bool` - true while the fighter has an open show_top with
   by_day >= day (the show is the next bout; outside offers are not shown).
5. `can_decline_pro(list: Array, fid: String) -> bool` - false while an open turn_pro exists for the fighter.
6. `can_invite(list: Array, wclass: String, day: int) -> bool` - false while ANY open no_signing in that wclass has
   by_day > day.
7. `resolve(p: Dictionary, v: Dictionary) -> Dictionary` - one promise on a given day. v: {day:int, fit:bool,
   made_weight:bool, boxed:bool (fought on the show night), turned_pro:bool, signed_in_class:bool}. Returns
   {state:String, loyalty:int, leaves:bool, line:String}. Only an "open" promise changes; anything else returns its own
   state with loyalty 0.
   - show_top on day == by_day: fit and made_weight and boxed -> kept, +KEPT, line "kept: top of our show";
     otherwise -> broken, BROKEN, leaves true (the map: unfit on the night = leaves the Monday after), line
     "broken: missed our show". Before by_day: stays open, 0.
   - turn_pro: turned_pro -> kept +KEPT "kept: turned pro"; otherwise open.
   - no_signing: signed_in_class before by_day -> broken BROKEN, leaves false, "broken: signed in your class";
     day >= by_day and not signed -> kept +KEPT "kept: no signing in your class".
8. `line(p: Dictionary, date_text: String) -> String` - the PROMISES OPEN row with no names (names live in headers):
   show_top "Top of our show on <date_text>", turn_pro "Turn pro when the offer comes", no_signing
   "No signing in your class before <date_text>".

## The test: tests/promises_test.gd (extends SceneTree; prints ok/FAIL per check; last line `PROMISES PASS fails=0` or
`PROMISES FAIL fails=<n>`; quit(0)/quit(1))
- listed: show_top {can_book:true, bouts_open:2} true; bouts_open 0 false; can_book false false. turn_pro wins_to_pro 2
  true, 3 false. no_signing scouted_in_class false -> false.
- make show_top for "danny" by_day 124 on day 91 -> ok; a second show_top for "danny" -> ok false "already promised";
  the input list is unchanged in size after make (a new array came back); by_day 90 on day 91 -> "the date has passed".
- The map's case: show promise for day 124. resolve on day 124 with fit false -> broken, loyalty -12, leaves true.
  fit, made_weight, boxed -> kept +10, leaves false. resolve on day 120 -> still open, 0.
- blocks_offer for "danny" on day 100 true, on day 125 false; for "lucy" false.
- turn_pro open -> can_decline_pro("danny") false; after resolve turned_pro -> kept +10; a list with that promise
  marked kept -> can_decline_pro true.
- no_signing for wclass "60 kg" by_day 150: can_invite("60 kg", 120) false, ("57 kg", 120) true, ("60 kg", 150) true.
  resolve with signed_in_class true on day 130 -> broken, leaves false.
- line(show_top, "Sat 9 May") == "Top of our show on Sat 9 May".

GDSCRIPT TRAPS (each cost an earlier Arena PR a fix): never `var x := <an Array or Dictionary element>` (untyped
Variant -> parse error: write `var x: int = int(d["k"])`); Array has no join(); `duplicate(true)` for the new list; a
ternary is `a if cond else b`.

## Contract
OWNS: scripts/rules/Promises.gd, tests/promises_test.gd
RED_TEST: tests/promises_test.gd -> PROMISES PASS fails=0 (red on main: the files do not exist)
REGRESSION: tests/home_bout_test.gd, tests/approach_wire_test.gd (S490: the wiring that landed after)
VISUAL: no
NOT YOURS: every other file. Both files under 500 lines. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/promises_test.gd` (Godot 4.7.2).
Work on your own branch, open a PR, never merge. PR body: `RESULT: tests/promises_test.gd -> PROMISES PASS fails=0`.

## Prior research
ops/research/R58_MAP_S439.md section 4 M5 (the promise list) and M4 (PROMISE: OUR SHOW); section 9 says why "every
offer to <date>" and "the stipend from <date>" were cut; scripts/rules/Loyalty.gd MOVES promise_kept / promise_broken.

## What would a human do?
A gym owner who promises a boxer the top of the next show has to deliver it - and the boxer remembers if he doesn't.

## Prefab check
None: our own rules.
