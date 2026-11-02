# TASK U93 — CURSOR — THE REAR HOOK WITHOUT THE STANCE SWAP: FOUR SPLICES OF THE MIRRORED HOOK, MEASURED

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u93-hook-splice` - Claude creates it from `master`
before launch. Push the BRANCH. Stage: S4a (transitions) - measurement before a build.

**Test tier: A NEW TOOL FILE ONLY.** Parse gate on your tool, then run it. No suite, no script edited.
`python research/U93_check.py` must exit 0 before you commit. ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_hook_splice.gd` - NEW, yours.
- `research/U93_hook_splice.json` - NEW, written by your tool.
- `research/U93_HOOK_SPLICE.md` - NEW, 25 lines at most.

## Why this exists

`hook_rear` is the lead hook MIRRORED, so it also mirrors the FEET: it starts right-foot-forward against a
left-foot-forward stance (Q98), entering it swaps the feet inside a 0.27 s join (U90: 59/59 windows over the join
bound), and those joins skate at 2.755 m/s - the single worst source of planted-foot skate in the bout (Q99).
The fix candidate: mirror only the UPPER body, and take the hips and legs from an unmirrored take. This measures four
ways to build that, on f01, before anything is bound.

## What to read - ONLY these

- `Godot/tools/probe_take_skate.gd` (136 lines, read whole): bind f01 through FightStagePlayer exactly as the room
  does, play a take alone with the node still, compose bone positions from `get_bone_pose`, `_world_of`.
- `research/Q98_take_stance.json` (read whole) and `Godot/tools/measure_take_stance.gd`: `grep -n "forward\|lateral\|split\|width\|lead" Godot/tools/measure_take_stance.gd`
  and ~15 lines around the first hits - the stance measure you must reproduce exactly.
- `Godot/scripts/FightClipRetarget.gd`: `sed -n '54,77p'` (the 22 bone names we drive).

## The variants (built in your tool from the takes the bound player already holds)

`ap.get_animation("hook_lead")`, `ap.get_animation("hook_rear")` (production: the mirror) and `ap.get_animation("idle")`.
UPPER = Spine, Chest, UpperChest, Neck, Head, LeftShoulder, RightShoulder, Left/RightUpperArm, Left/RightLowerArm,
Left/RightHand. LOWER = Left/RightUpperLeg, Left/RightLowerLeg, Left/RightFoot, Left/RightToes.
A track belongs to the bone its path's last subname names. Build each variant as a NEW Animation (length = hook_rear's):

1. `mirror` - hook_rear itself (the baseline).
2. `upper_mirror_lower_lead` - UPPER tracks from hook_rear; Hips (rotation AND position tracks) and LOWER from hook_lead.
3. `upper_mirror_lower_idle` - UPPER from hook_rear; Hips and LOWER from idle, resampled at hook_rear's key times
   (idle loops: sample it at `t mod idle.length`; bake one key per 1/30 s).
4. `upper_mirror_hipsrot_mirror_lower_idle` - UPPER and the Hips ROTATION track from hook_rear; the Hips POSITION
   track and LOWER from idle (resampled as in 3).

Copy key values untouched (no re-mirroring). Add each to the player's library under its variant name and play it alone,
node still, `advance(1/30)` per frame, like the probe.

## What to measure, per variant

- `first` / `last`: the Q98 stance at frame 0 and the last frame - `lead` ("LeftToes"/"RightToes"), `split_m`, `width_m`.
- `entry_pose_deg`: at frame 0, the mean angle (degrees) between this variant's and idle-at-t=0's SKELETON-SPACE bone
  orientations over LeftUpperArm, LeftLowerArm, RightUpperArm, RightLowerArm, LeftUpperLeg, LeftLowerLeg,
  RightUpperLeg, RightLowerLeg, Spine, Chest (`a.inverse() * b` angle of the orthonormalized bases).
- `hand_chest_dev_mean_m` / `_max_m`: per frame, the RightHand position in the Chest bone's frame
  (`chest.affine_inverse() * hand`) minus the `mirror` variant's at the same frame; mean and max length.
- `hand_node_dev_mean_m` / `_max_m`: the same, with the RightHand in the NODE frame (`_world_of(node).affine_inverse() *
  world hand`) - where the fist actually goes.
- `reach_fwd_max_m`: max over frames of the RightHand's node-frame coordinate along the node's facing +Z.
- `torso_yaw_dev_max_deg`: max over frames of the horizontal angle between this variant's and `mirror`'s Chest +Z
  axis in the node frame.
- `skate_mean_mps` / `planted_frames`: the probe's lower-toe skate (within 3 cm of its rest height) on the still node.

JSON `res://research/U93_hook_splice.json`:
`{"population": {"fighter": "f01_m_box_welter", "binding": "boxing", "node": "still", "fps": 30},
  "idle_first": {"lead": "...", "split_m": 0.0, "width_m": 0.0},
  "variants": [{"name": "mirror", "frames": 0, "first": {...}, "last": {...}, "entry_pose_deg": 0.0,
    "hand_chest_dev_mean_m": 0.0, "hand_chest_dev_max_m": 0.0, "hand_node_dev_mean_m": 0.0, "hand_node_dev_max_m": 0.0,
    "reach_fwd_max_m": 0.0, "torso_yaw_dev_max_deg": 0.0, "skate_mean_mps": 0.0, "planted_frames": 0}, ...]}`

## The digest `U93_HOOK_SPLICE.md`

Opens with `## DECISIONS`. A table: variant -> first lead, last lead, entry_pose_deg, hand_node_dev_max_m,
reach_fwd_max_m, torso_yaw_dev_max_deg, skate_mean_mps. One line: which variant keeps idle's stance AND the fist's path
closest to the mirror.

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u93-hook-splice`;
`python Tools/agent_comms.py send --from cursor --to claude --topic "U93 ready" --body "<hash>"`. Do not edit
HANDOFF.md or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`, `clean`, `rebase` or `merge`.

## The trap

A splice that copies the wrong tracks still plays. Three things cannot differ, and the check tests them: `mirror`'s
stance must equal Q98's hook_rear row; `upper_mirror_lower_lead`'s stance must equal Q98's hook_lead row (its legs ARE
hook_lead's); and the RightHand in the CHEST frame must be identical to `mirror`'s in variants 2 and 3 (same arm chain
below the chest) - within a millimetre.
