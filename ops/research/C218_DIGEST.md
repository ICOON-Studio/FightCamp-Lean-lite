# C218 - live active-ragdoll motion

Branch `codex/c218-ragdoll-live-motion`, based on C217 (`5a0d02c7`), not master. **Live-motion and knee gates PASS.** The isolated prototype remains OFF by default; no shipped-backend migration is proposed. Claude merges.

## Achieved beside wanted

Seed 77321, full moving kickboxing bout, 60 Hz, 10,730 presentation frames including final recovery. In each run A reacts and B is a different model: f01/f02, f02/f01, MPFB/f02. Only A owns physics, preserving C217's one-active-body ceiling. Injection exercises presentation without changing engine state. Every accepted reaction includes measured clean-animation movement; the probe fails on refusal, insufficient count, stationary animation, tracking error, or identical model paths.

Error statistics are p50/p95/max of each accepted reaction's maximum body-to-target error. Internal pre-solve measurements include the failing tick even if the guard hides output; independent post-solve samples are merged by maximum. No error clipping, guard reset, or hidden retry earns a pass.

| Reacting rig | Accepted / wanted | p50 m | p95 m | Maximum m / wanted | Minimum animation movement per reaction |
| --- | ---: | ---: | ---: | ---: | ---: |
| Tripo f01, 1.78 m | 45 / >=45 | 0.129339 | 0.265884 | 0.407635 / <0.75 | 0.042169 m |
| Tripo f02, 1.90 m | 45 / >=45 | 0.142602 | 0.281798 | 0.370984 / <0.75 | 0.059795 m |
| MPFB, 1.98 m | 45 / >=45 | 0.155780 | 0.307236 | 0.428085 / <0.75 | 0.034492 m |

All three: zero guard failures, final mix zero, 3600 engine ticks and 51 log events. Separately, C217's seeded 200-reaction controlled schedule remains 200 accepted / 200 recovered for each rig. Controlled maximum errors: f01 0.138959 m; f02 0.142609 m; MPFB 0.164094 m. These are regression evidence, not a substitute for the moving runs.

MPFB critical-leg hold, captured after 60 frames: **achieved knee +0.016329 m above the original ankle plane; wanted absolute distance <=0.03 m**. Motor target +0.016027 m, visible mix 1.0, original ankle world Y 1.366835 m. Before the proportion-aware kneel change, the same controlled probe's closest rendered knee was 0.157357 m above that reference. The hold sample is stronger evidence than merely crossing the reference during a moving kick. The knee can transiently overshoot the plane (the three-reaction diagnostic recorded a -0.0442 m minimum against the contemporaneous healthy ankle); this is geometric presentation, not floor-collision/contact-force certification.

## Reuse and change

Read C217 digest first, pinned Kickback `physics_rig_sync.gd`, spring resolver, builder, tuning, and two-bone IK. Read installed UE 5.8 `Engine/Source/Runtime/Engine/Classes/PhysicsEngine/PhysicalAnimationComponent.h` and `Private/PhysicsEngine/PhysicalAnimationComponent.cpp`. Its `FPhysicalAnimationData` defaults to local simulation with all six strength/force fields zero, not a numeric tuning recipe. `TickComponent` refreshes current skeletal targets; `UpdateTargetActors` explicitly discusses animation tick ordering. Godot's [PhysicalBoneSimulator3D](https://docs.godotengine.org/en/stable/classes/class_physicalbonesimulator3d.html) accepts selected simulated bones. Reuse those architectural boundaries, not Unreal code.

C217 already sampled live poses: its failure was not literally a hit-time snapshot. All 16 bodies were dynamic, including pelvis and healthy limbs, and upstream chain consistency removed independent child position correction. Reproduction accepted only 1/4 injections and reached 1.116126 m against the <0.75 m bound. Initial partial-simulation tuning passed Tripo but failed MPFB at 0.921323 m; it was rejected, not reported as delivery.

Keep Kickback's builder, joints, velocity springs, mapping, IK, and rollback-safe SkeletonModifier3D output. Only the struck chain is dynamic. Other bodies are kinematic, driven by current animation plus bounded procedural support/brace targets. Invoke springs once after supplying targets. Carry dynamic residual transforms and velocities with the animated root, also moving the pinned resolver's feed-forward history into that frame to avoid double root travel. Refresh poses during both hidden arming ticks. Healthy output combines the latest animation with the support correction, avoiding idle-versus-physics lag. Never write a gameplay root or fight state.

Final measured tuning: chain consistency 0; default positional pin 0.6, feet 0.8; commanded linear/angular limits 12 m/s and 20 rad/s. These are prototype choices, not Unreal defaults. The struck chain still softens for 0.4 s and blend rises/decays. Kinematic pelvis support is limited to 0.12 m horizontally. Critical-leg depth now uses thigh length and the original ankle reference, capped at 0.65 m; the struck foot trails to permit a knee-down pose. Critical leg blend reaches 1.0 at the hold rather than leaving 15% upright pose in the knee. No claim of an autonomous support-polygon catch-step controller is made.

## Parity, artifacts, and gates

- OFF creates zero presenters. All nine RGBA frame SHA256 hashes at steps 30, 60, 120, 240, 360, 480, 600, 720, 840 match the pre-C217 room under the shipped backend.
- Full OFF and all three ON engine-log SHA256: `c70a0758103e6c2d8ecfee2a3cd4b1b8543dd4f7ee867ec94967169ab231ae3c`.
- All 65 pinned Kickback files remain byte-identical to `1d2c5ae3617eb676dc86368a30eb31f80ab52419`. No addon diff.
- `Godot/project.godot` byte-unchanged; SHA256 `ca273bc4c1153694e854fa2d20bbf4a2918c52c1fc30ec759664998b2909d89d`.
- Final parse: `CHECK total=3 fails=0 autoload_refs=0 autoload_warnings=0`. Focused live/controlled runs have exit 0 and no SCRIPT ERROR or engine ERROR. Raw-FBX and teardown warnings remain baseline noise.
- Authorized subset: `python Godot/tools/run_tests.py --jobs 2 --only fight_world_live,fight_room` -> **`SUITE total=5 fails=1`**. Only `fight_room_walkout_test.gd` fails: `TOTAL=2650 fails=2638`; all 2,638 failure strings match C217's recorded baseline exactly, with zero new SCRIPT ERROR. No worse than C217. Never the full suite.

[Moving before/after MP4](../docs/previews/c218/c218_moving_comparison.mp4), [contact sheet](../docs/previews/c218/c218_moving_contact_sheet.jpg), [MPFB knee hold](../docs/previews/c218/mpfb_knee_hold.jpg), and [validation](../docs/previews/c218/validation.json). MP4: 8 s, 240 frames, 30 fps, 1920x660 H.264, full decode passed. Both panels run the same moving bout with distinct f01/f02 fighters. C217 trips its guard; C218 keeps reacting. Reviewed onset, moving hold, protective-head reaction and recovery samples (comparison frames 12, 36, 105, 150, 230), plus MPFB knee frame 135. This is forced presentation evidence, not a claim that the seed naturally generated critical hits, production contact quality, or two-active-body collision acceptance.

## Reproduce

Reuse the isolated `.c217-jolt` startup project described in C217_DIGEST: copied project config selecting Jolt, source/resource junctions, separate class cache, shared imported resources. Do not change shipped `project.godot`. Parse the three owned scripts first. Headless engine: `%LOCALAPPDATA%/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe`.

- Live: `--headless --path .c217-jolt --fixed-fps 60 --script tools/c217_engine_trial.gd -- on=1 inject=1 gate=1 mesh=<rig> opponent=<different rig> height=<metres> out=<json>`.
- Controlled: same startup, `--script tools/c217_trial.gd -- on=1 count=200 mesh=<rig> height=<metres> out=<json>`. The tool chooses a different opponent for f02. `generator=1` now changes only fighter A.
- Engine parity: engine trial with `on=0`, no frame limit, same seed.
- Moving capture: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path .c217-jolt --fixed-fps 60 --script tools/c217_engine_trial.gd -- on=1 inject=1 frames=480 capture=<existing directory> out=<json>`. Frames save every second step at 30 fps. For before footage use C217 presenter revision `5a0d02c7`; leave the current probe unchanged.
- OFF pixels: hidden launcher, shipped `--path Godot`, engine trial `on=0 pixels=1 frames=900`; compare with `baseline=<original room extracted from 9fae6211>`. The original-room compatibility error in an initial capture was corrected and that capture rerun; its failed output was not accepted.
- MPFB knee capture: hidden launcher, isolated project, controlled tool `count=3 mesh=res://assets/models/generator/mpfb_male_pilot.glb height=1.98 capture=<directory>`. JSON prints achieved beside wanted at the hold.

Direct C218 intake overrides generic master-rebase/mailbox intake. The user explicitly skipped the watchdog using Claude's GREEN check. No HANDOFF, CURRENT_STATUS, HANDOFF_ARCHIVE, or FightRealtime whole-file read/edit. Pre-existing importer changes remain untouched. Implementation checkpoints `99d44b4b` and `07a03fbf` were pushed during work. All windowed runs use the hidden launcher. Only C218-owned files and the explicitly requested one-line Claude message are delivered.
