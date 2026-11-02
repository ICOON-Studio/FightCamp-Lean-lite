# TASK U108 — CURSOR — WHAT EVERY OWNED CLIP ACTUALLY DOES: A BEHAVIOUR CENSUS OF THREE PACKS, MEASURED IN BLENDER

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U80`,
branch `cursor/u108-clip-census` (Claude creates it from `origin/master` before launch - do not switch branches). Push the
BRANCH. Stage: S4a (NEVER IDLE, research queued behind the jab types).

**Test tier: DEV TOOLS + RESEARCH, NO GODOT.** No parse gate, no Godot test. Blender runs headless:
`D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe --background --factory-startup --python <script> -- <args>`.
`python research/U108_check.py` must print `U108_CHECK PASS` (it runs Blender itself, a few minutes). **IF IT DOES
NOT, DO NOT COMMIT AND DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `U108_check.py`,
`U108_probe_blender.py`, or anything under `Godot/assets/`, `Tools/footage/` or `Godot/tools/`. Spend no Higgsfield credits.

## Owned files

- `Tools/blender_moves/clip_behaviour_census.py` - NEW: Blender script, every clip -> series + metrics (steps 1-3).
- `Tools/blender_moves/clip_behaviour_sheets.py` - NEW: plain Python + matplotlib, series -> label sheets (step 4).
- `research/U108_clip_behaviour.json` - NEW (step 3's output; NO series inside it).
- `research/U108_sheets/<label>.png` - NEW (step 4's output).
- `research/U108_CLIP_BEHAVIOUR.md` - NEW, 80 lines at most.
- Not committed: `C:/Users/user/AppData/Local/Temp/FightCamp-moves/U108/series.npz`.

## Why this exists

The operator (2026-09-14): fighters are never static between exchanges - "I want see the fighters hop in their stances".
A name-only inventory of our clips found static guards, walks, turns, dodges and slips, and no bouncing stance, shuffle,
pivot or stance switch. Names can lie both ways, and two instruments already have: Godot's Q86 read FM1's `idle_A` and
`idle_Tiramis` and Motifect's guards as ZERO motion, while Blender shows FM1's hips moving 3 cm - and shows those two FM1
files with DIFFERENT keyframes but IDENTICAL hips and head. This census measures what each clip's body does, so Claude
generates only what is really missing.

## Population

Every `.fbx` / `.FBX` file (recursive) under `Godot/assets/anim/audition/ramsterz_h2h`, `.../magicpot_fm1` and
`.../motifect`. Key = its path relative to `Godot/assets/anim/audition/` with forward slashes. A file with no action after
import (a mesh, `T_pose`) goes to `excluded` as `"no animation"`; a file missing a role's joint goes there as `"no joints"`.
Everything else is measured - weapon clips included (record `"weapon": true` when the lower-case file name contains
sword, axe, knife, spear, staff, hammer, blunt, katana, dagger, bow, gun, rifle, pistol, shield, nunchaku, stick, blade,
mace, whip, tonfa or sai).

## Step 1 - import and joints (one FRESH `read_factory_settings(use_empty=True)` scene per file)

`bpy.ops.import_scene.fbx(filepath=...)`. Frame range = min/max over ALL `bpy.data.actions` of `frame_range`; fps =
`scene.render.fps / scene.render.fps_base`; `length_s = (end - start) / fps`. Roles, in THIS order: `pelvis, head,
thigh_l, thigh_r, foot_l, foot_r, hand_l, hand_r, toe_l, toe_r`. Joint names per pack (verified by Claude on 2026-09-14):
- `ramsterz_h2h` - 68 EMPTIES, no armature: `pelvis, head, thigh_l, thigh_r, foot_l, foot_r, hand_l, hand_r, ball_l, ball_r`.
- `magicpot_fm1` - an armature: `Hip, Head, Thigh_L, Thigh_R, Foot_L, Foot_R, Hand_L, Hand_R, Toe_L, Toe_R`.
- `motifect` - an armature OBJECT named `Hips` (the FBX root bone became the object, scale 0.01): `Hips, Head, LeftLeg,
  RightLeg, LeftFoot, RightFoot, LeftHand, RightHand, LeftToeBase, RightToeBase`.
A position is `arm.matrix_world @ arm.pose.bones[name].head` when the first armature has that bone, else
`scene.objects[name].matrix_world.translation`. Metres, Blender world, Z up.

## Step 2 - sampling and keys

Sample index k = 0 .. floor(length_s * 30 + 1e-6): frame = start + (k / 30) * fps, set with
`scene.frame_set(int(frame // 1), subframe=frame - int(frame // 1))`. Series = float array (samples, 10, 3), saved in
`series.npz` under the key = the file key with `/` replaced by `__`. `keys_digest`: sha1 over the actions sorted by name,
each action's fcurves sorted by (data_path, array_index); for each fcurve update with
`"%s|%s|%d|" % (action.name.split("|")[0], data_path, array_index)` then `",".join("%.5f" % kp.co[1] ...)`. Blender 5.2
actions are LAYERED: the fcurves are in `action.layers[*].strips[*].channelbags[*].fcurves`. `keys_vary` = any fcurve
whose keyframe values span more than 1e-4.

## Step 3 - metrics (exact; the check recomputes each from your series)

Horizontal = (x, y). `minutes = length_s / 60` (rates are 0 when it is 0). fwd(k) = unit (-r.y, r.x) with r = thigh_r - thigh_l
at k (keep the previous fwd if |r| < 1e-6; fwd(-1) = (0, 1)). `T_m` = |head - pelvis| at k=0. `pelvis_z_range_m` = max - min
of pelvis z; `pelvis_z_p5_p95_m` = numpy percentile 95 - 5. `bounce_per_min`: med = median(pelvis z); walking the samples,
z > med + 0.005 sets "high" (counting a low->high change), z < med - 0.005 sets "low"; count / minutes. `foot_lift_m` = max
over feet of (max z - percentile-5 z). `lifts_per_min`: per foot, base = percentile-5 z, start "up" if z[0] > base + 0.04
else "down"; down->up when z > base + 0.04 counts, up->down when z < base + 0.02; both feet summed / minutes.
`travel_net_m` = horizontal |pelvis[last] - pelvis[0]|; `travel_path_m` = sum of horizontal steps. `travel_dir`: "none" if
net < 0.10, else by the larger of d.fwd(0) ("forward"/"back") and d.right0 ("right"/"left"), right0 = (fwd0.y, -fwd0.x).
`turn_deg` = signed atan2 angle fwd(0) -> fwd(last); `turn_max_deg` = max |angle fwd(0) -> fwd(k)|. `level_drop_m` = pelvis
z[0] - min. `guard_share` = share of samples with BOTH hands' z > pelvis z + 0.75 (head z - pelvis z). Lead: s = (foot_l -
foot_r).fwd(k), state "L" if s > 0.05, "R" if s < -0.05, else unchanged; `lead_swaps` = state changes after the first
state; `lead_left_share` = share of samples in "L". `hand_speed_max_mps` / `foot_speed_max_mps` = max over both of the 3D
step length x 30. `static` = range < 0.005 and path < 0.01 and every role within 0.01 of its k=0 position.
`motion_digest` = sha1 of `np.round(series * 1000).astype(np.int32).tobytes()`. `labels`, in this order when true: 
`static_hold` (static); `bounce` (p5_p95 >= 0.02, bounce_per_min >= 60, net < 0.25); `foot_lift` (foot_lift_m >= 0.06,
lifts_per_min >= 30); `in_place_steps` (foot_lift and net < 0.25); `steps_travel` (net >= 0.25); `turn` (|turn_deg| >= 45);
`level_change` (level_drop_m >= 0.4 T_m); `stance_switch` (lead_swaps >= 1 and foot_lift_m >= 0.06); `strike_hand` (hand
speed >= 5.0); `strike_foot` (foot speed >= 6.0). THESE ARE CENSUS BINS CLAUDE CHOSE TO SORT CLIPS FOR A HUMAN TO OPEN -
not realism bounds and not from a study; say so in the digest.

JSON: `{"population": "<one sentence: packs, files found, measured, excluded>", "roles": [the 10], "packs": {<pack>:
{"joints": {role: name}}}, "clips": {<key>: {"pack", "weapon", "fps", "length_s", "samples", "keys_digest", "keys_vary",
every metric above, "labels"}}, "excluded": {<key>: <reason>}}`, floats rounded to 4 decimals.

## Step 4 - sheets, and LOOK at them

For each label with clips, `U108_sheets/<label>.png`: up to 12 clips (largest defining number first), one row each: the
clip name, a side-on stick figure (fwd(0) horizontal, z up) at 6 evenly spaced samples, and the pelvis-z trace. Open three
sheets yourself before writing the digest.

## The digest (`U108_CLIP_BEHAVIOUR.md`)

`# U108 - what every owned clip does`, then `## DECISIONS` (at most 12 lines): one line per label with the label in
backticks and its count; the unarmed clips labelled `bounce`, `stance_switch` and `in_place_steps` by name; one line with
`idle_A`, `idle_Tiramis`, and `same motion` or `different motion` (the motion digests decide) plus what differs if
anything; the Motifect guards' pelvis range. Then `## Bins` (the thresholds, labelled as Claude's census bins),
`## Surprises` (clips whose numbers contradict their names), `## Population` (the JSON string verbatim).

## Deliver

`git restore --staged -- AgentComms/messages` first. Commit ONLY the owned files with their paths on the commit line,
`git show --stat HEAD`, `git push -u origin cursor/u108-clip-census`, then `python Tools/agent_comms.py send --from cursor
--to claude --topic "U108 ready" --body "<the U108_CHECK line> - bounce <n>, stance_switch <n>, in_place_steps <n>"`. If the
check fails: no commit, no push, `--topic "U108 BLOCKED" --body "<the FAIL lines>"`. Do not edit HANDOFF.md.

## The trap

An FBX import in a scene that already holds another clip can hand the NEW file's action to the OLD objects, or leave a
file unanimated at its rest pose - both give identical or zero numbers that look like a finding. One fresh factory scene
per file, and a clip whose keyframes vary but whose ten joints never move is a bug until the probe agrees.
