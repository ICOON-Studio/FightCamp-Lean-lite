# TASK_U146 - no body teleports (Cursor)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S60, 2026-09-23.

## Why
Operator: *"can you make the animation smother it is very abrapt"*. U145 measured it
(`research/U145_DIGEST.md`, probe `Godot/tools/u145_transition_probe.gd`): it is NOT the
frame rate (0 transitions missed at 30 fps) and NOT mainly blend length (2x blends or
inertialization: 75 -> 71 body jumps). It is BODIES TELEPORTING: ~73 jumps a boxing round
(> 0.10 m or > 15 deg in one 1/60 s frame), MMA 45-61. Claude re-ran the probe with the named
writers (`U145_BODY_WRITE`):
1. `FightWorldLiveScreen._place_bodies` -> `_floor_clamped` -> `_refused_overlap_depth`: when the
   meshes overlap, the pair is pushed apart by the WHOLE depth in one frame, up to ~0.5 m
   (e.g. frame 1551: placed.x 0.758 -> 1.271 while the engine gap only moved 0.595 -> 0.621).
2. Paired grapple presentation (`_update_grapple` / PairedClipMount): at pair start both bodies
   snap to the authored mount, up to 0.65 m and 33 deg (frame 6280, BodyLock_Loop).
Claude tried rate-limiting the engine-gap handoff in `_read_track`; it changed NOTHING (jumps
stayed 73) and was reverted - that is not the writer. Do not repeat it.

## Owned files
- `Godot/scripts/FightWorldLiveScreen.gd` - ONLY `_floor_clamped` / `_refused_overlap_depth`
  callers and the pair/grapple mount entry (grep them). ~3,000 lines: never read it whole.
- `Godot/tests/fight_room_no_teleport_test.gd` (NEW), `research/U146_DIGEST.md` (NEW).

## Spec
1. Overlap refusal must not teleport: carry a per-pair push state that EASES toward the required
   separation at a capped speed (start at 2.5 m/s - footwork speed - and report what you chose),
   and holds it while the overlap persists, decaying when it clears. Bodies must still not
   interpenetrate beyond today's floor: measure the max refused-overlap depth rendered per round
   BEFORE and AFTER and report both - a smoother picture that lets torsos pass through is a
   regression (the operator has rejected overlapping bodies before).
2. Pair/grapple start: blend both bodies from where they stand to the authored mount over
   0.20-0.30 s (position + yaw) instead of snapping. Pair END likewise.
3. Nothing about the engine changes: the seeded beat list must be byte-identical before/after.

## Gate
- Run the probe BEFORE your change and AFTER (same seed 94301, arm A; windowed through
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 1280x720 --script tools/u145_transition_probe.gd -- stills=off`).
  Print body jumps per round for boxing and MMA before/after. Target: boxing <= 10, MMA <= 15
  (a CEILING - lower is better; if you land lower say so).
- Max rendered overlap depth per round: after <= before + 0.01 m.
- New test: over one boxing round, no body node moves > 0.10 m or turns > 15 deg in one 1/60 s
  frame except at the bell; beat list identical to a run with the easing switched off.
- `run_tests.py --only room`, `--only world`, `--only grapple`; `tests/fight_room_ring_bounds_test.gd`;
  `tests/fight_room_walkout_test.gd`. No full suite.
- Branch `cursor/u146-no-teleports`, digest with the before/after table, one
  `python Tools/agent_comms.py send --from cursor --to claude --topic U146 --body "..."`. Do NOT edit HANDOFF.md.

## Trap
The push exists for a reason. Easing it lets bodies overlap for a few frames - measure that, and
if the overlap budget is broken, shorten the ease rather than keep the smoothness.
