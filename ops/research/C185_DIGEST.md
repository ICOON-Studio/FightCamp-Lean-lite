# C185 - hands and abrupt motion

Model: gpt-6-astra. Branch: codex/c185-hands. Seed 92012, MMA, default record_room options, 30 fps, 60 seconds.

## Mechanism and result

The walk layer replaces pelvis rotation. Its children inherit that replacement, redirecting the torso and punching arm even though the arm tracks play. The fix preserves the action's skeleton-space Spine rotation across the lower-body splice, expressing it relative to the new pelvis. The legs still walk and the existing inertializer still blends joins. No source clip, separation rule, engine state or layout is edited.

One measured body: A, wrestler/grappler, f05_m_mma_light_rigged.glb, rendered height 1.74 m. Opponent B: f06_m_mma_lhw_rigged.glb, rendered height 1.82 m. Engine ids a/b; both engine height fields are 178 cm. Render heights are not silently substituted for the engine population.

Mean lead-hook left-wrist error against the bound clip's unlayered pose drops from 0.195 m to 0.067 m. Wrist/hip threshold crossings (>0.15 m per frame) drop from 84 to 59 in frames 0..599. This improves the mechanism; it does not fix every abrupt movement.

## Measurement definition

The trace advances the same room at 1/30 s and samples AFTER placement, playback, aim, hand contact and bounds correction. Automatic room processing is disabled to prevent a second clock. LeftHand is the orthodox lead wrist; RightHand is rear. Chest is an asserted existing bone. Coordinates are world-axis wrist minus chest, in metres. Video time is frame/30; show_s is separately logged.

Source means the bound, retargeted clip evaluated without playback layers on the SAME measured skeleton, not the original vendor skeleton. Forward extension projects wrist-minus-chest toward the opponent's chest. Source peak samples the complete bound clip at 30 Hz using the current body transform. Guard is idle at time zero in the frame's body orientation. Missing landmarks fail loudly.

Recovery is sampled 0.3/0.6 s after playback leaves the strike. The table names the running clip: a walking guard differs from a frozen idle key. Existing playback already queues recovery; no missing segment is invented.

## Strike extension and recovery

| Run | Strike/start s | Display s | Peak forward/source m | Forward excursion m | Guard +0.3 lead/rear m (clip) | Guard +0.6 lead/rear m (clip) |
|---|---|---:|---|---:|---|---|
| BEFORE | Lead hook 1, 1.100 | 0.967 | 0.468/0.626 | 0.014 | 0.067/0.043 (loc_strafe_right) | 0.072/0.045 (loc_strafe_left) |
| BEFORE | Lead hook 2, 8.733 | 0.967 | 0.417/0.636 | 0.158 | 0.195/0.101 (loc_strafe_left) | 0.014/0.012 (idle) |
| BEFORE | Jab fallback, 12.767 | 0.800 | 0.639/0.769 | 0.298 | 0.060/0.012 (idle) | 0.092/0.051 (loc_strafe_left) |
| AFTER | Lead hook 1, 1.100 | 0.967 | 0.452/0.625 | 0.000 | 0.070/0.042 (loc_strafe_right) | 0.073/0.045 (loc_strafe_left) |
| AFTER | Lead hook 2, 8.733 | 0.967 | 0.444/0.635 | 0.218 | 0.233/0.101 (loc_strafe_left) | 0.079/0.012 (idle) |
| AFTER | Jab fallback, 12.767 | 0.800 | 0.739/0.769 | 0.425 | 0.060/0.012 (idle) | 0.092/0.051 (loc_strafe_left) |

A has four actor entries in the first 20 video seconds. Two play hook_lead; muay_thai_jab_teep_switch at frame 383 uses the existing jab fallback. muay_thai_thip_top at frame 420 displays no new strike clip, so its extension/recovery is unavailable. All four entries are logged. Beat span is 0.05 s; presentation budgets are 2.5333, 2.4813, 1.23324 and 0.9 s. Display duration is distinguished from those budgets.

## Abrupt motion census

Every threshold crossing follows. Same-clip rows must not be misreported as clip transitions. Lower-layer transitions are independent. Coincidence does not prove cause for each jump. Residual within-clip hand movement and whole-body placement jumps remain.

| Run | Bone | Crossings | Maximum m/frame |
|---|---|---:|---:|
| BEFORE | LeftHand | 62 | 0.8698 |
| BEFORE | RightHand | 19 | 0.5887 |
| BEFORE | Hips | 3 | 0.5126 |
| AFTER | LeftHand | 39 | 0.8520 |
| AFTER | RightHand | 17 | 0.5571 |
| AFTER | Hips | 3 | 0.5123 |

```text
run frame seconds bone jump_m clip_transition lower_transition
BEFORE 21 0.7000 LeftHand 0.15441 loc_advance_right->loc_advance_right ->
BEFORE 24 0.8000 LeftHand 0.16040 idle->idle ->
BEFORE 28 0.9333 LeftHand 0.15411 idle->idle ->
BEFORE 35 1.1667 LeftHand 0.23567 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
BEFORE 39 1.3000 LeftHand 0.23224 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
BEFORE 40 1.3333 LeftHand 0.15320 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
BEFORE 41 1.3667 LeftHand 0.37417 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
BEFORE 45 1.5000 LeftHand 0.20917 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
BEFORE 47 1.5667 LeftHand 0.21982 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
BEFORE 58 1.9333 LeftHand 0.23523 hook_lead->hook_lead loc_strafe_right->
BEFORE 58 1.9333 RightHand 0.21624 hook_lead->hook_lead loc_strafe_right->
BEFORE 58 1.9333 Hips 0.28213 hook_lead->hook_lead loc_strafe_right->
BEFORE 101 3.3667 LeftHand 0.22793 loc_strafe_left->loc_strafe_left ->
BEFORE 102 3.4000 LeftHand 0.16704 loc_strafe_left->loc_strafe_left ->
BEFORE 107 3.5667 LeftHand 0.19012 loc_strafe_right->loc_strafe_right ->
BEFORE 108 3.6000 LeftHand 0.23388 loc_strafe_right->loc_strafe_right ->
BEFORE 110 3.6667 LeftHand 0.27713 loc_strafe_right->react_head#3 ->loc_strafe_right
BEFORE 111 3.7000 LeftHand 0.38893 react_head#3->react_head#3 loc_strafe_right->loc_strafe_right
BEFORE 112 3.7333 LeftHand 0.21911 react_head#3->react_head#3 loc_strafe_right->loc_strafe_right
BEFORE 115 3.8333 LeftHand 0.46134 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 115 3.8333 RightHand 0.18877 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 116 3.8667 RightHand 0.19421 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 118 3.9333 LeftHand 0.34334 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 118 3.9333 RightHand 0.21129 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 119 3.9667 LeftHand 0.20656 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 120 4.0000 LeftHand 0.19791 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 120 4.0000 RightHand 0.17584 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 121 4.0333 LeftHand 0.15526 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 121 4.0333 RightHand 0.30388 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
BEFORE 122 4.0667 LeftHand 0.28394 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_retreat_right
BEFORE 122 4.0667 RightHand 0.41341 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_retreat_right
BEFORE 123 4.1000 LeftHand 0.26189 react_body#5_lead->react_body#5_lead loc_retreat_right->loc_retreat_right
BEFORE 123 4.1000 RightHand 0.34359 react_body#5_lead->react_body#5_lead loc_retreat_right->loc_retreat_right
BEFORE 124 4.1333 LeftHand 0.27020 react_body#5_lead->react_body#5_lead loc_retreat_right->loc_retreat_right
BEFORE 124 4.1333 RightHand 0.24784 react_body#5_lead->react_body#5_lead loc_retreat_right->loc_retreat_right
BEFORE 126 4.2000 RightHand 0.17253 react_body#5_lead->react_body#5_lead loc_retreat_right->loc_retreat
BEFORE 127 4.2333 LeftHand 0.17348 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
BEFORE 127 4.2333 RightHand 0.22127 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
BEFORE 128 4.2667 LeftHand 0.21799 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
BEFORE 128 4.2667 RightHand 0.23608 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
BEFORE 129 4.3000 LeftHand 0.15242 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
BEFORE 130 4.3333 LeftHand 0.15727 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
BEFORE 131 4.3667 LeftHand 0.16242 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
BEFORE 132 4.4000 LeftHand 0.16849 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
BEFORE 143 4.7667 LeftHand 0.26896 react_body#5_lead->react_body#5_lead loc_retreat->
BEFORE 143 4.7667 RightHand 0.32906 react_body#5_lead->react_body#5_lead loc_retreat->
BEFORE 263 8.7667 RightHand 0.18174 hook_lead->hook_lead loc_advance_left->loc_advance
BEFORE 264 8.8000 LeftHand 0.16702 hook_lead->hook_lead loc_advance->loc_advance
BEFORE 265 8.8333 LeftHand 0.18441 hook_lead->hook_lead loc_advance->loc_advance_right
BEFORE 266 8.8667 LeftHand 0.16261 hook_lead->hook_lead loc_advance_right->loc_advance_right
BEFORE 268 8.9333 LeftHand 0.32581 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
BEFORE 271 9.0333 LeftHand 0.86978 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
BEFORE 275 9.1667 LeftHand 0.45601 hook_lead->hook_lead loc_strafe_right->loc_retreat_right
BEFORE 276 9.2000 LeftHand 0.34566 hook_lead->hook_lead loc_retreat_right->loc_retreat_right
BEFORE 277 9.2333 LeftHand 0.55884 hook_lead->hook_lead loc_retreat_right->
BEFORE 277 9.2333 RightHand 0.33866 hook_lead->hook_lead loc_retreat_right->
BEFORE 277 9.2333 Hips 0.49942 hook_lead->hook_lead loc_retreat_right->
BEFORE 279 9.3000 LeftHand 0.64193 hook_lead->hook_lead ->loc_retreat_left
BEFORE 279 9.3000 RightHand 0.58865 hook_lead->hook_lead ->loc_retreat_left
BEFORE 279 9.3000 Hips 0.51257 hook_lead->hook_lead ->loc_retreat_left
BEFORE 288 9.6000 LeftHand 0.18826 hook_lead->hook_lead loc_strafe_left->loc_strafe_left
BEFORE 289 9.6333 LeftHand 0.24458 hook_lead->hook_lead loc_strafe_left->loc_strafe_left
BEFORE 295 9.8333 LeftHand 0.23119 loc_strafe_left->loc_strafe_left ->
BEFORE 382 12.7333 RightHand 0.17208 react_head#1->react_head#1 loc_strafe_left->loc_strafe_left
BEFORE 384 12.8000 LeftHand 0.17849 jab->jab loc_strafe_left->loc_strafe_left
BEFORE 389 12.9667 LeftHand 0.33235 jab->jab loc_strafe_left->loc_strafe_left
BEFORE 396 13.2000 LeftHand 0.38142 jab->jab loc_strafe_left->
BEFORE 449 14.9667 LeftHand 0.18202 react_head#2->react_head#2 ->
BEFORE 450 15.0000 LeftHand 0.17642 react_head#2->react_head#2 ->
BEFORE 493 16.4333 LeftHand 0.19119 react_leg->react_leg ->
BEFORE 494 16.4667 LeftHand 0.21969 react_leg->react_leg ->
BEFORE 495 16.5000 LeftHand 0.17014 react_leg->react_leg ->
BEFORE 496 16.5333 LeftHand 0.22027 react_leg->react_leg ->
BEFORE 497 16.5667 LeftHand 0.24618 react_leg->react_leg ->
BEFORE 498 16.6000 LeftHand 0.22342 react_leg->react_leg ->
BEFORE 498 16.6000 RightHand 0.15073 react_leg->react_leg ->
BEFORE 499 16.6333 LeftHand 0.17733 react_leg->react_leg ->
BEFORE 500 16.6667 LeftHand 0.18690 react_leg->react_leg ->
BEFORE 500 16.6667 RightHand 0.37818 react_leg->react_leg ->
BEFORE 501 16.7000 LeftHand 0.16775 react_leg->react_leg ->
BEFORE 502 16.7333 LeftHand 0.19478 react_leg->react_leg ->
BEFORE 503 16.7667 LeftHand 0.17386 react_leg->react_leg ->
BEFORE 532 17.7333 LeftHand 0.15129 react_leg->react_leg ->
BEFORE 533 17.7667 LeftHand 0.16081 react_leg->react_leg ->
AFTER 21 0.7000 LeftHand 0.15441 loc_advance_right->loc_advance_right ->
AFTER 24 0.8000 LeftHand 0.16040 idle->idle ->
AFTER 28 0.9333 LeftHand 0.15411 idle->idle ->
AFTER 41 1.3667 LeftHand 0.27915 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 42 1.4000 LeftHand 0.30640 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 45 1.5000 LeftHand 0.26255 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 46 1.5333 LeftHand 0.17525 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 47 1.5667 LeftHand 0.16127 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 58 1.9333 LeftHand 0.26830 hook_lead->hook_lead loc_strafe_right->
AFTER 58 1.9333 RightHand 0.27545 hook_lead->hook_lead loc_strafe_right->
AFTER 58 1.9333 Hips 0.28213 hook_lead->hook_lead loc_strafe_right->
AFTER 110 3.6667 LeftHand 0.25414 loc_strafe_right->react_head#3 ->loc_strafe_right
AFTER 111 3.7000 LeftHand 0.30604 react_head#3->react_head#3 loc_strafe_right->loc_strafe_right
AFTER 111 3.7000 RightHand 0.22343 react_head#3->react_head#3 loc_strafe_right->loc_strafe_right
AFTER 113 3.7667 LeftHand 0.17941 react_head#3->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 115 3.8333 LeftHand 0.25206 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 115 3.8333 RightHand 0.35106 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 116 3.8667 LeftHand 0.57133 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 116 3.8667 RightHand 0.27799 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 117 3.9000 LeftHand 0.15829 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 117 3.9000 RightHand 0.15776 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 118 3.9333 RightHand 0.23660 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 121 4.0333 RightHand 0.21907 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_strafe_right
AFTER 122 4.0667 RightHand 0.15723 react_body#5_lead->react_body#5_lead loc_strafe_right->loc_retreat_right
AFTER 123 4.1000 RightHand 0.17280 react_body#5_lead->react_body#5_lead loc_retreat_right->loc_retreat_right
AFTER 129 4.3000 LeftHand 0.15470 react_body#5_lead->react_body#5_lead loc_retreat->loc_retreat
AFTER 263 8.7667 RightHand 0.19505 hook_lead->hook_lead loc_advance_left->loc_advance
AFTER 269 8.9667 RightHand 0.18525 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 270 9.0000 LeftHand 0.20819 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 270 9.0000 RightHand 0.27880 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 271 9.0333 LeftHand 0.85202 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 273 9.1000 LeftHand 0.17983 hook_lead->hook_lead loc_strafe_right->loc_strafe_right
AFTER 277 9.2333 LeftHand 0.55855 hook_lead->hook_lead loc_retreat_right->
AFTER 277 9.2333 RightHand 0.55707 hook_lead->hook_lead loc_retreat_right->
AFTER 277 9.2333 Hips 0.48630 hook_lead->hook_lead loc_retreat_right->
AFTER 279 9.3000 LeftHand 0.49876 hook_lead->hook_lead ->loc_retreat_left
AFTER 279 9.3000 RightHand 0.50096 hook_lead->hook_lead ->loc_retreat_left
AFTER 279 9.3000 Hips 0.51229 hook_lead->hook_lead ->loc_retreat_left
AFTER 382 12.7333 RightHand 0.15688 react_head#1->react_head#1 loc_strafe_left->loc_strafe_left
AFTER 389 12.9667 LeftHand 0.30079 jab->jab loc_strafe_left->loc_strafe_left
AFTER 390 13.0000 LeftHand 0.17117 jab->jab loc_strafe_left->loc_strafe_left
AFTER 391 13.0333 LeftHand 0.15533 jab->jab loc_strafe_left->loc_strafe_left
AFTER 449 14.9667 LeftHand 0.21346 react_head#2->react_head#2 ->
AFTER 450 15.0000 LeftHand 0.16189 react_head#2->react_head#2 ->
AFTER 493 16.4333 LeftHand 0.19119 react_leg->react_leg ->
AFTER 494 16.4667 LeftHand 0.21969 react_leg->react_leg ->
AFTER 495 16.5000 LeftHand 0.17014 react_leg->react_leg ->
AFTER 496 16.5333 LeftHand 0.22027 react_leg->react_leg ->
AFTER 497 16.5667 LeftHand 0.24618 react_leg->react_leg ->
AFTER 498 16.6000 LeftHand 0.22342 react_leg->react_leg ->
AFTER 498 16.6000 RightHand 0.15073 react_leg->react_leg ->
AFTER 499 16.6333 LeftHand 0.17733 react_leg->react_leg ->
AFTER 500 16.6667 LeftHand 0.18690 react_leg->react_leg ->
AFTER 500 16.6667 RightHand 0.37818 react_leg->react_leg ->
AFTER 501 16.7000 LeftHand 0.16775 react_leg->react_leg ->
AFTER 502 16.7333 LeftHand 0.19478 react_leg->react_leg ->
AFTER 503 16.7667 LeftHand 0.17386 react_leg->react_leg ->
AFTER 532 17.7333 LeftHand 0.15129 react_leg->react_leg ->
AFTER 533 17.7667 LeftHand 0.16081 react_leg->react_leg ->
```

## Per-frame strike wrist log

All displayed strike frames for A in the first 20 seconds. The committed trace generates complete 620-frame JSONL including actor/target entries, source poses/peaks, hips, guard offsets and lower-layer state. Blend below is the effective inertial join duration; zero AnimationPlayer crossfade does not mean no blending.

```text
run frame clip blend_in/out lead_xyz_m rear_xyz_m
BEFORE 33 hook_lead 0.270/0.270 0.1639,0.2497,-0.4368 0.2590,0.2628,-0.0014
BEFORE 34 hook_lead 0.270/0.270 0.2093,0.2706,-0.4301 0.2527,0.2634,0.0026
BEFORE 35 hook_lead 0.270/0.270 0.1112,0.1460,-0.2522 0.2367,0.2737,0.0035
BEFORE 36 hook_lead 0.270/0.270 0.0530,0.1291,-0.2542 0.2125,0.2869,0.0001
BEFORE 37 hook_lead 0.270/0.270 -0.0039,0.1160,-0.2986 0.2102,0.2882,-0.0197
BEFORE 38 hook_lead 0.270/0.270 -0.1370,0.0741,-0.2702 0.1953,0.2912,-0.0470
BEFORE 39 hook_lead 0.270/0.270 -0.3867,0.1252,-0.1886 0.1953,0.2888,-0.0485
BEFORE 40 hook_lead 0.270/0.270 -0.4522,0.2148,-0.0424 0.1798,0.2805,-0.0384
BEFORE 41 hook_lead 0.270/0.270 -0.1396,0.3075,-0.1531 0.1705,0.2726,-0.0548
BEFORE 42 hook_lead 0.270/0.270 -0.2172,0.3892,-0.1585 0.1766,0.2760,-0.0805
BEFORE 43 hook_lead 0.270/0.270 -0.2847,0.3876,-0.2144 0.1542,0.2839,-0.1040
BEFORE 44 hook_lead 0.270/0.270 -0.2915,0.3567,-0.1702 0.1416,0.2796,-0.1181
BEFORE 45 hook_lead 0.270/0.270 -0.1297,0.3714,-0.1795 0.1331,0.2845,-0.1346
BEFORE 46 hook_lead 0.270/0.270 -0.1080,0.3253,-0.2280 0.1099,0.2749,-0.1413
BEFORE 47 hook_lead 0.270/0.270 -0.1424,0.1490,-0.3379 0.0928,0.2645,-0.1555
BEFORE 48 hook_lead 0.270/0.270 -0.1631,0.1750,-0.3399 0.0683,0.2552,-0.1704
BEFORE 49 hook_lead 0.270/0.270 -0.2208,0.1921,-0.3051 0.0422,0.2498,-0.1809
BEFORE 50 hook_lead 0.270/0.270 -0.2516,0.2163,-0.2677 0.0180,0.2475,-0.1844
BEFORE 51 hook_lead 0.270/0.270 -0.2730,0.2402,-0.2294 -0.0041,0.2476,-0.1815
BEFORE 52 hook_lead 0.270/0.270 -0.2864,0.2605,-0.1868 -0.0242,0.2498,-0.1744
BEFORE 53 hook_lead 0.270/0.270 -0.2924,0.2753,-0.1422 -0.0417,0.2527,-0.1655
BEFORE 54 hook_lead 0.270/0.270 -0.2931,0.2843,-0.1031 -0.0546,0.2538,-0.1581
BEFORE 55 hook_lead 0.270/0.270 -0.2921,0.2873,-0.0693 -0.0648,0.2532,-0.1520
BEFORE 56 hook_lead 0.270/0.270 -0.2919,0.2818,-0.0422 -0.0731,0.2542,-0.1490
BEFORE 57 hook_lead 0.270/0.270 -0.2904,0.2706,-0.0259 -0.0777,0.2552,-0.1512
BEFORE 58 hook_lead 0.270/0.270 -0.2557,0.2765,-0.0735 -0.0273,0.2584,-0.1678
BEFORE 59 hook_lead 0.270/0.270 -0.2916,0.2680,-0.0579 -0.0408,0.2557,-0.1781
BEFORE 60 hook_lead 0.270/0.270 -0.3495,0.2532,-0.0421 -0.0665,0.2556,-0.2010
BEFORE 61 hook_lead 0.270/0.270 -0.4006,0.2197,-0.0862 -0.0707,0.2445,-0.2453
BEFORE 262 hook_lead 0.270/0.270 0.3274,0.1708,0.0509 0.0110,0.2149,0.2083
BEFORE 263 hook_lead 0.270/0.270 0.2428,0.1373,0.0456 -0.0378,0.3559,0.1983
BEFORE 264 hook_lead 0.270/0.270 0.1150,0.1915,0.1018 -0.0967,0.3066,0.2331
BEFORE 265 hook_lead 0.270/0.270 0.1833,0.0556,0.1693 -0.1500,0.2992,0.1502
BEFORE 266 hook_lead 0.270/0.270 0.1264,0.0118,0.2861 -0.1704,0.2948,0.1176
BEFORE 267 hook_lead 0.270/0.270 0.1401,0.0602,0.1390 -0.1733,0.2976,0.1197
BEFORE 268 hook_lead 0.270/0.270 0.4396,0.1369,-0.0447 -0.1429,0.3009,0.1491
BEFORE 269 hook_lead 0.270/0.270 0.4993,0.2151,-0.1018 -0.1550,0.3504,0.1590
BEFORE 270 hook_lead 0.270/0.270 0.5830,0.1551,-0.1776 -0.1354,0.2824,0.1473
BEFORE 271 hook_lead 0.270/0.270 -0.0048,0.1805,0.4062 -0.2050,0.2978,0.1440
BEFORE 272 hook_lead 0.270/0.270 0.1121,0.1566,0.4190 -0.1200,0.2714,0.1597
BEFORE 273 hook_lead 0.270/0.270 0.1172,0.2710,0.3963 -0.0865,0.2818,0.1617
BEFORE 274 hook_lead 0.270/0.270 0.1004,0.2562,0.3949 -0.0767,0.2814,0.1612
BEFORE 275 hook_lead 0.270/0.270 0.2612,0.5462,0.2218 -0.0061,0.2724,0.1827
BEFORE 276 hook_lead 0.270/0.270 0.2677,0.2411,0.0270 0.0724,0.2656,0.1642
BEFORE 277 hook_lead 0.270/0.270 0.1016,0.1096,0.3926 -0.1244,0.2438,0.2347
BEFORE 278 hook_lead 0.270/0.270 0.1756,0.1333,0.4119 -0.0790,0.2204,0.2400
BEFORE 279 hook_lead 0.270/0.270 0.1663,0.3001,0.2530 -0.0860,0.2686,0.1267
BEFORE 280 hook_lead 0.270/0.270 0.2059,0.3004,0.1949 -0.0251,0.2636,0.1555
BEFORE 281 hook_lead 0.270/0.270 0.2786,0.2915,0.1177 0.0376,0.2558,0.1629
BEFORE 282 hook_lead 0.270/0.270 0.2993,0.3023,0.0370 0.0951,0.2453,0.1542
BEFORE 283 hook_lead 0.270/0.270 0.3080,0.2868,0.0160 0.1013,0.2473,0.1448
BEFORE 284 hook_lead 0.270/0.270 0.2696,0.2947,-0.0091 0.1068,0.2472,0.1376
BEFORE 285 hook_lead 0.270/0.270 0.1892,0.2963,-0.0251 0.1100,0.2531,0.1409
BEFORE 286 hook_lead 0.270/0.270 0.1568,0.3313,-0.0451 0.1070,0.2597,0.1383
BEFORE 287 hook_lead 0.270/0.270 0.2408,0.3826,-0.1352 0.1061,0.2580,0.1426
BEFORE 288 hook_lead 0.270/0.270 0.1677,0.2328,-0.0534 0.1316,0.2437,0.1484
BEFORE 289 hook_lead 0.270/0.270 0.3776,0.1578,-0.0178 0.1452,0.2391,0.1786
BEFORE 290 hook_lead 0.270/0.270 0.3841,0.2026,-0.0248 0.1529,0.2395,0.2103
BEFORE 383 jab 0.270/0.270 -0.1775,0.1902,-0.2908 0.1792,0.0818,-0.2626
BEFORE 384 jab 0.270/0.270 -0.2443,0.1691,-0.1655 0.1571,0.1123,-0.2765
BEFORE 385 jab 0.270/0.270 -0.2711,0.1693,-0.0958 0.1696,0.1360,-0.2766
BEFORE 386 jab 0.270/0.270 -0.2952,0.1963,-0.1322 0.1896,0.1330,-0.2505
BEFORE 387 jab 0.270/0.270 -0.3263,0.2483,-0.1778 0.1740,0.1246,-0.2238
BEFORE 388 jab 0.270/0.270 -0.3258,0.2894,-0.1916 0.1458,0.1277,-0.2082
BEFORE 389 jab 0.270/0.270 -0.6101,0.3587,-0.2868 0.1271,0.1364,-0.2050
BEFORE 390 jab 0.270/0.270 -0.6097,0.3679,-0.2965 0.1186,0.1392,-0.2095
BEFORE 391 jab 0.270/0.270 -0.6095,0.3920,-0.2816 0.1067,0.1381,-0.2171
BEFORE 392 jab 0.270/0.270 -0.6459,0.3022,-0.2494 0.0908,0.1353,-0.2256
BEFORE 393 jab 0.270/0.270 -0.6195,0.2007,-0.3504 0.0806,0.1353,-0.2340
BEFORE 394 jab 0.270/0.270 -0.5694,0.1483,-0.3387 0.0862,0.1337,-0.2404
BEFORE 395 jab 0.270/0.270 -0.5093,0.1457,-0.2961 0.0975,0.1365,-0.2452
BEFORE 396 jab 0.270/0.270 -0.1496,0.0940,-0.4268 0.2020,0.1392,-0.1826
BEFORE 397 jab 0.270/0.270 -0.2207,0.1327,-0.4175 0.1939,0.1462,-0.1970
BEFORE 398 jab 0.270/0.270 -0.2032,0.1603,-0.3740 0.1789,0.1572,-0.2076
BEFORE 399 jab 0.270/0.270 -0.2050,0.1632,-0.3672 0.1609,0.1716,-0.2138
BEFORE 400 jab 0.270/0.270 -0.2136,0.1628,-0.3678 0.1442,0.1877,-0.2183
BEFORE 401 jab 0.270/0.270 -0.2298,0.1657,-0.3622 0.1301,0.2044,-0.2211
BEFORE 402 jab 0.270/0.270 -0.2499,0.1714,-0.3568 0.1201,0.2205,-0.2223
BEFORE 403 jab 0.270/0.270 -0.2685,0.1761,-0.3502 0.1133,0.2350,-0.2232
BEFORE 404 jab 0.270/0.270 -0.2859,0.1801,-0.3492 0.1090,0.2471,-0.2246
BEFORE 405 jab 0.270/0.270 -0.2989,0.1806,-0.3509 0.1052,0.2562,-0.2269
BEFORE 406 jab 0.270/0.270 -0.3068,0.1823,-0.3522 0.1036,0.2619,-0.2287
AFTER 33 hook_lead 0.270/0.270 0.1463,0.2464,-0.4429 0.2562,0.2672,-0.0089
AFTER 34 hook_lead 0.270/0.270 0.0266,0.2274,-0.4173 0.2452,0.2722,-0.0403
AFTER 35 hook_lead 0.270/0.270 -0.0624,0.2015,-0.3375 0.2190,0.2833,-0.0711
AFTER 36 hook_lead 0.270/0.270 -0.0982,0.1839,-0.2747 0.1910,0.2977,-0.0780
AFTER 37 hook_lead 0.270/0.270 -0.1746,0.1401,-0.2340 0.1877,0.3049,-0.0890
AFTER 38 hook_lead 0.270/0.270 -0.2993,0.1014,-0.1418 0.1783,0.3094,-0.0852
AFTER 39 hook_lead 0.270/0.270 -0.4331,0.1422,-0.0163 0.1895,0.2679,-0.1065
AFTER 40 hook_lead 0.270/0.270 -0.4462,0.2863,-0.0060 0.1578,0.2432,-0.0990
AFTER 41 hook_lead 0.270/0.270 -0.2116,0.2054,0.0427 0.1615,0.2382,-0.1162
AFTER 42 hook_lead 0.270/0.270 -0.1814,0.4060,-0.1556 0.1832,0.2494,-0.1342
AFTER 43 hook_lead 0.270/0.270 -0.2250,0.3650,-0.2229 0.1822,0.2553,-0.1296
AFTER 44 hook_lead 0.270/0.270 -0.2247,0.3236,-0.2454 0.1848,0.2533,-0.1214
AFTER 45 hook_lead 0.270/0.270 -0.0263,0.3008,-0.2473 0.1841,0.2536,-0.1214
AFTER 46 hook_lead 0.270/0.270 0.0203,0.1351,-0.2625 0.1708,0.2508,-0.1247
AFTER 47 hook_lead 0.270/0.270 0.0630,0.1184,-0.3805 0.1576,0.2441,-0.1353
AFTER 48 hook_lead 0.270/0.270 0.0257,0.1096,-0.4047 0.1417,0.2374,-0.1497
AFTER 49 hook_lead 0.270/0.270 -0.0335,0.1378,-0.3982 0.1211,0.2348,-0.1646
AFTER 50 hook_lead 0.270/0.270 -0.0889,0.1725,-0.3796 0.0959,0.2369,-0.1740
AFTER 51 hook_lead 0.270/0.270 -0.1322,0.2023,-0.3537 0.0697,0.2408,-0.1774
AFTER 52 hook_lead 0.270/0.270 -0.1798,0.2338,-0.3127 0.0444,0.2457,-0.1762
AFTER 53 hook_lead 0.270/0.270 -0.2123,0.2567,-0.2656 0.0224,0.2510,-0.1717
AFTER 54 hook_lead 0.270/0.270 -0.2347,0.2742,-0.2170 0.0059,0.2545,-0.1660
AFTER 55 hook_lead 0.270/0.270 -0.2505,0.2846,-0.1701 -0.0080,0.2560,-0.1607
AFTER 56 hook_lead 0.270/0.270 -0.2596,0.2868,-0.1292 -0.0181,0.2580,-0.1589
AFTER 57 hook_lead 0.270/0.270 -0.2619,0.2829,-0.0979 -0.0242,0.2591,-0.1622
AFTER 58 hook_lead 0.270/0.270 -0.2557,0.2765,-0.0735 -0.0273,0.2584,-0.1678
AFTER 59 hook_lead 0.270/0.270 -0.2916,0.2680,-0.0579 -0.0408,0.2557,-0.1781
AFTER 60 hook_lead 0.270/0.270 -0.3495,0.2532,-0.0421 -0.0665,0.2556,-0.2010
AFTER 61 hook_lead 0.270/0.270 -0.4023,0.2316,-0.0259 -0.0924,0.2603,-0.2206
AFTER 262 hook_lead 0.270/0.270 0.2692,0.1641,0.0514 0.0158,0.2088,0.2047
AFTER 263 hook_lead 0.270/0.270 0.3025,0.1987,0.0635 -0.0321,0.3555,0.2458
AFTER 264 hook_lead 0.270/0.270 0.3056,0.2124,0.0708 -0.0643,0.3413,0.2367
AFTER 265 hook_lead 0.270/0.270 0.2771,0.1871,0.1111 -0.0865,0.3249,0.1911
AFTER 266 hook_lead 0.270/0.270 0.2997,0.1188,0.0540 -0.0570,0.2986,0.2014
AFTER 267 hook_lead 0.270/0.270 0.3228,0.1019,-0.0717 -0.0679,0.3079,0.1900
AFTER 268 hook_lead 0.270/0.270 0.3706,0.1422,-0.2246 -0.0680,0.3361,0.1850
AFTER 269 hook_lead 0.270/0.270 0.4256,0.2597,-0.2767 0.0545,0.3138,0.0178
AFTER 270 hook_lead 0.270/0.270 0.5142,0.3030,-0.1041 -0.1164,0.2720,0.1778
AFTER 271 hook_lead 0.270/0.270 -0.0681,0.1433,0.4357 -0.1664,0.2858,0.1316
AFTER 272 hook_lead 0.270/0.270 0.0874,0.1398,0.4973 -0.1276,0.2527,0.1877
AFTER 273 hook_lead 0.270/0.270 -0.0591,0.1584,0.4181 -0.1310,0.2533,0.1781
AFTER 274 hook_lead 0.270/0.270 -0.0260,0.1636,0.4434 -0.1289,0.2534,0.1738
AFTER 275 hook_lead 0.270/0.270 0.0043,0.1226,0.4321 -0.1187,0.2508,0.1750
AFTER 276 hook_lead 0.270/0.270 0.0449,0.1037,0.4155 -0.1059,0.2441,0.1787
AFTER 277 hook_lead 0.270/0.270 0.1016,0.1096,0.3926 -0.1101,0.1065,0.3040
AFTER 278 hook_lead 0.270/0.270 0.1533,0.1378,0.3691 -0.0924,0.1818,0.2747
AFTER 279 hook_lead 0.270/0.270 0.1950,0.1725,0.3376 -0.0415,0.2369,0.1943
AFTER 280 hook_lead 0.270/0.270 0.2296,0.2056,0.2997 -0.0180,0.2408,0.1897
AFTER 281 hook_lead 0.270/0.270 0.2544,0.2338,0.2558 0.0026,0.2457,0.1816
AFTER 282 hook_lead 0.270/0.270 0.2671,0.2567,0.2105 0.0172,0.2510,0.1723
AFTER 283 hook_lead 0.270/0.270 0.2742,0.2742,0.1644 0.0282,0.2545,0.1637
AFTER 284 hook_lead 0.270/0.270 0.2773,0.2846,0.1215 0.0373,0.2560,0.1566
AFTER 285 hook_lead 0.270/0.270 0.2776,0.2868,0.0838 0.0445,0.2580,0.1536
AFTER 286 hook_lead 0.270/0.270 0.2743,0.2829,0.0541 0.0502,0.2591,0.1561
AFTER 287 hook_lead 0.270/0.270 0.2642,0.2765,0.0315 0.0538,0.2584,0.1612
AFTER 288 hook_lead 0.270/0.270 0.2971,0.2680,0.0095 0.0693,0.2557,0.1690
AFTER 289 hook_lead 0.270/0.270 0.3515,0.2532,-0.0190 0.1003,0.2556,0.1864
AFTER 290 hook_lead 0.270/0.270 0.3730,0.2442,-0.0409 0.1318,0.2603,0.1995
AFTER 383 jab 0.270/0.270 -0.2086,0.2141,-0.2496 0.1461,0.1027,-0.2754
AFTER 384 jab 0.270/0.270 -0.2022,0.2083,-0.1677 0.1932,0.1118,-0.2528
AFTER 385 jab 0.270/0.270 -0.2167,0.2079,-0.1379 0.2458,0.1190,-0.2218
AFTER 386 jab 0.270/0.270 -0.2157,0.2218,-0.2177 0.2745,0.1261,-0.1585
AFTER 387 jab 0.270/0.270 -0.1851,0.2450,-0.3247 0.2628,0.1376,-0.0889
AFTER 388 jab 0.270/0.270 -0.1235,0.2439,-0.3897 0.2352,0.1497,-0.0562
AFTER 389 jab 0.270/0.270 -0.1375,0.2618,-0.7099 0.2197,0.1578,-0.0601
AFTER 390 jab 0.270/0.270 -0.1001,0.1519,-0.6077 0.2140,0.1597,-0.0777
AFTER 391 jab 0.270/0.270 -0.1174,0.0816,-0.7406 0.2099,0.1560,-0.0959
AFTER 392 jab 0.270/0.270 -0.1792,0.1055,-0.7428 0.2052,0.1495,-0.1140
AFTER 393 jab 0.270/0.270 -0.1824,0.0434,-0.7208 0.2006,0.1434,-0.1370
AFTER 394 jab 0.270/0.270 -0.1769,-0.0028,-0.6387 0.2028,0.1376,-0.1518
AFTER 395 jab 0.270/0.270 -0.1912,0.0120,-0.5301 0.2039,0.1363,-0.1678
AFTER 396 jab 0.270/0.270 -0.1496,0.0940,-0.4268 0.2020,0.1392,-0.1826
AFTER 397 jab 0.270/0.270 -0.2207,0.1327,-0.4175 0.1939,0.1462,-0.1970
AFTER 398 jab 0.270/0.270 -0.2032,0.1603,-0.3740 0.1789,0.1572,-0.2076
AFTER 399 jab 0.270/0.270 -0.2050,0.1632,-0.3672 0.1609,0.1716,-0.2138
AFTER 400 jab 0.270/0.270 -0.2136,0.1628,-0.3678 0.1442,0.1877,-0.2183
AFTER 401 jab 0.270/0.270 -0.2298,0.1657,-0.3622 0.1301,0.2044,-0.2211
AFTER 402 jab 0.270/0.270 -0.2499,0.1714,-0.3568 0.1201,0.2205,-0.2223
AFTER 403 jab 0.270/0.270 -0.2685,0.1761,-0.3502 0.1133,0.2350,-0.2232
AFTER 404 jab 0.270/0.270 -0.2859,0.1801,-0.3492 0.1090,0.2471,-0.2246
AFTER 405 jab 0.270/0.270 -0.2989,0.1806,-0.3509 0.1052,0.2562,-0.2269
AFTER 406 jab 0.270/0.270 -0.3068,0.1823,-0.3522 0.1036,0.2619,-0.2287
```

## Video evidence

research/_captures/watch_loop/take2_c185_seed92012.mp4: 1800 frames, 1920x1080, 30 fps, 60 s, 13,134,667 bytes (<50 MB). Both recordings use record_room.gd, seed=92012 discipline=mma, default options and the hidden launcher. Both commands supply --resolution 854x480, but Movie Maker reports the project's 1920x1080 recording resolution.

previews/c185_before_after.png is labelled BEFORE | AFTER at 0,5,...,55 s and was OPENED. A decoded 10-fps video sequence from 8.7 s was also opened for closer inspection. The corrected torso/arm stays steadier through the walk, the hand extends, and recovery closes toward guard. Abrupt hand motion and crowding/clipping remain. This is decoded-frame review, not a claim of uninterrupted human playback or operator acceptance.

## Reproduction and gates

Import ran first and completed. The sandbox initially denied Godot launch; authorized escalation succeeded. No HANDOFF, status, archive or prior digest was read/edited. The task's scope overrides the general mailbox/sync and HANDOFF entry workflow.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/record_room.gd --rendering-driver opengl3 --write-movie <temporary.avi> --fixed-fps 30 --resolution 854x480 --quit-after 1800 -- seed=92012 discipline=mma
python Godot/tools/check_scripts.py Godot/scripts/FightStagePlayer.gd Godot/tools/c185_wrist_trace.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/c185_wrist_trace.gd --rendering-driver opengl3 --fixed-fps 30 -- out=<trace.jsonl>
python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room_no_teleport,paired_stage
```

Candidate parse: CHECK total=2 fails=0. Candidate focused tier: SUITE total=16 fails=1; only fight_stage_realism_test.gd failed (TOTAL=13 fails=8). Final baseline comparison is recorded below.

Measurement-only diagnostic switches: diagnostic=no_layers (61 crossings), diagnostic=no_inertia (93), diagnostic=raw disables procedural hand correction (90). Production retains all mechanisms.

## Final baseline comparison

The unchanged baseline also fails fight_stage_realism_test.gd: SUITE total=1 fails=1, TOTAL=13 fails=8. Both versions fail R1, R2, R3, R4, R5, R5b, R7 and R8. This is NOT a green realism gate, and identical rule verdicts do not mean identical motion.

| Metric (three boxing seeds 94301, 51227, 77003) | Baseline | Candidate |
|---|---:|---:|
| R4 returns passing | 315/391 | 320/391 |
| R5 worst join/source ratio | 2.57x | 2.47x |
| R5b worst same-frame ratio | 2.14x | 2.06x |
| R8 landed hands reaching target | 112/189 (59%) | 123/189 (65%) |
| R7 violating overlap share | 8.9% | 8.9% |
| R3 mean planted-foot skate | 0.694 m/s | 0.696 m/s |

Tradeoff: candidate R5 newly lists Spine 684/482 deg/s, Chest and UpperChest 771/607 deg/s over their bounds. Preserving the authored upper-body orientation while the walk drives its parent requires additional spine rotation. Hand/arm metrics improve, but torso continuity is not proven solved. This branch is a measured partial correction for review, not an assertion that the operator's complete visual complaint is resolved.

The saved candidate implementation was restored byte-for-byte after the isolated baseline run. Final parse CHECK total=2 fails=0. The final trace was rerun; candidate counts remain 59 crossings. Effective inertial strike and return durations are both 0.27 s; AnimationPlayer crossfades are zero because the inertializer owns those joins. The digest's frame log records the effective durations, not the unused 0.20 s crossfade constant.

Only the owned player, trace, MP4, PNG and digest are staged. FightWorldLiveScreen.gd is untouched, preserving U155's editing boundary. Import-generated files are left unstaged. No merge to master.

A direct-pelvis-rotation alternative was also measured (60 crossings, lead-hook error 0.0657 m). It failed fight_room_no_teleport_test.gd, which the selected candidate passed. That alternative and its recording were rejected; its test run was stopped after the regression. The selected seven-line Spine-compensation implementation and matching original AFTER recording were restored. The final contact sheet was rebuilt, labelled and opened again. This experiment adds no code or diagnostic default to the shipped implementation.
