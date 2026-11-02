# TASK STEPPICKER1 - pick a captured boxing step for a step intent, warp it onto the engine's spot (pure module + test)

Model: Arena (cloud, FightCamp-lite). Discipline: BOXING (demo).

## Why (Claude S274, from FOOTWORK_PLAN_S273.md)
The fight's body is slid by the engine and a procedural planner invents the steps under it, so feet skate on 13-15 % of
planted frames (S258 probe planted_skate) while the board's mocap takes look right because the actor's own steps move him.
The fix: the bout asks for STEPS (an intent: direction + distance + turn), a picker chooses the nearest CAPTURED step from a
library (Rokoko / Ailive cuts with their root motion), and warps its root translation a little so the body lands on the
engine's spot. The sim still owns WHERE the body ends; the clip owns HOW it gets there. You write the picker only.

## What to write
`Godot/scripts/rules/StepPicker.gd` - `extends RefCounted`, PURE: static funcs only, zero preloads, no file read, no RNG,
no argument modified (same header style as `Godot/scripts/rules/PunchTiming.gd`).

Data shapes (plain Dictionaries / Vector2, metres, degrees, the fighter's LOCAL frame: +y = toward the opponent, +x = his right):
- library entry: `{"id": String, "move": Vector2, "turn_deg": float, "length_s": float, "kind": String}`
  `move` = the clip's root translation start->end; `kind` in `step|pivot|bounce`.
- intent: `{"move": Vector2, "turn_deg": float}` (a bounce in place = move (0,0), turn 0).

Functions:
1. `pick(library: Array, intent: Dictionary) -> Dictionary` returns
   `{"id": String, "scale": float, "rotate_deg": float, "turn_extra_deg": float, "cost": float}` or `{}` when the library is empty.
   - Cost of an entry: direction error (angle between `move` vectors, degrees; 0 when both are shorter than 0.05 m) x 1.0
     + distance error |len(intent) - len(entry)| in cm x 0.5 + |turn error| deg x 0.3. Lowest cost wins; tie -> lower id
     (String compare) so the result is deterministic.
   - An entry whose length is under 0.05 m (a bounce) only matches an intent shorter than 0.10 m, and vice versa
     (a 0.3 m step never answers a bounce request).
   - `scale` = len(intent) / len(entry), CLAMPED to 0.8..1.2 (motion warping without breaking the plants); 1.0 for bounces.
   - `rotate_deg` = signed angle from entry.move to intent.move, CLAMPED to -10..+10.
   - `turn_extra_deg` = intent.turn - entry.turn, CLAMPED to -15..+15.
2. `warp(entry: Dictionary, picked: Dictionary) -> Vector2` - the root translation the body will travel:
   entry.move rotated by picked.rotate_deg then multiplied by picked.scale.
3. `residual(intent: Dictionary, entry: Dictionary, picked: Dictionary) -> Vector2` - intent.move - warp(...). The bout
   slides only this remainder; the test proves it is zero inside the clamp band and non-zero outside it.

## The test
`Godot/tests/step_picker_test.gd` - `extends SceneTree`, preload the module only, `_check` + `print("STEP_PICKER failures=%d")`,
`quit(1 if failures > 0 else 0)` (same shape as `Godot/tests/focus_variety_test.gd`). A fixture library of >= 8 entries
(step_in 0.30, step_out 0.30, step_left 0.28, step_right 0.28, pivot_l 30 deg, pivot_r -30 deg, bounce, a long step_in 0.45).
Cases, each a separate check:
- straight in 0.32 m -> step_in, scale 0.32/0.30, rotate 0;
- in 0.43 m -> the long step_in (not step_in scaled 1.43, which the clamp forbids);
- diagonal in-left 0.30 m at 45 deg -> the entry whose direction is nearest, rotate clamped to +-10, residual non-zero;
- 0.6 m in -> scale clamped 1.2 and residual = intent - warp (non-zero);
- 0.03 m request -> bounce; a 0.3 m request never returns bounce;
- turn 35 deg in place -> pivot_l, turn_extra 5;
- empty library -> {};
- determinism: two entries with equal cost -> the lower id, every time;
- the input library and intent are unchanged after pick (deep compare against a duplicate(true)).
The test must be RED on master (the module does not exist) and green with your module. Add one MUTANT proof in the PR
body: flip the scale clamp to 0.5..2.0 and show which check goes red.

## Parse gate and tests
`python Godot/tools/check_scripts.py scripts/rules/StepPicker.gd tests/step_picker_test.gd`;
`$GODOT --headless --path Godot --script tests/step_picker_test.gd`. No LFS assets are loaded (pure). Plain `--script` only.
PR body: `RESULT: tests/step_picker_test.gd -> STEP_PICKER failures=0`.

## Owned files
Godot/scripts/rules/StepPicker.gd (new), Godot/tests/step_picker_test.gd (new). Nothing else.

## Prior research
FOOTWORK_PLAN_S273.md (the plan), topics/footwork.md, J49_MECHANICS_MEET_PRESENTATION.md row 5 (motion matching, Clavet
For Honor: game logic is a simple timed state machine, MM picks the clip), FIGHTGAP1 spacing ranges (jab ~1.2 m, hook
0.75-0.85, clinch < 0.65 - the bout's step distances come from these, not this module).

## What would a human do?
An animator with a step library picks the take whose footprints are closest to where the director wants the actor, then
nudges it a few centimetres and degrees in the edit - never stretches a step by half, which reads as skating.

## Prefab check
Motion matching plugins exist for Unreal/Unity; nothing for Godot 4.7 that fits a 2-fighter 8-direction step set. This is
the small form (nearest-neighbour over ~20 entries), ~120 lines.

## The one trap
Never widen the clamps to make a case pass - a 1.5x warped step IS the skate we are removing. The remainder goes to
`residual`, visibly.

## Contract
OWNS: Godot/scripts/rules/StepPicker.gd, Godot/tests/step_picker_test.gd
RED_TEST: Godot/tests/step_picker_test.gd -> STEP_PICKER failures=0
REGRESSION: step_picker_test
VISUAL: no
