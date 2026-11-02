# TASK U107 — CURSOR — TEXT-TO-MOTION JAB TYPES ON OUR FIGHTER: A COMMITTED JAB, A RANGE-FINDER AND A FEINT, RETARGETED AND MEASURED BESIDE THE JABS WE HAVE

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U80`,
branch `cursor/u107-t2m-jab-types` (Claude creates it from `origin/master` before launch - do not switch branches). Push
the BRANCH. Stage: S4a (THE THREE JAB TYPES).

**Test tier: DEV TOOLS + RESEARCH, NO GODOT SCRIPT.** No parse gate, no Godot test. Blender runs headless:
`D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe --background --factory-startup --python <script> -- <args>`.
`python research/U107_check.py` must print `U107_CHECK PASS`. **IF IT DOES NOT, DO NOT COMMIT AND DO NOT PUSH: send
the BLOCKED mail with its FAIL lines.** Never edit `U107_check.py`, `Tools/blender_moves/author_pair.py`,
`Tools/blender_moves/bridge.py`, `Tools/blender_moves/glb_clip_to_bridge.py` or anything under `Tools/footage/`. Spend no
Higgsfield credits.

## Owned files

- `Tools/blender_moves/npz_clip_to_bridge.py` - NEW (step 1).
- `Tools/blender_moves/take_mechanics.py` - NEW (step 2).
- `research/S4A_PAIRS/take_mechanics_jab_types.json` - NEW (step 2's output).
- `research/U107_T2M_JAB_TYPES.md` - NEW, 70 lines at most.

## Why this exists

The operator decided (2026-09-14): strikes are authored as two-man pairs, and AI clips may be RAW MATERIAL. Next come
three jab types the engine already throws but shows as one full jab: a range-finder, a feint and a committed jab. Claude
generated candidates with Higgsfield's text-to-motion (NVIDIA ARDY, 20 fps, one body) and picked three by measurement and
by eye. Before any of them is authored into a pair, each must be ON OUR FIGHTER and measured the same way as the two jabs
we already author from: the bought `jab` take and U106's Meshy `jab_meshy`.

## Inputs (all on disk)

- Clips `C:/Users/user/AppData/Local/Temp/FightCamp-higgs/motion/types/`: `jab_committed_41.npz` (a lunging full jab),
  `jab_feint_41.npz` (a quick three-quarter jab - the range-finder candidate), `jab_feint_37.npz` (a short hand feint).
  Arrays: `posed_joints` (T, 27, 3) joint positions, `global_rot_mats` (T, 27, 3, 3) joint world rotations, `fps` 20,
  model space **Y up**, metres. Joint order (index: name): 0 Hips, 1 Spine, 2 Spine1, 3 Spine2, 4 Spine3, 5 Neck, 6 Head,
  7 RightShoulder, 8 RightArm, 9 RightForeArm, 10 RightHand, 11 RightHandEnd, 12 RightHandThumb1, 13 LeftShoulder,
  14 LeftArm, 15 LeftForeArm, 16 LeftHand, 17 LeftHandEnd, 18 LeftHandThumb1, 19 RightUpLeg, 20 RightLeg, 21 RightFoot,
  22 RightToeBase, 23 LeftUpLeg, 24 LeftLeg, 25 LeftFoot, 26 LeftToeBase.
- The source rest pose: `D:/Tools/Blender/blender-5.2.1-windows-x64/portable/extensions/user_default/higgsfield_blender/resources/motion/cskel27.npz`
  (`rig_joint_names`, `rig_joint_connections` (parent, child) pairs, `bind_rig_transform` (27, 4, 4) joint world
  transforms at bind). Read it with numpy; do not enable the add-on.
- Our f01 bridge `C:/Users/user/AppData/Local/Temp/FightCamp-moves/f01_takes.json` (takes `idle`, `jab`, `cross`,
  `react_head`) and U106's `C:/Users/user/AppData/Local/Temp/FightCamp-moves/f01_takes_meshy.json` (`jab_meshy`).

## Step 1 - `Tools/blender_moves/npz_clip_to_bridge.py`

`-- <clip.npz> <our_bridge.json> <take_name> <out_bridge.json> [--append]`. Read `Tools/blender_moves/glb_clip_to_bridge.py`
whole (it is the U106 retarget: rest alignment, `build_godot_pose`, the 60 fps export) and import its functions rather
than copying them. The difference is only WHERE the source transforms come from:
1. Source world transforms per frame from the npz: rotation `global_rot_mats[t, j]`, position `posed_joints[t, j]`; the
   source rest from `bind_rig_transform[j]`. The add-on's own importer converts model space to Blender with
   `(x, y, z) -> (x, -z, y)` (a proper rotation): apply it to both rotations (`C @ R @ C.T`) and positions (`C @ p`) so
   the dicts you pass to `build_godot_pose` are in the same Blender world frame our fighter imports into.
2. A `BONE_MAP` for cskel27 (documented from `rig_joint_connections`, parent order): `Hips->Hips`, `Spine->Spine`,
   `Spine2->Chest`, `Spine3->UpperChest`, `Neck->Neck`, `Head->Head`, `LeftShoulder->LeftShoulder`, `LeftArm->LeftUpperArm`,
   `LeftForeArm->LeftLowerArm`, `LeftHand->LeftHand`, `LeftUpLeg->LeftUpperLeg`, `LeftLeg->LeftLowerLeg`,
   `LeftFoot->LeftFoot`, `LeftToeBase->LeftToes`, and the Right ones (`Spine1` unmapped - say so in the digest).
3. Sample on a 60 fps grid from 0 to (frames - 1) / 20 s: between the two nearest source frames, quaternion slerp for
   rotations and linear for positions. Export rows with `bridge.export_pose_row` exactly as glb_clip_to_bridge.py does,
   `contact_s` = the time LeftHand is farthest from LeftUpperArm, `length_s` = the last sample time.
4. `--append` adds the take to an existing out file instead of starting from a copy of our bridge. Build ONE file,
   `C:/Users/user/AppData/Local/Temp/FightCamp-moves/f01_takes_t2m.json`, with takes `jab_committed_t2m`
   (jab_committed_41), `jab_rangefinder_t2m` (jab_feint_41), `jab_feint_t2m` (jab_feint_37) and our `idle` copied in.
   Render preview PNGs of each take at 5 evenly spaced times to `C:/Users/user/AppData/Local/Temp/FightCamp-moves/U107/`
   and OPEN them before step 2: a twisted limb or a figure facing away is a step 1 bug.

## Step 2 - `Tools/blender_moves/take_mechanics.py` (plain Python + numpy; the check recomputes every number)

`python Tools/blender_moves/take_mechanics.py --out research/S4A_PAIRS/take_mechanics_jab_types.json <label>=<bridge.json>:<take> ...`
with exactly these five labels: `t2m_committed`, `t2m_rangefinder`, `t2m_feint` (the new file), `bought_jab`
(f01_takes.json `jab`), `meshy_jab` (f01_takes_meshy.json `jab_meshy`). A CONTRACT - names and definitions exact. Joint
positions come from each pose row (`row[12*i+9:12*i+12]` for bone i, bone order from the file's `bones`). Per take:
- `up` = unit vector from the mean of LeftFoot and RightFoot to Head at row 0; `T` = |Neck - Hips| at row 0 (m).
- `arm_len_m` = |LeftLowerArm - LeftUpperArm| + |LeftHand - LeftLowerArm| at row 0; `reach(r)` = |LeftHand - LeftUpperArm|.
- `peak` = the row of maximum reach; `peak_s` its time; `reach_share_peak` = reach(peak) / arm_len_m.
- `guard` = the median reach over rows with time <= min(0.3, 0.5 * peak_s); `guard_share` = guard / arm_len_m;
  `rise` = reach(peak) - guard.
- `onset` = the last row r < peak with reach(r) < guard + 0.2 * rise, plus one; `onset_s` its time;
  `extension_s` = peak_s - onset_s.
- `back` = the first row r > peak with reach(r) < guard + 0.5 * rise (none -> `return_s` null); `return_s` = its time -
  peak_s.
- `forward` = unit of (LeftHand - LeftUpperArm) at peak with its component along `up` removed.
- `hips_out_T` = (Hips(peak) - Hips(onset)) . forward / T; `lead_ankle_out_T` the same with LeftFoot.
- `rear_hand_v_head_m` = the minimum over rows onset..back (or the last row) of (RightHand - Head) . up.
- `length_s` = the take's `length_s`.
Output: `{"population": "<one sentence naming the five takes and their sources>", "takes": {<label>: {"bridge", "take",
"arm_len_m", "reach_share_peak", "guard_share", "onset_s", "peak_s", "extension_s", "return_s", "hips_out_T",
"lead_ankle_out_T", "rear_hand_v_head_m", "length_s"}}}`, numbers rounded to 4 decimals.

## The digest (`U107_T2M_JAB_TYPES.md`)

- `# U107 - text-to-motion jab types on our fighter`, then `## DECISIONS` (at most 10 lines): for each of the five
  labels its `reach_share_peak` (2 decimals, as in the JSON), `extension_s` and `hips_out_T`, and one line on whether
  the three t2m takes differ from each other the way their names say (range-finder shorter than committed, feint
  shortest, committed travelling most) - numbers, not adjectives.
- `## Mechanics` - one table, all five takes, every key of the contract.
- `## Bone map` - source -> ours with each source joint's parent; name what is unmapped.
- `## Population` - the JSON's population string, verbatim.

## Deliver

`git restore --staged -- AgentComms/messages` first. Commit ONLY the owned files with their paths on the commit line,
`git show --stat HEAD`, `git push -u origin cursor/u107-t2m-jab-types`, then `python Tools/agent_comms.py send --from
cursor --to claude --topic "U107 ready" --body "<the U107_CHECK line> - reach share committed/rangefinder/feint <a>/<b>/<c>"`.
If the check fails: no commit, no push, `--topic "U107 BLOCKED" --body "<the FAIL lines>"`. Do not edit HANDOFF.md.

## The trap

ARDY's joint rotations are WORLD rotations of the joint frame at bind, not bone-roll-aligned Blender rotations: feeding
`global_rot_mats` into `build_godot_pose` without the same `(x, -z, y)` change of basis on BOTH the frames and the rest
turns every delta into a rotation about the wrong axis - the numbers stay smooth and the arms point sideways. The check
compares every limb segment's direction with the npz's own joint positions.
