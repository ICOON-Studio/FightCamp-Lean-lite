# C191 - what still clips

2026-09-24. Codex / gpt-6-astra / medium. Branch `codex/c191-what-still-clips`; baseline `6aa72538`.

## Result

`contact_stop` is implemented and defaults OFF. In the requested 60-second MMA seed, overlap over 3 cm falls from **1370/3600 frames (38.06%) to 524/3600 (14.56%)**. The longest run falls from **3.300 s to 0.517 s**. The biggest owner, leg/leg, falls from **959 to 43 frames**. This is a reduction, not a clipping-free claim: the final worst overlap is still **29.80 cm**, in a low-kick window where preserving contact takes priority over root separation.

All **nine sampled landed punches** finish within **1.02 cm** of their posed target surface. The sampled landed low kick is **2.10 cm short**, versus **2.88 cm short** before. The entire simulation event log is byte-identical OFF/ON. Mean posed hip distance changes **1.0446 -> 1.0870 m**; maximum stays **2.3399 m**. No selection, damage, timing, RNG, simulation spacing, or landed-volume rule was edited.

## Instrument and positive control

`tools/c191_clip_census.gd`: seed 92012, MMA, grappler **175 cm** / striker **185 cm**, 3600 rendered frames at **60 Hz**, no warm-up, no walkout/hit cam; first sample at 1/60 s. Both `strikes_play_whole` and `reactions_play_whole` ON, then both OFF as a control. Before/after contact_stop keeps both ON. The whole-clip switch changes scheduling, so the both-OFF control is not a one-factor contact-stop comparison.

The existing `FightBodyCapsules` instrument composes current local bone poses through the rig hierarchy on every frame and transforms them to world metres. Radii come from the dominant-weight skin vertices (80th percentile distance to each bone segment; sphere centres from the skin), scaled to the mounted stature. It never uses a posed mesh import AABB. These are calibrated capsule approximations, not exact triangle penetration. The empty neck-weight group uses the existing 0.04 local-unit fallback; this limitation is retained, not described as a skin measurement. Raw JSON includes both calibrations, mount scales, every frame, per-pair depths, clip clocks, effector measurements and pose/event hashes.

**Positive control printed before the summary:** tick **1028**, **17.1333 s**, A `loc_advance` at 0.01352 s / B `kickboxing_clinch_knee` at 0.05000 s; A Head / B LeftHand overlap **6.8215 cm**. This is an observed clinch-knee frame, not a fabricated coincident-body test or a claim that paired ground grappling occurred. Both-OFF also observes a positive clinch frame. The tool exits nonzero if no positive clinch witness appears; the regression test asserts it occurs.

## Census

Pair-seconds below count a part-pair family once per rendered frame when any member exceeds 3 cm. Different rows can overlap in time. The last two columns assign each violating frame only to its deepest pair; these sum to total violating seconds. `glove` denotes the measured hand sphere.

| Pair family | Both OFF s | Both ON before s | Both ON after s | Deepest before s | Deepest after s |
|---|---:|---:|---:|---:|---:|
| thigh / thigh | 6.183 | 15.683 | 0.600 | 7.183 | 0.300 |
| shin / thigh | 4.433 | 11.883 | 0.550 | 0.367 | 0.000 |
| torso / upper arm | 0.283 | 8.783 | 1.517 | 0.967 | 0.650 |
| shin / shin | 2.783 | 8.617 | 0.383 | 0.233 | 0.017 |
| forearm / torso | 0.250 | 8.433 | 1.233 | 1.000 | 0.233 |
| shoulder / torso | 0.033 | 6.983 | 0.950 | 0.433 | 0.317 |
| foot / foot | 0.950 | 6.550 | 2.233 | 0.900 | 1.733 |
| head / shoulder | 0.083 | 6.250 | 1.350 | 0.550 | 0.867 |
| torso / torso | 0.033 | 5.500 | 0.233 | 0.850 | 0.000 |
| head / torso | 0.083 | 5.383 | 0.067 | 1.200 | 0.000 |
| shoulder / upper arm | 0.117 | 5.100 | 0.800 | 0.250 | 0.133 |
| thigh / torso | 1.000 | 4.933 | 1.367 | 1.067 | 0.700 |
| glove / torso | 0.500 | 4.733 | 0.550 | 1.000 | 0.150 |
| foot / shin | 0.817 | 4.717 | 1.233 | 0.150 | 0.117 |
| forearm / shoulder | 0.150 | 4.467 | 0.667 | 0.100 | 0.067 |
| head / upper arm | 0.233 | 4.267 | 1.183 | 0.600 | 0.550 |
| glove / shoulder | 0.783 | 4.200 | 0.733 | 0.550 | 0.333 |
| glove / upper arm | 0.433 | 4.000 | 0.617 | 0.283 | 0.167 |
| forearm / glove | 1.250 | 3.983 | 0.600 | 0.633 | 0.117 |
| forearm / upper arm | 0.117 | 3.983 | 0.417 | 0.233 | 0.067 |
| forearm / head | 0.200 | 3.583 | 0.583 | 0.483 | 0.067 |
| glove / head | 0.267 | 3.567 | 0.433 | 1.250 | 0.117 |
| head / head | 0.050 | 3.450 | 0.000 | 0.267 | 0.000 |
| shoulder / shoulder | 0.000 | 3.383 | 0.517 | 0.133 | 0.300 |
| upper arm / upper arm | 0.050 | 2.800 | 0.467 | 0.033 | 0.167 |
| glove / glove | 1.300 | 2.133 | 0.533 | 0.817 | 0.250 |
| thigh / upper arm | 0.633 | 1.933 | 1.217 | 0.067 | 0.050 |
| forearm / forearm | 0.217 | 1.883 | 0.283 | 0.133 | 0.033 |
| shoulder / thigh | 0.350 | 1.800 | 1.550 | 0.583 | 0.750 |
| forearm / thigh | 0.667 | 1.350 | 0.150 | 0.000 | 0.000 |
| shin / torso | 1.150 | 1.183 | 0.650 | 0.067 | 0.067 |
| head / thigh | 0.183 | 0.800 | 0.417 | 0.167 | 0.217 |
| glove / thigh | 0.150 | 0.783 | 0.017 | 0.017 | 0.000 |
| shin / shoulder | 0.533 | 0.350 | 0.333 | 0.000 | 0.000 |
| foot / thigh | 0.567 | 0.333 | 0.250 | 0.167 | 0.150 |
| shin / upper arm | 0.583 | 0.317 | 0.200 | 0.050 | 0.017 |
| head / shin | 0.350 | 0.267 | 0.317 | 0.000 | 0.000 |
| foot / torso | 0.433 | 0.183 | 0.133 | 0.033 | 0.033 |
| forearm / shin | 0.217 | 0.183 | 0.000 | 0.000 | 0.000 |
| glove / shin | 0.083 | 0.117 | 0.000 | 0.017 | 0.000 |
| foot / shoulder | 0.300 | 0.033 | 0.033 | 0.000 | 0.000 |
| foot / upper arm | 0.317 | 0.017 | 0.000 | 0.000 | 0.000 |
| foot / forearm | 0.050 | 0.000 | 0.000 | 0.000 | 0.000 |
| foot / head | 0.133 | 0.000 | 0.000 | 0.000 | 0.000 |

| Run | Frames >3 cm | Share | Longest run s | Worst cm |
|---|---:|---:|---:|---:|
| before_off | 626/3600 | 17.389% | 0.600 | 29.289 |
| before_on | 1370/3600 | 38.056% | 3.300 | 35.468 |
| after_on | 524/3600 | 14.556% | 0.517 | 29.803 |

Overlap-frame animation contexts (exclusive; context is not permission to clip):

- before_off: legacy_strike 373/60 = 6.217 s, unowned_locomotion_guard 196/60 = 3.267 s, unowned_reaction 57/60 = 0.950 s.
- before_on: unowned_locomotion_guard 441/60 = 7.350 s, unowned_reaction 173/60 = 2.883 s, whole_strike 756/60 = 12.600 s.
- after_on: unowned_locomotion_guard 103/60 = 1.717 s, unowned_reaction 71/60 = 1.183 s, whole_strike 350/60 = 5.833 s.

The unowned reaction and locomotion/guard rows are included, not filtered away. Whole-strike placement returns before the legacy floor path; whole-strike arms also refuse the legacy `push_hand` correction. Those two bypasses explain why existing contact machinery did not own these frames. No authored paired-grapple frames occur in this 60-second seed; authored pairs/ground holds remain outside this fix.

### Ten worst: before_off

Tick is the rendered 60 Hz frame index, not the engine simulation tick. Clip clocks are seconds.

| Tick | Time s | Depth cm | A clip @ clock | B clip @ clock | Deepest concrete pair |
|---:|---:|---:|---|---|---|
| 2514 | 41.9000 | 29.289 | `idle` @ 0.2000 | `muay_thai_switch_kick_body` @ 0.2667 | UpperChest-Neck / RightUpperLeg-RightLowerLeg |
| 2513 | 41.8833 | 28.842 | `idle` @ 0.1833 | `muay_thai_switch_kick_body` @ 0.2500 | UpperChest-Neck / RightUpperLeg-RightLowerLeg |
| 2511 | 41.8500 | 28.500 | `idle` @ 0.1500 | `muay_thai_switch_kick_body` @ 0.2167 | UpperChest-Neck / RightUpperLeg-RightLowerLeg |
| 2510 | 41.8333 | 28.483 | `idle` @ 0.1333 | `muay_thai_switch_kick_body` @ 0.2000 | UpperChest-Neck / RightUpperLeg-RightLowerLeg |
| 2512 | 41.8667 | 28.060 | `idle` @ 0.1667 | `muay_thai_switch_kick_body` @ 0.2333 | UpperChest-Neck / RightUpperLeg-RightLowerLeg |
| 3286 | 54.7667 | 26.438 | `loc_advance` @ 0.0322 | `muay_thai_switch_kick_body` @ 0.2333 | UpperChest-Neck / RightLowerLeg-RightFoot |
| 3155 | 52.5833 | 25.784 | `loc_strafe_right` @ 0.1338 | `muay_thai_thip_khang` @ 0.5500 | Hips-Spine / RightUpperLeg-RightLowerLeg |
| 3287 | 54.7833 | 25.532 | `loc_advance` @ 0.0395 | `muay_thai_switch_kick_body` @ 0.2500 | UpperChest-Neck / RightLowerLeg-RightFoot |
| 1119 | 18.6500 | 24.844 | `react_leg` @ 2.6667 | `kickboxing_roundhouse` @ 0.2333 | UpperChest-Neck / RightFoot-RightToes |
| 939 | 15.6500 | 24.581 | `idle` @ 0.3167 | `muay_thai_switch_kick_body` @ 0.2333 | UpperChest-Neck / RightFoot-RightToes |

### Ten worst: before_on

Tick is the rendered 60 Hz frame index, not the engine simulation tick. Clip clocks are seconds.

| Tick | Time s | Depth cm | A clip @ clock | B clip @ clock | Deepest concrete pair |
|---:|---:|---:|---|---|---|
| 3132 | 52.2000 | 35.468 | `loc_advance` @ 0.2592 | `kickboxing_axe_kick` @ 0.2000 | UpperChest-Neck / Chest-UpperChest |
| 3133 | 52.2167 | 35.393 | `loc_advance_right` @ 0.0108 | `kickboxing_axe_kick` @ 0.2167 | UpperChest-Neck / Chest-UpperChest |
| 3082 | 51.3667 | 34.769 | `slip` @ 0.1000 | `kickboxing_high_kick` @ 0.3667 | UpperChest-Neck / Hips-Spine |
| 3083 | 51.3833 | 33.529 | `slip` @ 0.1167 | `kickboxing_high_kick` @ 0.3833 | UpperChest-Neck / Hips-Spine |
| 3081 | 51.3500 | 32.452 | `slip` @ 0.0833 | `kickboxing_high_kick` @ 0.3500 | UpperChest-Neck / Hips-Spine |
| 515 | 8.5833 | 32.422 | `react_leg` @ 1.9833 | `idle` @ 2.3667 | Head / Chest-UpperChest |
| 514 | 8.5667 | 31.574 | `react_leg` @ 1.9667 | `idle` @ 2.3500 | Head / Chest-UpperChest |
| 3134 | 52.2333 | 31.282 | `loc_advance_right` @ 0.0216 | `kickboxing_axe_kick` @ 0.2333 | UpperChest-Neck / Chest-UpperChest |
| 3131 | 52.1833 | 30.917 | `loc_advance` @ 0.2448 | `kickboxing_axe_kick` @ 0.1833 | UpperChest-Neck / Chest-UpperChest |
| 3080 | 51.3333 | 30.755 | `slip` @ 0.0667 | `kickboxing_high_kick` @ 0.3333 | Chest-UpperChest / Hips-Spine |

### Ten worst: after_on

Tick is the rendered 60 Hz frame index, not the engine simulation tick. Clip clocks are seconds.

| Tick | Time s | Depth cm | A clip @ clock | B clip @ clock | Deepest concrete pair |
|---:|---:|---:|---|---|---|
| 2656 | 44.2667 | 29.803 | `loc_retreat` @ 0.0508 | `kickboxing_low_kick` @ 0.4667 | Chest-UpperChest / RightUpperLeg-RightLowerLeg |
| 763 | 12.7167 | 28.201 | `jab` @ 0.1333 | `muay_thai_straight_knee` @ 0.4333 | Chest-UpperChest / RightUpperLeg-RightLowerLeg |
| 969 | 16.1500 | 27.533 | `loc_strafe_left` @ 0.0069 | `kickboxing_body_kick` @ 0.2667 | UpperChest-Neck / RightLowerLeg-RightFoot |
| 968 | 16.1333 | 26.858 | `loc_strafe_left` @ 0.0034 | `kickboxing_body_kick` @ 0.2500 | UpperChest-Neck / RightLowerLeg-RightFoot |
| 3458 | 57.6333 | 26.488 | `react_head#3` @ 0.1333 | `kickboxing_axe_kick` @ 0.4333 | LeftUpperArm-LeftLowerArm / Hips-Spine |
| 967 | 16.1167 | 26.153 | `idle` @ 1.0667 | `kickboxing_body_kick` @ 0.2333 | UpperChest-Neck / RightLowerLeg-RightFoot |
| 764 | 12.7333 | 25.856 | `jab` @ 0.1500 | `muay_thai_straight_knee` @ 0.4500 | Hips-Spine / RightUpperLeg-RightLowerLeg |
| 762 | 12.7000 | 25.718 | `jab` @ 0.1167 | `muay_thai_straight_knee` @ 0.4167 | Chest-UpperChest / RightUpperLeg-RightLowerLeg |
| 3080 | 51.3333 | 25.043 | `slip` @ 0.0667 | `kickboxing_high_kick` @ 0.3333 | Chest-UpperChest / RightUpperLeg-RightLowerLeg |
| 3078 | 51.3000 | 24.742 | `slip` @ 0.0333 | `kickboxing_high_kick` @ 0.3000 | UpperChest-Neck / RightUpperLeg-RightLowerLeg |

## Playback / placement change

- Room switch `configure({"contact_stop": true})`, default false. It runs after the final root/hand writers; paired exchanges and ground holds are excluded.
- Up to six posed contact iterations correct fixed head/torso pairs and leg/leg pairs only, sharing root movement equally. Total pair correction is capped at the existing C190 **0.4 m** warp allowance. The solve leaves a **5 mm** tolerance and adds no extra range buffer. Arena clamping still applies.
- A landed kick or knee fades out root correction over the existing 0.20 s in / 0.05 s hold / 0.15 s out contact envelope. This is necessary: the first version reduced overlaps further but moved the landed low kick 14.6 cm short. The final version preserves that contact; the no-kick-anchor mutant catches its removal.
- Four reposed arm passes correct penetrations. During a landed hand strike, a target on the actual head/torso capsule union takes priority over a guard push that would make the blow miss. The two-bone solver preserves bone lengths and the glove rotation; four feedback iterations compensate reach limiting. It does not freeze, seek, trim, or speed up the clip.
- No `FightSeparation.gd` change. No changes to Cursor U160 speed-cap/hand-continuity functions. OFF never reaches these new writers.

## Landed-contact and compatibility evidence

At each sampled landed contact, signed capsule surface depth is positive for penetration, negative for a gap. Hand identity comes from the strike contact data; kick/ knee effectors are selected from the source clip by travel at contact, matching C190. A knee is measured with its shin capsule here, not its glove.

| Tick | Take | Effector | Region | Before cm | After cm |
|---:|---|---|---|---:|---:|
| 103 | hook_lead | LeftHand | head_neck | -10.197 | -0.000 |
| 236 | hook_rear | RightHand | head_neck | -9.983 | 1.016 |
| 535 | hook_lead | LeftHand | torso_core | 5.415 | -0.000 |
| 760 | muay_thai_straight_knee | RightLowerLeg-RightFoot | head_neck | -18.057 | -18.057 |
| 969 | kickboxing_body_kick | RightFoot-RightToes | head_neck | -11.251 | -11.251 |
| 1119 | boxing_overhand | RightHand | torso_core | -0.692 | 0.000 |
| 1437 | boxing_one_two | LeftHand | torso_core | 8.186 | -0.000 |
| 1568 | hook_lead | LeftHand | head_neck | -10.061 | 0.034 |
| 2168 | hook_lead | LeftHand | head_neck | -5.468 | 0.000 |
| 2175 | boxing_one_two | LeftHand | head_neck | -45.175 | -0.000 |
| 2662 | kickboxing_low_kick | LeftFoot-LeftToes | left_leg | -2.880 | -2.098 |
| 3302 | hook_lead | LeftHand | torso_core | 3.184 | 0.000 |
| 3452 | kickboxing_axe_kick | RightFoot-RightToes | head_neck | -20.339 | -18.552 |

The 3 cm test tolerance is about one third of the measured 8.96-10.17 cm world glove radius and requires proximity on both sides of the surface. It cannot pass merely by moving the men farther apart. It covers every observed landed punch and the observed landed low kick, with occurrence assertions. Other head-targeted knee/kick clips still miss by 11-19 cm; C190 already documented target-height/binding mismatches. These are unresolved visual contacts, not claimed as landed by this geometry.

Exact compatibility: all **3600** OFF pose hashes match execution of the unmodified baseline room source; the baseline and current stage have identical executable OFF behavior. The regression test independently compares OFF pose bytes with the contact call removed. Event hash both ON before/after: `c69594a7fdf028beee661c28308f542d1706d4149826885edf8c2b2fea7de279`. Aggregate OFF pose hash (SHA-256 of compact JSON of the 3600 per-frame hashes): `2305b9deaa3260d212cb9f827be154bdaf24a42239f8c1738859549b72fa3604`.

J20 event-rate anchors cannot move in this exact-log comparison. This does not certify population calibration: C190's pre-existing anchor misses remain.

## Gates

- Parse: **4 scripts, 0 failures** (both production scripts, census, new test). Generated recorder derivatives and baseline source also parsed before running.
- `fight_contact_stop_test`: **146 checks, 0 failures**; nine landed punches, one landed low kick, positive clinch overlap, reduced overlap and leg/leg counts, exact simulation log equality and OFF pose bytes.
- Runtime mutants compile without changing production files: no room hook **10 failures**; no placement **1**; no landed-hand targeting **7**; no kick anchor **1**. Each is an assertion failure, not a parse error or missing feature.
- `--only fight_stage`: **SUITE total=10 fails=1**, only the documented ceiling `fight_stage_realism_test`.
- `--only fight_world`: **SUITE total=4 fails=0**.
- `--only fight_separation`: **SUITE total=2 fails=0**.
- `--only fight_strike_whole`: **SUITE total=1 fails=0**.
- No full suite. Existing ObjectDB shutdown leak warnings remain.

## Film reviewed

`_captures/watch_loop/c191_clipping_ab.mp4`: **10.0 s**, **1280 x 540**, **30 fps**, **1,471,306 bytes** (<50 MB), contact_stop **OFF | ON**, both whole switches ON. Same seed, camera and 60 Hz clock, window **47.2-57.2 s**, containing the baseline worst moment at 52.2 s. Raw recordings have 600 frames each at 60 fps. Export uses the same fixed crop (960 x 810 at 480,270 from 1920 x 1080), scaled to 640 x 540 per side; no time offsets, retiming or pose edits. Audio omitted.

Both windowed runs used `Tools/godot_hidden.ps1`. The owned census generates scratch derivatives of `tools/record_room.gd`, adding its missing whole/contact switch options, a 2832-frame deterministic pre-roll and the fixed camera. The unowned recorder source is unchanged.

**Opened the final movie as a ten-frame contact sheet**, also opened its enlarged worst-window frame. The ON arm separates the severe torso/leg mergers in the middle of the interval while retaining close exchanges. Feet, upper arms and kick-window overlaps remain visible; stills do not establish smoothness or full visual acceptance. The final root correction is distance-bounded, not independently speed-smoothed; rapid correction remains a visual risk requiring motion review. The task is a bounded clipping reduction, default OFF.

## Reproduce

All paths relative to the C191 worktree. Set `$g` to the supplied Godot 4.7.2 console executable.

```powershell
python Godot/tools/check_scripts.py Godot/scripts/FightStagePlayer.gd Godot/scripts/FightWorldLiveScreen.gd Godot/tools/c191_clip_census.gd Godot/tests/fight_contact_stop_test.gd
& $g --headless --path Godot --script tools/c191_clip_census.gd -- whole=false stop=false out=control
& $g --headless --path Godot --script tools/c191_clip_census.gd -- whole=true stop=false out=before
& $g --headless --path Godot --script tools/c191_clip_census.gd -- whole=true stop=true out=after
& $g --headless --path Godot --script tests/fight_contact_stop_test.gd
# Repeat test with: -- mutant=no_hook / no_placement / no_landed_contact / no_kick_anchor
& $g --headless --path Godot --script tools/c191_clip_census.gd -- mode=prepare_record stop=false
& $g --headless --path Godot --script tools/c191_clip_census.gd -- mode=prepare_record stop=true
python Godot/tools/check_scripts.py Godot/.godot/c191/record_false.gd Godot/.godot/c191/record_true.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script .godot/c191/record_false.gd --rendering-method gl_compatibility --fixed-fps 60 --write-movie .godot/c191/off.avi --quit-after 600 -- seed=92012 discipline=mma
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script .godot/c191/record_true.gd --rendering-method gl_compatibility --fixed-fps 60 --write-movie .godot/c191/on.avi --quit-after 600 -- seed=92012 discipline=mma
python Godot/tools/run_tests.py --only fight_stage
python Godot/tools/run_tests.py --only fight_world
python Godot/tools/run_tests.py --only fight_separation
python Godot/tools/run_tests.py --only fight_strike_whole
```

Raw census and scratch media are under `Godot/.godot/c191`. Only owned sources/test/tool, this digest, the MP4 and three C191 mail files are committed. Import-cache changes and the pre-existing untracked assets are excluded. The task-specific no-HANDOFF rule overrides the generic HANDOFF-block instruction. RTK required `CLAUDE_CONFIG_DIR`; exact evidence used raw output. The initial generic brief printed unrelated assignments; none was taken on. C191 remained the only implemented task.
