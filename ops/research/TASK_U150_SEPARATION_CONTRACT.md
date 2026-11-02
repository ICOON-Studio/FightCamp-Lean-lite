# TASK_U150 - the BLIND contract test for `FightSeparation` (Cursor)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S62, 2026-09-24.

## Why
S62 gave the ENGINE a minimum hips-to-hips distance (`Godot/scripts/FightSeparation.gd`, a pure
module with zero preloads) so the room stops shoving overlapping bodies. Claude wrote the module and
its own test; a test written against an implementation only ever agrees with it. U148 proved the
point last session: the blind test found a zero pose read that the author's 17-check test could
not. So this test is written from the CONTRACT below and NOTHING else.

**YOU ARE FORBIDDEN TO OPEN `Godot/scripts/FightSeparation.gd`, `Godot/tests/fight_separation_test.gd`
or `Godot/scripts/FightRealtime.gd`.** Do not grep them. Everything you may know is in this file.

## The contract (verbatim from the module's header; the ONLY spec)
Static functions on the script at `res://scripts/FightSeparation.gd` (load it with `load()`):

- `kind_for(stance: String, phase_a: String, phase_b: String) -> String` returns one of
  `"ground"`, `"clinch"`, `"engage"`, `"reset"`. Stance `"ground"` always wins; stance `"clinch"`
  is next; otherwise if EITHER phase is `"engage"` the kind is `"engage"`; anything else (`"reset"`,
  `"measure"`, `""`) is `"reset"`.
- `floor_m(kind: String, mean_arm_m: float, reference_arm_m: float) -> float` is the G79 lower
  edge for the kind - ground 0.0, clinch 0.28, engage 0.55, reset 0.85 metres - multiplied by
  `mean_arm_m / reference_arm_m`. A non-positive or non-finite arm on either side means scale 1.0.
  An unknown kind is 0.0.
- `resolve(a: Vector2, b: Vector2, floor: float, dt: float) -> Dictionary` with keys `"a"`, `"b"`
  (Vector2), `"pushed"` (bool), `"push_m"` (float, total push across both men), `"axis"`
  (Vector2, unit from a to b), `"deficit_m"` (float, `max(0, floor - |b-a|)`). The push is
  `min(deficit, 2.5 * dt)`, HALF to each man, `a` moved against the axis and `b` along it, so
  the new gap is exactly `old_gap + push_m`. A push at or under 0.0005 m is NOT written
  (`pushed` false, `push_m` 0.0, positions returned unchanged). Coincident men (`a == b`) use
  axis `Vector2.RIGHT`. Positions are returned UNCLAMPED (the caller owns the ring wall).
- `strip_inward(velocity: Vector2, toward_other: Vector2) -> Vector2` removes the component of
  `velocity` along `toward_other` when that component is positive; a velocity pointing away or
  sideways is returned unchanged; a zero `toward_other` returns `velocity` unchanged.
- Constants readable on the script: `PUSH_CAP_MPS` (2.5), `REFERENCE_REACH_CM` (180.0),
  `EPSILON_M` (0.0005), `FLOOR_M` (Dictionary kind -> metres), `KINDS` (Array of the four kinds).
- The module takes NO random draw anywhere: the same inputs give the same outputs.

## Owned files
`Godot/tests/fight_separation_contract_test.gd` (new), `research/U150_DIGEST.md` (new).
Nothing else. Do NOT touch `fight_separation_test.gd` (Claude's) or any script.

## Do
1. `extends SceneTree`, `_initialize()`, `load()` the module, one `_check(ok, label)` counter,
   and end with ONE line `TOTAL=<checks> fails=<fails>` then `quit(1 if fails > 0 else 0)`.
   Mirror `Godot/tests/ground_graph_contract_test.gd`'s shape (you MAY read that file).
2. Cover every clause above with at least one check, including the boundaries: push exactly at
   the cap, deficit exactly zero, a deficit of exactly 0.0005 (not written) and 0.0006 (written),
   `a == b`, scale by a doubled arm, negative and NaN arms, an unknown kind, `dt` 0 and negative
   (push 0), and that `|new_b - new_a| == old_gap + push_m` to 1e-6 for several non-axis-aligned
   pairs.
3. MUTANTS, in the digest as a table: with `--` args `mutant=<name>` your test loads a STUB you
   write inline (a Dictionary of Callables or a small inner class) instead of the module, one
   per mutant: (a) push not halved (whole push to `b`), (b) cap read as 2.5 per tick not per
   second, (c) clinch floor 0.40 (upper edge), (d) `kind_for` ignoring stance ground, (e)
   `strip_inward` also removing the outward component. Every mutant must be CAUGHT (fails > 0).
   `feedback_prove_contract_tests_with_mutants`: a green test that catches no mutant proves nothing.

## Gate
Tier: NEW test file only, no script edited. `python Godot/tools/check_scripts.py
Godot/tests/fight_separation_contract_test.gd`, then
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_separation_contract_test.gd`
must print `TOTAL=N fails=0`, and each mutant run must print `fails>0`. No suite.
Branch `cursor/u150-separation-contract`, one
`python Tools/agent_comms.py send --from cursor --to claude --topic U150 --body "<one line: TOTAL, fails, mutants caught N/5, any clause the module FAILS>"`.
Do NOT edit HANDOFF.md. If the module fails a clause, that is the finding - report it, do not
soften the test to pass.

## FULL BRANCH (operator, 2026-09-24: "assign full branch deliveries not small tasks")
The blind test above is PART 1 and is delivered FIRST, before you read any engine file. Then, on the
SAME branch, two more parts - and once Part 1 is committed the read ban is lifted for Parts 2-3.

### Part 2 - the room's no-teleport gate, with the engine floor ON
`Godot/tests/fight_room_no_teleport_test.gd` fails by ONE jump (>0.10 m or >15 deg in a 1/60 s
frame, boxing seed 94301) since the engine floor landed - it passed at U146. The engine now pushes
the two men apart at up to 2.5 m/s total (0.125 m per 20 Hz tick, half each); the room's own
overlap easing (U146, `FightWorldLiveScreen.gd`, `OVERLAP_SEP_MPS` / `RENDERED_GAP_MAX_STEP_M`) is
still layered on top of it. Find the one frame (extend the test's `_count_jump` to PRINT frame,
body, metres and degrees when it fires - keep that print), name the cause, and fix it on the ROOM
side behind a switch that defaults ON: the likely shape is that the room should not ease a gap the
engine is already opening (read the engine's push from the track sample rather than re-deriving
it), or the track interpolation should spread a 20 Hz step across its three 60 Hz frames. Do NOT
touch `FightRealtime.gd` or `FightSeparation.gd`. Gate: `run_tests.py --only fight_room,fight_world,grapple`
green, `fight_room_no_teleport` green, boxing and MMA.

### Part 3 - the AFTER table
Re-run `Godot/tools/u149_distance_by_phase.gd` (yours, headless, ~6 min) on the tree with Parts 1-2
and append the AFTER table to `research/U149_DIGEST.md` beside the BEFORE, with the deltas
per phase: engage p10 must now sit at or above 0.55 m x (mean arm / reference arm), reset/measure
p10 at or above 0.85 x the same, and the share below the G79 punch floor in engage is the number the
operator reads. Say plainly if anything is worse.

Owned files widen for Parts 2-3 to: `Godot/scripts/FightWorldLiveScreen.gd` (3,400 lines - windows
only: grep `OVERLAP_SEP\|RENDERED_GAP\|_step_gap\|_refuse_overlap\|_target_gap` and read those
functions), `Godot/tests/fight_room_no_teleport_test.gd`, `research/U149_DIGEST.md`. One
digest for the branch (`U150_DIGEST.md`, three sections). One `send` per part landed.
