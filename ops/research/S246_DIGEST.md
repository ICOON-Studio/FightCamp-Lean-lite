# S246 DIGEST - 2026-10-17 - MetaHuman motion: twist bones driven, walk posture fixed, ActionForge clips one-to-one

Operator, this session (verbatim): "the moment the fighter moves he stops look like a human", "his right arm is missing you can't
see that ???", "check the whole rigging process what is correct what is in the game fix a fucking animation properly", "his posture is
wrong his shoulders are way back than normal", "Use the ActionForge walk in the game, and use ActionForge clips for the other
MetaHuman moves too", "the sword animations are like punches because he is not holding a sword".

## What now works (pushed)
- **MetaHuman twist bones driven** (3c2a4715): `scripts/MetaHumanTwist.gd` (SkeletonModifier3D) turns lowerarm/upperarm/calf/thigh
  twist bones every frame like UE's MetaHuman post-process rig (forearm 0.67/0.33 of the hand's roll, upper arm -0.67/-0.33);
  `MetaHumanRig.fold_static_skin_weights` no longer folds their skin into the elbow/shoulder (STAFF1 S141 had). tests/mh_twist_bones_test.gd
  24 fails on master -> 0 (mh_boxer_01 + mh_staff_coach).
- **Walk posture**: the UE4->MetaHuman retarget re-aimed the clavicles at the mannequin's collarbone direction - the walk pulled the
  shoulders 13 cm behind the neck (source take: 2 cm). UALMotion TORSO_PAIRS now include the clavicles. tests/ual_walk_posture_test.gd
  (walk-minus-rest changes vs the source take, two bodies) 8 fails on master -> 0.
- **ActionForge** (077dc4c5, 83701096): 49 CC0 takes (Quaternius UAL via actionforge.app, exported on UE5 Manny = MetaHuman bone layout,
  in place, animation only) in `assets/anim/actionforge` (CREDITS.md). `AFMotion.build(skel, role)` plays them one-to-one
  (pose_mh = rest_mh * rest_manny^-1 * pose_manny, no re-aim; rests agree within ~5 deg - tools/s246_af_inspect.gd), plants the lowest
  foot at every key. `UALMotion.build` hands every MetaHuman to AFMotion: gym walker, coach, staff idles, profile stage now play the
  ActionForge walk/idle/talk/sit. tests/af_motion_test.gd 0 fails (49 roles x 2 bodies; control: the retarget route still builds).
- **Pad round kit** (51ff685c): boxing gloves + true-size focus mitts (CCFighterSkin "focus" style) on the PadPair round, off at its end;
  the station tag no longer covers the pair in a close-up (ClubRoomBase lost GymHall3D's rule in ROOMSPLIT1). Probe gates added:
  guard hand stays on its own side; glove stays outside its own head.
- **DecisionPacing restored** (f3563220): DecisionPacing.gd + its test were 0 bytes on master since the S238 collect (Grok Dev found it).

## Evidence
- run_tests --only af_motion,ual_*,mh*,staff_pose,profile_stage,gym_club,gym_hall,coach,training_floor,pad_pair... --jobs 3: SUITE total=33 fails=0.
- Videos/sheets on 8787/review: mh_walk.mp4 (shipped), s246_walk_fix/before_after.jpg, s246_walk_af/three_way.jpg (shipped / fixed retarget /
  ActionForge), gym_walk_game_camera.mp4, s246_strikes/strike_sheet_0/1.jpg, s246_padpair/real_vs_ours.jpg.
- Real reference footage (Pexels, free licence, scratchpad only): pad work 7187396/6296443, walking 5632039/9488251 (mocap-suit side walk).

## Not done / still wrong
- **PADPAIR1 pad clip fails its own new gate**: rear glove ~10 cm inside the head (f096 -0.099 m), coach mitts held at his own face.
  Head-locked guard tried (author_padpair.py) - glove follows the head but its offset is still inside; reverted, not committed.
  Next: set the guard offset from the MEASURED head geometry in the game (probe prints clearance), rebuild, side sheet vs footage.
- Strike sheet verdict: jab, cross, shield_bash read as boxing punches; melee hook, overhand and every sword clip are lunging haymakers -
  kept under source names, NOT wired as boxing punches. shield loop is not a cover-up.
- Grappling (operator: "it may have more things we can use for the grappling"): the askNK video (i4lCE-_Uem0, full transcript read)
  shows ActionForge as a ONE-character editor - import own motions (GLB best), compose/layer per body part, IK pins + pole vectors, pose
  layers on a timeline, blend, Motion Lab posture/gait/8-direction. No two-body contact tools, no grappling clips. Use: clean single-body
  takes on the MetaHuman; two-body holds stay on Cascadeur (D13). Grappling is MMA - PARKED for the boxing demo.
- Q-S242-4 (CAMFOV17 close) still unanswered. Q-S242-5 (QuickMagic) superseded by the ActionForge route.

## In flight
- Grok Dev NIGHTLY9 (TASK_NIGHTLY9.md): rivalry-heat drain per live tick, hands-smooth gate excludes the contact glove, clip slice on
  played length. Branches grok/nightly9-*.

## Lessons (rules this session earned)
- A body check must look at the SURFACE (glove inside head, arm through face), not only bones - every S244 gate passed a broken clip.
- A MetaHuman needs its helper bones driven; folding their skin is never "safe".
- Retarget between rigs: copy each bone's change from rest, never another rig's absolute bone direction (spine S210, clavicles S246).
- Reference footage first, frame by frame, full body with feet - before any motion is judged or authored.
