# Q29 DIGEST — the clip graft is one module now

**Agent:** qwen  **Date:** 2026-09-10  **Task:** TASK_Q29.md

## What landed

`Godot/scripts/BoneTrackGraft.gd` — statics-only module, zero preloads.
One function: `graft(source, skel, skel_path) -> Dictionary`.
Returns `{"animation", "matched", "unmatched"}`.
Splits on `:` first, then `/` — an already-grafted track (`Skeleton3D:Chest`)
extracts `"Skeleton3D"` as the bone name, which does not match, so the track
is left alone. No `Skeleton3D:Skeleton3D:Chest` is ever produced.

## Callers replaced

- `Godot/tools/probe_anim.gd` — 14-line inline loop → 4-line call
- `Godot/tests/fight_world_anim_test.gd` — 12-line inline loop → 4-line call

## Test

`Godot/tests/bone_track_graft_test.gd` — 17 checks, 0 fails.
Covers: happy path (5/5 matched), unmatched bone (LeftClavicle reported,
not silently dropped), source Animation unchanged after graft, re-graft
safety (no double prefix), empty animation (no crash).

## Gates

- parse: 4/4 pass
- bone_track_graft_test: TOTAL=17 fails=0
- fight_world_anim_test: TOTAL=23 fails=0 (unchanged)

## Not touched

FightRealtime.gd (Cursor), combat_rulesets.json (Codex), HANDOFF.md,
any .glb, any pin file.
