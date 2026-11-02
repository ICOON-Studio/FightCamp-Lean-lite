# ANIMFIX2 / S225 - prerequisite gate RED; production unchanged

**BLOCKED, not implemented or visually accepted.** The literal +20-degree
upper-arm direction gate is incompatible with rotating the actual oblique
rest directions by 20 degrees about the prescribed lateral axis. The tested
three-number angular-displacement candidate also fails generator key parity
and the 3 cm catch gate. Production bindings, pose layer, player, mirror,
native wiring, foot bake, source assets and imports are unchanged.

The task explicitly says test (b) must prove the side rule **before touching
the catch recipe**. No thresholds were relaxed to pass it. A scope question
was offered to the operator during the session; absent a revised instruction,
this handoff retains the task's gate and its no-re-solve boundary. Claude needs
to revise the anatomical representation/gate before production conversion.

## Baseline and delivery

- Branch `codex/animfix2`, never master. Clean intake, fetch/rebase to
  `bfce5f4f` (contains ANIMFIX1); initial red witness pushed as `796f10cc`.
- The worktree was renamed: `.git` points to the existing `worktrees/ANIMFIX1`
  metadata, whose back-pointer correctly names ANIMFIX2. No repair was needed.
  Git writes and hidden Godot runs needed sandbox escalation, which succeeded.
- Toolkit at both requested locations, task whole, CLAUDE sections 4-7,
  visual-gate skill, design rules, traps, audit sections 1/8, verdict section 4,
  ANIMFIX1 digest and named solve-tool path were read. Brief/inbox completed;
  unrelated historical messages did not replace this explicit assignment.
- The isolated prototype and failing contracts were pushed as `f76a4a8e`.
  `tools/animfix2_candidate_layer.gd` is diagnostic only. No production caller
  references it. The legacy arm of the test calls the actual production layer.
- General rules set aside: task branch overrides CLAUDE's master-push rule;
  task/launch instruction overrides generic console/headless launch advice;
  explicit serial-worker allowance overrides CLAUDE's older no-serial rule.
  Research/evidence delivery writes no HANDOFF block; Claude owns status there.

## Red first, on unchanged production

The catch uses its real RamsterZ `H2H_Idle.FBX` / `T_pose.fbx` binding, not the
different active guard source. Same retarget corrections, 30 Hz keys and warp
as the player, then the production layer. Intermediate rests are decoded on
a duplicate for FK readback; no skeleton correction is written into clips.
Positions are skeleton-space metres relative to Head, before foot bake.
The common generator GLB is the coordinate-conversion reference; this is not
a claim of four separate scaled generator fixtures.

| Body | Old catch wrist minus Head (x,y,z), m | Distance from generator, m |
|---|---|---:|
| Generator | (0.000764, -0.037860, 0.179580) | reference |
| MH05 | (-0.062887, -0.362765, -0.014183) | **0.383612** |
| MH08 | (-0.038124, -0.398549, -0.003076) | **0.406167** |
| MH02 | (-0.042352, -0.381533, -0.003465) | **0.391759** |
| MH09 | (-0.036420, -0.428007, 0.010217) | **0.426943** |

At 0.275 s the raw generator measures 17.96 cm forward, 0.08 cm lateral,
3.79 cm below Head. This is near the historical 17.4 cm forward target; the
0.56 cm difference is reported, not fitted away. The first test
was RED before any candidate existed: `SUITE total=1 fails=1`, five failures
(four catch distances plus MH08 idle wrist). Exact output:
[red_details.txt](../docs/previews/animfix2/red_details.txt).

## Why the literal side-axis gate cannot pass on these rest directions

The independent oracle applies `Basis(Vector3.RIGHT, 20 degrees)` directly to
each measured skeleton-space rest direction. The candidate's rest-conjugated
offset agrees with this oracle within 0.00001 degrees on both sides. But a
direction with a nonzero component along the rotation axis traces a cone:

`cos(direction_angle) = d.x^2 + (1 - d.x^2) * cos(axis_rotation)`

| Rig | Left direction change | Right direction change | Axis rotation |
|---|---:|---:|---:|
| Generator | 15.039969 deg | 15.039969 deg | 20 deg |
| MH05 | 16.305509 deg | 16.304847 deg | 20 deg |
| MH08 | 15.871891 deg | 15.871879 deg | 20 deg |

The analytic cone equation is printed beside the direct vector measurement.
This failure exists for pure flex, independent of the multi-axis composition
choice, conversion solver, side-sign handling or catch recipe. No extra
rotation was added to force the direction displacement to 20 degrees.

Claude must clarify whether (b) means a signed rotation about the lateral axis
(measured in its perpendicular plane), or a 20-degree great-circle direction
change. Those are different contracts for these rigs. This report does not
silently substitute one for the other.

## Conversion candidate and parity, not an accepted representation

The task does not specify multi-axis composition/interpolation. The final
prototype uses exponential coordinates: the anatomical triple gives components
of one angular displacement on lateral +X, forward +Z, and the measured bone
rest direction. Right-side abduct/twist signs are mirrored once. The offline
tool conjugates the old generator peak quaternion into global-rest space,
takes its rotation vector and solves the three-axis linear system. There is
no head/wrist objective, MH fit, artistic search or new production switch.

All **36 rotation entries across 11 recipes** reproduce their generator peak
rotation (maximum residual below 0.00003 deg). `drop_frac` is untouched. The
tool emits [conversion.json](../docs/previews/animfix2/conversion.json) and the
table below. It intentionally does not overwrite production bindings after
the prerequisite failed; old numbers remain in the JSON and table, rather
than pretending the requested `deg_legacy` migration was completed.

Peak equivalence does not preserve the weighted Euler path. The test compares
every original 30 Hz rotation key in the selected source/warped clips, as well
as the converter's 101-sample weight sweep. At actual clip keys:

| Entry | Max quaternion error | Max segment-direction error |
|---|---:|---:|
| Catch / RightUpperArm | 1.888353 deg | 0.510514 deg |
| Overhand / RightUpperArm | 1.985950 deg | 1.918273 deg |
| Shovel hook / LeftLowerArm | 7.325493 deg | 2.735260 deg |

Seven entries fail the <0.1 deg key criterion; the table is not a claim of
parity on the four independently mounted generator body sizes. The final counterexample
does not prove every possible richer representation impossible. Offline
per-weight anatomical samples could preserve the authored path, but that
requires an explicit representation change rather than merely one triple.

## Per-stage readback and wrist gate

MH08 construction, seed-independent clip readback. Live room below uses seed
930093 / MH08 Miller. Directions are skeleton-space unit vectors:

| Role / time | Stage | Rear upper arm | Rear forearm |
|---|---|---|---|
| Catch / .275 | Retarget | (-.645166,-.677870,.352494) | (.168115,.667435,.725443) |
| Catch / .275 | Production old layer | (-.529685,-.843630,.087877) | (.608704,.061958,.790975) |
| Catch / .275 | Isolated new candidate | (-.131795,-.114690,.984620) | (.388094,.657961,.645345) |
| Lead uppercut / .600 | Retarget | (-.942353,-.330123,.054675) | (.151119,.438113,.886127) |
| Lead uppercut / .600 | Production old layer | (-.886172,-.365010,.285425) | (.608865,-.231161,.758847) |
| Lead uppercut / .600 | Isolated new candidate | (-.669228,-.575918,.469523) | (.613837,.368293,.698258) |

Candidate catch distances from the unchanged generator peak: MH05 **3.043 cm**,
MH08 **5.510 cm**, MH02 **5.369 cm**, MH09 **8.755 cm**. All remain outside the
3 cm gate. The production retarget computes against a silhouette-aligned
virtual rest (`FightClipRetarget.gd:304-310`), whereas the requested layer
conjugates against raw global rest. That is a relevant frame difference for
the next design, not a proven sole explanation for all metric error; proportions
also differ. No per-rig target re-solve was attempted.

Wrist line = LowerArm->Hand versus Hand->MiddleProximal, both as posed segment
directions, not quaternion components:

| Body | Active guard .600, retarget | Catch .275, retarget | Old layer | Candidate |
|---|---:|---:|---:|---:|
| MH05 | 16.8222 deg | 10.0101 deg | 10.0101 deg | 10.0101 deg |
| MH08 | **21.1602 deg** | 12.3038 deg | 12.3037 deg | 12.3038 deg |

**MH08's guard bend is already present before the pose layer.** The first
measured boundary is retarget output: `FightClipRetarget.gd:486` invokes
`RestFixer.pose_frame`; production receives that animation at
`FightStagePlayer.gd:2344-2350`, before layer application at :2370.
The active-guard binding has no pose layer at all. The source versus retarget
split was not isolated, so this report does not assign the cause to either.
The lead uppercut's MH08 rear wrist is likewise already 41.7267 degrees at
retarget and remains so after both layers. **No clamp.** Full readback:
[candidate_details.txt](../docs/previews/animfix2/candidate_details.txt).

## Opened game-camera baseline stills

`animfix2_pose_room.gd` uses the real room/broadcast camera, seed 930093,
MH09 Vance / MH08 Miller. It pauses the simulation at frame 30, seeks the real
production clip at each named time, waits four render frames and saves through
`still_framing.save_if_framed`. All four report `STILL_FRAMING OK`, `err=0`, and
were opened with the file image tool. Controlled playback, not natural strike
selection or proof of actual contact. No movie/fixed-fps mode was used in this
baseline, so no deterministic whole-room before/after pairing is claimed.

Each line follows gap / noses / wrists / feet / briefed defect / bodies:

- [Guard .600](../docs/previews/animfix2/before/guard.png): clear step apart;
  heads face across and slightly down; bent glove lines; wide stance and rolled/
  pointed feet; unchanged baseline guard; MH09 red / MH08 purple.
- [Catch .100](../docs/previews/animfix2/before/catch_between.png): clear step
  apart; both face across; MH08 rear glove lowering, glove lines bent; wide
  uneven stance; catch before hold; MH09 red / MH08 purple.
- [Catch .275](../docs/previews/animfix2/before/catch_hold.png): clear step
  apart; both face opponent; MH08 rear glove low beside chest and partly hidden,
  lead wrist bent; wide stance and raised rear heel; catch glove nowhere near
  face; MH09 red / MH08 purple.
- [Uppercut .600](../docs/previews/animfix2/before/uppercut_dip.png): clear gap,
  no contact; Vance across, Miller down at floor; bent glove lines, rear glove
  partly hidden; MH08 rear leg extends wide with pointed foot; distorted dip
  remains; MH09 red / MH08 purple.

No still establishes sliding or full glove orientation. Posted all four with
these captions via `review_add.py --stage S225` to
`E:/FightCamp/review/2026-10-14_1918_animfix2_red_catch_and_uppercut_baseline`.
Review remains OPEN. Visual-gate skill says **"A visual change is closed by
THE OPERATOR"**; no closure is claimed. No new animation asset
(`clip_status.py new-anims`: 0). No candidate/after stills were substituted for
an implemented production repair.

## Verification and outstanding work

- Parse: all four new/changed diagnostic .gd files pass. Final test refinement
  (actual key times and numeric JSON matching) also passes its parse gate.
- Red baseline: `SUITE total=1 fails=1`, five measured failures.
- Final isolated candidate: `SUITE total=1 fails=1`, 18 measured failures:
  six direction angles, seven key-parity entries, four catch distances, one
  pre-existing idle wrist. No SCRIPT ERROR in the final focused output.
- Named affected subset, one serial run: **`SUITE total=31 fails=3`**.
  The failures are this intentionally red anatomical diagnostic;
  `fight_clip_slice_test` (23 checks, one failure: `boxing_rear_hook` 1.724 s
  versus its <1.2 s assertion, also recorded in ANIMFIX1); and `staff_pose_test`
  (248 checks, 48 seated-palm failures on the four staff models). The latter
  two run unchanged production code, with no dependency on the isolated
  candidate. They were not repaired in this task. All 28 other selected tests
  passed, including the live body-layer, MetaHuman, reset and uppercut checks.
  [Summary](../docs/previews/animfix2/affected_suite.txt),
  [slice output](../docs/previews/animfix2/slice_details.txt),
  [staff output](../docs/previews/animfix2/staff_details.txt).
- Every Godot launch, including Python-runner children, used the temporary
  `E:/FightCamp/tmp/animfix2/hidden_gate.cmd`: watchdog first, then
  `godot_hidden.ps1`, GUI executable, one worker. Watchdog readings included
  GREEN and permitted AMBER (76 C); no launch on RED. No window opened.
- Baseline capture exited 0 with all four framing receipts. Shutdown logged
  ObjectDB/resource/PagedAllocator leak messages; these are disclosed and not
  used as a clean-engine gate. No capture script error was observed.

**Not completed:** production anatomical API/caller migration; the 11 binding
conversions with `deg_legacy`; green (a)/(b)/(c); four mounted generator-body
parity; the one after-change 2-seed x 4-body x 60 s sole gate and side-by-side
foot rows; deterministic before/after stills; Claude/operator visual closure.
There is no after-change sole result to compare because no production change
was admitted. ANIMFIX1's foot rows remain historical evidence, not relabelled
as a new run. No full suite was run.

**Status tracking:** blocker `4bdb1af495ad` is recorded in AgentComms; this
digest must not be treated as a completion marker.

**Claude next:** clarify axis-angle versus direction-angle in (b); specify the
anatomical frame at the silhouette-aligned boundary and whether absolute
Head-relative metre targets or portable joint motion is the desired contract;
authorize a representation that preserves the original weighted curve (or an
offline per-rig bake) before converting bindings. Keep the pre-layer wrist
repair and foot repair assigned separately. Do not merge the expected-red test
as a completed animation fix.

## Offline conversion table

Diagnostic angular coordinates only. `deg_legacy` below retains every original
value. Peak residual is quaternion error; curve error samples 101 weights and
therefore can be slightly larger than the actual-key maxima above. Windows and
full-precision values are in conversion.json. Drop entries were skipped intact.

| Recipe | Bone | deg_legacy | anat flex / abduct / twist | Peak residual deg | Curve error deg |
|---|---|---|---|---:|---:|
| boxing_lead_uppercut | Spine | [25, 0, 0] | 24.999996 / 0.000000 / 0.000000 | 0.0000034 | 0.000009 |
| boxing_lead_uppercut | Spine | [-12, 0, 0] | -12.000000 / 0.000000 / 0.000000 | 0.0000000 | 0.000003 |
| boxing_lead_uppercut | Hips | [0, 25, 0] | -0.000000 / 0.000006 / 25.000002 | 0.0000032 | 0.000005 |
| boxing_lead_uppercut | RightUpperArm | [15, -2, -4] | -19.675581 / 4.669889 / 14.436856 | 0.0000035 | 0.155000 |
| boxing_lead_uppercut | RightLowerArm | [3, 0, 0] | -4.343845 / -3.118908 / 4.426802 | 0.0000042 | 0.000008 |
| boxing_lead_uppercut | RightShoulder | [3, 0, 0] | -16.816128 / 0.826607 / 16.566996 | 0.0000013 | 0.000003 |
| boxing_cross | RightUpperArm | [20, 0, 10] | -27.167757 / -8.604012 / 19.526764 | 0.0000046 | 0.437718 |
| boxing_cross | Spine | [-6.29, 0.06, -4.09] | -6.289464 / -4.118493 / 0.377991 | 0.0000011 | 0.056200 |
| boxing_cross | Spine | [-13.12, -0.13, -3.15] | -13.113140 / -3.178811 / -0.071271 | 0.0000026 | 0.089923 |
| boxing_cross | Spine | [-9.39, -0.34, 1.46] | -9.393776 / 1.441429 / -0.409480 | 0.0000018 | 0.031296 |
| boxing_cross | Spine | [3.79, -0.15, -2.43] | 3.792608 / -2.445466 / 0.252618 | 0.0000009 | 0.020189 |
| boxing_cross | Chest | [-5.27, 0.38, -6.67] | -5.286114 / -6.711174 / -0.847595 | 0.0000016 | 0.077245 |
| boxing_cross | Chest | [-13.42, 1.01, -6.75] | -13.463049 / -6.663574 / -0.699896 | 0.0000004 | 0.204036 |
| boxing_cross | Chest | [-11.98, 0.49, 0.52] | -11.977636 / 0.574756 / 0.621377 | 0.0000017 | 0.017700 |
| boxing_cross | Chest | [-2.27, 0.17, 1.54] | -2.267578 / 1.557878 / 0.414070 | 0.0000007 | 0.007679 |
| boxing_jab | Spine | [0, 0, 5.75] | -0.000000 / 5.800556 / -0.764177 | 0.0000010 | 0.000002 |
| boxing_slip | Spine | [-20, 0, 0] | -20.000004 / 0.000000 / 0.000000 | 0.0000000 | 0.000007 |
| boxing_slip | Chest | [-20, 0, 0] | -20.000006 / 0.000000 / 0.000000 | 0.0000051 | 0.000010 |
| boxing_catch | RightUpperArm | [47.0, 5.0, 15.5] | -63.568291 / -9.515840 / 43.362316 | 0.0000139 | 1.888673 |
| boxing_catch | RightLowerArm | [-42.5, 0.0, 0.0] | 61.537758 / 44.184490 / -62.712959 | 0.0000092 | 0.000011 |
| boxing_catch | RightShoulder | [13.5, 0.0, 0.0] | -75.672577 / 3.719732 / 74.551491 | 0.0000060 | 0.000006 |
| slip/variants/0 | Spine | [-20, 0, 0] | -20.000004 / 0.000000 / 0.000000 | 0.0000000 | 0.000007 |
| slip/variants/0 | Chest | [-20, 0, 0] | -20.000006 / 0.000000 / 0.000000 | 0.0000051 | 0.000010 |
| boxing_overhand | RightShoulder | [0, 0, -35] | 18.267706 / 34.272720 / -16.832380 | 0.0000205 | 0.000017 |
| boxing_overhand | RightUpperArm | [30, 30, 0] | -38.236546 / 9.709167 / -4.089228 | 0.0000078 | 1.985950 |
| boxing_overhand | Spine | [0, 0, -10] | -0.000000 / -10.087926 / 1.329004 | 0.0000012 | 0.000002 |
| boxing_cross_body | Spine | [4, 0, 0] | 4.000000 / 0.000000 / 0.000000 | 0.0000004 | 0.000002 |
| boxing_rear_hook_body | Spine | [16, 8, 0] | 15.973929 / -1.126827 / 8.096360 | 0.0000019 | 0.279821 |
| boxing_rear_hook_body | RightUpperArm | [24, 0, 0] | -31.794920 / 1.533409 / 20.910975 | 0.0000043 | 0.000009 |
| boxing_shovel_hook | Spine | [0, 8, 0] | -0.000001 / 0.000001 / 7.999999 | 0.0000000 | 0.000002 |
| boxing_shovel_hook | LeftShoulder | [0, 0, -50] | -26.096729 / -48.961040 / 24.046261 | 0.0000037 | 0.000010 |
| boxing_shovel_hook | LeftUpperArm | [-20, 0, 0] | 26.495770 / -1.277841 / -17.425814 | 0.0000075 | 0.000006 |
| boxing_shovel_hook | LeftLowerArm | [80, 0, 40] | -109.424034 / -30.887489 / 49.444790 | 0.0000092 | 7.344157 |
| boxing_up_jab | LeftShoulder | [0, 0, -50] | -26.096729 / -48.961040 / 24.046261 | 0.0000037 | 0.000010 |
| boxing_up_jab | LeftLowerArm | [-30, 0, 0] | 43.438416 / 31.189053 / -44.267971 | 0.0000036 | 0.000010 |
| boxing_up_jab | Spine | [0, 0, 5.75] | -0.000000 / 5.800556 / -0.764177 | 0.0000010 | 0.000002 |
