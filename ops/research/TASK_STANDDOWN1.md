# TASK STANDDOWN1 - QWEN (qwen3-coder) - no sparring for 5, 10 or 21 days after a bout, by the head it left (pure module + unit test)

Status: OPEN (S433, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: `ops/research/TRAINING_MAP_S432.md` section 0 row F6 STANDDOWN1 and T32. Read both (row F6, and T32 near line 199).
THE DEFECT, read in today's code (S433): only a stoppage loss stops a boxer. `scripts/state/Injuries.gd:175-179` (after_bout)
works out the head place `clampf(100.0 - dmg * DAMAGE_TO_WORST, 0.0, 100.0)` (`:26` DAMAGE_TO_WORST 2.2) and hands it to
InjuryRoll.bout_roll; a head-stoppage loss gets the suspension (`scripts/rules/InjuryRoll.gd:12` KO_DAYS 30), any other bout
sets nothing unless the injury roll lands. The bout is then done, so `scripts/rules/WeekPhase.gd:43-45` phase() returns "base", whose
`:19` "spar": 1 puts a sparring night on Thursday (`scripts/rules/WeekPlan.gd:62` SPAR_DAYS [[], [3], [1, 3]]), and
`scripts/state/Sim.gd:200` runs that evening unless `Injuries.out` (`:173`). So a boxer beaten on Saturday spars on Thursday,
day 5. The map is right about this. ONE THING THE MAP HAS WRONG: it says a head knock is "out 14 to 21 days (InjuryRoll head,
CODE)". The code's head row is `InjuryRoll.gd:18` ["head", 37, 21, 35] = 21 to 35 days (14 to 21 is the cut). This brief uses
the code's row, read from InjuryRoll, never typed.

## Contract
OWNS: scripts/rules/StandDown.gd (NEW, 0 lines now, aim ~60), tests/stand_down_test.gd (NEW, 0 lines now)
RED_TEST: tests/stand_down_test.gd -> STAND_DOWN checks=8 failures=0
REGRESSION: injury_roll_test (StandDown reads InjuryRoll.BOUT_TYPES; InjuryRoll is not edited, so the other tests that preload it -
attr_ten_test, camp_protocol_test, gym_spend_test, injury_why_test - cannot change; no test reads StandDown today: grep tests/ found none)
VISUAL: no

## The job
1. `scripts/rules/StandDown.gd`: `extends RefCounted`, pure static, its ONLY preload
   `const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")`. No Career, no Clock, no Injuries.gd (state; it pulls the game).
   Constants: `HEAD_PER_DAMAGE := 2.2` (comment: the same as Injuries.DAMAGE_TO_WORST), `FINE_AT := 55.0`, `HURT_AT := 35.0`,
   `DAYS := {"fine": 5, "hurt": 10, "critical": 21}`, `ANYWAY_CHANCE := {"fine": 0.02, "hurt": 0.06, "critical": 0.0}` (ESTIMATE).
2. `static func head_place(damage: float) -> float`: `clampf(100.0 - damage * HEAD_PER_DAMAGE, 0.0, 100.0)`.
3. `static func band(head: float) -> String`: "fine" when head >= 55, "hurt" when 35 <= head < 55, else "critical".
4. `static func make(bout_day: int, damage: float, stopped: bool) -> Dictionary`: `{}` when stopped (the suspension rules,
   it is 30 days or more); else `{"band": b, "damage": roundi(damage), "head": head_place(damage), "open_day": bout_day + DAYS[b] + 1}`.
   Days bout_day+1 .. bout_day+DAYS[b] are locked; open_day is the first night sparring runs again.
5. `static func locked(sd: Dictionary, day: int) -> bool`: false for `{}`; else `day < int(sd["open_day"])`.
6. `static func reason(sd: Dictionary, open_words: String) -> String`: `"no sparring to %s: the head took %d" % [open_words,
   int(sd["damage"])]`, "" for `{}`. The caller passes the date words (Clock.fmt(open_day), e.g. "Thu 5 Mar"); StandDown never formats dates.
7. `static func can_spar_anyway(sd: Dictionary) -> bool`: true only for band "fine" or "hurt".
8. `static func head_days() -> Array`: [min, max] read from the "head" row of `InjuryRoll.BOUT_TYPES` (today [21, 35]).
9. `static func spar_anyway_roll(seed: int, sd: Dictionary) -> Dictionary`: `{"knocked": false, "type": "none", "days_out": 0}` when
   not can_spar_anyway; else a RandomNumberGenerator seeded with `seed` (`rng.seed = seed`): knocked when `rng.randf() < ANYWAY_CHANCE[band]`,
   then `{"knocked": true, "type": "head", "days_out": rng.randi_range(min, max)}` from head_days(); not knocked returns the same
   `{"knocked": false, "type": "none", "days_out": 0}`.
10. `static func price_line(sd: Dictionary) -> String`: "" when not can_spar_anyway; else
   `"Spar anyway: %d in 100 of a head knock, out %d to %d days, bouts closed"` with `roundi(chance * 100.0)` (0.06 * 100.0 is
   6.000000000000001 in floats: round it, never int() it), then head_days()[0] and head_days()[1]. Words for the button.

## The checks (tests/stand_down_test.gd; each FAILS on main: the file preloads scripts/rules/StandDown.gd, which does not exist,
so Godot prints `Parse Error: Preload file "res://scripts/rules/StandDown.gd" does not exist`, the test never runs and no STAND_DOWN line prints)
a. head_place(25) == 45 (near, 0.001); head_place(0) == 100; head_place(60) == 0 (clamped).
b. band: 55 -> fine, 54.9 -> hurt, 35 -> hurt, 34.9 -> critical; damage 10 -> fine, 25 -> hurt, 40 -> critical.
c. THE MAP'S TEST: make(100, 25, false): band hurt, open_day 111; locked on every day 101..110, not locked on 111 or 112.
d. Days by band: fine open_day = bout_day + 6, critical = bout_day + 22; make(_, 25, true) is {} and locked({}, any) is false.
e. reason(make(100, 25, false), "Thu 5 Mar") == "no sparring to Thu 5 Mar: the head took 25"; reason({}, "x") == "".
f. can_spar_anyway: fine true, hurt true, critical false, {} false.
g. head_days() == [21, 35]. spar_anyway_roll over seeds 0..9999: hurt knocks 450..750 (6 in 100), fine 100..300, critical 0;
   every knock has type "head" and days_out inside 21..35; the same seed twice gives the same dictionary.
h. price_line(hurt) == "Spar anyway: 6 in 100 of a head knock, out 21 to 35 days, bouts closed"; critical gives "".
EXACTLY 8 checks, one `_check` call per letter a..h: gather each letter's parts into one `ok` flag first (as tests/injury_roll_test.gd
`_test2` does), then one `_check(ok, "<letter>: ...")`. Count every `_check` call in `checks`. Print `PASS <label>` / `FAIL <label>` per
check, then `STAND_DOWN checks=%d failures=%d`, then `quit(1 if failures > 0 else 0)`. The pass line is exactly
`STAND_DOWN checks=8 failures=0` (copy tests/injury_roll_test.gd's shape: `extends SceneTree`, `_initialize`, `_check`, `_near`).

## NOT the seat's job (Claude's follow-up, S433)
The wiring: Injuries.after_bout sets `f["stand_down"] = StandDown.make(c.day, dmg, head_stop)`; Sim.step_day (Sim.gd:200, beside
`resting`) runs "rest" on a locked sparring evening; the strip, the lock reason, the SPAR ANYWAY button. PadWeek.evenings takes no
day, so where the lock lands is Claude's call. Do NOT edit Injuries.gd, Sim.gd, PadWeek.gd, InjuryRoll.gd or any other file.

## Prior research
`python ops/Tools/prior_research.py stand-down sparring "head knock" concussion`: TRAINING_MAP_S432.md (F6, T32),
J_STRESS_S206.md (hard sparring is a real, cumulative cost), J13_THE_BODY_THE_DIET_AND_THE_PICTURE.md and J12_RECOVERY_AND_THE_YEARS.md
(concussion hold days, not age-scaled), CORE_LOOP_MAP_S432.md C17 (the stand-down greys the pair picker), ops/research/topics/training_floor.md.

## What would a human do?
A boxing coach does not put a fighter who took a beating on Saturday in for sparring on Thursday: the head gets days off contact,
more the worse the night was, and a coach who spars a hurt fighter anyway knows the risk is real and says so before the bell.

## Prefab check
None: our own rules, on InjuryRoll's existing head row.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
on the PC (`<godot.exe>` = %LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe). Parse first with `--check-only --script res://<file>`
for both files. No file over 500 lines (both owned files are new; keep the module under ~80). Never "he" or "she" in text.
Do not add the test to tools/run_tests.sh. Keep every existing function's signature (you add a file; touch nothing else).
GDScript traps (GDSCRIPT_TRAPS.md): `var x := <call>` fails when the call returns Variant (dictionary get, array index): type it
(`var b: String = str(sd["band"])`, `var lo: int = int(row[2])`); `%` in a format string is `%%`; a variable name reused in one
function is a parse error, even across blocks (the loops over seeds: one name per loop).
THE TRAP: the head-knock days. The map says 14 to 21; the code's head row is 21 to 35. Read them from InjuryRoll.BOUT_TYPES in
head_days() (find the row whose [0] is "head", take int(row[2]) and int(row[3])); never type the knock's days (14, 21, 35) anywhere in
StandDown.gd except the constants step 1 gives (HURT_AT 35.0 and DAYS "critical" 21 are band numbers, not knock days: keep them).
And the band edges: 55 is fine, 35 is hurt (>=, not >).

## Result lines (PR body)
RESULT: tests/stand_down_test.gd -> STAND_DOWN checks=8 failures=0
RESULT: tests/injury_roll_test.gd -> INJURY_ROLL failures=0
Paste in the PR body: the knock counts per band over the 10,000 seeds, and the line count of each new file.
