# TASK STATIONFOCUS1 - pure StationFocus.gd: 2-3 focus options per gym station + the RING REPORT (boxing demo)

Model: Cursor (cloud). Discipline: BOXING (demo).
Approved by the operator, board Q-S264-1 (S266): "Build the station focus plan as written". Spec: `research/STATION_FOCUS_S266.md`
(read it whole - the TABLE there is the data, exactly). Operator's words: "you setup his program and then watch him do it ... you select
the heavy bag and you have 2-3 options to focus with different +/- ... the real test is the ring time" / "keep it simple but deep".

## Files you own (both NEW; touch nothing else)
1. `Godot/scripts/rules/StationFocus.gd` - `extends RefCounted`, static funcs only, no class_name, no autoload, no preloads.
2. `Godot/tests/station_focus_test.gd` - `extends SceneTree`, prints `OK`/`FAIL` lines, ends `print("STATION_FOCUS failures=%d" % failures)`
   and `quit(1 if failures else 0)`.

## The module (exact API)
- `const FOCUS := {...}` the spec table as data. Station keys = the club station ids: `heavy_bag`, `pads`, `speed_bag`, `double_end`,
  `shadowbox`, `agility_ladder`, `treadmill`, `weights`, `ring`. Each value: Array of
  `{"id": String, "name": String, "default": bool, "gains": {attr: mult}, "load": float, "wear": bool}`; ids are snake_case of the name
  (`power_shots`, `combinations`, `bag_rounds`, ...). Attribute keys are exactly: hand_speed, footwork, guard, head_movement, technique,
  power, conditioning, fight_iq, composure, recovery. "+X" cross-train rows are just more keys in `gains`.
- `const ALIASES := {"defence_drill": "double_end", "mirror_strip": "shadowbox", "bike": "treadmill", "power_rack": "weights",
  "olympic_platform": "weights", "ring_sparring": "ring"}`; `static func station_key(club_station: String) -> String` (alias or itself).
- `static func options(club_station) -> Array` (deep copy; [] for recovery and unknown stations).
- `static func default_focus(club_station) -> String` (the row with default true; "" when none).
- `static func weights(club_station, focus_id) -> Dictionary` ({attr: mult}; unknown focus -> the default's; unknown station -> {}).
- `static func load_mult(club_station, focus_id) -> float` (unknown -> 1.0).
- `static func is_wear(club_station, focus_id) -> bool`.
- `static func card_lines(club_station) -> Array[String]` - one line per option, EXACT format `[1] POWER SHOTS   + POWER  - more fatigue`:
  index from 1; NAME upper case; then three spaces; `+ ` and the attributes with mult >= 1.4 upper-cased with `_` -> space, joined by
  `, ` (if none >= 1.4, the single highest); then two spaces and the minus part: `- more fatigue` when load >= 1.2, `- easy` when load <= 0.8,
  else nothing (no trailing spaces); `, injury risk` appended to the minus part when wear (`- more fatigue, injury risk`).
- `static func ring_report(this_spar: Dictionary, last_spar: Dictionary) -> Dictionary`. Spar dict:
  `{"landed": int, "thrown": int, "clean_taken": int, "stamina_end": float 0..100}`. Returns
  `{"lines": [line1, line2, line3], "weakest": "fade"|"miss"|"hit"|"", "station": club station id or ""}`:
  - line1 `LANDED 34% (+4)`: landed/thrown rounded to an int percent; the arrow part `(+4)` / `(-3)` / `(0)` only when last_spar is not
    empty; thrown 0 -> `LANDED 0%`.
  - line2 `GUARD: 12 clean shots taken (-3)` (same arrow rule on clean_taken).
  - weakest by score, highest positive wins (ties: fade > hit > miss): fade = (40 - stamina_end) / 40; miss = (0.35 - landed%) / 0.35
    (landed% as 0..1); hit = (clean_taken - 8) / 8.
  - line3 + station: fade -> `He fades late - put him on the bike.` / `treadmill`; hit -> `He takes too many clean shots - double-end, SLIPS.` /
    `double_end`; miss -> `He is missing - heavy bag, COMBINATIONS.` / `heavy_bag`; none positive -> `Good spar - keep the program.` / "".

## Acceptance - the test must cover (write it from THIS contract, not from your implementation)
1. Every station in the spec has 2-3 options and exactly ONE default; recovery has none.
2. Heavy bag weights: power_shots power 1.6 / technique 0.6 / load 1.3; bag_rounds has conditioning 0.4.
3. Aliases: `defence_drill` == `double_end` options; `bike` == `treadmill`.
4. Unknown focus on a known station -> the default's weights; unknown station -> {} and load 1.0.
5. card_lines heavy_bag == exactly ["[1] POWER SHOTS   + POWER  - more fatigue", "[2] COMBINATIONS   + TECHNIQUE",
   "[3] BAG ROUNDS   + POWER, TECHNIQUE  - more fatigue"] - note bag_rounds has no attr >= 1.4 -> the single highest; power and technique
   tie at 0.8 -> list both (tie = all at the max). Treadmill intervals line ends `- more fatigue, injury risk`; speed bag rhythm ends `- easy`.
6. ring_report first spar (last {}): no arrows; `LANDED 34%` for 34/100.
7. ring_report with last: arrows `(+4)` and `(-3)` exact.
8. weakest: stamina_end 10 -> fade/treadmill; clean_taken 20 (stamina 80, landed 40%) -> hit/double_end; landed 15% (stamina 80, clean 5)
   -> miss/heavy_bag; all good -> "" and `Good spar - keep the program.`
9. Every gains key is one of the 10 attribute names (catch typos).
10. Mutants (report in the PR body): power_shots power 1.6 -> 1.5 must fail; the fade threshold 40 -> 30 must fail.

## Parse gate + test
`python Godot/tools/check_scripts.py Godot/scripts/rules/StationFocus.gd Godot/tests/station_focus_test.gd`
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/station_focus_test.gd` (or `python Tools/cloud_test.py station_focus_test`).
Tier: new pure module + its test only. Write the test FIRST and show it red (module missing) in the PR body.
PR body: `RESULT: tests/station_focus_test.gd -> STATION_FOCUS failures=0` + the two mutant lines.

## Prior research
STATION_FOCUS_S266.md (the spec + attribute coverage), Attributes.gd STATIONS (pts/hr), LoadLedger.station_hourly_rate (J62 session-RPE),
TrainingMeters (Foster monotony), SparringBlock.gd (the ring block that will feed ring_report), topics/training_floor.md.

## What would a human do?
A coach tells the fighter what to work on at each bag ("power shots", "combinations", "rounds") and after sparring says the one thing to
fix tomorrow. The module is that coach's menu and that coach's sentence.

## Prefab check
Pure data + rules; no asset. Nothing to reuse beyond our own Attributes/LoadLedger numbers.

## The one trap
Do not read or edit any other script; no preloads. The card text format is exact - the floor shows it verbatim.

## Contract
OWNS: Godot/scripts/rules/StationFocus.gd, Godot/tests/station_focus_test.gd
RED_TEST: Godot/tests/station_focus_test.gd -> STATION_FOCUS failures=0
REGRESSION: station_focus_test
VISUAL: no
