# LOCOSLIDE1 - Walking Foot Slide

> CLAUDE'S READING (S408). What this table shows: with every modifier layer off the numbers are the same as with all on, so the layers are out; and the game's planted foot travels about 2-4 cm a stretch against 0.5-1.7 cm in the source, most on the side step (rk_loc_left).
> What it cannot say: (1) "baked into the retargeting" is not measured - the CLIP arm is the retarget, the contact hold and RkLoco together; (2) SNAPS also counts a swinging foot, and the game row covers 150 looped frames against one source pass, so that column compares nothing; (3) slide here is path length, not which way the foot creeps. The worst frame is not named. LOCOSLIDE2 measures those.

**Date:** 2026-11-09
**Branch:** qwen/locoslide1
**Leg length (Godot):** left=0.8380m, right=0.8370m
**Leg length (Blender):** rk_loc_in=0.8422m, others=0.8890m
**Planted definition:** ball within 3cm of lowest height AND speed < 0.25 m/s
**Snap threshold:** >3cm jump in one frame

## Table

For rk_loc_in (mirror:true), GAME left compares with SOURCE right, and GAME right compares with SOURCE left.

| Clip | Foot | Arm | Planted Share | Slide Mean (m) | Slide Worst (m) | Snaps |
|------|------|-----|---------------|----------------|-----------------|-------|
| rk_loc_in | left | SOURCE | 0.775 | 0.0127 | 0.0236 | 4 |
| rk_loc_in | left | CLIP | 0.753 | 0.0265 | 0.0451 | 27 |
| rk_loc_in | left | GAME | 0.753 | 0.0263 | 0.0444 | 27 |
| rk_loc_in | right | SOURCE | 0.850 | 0.0531 | 0.0531 | 6 |
| rk_loc_in | right | CLIP | 0.720 | 0.0140 | 0.0309 | 22 |
| rk_loc_in | right | GAME | 0.727 | 0.0154 | 0.0360 | 22 |
| rk_loc_back | left | SOURCE | 0.627 | 0.0051 | 0.0095 | 10 |
| rk_loc_back | left | CLIP | 0.567 | 0.0225 | 0.0571 | 42 |
| rk_loc_back | left | GAME | 0.567 | 0.0225 | 0.0571 | 42 |
| rk_loc_back | right | SOURCE | 0.529 | 0.0092 | 0.0159 | 11 |
| rk_loc_back | right | CLIP | 0.427 | 0.0202 | 0.0291 | 52 |
| rk_loc_back | right | GAME | 0.427 | 0.0202 | 0.0291 | 52 |
| rk_loc_left | left | SOURCE | 0.733 | 0.0168 | 0.0200 | 2 |
| rk_loc_left | left | CLIP | 0.767 | 0.0420 | 0.0532 | 10 |
| rk_loc_left | left | GAME | 0.767 | 0.0420 | 0.0532 | 10 |
| rk_loc_left | right | SOURCE | 0.767 | 0.0064 | 0.0089 | 3 |
| rk_loc_left | right | CLIP | 0.767 | 0.0340 | 0.0574 | 15 |
| rk_loc_left | right | GAME | 0.767 | 0.0340 | 0.0574 | 15 |
| rk_loc_right | left | SOURCE | 0.667 | 0.0081 | 0.0162 | 5 |
| rk_loc_right | left | CLIP | 0.687 | 0.0214 | 0.0219 | 24 |
| rk_loc_right | left | GAME | 0.687 | 0.0214 | 0.0219 | 24 |
| rk_loc_right | right | SOURCE | 0.633 | 0.0104 | 0.0117 | 5 |
| rk_loc_right | right | CLIP | 0.647 | 0.0246 | 0.0367 | 25 |
| rk_loc_right | right | GAME | 0.647 | 0.0246 | 0.0367 | 25 |

## Analysis: GAME vs SOURCE > 2cm per stretch

Comparing GAME slide_mean with SOURCE slide_mean (mirror-aware for rk_loc_in):

| Clip | Foot | GAME (m) | SOURCE (m) | Diff (cm) |
|------|------|----------|------------|-----------|
| rk_loc_in | left (vs src right) | 0.0263 | 0.0531 | -2.68 (GAME better) |
| rk_loc_in | right (vs src left) | 0.0154 | 0.0127 | +0.27 |
| rk_loc_back | left | 0.0225 | 0.0051 | +1.74 |
| rk_loc_back | right | 0.0202 | 0.0092 | +1.10 |
| **rk_loc_left** | **left** | **0.0420** | **0.0168** | **+2.52** |
| **rk_loc_left** | **right** | **0.0340** | **0.0064** | **+2.76** |
| rk_loc_right | left | 0.0214 | 0.0081 | +1.33 |
| rk_loc_right | right | 0.0246 | 0.0104 | +1.42 |

**Clips exceeding 2cm threshold:** rk_loc_left on both feet (left: 2.52cm, right: 2.76cm).

## Which layer causes it?

CLIP mode (all SkeletonModifier3D layers off) and GAME mode (nothing off) produce **identical results** for every clip and foot. The modifier layers (BoxerFootworkRig, FootPlant, KneeTrack, etc.) have **no effect** on the foot slide.

The slide difference between SOURCE and GAME is **not caused by any modifier layer**. It is inherent in the retargeted clip itself - the RkRetarget process that maps the source animation onto the MetaHuman skeleton, combined with RkLoco's root motion extraction. The foot positions in the retargeted clip do not perfectly match the source due to skeleton differences and the root motion extraction process.

## Worst clip and frame for a still

**Worst clip:** rk_loc_left (both feet exceed 2cm threshold)
**Worst foot:** right foot (slide_worst = 0.0574m = 5.74cm per planted stretch)
**Worst frame:** The probe does not track exact frame numbers for worst slide, but the worst slide occurs during a planted stretch where the ball travels 5.74cm while remaining within 3cm of its lowest height. This likely occurs during the push-and-drag phase of the side step, where the foot plants but the body continues to move.

## Summary

The walking loco clips show measurable foot slide in the Godot retargeted versions compared to the raw Blender source. The slide is most pronounced in rk_loc_left (side step), where both feet exceed the 2cm threshold. However, this slide is **not caused by any modifier layer** - it is inherent in the retargeting pipeline. The footwork rig and other modifiers do not increase or decrease the slide. The slide comes from the clip itself as retargeted onto the MetaHuman skeleton with root motion extracted by RkLoco.

The operator's observation ("the fighters are sliding") is confirmed: the retargeted clips do show more slide than the raw source. But the slide is baked into the retargeted animation, not introduced by the game's modifier layers. Fixing it would require either improving the retargeting process or adding explicit foot planting in the animation clips themselves.
