# Q213C - honest clipping coverage, 2026-10-03

Coverage repaired and measured: **26/26 moves, all four pairings, 104 completed
move/pair runs**. Each of the four sequential processes reports:

```text
Q213_GATE FAIL population=clips_boxing_exact_pin moves=26 pass=23 fail=3 measured=26/26
```

**Task incomplete:** all original 22 moves still pass; the three newly measured
palette combinations fail on every rig. No binding fix is claimed. The withdrawn
inside uppercut has no clipping failure in this diagnostic, but is NOT certified.

## Selection and measurement repair

The two named files are narrowly scoped fallbacks appended after legacy selection;
they cannot replace an existing key. `q213c_coverage_check.gd` contains the frozen
pre-Q213C lookup and compares `var_to_bytes` of the complete selected records
(file, spacing, run number, priority), not just filenames:

```text
Q213C_COVERAGE preserved=88/88 added=16/16 empty=FAIL clean=PASS failures=0
```

All 22 old moves x four rigs have byte-identical selections. `Q213_CERT` prints
each move, rig, file and spacing. An empty tracker fails. A move needs all expected
samples on every requested pairing to pass; summary includes measured=N/26 and
failure exits 1. Failure pairs/windows now print for every move. Thresholds,
pin iterations, pose sampling, spacing and event depth/duration logic are unchanged.
The final per-move spacing label uses the selected rig; earlier pair=1/2 logs
labelled rig 0 there, but Q213_CERT/Q213_CLIPS and measurements used the correct rig.

### Withdrawn uppercut caveat

The four rows in `c231_inside_uppercut.json` have no mechanical failures, but name
`mixamo_pipeline_a/Boxing_Lead_Hand_Uppercut.glb`, whereas the current binding plays
`cascadeur_c229/Cascy_C231_InsideUppercut.glb`. All also have `accepted=false`.
Admitting the filename alone still fails the old source-match check. Only this
explicitly requested withdrawn diagnostic uses the historical spacing despite
that mismatch; output labels `WITHDRAWN diagnostic_fixture_only source_mismatch`.
It measures the current Cascy binding. This is not a source, visual or palette
certificate. The binding is unchanged.

## Remaining fix needs a scope decision

`FightStagePlayer.gd:1203` skips bindings with `sequence` before reading pose_layer
or foot_lock. Its `play_role` at line 1358 uses shared component animations.
Adding knee_swivel/pose_layer to the three owned combination entries is therefore
inert. Changing shared jab/cross/body-hook/uppercut entries exceeds the explicit
three-binding edit window and changes old consumers.

The sequence certificate gate supplies `sequence_receiver` and `sequence_bodies`
(`c223_sequence_gate.gd:176`), while Q213 omits them. The existing between-part
spacing step returns immediately without the receiver (`FightStagePlayer.gd:323`).
The liver/six-punch binding comments explicitly depend on that step. Q213's
playback is preserved in this coverage repair rather than silently changing it.

The operator was asked to approve the existing sequence setup in Q213 and,
if failures remain, opt-in per-sequence part layers in FightStagePlayer. No answer
had arrived when this digest was prepared. Those changes remain pending; no
ineffective binding fields were added. Next action: settle scope, then correct
and remeasure the three combinations on all four rigs.

## Per-move table

Order a/b/c/d: welter_a vs welter_b, welter_b vs welter_a, heavy_c vs heavy_d,
heavy_d vs heavy_c. Every row completed all four pairings. Events are failing
events per rig; worst cm is maximum reported depth. Brief deep overlaps may
pass the unchanged duration limit. A single certificate name applies to all rigs;
four names are listed in a/b/c/d order when selections differ.

| Move | Certificate(s) | Events a/b/c/d | Worst cm | Verdict |
| --- | --- | --- | ---: | --- |
| boxing_body_hook | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_catch | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_check_hook | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_counter_over_jab | s125_g147_counters_b.json | 0/0/0/0 | 0.00 | PASS |
| boxing_cross | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_cross_body | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_double_jab | s125_g147_counters_a.json | 0/0/0/0 | 0.00 | PASS |
| boxing_inside_uppercut | c231_inside_uppercut.json | 0/0/0/0 | 0.00 | WITHDRAWN; diagnostic PASS only |
| boxing_jab | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_jab_body | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_lead_hook | s136_bound.json | 0/0/0/0 | 2.33 | PASS |
| boxing_lead_uppercut | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_liver_combo | s135_chains.json | 4/4/4/4 | 21.50 | FAIL |
| boxing_one_two | s125_g147_counters_a.json; run10_chain.json; s125_g147_counters_a.json; s125_g147_counters_a.json | 0/0/0/0 | 2.52 | PASS |
| boxing_one_two_hook | s135_chains.json | 2/2/2/2 | 13.78 | FAIL |
| boxing_overhand | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_pull | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_pull_counter | s125_g147_counters_b.json | 0/0/0/0 | 0.00 | PASS |
| boxing_rear_hook | run9_rear_final.json; run9_rear_bound.json; run9_rear_final.json; run9_rear_final.json | 0/0/0/0 | 8.95 | PASS |
| boxing_rear_hook_body | s122_bound_controls.json | 0/0/0/0 | 3.66 | PASS |
| boxing_rear_uppercut | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_shovel_hook | s122_bound_controls.json | 0/0/0/0 | 0.00 | PASS |
| boxing_six_punch_combo | s135_chains.json | 8/8/8/8 | 20.35 | FAIL |
| boxing_slip | s136_bound.json | 0/0/0/0 | 0.00 | PASS |
| boxing_slip_counter | s125_g147_counters_a.json | 0/0/0/0 | 0.00 | PASS |
| boxing_up_jab | s136_bound.json | 0/0/0/0 | 0.00 | PASS |

## Failure evidence

- Liver combo: 4 events per rig, HEAD/TORSO/ARM/LEG during body hook around
  1.68-2.53 s. Worst 21.50 cm, heavy_c lead thigh against receiver rear thigh.
- One-two-hook: 2 per rig, jab LEG around 0.40-0.48 s and cross ARM around
  0.97-1.02 s. Worst 13.78 cm, heavy_d.
- Six-punch combo: 8 per rig, initial jab/cross plus rear-uppercut body/leg
  overlaps around 2.3-3.1 s and final cross ARM. Worst 20.35 cm, heavy_d.

Raw logs include exact class windows, pair names, frames and source clips.

## Verification and reproduction

- Parse: `CHECK total=2 fails=0 autoload_refs=0 autoload_warnings=0`.
- Coverage probe: 88 unchanged, 16 added; empty FAIL, sampled clean PASS.
- Four pinned runs: each measured=26/26, pass=23 fail=3, exit 1.
- `python Godot/tools/run_tests.py --only q213_clip_gate_contract --jobs 2`:
  `SUITE total=1 fails=0` (one selected test, one Godot process).
- No SCRIPT ERROR or ERROR in the measurement logs. Each contains 165 warnings
  from FBX reading/object cleanup; disclosed rather than treated as verification.
- `git diff --check` passed. No full suite, viewer or HANDOFF edit.

From cmd, run each pair separately and sequentially:

```bat
python Godot/tools/check_scripts.py Godot/tools/q213_clip_gate.gd Godot/tools/q213c_coverage_check.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once && powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q213_clip_gate.gd -- mode=clips pin=1 pair=0 trace_pose=1
```

Repeat the second command with pair=1, pair=2, pair=3, awaiting each exit. Coverage
probe: Godot `--headless --path Godot --script tools/q213c_coverage_check.gd`, after
the same watchdog chain. Logs: `scratch/q213c_coverage.log`, `scratch/q213c_pair0.log`
through `q213c_pair3.log`, `scratch/q213c_contract.log` (local, not committed).

The fresh worktree required a headless import. Every heavy step was chained to
the watchdog with &&. GREEN/AMBER launched; no RED occurred. Only one owned Godot
process at a time. Import noise and generated UIDs are excluded from staging.
Fetch/rebase succeeded with escalated shared-Git access; base c64e6d2d includes
965dbeee. The explicit operator Q213C assignment overrides unrelated tasks in
the broad mailbox brief; TASK_Q213C.md is absent from this checkout. No unrelated
work or edits outside the owned paths.

## Q213D - opt-in sequence corrections (S148, 2026-10-03)

Pinned gate: **26/26 PASS on each of four rigs; 104/104 completed move/pair runs; 13,916 measured frames; zero failing events**. The withdrawn inside uppercut remains a diagnostic only, not a restored source or palette certificate.

### Implementation and scope

Only the three requested combination bindings opt into `sequence_layers`: component role -> `pose_layer` and/or `foot_lock` (including `knee_swivel`). FightStagePlayer copies the already-bound component into a private per-combination take, uses the existing pose and foot-lock helpers, and preserves the original contact, onset and splice clocks. Variant selection still uses the original logical role and cursor. Shared role and variant dictionaries are restored immediately. The live sequence step samples the private take when present. A sequence without this field follows the original playback path.

The body-hook/uppercut clearance is distributed through hips and trunk, with knee swivels preserving their foot-lock targets. The earlier numerical-only candidate used too much spinal back-bend and was rejected after rendering. The final data uses lateral clearance with substantially less spinal rotation. The one-two-hook and six-punch cross use a local arm/trunk correction; the six-punch lead hook has its own knee layer. No shared single-move binding was edited.

The gate change is reporting only: SHA-256 of every bone pose, skeleton transform, animation name/playhead and sequence index for both bodies, before and after the unchanged pin on every frame. Selection, spacing, population, depth/duration thresholds, pin iterations and receiver/sequence setup are unchanged.

### Final 26-move table

Order a/b/c/d: welter_a vs welter_b, welter_b vs welter_a, heavy_c vs heavy_d, heavy_d vs heavy_c. Every row completed all four pairs. Worst cm includes brief overlaps below the unchanged duration limit. Certificate selections remain those in the Q213C table above.

| Move | Failing events a/b/c/d | Worst cm | Verdict |
| --- | --- | ---: | --- |
| boxing_body_hook | 0/0/0/0 | 0.00 | PASS |
| boxing_catch | 0/0/0/0 | 0.00 | PASS |
| boxing_check_hook | 0/0/0/0 | 0.00 | PASS |
| boxing_counter_over_jab | 0/0/0/0 | 0.00 | PASS |
| boxing_cross | 0/0/0/0 | 0.00 | PASS |
| boxing_cross_body | 0/0/0/0 | 0.00 | PASS |
| boxing_double_jab | 0/0/0/0 | 0.00 | PASS |
| boxing_inside_uppercut | 0/0/0/0 | 0.00 | WITHDRAWN; diagnostic PASS only |
| boxing_jab | 0/0/0/0 | 0.00 | PASS |
| boxing_jab_body | 0/0/0/0 | 0.00 | PASS |
| boxing_lead_hook | 0/0/0/0 | 2.33 | PASS |
| boxing_lead_uppercut | 0/0/0/0 | 0.00 | PASS |
| boxing_liver_combo | 0/0/0/0 | 2.94 | PASS |
| boxing_one_two | 0/0/0/0 | 2.52 | PASS |
| boxing_one_two_hook | 0/0/0/0 | 6.72 | PASS |
| boxing_overhand | 0/0/0/0 | 0.00 | PASS |
| boxing_pull | 0/0/0/0 | 0.00 | PASS |
| boxing_pull_counter | 0/0/0/0 | 0.00 | PASS |
| boxing_rear_hook | 0/0/0/0 | 8.95 | PASS |
| boxing_rear_hook_body | 0/0/0/0 | 3.66 | PASS |
| boxing_rear_uppercut | 0/0/0/0 | 0.00 | PASS |
| boxing_shovel_hook | 0/0/0/0 | 0.00 | PASS |
| boxing_six_punch_combo | 0/0/0/0 | 7.17 | PASS |
| boxing_slip | 0/0/0/0 | 0.00 | PASS |
| boxing_slip_counter | 0/0/0/0 | 0.00 | PASS |
| boxing_up_jab | 0/0/0/0 | 0.00 | PASS |

Final pinned logs: `scratch/q213d_final_pair0.log` through `pair3.log`; each reports `Q213_GATE PASS population=clips_boxing_exact_pin moves=26 pass=26 fail=0 measured=26/26`. No SCRIPT ERROR or ERROR in these four logs.


### Byte-identical playback proof

Baseline runtime files were verified against `5e613215` (checkout line endings aside). The unchanged 23 moves replay the same input history on both revisions, through the original pinned gate via `q213d_preservation.gd`: **92/92 move/rig hashes match**, and all eight baseline/current runs pass 23/23. A mixed 26-role stream has deliberately changed predecessor poses and receiver contact state after an opted combination; those transients are not used to claim byte identity. No measurement in the full 26-role gate was reset or omitted.

`q213d_sequence_hash.gd` additionally covers **every one of the six non-opted sequences**, including near-status `boxing_catch_counter`, on four rigs in both normal and whole-strike modes: **48/48 hashes match**. `q213d_compare.gd` rejects missing/empty/partial/errored logs and compares complete hash records including frame counts: `Q213D_COMPARE matching=140/140 failures=0`.

Below are SHA-256 digests of the sorted per-run hash lines; each digest is identical before and after. Individual per-move hashes remain in the local logs.

| Rig | 23 moves: before = after | 6 sequences x 2 modes: before = after |
| --- | --- | --- |
| welter_a | `b10e95fc48ce3d6c2c542bc1064ed05f54e612e92b718e343df70209f0eb2f9d` | `a05cfd38d09d184beeaa66b6b3c05e6e1d54c861b0e9b0a1567be6c0b6325948` |
| welter_b | `e59c284f16ee92e70f9925f6e360fb0bf1b3babd71283071689fffafe221ff31` | `e1b63239accfde3b7cd8e9986dafd7300298ff70794470b092beeed0cc8e7e57` |
| heavy_c | `3c8b5a06ca4bf2d21d34d1652c46119ed6a9aeb9c8294ee25854cf6db6b82e74` | `8951c1f06bbde5bd4d4d27cc151c784845ab5b06313b259c12f3bfc0c8c1461b` |
| heavy_d | `09cd861ae49e13fbf97a1c25b950d9e256162d4de7e226f6525e21cd40dad59c` | `22df3f5ae67f595271a2a8a67f60864461c43629a9f9991e084f0f768c465f99` |

Logs: `scratch/q213d_before_preserved0.log` ... `3.log`, `q213d_after_preserved0.log` ... `3.log`, `q213d_before_sequences0.log` ... `3.log`, `q213d_after_sequences0.log` ... `3.log`, and `q213d_compare.log`.

### Structural gates

- Parse (nine changed scripts plus three focused tests): `CHECK total=12 fails=0 autoload_refs=0 autoload_warnings=0`.
- Final isolation/occurrence: `Q213D_LAYER_CHECK original_takes=175 corrected_plays=14 failures=0`. Every original animation retains identical keys; shared role/variant lookup bytes, durations and splice/contact clocks are preserved. All seven corrected component takes actually play in both modes, including cache reuse.
- Final selection/coverage: `Q213C_COVERAGE preserved=88/88 added=16/16 empty=FAIL clean=PASS failures=0`.
- Each final pinned log contains 165 existing FBX-reader/object-cleanup warnings, as Q213C did, and no SCRIPT ERROR or ERROR. These warnings are disclosed, not counted as validation.

### Focused regressions and known baseline failure

Each runner invocation used `--jobs 2` with one selected test, serially:

- `--only q213_clip_gate_contract`: `SUITE total=1 fails=0`.
- `--only fight_stage_playback`: `SUITE total=1 fails=0`.
- `--only fight_stage_technique_fidelity`: `SUITE total=1 fails=1`, `TOTAL=34 fails=1`: `the NEAREST branch is reached by the fixture (got 0)`.
- The identical fidelity test was rerun on the verified `5e613215` player/binding snapshots: **same assertion, same `TOTAL=34 fails=1`**. This is a pre-existing fixture occurrence failure, not a green result. The assertion and test file are untouched. Current and baseline evidence: `scratch/q213d_fidelity_current_details.log`, `scratch/q213d_fidelity_baseline_details.log`; runner summaries `q213d_test_fight_stage_technique_fidelity.log` and `q213d_fidelity_baseline.log`.

### Reproduction and workflow

From cmd, prepend the watchdog to each heavy invocation and await each exit. RED means wait and retry, never launch through it; AMBER is permitted:

```bat
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once && powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q213_clip_gate.gd -- mode=clips pin=1 pair=0 trace_pose=1
```

Repeat separately with `pair=1`, `pair=2`, `pair=3`. Other entry points, each behind the same watchdog:

- `tools/q213d_preservation.gd -- pair=N`: unchanged 23-role input history, pinned; capture as `scratch/q213d_before_preservedN.log` on the baseline runtime and `q213d_after_preservedN.log` on Q213D.
- `tools/q213d_sequence_hash.gd -- pair=N` (headless): all six non-opted sequences, both modes; baseline/current logs named `q213d_before_sequencesN.log` / `q213d_after_sequencesN.log`.
- `tools/q213d_compare.gd` (headless): strict 140-record comparison of those logs.
- `tools/q213d_layer_check.gd` (headless): original-library isolation, corrected-take occurrence, lookup restoration, duration/contact/splice preservation.
- `tools/q213c_coverage_check.gd` (headless): retained selection and empty-tracker contract.
- `tools/q213d_pose_review.gd` (hidden windowed): baseline/current clearance witnesses in `scratch/q213d_pose_review.png`; top=baseline, bottom=corrected, columns=liver / one-two-hook / six-punch. These are pose witnesses, not a full animation-quality certificate.

All Q213D Godot jobs were serialized; the host's already-running MH2 job and separate open Godot app were left untouched. Every heavy launch followed GREEN/AMBER watchdog output; no RED occurred. No operator-facing render windows, full suite, HANDOFF edit or import-file staging. The explicit Q213D assignment superseded unrelated broad-mailbox tasks. Fetch succeeded; the generic rebase step was set aside because of pre-existing import changes and the required frozen `5e613215` comparison base. Delivery stays on the explicitly requested `codex/q213c` branch.

The final pose sheet was regenerated and opened after freezing the delivered bindings; it retains the lateral/hip correction and removes the rejected candidate's excessive spinal arch. Raw render log: `scratch/q213d_pose_review_final.log`.

## Q213E - instrument audit (S151, 2026-10-03)

Mesh route: FightBodyCapsules.gd, clips, bindings and pin behaviour are untouched.
The final skin measure includes identity blend shapes, all four skin weights,
Skin bind matrices, current poses, world transforms, AND the actual active
FighterFist SkeletonModifier3D. Its temporary pose writes are restored exactly.
Native bake validation found the missing render modifier in the first probe:
open animation fingers differed from rendered folded fingers by up to 10 cm.
Those preliminary skin tables and the preliminary nine-failure run are INVALID
and superseded. The preliminary run and sheets are archived under
`scratch/q213e_prefist_*`; only the final evidence files named below are accepted.
The corrected pipeline agrees with native baked skin within 0.1 mm on the initial
18 actor/pose checks. Final tables and validation follow below.

The review renderer is unpinned. It warms the receiver for 120 frames and plays
only three combinations, whereas the gate warms for 30 and pins every frame of
the 26-move stream. The review poses therefore are NOT the gate pinned poses.
The witness pin=1 readings apply the original pin once to each exact review pose;
they are not represented as the continuously pinned gate trajectory.

The first full attempt exited before a gate summary and was discarded. Long
mesh runs now yield every eight samples, with full before/after pose and clock
hash assertions. The 19 common move hashes matched the pre-yield run exactly.
The subsequent pre-modifier run completed 441 yield checks without a change.
No unfinished run or rejected measurement is reported as a certificate.

### Step 1 - final exact-frame table

All six unpinned reconstructed crops are pixel-identical to `scratch/q213d_pose_review.png` (6/6). A = attacking heavy_d; B = defending heavy_c. Mesh counts are posed vertices (including seam duplicates), in the requested hand/forearm/head source regions and torso/neck/head target regions. Both directions are checked. Capsules below are the original instrument readings; its common 2 cm prefilter censors smaller depths to zero.

| Frame | Pin | Capsule HEAD/TORSO/ARM cm | Skin A to B cm (vertices) | Skin B to A cm (vertices) |
| --- | ---: | --- | --- | --- |
| baseline liver_combo f110 | 0 | 12.02 / 2.92 / 11.08 | 1.09 (22) | 6.98 (123) |
| baseline liver_combo f110 | 1 | 0.00 / 2.92 / 0.00 | 0.00 (0) | 0.00 (0) |
| baseline one_two_hook f59 | 0 | 0.00 / 0.00 / 23.32 | 11.13 (160) | 0.00 (0) |
| baseline one_two_hook f59 | 1 | 0.00 / 0.00 / 6.33 | 2.47 (34) | 0.00 (0) |
| baseline six_punch_combo f178 | 0 | 8.46 / 13.07 / 24.49 | 11.73 (532) | 10.15 (86) |
| baseline six_punch_combo f178 | 1 | 8.46 / 13.07 / 15.22 | 0.00 (0) | 0.00 (0) |
| corrected liver_combo f110 | 0 | 0.00 / 0.00 / 0.00 | 0.00 (0) | 0.00 (0) |
| corrected liver_combo f110 | 1 | 0.00 / 0.00 / 0.00 | 0.00 (0) | 0.00 (0) |
| corrected one_two_hook f59 | 0 | 0.00 / 0.00 / 5.44 | 0.00 (0) | 0.00 (0) |
| corrected one_two_hook f59 | 1 | 0.00 / 0.00 / 0.00 | 0.00 (0) | 0.00 (0) |
| corrected six_punch_combo f178 | 0 | 0.00 / 0.00 / 8.29 | 0.00 (0) | 0.00 (0) |
| corrected six_punch_combo f178 | 1 | 0.00 / 0.00 / 0.00 | 0.00 (0) | 0.00 (0) |

The baseline has real visible forearm penetration; those frames are positive controls. The corrected row does **not** establish several centimetres of the requested skin penetration at these exact poses. In particular, the apparent pre-modifier hand/head failures were invalid open-finger measurements. The same-pose "capsule under limit / skin several cm inside" hypothesis is not demonstrated by these six final witnesses. The 2 cm prefilter still incorrectly hides potential HEAD readings between 1 and 2 cm.

Full per-class pairs and anatomical counts:

- baseline/boxing_liver_combo pin=0: capsules HEAD 12.02 cm Head>RightLowerArm-RightHand; TORSO 2.92 cm UpperChest-Neck>UpperChest-Neck; ARM 11.08 cm UpperChest-Neck>RightLowerArm-RightHand; LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {"forearm": {"count": 22, "max_cm": 1.09054856002331, "pair": "RightLowerArm>Spine"}}; B to A {"forearm": {"count": 122, "max_cm": 6.98327496647835, "pair": "RightLowerArm>Head"}, "hand": {"count": 1, "max_cm": 0.317526538856328, "pair": "RightHand>Head"}}.
- baseline/boxing_liver_combo pin=1: capsules HEAD 0.00 cm (none reported); TORSO 2.92 cm UpperChest-Neck>UpperChest-Neck; ARM 0.00 cm (none reported); LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {}; B to A {}.
- baseline/boxing_one_two_hook pin=0: capsules HEAD 0.00 cm (none reported); TORSO 0.00 cm (none reported); ARM 23.32 cm RightLowerArm-RightHand>UpperChest-Neck; LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {"forearm": {"count": 160, "max_cm": 11.1277051270008, "pair": "RightLowerArm>UpperChest"}}; B to A {}.
- baseline/boxing_one_two_hook pin=1: capsules HEAD 0.00 cm (none reported); TORSO 0.00 cm (none reported); ARM 6.33 cm RightUpperArm-RightLowerArm>UpperChest-Neck; LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {"forearm": {"count": 34, "max_cm": 2.47294474393129, "pair": "RightLowerArm>UpperChest"}}; B to A {}.
- baseline/boxing_six_punch_combo pin=0: capsules HEAD 8.46 cm Head>LeftShoulder-LeftUpperArm; TORSO 13.07 cm UpperChest-Neck>UpperChest-Neck; ARM 24.49 cm LeftLowerArm-LeftHand>UpperChest-Neck; LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {"forearm": {"count": 189, "max_cm": 11.7322251200676, "pair": "LeftLowerArm>UpperChest"}, "hand": {"count": 343, "max_cm": 5.88804259896278, "pair": "LeftHand>UpperChest"}}; B to A {"forearm": {"count": 86, "max_cm": 10.1491630077362, "pair": "LeftLowerArm>UpperChest"}}.
- baseline/boxing_six_punch_combo pin=1: capsules HEAD 8.46 cm Head>LeftShoulder-LeftUpperArm; TORSO 13.07 cm UpperChest-Neck>UpperChest-Neck; ARM 15.22 cm UpperChest-Neck>LeftShoulder-LeftUpperArm; LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {}; B to A {}.
- corrected/boxing_liver_combo pin=0: capsules HEAD 0.00 cm (none reported); TORSO 0.00 cm (none reported); ARM 0.00 cm (none reported); LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {}; B to A {}.
- corrected/boxing_liver_combo pin=1: capsules HEAD 0.00 cm (none reported); TORSO 0.00 cm (none reported); ARM 0.00 cm (none reported); LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {}; B to A {}.
- corrected/boxing_one_two_hook pin=0: capsules HEAD 0.00 cm (none reported); TORSO 0.00 cm (none reported); ARM 5.44 cm RightShoulder-RightUpperArm>LeftHand; LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {}; B to A {}.
- corrected/boxing_one_two_hook pin=1: capsules HEAD 0.00 cm (none reported); TORSO 0.00 cm (none reported); ARM 0.00 cm (none reported); LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {}; B to A {}.
- corrected/boxing_six_punch_combo pin=0: capsules HEAD 0.00 cm (none reported); TORSO 0.00 cm (none reported); ARM 8.29 cm RightLowerArm-RightHand>LeftLowerArm-LeftHand; LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {}; B to A {}.
- corrected/boxing_six_punch_combo pin=1: capsules HEAD 0.00 cm (none reported); TORSO 0.00 cm (none reported); ARM 0.00 cm (none reported); LEG 0.00 cm (none reported); FOOT 0.00 cm (none reported); skin A to B {}; B to A {}.

### Step 2 - measurement repair

The gate supplements capsules with actual post-modifier skinned surface checks, in both directions. Native concave-mesh queries find containment, and exact point/triangle distances measure depth. Class limits are unchanged: HEAD >1 cm/>1 frame, TORSO >2 cm/>3 frames, ARM >3 cm/>3 frames; existing leg/foot limits are unchanged. No forearm allowance is subtracted. The original glove pin/contact solver is unchanged.

The common 2 cm prefilter is removed; consecutive runs count only samples exceeding their own class limit, preventing below-limit frames from joining separate events. Worst-pair reporting now follows the actual peak. Skin vertices with a ray-exit upper bound <=1 cm can be omitted at runtime because they cannot exceed any G147 limit; the step-1 measurements are uncensored. The native search and this conservative shortcut are compared against the independent full-triangle reference, with 0.1 mm numerical tolerance.

The three visibly penetrating baseline poses are held for four frames as instrument sensitivity controls and must read FAIL; this does not assert their original animation duration. This remains a discrete vertex/surface diagnostic, not a continuous swept-volume certificate.

### Step 3 - final 26 moves x 4 rigs

**104/104 complete; 95 passing move/rig runs, 9 failing move/rig runs. Across rigs: 23 moves PASS, 3 FAIL.** a/b/c/d = welter_a vs welter_b / welter_b vs welter_a / heavy_c vs heavy_d / heavy_d vs heavy_c. All new failures are among the original 22. No clips or bindings were changed. The withdrawn inside uppercut remains a diagnostic, not an admitted clip.

| Move | Failing events a/b/c/d | Peak any class cm | Worst failing class (rig, frame, cm) | Verdict |
| --- | --- | ---: | --- | --- |
| boxing_body_hook | 0/0/0/0 | 0.00 | - | PASS |
| boxing_catch | 0/0/0/0 | 0.00 | - | PASS |
| boxing_check_hook | 0/0/0/0 | 0.00 | - | PASS |
| boxing_counter_over_jab | 0/0/0/0 | 2.35 | - | PASS |
| boxing_cross | 0/0/0/0 | 0.01 | - | PASS |
| boxing_cross_body | 0/0/0/0 | 1.07 | - | PASS |
| boxing_double_jab | 0/0/0/0 | 0.00 | - | PASS |
| boxing_inside_uppercut | 0/0/0/0 | 1.65 | - | WITHDRAWN; diagnostic PASS |
| boxing_jab | 0/0/0/0 | 0.00 | - | PASS |
| boxing_jab_body | 0/0/0/0 | 0.00 | - | PASS |
| boxing_lead_hook | 0/0/0/0 | 2.33 | - | PASS |
| boxing_lead_uppercut | 1/2/2/2 | 3.85 | d, f74, HEAD, 3.85 | FAIL |
| boxing_liver_combo | 0/0/0/0 | 2.94 | - | PASS |
| boxing_one_two | 0/0/0/0 | 2.52 | - | PASS |
| boxing_one_two_hook | 0/0/0/0 | 6.72 | - | PASS |
| boxing_overhand | 0/0/0/0 | 2.22 | - | PASS |
| boxing_pull | 0/0/0/0 | 0.00 | - | PASS |
| boxing_pull_counter | 0/0/0/0 | 0.01 | - | PASS |
| boxing_rear_hook | 0/1/0/0 | 8.95 | b, f27, HEAD, 1.56 | FAIL |
| boxing_rear_hook_body | 1/3/1/3 | 3.66 | d, f19, HEAD, 3.63 | FAIL |
| boxing_rear_uppercut | 0/0/0/0 | 0.01 | - | PASS |
| boxing_shovel_hook | 0/0/0/0 | 0.07 | - | PASS |
| boxing_six_punch_combo | 0/0/0/0 | 7.17 | - | PASS |
| boxing_slip | 0/0/0/0 | 0.00 | - | PASS |
| boxing_slip_counter | 0/0/0/0 | 0.02 | - | PASS |
| boxing_up_jab | 0/0/0/0 | 0.95 | - | PASS |

A peak can exceed a limit without failing if its event is too brief. The "peak any class" can therefore exceed the worst failing-class peak. All nine failing move/rig cases below are actual **posed skin** HEAD events, not capsule-only failures.

| Move | Rig | Pair | Worst frame | cm | Failing windows (frames, peak cm) |
| --- | --- | --- | ---: | ---: | --- |
| boxing_lead_uppercut | a | skin:B:LeftHand>Head | 44 | 1.07 | 44-45: 1.07 |
| boxing_lead_uppercut | b | skin:B:LeftHand>Head | 77 | 3.31 | 50-56: 1.49; 73-81: 3.31 |
| boxing_lead_uppercut | c | skin:B:LeftHand>Head | 72 | 1.80 | 39-41: 1.10; 68-75: 1.80 |
| boxing_lead_uppercut | d | skin:B:LeftHand>Head | 74 | 3.85 | 49-57: 2.10; 71-80: 3.85 |
| boxing_rear_hook | b | skin:B:LeftLittleDistal>Head | 27 | 1.56 | 27-28: 1.56 |
| boxing_rear_hook_body | a | skin:B:LeftLittleDistal>Head | 43 | 2.17 | 42-46: 2.17 |
| boxing_rear_hook_body | b | skin:B:LeftHand>Head | 18 | 3.27 | 17-19: 3.27; 27-28: 1.86; 52-57: 2.52 |
| boxing_rear_hook_body | c | skin:B:LeftHand>Head | 43 | 2.85 | 41-47: 2.85 |
| boxing_rear_hook_body | d | skin:B:LeftHand>Head | 19 | 3.63 | 17-20: 3.63; 27-29: 2.54; 46-53: 2.77 |

Each final run reports `measured=26/26`, no SCRIPT ERROR/ERROR, and `Q213E_YIELD poses_and_clocks_preserved=441` (1,764 total). Pairing 0 also has 26/26 byte-identical full pose/clock stream hashes against the pre-modifier measurement run, confirming that the modifier is sampled and restored rather than changing playback.

Final numeric evidence: `scratch/q213e_pair0.log` through `q213e_pair3.log`, plus corresponding JSON reports and `q213e_worst_RIG_MOVE.bin` exact-pose snapshots.

### Step 4 - opened and inspected all three failure sheets

Each sheet has two full views and a close view, rendered through
`Tools/godot_hidden.ps1` and opened with the file image tool. These are the
highest readings in a **failing class**, across failing rigs; larger brief peaks
that pass G147 are reported separately in the table. The renderer restores the
saved gate pose, without seeking the animation or applying another pin. Every
sheet remeasures and reproduces the recorded gate depth within 0.2 mm. All six
actor meshes also match Godot's native blend-plus-skeleton bake within
**0.087081 mm maximum** across all 14,517 vertices per actor.

| Move / saved frame | Original HEAD capsule cm | Rendered-skin HEAD cm | What I see |
| --- | ---: | ---: | --- |
| lead_uppercut, heavy_d f74 | 0.00 | 3.8462 | The pale attacker bows into the dark defender's raised hand. The close view shows the hand occupying the temple/scalp boundary. This is hand/head contact, not a forearm crossing the chest. |
| rear_hook, welter_b f27 | 0.00 | 1.5595 | The blue-trunk attacker leans into the red-trunk defender's hand at the side of the head. The hand contour partly disappears behind the temple; the overlap is subtler in the still than in the other two sheets. I do not infer the centimetres from the image alone. |
| rear_hook_body, heavy_d f19 | 0.00 | 3.6349 | The green-trunk attacker's head sits under the yellow-trunk defender's raised hand. The close view shows the palm/finger region intersecting the temple/scalp boundary. |

These matched **pinned** poses prove a real instrument blind spot: the original
HEAD capsule report is zero while the validated rendered skin penetrates by
1.56-3.85 cm. This evidence is separate from the original six-frame sheet,
whose corrected-row requested skin checks read zero.

Sheets:
- [Lead uppercut](../../scratch/q213e_review_boxing_lead_uppercut.png)
- [Rear hook](../../scratch/q213e_review_boxing_rear_hook.png)
- [Rear-hook-body](../../scratch/q213e_review_boxing_rear_hook_body.png)

### Final verification and reproduction

- Parse: `CHECK total=6 fails=0 autoload_refs=0 autoload_warnings=0`.
- Render-mesh/reference controls: `Q213E_REFERENCE maxima=24/24 failures=0`.
  Three baseline held-pose controls fail, nine remaining pin-state controls pass;
  runtime culling preserves all above-1-cm maxima.
- Focused runner, `--only q213_clip_gate_contract --jobs 2`:
  `SUITE total=1 fails=0`. No full suite was run.
- Frozen selection: `Q213C_COVERAGE preserved=88/88 added=16/16
  empty=FAIL clean=PASS failures=0`. The 26-move selection is unchanged.
- Final numeric logs: four complete summaries, 13,916 samples total,
  1,764 successful pose/clock preservation checks, no SCRIPT ERROR/ERROR.
- Final visual readback: `Q213E_REVIEW_COMPLETE sheets=3`, three reproduced
  depths, six native-skin comparisons, no errors or warnings.
- Existing input-reader/certificate warnings remain (165 per numeric log and
  128 in the coverage log); they are not counted as successful validation or hidden by exit codes.

From this worktree, prepend the watchdog with `&&` to **each** heavy command:

```bat
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once && powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q213e_probe.gd
```

Then run `tools/q213e_benchmark.gd` headless (reads the probe's geometry fixtures),
`tools/q213_clip_gate.gd -- mode=clips pin=1 pair=N trace_pose=1` separately for
N=0,1,2,3, and finally `tools/q213e_review.gd` windowed through the hidden launcher.
Read the complete summary and error stream, not the exit code alone: numerical
FAIL runs intentionally exit 1. Evidence lives in `scratch/q213e_witness_*`,
`q213e_native_final.log`, `q213e_pair0.log` through `q213e_pair3.log`,
`q213e_contract.log`, `q213e_coverage.log`, and `q213e_review_final.log`.

Workflow: the dirty worktree's pre-existing import churn and the explicitly
assigned `codex/q213c` branch took precedence over the general intake rebase.
Origin was fetched; no rebase, HANDOFF edit, clip fix, binding edit, capsule-radius
edit, or merge was performed. Only the owned gate, new Q213E tools and this
appended digest section are included in delivery. Import files are excluded.
