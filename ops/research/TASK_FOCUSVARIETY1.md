# TASK FOCUSVARIETY1 - the same focus day after day flattens its gains, and the coach says "change the plan" (boxing demo)

Model: Arena (cloud, repo ICOON-Studio/FightCamp-lite, branch arena/*). Discipline: BOXING (demo).
Approved scope: operator board Q-S264-1 (S266) "Build the station focus plan as written" - spec `research/STATION_FOCUS_S266.md`
section "Deep": "The same focus day after day raises monotony -> gains flatten -> CHANGE THE PLAN fires. Varying focus is the skill the
player learns." Operator: "keep it simple but deep".

## Files you own (both NEW; touch nothing else)
1. `Godot/scripts/rules/FocusVariety.gd` - `extends RefCounted`, static funcs only, no class_name, no autoload, no preloads, no RNG.
   Never mutates an argument (return fresh dictionaries).
2. `Godot/tests/focus_variety_test.gd` - `extends SceneTree`, prints `OK: ...` / `FAIL: ...` lines, ends
   `print("FOCUS_VARIETY failures=%d" % failures)` and `quit(1 if failures > 0 else 0)`.

## The module (exact API)
History shape: `{station: [[day: int, focus_id: String], ...]}` - one entry per (station, day), oldest first.
- `const KEEP_DAYS := 7` - entries older than `day - KEEP_DAYS + 1` are dropped by `record`.
- `static func record(history: Dictionary, day: int, station: String, focus_id: String) -> Dictionary` - a NEW history with
  [day, focus_id] for that station; a second record for the same (station, day) REPLACES that day's focus (last pick of the day wins);
  old entries pruned (all stations).
- `static func streak(history: Dictionary, station: String, day: int) -> int` - how many CONSECUTIVE calendar days ending at `day`
  that station was trained with the SAME focus as on `day` (0 when `day` has no entry; a missing day breaks the streak).
- `static func gain_mult(streak_days: int) -> float` - 1.0 for 0..2, 0.92 at 3, 0.85 at 4, 0.80 at 5, 0.75 at 6 or more.
- `static func nudge(history: Dictionary, day: int, names: Dictionary = {}) -> String` - "" unless some station's streak at `day`
  is >= 3; then exactly `CHANGE THE PLAN: 3 days of POWER SHOTS at the heavy bag - the gains are flattening.` using the LONGEST streak
  (ties: station name ascending), the focus id upper-cased with `_` -> space (or `names[focus_id]` when given), the station id with
  `_` -> space, lower case, after "the ".

## Acceptance - the test must cover (write it from THIS contract, then check your module against it)
1. record twice same (station, day) -> one entry, the second focus.
2. record prunes: an entry 7+ days old is gone after a record on a later day (KEEP_DAYS 7: day 10 keeps days 4..10).
3. streak: heavy_bag power_shots on days 1,2,3 -> streak(day 3) == 3; days 1,2 power_shots + day 3 combinations -> 1; days 1 and 3
   only (day 2 missing) -> 1; no entry on day -> 0.
4. gain_mult exact table: 0,1,2 -> 1.0; 3 -> 0.92; 4 -> 0.85; 5 -> 0.80; 6, 9 -> 0.75.
5. nudge: 2-day streak -> ""; 3-day heavy_bag power_shots -> the exact sentence above; two stations with 4 and 3 -> names the 4;
   `names` {"power_shots": "POWER SHOTS"} used when given.
6. The input history is unchanged after record (deep compare with a copy taken before).

## Prior research
Foster 1998 training monotony (same load day after day raises monotony/strain); accommodation principle (a repeated stimulus yields
diminishing adaptation). Our TrainingMeters already reads Foster monotony from the load ledger; this module is the FOCUS side.

## What would a human do?
A coach who sees his fighter do the same power work four days running changes the session - the body stops answering the same stimulus.

## Prefab check
None - a 60-line pure rule; no library models focus variety.

## The one trap
Calendar days, not entries: a gap day BREAKS a streak. Do not count entries.

## Contract
OWNS: Godot/scripts/rules/FocusVariety.gd, Godot/tests/focus_variety_test.gd
RED_TEST: Godot/tests/focus_variety_test.gd -> FOCUS_VARIETY failures=0
REGRESSION: focus_variety_test
VISUAL: no

PR body must carry: `RESULT: tests/focus_variety_test.gd -> FOCUS_VARIETY failures=0`. Never delete or weaken a test to go green.
