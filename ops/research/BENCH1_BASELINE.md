# BENCH1 baseline (engine instrumentation only)

BENCH1B records the real presented fight on the operator PC. The baseline, movie and guarded stills are preserved in `previews/bench1/`.

## Intent not yet expressible in the sim (logged, not faked)

- Forced miss distance (e.g. jab whiff 8 cm outside the ear) — `params.intent_miss_cm` stays in the timeline/CSV only.
- Forced damage thresholds (18 vs 34) — sim damage still comes from ImpactModel, not script params.
- Clinch hold/break at scripted timestamps — needs `boxing_clinch` room path + referee break timing wired to the hook.
- Slip / pivot / CoM shift magnitudes — defence and footwork hooks are intent-only today.
- Miller composure-driven pad-chain suppression — composure is seated when `ludo_composure` is on; scripted shaken state is partial.

## Grader

`python3 Tools/smooth_metrics.py --bench <csv>` prints `STEP n PASS|FAIL measured=<x> threshold=<y>` for steps 1–9. Expect mostly FAIL until HUMAN1–6 land; thresholds are not relaxed.

## Synthetic fixture

`Godot/tests/fixtures/bench1_synthetic_step1_pass.csv` — stdlib/numpy grader smoke only.


## Baseline (master 1e93e0d9615ea38918055ede1a2c8cf2790baa92)

Recorded 2026-10-10 on Windows, Godot 4.7.2, Vulkan Forward+, AMD Radeon RX 6800 XT. BENCH1B changes only the benchmark capture path: the LudoCast conversion from `bench1_test.gd`, seed 930093, boxing, A/red Leo Vance versus B/blue Ray "Meat-Axe" Miller, and the broadcast camera with `as_game`. The game's existing identity kit renders Miller in purple trunks; blue denotes his benchmark side, not a changed costume. No animation or grader threshold was changed.

The existing `RenderingServer.frame_post_draw` sampler reads the presented players' skeleton world poses, AnimationPlayer clips/times and camera after rendering. The blue metrics formerly emitted eleven fields for ten header columns; BENCH1B removes that extra placeholder and checks every row's width. Earlier malformed captures are discarded. Benchmark initialization is deferred until the scene tree is active so the recording overlay builds its labels before being enabled.

`E:/FightCamp/tmp/bench1/base.csv`: **1,860 data rows** plus header, 31 fields in every row, frames 1-1860, presented timestamps 0.016667-31.000000 s, fixed 60 fps. This covers the initial bell and the complete 30-second script plus one second. The preserved CSV is [base.csv](../docs/previews/bench1/base.csv).

Graded with `python Tools/smooth_metrics.py --bench E:/FightCamp/tmp/bench1/base.csv`:

```text
STEP 1 FAIL measured=0.000000 threshold=4.0
STEP 2 FAIL measured=hop=247,min_width_m=0.281886 threshold=hop=0,width>=0.30
STEP 3 FAIL measured=0.000000 threshold=3.0
STEP 4 PASS measured=0.591305 threshold=>0.01
STEP 5 PASS measured=0.000000 threshold=12.0
STEP 6 FAIL measured=0 threshold=>=1
STEP 7 FAIL measured=0.000000 threshold=0.03
STEP 8 FAIL measured=0.000000 threshold=8.0..14.0
STEP 9 FAIL measured=0.000000 threshold=1.0..1.8
CAMERA accel_jerk_std=692.994480
JOIN_TOTAL count=20 median=nan p95=nan max=nan
```

Seven FAIL, two provisional PASS. These are the unchanged grader's results, not proof that all nine properties are instrumented. Only pelvis positions, stance width, presented clip/time, event/force and camera are populated today. Foot-lock flags, gaze, strike phase, head displacement/rotation, CoM margin, wrist drop and glove spring are placeholders. In particular, Step 5's zero gaze error is a placeholder pass; Step 4 uses absolute pelvis X rather than the specified pelvis-before-glove timing. Step 2's hop count is from placeholder unlocked feet, while its minimum stance width is a real posed-skeleton measurement. JOIN_TOTAL measures red clip changes but reports unavailable acceleration statistics as `nan`. CAMERA includes the existing sampler's startup from a zero previous camera position and velocity; its label calls this jerk, though the calculation is acceleration magnitude. None of these limitations is repaired by loosening a threshold.

### Movie and guarded stills

[overlay.mp4](../docs/previews/bench1/overlay.mp4): 1920x1080, 30 fps, 930 frames, 31 seconds. The requested local output is `E:/FightCamp/tmp/bench1/overlay.mp4`; [overlay.csv](../docs/previews/bench1/overlay.csv) has 930 correctly aligned rows, presented timestamps 0.025000-30.991667 s.

Godot rejected direct `--write-movie overlay.mp4` with "Can't find movie writer for file type". The supported `--write-movie E:/FightCamp/tmp/bench1/overlay.avi` take was encoded to H.264/yuv420p MP4 with ffmpeg (`-crf 18 -movflags +faststart`). The supported take is the final evidence. No visible desktop, browser or player was opened.

The harness calls `still_framing.gd.save_if_framed` on movie frames 90, 300 and 660 (zero-based). All three printed STILL_FRAMING OK. The final PNGs were extracted from those exact MP4 frames after guard approval, then opened with the file image tool. Both fighters' heads and feet are inside every frame:

- [overlay_03s.png](../docs/previews/bench1/overlay_03s.png): Vance left in red, Miller right in purple, close guard at the probe-jab segment; clock 2:57, both full bodies visible.
- [overlay_10s.png](../docs/previews/bench1/overlay_10s.png): separated high guards over the centre logo in the landed-cross segment; clock 2:50, Vance stepping and Miller leaning back, both full bodies visible.
- [overlay_22s.png](../docs/previews/bench1/overlay_22s.png): both reset in guard during the heavy-combination segment; clock 2:38, Miller's CUT indicator visible, both full bodies visible.

These are observed poses at the requested times, not claims that every authored intent was realized. The existing debug overlay has layout defects (text under the upper HUD and vertically wrapped along the left edge), and its magenta markers are not validated CoM locations: `_add_com_marker` assigns a global transform before adding its mesh to the tree, logging `!is_inside_tree()`. Those out-of-scope overlay defects remain visible in the movie. Existing FBX "Reading less data than requested" warnings and resource-leak teardown diagnostics were also logged. The final takes contain no GDScript SCRIPT ERROR; they are not clean engine-error logs.

### Reproduce and gates

Use `Tools/godot_hidden.ps1` with `FIGHTCAMP_GODOT_EXE` set to the non-console Godot 4.7.2 executable. Enforce a 1200-second subprocess timeout on each windowed run:

```text
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/record_room.gd --resolution 1920x1080 --fixed-fps 60 --quit-after 1860 -- as_game bench1=1 bench=1 csv=E:/FightCamp/tmp/bench1/base.csv
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/record_room.gd --resolution 1920x1080 --fixed-fps 30 --quit-after 930 --write-movie E:/FightCamp/tmp/bench1/overlay.avi -- as_game bench1=1 bench=1 csv=E:/FightCamp/tmp/bench1/overlay.csv debug_overlay=1 bench_stills=res://docs/previews/bench1 bench_stills_fps=30
```

- `python Godot/tools/check_scripts.py Godot/tools/record_room.gd`: CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0.
- `python Godot/tools/run_tests.py --only bench1_test --timeout 300 --verbose`: SUITE total=1 fails=0 (non-console engine).
- CSV validation: every row has 31 fields; frames consecutive; base 1860 rows, overlay 930 rows.
- Framing receipts and artifact SHA-256 hashes: [capture_receipt.txt](../docs/previews/bench1/capture_receipt.txt).

Task-specific rules supersede generic console-engine, broad affected-suite and HANDOFF/mailbox-write rules. Only the task's parse and focused test gates were run; HANDOFF.md and AgentComms were not written.

## After HUMAN1

Recorded 2026-10-10, Godot 4.7.2, the same seed 930093, Leo Vance versus Ray Miller, broadcast game camera, 1920x1080, fixed 60 fps and 1,860 frames. Both `human_hit_additive` and `human_flinch` remain OFF by default, including the demo. The operator explicitly permitted the minimal room switch/opponent/frame wiring and capture forwarding beyond the original "bench columns ONLY" window, and the realism runner's 1,307-second timeout. Master, HANDOFF.md and AgentComms were not edited.

The additive layer restores its writes before the next clip sample, then applies the existing FightHitAdditive/FightFlinch maths after the sampled pose. Head/neck/spine rotation uses the existing retarget map and the 0.6/0.3/0.1 split. Light contacts preserve both playing clips; heavy contacts retain the full reaction. Missing named impact directions fall back to the direction away from the attacker. Glove sampling runs after both bodies advance. CSV values measure the before/after posed head transforms, impulse envelope, real glove proximity and flinch displacement; no grader threshold was changed.

### Controlled contact and measurement limits

The unchanged BENCH1 simulation does not forward its scripted 18-damage cross intent to Miller's presenter in the Step 1 window. [on.csv](../docs/previews/human1/on.csv), with only the two response switches, records **STEP 1 FAIL measured=0.055953**, **STEP 3 PASS measured=6.229161**. This is retained as evidence rather than silently relabeled a passing simulation take. Its `sim_damage_value` remains the original normalized force field, not an 18-point damage measurement.

To exercise the requested 18-damage presentation contract, the capture tool has an explicit, OFF-by-default `human1_contact_probe=1`: Vance starts the real cross clip at 9.75 s; Miller receives an explicit 18-damage clean-contact presentation input at 10.0 s. The simulation log and its event/damage CSV columns are unchanged. `bench_stimulus=human1_contact_18` labels this controlled input, and the log prints `HUMAN1 CONTROLLED_CONTACT`. This proves the additive response to a known contact input; it does not prove that the original simulation delivered that cross or that its glove visibly contacted the head. The proximity flinch is from actual opponent glove motion, without a synthetic glove input.

[probe.csv](../docs/previews/human1/probe.csv), graded by the unchanged `Tools/smooth_metrics.py`:

```text
STEP 1 PASS measured=7.504985 threshold=4.0
STEP 2 FAIL measured=hop=247,min_width_m=0.461419 threshold=hop=0,width>=0.30
STEP 3 PASS measured=6.229161 threshold=3.0
STEP 4 PASS measured=0.591305 threshold=>0.01
STEP 5 PASS measured=0.000000 threshold=12.0
STEP 6 FAIL measured=0 threshold=>=1
STEP 7 FAIL measured=0.000000 threshold=0.03
STEP 8 FAIL measured=0.000000 threshold=8.0..14.0
STEP 9 FAIL measured=0.000000 threshold=1.0..1.8
CAMERA accel_jerk_std=691.839977
JOIN_TOTAL count=21 median=nan p95=nan max=nan
```

Before/after: Step 1 0.000000 FAIL -> 7.504985 PASS (controlled contact); Step 3 0.000000 FAIL -> 6.229161 PASS (real proximity flinch). No other STEP verdict worsened; Step 2's measured minimum width increased from 0.281886 m to 0.461419 m, with the same 247 placeholder unlocked-foot rows. The baseline's Step 4/5 provisional passes and other uninstrumented properties retain their original limitations.

[off.csv](../docs/previews/human1/off.csv) has 1,860 rows and all 31 original master columns match the preserved master baseline exactly: maximum numeric difference 0.0, zero string mismatches. The three new columns carry zero response weights and `none` stimulus. All capture CSV rows have their header's field count and consecutive frame numbers. [capture_receipt.txt](../docs/previews/human1/capture_receipt.txt) contains grading, framing receipts and SHA-256 hashes.

### Guarded game-camera stills

Both stills were saved directly by `still_framing.gd.save_if_framed`, printed `STILL_FRAMING OK ... shot=broadcast err=0`, and were opened only with the file image tool. Both fighters are visible from head to feet. The filenames identify the requested segments; the receipts give the exact response frames:

- [overlay_03s.png](../docs/previews/human1/overlay_03s.png): actual glove-triggered flinch at 2.833333 s, Miller in purple drawing his head away in close guard opposite Vance in red; measured retreat 3.789438 cm and chin/head rotation 4.663881 degrees.
- [overlay_10s.png](../docs/previews/human1/overlay_10s.png): 10.033333 s, Vance's cross clip continues while Miller's head is deflected backward by the controlled contact, 6.299180 degrees; flinch displacement is zero. Vance's clip time advances 0.250000 -> 0.266667 -> 0.283333 -> 0.300000 across the contact, and the peak head snap reaches 7.504985 degrees at 10.05 s. The image is response evidence, not proof of glove/head contact.

### Validation

The previous run reported **RED: 7 failures on master** (the seven absent-response witnesses). This continuation parses all five touched scripts: `CHECK total=5 fails=0 autoload_refs=0 autoload_warnings=0`; the final capture-only guard/refactor also parses successfully.

- `human1_test`: PASS, Leo Vance versus Ray Miller; 18-damage snap/settle, both clip clocks, 34-damage full reaction, 20 cm whiff, contact priority, 10-second idle accumulation guard and OFF control, plus real room switch/opponent wiring.
- `anim_smooth`: 2/2 PASS; `bench1`: 1/1 PASS (combined focused run `SUITE total=4 fails=0`).
- Other `fight_stage` tests: 9/9 PASS, `SUITE total=9 fails=0`, jobs 2, 300-second base ceiling.
- After committing and rebasing `codex/human1` onto fetched upstream: all five scripts parse again, and `human1,bench1` pass again (`SUITE total=2 fails=0`). Committed CSV/PNG blob hashes match the capture receipt.
- Realism: the final isolated run completed within its allowed 1,307-second ceiling, **rc=1, TOTAL=13 fails=7, SUITE total=1 fails=1**. Failed rules: R1 space between exchanges, R2 stance takes, R3 planted-foot skate, R3b feet above canvas, R5 join motion, R5b joins against the same frames, R7 body overlap. These are the seven GATED S4a baseline rules documented in the runner's slow-test notes; HUMAN1 defaults OFF in this run. The unmodified corner-panel absolute node lookup also logged engine errors while this test stepped the room synchronously from `_initialize`. [realism.log](../docs/previews/human1/realism.log) preserves the complete result. Two earlier attempts exited abnormally with rc=-1 before a summary. No attempt was manually stopped at 300 seconds. **The task's requested all-green realism gate remains unmet; the controlled bench PASS is not a claim that these broader realism failures were fixed.**

Captures use the hidden desktop launcher, non-console engine, Dummy audio and a 1,200-second subprocess timeout. No desktop viewer, browser or video player was opened. Capture logs contain no GDScript SCRIPT ERROR; pre-existing FBX-read warnings and teardown leak/resource diagnostics remain.

Reproduce the controlled measurement (set `FIGHTCAMP_GODOT_EXE` to the installed non-console executable and enforce a 1,200-second subprocess timeout):

```text
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/record_room.gd --resolution 1920x1080 --fixed-fps 60 --quit-after 1860 -- as_game bench1=1 bench=1 human_hit_additive=1 human_flinch=1 human1_contact_probe=1 csv=E:/FightCamp/wt/HUMAN1/previews/human1/probe.csv bench_stills=res://docs/previews/human1 bench_stills_fps=60
python Tools/smooth_metrics.py --bench previews/human1/probe.csv
```

Omit `human1_contact_probe=1` for the unforced ON capture; omit both response switches and the probe for the OFF control. The original baseline above remains unchanged.

## After HUMAN2

### Instrumentation-first OFF control (before any motion change)

Master production code (3635c736; owned motion files equal origin/master 9f2b2a73), Leo Vance versus Ray Miller, seed 930093, 1,860 frames at 60 fps. The CSV now reads the runtime per-foot plant states, including the existing world-planted shuffle, instead of four zero placeholders. No motion changed for this run.

`STEP 2 FAIL measured=hop=244,min_width_m=0.281886 threshold=hop=0,width>=0.30`

The original placeholder count was 247. Runtime lock instrumentation removes only three frames. The grader counts double-unlocked flags throughout the 12.5-16.5 s segment, including whole strike clips; it does not filter by ground speed. This count is not evidence that every counted frame visibly has both soles above the canvas.

Pre-motion HUMAN2 test: seven absent-feature witnesses fail (`HUMAN2 fails=7`), no script errors. Parse: instrumented player/harness and new test pass. A headless editor import reached its 300-second ceiling; its generated cache then supported the tests and the complete hidden OFF capture. No visible viewer or browser was opened.

### Owned player implementation and focused evidence

HUMAN2 remains default OFF. The opt-in player replaces the legacy threshold shuffle with one swing foot and one world support ball, alternating a 48 cm paired stride; forward starts with the lead, backward with the rear. Its clock is the player's clip time, and its stride rate follows requested root speed. Late room corrections re-solve against the same support anchor instead of dragging it. Whole takes, paired takes and set pieces are excluded from the HUMAN2 solver. Pivot correction steps the rear foot while retaining the lead-ball anchor. FightFootLock's existing blind-tested `step()` contract is unchanged.

The focused two-boxer test passes before the mutant: Leo Vance forward/back minimum stance 0.319614/0.328168 m, locked drift 0.005196/0.000001 m; Ray Miller 0.334547/0.339431 m, drift 0.004960/0.000001 m. All four exercises have zero double-unlocked frames and zero root/distance error. The deliberately repeated-swing-foot mutant produces four order failures, one per boxer/direction, then is restored. The test also checks OFF against the four pose digests recorded before motion edits; the mutant run confirms those checks still pass. Final green rerun passes (HUMAN2 fails=0); the recorded master pose digests and OFF restoration checks pass.

The 1,860-row instrumented OFF CSV compares with the preserved master BENCH1 CSV: maximum absolute difference is exactly 0.0 for both pelvis X/Z, both stance widths, defender head angle and defender head displacement. The lock flags are the intentional instrumentation difference.

Final checks: human2 1/1, bench1 1/1, anim_smooth 3/3, foot 9/9 pass. Parse 4/4 passes. fight_stage: SUITE total=10 fails=1; nine pass, fight_stage_realism_test.gd times out at TASK_HUMAN2's 300-second per-engine ceiling. The task ceiling overrides the runner's normal slow-test allowance. No full suite. The requested all-green fight_stage criterion is unmet.

**Incomplete integration:** TASK_HUMAN2 restricts record_room.gd to bench columns and does not own FightWorldLiveScreen.gd or c223_production_gate.gd. The required room option, ON benchmark forwarding/still selection and C223 ON activation need those minimal wiring edits. Scope clarification was requested before changing those files/sections. No room-option, ON benchmark or C223 ON result is claimed at this checkpoint.

The complete OFF STEP lines (ON capture remains pending):

```text
STEP 1 FAIL measured=0.000000 threshold=4.0
STEP 2 FAIL measured=hop=244,min_width_m=0.281886 threshold=hop=0,width>=0.30
STEP 3 FAIL measured=0.000000 threshold=3.0
STEP 4 PASS measured=0.591305 threshold=>0.01
STEP 5 PASS measured=0.000000 threshold=12.0
STEP 6 FAIL measured=0 threshold=>=1
STEP 7 FAIL measured=0.000000 threshold=0.03
STEP 8 FAIL measured=0.000000 threshold=8.0..14.0
STEP 9 FAIL measured=0.000000 threshold=1.0..1.8
```

The stored `s136_bound.json` master certificate has 64/64 non-reference certified pairs with no mechanical failures. This is a stored reference, not a fresh HUMAN2 C223 run. The ON production gate has not run. Neither requested still has been captured; no framing or pivot visual claim is made.

The OFF Step 2 window contains boxing_jab, boxing_cross, boxing_lead_hook and boxing_rear_uppercut clips. The existing baseline's intent-only slip/pivot/CoM hook limitation is still present. Wiring the opt-in room switch alone does not establish that this scripted segment exercises the gait; benchmark footwork intent routing needs investigation within an expanded read/edit window.

### Authorized continuation (2026-10-11)

The operator expanded HUMAN2's edit window to the room switch forwarding, benchmark footwork routing, and C223 ON gate wiring. The checkpoint's incomplete-integration statement above is historical. `human_footwork` is now a room option forwarded to both players, default OFF, absent from DEMO_SWITCHES. Master, HANDOFF.md and AgentComms are not edited. The task-specific non-console engine, hidden launcher, isolated branch and narrow gates take precedence over generic entry/rebase, console-engine and handoff procedures. Generated previews/imports remain unstaged as instructed.

**Controlled probe, not sim-authored footwork:** FightSimScriptHook maps step_left and pivot to a one-tick circle intent; it cannot sustain the requested four-second beat or its 45-degree turn. The opt-in `human2_footwork_probe=1` therefore isolates idle players from the room's presentation schedule during 12.5-16.5 s, exercises the existing HUMAN2 gait with forward/lateral steps and a lead-ball pivot, then restores the room roots and samples a planted idle before resuming. It requires `human_footwork=1`; neither probe nor gait is enabled by default. No certified take runs inside the probe and the simulation log is unchanged. CSV stimulus labels identify 241 `human2_footwork_probe` rows and one `human2_footwork_exit` handoff frame. This proves controlled presentation, not that the simulation delivered those motions.

The fresh OFF capture has 1,860 rows and is **byte-identical** to the checkpoint's instrumented off.csv (SHA-256 `8461be515c5a61fc7155a7fe21b197c75b343719f4e8fe449df5380a89685125`). Maximum pose-column difference from the preserved master baseline remains **0.0**. The final ON CSV has 1,860 rows, 34 fields, consecutive frames, and strictly increasing 1/60-second timestamps from 0.016667 to 31.000000. The probe exit advances the room clock and samples the real idle pose/locks before rendering; it does not emit an uninitialized reset frame. No grader thresholds or lock flags are fabricated.

All three human switches ON, plus the explicitly labelled HUMAN1 contact and HUMAN2 footwork probes:

```text
STEP 1 PASS measured=7.504985 threshold=4.0
STEP 2 PASS measured=hop=0,min_width_m=0.451931 threshold=hop=0,width>=0.30
STEP 3 PASS measured=6.229161 threshold=3.0
STEP 4 PASS measured=0.588113 threshold=>0.01
STEP 5 PASS measured=0.000000 threshold=12.0
STEP 6 FAIL measured=0 threshold=>=1
STEP 7 FAIL measured=0.000000 threshold=0.03
STEP 8 FAIL measured=0.000000 threshold=8.0..14.0
STEP 9 FAIL measured=0.000000 threshold=1.0..1.8
```

STEP 2 improves to PASS; no other STEP verdict worsens. Step 4's provisional absolute-X metric changes from 0.591305 to 0.588113 and remains PASS; the other measurements equal HUMAN1's controlled benchmark. The original instrumentation caveats for Steps 4-9 still apply. Final ON CSV SHA-256: `be388b2147473e6fb8ff295dd68ccb9859d04ff2b4d0204130a76505d1dc6302`.

Current script gates: six touched scripts parse successfully. The final related/focused rerun after the certified-contact repair is **SUITE total=24 fails=0**, jobs 2, covering human1 1/1, human2 1/1, bench1 1/1, anim_smooth 3/3, foot 9/9, and the nine non-realism fight_stage tests. The fresh HUMAN2 test retains zero hops, correct alternating order, minimum stance 0.319614 m, maximum locked drift 0.005196 m, zero distance error, and matching master OFF pose digests for Leo Vance and Ray Miller. Recorded RED and restored mutant results remain 7 failures and 4 order failures respectively.

The armed C223 gate exposed a HUMAN2 contact-guard bug: 15 of the first 16 certified pairs gained contact-slip failures. Although the gait rejected whole takes, its pending `_shuffle_active` latch had already bypassed the take's existing foot-lock selection. The repair clears that latch before foot-lock selection during whole/pair/set-piece ownership; OFF remains unchanged. A new two-boxer witness compares actual world-toe traces through a certified jab, including its return to idle, with and without an armed gait request. It fails for both boxers before the repair (**2 failures**) and passes after it. Both fixtures must actually exercise a whole-take window, so missing clips cannot produce a vacuous pass. [Witness RED](../docs/previews/human2/cert_guard_red.log), [final green](../docs/previews/human2/green_final.log).

The isolated realism rerun with `--timeout 1300 --jobs 2` **completes within 1300 seconds**, rc=1, **TOTAL=13 fails=7; SUITE total=1 fails=1**. These are the same seven documented HUMAN1 baseline rules: R1 space between exchanges, R2 stance takes, R3 planted-foot skate, R3b feet above canvas, R5 join motion, R5b joins against the same frames, R7 body overlap. The all-green realism criterion remains unmet; this is a completed failing test, not a timeout or a claim that HUMAN2 repaired those broader rules. [Engine result](../docs/previews/human2/realism_engine.log).

Both final stills were saved by `still_framing.gd.save_if_framed`, printed `STILL_FRAMING OK ... shot=broadcast err=0`, and opened with the file image tool. Both men's heads and feet are inside the game-camera frame:

- [human2_forward.png](../docs/previews/human2/human2_forward.png), 12.583333 s: Vance in red lifts his lead foot while the rear supports him, opposite Miller in purple; measured locks `[false, true]`. SHA-256 `69c431018879ba82a27c40232f881aef19984d37f48230e9458532c6d71d4e7c`.
- [human2_pivot.png](../docs/previews/human2/human2_pivot.png), 14.816667 s: Vance turns in guard over the lead ball while his rear foot swings; Miller turns opposite him. Measured red locks `[true, false]`. SHA-256 `4db4ee11ae544cb8fcb9aa382e14034416b71ed1a42850499166058ff66b5b65`.

Capture evidence remains local and unstaged per instruction: [OFF CSV](../docs/previews/human2/off_resumed.csv), [ON CSV](../docs/previews/human2/on.csv), [ON framing/probe log](../docs/previews/human2/on.log), [final focused summary](../docs/previews/human2/focused_final.log), [HUMAN2 metrics](../docs/previews/human2/green_final.log). Hidden captures contain no GDScript SCRIPT ERROR; pre-existing FBX read and teardown allocator/resource warnings remain.

Reproduce ON through Tools/godot_hidden.ps1 with the installed non-console FIGHTCAMP_GODOT_EXE, a 1300-second process-tree timeout, and an admitted watchdog check immediately before launch:

```text
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/record_room.gd --resolution 1920x1080 --fixed-fps 60 --quit-after 1860 -- as_game bench1=1 bench=1 human_hit_additive=1 human_flinch=1 human_footwork=1 human1_contact_probe=1 human2_footwork_probe=1 csv=E:/FightCamp/wt/HUMAN2/previews/human2/on.csv bench_stills=res://docs/previews/human2 bench_stills_fps=60
python Tools/smooth_metrics.py --bench previews/human2/on.csv
```

### C223 production OFF/ON comparison

The complete production gate ran on all four generated rigs and all 16 certified candidate IDs from s136_bound.json. Four clips per batch kept each headless worker within the task's 300-second timeout; Tools/c223_parallel.py used four workers at IDLE priority. Each launch was admitted by the PC watchdog. The reference_jab probe is always included by the gate even with clips=, so certified counts exclude it; the combined reports retain one reference row per rig, yielding the standard 68 rows. No threshold, binding or asset was changed.

| Control | Certified pairs passed | Mechanical failures | Harness errors |
| --- | ---: | ---: | ---: |
| Historical s136 master certificate | 64/64 | 0 | 0 |
| Fresh HUMAN2 OFF control | 29/64 | 35 | 0 |
| Fresh HUMAN2 ON, armed gait request | 29/64 | 35, identical to OFF | 0 |

**Switch regressions: 0/64.** Every complete gate row, including the reference rows, is exactly equal between fresh OFF and ON after removing only the human_footwork marker. All 68 ON markers are true and all OFF markers false. The 32 completed worker logs contain no GDScript SCRIPT ERROR or Parse Error. This confirms that the repaired guard preserves the existing certified pipeline rather than bypassing its foot lock.

The historical certificate is not a fresh current baseline. The fresh OFF failures already include foot_floor_cm on 24 pairs, skin_floor_cm on 6, g147_clipping on 7, and contact_slip_cm on 4 (overlapping counts across 35 pairs). ON neither adds nor changes any failure or measurement. No current 64/64 pass is claimed, and those baseline failures are not repaired by altering OFF behavior. Together with realism's seven baseline failures, they remain visible limitations of the requested all-green Done list.

Combined reports are saved both in the local previews directory and at the requested external destinations: `E:/FightCamp/tmp/human2_c223_before.json` (SHA-256 `a83150ef3d36b28fb428173c8d1adfbacf3cee8e6b6de5c08f035d12d99160ab`) and `E:/FightCamp/tmp/human2_c223.json` (`08f62a6afe7c71ad8f56992116530a32f84aa817e9d47dd137d873ddc94fdb22`). External copies are byte-identical. [OFF report](../docs/previews/c223/human2_c223_before.json), [ON report](../docs/previews/c223/human2_c223.json). Reports, worker/capture logs and previews remain unstaged per operator instruction.

Reproduce each of the four batches below with `python Tools/c223_parallel.py production --jobs 4 --timeout 300 -- plant phase live_contact bound clips=<batch> report=<unique-name>.json`; append the bare argument `human_footwork` for ON. The gate arms a zero-speed planted/pivot request before the certified take. The 64 certified rows must retain identical pose-derived data and failure lists between OFF and ON; do not grade the reference probe as a certified move.

```text
owned_jab,owned_cross,owned_lead_hook,owned_rear_hook
rear_body_hook,qm_check_hook_t17,boxing_lead_uppercut,boxing_rear_uppercut
body_jab_long,boxing_body_hook,boxing_up_jab,q215_slip
q215_pull,v_catch_rz,v_overhand,v_cross_body
```

Evidence: [OFF CSV](../docs/previews/human2/off.csv), [OFF capture log](../docs/previews/human2/off.log), [master pose digests](../docs/previews/human2/master_pose.log), [mutant](../docs/previews/human2/mutant.log), [focused green](../docs/previews/human2/green.log), [realism timeout](../docs/previews/human2/fight_stage_realism.log).
