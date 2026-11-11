# TASK REST1 - QWEN (qwen3-coder) - a rest morning adds Recovery and takes nothing off Stamina (two lines out + a red test)

Status: OPEN (S433, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: `ops/research/TRAINING_MAP_S432.md` section 0, row F1 REST1 (the first foundation fix; F2 needs a clean Recovery).
Checked on main by Claude (S433): the map is right about the code. `WeekPlan.day` (scripts/rules/WeekPlan.gd:257-260) gives a
`rest` or `mobility` morning an `attr_gain` off Conditioning's headroom; `Sim.step_day` (scripts/state/Sim.gd:212-213) calls
`Attrs.apply_session(f, "rest", "", attr_gain)` -> `Attrs.train(f, "", gain, ["recovery"])`; `LEGACY.get("")` is empty, so
scripts/rules/Attrs.gd:327-332 sets `out["recovery"] = gain` and then:
    329  # Rest trains recovery and must not move conditioning, the mean of stamina and recovery (WeekPlan leaves the
    330  # old stat at 0 on a rest day). The same points come off stamina.
    331  if float(out.get("recovery", 0.0)) > 0.0 and not out.has("stamina"):
    332      out["stamina"] = -float(out["recovery"])
Every rest morning (taper weeks: Wed, Sat, Sun in WeekPhase.WEEKS["taper"]; every Sunday; every injured week, which Sim runs
as all rest) turns Stamina into Recovery. One more fault the map missed: line 332 runs BEFORE the clamp at lines 348-351,
so a fighter with Recovery at 99 gains no Recovery and still loses the whole gain from Stamina.

## Contract
OWNS: scripts/rules/Attrs.gd (411 lines; only lines 329-332), tests/rest_keeps_stamina_test.gd (new)
RED_TEST: tests/rest_keeps_stamina_test.gd -> REST_KEEPS_STAMINA checks=18 failures=0   (run it on main FIRST: it must print
failures=11; paste both runs)
REGRESSION: attr_board_test, attr_ten_test, fighter_model_bars_test, fighter_model_speed_test, fighter_model_test, fighter_profile_test, gym_kinds_bots_test, knowledge_test, injuries_test, week_read_test
VISUAL: no

Regression notes: (every test that reads Attrs; injuries_test plays all-rest weeks; week_read_test plays real Sim weeks with a rest Sunday and dates
Conditioning against the planner - after the fix Conditioning rises a little on rest days). If one goes red, paste the FAIL lines in
the PR body; do not edit that test.

## The job
1. scripts/rules/Attrs.gd, `static func train(f: Dictionary, stat: String, gain: float, names: Array = []) -> Dictionary`:
   delete lines 329-332 (the two comment lines and the `if` with its body). Put one comment in their place:
   `# Rest adds Recovery and nothing else (S433 REST1): Conditioning, the mean of Stamina and Recovery, rises a little.`
   Nothing else in the file changes: keep every existing function's signature, every constant, the clamp loop, `sync(f)`.
2. tests/rest_keeps_stamina_test.gd, `extends SceneTree`, the house shape of tests/fighter_model_test.gd (`_initialize`,
   `_check(ok, label)` printing `OK  ` / `FAIL `, `quit(0 if failures == 0 else 1)`), counting checks, ending with
   `print("REST_KEEPS_STAMINA checks=%d failures=%d" % [checks, failures])`. Preload only these three, exactly:
   `const Attrs := preload("res://scripts/rules/Attrs.gd")`, `const WP := preload("res://scripts/rules/WeekPlan.gd")`,
   `const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")`.
   Fixture: copy `_ctx(f)` and `_box(id)` from tests/attr_ten_test.gd:184-193 (every old stat 55, pot 80, coach 60.0).
   A day: `var r := WP.full_day(str(d[0]), str(d[1]), "rest", _ctx(f), 20.0)`; if `str(r["stat"]) != ""` call
   `Attrs.apply_session(f, str(d[0]), str(r["stat"]), float(r["gain"]))`; if `float(r["attr_gain"]) > 0.0` call
   `Attrs.apply_session(f, str(d[0]), "", float(r["attr_gain"]))`. Keep the returned Dictionary of BOTH calls (3a reads
   the rest call's, 3b reads the roadwork call's "stamina"). Read values with `Attrs.of(f)` before and after; never assume
   a starting number (from_stats adds a seeded spread and the -5/+5 split). `Attrs.of(f)` returns the fighter's LIVE
   attribute Dictionary, which the call then changes: copy each number into a float BEFORE the call
   (`var st0: float = float(Attrs.of(f)["stamina"])`, the same for "recovery" and for `f["stats"]["conditioning"]`), never
   keep the Dictionary and compare it with itself afterwards.
3. The checks, 18 in this order (on main the fixture's rest gain is about 0.18 a morning: 1.0 x coach 0.92 x headroom
   1.0 x share 0.2):
   a. Step the 7 days of `WeekPhase.WEEKS["taper"]`. For each of the three rest mornings (index 2, 5, 6):
      - attr_gain > 0 (a precondition; passes on main).
      - Recovery rose by the returned `out["recovery"]`, > 0 (passes on main).
      - Stamina unchanged, |delta| < 0.0001. MAIN FAILS: Stamina falls by the Recovery gained (about -0.18).
      - `f["stats"]["conditioning"]` rose by half the Recovery gain (±0.0001). MAIN FAILS: it does not move (0.00).
      - the returned Dictionary has no "stamina" key. MAIN FAILS: it holds "stamina": about -0.18.
   b. The whole week: Stamina at the end minus the start equals the sum of the "stamina" values the NON-rest mornings
      returned (the two light roadwork mornings), ±0.0001. MAIN FAILS: short by the three rest gains (about -0.55).
      Do not check "Stamina ends where it began": roadwork trains Stamina, so that is false after the fix too.
   c. Recovery at the cap: a fresh `_box("cap")`, `var a := Attrs.of(f)`, `a["recovery"] = 99.0`, `Attrs.sync(f)`, one
      rest morning: Stamina unchanged. MAIN FAILS: Recovery gains 0 and Stamina still loses the gain (line 332 is before
      the clamp).
   d. A mobility morning on a fresh box: Stamina and Recovery unchanged, Flexibility up, all three in ONE `_check` (passes
      on main; guards the cut). 3b, 3c and 3d are one check each: 15 + 1 + 1 + 1 = 18.
   Red count on main: 9 (a) + 1 (b) + 1 (c) = 11. Each label names the day and both numbers, e.g.
   `"Wed rest keeps Stamina %.3f -> %.3f (Recovery +%.3f)"`.
4. Do not add the test to tools/run_tests.sh. Do not edit WeekPlan.gd, Sim.gd or any other test.

## The trap
The map's own test sentence ("Stamina ends where it began") cannot pass: the taper week has two roadwork mornings. Check
each rest morning and the week's sum as in 3a/3b. And do not "fix" the cap case by clamping line 332 instead of deleting it.

## GDScript traps (ops/research/GDSCRIPT_TRAPS.md)
- `var x := <call>` fails when the call returns Variant: `var g: float = float(r["attr_gain"])`, `var out: Dictionary = ...`.
- `%` inside a format string is `%%`. A name reused in one function is a parse error, even across blocks.

## Prior research
`python ops/Tools/prior_research.py rest stamina recovery` and `"rest day" Attrs.train detraining taper`: TRAINING_MAP_S432.md
(F1, sections 0 and the Rest rows), CORE_LOOP_MAP_S432.md (F1 REST1 assigned to Qwen), J62_TRAINING_DAY_REPLY.md (one full rest
day a week for a pro; recovery-day content NOT FOUND), research/topics/body_damage.md (cardio, fatigue, recovery).

## What would a human do?
A coach knows a rest day makes a fighter fresher and costs no fitness; fitness falls only when the work stops for weeks
(that is fade by dose, T15, a later task). So rest adds Recovery and leaves Stamina alone.

## Prefab check
None: our own rule, two lines.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`
on the PC. Parse first with the same command and `--check-only --script res://<file>` for both owned files (a parse error
hangs a headless test). No file over 500 lines: Attrs.gd is 411 now (about 408 after), the new test stays under 150.
Never "he" or "she" in text.

## Result lines (PR body)
RESULT: tests/rest_keeps_stamina_test.gd -> REST_KEEPS_STAMINA checks=18 failures=0   (and the main run: failures=11)
RESULT: tests/fighter_model_test.gd -> FIGHTER_MODEL failures=0
RESULT: tests/attr_ten_test.gd -> ATTR_TEN failures=0
RESULT: tests/injuries_test.gd -> INJURIES failures=0
RESULT: tests/week_read_test.gd -> WEEK_READ failures=0
Paste in the PR body: the three rest mornings' Stamina / Recovery / Conditioning before and after, on main and the branch.
