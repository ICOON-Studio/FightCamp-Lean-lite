# C188 — struck-segment physics experiment, NOT ACCEPTED

Branch: codex/c188-hit-physics. Model: gpt-6-astra, medium.

**Verdict: keep hit_physics OFF.** The experiment produces a visible head yield and restores the animated pose, but the no-worsening contact gate does not pass. The final rendered capsule proxy worsens by **4.250 mm** at a contact window. Neither timing run maintains an absolute 60-fps floor. No claim of accepted visual improvement or exact mesh-penetration clearance is made.

## Delivered

- scripts/FightHitPhysics.gd: PhysicalBoneSimulator3D with exactly UpperChest, Neck, Head; each is spring-anchored to the moving animated pose. This is not a full ragdoll. Only the scored target receives the impulse. Force scales the impulse; reaction_dir maps through the attacker-to-target world axis. Unknown directions refuse an impulse rather than invent one.
- Start stops the prior simulation, starts only this chain, waits a physics tick, applies an offset impulse, holds influence at 1 for 0.15 s, fades for 0.20 s, stops, resets influence to 1. Gravity is zero; isolated layer, zero mask and explicit collision exceptions exclude floor, opponent and self. Per-segment rotation limits and a 3.5 rad/s angular-speed cap bound the response.
- Animation transport prevents the physical bodies lagging behind keyed movement. A following SkeletonModifier preserves both solved shoulder/arm global poses; arms, hips, legs and roots are never simulated. These are per-bone springs rather than a newly authored parent-joint ragdoll.
- Player section and minimal room hooks: default-OFF option, queued at actor scheduling for the recorded impact time, plus the standing paired-impact route. Grappling and knockdowns remain clips. C187 root/hand functions and the C191 contact_stop block were not edited.
- tests/fight_hit_physics_test.gd: 66 checks, zero failures. Real physics and rendered displacement occur; checks cover OFF pose bytes, root/hips, arm preservation, collision isolation, one impulse, invalid input, reset, retrigger/cancel and return sampled at 24 physics frames (0.4 s).
- tools/c188_hit_physics_ab.gd: seed 92012, two real mounted room fighters, fixed 60 Hz, shared standing camera with yaw 65 degrees. Captures post-modifier skeletons and the room's mesh-derived capsule proxy. Generated raw frames/JSON stay local and are reproducible.
- [_captures/watch_loop/c188_hit_physics_ab.mp4](_captures/watch_loop/c188_hit_physics_ab.mp4): **10.000 s, 60 fps, 1920x540, H.264/yuv420p, 4,106,364 bytes**. The exact same first 10 seconds appear side by side, A OFF / B ON. No retiming. Contact-sequence frames extracted from the final MP4 were visually inspected; this is not an operator acceptance verdict.

## Final A/B evidence

The 60-second seed contains 16 landed contacts. Eleven have an engine force/direction suitable for this slice (lead and rear arms, head and torso); five have blank reaction_dir and receive no invented impulse. Raw JSON contains all 16, not only the successful inputs.

Across 3,600 matched frames: **zero differing fighter root transforms**, zero root displacement during the physics phase; maximum hand-position difference **0.000000267 m** (floating-point noise). Thus the visible change is not a root correction or an arm-IK replacement.

| Scored time (s) | Arm | Struck bone | Impulse delay (ms) | Peak bone difference (mm) | Difference 0.4 s after impulse (mm) | Worst capsule increase, contact + 8 frames (mm) |
|---|---|---|---:|---:|---:|---:|
| 1.4 | lead | UpperChest | 16.7 | 15.01 | 0.000 | 0.000 |
| 3.5 | lead | Head | 33.3 | 97.76 | 0.171 | 0.000 |
| 3.6 | lead | Head | 33.3 | 86.90 | 0.000 | 0.000 |
| 8.7 | lead | Head | 16.7 | 25.61 | 0.000 | 0.000 |
| 14.8 | rear | UpperChest | 16.7 | 15.60 | 0.000 | 0.000 |
| 18.2 | rear | UpperChest | 16.7 | 22.34 | 0.000 | 0.000 |
| 21.3 | rear | Head | 16.7 | 42.20 | 0.000 | 0.000 |
| 22.0 | lead | Head | 16.7 | 29.86 | 0.000 | 2.403 |
| 34.7 | lead | UpperChest | 33.3 | 11.50 | 0.000 | 0.000 |
| 55.7 | rear | UpperChest | 33.3 | 13.46 | 0.000 | 0.000 |
| 58.4 | rear | UpperChest | 33.3 | 15.92 | 0.000 | 4.250 |

The 3.5/3.6 s strikes retrigger the same segment; their windows overlap. Head motion is 25.6–97.8 mm including that overlap; chest motion is 11.5–22.3 mm. Head movement on body strikes is negligible with these independent animated-pose anchors, so this does NOT establish coupled whole-chain force transmission.

First eight physics head-velocity projections onto the blow axis, starting at the recorded impulse frame (the first entry precedes physics integration):
- 3.5 s (lead): 0, 0.824, 0.133, -0.196, -0.267, 0.188, 0.093, 0.421 m/s.
- 3.6 s (lead): 0.093, 0.421, -0.171, -0.48, -0.575, -0.547, -0.459, -0.352 m/s.
- 8.7 s (lead): 0, 0.436, 0.069, -0.088, -0.098, -0.116, -0.136, -0.143 m/s.
- 21.3 s (rear): 0, 0.73, 0.133, -0.18, -0.301, -0.309, -0.258, -0.17 m/s.
- 22.0 s (lead): 0, 0.517, 0.094, -0.127, -0.213, -0.219, -0.182, -0.119 m/s.

The first nonzero response follows the blow; the spring reverses while returning. Therefore a strict requirement for positive alignment throughout all eight frames is NOT met. Angular speed is recorded per frame in JSON, capped at 3.5 rad/s; angular-axis alignment is not certified. Root invariance and return are proven, not a complete motion-quality pass.

**Contact limitation:** the harness measures rendered, mesh-derived capsules through the room's existing posed_parts/refused-overlap functions. It does not compute exact triangle-to-triangle mesh penetration. The existing proxy itself worsens (4.250 mm at 58.4 s, 2.403 mm at 22.0 s), which is already sufficient to withhold acceptance. Do not relabel this as an exact mesh test or enable the switch from these results.

## Performance

RX 6800 XT, Vulkan Forward+, 1280x720. Separate no-image-writing runs; first 600 warm-up frames excluded. 3,000 measured frames per arm. Wall time covers the harness's frame advance through rendering; this is instrumented timing, not an uninstrumented shipping benchmark.

| Mode | Room CPU p50/p95 (ms) | Frame wall p50/p95 (ms) | Max frame (ms) | Frames over 16.667 ms |
|---|---:|---:|---:|---:|
| OFF | 2.919/7.303 | 3.54/7.984 | 20.598 | 7/3000 |
| ON | 2.926/6.801 | 3.555/7.493 | 20.533 | 7/3000 |

Both miss the strict no-drop-below-60 floor. These numbers do not establish a physics performance regression, but do not pass the floor. Jolt island counts were not collected.

## Gates

Required --headless --import ran once before execution. Parse gate precedes each changed-script test. The focused contract ran before broad tiers, and both required mutants failed: moving the root, and leaving influence at zero. Both were removed; restored source is green. The final return check was tightened from a longer wait to exactly 24 frames and remains green.

| Run (one --only per invocation) | Result |
|---|---|
| fight_hit_physics_test | SUITE total=1 fails=0; 66 checks |
| root-movement mutant | SUITE total=1 fails=1 |
| influence-zero mutant | SUITE total=1 fails=1 |
| fight_stage | SUITE total=10 fails=1 |
| fight_world | SUITE total=4 fails=0; repeated after final scheduling hook, same result |
| fight_room | SUITE total=4 fails=0 |
| paired_stage | SUITE total=1 fails=0 |
| fight_body_layers | SUITE total=2 fails=0 |
| fight_hit | SUITE total=2 fails=0 |

fight_stage_realism_test is the sole red test: exactly **8** red rules (R1, R2, R3, R4, R5, R5b, R7, R8), matching the supplied ceiling. No full suite was run. Baseline and ON standalone capture processes both report existing ObjectDB cleanup leaks; no script/engine errors remain in the final captures.

## Reproduce

After parsing the owned scripts, run each capture separately through Tools/godot_hidden.ps1:

    powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --fixed-fps 60 --script tools/c188_hit_physics_ab.gd -- mode=off frames=3600 capture
    powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --fixed-fps 60 --script tools/c188_hit_physics_ab.gd -- mode=on frames=3600 capture

For timing, replace capture with perf. JPEGs cover the first 600 frames; measurements.json covers all frames. Encode matching 60-fps sequences as two 960x540 panels, hstack, H.264 CRF 19, yuv420p, 10 s. No generated JPEGs, imports or unrelated shared-worktree changes are staged.

The explicit C188 read/ownership window took precedence over AGENTS.md's general brief/inbox/HANDOFF and visual-law setup. HANDOFF.md, CURRENT_STATUS.md, HANDOFF_ARCHIVE.md and prior digests were not read or edited. Only this new digest is authored. The branch is an experiment for review, not an accepted/default-enabled feature.


## Round 2 - contact constraints and call profiling (2026-09-24)

**Verdict: still NOT ACCEPTED; hit_physics stays OFF.** The two original startup spikes are removed, but the contact-window gate now fails by **6.538 mm** at 14.883 s. No further tuning after the final A/B failure. Round 1 above remains the historical record; the linked MP4 now contains round 2.

### Changes and cause

C191's pair census uses the same posed capsule and pair_depth API. The C188 harness now records every named pair after skeleton modifiers, alongside the original refused-overlap metric. This preserves C188's original room settings and physics/render timing; C191's separate whole-clip experiment was not substituted.

The original +4.250 mm is **A Head / B RightHand**, frame 3505 (58.433 s). OFF has a 1.000 mm gap; round-1 ON penetrates 4.250 mm. The other spike is **A Head / B LeftHand**, frame 1320 (22.017 s). At these frames head positions differ by less than 0.001 mm and rotations match to floating-point precision; the newly queued impulse has not yet integrated. Thus the original startup failure is not evidence of the spring translating into the arm. PhysicalBone outputs a rigid transform and loses keyed bone scale, changing the head capsule's offset/skin. Round 2 restores the keyed scales after the simulator. A non-unit-scale contract and its scale-loss mutant prove that defect separately.

The player passes the room's posed body data and partner to the physics section. Near head/torso capsule pairs supply the existing contact solver's outward normals. The impulse is projected into their free half-spaces both when queued and immediately before its delayed application; incompatible directions are refused to zero. Spring translation and its next-step velocity are also constrained. The module still simulates only the original three bones. Roots and C187 hand/root code are untouched. Idle frames skip physics pose preparation. Startup remains per hit because measured startup is only 8-11 microseconds, far below a missed 16.667 ms frame budget; keeping all bodies alive would not address the measured cause.

### Pair table (signed capsule depth, mm; negative means gap)

Indices are zero-based harness frames. Names are A part / B part. These head pairs have zero overlap allowance, so positive depth is also refused excess.

| Frame / time | Pair | OFF | Round-1 ON | Round-2 ON | Round-2 excess increase |
|---|---|---:|---:|---:|---:|
| 1320 / 22.017 | Head / LeftHand | -0.779 | 2.403 | -1.362 | 0.000 |
| 3505 / 58.433 | Head / RightHand | -1.000 | 4.250 | -10.193 | 0.000 |
| 891 / 14.867 | Head / RightUpperArm-RightLowerArm | 107.974 | 105.785 | 112.134 | 4.161 |
| 892 / 14.883 | Head / RightUpperArm-RightLowerArm | 96.066 | 92.584 | 102.604 | **6.538** |
| 892 / 14.883 | Head / RightLowerArm-RightHand | 73.563 | 70.078 | 80.101 | **6.538** |
| 3507 / 58.467 | Head / RightHand | 115.462 | 114.111 | 116.252 | 0.789 |
| 3520 / 58.683 | Head / LeftHand | 6.111 | 5.533 | 7.957 | 1.846 |

The last row is outside the contact-plus-eight-frame window, included to avoid hiding a later regression. The worst in-window result is 6.538 mm. The translation-only contact planes do not bound the final capsule after angular motion and hierarchy/scale restoration. At frame 892, the rendered head shifts (-1.378, -11.611, -2.513) mm although its orientation matches OFF, while UpperChest rotates. Restoring an upstream global scale before reading a downstream pose in the scale fence can also move that downstream origin. The final rendered witness therefore rejects this approach; an outward impulse alone is insufficient. No claim of mesh-triangle clearance is made.

Across all 3,600 matched frames, serialized root transforms have **zero differences**, physics-phase root delta is **0**, and maximum hand difference is **0.000338 mm**. The same 16 landed events produce 11 impulses; blank reaction directions remain refused. Peak head differences on head strikes are 25.498-93.780 mm; struck-chest peaks are 8.170-22.123 mm. Isolated reactions have zero measured chain-position difference 24 physics frames after impulse and influence reset to 1. The 3.5 s strike is retriggered at 3.6 s: at its earlier 24-frame sample, the later reaction is still fading (2.011 mm, influence 0.167); 24 frames after the retrigger it is restored. This does not upgrade round 1's angular/alignment limitations into a pass.

### Round-2 timing

Serial hidden-window runs, no JPEG writes and no per-pair census. The owned focused-test processes finished before timing began; unrelated pre-existing processes were not stopped. Same 1280x720 renderer and fixed 60 Hz simulation as round 1. These are instrumented wall timings, not a certified isolated GPU benchmark. As before, exclude the first 600 warm-up frames for the main table (3,000 measured per mode).

| Mode | Room CPU p50/p95 (ms) | Frame wall p50/p95 (ms) | Max frame (ms) | Frames >16.667 ms |
|---|---:|---:|---:|---:|
| OFF | 2.954 / 6.926 | 3.594 / 7.644 | 25.754 | 7/3000 |
| ON | 3.017 / 7.290 | 3.700 / 8.066 | 23.192 | 4/3000 |

**Both fail the absolute 60-fps floor.** Including warm-up, OFF max is 46.915 ms (11/3600 over budget), ON max 43.625 ms (9/3600). Startup frames are not silently discarded from the verdict.

ON call profile, milliseconds (inclusive timers; percentile/max values per call are not additive):

| Call | p50 | p95 | Max |
|---|---:|---:|---:|
| _correct_refused_overlap | 0.729 | 4.926 | **19.030** |
| _place_bodies | 0.755 | 1.203 | 5.205 |
| _sample_refused_overlap_render | 0.721 | 1.170 | 3.419 |
| _solve_contacts | 0.302 | 0.489 | 0.658 |
| _advance_bodies | 0.151 | 0.233 | 0.927 |
| _pump_to | 0.003 | 0.229 | 0.904 |
| _aim_strikes | 0.004 | 0.012 | 0.062 |
| _finish_root_frame | 0.003 | 0.005 | 0.012 |
| _contest_clamp_limbs | 0.003 | 0.005 | 0.010 |
| hit contact_planes (504 nonzero samples, entire run) | 0.137 | 0.230 | 0.270 |
| hit prepare_frame (504 nonzero samples) | 0.006 | 0.010 | 0.024 |
| physical_bones_start_simulation (11 hits) | 0.008 | 0.015 | **0.015** |
| physical_bones_stop_simulation (21 nonzero samples) | 0.007 | 0.011 | 0.012 |

The original instrumented round-1 replay measured startup at 8-11 microseconds; final round 2 peaks at 15 microseconds. At the worst warmed ON frame, **2775**, wall time is 23.192 ms and room CPU is 21.839 ms; _correct_refused_overlap alone takes **19.030 ms**, _place_bodies 0.963 ms, refused-overlap sampling 0.777 ms, and contact solving 0.354 ms. Both physics profile dictionaries are empty that frame (no hit work). The other three over-budget ON frames likewise have no hit work, and overlap correction takes 16.332-17.599 ms. The sampled engine physics monitor peaks at 0.382 ms, but it is a coarse monitor rather than per-call physics attribution. The evidence points to the existing room overlap-correction path, not simulator start/stop. That path was not changed: this round stops with the measured failure.

### Round-2 gates and artifact

Parse gate passed on all five changed .gd files before tests. fight_hit_physics_test passes **93 checks**. Mutants allowing root movement, leaving influence zero, removing scale restoration, and allowing inward direction each produce SUITE total=1 fails=1; restored source produces SUITE total=1 fails=0. The scale assertion runs during the physical response, not just after cancellation.

| Run (one --only per invocation) | Result |
|---|---|
| fight_hit_physics_test | SUITE total=1 fails=0; 93 checks |
| each of four mutants | SUITE total=1 fails=1 |
| fight_stage | SUITE total=10 fails=1; realism TOTAL=13 fails=8, at the supplied ceiling |
| fight_world | SUITE total=4 fails=0 |
| fight_room | SUITE total=4 fails=0 |
| paired_stage | SUITE total=1 fails=0 |
| fight_body_layers | SUITE total=2 fails=0 |
| fight_hit | SUITE total=2 fails=0 |

No full suite. The existing import cache from round 1 was reused. Sandbox test runs print the host root-certificate-store warning; the classifier does not count that environmental warning as a test failure.

The new MP4 is **10.000 s, 60 fps, 1920x540, H.264/yuv420p, 4,104,159 bytes**. Same seed/camera and first 600 frames side by side, no retiming. Contact sequence frames 210, 218, 228 and 530 were extracted from the encoded MP4 and visually inspected. There is visible head displacement, but this is not an acceptance verdict.

Reproduce each capture separately through Tools/godot_hidden.ps1 using the round-1 command with `mode=off` or `mode=on`, `frames=3600 census capture suffix=_r2`. For serial timing use `frames=3600 perf suffix=_r2_perf` without census or capture. The harness profiles room calls through a local subclass; the shipping room changes only the existing C188 call arguments. Raw per-pair JSON and JPEGs are local, not staged. Existing capture cleanup leaks persist.

The current explicit read window took precedence over generic sync/brief/inbox, memory, visual-law and HANDOFF setup. No HANDOFF edit or unrelated import changes are included. This remains a failed experiment for Claude's review, default OFF.
