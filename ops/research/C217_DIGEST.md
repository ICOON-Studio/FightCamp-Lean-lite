# C217 - active-ragdoll nervous system prototype

Branch: `codex/c217-active-ragdoll`. Status: experimental prototype delivered; **live integration NOT accepted**.

## Feasibility (written before implementation, 2026-09-27)

**Start with Kickback**, MIT, pinned upstream revision `1d2c5ae3617eb676dc86368a30eb31f80ab52419` ([source](https://github.com/blugart-dev/kickback/tree/1d2c5ae3617eb676dc86368a30eb31f80ab52419)). Its runtime assembly supplies 16 rigid bodies, limited Generic6DOF joints, animation-tracking velocity springs and a SkeletonModifier3D output pass. That pass rolls back after skinning, preserving clean animation targets. Its springs are velocity servos, not direct Jolt torque motors; do not describe this prototype as a new torque-PD implementation. Vendor its addon and MIT license without enabling the editor plugin globally.

**Our actual assets:** raw GLB inspection finds Tripo f01/f02 skin `skintokens_rig`; generator skin `Human.rig`. Both expose `Hips -> Spine -> Chest -> UpperChest -> Neck -> Head`, `Left/RightUpperLeg -> LowerLeg -> Foot -> Toes`, and `Left/RightUpperArm -> LowerArm -> Hand` (side prefixes on every limb name). The generator's troublesome `Root` is absent in the shipped GLB, matching S93's fix. Kickback's generic Hips/Spine detector should match these names; runtime detection and profile validation still have to prove it. Tripo has a centred floor origin and the existing presenter uses a 0.925 m lift; MPFB is sole-origin metres with zero lift. The inspected Tripo GLBs have no scale properties, while MPFB has near-unit floating-point scale noise. Both are additionally stature-scaled at mount time. Therefore measure world-space bone lengths and orthonormalize physics transforms; do not assume the task's scale warning means centimetres, or transplant Mixamo collider sizes.

**Backend and timing:** the project has no explicit 3D backend setting. The installed 4.7.2 runtime (`ed1daf0bf001b61586d9930840f2f1394092c079`) reports `DEFAULT`, 60 Hz physics. Its exact-revision source registers `GodotPhysics3D` as the default; Jolt registration does not replace that default. Therefore this existing project runs **Godot Physics**, despite current documentation saying newly created projects use Jolt. Kickback requires Jolt. Do not change `project.godot` globally to satisfy a prototype: a backend trial must be isolated, with room/prop effects measured before proposing migration. Use 60 Hz physics against a 60 fps render target. Native PhysicalBoneSimulator3D supports partial simulation and modifier influence, but does not itself supply an animation-target controller. Jolt exposes spring frequency/damping and torque limits; Godot's wrapper does not expose every native Jolt feature. Kickback remains the first candidate, conditional on that backend trial.

**Presentation boundary:** create nothing when `active_ragdoll` is OFF. When ON, copy landed event region/condition into the presenter; never retain a mutable engine-state dictionary, call engine mutators, or change fight RNG. Keep model roots under the existing room controller. Disable Kickback's spontaneous knockdown, random escalation and directed root movement; an engine-standing fighter must recover. Weaken the struck chain for approximately 0.4 s, bias support toward the opposite foot, and recover to animation. A critical leg reaction may kneel and rise only as a bounded presentation; critical head damage calls for arm protection. Stop at one body until scaled-rig stability and visible contact pass.

**Known prefab limits:** upstream explicitly calls its stumble scripted root displacement, not balance-driven stepping; its balance estimate is CoM versus foot midpoint/half-spread, not a contact support polygon. General rig robustness and active self-preservation remain unfinished. A built rig or finite transform is not visual acceptance. Require 200 seeded reactions, recovery/contact measurements, ON/OFF engine-log hashes, C112-style normal-room frame timings, and reviewed before/after video before calling the prototype complete.

References read: [Godot PhysicalBoneSimulator3D source docs](https://github.com/godotengine/godot/blob/master/doc/classes/PhysicalBoneSimulator3D.xml), [PhysicalBone3D](https://github.com/godotengine/godot/blob/master/doc/classes/PhysicalBone3D.xml), [Godot Jolt differences](https://github.com/godotengine/godot-docs/blob/master/tutorials/physics/using_jolt_physics.rst), [Jolt MotorSettings](https://jrouwe.github.io/JoltPhysics/class_motor_settings.html), [Sergio Abreu's active-ragdoll architecture](https://github.com/sergioabreu-g/active-ragdolls), and Kickback README, builder, sync, spring resolver, detector, tuning and setup source. Online master documentation is architectural evidence, not proof of installed-version behavior.

## Delivery and decisions (2026-09-27)

C215 merge `6872d458` is an ancestor. The original feasibility above is retained. Direct C217 intake superseded the general brief/HANDOFF intake; HANDOFF.md, CURRENT_STATUS.md and HANDOFF_ARCHIVE.md were not read or edited. The operator explicitly authorized vendoring beyond the initial owned-file list. No other gameplay module or project configuration was edited.

Kickback's 65 upstream files remain byte-identical to pinned `1d2c5ae3617eb676dc86368a30eb31f80ab52419`, including LICENSE. Godot generated seven SVG import receipts. The editor plugin is **not enabled**. Checkpoints `9fae6211` (vendor) and `5f596331` (initial controller/tools) were pushed during work. The earlier rebase was published with force-with-lease only after verifying the remote-only commits were the old feasibility commits.

Godot 4.7.2 cannot select this backend per scene through the supported startup setting. The least risky route is the separate `.c217-jolt` startup project: copied project configuration, Jolt setting only there, shared read-only source/assets via directory junctions, its own class-cache file, and a link to the existing imported-resource cache. **`Godot/project.godot` is byte-unchanged. No shipped backend migration is proposed.** The measured fight-room scene contains zero existing CollisionObject3D props; its visible room/props are mesh geometry. New ragdoll bodies have collision layer/mask zero. Thus this trial cannot establish behavior of dynamic gym props elsewhere, and makes no such claim.

`FightActiveRagdoll.gd` uses the vendor's 16-body joint builder, velocity springs, auto-detected profile, and two-bone IK. A proxy skeleton bakes stature into bone translations, with unit-scale physics transforms; nonuniform scale is refused. Both Tripo and MPFB map all 16 roles, including Chest -> UpperChest. No bespoke fallback profile was needed. A SkeletonModifier3D writes the visible result then lets Godot restore animation targets. The controller holds no fight-state reference and never writes the gameplay root. Its small state machine replaces upstream random escalation/root-moving recovery. Motors on the struck chain weaken for 0.4 s; mass-weighted body origins bias support toward the healthy foot, bounded to 0.12 m. Critical leg targets lower the hips 0.42 m with IK, then blend back; critical head targets raise hands to the temples. Two hidden arming ticks allow PhysicsServer to acknowledge reset transforms. This is **not a torque-PD motor implementation**.

The room's `active_ragdoll` option defaults OFF and creates/loads no presenter when OFF. ON on the shipped backend refuses with a diagnostic; only isolated Jolt creates the physics rig. The room snapshots the condition band onto the adapter's copy of an event, then forwards region/band/contact at the target presentation entry. It does not read the look-ahead state at display time. Only fighter A can acquire the prototype. This intentionally remains a one-active-body ceiling.

## Evidence and acceptance boundary

[Video](../docs/previews/c217/c217_comparison.mp4), [contact sheet](../docs/previews/c217/c217_contact_sheet.jpg), and [machine-readable validation](../docs/previews/c217/validation.json). MP4: 10.5 s, 315 frames at 30 fps, H.264, 1920x720 comparison composed from 1920x1080 room captures; full decode succeeded. Reviewed the displayed hurt-leg, knee-dip, and raised-arm frames, plus onset/recovery samples. The video explicitly labels **OFF idle control / ON controlled probes**: it is not footage of an engine-generated landed kick. The opponent remains animated; it has no active ragdoll. No two-active-body collision acceptance is claimed.

Final seeded list (RNG seed 217, 60 Hz): each body accepted 200 hits and completed 200 recovery windows, with zero guard failures. Recovery here means the bounded modifier returns to zero influence; it does not prove equilibrium of an unconstrained ragdoll. No NaNs or >0.75 m body-to-target departures occurred in these controlled runs.

| Rig | Mount scale | Accepted / recovered | Max target error | Max healthy-foot drift |
| --- | ---: | ---: | ---: | ---: |
| Tripo f01, 1.78 m | 0.962162 | 200 / 200 | 0.347615 m | 0.029412 m |
| Tripo f02, 1.90 m | 1.027027 | 200 / 200 | 0.345020 m | 0.059952 m |
| MPFB, 1.98 m | 1.145099 | 200 / 200 | 0.347794 m | 0.028684 m |

The Tripo knee reaches approximately the original ankle height; MPFB's minimum knee is 0.084763 m above that reference, so its knee contact is not accepted. Bone positions are proxies, not skin-surface contact measurements. The initial f02 failure was traced to the harness starting a hit before advancing idle; the final harness warms the animation before measuring. The earlier large hand error and the later live-motion failure are preserved as findings, not relabeled as passes.

**Live-motion gate FAILS.** Forced critical reactions during the moving seed-77321 bout exceed the 0.75 m tracking bound (final guard probe: 1.153527 m, five body violations on the first accepted reaction). The controller restores animation and latches refusal; no automatic retry. An earlier diagnostic without the latched guard exercised 45 reactions and also failed tracking, while preserving the same engine hash. Therefore step 4's live two-body extension is held. A contact-aware catch step/support polygon, continuous motion-target tracking, MPFB knee contact, and quantitative interpenetration/pop acceptance remain outstanding. This prototype is useful evidence and a safe OFF-default integration seam, **not a completed nervous system or a production-ready hit-reaction system**.

## Engine boundary, OFF identity, and gates

All full-round records (seed 77321, kickboxing, 3,600 ticks, 51 log events) have SHA-256:

`c70a0758103e6c2d8ecfee2a3cd4b1b8543dd4f7ee867ec94967169ab231ae3c`

Compared original room/Godot Physics, final OFF/Godot Physics, requested ON/Godot Physics (refused), isolated Jolt OFF, and isolated Jolt ON with actual injected presentation reactions. Natural events in this short seed never reached a qualifying band, so injection was necessary to avoid a vacuous ON test. Injection touches only the presenter, never engine state. Nine rendered RGBA pixel hashes also match exactly between the original room and final OFF room under the shipped backend. This proves those sampled frames, not every possible room state.

- Vendor parse: `CHECK total=26 fails=0 autoload_refs=0 autoload_warnings=0`.
- Final owned parse: `CHECK total=5 fails=0 autoload_refs=0 autoload_warnings=0`.
- Authorized subset only: `python Godot/tools/run_tests.py --only fight_world_live,fight_room` -> **`SUITE total=5 fails=1`**. Four pass; `fight_room_walkout_test.gd` fails.
- Same walkout assertions against pre-C217 room: both `TOTAL=2650 fails=2638`, all 2,638 failure strings identical. First failure: MMA A Y on frame 604 is 1.925400 vs mounted 1.900400; B is 1.925400 vs 1.950400. The baseline tool substitutes only the original room resource and inherits the named test unchanged. No assertions were weakened and no unrelated fix was made.
- Existing raw-FBX buffer warnings and exit ObjectDB leak warnings occur in baseline and trial runs; no SCRIPT ERROR was accepted as a pass. No full suite ran.

## Frame cost and room effects

Sequential windowed 1920x1080 live-room runs, seed 77321, 900 render steps (15 simulated seconds), physics/render simulation step 60 Hz, vsync disabled, no image readback. Statistics discard the first 61 frames. This is uncapped throughput measured by wall-frame intervals, equivalent to C112's frame-interval readout, not a claim that the game is capped to these rates.

| Backend / switch | Mean frame ms | p50 ms | p95 ms |
| --- | ---: | ---: | ---: |
| Shipped Godot Physics / OFF | 3.917 | 3.480 | 6.121 |
| Isolated Jolt / OFF | 3.894 | 3.449 | 6.277 |
| Isolated Jolt / ON + probes | 4.011 | 3.562 | 6.592 |

Observed ON-minus-Jolt-OFF mean difference: +0.118 ms. **The guard tripped on the first moving reaction**, so this includes mostly a dormant rig and is not sustained-active cost or a performance acceptance. The scene's zero pre-existing physics props and OFF pixel parity explain why no backend-dependent room/prop displacement was observed. Do not generalize this to the rest of the gym or enable Jolt globally.

## Reproduction

First register vendor classes in a local Godot cache (`--headless --editor --path Godot --quit`); this scans imports and can rewrite `.import` metadata. Then parse the five owned `.gd` files and the 26 vendor `.gd` files with `Godot/tools/check_scripts.py` before any measurement/test. Do not run the full suite.

Prepare `.c217-jolt` under this worktree: copy `Godot/project.godot`, append `[physics]` plus `3d/physics_engine="Jolt Physics"`, create directory junctions for Godot's resource directories except `.godot`, copy `.godot/global_script_class_cache.cfg` into its own `.godot`, and junction `.godot/imported` to the existing import cache. Do not edit the original project file or enable the editor plugin. This is a disposable separate-process trial, not a scene-level backend switch.

Run (windowed jobs must use the launcher):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path .c217-jolt --fixed-fps 60 --script tools/c217_trial.gd -- count=3 on=1
```

`c217_trial.gd`: `count=200`, `height=1.90`, `mesh=res://assets/models/fighters/f02_m_box_heavy_rigged.glb`, or `generator=1 height=1.98`; `out=res://docs/previews/c217/<name>.json`; `capture=<existing absolute frame directory>` captures every other frame (30 fps). Three-case preview is orthodox lead/left leg HURT, left leg CRITICAL, head CRITICAL. `on=0 pixels=1` supplies nine RGBA hashes; `baseline=<absolute original room script>` selects the pre-hook room.

`c217_engine_trial.gd`: `on=0|1`, `inject=1` to force repeated presentation-only critical probes, optional `frames=900` for timing; omit frames for the full-round hash. Use `--headless` directly for non-rendered measurements. Extract the original room with `git show 9fae6211:Godot/scripts/FightWorldLiveScreen.gd` to an untracked `.gd`; pass its path after `--` to `c217_baseline_walkout.gd` to reproduce the original named test failure. All source scripts and final evidence are committed; temporary projects, raw frame sequences and exploratory logs are not.

## Workspace note

The initial tracked tree was clean. The Godot class/import scan rewrote 2,283 tracked `.import` files. Automatic approval review rejected a broad computed-list restore because it could erase other work. Those importer changes remain unstaged; only C217-owned paths were committed. No unrelated untracked work was removed. This cleanup refusal did not block the prototype, tests, video, or push.
