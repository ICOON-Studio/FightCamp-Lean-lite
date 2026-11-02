# TASK U92 — CURSOR — WHEN WAS THE REAL FOOT PLANTED? THE PLANT CENSUS: SOURCE MOCAP AGAINST OUR RETARGET

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u92-plant-census` - Claude creates it from `master`
before launch. Push the BRANCH. Stage: S4a (the foot lock) - forecast measurement.

**Test tier: A NEW TOOL FILE ONLY.** Parse gate on your tool, then run it. No test suite, no script edited.
`python research/U92_check.py` must exit 0 before you commit. ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_plant_census.gd` - NEW, yours.
- `research/U92_plant_census.json` - NEW, written by your tool.
- `research/U92_PLANT_CENSUS.md` - NEW, 25 lines at most.

## Why this exists

Claude is building a FOOT LOCK: while a foot should be planted, it is pinned where it landed. It needs, per take and
per foot, the frames the foot SHOULD be planted. Two ways to know: detect plants on OUR retargeted take's toe path, or
on the SOURCE mocap's toe path (the real actor's foot, before our retarget dropped any hip travel). Where our toe
slides but the actor's did not, only the source knows. This census measures how far the two disagree, with two
thresholds, so the lock's detector is chosen from numbers.

## What to read - ONLY these

- `Godot/tools/probe_take_skate.gd` (136 lines, read whole): bind f01 through FightStagePlayer as the room does, play
  one take alone with the node still, compose bone positions from `get_bone_pose`, `_world_of`.
- `Godot/scripts/FightFootContacts.gd` (86 lines, read whole): `planted_intervals(positions, fps, floor_y,
  enter_speed_mps, enter_height_m, exit_ratio, min_frames)`.
- `Godot/scripts/FightClipRetarget.gd` (774 lines - never whole): `sed -n '398,470p'` (FLOOR_BONES, `hip_carry` ->
  `scale`), `sed -n '483,575p'` (`sway_of`, `_source_frames` - copy its window and sample-count rules EXACTLY),
  `sed -n '685,774p'` (`_load_fbx`, `_anim_of`, `_index`, `_local_at`, `_globals`, `_to_ours`). Call these statics
  directly from your tool (`FightClipRetarget._local_at(...)` works); do not edit the file.
- `Godot/scripts/FightClipBinding.gd`: `grep -n '"retarget"\|"mirror"\|"variants"\|"loop"' Godot/scripts/FightClipBinding.gd`
  and `sed -n '732,760p'` (`metadata_for`).

## What the tool measures

Bind f01 (`res://assets/models/fighters/f01_m_box_welter_rigged.glb`, boxing arena, node still) exactly as the probe
does. For EVERY animation the player holds whose role (`name.get_slice("#", 0)`) has `retarget: true` in its metadata,
take i of the role = `variants[i]` (or the role's own path/start_s/end_s when it has no variants), and for EACH foot
(`LeftToes`, `RightToes`), at 30 fps:

- `ours`: the take played alone (`ap.play(name, 0.0, 1.0)`, `seek(0.0, true)`, then `advance(1/30)` per frame), the
  toe's WORLD position `_world_of(skel) * global.origin`; `frames = ceili(anim.length * 30) + 1`. Floor = the lower
  toe's global REST height carried through `_world_of(skel)` (as R3 does).
- `source`: the take's FBX, same window rules and `samples` count as `_source_frames`, each sample
  `FightClipRetarget._to_ours(_globals(index, _local_at(index, clip, t)), FightClipRetarget.UE4_TO_OURS)`, the toe's
  `origin`. **A mirrored role reads the OTHER source foot** (our LeftToes <- source RightToes). Scale to our body:
  multiply every source position by `hip_carry(reference, skel, UE4_TO_OURS)["scale"]` and then by the skeleton's world
  scale `_world_of(skel).basis.get_scale().x`. Source floor = the lower of the REFERENCE T-pose's `LeftToes` /
  `RightToes` origin y (`_local_at(ref_index, null, 0.0)`), scaled the same way. Truncate both paths to the shorter.
- Three detectors, all `FightFootContacts.planted_intervals` at fps 30:
  `source` (defaults: 0.15 m/s, 0.06 m), `ours_c114` (defaults), `ours_ue` (0.60 m/s, 0.10 m - Unreal Engine 5.8's
  shipped Foot Placement defaults, SpeedThreshold 60 cm/s and DistanceToGround 10 cm, DOCUMENTED in
  `AnimationWarping/Source/Runtime/Public/BoneControllers/AnimNode_FootPlacement.h`). Expand intervals to per-frame
  booleans.

JSON `res://research/U92_plant_census.json`:
```
{"population": {"fighter": "f01_m_box_welter", "binding": "boxing", "node": "still", "fps": 30,
   "detectors": {"source": [0.15, 0.06], "ours_c114": [0.15, 0.06], "ours_ue": [0.60, 0.10]},
   "carry_scale": 0.0, "world_scale": 0.0},
 "rows": [{"take": "hook_rear", "role": "hook_rear", "foot": "LeftToes", "source_bone": "RightToes",
   "mirrored": true, "loops": false, "walk": false, "frames": 31,
   "source_planted": 0, "ours_c114_planted": 0, "ours_ue_planted": 0,
   "c114_both": 0, "c114_iou": 0.0, "ue_both": 0, "ue_iou": 0.0,
   "ours_speed_in_source_plants_p50": 0.0, "ours_speed_in_source_plants_p95": 0.0,
   "source_speed_in_source_plants_p95": 0.0,
   "source_min_height_m": 0.0, "ours_min_height_m": 0.0,
   "source_hips_net_m": 0.0, "source_hips_max_m": 0.0}],
 "summary": {"non_walk": {"frames": 0, "source_planted": 0, "c114_both": 0, "c114_iou": 0.0, "ue_both": 0,
   "ue_iou": 0.0, "ours_speed_in_source_plants_p50": 0.0, "ours_speed_in_source_plants_p95": 0.0},
   "walk": {...same keys...}}}
```
`iou = both / (a + b - both)`, and 1.0 when `a + b == 0`. `walk` = role begins with `loc_`. Speeds: horizontal
(`Vector2(dx, dz).length() * 30`), first frame takes the second's. `*_min_height_m` = min over frames of toe y minus
its floor. `source_hips_*` = `FightClipRetarget.sway_of(path, UE4_TO_OURS, 30.0, start_s, end_s)` net_m / max_m times
carry_scale. Summary rows pool frames over rows (IoU from the pooled counts, speeds as p50/p95 of the pooled samples).

## The digest `U92_PLANT_CENSUS.md`

Opens with `## DECISIONS`. One line: which of `ours_c114` / `ours_ue` agrees better with `source` on non-walk takes
(pooled IoU, both numbers). A table of the SIX non-walk rows with the highest `ours_speed_in_source_plants_p50`: take,
foot, source_planted, c114_iou, ue_iou, ours speed p50/p95. One line on the walks.

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u92-plant-census`;
`python Tools/agent_comms.py send --from cursor --to claude --topic "U92 ready" --body "<hash>"`. Do not edit
HANDOFF.md or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`, `clean`, `rebase` or `merge`.

## The trap

Units and floors. A source read in the wrong scale or against the wrong floor makes every foot airborne (no plants) or
buried. The idle take is a guard hold with both feet down: both feet must read planted on at least 90% of its frames
in BOTH `source` and `ours_c114`, and no toe may sit far under its floor - the check tests exactly this.
