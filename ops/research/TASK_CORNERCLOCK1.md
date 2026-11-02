# TASK CORNERCLOCK1 (S224) - the corner minute runs on a real clock: the pure engine + its contract test (Arena)

Model: Arena default. Repo ICOON-Studio/FightCamp, branch master. Own `arena/...` branch, open a PR into master, NEVER merge it.
Approved: operator Q-S221-5 "Approve, build it" on `research/LUDO_ROUND63_VERDICT_S224.md` (read it all; part G item 1 = this).
Numbers sourced in `research/J68_CORNER_MINUTE_JOHN_XAI.md` (heart rate on the stool).

## What exists (do not replace it - the clock drives it)
- `Godot/scripts/CornerPitStop.gd` (430 lines, extends RefCounted, static funcs): `cards(fighter, found)` returns job cards
  `{"id","problem","lane" (cutman|second|chief),"seconds","benefit","risk","two_sided"}` (~line 238); `PACES` (~24) careful/normal/rushed
  with `time` and `mistake`; `mistake_chance(pace, cutman_skill)`; `apply(fighter, picks, pace, cutman_skill, rolls)` (~317) applies a
  whole frozen plan; `auto_plan(fighter)` (~421) picks the default jobs. Tests: `tests/corner_pit_stop_test.gd`, `tests/ludo_corner_test.gd`.
- `Godot/assets/data/ludo_corner.json`: `ap_seconds` 15, `lane_ap` 2, `rushed_blunder` 0.35, `usable_s` 45, the lane `actions`.

## Build: new pure module `Godot/scripts/rules/CornerClock.gd` (extends RefCounted, NOT static - one instance per corner minute;
## zero preloads except `res://scripts/CornerPitStop.gd`; no RNG inside - rolls are passed in; no Node, no signals)
Phases (seconds since the bell, `t`): ARRIVAL 0-5 (nothing progresses), WORK 5-50, SECONDS_OUT 50-60, BELL at 60 (done).
API (exact names - the panel and the fight wire to these):
- `func start(cards: Array, default_picks: Array, pace: String, cutman_skill: float, rolls: Array) -> void` - default_picks are
  queued at t=0 per lane in the given order (they start at t=5).
- `func step(dt_real: float) -> Array` - advances `t` by dt_real * speed; returns the events that happened in this step, each a
  Dictionary `{"t": float, "kind": String, ...}`; kinds: "phase" (+"phase"), "job_started" (+"lane","id"), "job_done" (+"lane","id",
  "mistake": bool), "seconds_out", "doctor" (once at t=30 when `set_doctor_due(true)` was called), "bell".
- `func queue(lane: String, card: Dictionary, index: int = -1) -> bool` - add to a lane; false after SECONDS_OUT or unknown lane.
- `func cancel(lane: String, id: String) -> bool` - remove a queued job; a RUNNING job can be cancelled too (its time is lost, no effect).
- `func reorder(lane: String, id: String, new_index: int) -> bool` - only among the not-started jobs.
- `func set_pace(pace: String) -> void` - any time; scales the REMAINING seconds of running jobs and all queued ones (PACES time).
- `func set_speed(x: float) -> void` - 1.0 normal, 4.0 = SEND HIM OUT, 10.0 = auto-send; clamp 1..10.
- `func send_now() -> void` = set_speed(4.0).
- `func set_doctor_due(on: bool) -> void`.
- `func lanes() -> Dictionary` - per lane `{"running": {"id","progress" 0..1,"seconds_left"}|{}, "queue": [ids]}` for the UI bars.
- `func phase() -> String`, `func time() -> float`, `func done() -> bool`.
- `func result() -> Dictionary` - `{"done": [card...], "mistakes": [ids], "partial": [{"card": card, "fraction": f}], "pace": p}`.
Rules:
1. The three lanes run IN PARALLEL; inside a lane jobs run one after another in queue order.
2. A job's duration = card.seconds * PACES[pace].time (pace at the moment it started; set_pace rescales the remainder).
3. Mistake: when a job finishes, it is a mistake if the next value from `rolls` (cycle through the array) < CornerPitStop.mistake_chance(
   pace, cutman_skill) for cutman/second jobs; chief jobs use the pace mistake without the cutman skill factor.
4. At SECONDS_OUT (t=50): queued jobs that have not started are dropped (no effect, listed nowhere); running jobs keep running.
5. At the BELL (t=60): a job still running goes to `partial` with fraction = progress (0..1). Its effect scaling is NOT this module's job -
   add `static func scale_effect(effect: Dictionary, fraction: float) -> Dictionary` (numeric values * fraction, bool/str kept only if
   fraction >= 0.5) for the wiring to use.
6. Heart rate on the stool: `static func stool_bpm(bpm_at_bell: float, t: float) -> float` - front-loaded recovery from J68: total drop
   over the minute 30 bpm for a fit fighter (26-35 observed), `drop(t) = 30 * (1 - exp(-t/18)) / (1 - exp(-60/18))`; never below
   bpm_at_bell - 40 and never below 100. Job bpm effects in ludo_corner.json stay as they are (applied by the wiring).
7. Auto-send: `static func auto_send_allowed(ctx: Dictionary) -> Dictionary` -> `{"ok": bool, "reason": String}`; NOT ok (reason
   = the rule's name) when: ctx.knockdown_last_round; ctx.cut_pips >= 2 or ctx.swelling_pips >= 2; ctx.doctor_due; ctx.lost_last_two;
   ctx.final_round and abs(ctx.score_gap) <= 2. Otherwise ok, reason "".
Numbers from the verdict (part F) - change them in place:
- `CornerPitStop.gd` PACES: careful mistake 0.03 -> 0.02, rushed 0.20 -> 0.25 (normal stays 0.08; time multipliers unchanged).
- `ludo_corner.json`: `lane_ap` 2 -> 3. Leave `rushed_blunder` in the file (old frozen card still reads it) but add
  `"_s224": "rushed 3rd AP superseded by the real-time pace (LUDO_ROUND63_VERDICT_S224 F)"`.
- Any existing test that pins one of these three numbers: change ONLY that expected value, with a comment `# S224 r63 verdict F`.
  Never delete or weaken any other check.

## Test (blind, from this contract): `Godot/tests/corner_clock_test.gd`
extends SceneTree, prints `CORNER_CLOCK PASS checks=N` or `CORNER_CLOCK FAIL ...`, quits non-zero on failure. Step with dt 0.1.
(a) phases: events "phase" at 5, 50 ("seconds_out" too) and "bell" at 60 (+-0.11), done() after.
(b) parallel lanes: cutman 15 s + second 12 s + chief 10 s queued at start -> each job_done at 20 / 17 / 15 s (+-0.11).
(c) sequence in a lane: two cutman jobs 15 + 25 -> done at 20 and 45.
(d) pace: rushed makes a 15 s job end at 5 + 10.5; switching normal -> rushed half way through a 20 s job ends it at 5 + 10 + 7.
(e) seconds out: a job queued to start at 52 never starts; queue() returns false after 50.
(f) bell mid-job: a 25 s job started at 40 -> partial fraction 0.8 (+-0.01); scale_effect({"stamina":0.1,"canvas_slick":true}, 0.4)
    -> stamina 0.04, canvas_slick dropped.
(g) cancel / reorder: cancel a queued job (never runs); reorder two queued jobs (order of job_done flips); cancel a running job (no
    job_done for it, the next job starts at once).
(h) speed: set_speed(4) at t=20 -> bell after 20 + 40/4 = 30 real seconds (+-0.11); speed clamps to 10.
(i) mistakes: rolls [0.0] -> every finished job is a mistake; rolls [0.99] -> none; careful pace mistake_chance(…, 50) == 0.02.
(j) doctor: set_doctor_due(true) -> exactly one "doctor" event at t=30.
(k) stool_bpm(185, 0) == 185; stool_bpm(185, 60) == 155 (+-0.5); stool_bpm(185, 20) between 162 and 167 (164.1 by the formula); floor at 100.
(l) auto_send_allowed: each of the 5 rules alone blocks with its own reason; a quiet context is ok.
(m) MUTANT: run (b) on a copy where lanes are forced sequential (a test-only subclass overriding one method) and show (b) fails.
Commands: parse `python Godot/tools/check_scripts.py Godot/scripts/rules/CornerClock.gd Godot/tests/corner_clock_test.gd
Godot/scripts/CornerPitStop.gd`; test `godot --headless --path Godot --script tests/corner_clock_test.gd`; then
`python Godot/tools/run_tests.py --jobs 2 --only corner` (every corner test green).

## Owned files
New: `Godot/scripts/rules/CornerClock.gd`, `Godot/tests/corner_clock_test.gd`. Edit: `Godot/scripts/CornerPitStop.gd` (PACES only),
`Godot/assets/data/ludo_corner.json` (lane_ap + the note), tests that pin those numbers (the pinned value only). Nothing else.
No switch: a pure module ships nothing until the corner panel calls it (next task, cloud Cursor).

## The one trap
GDScript: `:=` on a Variant from a Dictionary fails to parse - type it (`var x: float = float(d["k"])`). Read
`research/GDSCRIPT_TRAPS.md` first. Floating time: compare with tolerances, step events at the first step that crosses the time.

## Prior research
LUDO_ROUND63_REPLY_S224.txt parts B/F/G; J68_CORNER_MINUTE_JOHN_XAI.md + J68_CORNER_MINUTE_DOLA.md; S97 pit stop (CornerPitStop.gd header).

## What would a human do?
Motorsport Manager's pit stop: crews work in parallel, each job a bar, the slowest crew sets the stop; here the bell sets it.

## Prefab check
None: our own pit-stop rules already exist; this adds the clock around them.
