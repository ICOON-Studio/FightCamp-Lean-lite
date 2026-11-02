# TASK GLOVES2 - the gloves look abnormal in the live fight (operator S160)

Owner: Claude (visual; operator judges stills). Model: Fable 5.1 extra-high (operator S161). S162: the fix is the SKINNED glove - `CCFighterSkin._skin_glove`, switch `skinned_gloves`, test `tests/glove_cuff_live_test.gd` (cuff vs forearm in the live room at seed 92012).

## Operator, verbatim (2026-10-04, on a frame of the READROUND video)
"do you find the gloves on the picture normal ?" ... "is it really that hard to attach the gloves to the body?" ...
"you do not need to zoom, i didnt zoom either, its so obvious that the gloves look abnormal"

## TARGET BODIES (operator 2026-10-04: "i hope the fix is done on metahuman models")
The fix is judged FIRST on the four MetaHuman boxers (`assets/models/metahuman/mh_boxer_01..04.glb`, switch
`metahuman_bodies`, OFF by default until MH3's walk polish - record with `-- metahuman_bodies=1`). Then the same check on
the shipped default men (MPFB generator, `skin=generator`) and the Tripo demo pair, because those are what the game
shows while `metahuman_bodies` is OFF. One test covers all three body families; the stills and the clip go to the
operator on the MetaHumans.

## What is measured (S160)
- Recording: `tools/record_room.gd -- discipline=boxing seed=92012 as_game` (demo pair f01 box / f09 bare Tripo
  welters, procedural gloves via `CCFighterSkin.mount_procedural_gloves`). Video
  `previews/readround/readround_boxing.mp4`; frames 0:42-0:46 show a BARE HAND beside the glove on the
  bald fighter, gloves ball-like, no cuff, glove on the shoulder.
- `glove_log=1` (new in record_room): glove ORIGIN = hand bone origin, 0.0 cm, every frame for 50 s. So the glove does
  not drift; the defect is its ORIENTATION/SIZE/OFFSET from the wrist and the hand not being cut.
- `tools/gloves_s155_stills.gd -- tag=s160`: the camera now renders from INSIDE the body (s160_*.png useless) - fix
  its framing first, then use it (it prints finger joints outside the glove box; on Tripo rigs only `Hand` exists, so
  that print is blind - add the forearm and a hand-mesh vertex check).
- `FightBodyCapsules._fit_glove_parts` fits the glove capsule off-tree from identity transforms -> TASK_GLOVEFIT.

## Do
1. Fix the stills tool framing; render both fighters' gloves on the MetaHumans first at the seed-92012 frames (0:43-0:45) AND in guard.
2. Check, per glove: is the hand mesh cut (count hand-weighted triangles left visible); glove long axis vs forearm
   direction (deg); glove size vs head width (a 10-12 oz glove is ~0.28-0.30 m long, ~0.13 m wide; head ~0.15 m).
3. Fix the cause (likely `_pose_glove_tripo` axis/roll on f09/f01 or `hide_hand_meshes` missing their hand binds),
   show the operator a still EARLY ("show a still early, ask what is wrong" - S154 lesson), then a 20 s clip.
Acceptance: operator OK on the still + clip; a test that reads the visible-hand count and glove-vs-forearm angle and
goes red on today's tree.
