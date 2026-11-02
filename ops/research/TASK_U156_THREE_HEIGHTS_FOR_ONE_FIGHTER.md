# TASK_U156 - one fighter, three heights: engine 1.78, render 1.74/1.82, probe 1.49 - settle it (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S65, 2026-09-24.

## The disagreement (all on seed 92012, MMA, live room, merged to master in S65)
- Engine: both demo fighters carry `height_cm` 178 (C185 digest line 9).
- Codex C185: rendered heights **1.74 m** (A, `f05_m_mma_light_rigged.glb`) and **1.82 m** (B, `f06_m_mma_lhw_rigged.glb`).
- Your U155 probe (`tools/u155_scale_probe.gd` `_posed_height_m`): **1.489 / 1.496 m** posed in the room.
Real MMA fighters are 1.70-1.90 m. The operator said the cage looked far too small for the fighters; U155 fixed
the cage (9.144 m UFC). Before anyone "fixes" fighter scale, find out which of the three numbers is the truth.

## Part 1 - one definition, three reads, printed side by side
Define STATURE as the standing height a tape measure gives: sole to the TOP of the head (not the Head bone,
which sits ~0.15-0.20 m below the crown), in world metres, with every parent transform applied
(memory: rigs are not in metres - `FighterPhysique.height_scale()`; measure the posed thing, not the import AABB;
headless `get_bone_global_pose()` returns REST - compose from `get_bone_pose`). For each fighter print:
(a) engine `height_cm`; (b) the target height the room passed to `FighterPhysique.describe()` /
`height_scale()` and WHERE it came from (the fighter's own height, or `reference_height_m(limit_kg)` - a
class average); (c) stature in the REST pose at the applied scale; (d) Head-bone height and crown height in the
live fighting stance at 5 s. Then say which of 1.74/1.82 and 1.49 each read was measuring.

## Part 2 - fix only what is wrong
If the render ignores the engine's own `height_cm` (e.g. falls back to the class reference), make the room scale
each mesh to its fighter's `height_cm`, so rest-pose stature = engine height within 1 cm for both. If the 1.49 m
is only a crouched stance measured to the Head bone, correct the probe's definition and say so - do not rescale.
Print cage flat-to-flat / mean stature against the real ~5 (9.14 / 1.8) after the fix.

## Part 3 - the demo pair shares a frame
Both demo fighters are 178 cm in the engine. Standing rule (CLAUDE.md, NEVER TEST IDENTICAL FIGHTERS): the same
physical frame is an identical fixture. Report where the demo pair's heights are set and give the grappler
and the striker distinct, realistic statures for their classes (e.g. 1.75 / 1.85 m). Name the population in
the probe output.

## Owned files
`scripts/FighterPhysique.gd`, `scripts/FightWorldLiveScreen.gd` (fighter mounting / SCALE functions only - Codex
C186 edits its playback/hand functions; keep to yours), the demo-pair definition wherever Part 3 finds it,
`Godot/tools/u155_scale_probe.gd`, a new `Godot/tools/u156_stature_probe.gd`, `research/U156_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; then
`python Godot/tools/run_tests.py --only physique,arena,fight_world,fight_room,fight_metres` (`fight_metres` hangs
under --jobs - run it alone before believing it).
Any windowed Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`.
Branch `cursor/u156-stature`, worktree off `origin/master`, `--headless --import` once first. Commit, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U156 --body "..."` per part. Do NOT edit HANDOFF.md.
`FightWorldLiveScreen.gd` is ~3,500 lines - never open it whole; grep, then `sed -n 'A,Bp'` windows.
Trap: two numbers that agree with each other can both be wrong - check each against a tape measure (1.70-1.90 m).
