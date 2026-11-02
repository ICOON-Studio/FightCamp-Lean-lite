# TASK MIXAMO1A (S216) - bake the 115 approved Mixamo clips onto the MetaHuman fighter skeleton + catalogue + gates

Model: cloud Cursor (composer-2.5, `.github/workflows/cloud-agent.yml`, label `cursor`). Repo ICOON-Studio/FightCamp, branch from master.
Work on your own branch, open a PR, never merge. Do NOT commit `.import` / `.uid` files.

## Why
S215 downloaded 115 Mixamo clips (Ludo round 47 approved batch A: hit reactions, knockdowns, get-ups, idles, walks, blocks,
win/loss) into `Godot/assets/anim/mixamo_s215/*.fbx`. Nothing turns them into motion on our MetaHuman fighters yet. This task
produces animation-only bakes on the MetaHuman skeleton, one catalogue row per clip, and a test that reads them. NO fight wiring
here (that is MIXAMO1B, after this lands) - do not edit FightStagePlayer.gd, FightClipBinding.gd or any screen.

## The pattern to copy (already merged, operator-approved on the gym floor walkers)
`Godot/assets/anim/ual/UALMotion.gd` (109 lines) retargets UAL (UE4 mannequin) clips onto a MetaHuman skeleton through the
project's own `FightClipRetarget.retarget_clip`, folds intermediate rests (`MetaHumanRig.fold_intermediate_rests`), plants the
feet on the floor, and the `.res` bakes sit beside it (`assets/anim/ual/*.res`), checked by `tests/ual_clips_test.gd` (154 lines).
Copy that structure for Mixamo. Read-only references:
- `Godot/scripts/FightClipRetarget.gd` (1,511 lines - never read whole; `grep -n "static func"` then read the windows for
  `_load_fbx`, `_index`, `_globals`, `_local_at`, `_to_ours`, `silhouette_rest`, `RestFixer`, `retarget_clip`, `_contact_globals`,
  `_source_cache`, `SILHOUETTE_SEGMENTS`).
- `Godot/scripts/MetaHumanRig.gd` (434 lines): `load_fighter`, `fold_intermediate_rests`, `UE5_TO_OURS`.
- `Godot/tools/c223_mixamo_adapter.gd` (264 lines): line 7 = the Mixamo joint list; line 81 = Godot's FBX import names joints
  `mixamorig_Hips` / `mixamorig:Hips` - strip either prefix.

## Owned files (all NEW)
- `Godot/assets/anim/mixamo_s215/MixamoMotion.gd` - `build(skel: Skeleton3D, file: String, broken := false) -> Animation`.
- `Godot/tools/mixamo_s215_bake.gd` - SceneTree script: bakes every `*.fbx` in the folder onto `mh_boxer_01.glb`'s skeleton,
  writes `Godot/assets/anim/mixamo_s215/mh/<id>.res` and `Godot/assets/data/mixamo_s215_catalogue.json`.
- `Godot/assets/anim/mixamo_s215/mh/*.res` (115 bakes) + `Godot/assets/data/mixamo_s215_catalogue.json`.
- `Godot/tests/mixamo_s215_test.gd`.

## Spec
1. Joint map, source -> ours (strip the prefix first): Hips->Hips, Spine->Spine, Spine1->Chest, Spine2->UpperChest, Neck->Neck,
   Head->Head, LeftShoulder->LeftShoulder, LeftArm->LeftUpperArm, LeftForeArm->LeftLowerArm, LeftHand->LeftHand,
   LeftUpLeg->LeftUpperLeg, LeftLeg->LeftLowerLeg, LeftFoot->LeftFoot, LeftToeBase->LeftToes, and the same for Right.
   Build the map from the joint names the imported FBX actually has; a clip missing any of the 22 joints is a FAIL row, not a crash.
2. Keep UALMotion's torso rule: the Hips->Spine->Chest->UpperChest pairs are NOT re-aimed at the source rest (S210 trap: copying
   the source's absolute lumbar aim bent every MetaHuman forward at the pelvis - pot belly, bent knees). Use its
   `posture_segments()` logic.
3. Floor: per sample, plant the LOWEST of ALL mapped joints at y = 0 (not only the feet - a man lying on the canvas rests on his
   back/stomach, not on a buried toe). Keep the hips' horizontal travel (a hit reaction steps back; a fall travels) - do not zero it.
4. Loop: LOOP_LINEAR only for idles and walks (file name contains `Idle` or `Walk`, except `Injured_Stumble_Idle` which also
   loops); every reaction, fall, get-up, block react, strike, victory and defeat one-shot is LOOP_NONE.
5. id = file name lower snake case, `(1)`/`(2)` -> `_v1`/`_v2`, double underscores collapsed.
6. Catalogue row per clip (JSON array, sorted by id): `id, file, bake, category, target, side, power, fall, loop, length_s,
   fps_source, root_travel_xz_m, root_yaw_deg, hips_h_start_m, hips_h_end_m, hips_h_min_m, joints_mapped, gate` (gate = "PASS" or
   the first FAIL reason). PROVISIONAL tags from the file name (Ludo will correct them; keep the rules in one function):
   - category: `knockdown` (Knocked_Down, Knocked_Out, Falling_, Shoulder_Hit_And_Fall, Stunned__Male_Knocked_Down, Turn_To_Knocked,
     Getting_Hit_Backwards), `getup` (Getting_Up, Stand_Up, Standing_Up__Standing_Up_From), `block_react` (Standing_Block_React),
     `block` (Block, Blocking), `react_body` (Body, Rib, Kidney, Liver, Stomach, Side_Hit, Big_Side_Hit), `react_head` (Head, Face,
     Uppercut received, Rocked, Taking_Punch, Standing_React_*, Reaction__Male_Reaction, Hit_Reaction*, Getting_Hit_From_Back),
     `win` (Victory), `loss` (Defeat), `hurt_idle` (Injured), `walk` (Walk, Dodge, Side_Step), `idle` (Idle), `strike` (the
     Boxing_* uppercuts, *_Body_Jab, *_Hook_Punch_*, Right_Hook, Boxing_Body_Jab_Cross), else `other`. First match in that order.
   - target head|body|"" ; side left|right|front|back|"" (From_A_Left_Punch -> left, Right -> right, Straight/Front -> front,
     Back -> back); power light|medium|big|"" (Light/Small -> light, Medium -> medium, Big/Large/Rocked -> big);
     fall back|stomach|side|"" for knockdowns (and the lying position a get-up STARTS from: From_Back -> back,
     From_Stomach/Prone/Lying_On_Stomach -> stomach).

## Gates (in `tests/mixamo_s215_test.gd`, PASS/FAIL lines like `ual_clips_test.gd`)
Population: bakes are made on `mh_boxer_01`; the test ALSO plays every bake on `mh_boxer_03` (a different body - never test one
fighter only) and prints which body each line is about. Per clip, sampled every 1/30 s on each body:
- the bake exists, loads, has tracks, its length is within one frame of the source clip; no NaN/INF in any key.
- floor: the lowest joint sits in [-0.02, +0.05] m on every sample.
- standing clips (every category except knockdown, getup, and `other`): hips height >= 0.60 x the body's standing hips height on
  every sample.
- knockdown: hips at the end <= 0.45 m. getup: hips at the start <= 0.45 m and at the end >= 0.85 x standing hips height.
- no sample has a hand joint below the floor or more than 0.25 m above the head while category is react_head/react_body/block.
- catalogue: 115 rows, ids unique, every row's bake file exists, every `category` is one of the listed values.
- INSTRUMENT CAN READ WORSE (mutant, required): bake one clip with `broken = true` (map LeftUpLeg/RightUpLeg -> the upper ARMS, like
  UALMotion's `broken` flag) and assert the standing-hips or floor gate FAILS on it; print the FAIL line it produced.
- `tests/ual_clips_test.gd` still passes (you must not change UAL behaviour).

## Commands (the one tier: new files only -> parse + this test + ual_clips_test)
- `godot --headless --path Godot --import` once (imports the FBX; ~115 files).
- `python Godot/tools/check_scripts.py Godot/assets/anim/mixamo_s215/MixamoMotion.gd Godot/tools/mixamo_s215_bake.gd Godot/tests/mixamo_s215_test.gd`
- `godot --headless --path Godot --script tools/mixamo_s215_bake.gd`
- `godot --headless --path Godot --script tests/mixamo_s215_test.gd` and `--script tests/ual_clips_test.gd`
A test passes only if it prints no FAIL line, no SCRIPT ERROR, and exits 0. Paste both tests' last 30 lines in the PR body,
plus the catalogue's category counts and every clip whose gate is not PASS (with its reason). Do not delete or weaken a gate to go green:
a clip that fails stays in the catalogue with its FAIL reason.

## Prior research
`research/topics/retarget_rig.md` (KEEP OUR RETARGET; one canonical rig), `topics/hit_reactions.md` (reactions play whole on
the blow, U159), `C212_DIGEST.md` (Mixamo training audition on our rig, explicit 22-row map), `LUDO_ROUND47_VERDICT_S215.md`
(the approved batch), `LUDO_ROUND16_S193.md` s3 (knockdowns and get-ups).

## What would a human do?
A technical animator batch-retargets the Mixamo pack onto the game skeleton with one bone map, plants it on the floor, and walks the
whole set through an automatic check (floor, height, NaN) before an animator looks at a single clip.

## Prefab check
Godot's own retarget (BoneMap/SkeletonProfileHumanoid) was measured and lost to ours (`Q82_GODOT_RETARGET_VS_OURS.md`); the UAL
path above is the merged in-house prefab. Licence: Mixamo, royalty-free for commercial games; the raw .fbx must not be
redistributed standalone (private repo only - never attach them anywhere public).

## The one trap
The torso re-aim (spec 2). If every bake leans forward at the pelvis on mh_boxer_03, you copied the source lumbar aim.
