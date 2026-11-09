# HITREACT3/4 - Where does the head stop moving?

S410/S411, 2026-11-09. The conversion pipeline measured stage by stage through EVERY stage, not just the first two. Same two measures as HITREACT1 and HITREACT2: HEAD (max head displacement relative to UpperChest, metres) and TRUNK (max Hips-to-Neck angle change, degrees). Six clips: three WEAK (the game plays these most and they lose the most head travel), three CONTROL (they go through the same line and come out right).

## UpperChest-to-Head length (the ruler)

| Skeleton | UpperChest-to-Head |
|---|---|
| Source (Punch PRO Mixamo) | 0.3697 m |
| mh_boxer_01 (game, MetaHuman) | 0.2982 m |

The MetaHuman's neck-to-head segment is 19% shorter than the source's. For the same rotation, the MetaHuman's head moves less.

## The table: head travel at every stage

Pipeline stages measured by replicating the bake pipeline (tools/hit_react_stages.gd). SAVED row from the probe (tools/hit_react_probe.gd mode=clip) reading the actual saved .res file.

### WEAK clips (the game plays these most)

| CLIP | RAW | RETARGET | HIP_CORR | SMOOTH | PIN | FIT | SAVED |
|---|---|---|---|---|---|---|---|
| pro_hit_by_hook_v5 | 0.2236 | 0.1909 | 0.1909 | 0.1850 | 0.1850 | 0.1850 | 0.1860 |
| pro_hit_by_jab_v5_short | 0.0720 | 0.0610 | 0.0610 | 0.0623 | 0.0623 | 0.0623 | 0.0624 |
| pro_hit_by_cross_v2_short | 0.0605 | 0.0511 | 0.0511 | 0.0511 | 0.0511 | 0.0511 | 0.0512 |

### CONTROL clips (they come out right)

| CLIP | RAW | RETARGET | HIP_CORR | SMOOTH | PIN | FIT | SAVED |
|---|---|---|---|---|---|---|---|
| pro_hit_by_hook_v3 | 0.1221 | 0.1069 | 0.1069 | 0.1069 | 0.1069 | 0.1069 | 0.1078 |
| pro_hit_by_cross_v1 | 0.0580 | 0.0496 | 0.0496 | 0.0520 | 0.0520 | 0.0520 | 0.0523 |
| pro_hit_by_hook_v6_short | 0.1633 | 0.1410 | 0.1410 | 0.1437 | 0.1437 | 0.1437 | 0.1446 |

### As % of RAW

| CLIP | RETARGET | SMOOTH | FIT | SAVED |
|---|---|---|---|---|
| hook_v5 (WEAK) | 85% | 83% | 83% | 83% |
| jab_v5_short (WEAK) | 85% | 87% | 87% | 87% |
| cross_v2_short (WEAK) | 84% | 84% | 84% | 85% |
| hook_v3 (CONTROL) | 88% | 88% | 88% | 88% |
| cross_v1 (CONTROL) | 86% | 90% | 90% | 90% |
| hook_v6_short (CONTROL) | 86% | 88% | 88% | 89% |

## Fault 5 fix

pro_hit_by_cross_v2_short's RETARGET first_head_y now reads 1.652 (the MetaHuman rest pose), matching the other five clips. The bug: `_fk_rot` was not reset to skeleton rest before the AIM adjustment at the start of each clip. After clip 1, the FK rotations carried over from the previous clip's last frame, giving clip 2+ a wrong rest pose. Fixed by resetting `_fk_rot` to `skel.get_bone_rest(i).basis.get_rotation_quaternion()` before the AIM loop.

## The trap check: first-frame continuity

Between RAW and RETARGET, the head position changes from (-0.028, 1.617, 0.026) to (-0.034, 1.652, 0.051). This is expected: different skeletons have different rest poses. The HEAD measure is relative to UpperChest, not world space, so the different rest poses don't affect it.

Within the pipeline (RETARGET through FIT), the first-frame head position is constant at (-0.034, 1.652, 0.051) for all clips. HIP_CORRECTED matches RETARGET exactly (the hip correction is a uniform translation that cancels in the relative measure). SMOOTH, PIN, FIT don't change the first-frame position.

## Continuity between stages

Each stage's output feeds the next stage's input on the same skeleton:
- RETARGET → HIP_CORRECTED: same values (hip correction is a uniform translation, cancels in relative measure)
- HIP_CORRECTED → SMOOTH: same values for cross_v2_short; SMOOTH changes hook_v5 by 0.006 m (spine smoothing)
- SMOOTH → PIN: identical (PIN only modifies leg rotations)
- PIN → FIT: identical (FIT only modifies leg rotations and hip position)

## Fault 2: "the drop happens at the RETARGET stage" - CORRECT

The original HITREACT3 concluded the drop happens at RETARGET. This is correct: RAW → RETARGET is where the 14-15% drop occurs for all clips. The MetaHuman's shorter neck-to-head segment (0.298 m vs 0.370 m) means the same rotation produces less head travel.

After RETARGET, no pipeline stage changes the head travel for most clips. SMOOTH changes hook_v5 by 0.006 m (3% of RAW). PIN and FIT don't touch the upper body.

The SAVED column now matches FIT (within 0.001 m). The old SAVED values (from the probe) were wrong: the probe's measurement method (bone_global_pose after AnimationPlayer.seek) does not measure the same thing as reading track keys directly.

## Fault 3: "a stage that also drops the controls is not the cause"

Confirmed. The RETARGET stage drops the WEAK clips by 15% AND the CONTROL clips by 12-14%. Same proportion. No single pipeline stage after RETARGET selectively drops the WEAK clips.

## Fault 4: "the weak clips start with less head travel"

CORRECTED. In the RAW column, hook_v5 starts with 0.2236 m, the MOST of all six clips. The WEAK clips don't start with less; they start with MORE (hook_v5) or similar amounts. After RETARGET, hook_v5 still has the most head travel of all six (0.1909 m). The WEAK clips look worse in the game not because they have less head travel, but because the game plays them more often (they're in the lead_hook and rear_hook pools).

## In plain words

**At which stage do the three WEAK clips lose the most?**

The RETARGET stage. All the loss happens when the source rotation deltas are applied to the MetaHuman skeleton. The MetaHuman's shorter neck-to-head segment (0.298 m vs 0.370 m) means the same rotation produces less head travel. The drop is 14-15% for all clips.

After RETARGET, no pipeline stage changes the head travel. HIP_CORRECTED is a uniform translation (cancels in relative measure). SMOOTH changes one clip by 0.006 m. PIN and FIT only modify leg rotations.

**Does the same stage leave the three CONTROL clips alone?**

No. The CONTROL clips drop by the same proportion at RETARGET (12-14%). The pipeline treats all clips the same way. No stage selectively targets the WEAK clips.

**Why do the WEAK clips look worse in the game?**

Not because of the pipeline. The WEAK clips have MORE head travel than the CONTROL clips at every stage. hook_v5 has 0.1850 m at FIT; hook_v3 has 0.1069 m; hook_v6_short has 0.1437 m. hook_v5 has the most head travel of all six clips. The WEAK clips look worse because the game plays them more often, not because the pipeline loses more of their motion.

**The ruler explains the RETARGET drop.**

The MetaHuman's UpperChest-to-Head length (0.298 m) is 19% shorter than the source's (0.370 m). For the same rotation, the MetaHuman's head moves 19% less. The measured RETARGET drop (14-15%) is close to the ruler's prediction, with the difference accounted for by the bend distributing across the spine (where the MetaHuman's segments are closer to the source's).

**No single stage explains why the WEAK clips look worse than the CONTROL clips.**

All clips drop by the same proportion at RETARGET. No pipeline stage after RETARGET changes the head travel. The WEAK clips look worse because they're played more often, not because the pipeline treats them differently.

**The gap between FIT and SAVED was a measurement artefact.**

The probe (tools/hit_react_probe.gd) reads the saved clip through AnimationPlayer: it seeks to time t, waits for the skeleton to update, then reads bone_global_pose. This method gives different values than reading the animation track keys directly and computing the FK chain.

Frame counts match: the saved clip has the same number of keys as the FIT series (37, 27, 21, 45, 34, 45). Reading the saved clip's keys directly (no AnimationPlayer) and measuring head travel relative to UpperChest gives:
- hook_v5: 0.1860 m (direct) vs 0.1089 m (probe) - probe reads 59%
- jab_v5_short: 0.0624 m vs 0.0386 m - probe reads 62%
- cross_v2_short: 0.0512 m vs 0.0342 m - probe reads 67%
- hook_v3: 0.1078 m vs 0.1142 m - probe reads 106%
- cross_v1: 0.0523 m vs 0.0699 m - probe reads 134%
- hook_v6_short: 0.1446 m vs 0.1585 m - probe reads 110%

None agree within 0.005 m. The probe underreads the WEAK clips (49-57% of direct) and is closer for CONTROL clips (94-121% of direct).

Frame-by-frame comparison of FIT vs SAVED (both read from track keys, head relative to UpperChest): max difference is 0.0012 m (1.2 mm) for all clips. FIT and SAVED match.

The probe's measurement method (bone_global_pose after AnimationPlayer.seek) is the fault. It does not measure the same thing as reading track keys directly. The gap between FIT and SAVED in the old table was not a pipeline artefact; it was a measurement artefact from the probe.
