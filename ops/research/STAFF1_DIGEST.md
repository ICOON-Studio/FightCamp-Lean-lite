# STAFF1 — clothed MetaHuman gym staff

S154, 2026-10-03. Branch: `codex/staff1-metahuman-staff`. Four Creator bodies are mounted on the room calm/seated idles behind `metahuman_staff=1`. **The game default remains OFF.** This is a reviewable wardrobe fallback, not the requested tracksuit/scrubs/jeans wardrobe: the installed Creator content supplied only `WI_DefaultGarment`, a fitted T-shirt and shorts, without shoes.

## Sources and delivered cast

Before building, opened the primary PNGs with the file image tool: `staff_s154.png`, `office_s154.png`, `floor_s154.png`, `lobby_s154.png`, and `physio_s153.png`, `locker_s153.png`, `mat_s153.png`, all under `docs/previews/q232/`. The four S154 files supersede the missing S153 versions as instructed; no copies from the main checkout were needed. Read MH1/MH2 digests and the task's pipeline before building.

All four use Epic's Creator-fitted `WI_DefaultGarment` topology, with matte shirt/shorts colours. Tracksuit jacket/pants, polo/scrubs, trousers/jeans, hoodie and shoes were unavailable in the installed wardrobe. No clothes were modelled by hand or bought. Licence/provenance follows [MH1](MH1_DIGEST.md)'s MetaHuman/Epic section.

| Role / GLB | Creator preset and groom | Body height | Final bytes | Outfit appearance |
|---|---|---:|---:|---|
| `mh_staff_coach.glb` | Walter; BobLayered, grey cards; heavier build | 1.78 m | 4,953,852 | Slate T-shirt, dark shorts, barefoot |
| `mh_staff_trainer.glb` | Dominic; PulledBack | 1.80 m | 4,325,636 | Grey T-shirt, dark shorts, barefoot |
| `mh_staff_physio.glb` | Jelena; UpdoBraids | 1.68 m | 4,866,788 | Pale T-shirt, dark shorts, barefoot |
| `mh_staff_desk.glb` | Aera; BobMessy | 1.65 m | 4,921,752 | Blue-grey T-shirt, dark shorts, barefoot |

Each GLB has one 341-joint skin, including the deforming garment. Embedded images are at most 1024 pixels; the delivered flat-colour garment has no image textures. [Asset audit](../docs/previews/staff1/asset_audit.json) and adjacent per-model JSONs record hashes, body constraints, image sizes and export provenance. Creator receipts are in `docs/previews/staff1/*_creator_receipt.json`.

## Build and mounting

`staff1_run.py` wraps UE 5.8.2's existing MH2 Creator pipeline, one character at a time. A small generated C++ bridge exposes Epic's `ExportToSkeletalMesh` for the Chaos outfit; `staff1_bridge.py` preserves its source. Core Data preview skips garment skin transfer when face DNA is absent, so Blender transfers the fitted body's skin weights by nearest-triangle barycentric interpolation, retaining four normalized influences. A body coverage mask hides skin beneath clothing while preserving overlap under collars, cuffs and hems. Garment geometry itself remains Creator's. The final mask was checked in both standing and seated renders.

Walter/Dominic's initial short inseams failed the unchanged torso band. Rebuilt them in Creator with 80/82 cm inseams, preserving the requested heights; the tests were not loosened. Groom reference heads come from their actual binding assets, including Legacy01.

The room branch loads through `MetaHuman.load_fighter`, scales anatomical sole-to-crown height, and resamples the existing baked f01 room clips with rest correction and MH intermediate-rest folding. Their archived GLB/CMU source metadata is not runtime-loadable, so the baked `.res` animation is the source. Feet are planted using the target skeleton's foot/toe datum. Existing room seat offsets remain in charge after mounting. Office, mat and film inherit the unchanged `COACH_MODEL` callers; their source files needed no edits.

The idle floor coach is moved clear of the kit locker, and the desk attendant stands beside the counter clear of the hanging membership sign, only inside the opt-in branch. Existing fighters and OFF paths retain their original bodies.

**MH3 dependency:** STAFF1 carries only the authorized `MetaHumanRig.gd` diff from `402c301b` to `origin/codex/mh3-walk` (`5b9f5a21f91bbcd39fd0d655ce33a3d83d987ef2`). Its final file matches that commit exactly. No MH3 tests/tools/previews were taken. MH3 is unmerged and its walk acceptance is red; STAFF1 may need a rebase when MH3b lands. These staff stand or idle seated; this delivery makes no walking claim.

## Opened final stills

Opened every final room PNG below and the [1280×720 portrait](../docs/previews/staff1/portrait.png) with the file image tool after the last export. No desktop viewer was opened. No T-pose or floating groom was visible. The staff occupy their chairs/bench/sofa without obvious body-through-furniture in these views; this is a still review, not exhaustive collision certification.

| Still | Observed result and remaining visual issue |
|---|---|
| [Training floor](../docs/previews/q232/floor_staff1.png) | Grey-haired clothed coach is now visible in front of the kit locker, feet on the floor. He is small in the wide camera and angled away. |
| [Lobby](../docs/previews/q232/lobby_staff1.png) | Desk woman and her face are clear of the hanging sign, standing beside the counter. Bare feet and shorts do not read as ideal reception wear. |
| [Office](../docs/previews/q232/office_staff1.png) | Clothed owner sits upright in the chair behind the desk; face and grey hair visible. Desk/UI markers obscure the lower body in this camera. |
| [Locker](../docs/previews/q232/locker_staff1.png) | Coach stands beside the scale; trainer sits on the bench with the fighter. Clothing follows the seated pose; most staff faces turn toward their work. |
| [Mat](../docs/previews/q232/mat_staff1.png) | Coach stands at the rear edge of the mats, clothed and separate from the fighters. Idle stance is rather stiff. |
| [Staff](../docs/previews/q232/staff_staff1.png) | Coach at table, candidate on chair, trainer on sofa; bodies sit above their seats. Sleeve/shoulder deformation is still less polished than the face work, and the sofa sitter's reach is generic. |
| [Physio](../docs/previews/q232/physio_staff1.png) | Clothed physio stands clear of the treatment table, hair attached. Pale shirt is too bright under this room's lights; shorts/bare feet are an explicit wardrobe limitation. |
| [Film](../docs/previews/q232/film_staff1.png) | Clothed coach stands clear of sofa/table, facing the screen. His back is naturally toward the camera. The pre-existing pointer/cap props are not reattached to the MH hand/head by this task; pointer alignment remains wrong. |

Portrait review: four distinct faces, grey coach hair, attached grooms, arms down and complete legs/feet; all faces lit. The hem gaps found during mask iteration are absent in the final portrait. Remaining shortcomings are generic bulky shoulders, outward foot stance, coarse groom-card edges, very bright physio shirt and the common T-shirt/shorts wardrobe. These are not presented as polished role-specific uniforms.

## Validation

- Parse: `CHECK total=10 fails=0 autoload_refs=0 autoload_warnings=0`; nine touched production/test/render scripts plus the new portrait harness. Python syntax: 15 files passed.
- ON: body-scale population `checks=107 failures=0`; original S153 checks and bands retained. Four MH bodies each exercise calm and seated mounting, named skeleton, playing clip and anatomical landmarks. Calm hips-to-head distances: coach 0.605, trainer 0.613, physio 0.619, desk 0.586 m. Standing feet 0.010–0.015 m; seated test datum 0.928–0.931 m before room-specific reset.
- ON and OFF: `room_body_scale`, `room_click_marks`, `office_room`, `staff_room`, `physio_room`, `locker_room`, `mat_room`, `film_room` each returned `SUITE total=1 fails=0`, one at a time through `run_tests.py --jobs 2`. Click marks: 93 checks, zero failures. Final geometry-only mask correction receives an additional scale/staff-room run; no full suite was run.
- Raw-loader mutant: `SUITE total=1 fails=1`, engine rc=1, `checks=107 failures=20`; named loader/playing-idle/seat-datum failures. The adapter confirmed `STAFF1_MUTANT detected as FAIL`. [Mutant log](../docs/previews/staff1/mutant_room_body_scale.txt).
- OFF: all eight fixed-step PNGs are **byte-identical** to intake master `478a20e857a1e7d006801ed93b5ee04c0d32d22e`, including matching SHA-256 hashes and pixels. [Comparison receipt](../docs/previews/staff1/off_comparison.json); baseline captures retained. Baseline helper backs up only the nine authorized script paths, restores intake bytes temporarily and restores local bytes in `finally`.
- Asset audit: four GLBs below 8 MB; all embedded textures below 2K; garment nodes bound to their skin. [Validation metadata](../docs/previews/staff1/validation.json).

## Resource safety and reproduction

Watchdog ran before UE, Blender, each test engine and each capture. RED prevented further launches; work resumed after waiting and a passing check. A late mutant launch was blocked at CPU 84% and then retried. One UE and one Godot of this task at a time. Rendering used `Tools/godot_hidden.ps1`; Blender ran hidden with two threads. The bridge's UAT build ignored its requested parallel-action cap, so it is not claimed to have used two compile workers.

The first UE attempt exposed source 4K garment compilation and was stopped. Subsequent launches apply a startup device-profile override and cap garment textures to 1024 before spawning. Creator's post-assembly receipt reports a maximum **32×32 garment runtime texture**, below 2K. Source/mask assets can still load at 4K; the claim concerns the measured assembled output and delivered GLB, not all source inputs.

Two broad Godot imports hit RED and were stopped. Reused 366 existing derived cache files only after checking exact source SHA-256 and `.import` text against the main checkout, rather than continuing the bulk import. No import metadata belongs in this commit. UE exports, temporary build products and intermediate texture sidecars remain local scratch; canonical delivery is the four embedded GLBs and receipts.

Automatic approval review rejected the proposed cleanup of 2,479 modified import files and 116 untracked metadata files because it could not establish their provenance sufficiently for deletion/restoration. No cleanup workaround was attempted. This metadata remains unstaged and excluded from the owned delivery.

Reproduce with `staff1_run.py <role>`, `staff1_finish.py <role>`, then `staff1_audit.py` (roles: coach/trainer/physio/desk). The generated bridge must already be installed in the pilot UE project; `staff1_bridge.py` records that build/install step. On already exported data, `staff1_finish.py <role> --final-only` rebuilds only the GLB. Parse first, then `staff1_gates.py on`, `staff1_gates.py off`, `staff1_gates.py mutant`; all use the guarded R75 runner. `staff1_render.py on` and `portrait` use the hidden wrapper. `baseline`, `off`, then `staff1_compare.py` reproduce the image comparison against the pinned intake commit.

Task precedence exceptions: explicit S154 source substitutions and MH3 loader hunk as authorized by the operator; STAFF1's narrow owned windows replace general HANDOFF/digest habits. `HANDOFF.md` was not edited. Default switch remains OFF for operator review.


## STAFF1b - relaxed hands and standing posture (S154, 2026-10-03)

The operator was right: the original portrait had turned-out thumbs, rigid fingers, arms held against the torso, elevated shoulders and a forward head. The earlier description of "generic bulky shoulders" failed to identify the hands. Opened the original portrait before changing code; retained it as [portrait_before.png](../docs/previews/staff1/portrait_before.png).

### Measured cause, before editing the pose

Measured all four bodies at calm-idle t=0.5 seconds, in world space with uniform scale removed. [pose_before.json](../docs/previews/staff1/pose_before.json) contains world quaternions, rest quaternions, positions and key presence. [pose_before_degrees.csv](../docs/previews/staff1/pose_before_degrees.csv) prints **every left/right UpperArm, LowerArm, Hand, thumb/index/middle root**, plus shoulders, ring/little roots and thighs, against both MH REST and the corresponding MPFB comparison pose. [pose_anatomical_errors.json](../docs/previews/staff1/pose_anatomical_errors.json) separates segment direction from axial palm-frame roll.

One premise needed correcting: `Godot/tools/c219_bake.gd` loads `f01_m_box_welter_rigged.glb` and bakes CMU `77_02.glb` into `calm_idle.res`. The checked-in resource was **not baked on MPFB**. Its archived CMU source GLB is absent. Accordingly, the MPFB comparison is the same checked-in f01 pose carried to `mpfb_male_pilot.glb` with the existing silhouette/rest correction, not a claim to have recovered the missing original capture. Copying its local rotations directly to MPFB gives a meaningless pose and was not used for the final comparison.

World rotation from MH REST, degrees (left/right):

| Body | Shoulder | UpperArm | LowerArm | Hand | Thumb root | Index root | Middle root |
|---|---:|---:|---:|---:|---:|---:|---:|
| Coach | 20.74/15.74 | 51.50/38.59 | 34.69/21.61 | 35.19/22.95 | 35.19/22.95 | 35.19/22.95 | 35.19/22.95 |
| Trainer | 20.65/15.64 | 51.68/38.70 | 34.78/21.56 | 35.29/22.84 | 35.29/22.84 | 35.29/22.84 | 35.29/22.84 |
| Physio | 20.65/15.65 | 51.57/38.63 | 34.72/21.59 | 35.23/22.91 | 35.23/22.91 | 35.23/22.91 | 35.23/22.91 |
| Desk | 20.61/15.59 | 51.92/38.83 | 34.90/21.50 | 35.43/22.71 | 35.43/22.71 | 35.43/22.71 | 35.43/22.71 |

Raw cross-rig basis differences in the CSV include incompatible bone-axis conventions; a 143-degree basis difference is **not** proof of a 143-degree anatomical wrist error. Anatomical comparison finds UpperArm direction differences of 15.85 degrees, LowerArm 15.73-15.84, and hand-forward 15.66-18.29. After shortest-arc alignment of the long axes, the forearm's palm-frame roll differs by -12.40 to -13.24 degrees on the left and +13.83 to +14.67 on the right. Hand-frame residual roll is -10.52 to -11.53 / +12.14 to +13.13 degrees. Thus the fault spans shoulder/arm posture and roll; it is not an isolated 180-degree wrist flip. The old MH hand-forward/forearm angle itself is only 2.3-3.6 degrees: much of the apparent wrist bend comes from the whole arm pointing forward and the inherited hand shape.

The old clip has **no finger tracks**. Its 22-joint retarget map carries arm/hand rotations but no fingers; every finger root retains its MH local rest and inherits the hand's global change, which explains the identical rest-delta columns above. The old standing hand-forward axis tilts roughly 38-42 degrees from down, versus roughly 22-26 on the MPFB comparison.

### Source fix and limits

Selected option (b): `MetaHumanRig.staff_room_idle` authors a four-second MH standing loop in anatomical frames. The upper arms stand nine degrees off the torso; elbows flex about eight degrees; palms face the thighs; finger joints get an open 8/12/6-degree curl. A 0.45-degree spinal breath and 0.35-degree arm sway close over the loop. Rest torso/neck/clavicle posture replaces the hunched standing capture. The seated body animation remains; its lower-arm roll and wrist curves are replaced together so hands follow the forearms with palms toward the lap. Old wrist keys are removed before resampling, not interleaved with corrected samples.

Only the existing `metahuman_staff` branch calls this helper. No fighter loader, shared retarget math, room script, switch default or OFF body path changed. Assets were not rebuilt. The physio's `Staff_Shirt` receives albedo `(0.30, 0.36, 0.36)`, roughness `1.0`, specular `0.15` inside that branch, reducing the white clipping under room lights.

[wardrobe_b_audit.json](../docs/previews/staff1/wardrobe_b_audit.json) records a fresh scan of installed Creator clothing and pilot-project content: only `WI_DefaultGarment`, **no shoe/boot/sneaker asset**. Desk and physio remain barefoot; no unavailable closed-toe shoe is claimed.

### Opened final images

Opened the corrected [portrait](../docs/previews/staff1/portrait.png), the [enlarged crop of all eight hands](../docs/previews/staff1/hands_crop.png), and **each of these eight final room PNGs with the file image tool**. No desktop viewer was launched.

Portrait and crop: all four heads are upright, shoulders lower, arms separated from the torso, wrists continuous with the forearms, and fingers softly curved rather than splayed/clawed. Coach hands are viewed nearly edge-on beside his broad hips; trainer's curl is the most visible. Physio and desk hands hang beside the shorts with inward palms. Shoulder/sleeve shapes are substantially calmer, although the transferred garment weighting still produces small irregularities; the desk sleeve has a tiny skin-coloured spot. The physio top is visibly muted rather than blown-out white.

| Final still | Hands, arms and shoulders observed |
|---|---|
| [Floor](../docs/previews/staff1/on_b/floor_b.png) | Coach beside the locker stands upright, near arm down beside the hip, shoulder lowered. Far hand is hidden by the body; this wide view cannot resolve individual fingers. |
| [Lobby](../docs/previews/staff1/on_b/lobby_b.png) | Desk woman has both arms down with clearance, shoulders level and hands alongside the thighs. The portrait crop supplies the finger detail absent at room scale. |
| [Office](../docs/previews/staff1/on_b/office_b.png) | Seated coach retains the seated shoulder/reach pose. Desk, laptop and markers obscure most of both hands; this still does not independently prove finger orientation. |
| [Locker](../docs/previews/staff1/on_b/locker_b.png) | Standing coach has lowered shoulders and hands beside the hips. Seated trainer keeps the forward reach, with the visible hand now palm-down instead of an upturned cup; far hand is obscured. |
| [Mat](../docs/previews/staff1/on_b/mat_b.png) | Rear coach stands upright with relaxed shoulders and arms down; hands lie along the shorts instead of sticking forward. Fingers are too small to resolve individually. |
| [Staff](../docs/previews/staff1/on_b/staff_b.png) | All three retain the seated reach. Trainer's wrists follow the forearms, with fingers curling down over the knees and palms toward the lap. Candidate and coach have the same downward hand attitude. Seated shoulders/sleeves remain less polished than the new standing pose; the generic reach is retained intentionally. |
| [Physio](../docs/previews/staff1/on_b/physio_b.png) | Near hand hangs beside the thigh, arm clears the torso and shoulder is lowered. Far hand is partly hidden by body/table. The shirt retains a muted green-grey tone under the bright medical-room lights. |
| [Film](../docs/previews/staff1/on_b/film_b.png) | Rear view clearly shows both hands beside the thighs, open curved fingers, separated arms and lowered shoulders. Existing floating pointer/cap attachment remains a separate pre-existing issue. |

### Regression gates

`staff_pose_test.gd` derives the anatomical hand-forward/thigh bound from the measured MPFB pose: left 24.814 degrees, right 29.792, plus five degrees for proportions = **34.792 degrees**. The same test exercises all four staff, both hands, six loop samples and seated wrist/palm orientation. Corrected standing maximum is **7.503 degrees**. When the switch is OFF, it exercises the MH pose contract directly rather than skipping; ON additionally exercises real room mounting.

- Final ON and OFF pose tests: **248 checks, 0 failures**, each `SUITE total=1 fails=0`.
- Old-pose mutation: remove only the new MH pose-author call; restore in `finally`. **248 checks, 163 failures**, `SUITE total=1 fails=1`, rc=1. Named failures include coach right hand/thigh **46.55 > 34.79**. [Full RED log](../docs/previews/staff1/old_pose_red.txt). The test is unchanged between RED and GREEN.
- Body scale: **107 checks, 0 failures**; original height/feet bands retained.
- `room_click_marks`, `office_room`, `staff_room`, `physio_room`, `locker_room`, `mat_room`, `film_room`: each **SUITE total=1 fails=0**, sequentially, using `run_tests.py --jobs 2` through the guarded adapter. No full suite was run.

Task precedence: explicit STAFF1b ownership replaced the broader old STAFF1 window and general HANDOFF rule. `HANDOFF.md` was not edited. Existing import metadata was preserved in a path-scoped stash during rebase and then reapplied; no imports belong in this delivery. Branch retained as `codex/staff1-metahuman-staff`.

OFF comparison: **8/8 PNGs byte-identical** to rebased master snapshot `402f25743aaaeb2e777b7b8854f57b731b50a830` (the baseline used at this task intake). [SHA-256 receipt](../docs/previews/staff1/off_b_comparison.json). Both baseline and candidate were freshly rendered at fixed 60 fps with the same seed. Only the two owned production files are temporarily restored for the baseline; they are restored to candidate bytes in `finally`.

Reproduce: `staff1_b_review.py old_pose` records RED and the before world-space measurements; `staff1_pose_report.py` prints the per-bone degree table and anatomical roll; `staff1_pose_probe.py` records the corrected world-space pose. Use `staff1_gates.py on staff_pose` and `off staff_pose`; `staff1_b_review.py on_b`, `baseline_b`, `off_b`, `compare`; `staff1_render.py portrait`, then `staff1_b_review.py crop`. All commands are under `Tools/metahuman/`. Guarded render/test adapters ran the watchdog before each heavy launch, and never ran two Godot jobs of this task together. No UE or Blender launch was needed.

Final parse: `CHECK total=5 fails=0 autoload_refs=0 autoload_warnings=0`; Python syntax: four changed/new tools passed. [Validation receipt](../docs/previews/staff1/validation_b.json).
