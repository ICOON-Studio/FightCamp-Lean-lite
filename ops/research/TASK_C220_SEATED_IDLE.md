# TASK C220 - CODEX - A SEATED IDLE: PEOPLE SITTING AT THE STAFF TABLE AND ON THE LOBBY SOFA (S113)
Owner: codex. Model: gpt-6-astra, medium (spatial: pelvis on a seat, feet on the floor). Assigned 2026-09-27 (S113).
Branch `codex/c220-seated-idle` from `origin/master`, own worktree. Claude merges. HELD: launch when a shell slot frees
(max two agents at once).

## Why
C219 (merged b68e7cbc) gave the rooms a standing-at-ease clip and a lying clip. Every room still has empty chairs and
sofas: D59/D60 called the staff room "spare/empty", and the lobby sofa is where a walk-in waits. A seated clip lets a
coach sit at the staff table and a visitor sit on the lobby sofa.

## What would a human do?
A game animator takes a stock "sitting idle / seated breathing" clip (mocap or library), retargets it to the house
skeleton, checks the pelvis on the seat and the feet on the floor, and loops it. Nobody hand-keys it.

## Prefab check
CMU mocap (free, permissive) has seated subjects - C219's `Godot/assets/anim/boot/c219_source/SOURCE.md` shows the
fetch and bake path you already built (`Godot/tools/c219_bake.gd`); reuse it. Mixamo "Sitting Idle" needs a browser you
do not have. Name clip, source and licence in the digest.

## Build
1. `seated_idle.res` beside `calm_idle.res`, baked the same way; `SEATED_IDLE_CLIP` in `TrainingFloor3D.gd` next to
   `CALM_IDLE_CLIP`.
2. Staff room: the first coach sits at the table on one of its chairs (`StaffRoom3D.gd`, chair positions in its table
   builder); a second coach, if any, stays standing at ease. Lobby: when the week brings a walk-in and the desk is
   staffed, the walk-in sits on the sofa (`Lobby3D.gd`); otherwise unchanged.
3. Measure on TWO DIFFERENT rigs (never identical): pelvis within 0.04 m of the seat top, feet within 0.03 m of the
   floor over the loop, on the POSED skinned mesh in world space. Print achieved beside wanted.
4. Raw sources go to `D:/FightCamp_originals/c220_source` (NOT the repo); only `SOURCE.md` is committed.

## Gate (tier: script edited)
Parse gate on touched `.gd`; then `python Godot/tools/run_tests.py --only staff_room,front_door,office_room,physio_room,
training_floor_3d,locker_room,mat_room,gym_wing`. Renders through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s109_render_staff_room.gd`
(and `s107_render_lobby.gd`); put before/after in `previews/c220/`.

## Owned files
`TrainingFloor3D.gd` (constants only), `StaffRoom3D.gd`, `Lobby3D.gd` (small, read whole), `Godot/tools/c220_*.gd`,
`Godot/assets/anim/boot/seated_idle.res`, `research/C220_DIGEST.md`.

## Deliver
Commit and push AS YOU GO; digest; one line with `python Tools/agent_comms.py send --from codex --to claude --topic C220
--body "..."`. Do NOT edit HANDOFF.md. **Trap:** C219 found `_add_body` lifts every rig 0.925 m - a seated clip that
already carries its seat height floats him; mount on the floor datum as C219 did for the lying clip.
