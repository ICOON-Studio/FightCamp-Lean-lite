# MH3 - MetaHuman walk polish, S152

Branch `codex/mh3-walk`; control master `e8d454af`. Operator: "the metahuman look better, the walking animation on them needs polishing".

**Verdict: not certified; switch remains OFF.** The MH-only changes improve the measured anatomical scale, fold lifecycle and sole handling, but Kelvin still has 18/22 finding rows against MPFB's 14/22. The planted-slide metrics meet the requested band. The remaining motion findings are retained rather than waived.

## Measurement order and control

Measured Kelvin/03 first, before changes: [step-1 side-by-side table](../docs/previews/mh3/before_table.md), [baseline hashes](../docs/previews/mh3/baseline_sources.json). All 22 palette IDs are covered using the production gate for 13 singles and the production-bound sequence gate for nine chains; the production gate's TAKES dictionary does not contain those nine chain IDs. Calibration `reference_jab` is retained in raw reports but excluded from palette counts. Both arms use identical arguments, fixtures and existing instruments.

The task's "MPFB is 0 today" premise did not reproduce at its named master. Kelvin MPFB has 14/22 finding rows (5 singles, all 9 chains), MH has 22/22. These are findings, not engine/runtime failures. The historical S136 certificates remain untouched. No threshold, clip, binding, shared player, control rig, or certificate was changed to obtain a pass.

## MH changes and before/after

Only `MetaHumanRig.gd` changes production behavior; `FightWorldStage.gd` remains byte-identical to master and the switch stays OFF. The table's correction section records achieved values beside the control. [Corrected Kelvin table](../docs/previews/mh3/candidate_table.md).

- Anatomical scale: measure original MH_Skin surface vertices in fighter space, excluding hair, brows and clothing. Kelvin height input 1.8237286 -> 1.7983380 m; mount scale for a 1.90 m fighter 1.0418217 -> 1.0565311. No arbitrary root lift: the measured idle soles were already above the floor.
- Rest-fold lifecycle: fold populated libraries and embedded contact takes, and mark folded animations so re-adding a take cannot fold it twice. Re-add rotation drift 8.53290 degrees -> exact key equality (0 degrees).
- Static corrective/twist skin binds: fold each unanimated helper's rest chain into its own bind pose and bind it to its nearest mapped animated ancestor. Vertices, weights, skeleton, fingers and exporter offsets remain intact. Kelvin's mapped left thigh went from zero collected vertices (fallback capsule radius) to 332 measured vertices. Across idle/jab/advance, all 49,880 skinned vertices differed by less than 0.00000048 m after 867 bind folds. The earlier weight-merge experiment was rejected; the shipped bind-fold method passes the unchanged 0.00001 m preservation bound.
- Final target-sole pass: pose-matched transitions are authored after initial bake/library insertion. Kelvin's finalized jab curve still dipped 2.780 cm in the height/fold-only diagnostic. At first playback, and after later key edits, MH standing takes receive the existing target-skin sole solver again. It changes runtime leg rotations, preserves lifted swing feet and leaves hips alone. Clip assets and the shared solver are unchanged. The diagnostic runtime jab minimum improves from -3.032 to -1.265 cm. Runtime blending still leaves sub-centimeter/approximately 1 cm sole dips; this is not claimed to be perfect floor contact.

Combined Kelvin result: finding rows 22 -> 18 versus MPFB 14. Single maximum foot penetration fell from about 1.59 cm to 0.0202913 cm. Chain skin-floor findings fell from 9 -> 0, but all nine landmark-floor findings remain. No join-discontinuity finding occurred in either bound baseline arm; the old MH2 unbound count is not substituted for this baseline.

Corrected three-seed S139: 5128.3 cm/fighter-minute versus MPFB 5562.4; p95 2.568 m/s versus MPFB 2.643. Both fall within the requested 15%. Baseline MH was 4513.5 and 2.451: the changes improve measured floor handling, not every aggregate metric.

## Remaining foot-contact investigation

The read-only `mh3_chain_floor_probe.gd` measures the unchanged sequence gate's actual frames. All nine Kelvin diagnostic rows match the corrected candidate rows exactly except planner wall-clock `plan_ms`. The lowest landmark is RightToes: -0.0202913 cm on one-two/double-jab/one-two-hook/liver/six-punch; -0.595166 cm on slip-counter; -0.787236 cm on pull-counter; -0.595178 cm on counter-over-jab; -0.0967402 cm on catch-counter. See [raw landmark samples](../docs/previews/mh3/chain_landmarks.json).

The diagnostic was then extended with the unchanged gate's read-only pop detector and run for the 21 affected chains on the other three bodies. All 21 rows match the full run, again excluding only `plan_ms`; together with Kelvin this supplies 30 matching detail rows. Maximum toe penetration is 5.90231 mm (welter_a), 4.80725 mm (welter_b), 7.87236 mm (heavy_c), and 8.71076 mm (heavy_d), all on pull-counter. Pop counts and worst acceleration samples are preserved, including helper bones; none are filtered to change the gate result. [Complete details](../docs/previews/mh3/chain_details.json) and the findings appendix below give each affected row's values. Heavy_d body-cross has zero detected contact runs while `whole=true` and `idle_reached=true`.

A blanket 8 mm root lift was considered and rejected, not implemented. Idle skin soles already measure +8.3298 mm; another 8 mm would increase floating and violate the existing MH2 mounted-feet 1 mm bound. The shared player's `_ground()` returns during whole-strike presentation; it remains unchanged under the task's edit window. The final MH sole bake improves individual takes, but does not fully solve the shown/blended chain poses. Further MH-specific join/foot grounding remains unresolved. No floor tolerance was relaxed.

The first-play bake can also add work when a take is first used or edited. Its real-time frame cost has not been benchmarked. The fixed-step review movie establishes rendered behavior, not real-time performance.

## Full MH measurement and slide repeat

The full unchanged-source rerun measured all 88 MH palette rows with zero missing rows: 59 have findings. By body: generator_welter_a 13/22, generator_welter_b 13/22, Kelvin generator_heavy_c 18/22, generator_heavy_d 15/22. Kelvin's full-run rows reproduce the candidate and read-only landmark diagnostic, excluding only nested planner wall-clock `plan_ms`.

The final S139 run exactly reproduces the corrected candidate (8,183 planted samples). The MPFB rerun exactly reproduces its master baseline (8,115 samples).

| Seed / pooled metric | Final MH | Master MPFB and repeat |
|---|---:|---:|
| 92012 fighter A, cm/min | 9611.9 | 10433.7 |
| 92012 fighter B, cm/min | 6432.3 | 6475.1 |
| 94301 fighter A, cm/min | 0.9 | 25.3 |
| 94301 fighter B, cm/min | 4795.4 | 5475.3 |
| 17701 fighter A, cm/min | 4355.7 | 5300.2 |
| 17701 fighter B, cm/min | 5573.6 | 5665.0 |
| Pooled cm/fighter-minute | 5128.3 | 5562.4 |
| Pooled p95 planted speed, m/s | 2.568 | 2.643 |

MH pooled slide is 7.80% below MPFB; p95 is 2.84% below. Both are inside the literal 85%-115% band. These metrics do not establish that feet are visually stationary; the sampled planted slide remains large in both arms, and the candidate's sample count changed relative to old MH.

## Sealed acceptance comparison

[Final side-by-side table](../docs/previews/mh3/after_table.md); [sealed acceptance receipt](../docs/previews/mh3/acceptance.json).

| Body | MH finding rows / 22 | MPFB finding rows / 22 |
|---|---:|---:|
| generator_welter_a | 13 | 14 |
| generator_welter_b | 13 | 14 |
| generator_heavy_c (Kelvin) | 18 | 14 |
| generator_heavy_d | 15 | 14 |
| Total / 88 | 59 | 56 |

**C223 acceptance FAILS:** MH 59 > MPFB 56, and step-1 Kelvin 18 > 14. **S139 passes** both 15% bounds. **MPFB control passes:** Kelvin's production and sequence rows reproduce master, ignoring only planner wall-clock timing; all three slide seeds, pooled values and sample count reproduce exactly. The shared source/certificate hashes remain unchanged. The four-body MPFB comparison has 88 complete rows, 14 finding rows per body. It is not represented as zero.

All accepted C223/slide/detail engine logs were screened with the repository runner's runtime-error classifier: 51 logs, zero runtime errors. Existing warnings remain visible in the raw logs and receipt, including FBX read warnings and ObjectDB leaks; no warning-free or performance claim is made. Source hashes captured before the full MH run match the final measured sources. Six final report hashes are sealed and checked by the new test.

## Execution safeguards

Every engine launch uses a watchdog check and an exclusive MH3 engine lock; RED waits and an in-flight owned engine is suspended on RED until clear. The requested suite uses `--jobs 2`, with actual engine execution serialized. Renders use `Tools/godot_hidden.ps1`; no viewer is opened on the operator's screens. Parse gate: `CHECK total=5 fails=0 autoload_refs=0 autoload_warnings=0 time=161s`.

Three workers in the initial full MPFB sequence batch exited with code 4294967295 (-1) and no rows. Their cause remains unknown: no script error or Windows crash event established a cause, and one affected worker had no thermal suspension. Successful original workers were retained; only missing rigs were retried as individual chains with the identical gate, arguments and certificates. Interrupted reports, each retry receipt and full successful engine logs remain in the artifact directory. Planner wall-clock `plan_ms` is excluded from deterministic comparisons; pose measurements and findings are not excluded. Earlier pauses and engine-lock waiting make wrapper wall times unsuitable as performance benchmarks.

Task-specific scope overrides generic HANDOFF delivery: HANDOFF.md was not edited. No full repository suite. Generated `.import` files and `audio_exports/` are excluded from commits. The headless import needed to initialize this clean worktree is environment setup, not source work.

## Final gates and mutant

- Final parse: `CHECK total=6 fails=0 autoload_refs=0 autoload_warnings=0 time=33s`.
- Requested focused suite (`--only fight_world_stage,fighter_physique,fight_world_live,mh2,mh3 --jobs 2`): `SUITE total=4 fails=1`. `fight_world_live_test`, `fighter_physique_test` and `mh2_bodies_test` pass. No test filename matched `fight_world_stage`; its mount behavior is exercised by MH2/MH3.
- `mh3_walk_test`: 217 checks, 2 errors: aggregate finding bound (59 > 56) and step-1 Kelvin bound (18 > 14). Slide, control hashes/rows, measured stature, collected limb vertices, production bind, repeat-fold and contact-take checks pass. Corrected stature 1.9000000406 m; re-added clip changed keys = 0.
- Explicit `mh2_bodies_test` with `metahuman_bodies=0` and `=1`: both `MH2_BODIES errors=0`, engine rc=0, zero runtime errors under the runner classifier.
- Old `height_of` mutant: parse passes; test is RED with 217 checks / 4 errors. Besides the two existing motion bounds and stale-source protection, the independent anatomical assertion fails: 1.8735475358 m vs requested 1.90 m (26.45 mm short, 1 mm bound). This is an actual physical regression, not merely a receipt/hash rejection.
- Exact corrected source bytes restored, hash matches the full-run receipt, restored parse passes, restored test returns to 217 checks / 2 known errors. No script/runtime errors in either valid mutant or restored test.

The first mutant harness attempt produced doubled Windows carriage returns and failed parsing. It was restored immediately, preserved as `mutant_harness_crlf_*`, corrected to write normalized bytes, and rerun. That rejected harness attempt is not counted as the mutant proof. [Focused log](../docs/previews/mh3/focused_tests.log), [mutant proof](../docs/previews/mh3/mutant_height.log), [restored test](../docs/previews/mh3/restored_mh3_test.log).

## Video and opened feet sheet

[20-second silent live-room MP4](../docs/previews/mh3/live_room.mp4), [twelve-frame feet/legs sheet](../docs/previews/mh3/steps_sheet.png), [full-frame overview](../docs/previews/mh3/review_sheet.png), [stream/hash receipt](../docs/previews/mh3/video_receipt.json).

Rendered through `Tools/godot_hidden.ps1` and `tools/record_room.gd`, with `as_game metahuman_bodies=1 seed=92012 discipline=boxing shot=broadcast venue_art=1`, fixed 30 fps and 600 frames. Verified H.264 1920x1080, exactly 20.00 seconds, 600 frames, zero audio streams. Recording engine rc=0; the existing runner classifier reports zero runtime errors and 103 warnings. Shutdown resource/leak messages are retained in the log under the runner's existing noise policy, not deleted. No viewer or game window was opened on the operator's screens.

**Opened and visually inspected with the file image tool:** the full-frame overview, the full-resolution 16-second frame, and the final `steps_sheet.png`. The final sheet has twelve samples from 15.000 to 16.466667 seconds, 4 frames apart, cropped to original pixels `(500,400)-(1400,870)`. This is inspection of decoded movie frames, not a claim of continuous playback or a frame-perfect pop audit.

Observed: blue's forward foot flattens around 15.533-15.800 seconds while the rear foot rolls onto its toe with the heel lifted; later the feet spread and turn as the stance widens. Red's feet lift/reposition as the pair separate. The feet continue shifting relative to the canvas markings, and the sequence does not consistently read as a stationary, weight-bearing support foot followed by a clean step. Several poses look toe-supported/lightly floating; the retarget still lacks convincing weight and planted-foot stability. I would not call the walk fixed from this sheet. There is no gross foot/leg disappearance below the canvas in these samples, but the camera and sampling cannot exclude the measured 4.8-8.7 mm chain toe dips. Knees bend and recover across the samples; these four-frame intervals cannot establish the absence of a one-frame knee pop. The numeric gate's pop findings remain failures.

The body appearance remains recognizably MH. This review supports delivering the experiment and evidence for review, **not enabling the switch or certifying motion parity**. Real-time frame cost and operator approval remain unestablished.

## Every remaining MH finding

| Rig / move | Finding | Measured value |
|---|---|---|
| generator_welter_a / boxing_lead_hook | peak_fist_band | 14.5169 m/s; band [8.0, 14.0] |
| generator_welter_a / boxing_rear_hook_body | g147_clipping | LEG: 10.2253 cm, 3 failing events |
| generator_welter_a / boxing_check_hook | contact_slip_cm | 22.8198 cm |
| generator_welter_a / boxing_lead_uppercut | contact_slip_cm | 2.68294 cm |
| generator_welter_a / boxing_rear_uppercut | g147_clipping | ARM: 3.43016 cm, 1 failing events |
| generator_welter_a / boxing_body_hook | peak_fist_band | 14.0549 m/s; band [8.0, 14.0] |
| generator_welter_b / boxing_cross | g147_pin_pop | 2 events |
| generator_welter_b / boxing_rear_hook | g147_clipping | LEG: 5.8752 cm, 2 failing events |
| generator_welter_b / boxing_rear_hook | g147_pin_pop | 10 events |
| generator_welter_b / boxing_rear_hook_body | g147_clipping | LEG: 10.753 cm, 2 failing events |
| generator_welter_b / boxing_check_hook | contact_slip_cm | 22.1842 cm |
| generator_welter_b / boxing_lead_uppercut | g147_clipping | LEG: 2.83079 cm, 1 failing events |
| generator_welter_b / boxing_lead_uppercut | contact_slip_cm | 2.66251 cm |
| generator_heavy_c / boxing_jab | foot_floor_cm | 0.0202913 cm |
| generator_heavy_c / boxing_lead_hook | contact_slip_cm | 27.1593 cm |
| generator_heavy_c / boxing_lead_hook | peak_fist_band | 14.775 m/s; band [8.0, 14.0] |
| generator_heavy_c / boxing_rear_hook | g147_clipping | LEG: 7.37574 cm, 2 failing events |
| generator_heavy_c / boxing_rear_hook | g147_pin_pop | 17 events |
| generator_heavy_c / boxing_rear_hook_body | g147_clipping | ARM: 3.30305 cm, 1 failing events; LEG: 12.4131 cm, 3 failing events |
| generator_heavy_c / boxing_rear_hook_body | g147_pin_pop | 11 events |
| generator_heavy_c / boxing_check_hook | contact_slip_cm | 25.4082 cm |
| generator_heavy_c / boxing_lead_uppercut | g147_clipping | LEG: 5.83181 cm, 1 failing events |
| generator_heavy_c / boxing_rear_uppercut | g147_clipping | ARM: 4.4101 cm, 1 failing events |
| generator_heavy_c / boxing_body_hook | peak_fist_band | 14.8267 m/s; band [8.0, 14.0] |
| generator_heavy_c / boxing_up_jab | foot_floor_cm | 0.0202913 cm |
| generator_heavy_c / boxing_up_jab | peak_fist_band | 9.82726 m/s; band [4.5, 9.5] |
| generator_heavy_d / boxing_cross | g147_pin_pop | 1 events |
| generator_heavy_d / boxing_lead_hook | g147_clipping | LEG: 5.90374 cm, 1 failing events |
| generator_heavy_d / boxing_rear_hook | g147_clipping | LEG: 7.00618 cm, 2 failing events |
| generator_heavy_d / boxing_rear_hook_body | g147_clipping | ARM: 3.19963 cm, 1 failing events; LEG: 15.0582 cm, 3 failing events |
| generator_heavy_d / boxing_check_hook | contact_slip_cm | 23.7993 cm |
| generator_heavy_d / boxing_lead_uppercut | g147_clipping | LEG: 6.16492 cm, 1 failing events |
| generator_heavy_d / boxing_rear_uppercut | g147_clipping | ARM: 4.36969 cm, 1 failing events |
| generator_heavy_d / boxing_cross_body | contact/whole/idle | contact runs=0; whole=True; idle_reached=True |
| generator_welter_a / boxing_one_two | pop | 5 events; worst {'accel_m_s2': 594.925109863281, 'bone': 'lowerarm_out_r', 'frame': 58, 'neighbour_mean_m_s2': 188.911522547404} |
| generator_welter_a / boxing_slip_counter | contact_slip_cm | 3.87443 cm |
| generator_welter_a / boxing_slip_counter | landmark_floor | RightToes: -0.142111 cm, t=0.716667 s, boxing_cross/1 (matching diagnostic) |
| generator_welter_a / boxing_pull_counter | landmark_floor | RightToes: -0.590231 cm, t=0.666667 s, boxing_cross/1 (matching diagnostic) |
| generator_welter_a / boxing_counter_over_jab | contact_slip_cm | 3.87443 cm |
| generator_welter_a / boxing_counter_over_jab | landmark_floor | RightToes: -0.142123 cm, t=0.716667 s, boxing_overhand/1 (matching diagnostic) |
| generator_welter_a / boxing_one_two_hook | part_2_peak_band | 14.1446 m/s; band [8.0, 14.0] |
| generator_welter_a / boxing_one_two_hook | pop | 8 events; worst {'accel_m_s2': 651.510803222656, 'bone': 'lowerarm_out_r', 'frame': 58, 'neighbour_mean_m_s2': 194.35738992691} |
| generator_welter_a / boxing_one_two_hook | g147_pin_pop | {'attacker': [{'accel_m_s2': 533.86962890625, 'bone': 'RightLowerArm', 'frame': 58, 'neighbour_mean_m_s2': 177.848625818888}, {'accel_m_s2': 533.868713378906, 'bone': 'lowerarm_correctiveRoot_r', 'frame': 58, 'neighbour_mean_m_s2': 177.848381519318}], 'receiver': []} |
| generator_welter_a / boxing_liver_combo | part_2_peak_band | 14.2202 m/s; band [8.0, 14.0] |
| generator_welter_a / boxing_liver_combo | pop | 5 events; worst {'accel_m_s2': 594.925109863281, 'bone': 'lowerarm_out_r', 'frame': 58, 'neighbour_mean_m_s2': 188.911522547404} |
| generator_welter_a / boxing_six_punch_combo | part_2_peak_band | 14.1446 m/s; band [8.0, 14.0] |
| generator_welter_a / boxing_six_punch_combo | part_4_peak_band | 14.1226 m/s; band [8.0, 14.0] |
| generator_welter_a / boxing_six_punch_combo | pop | 16 events; worst {'accel_m_s2': 651.510803222656, 'bone': 'lowerarm_out_r', 'frame': 58, 'neighbour_mean_m_s2': 194.35738992691} |
| generator_welter_a / boxing_six_punch_combo | g147_clipping | ARM: 3.00942 cm, 1 failing events |
| generator_welter_a / boxing_six_punch_combo | g147_pin_pop | {'attacker': [{'accel_m_s2': 533.86962890625, 'bone': 'RightLowerArm', 'frame': 58, 'neighbour_mean_m_s2': 177.848625818888}, {'accel_m_s2': 533.868713378906, 'bone': 'lowerarm_correctiveRoot_r', 'frame': 58, 'neighbour_mean_m_s2': 177.848381519318}], 'receiver': []} |
| generator_welter_b / boxing_one_two | pop | 1 events; worst {'accel_m_s2': 515.159545898438, 'bone': 'lowerarm_bck_r', 'frame': 58, 'neighbour_mean_m_s2': 170.687168300152} |
| generator_welter_b / boxing_one_two | g147_pin_pop | {'attacker': [{'accel_m_s2': 640.559204101563, 'bone': 'RightLowerArm', 'frame': 58, 'neighbour_mean_m_s2': 209.80867099762}, {'accel_m_s2': 640.560546875, 'bone': 'lowerarm_correctiveRoot_r', 'frame': 58, 'neighbour_mean_m_s2': 209.809308369954}, {'accel_m_s2': 655.175048828125, 'bone': 'lowerarm_bck_r', 'frame': 58, 'neighbour_mean_m_s2': 207.928078174591}, {'accel_m_s2': 632.561279296875, 'bone': 'lowerarm_in_r', 'frame': 58, 'neighbour_mean_m_s2': 208.629217465719}], 'receiver': []} |
| generator_welter_b / boxing_slip_counter | landmark_floor | RightToes: -0.206925 cm, t=0.716667 s, boxing_cross/1 (matching diagnostic) |
| generator_welter_b / boxing_pull_counter | landmark_floor | RightToes: -0.480725 cm, t=0.633333 s, boxing_cross/1 (matching diagnostic) |
| generator_welter_b / boxing_counter_over_jab | landmark_floor | RightToes: -0.206747 cm, t=0.716667 s, boxing_overhand/1 (matching diagnostic) |
| generator_welter_b / boxing_catch_counter | contact_slip_cm | 12.5691 cm |
| generator_welter_b / boxing_one_two_hook | pop | 5 events; worst {'accel_m_s2': 582.820922851563, 'bone': 'lowerarm_out_r', 'frame': 58, 'neighbour_mean_m_s2': 187.277992129326} |
| generator_welter_b / boxing_one_two_hook | g147_pin_pop | {'attacker': [{'accel_m_s2': 736.173950195313, 'bone': 'RightLowerArm', 'frame': 58, 'neighbour_mean_m_s2': 237.851587613424}, {'accel_m_s2': 736.173278808594, 'bone': 'lowerarm_correctiveRoot_r', 'frame': 58, 'neighbour_mean_m_s2': 237.851293563843}, {'accel_m_s2': 752.66552734375, 'bone': 'lowerarm_out_r', 'frame': 58, 'neighbour_mean_m_s2': 236.991640408834}, {'accel_m_s2': 586.900634765625, 'bone': 'lowerarm_twist_02_r', 'frame': 58, 'neighbour_mean_m_s2': 188.82798910141}], 'receiver': []} |
| generator_welter_b / boxing_liver_combo | part_2_peak_band | 14.2704 m/s; band [8.0, 14.0] |
| generator_welter_b / boxing_liver_combo | pop | 1 events; worst {'accel_m_s2': 515.159545898438, 'bone': 'lowerarm_bck_r', 'frame': 58, 'neighbour_mean_m_s2': 170.687168300152} |
| generator_welter_b / boxing_liver_combo | g147_pin_pop | {'attacker': [{'accel_m_s2': 640.559204101563, 'bone': 'RightLowerArm', 'frame': 58, 'neighbour_mean_m_s2': 209.80867099762}, {'accel_m_s2': 640.560546875, 'bone': 'lowerarm_correctiveRoot_r', 'frame': 58, 'neighbour_mean_m_s2': 209.809308369954}, {'accel_m_s2': 655.175048828125, 'bone': 'lowerarm_bck_r', 'frame': 58, 'neighbour_mean_m_s2': 207.928078174591}, {'accel_m_s2': 632.561279296875, 'bone': 'lowerarm_in_r', 'frame': 58, 'neighbour_mean_m_s2': 208.629217465719}], 'receiver': []} |
| generator_welter_b / boxing_six_punch_combo | pop | 10 events; worst {'accel_m_s2': 582.820922851563, 'bone': 'lowerarm_out_r', 'frame': 58, 'neighbour_mean_m_s2': 187.277992129326} |
| generator_welter_b / boxing_six_punch_combo | g147_pin_pop | {'attacker': [{'accel_m_s2': 736.173950195313, 'bone': 'RightLowerArm', 'frame': 58, 'neighbour_mean_m_s2': 237.851587613424}, {'accel_m_s2': 735.904541015625, 'bone': 'RightLowerArm', 'frame': 249, 'neighbour_mean_m_s2': 237.736368497213}, {'accel_m_s2': 736.173278808594, 'bone': 'lowerarm_correctiveRoot_r', 'frame': 58, 'neighbour_mean_m_s2': 237.851293563843}, {'accel_m_s2': 735.904907226563, 'bone': 'lowerarm_correctiveRoot_r', 'frame': 249, 'neighbour_mean_m_s2': 237.736360549927}], 'receiver': []} |
| generator_heavy_c / boxing_one_two | landmark_floor | RightToes: -0.0202913 cm, t=0.1 s, boxing_jab/0 (matching diagnostic) |
| generator_heavy_c / boxing_double_jab | contact_slip_cm | 14.5869 cm |
| generator_heavy_c / boxing_double_jab | landmark_floor | RightToes: -0.0202913 cm, t=0.1 s, boxing_jab/0 (matching diagnostic) |
| generator_heavy_c / boxing_slip_counter | landmark_floor | RightToes: -0.595166 cm, t=0.716667 s, boxing_cross/1 (matching diagnostic) |
| generator_heavy_c / boxing_pull_counter | landmark_floor | RightToes: -0.787236 cm, t=0.666667 s, boxing_cross/1 (matching diagnostic) |
| generator_heavy_c / boxing_counter_over_jab | landmark_floor | RightToes: -0.595178 cm, t=0.716667 s, boxing_overhand/1 (matching diagnostic) |
| generator_heavy_c / boxing_catch_counter | contact_slip_cm | 13.9563 cm |
| generator_heavy_c / boxing_catch_counter | landmark_floor | RightToes: -0.0967402 cm, t=0.65 s, boxing_jab/1 (matching diagnostic) |
| generator_heavy_c / boxing_one_two_hook | part_2_peak_band | 14.7451 m/s; band [8.0, 14.0] |
| generator_heavy_c / boxing_one_two_hook | landmark_floor | RightToes: -0.0202913 cm, t=0.1 s, boxing_jab/0 (matching diagnostic) |
| generator_heavy_c / boxing_liver_combo | part_2_peak_band | 15.3323 m/s; band [8.0, 14.0] |
| generator_heavy_c / boxing_liver_combo | landmark_floor | RightToes: -0.0202913 cm, t=0.1 s, boxing_jab/0 (matching diagnostic) |
| generator_heavy_c / boxing_six_punch_combo | part_2_peak_band | 14.7451 m/s; band [8.0, 14.0] |
| generator_heavy_c / boxing_six_punch_combo | part_4_peak_band | 14.3957 m/s; band [8.0, 14.0] |
| generator_heavy_c / boxing_six_punch_combo | contact_slip_cm | 26.605 cm |
| generator_heavy_c / boxing_six_punch_combo | landmark_floor | RightToes: -0.0202913 cm, t=0.1 s, boxing_jab/0 (matching diagnostic) |
| generator_heavy_c / boxing_six_punch_combo | g147_clipping | ARM: 4.33627 cm, 1 failing events |
| generator_heavy_d / boxing_one_two | landmark_floor | RightToes: -0.175585 cm, t=0.733333 s, boxing_cross/1 (matching diagnostic) |
| generator_heavy_d / boxing_one_two | g147_pin_pop | {'attacker': [{'accel_m_s2': 576.142517089844, 'bone': 'lowerarm_bck_r', 'frame': 57, 'neighbour_mean_m_s2': 185.94482922554}], 'receiver': []} |
| generator_heavy_d / boxing_double_jab | landmark_floor | RightToes: -0.453176 cm, t=0.733333 s, boxing_jab/1 (matching diagnostic) |
| generator_heavy_d / boxing_pull_counter | skin_floor_cm | 2.22051 cm |
| generator_heavy_d / boxing_pull_counter | landmark_floor | RightToes: -0.871076 cm, t=0.666667 s, boxing_cross/1 (matching diagnostic) |
| generator_heavy_d / boxing_catch_counter | landmark_floor | RightToes: -0.24549 cm, t=0.65 s, boxing_jab/1 (matching diagnostic) |
| generator_heavy_d / boxing_one_two_hook | landmark_floor | RightToes: -0.175585 cm, t=0.733333 s, boxing_cross/1 (matching diagnostic) |
| generator_heavy_d / boxing_one_two_hook | pop | 1 events; worst {'accel_m_s2': 573.89453125, 'bone': 'lowerarm_bck_r', 'frame': 57, 'neighbour_mean_m_s2': 184.556353827318} |
| generator_heavy_d / boxing_one_two_hook | g147_clipping | LEG: 3.79156 cm, 1 failing events |
| generator_heavy_d / boxing_one_two_hook | g147_pin_pop | {'attacker': [{'accel_m_s2': 630.759155273438, 'bone': 'lowerarm_bck_r', 'frame': 57, 'neighbour_mean_m_s2': 202.325877348582}, {'accel_m_s2': 663.261474609375, 'bone': 'lowerarm_out_r', 'frame': 57, 'neighbour_mean_m_s2': 214.933102766673}], 'receiver': []} |
| generator_heavy_d / boxing_liver_combo | part_2_peak_band | 14.3128 m/s; band [8.0, 14.0] |
| generator_heavy_d / boxing_liver_combo | landmark_floor | RightToes: -0.175585 cm, t=0.733333 s, boxing_cross/1 (matching diagnostic) |
| generator_heavy_d / boxing_liver_combo | g147_pin_pop | {'attacker': [{'accel_m_s2': 576.142517089844, 'bone': 'lowerarm_bck_r', 'frame': 57, 'neighbour_mean_m_s2': 185.94482922554}], 'receiver': []} |
| generator_heavy_d / boxing_six_punch_combo | landmark_floor | RightToes: -0.175585 cm, t=0.733333 s, boxing_cross/1 (matching diagnostic) |
| generator_heavy_d / boxing_six_punch_combo | pop | 2 events; worst {'accel_m_s2': 574.107421875, 'bone': 'lowerarm_bck_r', 'frame': 248, 'neighbour_mean_m_s2': 184.57842473189} |
| generator_heavy_d / boxing_six_punch_combo | g147_clipping | ARM: 3.22752 cm, 1 failing events; LEG: 3.86414 cm, 2 failing events |
| generator_heavy_d / boxing_six_punch_combo | g147_pin_pop | {'attacker': [{'accel_m_s2': 630.759155273438, 'bone': 'lowerarm_bck_r', 'frame': 57, 'neighbour_mean_m_s2': 202.325877348582}, {'accel_m_s2': 630.321899414063, 'bone': 'lowerarm_bck_r', 'frame': 248, 'neighbour_mean_m_s2': 202.068546454112}, {'accel_m_s2': 663.261474609375, 'bone': 'lowerarm_out_r', 'frame': 57, 'neighbour_mean_m_s2': 214.933102766673}, {'accel_m_s2': 663.198364257813, 'bone': 'lowerarm_out_r', 'frame': 248, 'neighbour_mean_m_s2': 214.771450042725}], 'receiver': []} |
