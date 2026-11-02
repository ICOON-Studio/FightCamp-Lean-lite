# S224 animation code audit — Codex / ANIMAUDIT1

## Verdict and scope

**The MetaHuman right-side rest convention is real; the models are not thereby broken. The pipeline contains operations that assume a different convention, most concretely its post-retarget local-quaternion mirror and rig-independent local Euler pose layers. The core per-bone global retarget equation already accounts for different rest axes. Adding a blanket right-side sign flip there would be the wrong repair.**

There is also a confirmed foot-anatomy error in the baseline silhouette/sole bake, a concrete mirrored-animation metadata/folding hazard, and overlapping late pose ownership. Source choreography remains an independent problem. None of this read-only work establishes which operation caused every frame of the recorded 87.6-degree rear-foot excursion. That requires the exact failing clip/time and its intermediate poses, not another guessed correction.

Audited on 2026-10-14:

- **A** = audit worktree/base `861afdf882e09006449f81f7f68eb8ac832da90e`, branch `codex/animaudit1`. Unqualified source citations below refer to A, relative to repository root.
- **F** = fetched `origin/codex/flyfoot1` at `06ecf21b635dc86553695f6943a851196d406cfe`. `F:path:line` means that exact branch snapshot, read with `git show`; it does not mean the working file in A. F has the S223 sole changes and later ground-support pass.
- Toolkit and requested audit brief read first; clean worktree fetched and rebased successfully. Brief/inbox were checked; the brief emitted a large backlog, not a replacement assignment. This session implements only the operator's ANIMAUDIT1 request.
- No Godot process, import, test, render, DCC, browser window, video player, or image viewer was started. No game file, switch, gate, clip, or threshold was edited. Only this document and `Tools/anim_audit_axes.py` are deliverables.
- Task overrides: the two-file audit scope supersedes generic HANDOFF/mailbox-write/done-gate habits. No HANDOFF block or extra tracked message is written. No engine-based proof is claimed. Inspection of binary FBX transforms is specifically left unresolved under the task's JSON-only Python allowance; it is not guessed from a bone-name map.

### An important source/digest mismatch

The audit pack describes a native-MH production path. `research/MHNATIVE1_DIGEST.md:15-44` describes direct 341-joint native playback and bypassing late writers. **That implementation is absent from both audited player snapshots.** In A, boxing idle is `active_guard.glb`, retargeted (`Godot/scripts/FightClipBinding.gd:28-35`); the lead hook is RamsterZ FBX (`:39-45`); the inside uppercut is a retargeted Cascy clip (`:79-85`). `FightStagePlayer.bind` branches on metadata's retarget flag, and `_graft_retargeted` calls the silhouette correction and retarget pipeline (`Godot/scripts/FightStagePlayer.gd:2295-2306,2344-2382`). Neither A nor F contains `mh_native_clips` or a native-MH binding/bypass in this player, binding, or MetaHumanRig module. The five files in `assets/anim/metahuman/` alone do not prove production uses them.

`research/ANIMSOURCE1A_DIGEST.md:3-7` explicitly says its source delivery did not change production bindings. Treat MHNATIVE1's digest as evidence about its recorded implementation/run, not proof that A/F contains it. Establish the intended integration commit before claiming a native-vs-retarget A/B comparison.

## 1. Ranked causes and falsifiers

### 1 — Target-local operations lack a target-rig coordinate contract

**Confirmed code defect: post-retarget mirroring.** `Godot/scripts/FightClipMirror.gd:17-28,62-82` swaps Left/Right track names and transforms every rotation with `(qx,-qy,-qz,qw)`. This is `S R S`, where `S=diag(-1,1,1)`, in the key's local coordinates. It takes neither skeleton nor rests nor parent frames. `Godot/scripts/FightStagePlayer.gd:2351-2354` applies it **after** the target has been retargeted; `:2392-2407` also mirrors already-inserted reaction animations. The graft route calls it at `:1522-1524` too.

The new raw-asset inspection supplies a numerical witness without running the game. Reflecting the left MH local rest with that formula and comparing with the corresponding right local rest gives, on body05:

| Bone | Local-rest mirror discrepancy, degrees |
|---|---:|
| thigh | 178.264 |
| calf | 2.066 |
| foot | 5.646 |
| ball | 180.000 |
| upperarm | 90.526 |
| lowerarm | 73.294 |
| hand | approximately 0.0004 |

This calculation compares **each local bone**, not the final accumulated limb error. The near-zero hand row does not save the hand: its parents are wrong. The corresponding six sampled converted Mixamo GLBs have discrepancies below 0.003 degrees; UAL's largest is about 0.119 degrees. That is concrete evidence that a convention-dependent mirror migrated into a rig on which it is not valid. Binary evidence location: `mh_boxer_05.glb` JSON nodes 306/339 thigh, 294/327 calf, 293/326 foot, 292/325 ball, 129/262 upperarm, 117/250 lowerarm, 109/242 hand; calculation is `Tools/anim_audit_axes.py:107-115`, `mirror_rest_error`.

There are actual uses, not just dead utility code: `hook_rear` has `mirror:true` (`Godot/scripts/FightClipBinding.gd:205-213`), and every `react_*` graft gets a mirrored version (`Godot/scripts/FightStagePlayer.gd:2398-2407`). **Do not claim this proves the named `boxing_rear_uppercut` failure**: the role's actual selected source and mirror use must be traced separately. A faulty mirror is sufficient to break mirrored poses, not an explanation for every non-mirrored right foot.

**Confirmed unsafe portability: local pose-layer recipes.** `Godot/scripts/FightClipPoseLayer.gd:19-21,91-105` post-multiplies `q * Quaternion.from_euler(deg * weight)`. It has no rig, rest, side frame, or per-body conversion. The caller applies those recipes to the already-retargeted target (`Godot/scripts/FightStagePlayer.gd:2373-2375`). Examples include the rear guard arm in a lead uppercut (`Godot/scripts/FightClipBinding.gd:73-75`), rear arm recovery (`:110`), catch guard's 47-degree upper arm / -42.5-degree forearm / 13.5-degree shoulder (`:173-175`), and lead-arm recipes (`:1111-1113,1155-1156`). The catch comments explicitly describe calibration on generated legal rigs (`:160-166`), not a per-MH anatomical-space solve.

These recipes are side-specific numbers, **not literally identical L/R numbers**. The error is applying the same numeric recipe across incompatible target coordinate systems. The same problem exists on the left; the MH right-side convention makes a blanket fix especially dangerous. Large fixed values can produce a wrong wrist/guard even if retargeting itself is correct.

**Proof/disproof:** first evaluate neutral rest and small signed rotations at the mirror/pose-layer boundary, then compare the actual sampled mirrored and non-mirrored failing roles. A rest-aware mirror must preserve each target's neutral rest, reflect an anatomical direction correctly, and be involutive. For pose layers, hold the anatomical target constant across a legacy rig and MH05/MH08; compare the resulting joint directions, not Euler components. If a failing frame never visits mirror/pose-layer code, those defects do not explain that frame.

### 2 — Baseline transfers foot-bone slope as if it were sole orientation

`Godot/scripts/FightClipRetarget.gd:327-359` aligns every silhouette segment from target bone positions to source bone positions; Foot-to-Toes is included in the segment list (`:247-279`). A foot's elevated ankle and low ball are not its sole plane. `Godot/scripts/FightClipFootPlant.gd:59-65` then feeds the downward rest ankle-to-ball line into a toe-floor correction. That is a second anatomical proxy for the wrong quantity.

F's changes are **not an identical local Euler rotation applied to both feet**. `F:Godot/scripts/FightClipRetarget.gd:354-359` constructs a heading about skeleton-space UP, multiplies the individual target global rest, and converts through the individual parent inverse. `F:Godot/scripts/FightClipFootPlant.gd:60-69` projects the rest direction onto the floor, then uses posed/rest bases. Both preserve per-side coordinate information. Reversing the right-foot angle in either would introduce a new error.

The previous digest records a source rest ankle-to-ball pitch of 39.179 degrees versus approximately 24-29 degrees on MH (`F:research/FLYFOOT2_CHAIN_DIGEST.md:23`). Its S223 short-run measurements improve after those two changes. That supports an actual cause for the baseline excessive sole tilt. The subsequent full-duration gate remains red, so it was a partial repair.

**Proof/disproof:** inspect source reference, corrected virtual rest, retargeted key, pose-layer output, and final foot-bake output at the *same* failing time, using the target's skinned sole plane. Preserve intended heel lift separately from foot pointing. If the first wrong plane already exists before this bake, a runtime foot-lock patch cannot repair its origin. If the source-authored sole is already wrong, correct the source.

### 3 — Mirrored reaction animations can be folded twice

This is a separate, mechanically traceable defect in transformation state:

1. `Godot/scripts/FightWorldStage.gd:191` installs MetaHuman's library watcher.
2. `Godot/scripts/FightStagePlayer.gd:2392` adds the retargeted animation. The synchronous `animation_added` callback calls `fold_intermediate_rests` (`Godot/scripts/MetaHumanRig.gd:204-225`).
3. That converts collapsed mapped-parent keys to actual-parent locals and marks `mh_rest_folded` (`Godot/scripts/MetaHumanRig.gd:273-299`).
4. `Godot/scripts/FightStagePlayer.gd:2399` mirrors the already-folded animation. `FightClipMirror.gd:13-29` creates a fresh Animation and copies tracks and a few playback properties, **no metadata**.
5. Adding it at `:2407` triggers another fold because the idempotence marker is absent.

Intermediate MH spine/neck rests are not all identity. This can alter the mirrored reaction chest/head even independently of the side mirror. It also discards other provenance/constraint metadata; blindly copying all metadata is not a complete solution because side-specific contact/foot data must be transformed too.

**Proof/disproof:** record the key-space state and per-track quaternion before/after each insertion. On a mirrored reaction, an extra multiplication by the inverse intermediate rest establishes double folding. Require exactly one collapsed-to-actual-parent conversion. This is a static call-order finding; its per-frame visual magnitude was not measured here.

### 4 — Many writers preserve or overwrite different definitions of “correct”

The call graph below shows several independent owners of hips, arms, legs and wrists. Two examples are decisive:

- Runtime leg IK deliberately **preserves incoming foot world orientation** (`Godot/scripts/FightStagePlayer.gd:6097-6128`). Thus slide/crossing/gait can pass while the sole remains pointed. Its correctness as an XZ plant does not establish rotational correctness.
- Runtime arm IK preserves incoming hand global orientation while changing the upper/lower arm (`:5395-5415`). That can create or retain wrist bend relative to the newly bent forearm. The late wrist modifier then changes the hand again (`Godot/scripts/FighterWrist.gd:45-66`). Each has a defensible local objective; together they lack a single contact-and-orientation constraint.

Root correction after planting moves a good plant; later shuffle reseating bends the legs again. A late torso/contact pass changes wrists after a continuity pass. Held contact offsets are reintroduced next frame and can contend with new source motion. These are actual dependencies, not “49 writers all run every frame.”

**Proof/disproof:** record per-bone deltas and constraint error after each existing writer callback, with role, branch SHA, switches, body and time. Toggle or remove exactly the first offending owner in a bounded experiment. If the plane is already wrong at `animation_sample`, no later writer is its initial cause, although later writers can preserve or worsen it.

### 5 — Source quality, coverage and validation were insufficient

Native skeleton matching removes one source of error; it does not author correct boxing, receiver response, contact spacing, guard endpoints or transitions. The retained ANIMSOURCE1D body-hook evidence has a 64.47-degree native lead wrist bend and one distinct receiver pose across 21 frames (`F:research/ANIMSOURCE1D_CHAIN_DIGEST.md:25-45`). A runtime mirror fix cannot create that missing receiver choreography.

The five native assets do not cover an entire bout, and A/F does not bind them as a native production palette. “About 500 library clips” is inventory, not verified technique/side/phase coverage. `research/C87_THE_RETARGET_LADDER.md` already distinguishes true technique coverage from merely nearby names; its historical demand counts are not a current coverage census.

**Proof/disproof:** inspect authored native source and final game output separately for the same action and both participants. Require complete start/contact/recovery and joins. A source-faithful bad hook disproves “retargeting caused this hook's shape”; a good source that breaks only downstream implicates the pipeline.

## 2. Axes inspection: what the actual files say

Run:

```powershell
python Tools/anim_audit_axes.py
python Tools/anim_audit_axes.py --json --extra Godot/assets/anim/metahuman/mh_jab.glb
```

Both data-inspection runs completed, exit 0. Default: **28 model GLBs + 10 library GLBs = 38, zero errors/missing bone pairs**; text output contained 877 lines, including 532 bone-axis rows and 266 pair rows. With native jab: **39, zero errors**. Each file prints world-rest XYZ axes for thigh/calf/foot/ball/upperarm/lowerarm/hand on both sides, pairwise dot products, opposed-axis flags, and the local mirror discrepancy. JSON also contains node indices, positions and axis lengths. No buffers are written, assets imported, animations played, or tests launched.

The script reads only the GLB JSON chunk, composes column-major matrix or TRS transforms through every scene ancestor, normalizes the three columns, and resolves explicit bone aliases. It does not confuse renamed Mixamo `thigh_l` with proof of Unreal axis conventions. Missing, ambiguous, invalid or LFS-pointer assets fail visibly. These are **raw scene-node rest axes**, not an assertion about evaluated Godot poses, inverse-bind correctness, or skinned vertices.

The 28 model files are `mh_boxer_01..12`, `mh_member_1..4`, `mh_pilot_01..02`, `mh_staff_cleaner_1`, `mh_staff_coach`, `mh_staff_coach_2`, `mh_staff_coach_3`, `mh_staff_cutman_1`, `mh_staff_desk`, `mh_staff_desk_2`, `mh_staff_physio`, `mh_staff_physio_2`, and `mh_staff_trainer`. All contain a 341-joint skin and show the same leg-axis convention. This includes more than the twelve selectable boxing bodies.

Representative body05 world-rest axes, rounded:

| Bone | X | Y | Z |
|---|---|---|---|
| foot_l | (0.00465, 0.99950, 0.03121) | (-0.14804, 0.03156, -0.98848) | (-0.98897, -0.00002, 0.14811) |
| foot_r | (0.00465, -0.99950, -0.03121) | (-0.14804, -0.03156, 0.98848) | (-0.98897, 0.00002, -0.14811) |
| hand_l | (0.50410, -0.60399, 0.61732) | (-0.79455, -0.60448, 0.05740) | (0.33849, -0.51942, -0.78462) |
| hand_r | (0.50410, 0.60399, -0.61732) | (-0.79455, 0.60448, -0.05739) | (0.33849, 0.51942, 0.78462) |

Body05 L/R axis dot products:

| Pair | X dot | Y dot | Z dot |
|---|---:|---:|---:|
| thigh | -0.99563 | -0.95665 | 0.95229 |
| calf | -0.99612 | -0.95617 | 0.95229 |
| foot | -0.99996 | -0.95617 | 0.95613 |
| ball | -0.95617 | -0.99996 | 0.95613 |
| upperarm | -0.26434 | -0.99828 | 0.26263 |
| lowerarm | -0.49177 | -0.77085 | 0.26262 |
| hand | -0.49177 | 0.26262 | -0.77085 |

The brief's foot observation is reproduced. **“All hand X/Y axes are the left negated” is not literally true in scene-world coordinates.** Bone orientation, mirrored anatomical placement and local-frame convention must be separated. The script's `XY_FLIP` threshold is an explicit diagnostic (X/Y dot below -0.8, Z dot above +0.8), not a universal rig classifier. Native `mh_jab.glb` matches body05's inspected axes to a maximum component difference of approximately `4.8e-6`.

Also, on these feet local X points nearly vertically, not along a generic anatomical pitch axis. A universal “negate right X pitch” patch confuses coordinate names with anatomical movements.

The deterministic ten-file sample is:

| Relative to `Godot/assets/anim/` | Observed leg convention | Observed arm convention |
|---|---|---|
| `ual/UAL1_Standard.glb` (43 animations) | L/R XYZ approximately parallel | X/Y approximately opposed, Z parallel |
| `c207/walk.glb` | same | same |
| `c209/shadowboxing/take1/motion.glb` | same | same |
| `c209/heavy_bag/take1/motion.glb` | same | same |
| `c223/mixamo_pipeline_a/Jab_Punch.glb` | same | same |
| `c223/mixamo_pipeline_a/Hook_With_The_Lead_Hand.glb` | same | same |
| `c223/mixamo_pipeline_a/Hook_Punch_With_The_Rear_Hand.glb` | same | same |
| `c223/mixamo_pipeline_a/Standing_Left_Uppercut_Punch.glb` | same | same |
| `c223/mixamo_pipeline_a/Male_Fight_Idle_Boxing_Stance.glb` | same | same |
| `c223/mixamo_pipeline_a/High_Center_Block.glb` | same | same |

This proves the convention of those stored GLBs, including the converted Mixamo carriers and UAL. **It does not prove the raw UE4/RamsterZ FBX convention or every original Mixamo FBX convention.** The production RamsterZ reference is `assets/anim/audition/ramsterz_h2h/T_pose.fbx`; the raw FBX rest matrices were not decoded under this task's restriction to Python GLB/glTF JSON and git/grep. The historical large-right-hip/toe correction comments are evidence that axis differences were known, not a substitute for inspecting that FBX. Next permitted raw-FBX audit should read evaluated Model pre/local/post rotations and hierarchy or bind Pose matrices, retaining units/up-axis; no Godot launch is intrinsically necessary. Do not infer UE4 axes merely from `UE4_TO_OURS` naming.

## 3. Coordinate-operation inventory

Repeated use of the same *formula* is safe when each bone supplies its own rest/parent basis. The dangerous case is reuse of components without that conversion.

| Location | Operation and right-side assessment |
|---|---|
| `Godot/scripts/FightClipRetarget.gd:174-196,281-310,483-488`; `BoneRestFixer.gd:49-61,102-114` | Per-bone `C=reference^-1*target`, then `source*C`, then inverse retargeted parent. **Handles axis flips**; no shared left correction is assigned to the right. Virtual-rest selection still controls anatomical alignment. |
| `BoneRestFixer.gd:78-87`; `FightClipRetarget.gd:346-359` | Skeleton-space shortest arc transported through each parent. Not a local-axis sign bug; foot segment choice is the anatomical bug above. |
| `F:FightClipRetarget.gd:354-359` | Per-foot rest-based global yaw. Same math, different right rest; no missing right sign demonstrated. |
| `FightClipRetarget.gd:577-616,945-963,1187-1216` | Hip carry axes are parent-derived; parent map walks nearest mapped ancestor. Cascadeur spine split is central-chain math, not an L/R leg/hand axis map. |
| `FightClipMirror.gd:74-84`; `FightStagePlayer.gd:1524,2354,2399` | Fixed local reflection plus name swap. **Broken coordinate assumption on MH**; position X reflection likewise assumes matching local position frames. Scale is copied. |
| `FightClipPoseLayer.gd:91-105`; `FightClipBinding.gd:65-75,108-118,136-150,172-175,487,654-657,1020-1023,1088-1113,1152-1157` | Literal target-local Euler layers. No per-rig conversion; right guard/catch writers are explicit risks. Not all entries act on both sides. These are the binding's rotation-recipe blocks, including central-chain-only variants. |
| `FightClipFootPlant.gd:46-84,173-205` | Same solver on each leg, but uses actual globals and parent inverses. Anchor offset explicitly signs skeleton X by side (`:175-179`), assuming model forward +Z. Lock-foot knee swivel rotates around measured hip-to-ankle direction (`:193-195`), not a typed local X. It preserves foot orientation; wrong incoming pitch survives. |
| `MetaHumanRig.gd:24-60,67-82` | Joint/finger **name** map only; no axis canonicalization. Renaming `foot_r` to `RightFoot` does not make its local frame match the library rig. |
| `MetaHumanRig.gd:259-299` | Per-chain inverse intermediate-rest folding; correct in principle for collapsed-parent keys, unsafe if applied twice or to already-actual-local keys. |
| `MetaHumanRig.gd:348-408` | Staff-only anatomical frames and explicit side sign for finger curl; not the boxing guard writer. Central spine breathing still uses a local X, but it is not an L/R error. |
| `FightStagePlayer.gd:203-210` | Spacing flare post-multiplies local FORWARD with opposite side angles. It does have a side sign, but assumes that typed local axis means the desired anatomical flare on every rig. Per-rest anatomical-axis conversion is absent. |
| `FightAliveStance.gd:167,181-210` | Shoulder event picks a side, reuses a positive local X component and signs local Y; `rot*Euler` is convention-dependent. Continuous position offsets and hit/flinch `_rotate_world` (`:98-103`) instead transport through parent world basis. |
| `FightStagePlayer.gd:91-97,170-181` | Same wrist/fatigue/spring translation code on both sides converts world displacement through each parent; no bare same-local-axis rotation. Can still change chain geometry and wrist-to-forearm alignment. |
| `FightStagePlayer.gd:2191-2198`; `FightBodyLayers.gd:333-345` | Lower splice copies same-target clip locals, then restores upper global orientation through its parent. No missing right sign; it can replace the action's lower pose. |
| `FightStagePlayer.gd:4380-4384,4633-4638,4690-4694` | Join/inertia/dead blend uses residuals derived per bone, not one hardcoded axis for both sides. Bad source or mixed-space input can still be smoothed into the next clip. |
| `FightWorldLiveScreen.gd:5870-5889` | Injury cue combines left/right injury weights, then post-multiplies the central Spine by fixed local Z roll and X fold. This is another anatomical-axis assumption across rigs; it does not write either side's leg directly. Its late spine write can move both arms after contact. |
| `FightStagePlayer.gd:5025,5072,5099,5123,5154-5171,5305-5332` | Reach uses parent-inverse translation; torso/core/leg/upper-arm contact turns use measured geometry and parent conjugation. Leg release delta is computed separately per side. These are later pose owners, not demonstrated left/right sign bugs. |
| `FightStagePlayer.gd:5202-5271` | Guard/contact/head holds are world displacement histories keyed separately L/R and replayed through `_bend_arm`. Same release constant is not an axis map. Deferred push and stale hold state can fight a new pose. |
| `FightStagePlayer.gd:5360-5415,6097-6128`; `FightClipRetarget.gd:1391-1426` | Runtime/baked contact IK uses geometry, global turns and actual parents. Right axes are carried correctly. Preserving hand/foot global orientation does **not** straighten wrist or sole relative to changed upstream geometry. Singular pole cases remain a separate limitation. |
| `animation/InsideUppercutIK.gd:16-27,65-67` | Rotation/translation transported from world to actual parent; side selected by effector. Fixed head-local chin/scalp offsets are another rig assumption, not a right-arm sign correction. |
| `FighterWrist.gd:26-37,45-66` | Wrist-to-middle direction calibrated per side from rest; global correction, parent-inverse write. **Not** identical local right/left Euler. Can override earlier hand orientation after the room has measured it. |
| `FighterFist.gd:24-43` | Same **uniform scale** on both hands' finger bones. No rotational sign error. This is finger shortening under a glove, not anatomically authored finger curling. |
| `CCFighterSkin.gd:475-495,572-585,729-749` | MH glove uses wrist/middle/index/little anatomical frame, two-bone skin binds, side mesh reflection. Fixed shared glove pitch/default roll acts on the **glove mesh frame**, not the skeleton hand bone; side twist offsets are explicitly -75/+71 (`:95`). They can make glove visual orientation disagree with a bone-only metric. Tripo fallback (`:498-522`) uses bone axes and is a different path. |
| `FighterCapsules.gd:301-309,859-944` | Builds/measures capsule geometry; **zero direct bone-pose setters**. The room's collision response writes bones. Do not count a capsule query as an additional bone writer. |
| `BoneTrackGraft.gd:31-48` | Copies existing keys and rewrites paths only. Same bone name is not proof of matching rest. Any non-retarget graft onto MH needs explicit same-rig provenance. |
| `FightActiveRagdoll.gd:333-349`; `FightHitPhysics.gd:48-60` | Global pose output and fence restoration. Coordinate-aware, but can override clip/contact results late. Availability and influence are conditional. |

Table paths without a directory after the first row are also under `Godot/scripts/`; `F:` rows refer to F. This inventory covers the requested modules and the connected pose/glove/guard/contact paths; it is not an assertion about every unrelated animation tool in the repository.

## 4. Writer count and execution order

### Reproducible static count, not a fictitious per-frame number

The 6,499-line `FightStagePlayer.gd` in A has **27 setter call sites plus one `reset_bone_poses`**. F is 6,600 lines and has the same count, with shifted line numbers. Neither has 49 direct setters inside that file.

Across the following nine connected runtime modules, there are **49 textual setter/reset sites**. Of those, one is a fresh-mount reset, one initializes a ragdoll proxy, and six are undo/restoration sites before clip sampling. The remaining **41 are potential post-sample setter sites**, not 41 calls guaranteed per frame. Loops can call a site many times; switches and role guards can skip it; inertia modes are alternatives. The engine animation sampler and internal physics modifier writes are additional operations, not GDScript call sites in this count.

| Module under `Godot/scripts/` | Sites | Exact A line numbers |
|---|---:|---|
| `FightStagePlayer.gd` | 28 | 97, 210, 2198, **3582 reset**, 3732, 3739, 3742, 4113, 4160, 4380, 4384, 4633, 4638, 4690, 4694, 5025, 5072, 5099, 5123, 5171, 5331, 5410, 5411, 5415, 5943, 6126, 6127, 6128 |
| `FightAliveStance.gd` | 7 | 80, 103, 177, 178, 200, 202, 210 |
| `FightBodyLayers.gd` | 3 | 333, 339, 345 |
| `FighterFist.gd` | 2 | 41, 43 |
| `FighterWrist.gd` | 1 | 66 |
| `FightHitPhysics.gd` | 2 | 58, 60 |
| `FightWorldLiveScreen.gd` | 2 | 4679, 5889 |
| `animation/InsideUppercutIK.gd` | 2 | 21, 27 |
| `FightActiveRagdoll.gd` | 2 | **75 proxy initialization**, 349 |

The six pre-sample undo sites are player 3732/3739/3742/5943 and AliveStance 177/178. Skin follower writes (`FighterSkinFollower.gd:157-158`) target an overlay/destination skeleton, not extra writers on this source MH skeleton. Physique setup (`FighterPhysique.gd:149,280`) is not a per-frame correction. Neither was smuggled into the 49 count.

### Ordered frame pipeline

This is the actual source call order, with conditional branches shown. Each row can contain multiple per-bone writes. The room's outer loop calls A and B; the same logical order applies to each.

| Order | Owner / action | Evidence and what it can supersede |
|---:|---|---|
| 0 | Restore spacing flare, contact pelvis, previous ground lift, IK undo stack, AliveStance undo | `FightStagePlayer.gd:3731-3748`; clears prior-frame overlays before new sample. |
| 1 | AnimationPlayer sample/seek; onset warp or S-curve selects the sample time | `:3751-3773`; `_paired_hold` samples then returns at 3755. An ordinary `in_pair()` clock is a different path, not that same early return. |
| 2 | Lower-body clip splice; restore upper-body global orientation | `:3781-3782,2193-2198`; replaces hips/legs from main action. |
| 3 | AliveStance discrete event | `:3784-3787`; local event overlays source hips/shoulder/spine. Continuous breath is calculated here but applied later. |
| 4 | Join inertialization / review join / dead blend, depending on mode | `:3794-3795,4380-4384,4633-4638,4690-4694`; can replace/offset any driven bones after lower/event passes. |
| 5 | Layer hips smoothing | `:3797,4113`; changes hips again. |
| 6 | Foot locking, including support/pivot/front-step targets | `:3810-3813,6083-6091,6126-6128`; rewrites thigh/calf/foot, preserves current foot world orientation. |
| 7 | Ground hips, shuffle leg solve, optional second ground | `:3822-3825`; can undo prior support height or foot locations. |
| 8 | Continuous breathing/guard positions | `:3832-3833`; applied after pose history/clip-hand recording. |
| 9 | Human hit/flinch response | `:3834-3839`; rotates/translates upper chain. |
| 10 | Fatigue and glove-spring pose pass | `:3840-3841,170-181`; translates shoulders/head/hands in world-derived directions. |
| 11 | Inside-uppercut procedural solve | `:3842-3847`; can replace source uppercut shape after all the above. |
| 12 | Room spacing flare; strike aim; ordinary contact solve; refused-overlap hand pushes/holds | `FightWorldLiveScreen.gd:2013-2022`; `FightStagePlayer.gd:210,5214,5227,5915`; multiple arm solves may contend. `finish_human_frame` at room 2126 advances response state, not another direct bone setter. |
| 13 | Root/rope/contest placement, early hand finish when sync OFF, strike effector cap, early hand-offset smoothing when sync OFF | room `:2026-2041`; player `:5717-5781,5784-5834,4085`. A root move changes world contacts without a bone-local setter. `finish_hand_frame` also reseats shuffle legs/grounds before its hand-role early returns (`:5789-5792`). |
| 14 | Two leg-cross correction passes, then release limiting | room `:2044-2049`; player `:5123,5171`; changes hips/descendant feet after foot planting. |
| 15 | Pair-gap/root cap/easing; late refused-head contact and held-head release | room `:2050-2068`; player `:5256,5265,5331`; can move hands after early continuity. |
| 16 | Final posed-contact solve | room `:2069-2070,4498-4730`; core/torso/reach/landed-hand and separation writes. Iterates contacts; not one write. Room 4679 also explicitly restores a spine rotation in a refused correction path. |
| 17 | Queue/refresh hit-physics targets; limb cue | room `:2075-2082`; limb cue writes spine at 5889. Physics targets here are not the later modifier output. |
| 18 | Final root/rope placement; when sync ON, settle hand offsets then finish hand frame | room `:2085-2092`; smoothing may move an arm after contact solve, and shuffle reseating can still run. |
| 19, F only | Final ground support | `F:FightWorldLiveScreen.gd:2099-2101` -> `F:FightStagePlayer.gd:4196-4198`; an extra late hips correction, not a new unique setter site. |
| 20 | Skeleton modifiers: fist scales, optional ragdoll / physical simulator / ArmFence; wrist kept last | `FighterFist.gd:36-43`; `FightActiveRagdoll.gd:7-10,333-349`; `FightHitPhysics.gd:48-60`; `CCFighterSkin.gd:398-405`; `FighterWrist.gd:40-66`. Exact active middle order depends on mounted nodes; code proves the wrist-last policy, not which optional physics node existed in a historical run. |
| 21 | Skin/glove synchronization from modified skeleton | `CCFighterSkin.gd:409-429`; rendering consumes the modifier result. Skeleton modifier poses are subsequently restored, so a late ordinary bone read need not equal the skin's drawn pose. |

`reseat_hand_writers_after_late_contact` (`FightStagePlayer.gd:5276-5295`) only changes continuity state, not bone poses. The room explicitly says not to call it before sync-on writers (`FightWorldLiveScreen.gd:2072-2074`). Counting it as an independent direct writer overstates the number, while ignoring the state it controls understates the dependency.

### Clip construction happens before that frame order

Do not call `FightClipFootPlant.bake` a per-frame runtime modifier. The construction chain is: raw source read -> per-target rest/silhouette correction -> retargeted keys -> optional mirror -> phase warp/root hold -> local Euler layer -> optional foot lock -> optional sole bake -> address paths -> library insertion/intermediate-rest fold -> mirrored reaction insertion -> recovery/guard key edits -> dirty first-playback sole rebake (`FightStagePlayer.gd:2344-2407,1798-1821`; `MetaHumanRig.gd:239-254`).

Thus `animation_sample` is **already the result of several baked transforms**, not raw motion. An observer identifying it as the first bad writer narrows the problem to clip construction; it does not distinguish reference choice, mirror, pose layer, folding and sole bake.

## 5. Import/rest/scale audit

| Asset/settings | Observed settings | Interpretation |
|---|---|---|
| `Godot/assets/models/metahuman/mh_boxer_05.glb.import:21-45` | apply root scale=true; root scale=1; named skins=true; animation import=true; immutable tracks removed=true; rest-as-RESET=false; import script empty; `_subresources={}` | No configured BoneMap, retarget method, rest fixer or Fix Silhouette in this file. No custom import script. |
| `Godot/assets/anim/c223/mixamo_pipeline_a/Jab_Punch.glb.import:21-45` (also c207 walk) | Same settings above | No configured import-time humanoid-axis overwrite or silhouette fix. Raw GLB still has its own convention. |
| `Godot/assets/anim/audition/ramsterz/T_pose.fbx.import:21-46` | Same root scale/map absence; animation trimming=true; FBX importer=0 | Trimming may affect available keys; no configured rest-fixer map. This is settings evidence, not evaluated raw FBX axes. |
| `Godot/assets/anim/metahuman/mh_jab.glb.import:21-49` | root scale=1; immutable tracks removed=false; AnimationPlayer compression=false and optimizer=false | Native file settings intentionally preserve channels; no BoneMap/rest fixer is configured. |

More important than these sidecars: **the audited runtime bypasses the imported `.scn` for these loaders.** `MetaHumanRig.load_fighter` reads raw GLB bytes with `GLTFDocument.append_from_buffer` and `generate_scene` (`Godot/scripts/MetaHumanRig.gd:67-78`); clip loading does the corresponding raw GLTF/FBXDocument operation (`Godot/scripts/FightClipRetarget.gd:988-1005`). Renaming, runtime virtual-rest correction, key folding, skin-bind folding and physique scaling are the relevant operations, not a hidden editor BoneMap setting in the examined sidecars.

- `MetaHumanRig` renames before scene generation, but does not change those node rests (`:72-78`).
- Its default `fold_static_skin_weights` changes skin-bind bone assignments and folds static helper rest chains into bind poses (`:92-122`). It does not animate all 341 helpers. This preserves static chain placement but cannot reproduce an animated corrective system. It is a real deformation simplification, not proof that the entire skeleton is malformed.
- The retargeter deliberately uses nearest mapped parents (`FightClipRetarget.gd:945-963`); MH folding must reconcile the actual intermediate joints exactly once.
- The stage scales bodies from measured height/physique (`FightWorldStage.gd:187-195`). Uniform centimetre/metre conversion changes distances, not unit-axis handedness or one side's orientation alone. Actual nonuniform scale/skin deformation still needs a separate evaluated-pose comparison.
- ANIMSOURCE1A documents a historical 100x export-root repair (`research/ANIMSOURCE1A_DIGEST.md:89-95`). That is not evidence that today's observed right-only angle comes from a current 100x import error.

**Not established here:** equivalence of raw nodes and every Godot imported rest, correctness of every inverse bind, exact original FBX transforms, or the final drawn modifier stack. No engine was available by design; sidecar inspection must not be presented as an engine import validation.

## 6. What is not the cause, and what the gate does/does not prove

1. **The right-side rest convention by itself is not a corrupt asset.** All 28 model GLBs agree, and the inspected native jab uses the same convention. Correct rest-aware math can handle it.
2. **The core `source_global * correction` operation does not ignore the right rest.** It computes each bone's correction. The old 137-degree-hip comment is motivation for that correction, not evidence the correction is currently absent.
3. **A shared loop is not proof of an axis bug.** Foot IK, wrist limiting and most contact turns use measured directions and parent conversions. Reversing their right-side signs without a witness would break correct math.
4. **FighterCapsules does not directly rotate bones.** Its constraints may provoke room corrections, but capsule construction/queries and correction writers are distinct.
5. **A-pose versus T-pose is addressed, not automatically solved everywhere.** A reference plus virtual silhouette is explicitly used. The remaining question is whether that reference and anatomical alignment are appropriate, especially feet; merely saying “T versus A” does not locate the fault.
6. **Root translation/scale alone does not explain opposite local handedness.** It can explain spacing, floor penetration, apparent reach and later IK demand. Keep that causal chain separate.
7. **The sole probe is substantially better than an ankle-to-ball proxy, but not infallible.** `F:Godot/tools/foot_orientation_probe.gd:12-25,28-74` skins three selected sole vertices using their influences; `:76-83` measures the resulting plane. There is no constant right-foot local rotation in that measurement. However, it chooses the upward normal (`:78-79`), so its reported “pitch” is unsigned plane tilt in 0-90 degrees, not signed anatomical pitch or a detector of an upside-down sole. Selection should also verify three distinct, non-collinear markers. Post-draw reads must be reconciled with temporary SkeletonModifier outputs (`CCFighterSkin.gd:419`); a frame-post-draw callback alone is not proof that every transient modifier was sampled.
8. **“94-97% outside” is not “94-97% en pointe.”** The retained rear band is 10-35 degrees. F's guard still records rear sole angles around 3.8/4.77 degrees, below the lower limit; the digest separately records the 62.51-87.64-degree seven-frame excursion. Without below-band/above-band/roll counts, the aggregate percentage cannot establish the direction or prevalence of pointing. The severe excursion is independently red. Do not loosen the band in this audit.
9. **Passing gait or joint-position tests does not prove shape.** `_bend_leg` preserves foot orientation; `_bend_arm` preserves hand orientation. Those choices explain how slip/contact-position metrics can pass while feet or wrists look wrong.

## 7. Why my rounds kept ending red

I did not finish the requested animation outcome. The records support specific reasons rather than a general excuse about MetaHuman:

- **FLYFOOT:** I initially measured an anatomical ankle-to-ball line as if it were a sole. That was a bad observable for the complaint. The later mesh-plane probe corrected the measurement, and the two source/bake changes improved the short sample. I then had full-duration evidence that the solution was incomplete. I should have separated low-angle rear-band failures from actual high tilt, and traced the worst clip through every construction boundary before spending further iterations on corrective layers. A six-second improvement and a green gait gate were never enough for bout-wide acceptance (`F:research/FLYFOOT2_CHAIN_DIGEST.md`, “Red evidence”, “Round 2”, “Full-duration result”).
- **PAIRLIVE:** the chain record contains instrumentation and scheduling attempts, not three successful or failed production repairs. It explicitly says the original gate never ran, the benchmark population was different, and first-writer hypotheses were unverified (`F:research/PAIRLIVE1_CHAIN_DIGEST.md:8-18,23-33`). I left the issue open because there was no red-to-green proof. Scheduling explains missing runtime evidence; it does not establish or excuse the animation defect.
- **ANIMSOURCE1D:** I preserved rejected source shapes and recovered a useful guard candidate, but did not produce an accepted two-person hook. The body-hook receiver was static, source wrist/facing were red, retained exports were not a fresh current-runtime capture, and old still/export transforms were not fully matched (`F:research/ANIMSOURCE1D_CHAIN_DIGEST.md:7-11,25-45,60-76`). A static guard primary pass did not meet the hook/palette endpoint requirement.
- **The recurring engineering mistake:** treating names, isolated numeric improvements, authored assets and diagnostic WIP as steps close enough to a finished animation, while rig-space assumptions, source ownership, integration state and final visual behavior were still unsettled. Adding another late clamp increases the number of places that can hide or reintroduce the defect. I also should have checked the current source against native-playback claims earlier; a digest is not an executable implementation.

These are separate outcomes. Red sometimes meant a demonstrated defect, sometimes a missing validation run, and sometimes a useful partial candidate. Reporting all of them as one mysterious repeated “MH failure” loses the information needed to fix them.

## 8. First fix and its proof

**First code change: replace the blind target-local mirror with a rest-aware mirror at one explicit clip-construction boundary, including an explicit collapsed-parent/actual-parent state.** Do not add a right-foot sign switch. Do not replace the models. This has the strongest fresh, reproducible mathematical witness and removes a known source of severe pose corruption without changing boxing thresholds.

A clear formulation in skeleton space is:

```text
S = sagittal reflection in the canonical skeleton frame
D_left = G_pose_left * inverse(G_rest_left)
D_right = S * D_left * S
G_pose_right = D_right * G_rest_right
L_pose_right = inverse(G_pose_actual_parent_right) * G_pose_right
```

Map every paired bone, handle the central chain, and reflect position displacements in that same frame with an explicit policy for target proportions. Preserve each target's neutral rest. Alternatively mirror source motion in a verified canonical source rig before the target retarget stage. **Do not simply copy folded metadata onto keys of a different coordinate meaning.** Fold once after the mirror's declared output space; transform side-specific metadata or rebuild it.

Proof sequence for the later implementation owner, **not executed in this audit**:

1. Keep this raw neutral-rest discrepancy as the red witness. The replacement must map zero motion to each target rest; mirror twice must recover the original motion, and a signed anatomical rotation must mirror correctly on both sides. Use MH05/MH08 and an unflipped-leg control; include intermediate spine parents.
2. At a known mirrored production reaction/hook, compare source -> retarget -> mirror -> fold -> foot bake at identical times. Require exactly one fold. Validate limb directions, wrist orientation and skinned sole planes, not quaternion component equality.
3. Reproduce the exact rear-uppercut witness at 38.225-38.425 s for seed 930093/body08. If it does not traverse the mirror, do not advertise the mirror repair as its fix: use the same per-stage readback to isolate that clip's pose-layer/foot-bake/source fault next.
4. Restore the production call chain and verify post-modifier drawn skin, all twelve boxing bodies, both seeds, complete idle/action/recovery transitions and the original duration. Report below/above-band and roll failures separately, along with gait. Keep the accepted thresholds and compare unchanged controls.
5. Finish with framed game-camera guard/between/contact evidence and a full motion review. Only that supports “fixed in game.” Engine scheduling must provide one exclusive slot; no competing run should be launched to obtain it.

The already-recorded sole-rest correction should be retained as a separately bounded candidate while its residual failures are resolved. After mirroring, the next code boundary is the hardcoded local Euler layers: re-author those targets in anatomical/canonical space or bake them for the MH rig. No claim that the first fix alone completes the bout.

## 9. Simplify or replace?

**Simplify ownership and replace the ad hoc clip-construction contract; do not rewrite the whole game or buy another model as the first move.** The useful parts already exist: original sources, Cascadeur rigging, rest-aware retarget math, anatomical glove frames, two-bone IK and writer observers.

Proposed production method using the existing tools:

1. One canonical MH authoring rig in Cascadeur, with Blender used for deterministic export/package inspection. Library motion can be retargeted and cleaned up **offline**, then approved and baked. Author pair interactions with both performers and one shared time/root contract. This is a proposed workflow, not a claim that another tool automatically improves boxing.
2. One versioned asset contract: hierarchy/rest fingerprint, coordinate convention, units, per-clip source and retarget recipe, authored root motion, support/contact curves, striking side and phase markers. Native same-rig clips and library-derived clips can share the final contract; they must not silently take incompatible paths.
3. A small ordered runtime pose graph: sample/blend -> bounded body additives -> one combined support/contact solve -> one final hand/skin policy. Each stage declares the bones it owns and the space it consumes/produces. Preserve paired-take ownership end to end, including the room and modifiers.
4. Retire redundant writers only after their constraint is owned by that graph. In particular, combine the repeated hand push/hold/continuity solves and settle foot translation **and** orientation together. Do not simply delete all 49 textual sites; undo/setup and renderer-specific writes are not equivalent to competing animation layers.
5. Expand native/approved coverage around actually played boxing roles and transitions. A five-clip palette with a broken fallback is not an accepted native bout. Fallback use must be explicit in the recording and acceptance report.

A wholesale Godot/native-engine retarget replacement is not justified by this audit: the central global correction is sound, and the demonstrated failures sit at local mirroring/layers, anatomy selection, lifecycle state and composition boundaries. A replacement retargeter would still need verified rests, source cleanup, pair choreography and writer ownership. Fix the demonstrable boundary first, then reduce the live pose graph instead of accumulating more switches.

## Delivery / limits

Delivered: this report and `Tools/anim_audit_axes.py`. Fresh evidence is raw GLB JSON inspection and static source/call-order analysis. Historical runtime numbers are explicitly attributed to the F digests. No fresh game acceptance, import validation, raw-FBX matrix result, or visual repair is claimed. The report answers the audit hypotheses while keeping those remaining proof obligations visible.
