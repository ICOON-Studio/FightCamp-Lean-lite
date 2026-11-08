# TASK RETARGET2 - CURSOR (GPT-5.6 Sol High) - RETARGET1 round 2: keep the wins, fix the stance and the end trim

Status: OPEN (S399, Claude main). Rework of PR #81 (NOT merged). BASE is that branch.
FILMED by the rokoko-back session (E:/FightCamp/tmp/rokoko2/r1_pr81/<clip>.mp4 vs r1_main/<clip>.mp4, same body/camera,
blind Sonnet critic, every-frame bursts + 3-frame leg crops):
- KEEP (better than main): body snaps down (win 15 -> 0, fidget_v1 2 -> 0, cross 1 -> 0), slide down (win 5.63 -> 3.71 m,
  idle 0.157 -> 0.104), idle loop seam fixed (wrap jump 0.7 deg vs 12.8; fidget_v2 7.9 vs 33.4); win 7.5 vs 6.5.
- FIX 1 - STANCE COLLAPSE: pro_left_jab PR 5.5 vs main 7 - "the stance collapses, boots stack in line, legs cross"
  (r1_pr81/pro_left_jab.mp4 0:00.8-0:01.2: boots one behind the other, legs straight; main keeps a wide bladed stance);
  fidget_v1 rear boot overlaps the front at ~2.5 s. Measure stance WIDTH (feet across her facing) and length per frame vs the
  raw take scaled to our legs; a foot placement / hip turn error, not the source. Bar: width within 15 % of raw every frame.
- FIX 2 - END TRIM: every clip lost 0.33-0.37 s at the END; on short clips it removes real motion (fidget_v2 35 -> 24 frames,
  "barely moves"). Keep the full clip length (or trim only frames that repeat the first frame of a loop). Bar: frames >= raw
  frames - 1 for every clip.
- Contact timing must stay (jab peak 0.467 s, cross 0.300 s).

## Contract
BASE: cursor/retarget1
OWNS: tools/raw_fbx_feet.py, tools/retarget_compare.gd, tools/clip_gltf.gd, tools/owned_mocap_bake.gd, assets/anim/baked/, tests/retarget_fidelity_test.gd
RED_TEST: tests/retarget_fidelity_test.gd -> RETARGET_FIDELITY failures=0
REGRESSION: boxer_footwork_test, foot_plant_test, fight_polish_test, corner_warm_test, golden_path_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/clip_orbit.gd -- out=E:/FightCamp/tmp/retarget1 clips=mc_Box1_M3_Idle_Fidget_V1,mc_Box1_M3_Left_Jab,mc_Box1_M3_Win_V1

## What is measured (S399, Claude)
114 of the 122 clips the fight plays are MoCap Online Punch PRO (bought, EUR 42.43; source FBX at
E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX, 145 files, UE4 mannequin). Same measure both sides (a foot
within 3 cm of its lowest point is planted; slide = its floor travel while planted):

| clip | RAW on its own skeleton (Blender, tools/raw_fbx_feet.py) | OURS baked on MetaHuman (tools/clip_feet_probe.gd) |
|---|---|---|
| Idle | slide 0.11 m, leg snaps 0 | 0.15 m, 0 |
| Idle_Fidget_V1 | 0.73 m, 0 | 2.29 m, 2 |
| Idle_Fidget_V8 | 1.24 m, 0 | 4.41 m, 5 |
| Win_V1 | 3.03 m, 10 | 5.48 m, 15 |
| Left_Jab | 0.30 m, 0 | 0.39 m, 0 |
So the pack is smooth (0 leg snaps in 6 of 7 tested); OUR conversion adds the tremble and 1.3-3.6x the foot slide. The
previews on the board (ops/previews/lean_anim, clip_orbit) also run the fight's leg layers on top. NOTE the S399 trap:
bone reads outside `skel.skeleton_updated` return the clip pose without modifiers - clip_feet_probe's numbers are the BAKE
alone (good for this task); for "as drawn" read inside skeleton_updated (tools/stance_probe.gd shows how).

## Do
1. tests/retarget_fidelity_test.gd + tools/retarget_compare.gd FIRST: for every Punch PRO clip, the raw numbers (write them
   once from tools/raw_fbx_feet.py into a json, Blender: `"C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" -b
   --factory-startup --python tools/raw_fbx_feet.py -- <fbx...>`; also add a knee jitter number = mean |second difference|
   of the calf rotation, deg/frame^2) against ours, scaled by leg length. Bars per clip: our slide <= raw x 1.15 + 0.02 m;
   our leg snaps <= raw; our knee jitter <= raw x 1.2. It must FAIL on main for most clips.
2. Re-import the pack the standard way: Godot 4.7's FBX import with a BoneMap onto SkeletonProfileHumanoid and our MetaHuman
   body's profile (the engine's retargeting: rest fixer, overwrite axis, keep global rest), then bake to our .res format
   (tools/clip_gltf.gd `import ... like=mc_Box1_M3_Idle` shows the format) - or Blender's retarget if Godot's cannot reach
   the bars; say which and why. No hand-tuned per-clip fixes. Keep the old .res files as *_old for A/B until Claude OKs.
3. Measure all 145 after; print the table in the PR body (worst 20 first). Then the three FILM clips on the turntable with
   the fight's leg layers OFF (pure clip) and ON, so Claude can see which part trembles.
4. Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`. Do not loosen a bar, do
   not drop clips from the table, do not touch scripts/fight3d layers (WALK1 owns those, next).

## Board bar (operator S399: "i want to start seeing proper clips 8/10 on the board")
Do NOT post clips yourself. Claude posts a re-imported clip only after its numbers pass AND a blind critic scores it 8/10.
List in the PR body the 10 clips with the best raw-vs-ours numbers first, so they are judged first.

## Result lines (PR body)
RESULT: RETARGET_FIDELITY main <n> clips failing -> after <n>
RESULT: method <godot humanoid retarget | blender> - why
RESULT: worst after: <clip slide raw/ours, snaps raw/ours, jitter raw/ours> x5
RESULT: regression <pass/fail per test>

## What would a human do?
Play the bought clip in its own viewer next to ours, frame for frame: if ours shakes and theirs does not, the import is wrong.
