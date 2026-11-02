# TASK Q100 — QWEN — THE FIGHTING MOTIONS RIG: ITS BONES MAPPED TO OURS, AND WHICH FILE IS ITS REST POSE

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q100-fm1-rig` - Claude creates it from `master` before launch. Push the BRANCH.
Stage: S4a (stance takes, the realism test's R2) - forecast measurement.

**Test tier: A NEW TOOL FILE ONLY.** Parse gate on your tool, then run it. No suite, no script edited.
`python research/Q100_check.py` must exit 0 before you commit. ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_fm1_rig.gd` - NEW, yours.
- `research/Q100_fm1_rig.json` - NEW, written by your tool.
- `research/Q100_FM1_RIG.md` - NEW, 25 lines at most.

## Why this exists

The operator ruled (2026-09-13) that the two free Fighting Motions Vol.1 guard holds, `idle_A.fbx` and
`idle_Tiramis.fbx` (`res://assets/anim/audition/magicpot_fm1/`), join our stance rotation. Every clip we play today
is RamsterZ's UE4 mannequin, retargeted through `FightClipRetarget.UE4_TO_OURS` (22 rows) against its reference
T-pose `T_pose.fbx`. Fighting Motions is a different 21-bone rig with different names, and we do not yet know which
of its files holds a usable REST pose. Retargeting needs both: a name map and a rest. This finds them.

## What to read - ONLY these

- `Godot/scripts/FightClipRetarget.gd` (774 lines - never whole): `sed -n '54,77p'` (UE4_TO_OURS: the 22 bones we
  drive, in OUR names), `sed -n '685,774p'` (`_load_fbx`, `_anim_of`, `_index`, `_local_at`, `_globals`, `_to_ours` -
  call them directly from your tool).
- `Godot/tools/probe_take_skate.gd` (136 lines, read whole) - how to bind f01 and read OUR skeleton's rest.

## What the tool measures

For each of `BlueGuy.fbx`, `idle_A.fbx`, `idle_Tiramis.fbx` in `res://assets/anim/audition/magicpot_fm1/`:
load with `FightClipRetarget._load_fbx`. **A file with a mesh imports its bones inside a `Skeleton3D`** (read them with
`get_bone_count`, `get_bone_name`, `get_bone_parent`, `get_bone_rest`); **a mesh-free clip imports them as plain
`Node3D`s** (`_index`). Handle both. Per file, list every bone: `name`, `parent`, `local_origin`, `global_origin`
(composed from the file's own hierarchy - the REST, `_local_at(index, null, 0.0)` for Node3D bones).

**The map**: for each of OUR 22 bone names (the VALUES of UE4_TO_OURS), the Fighting Motions bone name, by these rules
in order - (1) the bone names contain the same body part and side (e.g. `Hips`/`pelvis`, `LeftUpperArm`/`upperarm_l`/
`L_UpperArm`/`Arm_L`); (2) where names are ambiguous, the hierarchy decides (a thigh is a child of the pelvis, a calf
of the thigh, a toe of the foot). Record `method` per row: `"name"` or `"hierarchy"`. If one of our 22 has NO bone,
map it to `""` and say so - do not force a match.

**The rest pose angles**, for each file AND for OUR f01 skeleton rest (`get_bone_global_rest`), from global origins:
`shoulder_abduction_deg` (left and right, R108's definition: the angle between the UPPER-SPINE direction
Chest->UpperChest and the upper-arm direction UpperArm->LowerArm, so 90 is a T-pose and ~180 is arms at the sides),
`elbow_flex_deg` (angle between upper arm and forearm directions, 0 = straight),
`knee_flex_deg` (thigh v shin, 0 = straight), `hips_height_m` (hips y minus the lower toe's y). Use the MAPPED bones.

JSON `res://research/Q100_fm1_rig.json`:
`{"files": {"BlueGuy.fbx": {"kind": "skeleton"|"nodes", "bones": [{"name": "", "parent": "", "local_origin": [x,y,z],
   "global_origin": [x,y,z]}], "rest_angles": {...}}, "idle_A.fbx": {...}, "idle_Tiramis.fbx": {...}},
  "ours": {"fighter": "f01_m_box_welter", "rest_angles": {"shoulder_abduction_deg_l": 0.0, "shoulder_abduction_deg_r": 0.0,
   "elbow_flex_deg_l": 0.0, "elbow_flex_deg_r": 0.0, "knee_flex_deg_l": 0.0, "knee_flex_deg_r": 0.0, "hips_height_m": 0.0}},
  "map": [{"ours": "Hips", "fm1": "", "method": "name"}],
  "rest_file": "<the file whose rest is a T-pose closest to ours, or \"\" if none is>"}`
(each file's `rest_angles` uses the same seven keys).

## The digest `Q100_FM1_RIG.md`

Opens with `## DECISIONS`. The 22-row map as a table; the rest angles of the three files and ours; one line naming the
rest file (or saying none is a T-pose, and what the closest is).

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q100-fm1-rig`;
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q100 ready" --body "<hash>"`. Do not edit HANDOFF.md.
Never `git stash`, `reset`, `checkout .`, `clean`, `rebase` or `merge`.

## The trap

A clip file's hierarchy is NOT always the rig's rest: its nodes may hold the first animation frame, not a T-pose. So
MEASURE the angles for all three files, never assume BlueGuy is the rest because it has the mesh. And OUR f01 rest is an
anchor from an older instrument: R108 measured f01's shoulder abduction at 92.1 deg - the check holds you to it.
