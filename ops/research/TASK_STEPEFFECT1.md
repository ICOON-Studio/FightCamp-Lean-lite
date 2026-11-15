# TASK STEPEFFECT1 - what each of the ten steps does when it fires, and how well (pure data table + grade + test)

Status: OPEN (S485, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
STEPVALUE1 (footwork and defence worth learning) is APPROVED by the owner (board Q-S294-230 "Yes, build it after the
fight week"; the fight week shipped in S481). Map: ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md - this task is build
pieces 2 (StepEffect, section 3) and 4 (the grade, section 4.2). Every number below is copied from the map (ESTIMATE
starting values; a later probe tunes them in this one file). Nothing calls it yet; Claude wires the exchange after.

## What to build: scripts/rules/StepEffect.gd (extends RefCounted; pure static; NO preload, NO class_name)
Constants:
- `STEPS := ["step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint", "tie_up", "roll_out", "push_off"]`
  (the same ids and order as StepMastery.NODES)
- `GRADE_MULT := {"good": 1.2, "ok": 0.85, "poor": 0.35}`, `GOOD_GAP := 5.0`  (good = 5+ above, poor = 5+ below, else ok)
- `ABILITY := {` step id -> [your boxer's ability, the opponent's ability] `}`:
  step_back [footwork, speed]; step_out [footwork, footwork]; pivot_out [footwork, fight_iq]; step_in [speed, timing];
  cut_off [footwork, footwork]; herd [footwork, strength]; feint [fight_iq, composure]; tie_up [inside, strength];
  roll_out [defence, accuracy]; push_off [strength, strength]
- `TABLE := {` step id -> a Dictionary with exactly these keys (absent effect = 0 / "" / false):
  `deny` (float, share of the opponent's damage taken away), `deny_on` ("power" | "all" | "head_hooks" | ""),
  `distance` ("long" | "mid" | "inside" | ""), `open` (float, edge added to your next line), `open_on` ("counter" | "any" |
  "inside" | "power" | ""), `drain` (float, extra tank the opponent loses), `break_to` (the opponent's mode for the next
  exchange: "boxing" | ""), `ropes` (int added to YOUR ropes count), `opp_ropes` (int added to the OPPONENT's ropes
  count), `clears_ropes` (bool), `opp_steps_less` (float, the opponent's step lines fire this much less),
  `opp_counter_edge` (float, added to the opponent's counter line, negative = worse), `ends_early` (bool, both land
  half), `self_tank` (float, tank you GAIN), `tank` (float, tank the step costs; negative = it recovers),
  `wrong_extra_damage` (float, extra damage you take that exchange when it fires as a wrong answer),
  `best` (Array of situation ids), `wrong` (Array of situation ids) `}`. The values:

| step | deny / on | distance | open / on | drain | break_to | ropes | opp_ropes | clears | other | tank | best | wrong |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| step_back | 0.35 power | long | 0.10 counter | 0 | | 1 | 0 | no | | 0.3 | press, loadup | range, counter |
| step_out | 0.25 all | | 0 | 0 | boxing | 0 | 0 | yes | | 0.5 | press, loadup | counter |
| pivot_out | 0 | mid | 0.08 any | 0 | | 0 | 0 | yes | | 0.5 | press, ropes, inside | range |
| step_in | 0 | inside | 0.12 inside | 0.4 | | 0 | 0 | no | wrong_extra_damage 0.2 | 0.3 | range, she_tired | press, counter |
| cut_off | 0 | | 0 | 0.6 | | 0 | 1 | no | opp_steps_less 0.3 | 0.5 | range, she_tired | press |
| herd | 0 | | 0.12 power | 0 | | 0 | 1 | no | | 0.6 | range, she_tired, she_hurt | press |
| feint | 0 | | 0.12 any | 0 | | 0 | 0 | no | opp_counter_edge -0.10 | 0.15 | counter | press |
| tie_up | 0 | | 0 | 0 | boxing | 0 | 0 | no | ends_early true, self_tank 0.8 | -0.8 | loadup, inside, hurt | range |
| roll_out | 0.40 head_hooks | | 0.10 counter | 0 | | 0 | 0 | no | | 0.3 | press, loadup | body |
| push_off | 0 | mid | 0 | 0.3 | | 0 | 0 | no | | 0.4 | inside, clinch | range |

- `ROPES_AT := 3` (three in a round on your count = the next exchange is on the ropes; owner said yes, Q-S294-231)

Functions:
1. `effect(step: String) -> Dictionary` - a deep copy of TABLE[step]; {} for an unknown id.
2. `grade(mine: float, theirs: float) -> String` - "good" when mine - theirs >= GOOD_GAP, "poor" when theirs - mine >=
   GOOD_GAP, else "ok".
3. `grade_for(step: String, my_stats: Dictionary, opp_stats: Dictionary) -> String` - reads ABILITY[step]; a missing stat
   counts 0.0; "ok" for an unknown step.
4. `scaled(step: String, grade_word: String) -> Dictionary` - effect(step) with deny, open, drain, opp_counter_edge,
   opp_steps_less and self_tank multiplied by GRADE_MULT[grade_word] (unknown grade = "ok"); distance, ropes, opp_ropes,
   clears_ropes, ends_early, tank, wrong_extra_damage, best, wrong and the *_on / break_to words are NEVER scaled
   (map 4.2: "Grade never changes DISTANCE or the ropes count").
5. `is_best(step: String, situation: String) -> bool`, `is_wrong(step: String, situation: String) -> bool`.
6. `ropes_after(count: int, step: String) -> int` - your ropes count after the step fires: 0 when clears_ropes, else
   count + ropes.
7. `on_ropes(count: int) -> bool` - count >= ROPES_AT.
Comment block at the top in the house style: what it is, the owner's two rulings quoted above, the map path and sections,
"every number ESTIMATE until probes 2-7 pass", one usage line per function.

## Test: tests/step_effect_test.gd (extends SceneTree; preload the module by path; prints "ok   <what>" / "FAIL <what>",
ends with one line `STEP_EFFECT PASS fails=0` or `STEP_EFFECT FAIL fails=<n>`, quit(0) on pass, quit(1) on fail)
Cover at least: STEPS.size() == 10 and every step has a TABLE row and an ABILITY pair; every TABLE row has exactly the
same key set; effect("step_back").deny == 0.35 and .deny_on == "power" and .ropes == 1; effect("nope") == {};
effect returns a copy (changing it leaves TABLE alone); grade(60, 55) == "good", grade(55, 60) == "poor", grade(58, 55)
== "ok"; grade_for("step_back", {"footwork": 70}, {"speed": 60}) == "good"; grade_for("tie_up", {}, {"strength": 50}) ==
"poor"; scaled("step_back", "good").deny == 0.42 (within 0.0001) and .ropes == 1 and .distance == "long";
scaled("tie_up", "poor").self_tank == 0.28 and .tank == -0.8; scaled("feint", "good").opp_counter_edge == -0.12;
is_best("step_back", "press") true, is_wrong("step_in", "counter") true, is_best("feint", "press") false;
ropes_after(2, "step_back") == 3, ropes_after(2, "pivot_out") == 0, ropes_after(1, "feint") == 1; on_ropes(3) true,
on_ropes(2) false.

GDSCRIPT TRAPS (both cost an earlier Arena PR a fix): never `var x := <an Array or Dictionary element>` (untyped Variant ->
parse error: write `var x: float = float(d["k"])`); Array has no join(). Deep-copy with `.duplicate(true)`.

## Pass lines
RESULT: tests/step_effect_test.gd -> STEP_EFFECT PASS fails=0
(Arena's runner has no Godot: write the code and test exactly to this brief; Claude runs the test on the PC.)

## Contract
OWNS: scripts/rules/StepEffect.gd, tests/step_effect_test.gd
RED_TEST: tests/step_effect_test.gd -> STEP_EFFECT PASS fails=0 (red on main: the files do not exist)
REGRESSION: tests/step_effect_test.gd (nothing else calls it yet; Claude wires the exchange after)
VISUAL: no
NOT YOURS: every other file. Both files under 500 lines. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/step_effect_test.gd` (Godot 4.7.2).
Work on your own branch, open a PR, never merge.

## Prior research
DESIGN_STEPVALUE1_V1_KALLI_KALLI.md sections 2, 3, 4.2, 10 (critics Dola 8/8, Maria 7/6); StepMastery.gd (the ten ids);
Attrs.gd (ability ids: footwork, speed, fight_iq, timing, strength, composure, inside, defence, accuracy).

## What would a human do?
A coach knows what each move buys and against whom: the pull-back against the pressure fighter, the clinch against the
slugger, and that a slow boxer's step-back is a waste of pad time.

## Prefab check
None: a data table of the map's numbers.
