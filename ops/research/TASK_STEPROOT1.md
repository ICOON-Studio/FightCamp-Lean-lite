# TASK STEPROOT1 - move the body along a captured step's own root curve, warped (pure module + test)

Model: Arena (cloud, FightCamp-lite). Discipline: BOXING (demo).

## Why (Claude S274, FOOTWORK_CONTRACT_S274.md step 1)
The bout will ask for steps (StepIntent.gd), pick a captured step (StepPicker.gd, warp: scale 0.8-1.2, rotate +-10 deg) and
pin the take's own foot plants (FootContacts.gd) - all on master. The missing piece: WHERE the body node is on each frame of
the step. It must follow the take's own root curve (a real step accelerates and settles - never a linear glide), warped by
the pick, and then slide only the residual over a short ease.

## What to write
`Godot/scripts/rules/StepRoot.gd` - `extends RefCounted`, PURE (static funcs, zero preloads, no file read, no RNG, no
argument modified). Header style of `Godot/scripts/rules/StepPicker.gd` (read it; reuse its frame: local metres, +y toward
the opponent, +x his right, positive rotate = counter-clockwise as `Vector2.rotated`).

1. `offsets(root: Array, picked: Dictionary) -> Array` - `root` = the take's root (hips) XZ per frame as Vector2, frame 0
   first, in the take's own frame. Returns per frame the offset from the step's start: `(root[i] - root[0])` rotated by
   `picked.rotate_deg` then scaled by `picked.scale` (StepPicker.warp semantics - the last offset must EQUAL
   `StepPicker.warp(entry, picked)` when entry.move = root[last] - root[0]).
2. `residual_ease(residual: Vector2, frames: int) -> Array` - the leftover slide spread over `frames` frames with a smoothstep
   (3t^2 - 2t^3) profile: cumulative offsets, first > 0, last == residual exactly, monotonic along the residual.
3. `path(root: Array, picked: Dictionary, residual: Vector2, ease_frames: int = 3) -> Array` - offsets(...) followed by
   the ease frames, each ease frame = last step offset + the eased residual.
4. `max_speed(path: Array, fps: float) -> float` - the largest per-frame speed (m/s) along a path (the probe column the
   contract asks for).

## The test
`Godot/tests/step_root_test.gd` - `extends SceneTree`, preload StepRoot and StepPicker only, `_check` +
`print("STEP_ROOT failures=%d")`, `quit(1 if failures > 0 else 0)`. Synthetic root curves (30 fps):
- a 0.30 m straight step forward with an ease-in-out profile over 15 frames: picked scale 1.0 rotate 0 -> offsets equal the
  curve minus its start; the middle frame is NOT the linear midpoint +-0.01 unless the curve was linear (the shape is kept);
- the same with scale 1.2 rotate +10 -> last offset == StepPicker.warp(entry, picked) within 1e-5, and every offset's
  length is 1.2x the source's;
- residual_ease((0.06, 0), 3): three values, increasing, last exactly (0.06, 0), first < half;
- path(): length = curve frames + ease frames; continuity - no jump between the last step frame and the first ease frame
  larger than the residual itself;
- max_speed on a 0.30 m step over 0.5 s with smoothstep -> ~0.9 m/s (1.5 x average), within 10 %;
- zero-length root (a bounce) -> all offsets zero; empty root -> [];
- inputs unchanged (compare to duplicate(true)).
RED on master (module missing), green with yours. PR body: one MUTANT proof (apply scale before rotate around the wrong
origin, or drop the rotation -> which check goes red).

## Parse gate and tests
`python Godot/tools/check_scripts.py scripts/rules/StepRoot.gd tests/step_root_test.gd`;
`$GODOT --headless --path Godot --script tests/step_root_test.gd`. Pure - no LFS. PR body:
`RESULT: tests/step_root_test.gd -> STEP_ROOT failures=0`.

## Owned files
Godot/scripts/rules/StepRoot.gd (new), Godot/tests/step_root_test.gd (new). Nothing else.

## Prior research
FOOTWORK_CONTRACT_S274.md, FOOTWORK_PLAN_S273.md (motion warping +-20 %), StepPicker.gd / StepIntent.gd / FootContacts.gd.

## What would a human do?
A game animator with motion warping: keep the clip's root curve, stretch and turn it a little so the feet land on the
target, and blend the last few centimetres in over a couple of frames - never lerp the body in a straight line.

## Prefab check
Unreal's Motion Warping plugin does this per montage; nothing for Godot 4.7. ~80 lines.

## The one trap
Never replace the root curve with a straight line or a constant speed - the curve IS the realism.

## Contract
OWNS: Godot/scripts/rules/StepRoot.gd, Godot/tests/step_root_test.gd
RED_TEST: Godot/tests/step_root_test.gd -> STEP_ROOT failures=0
REGRESSION: step_root_test
VISUAL: no
