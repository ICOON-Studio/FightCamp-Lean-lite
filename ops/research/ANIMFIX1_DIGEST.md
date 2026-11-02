# ANIMFIX1 round 2 (S224) - mirror repair; uppercut separate

## Part A - rest-aware mirror

Part A commit: `66bc5b04` (replaces intermediate `dd6a246d` with the bare-track fold repair and final evidence). Claude's round-2 ruling supersedes the earlier uppercut stop below. The neutral mirror witness, not the uppercut, authorizes this repair. No uppercut fix is claimed.

Production change: post-retarget callers pass the target skeleton. `FightClipMirror` folds a private input copy once, composes skeleton-space motion relative to each bone's own global rest, reflects that delta, applies the opposite bone's rest, and writes actual-parent locals. The output declares `mirror_space=actual_parent_rest_delta` and retains `mh_rest_folded`; library insertion therefore does not fold mirrored reactions again. Central bones use the same equation. Hips displacement reflects in skeleton metres about the target rest, so the caller's former extra rest-X offset is removed. Contact takes are recursively mirrored, side metadata is carried, stale weak references/floor reports are discarded and the floor cache is marked dirty. The existing source-only canonical-carrier API remains for pre-retarget clips; no switch, clamp, band, pose layer, native binding or source asset changes.

Red reproduced before production edits: neutral-rest test fails with the same 28 paired-bone failures recorded below. Expanded contracts cover MH05/MH08 neutral rest, double mirror at every original key including Hips translation, signed knee +20 / wrist +15 using skeleton-space directions, symmetric unflipped control, and synchronous reaction-library insertion with exactly one fold. Final contracts: `ANIMFIX1 rest/motion/control/fold failures=0`; worst double-mirror error MH05 0.0002974 deg, MH08 0.0001925 deg; position error 0 m; unflipped control 0.00000733 deg. Signed limb directions differ from the independent reflected oracle by at most 0.000131 deg. Metadata checks cover rest-relative opposite-side foot-lock anchors and preservation of Hips-drop semantics; side-local Euler recipes remain source provenance, not a falsely relabelled destination recipe. Source clips are untouched.

Parse gates pass on all touched scripts and probes. The authorized affected subset initially returned: `SUITE total=29 fails=1`. The only failure is `fight_clip_slice_test`: selected `boxing_rear_hook` is 1.724 s while a historical assertion requires <1.2 s. A separate run with all owned production scripts restored to HEAD reproduced the identical failure (`SUITE total=1 fails=1`); repairs were restored in `finally`. This is not attributed to the mirror. Final focused mirror test passed after the metadata additions. Logs: [green_mirror.txt](../docs/previews/animfix1/green_mirror.txt), [affected_suite.txt](../docs/previews/animfix1/affected_suite.txt), [baseline_slice.txt](../docs/previews/animfix1/baseline_slice.txt). The same affected subset was repeated after the bare-track integration repair below: `SUITE total=29 fails=1`, with the same baseline-only failure. No full suite run.

All Godot invocations, including the Python runners, went through the temporary `E:/FightCamp/tmp/animfix1/hidden_gate.cmd` wrapper (watchdog, then `Tools/godot_hidden.ps1`, GUI executable). Watchdogs green; no visible windows. Worktree was clean at intake and rebased onto `3dfc9394`; no import or source-asset edits.

### Bare-track integration regression

The mirror also receives bare retarget track names before `address_tracks`. The fold helper previously read only NodePath subnames, so it marked those clips folded without converting their intermediate rests. The new regression is RED first: MH05/MH08 chest error 7.32095/7.32072 degrees and head 16.70533/16.70561 degrees. `MetaHumanRig.fold_intermediate_rests` now resolves both bare names and addressed subnames. Final bare-vs-already-folded mirror comparison is green below 0.00001 degrees. [Red witness](../docs/previews/animfix1/red_bare_fold.txt), final output in `green_mirror.txt`. This is part of Part A's mirror input-space contract, not an uppercut foot correction. Final captures and the affected subset/sole coverage are refreshed after it.

### Controlled live-room witness

`animfix1_mirror_room.gd` loads the production room and its libraries (seed 930093, MH09 Vance / MH08 Miller), pauses its simulation at frame 30, explicitly seeks MH08's real `hook_rear` and `react_head_lead` animations, and waits four render frames before saving through `still_framing.save_if_framed`. It is controlled playback in the real room, not a naturally selected strike or proof of opponent contact. The initial pre-draw-only capture was rejected because it rendered the prior pose; the delivered files replace it with the verified paused/settled capture. All eight delivered stills were opened; all report broadcast framing OK, err=0.

| MH08 pose | Before left/right sole tilt | After left/right sole tilt | Right wrist Y before -> after |
|---|---|---|---|
| Guard 0.20 s | 20.941 / 28.863 deg | 20.941 / 28.863 deg | 1.3733 -> 1.3733 m |
| Rear hook 0.20 s | 14.371 / 48.333 deg | 2.364 / 39.138 deg | 0.1967 -> 1.1703 m |
| Rear hook 0.40 s | 21.582 / 15.294 deg | 14.510 / 3.752 deg | 0.3749 -> 1.2903 m |
| Mirrored reaction 0.20 s | 45.444 / 46.609 deg | 26.172 / 32.896 deg | 0.4273 -> 1.4589 m |

Full wrist origins AND orientation bases, plus sole tilt/roll: [before](../docs/previews/animfix1/red_mirror/readback.json), [after](../docs/previews/animfix1/after_mirror/readback.json). Offline per-stage source-motion/retarget/mirror/fold readback: [mirror_construction.json](../docs/previews/animfix1/mirror_construction.json). `hook_rear` does not request a foot bake; the probe reports that boundary as absent instead of inventing a production stage. Retarget keys are decoded according to their collapsed-parent space for measurement; an additional raw-local baseline snapshot is explicitly labelled. Source-only files have no skin: the source-motion witness applies their global rest deltas to MH08's skin without silhouette matching and is labelled accordingly.

### Opened still observations (all MH09 red / MH08 purple)

Each row follows gap / noses / wrists / feet / mirror defect / bodies. Stills cannot establish sliding.

- **Before guard:** clear gap; faces across and down; bent glove/forearm lines; wide stance, rolled/pointed feet; guard remains the unchanged control; MH09/MH08.
- **Before hook 0.20:** clear gap; Vance toward Miller, Miller folded toward floor; wrists crushed near floor; legs folded underneath torso; catastrophic mirror inversion visible; MH09/MH08.
- **Before hook 0.40:** clear gap; Vance toward Miller, Miller down; twisted low gloves; inverted pelvis and folded legs; catastrophic mirror inversion visible; MH09/MH08.
- **Before reaction:** clear gap; Vance toward Miller, Miller down; low twisted gloves; body and legs collapsed; mirror/fold corruption visible; MH09/MH08.
- **After guard:** clear gap; faces across/down; wrist bends remain; wide stance and rolled feet; unchanged control; MH09/MH08.
- **After hook 0.20:** clear gap; heads generally face across; one glove forward and opposite glove near jaw, wrist bend remains; very wide stance with raised feet; whole-body inversion removed, foot presentation unresolved; MH09/MH08.
- **After hook 0.40:** clear gap, no actual opponent contact; Vance faces across and Miller looks down/across along the punch; right forearm crosses torso, glove remains bent; wide stance with apparent float; inversion removed, shape not accepted; MH09/MH08.
- **After reaction:** clear gap; Vance toward Miller, Miller tilted up/away; raised gloves with bent wrist; wide bent-knee stance and uneven foot placement; inversion removed, remaining shape unresolved; MH09/MH08.

Before and after files are in `docs/previews/animfix1/red_mirror/` and `after_mirror/`. Five review stills posted to `E:/FightCamp/review/2026-10-14_1712_animfix1_final_mirror_boundary_visual_re` (ops board `/review`). No new animation asset (`clip_status.py new-anims`: 0); these are new runtime captures. **Visual review remains OPEN for Claude and the operator.** The visual-gate instruction "One bad item on any still = GO BACK ... Do not accept with notes" is honored by withholding acceptance; round-2 scope prohibits expanding this mirror change into unrelated pose/foot repairs. The toolkit's `c209/shadowboxing_take1_raw.mp4` and sheet were opened: both are rendered footage, and the sheet labels itself rejected, so they are not misrepresented as real-human reference. The supplied external heavy-bag path is absent.

### Full-duration sole coverage (Part A)

Two seeds x MH02/MH05/MH08/MH09 x 60.033 s: coverage complete. All 16 foot rows remain RED against the unchanged bands (lead 0-12 deg, rear 10-35 deg, roll 10 deg/12 deg); below/above/roll flags may overlap only through roll. This is the broad residual-foot gate, not the neutral mirror contract.

| Seed | Body / foot | Frames | Below | Above | Roll | Max tilt | >55 deg longest run |
|---|---|---:|---:|---:|---:|---:|---:|
| 94301 | mh_boxer_08.glb/Left | 1802 | 0 | 1795 | 1730 | 50.305 deg | 0 |
| 94301 | mh_boxer_08.glb/Right | 1802 | 5 | 30 | 1773 | 78.536 deg | 7 |
| 94301 | mh_boxer_09.glb/Left | 1802 | 0 | 1748 | 1631 | 59.416 deg | 2 |
| 94301 | mh_boxer_09.glb/Right | 1802 | 22 | 71 | 1763 | 58.371 deg | 3 |
| 94301 | mh_boxer_02.glb/Left | 1802 | 0 | 1795 | 1785 | 63.800 deg | 4 |
| 94301 | mh_boxer_02.glb/Right | 1802 | 10 | 62 | 1779 | 69.797 deg | 5 |
| 94301 | mh_boxer_05.glb/Left | 1802 | 0 | 1781 | 1777 | 54.861 deg | 0 |
| 94301 | mh_boxer_05.glb/Right | 1802 | 17 | 90 | 1773 | 79.338 deg | 7 |
| 930093 | mh_boxer_08.glb/Left | 1802 | 0 | 1800 | 1730 | 52.617 deg | 0 |
| 930093 | mh_boxer_08.glb/Right | 1802 | 22 | 59 | 1772 | 80.695 deg | 5 |
| 930093 | mh_boxer_09.glb/Left | 1802 | 0 | 1780 | 1659 | 41.618 deg | 0 |
| 930093 | mh_boxer_09.glb/Right | 1802 | 22 | 63 | 1763 | 89.631 deg | 9 |
| 930093 | mh_boxer_02.glb/Left | 1802 | 0 | 1799 | 1789 | 63.702 deg | 6 |
| 930093 | mh_boxer_02.glb/Right | 1802 | 41 | 38 | 1746 | 60.870 deg | 5 |
| 930093 | mh_boxer_05.glb/Left | 1802 | 0 | 1802 | 1800 | 48.020 deg | 0 |
| 930093 | mh_boxer_05.glb/Right | 1802 | 32 | 78 | 1758 | 72.807 deg | 7 |

Raw CSVs and JSON summaries: `docs/previews/animfix1/sole_<seed>_<pair>.*`. The first 94301 smaller-pair attempt was rejected because it still selected MH09/MH08: the picker needs `weight_kg`, not only `competition_weight_kg`. The probe now supplies the correct field, asserts each actual body path, and the affected run was repeated. Rejected summary retained outside git at `E:/FightCamp/tmp/animfix1/rejected_wrong_cast_94301.json`. The delivered four summaries pass exact seed/body/duration/frame coverage assertions. Final log classification caught and rejected a probe-only post-close CSV callback (`store_buffer: Parameter f is null`). The probe now disconnects `frame_post_draw` before closing; all four runs were repeated, each emits exactly one summary, and CSV row counts match JSON frames. [Clean engine checks](../docs/previews/animfix1/sole_engine_checks.txt). No bands were changed. As in round 1, the three-vertex plane is unsigned and does not itself distinguish an inverted sole; neutral rotations and the opened stills cover that mirror defect.

## Part B - uppercut construction trace

**Finding: the first stage above 35 degrees is the source itself.** At raw clip time 0.50 s, the source's global rest-delta motion on MH08 skin already produces a 35.323645-degree right sole plane. It reaches 71.201642 degrees at 0.65 s and 72.195113 degrees at 0.75 s, before `retarget_clip`, mirror, fold or foot bake. This clip goes to the approved offline re-bake. Part B changes no production code, source asset, switch, threshold or clamp.

Source: `Godot/assets/anim/c223/mixamo_pipeline_a/Boxing_Back_Hand_Uppercut.glb`, SHA256 `c75196da35329810f1f5f58acf8096b6a911fe7d49e2695d42b00ecbeafd9810`. The binary has zero meshes, 66 nodes; animation 0 uses right-foot rotation channel/sampler 172 (node 58 `foot_r`) and right-ball rotation channel/sampler 175 (node 59 `ball_r`). These are binary channel locators, not invented text line numbers.

**Why / code locations:** `FightClipBinding.gd:89` chooses that source. Its carrier globals are sampled without correction by `FightClipRetarget.gd:854`; the probe's source arm at `tools/animfix1_uppercut_probe.gd:21` precedes the actual retarget call at `:28`. `tools/animfix1_construction_probe.gd:102` applies only `G_source_pose * inverse(G_source_rest)` to each MH08 rest basis, with actual-parent reconstruction at `:104`; no silhouette, foot bake or runtime writer intervenes. The asset has no source skin, so this is explicitly source motion measured on MH08 skin, not a claimed measurement of a nonexistent source mesh. Using the carrier's own rest or the separate reference rest gives identical sole angles to the reported precision. Independent carrier right-foot rest-normal tilt is 44.900 degrees at 0.50 s and 76.038 degrees at 0.65 s (`animfix1_uppercut_probe.gd:76`); this corroborates that the source rotation is already pointed without relying on the MH sole triangle or ankle-to-ball slope.

### Right sole plane, degrees, at each stage's clip clock

The first four rows share the raw source clock. Production warp changes that clock; inverse mappings follow the table. Mirror is absent throughout.

| Stage | 0.50 | 0.55 | 0.60 | 0.65 | 0.70 | 0.75 | 0.80 |
|---|---:|---:|---:|---:|---:|---:|---:|
| Source on own carrier, expressed on MH08 skin | 35.324 | 55.890 | 67.419 | 71.202 | 72.163 | 72.195 | 71.430 |
| Retarget (collapsed-parent keys decoded) | 45.421 | 64.056 | 73.987 | 77.863 | 79.261 | 80.063 | 79.597 |
| Fold to actual parents | 45.421 | 64.056 | 73.987 | 77.863 | 79.261 | 80.063 | 79.597 |
| Fold then foot bake (requested order) | 42.001 | 52.124 | 61.861 | 61.147 | 60.546 | 80.063 | 79.597 |
| Production phase warp | 74.930 | 78.532 | 79.822 | 80.056 | 77.775 | 69.177 | 53.084 |
| Production foot bake before library insertion | 61.725 | 60.839 | 60.692 | 80.056 | 77.775 | 60.583 | 46.245 |
| Production library fold | 61.725 | 60.839 | 60.692 | 80.056 | 77.775 | 60.583 | 46.245 |

Production clocks 0.50/0.55/0.60/0.65/0.70/0.75/0.80 map to source clocks 0.608333/0.670833/0.731147/0.781147/0.831147/0.881147/0.931147. At those aligned source times the source-on-MH08 plane is 68.280/71.584/72.234/71.850/69.673/61.030/45.467 degrees. Thus the comparison does not mistake retiming for a newly introduced foot rotation.

The target retarget raises raw-clock sole tilt by roughly 7-10 degrees in this window; `FightClipRetarget.gd:354` aligns anatomical segments to the source-rest silhouette. That is later than the first violation, so this task's source-first ruling leaves it unchanged. Three intermediate rotation tracks fold; fold does not alter the sole. Actual production requests the foot bake at `FightStagePlayer.gd:2377` before library insertion/fold. The probe preserves that order in its production arm as well as measuring the requested fold-then-bake arm.

At the seven exact live animation clocks from round 1, offline production yields 61.707713 / 60.781826 / 75.460128 / 79.934298 / 77.436450 / 59.918408 / 45.912648 degrees, within 0.041801 degrees of the original `animation_sample` readback. A second final-floor bake leaves those numbers unchanged. This independently reproduces the 60-80 degree excursion during construction; the mirror is never visited.

**Verification and limits:** final probe parse `CHECK total=1 fails=0`; hidden headless run exits 0 and passes the existing `run_tests.Result` error classifier, with 77 stage/time rows. Full data includes both sole planes, roll, both wrist positions/bases, source carrier normals, inverse clock mapping and bake reports: [uppercut_construction.json](../docs/previews/animfix1/uppercut_construction.json); [engine trace](../docs/previews/animfix1/uppercut_trace.txt). Reproduce through the watchdog/hidden launcher with `--headless --path Godot --script tools/animfix1_uppercut_probe.gd -- as_game`. The probe copies bake-only metadata from `BINDINGS` exactly as `FightStagePlayer.gd:1481-1483` does; `metadata_for` alone omits `strike_warp`. Earlier incomplete metadata attempts are excluded. No full suite for this read-only Part B.

**Claude next:** inspect the final mirrored hook/reaction stills, retain visual review OPEN, and send this source uppercut to the already approved offline MetaHuman re-bake. Keep the source pointed-foot repair separate from the mirror repair. Neither the full-duration sole gate nor the whole fight's visual acceptance is closed.

---

## Round 1 historical evidence (superseded stop, retained measurements)

# ANIMFIX1 S224 — stopped at the uppercut route gate

**No production repair.** The task's explicit stop condition fired: the selected body08 `boxing_rear_uppercut` never visits `FightClipMirror`. The mirror bug is independently RED, but cannot be claimed as this uppercut's cause or fix. Claude needs to separate the mirrored hook/reaction repair witness from this non-mirrored uppercut witness before implementation resumes.

## Baseline and scope

- Clean `codex/animfix1` synchronized to current master `124c7e3a` before adding instruments. All measurements below use that unchanged production pipeline, not the FLYFOOT candidate branch.
- Toolkit, task, verdict, own audit sections 1/8, traps, design rules, and visual gate read. Brief/inbox completed; inbox contained old assignments, none for ANIMFIX1. The operator's explicit task remained the assignment.
- Only a red neutral test, read-only probes, evidence, this digest, and Claude's message are delivered. No mirror, retarget, fold, foot bake, pose layer, native wiring, switch, threshold, asset, or import change. Other animation branches were only read for the existing measurement helper; their worktrees were untouched.
- Task instruction taking precedence over completing the normal repair/gates: **“If that clip never goes through the mirror, SAY SO and stop there - do not claim the fix.”** This is a prerequisite-stop delivery, not task completion or visual acceptance. No HANDOFF block for this research/evidence outcome; Claude owns the status update.

## Red first

New `Godot/tests/rest_aware_mirror_test.gd` puts actual-parent neutral rotation keys for all 22 mapped joints into the current mirror, then compares all 16 paired joints to their own target rest. Both MH05 and MH08 are loaded from the real GLBs. The test is intentionally still RED; remaining motion/fold contracts are explicitly marked pending.

```text
REST_MIRROR body=05 bone=RightUpperLeg error_deg=178.263812 limit=0.5 FAIL
REST_MIRROR body=05 bone=RightToes error_deg=180.000005 limit=0.5 FAIL
REST_MIRROR body=05 bone=RightUpperArm error_deg=90.526323 limit=0.5 FAIL
REST_MIRROR body=05 bone=RightLowerArm error_deg=73.293961 limit=0.5 FAIL
REST_MIRROR body=08 bone=RightUpperLeg error_deg=178.263703 limit=0.5 FAIL
REST_MIRROR body=08 bone=RightToes error_deg=180.000005 limit=0.5 FAIL
ANIMFIX1 neutral-rest failures=28; motion/fold contracts PENDING
SUITE total=1 fails=1
```

Full red output: [red_neutral.txt](../docs/previews/animfix1/red_neutral.txt).

## Exact live route and sole readback

`animfix1_route_probe.gd` inherits the production `record_room.gd`; it observes the normal room, with no controlled move injection or pose writes. Run: seed 930093, `as_game bench1=1 pose_log=1`, fixed 30 fps, game broadcast camera. Body09 Vance / body08 Miller. The sole helper reuses FLYFOOT's three skinned-vertex plane measurement, adding distinct/non-collinear marker assertions. It recomposes the live locals so stale headless globals are not mistaken for a pose.

All seven body08 rows select `boxing_rear_uppercut` from `res://assets/anim/c223/mixamo_pipeline_a/Boxing_Back_Hand_Uppercut.glb`. All report `binding_mirror=false`, `reaction_mirror=false`, `folded=true`. Live clip time spans 0.504651–0.800629 s.

| Fight time s | Clip time s | Right sole at animation_sample deg | Right sole after draw deg | After-draw roll deg |
|---|---|---|---|---|
| 38.225000 | 0.504651 | 61.665912 | 45.383113 | 30.335172 |
| 38.258333 | 0.554395 | 60.769600 | 48.341408 | 29.840219 |
| 38.291667 | 0.604360 | 75.461187 | 68.589245 | 54.309494 |
| 38.325000 | 0.654065 | 79.965089 | 80.695140 | -64.090855 |
| 38.358333 | 0.703362 | 77.436457 | 77.808620 | -46.364192 |
| 38.391667 | 0.752225 | 59.934213 | 59.934193 | 22.406639 |
| 38.425000 | 0.800629 | 45.912412 | 45.912398 | 30.958720 |

This independently reproduces a severe excursion on today's master, but is **not** the older candidate's 87.638-degree result. Three after-draw samples exceed 55 degrees; all seven exceed 12 degrees absolute roll. Plane tilt is unsigned 0–90 degrees in skeleton space; this is not signed anatomical pitch, an upside-down-sole detector, or proof that transient SkeletonModifier outputs equal these recomposed locals.

Construction-route readback and limits:

| Boundary | Evidence |
|---|---|
| Source | Actual selected source above; its GLB has zero meshes. A source skinned sole plane cannot be measured directly from it. No bone-line substitute is reported. |
| Retarget | `retarget=true`; `_graft_retargeted` calls `retarget_clip` at FightStagePlayer.gd:2344. No isolated construction-pose number collected before the stop. |
| Mirror | **Not visited.** Binding has no mirror flag (FightClipBinding.gd:87–93); call at FightStagePlayer.gd:2353 is guarded by that flag. The second call at :2399 requires a `react_` role, which this is not. |
| Fold / foot bake | Live animation has `mh_rest_folded=true`; binding requests `plant_skin_floor=true`. Those construction outputs were not isolated after the mirror-bypass stop. Their correctness is not asserted. |
| Runtime sample / after draw | Measured above. These are two observable playback boundaries, not substitutes for the missing construction-stage measurements. |

Evidence: [route.json](../docs/previews/animfix1/route.json), [red_route.txt](../docs/previews/animfix1/red_route.txt). Full local engine log: `E:/FightCamp/tmp/animfix1/route_engine.log`. No SCRIPT ERROR or engine ERROR lines; existing source-loader warnings remain. Recorder exited 0 and produced 14 route rows (both fighters × seven frames).

## Opened baseline stills — RED, not acceptance

Both were saved by `still_framing.gd.save_if_framed`, with `STILL_FRAMING OK`, `shot=broadcast`, `err=0`. Both were opened with the file image tool; nothing displayed on the operator's screens.

### [Guard, 0.525 s](../docs/previews/animfix1/red_guard.png)

1. Gap: clearly separated, roughly a full step apart; no body contact.
2. Noses: both generally face the opponent, with downward head tilt.
3. Wrists: glove/forearm lines visibly bend; not a neutral-wrist pass.
4. Feet: wide bent-knee stance; feet look pointed/rolled and unevenly planted. A still cannot prove absence of sliding.
5. Defect: baseline visibly remains wrong; this is not a repaired guard.
6. Bodies: MH09 Vance in red trunks; MH08 Miller in purple. Both heads and all feet are within the frame.

### [Uppercut window, 38.225 s](../docs/previews/animfix1/red_uppercut.png)

1. Gap: torsos crowd/touch with substantial arm/body overlap; no clean visible separation.
2. Noses: both generally aim toward one another at very close range.
3. Wrists: one glove extends behind/above the heads; overlapping arms obscure the other wrist lines. No wrist alignment pass.
4. Feet: Miller's rear leg extends far behind with a pointed foot; the fighters' stance projections overlap. No sliding inference from one still.
5. Defect: the uppercut remains visibly distorted, despite bypassing the mirror. This is the start of the requested window, not its 80.70-degree peak.
6. Bodies: MH09 Vance / MH08 Miller; both head-to-feet within the game camera.

The requested rear-hook/mirrored-reaction red stills were not captured by the natural-role selector during this run. No replacement move was injected after the stop condition. No green stills or real-footage comparison, motion acceptance, Claude review, or operator closure is claimed.

## Gates and next action

```text
CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0 time=0s  # neutral test
CHECK total=2 fails=0 autoload_refs=0 autoload_warnings=0 time=0s  # probes
SUITE total=1 fails=1  # expected neutral-rest RED, before any repair
```

Watchdog was GREEN before each Godot invocation. GUI executable only; headless parse/test and hidden-desktop capture via `godot_hidden.ps1`. Sandbox access to Git metadata and the installed Godot needed approved escalations; no approval rejection, visible window, or unrelated process termination occurred.

Not run after the explicit stop: rest-aware mirror implementation; fold-once repair; signed knee/wrist and double-mirror/control/reaction tests; affected-system suite; 2 seeds × 4 bodies × 60 s sole gate; green guard/hook/reaction stills. The task's two-job affected-suite instruction was never reached; the single red test used one job.

**Claude next:** revise the ANIMFIX1 witness to an actually mirrored hook/reaction, explicitly permitting that independent repair to proceed despite the non-mirrored uppercut. Route the uppercut's construction-stage source/retarget/fold/foot investigation separately. Do not merge this expected-red test as a completed fix or mark ANIMFIX1 accepted.
