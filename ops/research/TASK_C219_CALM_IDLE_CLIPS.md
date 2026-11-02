# TASK C219 - CODEX - CALM IDLE CLIPS FOR THE ROOMS: STANDING AT EASE, AND LYING ON THE TABLE (S112)
Owner: codex. Model: gpt-6-astra, medium (spatial: pose, contact with a table top). Assigned 2026-09-27 (S112).
Branch `codex/c219-calm-idle` from `origin/master`, own worktree. Claude merges. HELD: launch when a shell slot
frees (max two agents at once).

## Why
Every body drawn in the six rooms plays `IDLE_CLIP` (`TrainingFloor3D.gd:29`, `res://assets/anim/boot/idle_f01.res`),
which is a FIGHT GUARD. The coach at the staff-room table, the owner at his desk and the desk hand in the lobby all
stand with their hands up, and the physio room shows no patient at all because a guard on a treatment table read as
"waiting to spar" (S111, D58; `PhysioRoom3D.gd` `_build_patient`). The rooms need two calm clips on our rigs.

## What would a human do?
A game animator takes a stock "standing idle / relaxed breathing" and a "lying on back, breathing" clip (mocap or a
library), retargets each once to the house skeleton, checks feet on the floor and the back on the surface, and loops
them. Nobody hand-keys an idle.

## Prefab check
Mixamo "Idle", "Breathing Idle", "Standing Idle" and "Laying Idle" / "Lying Down" (free with an Adobe login; the
browser pane is signed in - S82 used it for `assets/anim/mixamo_audition/`). CMU mocap (free, permissive) as a
fallback. Name the clip, its source and licence in the digest.

## Build
1. Two clips on the f01 rig, baked like the station clips beside `IDLE_CLIP` (same bone naming, hips at the rig
   origin): `calm_idle` (standing at ease, arms down, a slow weight shift) and `lying_idle` (on the back, breathing).
2. Add `CALM_IDLE_CLIP` and `LYING_IDLE_CLIP` constants in `TrainingFloor3D.gd` next to `IDLE_CLIP`, and an optional
   clip argument on `_add_body` so a room can ask for one; default stays `IDLE_CLIP` (the floor is unchanged).
3. Use `CALM_IDLE_CLIP` in Office3D (owner), StaffRoom3D (coaches), Lobby3D (desk hand); put the worst-shape fighter
   back on the physio table with `LYING_IDLE_CLIP` (pad top 0.78 m, `PhysioRoom3D.gd` `_build_table`).
4. Measure it on TWO DIFFERENT rigs (never identical): feet within 0.03 m of the floor over the loop for the standing
   clip; the back within 0.05 m of the pad for the lying one. Print achieved beside wanted.

## Gate
Parse gate on touched `.gd`; `python Godot/tools/run_tests.py --jobs 2 --only office_room,staff_room,physio_room,front_door,training_floor`
green. Render the four rooms with `tools/s105_render_office.gd`, `s107_render_lobby.gd`, `s109_render_staff_room.gd`,
`s110_render_physio.gd`, run hidden:
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/<render>.gd`.

## Owned files
`Godot/assets/anim/boot/` (new clips only), `TrainingFloor3D.gd` (the constants + the `_add_body` argument only -
~1,550 lines, never open it whole; `sed -n` around `:29` and `_add_body`), the `_add_body` call sites in the four
rooms, `Godot/tools/c219_*.gd`, `research/C219_DIGEST.md`.

## Deliver
Commit and push as you go; digest with the before/after renders; one line with
`python Tools/agent_comms.py send --from codex --to claude --topic C219 --body "..."`. Do NOT edit HANDOFF.md.
Trap: the idle's hips sit at the rig origin and bodies are lifted 0.925 m (S84 rigs) - a lying clip baked the same way
will float or sink by that lift; measure the posed mesh, not the rest box.
