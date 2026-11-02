# TASK_U149 - how far apart are the two men NOW, by phase? The instrument S62 gates on (Cursor)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S61, 2026-09-23.

## Why
S62 makes the ENGINE keep a minimum distance, so the room stops shoving overlapping bodies (U147:
overlap runs >3 cm last 0.150 s against a 0.1 s budget; faster room pushes bring teleports back).
Grok's `research/G79_CLOSING_DISTANCE.md` gives the real bands (read its last section only):
punching 0.85-1.10 m COM, hook/uppercut frames 0.55-0.70, clinch lock 0.28-0.40, closing 1.0-2.0 m/s,
boxing 1.23 +- 0.16 m mean stand-off. Before anyone changes the engine we need the SAME number on
the UNCHANGED tree - an instrument run on the old tree first.

## Owned files
`Godot/tools/u149_distance_by_phase.gd` (new), `research/U149_DIGEST.md` (new). Nothing else.

## Do
1. A headless tool (SceneTree script) that mounts `res://scenes/FightWorldLive.tscn` exactly as
   `Godot/tests/fight_room_no_teleport_test.gd` does (configure BEFORE add_child, then `setup`, then
   step `_process(1/60)`), for boxing and MMA, seeds 94301, 810039, 93002 - one round each.
2. Per frame record the two HIPS-bone world positions (horizontal distance, metres), the phase each
   man is in (what the room's readout calls `doing` / the adapter's current beat kind - find it by
   grep in `FightWorldLiveScreen.gd`, do not read the file whole: it is 3,400 lines), and the
   closing speed (d distance / dt).
3. Print per discipline and phase: n frames, p10/p50/p90/min of distance, p90 closing speed, and the
   share of frames below each G79 band floor. Name the population in the output (meshes, seeds,
   discipline). Tripo bodies only (no `fighter_skin`).
## Gate
Tier: new tool file only. `python Godot/tools/check_scripts.py Godot/tools/u149_distance_by_phase.gd`,
then run it once:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/u149_distance_by_phase.gd`.
No suite. The digest carries the table verbatim from the tool's output. Branch
`cursor/u149-distance-by-phase`, one `agent_comms.py send --from cursor --to claude --topic U149`.
Do NOT edit HANDOFF.md.
