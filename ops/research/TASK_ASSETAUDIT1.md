# TASK ASSETAUDIT1 part A - list every model the gym loads and the newest model we own of the same object (S243)

Operator S242: "make sure the assets you are using are up to date" (after the double-end bags were a self-built cord-and-ball while a
real GYMPACK model sat on disk - fixed 65cc7b68). Discipline: BOXING (demo). Seat: Cline (cloud, label `cline`). Model: Cline default.
Part B (the swaps + iso stills) is Claude's after this lands - stills need the PC's GPU.

## Deliverable (one PR, branch cline/assetaudit1)
1. NEW `Tools/asset_audit.py` (pure Python 3, stdlib only): collects every `res://...glb|gltf|fbx|tscn` path the gym loads from
   - `Godot/assets/data/gym_club.json` and `Godot/assets/data/gym_hall.json` (walk the whole JSON, any string ending in a model ext),
   - string literals in `Godot/scripts/club_rooms/*.gd`, `Godot/scripts/club_look/*.gd`, `Godot/scripts/club_zones/*.gd`,
     `Godot/scripts/GymClub3D.gd`, `Godot/scripts/GymHall3D.gd` (regex `res://[^"']+\.(glb|gltf|fbx|tscn)`),
   - and every self-built prop: a `_box(`/`BoxMesh`/`CylinderMesh` call in those scripts whose node name names a real object
     (bag, rack, bench, ring, mirror, clock, timer, sign, locker, desk, chair, table, rope, mat, dumbbell, kettlebell, treadmill, bike).
   For each object it searches `Godot/assets/models/**` for other model files whose file name shares the object word(s) and prints
   them with the date of their newest commit (`git log -1 --format=%cs -- <file>`) and their folder (props/gym_pack = GYMPACK 10-11,
   props/gym, rooms, office, reception, kit, kenney, c78floor, gymlook3b).
2. NEW `research/ASSETAUDIT1_INVENTORY.md`, written by the script (`python Tools/asset_audit.py > ...`): one table row per object -
   object | what the gym loads now (path or "self-built: script:line") | its commit date | newer/better candidates (path, date, folder)
   | verdict: KEEP (already newest) / SWAP (name the candidate) / CHECK (two candidates or unsure) - SWAP only when the candidate is the
   same object and newer.
3. NEW `Tools/test_asset_audit.py` (unittest, stdlib): a fake tree in a temp dir with gym_club.json naming `res://assets/models/a/bag_old.glb`,
   a newer `assets/models/gym_pack/bag.glb` and a script with `_box(... "Clock" ...)`; asserts the bag row says SWAP -> gym_pack/bag.glb
   and the clock row says self-built. Pass line: `ASSET_AUDIT_TEST ok`.
No .gd, .json, .tscn or model file changes. Git LFS is not in CI: read paths and git dates only, never open a .glb.

## Gates
- `python Tools/test_asset_audit.py` -> `ASSET_AUDIT_TEST ok`.
- `python Tools/asset_audit.py` runs clean on the real repo; the inventory lists at least the double-end bag as already on
  props/gym_pack/double_end_bag.glb (KEEP) - the known-good row.
- PR body: `RESULT: Tools/test_asset_audit.py -> ASSET_AUDIT_TEST ok` and the inventory's row count.

## Prior research
research/TWOPOINT_ALIGNMENT.md (operator S244: every agent aligned with Two Point Museum perspective + per-room items).
S242_DIGEST.md (double-end bag swap 65cc7b68, "NOT done yet: the same check for EVERY model the gym loads"); GYMPACK 10-11 pack in
props/gym_pack; Ludo r94 kit (props/gym).

## What would a human do?
Open the asset folder beside the level, list what the level references, sort by date, swap the stale ones.

## Prefab check
Tooling over our own files - no asset to buy.

## The one trap
Self-built props (BoxMesh stand-ins) do not appear as paths - grep the builder calls too, or the audit misses exactly the case that
started this task.
