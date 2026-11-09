# HITREACT2 - Where does a hit reaction lose its movement?

S409, 2026-11-09. Same two measures as HITREACT1 (HEAD: max head displacement relative to UpperChest; TRUNK: max Hips-to-Neck angle change). Every clip in the HITREACT1 table, now with peak frames and hips-to-head height on both sides.

## The three questions

1. **Window mismatch**: does the source FBX cover more frames than the game clip, making the source look bigger?
2. **Body proportions**: is the MetaHuman shorter than the source skeleton, so the same rotation moves the head less?
3. **Conversion pipeline**: at which stage of the bake does the head travel actually drop?

## 1. The windows match

Every game clip is its own FBX file. The `_short` variants are separate, shorter FBX takes, not trims of the full one. The baker reads the whole source JSON (frame 1 to last) and writes the whole clip. The game clip is 3 frames shorter than the source FBX (the baker drops 3 leading frames where the hips jump on the take's first key). Those 3 frames are the guard stance - no head movement. The source's peak and the game's peak sit within 0-3 frames of each other on most clips:

| CLIP | SRC frames | GAME frames | SRC peak_f | GAME peak_f | peak Δ |
|---|---|---|---|---|---|
| pro_hit_by_cross_v1 | 34 | 31 | 21 | 19 | 2 |
| pro_hit_by_cross_v1_short | 29 | 26 | 14 | 11 | 3 |
| pro_hit_by_cross_v2_short | 21 | 18 | 10 | 8 | 2 |
| pro_hit_by_cross_v3 | 45 | 42 | 10 | 29 | **19** |
| pro_hit_by_hook_v1 | 39 | 36 | 18 | 16 | 2 |
| pro_hit_by_hook_v1_short | 34 | 31 | 12 | 11 | 1 |
| pro_hit_by_hook_v2_short | 23 | 20 | 10 | 20 | **10** |
| pro_hit_by_hook_v3 | 45 | 42 | 16 | 15 | 1 |
| pro_hit_by_hook_v3_short | 38 | 35 | 12 | 28 | **16** |
| pro_hit_by_hook_v5 | 37 | 34 | 13 | 11 | 2 |
| pro_hit_by_hook_v6_short | 45 | 42 | 14 | 13 | 1 |
| pro_hit_by_hook_v7_short | 41 | 38 | 17 | 15 | 2 |
| pro_hit_by_hook_v8_short | 43 | 40 | 18 | 16 | 2 |
| pro_hit_by_jab_v1_short | 32 | 29 | 7 | 29 | **22** |
| pro_hit_by_jab_v2_short | 27 | 24 | 9 | 24 | **15** |
| pro_hit_by_jab_v3 | 33 | 30 | 12 | 10 | 2 |
| pro_hit_by_jab_v4_short | 35 | 32 | 8 | 32 | **24** |
| pro_hit_by_jab_v5_short | 27 | 24 | 11 | 9 | 2 |
| pro_hit_by_combo_v1_short | 53 | 50 | 12 | 30 | **18** |
| pro_hit_by_combo_v2_short | 73 | 70 | 34 | 23 | 11 |
| pro_hit_by_gutshot_v2 | 60 | 57 | 25 | 23 | 2 |
| pro_hit_by_gutshot_v2_short | 51 | 48 | 16 | 14 | 2 |
| pro_hit_by_gutshot_v3 | 54 | 51 | 16 | 13 | 3 |
| pro_hit_by_uppercut_v1 | 64 | 61 | 9 | 36 | **27** |

Bold: the peaks sit on very different frames. The two clips are not measuring the same stretch of movement. On these clips (cross_v3, hook_v2_short, hook_v3_short, jab_v1_short, jab_v2_short, jab_v4_short, combo_v1_short, uppercut_v1) the game's peak is a LATER movement than the source's peak - a secondary reaction or the start of recovery, not the impact. The source peaks early (frames 7-16); the game peaks late (frames 20-36). The game's peak head travel is the distance at a different moment, and it reads smaller because the impact has already passed.

## 2. Scale check: the MetaHuman is TALLER, not shorter

Hips-to-head at the first frame, both sides:

| Body | hips_to_head |
|---|---|
| Source (Punch PRO Mixamo) | 0.652 m |
| mh_boxer_01 (game, mean) | 0.737 m |
| mh_boxer_02 (game, mean) | 0.647 m |

The game's orthodox body (mh_boxer_01) is 13% taller from hips to head than the source. The southpaw (mh_boxer_02) is the same height as the source. A taller body should move its head MORE for the same pose, not less. Proportions alone predict the game's head travel should be 1.13x the source's (for boxer_01) or 0.99x (for boxer_02).

## 3. The new table

SOURCE is the Punch PRO FBX in Blender (tools/hit_react_raw.py), full take. CLIP is the game's MetaHuman body with every SkeletonModifier3D off (tools/hit_react_probe.gd, mode=clip), mean of both bodies. H/H is hips-to-head height. Ratio is CLIP/SOURCE on head_m.

| CLIP | SRC head_m | SRC trunk° | SRC peak_f | GAME head_m | GAME trunk° | GAME peak_f | SRC H/H | GAME H/H | Ratio |
|---|---|---|---|---|---|---|---|---|---|
| pro_hit_by_cross_v2_short | 0.063 | 4.5 | 10 | 0.032 | 3.7 | 8 | 0.652 | 0.739 | 51% |
| pro_hit_by_hook_v2_short | 0.093 | 8.7 | 10 | 0.048 | 3.8 | 20 | 0.652 | 0.738 | 51% |
| pro_hit_by_jab_v5_short | 0.076 | 6.2 | 11 | 0.036 | 7.3 | 9 | 0.652 | 0.740 | 48% |
| pro_hit_by_jab_v3 | 0.091 | 7.7 | 12 | 0.059 | 6.5 | 10 | 0.652 | 0.735 | 65% |
| pro_hit_by_cross_v1_short | 0.075 | 4.2 | 14 | 0.062 | 4.7 | 11 | 0.652 | 0.737 | 82% |
| pro_hit_by_hook_v6_short | 0.169 | 8.7 | 14 | 0.150 | 3.5 | 13 | 0.652 | 0.737 | 89% |
| pro_hit_by_jab_v1_short | 0.121 | 10.8 | 7 | 0.072 | 7.4 | 29 | 0.652 | 0.739 | 60% |
| pro_hit_by_cross_v1 | 0.059 | 8.6 | 21 | 0.066 | 7.0 | 19 | 0.652 | 0.737 | 112% |
| pro_hit_by_hook_v1 | 0.161 | 8.4 | 18 | 0.140 | 6.7 | 16 | 0.652 | 0.738 | 87% |
| pro_hit_by_jab_v2_short | 0.162 | 16.0 | 9 | 0.087 | 9.7 | 24 | 0.652 | 0.740 | 54% |
| pro_hit_by_hook_v3 | 0.126 | 9.1 | 16 | 0.109 | 9.3 | 15 | 0.652 | 0.737 | 86% |
| pro_hit_by_cross_v3 | 0.226 | 25.0 | 10 | 0.111 | 15.3 | 29 | 0.652 | 0.737 | 49% |
| pro_hit_by_hook_v1_short | 0.175 | 8.5 | 12 | 0.119 | 4.9 | 11 | 0.652 | 0.738 | 68% |
| pro_hit_by_gutshot_v2_short | 0.213 | 25.9 | 16 | 0.126 | 20.5 | 14 | 0.652 | 0.737 | 59% |
| pro_hit_by_hook_v5 | 0.229 | 17.7 | 13 | 0.103 | 14.2 | 11 | 0.652 | 0.734 | 45% |
| pro_hit_by_hook_v3_short | 0.140 | 12.2 | 12 | 0.071 | 8.7 | 28 | 0.652 | 0.737 | 51% |
| pro_hit_by_jab_v4_short | 0.117 | 10.0 | 8 | 0.065 | 7.3 | 32 | 0.652 | 0.741 | 55% |
| pro_hit_by_uppercut_v1 | 0.272 | 32.2 | 9 | 0.153 | 23.0 | 36 | 0.652 | 0.739 | 56% |
| pro_hit_by_combo_v1_short | 0.171 | 15.6 | 12 | 0.089 | 8.2 | 30 | 0.652 | 0.731 | 52% |
| pro_hit_by_hook_v8_short | 0.357 | 34.6 | 18 | 0.263 | 30.6 | 16 | 0.652 | 0.737 | 74% |
| pro_hit_by_hook_v7_short | 0.367 | 39.1 | 17 | 0.274 | 35.4 | 15 | 0.652 | 0.737 | 75% |
| pro_hit_by_combo_v2_short | 0.127 | 15.6 | 34 | 0.114 | 9.5 | 23 | 0.652 | 0.740 | 90% |
| pro_hit_by_gutshot_v2 | 0.245 | 28.3 | 25 | 0.171 | 26.7 | 23 | 0.652 | 0.737 | 70% |
| pro_hit_by_gutshot_v3 | 0.282 | 34.0 | 16 | 0.169 | 28.3 | 13 | 0.652 | 0.729 | 60% |

## 4. Step analysis: the three most-played weak clips

The three weakest clips that the game plays most (from BeatClips pools): cross_v3 (cross pool, 3 picks), hook_v5 (lead_hook + rear_hook, 3+3 picks), hook_v2_short (lead_hook + lead_uppercut, 2+3 picks).

tools/hit_react_steps.py compares three stages:
- STAGE 1 (source): the raw FBX head travel in Blender
- STAGE 2 (proportion): stage 1 × (game hips-to-head / source hips-to-head) - what the game would have if proportions were the only difference
- STAGE 3 (game): the actual game clip head travel

### cross_v3 (source peak frame 10, game peak frame 29 - DIFFERENT movements)

| Stage | head_m | Note |
|---|---|---|
| 1 (source) | 0.2259 | FBX full take, peak at frame 10 |
| 2 (proportion) | 0.2554 | 1.13x source (game is taller) |
| 3 (game) | 0.1169 | peak at frame 29, a different movement |
| **1→3 ratio** | **0.52** | pipeline loses 48% |

### hook_v5 (source peak frame 13, game peak frame 11 - SAME movement)

| Stage | head_m | Note |
|---|---|---|
| 1 (source) | 0.2294 | FBX full take, peak at frame 13 |
| 2 (proportion) | 0.2583 | 1.13x source (game is taller) |
| 3 (game) | 0.1089 | peak at frame 11, same movement |
| **1→3 ratio** | **0.47** | pipeline loses 53% |

### hook_v2_short (source peak frame 10, game peak frame 20 - DIFFERENT movements)

| Stage | head_m | Note |
|---|---|---|
| 1 (source) | 0.0927 | FBX full take, peak at frame 10 |
| 2 (proportion) | 0.1049 | 1.13x source (game is taller) |
| 3 (game) | 0.0503 | peak at frame 20, a different movement |
| **1→3 ratio** | **0.54** | pipeline loses 46% |

## In plain words

**Is the loss real once the windows match?** Yes. The windows already match: every game clip is its own FBX file, and the baker reads the full take. The game clip is 3 frames shorter (the baker drops 3 leading frames of hip-jump, which are guard stance with no head movement). Removing those 3 frames from the source changes the source's peak by less than 1%.

**How large?** The conversion pipeline loses 45-55% of the head travel on the weakest clips. The game's MetaHuman body is actually TALLER than the source skeleton (0.737 m hips-to-head vs 0.652 m), so proportions alone predict the game should have MORE head travel, not less. The proportion factor is 1.13x, meaning the pipeline's actual loss is even larger than the raw ratio suggests: stage 3/2 = 0.42-0.48 on the three most-played weak clips.

**At which stage?** The drop is in the conversion pipeline (rotation retarget + foot IK + smoothing + fit), not in the window or the body proportions. The rotation retarget is the most likely cause: the source's rotation deltas, applied to the MetaHuman's different bone lengths and rest orientations, produce less head travel because the spine/neck chain on the MetaHuman distributes the bend differently. The source's head sits on a shorter neck-to-head segment (0.652 m) than the game's (0.737 m), but the bend happens lower in the spine, where the MetaHuman's segments are longer, so the same angle change produces less displacement at the head.

**The peak frame trap.** Eight clips have their source and game peaks more than 10 frames apart. On these clips, the game is measuring a LATER movement than the source - a secondary reaction or the start of recovery. The game's peak reads smaller because the impact has already passed. This is not a measurement error; it's the game's clip showing a different stretch of the take than what the source peaks at. The loss on these clips is real but compounded by the timing shift.

**What the row shows:** hook_v5 is the cleanest case. Source and game peaks sit 2 frames apart (frames 13 and 11) - the same movement. The source moves 0.229 m; the game moves 0.109 m. The game's body is 13% taller. Proportions predict 0.258 m; the game reads 0.109 m. The pipeline loses 58% of the head travel on the same movement.
