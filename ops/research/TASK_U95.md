# TASK U95 — CURSOR — BODIES THAT PASS THROUGH EACH OTHER: THE OVERLAP, MEASURED FROM THE MESHES

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u95-overlap` - Claude creates it from `master`
before launch. Push the BRANCH. Stage: S4a (watchability) - an instrument before a fix.

**Test tier: A NEW TOOL FILE ONLY.** Parse gate on your tool (`python Godot/tools/check_scripts.py
Godot/tools/measure_body_overlap.gd`), then run it. No suite, no production script edited.
`python research/U95_check.py` must exit 0 before you commit. ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_body_overlap.gd` - NEW, yours.
- `research/U95_body_overlap.json` - NEW, written by your tool.
- `research/U95_BODY_OVERLAP.md` - NEW, 30 lines at most.

## Why this exists

The operator watched the 3D fight on 2026-09-14 and named "bodies overlap" first: up close the two men pass through
each other. Nothing measures it. The room keeps them 0.80 / 0.95 / 1.10 m apart (POCKET / MID / LONG, labelled
INFERENCE in `FightWorldLiveScreen.gd:79`); elite boxers stand 1.23 +- 0.16 m apart (Schortgen, ECSS 2023, via K29).
Before any distance changes we need the overlap itself: how often, how deep, which body parts, during which takes,
at which gap - and at what gap two men in guard first touch. PHYSICS: two bodies cannot occupy the same space.

## What to read - ONLY these

- `Godot/tests/fight_stage_realism_test.gd` `:64-80` and `:92-165` (`_run_bout`: how the room is built, configured
  and stepped; copy it, the population must be the realism test's), `:34-41` (FPS, SEEDS, ROUNDS, MAX_STEPS).
- `Godot/scripts/FightWorldLiveScreen.gd` `:40-50` (the two meshes), `:159-187` (`configure` options), `:188-240`
  (`setup`, the mount), `:439-455` (`_step_gap`: how bodies are placed).
- `Godot/scripts/FightWorldStage.gd` `:31-80` (`mount`: the MeshInstance3D and Skeleton3D of a fighter).
- `Godot/tools/probe_take_skate.gd` `:112-136` (`_globals`, `_world_of`, `_parent_first`).

## The body model - derived from each mesh, never typed

For each mounted fighter, ONCE, at rest:
1. From its `MeshInstance3D`: every surface's `Mesh.ARRAY_VERTEX`, `ARRAY_BONES`, `ARRAY_WEIGHTS`, and its `Skin`
   (`get_bind_count`, `get_bind_bone` or `get_bind_name` -> skeleton bone, `get_bind_pose`). `ARRAY_BONES` indexes the
   skin's binds. A vertex belongs to the bone of its LARGEST weight. Its rest position in skeleton space is
   `skel.get_bone_global_rest(bone) * skin.get_bind_pose(bind) * vertex`.
2. SEGMENT capsules (bone origin to child origin, rest): Hips-Spine, Spine-Chest, Chest-UpperChest, UpperChest-Neck,
   Neck-Head, Left/RightShoulder-UpperArm, Left/RightUpperArm-LowerArm, Left/RightLowerArm-Hand,
   Left/RightUpperLeg-LowerLeg, Left/RightLowerLeg-Foot, Left/RightFoot-Toes. Each takes the vertices of its FIRST
   bone; radius = the 80th percentile of their distances to the segment.
3. SPHERES for the leaves Head, LeftHand, RightHand: centre = the centroid of that bone's vertices; radius = the 80th
   percentile of their distances to it.
4. Classes: torso (Hips, Spine, Chest, UpperChest capsules), head (Neck capsule, Head sphere), arm (Shoulder, UpperArm,
   LowerArm), hand (Hand sphere), leg (UpperLeg, LowerLeg), foot (Foot).
Posed, per frame: a capsule's ends are the two bones' POSED global origins; a sphere's centre is
`pose_global(bone) * rest_global(bone).affine_inverse() * rest_centre`. Everything to WORLD through `_world_of(skel)`;
radii times the skeleton's world scale.

## What to measure

**A. The bouts.** Two populations, each the realism test's three seeds and rounds, stepped exactly as `_run_bout`:
`realism` (the room's defaults: f01 v f09) and `watch` (`fighter_b_mesh` =
`res://assets/models/fighters/f02_m_box_heavy_rigged.glb`, what `tools/watch_live_room.gd` shows the operator).
Every frame, for every capsule/sphere pair (one from each man): `depth = rA + rB - distance` between the two segments
(`Geometry3D.get_closest_points_between_segments`; a sphere is a zero-length segment). Prefilter pairs with the two
bodies' world AABBs if you must, never by skipping frames. Per population and seed:
- `frames`; `overlap_frames` (frame depth, the max over pairs, above 0.02 m) and `overlap_share`;
- `depth_p50_m`, `depth_p95_m`, `depth_max_m` over the overlap frames;
- `by_class`: for each class pair (`hand>head`, `hand>torso`, `arm>torso`, `arm>head`, `torso=torso`, `head=head`,
  `arm=arm`, `leg=leg`, `foot=foot`, `other`; `x>y` pools both directions) - frames where it is the deepest pair, and
  its depth p95;
- `by_takes`: the ten (A take, B take) pairs with the most overlap frames - frames and depth p95;
- `gap`: node distance p5 / p50 / p95 over all frames and over overlap frames.
- `symmetry_max_abs_diff_m`: on 200 frames spread over the first bout, the frame depth computed A-against-B and
  B-against-A - the largest difference.

**B. The static sweep**, per population's two meshes: the same room mount, bodies facing, both playing `idle` take 0
paused at phase 0, 0.25, 0.5 and 0.75 of the loop, node gap 0.50 to 1.60 m in 0.05 m steps: per gap, the max frame
depth over the four phases, overall and per class pair. Then `first_touch_gap_m` (the largest gap with any depth
> 0.02 m) and `torso_touch_gap_m` (the same for `torso=torso`); `null` when nothing touches even at 0.50 m. `bodies`
is keyed by mesh name without `_rigged.glb` (`f01_m_box_welter`, `f09_m_bare_welter`, `f02_m_box_heavy`).

JSON `res://research/U95_body_overlap.json`:
`{"population": {"seeds": [...], "rounds": 3, "fps": 30, "threshold_m": 0.02, "radius_rule": "p80 of dominant-weight vertices",
   "realism": {"a": "f01_m_box_welter", "b": "f09_m_bare_welter"}, "watch": {"a": "f01_m_box_welter", "b": "f02_m_box_heavy"}},
  "bodies": {"f01_m_box_welter": {"capsules": [{"name": "Hips-Spine", "class": "torso", "radius_m": 0.0, "vertices": 0}, ...]}, ...},
  "bouts": [{"population": "realism", "seed": 94301, "frames": 0, "overlap_frames": 0, "overlap_share": 0.0, "depth_p50_m": 0.0, "depth_p95_m": 0.0, "depth_max_m": 0.0,
    "by_class": {"hand>head": {"frames": 0, "depth_p95_m": 0.0}, ...}, "by_takes": [{"a": "jab", "b": "react_head", "frames": 0, "depth_p95_m": 0.0}, ...],
    "gap": {"all": {"p5": 0.0, "p50": 0.0, "p95": 0.0}, "overlap": {"p5": 0.0, "p50": 0.0, "p95": 0.0}}}, ...],
  "sweep": [{"population": "realism", "gaps": [{"gap_m": 0.5, "depth_m": 0.0, "by_class": {"torso=torso": 0.0, ...}}, ...], "first_touch_gap_m": 0.0, "torso_touch_gap_m": 0.0}, ...],
  "symmetry_max_abs_diff_m": 0.0}`

## The digest `U95_BODY_OVERLAP.md`

Opens with `## DECISIONS`: per population - overlap share, depth p95 and max, the three worst class pairs, the three
worst take pairs; the sweep's first-touch and torso-touch gaps against the room's bands (0.80 / 0.95 / 1.10 m) and the
real 1.23 +- 0.16 m. One line: is the overlap mostly the distance (bodies too close in guard) or mostly the takes
(punches and reactions travelling into the other man)?

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u95-overlap`;
`python Tools/agent_comms.py send --from cursor --to claude --topic U95-ready --body <hash>`. Do not edit HANDOFF.md
or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`, `clean`, `rebase` or `merge`.

## The trap

A body model in the wrong space still produces numbers. The check pins what cannot differ: each seed's frame count
equals the realism test's own run (19802, 19802, 19866); depth computed in either order is the same; in the sweep the
depth never grows as the gap widens and is zero for the torsos at 1.60 m; and radii come out human (a torso capsule
wider than a hand sphere). If Skin binds and ARRAY_BONES disagree in count, stop and report it - never guess a mapping.
