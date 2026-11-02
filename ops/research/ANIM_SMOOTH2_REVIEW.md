# ANIM-SMOOTH2B review - acceptance OPEN, 2026-10-10

**No requested arm reaches join p95 < 34,667 deg/s2 with breathing both ON and OFF. Stop here; do not relax the target or enable the new switches.** The combined arm C is retained as the review default because it minimizes the worse of the two p95 values: 26,507.175707 ON / 58,927.673431 OFF. Its OFF idle minimum also fails the 10% control. Foot drift has no qualifying plants and remains unwitnessed.

## Master integration and scope

Merged `origin/master` at `b855d645` into `codex/anim-smooth2` (merge `2a066225`, on top of `ae5a1d2e`). `FightInertialize.gd` and `anim_transitions.json` are exactly master's versions, including shortest-arc capture; no new table row was needed. The screen conflict preserves master's operator-approved breathing/camera game defaults and the two SMOOTH2 switches OFF. No HANDOFF edit, action scheduler, committed strike clock, simulation state, RNG, foot-lock implementation or animation asset change.

The player now consumes master's `transitions` schema and `capture` / `offset_at` / `rule` API; the existing pure test also exercises `apply`. Master's literal ANY_NON_STAGGER row is resolved at the player boundary, and its strict never-blend knockdown constraint is applied there. Local helpers replace calls to two methods absent from master's API: shortest-arc rotation-vector measurement and clip-space hips translation decay. No second inertialization module was created. The test preserves the 36 Ludo source rows as all 42 literal-source expansions, with duration/exit values checked independently.

## Protocol and arms

Seed 94400, boxing, bare `as_game` flag, 900 drawn frames at 30 Hz. Within each breathing condition only the requested join arm changes; both SMOOTH2 switches are ON for every experimental arm, OFF for master controls and final compatibility recordings. As in the first review, the camera spring follows the breathing control (ON/ON or OFF/OFF); all comparisons use matched settings. Every movie uses `Tools/godot_hidden.ps1` on its never-displayed desktop with Dummy audio. Final drawn global bone rotations are measured after modifiers, using the unchanged signed shortest-arc angular second difference and unchanged +/-2-frame join window.

- Untuned: adapted master API, original full-duration quintic envelope and forced midpoint endpoint sample.
- A: table durations, critical residual faded with a quintic over the last 25% of duration; no early forced midpoint clamp.
- B: duration floor `4/30 = 0.133333333 s` on non-cut joins; otherwise the untuned envelope/sampling.
- C: A + B. Cut remains zero duration. Only C is selected by default; the internal measurement selector retains reproducibility for rejected arms.

The A pilot still forced a midpoint sample to the endpoint half a frame early. It is not the final A arm. The corrected A recordings are `a2_on/off`; pilot numbers are retained below. C was recorded after that correction, B's sampling is unchanged.

## Achieved beside wanted

Wanted: **join p95 < 34,667 deg/s2 in BOTH breathing conditions**, camera/idle/feet within +/-10% of the matched master control. All rows have 49 clip changes. Median/p95/max are deg/s2; ON/OFF below means breathing/camera, not the new switches.

| Arm | Breathing | Median | p95 achieved | Max | p95 wanted | Result |
| --- | --- | ---: | ---: | ---: | --- | --- |
| Master, new switches OFF | ON | 11104.381940 | 38238.523677 | 222062.210893 | < 34,667 | FAIL |
| Master, new switches OFF | OFF | 10591.110922 | 34666.679544 | 220736.526815 | < 34,667 | PASS |
| Untuned, new switches ON | ON | 11093.852938 | 54956.161037 | 98309.813025 | < 34,667 | FAIL |
| A, tail only | ON | 11104.556297 | 39384.744104 | 162432.276247 | < 34,667 | FAIL |
| A, tail only | OFF | 11837.853074 | 69129.407638 | 144277.359075 | < 34,667 | FAIL |
| B, four-frame floor | ON | 10466.239643 | 25955.311193 | 106823.068168 | < 34,667 | PASS |
| B, four-frame floor | OFF | 11280.472266 | 62149.894913 | 101436.503546 | < 34,667 | FAIL |
| C, both (retained) | ON | 10426.613451 | 26507.175707 | 84243.079210 | < 34,667 | PASS |
| C, both (retained) | OFF | 11167.769244 | 58927.673431 | 202748.812326 | < 34,667 | FAIL |

The worst-condition p95 is A 69,129.407638, B 62,149.894913, C 58,927.673431. C wins that comparison but is not accepted. Even with ON p95 below target, isolated peaks remain large.

| Retained A pilot | Median | p95 | Max |
| --- | ---: | ---: | ---: |
| a_on | 11104.556297 | 40152.841395 | 166122.962758 |
| a_off | 11837.853074 | 66934.193386 | 131704.186180 |

## Where the acceleration comes from

Before tuning, the previous OFF/ON per-pair split identified idle -> boxing_slip, react_body -> idle and boxing_jab -> boxing_cross as the prior ON p95 owners, predominantly the left arm. Those historical split reports and frame angles are preserved in `pass2b/previous_*`.

The fresh API-adapted untuned take has slightly different numbers, so it was split again before running the arms. Its three global-p95 owners are jab -> cross (b LeftUpperArm), idle -> slip (a LeftUpperArm), cross -> idle (b LeftForeArm). Frame-by-frame witnesses:

1. Jab -> cross, join 613: frame 614 has 11.563823 deg applied residual; frame 615 hits the 0.09 s endpoint, removes it, and has 98,309.813025 deg/s2 acceleration. This is an actual endpoint-clamp spike.
2. Idle -> slip, join 637: the 97,208.257567 deg/s2 winning sample is frame 635, two frames BEFORE the labelled switch. There is no active residual there; the new slip's measured upper-arm residual is zero. A pair label is not proof the labelled switch caused its maximum.
3. Cross -> idle, join 637: frame 639 reaches 63,073.257128 deg/s2 while applied residual is only 1.816331 deg and the decay has NOT clamped. Large final-pose acceleration survives beyond the endpoint defect. This capture does not isolate which incoming-clip or later pose layer causes that remainder.

The full-window plot uses the angular second difference, not unsigned angle differences: `E:/FightCamp/tmp/anim_smooth2/pass2b/join_second_difference.png`. The tables below include step angle for inspection, alongside the actual signed-vector acceleration and sampled residual/clamp trace.

| Pair / bone | Frame | Clip | Step angle, deg | Acceleration, deg/s2 | Sampled raw / applied residual, deg | Clamp |
| --- | ---: | --- | ---: | ---: | --- | --- |
| jab to cross, b LeftUpperArm | 610 | boxing_jab | 5.136 | 3611.476 | inactive | - |
| jab to cross, b LeftUpperArm | 611 | boxing_jab | 3.286 | 6259.212 | inactive | - |
| jab to cross, b LeftUpperArm | 612 | boxing_jab | 7.457 | 5392.147 | inactive | - |
| jab to cross, b LeftUpperArm | 613 | boxing_cross | 28.906 | 20425.909 | 36.119133 / 34.415300 | false |
| jab to cross, b LeftUpperArm | 614 | boxing_cross | 22.527 | 12549.103 | 29.150964 / 11.563823 | false |
| jab to cross, b LeftUpperArm | 615 | boxing_cross | 87.766 | 98309.813 | 0.000000 / 0.000000 | true |
| jab to cross, b LeftUpperArm | 616 | boxing_cross | 33.683 | 58483.217 | inactive | - |
| jab to cross, b LeftUpperArm | 617 | boxing_cross | 23.675 | 33257.516 | inactive | - |
| jab to cross, b LeftUpperArm | 618 | boxing_cross | 27.483 | 12537.272 | inactive | - |
| idle to slip, a LeftUpperArm | 634 | idle | 53.463 | 39538.650 | inactive | - |
| idle to slip, a LeftUpperArm | 635 | idle | 64.465 | 97208.258 | inactive | - |
| idle to slip, a LeftUpperArm | 636 | idle | 46.072 | 40279.086 | inactive | - |
| idle to slip, a LeftUpperArm | 637 | boxing_slip | 9.101 | 34863.986 | 0.000000 / 0.000000 | false |
| idle to slip, a LeftUpperArm | 638 | boxing_slip | 4.846 | 7390.942 | 0.000000 / 0.000000 | false |
| idle to slip, a LeftUpperArm | 639 | boxing_slip | 12.852 | 10817.922 | 0.000000 / 0.000000 | true |
| idle to slip, a LeftUpperArm | 640 | boxing_slip | 18.676 | 7604.146 | inactive | - |
| idle to slip, a LeftUpperArm | 641 | boxing_slip | 10.259 | 13472.534 | inactive | - |
| idle to slip, a LeftUpperArm | 642 | boxing_slip | 13.455 | 10869.873 | inactive | - |
| cross to idle, b LeftForeArm | 634 | boxing_cross | 10.342 | 18158.601 | inactive | - |
| cross to idle, b LeftForeArm | 635 | boxing_cross | 22.613 | 11531.665 | inactive | - |
| cross to idle, b LeftForeArm | 636 | boxing_cross | 13.155 | 16270.132 | inactive | - |
| cross to idle, b LeftForeArm | 637 | idle | 13.410 | 23358.369 | 0.669100 / 0.666512 | false |
| cross to idle, b LeftForeArm | 638 | idle | 33.498 | 18739.202 | 2.217069 / 2.037463 | false |
| cross to idle, b LeftForeArm | 639 | idle | 40.752 | 63073.257 | 2.527860 / 1.816331 | false |
| cross to idle, b LeftForeArm | 640 | idle | 27.627 | 26111.920 | 2.305000 / 1.021854 | false |
| cross to idle, b LeftForeArm | 641 | idle | 24.925 | 12054.288 | 1.900774 / 0.357253 | false |
| cross to idle, b LeftForeArm | 642 | idle | 15.574 | 32024.127 | 1.480385 / 0.052545 | false |

C reduces these ON contributors, but OFF p95 is still owned by idle -> slip, cross -> idle and jab -> cross (left upper arm). Neither a continuous endpoint envelope nor four drawn frames establishes a bound on all final-pose accelerations. No further tuning or unrelated layer repair was attempted after the three arms failed the unchanged dual-condition target.

## Matched controls, best C

| Metric | Master ON | C ON | Master OFF | C OFF | Wanted / verdict |
| --- | ---: | ---: | ---: | ---: | --- |
| Camera acceleration sigma, m/s2 | 14.785468 | 15.770666 | 19.844293 | 20.120071 | +/-10%; +6.66% / +1.39%, PASS |
| Camera spikes | 142 | 141 | 282 | 284 | +/-10%, PASS |
| Idle minimum, cm/s | 0.505359 | 0.505359 | 0.000045 | 0.505359 | +/-10%; ON PASS, OFF FAIL |
| Idle median, cm/s | 88.952422 | 89.379149 | 91.212570 | 89.716548 | +/-10%; +0.48% / -1.64%, PASS |
| Guard-only minimum, cm/s | 2.346435 | 2.349314 | 0.567319 | 0.555113 | +/-10%, PASS |
| Pelvis minimum, cm | 45.386182 | 43.980676 | 44.456362 | 44.050907 | Measured floor 36.897622 cm, clears it |
| Frames below measured torso sum | 0 | 0 | 0 | 0 | Wanted 0; baseline already clears it |
| Frames below placeholder 55 cm | 5 | 6 | 6 | 6 | Diagnostic only, not the mesh-derived floor |
| Qualifying foot plants | 0 | 0 | 0 | 0 | UNWITNESSED; NaN drift is not a 10% pass |
| Failed framing frames | 0 | 0 | 0 | 0 | Wanted 0, PASS |

Torso radii remain 0.185925962 + 0.183050259 = 0.368976221 m. No torso-overlap elimination is claimed from a control already above that floor.

## Per-pair and per-bone join reports

`python Tools/smooth_metrics.py --joins-by-pair <csv>` reports each pair/bone's count, median, p95 and max. Contribution is the count of joins at or above the GLOBAL join p95 for which this pair/bone supplies the winning window maximum; one winning bone is assigned per join. It is not a ranking by each rare pair's own p95. Pair aggregates count each join once; their counts sum to 49. In the per-bone section, rows 1-10 are the top ten by contribution, then max. The underlying acceleration and join windows are unchanged.

### Before, master switches OFF, breathing ON

`master_on_clean.csv`: JOIN_TOTAL count=49 median=11104.381940 p95=38238.523677 max=222062.210893

Pair aggregates (ALL = original maximum across four bones per join):

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | boxing_jab | boxing_cross | ALL | 2 | 122524.817896 | 212108.471594 | 222062.210893 | 1 |
| 2 | react_body | idle | ALL | 6 | 3340.246934 | 57888.254047 | 74521.802562 | 1 |
| 3 | boxing_cross | idle | ALL | 6 | 8283.900486 | 31244.777545 | 38566.915572 | 1 |
| 4 | idle | boxing_rear_hook | ALL | 3 | 15107.902694 | 35482.132521 | 37745.935835 | 0 |
| 5 | boxing_slip | boxing_cross | ALL | 3 | 26444.460999 | 28503.346540 | 28732.111600 | 0 |
| 6 | idle | boxing_slip | ALL | 3 | 13912.584250 | 23050.202176 | 24065.493057 | 0 |
| 7 | idle | react_body | ALL | 6 | 15038.709546 | 21533.714392 | 22011.920162 | 0 |
| 8 | idle | boxing_jab | ALL | 2 | 20685.533856 | 20939.152494 | 20967.332343 | 0 |
| 9 | idle | boxing_cross | ALL | 2 | 19508.015111 | 20311.197466 | 20400.439950 | 0 |
| 10 | boxing_cross | boxing_lead_hook | ALL | 1 | 18039.230831 | 18039.230831 | 18039.230831 | 0 |
| 11 | boxing_lead_hook | idle | ALL | 1 | 11104.381940 | 11104.381940 | 11104.381940 | 0 |
| 12 | idle | slip | ALL | 1 | 10830.391348 | 10830.391348 | 10830.391348 | 0 |
| 13 | boxing_jab_body | idle | ALL | 3 | 3474.690773 | 9754.759799 | 10452.545247 | 0 |
| 14 | boxing_rear_hook | idle | ALL | 3 | 7483.426725 | 8315.691927 | 8408.165839 | 0 |
| 15 | idle | boxing_jab_body | ALL | 4 | 6688.384864 | 7688.944276 | 7702.608935 | 0 |
| 16 | slip | idle | ALL | 1 | 7329.181187 | 7329.181187 | 7329.181187 | 0 |
| 17 | react_head | idle | ALL | 1 | 4356.330550 | 4356.330550 | 4356.330550 | 0 |
| 18 | idle | react_head | ALL | 1 | 4256.704335 | 4256.704335 | 4256.704335 | 0 |

Per-bone top ten contributors:

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | boxing_jab | boxing_cross | LeftUpperArm | 2 | 120547.865411 | 211910.776345 | 222062.210893 | 1 |
| 2 | react_body | idle | LeftForeArm | 6 | 3300.784566 | 56913.247996 | 74521.802562 | 1 |
| 3 | boxing_cross | idle | LeftForeArm | 6 | 7389.887630 | 30987.824556 | 38566.915572 | 1 |
| 4 | boxing_jab | boxing_cross | LeftForeArm | 2 | 120564.822520 | 210111.220603 | 220060.820390 | 0 |
| 5 | react_body | idle | LeftUpperArm | 6 | 3301.760185 | 55222.996289 | 72015.187046 | 0 |
| 6 | boxing_jab | boxing_cross | RightUpperArm | 2 | 32050.218393 | 40206.732537 | 41113.011886 | 0 |
| 7 | boxing_jab | boxing_cross | RightForeArm | 2 | 27824.272025 | 39712.093910 | 41032.963009 | 0 |
| 8 | idle | boxing_rear_hook | LeftUpperArm | 3 | 15107.902694 | 35482.132521 | 37745.935835 | 0 |
| 9 | boxing_cross | idle | LeftUpperArm | 6 | 8283.900486 | 30179.322610 | 37146.308992 | 0 |
| 10 | idle | boxing_rear_hook | LeftForeArm | 3 | 13575.764195 | 28988.859289 | 30701.425411 | 0 |

<details>
<summary>All remaining pair/bone rows (counts and zero-contribution rows retained)</summary>

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 11 | boxing_slip | boxing_cross | LeftForeArm | 3 | 25177.076550 | 28376.608095 | 28732.111600 | 0 |
| 12 | boxing_slip | boxing_cross | RightForeArm | 3 | 17488.957209 | 25716.258517 | 26630.403107 | 0 |
| 13 | boxing_slip | boxing_cross | RightUpperArm | 3 | 25646.224089 | 26364.637308 | 26444.460999 | 0 |
| 14 | boxing_slip | boxing_cross | LeftUpperArm | 3 | 23116.188096 | 25017.479348 | 25228.733932 | 0 |
| 15 | idle | boxing_slip | LeftForeArm | 3 | 8468.056990 | 22505.749450 | 24065.493057 | 0 |
| 16 | idle | react_body | RightForeArm | 6 | 11543.415091 | 19957.423220 | 22011.920162 | 0 |
| 17 | idle | boxing_jab | RightUpperArm | 2 | 20685.533856 | 20939.152494 | 20967.332343 | 0 |
| 18 | idle | boxing_jab | LeftForeArm | 2 | 20481.217771 | 20656.579742 | 20676.064405 | 0 |
| 19 | idle | boxing_cross | RightUpperArm | 2 | 18731.659230 | 20233.561878 | 20400.439950 | 0 |
| 20 | idle | react_body | LeftForeArm | 6 | 13498.302220 | 19316.520117 | 20099.097081 | 0 |
| 21 | idle | boxing_jab | RightForeArm | 2 | 19802.052403 | 19859.854851 | 19866.277345 | 0 |
| 22 | idle | react_body | RightUpperArm | 6 | 12385.004005 | 18805.020708 | 19547.998820 | 0 |
| 23 | idle | boxing_slip | LeftUpperArm | 3 | 9491.906421 | 18539.927108 | 19545.262740 | 0 |
| 24 | idle | boxing_cross | LeftForeArm | 2 | 19017.741531 | 19379.677664 | 19419.892790 | 0 |
| 25 | idle | boxing_cross | LeftUpperArm | 2 | 18349.505581 | 18425.306090 | 18433.728368 | 0 |
| 26 | boxing_cross | boxing_lead_hook | RightForeArm | 1 | 18039.230831 | 18039.230831 | 18039.230831 | 0 |
| 27 | idle | boxing_jab | LeftUpperArm | 2 | 17563.977400 | 17885.436737 | 17921.154441 | 0 |
| 28 | idle | react_body | LeftUpperArm | 6 | 13356.212399 | 17409.167638 | 17801.451545 | 0 |
| 29 | idle | boxing_slip | RightForeArm | 3 | 13102.694318 | 13831.595257 | 13912.584250 | 0 |
| 30 | idle | boxing_slip | RightUpperArm | 3 | 11014.826711 | 13060.966899 | 13288.315809 | 0 |
| 31 | idle | boxing_cross | RightForeArm | 2 | 11358.785140 | 12752.825071 | 12907.718396 | 0 |
| 32 | boxing_lead_hook | idle | LeftUpperArm | 1 | 11104.381940 | 11104.381940 | 11104.381940 | 0 |
| 33 | idle | slip | LeftForeArm | 1 | 10830.391348 | 10830.391348 | 10830.391348 | 0 |
| 34 | idle | slip | LeftUpperArm | 1 | 10668.453469 | 10668.453469 | 10668.453469 | 0 |
| 35 | boxing_cross | boxing_lead_hook | LeftUpperArm | 1 | 10644.685607 | 10644.685607 | 10644.685607 | 0 |
| 36 | react_body | idle | RightForeArm | 6 | 1356.847583 | 9979.991656 | 10644.119373 | 0 |
| 37 | react_body | idle | RightUpperArm | 6 | 1172.902757 | 8879.374762 | 10561.680180 | 0 |
| 38 | boxing_lead_hook | idle | LeftForeArm | 1 | 10481.690765 | 10481.690765 | 10481.690765 | 0 |
| 39 | boxing_jab_body | idle | RightUpperArm | 3 | 1731.331013 | 9580.423823 | 10452.545247 | 0 |
| 40 | boxing_jab_body | idle | RightForeArm | 3 | 3166.909790 | 9659.835912 | 10381.272147 | 0 |
| 41 | idle | boxing_rear_hook | RightForeArm | 3 | 5990.532936 | 9745.527676 | 10162.749313 | 0 |
| 42 | idle | boxing_rear_hook | RightUpperArm | 3 | 8923.511404 | 9534.844621 | 9602.770534 | 0 |
| 43 | idle | slip | RightForeArm | 1 | 9239.851903 | 9239.851903 | 9239.851903 | 0 |
| 44 | idle | slip | RightUpperArm | 1 | 8973.334407 | 8973.334407 | 8973.334407 | 0 |
| 45 | boxing_cross | boxing_lead_hook | LeftForeArm | 1 | 8564.564516 | 8564.564516 | 8564.564516 | 0 |
| 46 | boxing_cross | boxing_lead_hook | RightUpperArm | 1 | 8494.929894 | 8494.929894 | 8494.929894 | 0 |
| 47 | boxing_rear_hook | idle | LeftUpperArm | 3 | 7483.426725 | 8315.691927 | 8408.165839 | 0 |
| 48 | idle | boxing_jab_body | RightUpperArm | 4 | 2987.055995 | 7015.140143 | 7702.608935 | 0 |
| 49 | idle | boxing_jab_body | LeftUpperArm | 4 | 5547.873084 | 7331.383131 | 7611.511210 | 0 |
| 50 | slip | idle | LeftForeArm | 1 | 7329.181187 | 7329.181187 | 7329.181187 | 0 |
| 51 | slip | idle | RightForeArm | 1 | 7273.194221 | 7273.194221 | 7273.194221 | 0 |
| 52 | boxing_cross | idle | RightForeArm | 6 | 4768.778057 | 6788.296299 | 7261.178165 | 0 |
| 53 | boxing_rear_hook | idle | LeftForeArm | 3 | 5077.661736 | 7031.552140 | 7248.651073 | 0 |
| 54 | slip | idle | RightUpperArm | 1 | 7215.954140 | 7215.954140 | 7215.954140 | 0 |
| 55 | slip | idle | LeftUpperArm | 1 | 7162.592023 | 7162.592023 | 7162.592023 | 0 |
| 56 | boxing_lead_hook | idle | RightUpperArm | 1 | 6486.694054 | 6486.694054 | 6486.694054 | 0 |
| 57 | idle | boxing_jab_body | LeftForeArm | 4 | 5664.663999 | 6196.827324 | 6272.986525 | 0 |
| 58 | boxing_lead_hook | idle | RightForeArm | 1 | 6001.016116 | 6001.016116 | 6001.016116 | 0 |
| 59 | boxing_jab_body | idle | LeftUpperArm | 3 | 1626.550885 | 5493.721685 | 5923.407330 | 0 |
| 60 | boxing_cross | idle | RightUpperArm | 6 | 5319.257742 | 5759.572032 | 5855.073602 | 0 |
| 61 | boxing_rear_hook | idle | RightUpperArm | 3 | 4810.806552 | 4859.276004 | 4864.661499 | 0 |
| 62 | boxing_jab_body | idle | LeftForeArm | 3 | 3474.690773 | 4418.896400 | 4523.808136 | 0 |
| 63 | boxing_rear_hook | idle | RightForeArm | 3 | 4506.542402 | 4512.682177 | 4513.364374 | 0 |
| 64 | react_head | idle | RightUpperArm | 1 | 4356.330550 | 4356.330550 | 4356.330550 | 0 |
| 65 | idle | react_head | RightForeArm | 1 | 4256.704335 | 4256.704335 | 4256.704335 | 0 |
| 66 | idle | react_head | LeftUpperArm | 1 | 4218.142693 | 4218.142693 | 4218.142693 | 0 |
| 67 | idle | react_head | LeftForeArm | 1 | 4198.097101 | 4198.097101 | 4198.097101 | 0 |
| 68 | idle | react_head | RightUpperArm | 1 | 4174.876746 | 4174.876746 | 4174.876746 | 0 |
| 69 | idle | boxing_jab_body | RightForeArm | 4 | 2553.233873 | 3585.994246 | 3709.025453 | 0 |
| 70 | react_head | idle | RightForeArm | 1 | 3398.524713 | 3398.524713 | 3398.524713 | 0 |
| 71 | react_head | idle | LeftForeArm | 1 | 1238.576539 | 1238.576539 | 1238.576539 | 0 |
| 72 | react_head | idle | LeftUpperArm | 1 | 1233.967527 | 1233.967527 | 1233.967527 | 0 |

</details>

### Before, master switches OFF, breathing OFF

`master_off.csv`: JOIN_TOTAL count=49 median=10591.110922 p95=34666.679544 max=220736.526815

Pair aggregates (ALL = original maximum across four bones per join):

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | boxing_jab | boxing_cross | ALL | 2 | 121862.906698 | 210849.164803 | 220736.526815 | 1 |
| 2 | react_body | idle | ALL | 6 | 3909.074176 | 52375.576600 | 67680.887006 | 1 |
| 3 | boxing_slip | boxing_cross | ALL | 3 | 26316.939505 | 36637.345304 | 37784.057060 | 1 |
| 4 | idle | boxing_rear_hook | ALL | 3 | 13067.832261 | 28298.335170 | 29990.613270 | 0 |
| 5 | idle | boxing_jab | ALL | 2 | 21384.020671 | 21416.880543 | 21420.531640 | 0 |
| 6 | idle | react_body | ALL | 6 | 16014.195985 | 21093.626957 | 21368.828991 | 0 |
| 7 | boxing_cross | idle | ALL | 6 | 8172.826812 | 17128.146785 | 19598.468989 | 0 |
| 8 | idle | boxing_cross | ALL | 2 | 19278.990498 | 19324.186462 | 19329.208235 | 0 |
| 9 | boxing_cross | boxing_lead_hook | ALL | 1 | 18045.286017 | 18045.286017 | 18045.286017 | 0 |
| 10 | idle | boxing_slip | ALL | 3 | 13509.212077 | 16938.855980 | 17319.927525 | 0 |
| 11 | idle | slip | ALL | 1 | 10868.649400 | 10868.649400 | 10868.649400 | 0 |
| 12 | boxing_lead_hook | idle | ALL | 1 | 10591.110922 | 10591.110922 | 10591.110922 | 0 |
| 13 | idle | boxing_jab_body | ALL | 4 | 5939.177828 | 7495.765883 | 7680.612854 | 0 |
| 14 | boxing_rear_hook | idle | ALL | 3 | 7279.774883 | 7435.334191 | 7452.618559 | 0 |
| 15 | slip | idle | ALL | 1 | 7336.960783 | 7336.960783 | 7336.960783 | 0 |
| 16 | boxing_jab_body | idle | ALL | 3 | 3458.125556 | 6247.686734 | 6557.637976 | 0 |
| 17 | react_head | idle | ALL | 1 | 5147.232511 | 5147.232511 | 5147.232511 | 0 |
| 18 | idle | react_head | ALL | 1 | 3934.213176 | 3934.213176 | 3934.213176 | 0 |

Per-bone top ten contributors:

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | boxing_jab | boxing_cross | LeftUpperArm | 2 | 119886.827154 | 210651.556849 | 220736.526815 | 1 |
| 2 | react_body | idle | LeftForeArm | 6 | 3760.035313 | 51891.579740 | 67680.887006 | 1 |
| 3 | boxing_slip | boxing_cross | RightForeArm | 3 | 17338.002026 | 35739.451556 | 37784.057060 | 1 |
| 4 | boxing_jab | boxing_cross | LeftForeArm | 2 | 119934.630617 | 208910.636875 | 218796.859792 | 0 |
| 5 | react_body | idle | LeftUpperArm | 6 | 3882.622317 | 50735.342749 | 65914.267412 | 0 |
| 6 | boxing_jab | boxing_cross | RightUpperArm | 2 | 31825.819914 | 39778.699914 | 40662.353247 | 0 |
| 7 | boxing_jab | boxing_cross | RightForeArm | 2 | 27637.075448 | 39353.211696 | 40655.004612 | 0 |
| 8 | idle | boxing_rear_hook | LeftUpperArm | 3 | 13067.832261 | 28298.335170 | 29990.613270 | 0 |
| 9 | idle | boxing_rear_hook | LeftForeArm | 3 | 11439.864845 | 28035.088320 | 29879.002040 | 0 |
| 10 | boxing_slip | boxing_cross | RightUpperArm | 3 | 25681.679401 | 26253.413494 | 26316.939505 | 0 |

<details>
<summary>All remaining pair/bone rows (counts and zero-contribution rows retained)</summary>

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 11 | boxing_slip | boxing_cross | LeftUpperArm | 3 | 22956.003825 | 25195.404990 | 25444.227342 | 0 |
| 12 | boxing_slip | boxing_cross | LeftForeArm | 3 | 22640.557408 | 23823.422197 | 23954.851618 | 0 |
| 13 | idle | boxing_jab | RightUpperArm | 2 | 21384.020671 | 21416.880543 | 21420.531640 | 0 |
| 14 | idle | react_body | LeftForeArm | 6 | 14679.802882 | 20523.435339 | 21368.828991 | 0 |
| 15 | idle | boxing_jab | LeftForeArm | 2 | 20591.371156 | 20653.668452 | 20660.590373 | 0 |
| 16 | idle | react_body | RightForeArm | 6 | 10720.488250 | 18464.283584 | 20268.020853 | 0 |
| 17 | idle | boxing_jab | RightForeArm | 2 | 20112.893917 | 20153.846351 | 20158.396622 | 0 |
| 18 | boxing_cross | idle | LeftUpperArm | 6 | 8172.826812 | 17128.146785 | 19598.468989 | 0 |
| 19 | idle | boxing_cross | LeftForeArm | 2 | 19278.990498 | 19324.186462 | 19329.208235 | 0 |
| 20 | boxing_cross | idle | LeftForeArm | 6 | 7468.312932 | 16557.951626 | 19251.635347 | 0 |
| 21 | idle | boxing_cross | RightUpperArm | 2 | 19012.752341 | 19042.046079 | 19045.300939 | 0 |
| 22 | idle | boxing_cross | LeftUpperArm | 2 | 18535.306967 | 18571.434036 | 18575.448155 | 0 |
| 23 | idle | react_body | RightUpperArm | 6 | 12783.199931 | 17679.408170 | 18047.245956 | 0 |
| 24 | boxing_cross | boxing_lead_hook | RightForeArm | 1 | 18045.286017 | 18045.286017 | 18045.286017 | 0 |
| 25 | idle | boxing_jab | LeftUpperArm | 2 | 17559.182325 | 17987.812078 | 18035.437607 | 0 |
| 26 | idle | boxing_slip | LeftForeArm | 3 | 8827.376596 | 16470.672432 | 17319.927525 | 0 |
| 27 | idle | react_body | LeftUpperArm | 6 | 13070.076818 | 16721.174469 | 16814.837004 | 0 |
| 28 | idle | boxing_slip | RightForeArm | 3 | 13319.806429 | 14143.855725 | 14235.416757 | 0 |
| 29 | idle | boxing_slip | RightUpperArm | 3 | 10792.354598 | 13237.526329 | 13509.212077 | 0 |
| 30 | idle | boxing_slip | LeftUpperArm | 3 | 10687.064665 | 12938.547149 | 13188.711869 | 0 |
| 31 | idle | boxing_cross | RightForeArm | 2 | 11815.906109 | 11868.818526 | 11874.697684 | 0 |
| 32 | idle | slip | LeftForeArm | 1 | 10868.649400 | 10868.649400 | 10868.649400 | 0 |
| 33 | idle | slip | LeftUpperArm | 1 | 10655.436817 | 10655.436817 | 10655.436817 | 0 |
| 34 | boxing_cross | boxing_lead_hook | LeftUpperArm | 1 | 10650.827920 | 10650.827920 | 10650.827920 | 0 |
| 35 | boxing_lead_hook | idle | LeftForeArm | 1 | 10591.110922 | 10591.110922 | 10591.110922 | 0 |
| 36 | boxing_lead_hook | idle | LeftUpperArm | 1 | 10573.432584 | 10573.432584 | 10573.432584 | 0 |
| 37 | react_body | idle | RightForeArm | 6 | 1338.397902 | 8862.751289 | 9663.786591 | 0 |
| 38 | react_body | idle | RightUpperArm | 6 | 1144.211675 | 8550.017332 | 9597.018199 | 0 |
| 39 | idle | slip | RightForeArm | 1 | 9144.407166 | 9144.407166 | 9144.407166 | 0 |
| 40 | idle | slip | RightUpperArm | 1 | 9026.399912 | 9026.399912 | 9026.399912 | 0 |
| 41 | idle | boxing_rear_hook | RightUpperArm | 3 | 7816.969513 | 8518.275886 | 8596.198816 | 0 |
| 42 | boxing_cross | boxing_lead_hook | LeftForeArm | 1 | 8534.915864 | 8534.915864 | 8534.915864 | 0 |
| 43 | boxing_cross | boxing_lead_hook | RightUpperArm | 1 | 8497.929610 | 8497.929610 | 8497.929610 | 0 |
| 44 | idle | boxing_rear_hook | RightForeArm | 3 | 6437.975149 | 7852.572112 | 8009.749552 | 0 |
| 45 | idle | boxing_jab_body | LeftUpperArm | 4 | 5687.152014 | 7427.612309 | 7680.612854 | 0 |
| 46 | boxing_rear_hook | idle | LeftUpperArm | 3 | 7279.774883 | 7435.334191 | 7452.618559 | 0 |
| 47 | slip | idle | RightForeArm | 1 | 7336.960783 | 7336.960783 | 7336.960783 | 0 |
| 48 | slip | idle | RightUpperArm | 1 | 7336.942233 | 7336.942233 | 7336.942233 | 0 |
| 49 | boxing_rear_hook | idle | LeftForeArm | 3 | 5388.180596 | 6785.524140 | 6940.784534 | 0 |
| 50 | boxing_jab_body | idle | RightUpperArm | 3 | 1978.901291 | 6099.764308 | 6557.637976 | 0 |
| 51 | boxing_jab_body | idle | RightForeArm | 3 | 2965.034043 | 6143.849427 | 6497.051136 | 0 |
| 52 | slip | idle | LeftForeArm | 1 | 6472.854404 | 6472.854404 | 6472.854404 | 0 |
| 53 | slip | idle | LeftUpperArm | 1 | 6472.845950 | 6472.845950 | 6472.845950 | 0 |
| 54 | idle | boxing_jab_body | RightUpperArm | 4 | 2368.644250 | 5936.212890 | 6448.299713 | 0 |
| 55 | idle | boxing_jab_body | LeftForeArm | 4 | 5600.979262 | 6176.993015 | 6248.479563 | 0 |
| 56 | boxing_cross | idle | RightUpperArm | 6 | 5398.029833 | 6033.410730 | 6220.193511 | 0 |
| 57 | boxing_lead_hook | idle | RightForeArm | 1 | 5856.894641 | 5856.894641 | 5856.894641 | 0 |
| 58 | boxing_cross | idle | RightForeArm | 6 | 4811.872214 | 5392.289762 | 5505.202719 | 0 |
| 59 | idle | boxing_jab_body | RightForeArm | 4 | 1901.619009 | 4905.498862 | 5407.392289 | 0 |
| 60 | boxing_jab_body | idle | LeftUpperArm | 3 | 1488.148128 | 4879.210408 | 5255.995105 | 0 |
| 61 | react_head | idle | RightUpperArm | 1 | 5147.232511 | 5147.232511 | 5147.232511 | 0 |
| 62 | boxing_rear_hook | idle | RightUpperArm | 3 | 4631.486289 | 5092.149835 | 5143.334674 | 0 |
| 63 | boxing_jab_body | idle | LeftForeArm | 3 | 3458.125556 | 4712.306787 | 4851.660257 | 0 |
| 64 | boxing_rear_hook | idle | RightForeArm | 3 | 4429.709649 | 4644.771128 | 4668.666847 | 0 |
| 65 | boxing_lead_hook | idle | RightUpperArm | 1 | 4535.824806 | 4535.824806 | 4535.824806 | 0 |
| 66 | react_head | idle | RightForeArm | 1 | 4195.581227 | 4195.581227 | 4195.581227 | 0 |
| 67 | idle | react_head | RightUpperArm | 1 | 3934.213176 | 3934.213176 | 3934.213176 | 0 |
| 68 | idle | react_head | LeftForeArm | 1 | 3934.205200 | 3934.205200 | 3934.205200 | 0 |
| 69 | idle | react_head | LeftUpperArm | 1 | 3934.197396 | 3934.197396 | 3934.197396 | 0 |
| 70 | idle | react_head | RightForeArm | 1 | 3934.195081 | 3934.195081 | 3934.195081 | 0 |
| 71 | react_head | idle | LeftForeArm | 1 | 1298.885763 | 1298.885763 | 1298.885763 | 0 |
| 72 | react_head | idle | LeftUpperArm | 1 | 1250.029186 | 1250.029186 | 1250.029186 | 0 |

</details>

### Untuned switches ON, breathing ON

`original_on.csv`: JOIN_TOTAL count=49 median=11093.852938 p95=54956.161037 max=98309.813025

Pair aggregates (ALL = original maximum across four bones per join):

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | boxing_jab | boxing_cross | ALL | 2 | 58946.003427 | 94373.432065 | 98309.813025 | 1 |
| 2 | idle | boxing_slip | ALL | 3 | 15895.696240 | 89077.001434 | 97208.257567 | 1 |
| 3 | boxing_cross | idle | ALL | 6 | 8703.273020 | 49624.561269 | 63073.257128 | 1 |
| 4 | react_body | idle | ALL | 6 | 5677.710203 | 35728.059831 | 42780.516900 | 0 |
| 5 | idle | boxing_jab | ALL | 2 | 25968.718907 | 26980.725668 | 27093.170864 | 0 |
| 6 | idle | slip | ALL | 1 | 25549.254040 | 25549.254040 | 25549.254040 | 0 |
| 7 | boxing_slip | boxing_cross | ALL | 3 | 21656.464545 | 23986.828796 | 24245.758157 | 0 |
| 8 | idle | boxing_rear_hook | ALL | 3 | 10149.540877 | 22495.688053 | 23867.482184 | 0 |
| 9 | idle | react_body | ALL | 6 | 15302.065811 | 21782.502480 | 23276.965026 | 0 |
| 10 | boxing_cross | boxing_lead_hook | ALL | 1 | 17703.883775 | 17703.883775 | 17703.883775 | 0 |
| 11 | idle | boxing_cross | ALL | 2 | 14903.088289 | 15854.432753 | 15960.137693 | 0 |
| 12 | boxing_lead_hook | idle | ALL | 1 | 11104.556297 | 11104.556297 | 11104.556297 | 0 |
| 13 | slip | idle | ALL | 1 | 10430.049482 | 10430.049482 | 10430.049482 | 0 |
| 14 | boxing_jab_body | idle | ALL | 3 | 4148.830970 | 9128.883441 | 9682.222605 | 0 |
| 15 | idle | boxing_jab_body | ALL | 4 | 6011.131412 | 7935.219276 | 8143.231393 | 0 |
| 16 | boxing_rear_hook | idle | ALL | 3 | 5278.499954 | 6762.128082 | 6926.975652 | 0 |
| 17 | idle | react_head | ALL | 1 | 4673.042578 | 4673.042578 | 4673.042578 | 0 |
| 18 | react_head | idle | ALL | 1 | 4333.505535 | 4333.505535 | 4333.505535 | 0 |

Per-bone top ten contributors:

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | boxing_jab | boxing_cross | LeftUpperArm | 2 | 57951.275135 | 94273.959236 | 98309.813025 | 1 |
| 2 | idle | boxing_slip | LeftUpperArm | 3 | 15753.313730 | 89062.763183 | 97208.257567 | 1 |
| 3 | boxing_cross | idle | LeftForeArm | 6 | 7637.946016 | 49367.586476 | 63073.257128 | 1 |
| 4 | idle | boxing_slip | LeftForeArm | 3 | 15895.696240 | 87098.115812 | 95009.495765 | 0 |
| 5 | boxing_jab | boxing_cross | LeftForeArm | 2 | 57224.014026 | 91101.652203 | 94865.834223 | 0 |
| 6 | boxing_cross | idle | LeftUpperArm | 6 | 8637.195296 | 48382.850476 | 61417.642737 | 0 |
| 7 | react_body | idle | LeftUpperArm | 6 | 4895.223402 | 33351.981731 | 42780.516900 | 0 |
| 8 | react_body | idle | LeftForeArm | 6 | 4675.916586 | 29919.010353 | 37772.380879 | 0 |
| 9 | idle | boxing_jab | LeftForeArm | 2 | 25968.718907 | 26980.725668 | 27093.170864 | 0 |
| 10 | idle | slip | LeftUpperArm | 1 | 25549.254040 | 25549.254040 | 25549.254040 | 0 |

<details>
<summary>All remaining pair/bone rows (counts and zero-contribution rows retained)</summary>

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 11 | boxing_jab | boxing_cross | RightUpperArm | 2 | 22402.688217 | 25157.326916 | 25463.397883 | 0 |
| 12 | idle | boxing_jab | LeftUpperArm | 2 | 23634.191080 | 25168.544898 | 25339.028655 | 0 |
| 13 | boxing_slip | boxing_cross | LeftForeArm | 3 | 21009.990145 | 23922.181356 | 24245.758157 | 0 |
| 14 | boxing_slip | boxing_cross | LeftUpperArm | 3 | 21656.464545 | 23912.646171 | 24163.333018 | 0 |
| 15 | idle | boxing_rear_hook | LeftUpperArm | 3 | 10111.644320 | 22491.898398 | 23867.482184 | 0 |
| 16 | idle | react_body | RightForeArm | 6 | 10943.990339 | 20705.267125 | 23276.965026 | 0 |
| 17 | idle | slip | LeftForeArm | 1 | 21493.003330 | 21493.003330 | 21493.003330 | 0 |
| 18 | boxing_jab | boxing_cross | RightForeArm | 2 | 16918.820421 | 20989.246349 | 21441.515896 | 0 |
| 19 | idle | boxing_slip | RightForeArm | 3 | 14749.340987 | 19446.690370 | 19968.618079 | 0 |
| 20 | idle | react_body | RightUpperArm | 6 | 10430.699738 | 18686.760970 | 19569.667731 | 0 |
| 21 | idle | boxing_rear_hook | LeftForeArm | 3 | 10149.540877 | 17987.531921 | 18858.419815 | 0 |
| 22 | boxing_slip | boxing_cross | RightUpperArm | 3 | 16437.914461 | 17915.486036 | 18079.660656 | 0 |
| 23 | idle | react_body | LeftUpperArm | 6 | 13320.078278 | 17558.183913 | 17799.484754 | 0 |
| 24 | boxing_cross | boxing_lead_hook | RightForeArm | 1 | 17703.883775 | 17703.883775 | 17703.883775 | 0 |
| 25 | idle | react_body | LeftForeArm | 6 | 14534.919969 | 16814.649979 | 17299.114841 | 0 |
| 26 | idle | slip | RightUpperArm | 1 | 17227.979631 | 17227.979631 | 17227.979631 | 0 |
| 27 | idle | boxing_jab | RightForeArm | 2 | 15896.972959 | 16442.129053 | 16502.701952 | 0 |
| 28 | idle | boxing_jab | RightUpperArm | 2 | 16032.506617 | 16330.150599 | 16363.222152 | 0 |
| 29 | idle | boxing_cross | RightUpperArm | 2 | 14475.014109 | 15811.625335 | 15960.137693 | 0 |
| 30 | idle | boxing_slip | RightUpperArm | 3 | 13719.496535 | 15108.467751 | 15262.797886 | 0 |
| 31 | react_body | idle | RightForeArm | 6 | 3442.177656 | 13340.465506 | 14570.688623 | 0 |
| 32 | boxing_slip | boxing_cross | RightForeArm | 3 | 13006.844929 | 14260.133944 | 14399.388279 | 0 |
| 33 | idle | boxing_cross | LeftForeArm | 2 | 13862.739979 | 14228.784067 | 14269.455632 | 0 |
| 34 | idle | slip | RightForeArm | 1 | 14111.821747 | 14111.821747 | 14111.821747 | 0 |
| 35 | idle | boxing_cross | LeftUpperArm | 2 | 13631.495399 | 13824.584536 | 13846.038885 | 0 |
| 36 | boxing_cross | boxing_lead_hook | RightUpperArm | 1 | 12855.037954 | 12855.037954 | 12855.037954 | 0 |
| 37 | boxing_cross | boxing_lead_hook | LeftUpperArm | 1 | 11433.460845 | 11433.460845 | 11433.460845 | 0 |
| 38 | boxing_lead_hook | idle | LeftUpperArm | 1 | 11104.556297 | 11104.556297 | 11104.556297 | 0 |
| 39 | boxing_lead_hook | idle | LeftForeArm | 1 | 10482.184572 | 10482.184572 | 10482.184572 | 0 |
| 40 | slip | idle | RightForeArm | 1 | 10430.049482 | 10430.049482 | 10430.049482 | 0 |
| 41 | slip | idle | LeftUpperArm | 1 | 10346.648614 | 10346.648614 | 10346.648614 | 0 |
| 42 | slip | idle | RightUpperArm | 1 | 10300.542649 | 10300.542649 | 10300.542649 | 0 |
| 43 | slip | idle | LeftForeArm | 1 | 10133.355626 | 10133.355626 | 10133.355626 | 0 |
| 44 | idle | boxing_rear_hook | RightForeArm | 3 | 5601.478270 | 9644.368656 | 10093.578699 | 0 |
| 45 | react_body | idle | RightUpperArm | 6 | 3637.640136 | 9472.417329 | 9808.699349 | 0 |
| 46 | boxing_jab_body | idle | RightUpperArm | 3 | 1753.300471 | 8889.330391 | 9682.222605 | 0 |
| 47 | boxing_cross | boxing_lead_hook | LeftForeArm | 1 | 9672.872750 | 9672.872750 | 9672.872750 | 0 |
| 48 | boxing_jab_body | idle | RightForeArm | 3 | 3478.388735 | 8884.207744 | 9484.854301 | 0 |
| 49 | idle | boxing_cross | RightForeArm | 2 | 9072.177752 | 9372.082877 | 9405.405669 | 0 |
| 50 | idle | boxing_rear_hook | RightUpperArm | 3 | 8835.983632 | 9070.852201 | 9096.948708 | 0 |
| 51 | boxing_cross | idle | RightUpperArm | 6 | 5663.957600 | 7996.616266 | 8346.978078 | 0 |
| 52 | idle | boxing_jab_body | LeftUpperArm | 4 | 5239.449104 | 7733.198631 | 8143.231393 | 0 |
| 53 | boxing_cross | idle | RightForeArm | 6 | 5059.109142 | 6849.945317 | 7335.733597 | 0 |
| 54 | idle | boxing_jab_body | LeftForeArm | 4 | 5442.620385 | 6789.827528 | 6996.362641 | 0 |
| 55 | boxing_rear_hook | idle | LeftUpperArm | 3 | 5278.499954 | 6762.128082 | 6926.975652 | 0 |
| 56 | idle | boxing_jab_body | RightUpperArm | 4 | 3784.954937 | 6358.055005 | 6756.483943 | 0 |
| 57 | boxing_rear_hook | idle | LeftForeArm | 3 | 5171.865249 | 5974.767115 | 6063.978433 | 0 |
| 58 | boxing_lead_hook | idle | RightUpperArm | 1 | 6010.713017 | 6010.713017 | 6010.713017 | 0 |
| 59 | boxing_lead_hook | idle | RightForeArm | 1 | 6001.159289 | 6001.159289 | 6001.159289 | 0 |
| 60 | boxing_rear_hook | idle | RightUpperArm | 3 | 4863.972738 | 4871.013365 | 4871.795657 | 0 |
| 61 | boxing_rear_hook | idle | RightForeArm | 3 | 4513.049323 | 4736.614231 | 4761.454777 | 0 |
| 62 | idle | react_head | RightForeArm | 1 | 4673.042578 | 4673.042578 | 4673.042578 | 0 |
| 63 | idle | react_head | LeftUpperArm | 1 | 4632.230674 | 4632.230674 | 4632.230674 | 0 |
| 64 | idle | react_head | LeftForeArm | 1 | 4615.727314 | 4615.727314 | 4615.727314 | 0 |
| 65 | boxing_jab_body | idle | LeftUpperArm | 3 | 2158.272318 | 4349.561849 | 4593.038464 | 0 |
| 66 | idle | react_head | RightUpperArm | 1 | 4587.384997 | 4587.384997 | 4587.384997 | 0 |
| 67 | react_head | idle | RightUpperArm | 1 | 4333.505535 | 4333.505535 | 4333.505535 | 0 |
| 68 | boxing_jab_body | idle | LeftForeArm | 3 | 4130.908333 | 4147.038706 | 4148.830970 | 0 |
| 69 | react_head | idle | RightForeArm | 1 | 3405.789282 | 3405.789282 | 3405.789282 | 0 |
| 70 | idle | boxing_jab_body | RightForeArm | 4 | 2920.562017 | 3281.861672 | 3306.053143 | 0 |
| 71 | react_head | idle | LeftUpperArm | 1 | 1235.842364 | 1235.842364 | 1235.842364 | 0 |
| 72 | react_head | idle | LeftForeArm | 1 | 1164.254032 | 1164.254032 | 1164.254032 | 0 |

</details>

### After, retained C switches ON, breathing ON

`c_on.csv`: JOIN_TOTAL count=49 median=10426.613451 p95=26507.175707 max=84243.079210

Pair aggregates (ALL = original maximum across four bones per join):

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | boxing_jab | boxing_cross | ALL | 2 | 49694.286401 | 80788.199929 | 84243.079210 | 1 |
| 2 | boxing_cross | idle | ALL | 6 | 8531.410412 | 24608.521351 | 29718.537238 | 1 |
| 3 | react_body | idle | ALL | 6 | 5202.653287 | 23829.985579 | 26928.724760 | 1 |
| 4 | idle | boxing_jab | ALL | 2 | 25649.740438 | 25852.340958 | 25874.852127 | 0 |
| 5 | idle | boxing_slip | ALL | 3 | 14598.236399 | 23051.333694 | 23990.566727 | 0 |
| 6 | idle | boxing_rear_hook | ALL | 3 | 9754.405806 | 21508.528346 | 22814.541961 | 0 |
| 7 | boxing_slip | boxing_cross | ALL | 3 | 19613.678868 | 22157.660211 | 22440.324805 | 0 |
| 8 | idle | react_body | ALL | 6 | 15662.540975 | 20671.655175 | 21826.959617 | 0 |
| 9 | boxing_cross | boxing_lead_hook | ALL | 1 | 17528.193003 | 17528.193003 | 17528.193003 | 0 |
| 10 | idle | boxing_cross | ALL | 2 | 15366.410321 | 16326.042871 | 16432.668710 | 0 |
| 11 | boxing_lead_hook | idle | ALL | 1 | 11104.556297 | 11104.556297 | 11104.556297 | 0 |
| 12 | slip | idle | ALL | 1 | 10426.613451 | 10426.613451 | 10426.613451 | 0 |
| 13 | boxing_jab_body | idle | ALL | 3 | 4148.592563 | 9529.867299 | 10127.786714 | 0 |
| 14 | idle | boxing_jab_body | ALL | 4 | 6075.289806 | 7954.243173 | 8138.315093 | 0 |
| 15 | boxing_rear_hook | idle | ALL | 3 | 5289.403999 | 7212.039972 | 7425.666191 | 0 |
| 16 | idle | slip | ALL | 1 | 7048.950052 | 7048.950052 | 7048.950052 | 0 |
| 17 | react_head | idle | ALL | 1 | 4333.785474 | 4333.785474 | 4333.785474 | 0 |
| 18 | idle | react_head | ALL | 1 | 4169.580778 | 4169.580778 | 4169.580778 | 0 |

Per-bone top ten contributors:

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | boxing_jab | boxing_cross | LeftUpperArm | 2 | 48918.768501 | 80710.648139 | 84243.079210 | 1 |
| 2 | boxing_cross | idle | LeftUpperArm | 6 | 8531.410412 | 24608.521351 | 29718.537238 | 1 |
| 3 | react_body | idle | LeftUpperArm | 6 | 4574.935917 | 22109.787080 | 26928.724760 | 1 |
| 4 | boxing_jab | boxing_cross | LeftForeArm | 2 | 47222.495926 | 76793.459202 | 80079.121788 | 0 |
| 5 | boxing_cross | idle | LeftForeArm | 6 | 7549.135397 | 24327.689600 | 29686.727961 | 0 |
| 6 | idle | boxing_jab | LeftForeArm | 2 | 25649.740438 | 25852.340958 | 25874.852127 | 0 |
| 7 | idle | boxing_slip | LeftUpperArm | 3 | 11844.855490 | 22775.995603 | 23990.566727 | 0 |
| 8 | idle | boxing_jab | LeftUpperArm | 2 | 23226.584988 | 23797.929801 | 23861.412558 | 0 |
| 9 | react_body | idle | LeftForeArm | 6 | 5101.098061 | 19274.645239 | 23360.280897 | 0 |
| 10 | idle | boxing_rear_hook | LeftUpperArm | 3 | 9754.405806 | 21508.528346 | 22814.541961 | 0 |

<details>
<summary>All remaining pair/bone rows (counts and zero-contribution rows retained)</summary>

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 11 | boxing_slip | boxing_cross | LeftUpperArm | 3 | 19613.678868 | 22157.660211 | 22440.324805 | 0 |
| 12 | boxing_slip | boxing_cross | LeftForeArm | 3 | 16092.058020 | 21584.604141 | 22194.887043 | 0 |
| 13 | idle | react_body | RightForeArm | 6 | 10539.887762 | 19812.718934 | 21826.959617 | 0 |
| 14 | boxing_jab | boxing_cross | RightUpperArm | 2 | 17813.240395 | 20214.212518 | 20480.987199 | 0 |
| 15 | idle | boxing_slip | LeftForeArm | 3 | 12108.563683 | 19124.326200 | 19903.855368 | 0 |
| 16 | idle | boxing_slip | RightForeArm | 3 | 13999.322310 | 19166.885537 | 19741.059229 | 0 |
| 17 | idle | react_body | RightUpperArm | 6 | 10134.874442 | 18342.034582 | 19568.686686 | 0 |
| 18 | idle | boxing_rear_hook | LeftForeArm | 3 | 9702.457428 | 17519.489069 | 18388.048140 | 0 |
| 19 | idle | react_body | LeftUpperArm | 6 | 12447.829618 | 16945.623261 | 17893.235255 | 0 |
| 20 | boxing_cross | boxing_lead_hook | RightForeArm | 1 | 17528.193003 | 17528.193003 | 17528.193003 | 0 |
| 21 | idle | react_body | LeftForeArm | 6 | 13938.912227 | 17135.196818 | 17205.741851 | 0 |
| 22 | boxing_slip | boxing_cross | RightUpperArm | 3 | 15736.554222 | 16825.206839 | 16946.168241 | 0 |
| 23 | idle | boxing_cross | RightUpperArm | 2 | 14818.906875 | 16271.292527 | 16432.668710 | 0 |
| 24 | idle | boxing_jab | RightUpperArm | 2 | 16073.444482 | 16391.413841 | 16426.743770 | 0 |
| 25 | idle | boxing_jab | RightForeArm | 2 | 15891.338041 | 15938.454925 | 15943.690135 | 0 |
| 26 | boxing_jab | boxing_cross | RightForeArm | 2 | 11877.404624 | 15174.549353 | 15540.898768 | 0 |
| 27 | idle | boxing_cross | LeftForeArm | 2 | 14636.680927 | 15112.594475 | 15165.473758 | 0 |
| 28 | idle | boxing_slip | RightUpperArm | 3 | 14423.307929 | 14580.743552 | 14598.236399 | 0 |
| 29 | react_body | idle | RightForeArm | 6 | 3080.975392 | 13297.124709 | 14533.768034 | 0 |
| 30 | idle | boxing_cross | LeftUpperArm | 2 | 14232.854435 | 14293.422183 | 14300.151933 | 0 |
| 31 | boxing_slip | boxing_cross | RightForeArm | 3 | 13511.559700 | 14044.963825 | 14104.230950 | 0 |
| 32 | boxing_cross | boxing_lead_hook | RightUpperArm | 1 | 13293.575343 | 13293.575343 | 13293.575343 | 0 |
| 33 | boxing_cross | boxing_lead_hook | LeftUpperArm | 1 | 11355.131155 | 11355.131155 | 11355.131155 | 0 |
| 34 | boxing_lead_hook | idle | LeftUpperArm | 1 | 11104.556297 | 11104.556297 | 11104.556297 | 0 |
| 35 | boxing_lead_hook | idle | LeftForeArm | 1 | 10482.184572 | 10482.184572 | 10482.184572 | 0 |
| 36 | slip | idle | RightForeArm | 1 | 10426.613451 | 10426.613451 | 10426.613451 | 0 |
| 37 | idle | boxing_rear_hook | RightForeArm | 3 | 5611.674129 | 9870.634784 | 10343.852634 | 0 |
| 38 | slip | idle | RightUpperArm | 1 | 10297.135514 | 10297.135514 | 10297.135514 | 0 |
| 39 | boxing_jab_body | idle | RightUpperArm | 3 | 1753.414854 | 9290.349528 | 10127.786714 | 0 |
| 40 | boxing_jab_body | idle | RightForeArm | 3 | 3479.045456 | 9286.742682 | 9932.042374 | 0 |
| 41 | idle | boxing_rear_hook | RightUpperArm | 3 | 9370.420052 | 9661.837467 | 9694.217180 | 0 |
| 42 | idle | boxing_cross | RightForeArm | 2 | 8960.091284 | 9543.766054 | 9608.618807 | 0 |
| 43 | react_body | idle | RightUpperArm | 6 | 3310.897135 | 9100.878776 | 9546.125289 | 0 |
| 44 | slip | idle | LeftForeArm | 1 | 9353.164273 | 9353.164273 | 9353.164273 | 0 |
| 45 | boxing_cross | boxing_lead_hook | LeftForeArm | 1 | 9299.552693 | 9299.552693 | 9299.552693 | 0 |
| 46 | slip | idle | LeftUpperArm | 1 | 8497.655403 | 8497.655403 | 8497.655403 | 0 |
| 47 | idle | boxing_jab_body | LeftUpperArm | 4 | 5165.650056 | 7706.999545 | 8138.315093 | 0 |
| 48 | boxing_rear_hook | idle | LeftUpperArm | 3 | 5289.403999 | 7212.039972 | 7425.666191 | 0 |
| 49 | idle | slip | RightForeArm | 1 | 7048.950052 | 7048.950052 | 7048.950052 | 0 |
| 50 | idle | boxing_jab_body | LeftForeArm | 4 | 5201.773650 | 6730.559268 | 6993.703141 | 0 |
| 51 | idle | boxing_jab_body | RightUpperArm | 4 | 3776.394996 | 6489.652580 | 6911.168956 | 0 |
| 52 | idle | slip | RightUpperArm | 1 | 6622.205533 | 6622.205533 | 6622.205533 | 0 |
| 53 | idle | slip | LeftForeArm | 1 | 6408.668129 | 6408.668129 | 6408.668129 | 0 |
| 54 | boxing_cross | idle | RightForeArm | 6 | 4760.460778 | 6055.817516 | 6284.603125 | 0 |
| 55 | boxing_lead_hook | idle | RightUpperArm | 1 | 6097.796095 | 6097.796095 | 6097.796095 | 0 |
| 56 | boxing_lead_hook | idle | RightForeArm | 1 | 6001.159289 | 6001.159289 | 6001.159289 | 0 |
| 57 | boxing_cross | idle | RightUpperArm | 6 | 5409.429272 | 5882.927041 | 5892.284377 | 0 |
| 58 | idle | slip | LeftUpperArm | 1 | 5759.664503 | 5759.664503 | 5759.664503 | 0 |
| 59 | boxing_rear_hook | idle | LeftForeArm | 3 | 5184.868403 | 5633.107320 | 5682.911644 | 0 |
| 60 | boxing_rear_hook | idle | RightUpperArm | 3 | 4851.306229 | 4877.963582 | 4880.925510 | 0 |
| 61 | boxing_jab_body | idle | LeftUpperArm | 3 | 2159.347781 | 4433.062048 | 4685.696967 | 0 |
| 62 | boxing_rear_hook | idle | RightForeArm | 3 | 4427.530301 | 4515.549104 | 4525.328971 | 0 |
| 63 | react_head | idle | RightUpperArm | 1 | 4333.785474 | 4333.785474 | 4333.785474 | 0 |
| 64 | boxing_jab_body | idle | LeftForeArm | 3 | 4148.592563 | 4236.117840 | 4245.842871 | 0 |
| 65 | idle | react_head | RightForeArm | 1 | 4169.580778 | 4169.580778 | 4169.580778 | 0 |
| 66 | idle | react_head | LeftUpperArm | 1 | 4132.003209 | 4132.003209 | 4132.003209 | 0 |
| 67 | idle | react_head | LeftForeArm | 1 | 4111.204657 | 4111.204657 | 4111.204657 | 0 |
| 68 | idle | react_head | RightUpperArm | 1 | 4088.699878 | 4088.699878 | 4088.699878 | 0 |
| 69 | react_head | idle | RightForeArm | 1 | 3406.076529 | 3406.076529 | 3406.076529 | 0 |
| 70 | idle | boxing_jab_body | RightForeArm | 4 | 2924.900737 | 3351.740920 | 3387.883113 | 0 |
| 71 | react_head | idle | LeftUpperArm | 1 | 1235.260951 | 1235.260951 | 1235.260951 | 0 |
| 72 | react_head | idle | LeftForeArm | 1 | 1164.396625 | 1164.396625 | 1164.396625 | 0 |

</details>

### After, retained C switches ON, breathing OFF

`c_off.csv`: JOIN_TOTAL count=49 median=11167.769244 p95=58927.673431 max=202748.812326

Pair aggregates (ALL = original maximum across four bones per join):

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | idle | boxing_slip | ALL | 3 | 15645.962610 | 184038.527355 | 202748.812326 | 1 |
| 2 | boxing_cross | idle | ALL | 6 | 8537.479527 | 65333.703021 | 83872.805367 | 1 |
| 3 | boxing_jab | boxing_cross | ALL | 2 | 37250.650137 | 57139.795397 | 59349.700426 | 1 |
| 4 | react_body | idle | ALL | 6 | 4463.909794 | 47588.389333 | 58294.632939 | 0 |
| 5 | idle | boxing_jab | ALL | 2 | 25700.486758 | 25836.409259 | 25851.511759 | 0 |
| 6 | boxing_slip | boxing_cross | ALL | 3 | 22939.874983 | 23269.247259 | 23305.844179 | 0 |
| 7 | idle | react_body | ALL | 6 | 14531.204706 | 19449.979926 | 20320.985643 | 0 |
| 8 | boxing_cross | boxing_lead_hook | ALL | 1 | 17526.963391 | 17526.963391 | 17526.963391 | 0 |
| 9 | idle | boxing_rear_hook | ALL | 3 | 11167.769244 | 15431.051966 | 15904.750046 | 0 |
| 10 | idle | boxing_cross | ALL | 2 | 14996.840246 | 15009.613445 | 15011.032689 | 0 |
| 11 | boxing_lead_hook | idle | ALL | 1 | 11837.853074 | 11837.853074 | 11837.853074 | 0 |
| 12 | slip | idle | ALL | 1 | 10450.549926 | 10450.549926 | 10450.549926 | 0 |
| 13 | idle | boxing_jab_body | ALL | 4 | 5634.086020 | 7870.713917 | 8138.320178 | 0 |
| 14 | boxing_rear_hook | idle | ALL | 3 | 5224.577637 | 6956.038518 | 7148.423060 | 0 |
| 15 | idle | slip | ALL | 1 | 6863.161429 | 6863.161429 | 6863.161429 | 0 |
| 16 | boxing_jab_body | idle | ALL | 3 | 4115.787461 | 6111.131086 | 6332.835933 | 0 |
| 17 | react_head | idle | ALL | 1 | 5132.790683 | 5132.790683 | 5132.790683 | 0 |
| 18 | idle | react_head | ALL | 1 | 3849.751458 | 3849.751458 | 3849.751458 | 0 |

Per-bone top ten contributors:

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | idle | boxing_slip | LeftUpperArm | 3 | 12248.839576 | 183698.815051 | 202748.812326 | 1 |
| 2 | boxing_cross | idle | LeftUpperArm | 6 | 8537.479527 | 65333.703021 | 83872.805367 | 1 |
| 3 | boxing_jab | boxing_cross | LeftUpperArm | 2 | 36473.828488 | 57062.113232 | 59349.700426 | 1 |
| 4 | idle | boxing_slip | LeftForeArm | 3 | 12381.860760 | 183659.657029 | 202690.523281 | 0 |
| 5 | boxing_cross | idle | LeftForeArm | 6 | 7466.398987 | 64449.317295 | 83106.897683 | 0 |
| 6 | react_body | idle | LeftForeArm | 6 | 4299.549984 | 45985.433158 | 58294.632939 | 0 |
| 7 | boxing_jab | boxing_cross | LeftForeArm | 2 | 34634.761683 | 52873.963586 | 54900.541576 | 0 |
| 8 | react_body | idle | LeftUpperArm | 6 | 4422.631367 | 43495.958164 | 54861.680428 | 0 |
| 9 | idle | boxing_jab | LeftForeArm | 2 | 25700.486758 | 25836.409259 | 25851.511759 | 0 |
| 10 | idle | boxing_jab | LeftUpperArm | 2 | 23233.239419 | 23967.470936 | 24049.052216 | 0 |

<details>
<summary>All remaining pair/bone rows (counts and zero-contribution rows retained)</summary>

| Rank | From | To | Bone | Count | Median | p95 | Max | Global-p95 contribution |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 11 | boxing_slip | boxing_cross | LeftUpperArm | 3 | 22939.874983 | 23269.247259 | 23305.844179 | 0 |
| 12 | boxing_slip | boxing_cross | LeftForeArm | 3 | 21756.064562 | 22892.566205 | 23018.844165 | 0 |
| 13 | idle | boxing_slip | RightForeArm | 3 | 13857.659354 | 20442.798951 | 21174.481128 | 0 |
| 14 | boxing_jab | boxing_cross | RightUpperArm | 2 | 17996.148846 | 20556.242942 | 20840.697842 | 0 |
| 15 | idle | react_body | RightForeArm | 6 | 10227.950048 | 18638.682209 | 20320.985643 | 0 |
| 16 | idle | react_body | RightUpperArm | 6 | 11142.217165 | 17236.290034 | 18087.537074 | 0 |
| 17 | boxing_cross | boxing_lead_hook | RightForeArm | 1 | 17526.963391 | 17526.963391 | 17526.963391 | 0 |
| 18 | idle | boxing_jab | RightUpperArm | 2 | 16824.335873 | 16940.283660 | 16953.166747 | 0 |
| 19 | boxing_slip | boxing_cross | RightUpperArm | 3 | 15755.377884 | 16827.093640 | 16946.173168 | 0 |
| 20 | idle | react_body | LeftForeArm | 6 | 12832.778211 | 16675.148269 | 16836.962774 | 0 |
| 21 | idle | react_body | LeftUpperArm | 6 | 11347.700034 | 15868.907667 | 16737.364300 | 0 |
| 22 | idle | boxing_jab | RightForeArm | 2 | 16323.619797 | 16438.415364 | 16451.170428 | 0 |
| 23 | idle | boxing_rear_hook | LeftForeArm | 3 | 9541.802806 | 15268.455322 | 15904.750046 | 0 |
| 24 | boxing_jab | boxing_cross | RightForeArm | 2 | 12011.734384 | 15425.909344 | 15805.262117 | 0 |
| 25 | idle | boxing_slip | RightUpperArm | 3 | 13482.628040 | 15429.629153 | 15645.962610 | 0 |
| 26 | react_body | idle | RightForeArm | 6 | 3017.017091 | 13793.108516 | 15469.658516 | 0 |
| 27 | idle | boxing_cross | RightUpperArm | 2 | 14996.840246 | 15009.613445 | 15011.032689 | 0 |
| 28 | idle | boxing_cross | LeftForeArm | 2 | 14919.051245 | 14944.497798 | 14947.325192 | 0 |
| 29 | idle | boxing_rear_hook | LeftUpperArm | 3 | 11167.769244 | 14178.760686 | 14513.315290 | 0 |
| 30 | idle | boxing_cross | LeftUpperArm | 2 | 14454.067541 | 14480.414851 | 14483.342330 | 0 |
| 31 | boxing_slip | boxing_cross | RightForeArm | 3 | 13473.366458 | 14041.142687 | 14104.228935 | 0 |
| 32 | boxing_cross | boxing_lead_hook | RightUpperArm | 1 | 13291.369149 | 13291.369149 | 13291.369149 | 0 |
| 33 | boxing_lead_hook | idle | LeftForeArm | 1 | 11837.853074 | 11837.853074 | 11837.853074 | 0 |
| 34 | boxing_cross | boxing_lead_hook | LeftUpperArm | 1 | 11354.756051 | 11354.756051 | 11354.756051 | 0 |
| 35 | boxing_lead_hook | idle | LeftUpperArm | 1 | 10573.151709 | 10573.151709 | 10573.151709 | 0 |
| 36 | slip | idle | RightUpperArm | 1 | 10450.549926 | 10450.549926 | 10450.549926 | 0 |
| 37 | slip | idle | RightForeArm | 1 | 10450.526520 | 10450.526520 | 10450.526520 | 0 |
| 38 | slip | idle | LeftForeArm | 1 | 9753.027944 | 9753.027944 | 9753.027944 | 0 |
| 39 | boxing_cross | boxing_lead_hook | LeftForeArm | 1 | 9299.552693 | 9299.552693 | 9299.552693 | 0 |
| 40 | react_body | idle | RightUpperArm | 6 | 3236.619853 | 8975.012742 | 9104.814158 | 0 |
| 41 | slip | idle | LeftUpperArm | 1 | 8939.712719 | 8939.712719 | 8939.712719 | 0 |
| 42 | idle | boxing_rear_hook | RightUpperArm | 3 | 7966.986701 | 8533.277605 | 8596.198816 | 0 |
| 43 | idle | boxing_cross | RightForeArm | 2 | 8333.100610 | 8352.133823 | 8354.248624 | 0 |
| 44 | boxing_cross | idle | RightUpperArm | 6 | 5522.297229 | 7727.135469 | 8229.529320 | 0 |
| 45 | idle | boxing_jab_body | LeftUpperArm | 4 | 5039.384976 | 7692.303604 | 8138.320178 | 0 |
| 46 | idle | boxing_rear_hook | RightForeArm | 3 | 6408.379034 | 7822.060135 | 7979.135813 | 0 |
| 47 | boxing_rear_hook | idle | LeftUpperArm | 3 | 5224.577637 | 6956.038518 | 7148.423060 | 0 |
| 48 | idle | boxing_jab_body | LeftForeArm | 4 | 4953.145857 | 6695.567482 | 6993.713226 | 0 |
| 49 | idle | slip | RightForeArm | 1 | 6863.161429 | 6863.161429 | 6863.161429 | 0 |
| 50 | idle | slip | RightUpperArm | 1 | 6661.151993 | 6661.151993 | 6661.151993 | 0 |
| 51 | boxing_cross | idle | RightForeArm | 6 | 5248.780085 | 6272.884067 | 6439.536815 | 0 |
| 52 | idle | boxing_jab_body | RightUpperArm | 4 | 2804.565922 | 6016.295914 | 6354.278441 | 0 |
| 53 | boxing_jab_body | idle | RightUpperArm | 3 | 1973.931008 | 5896.945440 | 6332.835933 | 0 |
| 54 | boxing_jab_body | idle | RightForeArm | 3 | 3279.773655 | 5998.841596 | 6300.960256 | 0 |
| 55 | boxing_rear_hook | idle | LeftForeArm | 3 | 5140.551904 | 6070.683962 | 6174.031969 | 0 |
| 56 | boxing_lead_hook | idle | RightForeArm | 1 | 5857.693496 | 5857.693496 | 5857.693496 | 0 |
| 57 | boxing_jab_body | idle | LeftUpperArm | 3 | 2029.743094 | 5465.698727 | 5847.471575 | 0 |
| 58 | idle | slip | LeftForeArm | 1 | 5638.650709 | 5638.650709 | 5638.650709 | 0 |
| 59 | idle | slip | LeftUpperArm | 1 | 5619.318900 | 5619.318900 | 5619.318900 | 0 |
| 60 | idle | boxing_jab_body | RightForeArm | 4 | 2552.983834 | 4987.256453 | 5312.018404 | 0 |
| 61 | boxing_rear_hook | idle | RightUpperArm | 3 | 4406.519947 | 5073.487923 | 5147.595476 | 0 |
| 62 | boxing_jab_body | idle | LeftForeArm | 3 | 4115.787461 | 5040.844287 | 5143.628378 | 0 |
| 63 | react_head | idle | RightUpperArm | 1 | 5132.790683 | 5132.790683 | 5132.790683 | 0 |
| 64 | boxing_lead_hook | idle | RightUpperArm | 1 | 4948.100025 | 4948.100025 | 4948.100025 | 0 |
| 65 | boxing_rear_hook | idle | RightForeArm | 3 | 3988.708328 | 4603.020937 | 4671.277894 | 0 |
| 66 | react_head | idle | RightForeArm | 1 | 4208.410052 | 4208.410052 | 4208.410052 | 0 |
| 67 | idle | react_head | RightUpperArm | 1 | 3849.751458 | 3849.751458 | 3849.751458 | 0 |
| 68 | idle | react_head | RightForeArm | 1 | 3849.739095 | 3849.739095 | 3849.739095 | 0 |
| 69 | idle | react_head | LeftForeArm | 1 | 3849.738549 | 3849.738549 | 3849.738549 | 0 |
| 70 | idle | react_head | LeftUpperArm | 1 | 3849.729666 | 3849.729666 | 3849.729666 | 0 |
| 71 | react_head | idle | LeftUpperArm | 1 | 1254.633076 | 1254.633076 | 1254.633076 | 0 |
| 72 | react_head | idle | LeftForeArm | 1 | 1220.853127 | 1220.853127 | 1220.853127 | 0 |

</details>

## Switches OFF: final-code CSV identity to current master

Both controls were freshly recorded from master's player/screen, then re-recorded from final task code. CSV rows 1..900 are byte-identical, including camera, poses, clip names and framing. SHA-256 printed in full:

- Breathing/camera ON: master `master_on_clean.csv` / final `verified_off_on.csv`
  both `cef8fc5577eac95219eaa1cdcfffc70fa832bb862570a1e44a709ec113edd54c`.
- Breathing/camera OFF: master `master_off.csv` / final `verified_off_off.csv`
  both `f45a100c0379647e89d5b3f5fdaec5b3598b62b50d40c4e7c2e85980c2ac0a23`.

## Gates and delivered evidence

Final parse: `CHECK total=3 fails=0 autoload_refs=0 autoload_warnings=0` (player, screen, focused test). All requested runner groups used `--jobs 2`:

| Group | Summary |
| --- | --- |
| anim_smooth2 | SUITE total=1 fails=0 |
| anim_inert1 | SUITE total=1 fails=0 |
| alive | SUITE total=1 fails=0 |
| camera | SUITE total=3 fails=0 |

No full suite was run. The known SMOOTH1 stage-test R1-R7 failures were not chased or re-run. Pure/interface green results are not a player-facing acceptance claim. The inherited four-half-life specification conflict remains: the exact critical formula leaves 7.0736 deg from 30 deg at 4 half-lives; master's endpoint clamp makes the endpoint identity. The player tail does not silently alter that pure API.

Silent H.264, 1280x720, 30 fps, 900 frames / 30 seconds, video stream only:
- `E:/FightCamp/tmp/anim_smooth2/before2b.mp4`: fresh master, new switches OFF, breathing/camera ON.
- `E:/FightCamp/tmp/anim_smooth2/best2b.mp4`: retained C, new switches ON, breathing/camera ON.

The capture calls `still_framing.save_if_framed` at frames 1, 180, 360, 540, 720 and 900. All twelve stills were opened with the FILE image tool; both men are head to feet. No browser, viewer, Explorer or video player was opened. Every accepted recording has zero SCRIPT/USER errors and zero failed framing frames; ordinary renderer warnings and teardown leaks are not product failures.

All trial CSVs, reports, residual logs, second-difference plot, framed stills, the two source AVIs, gate summaries and temporary capture/reproduction scripts are preserved in `E:/FightCamp/tmp/anim_smooth2/pass2b/`. The failed first master capture had a diagnostic-only null-to-bool error after its CSV sample; it was replaced by `master_on_clean` and is not acceptance evidence. Initial Chocolatey-shim test runs were replaced by the actual GUI Godot 4.7.2 binary headlessly; the final gates above are the real runner results.

Task-specific entry exceptions: merge master rather than rebase, resolve the previously owned pure module/table to master's versions, use the silent GUI executable, two test jobs, branch-only push, no HANDOFF. Generated import/UID files remain unowned and unstaged.

First-pass provenance is retained in git at `ae5a1d2e`: RED fails=3, original ON p95 54,427.376703, OFF p95 83,359.809664, original videos `before.mp4` / `after.mp4`. Those are historical results, not the second-pass controls above. Acceptance remains **OPEN**; stop tuning at the requested three arms.
