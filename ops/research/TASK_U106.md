# TASK U106 — CURSOR — A HIGGSFIELD CLIP ON OUR FIGHTER: RETARGET, AUTHOR THE PAIR, MEASURE IT AGAINST REAL BOXERS

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U80`,
branch `cursor/u106-higgsfield-jab` (Claude creates it from `origin/master` before launch - do not switch branches). Push
the BRANCH. Stage: S4a (SMOOTH THE JAB IN COMBOS) - the operator's question "will Higgsfield clips + script + Blender work?".

**Test tier: DEV TOOLS + RESEARCH, NO GODOT SCRIPT.** No parse gate, no Godot test. Blender runs headless:
`D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe --background --factory-startup --python <script> -- <args>`.
`python research/U106_check.py` must print `U106_CHECK PASS` (it launches Blender itself). **IF IT DOES NOT, DO NOT
COMMIT AND DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `U106_check.py`,
`Tools/blender_moves/author_pair.py`, `Tools/blender_moves/bridge.py` or anything under `Tools/footage/`.

## Owned files

- `Tools/blender_moves/glb_clip_to_bridge.py` - NEW (the retarget, below).
- `Tools/blender_moves/specs/BOX_JAB_HEAD_LAND_F01_F09_MESHY.json` - NEW (a copy of `BOX_JAB_HEAD_LAND_F01_F09.json`).
- `research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_MESHY_events.json`, `..._fold.json` - NEW.
- `research/U106_HIGGSFIELD_JAB.md` - NEW, 70 lines at most.

## Why this exists

The operator bought Higgsfield Plus and asked whether its animation clips + our move script + Blender can make realistic
fight clips. Claude spent 8 credits on one test: Higgsfield rigged OUR f01 fighter mesh and applied Meshy's library clip
`Left_Jab_from_Guard`. It came back at `C:/Users/user/AppData/Local/Temp/FightCamp-higgs/jab191_rigged.glb`: one armature
named `Armature`, 24 Mixamo-style bones (`Hips`, `Spine02`, `Spine01`, `Spine`, `neck`, `Head`, `head_end`, `headfront`,
`LeftShoulder`, `LeftArm`, `LeftForeArm`, `LeftHand`, `LeftUpLeg`, `LeftLeg`, `LeftFoot`, `LeftToeBase` and the Right
ones), mesh `char1` plus a stray `Icosphere`, one action `Armature|Left_Jab_from_Guard|baselayer`, 24 fps, frames 0-43.
Its hand path is smooth (a 0.17 s extension - the jab we bought snaps its arm out in 0.033 s) but it cocks back first,
holds full reach ~0.33 s and dips the hips ~9 cm. The question is whether it makes a BETTER authored exchange than the
bought jab once it goes through the same pipeline - measured the way we measure real boxers, not by eye.

## Step 1 - `Tools/blender_moves/glb_clip_to_bridge.py`

`-- <clip.glb> <our_bridge.json> <take_name> <out_bridge.json>`. Read `Tools/blender_moves/bridge.py` whole (219 lines) and
`Tools/blender_moves/author_pair.py` lines 1-110 (how a bridge fighter is imported and mapped). Our bridge for f01 is
`C:/Users/user/AppData/Local/Temp/FightCamp-moves/f01_takes.json` (`fightcamp.pose_bridge` v1: `fighter`, `bones` (22),
`skeleton_world`, `takes` {name: {length_s, contact_s, times, pose}}).
1. Import OUR fighter exactly as author_pair.py does (`bridge.import_fighter`, `bridge.Mapping`, the world scale), and the
   clip GLB (`bpy.ops.import_scene.gltf`, `bone_heuristic="TEMPERANCE"`). Drop the `Icosphere`.
2. Bone map (write it as a constant, documented from the clip's own hierarchy - print the parent of every source bone
   and put the three spine bones in parent order onto our `Spine`, `Chest`, `UpperChest`): `Hips->Hips`, `neck->Neck`,
   `Head->Head`, `LeftShoulder->LeftShoulder`, `LeftArm->LeftUpperArm`, `LeftForeArm->LeftLowerArm`, `LeftHand->LeftHand`,
   `LeftUpLeg->LeftUpperLeg`, `LeftLeg->LeftLowerLeg`, `LeftFoot->LeftFoot`, `LeftToeBase->LeftToes`, and the Right ones.
3. Retarget by WORLD rotation deltas from the rest pose (both rigs skin the same f01 mesh in its rest T-pose): for each
   mapped bone at clip frame t, `delta = src_world_rot(t) * src_world_rot(rest)^-1`, and our bone's world rotation is
   `delta * our_world_rot(rest)`; set our pose bones parent-first so each child's local basis follows. Our `Hips`
   translation = the source hips' world translation from its rest, scaled by (our rest hip height / the source's).
   Face the same way as the clip (both import facing the same direction; say which in the digest).
4. Sample on a 60 fps grid over the action's frame range (Blender interpolates the 24 fps keys), export each frame with
   `bridge.export_pose_row` (placement = our armature at the first frame), and write `<out_bridge.json>`: a copy of our
   bridge whose `takes` holds ONLY `<take_name>` with `times`, `pose`, `length_s`, and `contact_s` = the time the LeftHand
   joint is farthest from the LeftUpperArm joint (the reach peak).
Run it: clip -> `C:/Users/user/AppData/Local/Temp/FightCamp-moves/f01_takes_meshy.json`, take `jab_meshy`; then ADD our
bridge's `idle` take into that file (copy the entry) so author_pair.py has the stance.

## Step 2 - author the exchange with the SAME v1 settings as the committed jab

Copy `Tools/blender_moves/specs/BOX_JAB_HEAD_LAND_F01_F09.json` to `..._F01_F09_MESHY.json`: `id`
`BOX_JAB_HEAD_LAND_F01_F09_MESHY`; thrower `bridge` the new file, `move` `jab_meshy`, `stance` `idle`; keep every other
field (vertical_scale, pitch_scale, extension_s, aim swing, distance swing_reach, feet); `out` paths ONLY under
`C:/Users/user/AppData/Local/Temp/FightCamp-moves/U106/` (pair json, report, preview frames `[32,38,40,42,44,46,50,56,62]`)
- never into `Godot/assets`. Run author_pair.py on it and keep its full log.

## Step 3 - measure it through the footage instrument, beside the committed pair

`F=C:/Users/user/AppData/Local/Temp/FightCamp-footage`. For the Meshy pair: `python Tools/footage/pair_to_track.py
<its pair.json> $F/pair_meshy.npz`, `python Tools/footage/pair_events.py $F/pair_meshy.npz
research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_MESHY_events.json "BOX_JAB_HEAD_LAND_F01_F09_MESHY (authored pair, 60 fps)"`,
`python Tools/footage/fold_footage.py --out research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_MESHY_fold.json
--population "BOX_JAB_HEAD_LAND_F01_F09_MESHY: Higgsfield/Meshy Left_Jab_from_Guard on f01 through glb_clip_to_bridge.py, authored with the v1 spec" 0:<that events file>`,
then `python Tools/footage/compare_to_footage.py <that fold> --footage research/S4A_PAIRS/footage_two_men.json`
and the same compare for the committed `research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_fold.json`.

## The digest (`U106_HIGGSFIELD_JAB.md`)

- `# U106 - a Higgsfield jab on our fighter` then `## DECISIONS` (at most 10 lines): does the Meshy-sourced pair land
  inside footage p10-p90 on more or fewer keys than the committed RamsterZ-sourced pair (count both, by name), which keys
  differ, the author log's swing angle and glove-to-aim for each, and one line on what the retarget could not carry.
- `## Bone map` - the source -> ours table, with each source bone's parent.
- `## Compare` - both compare_to_footage.py outputs verbatim, each in its own ```text fence, the committed pair first.
- `## Population` - the Meshy fold's population string, verbatim.

## Deliver

`git restore --staged -- AgentComms/messages` first. Commit ONLY the owned files with their paths on the commit line,
`git show --stat HEAD`, `git push -u origin cursor/u106-higgsfield-jab`, then `python Tools/agent_comms.py send --from
cursor --to claude --topic "U106 ready" --body "<the U106_CHECK line> - Meshy pair inside footage on <n> keys, committed <n>"`.
If the check fails: no commit, no push, `--topic "U106 BLOCKED" --body "<the FAIL lines>"`. Do not edit HANDOFF.md. Spend
no Higgsfield credits.

## The trap

A retarget that copies LOCAL rotations between two rigs with different bone rolls produces a clip that looks alive in
the numbers and twists every limb on screen. The check samples both skeletons' joint POSITIONS in Blender with its own code
and compares each limb segment's direction - build from world rotation deltas, and open the preview PNGs before you run it.
