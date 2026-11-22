# FP2POSE3 - the cross's rear knee, a boxer's stance length, the rear heel on hooks and uppercuts

S537, 2026-11-22. Fight player v2 only (METHOD S510). Round 3 after docs/FP2POSE2_RESULT.md. Everything is done OFFLINE
at the bake (the S529 step refit's verdict, ops/research/FIGHTPLAYER2_SCOPE_S510.md); no runtime layer was added.
The owner closes this, not a test. Films and stills: `ops/previews/s537_fp2pose3/` (game camera, both men head to feet,
hidden desktop; every one opened by me).

## 0. The rear knee on the cross (owner S537: "blue fighter twists knee unnaturally outwards when he throws", "the power does not come from twisting the knee use our research/clips")

### Why it happened
The FP2POSE2 bake turned the rear foot in about its ball (to a fixed 12 deg off the punch line, 37-46 deg from the
guard) and solved the leg again "with the knee in the plane it bends in" - the plane the FLAT-FOOTED actor bent it in.
The foot turned in under a knee that did not: the knee ended outside its own toes, and the foot's turn itself was an
invented number (K46: no study gives a pivot angle; "never invent pivot deg").

### The references (our research and clips), one ruler for all
| what | real / captured | our takes as bought | FP2POSE2 bake | now |
|---|---|---|---|---|
| where the knee points against its own toes at the contact (- = inside) | Mixamo Cross_Punch -41 deg, Cross_Punch__A -24; our own two takes with a real leg drive -51, -45 | -4 to -51 | **+1 to +14 on 6 of 9 takes** (outside the toes) | **-12 to -41, every take** |
| the knee's direction against the PELVIS, guard -> contact | changes 7 and 9 deg (Mixamo), 2 and 3 (ours): the thigh goes round with the hip | lags the hips 8-25 deg on 6 takes | lags the same | 0-1 deg: it goes with the hips |
| rear foot's turn at the contact | Cross_Punch 20 deg for 54 of hips (0.37 a degree); no study (K46) | 0-12 | 13-30 (to a fixed 12 deg off the line) | 0-20 = 0.37 x the take's own hip turn |
| rear ankle extension | ~12 deg (Cheraghi 2014; his table 73 -> 98) | -6 to +8 | +4 to +17 | +6 to +18 |
| rear knee at the impact | 143 +- 16 deg (Dinu & Louis 2020) | 139-155 | 128-144 | 127-143 |
| rear knee THROUGH the drive | extends ~25 deg (Cheraghi) | extends 0-27 from its deepest | flexes 6-15 into the contact | **still flexes 1-16** (see "Not fixed") |
| hips forward by the impact | 27.8 +- 6 cm (Cheraghi; CROSS_POWER_S439) ; Cross_Punch__A 11.6 | 0-3 cm (the hard take 9.5) | same | **same: not touched** |
| rear heel at the contact (as drawn) | Cross_Punch +4.7 cm | -1.7 to +3.9 | +3.6 to +4.9 | +3.6 to +4.9 |
The labelled fight clips in E:/FightCamp/fight_video_data were not used for these: they hold 2D picture positions,
no leg joint angles a foot's turn or a knee's direction can be read from. The measured references are the two captured
Mixamo crosses (on our body, FP2POSE2's route) and the studies.

### The fix (tools/cross_legs_bake.gd, the 9 files re-baked)
- **The knee goes with the hips.** After the leg is solved onto the raised ankle it is swung about its own hip-ankle
  line until the knee points where it pointed against the pelvis at the take's start - the captured rule above. Nothing
  twists at the knee; the thigh is carried round by the hip.
- **The foot turns the captured share**, 0.37 of the take's own hip turn, never past 12 deg off the line. A take whose
  hips turn 14 deg gets 5 deg of foot; the plain cross (hips 52) gets 19.
- The heel lift is FP2POSE2's (ankle extension 6-18 deg, the study says ~12).

### As drawn in v2 (tests/player2_test.gd KNEE, blue, every cross take v2 plays)
| | knee against its toes at the contact | knee further out of the hip-foot line than in the guard |
|---|---|---|
| the takes as bought (`fp2nocrosslegs`) | -4 to -55 deg | 1.5-6.9 cm |
| FP2POSE2 bake | **+3** to -41 (7 of 8 within 5 deg of the toes or outside) | 2.5-**10.2** cm |
| now | -16 to -42 | 3.0-6.6 cm |
The brief's wording "on or inside the line from the rear hip to the rear foot" is not what a bent leg does even in
the captured cross (11.5 cm outside at the contact): the bar is the two things the captures do share - the knee
INSIDE its toes (8 deg or more) and no more than 7 cm further out than in the guard. Red on the FP2POSE2 bake
(least +3 deg, most +10.2 cm), green now.
Films: `0_knee_cross_a_before_left_after_right.mp4` (the take where it showed most: before, the rear shin splays out
and the heel kicks round; after, the shin stands up behind the lead leg) and `0_knee_cross_...` for the plain take.

## 1. Measured first: the stance (tools/stance_bake.gd prints it; the takes as baked, ankle to ankle, cm)
| takes | n | length at the start, before -> after | width | chest ahead of hips | hips between the feet (0 rear, 1 lead) | length at the contact | width at the contact | chest ahead at the contact |
|---|---|---|---|---|---|---|---|---|
| guard loops st_wait, st_wait_g | 2 | 38 -> 54 | 34-35 | +2 | 0.49-0.50 -> 0.42-0.43 | - | - | - |
| jab | 8 | 37-38 -> 53-54 | 34-37 | -1 to +1 | 0.42-0.50 -> 0.37-0.43 | 36-45 -> 52-61 | 33-41 | -5 to +9 |
| cross | 8 | 35-37 -> 51-53 | 34-36 | -1 to 0 | 0.47-0.50 -> 0.41-0.42 | 30-34 -> 46-50 | 39-44 | +2 to +14 |
| lead hook | 5 | 33-39 -> 49-55 | 33-36 | -1 to 0 | 0.36-0.50 -> 0.33-0.43 | 38-55 -> 54-71 | 29-46 | -8 to +9 |
| rear hook | 5 | 36-38 -> 52-54 | 35-37 | -1 to 0 | 0.46-0.51 -> 0.40-0.43 | 30-53 -> 46-69 | 42-54 | +1 to +11 |
| lead uppercut | 5 | 34-37 -> 50-53 | 35-36 | -1 | 0.43-0.48 -> 0.37-0.41 | 37-40 -> 53-56 | 33-37 | -8 to +11 |
| rear uppercut | 3 | 37-38 -> 53-54 | 35-36 | -1 | 0.44-0.52 -> 0.38-0.44 | 24-35 -> 40-51 | 40-48 | +5 to +13 |
| refitted steps | 8 | 38 -> 54 | 35 | +2 | 0.49 -> 0.42 | - | - | - |
| reactions / blocks / dodges / idles | 61 | 30-54 -> 46-70 (the guard's 34-40 -> 50-56) | 17-57 | -1 to +7 | 0.38-0.64 -> 0.34-0.51 | - | - | - |
What it says:
- **The guard is short: 37-38 cm**, against 45-65 for a boxing stance (Dempsey: ~46 cm heel to heel at 5'10", K46 s6).
- **The guard's trunk is not the fault.** The chest is 1-4 cm ahead of the hips in the guard (as drawn too). The
  "9-14 cm ahead" of FP2POSE2 is the CROSS at its contact - the punch's own lean onto the lead leg (K46: 61 % of the
  ground force is on the lead foot at a cross's impact). So the trunk, arms and head are not touched; the base under
  them is made longer. Every glove lands where the census measured it (landed gloves: median 0.006 m, 14 of 14, as before).

## 2. The fix (scripts/fight3d/v2/Stance.gd, tools/stance_bake.gd -> assets/anim/baked/v2/stance/, 119 files, 1.5 MB)
The SAME move on every standing take the census keeps (guard loops, punches, reactions, blocks, dodges, idles, the
refitted steps), so every join meets the stance it left:
- the lead foot stands **12 cm further forward**, the rear foot **4 cm further back** (a constant move in the take's own
  space: a planted foot stays planted, a swung foot lands as far on);
- the hips ride **5 cm lower** (a longer base sits lower; without it the lead knee locks), and lower still, eased,
  wherever a leg would be past 97 % of its length (8.6 cm more at most, in the gut-shot reactions and the dodges);
- both legs solved again; the feet keep their own turn, pitch and height (the cross's raised heel is baked first and kept).
Laid over the takes as the v2 library is built (StepClips.load_into: v2 and its census only; the shipped player keeps
the takes as bought). `-- fp2nostance` = the control arm. Knockdowns and wins are not re-done.
Why 12 + 4 and not the hips kept exactly midway: measured in v2 over 60 s, 7 + 7 added 0.5 m of foot slide and 14 on the
rear foot alone 0.9 m; with the lead foot doing most of it the slide is where it was. 10 + 4 left one guard at 44 cm.
The hips now sit 0.42 of the way from the rear ankle to the lead (0.49 before): a shade on the back foot.

**Rear hooks and rear uppercuts: measured, NOT re-baked.** The brief expected the cross's flat rear foot there. It is
not there: on all 8 that v2 plays the actor's own rear foot is pitched up 17-43 deg at the contact (the crosses: 0-18)
and the knee is 6-53 deg inside its toes. The bake had nothing to add to 6 and would have turned the foot of 2 by a
punch line a hook does not have. As drawn the rear heel is up 3.3-6.0 cm on all 8; the HEEL test now reads them.

## 3. Tests (tests/player2_test.gd; 60 s of two different bodies, mh_boxer_12 against mh_boxer_07)
| bar | before this task | now |
|---|---|---|
| STANCE guard 45-65 cm long, chest within 6 cm of over the hips (new; `fp2nostance`: FAIL 34..46 cm) | 34-46 cm, chest 4 | **46-63 cm, chest 4: PASS** |
| KNEE (new, section 0) | FAIL +3 deg, +10.2 cm | PASS -16 deg, 6.6 cm |
| HEEL, now 16 takes (crosses, rear hooks, rear uppercuts) | 3.6 cm (8 takes) | PASS least 3.3 cm (pro_right_uppercut_hurt) |
| FEET never cross | 20 cm | PASS 26 cm |
| GAZE | 20 deg | PASS 20 deg |
| landed gloves | median 0.006 m, 14 of 14 | the same |
| JUMPS (debt) | 1 | 1 |
| SLIDE (debt) | 6.66 / 6.97 m | 6.70 / 6.88 m (red +4 cm, blue -9 cm: no worse in sum) |
failures=0. Regression: choreographer_test failures=0, arm_build_test failures=0, file_limits_test failures=0,
clip_db_test failures=0.

## 4. Films and stills (ops/previews/s537_fp2pose3/, before left / after right)
- `1_guard_...jpg`: both men in the guard. Before: two boots close together under each man. After: a boxer's base,
  knees bent, sitting lower.
- `2_cross_contact_...jpg`: the plain cross at its contact. After: the lead foot is planted well ahead of the chest,
  the rear foot back on its ball - the lean now has a base under it.
- `3_loop_cross_...mp4`, `4_loop_cross_a_...mp4`: guard -> cross -> guard, four times. No pop at either join.
- `5_loop_rear_hook_...mp4`, `6_rear_hook_contact_...jpg`: pro_right_hook (its legs are the actor's own, on the longer stance).
My read: **7 / 10** (FP2POSE2: 6). He stands and punches like a boxer now; the cross still does not look DRIVEN.

## Not fixed, said plainly (what holds it under 8)
1. **The hips do not drive forward.** Real: 28 cm; the captured stepping cross 11.6; ours 0-3. With the hips in place a
   raised heel can only BEND the rear knee into the contact (1-16 deg), where a real cross straightens it ~25 deg - the
   in-place Mixamo cross bends 8 the same way. This is the owner's "power" point and the next item: a hip drive of
   10-18 cm on power punches (CROSS_POWER_S439 fix 3) with the reach census re-run, since the gloves then travel further.
2. The hips sit a shade on the back foot (0.42) because moving the rear foot back costs slide in v2's foot pins.
3. A guard taken straight after a stepping cross is as short as 46 cm (the pins hold the feet where the step left them).
4. Rear uppercuts land with the feet only 40-51 cm apart along the line (24-35 before): the actor steps his rear
   foot up under him on two of the three.
5. The stance bake was made on mh_boxer_01 and is played on every body (like every baked take); read as drawn on 07
   and 12 only.
6. Foot slide (6.7 / 6.9 m a minute) and the one head jump are the same debt as before.

## Outside the brief's owned files (2 lines)
`scripts/fight3d/v2/StepClips.gd`: one preload and one call (`Stance.load_into`) at the end of load_into - the step
takes enter the library there, after CrossLegs, so the stance cannot be laid over them from CrossLegs.gd.
Also `tools/cross_legs_bake.gd` (step 0 names it). Order when re-baking: cross_legs_bake, then stance_bake.

## Prefab check
Mixamo Cross_Punch and Cross_Punch__A measured as references (E:/FightCamp/packs/mixamo_cross, outside the repo);
nothing of theirs is in the repo.
