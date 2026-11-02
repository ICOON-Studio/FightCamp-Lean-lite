# TASK SHOUTS1 - corner shouts the fighter LEARNS, as one pure rules module (boxing)

Model: Arena (cloud). Discipline: BOXING (demo). Fast lane: ADD ONLY the two new files below, touch nothing else.

## Why
Operator idea S249 (verbatim): "during the corner at a fight you can shout a command every 25s (stay behind the jab e.g) these things you
complete for your during the trainiing bars feeling in real time as the fighter learns them , also being able to see(hear) what the
opponent does and prepare your next command(shout) options that are not fully learned by the fighter might be risky etc".
Operator board answer Q-S249-3: "Build it". Design: Ludo r117, verbatim in `research/ludo_rx/LUDO_R117_raw.txt` (shout list :9-122,
learning :123-173, execution :174-221, rhythm :222-243, live reads :244-279) and `LUDO_R117_cont_raw.txt` (traps + balance :1-88). The
verdict that overrides Ludo where they differ: `research/CORNER_SHOUTS_VERDICT_S250.md` - READ IT FIRST.
Claude wires the module into `scripts/rules/ApronShouts.gd` and the training day afterwards - you write only the module + its test.

## Files you create (only these)
1. `Godot/scripts/rules/CornerShouts.gd` - `extends RefCounted`, ALL functions `static`, NO preloads, NO autoloads, NO scene access,
   NO RNG (every random draw is a float 0..1 passed IN by the caller).
2. `Godot/tests/corner_shouts_test.gd` - `extends SceneTree`, `OK  <label>` / `FAIL <label>` lines, ends with
   `print("CORNER_SHOUTS failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`.

## CornerShouts.gd API
- `const SHOUTS: Dictionary` - the 12 ids of r117 :23-114 (STAY_BEHIND_JAB, OFF_THE_ROPES, GO_TO_THE_BODY, TIE_HIM_UP, BOX_AND_MOVE,
  STEP_ON_THE_GAS, TIME_THE_COUNTER, HIGH_GUARD_WALKDOWN, DOUBLE_THE_JAB, RIP_THE_LIVER, CHANGE_THE_LEVELS, KILL_THE_CLOCK) -> 
  `{"text", "duration_s", "levers": Dictionary, "counter_risk": Dictionary, "primary_station", "secondary_station", "rate_primary",
  "rate_secondary"}`. Levers only from the r117 lever list (:12-20): `jab_w/straight_w/hook_w/upper_w` (fractions), `head_bias` (0-1),
  `distance_bias` (-1..1), `pace_mult`, `guard` ("high"/"neutral"/"low"), `clinch_urge`, `counter_commit` (0..0.30), `accuracy_delta`,
  `evasion_delta` (fractions). NO critical-power / crit-rate lever anywhere (verdict "Left out"): where Ludo writes "+N% critical/stun",
  put `{"opp_accuracy_delta": N/100}` in counter_risk instead. KILL_THE_CLOCK carries `"last_seconds": 30`.
- `const TIER_USABLE = 30.0`, `TIER_SHARP = 60.0`, `TIER_DRILLED = 85.0`; `static func tier(mastery: float) -> String` -> "Raw" / "Usable" /
  "Sharp" / "Drilled-in".
- Learning: `static func cap(fight_iq: float, technique: float) -> float` = min(100, 35 + 0.4 iq + 0.25 tech);
  `static func gain(shout_id: String, station: String, hours: float, coach_present: bool, mastery: float, cap: float) -> float` returns the
  NEW mastery (primary rate, secondary rate, any other station 0; x1.35 coach present; never above cap);
  `static func film_gain(mastery: float, cap: float) -> float` (+6, never above min(60, cap), never lowers a mastery already above 60);
  `static func decay_week(mastery: float, drilled_hours_this_week: float) -> float` (-0.85 when < 0.5 h drilled; floor 30 once >= 30,
  else floor 0).
- Execution: `static func exec_chance(mastery: float, trust: float, composure: float, contradicts_style: bool) -> float` (0-100) =
  0.55 m + 0.25 t + 0.20 c, +12 if trust > 75, -30 if trust < 30 AND contradicts_style, clamped 5..98.
  `static func resolve(mastery: float, trust: float, composure: float, contradicts_style: bool, roll_exec: float, roll_fail: float) -> Dictionary`
  -> `{"outcome": "clean"|"delayed"|"ignored"|"blunder", "delay_s", "trust_delta", "composure_delta", "effects": Dictionary}`:
  success when roll_exec * 100 < exec_chance; a success is "clean" when exec_chance >= 70 else "delayed" (delay_s = lerp 5.0 -> 3.5 as
  exec_chance goes 40 -> 70; below 40 use 5.0). A failure rolls roll_fail on the tier's failure table: Raw ignore 0.50 / delay 0.30 /
  blunder 0.20, Usable 0.70 / 0.25 / 0.05, Sharp and Drilled-in 1.0 / 0 / 0. trust > 75 turns a blunder into "ignored".
  Effects: delayed -> `{"evasion_delta": -0.15, "counter_rate": 0.0, "for_s": 2.5}`; blunder -> `{"guard": 0.0, "for_s": 1.8,
  "opp_counter_accuracy_delta": 0.30}` and composure_delta -8 (NO auto knockout, no crit); ignored -> trust_delta -1.
  `static func blunder_odds(mastery: float) -> Dictionary` -> `{"blunder", "ignore", "delay"}` fractions of a failure, for the HUD tooltip.
- Rhythm: `const COOLDOWN_S = 25.0`; `static func cooldown_s(composure: float) -> float` (x0.85 when composure >= 70);
  `static func max_per_round(coach_rating: float, composure: float) -> int` (3, +1 when coach_rating >= 70, 1 when composure < 20, never > 4).
  `static func unmatched_trust_delta() -> float` = -4.0 (verdict: Ludo's -8 halved) for a shout that answers no live read.
- Live reads: `static func reads(window: Dictionary) -> Array` - the 4 reads of r117 :251-266 from a rolling-window summary
  `{"jab_thrown", "jab_slipped_or_blocked", "high_guard_s", "window_s", "power_share", "power_accuracy", "stamina", "bpm"}`; each read
  `{"id": "READING_YOUR_LEAD"|"SHELLING_TIGHT"|"TELEGRAPHING_POWER"|"GASPING", "label", "shouts": [two ids]}`, in that order, only
  the triggered ones. `const READ_WINDOW_S = 8.0`.
- Every number above is a `const` at the top (Claude recalibrates them in a 100-bout batch); the test reads the consts, never the literals.

## The test (from this contract, not from your code)
- all 12 ids present, each with duration > 0, text without "{", and no key containing "crit" anywhere in SHOUTS;
- tier flips exactly at 30 / 60 / 85; cap: Ludo's Leo Vance (IQ 52, Tech 44) -> 66.8 and IQ 90/Tech 85 -> 92.25;
- gain: primary 1 h coach present = rate x 1.35; never above cap; unknown station = no change; film stops at 60; decay floor 30 vs 0;
- exec_chance clamps at 5 and 98; trust 76 adds 12; trust 29 + contradicts subtracts 30;
- resolve: a Drilled-in shout can never blunder for ANY roll_fail in 0..1 step 0.01; trust 80 never blunders; Raw with roll_fail 0.95 and
  trust 50 blunders; a blunder carries no crit and no knockout key; the failure-table boundaries flip at 0.50 / 0.80 (Raw);
- rhythm: 25 s, 21.25 s at composure 70, max 4 with coach 70, 1 at composure 19;
- reads: each read triggers just past its threshold and not just before it.
- Mutants: say in the PR body which two consts you nudged and that the test went red.

## Prior research
`python Tools/prior_research.py corner shouts learned mastery`: DrillMastery.gd (station pips, S84) and TECHNIQUE_CATALOGUE_CONTRACT.md -
neither covers corner calls. Existing: `scripts/rules/ApronShouts.gd` (5 shouts, 22 s, 3 per round, adherence chance) - do NOT edit it.

## What would a human do?
A real cornerman only yells what the fighter has drilled; a new instruction mid-round gets ignored or half-done, and a panicked fighter
hears nothing. He watches the other man ("he's dropping his left after the jab") and calls the drilled answer.

## Prefab check
No boxing corner-call library exists (Asset Library / GitHub searched S250 for the verdict). Pure GDScript, no assets.

## Contract
OWNS: Godot/scripts/rules/CornerShouts.gd, Godot/tests/corner_shouts_test.gd
RED_TEST: Godot/tests/corner_shouts_test.gd -> CORNER_SHOUTS failures=0
REGRESSION: corner_shouts_test
VISUAL: no

## The trap
GDScript `:=` cannot infer a type from a Variant (Dictionary values, `.get(...)`) - type it explicitly (`var x: float = ...`).
Do not delete or weaken a check to go green; CI runs the test. Plain `--script` tests are the OFF control arm (game switches off) - this
module has no switch. PR body: `RESULT: tests/corner_shouts_test.gd -> CORNER_SHOUTS failures=0`. Repo: ICOON-Studio/FightCamp, branch
`arena/...`, open a PR, never merge.
