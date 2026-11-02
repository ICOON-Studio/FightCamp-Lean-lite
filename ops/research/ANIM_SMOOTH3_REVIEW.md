# ANIM-SMOOTH3 review ? 2026-10-11

**Acceptance remains OPEN.** Both join p95 values pass, but camera/idle/guard controls do not all remain within ?10%. No target was relaxed and no game switch was enabled. Branch `codex/anim-smooth3`, control `c2e338c5`.

## Diagnosis and provenance

The three quoted 98,310 / 97,208 / 63,073 deg/s? witnesses are from SMOOTH2B's `original_on.csv`, not an OFF recording. Current master also enables `ludo_composure` in `FightRealtime.DEMO_SWITCHES`; seed 94400 now produces 44 rather than 49 clip changes. The diagnostic harness explicitly disables that newly enabled engine switch to reproduce the historical schedule. Acceptance controls use pristine current master and its current `as_game` defaults. Neither correction changes the target.

Historical replay: seed 94400, boxing, `as_game`, untuned SMOOTH2 join arm, breathing/camera ON, same 645 drawn frames at 30 Hz. Every experiment disables only the named layer group; the other switches and event schedule stay matched. Guard hold means the late contact/head hold release plus hand-offset smoothing. IK means the shared arm contact solver, direct upper-arm head-stop rotation, and foot lock. Root means root acceleration control and the SMOOTH2 spacing/flare pass. Strike aim is the actual player aim path; there is no separate head look-at layer in this pipeline. Drawn means the FighterFist/FighterWrist SkeletonModifier3Ds. Those modifiers were explicitly disabled on both skeletons.

| Disabled layer | b upper arm f615, jab?cross | a upper arm f635, idle before slip | b forearm f639, cross?idle |
| --- | ---: | ---: | ---: |
| None | 98,309.813 | 97,208.258 | 63,073.257 |
| Breathing/alive | 108,341.280 | 13,101.257 | 9,821.976 |
| Guard hold/hand offset | 29,384.885 | 51,142.193 | 87,226.072 |
| Strike aim | 98,309.813 | 97,208.258 | 63,073.257 |
| IK | 18,287.631 | 164.773 | 3,228.617 |
| Root/spacing | 87,094.696 | 34,639.141 | 22,039.238 |
| Drawn modifiers | 98,309.813 | 97,208.258 | 63,073.257 |

The owner of spikes 2 and 3 is **arm contact IK**, with breathing and spacing changing its contact geometry. Spike 2 is not the idle?slip switch: f635 is still idle and has no active inertial residual. Its acceleration is 191.445 after animation sampling, 192.004 after body/inertia, 70,375.520 after the overlap arm push, 115,741.760 after late stop/hold, and 97,208.258 after hand-offset smoothing. Spike 3 is 18.658 after animation sampling, 24.812 after body, 3,228.617 after inertia, 105,263.372 after overlap, 127,473.016 after late contact, and 63,073.257 after hand-offset smoothing. A second contact writer can undo the improvement of an earlier one; a per-call limit is insufficient.

Source-only FK measurements use the player's retargeted clip tracks and skeleton rest hierarchy, with no joins, root motion, procedural layers or modifiers. One full authored clip is sampled at 30 Hz, without inventing loop joins. The floating-point length produced an extra near-duplicate endpoint at 2.400000095 s; that nonuniform sample is excluded from the 30 Hz source metrics and retained in `source.raw.csv`:

| Clip | Left upper arm max | Right upper arm max | Left forearm max | Right forearm max |
| --- | ---: | ---: | ---: | ---: |
| Idle, 2.4 s | 28.921 | 28.894 | 0.111 | 0.111 |
| Boxing cross, 0.833333 s | 29,375.195 | 77,076.787 | 7,821.955 | 7,821.955 |

The source cross has a separate right-upper-arm peak at 0.333333 s; this is not evidence that it owns the two historical left-arm witnesses.

## Change

`smooth3` is a single player review switch, default false, with no game/room default enablement. Legacy `FightInertialize.capture`, `offset_at`, `apply` and `rule` remain unchanged. The new finite Hermite residual decays position, velocity and acceleration to zero at exit, uses the sampled clock without the old forced midpoint endpoint, and bounds residual sign/magnitude. The existing C arm already has a four-frame floor; SMOOTH3 also supplies that floor when measured independently on a shorter arm. A zero-velocity 11.6? residual removes at most 39.6484% in any 30 Hz sample. Opposing velocity is retained within the monotone bound; velocity away from zero is constrained rather than allowed to overshoot the residual. Hips keep the critical translation decay with the finite full-duration envelope.

At the actual contact-IK source, all upper-arm and forearm solves share an eight-degree budget per bone per presentation frame, including late contact/head/guard solves. The direct shoulder head-stop shares the same budget. Wrist orientation uses the chain actually applied, and returned reach shortfall is measured from the constrained wrist rather than falsely reporting the unconstrained solver's reach. Clip clocks, fight RNG, schedules, assets and transition table are unchanged. Contact correction can be incomplete under this review budget; no collision-clearance acceptance is inferred.

`review_layer_off` is an empty-by-default diagnostic selector retained to reproduce the bisection, not a game setting. All diagnostic and capture scripts live outside tracked source in the evidence bundle. No HANDOFF edit.

## Matched acceptance measurements

Protocol: seed 94400, boxing, bare `as_game`, 900 drawn frames at 30 Hz, current-master composure defaults, signed shortest-arc second difference, unchanged ?2-frame join window, unchanged `Tools/smooth_metrics.py`. Breathing/camera are matched ON/ON and OFF/OFF. The candidate uses SMOOTH2 C plus `smooth3`; both SMOOTH2 switches are ON only for the candidate. Controls were recorded after temporarily restoring both owned scripts from pristine `HEAD`; the candidate files were then restored.

| Arm | Breathing | Median deg/s? | p95 achieved deg/s? | p95 wanted | Max deg/s? | Join result |
| --- | --- | ---: | ---: | --- | ---: | --- |
| Master, review switches OFF | ON | 12,704.626561 | 30,890.279427 | < 34,667 | 50,944.298047 | PASS |
| Master, review switches OFF | OFF | 13,052.516533 | 29,922.232710 | < 34,667 | 59,310.355531 | PASS |
| SMOOTH3, review switches ON | ON | 14,461.726410 | 27,139.652092 | < 34,667 | 28,404.916636 | PASS |
| SMOOTH3, review switches ON | OFF | 14,893.917942 | 26,894.466021 | < 34,667 | 36,973.050650 | PASS |

All four takes have 44 clip changes and zero failed framing frames. Join p95 improves by 12.14% ON and 10.12% OFF; this is not overall acceptance.

| Control metric | Master ON | Candidate ON | Master OFF | Candidate OFF | Wanted / verdict |
| --- | ---: | ---: | ---: | ---: | --- |
| Camera acceleration sigma, m/s? | 28.647724 | 24.512933 | 20.503984 | 21.660544 | ?10%: ON ?14.43% FAIL; OFF +5.64% PASS |
| Camera spike count | 176 | 176 | 236 | 236 | ?10%: PASS both |
| Idle minimum, cm/s | 0.505359 | 0.505359 | 0.000045 | 0.378531 | ?10%: ON PASS; OFF FAIL |
| Idle median, cm/s | 91.353552 | 92.663195 | 92.894089 | 91.751403 | ?10%: +1.43% / ?1.23%, PASS |
| Guard-only minimum, cm/s | 2.966650 | 2.966987 | 0.567319 | 0.637699 | ?10%: ON PASS; OFF +12.41% FAIL |
| Minimum pelvis separation, cm | 53.432511 | 55.231558 | 53.164437 | 54.123173 | Diagnostic; no collision-clearance claim |
| Qualifying foot plants | 0 | 0 | 0 | 0 | UNWITNESSED; NaN drift is not a pass |
| Failed framing frames | 0 | 0 | 0 | 0 | Wanted 0: PASS |

The OFF idle minimum includes reactions: control A RightShoulder f234 (`react_head`) is 0.000045 cm/s; candidate A Spine2 f236 (`react_head`) is 0.378531 cm/s. The guard minimum on A Spine2 f271 remains in idle, 0.567319?0.637699 cm/s. These failures are retained, not replaced by the median or by a different minimum definition. The camera improvement still fails the explicitly two-sided 10% limit.

### Remaining top-three spikes: every owner has a frame witness

Each row is a distinct join's maximum across the four measured arms and its ?2-frame window, not a rare pair's percentile. Values are signed shortest-arc acceleration magnitudes in deg/s?. The actual source/layer/drawn quaternions are in `after_on.csv.layers.csv` and `after_off.csv.layers.csv`.

| Condition | Join / bad frame | Side / bone | Pair label | After animation | After inertia | After overlap | After late contact | Final drawn | Owner |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| ON | 748 / 748 | b RightForeArm | idle?boxing_lead_hook | 2,327.029 | 2,371.811 | 17,446.376 | 28,404.907 | 28,404.917 | Late arm contact IK |
| ON | 476 / 474 | b LeftForeArm | boxing_slip?boxing_cross | 11,216.071 | 11,216.072 | 11,216.072 | 28,192.030 | 28,206.456 | Late arm contact IK |
| ON | 697 / 699 | a LeftUpperArm | boxing_cross?idle | 675.330 | 662.391 | 6,340.119 | 27,233.819 | 27,233.821 | Late arm contact IK |
| OFF | 592 / 592 | a LeftForeArm | idle?react_body | 12,395.023 | 9,415.295 | 28,063.690 | 36,973.073 | 36,973.051 | Late arm contact IK |
| OFF | 476 / 475 | b RightUpperArm | boxing_slip?boxing_cross | 12,138.486 | 12,138.486 | 12,138.486 | 28,292.968 | 28,292.968 | Late arm contact IK |
| OFF | 697 / 699 | a LeftUpperArm | boxing_cross?idle | 671.960 | 659.072 | 6,194.846 | 26,966.275 | 26,966.268 | Late arm contact IK |

ON f474 and OFF f475 precede the labelled f476 slip?cross switch. Neither is attributed to that incoming cross merely because it lies in the join window. All six remaining peaks enter or grow in the late contact solve, after the source and inertialized pose are already sampled. The shared per-frame budget reduces their size but does not ensure correction-velocity continuity across frames. Source cross acceleration is separately measured above and is not the owner of these six maxima.

Historical ON same-frame fix witness, untuned join arm plus SMOOTH3 (645-frame diagnostic, **not** a replacement acceptance take): f615 b upper arm 98,309.813?13,400.349; f635 a upper arm 97,208.258?2,419.367; f639 b forearm 63,073.257?23,014.872 deg/s?. The old f615 clamp is gone: sampled residual f613/f614/f615 is 36.051258 / 24.239283 / 8.762831 degrees with duration 0.133333 s, not a one-frame removal at 0.09 s. The pure 11.6-degree test verifies sign, per-sample removal and zero endpoint slope independently.

### Default-OFF identity

Both final-code OFF recordings are byte-identical to pristine-master controls over frames 1..900:

- Breathing ON: `master_on.csv` = `verified_off_on.csv`, SHA-256 `c5515e564a627ea2218ae5bb2b0474d74cb8733c2d8f0827a92eb3323854fb44`.
- Breathing OFF: `master_off.csv` = `verified_off_off.csv`, SHA-256 `349d6cba530466ecb4a45bb8dc2b6a05565e63eb31e4c2b316223ed182b3c790`.



## Prefab check

The installed Godot 4.7.2 binary exposes `xfade_time` and `xfade_curve` on `AnimationNodeTransition`, and no inertialization property. Its standard crossfade does not replace our velocity/residual capture at the manual, post-clip player boundary. An AnimationTree conversion would also need to preserve the room's committed strike clock, contact/grounding order and drawn modifiers. This task does not claim the suggested built-in inertialization exists or perform that conversion.

## Gates and evidence

Final parse: `CHECK total=3 fails=0 autoload_refs=0 autoload_warnings=0`. The new pure headless test exits 0 under the output-checking runner. Baseline groups passed: anim_smooth 2/0, anim_inert 1/0, alive 1/0, camera 3/0. Final groups: anim_smooth 3/0, anim_inert 1/0, alive 1/0; camera 3/0. Every group uses `--jobs 2`. No full suite.

Silent H.264, video stream only, 1280?720, 30 fps, independently counted 900 frames / 30.0 seconds:

- `E:/FightCamp/tmp/anim_smooth3/before.mp4`: pristine current master, review switches OFF, breathing/camera ON.
- `E:/FightCamp/tmp/anim_smooth3/after.mp4`: candidate, review switches ON, breathing/camera ON.

All capture CSVs, layer traces, metrics, per-pair/per-bone reports, scripts, gate summaries and framed stills are under `E:/FightCamp/tmp/anim_smooth3/`. Capture stills pass only through `still_framing.save_if_framed`; none was opened in a viewer. Numeric framing is verified, human visual review is Claude's next gate. The inherited `JOIN_FRAME` predictions in `after_on.log` describe SMOOTH2 decay and are not SMOOTH3 residual evidence; use its actual layer/drawn CSV and the corrected historical residual trace instead. Accepted captures contain no SCRIPT/USER errors; renderer warnings and teardown leaks remain separate.

Acceptance remains OPEN. No further blend tuning or target change was made after the source attribution and this bounded fix.

Entry exceptions: the operator's explicit branch reset replaces the generic rebase; task-specific branch-only push and no-HANDOFF rules apply. No window was displayed; every graphical run used the existing hidden-desktop launcher with Dummy audio. No browser, image viewer, video player or file-viewing application was opened.
