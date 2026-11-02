# TASK_U155 - the octagon is far too small for the fighters, a fighter kicks from outside it, and they clip (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S64 handover, 2026-09-24.

## The operator's words (take one, `research/OPERATOR_WATCH_TAKE1_VERDICT.md`)
> 1. I still seeing clipping ...
> 3. The arena is exremely small you must have done a mistake on your calculation there is no way the analogies of fighters and octagon are correct.
> 4. on 52 second ovf video the red fight is out of the arena kicking

## Part 1 - the scale, in metres, from the rendered scene
Real anchors: UFC octagon 30 ft (9.14 m) across (`RingSpace.gd:21` already says 9.1 m at half_width 4.55);
UFC Apex small cage 25 ft (7.6 m); an MMA fighter 1.70-1.90 m. So the cage is ~5x a fighter's height.
In the live room (seed 92012, MMA, default options - reproduce take one with `tools/record_room.gd` via
`Tools\godot_hidden.ps1`), print: the arena MESH's world AABB across flats (the rendered cage, `ArenaRig.gd`),
`_arena_half_m` and where it came from (`FightWorldLiveScreen.gd:772-774`: `contest` meta minus
`ROPE_BODY_MARGIN_M`, else `FightRealtime.DEFAULT_HALF_WIDTH`), and each fighter's POSED height in world metres
(memory: rigs are not in metres - `FighterPhysique.height_scale()`; measure the posed skeleton head-to-foot,
never the import AABB). Report cage-width / fighter-height against the real ~5. Find which one is wrong (cage
mesh scale, engine half-width, or fighter scale) and fix THAT one so the rendered cage, the engine's bound and
the bodies all agree in metres.

## Part 2 - outside the cage at 52 s
At 52 s of take one the red fighter kicks from outside the fence. Find the frame, print both bodies' hip and
foot positions against the octagon half-planes (`RingSpace.clamp_to_floor`, SHAPE_OCTAGON), and which path
moved the body past the bound (placement, overlap correction, a clip's root motion...). Fix so no hip or foot
leaves the contest area on any frame of the 60 s take.

## Part 3 - clipping
On the same take, count frames where the two bodies interpenetrate beyond 3 cm (your U145/U154 probe) and list
the worst three moments with the clip pair playing. Report only; fix only if it falls out of Parts 1-2.

## Owned files
`scripts/ArenaRig.gd`, `scripts/RingSpace.gd`, `scripts/FightWorldLiveScreen.gd` (bounds/scale/separation only -
Codex C185 edits its playback functions), a new `Godot/tools/u155_scale_probe.gd`, `research/U155_DIGEST.md`,
a re-recorded `research/_captures/watch_loop/take2_u155_seed92012.mp4` and a before/after sheet.

## Gate (tier: scripts edited)
Parse gate; `python Godot/tools/run_tests.py --only ring_space,arena,fight_world,fight_room_no_teleport,fight_metres`.
(`fight_metres` hangs under --jobs; run it alone.) Branch `cursor/u155-arena-scale`, worktree off `origin/master`,
`--headless --import` once first. Commit, push, `python Tools/agent_comms.py send --from cursor --to claude --topic U155 --body "..."` per part.
Do NOT edit HANDOFF.md.
Trap: two numbers that agree with each other can both be wrong - check each against the real 9.1 m and 1.8 m, not against each other.
