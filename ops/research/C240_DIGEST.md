# C240 — boxing clinch room fixture (NOT COMPLETE / NOT MERGE-READY)

The paired clips and event consumer are implemented and a 30-second silent live-room video exists. The integrated task is **not accepted**: Q233 is not on origin, the production room currently drops hold events, and the same-seed excerpt does not halve overlap. No HANDOFF change. No engine changes.

## Review artifact

`previews/c240/live.mp4`: 1280×720, 30 fps, 900 frames, 30 seconds, no audio. `video_receipt.json` records the SHA-256 and encoding checks. Both men are active before and after the hold. Game camera and `as_game` switches. The fighters come from the Q212 booking path: Nasir Duarte (`athlete_001`) and Sami Okafor (`offer_opponent_local_light-heavyweight_1`), seed 2840125337. The reproducible ten-bout population is retained in `booked_population.json`.

**This is explicitly a scripted Q233-event fixture.** At 5 s it emits `hold_engage {holder:a,cause:too_close}`, at 10 s `hold_break {by:referee}`. These are not measured engine decisions, a measured clinch rate, or a full-bout population census. No engine-distance threshold was implemented in the room to impersonate Q233.

The fixture changes presentation only: the current engine continues resolving its ordinary exchanges during that scripted window. Q233 must supply actual clinch scoring, inside work and suppressed head shots before this becomes gameplay evidence.

Frames inspected with the file image tool only: the hold has staggered feet, complementary high/low arms and heads beside each other; the release separates both men into guard. Later live exchanges still show crowding. No viewer or desktop app was opened.

## Delivered code and assets

- `FightClipBinding.BOXING_HOLD_BINDINGS`: two event-only films kept outside strike-catalogue coverage. The initial BINDINGS placement tripped the alias contract and was corrected.
- `FightStagePlayer`: boxing-only grafts; initiator/partner assignment from the event; 0.35 s entry crossfade; ordinary strikes/locomotion cannot cut the hold; break plays the existing retreat film for 0.8 s then returns to guard; `foul_on_break` selects a jab only for its named side. MMA/kickboxing reject these boxing events.
- `FightStagePlayer.fit_boxing_hold_pair`: after root placement, separates head/torso surface intersections using both fighters' posed mesh-derived capsules and `FightPoseSolver.capsule_gap`. It returns failure for absent bodies or a nonconverged fit. It does not trigger holds or mutate the engine.
- `Tools/blender_moves/c240_author.py`: Blender 5.2.1 headless authoring on the existing Pipeline-A guard rig, two-bone arm and planted-foot IK. Two 2 s loops; timing/angles are authored judgment. `assets/anim/c223/c240/SOURCE.json` records source and output hashes and provenance. No purchases or provider generation.
- `Godot/tools/c240_overlap_census.gd`: live-room recorder and per-frame surface-depth instrument. Its current mode is a fixture, not the outstanding full-bout census. It reproduces ten Q212 booked pairings in a separate timestamped save directory without wiping the Q212 save.
- `Godot/tests/c240_boxing_clinch_test.gd`: actual production-player clip occurrence, both roles, interruption protection, retreat/guard return, malformed-holder refusal, named foul punch and non-boxing event controls. Q233's engine threshold/hash tests remain Q233's dependency.

## Measured before/after — SAME seed, 30 s excerpt only

| Measure | Before, no fixture hold | After, fixture hold | Required |
|---|---:|---:|---|
| Frames | 900 | 900 | >=10 complete seeded booked bouts remains outstanding |
| Any head pair >1 cm | 17 (1.89%) | 15 (1.67%) | at least halved: **FAIL** |
| Torso/torso >2 cm, >=3 consecutive frames | 0 | 0 | no nonzero baseline from this excerpt |

During the settled hold (5.5–10 s), max head penetration was 0.001999 m and torso penetration was zero. This does not excuse later head overlaps. Raw measurements retain every frame and both fighter records. The counter compares **posed body capsules**, not engine root gap, and requires a nonempty pair set.

## Research and prefab evidence

Read C240, S139, C237 digest, the canonical clinch topic, Q175 digest, G147 and K38. K38 cites Davis et al. 2015, DOI `10.1123/ijspp.2013-0474`: amateur rounds 1–3 average 2.5, 3.2 and 4.8 clinches, approximately 5–6 s each; no professional 12-round anchor was found. Those are the engine targets, not measurements achieved by this fixture.

Q175's digest describes engine hold work, not a boxing animation asset. The on-disk CMU 18_05/19_05 files each have 93 animation channels; the Cascadeur cage-clinch pair has 198 channels per actor and its supplied thumbnail is 1×1. No RamsterZ H2H filename identifies a clinch/grab/hold. No Harmony asset was found under the animation assets. Static inventory is not a clean-pose certificate for these sources; none is represented as certified or bound by C240. The task-authorized local guard authoring route was used.

## Integration blockers / remaining acceptance

1. `FightWorldLiveScreen._pump_to` accepts only actions and grapples and drops other events before `FightStagePlayer` sees them. The necessary routing and paired-root ownership hooks lie outside C240's owned files. A request to extend scope to minimal `FightWorldLiveScreen.gd` / possibly `FightBeatAdapter.gd` clinch hooks is pending. Neither file has been edited.
2. `git ls-remote --heads origin qwen/q233-boxing-clinch` returned no branch. Do not invent its implementation or claim its rates. Need Q233's engine-generated hold/break stream, proximity threshold tests, controls, and both booked-census arms.
3. Run >=10 complete seeded booked bouts, same before/after populations, and halve head/torso overlap. The 30 s excerpt above fails the reduction target. KO+TKO 40–55%, thrown 45–56 per man-round, and measured holds 2.5–4.8/round remain unverified here.
4. Operator video approval remains the merge bar. This branch is a review candidate, not a completed task.
5. The affected-system gate is not green: the realism test reached its 600 s timeout. The runner's sandboxed cleanup left its own child alive; its PID, creation time, parent and exact C240 test command were verified before stopping that child. No unrelated process was stopped.

## Validation

- Final parse: `CHECK total=4 fails=0 autoload_refs=0 autoload_warnings=0`.
- Initial focused room test: `SUITE total=1 fails=0`.
- Requested affected systems, plus C240, jobs=2: **`SUITE total=22 fails=3`**. Failures: the original alias-table placement (fixed), `fight_stage_technique_fidelity_test.gd` (fixture reaches zero NEAREST substitutions), and `fight_stage_realism_test.gd` (600 s timeout). The remaining 19 passed.
- Final focused rerun after the alias fix and retreat/foul assertions: **`SUITE total=2 fails=0`** (`c240_boxing_clinch`, `fight_clip_alias`). This does not turn the unresolved broad gate into a green result.
- Baseline comparison uses only the two owned runtime files restored temporarily to intake commit `08080a69b77397a0b4325953cc179b96297c9530`, runs parse then the fidelity test, and restores the candidate byte-for-byte in `finally`. See `Tools/blender_moves/c240_baseline_test.py` and `validation.json` for the recorded result.
- Baseline result: `CHECK total=2 fails=0`; **`SUITE total=1 fails=1`**, the same zero-NEAREST assertion. That fidelity failure is reproduced without C240. The realism timeout has not been baseline-attributed and remains unresolved.

## Reproduction

Watchdog GREEN before heavy work; all windowed Godot runs used `Tools/godot_hidden.ps1`. Parse touched scripts first with `Godot/tools/check_scripts.py`.

```
blender --background --factory-startup --python Tools/blender_moves/c240_author.py
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/c240_overlap_census.gd -- as_game booked seconds=30 render out=res://docs/previews/c240/frames
python Tools/blender_moves/c240_encode.py
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --headless --path Godot --script tools/c240_overlap_census.gd -- as_game booked before seconds=30 out=res://docs/previews/c240/before
```

Use the task's Blender executable path. The optional game-dev CLI was absent, so the explicitly requested Blender route took precedence over the optional skill workflow. Initial import generated cache metadata; it reported errors/warnings and is not claimed as a clean import gate. Runtime recordings completed with existing FBX read warnings and shutdown resource-leak diagnostics; there were no GDScript runtime errors in the fixture captures. Validation results are recorded in the preview evidence alongside the video.
