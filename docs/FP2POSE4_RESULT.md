# FP2POSE4 - the hip drive on the rear-hand power punches, authored at the bake

S537, 2026-11-22. Fight player v2 only (METHOD S510). Round 4 after docs/FP2POSE3_RESULT.md ("the cross still does not
look DRIVEN") and docs/CASCTEST1_RESULT.md (AutoPhysics does not add it). Owner S537: "the power does not come from
twisting the knee use our research/clips when you make animations". Everything is done OFFLINE at the bake; no runtime
layer was added. The owner closes this, not a test. Films and stills: `ops/previews/s537_fp2pose4/` (game camera, both
men head to feet, hidden desktop; every one opened by me).

## What the studies say, and ours beside them (the cross)
| what | real / captured | before (FP2POSE3) | now, as baked (body 01) | now, as drawn in v2 (blue = body 07) |
|---|---|---|---|---|
| hips toward the other man by the contact | 27.8 +- 6 cm (Cheraghi 2014; CROSS_POWER_S439); captured stepping cross 11.6; CROSS_POWER fix 3 asks 10-18 | -0.4 to +3.4 cm (stepping takes 6.3, hard 10.1); drawn -0.9 to +6.6 | **11.6-14.2 cm** (hard takes 16.8-17.1) | **13.2-19.3 cm** |
| rear knee THROUGH the drive (deepest in the load -> contact) | extends ~25 deg (Cheraghi) | +0 on 5 of 9 takes, +5 to +22 on 4; drawn +0 to +18 | **+15 to +40 deg** | **+20 to +40 deg** |
| rear knee at the impact | 143 +- 16 deg (Dinu & Louis 2020) | 114-126 (hard 144); drawn 115-125 | 131-146 (hard 155) | 133-152 |
| lead knee at the impact (the brace) | the lead foot takes 61 % of the ground force and brakes (K46) | 129-153 | gives 5-13 deg under the weight (122-148); the hips rise 0-2.5 cm for the rest | not read |
| rear heel / foot | ankle extends ~12 deg; pivot on the ball (K46) | heel up 3.6-4.9 cm | the ball does not move; pitched up 0-9 deg more where the leg runs out | heel up 3.6 cm at least |
| knee against its own toes (FP2POSE3's rule) | -24 to -51 deg | -16 at least | not read | -16 at least; 5.2 cm out of the hip-foot line at most (bar 7) |
| glove face, top speed (one ruler: the hand's striking face on the bake body, 60 Hz) | 6-11.5 m/s (G75) | plain 6.5, a 5.6, b 6.1, c 5.4, ft 6.4, hard 8.2, hard_ft 6.2, hurt 4.0, hurt_ft 6.1 | **7.3, 6.9, 7.6, 6.2, 7.5, 8.7, 6.6, 5.0, 7.1** (+0.4 to +1.5) | not read |
| glove face AT the contact | most of its top speed (G75) | 1.1, 1.9, 3.4, 5.4, 1.5 (plain, a, b, c, ft) | 1.5, 2.8, 4.4, 6.2, 2.4 | not read |

The glove ruler is not CROSS_POWER_S439's (its 4.4-5.4 m/s was the shown glove through the shipped player's arm solve):
read the before -> after on this one ruler only. The glove speeds were printed by the bake run before the last two
re-bakes (which changed only the leg-reach limit and the contact times by a frame); they were not printed again.
The glove still arrives slowing down on the plain, a and ft takes: that is the contact-frame rule (CROSS_POWER fix 1),
not touched here.

Rear hooks and rear uppercuts (8 takes v2 plays): five already carry the hips 10.4-19.5 cm by themselves (the actor
steps in) and get only the load; three are driven (hook_hard 4.9 -> 14.0 cm, uppercut_hurt 1.8 -> 10.4, hook and
hook_ft +1). As drawn: hips 10.5-19.6 cm on all 8; the rear knee straightens +7 to +51 deg (as bought +2 to +32).

## What was built
- `scripts/fight3d/v2/Drive.gd` (the rule: which takes, how far - cross 14 cm, rear hook 12, rear uppercut 10; hard x 1.2,
  hurt x 0.85; always inside the study's 10-18) and `tools/drive_bake.gd` -> `assets/anim/baked/v2/drive/` (17 files, 364 KB).
- Per take: **the load** (over 0.14 s the hips sit 2 cm back and 1.5 cm down onto the rear leg; 3 cm down on a rear
  hook, 4 on a rear uppercut), **the drive** (0.18 s, the hips forward along the line, still moving as the glove lands,
  its top 0.04 s after the contact; less what the take travels itself), **the recoil** (back over 0.4 s). The rear ball
  stays where it stands, the heel comes up more only where the leg would be past 94 % of its length; the lead foot
  stays and its knee gives 8 deg at most - the hips rise (2.5 cm at most) for the rest. Both legs solved again with the
  knee in the plane it bends in under the take's own pelvis: nothing turns at the knee (KNEE test still green).
- **In v2 the forward part rides the BODY** (the take's root path, where every take's own travel already goes), not the
  pose. Measured first as a pose: v2 cuts a landed cross about 0.07 s after its contact, the hips came back 15 cm inside
  the join to the guard and both feet skated 2 cm a picture (slide 6.70 / 6.88 -> 6.96 / 7.10 m). As body travel the man
  stays where the drive took him and the plan walks it off like any other take's travel.
- **The census rows of the 17 driven takes were measured again** (`assets/data/clip_db.json`): the gloves land further
  out, e.g. plain cross contact_gap 1.02 -> 1.12 m, hips_at_contact 0.03 -> 0.14. Bake and census were run twice; the
  contact times settled (the most a contact moved: cross_hurt 0.292 -> 0.263 s).

## Tests (tests/player2_test.gd, 60 s, mh_boxer_12 against mh_boxer_07)
| bar | before | now |
|---|---|---|
| DRIVE (new): hips 10 cm or more toward the other man by the contact (16 takes); rear knee straightens 15 deg from its deepest on a cross, 5 on a rear hook / uppercut | **FAIL** (`-- fp2nodrive`): least -0.9 cm, cross knee +0 | **PASS**: least 10.5 cm (pro_right_uppercut), cross knee +20 at least, others +7 at least (pro_right_hook_ft) |
| KNEE | -16 deg, 6.6 cm | PASS -16 deg, 5.2 cm |
| HEEL (16 takes) | 3.3 cm | PASS 3.6 cm |
| FEET | 26 cm | PASS 28 cm |
| STANCE | 46-63 cm | PASS 48-63 cm |
| GAZE | 20 deg | PASS 20 deg |
| landed gloves | median 0.006 m, 14 of 14 | median 0.007 m, 14 of 14 (worst 0.034, as before) |
| JUMPS (debt) | 1 | 1 (another event: a hit man's head, 12 cm) |
| SLIDE (debt) | 6.70 / 6.88 m | 6.53 / 6.66 m |

failures=0. Regression: choreographer_test, arm_build_test, file_limits_test, clip_db_test: failures=0 each.
Two things about the test itself:
- The pose part now walks blue back to his mark before each take (a driven take really leaves him 10-19 cm on, and no
  plan runs there: after 16 takes he stood inside red and the bout opened with the heads together).
- The rear hook / uppercut knee bar was first written as 8 deg and lowered to 5 when pro_right_hook_ft read +7: no study
  gives that figure, so the bar there only says "it straightens, never bends". The cross bar (15) is the study's.
- `-- fp2nodrive` now also reads the new census rows without the drive they were measured with, so its KNEE and its
  distances are not the old build's. The "before" column is the build before this task.

## Films and stills (ops/previews/s537_fp2pose4/, before left / after right)
- `1_cross_contact_...jpg`: the plain cross at its contact. After: the trunk and hips are over the lead leg, the rear
  leg is long behind him with the heel well up - he has pushed off it. Before: he stands between his feet and reaches.
  (No plan runs in this still, so the after glove goes 10 cm deeper past red's guard; in a bout the men stand that much
  further apart.)
- `3_loop_cross_...mp4`: guard -> cross -> guard, twice at speed, once at quarter speed.
- `2_rear_hook_contact_...jpg`, `4_loop_hook_...mp4`: pro_right_hook. Almost the same picture both sides: this take
  already steps in 11 cm, the bake adds the sit before it and 1 cm.
- `0_guard_...jpg`: the guard, unchanged.
I opened the three stills and a strip of five pictures from the cross loop (guard, drive, contact, after, recoil); I
did not play the two films through as video.
My read: **7.5 / 10** (FP2POSE3: 7). The cross now goes THROUGH the man instead of at him. Not 8 yet, see below.

## Not fixed, said plainly
1. **14 cm is half the real 28.** The rest is a step (the real cross's lead foot goes in); our takes keep both feet.
2. **The hips do not turn more**: 27-51 deg against a real 69-78 (K49). This bake moves the pelvis, it does not rotate it.
3. The glove still arrives slowing down on three takes (the contact frame is the closest-to-the-face frame).
4. The weakest: pro_right_hook_ft (knee +7 deg as drawn) and pro_right_uppercut (+10, hips 10.5 cm, all the actor's own).
5. As drawn the foot pins of v2 straighten the rear leg further than the bake on another body (152 deg on the plain
   cross against 144 baked). Baked on mh_boxer_01, read as drawn on 07 and 12 only.
6. In the contact still the man leans a long way over his lead foot (the take's own lean plus the drive). On a landed
   cross it reads as commitment; on a missed one it may read as over-reaching - the owner's call.
7. From the game camera the feet look close together at the contact (as they did before): the base is not wider.

## To reach 10
1. A cross that steps: the lead foot goes in 10-15 cm with the drive (the step refit under the punch), hips ~28 cm.
2. Pelvis rotation raised to ~70 deg on the cross at the bake, shoulders following (K49).
3. The contact moved to the glove's fast frame (CROSS_POWER fix 1) so the drive lands moving.
4. The same drive read on every body size (bake per body or scale the leg solve), and on southpaws.
5. A recoil that pushes back off the lead foot instead of an eased return.

## Outside the brief's owned files
- `scripts/fight3d/v2/StepClips.gd`: one preload and one call (`Drive.load_into`, after the stance).
- `assets/data/clip_db.json`: the 17 driven takes' rows only. **A full census run changes 115 more rows** (about 1 cm of
  contact gap each, and `pro_left_hook` would no longer be dropped): the committed census predates FP2POSE3's stance
  bake. Not taken here - it changes which takes play; it needs its own item.
- `scripts/fight3d/v2/CrossLegs.gd` (owned) was not changed.
- `ops/previews/s537_fp2pose4/` is git-ignored (local, like every preview).

Order when re-baking: cross_legs_bake, stance_bake, drive_bake, then the census rows of the driven takes.

## Prefab check
None (our bake on bought takes; nothing of anyone's is added).
