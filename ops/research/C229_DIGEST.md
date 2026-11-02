# C229 — Cascadeur shovel hook and inside uppercut

## Scope and execution

Worktree `D:/FightCamp/wt/C229`, branch `codex/c229-cascadeur-hooks`.
Intake rebased the clean branch onto `99eb62d6`. Task-owned paths override the
general HANDOFF and unrelated mailbox-task workflow. No engine or gate thresholds
are changed. The optional game-dev CLI was unavailable; the explicitly assigned
Cascadeur/csend pipeline was used directly.

The fresh worktree required Godot cache initialization. Initial harness parse
errors cleared after class discovery; subsequent parse checks passed. Generated
unrelated import sidecars were restored. Every heavy run used the watchdog
(GREEN), at most two Godot jobs, and hidden-window rendering.

## 1. Shovel hook — REJECTED, original binding retained

Starting take: owned RamsterZ `H2H_HookPunch_InPlace.FBX`, the current binding's
source, preserving its 31 frames at 30 Hz and its existing punch construction.
The Meshy hook alternative exists, but changing takes would discard the current
timing and punch. No purchase or generation service was used.

`build_c229_source.py` reads source joint positions and rest-relative rotations
with Blender. `build_c229_shovel_hook.py` keys 39 Cascy controllers at every frame;
the lead calf direction pole stays outside the lead ankle. No solver-owned joint
is written. Both `modify_update` calls are asserted. Cascadeur exports the actual
animation and a separate rest pose. `SOLVED.json` retains joint read-back.

The first pass preserved segment directions but lost twist; the second preserves
source rest-relative rotations. In-game visuals and four-rig gates reject both.
The first solved lead knee was 2.75–13.71 cm outside its ankle in source space;
that source measurement does not establish acceptable in-game motion.

### Four-rig measurements

All rows below are the actual `v_shovel_hook` rows, not the reference jab.

| Rig | Before speed m/s | Before onset ms | Before failure | Final speed m/s | Final onset ms | Final pin pops | Final failures |
|---|---:|---:|---|---:|---:|---:|---|
| welter_a | 8.381 | 166.7 | g147_clipping | 12.218 | 183.3 | 1 | body_overlap, g147_clipping, g147_pin_pop |
| welter_b | 8.013 | 166.7 | g147_clipping | 11.670 | 183.3 | 17 | body_overlap, g147_clipping, g147_pin_pop |
| heavy_c | 8.867 | 166.7 | g147_clipping | 12.882 | 183.3 | 4 | body_overlap, g147_clipping, g147_pin_pop |
| heavy_d | 8.630 | 166.7 | g147_clipping | 12.540 | 183.3 | 0 | body_overlap, g147_clipping |

Speed band 6.5–14 m/s; onset band 132–657 ms. Both runs complete with eight rows,
zero harness errors and all four worker exits 0. **This is not a PASS:** all four
candidate rows fail. Baseline heavy_c reference_jab independently has a pin pop.

Reports: `docs/previews/c223/c229_shovel_hook_before.json`,
`c229_shovel_hook_attempt1.json`, `c229_shovel_hook.json`.
The bound gate uses the binding for playback but still prints the old TAKES source
and reference labels. During both attempted runs the actual binding paths were
`assets/anim/c223/cascadeur_c229/Cascy_C229_ShovelHook{,_rest}.glb`.
The other binding fields remained the baseline values.

### Pipeline findings and evidence

The initial single-strike trial lacked a Spine track: `_graft_retargeted` uses
UE4_TO_OURS directly, unlike the Cascy-aware paired route. A bounded read of the
retarget/graft dependency established this; those engine files were not edited.
The game-only carrier therefore renames Cascy joints to corresponding UE4 labels
in both take and rest. Skeleton transforms and animation samples remain intact.
The raw Cascadeur GLBs are retained under `Tools/cascadeur/c229_shovel_hook/`.
The compact game animation is 145,240 bytes; rest is 20,068 bytes. The unused
preview mannequin is replaced with a three-vertex skinned carrier.

`DataSourceManager.save_scene_as` silently produced no file. The documented
`Scene.save(path)` worked; native scenes retain the original and twist passes.
Never close a non-current tab. Saving over a path open in another tab is rejected;
replays use a content-tagged scene path.

First side sheet opened: the punch wraps behind the thrower and brings the two
bodies too close. That wrong look is rejected independently of the numeric gate.
Final side/game sheets were both opened:
`docs/previews/c229/shovel_final_side_v_shovel_hook_generator_welter_a.png` and
`shovel_final_game_v_shovel_hook_generator_welter_a.png`. At 0.233–0.550 s the
thrower turns his back and the arm folds behind him; this is not an acceptable
rising body hook. Source knee placement alone did not survive as a correct
whole punch. The original binding was restored after this review.

No shovel certificate is added to `certified_moves.json`. Asset-manifest approval
records authoring/licensing availability, not certification. Monthly Pro/export
flags and the 2026-10-27 expiry were verified in the running app log.

Reproduce source extraction with Blender 5.2.1, then run:

```text
python Tools/cascadeur/build_c229_shovel_hook.py
python Godot/tools/check_scripts.py Godot/scripts/FightClipBinding.gd Godot/tools/c223_production_gate.gd
python Tools/c223_parallel.py production --jobs 2 -- plant phase live_contact bound clips=v_shovel_hook report=c229_shovel_hook.json
```

For the rejected audition, temporarily substitute only the two shovel paths as
listed above; the committed production binding retains the original source.

Final parse: **CHECK total=3 fails=0**. Required bounded command
`run_tests.py --jobs 2 --only certified_palette,clip_binding,asset_manifest`:
**SUITE total=2 fails=0** (the selector matched two tests). Full suite not run.
No MP4 is represented as certified: this move failed both mechanical and visual
review. The task's failed-move path retains stills and measurements instead.

Shovel publication: **a2e2ad31**, pushed to `origin/codex/c229-cascadeur-hooks`
before starting the inside-uppercut baseline.

## 2. Inside uppercut — REJECTED

Starting take: owned `mixamo_pipeline_a/Boxing_Lead_Hand_Uppercut.glb`, the current
source. Keeping its fist trajectory/timing makes the rear-arm and trunk repair
attributable; no alternative punch is substituted. The source and its own rest
are sampled at 30 Hz (67 frames, 2.2 seconds). The source reader now explicitly
uses 30 Hz for GLTF, matching the Cascadeur timeline; the FBX shovel was already
30 Hz and is unaffected.

`build_c229_inside_uppercut.py` keys the Cascy controllers. The rear hand target
is fixed relative to the head; a two-link elbow solve preserves segment lengths
while placing the elbow below/forward. The chest heading is clamped before the
controller solve. A 30-degree input cap read back as 36.31 degrees, so the final
input cap is 22.5 degrees: solved shoulder heading **28.36 degrees maximum**.
Rear elbow stays at least **0.95 cm forward of the hip** in source space; rear
hand/head offsets are about x -12, y -9, z +18 cm. These are source measurements,
not claims about the retargeted game pose.

The first four-rig attempt retained the old two-arm compacting layer. It failed
body_overlap and g147_clipping on all four rigs, plus g147_pin_pop on three.
Speeds 7.73–8.94 m/s and onset 350 ms were in band. Its side sheet was opened:
`docs/previews/c229/inside_attempt1_side_v_inside_uppercut_generator_welter_a.png`.
The arm still folds high around the head; the source guard measurement alone is
insufficient to certify that picture.

Second attempt: remove the obsolete compacting layer from this binding and
re-key the lead knee direction outside its ankle. The initial source knee was
8.36–24.32 cm inward; the revised solve's worst inward offset is 1.81 cm.
All changes remain in source/controller authoring and the permitted binding.
Parse preflight briefly stalled in its repository-file read scan, then cleared;
normal `check_scripts.py` completed with **CHECK total=2 fails=0**. No parser or
gate code was changed or bypassed.

Attempt 2 cleared **g147_pass on all four rigs**, but retained 1.00–1.20 cm of
head/torso overlap and one rear-arm pin pop on three rigs. Attempt 3 smooths the
yaw cap, leans the torso backwards 3 degrees while preserving the striking-wrist
target during that lean, and adjusts the rear guard. Intermediate rear-hand
targets pulled the elbow behind the hip and were rejected from source read-back
before game gating. The final source elbow is at least **0.50 cm forward**.
Native final scene: `Cascy_C229_InsideUppercut_50920c99.casc`.

### Four-rig measurements

| Rig | Before speed m/s | Before onset ms | Before failure | Final speed m/s | Final onset ms | Final body gap cm | Final pin pops |
|---|---:|---:|---|---:|---:|---:|---:|
| welter_a | 9.705 | 366.7 | g147_clipping | 8.917 | 316.7 | -1.353 | 2 |
| welter_b | 10.318 | 366.7 | g147_clipping | 9.716 | 316.7 | -1.141 | 0 |
| heavy_c | 10.303 | 366.7 | g147_clipping | 9.651 | 366.7 | -1.283 | 1 |
| heavy_d | 10.682 | 366.7 | g147_clipping | 9.993 | 366.7 | -1.313 | 11 |

Final `g147_pass` is true on all four, but **all four fail body_overlap**.
welter_a/heavy_c/heavy_d also fail g147_pin_pop and pop_count; heavy_c fails
contact_slip_cm (2.0456 cm against 2 cm). Speed band 6.5–13.5 m/s and onset
band 71–627 ms remain unchanged. No gate was loosened.

Reports: `docs/previews/c223/c229_inside_uppercut_before.json`,
`c229_inside_uppercut_attempt1.json`, `c229_inside_uppercut_attempt2.json`,
`c229_inside_uppercut.json`. All four-rig runs completed eight rows with zero
harness errors; mechanical failures above still mean REJECTED.

As with the shovel, the bound report's source/reference text comes from the old
TAKES entry. Actual attempted paths were
`assets/anim/c223/cascadeur_c229/Cascy_C229_InsideUppercut{,_rest}.glb`.
Attempts 2–3 removed only this binding's two-element pose_layer; warp, root hold,
floor planting and phase-matched guard remained unchanged. Compact animation:
240,596 bytes; rest: 20,068 bytes. Raw Cascadeur exports and native iterations
are retained beside the reproducible authoring scripts.

Final side and game-angle sheets were opened:
`docs/previews/c229/inside_final_side_v_inside_uppercut_generator_welter_a.png`
and `inside_final_game_v_inside_uppercut_generator_welter_a.png`. The rear glove
does **not** stay at the chin in-game: it rises beside/behind the head while the
torso leans away. This fails the visual brief independently of the mechanical
failures. Source-space wrist/elbow constraints did not produce equivalent
target-rig rotations. **The original uppercut binding and its layer are restored.**
Neither move is added to the certified palette. No successful certificate or
certified MP4 is claimed.

During final rendering the watchdog reached AMBER (85–87% RAM), not RED. Only
saved C229 scenes were closed, always through `close_scene(app.current_scene())`
after verifying the current scene path was an existing C229 file. No unrelated
tab or process was closed. Both hidden renders exited normally.

The remaining authoring problem is the source-to-target orientation transfer:
position-constrained Cascy joints alone do not preserve the correct boxing arm
read through the single-strike retarget. More source parameter tuning is not
evidence of a fix. The rejected files preserve the attempts for that diagnosis;
they are not shipped live replacements.

Final uppercut validation after restoring both original bindings:
**CHECK total=2 fails=0**; required
`run_tests.py --jobs 2 --only certified_palette,clip_binding,asset_manifest`:
**SUITE total=2 fails=0**. There is no `clip_binding`-named test in this checkout;
the selector ran certified_palette and asset_manifest. Python authoring scripts
also compiled successfully. No full suite was run.

Both moves completed the task's failed-move path: baseline, Cascadeur authoring,
real exports and native saves, temporary binding, four-rig measurement, opened
game stills, rejection, original binding restoration, bounded validation, and
separate publication. **C229 did not produce a newly certified move.**
