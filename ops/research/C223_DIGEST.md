Boxing EXACT-that-PASSED: 10/36 -> 11/36

## S120 (Claude, Codex out of credits - operator: "you take all the 3d animation") - variants by ADDITIVE POSE LAYER

**New pipeline step (what an animator does when the library has the base punch but not its variant, Q57 row 4 / R124):**
`FightClipPoseLayer.gd` keys a local-space rotation offset (and an optional hips drop as a fraction of hip height) over a
window whose weight is exactly 0 at both ends, so the certified base's joins are untouched. Applied after the strike warp
and root hold, BEFORE the foot-plant bake (the plant still owns the feet). Binding field `pose_layer`. Axes were measured,
not guessed: `tools/s120_axis_probe.gd` (forward +Z; Spine +x leans forward, +y turns the rear shoulder forward, +z side-bends).
**Strike warp `pre` span** (`FightClipRetarget.strike_phase_warp`): an optional wind-up span before the strike span, so the
anticipation is shortened without speeding the snap; `strike_source_time` inverts both. Needed because onset x peak is fixed
by the hand's travel: one uniform warp could not put the rear hook's body version inside both 132-586 ms and 8-14 m/s.

**boxing_rear_hook_body CERTIFIED** - base: the certified orthodox rear hook (Mixamo Boxing_Back_Hand_Hook; RamsterZ has no
orthodox rear hook - its mirror swaps stance). Warp main 0.55..1.0505 x0.64, pre 0..0.55 x0.48; layer: Hips drop 0.035,
Spine [16,8,0], RightUpperArm [24,0,0], window 0.05 / 0.4 / hold 0.4 / 1.35. Production `play_role` witness
`docs/previews/c223/s120_rhb_bound.json`, errors 0, four generated legal rows:

| Body | Peak m/s (8-14) | Onset-impact ms (132-586) | Target gap cm (<=2) | Slip cm (<=2) | Pops | Whole/guard |
|---|---:|---:|---:|---:|---:|---|
| welter_a | 12.77 | 533.3 | 0.06 | 0.35 | 0 | yes |
| welter_b | 12.20 | 533.3 | 0.93 | 0.37 | 0 | yes |
| heavy_c | 13.48 | 566.7 | 0.35 | 0.39 | 0 | yes |
| heavy_d | 13.12 | 566.7 | -0.42 | 0.39 | 0 | yes |

Stills opened first (game angle + a side view, `yaw=100`, `s120_rhb_side_*`): rear glove drops to the ribs, knees bend, trunk
low at contact, recovers to guard. Trials on record: t0 (base, no layer: gap 4.2 cm), t1-t3 (arm axis found: -x moved the
glove away), t4-t7 (held offsets), warps 0.56/0.58/0.60/0.62/0.66 (speed vs timing trade), pre 0.45 (feet slip 2.4-2.7 cm:
the wind-up cannot be cut that far). Thin margins noted: head-to-head min body gap 0.001 m at contact (overlap rule passes).

**Defects fixed on the way (all from C223 merges that ran narrow subsets):** three dead aliases (boxing_cross / lead_hook /
rear_hook -> old clips; direct bindings already won); `boxing_one_two` never played with strikes_play_whole OFF (silent claim)
- the splice runs in both modes; clip_phases entries for both uppercuts were missing and rear_hook_body's described the old
LEFT-hand RamsterZ clip (effector now hard-coded for the body punches); tests taught the C223 graft loop and sequences.

**Body-shot aim (live contact helper, FightWorldLiveScreen._stop_landed_hand_contact) FIXED:** it aimed every landed body
punch at the torso surface nearest the attacker's SHOULDER, so body jabs / body hooks / shovels were pulled to chest height.
It now aims at the clip's OWN fist at its certified contact time (`fist_skel`), latched once per strike in the foe's space.
Two rejected versions on record: live glove every frame (chased the glove: body hook heavy_c 14.5 m/s) and glove latched at
aim-window start (caught straight/rising punches mid-flight: body jab at 2.6-2.7 m). Re-certified under it, four legal rows
(`s120_bodyaim.json`, `s120_bh.json`): boxing_jab_body PASS (6.6-7.2 m/s, contact 2.22-2.34); boxing_rear_hook_body PASS;
boxing_body_hook PASS after its warp 0.60 -> 0.66 (12.3-13.4 m/s, 617 ms <= 657). clip_phases for body hook / shovel rewritten
in the warped clock (the old entries were the RamsterZ clip's 1.0 s window).
**boxing_shovel_hook stays NEAR:** solved layer (tools/s120_layer_solve.gd: lead-side dip 20, arm tuck 20) lands at liver
height and passes every mechanical row (10.0-11.5 m/s), but the side stills show a wide lunge with the arm straight at
0.18 s - a lunging body punch, not the elbow-tucked rising shovel. Needs an elbow-in, rising forearm layer (next).

**Next moves (owned bases, RamsterZ first):** shovel hook (RamsterZ hook + elbow-in, rising layer), up-jab (RamsterZ jab +
lowered lead hand in the wind-up), overhand (RamsterZ straight + side bend and over-the-top arc; H2H_Haymaker REJECTED on
sight: a windmill that ends at the waist), inside uppercut (compact layer on the certified uppercut).


## Run 9 (S119) - strike-phase clock, source-time contact, fixed clear fixtures

### Run 10 continuation (S119) - RamsterZ source preference

Kickboxing EXACT-that-PASSED: **0/20 -> 0/20**. Run 10 starts from the merged branch head; no rebase. The explicit task intake supersedes generic mailbox/rebase and asset-package intake. No excluded status/handoff files were read or edited.

**boxing_jab:** production `play_role` witness now uses owned RamsterZ `H2H_JabInPlace.FBX`, Unity Asset Store EULA, embedded game use. Strike-only source span **0.20..0.25 s x 2.3**, unchanged **0.583333 s** recovery. Horizontal root travel is held before the existing foot bake and matched guards. No threshold changed. This is a source replacement, not an additional catalogue move.

The first strike-warp trial passed the two welters but slid **23.08 cm** on each heavy body. The existing root-hold pipeline removed this failure; it does not move the receiver per frame. Audition `run10_jab_root.json` passed all four. All four `run10_jab_bound_owned_jab_*.png` sheets were opened before measuring `run10_jab_bound.json`: lead straight, shoulder turn, retraction and guard return. The bound run uses ordinary guard warmup, without priming the incoming idle phase. Source metadata in `clip_phases.json` now describes the RamsterZ source; the production warp supplies its retimed contact and duration.

| Move | Body | Peak m/s (4.5..9.5) | Onset-impact ms (100..405) | Slip cm (<=2) | Result |
|---|---|---:|---:|---:|---|
| boxing_jab | A | 5.498 | 266.7 | 0.00300 | PASS |
| boxing_jab | B | 6.209 | 266.7 | 0.00593 | PASS |
| boxing_jab | C | 6.042 | 266.7 | 0.00556 | PASS |
| boxing_jab | D | 6.427 | 266.7 | 0.00315 | PASS |

Each PASS also requires whole play, guard return, zero pops, floor clearance, target reach, non-overlap, both joins and unchanged recovery. All 20 reference seam mutants remain rejected. Speed is comfortably inside the band, not fitted to an edge. JSON `accepted:false` retains the harness convention that visual review is recorded here.

**RamsterZ-sourced certified moves:** boxing_jab, boxing_cross, boxing_lead_hook, boxing_one_two, boxing_double_jab.

**boxing_one_two re-certified:** `run10_chain.json`, all four production sequence rows pass. A/B/C/D jab peaks **5.498/6.209/6.042/6.427 m/s**, cross peaks **8.509/8.312/8.981/8.858 m/s**; both strikes measure **266.7 ms** onset-impact on each body. Each has target contact, non-overlap, planted travel <=2 cm, floor clearance, unchanged per-bone joins and completion into guard. All four `run10_chain_boxing_one_two_*.png` sheets were opened first. The chain remains two real certified takes, cut at the source's half-retraction (0.783333 s), then the cross from its start. The harness can now load successive certificate files so its one fixed receiver uses the current jab reach instead of the previous Mixamo fixture. No bands or tolerances changed.

**boxing_double_jab re-certified:** the other four `run10_chain.json` rows pass. Both jab peaks are **5.498/6.209/6.042/6.427 m/s** for A/B/C/D. First/second onset-impact is **266.7/216.7 ms** on every body. Splice **0.783333 s**, second entry **0.066667 s**; two contacts occur and the second begins before full guard. Minimum second-start hand-to-guard fraction is **0.303/0.185/0.281/0.218**, rather than zero/full guard. All four double-jab sheets were opened before measurement. This recertifies the existing catalogue move and does not increase the census.

**Keep Mixamo:** boxing_jab_body. The four opened `run10_jab_trial_owned_jab_body_*.png` sheets do not establish a solar-plexus jab with the required knee/head level change; retiming a head jab is insufficient. The two heavy mechanical rows also fail slip in that trial. `Long_Body_Jab` remains bound.

Other RamsterZ source checks (`run10_sources_*.png`, generated A vs B, visual rejection before numeric certification): mirrored `owned_rear_hook` swaps the stance; `owned_lead_uppercut` and its mirrored rear candidate make a broad lunging/turning action with the rear leg flung back, rather than the required orthodox uppercut; `owned_body_hook` retains the head-hook trajectory. Keep the certified Mixamo rear hook, both uppercuts and body hook. The Run 9 rear-hook margin of **0.001175 m/s** remains explicitly a limitation, not a robust body-independent certificate.

Jab validation: parse passed before testing; focused `python Godot/tools/run_tests.py --only boxing_`: **SUITE total=4 fails=0** (`run10_boxing_tests.txt`). Bound gate errors=0, seam mutants 20/20 rejected. All windowed jobs used the hidden launcher with Dummy audio; real-host watchdog checks were GREEN. The initial sandbox watchdog reading was invalid due to CIM denial; it was not used as a health result. No full suite.

Remaining-move results are appended below as each move is completed. Token telemetry: pending final session snapshot.

### Run 9 historical certificate

Run 9 certified and production-bound: **boxing_lead_hook, boxing_rear_hook, boxing_lead_uppercut, boxing_rear_uppercut, boxing_body_hook**. All five passed all four legal generated rows through `play_role`. Kickboxing remains **0/20 -> 0/20**. Each move has its own commit/push and one-line Claude notification.

The per-binding `strike_warp` maps only `from_s..to_s` by `scale`. Before onset the clock is unchanged; after impact every key is translated by the removed strike duration, preserving recovery duration and poses. Exact boundary keys retain interpolation at both seams. The warp runs after whole-clip retarget/mirror and before foot-plant baking and matched guard authoring. Variant duration follows the resulting animation. Empty warp metadata leaves the old path unchanged.

Two consumers also need the new clock: the authored impact marker follows the warp (otherwise root holding can make the automatic target finder select the uppercut's terminal guard), and the live contact approach envelope runs in source time. Keeping the old 200 ms approach in animation time suppressed accelerated hooks. Its post-impact recovery remains 1:1. The live vendor-speed budget follows the same strike interval, with the native budget restored during recovery; the gate's speed bands are unchanged.

`hold_root_xz` holds the take's horizontal hip travel before foot planting. For those takes, the fixture starts at authored hand reach and increases separation only enough to fit the sampled whole-take head/torso capsule envelope. This is solved once before advancing the take, never by moving the receiver per frame. The ordinary target-contact row still rejects a source whose hand cannot reach that separation.

Sources remain the owned RamsterZ H2H set (Unity Asset Store EULA, embedded game use) and the operator-supplied Mixamo adapters already tracked here (Adobe Mixamo embedded-game-use licence, as recorded in Run 8). No new asset purchase or generation.

Setup corrections: the first trial mistakenly used `tripo`, selecting the older GLBs; visible reference/receiver deformation stopped that run before scoring. The generated-body trials then exposed a missing audition `guard=Bouncing_Boxing_Idle` option. The harness now defaults non-reference auditions to that guard. `run9_hook_trial_*`, `run9_hook_generated*`, `run9_base_trial*`, and `run9_marker_trial*` are diagnostic trials, not certification evidence. Final evidence uses generated A/B welter (66.0/66.5 kg) and C/D heavy (100/108 kg), both directions.

Production-path regression: the first bound occurrence test failed 10 assertions because the old technique list omitted the new hooks and the metadata projection dropped `strike_warp`/`hold_root_xz`. The player now includes warped bindings in its graft list and forwards these bake fields directly from the binding row. The corrected occurrence test passes 336 checks: each named warped role is grafted, plays itself, reaches the retimed marker, and finishes in the boxing guard. Binding accessors and unrelated technique lists remain untouched.

| Move | Source | Strike-only source interval s | Scale | Recovery s (unchanged) |
|---|---|---:|---:|---:|
| boxing_lead_hook | owned H2H_HookPunch_InPlace | 0.066667..0.333333 | 0.65 | 0.666667 |
| boxing_rear_hook | Boxing_Back_Hand_Hook | 0.000000..1.050500 | 0.57905 | 1.116167 |
| boxing_lead_uppercut | Boxing_Lead_Hand_Uppercut | 0.016667..0.755200 | 0.75 | 1.444800 |
| boxing_rear_uppercut | Boxing_Back_Hand_Uppercut | 0.066667..0.722400 | 0.80 | 1.477600 |
| boxing_body_hook | Mid_Hook_Punch_To_The_Body | 0.083333..1.019200 | 0.60 | 1.380800 |

Visual review: all 28 initial bound `run9_bound_<candidate>_<rig>.png` sheets were opened before their measurement; the separate final rear-hook review is recorded below. Reviewed guard/load/contact/retraction/guard on each legal generated fighter: horizontal bent-elbow lead/rear hook, rising lead/rear uppercut with knee/hip drive, and a separate level-changing hook to the ribs. The receiver remains fixed. These are the bound `play_role` takes, entered from ordinary guard warmup without manually seeking the incoming idle phase.

Reproduce the bound witness through `Tools/godot_hidden.ps1 --path Godot --script tools/c223_production_gate.gd -- plant phase live_contact bound render stills_only clips=owned_lead_hook,boxing_rear_hook,boxing_lead_uppercut,boxing_rear_uppercut,boxing_body_hook,whole_warp_mutant prefix=run9_recheck_ report=run9_recheck_stills.json`; open the PNGs; then repeat with `--headless`, without `render stills_only prefix=...`, and `report=run9_recheck.json`. Reference jab and its seam mutants are included automatically. Do not pass `tripo`.

Final bound results: `run9_bound.json` for lead hook, both uppercuts and body hook; `run9_rear_final.json` for rear hook. Both reports have errors=0 and 20/20 seam mutants rejected. All twenty final move/body rows pass. The rear-hook failures retained in the first report are superseded only by the separately reviewed and measured final rear report. Every PASS below also passes whole play, guard return, zero pops, foot/knee/skin floor, planted travel, target reach, non-overlap, both joins, and the new unchanged-recovery row. JSON `accepted:false` retains its manual-visual-review convention; this digest records that review.

| Move | Body | Peak m/s | Onset-impact ms | Slip cm <=2 | Target gap cm <=2 | Body gap m >=0 | Result |
|---|---|---:|---:|---:|---:|---:|---|
| boxing_lead_hook | A | 8.414 | 166.7 | 0.54779 | -0.102 | 0.2709 | PASS |
| boxing_rear_hook | A | 13.2620 | 583.3 | 1.01961 | -0.000 | 0.0010 | PASS |
| boxing_lead_uppercut | A | 7.688 | 516.7 | 1.08638 | -0.508 | 0.0010 | PASS |
| boxing_rear_uppercut | A | 9.955 | 566.7 | 0.36384 | -0.000 | 0.1957 | PASS |
| boxing_body_hook | A | 12.891 | 566.7 | 0.43192 | -0.077 | 0.1648 | PASS |
| boxing_lead_hook | B | 8.922 | 166.7 | 0.52344 | -0.049 | 0.2698 | PASS |
| boxing_rear_hook | B | 12.6726 | 550.0 | 0.97415 | -0.000 | 0.0010 | PASS |
| boxing_lead_uppercut | B | 8.319 | 516.7 | 1.10909 | 0.000 | 0.0010 | PASS |
| boxing_rear_uppercut | B | 10.148 | 500.0 | 0.34759 | -0.000 | 0.1659 | PASS |
| boxing_body_hook | B | 12.392 | 566.7 | 0.41649 | -0.055 | 0.1503 | PASS |
| boxing_lead_hook | C | 8.917 | 166.7 | 0.57876 | -0.104 | 0.2706 | PASS |
| boxing_rear_hook | C | 13.9988 | 583.3 | 1.07605 | -0.000 | 0.0010 | PASS |
| boxing_lead_uppercut | C | 8.186 | 516.7 | 1.04450 | -0.378 | 0.0010 | PASS |
| boxing_rear_uppercut | C | 10.513 | 566.7 | 0.38406 | -0.000 | 0.1892 | PASS |
| boxing_body_hook | C | 13.309 | 566.7 | 0.45488 | -0.132 | 0.1383 | PASS |
| boxing_lead_hook | D | 9.323 | 166.7 | 0.56301 | -0.071 | 0.2753 | PASS |
| boxing_rear_hook | D | 13.6304 | 583.3 | 1.04779 | -0.000 | 0.0010 | PASS |
| boxing_lead_uppercut | D | 8.614 | 516.7 | 1.01702 | 0.000 | 0.0010 | PASS |
| boxing_rear_uppercut | D | 10.629 | 566.7 | 0.37384 | -0.000 | 0.1745 | PASS |
| boxing_body_hook | D | 13.127 | 566.7 | 0.44512 | -0.122 | 0.1372 | PASS |

Whole-clip mutant: all four rows fail `recovery_clock` despite passing the original mechanical rows (peak 10.689/11.086/11.224/11.728 m/s; 150 ms onset-impact). It shortens the source recovery from 0.666667 s to 0.433333 s. No warped take receives a speed-only certificate. The reference jab calibration and five seam injections per fighter are unchanged.

Rear-hook iteration and limitation: bound `.066667..1.0505 x .60` measured 600-633.3 ms and failed the unchanged 586 ms ceiling, although the phase-primed audition passed. Including the take's initial anticipation (`0..1.0505 x .58`) reduced it to 566.7-600 ms; A/C/D still failed timing. The final `x .57905` trial passed 550-583.3 ms and 12.6726-13.9988 m/s. **Heavy C has only 0.001175 m/s below the 14 m/s ceiling; this is a narrow four-fixture, 60 Hz certificate, not evidence of margin on other bodies or clocks.** No band or measurement rule was loosened. Its 1.116167 s recovery is unchanged. All eight `run9_rear_final_*.png` sheets were opened before `run9_rear_final.json`; the rejected intermediate report is retained as `run9_rear_bound.json`.

Stop/source gap: **boxing_cross_body**, the next requested catalogue move. The existing whole owned head cross lacks the required body level change/target line (Run 8 review); current `Boxing_Body_Jab_Cross_Medium` is two punches, not a standalone cross. No new passable whole body-cross source was established. It remains uncertified; no head relabel or combo slice is promoted. The remaining 26 boxing moves and all 20 kickboxing moves are not claimed complete.

Delivery order: lead hook `150d6503`, lead uppercut `96f50304`, rear uppercut `eaed5f99`, body hook `1a39d236`, then the rear-hook commit containing this final digest. The first four were published while the rear-hook bound retry was being resolved.


Validation: parse passed for every touched script before testing. Final focused `python Godot/tools/run_tests.py --only boxing_`: `SUITE total=4 fails=0`; binding occurrence `336/336`, warp/join `254/254`. A prior sandbox run reported the 10 real binding assertions above plus a certificate-store environment error; the corrected unsandboxed focused run passed. No full suite. Every windowed run uses the hidden launcher with Dummy audio. Watchdog health was checked outside the sandbox after its CIM access denial produced an invalid first reading; render checks were GREEN. The first bound measurement check was AMBER (RAM 85%, C: 34.8 GB), not RED; both later rear-hook checks were GREEN. Each capture completed and was reviewed before its corresponding measurement; the focused suite ran alongside the later rear trials.

The generic rebase/mailbox intake and generic asset-package workflow are set aside for the explicit Run 9 brief and existing in-engine pipeline. No rebase, master push, HANDOFF edit, video, executable, or Kimodo. The local messaging CLI requires `--topic C223 --body` rather than the brief's `--task`/positional spelling; this preserves the requested one-line per-move notification. Session telemetry snapshot 2026-09-28T12:37:02.926Z: cumulative input 20,862,970 (cached 20,464,256; uncached 398,714), output 70,375 (reasoning subset 32,763), total 20,933,345 tokens. These are the session's reported cumulative counters, including repeated cached context; final delivery overhead follows this snapshot.


# Run 7 - cross certified on generated legal pairs

## Run 8 continuation (S118) - body jab and both chains certified; matched joins fixed

Boxing **2/36 -> 5/36** at this push: jab, cross, **boxing_jab_body**, **boxing_one_two**, and **boxing_double_jab**. Kickboxing remains 0/20. Both chains are production-bound and certified. Generated legal pairs only: A/B welter 66.0/66.5 kg; C/D heavy 100/108 kg, both directions, dressed game-default fighters.

### What changed

- Re-gated the Run 7 sources with S118 timing bands from d6372beb. Timing now clears both lead-hook takes on all four bodies; no additional full certificate follows from that correction alone. `run8_before.json`: 36/36 remaining source rows still failed J, errors=0, 20/20 seam mutants rejected.
- The per-take entry/exit guard phases already existed. Their cubic endpoint weight preserved velocity but introduced an acceleration change; the scalar inertializer also clamped velocity travelling away from the incoming pose. Matched takes now use quintic endpoint weights and the existing velocity-preserving Dead Blending implementation. Guard phase, native duration, full punch, foot-plant bake and acceptance limits remain. Endpoint authoring is idempotent. Mid-recovery strike-to-strike blends use a quintic weight too; chain certification is separate.
- `run8_final.json`: all 40 source rows pass both J seams on all four bodies; reference calibration is unchanged and 20/20 seam mutants still fail. These are source auditions, not promotions of the hooks or uppercuts.
- Long_Body_Jab passes all four and is the actual body-jab binding. Its sheets show a lead straight to the torso, knee bend, head off line, opposite hand guarding, and return. Adobe Mixamo source already supplied by the operator and tracked; same embedded-game-use licence as the prior adapter receipt. No new purchase or model generation.

### Bound-path certificate and regressions

`run8_bound.json` uses actual production bindings, no incoming-idle priming, the take's authored reach and the live head/body contact helper. All twelve move/body rows pass whole-play, guard return, zero pop events, floor, non-overlap, contact, peak speed, timing, planted travel and per-bone joins. errors=0; 20/20 seam mutants rejected. All twelve `run8_bound_<candidate>_<rig>.png` move sheets were opened before measurement.

| Move | Body | Peak m/s | Onset-impact ms | Slip cm <=2 | Skin cm | Target gap cm <=2 | Body gap m >=0 | Gate |
|---|---|---:|---:|---:|---:|---:|---:|---|
| boxing_cross | A | 10.069 | 250.0 | 0.00062 | 0.000 | -0.000 | 0.358 | PASS |
| boxing_jab | A | 5.783 | 333.3 | 0.00707 | 0.000 | -0.187 | 0.303 | PASS |
| boxing_jab_body | A | 5.985 | 383.3 | 0.01404 | 0.000 | -0.010 | 0.293 | PASS |
| boxing_cross | B | 9.801 | 250.0 | 0.00118 | 0.000 | 0.000 | 0.346 | PASS |
| boxing_jab | B | 5.790 | 333.3 | 0.00989 | 0.000 | -0.053 | 0.296 | PASS |
| boxing_jab_body | B | 5.674 | 383.3 | 0.01254 | 0.000 | -0.008 | 0.272 | PASS |
| boxing_cross | C | 10.633 | 250.0 | 0.00028 | 0.000 | 0.000 | 0.380 | PASS |
| boxing_jab | C | 6.164 | 350.0 | 0.02004 | 0.000 | -0.180 | 0.320 | PASS |
| boxing_jab_body | C | 6.226 | 383.3 | 0.02511 | 0.000 | -0.016 | 0.288 | PASS |
| boxing_cross | D | 10.423 | 250.0 | 0.00103 | 0.000 | 0.000 | 0.377 | PASS |
| boxing_jab | D | 6.142 | 350.0 | 0.02098 | 0.000 | -0.107 | 0.324 | PASS |
| boxing_jab_body | D | 6.050 | 383.3 | 0.01914 | 0.000 | -0.013 | 0.289 | PASS |

### Re-gated sources - all four rows, no threshold changes

J=per-bone join; V=peak-fist band; T=onset-impact band; B=body overlap. Hooks require 8-14 m/s, uppercuts 6.5-13.5, body jabs 4.5-9.5. Timing: lead hook/body hook 132-657 ms, rear hook 132-586, lead uppercut 71-627, rear uppercut 71-606, body jab 100-405. Every final row below passes J, planted travel <=2 cm, zero foot/knee/skin penetration, zero pop, whole-play and idle return. Before = fresh Run 8 re-gate with corrected bands but old joins. Final = revised joins. Sheets: `run8_before_*` and `run8_final_*`; named motions were visually reviewed before scoring.

| Candidate | Body | Before failures | Peak m/s | Onset-impact ms | Slip cm | Minimum body gap m | Final failures |
|---|---|---|---:|---:|---:|---:|---|
| owned_lead_hook | A | J,V | 7.131 | 266.7 | 0.3130 | 0.275 | V |
| boxing_lead_hook | A | J,V | 5.059 | 450.0 | 0.0328 | 0.125 | V |
| boxing_rear_hook | A | J,B,T | 8.181 | 983.3 | 0.1432 | -0.114 | B,T |
| boxing_lead_uppercut | A | J,B,T | 6.504 | 733.3 | 0.0556 | -0.028 | B,T |
| boxing_rear_uppercut | A | J,T | 7.985 | 650.0 | 0.2169 | 0.195 | T |
| boxing_jab_body | A | J,T | 4.677 | 383.3 | 0.0714 | 0.312 | PASS |
| body_jab_short | A | J | 5.060 | 316.7 | 0.0057 | 0.366 | PASS |
| body_jab_long | A | new audition | 5.985 | 383.3 | 0.0132 | 0.293 | PASS |
| boxing_body_hook | A | J,V,T | 7.678 | 933.3 | 0.1404 | 0.150 | V,T |
| body_hook_short | A | J,V,T | 5.656 | 816.7 | 0.0353 | 0.109 | V,T |
| owned_lead_hook | B | J,V | 7.437 | 266.7 | 0.2949 | 0.274 | V |
| boxing_lead_hook | B | J,V | 5.362 | 450.0 | 0.0313 | 0.126 | V |
| boxing_rear_hook | B | J,B,V,T | 7.817 | 983.3 | 0.2278 | -0.118 | B,V,T |
| boxing_lead_uppercut | B | J,B,T | 6.741 | 733.3 | 0.0849 | -0.034 | B,T |
| boxing_rear_uppercut | B | J,T | 8.116 | 650.0 | 0.3271 | 0.166 | T |
| boxing_jab_body | B | J,V,T | 4.255 | 383.3 | 0.0310 | 0.264 | V |
| body_jab_short | B | J | 5.091 | 316.7 | 0.0063 | 0.338 | PASS |
| body_jab_long | B | new audition | 5.674 | 383.3 | 0.0125 | 0.272 | PASS |
| boxing_body_hook | B | J,V,T | 7.392 | 933.3 | 0.1376 | 0.139 | V,T |
| body_hook_short | B | J,V,T | 5.567 | 816.7 | 0.0353 | 0.098 | V,T |
| owned_lead_hook | C | J,V | 7.499 | 266.7 | 0.3265 | 0.275 | V |
| boxing_lead_hook | C | J,V | 5.333 | 450.0 | 0.0378 | 0.120 | V |
| boxing_rear_hook | C | J,B,T | 8.635 | 983.3 | 0.3313 | -0.120 | B,T |
| boxing_lead_uppercut | C | J,B,T | 6.862 | 733.3 | 0.0220 | -0.045 | B,T |
| boxing_rear_uppercut | C | J,T | 8.430 | 650.0 | 0.3805 | 0.189 | T |
| boxing_jab_body | C | J,T | 4.761 | 383.3 | 0.0703 | 0.286 | PASS |
| body_jab_short | C | J,V | 2.956 | 316.7 | 0.0053 | 0.372 | V |
| body_jab_long | C | new audition | 6.226 | 383.3 | 0.0141 | 0.288 | PASS |
| boxing_body_hook | C | J,V,T | 7.890 | 933.3 | 0.1515 | 0.118 | V,T |
| body_hook_short | C | J,V,T | 5.867 | 816.7 | 0.0365 | 0.094 | V,T |
| owned_lead_hook | D | J,V | 7.859 | 266.7 | 0.3212 | 0.280 | V |
| boxing_lead_hook | D | J,V | 5.694 | 450.0 | 0.0337 | 0.128 | V |
| boxing_rear_hook | D | J,B,T | 8.408 | 983.3 | 0.1016 | -0.119 | B,T |
| boxing_lead_uppercut | D | J,B,T | 7.035 | 733.3 | 0.0189 | -0.049 | B,T |
| boxing_rear_uppercut | D | J,T | 8.510 | 650.0 | 0.3705 | 0.174 | T |
| boxing_jab_body | D | J,T | 4.594 | 383.3 | 0.0684 | 0.284 | PASS |
| body_jab_short | D | J,V | 2.836 | 316.7 | 0.0059 | 0.371 | V |
| body_jab_long | D | new audition | 6.050 | 383.3 | 0.0136 | 0.289 | PASS |
| boxing_body_hook | D | J,V,T | 7.835 | 933.3 | 0.1443 | 0.126 | V,T |
| body_hook_short | D | J,V,T | 5.805 | 816.7 | 0.1780 | 0.090 | V,T |

Stopped sources: lead hook (owned and Mixamo) is below speed floor; orthodox Boxing_Back_Hand_Hook is too late and overlaps, with B also below speed; lead uppercut is late and overlaps; rear uppercut is late. No whole-clip stance mirror is certified as a rear hook. Body hooks remain slow/late. Mid_Body_Jab fails speed on B, Short_Body_Jab on C/D; Long_Body_Jab clears all four. No head cross is relabelled as a body cross. The tested head-cross reuse lacks the required body-shot level/target line, and the available Body_Jab_Cross_Medium is a two-strike source, not a standalone body cross.

### Production one-two certificate

`play_role("boxing_one_two")` now chains the certified jab and rear cross. The player owns the jab half-retraction cut (0.7667 s), preserves the ordinary interruption guard and queues the matched idle after the cross. The receiver remains fixed at the shorter component reach; the previous jab-maximum fixture put the cross outside its range. No motion scaling or gate threshold changed. Bound sheets were reviewed before measurement. The bound witness calls the public role once; it does not force a component switch.

| Sequence | Body | Jab peak m/s | Cross peak m/s | Jab / cross onset ms | Slip cm | Skin cm | All gates |
|---|---|---:|---:|---|---:|---:|---|
| one-two | generator_welter_a | 5.079 | 10.069 | 333.3 / 266.7 | 0.0215 | 0.000 | PASS |
| one-two | generator_welter_b | 5.097 | 9.801 | 333.3 / 266.7 | 0.0186 | 0.000 | PASS |
| one-two | generator_heavy_c | 5.416 | 10.633 | 350.0 / 266.7 | 0.0167 | 0.000 | PASS |
| one-two | generator_heavy_d | 5.395 | 10.423 | 350.0 / 266.7 | 0.0149 | 0.000 | PASS |

Evidence: `run8_one_two_bound.json` (4/4 certificates, errors=0), `run8_one_two_bound_*.png`. Component occurrence is asserted in boxing_idle_binding_test. Body-jab certificate was pushed as 5e2b100e.

### Production double-jab certificate

`play_role("boxing_double_jab")` chains the certified jab twice. It cuts after the first contact at half retraction (0.7667 s), enters the second take at 0.1667 s and completes its 0.15 s smooth blend before the source speed peak. The second fist remains 25-35% away from terminal guard during that handoff, then fires: no full reset masquerading as a double-jab. Same source speed and punch amplitude; no mirrored stance or substitute combination file.

Earlier variants were rejected: entering at 0.2167 s smoothed away the second jab peak (3.747 m/s); a 0.075 s whole-body blend restored speed but failed J. Advancing the incoming phase earlier retained the full smooth blend and the authored acceleration. The public bound witness matches the audition and forces no component change. Both contacts and interruption refusal are asserted by the focused test.

| Sequence | Body | First / second peak m/s | First / second onset ms | Slip cm | Skin cm | Minimum guard-distance fraction | All gates |
|---|---|---|---|---:|---:|---:|---|
| double-jab | generator_welter_a | 5.783 / 5.073 | 333.3 / 200.0 | 1.5571 | 0.000 | 0.350 | PASS |
| double-jab | generator_welter_b | 5.790 / 5.087 | 333.3 / 200.0 | 1.4888 | 0.000 | 0.250 | PASS |
| double-jab | generator_heavy_c | 6.164 / 5.408 | 350.0 / 200.0 | 1.6445 | 0.000 | 0.330 | PASS |
| double-jab | generator_heavy_d | 6.142 / 5.389 | 350.0 / 200.0 | 1.6012 | 0.000 | 0.283 | PASS |

Evidence: `run8_double_bound.json` (4/4 certificates, errors=0), `run8_double_bound_*.png`, visually reviewed before scoring. One-two certificate pushed as 3ec2e112; this delivery adds double-jab. No other catalogue row is promoted.

### Validation and delivery state

Parse gates passed for all touched scripts (base CHECK total=5 fails=0; sequence CHECK total=4 fails=0; final binding/test CHECK total=2 fails=0). Final focused SUITE total=2 fails=0 (boxing_idle_binding_test, boxing_join_discontinuity_test). Endpoint tests now check actual per-take guard rotations/positions and idempotence. No full suite. Windowed jobs used Tools/godot_hidden.ps1 with Dummy audio. PC watchdog GREEN. Final base/bound reports have errors=0 and no SCRIPT ERROR/engine ERROR in their logs; FBX warnings and teardown leaks remain non-certificate noise.

Scope incident: a malformed quoted `rg` command broadened a search and returned excluded-file snippets, including HANDOFF.md. The search was stopped, the snippets were not used for implementation, and subsequent reads used explicit named paths. No excluded file was edited.

The generic rebase intake is set aside: Claude prepared c7b3fce9 by merging master; d6372beb is verified an ancestor. No rebase of already-merged history, master push, HANDOFF edit, video, executable or Kimodo.

Tokens used at final evidence snapshot (2026-09-28T09:42:26.901Z, cumulative API telemetry): total 17,211,373; input 17,154,493, including 16,851,200 cached; output 56,880, including 25,614 reasoning. Uncached input plus output: 360,173. Repeated cached context is included in API totals; final commit/message overhead follows.

### Original Run 7 evidence retained

Kickboxing remains 0/20. The whole owned RamsterZ H2H_StraightPunchInPlace is now the exact boxing_cross binding. Four bound-path sheets were opened before measurement: rear right straight, hip turn and rear heel pivot, left glove guarding, recoil into the shared Bouncing_Boxing_Idle. The source has a pronounced dip; it remains a rear straight, not an uppercut. No retiming, scaling, threshold relaxation or source slicing.

## Cross certificate and jab regression

`run7_bound.json` is the final production-binding witness, without priming the incoming idle. Generated welter a/b (66.0/66.5 kg) and heavy c/d (100/108 kg), both directions. Each row passes whole-play, idle return, zero pop events, zero foot/knee/skin penetration, non-overlap, head contact, speed, timing, planted-foot travel and per-bone join discontinuity. Reference calibration remains unchanged; all 20/20 seam mutants are rejected. Preview prefix: `run7_bound_owned_cross_`.

| Move | Striker (receiver is its legal partner) | Fist m/s | Onset-impact ms | Slip cm | Skin cm | Head gap cm | Body gap m | Gate |
|---|---|---:|---:|---:|---:|---:|---:|---|
| boxing_cross | generator_welter_a | 10.069 | 266.7 | 0.00105 | 0.000 | -0.000 | 0.358 | PASS |
| boxing_jab | generator_welter_a | 5.783 | 366.7 | 0.00914 | 0.000 | -0.187 | 0.303 | PASS |
| boxing_cross | generator_welter_b | 9.801 | 266.7 | 0.00103 | 0.000 | 0.000 | 0.346 | PASS |
| boxing_jab | generator_welter_b | 5.790 | 366.7 | 0.00786 | 0.000 | -0.053 | 0.296 | PASS |
| boxing_cross | generator_heavy_c | 10.633 | 266.7 | 0.00054 | 0.000 | 0.000 | 0.380 | PASS |
| boxing_jab | generator_heavy_c | 6.164 | 366.7 | 0.02004 | 0.000 | -0.180 | 0.320 | PASS |
| boxing_cross | generator_heavy_d | 10.423 | 266.7 | 0.00100 | 0.000 | 0.000 | 0.377 | PASS |
| boxing_jab | generator_heavy_d | 6.142 | 366.7 | 0.01101 | 0.000 | -0.107 | 0.324 | PASS |

## Pipeline fixes (not relaxed acceptance)

- Named base punches were absent from clip_phases; contact timing could follow a foot-driven farthest-reach marker. The live contact helper independently picked the farther hand, including the guarding hand. Both now use the named hand. The focused regression asks both opposite-hand techniques to contact from an identical pose, so farthest-hand selection cannot pass both.
- The existing foot lock used horizontal speed to decide whether a baked sole was planted, releasing the very slide it should stop. Baked takes now derive sustained vertical contact before the existing bounded foot-lock/leg-IK solve. Raised swings remain free; no pelvis correction, source retiming or acceptance-limit change. Cross slip fell from 2.04-2.56 cm to <=0.00105 cm. The jab still passes all four rows.
- The audition applies FightClipFootPlant to owned candidates too, preserves the unmodified reference, supports a true bound-path witness for any selected certified role, and has a stills-only mode that does not score before review. Body fixtures now select torso capsules and the actual live body-contact helper rather than aiming every candidate at the head.

## Validation and scope

Parse CHECK total=4 fails=0 on binding/player/test/gate; later tool-only edits also parsed. Focused SUITE total=2 fails=0 (boxing_idle_binding, boxing_join_discontinuity). No full suite. Windowed jobs used Tools/godot_hidden.ps1 with Dummy audio; watchdog GREEN. FBX reader warnings and ObjectDB teardown leaks occur, but final report errors=0 and no SCRIPT ERROR/engine ERROR in the witness. All acceptance values remain the Run 6 values.

The prescribed intake rebase conflicted by replaying already-merged historical C223 commits. It was aborted; dc749978 already contained fetched origin/master. That general rebase instruction was set aside to preserve Claude's prepared branch. No HANDOFF/CURRENT_STATUS/archive read or edit, no master push, video, executable, or Kimodo.

Tokens used at final evidence snapshot (2026-09-28T08:31:27.640Z, cumulative API telemetry): total 15,773,059; input 15,732,779, including 15,497,600 cached; output 40,280, including 12,374 reasoning. Uncached input plus output: 275,459. Cached context is repeatedly accounted by the API; this is not a unique-word count. Final commit/message overhead follows this snapshot.

## Remaining base punches - stopped, not promoted

Final shared-pipeline measurements: `run7_remaining_bases.json`, errors=0. Contact sheets were checked before scores. All four generated legal rows are below; A/B are welter a/b, C/D are heavy c/d, each against its same-class partner. Failure codes: J = join discontinuity; V = peak-fist band; T = onset-impact band; B = body overlap. These are unchanged Run 6 gates. All these rows pass planted-foot travel, floor, whole-play, idle return and zero-pop after the lock fix; passing those does not certify the move.

| Candidate / move | Body | Peak m/s (wanted) | Onset-impact ms (wanted) | Slip cm <=2 | Skin cm | Minimum body gap m >=0 | Failed |
|---|---|---|---|---:|---:|---:|---|
| owned_lead_hook | A | 7.13 (8.0-14.0) | 300.0 (477-657) | 0.1203 | 0.000 | 0.275 | J, V, T |
| boxing_lead_hook | A | 5.06 (8.0-14.0) | 466.7 (477-657) | 0.0315 | 0.000 | 0.125 | J, V, T |
| boxing_rear_hook | A | 8.18 (8.0-14.0) | 1016.7 (477-586) | 0.1435 | 0.000 | -0.114 | J, B, T |
| boxing_lead_uppercut | A | 6.50 (6.5-13.5) | 716.7 (606-627) | 0.0559 | 0.000 | -0.028 | J, B, T |
| boxing_rear_uppercut | A | 7.98 (6.5-13.5) | 683.3 (606-627) | 0.2167 | 0.000 | 0.195 | J, T |
| owned_lead_hook | B | 7.44 (8.0-14.0) | 300.0 (477-657) | 0.1167 | 0.000 | 0.274 | J, V, T |
| boxing_lead_hook | B | 5.36 (8.0-14.0) | 466.7 (477-657) | 0.0330 | 0.000 | 0.126 | J, V, T |
| boxing_rear_hook | B | 7.82 (8.0-14.0) | 1016.7 (477-586) | 0.2280 | 0.000 | -0.118 | J, B, V, T |
| boxing_lead_uppercut | B | 6.74 (6.5-13.5) | 716.7 (606-627) | 0.0852 | 0.000 | -0.034 | J, B, T |
| boxing_rear_uppercut | B | 8.12 (6.5-13.5) | 683.3 (606-627) | 0.2193 | 0.000 | 0.166 | J, T |
| owned_lead_hook | C | 7.50 (8.0-14.0) | 300.0 (477-657) | 0.0184 | 0.000 | 0.275 | J, V, T |
| boxing_lead_hook | C | 5.33 (8.0-14.0) | 466.7 (477-657) | 0.0396 | 0.000 | 0.120 | J, V, T |
| boxing_rear_hook | C | 8.64 (8.0-14.0) | 1016.7 (477-586) | 0.3359 | 0.000 | -0.120 | J, B, T |
| boxing_lead_uppercut | C | 6.86 (6.5-13.5) | 716.7 (606-627) | 0.0195 | 0.000 | -0.045 | J, B, T |
| boxing_rear_uppercut | C | 8.43 (6.5-13.5) | 683.3 (606-627) | 0.3805 | 0.000 | 0.189 | J, T |
| owned_lead_hook | D | 7.86 (8.0-14.0) | 300.0 (477-657) | 0.1411 | 0.000 | 0.280 | J, V, T |
| boxing_lead_hook | D | 5.69 (8.0-14.0) | 466.7 (477-657) | 0.0386 | 0.000 | 0.128 | J, V, T |
| boxing_rear_hook | D | 8.41 (8.0-14.0) | 1016.7 (477-586) | 0.1019 | 0.000 | -0.119 | J, B, T |
| boxing_lead_uppercut | D | 7.03 (6.5-13.5) | 716.7 (606-627) | 0.0147 | 0.000 | -0.049 | J, B, T |
| boxing_rear_uppercut | D | 8.51 (6.5-13.5) | 683.3 (606-627) | 0.3704 | 0.000 | 0.174 | J, T |

- Lead hook: owned H2H_HookPunch has the left horizontal arc, but fails speed/timing/joins. Mixamo Boxing_Lead_Hand_Hook fails the same gates. No promotion or retiming.
- Rear hook: whole-clip mirroring also mirrors the stance; the owned mirrored audition is not certified as an orthodox rear hook. Mixamo Boxing_Back_Hand_Hook fails joins, timing and body separation (and speed on B).
- Lead/rear uppercuts: owned H2H_LeadingUppercut and its mirror rejected visually for crouch/turn/stance change. The Mixamo named lead/rear uppercuts rise, but miss the unchanged 606-627 ms band and join limits; lead also overlaps the receiver. Standing_Left_Uppercut_Punch visibly turns through an exaggerated overhead finish and is rejected before scoring.
- Additional operator combat archive: lossless name/hierarchy adapters with hashes in `run7_combat_receipt.json`. Cross_Punch__A_Cross_Punch and Hook__Long_Hook_Punch_To_The_Head are stepping performances; Hook_Punch__A_Hook_Punch has a large turning load; Right_Hook__Right_Hook_Punch_From_Idle drops its guarding hand to its side. No numeric pass was used to overrule these sheet failures. These auditions do not claim every one of the 422 archive files has been viewed.
- Source sheets: `run7_named_*` for corrected named hands; `run7_combat_*` for archive candidates. Older `run7_owned.json` / `run7_mix_named.json` are intermediate diagnostics, not final certificates. Only `run7_bound.json` certifies the cross and jab.

## Body versions - no promotion

The owned head-cross reuse was rejected by eye: the modest dip and high target line do not establish the required body shot. The mirrored body hook changes stance and overreaches. The four plausible body takes were then measured on all four legal rows with actual torso contact, not head contact (`run7_body.json`, errors=0).

| Candidate | Body | Peak m/s | Onset-impact ms | Slip cm <=2 | Skin cm | Failed gates |
|---|---|---:|---:|---:|---:|---|
| boxing_jab_body | A | 4.68 | 416.7 | 0.0552 | 0.000 | J, T |
| body_jab_short | A | 5.06 | 333.3 | 0.0107 | 0.000 | J |
| boxing_body_hook | A | 7.68 | 933.3 | 0.1387 | 0.000 | J, V, T |
| body_hook_short | A | 5.66 | 833.3 | 0.0207 | 0.000 | J, V, T |
| boxing_jab_body | B | 4.25 | 416.7 | 0.0447 | 0.000 | J, V, T |
| body_jab_short | B | 5.09 | 333.3 | 0.0110 | 0.000 | J |
| boxing_body_hook | B | 7.39 | 933.3 | 0.1313 | 0.000 | J, V, T |
| body_hook_short | B | 5.57 | 833.3 | 0.0223 | 0.000 | J, V, T |
| boxing_jab_body | C | 4.76 | 433.3 | 0.0585 | 0.000 | J, T |
| body_jab_short | C | 2.96 | 333.3 | 0.0065 | 0.000 | J, V |
| boxing_body_hook | C | 7.89 | 933.3 | 0.1446 | 0.000 | J, V, T |
| body_hook_short | C | 5.87 | 833.3 | 0.0235 | 0.000 | J, V, T |
| boxing_jab_body | D | 4.59 | 416.7 | 0.0570 | 0.000 | J, T |
| body_jab_short | D | 2.84 | 333.3 | 0.0110 | 0.000 | J, V |
| boxing_body_hook | D | 7.83 | 933.3 | 0.1408 | 0.000 | J, V, T |
| body_hook_short | D | 5.80 | 833.3 | 0.1778 | 0.000 | J, V, T |

Short_Body_Jab is closest but joins fail on all four and peak speed fails on C/D. Mid_Body_Jab, Mid_Hook_Punch_To_The_Body and Short_Hook_Punch_To_The_Body also fail timing and/or speed. Body clips remain unpromoted. No head clip was relabelled as a certified body version.

## Sequences

One-two and double-jab auditions chain the certified jab/cross parts; no combo source was hunted. `c223_sequence_gate.gd` declares SEQUENCES and starts the next part at measured half retraction relative to the punching shoulder (excluding hip travel). This is an explicit audition override of the whole-clip guard, not a change to normal production interruption. A refused play request is a named error, never a relabelled first punch. Stills show both actual strikes. Each part must retain its contact/timing/speed and body gap, and the chain must retain the original join/floor/slip/pop gates. The first complete chain check (`run7_sequences.json`, errors=0) rejects both chains on all four rows. The second contact is evaluated at a fixed receiver position set by the first jab's own authored reach, not by teleporting the receiver between strikes.

| Chain | Body | Part 1 / 2 head gap cm (<=2) | Part 1 / 2 peak m/s | Slip cm (<=2) | Failed |
|---|---|---:|---:|---:|---|
| boxing_one_two | A | -0.19 / 0.87 | 5.78 / 10.98 | 0.421 | join_discontinuity |
| boxing_double_jab | A | -0.19 / -0.19 | 5.78 / 5.78 | 0.834 | join_discontinuity |
| boxing_one_two | B | -0.05 / 5.61 | 5.79 / 10.66 | 0.473 | part_1_contact_or_timing, join_discontinuity |
| boxing_double_jab | B | -0.05 / -0.05 | 5.79 / 5.79 | 0.796 | join_discontinuity |
| boxing_one_two | C | -0.18 / 2.02 | 6.16 / 11.60 | 0.029 | part_1_peak_band, part_1_contact_or_timing, join_discontinuity |
| boxing_double_jab | C | -0.18 / -0.18 | 6.16 / 6.16 | 0.880 | join_discontinuity |
| boxing_one_two | D | -0.11 / 5.00 | 6.14 / 11.38 | 0.389 | part_1_contact_or_timing, join_discontinuity |
| boxing_double_jab | D | -0.11 / -0.11 | 6.14 / 6.14 | 0.857 | join_discontinuity |

The half-retraction splice is 0.7667 s for this jab on all four bodies. Both actual punches occur; the discontinuity at the explicit mid-recovery handoff remains a real failure. No production sequence binding has been promoted.


One bounded J19 craft-range trial doubled only the inter-punch inertial blend from 0.15 to 0.30 s, without retiming either source. After re-render/review, welter A still failed: one-two hand/root excess 0.2957/0.0253 cm/frame2; double jab 0.7303/0.5101 (`run7_sequences_blend.json`). The original per-bone limits remain in force. Trial stopped rather than tuning thresholds. The production sequence API remains unimplemented because these candidate joins are not certified; the SEQUENCES entries are explicitly diagnostic, not playable catalogue promises.

Final validation: CHECK total=7 fails=0; focused SUITE total=2 fails=0; each final certificate/body/base/sequence report errors=0 and no SCRIPT ERROR or engine ERROR in its log. The sequence harness's initial procedural-glove skin-sampling error was fixed before the final captures/measurements. Ordinary whole-clip playback refused the initial chain interruption; the corrected audition explicitly owns its post-contact cut and checks the second play request. Those failed preliminary captures are not certificates.

Delivery: cross certificate pushed at `88bb9785`; first one-line Claude message `bcf92d250e29`. Final evidence push closes this run at **2/36, not completion of the five other base punches or of C223**. All source and chain failures remain visible. No threshold was loosened.

One-two-hook and counter combinations cannot be certified from the current inventory: no lead hook or defensive catch/slip/pull part has a Run 7 certificate. They remain blocked on certified parts; no single punch stands in for those chains.


---
Boxing EXACT-that-PASSED: 0/36 -> 1/36

# Run 6 - generated legal pairs; jab_med certified

2026-09-28. Boxing jab now binds the whole Mixamo Med_Head_Jab with provenance exact. The certificate covers four generated male athletes, both directions of each legal pair, the production binding, a normally running boxing idle, and the existing live-room landed-hand contact solver. Other candidates remain unpromoted; C223 as a whole is incomplete. Kickboxing remains 0/20.

## Bodies and review boundary

- WELTER: athlete a, 66.0 kg / 1.80 m, versus athlete b, 66.5 kg / 1.72 m (C213 pair).
- HEAVY: c223_heavy_c, 100 kg / 1.90 m, versus c223_heavy_d, 108 kg / 1.85 m.
- Stage.model_for_skin(..., generator, ...) selects mpfb_male_pilot.glb. Stage.apply_identity supplies FighterLook weights/skin; Stage.mount supplies FighterPhysique stature. Generated legacy clips retain C213 retargeting. No identical fighters or cross-class fixtures.
- Capsule extraction now resolves named skin binds and includes the seeded blend shapes. Sole sampling includes those same shapes. The preserved pre-rebase Tripo WIP/reference is historical secondary evidence, not the certificate.
- Four six-still jab sheets reviewed against SHOT_LIST_STRIKING: straight lead hand, shoulder cover, lead step, head contact, non-striking guard, recoil and return to the shared guard; heads/torsos remain separated. C213 base-body/open-finger and glove artwork limitations remain visible; this is animation certification, not final fighter art.

## Join correction and mutant proof

Metric: second difference of world hand/root positions (cm per 60 Hz frame squared) at seam-1 through seam+1, minus the adjacent interior p95 of the SAME bone. Entry and exit have separate per-bone limits. The reference excess is multiplied by 1.5, with a 0.001 cm/frame-squared numerical floor; no hand borrows another hand's limit. A duplicated zero-time sample after play_role was removed: only elapsed 1/60 s samples enter this metric. Interior p95, seam acceleration and excess are all retained in JSON. The entire clip still has its independent pop-event gate.

The first proposed aggregate-excess metric missed the heavyweight entry-hand pop and was rejected. `run6_generator_before.json` records that failed experiment; it is not the final calibration. Final proof is `run6_bound_jab_contact.json`: RamsterZ jab -> H2H_Idle passes on all four bodies, all four 10 cm seam-pop mutants plus the persistent 5 cm seam teleport are rejected on every body (20/20).

| Body | Old reference hand / root cm/frame | Old wanted hand / root | New reference max excess cm/frame2 | New entry RightHand limit / all other limits |
|---|---:|---:|---:|---:|
| welter_a | 0.2917 / 0.1867 | 0.4375 / 0.2801 | 0.5352 | 0.8028 / 0.001 |
| welter_b | 0.2787 / 0.1785 | 0.4180 / 0.2677 | 0.5115 | 0.7672 / 0.001 |
| heavy_c | 0.3078 / 0.1971 | 0.4617 / 0.2957 | 0.5650 | 0.8475 / 0.001 |
| heavy_d | 0.2997 / 0.1919 | 0.4496 / 0.2879 | 0.5501 | 0.8252 / 0.001 |

| Body | Entry hand 10 cm | Exit hand 10 cm | Entry root 10 cm | Exit root 10 cm | Exit teleport 5 cm |
|---|---:|---:|---:|---:|---:|
| welter_a | 2.165 REJECT | 19.325 REJECT | 18.476 REJECT | 19.547 REJECT | 4.551 REJECT |
| welter_b | 2.944 REJECT | 19.355 REJECT | 18.542 REJECT | 19.567 REJECT | 4.571 REJECT |
| heavy_c | 1.193 REJECT | 19.288 REJECT | 18.393 REJECT | 19.522 REJECT | 4.526 REJECT |
| heavy_d | 1.679 REJECT | 19.306 REJECT | 18.434 REJECT | 19.535 REJECT | 4.539 REJECT |

Mutant table values are maximum measured excess acceleration, not displacement. Mutants inject into measured world samples after the player and IK; the original samples are deep-copied. A separate synthetic constant-velocity test proves that a continuous 2 cm/frame moving guard passes while the same five defects fail.

Prefab runtime check: Godot 4.7.2 reports AnimationNodeTransition.xfade_time and no ClassDB class with an inertialization name. Godot AnimationTree/AnimationNodeTransition provides xfade_time; AnimationPlayer supports fixed crossfade. FightStagePlayer already implements quaternion/hip inertialization and a queued stance. Reused that player rather than replacing the queue with an AnimationTree. Idle phase search minimizes both pose and velocity error across hands, hips and feet. Authored endpoint crossfades touch at most 0.15 s at each end; the whole 1.5 s take remains. The queued idle enters at the matched exit phase. The bake creates target-specific Animation keys during binding; it does not apply a floor correction to the pelvis during frame playback. The bound-path witness does NOT prime/seek the incoming idle; its normal running phase is blended into the authored matched entry. [Godot transition documentation](https://docs.godotengine.org/en/stable/classes/class_animationnodetransition.html).

## Skin floor - bake, not pelvis lift

FightClipFootPlant bakes target-skin contact: toe/ball orientation correction followed by analytic FightLegIK two-bone correction, using actual blend-shaped sole vertices. Only leg/toe rotation keys change; no pelvis offset, per-clip lift, bone scaling or retiming. Existing runtime XZ foot locking remains, but cannot drag a baked foot back to an old vertical toe anchor. Baking alone had not fixed that second lock interaction; the final comparison includes both corrections.

| Body | guard_idle skin cm before -> after | jab_med before -> after | cross_new before -> after |
|---|---:|---:|---:|
| welter_a | 1.105 -> 0.000 | 2.410 -> 0.000 | 0.096 -> 0.000 |
| welter_b | 0.967 -> 0.000 | 2.403 -> 0.000 | 0.035 -> 0.000 |
| heavy_c | 0.824 -> 0.000 | 2.075 -> 0.000 | 0.000 -> 0.000 |
| heavy_d | 0.735 -> 0.000 | 2.208 -> 0.000 | 0.000 -> 0.000 |

## Contact, spacing and body separation

The generated reference jab itself does NOT fail the new head/torso overlap row: at the original 1.23 m fixture its minimum body gap is 0.389-0.460 m. jab_med at that same spacing carries 0.560-0.618 m of hip forward travel and comes within 0.039-0.158 m of the receiver. This is carried authored hip travel, not root-node translation; the fixed fixture was not a per-clip reach fit. These generated-body findings do not retroactively certify the rejected run-5 Tripo images.

The fixture now places the receiver at the outer head contact distance measured from the authored take. Body gap is checked over EVERY sampled clip frame, with head+torso against head+torso, wanted >=0. No body or arm is scaled.

Visual review caught another false positive: the old head target class included Neck-Head. It now requires the actual Head sphere, matching FightWorldLiveScreen._stop_landed_hand_contact. The final witness uses that existing production helper with pose_contact=false: arm rotations only, no reach/pelvis shift. Raw isolated clips that touch the neck are not counted as head hits. The production contact marker for named boxing punches now uses their named hand, preventing baked leg motion from selecting a foot-driven final-frame impact.

| Body | Raw authored root-to-hand m | Final fixture m | Min body gap m | Skin cm | Slip cm | Fist m/s | Onset-impact ms | Head gap cm |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| welter_a | 1.212 | 1.430 | 0.303 | 0.000 | 0.0051 | 5.783 | 366.7 | -0.187 |
| welter_b | 1.159 | 1.375 | 0.296 | 0.000 | 0.0048 | 5.790 | 366.7 | -0.053 |
| heavy_c | 1.280 | 1.520 | 0.320 | 0.000 | 0.0044 | 6.164 | 366.7 | -0.180 |
| heavy_d | 1.246 | 1.495 | 0.324 | 0.000 | 0.0051 | 6.142 | 366.7 | -0.107 |

All four jab rows: zero pop events, no foot/knee penetration, whole clip played, idle reached, zero seam excess above local interior, all required mechanical rows pass. Peak band remains 4.5-9.5 m/s; timing remains 100-405 ms; contact travel <=2 cm; head reach tolerance remains 2 cm. Minor negative head gaps are under 0.2 cm at the solver surface.

## Validation and delivery

Parse: CHECK total=11 fails=0. Requested `--jobs 1 --only clip,binding,fight_stage,boxing`: **SUITE total=27 fails=4**. The three new integration failures (stale boxing-jab alias, missing clip-phase row, missing GLB import cache) were corrected without weakening tests. Focused `--only clip_phases_data,fight_clip_alias,fight_clip_load,boxing`: **SUITE total=7 fails=0**. The synthetic seam test reports 8/8. Realism remains **TOTAL=13 fails=8**: R1/R2/R3/R4/R5/R5b/R7/R8, the same named failing rules as Run 5; measurements are not claimed identical. The initial realism log also recorded a missing boxing_boot import; the subsequent editor import refreshed the cache. No green overall tier is claimed. No full suite, video or executable. Windowed stills used Tools/godot_hidden.ps1 with Dummy audio. All pre-run watchdog readings GREEN.

WIP preserved before rebasing onto origin/master; branch remains codex/c223-boxing-kb-clips. The user's run-6 pipeline authorization supersedes the original binding-rows-only edit window for the named player, capsule, foot-bake and measurement fixes, the two live-room athlete-ID arguments, and the jab alias/phase registration needed by the actual binding. No HANDOFF/CURRENT_STATUS/archive edits, no master push. Unrelated untracked files remain untouched.

Sources unchanged: operator-supplied Adobe Mixamo, royalty-free embedded game use; owned RamsterZ Unity Asset Store EULA, embedded game use, no standalone redistribution. Kimodo, purchases and new-source searches were not used.

Reproduce: production gate via hidden launcher with `-- render clips=reference_jab,jab_med guard=Bouncing_Boxing_Idle plant phase distance bound live_contact report=run6_bound_jab_contact.json`. Foot baseline/final: run6_generator_before.json / run6_generator_final.json. Final jab certificate and stills: run6_jab_certificate.json / run6_jab_med_generator_*.png.

## Remaining five auditions - no further promotion

After jab_med was pushed in db42de78, all five requested next candidates ran on both legal generated pairs with the same phase-matched transition, authored spacing and live head-contact helper. All 20 candidate/body rows fail at least one mechanical requirement. The report is run6_next_candidates.json; errors=0 means the harness completed, not that these clips passed. Its reference controls again reject all 20 seam mutants. No source search, retiming or gate relaxation was used.

| Candidate | Failures across four bodies | Fist speed m/s | Onset-impact ms | Contact slip cm |
|---|---|---:|---:|---:|
| jab_new | contact_slip_cm, join_discontinuity, onset_to_impact_band, peak_fist_band | 3.021-3.235 | 533.333-533.333 | 22.850-25.112 |
| cross_new | contact_slip_cm, join_discontinuity, peak_fist_band | 4.340-4.694 | 316.667-316.667 | 21.402-23.758 |
| lead_hook_new | contact_slip_cm, join_discontinuity, peak_fist_band | 3.531-3.819 | 633.333-633.333 | 27.498-30.403 |
| rear_hook_new | contact_slip_cm, join_discontinuity, onset_to_impact_band, peak_fist_band | 5.046-5.691 | 300.000-300.000 | 21.482-23.416 |
| boxing_inside_uppercut | join_discontinuity, onset_to_impact_band, skin_floor_cm | 11.510-12.270 | 400.000-400.000 | 0.018-0.019 |

Every candidate's body-overlap row passes, but that does not certify the punch. Distances below are metres. Each row names the striking body; its receiver is the other ID in the named legal pair.

| Candidate | Class / striker vs receiver | Authored root-to-hand | Fixture | Minimum body gap |
|---|---|---:|---:|---:|
| jab_new | WELTER / generator_welter_a vs generator_welter_b | 0.754 | 0.990 | 0.347 |
| jab_new | WELTER / generator_welter_b vs generator_welter_a | 0.720 | 0.955 | 0.315 |
| jab_new | HEAVY / generator_heavy_c vs generator_heavy_d | 0.796 | 1.055 | 0.362 |
| jab_new | HEAVY / generator_heavy_d vs generator_heavy_c | 0.775 | 1.040 | 0.344 |
| cross_new | WELTER / generator_welter_a vs generator_welter_b | 0.861 | 1.100 | 0.436 |
| cross_new | WELTER / generator_welter_b vs generator_welter_a | 0.823 | 1.055 | 0.394 |
| cross_new | HEAVY / generator_heavy_c vs generator_heavy_d | 0.909 | 1.165 | 0.446 |
| cross_new | HEAVY / generator_heavy_d vs generator_heavy_c | 0.885 | 1.150 | 0.436 |
| lead_hook_new | WELTER / generator_welter_a vs generator_welter_b | 0.674 | 0.880 | 0.294 |
| lead_hook_new | WELTER / generator_welter_b vs generator_welter_a | 0.644 | 0.850 | 0.276 |
| lead_hook_new | HEAVY / generator_heavy_c vs generator_heavy_d | 0.712 | 0.930 | 0.297 |
| lead_hook_new | HEAVY / generator_heavy_d vs generator_heavy_c | 0.693 | 0.925 | 0.302 |
| rear_hook_new | WELTER / generator_welter_a vs generator_welter_b | 0.691 | 0.930 | 0.163 |
| rear_hook_new | WELTER / generator_welter_b vs generator_welter_a | 0.661 | 0.895 | 0.140 |
| rear_hook_new | HEAVY / generator_heavy_c vs generator_heavy_d | 0.730 | 0.985 | 0.162 |
| rear_hook_new | HEAVY / generator_heavy_d vs generator_heavy_c | 0.710 | 0.970 | 0.155 |
| boxing_inside_uppercut | WELTER / generator_welter_a vs generator_welter_b | 0.911 | 1.238 | 0.393 |
| boxing_inside_uppercut | WELTER / generator_welter_b vs generator_welter_a | 0.871 | 1.117 | 0.307 |
| boxing_inside_uppercut | HEAVY / generator_heavy_c vs generator_heavy_d | 0.962 | 1.308 | 0.403 |
| boxing_inside_uppercut | HEAVY / generator_heavy_d vs generator_heavy_c | 0.937 | 1.258 | 0.373 |

Representative still sheets reviewed: jab_new/welter_a, cross_new/heavy_c, lead_hook_new/welter_a, rear_hook_new/heavy_d, inside_uppercut/welter_b. The inside uppercut visibly dips and steps too far to establish compact inside identity; it remains unpromoted independently of its numeric failures. Its owned FBX follows the existing owned-source path (no Mixamo foot bake), with 2.007-2.205 cm skin penetration; welter_b exceeds the retained skin threshold. The four Mixamo candidates have zero measured skin penetration but 21-30 cm contact travel, so fixing vertical sole contact has not certified their planted-foot behavior. Source concerns for up-jab trajectory, overhand speed and head-height hook remain unresolved from Run 5. No claim that pipeline work has made every source acceptable.

The last change after the jab push is evidence/documentation only; the tested production implementation is unchanged. Boxing remains 1/36 EXACT-that-PASSED, kickboxing 0/20.


---
# Run 5 - shared guard and rest alignment; pipeline still NOT accepted

2026-09-28. **C223 remains incomplete. No punch was promoted to EXACT. This is an experimental pipeline checkpoint, not a ready-to-merge animation delivery.** The requested two pipeline problems are only partly resolved: the source-rest correction removes most foot-joint penetration, but residual skin penetration and the unchanged hand/root join gates still reject every punch. Kickboxing remains 0/20 -> 0/20; no kickboxing clips were changed.

## Shared guard and live routing

`RULESET_IDLE_BINDINGS.boxing` selects the supplied whole Mixamo `Bouncing_Boxing_Idle` with its own hierarchy-rest reference. `FightStagePlayer.bind(body, ruleset_id)` grafts the resolved source under the logical `idle` role, so existing idle requests, loop classification, and the queued return all use the same guard. The live room passes its discipline in the two bind calls. Other rulesets and callers without a ruleset retain `H2H_Idle`; missing boxing source/reference falls back to it too. This is an idle binding, **not an EXACT move promotion**.

The three source endpoint comparisons are saved in `../docs/previews/c223/run5_guard_distance.json`; the metric is mean Euclidean distance across both hands, hips and feet at each punch's first/last frame versus the idle's first/last frame. The report also removes each source's horizontal hip origin, matching pipeline A's recentering. Bouncing Boxing Idle is closest in both comparisons. All three saved references have hip height 1.042749 m and toe height 0.000009 m: Godot already converts the FBX centimetres. Applying another 0.01 scale would be wrong.

| Guard idle | Endpoint pose distance cm | Recentered distance cm |
|---|---:|---:|
| Male_Fight_Idle_Boxing_Stance | 17.866 | 17.289 |
| Bouncing_Fight_Idle_With_Guard_Up | 11.869 | 9.624 |
| Bouncing_Boxing_Idle | 5.523 | 5.278 |

**Important residual:** the chosen idle's own hand movement reaches **1.708 / 1.922 cm per 60 Hz frame**, already above the unchanged return-join limits **0.402 / 0.461 cm/frame**. This is measured from the true looping idle rows, not inferred from a rejected punch. Selecting the closest source guard does not make it satisfy that gate. No idle retiming, motion suppression, or threshold change was used to hide this. Existing RamsterZ boxing moves also join poorly to this new guard; this branch must not be described as a production visual improvement across all current moves.

## Shared floor mapping

Mixamo opts into `align_rest_floor` at retarget bake time. The correction composes the SAME silhouette-matched target rest used for rotations, measures its skinned sole and hip-to-floor span, and derives the source-to-target height scale from those rests. The baked Hips track maps the source reference to that aligned target reference. It uses no candidate extrema, per-clip offset, gate threshold, or new runtime pelvis lift. RamsterZ's existing mapping is unchanged. Source FBXs and converted GLBs are untouched.

Before/after below uses the same Bouncing Boxing Idle on both sides. The `guard_idle` is a real loop, not a guard played as a one-shot strike. `run5_floor_before.json` is the unaligned control; `run5_candidates.json` is the corrected production-player run. Exploratory one-shot guard probes were superseded by this true-loop comparison.

| Clip | Rig | Foot floor cm before -> after (wanted 0) | Skin floor cm before -> after | Skin wanted cm |
|---|---|---:|---:|---:|
| guard_idle | f01 | 0.000 -> 0.000 | 1.694 -> 1.217 | <=1.345 |
| boxing_jab | f01 | 1.262 -> 0.000 | 5.304 -> 2.734 | <=1.345 |
| guard_idle | f10 | 0.000 -> 0.000 | 1.690 -> 1.440 | <=1.689 |
| boxing_jab | f10 | 2.363 -> 0.000 | 6.048 -> 3.411 | <=1.689 |

Across the 48 Mixamo punch rows shared with run 4, foot-joint failures fall from **34 to 3**. The idle passes floor/skin on both rigs, but its f10 contact slip fails. The jab's foot landmarks now pass on both rigs; its skin still fails. **The floor fix is therefore partial, not complete.**

## Batch 1 - measured rows, no promotion

58 fresh-player rows / 58 six-still PNG sheets: 27 punch candidate/role auditions plus the reference and true looping guard on each distinct rig, f01 and f10. Named moves remain unpromoted. All 54 punch rows have measured target and timing results instead of run-4 unknowns. No speed retiming or threshold widening. Reference jab numbers remain unchanged, so the old wanted values are retained exactly.

Target fixture: the other, distinct rig in the boxing guard, facing the striker at the production MID 1.23 m or POCKET 1.07 m root spacing (hooks/uppercuts). The named striking hand's skin-derived capsule must reach the head/torso surface within the existing U95/R8 2 cm tolerance at the production contact marker +/- one 60 Hz frame. Negative gaps mean intersection, not a separate body-overlap certification. The receiver is a stationary target fixture; these rows do **not** certify the live-room moving-opponent aim/warp/contact solve.

Timing: actual production samples, sustained named-hand speed >= the existing 0.45 m/s for two samples to the production contact marker; SHOT_LIST_STRIKING bands are unchanged. On a target miss this is marker timing, not a physical impact. Shovel uses the union of the named hook/uppercut bands (477-657 ms). Whole endpoint, queued idle, floor, skin, contact slip, pop, and speed bands are still recorded. Stills are in `../docs/previews/c223/run5_<candidate>_<rig>.png`.

Pairs are f01 / f10. Foot/knee wanted 0 cm; contact travel <=2 cm; skin <=1.345 / 1.689 cm; hand join <=0.402 / 0.461 cm/frame; root join <=0.281 / 0.308 cm/frame. All pop counts and knee penetrations are zero. Full per-rig wanted/achieved values are in the JSON.

| Candidate | Foot cm | Skin cm | Hand join cm/frame | Root join cm/frame | Slip cm | Named hand m/s | Target gap cm | Timing ms | Failed rows (union) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| boxing_jab | 0.000 / 0.000 | 2.734 / 3.411 | 3.402 / 3.888 | 0.820 / 0.895 | 1.010 / 6.053 | 5.19 / 6.01 | 33.359 / 18.232 | 416.667 / 416.667 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, skin_floor_cm, target_line |
| jab_med | 0.000 / 0.000 | 2.502 / 3.343 | 1.734 / 1.950 | 0.907 / 0.989 | 0.592 / 0.690 | 5.20 / 5.90 | -2.995 / 0.204 | 366.667 / 366.667 | join_hand_cm, join_root_cm, skin_floor_cm |
| jab_long | 0.000 / 0.000 | 2.405 / 3.297 | 1.731 / 1.947 | 0.907 / 0.989 | 1.134 / 0.474 | 5.55 / 6.32 | 25.020 / 40.381 | 483.333 / 483.333 | join_hand_cm, join_root_cm, onset_to_impact_band, skin_floor_cm, target_line |
| jab_short | 0.000 / 0.000 | 3.261 / 3.016 | 1.738 / 1.953 | 0.907 / 0.989 | 3.427 / 3.160 | 3.41 / 3.99 | 13.600 / -13.775 | 416.667 / 416.667 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| jab_new | 0.000 / 0.000 | 0.340 / 1.163 | 1.741 / 2.107 | 0.679 / 0.741 | 0.272 / 0.002 | 3.47 / 4.29 | 32.244 / -2.518 | 483.333 / 550.000 | join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, target_line |
| cross_new | 0.000 / 0.000 | 1.535 / 1.075 | 2.678 / 3.163 | 0.697 / 0.760 | 0.034 / 0.004 | 3.37 / 4.00 | 31.241 / 2.420 | 316.667 / 333.333 | join_hand_cm, join_root_cm, peak_fist_band, skin_floor_cm, target_line |
| lead_hook_new | 0.000 / 0.000 | 0.443 / 1.155 | 2.453 / 2.888 | 0.679 / 0.741 | 1.808 / 0.007 | 4.26 / 5.11 | 28.754 / 1.739 | 466.667 / 483.333 | join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, target_line |
| rear_hook_new | 0.000 / 0.000 | 2.327 / 1.410 | 1.705 / 2.076 | 0.679 / 0.741 | 0.728 / 0.220 | 5.12 / 6.10 | 32.004 / 13.411 | 300.000 / 300.000 | join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| uppercut_new | 0.000 / 0.000 | 0.842 / 1.221 | 9.641 / 11.465 | 0.679 / 0.741 | 0.925 / 0.404 | 9.70 / 11.56 | 66.188 / 77.526 | 566.667 / 566.667 | join_hand_cm, join_root_cm, onset_to_impact_band, target_line |
| body_cross_combo | 0.000 / 0.000 | 2.523 / 3.372 | 1.732 / 1.949 | 0.907 / 0.989 | 11.591 / 2.570 | 4.48 / 5.28 | -14.110 / -15.089 | 633.333 / 633.333 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm |
| rear_body_hook | 0.000 / 0.000 | 1.413 / 1.882 | 3.167 / 3.965 | 0.907 / 0.989 | 78.079 / 88.669 | 7.32 / 8.87 | 34.105 / 44.451 | 850.000 / 850.000 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| shovel_hook | 0.000 / 0.000 | 0.981 / 1.069 | 1.738 / 1.954 | 0.907 / 0.989 | 7.826 / 0.010 | 6.36 / 7.55 | 49.353 / 54.490 | 733.333 / 733.333 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, target_line |
| boxing_cross | 0.000 / 0.000 | 2.041 / 4.255 | 2.737 / 3.151 | 0.679 / 0.741 | 53.909 / 47.996 | 5.27 / 6.20 | 24.347 / 13.835 | 500.000 / 616.667 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| boxing_lead_hook | 0.000 / 0.105 | 2.874 / 3.102 | 2.424 / 2.840 | 0.679 / 0.741 | 0.016 / 0.497 | 5.54 / 6.52 | 10.123 / -4.618 | 400.000 / 416.667 | foot_floor_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| head_hook_mid | 0.000 / 0.000 | 2.924 / 3.170 | 1.725 / 1.941 | 0.906 / 0.989 | 1.122 / 0.019 | 5.49 / 6.34 | 24.557 / 7.778 | 450.000 / 483.333 | join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| boxing_rear_hook | 0.000 / 0.000 | 2.390 / 3.971 | 2.438 / 2.851 | 0.679 / 0.741 | 51.256 / 38.458 | 7.01 / 8.46 | 79.611 / 70.835 | 516.667 / 533.333 | contact_slip_cm, join_hand_cm, join_root_cm, peak_fist_band, skin_floor_cm, target_line |
| boxing_lead_uppercut | 0.354 / 0.578 | 3.710 / 3.885 | 2.749 / 3.162 | 0.679 / 0.741 | 0.421 / 1.757 | 5.26 / 6.27 | 67.841 / 50.386 | 533.333 / 533.333 | foot_floor_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| boxing_rear_uppercut | 0.000 / 0.000 | 2.235 / 3.366 | 2.888 / 3.322 | 0.679 / 0.741 | 55.285 / 45.929 | 5.09 / 6.09 | 75.167 / 60.468 | 366.667 / 516.667 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| boxing_jab_body | 0.000 / 0.000 | 2.616 / 2.968 | 1.742 / 1.959 | 0.907 / 0.989 | 1.750 / 0.019 | 5.01 / 5.76 | -22.977 / -5.997 | 466.667 / 466.667 | join_hand_cm, join_root_cm, onset_to_impact_band, skin_floor_cm |
| body_jab_short | 0.000 / 0.000 | 2.510 / 2.512 | 1.731 / 1.947 | 0.907 / 0.989 | 24.409 / 10.900 | 3.67 / 4.25 | -5.079 / -6.948 | 416.667 / 416.667 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm |
| body_jab_long | 0.000 / 0.000 | 2.395 / 3.014 | 1.733 / 1.949 | 0.907 / 0.989 | 1.975 / 1.741 | 5.30 / 6.16 | -15.120 / 10.709 | 433.333 / 433.333 | join_hand_cm, join_root_cm, onset_to_impact_band, skin_floor_cm, target_line |
| boxing_body_hook | 0.000 / 0.000 | 2.155 / 2.410 | 1.737 / 1.954 | 0.907 / 0.989 | 12.861 / 27.952 | 7.32 / 8.87 | 34.594 / 44.843 | 833.333 / 850.000 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, skin_floor_cm, target_line |
| body_hook_short | 0.000 / 0.000 | 0.981 / 1.069 | 1.738 / 1.954 | 0.907 / 0.989 | 7.826 / 0.010 | 6.36 / 7.55 | 49.353 / 54.490 | 733.333 / 733.333 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, target_line |
| body_hook_long | 0.000 / 0.000 | 2.077 / 3.337 | 1.738 / 1.954 | 0.907 / 0.989 | 15.406 / 2.068 | 9.31 / 11.12 | 43.800 / 55.269 | 1000.000 / 1016.667 | contact_slip_cm, join_hand_cm, join_root_cm, onset_to_impact_band, skin_floor_cm, target_line |
| boxing_overhand | 0.000 / 0.000 | 0.752 / 1.039 | 2.196 / 2.696 | 0.679 / 0.741 | 0.003 / 0.003 | 31.95 / 36.62 | 90.291 / 70.735 | 633.333 / 633.333 | join_hand_cm, join_root_cm, onset_to_impact_band, peak_fist_band, target_line |
| boxing_up_jab | 0.000 / 0.000 | 0.286 / 1.115 | 2.236 / 2.743 | 0.679 / 0.741 | 5.897 / 0.179 | 15.18 / 17.28 | 39.362 / -3.390 | 366.667 / 200.000 | contact_slip_cm, join_hand_cm, join_root_cm, peak_fist_band, target_line |
| boxing_inside_uppercut | 0.000 / 0.000 | 1.620 / 2.280 | 2.361 / 2.891 | 0.679 / 0.741 | 0.005 / 0.006 | 11.46 / 13.19 | -1.201 / -5.833 | 400.000 / 400.000 | join_hand_cm, join_root_cm, onset_to_impact_band, skin_floor_cm |

## Stills and source limits

Reviewed run-5 representative sheets: Leading Hand Jab f01 dips toward the body rather than proving the requested head jab; Med Head Jab f01/f10 shows lead straight extension and passes target/speed/timing on both, but fails skin and both joins. New lead hook f01 sweeps broadly/low, not the required head-height hook. Body Hook f01 has level change but a low broad swing and misses the fixed rib target. New Standing Left Uppercut f10 drops the guard and turns through; its end is not the same guard. The f10 mesh visibly has open hands and has no finger bones to drive; player-only captures do not add the live room's procedural boxing glove overlay. No visual sign-off was granted. Other candidates already fail measured gates and are not claimed visually certified.

Mixamo cannot currently supply a certified up-jab (ordinary jab is not its low-hand rising trajectory), correctly paced overhand (owned take is far above 6-11 m/s), or compact inside uppercut (owned take changes stance/turns). A named new uppercut is not evidence of that compact motion.

Counters are **chains**, not missing single-clip purchases: pull = retreat/pull + cross; slip = slip/dodge + counter; catch = face-level rear catch/block + jab/cross; counter combination = defensive part + 2-3 punches. The run-4 block/dodge rows are only parts. No defensive part and punch pair is certified yet, so no sequence entry is bound and no counter gets EXACT. Once parts pass, sequence joins must meet J19 and the complete shot-list counter row. No new counter-source hunt, Kimodo, purchase, video or executable.

## Validation and reproduction

- Parse: CHECK total=7 fails=0. Focused `boxing_idle_binding_test.gd`: BOXING_IDLE_BINDING total=34 fails=0; exercises actual whole idle graft, continuous loop, queued return, both rigs, and actual legacy graft on rebind to kickboxing.
- Requested tier: **SUITE total=26 fails=2** initially: the new idle source was incorrectly listed as an independently playable BINDINGS role, and `fight_stage_realism_test.gd` failed. Moved the idle source into `RULESET_IDLE_BINDINGS` without weakening the alias contract. Focused rerun `--only clip_alias,boxing_idle_binding`: **SUITE total=2 fails=0**. Realism remains **TOTAL=13 fails=8** (R1/R2/R3/R4/R5/R5b/R7/R8), the same named failures as run 4; its measurements are not claimed unchanged. Exact initial command: `python Godot/tools/run_tests.py --jobs 1 --only clip,binding,fight_stage,boxing`. No full suite.
- Resource job: errors=0; source FBX buffer warnings and ObjectDB shutdown leaks remain. Exit 0 is not a clip acceptance certificate.
- GREEN watchdog before the final serial batch and test tier; one earlier AMBER RAM=86% was reported immediately, subsequent runs were GREEN. Windowed jobs used `Tools/godot_hidden.ps1`, silent audio.
- Reproduce guard selection with `tools/c223_guard_probe.gd`. Baseline with `tools/c223_production_gate.gd -- clips=guard_idle,boxing_jab guard=Bouncing_Boxing_Idle unaligned report=run5_floor_before.json`. Corrected auditions use `-- render clips=<batch-1 ids> guard=Bouncing_Boxing_Idle report=run5_candidates.json` through the hidden launcher.
- Scope expansion is the user's explicit run-5 idle/retarget authorization. The two live-room bind call arguments are necessary to route actual boxing bouts. Task-specific no-HANDOFF/no-CURRENT_STATUS/no-ARCHIVE and no-master-push rules were honored. Fetch succeeded; published run-4 branch history was retained rather than rewritten by the generic intake rebase. Unrelated untracked files were left alone.
- Adobe Mixamo: operator-supplied, royalty-free embedded game use (run-4 receipts/C212). RamsterZ: owned Unity Asset Store EULA, embedded game use, no standalone redistribution. Optional game-asset-production CLI was unavailable; C223's native Godot tools performed the inspection and retarget work.

**Outstanding before this is a fix:** a shared guard and authored joins that actually fit the unchanged join gate; remaining skinned sole penetration; f10 idle contact slip; and all rejected punch identities/timing/speed/target rows. No counters/combinations can be certified from these failed parts. Do not merge this checkpoint as completed C223.

---

# Run 4 - production-player auditions; no full pass

2026-09-28. **C223 remains incomplete. No binding changed and no move was promoted.** 35 candidate/role auditions across 17 requested boxing moves, plus the jab reference, ran on both distinct rigs: 72 rows and 72 six-still PNG sheets. Mixamo sources were tried first; the owned overhand, ordinary jab (rejected as up-jab) and leading uppercut (rejected as inside uppercut) were also measured. Blocks/dodges were checked against the complete counter rows, not accepted from their titles. Kickboxing certification remains 0/20 -> 0/20.

## Per-move disposition

Every entry stays unbound by C223. Failures below are the union across tested takes/rigs; detailed achieved/wanted numbers follow. An ordinary jab passing mechanical rows is not an up-jab pass. The counter rows require the counter, not only the defensive motion.

| Move | Candidate auditions | Failed measured rows | Shot-list review / remaining evidence |
|---|---:|---|---|
| boxing_jab | 5 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Lead straight visible; Leading Hand take dips low. New Jab Punch returns to a different high guard; f10 hands remain open. |
| boxing_cross | 2 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Rear straight action visible, but target height/line not established; floor and return join fail. |
| boxing_lead_hook | 3 x 2 rigs | foot floor, hand join, root join, skin floor, speed band | Lead-arm sweep visible; new lead-hook take is broad/low and too slow for the head-hook band. |
| boxing_rear_hook | 2 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Rear-arm sweep visible; head-height elbow/target alignment is not certified. |
| boxing_lead_uppercut | 2 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Rising lead hand; Standing Left take drops both hands and turns broadly instead of a compact guarded return. |
| boxing_cross_body | 1 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Available Body Jab Cross is a two-punch combination, not an exact whole single cross. |
| boxing_rear_hook_body | 1 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Whole mirrored lead-body take produces rear action but changes stance; no orthodox rear-hook sign-off. |
| boxing_shovel_hook | 1 x 2 rigs | hand join, root join, skin floor, slip, speed band | Short body hook does not prove the required diagonal liver trajectory; no exact identity. |
| boxing_rear_uppercut | 1 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Rear rising hand with hip turn; target contact is unproven and mechanical rows fail. |
| boxing_jab_body | 3 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Lead straight plus knee/level change visible; opponent solar-plexus alignment unproven. |
| boxing_body_hook | 3 x 2 rigs | foot floor, hand join, root join, skin floor, slip, speed band | Lead hand stays low with level change; rib target and correct compact hook arc not certified. |
| boxing_overhand | 1 x 2 rigs | speed band | Looping rear action and deep side bend visible, but peak fist exceeds the 6-11 m/s shot-list band. |
| boxing_up_jab | 1 x 2 rigs | speed band | Owned ordinary jab starts from guard; does not prove a rising jab from a low lead hand; too fast for jab band. |
| boxing_inside_uppercut | 1 x 2 rigs | hand join, root join, skin floor | Owned LeadingUppercut has a broad turn and stance change, not compact clinch-range action. |
| boxing_pull_counter | 1 x 2 rigs | hand join, root join, skin floor, slip | Dodge Retreat shows retreat/evasion without the required counter on the return. |
| boxing_slip_counter | 1 x 2 rigs | foot floor, hand join, root join, skin floor, slip | Dodge Advance shows travel/ducking, not a demonstrated counter from the slipped position. |
| boxing_catch_counter | 6 x 2 rigs | hand join, root join, skin floor | Six block takes show covers/leans; no immediate counter jab/cross. Low blocks are not a face-level rear-glove catch. |

## Production calibration

`c223_runtime_probe.gd` samples **after `FightStagePlayer.advance`**, including the production whole-punch foot lock. The 5 cm ramp is injected into copied sampled world-space toe positions **after the lock**, using the run-3 longest-run/peak-horizontal-direction method. The unchanged vertical contact classifier, >=100 ms contact run, two discarded boundary frames and <=2 cm path-travel ceiling remain in force. No raw-retarget slip value supplies a production acceptance row.

| Reference | Rig | Slip cm / 2 | 5 cm mutant cm / 2 | Reference slip | Slide mutant | 10 cm pop mutant |
|---|---|---:|---:|---|---|---|
| jab | f01 | 0.011354 / 2 | 4.355560 / 2 | PASS | FAIL as required | FAIL as required |
| kickboxing_roundhouse | f01 | 5.418076 / 2 | 7.668470 / 2 | FAIL | FAIL as required | FAIL as required |
| jab | f10 | 0.172418 / 2 | 4.376987 / 2 | PASS | FAIL as required | FAIL as required |
| kickboxing_roundhouse | f10 | 9.440273 / 2 | 11.224433 / 2 | FAIL | FAIL as required | FAIL as required |

**Two jab reference passes; all four slide mutants and all four pop mutants rejected. The two kick reference passes were NOT achieved.** Roundhouse still slides because the supplied production change excludes kicks. The calibration script exits 2 for these two reference failures. This does not block recording boxing rejection evidence, but it must not be described as four-reference calibration success.

## Per-candidate gate measurements

Pairs below are **f01 / f10**, both independently mounted for every candidate. The candidate harness uses the boxing arena deck, centred mount, 90-frame idle warm-up; calibration retains the prior probe spawn and 60-frame warm-up. Consequently its jab reference slip is 0.770256 / 0.176053 cm, still below 2, rather than the calibration values above. All 72 rows play within one 60 Hz sample of the whole endpoint and reach queued idle. All measured pop counts and knee penetrations are zero. The JSON also records pop excess over each joint's own p95 (descriptive, not a rejection of normal strike speed), every contact run and hand speeds.

Wanted: slip <=2 cm; foot/knee landmarks <=0 cm; skin <= same-rig production jab +1 cm; hand/root join <=1.5 x same-rig production jab. The skin and join margins are the authored bands retained from Claude's run-2 review, not primary-study numbers. Pop uses the inherited impulse/acceleration classifier, with the 10 cm controls above. Peak fist bands come from each `SHOT_LIST_STRIKING.md` row. No retiming or threshold widening was applied.

- f01 wanted: skin <=1.345 cm; hand join <=0.402 cm/frame; root join <=0.281 cm/frame.
- f10 wanted: skin <=1.689 cm; hand join <=0.461 cm/frame; root join <=0.308 cm/frame.

| Candidate (source mapping in JSON) | Slip cm / <=2 | Foot floor cm / 0 | Skin floor cm | Hand join cm/frame | Root join cm/frame | Peak named hand m/s (wanted) | Failed rows |
|---|---:|---:|---:|---:|---:|---|---|
| reference_jab | 0.770 / 0.176 | 0.000 / 0.000 | 0.345 / 0.689 | 0.268 / 0.307 | 0.187 / 0.205 | 15.16 / 17.26 (reference/defence) | measured rows pass only |
| boxing_jab | 0.778 / 0.923 | 0.759 / 1.759 | 3.507 / 4.279 | 2.705 / 3.147 | 2.169 / 2.148 | 5.12 / 5.94 (4.5-9.5) | foot floor, hand join, root join, skin floor |
| jab_med | 0.593 / 0.696 | 1.165 / 1.799 | 4.242 / 5.076 | 2.141 / 1.961 | 1.778 / 1.529 | 5.13 / 5.83 (4.5-9.5) | foot floor, hand join, root join, skin floor |
| jab_long | 7.492 / 1.237 | 0.880 / 0.909 | 4.221 / 4.197 | 2.193 / 2.020 | 1.778 / 1.529 | 5.47 / 6.24 (4.5-9.5) | foot floor, hand join, root join, skin floor, slip |
| jab_short | 7.351 / 5.567 | 1.434 / 1.748 | 4.940 / 4.888 | 2.257 / 2.100 | 1.940 / 1.709 | 3.38 / 3.95 (4.5-9.5) | foot floor, hand join, root join, skin floor, slip, speed band |
| jab_new | 0.003 / 0.004 | 0.000 / 0.000 | 1.078 / 1.390 | 3.237 / 3.963 | 0.382 / 0.419 | 3.47 / 4.29 (4.5-9.5) | hand join, root join, speed band |
| cross_new | 0.005 / 0.004 | 0.000 / 0.000 | 2.386 / 1.387 | 2.624 / 3.206 | 2.107 / 2.264 | 3.37 / 4.01 (6-11.5) | hand join, root join, skin floor, speed band |
| lead_hook_new | 0.015 / 0.010 | 0.000 / 0.000 | 1.051 / 1.325 | 2.832 / 3.418 | 0.207 / 0.227 | 4.27 / 5.13 (8-14) | hand join, speed band |
| rear_hook_new | 0.002 / 0.153 | 0.000 / 0.000 | 3.176 / 1.708 | 2.219 / 2.835 | 0.306 / 0.336 | 5.12 / 6.10 (8-14) | hand join, root join, skin floor, speed band |
| uppercut_new | 0.008 / 0.008 | 0.000 / 0.000 | 1.174 / 1.377 | 8.573 / 10.016 | 2.678 / 2.419 | 9.68 / 11.53 (6.5-13.5) | hand join, root join |
| body_cross_combo | 3.233 / 3.894 | 0.733 / 1.239 | 3.270 / 4.815 | 1.435 / 1.843 | 1.085 / 1.190 | 4.46 / 5.27 (6-11.5) | foot floor, hand join, root join, skin floor, slip, speed band |
| rear_body_hook | 26.982 / 45.915 | 1.184 / 1.456 | 4.088 / 4.510 | 4.002 / 5.172 | 2.752 / 1.936 | 7.34 / 8.88 (8-14) | foot floor, hand join, root join, skin floor, slip, speed band |
| shovel_hook | 2.475 / 0.021 | 0.000 / 0.000 | 2.905 / 2.253 | 1.440 / 1.848 | 1.085 / 1.190 | 6.36 / 7.55 (6.5-14) | hand join, root join, skin floor, slip, speed band |
| boxing_cross | 10.126 / 12.846 | 1.183 / 2.030 | 4.496 / 5.135 | 2.593 / 2.692 | 2.331 / 2.346 | 5.24 / 6.17 (6-11.5) | foot floor, hand join, root join, skin floor, slip, speed band |
| boxing_lead_hook | 0.862 / 0.018 | 0.836 / 1.426 | 3.954 / 4.163 | 2.777 / 2.949 | 2.536 / 2.671 | 5.55 / 6.53 (8-14) | foot floor, hand join, root join, skin floor, speed band |
| head_hook_mid | 1.159 / 0.017 | 1.467 / 1.529 | 5.264 / 5.122 | 2.201 / 2.046 | 2.095 / 1.878 | 5.45 / 6.30 (8-14) | foot floor, hand join, root join, skin floor, speed band |
| boxing_rear_hook | 42.699 / 37.681 | 0.908 / 1.598 | 3.731 / 4.312 | 2.512 / 2.552 | 2.364 / 2.344 | 6.99 / 8.44 (8-14) | foot floor, hand join, root join, skin floor, slip, speed band |
| boxing_lead_uppercut | 10.219 / 11.525 | 2.365 / 2.797 | 5.293 / 5.359 | 2.629 / 2.930 | 2.340 / 2.293 | 5.24 / 6.25 (6.5-13.5) | foot floor, hand join, root join, skin floor, slip, speed band |
| boxing_rear_uppercut | 17.359 / 7.185 | 0.880 / 1.555 | 3.883 / 4.588 | 2.551 / 2.986 | 2.396 / 2.366 | 5.06 / 6.06 (6.5-13.5) | foot floor, hand join, root join, skin floor, slip, speed band |
| boxing_jab_body | 1.598 / 0.019 | 1.271 / 2.130 | 4.467 / 4.924 | 1.416 / 1.817 | 1.085 / 1.190 | 4.94 / 5.70 (4.5-9.5) | foot floor, hand join, root join, skin floor |
| body_jab_short | 24.336 / 26.172 | 0.785 / 1.474 | 3.948 / 4.230 | 2.608 / 2.568 | 2.015 / 1.793 | 3.63 / 4.22 (4.5-9.5) | foot floor, hand join, root join, skin floor, slip, speed band |
| body_jab_long | 1.797 / 1.784 | 0.558 / 1.102 | 3.508 / 3.741 | 2.272 / 2.133 | 1.921 / 1.711 | 5.22 / 6.09 (4.5-9.5) | foot floor, hand join, root join, skin floor |
| boxing_body_hook | 15.704 / 7.425 | 1.173 / 1.476 | 4.239 / 4.319 | 2.258 / 2.107 | 2.042 / 1.819 | 7.33 / 8.88 (8-14) | foot floor, hand join, root join, skin floor, slip, speed band |
| body_hook_short | 2.475 / 0.021 | 0.000 / 0.000 | 2.905 / 2.253 | 1.440 / 1.848 | 1.085 / 1.190 | 6.36 / 7.55 (8-14) | hand join, root join, skin floor, slip, speed band |
| body_hook_long | 6.479 / 2.809 | 0.447 / 0.904 | 4.171 / 5.678 | 2.132 / 1.967 | 2.007 / 1.782 | 9.30 / 11.11 (8-14) | foot floor, hand join, root join, skin floor, slip |
| boxing_overhand | 0.005 / 0.009 | 0.000 / 0.000 | 1.167 / 1.074 | 0.179 / 0.220 | 0.187 / 0.205 | 31.95 / 36.62 (6-11) | speed band |
| boxing_up_jab | 0.770 / 0.176 | 0.000 / 0.000 | 0.345 / 0.689 | 0.268 / 0.307 | 0.187 / 0.205 | 15.16 / 17.26 (4.5-9.5) | speed band |
| boxing_inside_uppercut | 0.006 / 0.006 | 0.000 / 0.000 | 1.668 / 1.737 | 0.868 / 0.988 | 0.467 / 0.512 | 11.46 / 13.19 (6.5-13.5) | hand join, root join, skin floor |
| dodge_retreat | 61.169 / 30.505 | 0.000 / 0.000 | 1.616 / 2.973 | 3.600 / 4.355 | 1.226 / 1.345 | 3.76 / 4.43 (reference/defence) | hand join, root join, skin floor, slip |
| dodge_advance | 59.924 / 48.494 | 0.000 / 0.359 | 3.427 / 3.471 | 3.689 / 4.469 | 0.646 / 0.708 | 2.84 / 3.32 (reference/defence) | foot floor, hand join, root join, skin floor, slip |
| high_center | 0.012 / 0.011 | 0.000 / 0.000 | 1.498 / 0.807 | 1.414 / 1.814 | 1.074 / 1.178 | 2.19 / 2.47 (reference/defence) | hand join, root join, skin floor |
| high_left | 0.011 / 0.009 | 0.000 / 0.000 | 1.818 / 0.811 | 1.941 / 2.198 | 1.085 / 1.190 | 1.84 / 2.12 (reference/defence) | hand join, root join, skin floor |
| high_right | 0.013 / 0.010 | 0.000 / 0.000 | 0.983 / 0.797 | 2.244 / 2.099 | 2.083 / 1.864 | 2.54 / 3.08 (reference/defence) | hand join, root join |
| low_center | 0.011 / 0.012 | 0.000 / 0.000 | 0.982 / 0.796 | 2.201 / 2.042 | 1.778 / 1.529 | 1.28 / 1.55 (reference/defence) | hand join, root join |
| low_left | 0.009 / 0.009 | 0.000 / 0.000 | 1.410 / 0.814 | 2.321 / 2.204 | 1.778 / 1.529 | 1.50 / 1.86 (reference/defence) | hand join, root join, skin floor |
| low_right | 0.008 / 0.009 | 0.000 / 0.000 | 0.979 / 0.793 | 1.425 / 1.828 | 1.085 / 1.190 | 1.81 / 2.15 (reference/defence) | hand join, root join |

**Full acceptance is still unavailable:** per-opponent target-line reach is `null`, and onset-to-impact band verification remains pending. The harness deliberately never turns those unknowns into a pass. The six stills support visible identity observations, not continuous-motion perfection or an opponent-contact certificate. f10 retains open hands in the retargeted output. No clip is bound merely because it looks plausible.

## Pipeline, evidence and reproducibility

- `c223_mixamo_adapter.gd`: all 61 supplied FBXs available during conversion became whole GLBs plus separate Mixamo hierarchy-rest references. Production hard-codes UE4 bone names, so the adapter renames the source vocabulary while retaining its transforms and joint axes; the actual Mixamo rest drives silhouette corrections. No production script was edited. Originals are untouched on disk.
- `c223_mixamo_validate.gd`: **C223_ADAPTER_VALIDATION total=61 fails=0**. Every 30 fps frame and all 22 mapped global joints, plus saved rest, match the FBX within <0.1 mm / <0.1 degree serialization tolerances; source lengths match. `receipt.json` contains source hashes. This is conversion validation, not animation acceptance.
- License: operator-supplied Adobe Mixamo, royalty-free embedded game/commercial use (C212); RamsterZ owned Unity Asset Store EULA, embedded game use, no standalone asset redistribution. No purchases, paid generation, Kimodo or Blender dependency.
- `c223_production_gate.gd`: fresh mounted rig and fresh unmodified production player per candidate; whole pipeline A, normal contact/onset derivation, normal queue/foot-lock/procedural passes. Candidate registration is in the isolated player only; `FightClipBinding.gd` is unchanged. The old `c223_clip_gate.gd` remains a raw diagnostic/helper and is labelled accordingly.
- Earlier run-4 data from a reused player were superseded after detecting order dependence. The final fresh-player run is `run4_candidates.json`. `run4_isolation_validation.json` verifies the reference and new Jab Punch in a standalone headless selection against the full rendered batch on both rigs: all checked numeric deltas **0.0**. Earlier local `run4_extra.json` is obsolete and is not delivery evidence.
- Final stills: `../docs/previews/c223/run4_<candidate>_<rig>.png`, six recorded production poses per sheet. Selection includes peak named-hand speed and maximum forward reach, start/recovery/end; coincident extrema can repeat a pose. Snapshot rendering does not feed back into another candidate because every candidate gets a new player. Game camera: broadcast, yaw 35 degrees. No video or executable.
- Resource jobs report errors=0, but FBX buffer warnings and ObjectDB shutdown leaks remain (108864 on the full isolated batch). Engine exit 0 means the measurement job completed, not that a candidate passed.
- Parse: **CHECK total=5 fails=0**. Requested tier exactly: `python Godot/tools/run_tests.py --jobs 1 --only clip,binding,fight_stage,boxing`: **SUITE total=25 fails=1**. `fight_stage_realism_test.gd`: **TOTAL=13 fails=8**, R1/R2/R3/R4/R5/R5b/R7/R8. Missing imported `boxing_boot.glb` also remains. No full suite.
- PC watchdog returned valid GREEN host readings before heavy runs. Silent windowed runs used `Tools/godot_hidden.ps1`. User run-4 instructions supersede generic fetch/rebase/mailbox intake and HANDOFF-writing rules: no pull/rebase, no forbidden handoff/status reads or edits, no master push.

Reproduce after a GREEN watchdog: headless `tools/c223_runtime_probe.gd` for reference/mutant calibration; hidden launcher `--path Godot --script tools/c223_production_gate.gd -- render` for all measurements/stills. Optional `clips=<candidate,...> report=<filename.json>` limits an audition. Source conversion/validation scripts read the original operator-supplied FBXs. `run4_candidates.json` is the final complete report, not the superseded extra-selection report.

Next work is still required: correct source/runtime joins and floor behaviour without widening gates; supply real up-jab/compact inside-uppercut/single body-cross/counter sequences; establish opponent target-line and timing checks, then promote only complete two-rig passes. Footwork, combo chains and kickboxing remain later batches.

---

# Historical runs (superseded where noted)

Gate-certified EXACT census: boxing 0/36 -> 0/36; kickboxing 0/20 -> 0/20 (C223 gate evidence, not legacy labels).

# Run 3 - contact-slip gate, reference calibration FAILS

2026-09-28. Boxing EXACT-that-PASSED before **0/36**, after **0/36**. No binding promoted. The requested four reference passes have NOT been achieved. Step 1 replaces the speed acceptance row with the requested **<=2 cm horizontal toe travel per contact run >=100 ms**, excluding the first/last two frames. Travel is the sum of horizontal segment lengths; maximum over all qualifying runs is gated. Existing vertical contact classifier and all four 5 cm slide injections are unchanged. Speed remains descriptive only. No threshold was widened and no reference was exempted.

| Reference | Rig | Contact travel achieved / wanted cm | 5 cm mutant achieved / wanted cm | Reference | Mutant |
|---|---|---:|---:|---|---|
| H2H_JabInPlace | f01 | 4.764449 / 2.00 | 8.565679 / 2.00 | FAIL | FAIL |
| H2H_RoundhouseKick_InPlace | f01 | 5.418063 / 2.00 | 7.668453 / 2.00 | FAIL | FAIL |
| H2H_JabInPlace | f10 | 3.241283 / 2.00 | 6.839415 / 2.00 | FAIL | FAIL |
| H2H_RoundhouseKick_InPlace | f10 | 10.037963 / 2.00 | 11.444725 / 2.00 | FAIL | FAIL |

All four 10 cm pop controls still fail. Calibration exits 2 because the references fail; it is not a passing slide gate. Net endpoint displacement also exceeds 2 cm in all four reference rows (3.866, 4.218, 2.216, 4.373 cm respectively at the greatest-travel run), so replacing path travel with net travel would not fix calibration. Per-run start/end frames, travel and net displacement are retained in `../docs/previews/c223/owned_punch_measurements.json`. Do not change contact eligibility using horizontal speed solely to discard the injected slides.

The raw whole-clip retarget audition has exposed real displacement under the prescribed contact proxy. Production `FightStagePlayer.advance` explicitly bypasses foot locking while `whole_active()` or the whole-effector tail is active; no claim that enabling its existing foot-lock flag repairs these clips. Production source is read-only under C223. More investigation is separate from the requested short gate change.

Parse: CHECK total=2 fails=0 (gate and production probe). Requested serial tier: **SUITE total=25 fails=1**, exit 1. `fight_stage_realism_test.gd`: **TOTAL=13 fails=8**, R1, R2, R3, R4, R5, R5b, R7, R8, matching the prior named rule failures. This run additionally reports a missing imported `boxing_boot.glb` resource, so it is not described as an environment-clean result. No full suite. Watchdog GREEN, real host counters. No video or executable. User continuation supersedes generic intake/rebase: Claude already rebased this branch; fetch succeeded with authorized host execution and master ancestry was confirmed. No forbidden handoff/status documents read or edited.

## MIXAMO WANTED

Claude downloads in the operator's signed-in Chrome with operator confirmation; Codex does not download or wait. **Live-verified 2026-09-28** in a separate read-only Mixamo search tab, `https://www.mixamo.com/#/?page=1&query=boxing&type=Motion%2CMotionPack` and pages 2/3 (117 results). Existing operator download dialog was left untouched. Many cards have the generic title **Boxing**; the exact description is essential to identify the take.

| Search terms / exact description | Clip card title | Intended audition |
|---|---|---|
| `Boxing Leading Hand Jab` | `Boxing` | Lead jab |
| `Back Hand Cross` | `Boxing` | Rear cross |
| `Boxing Lead Hand Hook` | `Boxing` | Lead hook |
| `Boxing Back Hand Hook` | `Boxing` | Rear hook |
| `Boxing Lead Hand Uppercut` | `Boxing` | Lead uppercut |
| `Boxing Back Hand Uppercut` | `Boxing` | Rear uppercut |
| `Short Body Jab`, `Mid Body Jab` | `Lead Jab` | Body jab; request both variants |
| `Short Hook Punch To The Body`, `Mid Hook Punch To The Body`, `Long Hook Punch To The Body` | `Hook` | Body hooks; handedness must be inspected |
| `Short Hook Punch To The Head`, `Mid Hook Punch To The Head` | `Hook` | Compact head-hook alternatives |
| `Boxing Body Jab Cross Short` | `Body Jab Cross` | Body combination source only, not a whole single body-cross replacement |

No exact single body-cross, shovel-hook or overhand title was established in these boxing results. Do not invent one or treat a reaction (`Receive Stomach Uppercut`, `Livershot Knockdown`) as a strike. Mixamo use is under Adobe's free game/commercial-use allowance as documented by C212; source downloads remain Claude's action. All imported takes still need whole-clip pipeline A, both-rig mechanics and shot-list review.

## Production-player witness (not certification)

`c223_runtime_probe.gd` binds each distinct rig through the unchanged `FightStagePlayer`, sets `strikes_play_whole` before bind, takes its normal manual clock, warms idle, calls `play_role`, and advances through the automatically queued idle. It does not disable procedural passes, overwrite bindings, lock sampled toes, or place an opponent. All four takes reach within one 60 Hz sample of their source endpoint and automatically transition to idle. This proves these role clips execute in the isolated production player; it does **not** prove technique-event routing, exact final-frame display, a bout target line, or that a new binding passed.

| Role | Rig | Contact slip achieved / wanted cm | Hand join cm/frame | Root join cm/frame | Queued idle |
|---|---|---:|---:|---:|---|
| jab | f01 | 4.701054 / 2.00 FAIL | 0.268127 | 0.187228 | yes |
| jab | f10 | 3.168990 / 2.00 FAIL | 0.307136 | 0.205337 | yes |
| kickboxing_roundhouse | f01 | 5.418076 / 2.00 FAIL | 2.497130 | 1.703985 | yes |
| kickboxing_roundhouse | f10 | 9.440273 / 2.00 FAIL | 2.994362 | 1.868767 | yes |

Evidence: `../docs/previews/c223/run3_runtime.json`; source seconds 0.833333 jab / 0.700000 roundhouse, last sampled clocks 0.816667 / 0.683333 respectively. Probe errors=0, accepted=0; engine emitted existing FBX buffer warnings and 3024 ObjectDB shutdown leaks, no SCRIPT ERROR. Join figures are descriptive, not a recalibrated acceptance band.

Existing f01/f10 jab sheets were opened again: load, a straight lead-hand action and return are visible, but six equally spaced frames omit the exact peak; f10 has open hands. This is not a new full shot-list sign-off. All replacement sources still need visual review before candidate measurement.

## Run-3 source access

Live `get_host_status`: Blender **not connected**. Reconnection requested while independent work continues. No `bl_generate_motion` callable is exposed in this session; `bl_list_models` also returned the disconnected-host error. No paid job submitted, spend 0.0 credits. A concurrent task-file edit now says Kimodo is out; it was preserved, and no generation route was started under either instruction. CMU 14_01/02/03 source/BVH preparation from run 2 remains available but is not an imported or certified clip. Existing game-dev CLI is not on PATH; task-authorized Godot/bl_* pipeline remains the production route. Existing CMU BVH-to-GLB converter requires Blender; no background Blender substitute was launched. The mailbox CLI accepts `--topic C223 --body <line>`, not the requested unsupported `--task C223 <line>` spelling; the equivalent supported one-line send is used for delivery.

---

## Prior run 2 (historical; contact-speed gate superseded)

# C223 - banded gate continuation, batch 1 INCOMPLETE

2026-09-28, continuing dc3d66fc/26589243 on codex/c223-boxing-kb-clips. Claude review 00:10 applied. No binding promoted; no executable or video. The requested batch is not finished.

## Current banded result

Skate <= max(0.30 m/s, 1.5 x same-rig reference), hand/root join <= 1.5 x reference, skin floor <= reference + 1.0 cm. These exact margins are AUTHORED tolerance choices explicitly proposed in Claude's 00:10 review, not numbers published by K44/C189. K44 supplies the 0.1-0.2 s blend range and broad toe-speed heuristics; C189 demonstrates retarget and join variability. The existing 0.15 s audition blend and pop/reach/contact-run measurements are retained. Foot/knee landmarks remain zero-penetration requirements.

**Calibration failure discovered:** the old `skate_5cm_detected` meant only mutant p95 > reference p95, not rejection by the candidate gate. The widened ceiling admits all four existing 5 cm mutants. The gate now prints actual mutant rejection and exits 2 if calibration fails, while retaining all candidate diagnostic measurements for review. It never certifies a binding on a merely measurable perturbation. Do not shrink the bands back to point values or change the injected defect simply to get green. A contact-slip measure that distinguishes a sustained plant from a push/pivot is still needed before certification.

| Reference | Rig | 5 cm mutant p95 m/s | Banded ceiling m/s | Rejected by skate gate |
|---|---|---:|---:|---|
| reference_jab | f01 | 0.232463 | 0.303815 | NO |
| reference_roundhouse | f01 | 0.917091 | 0.925637 | NO |
| reference_jab | f10 | 0.211010 | 0.304525 | NO |
| reference_roundhouse | f10 | 1.067576 | 1.336657 | NO |

Both reference motions pass their numerical rows on both rigs; all four 10 cm pop mutants are rejected. The skate control is the failing calibration. Every accepted field remains false. `owned_punch_measurements.json` is the CURRENT evidence; previous point-ceiling results below are historical.

| Move | Rig | Skate achieved / wanted m/s | Skin achieved / wanted cm | Hand join achieved / wanted cm/frame | Root join achieved / wanted cm/frame | Numerical failures |
|---|---|---:|---:|---:|---:|---|
| boxing_jab | f01 | 0.203 / 0.304 | 0.599 / 1.599 | 0.238 / 0.357 | 0.303 / 0.455 | none; NOT certified |
| boxing_cross | f01 | 0.228 / 0.304 | 0.482 / 1.599 | 0.238 / 0.357 | 0.303 / 0.455 | none; NOT certified |
| boxing_lead_hook | f01 | 1.217 / 0.304 | 1.638 / 1.599 | 0.240 / 0.357 | 0.304 / 0.455 | skate_p95_m_s, skinned_penetration_cm |
| boxing_lead_uppercut | f01 | 0.150 / 0.304 | 0.255 / 1.599 | 0.506 / 0.357 | 0.528 / 0.455 | join_hand_cm_frame, join_root_cm_frame |
| boxing_overhand | f01 | 0.225 / 0.304 | 1.842 / 1.599 | 0.240 / 0.357 | 0.304 / 0.455 | skinned_penetration_cm |
| boxing_jab | f10 | 0.203 / 0.305 | 1.142 / 2.142 | 0.263 / 0.394 | 0.333 / 0.499 | none; NOT certified |
| boxing_cross | f10 | 0.246 / 0.305 | 0.560 / 2.142 | 0.263 / 0.394 | 0.333 / 0.499 | none; NOT certified |
| boxing_lead_hook | f10 | 1.316 / 0.305 | 1.707 / 2.142 | 0.264 / 0.394 | 0.333 / 0.499 | skate_p95_m_s |
| boxing_lead_uppercut | f10 | 0.213 / 0.305 | 0.862 / 2.142 | 0.570 / 0.394 | 0.579 / 0.499 | join_hand_cm_frame, join_root_cm_frame |
| boxing_overhand | f10 | 0.204 / 0.305 | 2.034 / 2.142 | 0.265 / 0.394 | 0.333 / 0.499 | none; NOT certified |

## Batch-1 disposition (all shot-list rows)

All rows additionally remain held by failed skate calibration and unverified production queue/guard joins. No legacy binding is relabelled as a C223 pass.

| Move | Decision and reason |
|---|---|
| boxing_jab | Numerical pass both rigs; Claude's f01 visual pass retained; f10 sheet inspected this run, extension and recovery visible. Certification held by calibration/runtime evidence. |
| boxing_double_jab | No whole two-jab take auditioned here; single jab cannot establish second jab from half retraction. Legacy EXACT is not certified. |
| boxing_up_jab | No demonstrated low-lead-hand rising jab; ordinary head jab is not this move. |
| boxing_jab_body | No demonstrated level-change/solar-plexus jab; head jab cannot stand in. |
| boxing_cross | Numerical pass both rigs after bands. Still rejected visually: f10 sheet inspected again, deep post-contact head-down dip at 0.500 s; head drop 20.7/22.9 cm. Whole-clip rule forbids using a trim as the solution. |
| boxing_cross_body | No demonstrated body cross; the head cross's dip AFTER extension does not establish a body target. |
| boxing_lead_hook | REJECTED per Claude 00:10; skate 1.217/1.316 m/s, f01 skin floor 1.638 > 1.599 cm. |
| boxing_rear_hook | No independent passing source. A mirror of the rejected lead-hook motion is not a certified replacement; no mirror audition claimed. |
| boxing_body_hook | No demonstrated lead hook to ribs with level change; rejected head hook cannot stand in. |
| boxing_rear_hook_body | No demonstrated rear hook to body; no accepted whole source. |
| boxing_shovel_hook | No demonstrated liver-directed half-hook/half-uppercut. GroinPunch is not accepted on its name: U108 turn 58.98 deg, drop 0.4464 m, zero swaps, and wrong named target. Not visually auditioned or certified. |
| boxing_lead_uppercut | REJECTED per Claude 00:10; U108 turn 83.99 deg, two swaps, drop 0.3305 m, source handedness disputed; joins fail both rigs even with bands. |
| boxing_rear_uppercut | No independent demonstrated rear uppercut; rejected leading/jumping sources cannot be renamed into acceptance. |
| boxing_inside_uppercut | No demonstrated compact clinch-range uppercut; jumping uppercuts show U108 turn 176.83 deg, four swaps, drop 0.3811 m. |
| boxing_overhand | Fails f01 skin floor 1.842 > 1.599 cm; f10 numerical pass alone is insufficient. Large head dip and 31.9/36.6 m/s hand peaks remain concerns. |

## Source preflight and generation access

`batch1_source_preflight.json` records U108 turn_max_deg, lead_swaps and level_drop_m for every owned punch-named candidate, including forward variants. These are SOURCE measurements, separately printed from retargeted mechanics; U108's jab swaps=2 versus our retargeted toe-based switches=0 is not silently treated as agreement. References and candidates now require all three U108 fields before retarget/render. The rejected lead-hook/lead-uppercut sources cannot be rerendered through this harness's render mode; their retained sheets remain rejection evidence. Owned licence: RamsterZ Unity Asset Store EULA, embedded game use, no standalone redistribution.

Kimodo discovery this run: exposed tools include no `bl_generate_motion` submit tool; Higgsfield model searches for both `Kimodo` and `ardy` returned zero entries; marketplace Kimodo search returned zero, motion search returned a video-overlay app only. No suitable cloud generation was submitted. The old repository t2m runners require background Blender plus its add-on; they were inspected, not launched or represented as a current callable cloud endpoint. Blender was not awaited and Mixamo sign-in was not attempted. This is a current execution limitation, not evidence that Kimodo is generally unavailable.

Spend this run: 0 jobs, 0.0 / 3.0 credits; no ledger reservation or charge to record. No purchase. Production bindings unchanged. No new render was needed to reject the previously reviewed sources.

## Current validation and delivery

- Parse: CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0.
- Banded focused diagnostic: ENGINE_RC 2; C223_DIAGNOSTIC errors=1 accepted=0 mode=measure. Expected explicit failure: all four skate mutants admitted by the band.
- Serial task tier: SUITE total=25 fails=1, exit 1. Only fight_stage_realism_test.gd failed, TOTAL=13 fails=8: R1 space_between_exchanges, R2 stance_takes, R3 planted_foot_skate, R4 back_in_guard, R5 joins_move_like_the_performance, R5b joins_against_the_same_frames, R7 bodies_never_pass_through, R8 the_fist_reaches_its_target. Same named failures as checkpoint; production bindings/scripts unchanged. No full suite.
- Watchdog: GREEN with real Windows counters before heavy runs; latest C free 41.4 GB, RAM 71%, CPU 12%, temperature unavailable. Initial sandbox CIM/engine launch denial resolved with approved execution; invalid zero-space output not used.
- Explicit continuation and dirty shared-worktree state supersede generic fetch/rebase/mailbox intake. Preserved existing task/review/shot-list/import-sidecar files; no HANDOFF edit or master push.

Next required work: restore meaningful slide-control rejection under tolerance bands, verify production whole-clip/guard joins on both rigs, obtain a callable Kimodo motion endpoint, then audition replacement whole clips. Batch 1 remains open; batches 2-5 have not started.

---

# Historical checkpoint dc3d66fc/26589243 (superseded numerical thresholds)


2026-09-28. No binding changed. Legacy census remains boxing EXACT 2 / NEAR 21 / FAMILY 13 and kickboxing EXACT 9 / NEAR 6 / FAMILY 5. The zero certified counts mean no complete C223 sign-off, not that every old clip has been proven wrong. Batches 2-5 have not begun.

## Evidence and limits

Fourteen six-frame PNG sheets cover five owned punches and two references on f01_m_box_welter_rigged (66.7 kg) and f10_m_bare_heavy_rigged (100 kg), separately mounted, never identical opponents. Whole RamsterZ sources use T-pose retarget and silhouette corrections. Camera is FightCameraRig broadcast at yaw 35 degrees. No video or executable produced.

`c223_clip_gate.gd` is a diagnostic audition, NOT a completed runtime acceptance gate. It samples whole retargeted clips at 60 Hz, measures world-space bone positions and all skin influences of foot/lower-leg vertices, and advances an actual AnimationPlayer through the final endpoint and an idle blend. It does not yet exercise FightStagePlayer's event queue, grounding or foot locks. Every JSON `accepted` remains false. Absolute target height, non-striking guard and semantic identity still need per-move visual review; straight extension alone cannot certify contact with an opponent.

Claude's review was read, including the 00:05 gate correction. Reach is now per-limb geometry (straight extension fraction >=0.95; other punches crossing centre is diagnostic only). Skate uses >=100 ms contact runs with two boundary frames excluded. Pop uses second difference above derived 400 m/s2 limb / 200 trunk ceiling and 3x neighbouring acceleration, plus a reversing-neighbour impulse signature to distinguish a one-frame offset from a keyed velocity corner. The latter signature is an additional implementation choice requiring review; it is not a primary-study threshold. Step excess over own p95 remains printed descriptively, not used as a rejection of ordinary fast strikes.

Both references pass their own diagnostics on both rigs. Each detects a 10 cm one-frame striking-bone displacement in recovery and an adversarial 5 cm planted-foot slide along the contact run's peak horizontal direction. This demonstrates these controls, not all possible faults. Candidate skate, floor and audition join limits are the measured same-rig jab; roundhouse has its own reference. Floors retain the reference's nonzero penetration rather than pretending zero. Full threshold provenance and achieved/wanted values are in `../docs/previews/c223/owned_punch_measurements.json`.

## Per-clip diagnostic table

Each cell with a slash is achieved / wanted. Pop excess is descriptive cm/frame, pop count must be zero. Foot/knee landmarks are 0/0 cm for every row; the skin column includes lower-leg vertices. All audition clocks reached the whole source endpoint, but production played-whole remains unknown.

| Move | Rig | Skate m/s | Skin floor cm | Pop excess; count | Extension fraction | Join hand cm/frame | Join root cm/frame | Diagnostic |
|---|---|---:|---:|---:|---:|---:|---:|---|
| reference_jab | f01 | 0.203 / 0.203 | 0.599 / 0.599 | 16.78; 0 | 1.000 | 0.238 / 0.238 | 0.303 / 0.303 | pass |
| reference_roundhouse | f01 | 0.617 / 0.617 | 0.793 / 0.793 | 20.86; 0 | 0.986 | 0.240 / 0.240 | 0.304 / 0.304 | pass |
| boxing_jab | f01 | 0.203 / 0.203 | 0.599 / 0.599 | 16.78; 0 | 1.000 | 0.238 / 0.238 | 0.303 / 0.303 | pass |
| boxing_cross | f01 | 0.228 / 0.203 | 0.482 / 0.599 | 13.32; 0 | 0.998 | 0.238 / 0.238 | 0.303 / 0.303 | skate_p95_m_s, join_hand_cm_frame |
| boxing_lead_hook | f01 | 1.217 / 0.203 | 1.638 / 0.599 | 6.06; 0 | 0.896 | 0.240 / 0.238 | 0.304 / 0.303 | skate_p95_m_s, join_hand_cm_frame, join_root_cm_frame, skinned_penetration_cm |
| boxing_lead_uppercut | f01 | 0.150 / 0.203 | 0.255 / 0.599 | 8.62; 0 | 0.792 | 0.506 / 0.238 | 0.528 / 0.303 | join_hand_cm_frame, join_root_cm_frame |
| boxing_overhand | f01 | 0.225 / 0.203 | 1.842 / 0.599 | 32.36; 0 | 0.979 | 0.240 / 0.238 | 0.304 / 0.303 | skate_p95_m_s, join_hand_cm_frame, join_root_cm_frame, skinned_penetration_cm |
| reference_jab | f10 | 0.203 / 0.203 | 1.142 / 1.142 | 18.77; 0 | 1.000 | 0.263 / 0.263 | 0.333 / 0.333 | pass |
| reference_roundhouse | f10 | 0.891 / 0.891 | 0.961 / 0.961 | 22.33; 0 | 0.987 | 0.264 / 0.264 | 0.333 / 0.333 | pass |
| boxing_jab | f10 | 0.203 / 0.203 | 1.142 / 1.142 | 18.77; 0 | 1.000 | 0.263 / 0.263 | 0.333 / 0.333 | pass |
| boxing_cross | f10 | 0.246 / 0.203 | 0.560 / 1.142 | 14.41; 0 | 0.998 | 0.263 / 0.263 | 0.333 / 0.333 | skate_p95_m_s, join_hand_cm_frame |
| boxing_lead_hook | f10 | 1.316 / 0.203 | 1.707 / 1.142 | 7.83; 0 | 0.896 | 0.264 / 0.263 | 0.333 / 0.333 | skate_p95_m_s, join_hand_cm_frame, join_root_cm_frame, skinned_penetration_cm |
| boxing_lead_uppercut | f10 | 0.213 / 0.203 | 0.862 / 1.142 | 10.11; 0 | 0.792 | 0.570 / 0.263 | 0.579 / 0.333 | skate_p95_m_s, join_hand_cm_frame, join_root_cm_frame |
| boxing_overhand | f10 | 0.204 / 0.203 | 2.034 / 1.142 | 36.14; 0 | 0.979 | 0.265 / 0.263 | 0.333 / 0.333 | skate_p95_m_s, join_hand_cm_frame, join_root_cm_frame, skinned_penetration_cm |

## Semantic review

- Jab: Claude passed f01 by eye; both rigs pass diagnostics. Production queue/join verification remains outstanding, so no promotion.
- Cross: source extension is present, but deep dip remains. Measured retargeted head drop 20.7 / 22.9 cm (f01/f10). Skate and guard join fail. Find a cleaner source; do not label exact.
- Lead hook: Claude provisional visual pass; measured peak hand is LEFT on both rigs. Skate, skin floor and joins fail.
- Lead uppercut: Claude REJECTED the source's crouch/turn/stance changes. U108 source hip drop 33 cm, turn 84 degrees, two lead swaps. Retargeted peak-speed hand reads LEFT while Claude cites U85 RIGHT: unresolved metric/source discrepancy, not proof of correct identity. Reject this take regardless of that discrepancy.
- Overhand: right-hand peak 31.9 / 36.6 m/s; large head dip and failed skate/floor/joins. Existing EXACT label is not a C223 pass.

All remaining batch-1 punches are unauditioned: rear hook, up jab, body jab/cross/hooks, shovel hook, rear/inside uppercut. Mirroring a whole retargeted hook is allowed but not yet measured. Defence, footwork, combination chains and kickboxing remain pending; the roundhouse row is calibration only, not kickboxing certification.

## Sources and blockers

Owned RamsterZ H2H: Unity Asset Store EULA, embedded game use; no standalone redistribution. Existing owned sources were referenced, not copied. Catalogue and U108 evidence were checked before accepting any identity.

Mixamo: browser reached public home, signed out. The Log In click was rejected by automatic approval because Adobe/Mixamo sign-in was not specifically authorized. User authorization is pending; no bypass attempted.

CMU: public subject 14 trials 01/02/03 are boxing at 120 Hz. Download hashes/URLs in `../assets/anim/c223/cmu_source/receipt.json`; ASF/AMC converted by the existing Tools/cmu_to_bvh.py into 5594/5423/5536-frame BVHs. These are local preparation, NOT usable game clips or completed source auditions. Raw downloads and derived BVH are ignored to avoid committing ~29 MB before take selection. CMU permits copying/modification and redistribution, including commercial incorporation, but not direct resale of the data; see SOURCE.md. No paid generation or purchases.

Blender was initially connected, then returned disconnected; latest host-status check still reports disconnected. Operator must open Higgsfield's Blender panel and press Connect. Live import/authoring is waiting for that connection; no background Blender substitution. Batch 4 also needs an agreed implementation seam: current FightStagePlayer queues idle rather than multi-clip sequences, while C223 owns binding rows only. Requested minimal scope clarification; no out-of-window production edit.

## Validation and reproduction

- Parse `python Godot/tools/check_scripts.py Godot/tools/c223_clip_gate.gd`: CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0.
- Focused tier exactly as assigned, jobs 1: SUITE total=25 fails=1. `fight_stage_realism_test.gd` fails R1 space_between_exchanges, R2 stance_takes, R3 planted_foot_skate, R4 back_in_guard, R5 joins_move_like_the_performance, R5b joins_against_the_same_frames, R7 bodies_never_pass_through, R8 the_fist_reaches_its_target (TOTAL=13 fails=8). Production code/bindings are unchanged; this is not a green tier. No full suite.
- Latest diagnostic: ENGINE_RC 0; C223_DIAGNOSTIC errors=0 accepted=0 mode=measure. Four calibration rows print reference_pass=true, pop_mutant_detected=true, skate_mutant_detected=true.
- Watchdog green before each heavy run. Sandbox CIM denial initially gave invalid zero-space reading; elevated read-only host counters were used instead. Windowed stills used Tools/godot_hidden.ps1. Godot import's content-identical tracked sidecar rewrites were restored; unrelated task/review/shot-list edits were preserved.
- Reproduce measurements after cache import and PNG capture: Godot console `--headless --path Godot --script tools/c223_clip_gate.gd -- measure`. Stills use the hidden launcher with the same script and `-- render` (optional `clips=...`). Run the watchdog first.

This is a reviewable batch-1 checkpoint, not batch-1 delivery or C223 completion. Next: production jab audition, resolve failed source choices after Mixamo/Blender access, then complete batch 1 before proceeding in order.
