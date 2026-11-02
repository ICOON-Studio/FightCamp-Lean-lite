# TASK U94 — CURSOR — THE REAR HOOK FROM A SKELETON-SPACE UPPER MIRROR: THE CHEST TURNS LIKE THE MIRROR, THE FEET STAY IDLE'S

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u94-hook-global` - Claude creates it from `master`
before launch. Push the BRANCH. Stage: S4a (transitions) - measurement before a build.

**Test tier: A NEW TOOL FILE ONLY.** Parse gate on your tool (`python Godot/tools/check_scripts.py
Godot/tools/measure_hook_global.gd`), then run it. No suite, no production script edited.
`python research/U94_check.py` must exit 0 before you commit. ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_hook_global.gd` - NEW, yours. Copy any helper you need from `measure_hook_splice.gd`; do NOT edit that file.
- `research/U94_hook_global.json` - NEW, written by your tool.
- `research/U94_HOOK_GLOBAL.md` - NEW, 30 lines at most.

## Why this exists

Your U93 (`research/U93_HOOK_SPLICE.md`) showed that copying hook_rear's upper-body LOCAL tracks over idle's
hips and legs keeps idle's stance (skate 0.325 -> 0.014 m/s) but turns the Chest 128 deg away from the mirror and
throws the fist 1.2 m off: a local rotation under a differently oriented pelvis is a different pose. The fix to test:
keep the mirror's Chest orientation in SKELETON space and let the Spine absorb the difference between the two pelvises.
Three ways to do that, measured against your two U93 rows, on f01, before anything is bound.

## What to read - ONLY these

- `Godot/tools/measure_hook_splice.gd` (412 lines, yours): setup `:36-90`, `_splice_idle_upper` `:120`,
  `_copy_track` `:149`, `_resample_track` `:164`, `_measure_variant` `:178`, `_stance_at` `:281`, `_pose_at` `:289`,
  `_entry_pose_deg` `:296`, `_basis_angle_deg` `:308`, `_horiz_yaw_deg` `:315`, `_foot_metrics` `:321`,
  `_globals` `:379`, `_world_of` `:389`, `_parent_first` `:399`.
- `research/U93_hook_splice.json` (read whole) - the numbers your first two rows must reproduce.

## The variants (all length = hook_rear's, 30 frames, one key per 1/30 s)

Notation, per frame f: `Gi_P(f)` = the skeleton-space ROTATION (quaternion of the orthonormalized basis from
`_globals`) of `P = skel.get_bone_parent(Spine)` while `idle` plays alone at `t = f/30 mod idle.length`;
`Gm_P(f)` = the same while `hook_rear` plays at `t = f/30`; `Lm_S(f)`, `Lm_C(f)` = hook_rear's LOCAL rotations of
Spine and Chest at that frame (`skel.get_bone_pose_rotation`). Sample these by playing each take alone first.

1. `mirror` - hook_rear itself (U93's baseline, reproduced).
2. `upper_mirror_lower_idle` - exactly U93's variant 3 (reproduced).
3. `global_chest_lower_idle` - Hips (rotation AND position) and LOWER from idle, resampled as in 2. Every bone ABOVE
   Spine (Chest, UpperChest, Neck, Head, both shoulders, arms, hands) keeps hook_rear's tracks, copied. The Spine
   gets a NEW rotation track: `L_S(f) = Gi_P(f).inverse() * Gm_P(f) * Lm_S(f)`. Then the Chest's skeleton-space
   rotation equals the mirror's on every frame.
4. `global_chest_yawmatch_lower_idle` - as 3, but with one constant yaw `Y` in front:
   `L_S(f) = Gi_P(f).inverse() * Y * Gm_P(f) * Lm_S(f)`. `Y = Quaternion(up, a)`, where `up` is the canvas up axis
   expressed in skeleton space (`(_world_of(skel).basis.inverse() * Vector3(0, 1, 0)).normalized()` - write the
   components, never a named direction), and `a` is the signed angle about `up` from hook_rear's Chest +Z to idle's
   Chest +Z at frame 0, both projected onto the plane normal to `up`. The torso then STARTS facing where idle's does.
5. `global_chest_yawmatch_split_lower_idle` - as 4, but the correction is shared by Spine and Chest:
   `C(f) = Gi_P(f).inverse() * Y * Gm_P(f)`, `H(f) = Quaternion.IDENTITY.slerp(C(f), 0.5)`,
   `L_S(f) = H(f) * Lm_S(f)`, `L_C(f) = (H(f) * Lm_S(f)).inverse() * C(f) * Lm_S(f) * Lm_C(f)`.
   The Chest's skeleton-space rotation is the same as variant 4's; no single joint takes the whole twist.

Normalize every quaternion you build. Add each variant to a library and play it alone, node still, `advance(1/30)`
per frame, exactly as U93 did.

## What to measure

Per variant, every U93 metric with U93's exact definitions (`first`, `last`, `entry_pose_deg`, `hand_chest_dev_mean_m`
/ `_max_m`, `hand_node_dev_mean_m` / `_max_m`, `reach_fwd_max_m`, `torso_yaw_dev_max_deg`, `skate_mean_mps`,
`planted_frames`; deviations are against `mirror`), plus:
- `twist_max_deg`: max over frames of `_horiz_yaw_deg` between the Hips' and the Chest's +Z axes in the node frame -
  how far the torso is wrung above the pelvis.
- `spine_from_rest_max_deg`, `chest_from_rest_max_deg`: max over frames of the angle between that bone's local pose
  rotation and its rest rotation (`skel.get_bone_rest(i).basis`).
- `chest_yaw_vs_idle_f0_deg`: at frame 0, `_horiz_yaw_deg` between this variant's Chest +Z and idle's Chest +Z.
- `strike`: `{"x", "y", "z", "frame"}` - the RightHand in the NODE frame at the frame of its largest z.
Variants 4 and 5 also carry `yaw_offset_deg` (the angle `a`, degrees).

Two REFERENCE rows, measured the same way where the metric applies (no deviation metrics): `hook_lead` (strike from
the LEFT hand) and `idle` (strike from the right hand). hook_lead's `twist_max_deg` and `*_from_rest_max_deg` are what
a real performer's hook does - the plausibility yardstick for 3-5.

JSON `res://research/U94_hook_global.json`:
`{"population": {"fighter": "f01_m_box_welter", "binding": "boxing", "node": "still", "fps": 30, "source": "hook_rear = FightClipMirror of hook_lead (RamsterZ H2H)"},
  "idle_first": {...}, "variants": [{"name": "mirror", ...all metrics...}, ...], "references": [{"name": "hook_lead", "first": {...}, "last": {...},
  "twist_max_deg": 0.0, "spine_from_rest_max_deg": 0.0, "chest_from_rest_max_deg": 0.0, "strike": {...}, "skate_mean_mps": 0.0, "planted_frames": 0}, {"name": "idle", ...}]}`

## The digest `U94_HOOK_GLOBAL.md`

Opens with `## DECISIONS`. A table: variant -> first lead, entry_pose_deg, twist_max_deg, spine_from_rest_max_deg,
strike (x, y, z), hand_node_dev_max_m, skate_mean_mps - with hook_lead's reference row under it. Then at most three
lines: which variant keeps idle's stance, starts nearest idle's pose, stays inside hook_lead's own twist, and lands
the fist at hook_lead's strike height and reach on the other side. If none does all four, say which fails which.

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u94-hook-global`;
`python Tools/agent_comms.py send --from cursor --to claude --topic "U94 ready" --body "<hash>"`. Do not edit
HANDOFF.md or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`, `clean`, `rebase` or `merge`.

## The trap

A Spine solve written in the wrong space still plays, and still looks like a hook. The check pins what cannot
differ: rows 1 and 2 reproduce U93's JSON; in 3 the Chest's facing equals the mirror's on every frame (torso yaw
deviation under 0.5 deg); in 4 and 5 it starts on idle's (under 0.5 deg at frame 0) and differs from the mirror's by
exactly `yaw_offset_deg`; in 3-5 the RightHand in the CHEST frame is the mirror's within a millimetre; and 3-5 start
in idle's stance. Quaternion multiplication order is the usual failure: `a * b` applies b first.
