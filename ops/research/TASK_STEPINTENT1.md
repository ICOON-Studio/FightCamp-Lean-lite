# TASK STEPINTENT1 - turn the bout's spacing into STEP INTENTS (pure module + test)

Model: Arena (cloud, FightCamp-lite). Discipline: BOXING (demo).

## Why (Claude S274, FOOTWORK_PLAN_S273.md step 2)
The bout moves a fighter by gliding him to a target position; the feet then skate (13-15 % of planted frames). The fix asks
for STEPS: a step intent `{"move": Vector2, "turn_deg": float}` in the fighter's LOCAL frame (+y toward the opponent, +x his
right), which `Godot/scripts/rules/StepPicker.gd` (on master, 295b4965 - read it) answers with a captured step. This task
writes the module that decides WHICH step to ask for, from the spacing state. You do not touch the bout or the picker.

## What to write
`Godot/scripts/rules/StepIntent.gd` - `extends RefCounted`, PURE (static funcs, zero preloads, no file read, no RNG - any
variety comes from an int `beat` argument the caller passes, no argument modified). Header style of `PunchTiming.gd`.

`next(state: Dictionary) -> Dictionary` returns `{"move": Vector2, "turn_deg": float, "why": String}`.
state keys: `gap_m` (centre to centre now), `want_gap_m` (the range the next action needs), `bearing_deg` (opponent's
direction off my facing, + = to my right), `edge_m` (distance from my back to the ropes along -y; large = open ring),
`stance` ("orthodox" | "southpaw"), `beat` (int, the caller's step counter).

Rules (spacing numbers from TASK_FIGHTGAP1.md / K50_SPACING_AND_REACH.md: jab 1.0-1.5 m, mean 1.23; hook/pocket 0.6-1.1 m;
clinch < 0.65 m):
1. FACE FIRST: |bearing| > 20 deg -> a pivot in place: move (0,0), turn = bearing clamped to +-35 deg, why "pivot".
2. CLOSE: gap - want > 0.10 -> step IN: move.y = +min(gap - want, 0.45), at least 0.25 (never a shuffle under 0.25 m - a
   real step); why "in".
3. OPEN: want - gap > 0.10 -> step OUT: move.y = -min(want - gap, 0.45), at least 0.25; BUT if edge_m < 0.6 the man cannot
   back straight up: step out at 45 deg to his lead-hand side instead (orthodox: -x... compute it: lead hand = left for
   orthodox, right for southpaw; the angled step keeps the same length); why "out" or "out_angled".
4. HOLD RANGE: |gap - want| <= 0.10 -> circle: a lateral step 0.25-0.30 m (alternate sides by `beat` parity, but an
   orthodox man circles to his LEFT twice as often: beat % 3 != 0 -> left), plus a turn that keeps him facing the
   opponent after the step (turn = the angle the opponent moves through as seen from the new spot, from gap_m); or a
   bounce in place (move (0,0), turn 0) when beat % 4 == 0; why "circle" / "bounce".
Every returned move is either (0,0) or 0.25..0.45 m long. Every turn within +-35 deg.

## The test
`Godot/tests/step_intent_test.gd` - `extends SceneTree`, preload the module only, `_check` + `print("STEP_INTENT failures=%d")`,
`quit(1 if failures > 0 else 0)` (shape of `Godot/tests/focus_variety_test.gd`). Cases (one check each):
- bearing 40 -> pivot, turn 35, move zero; bearing -10 with gap ok -> not a pivot;
- gap 1.8, want 1.2 -> in, 0.45; gap 1.35, want 1.2 -> in, 0.25 (floor); gap 1.25, want 1.2 -> circle or bounce;
- gap 0.7, want 1.2, edge 3.0 -> out 0.45 straight back; same with edge 0.4 -> out_angled, 45 deg to the lead side,
  orthodox and southpaw mirrored;
- circle: orthodox over beats 0..11 circles left at least twice as often as right; every circle step has length 0.25-0.30
  and a turn whose sign faces him back at the opponent (stepping left -> turn right, + deg);
- invariant sweep: 500 states on a grid (gap 0.4-2.4, want 0.6-1.5, bearing -60..60, edge 0.2-4, both stances, beats) ->
  every move is zero or 0.25-0.45 m, every turn within +-35;
- determinism: same state twice -> identical result; the input dictionary unchanged (compare to duplicate(true));
- integration with the picker (pure, no file): a fixture library (as in tests/step_picker_test.gd) - for 50 grid states
  StepPicker.pick(library, StepIntent.next(s)) returns a non-empty pick.
RED on master (module missing), green with yours. PR body: one MUTANT proof (drop the 0.25 m floor -> which check goes red).

## Parse gate and tests
`python Godot/tools/check_scripts.py scripts/rules/StepIntent.gd tests/step_intent_test.gd`;
`$GODOT --headless --path Godot --script tests/step_intent_test.gd`. Pure - no LFS. PR body:
`RESULT: tests/step_intent_test.gd -> STEP_INTENT failures=0`.

## Owned files
Godot/scripts/rules/StepIntent.gd (new), Godot/tests/step_intent_test.gd (new). Nothing else.

## Prior research
FOOTWORK_PLAN_S273.md, TASK_FIGHTGAP1.md + K50_SPACING_AND_REACH.md (ranges), topics/footwork.md (orthodox circles away from
the opponent's power hand = to his left), StepPicker.gd (the consumer).

## What would a human do?
A boxing coach: "step in to jab, step out when he crowds you, never back straight onto the ropes - angle out, keep circling
to your left, and always turn to face him."

## Prefab check
n/a - a ~100-line rule table specific to our spacing numbers.

## The one trap
Never emit a step shorter than 0.25 m to "fine tune" range - micro-steps are the skate we are removing; the leftover goes
through StepPicker.residual().

## Contract
OWNS: Godot/scripts/rules/StepIntent.gd, Godot/tests/step_intent_test.gd
RED_TEST: Godot/tests/step_intent_test.gd -> STEP_INTENT failures=0
REGRESSION: step_intent_test
VISUAL: no
