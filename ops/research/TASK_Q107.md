# TASK Q107 — QWEN — WHICH BODY PART LEADS: THE KINETIC CHAIN INSIDE OUR OWN MOCAP, FRAME BY FRAME

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q107-mocap-chain` (Claude creates it from `master` before launch - do not switch branches). Push the BRANCH.
Stage: S4a (THE MOVE SCRIPT).

**Test tier: A NEW MEASURE TOOL, NO EXISTING SCRIPT EDITED.** Parse gate on the tool, one run of it, then
`python research/Q107_check.py` must print `Q107_CHECK PASS`. No test suite. **IF THE CHECK FAILS, DO NOT COMMIT
AND DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `Q107_check.py`.

## Owned files

- `Godot/tools/measure_mocap_chain.gd` - NEW, `extends SceneTree`.
- `research/Q107_mocap_chain.json` - NEW (written by the tool).
- `research/Q107_MOCAP_CHAIN.md` - NEW, 60 lines at most.

## Why this exists

The operator watched our 3D boxing match and said: "it looks like each part of body have each own sped" and "There is
no cohesion between animations and reactions". We are writing a MOVE SCRIPT for every boxing technique: one timeline
on one clock for both fighters, saying which body part LEADS and which FOLLOWS and by how many frames - for a punch,
real boxers drive rear foot -> hips -> chest -> shoulder -> elbow -> fist; for a hit, head -> neck -> chest -> hips ->
feet. Before we author anything we need to know what the motion-capture clips we already own actually do: is the
chain in them, in what order, how many frames apart, and where the contact frame sits in it. That is this task: a
measurement of OUR clips, through the SAME production path the room plays them with. It says nothing about real
boxers (footage is measured separately) and invents nothing.

## Through production - and only production

The takes must be read exactly as the room binds them: retargeted onto fighter A (`f01_m_box_welter_rigged.glb`) by
`FightStagePlayer.bind`. Mount the room the way `Godot/tools/probe_clip_keys.gd` does (87 lines - read it whole):
`load("res://scenes/FightWorldLive.tscn")`, `configure({"seed": 94301, "rounds": 3})`, `setup()`, then
`stage_players()[0]`, its `animation_player()` and `skeleton()`. Every position comes from
`player.call("_sample_global", bone, anim, player.call("_bone_tracks", anim), t).origin` (skeleton space; see
`Godot/scripts/FightStagePlayer.gd:2297` - read only that function and `_bone_tracks` at `:2275`). **Never load an
FBX, never call `FightClipRetarget`, never write your own sampler: the check fails on any of those** (a previous task
wrote its own sampler, floated every body 0.9 m and posed them 58-86 deg off). If the room will not set up, send the
BLOCKED mail - never a substitute. `Skeleton3D.get_bone_global_pose()` returns the REST in these runs - never use it.

## What to measure

Takes (skip a name `ap.has_animation` says is missing, and list it under `"missing"`):
- STRIKES: `jab`, `cross`, `hook_lead`, `hook_rear`, `boxing_overhand`, `strike_body`
- REACTIONS: `react_head`, `react_head#1`, `react_head#2`, `react_head#3`, `react_body`, `react_body#1`, `block`, `slip`

Bones (16): `LeftToes RightToes LeftFoot RightFoot Hips Spine Chest UpperChest Neck Head LeftUpperArm RightUpperArm
LeftLowerArm RightLowerArm LeftHand RightHand`.

Times: `t_k = k / 60` for `k = 0, 1, ...` while `t_k < L - 1e-6`, then `L` itself last (`L` = the animation's length).

Per take, per bone (all in skeleton units and seconds):
- `raw`: the position at every `t_k`, `[x, y, z]` rounded to 6 decimals.
- `disp(t_k) = |p(t_k) - p(t_0)|`; `peak_disp = max disp`; `t_peak` = the FIRST `t_k` where `disp == peak_disp`.
- `onset_t` = the first `t_k` with `disp(t_k) >= 0.2 * peak_disp`, or `null` when `peak_disp < 0.02` (the bone is
  "still").
- `speed(t_k) = |p(t_k+1) - p(t_k-1)| / (t_k+1 - t_k-1)` for interior k only; `speed_peak_t` = the FIRST interior `t_k`
  of the maximum.

Per take, two YAW rows, for `Hips` and `Chest`: `yaw(t_k)` = the signed angle in degrees, about +Y, from the bone's
basis-Z axis at `t_0` to its basis-Z axis at `t_k`, both projected onto the XZ plane (`atan2` of the cross product's
y against the dot product), wrapped to (-180, 180]; `peak_yaw` = max `|yaw|`; `yaw_onset_t` = first `t_k` with
`|yaw| >= 0.2 * peak_yaw`, or `null` when `peak_yaw < 3`. Store `yaw` per frame (2 decimals) too.

STRIKES also get:
- `contact_s = player.contact_s(<take name>)` (the room's own contact frame).
- `strike_hand`: `LeftHand` or `RightHand`, whichever has the larger `peak_disp`; `strike_side` "L" or "R".
- `chain`: a list of entries `{"part": ..., "onset_frames": round((onset_t - contact_s) * 60), "speed_peak_frames":
  round((speed_peak_t - contact_s) * 60)}` for, in this order: the foot OPPOSITE the strike hand (`RightFoot` for a
  left hand), `Hips`, `Hips_yaw`, `Chest_yaw`, the strike side's `UpperArm`, `LowerArm`, `Hand` (for the yaw rows use
  `yaw_onset_t`, and `speed_peak_frames` = null). A part whose onset is `null` gets `"onset_frames": null`.
- `chain_order`: the part names sorted by `onset_frames` (nulls last, ties keep the list order above).

REACTIONS also get `response`: the same entry shape for `Head`, `Neck`, `UpperChest`, `Hips`, `LeftFoot`, `RightFoot`,
with frames counted from the take's START (a reaction take starts on contact), and `response_order` sorted the same way.

JSON: `{"population": "<one line: fighter A f01 via FightStagePlayer.bind, RamsterZ H2H catalogue (FightClipBinding), seed 94301>",
"fps": 60, "missing": [...], "takes": {"<take>": {"length_s", "times", "raw": {bone: [[x,y,z]...]}, "bones": {bone:
{"peak_disp", "t_peak", "onset_t", "speed_peak_t"}}, "yaw": {"Hips": {"per_frame", "peak_yaw", "yaw_onset_t"}, "Chest":
{...}}, + the strike or reaction fields}}}`. Write it with `JSON.stringify(data, "  ")` to
`res://research/Q107_mocap_chain.json` (resolve with `ProjectSettings.globalize_path`).

## The digest (`Q107_MOCAP_CHAIN.md`)

Open with `## DECISIONS` (at most 10 lines): for each strike, its `chain_order` and the frame numbers, and whether the
clip's chain runs feet -> hips -> chest -> arm or starts in the arm; for each reaction, whether the head leads and by
how much; where each strike's contact frame sits against its hand's speed peak. Then a `## Table` with one row per take.
**Every number in the digest must come from the JSON** - the check compares them. Then `## Method` (the definitions
above, in 5 lines) and `## Population` (the one-line population string).

## Run

1. `python Godot/tools/check_scripts.py Godot/tools/measure_mocap_chain.gd`
2. `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py C:/Users/user/AppData/Local/Temp/FightCamp-Q81 tools/measure_mocap_chain.gd --timeout 1200`
   (never pipe the console Godot exe into PowerShell). A `SCRIPT ERROR` line means fix and rerun; rc=0 alone is not a pass.
3. `python research/Q107_check.py` -> must print `Q107_CHECK PASS`.

## Deliver

`git restore --staged -- AgentComms/messages` first (old mail rides in this worktree's index). Commit ONLY the three
owned files with their paths on the commit line, `git show --stat HEAD`, `git push -u origin qwen/q107-mocap-chain`,
then `python Tools/agent_comms.py send --from qwen --to claude --topic "Q107 ready" --body "<the Q107_CHECK line>"`.
If the check fails: no commit, no push, and `--topic "Q107 BLOCKED" --body "<the FAIL lines>"`.
Do not edit HANDOFF.md or AgentComms/roadmap.json.

## The trap

A hit reaction's take and a strike's take are measured on DIFFERENT clocks: a strike's frames count from its contact
frame (negative = before contact), a reaction's from its own start. And the sentence in your DECISIONS is read
against the JSON - last time two of your summary sentences said the opposite of your own numbers. Write each sentence
from the JSON row in front of you.

## SEND-BACK 1 (Claude, 2026-09-14) - THE TWIST ROWS WERE MY DEFINITION'S FAULT, NOT YOURS; FIX THEM AND ADD SPEED-PEAK ORDERS

Your first pass (`01d49e5`) passed the old check, and Claude opened the numbers: a jab turning the chest 58 deg and a
cross 129 deg is not a punch. The definition in this file read each bone's basis-Z axis, and on this rig that axis is
near vertical, so its projection on the floor spins. Everything else stands; change exactly this:

1. Measure 18 bones: add `LeftUpperLeg` and `RightUpperLeg` to the 16.
2. Replace the two yaw rows. The JSON key `yaw` now holds `hip_line` and `shoulder_line` (drop `Hips` and `Chest`):
   the LINE from `LeftUpperLeg` to `RightUpperLeg` (hip line) and from `LeftUpperArm` to `RightUpperArm` (shoulder line),
   positions from `raw`, projected on the XZ plane. `yaw(t_k)` = the signed angle in degrees about +Y from the line's
   XZ direction at `t_0` to its XZ direction at `t_k`: with `(x0, z0)` at `t_0` and `(x, z)` at `t_k`,
   `atan2(z0 * x - x0 * z, x0 * x + z0 * z)` in degrees, wrapped to (-180, 180]. Store `per_frame` (3 decimals), `peak_yaw`,
   `yaw_onset_t` (first `t_k` with `|yaw| >= 0.2 * peak_yaw`, null when `peak_yaw < 3`) and NEW `yaw_speed_peak_t` = the
   FIRST interior `t_k` of the maximum of `|wrap(yaw(t_k+1) - yaw(t_k-1))| / (t_k+1 - t_k-1)` (null when `peak_yaw < 3`).
3. In `chain`, the two yaw parts are now named `hip_line_yaw` and `shoulder_line_yaw` (same positions in the list), and
   their `speed_peak_frames` = `round((yaw_speed_peak_t - contact_s) * 60)` (null only when the speed peak is null).
4. NEW `chain_order_by_speed_peak` (strikes) and `response_order_by_speed_peak` (reactions): the part names sorted by
   `speed_peak_frames`, nulls last, ties keeping the list order. Biomechanics orders a kinetic chain by when each
   segment's speed PEAKS (proximal to distal), not by a 20% displacement onset - so this is the order that matters.
5. The digest states BOTH orders for every take exactly as the JSON has them (`A -> B -> C`), and its DECISIONS say, per
   strike, whether the speed peaks run feet -> hips -> shoulders -> arm -> hand. Stay within 60 lines: a long table can
   list just the two orders per take.

`Q107_check.py` on master was updated to these definitions (it recomputes both lines from your raw positions); run the
NEW check - `git merge origin/master` brings it and this file into your branch. Commit the three owned files again on
the same branch, push, and send `Q107 ready` (or `Q107 BLOCKED` with the FAIL lines).
