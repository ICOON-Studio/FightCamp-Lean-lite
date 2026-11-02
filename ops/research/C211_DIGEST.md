# C211 fourth run - STOP: fixed surface anchors conflict with retained skin

**C211 is NOT complete. No production collision refit or grip-anchor wiring was
installed.** Production `FighterCapsules.gd`, `FightPoseSolver.gd` and the witness
remain at intake `63046931`. Delivered evidence is
`Godot/tools/c211_collision_fit_probe.gd` and this updated digest.

## Exact STOP reason

The authorized collision-fit investigation was performed with the run-3 skin
rays frozen. Lowering the thorax dome to the shoulder-root/clavicle plane exposes
the sockets but loses covered upper-body skin and still fails f01's five-direction
neck floor and both rigs' chest .80 no-loss floor. A lateral capsule circumscribed
around the uncovered, protected skin samples restores their coverage but buries
all ten sockets. Neither candidate is acceptable.

A stronger necessary-condition check makes this more than a rejected band fit:
**f01 neck .50 has at most 3 of the required 5 approaches if the existing covered
skin outside the whole Neck-to-Head axial slab must remain covered.** This bound
already exempts the entire slab at unlimited lateral width, more than the narrow
neck strip used in the candidate coverage table. It does not assume a particular
replacement torso or clavicle capsule. With the narrower strip the bound is 0.

For each sampled direction, the hand centre is the unchanged surface socket plus
`direction * other_rig_hand_radius`. If the hand sphere contains a skin sample
which (a) was covered before, (b) is outside the exempt neck slab, and (c) is
outside the unchanged target neck capsule, preserving coverage requires that
sample to remain inside a non-target collision capsule. The hand sphere then
cannot clear that capsule by radius-sum clearance, by the triangle inequality.
Thus changing only torso/girdle capsules cannot make those directions usable.
For f01 .50, 125 directions have such witnesses; only indices **66, 74, 79**
survive this optimistic bound. The weakest of those 125 rejection witnesses is
**0.289802 mm** inside its hand sphere, exceeding the 0.01 mm numerical guard.
Other blockers can only reduce the remaining three.

This conclusion is specific to the supplied anchor rule, unchanged neck capsule,
128 directions, other-rig hand radius, and preservation outside that bone-defined
slab. It is not a proof against another anatomically justified anchor rule or
another definition of the allowed neck skin. No broader skin exemption, neck/head
refit, clearance change, or lower approach floor was silently substituted.
Installing these sockets in both consumers cannot meet the requested green gate,
so the rejected fit and lookup were not installed. No mid-run authorization
request was made.

## Reproducible fit and measurement rules

Both rigs use the same bones-plus-skin derivation, without rig-specific constants.
The probe inherits run 3's fully weighted posed triangles and exact nearest-point
triangle distance. Bone globals are composed parent-first from local poses.
Capsule grounding is applied to the skin and anchor coordinates alike.

- **Before:** intake production capsules and capsule-axis targets.
- **Lower:** preserve thorax p0 and radius, move p1 down its axis so its upper
  hemisphere ends at the plane through the mean of the two UpperArm roots. This
  is a bone-based clavicle-plane proxy, not a claimed certified sternal notch.
- **Banded:** add a lateral capsule containing every formerly covered sample
  which Lower leaves uncovered outside the narrow neck strip. Its lateral range
  and cross-section midpoint come from those samples' bounds; radius is their
  maximum distance to the segment. No anchor-clearance search selects this fit.
  This is a deliberately measured candidate, not an accepted anatomical band.
- Skin samples are unique posed triangle vertices plus triangle centroids.
  Regions are fixed by the nearest **original capsule surface** (absolute signed
  distance), with the neck-strip override. Coverage is by the **whole capsule
  union**, so a replacement band can preserve another region's coverage.
- The narrow strip is between Neck and Head planes perpendicular to their bone
  axis, within the original neck radius along the shoulder lateral axis. It is
  a reproducible geometric classification, not certified semantic segmentation.
- Coverage counts alone do not prove continuous triangle coverage. Actual lost
  samples suffice to reject Lower; zero sampled losses do not certify Banded.
  The necessary-condition bound only needs actual sampled counterexamples.
- All anchors keep their run-3 bone-axis origins and first anterior skin-ray
  intersections, independent of each refit. Other targets remain unchanged.
  Surface sockets use zero target radius; target exclusion, all 128 directions,
  subject-body blockers, and radius-sum clearance remain intact.

| Rig | Thorax p1 Y before -> Lower (m) | Clavicle plane point Y (m) | Recovery samples | Band radius (m) |
|---|---:|---:|---:|---:|
| f01 | 1.809316 -> 1.620252 | 1.760549 | 801 | 0.188088 |
| f02 | 1.909302 -> 1.690548 | 1.848935 | 785 | 0.217619 |

## Before / rejected after: every approach

Counts out of 128. These are experimental after values; production before and
after are identical. Lower and Banded are both rejected.

| Spot | f01 before | Lower | Banded | f02 before | Lower | Banded |
|---|---:|---:|---:|---:|---:|---:|
| neck 0.15 | 0 | 3 | 0 | 0 | 27 | 0 |
| neck 0.50 | 0 | 3 | 0 | 0 | 5 | 0 |
| head 0.50 | 96 | 109 | 72 | 91 | 109 | 69 |
| thorax 0.65 | 28 | 39 | 0 | 40 | 79 | 0 |
| thorax 0.70 | 31 | 35 | 0 | 39 | 70 | 0 |
| thorax 0.80 | 35 | 25 | 0 | 40 | 39 | 0 |
| pelvis 0.50 | 64 | 64 | 64 | 53 | 53 | 53 |
| pelvis 0.60 | 66 | 66 | 66 | 56 | 56 | 56 |
| femur_r 0.25 | 58 | 58 | 58 | 71 | 71 | 71 |
| femur_r 0.40 | 59 | 59 | 59 | 74 | 74 | 74 |

## Every surface-anchor distance

Millimetres. Negative margin means inside at least one collision capsule,
including the target capsule. All ten anchors are on skin to much better than
0.01 mm; all ten are exposed in Lower and buried by Banded. The probe prints XYZ.

| Rig | Spot | Exact skin distance | Lower capsule margin | Banded capsule margin |
|---|---|---:|---:|---:|
| f01 | neck 0.15 | 0.000011 | 32.410718 | -86.909294 |
| f01 | neck 0.50 | 0.000008 | 48.327066 | -83.228938 |
| f01 | thorax 0.65 | 0.000002 | 14.918663 | -23.277879 |
| f01 | thorax 0.70 | 0.000008 | 16.658805 | -39.016321 |
| f01 | thorax 0.80 | 0.000012 | 22.846617 | -72.872557 |
| f02 | neck 0.15 | 0.000009 | 30.331294 | -44.603392 |
| f02 | neck 0.50 | 0.000008 | 48.990575 | -91.513485 |
| f02 | thorax 0.65 | 0.000122 | 29.332321 | -33.316419 |
| f02 | thorax 0.70 | 0.000003 | 31.642552 | -48.035845 |
| f02 | thorax 0.80 | 0.000015 | 32.075907 | -88.958994 |

## Posed skin coverage before / after, every capsule region

Each cell is covered samples / total samples. Lower's lost sample counts are
listed individually; Banded loses **zero sampled points** in every region but
fails the anchor and approach guards. Neck-strip losses alone are exempt.

| Original region | f01 before / Lower / Banded | f01 Lower lost | f02 before / Lower / Banded | f02 Lower lost |
|---|---|---:|---|---:|
| pelvis | 2554/3488 / 2554/3488 / 2614/3488 | 0 | 2292/3774 / 2292/3774 / 2371/3774 | 0 |
| thorax | 1767/2445 / 1382/2445 / 2290/2445 | 385 | 1520/2361 / 1038/2361 / 2243/2361 | 482 |
| shoulder_span | 246/246 / 84/246 / 246/246 | 162 | 94/94 / 18/94 / 94/94 | 76 |
| neck | 208/208 / 17/208 / 208/208 | 191 | 100/100 / 5/100 / 100/100 | 95 |
| head | 1755/2036 / 1692/2036 / 1803/2036 | 63 | 1288/1607 / 1156/1607 / 1325/1607 | 132 |
| upper_arm_l | 751/1193 / 751/1193 / 1135/1193 | 0 | 882/1491 / 882/1491 / 1388/1491 | 0 |
| upper_arm_r | 694/1232 / 694/1232 / 1142/1232 | 0 | 885/1548 / 885/1548 / 1429/1548 | 0 |
| forearm_l | 1308/2966 / 1308/2966 / 1308/2966 | 0 | 1236/2528 / 1236/2528 / 1236/2528 | 0 |
| forearm_r | 1209/2589 / 1209/2589 / 1209/2589 | 0 | 1469/2886 / 1469/2886 / 1469/2886 | 0 |
| femur_l | 3000/3599 / 3000/3599 / 3000/3599 | 0 | 2667/3291 / 2667/3291 / 2667/3291 | 0 |
| femur_r | 2822/3428 / 2822/3428 / 2822/3428 | 0 | 2457/3149 / 2457/3149 / 2457/3149 | 0 |
| shin_l | 1573/1793 / 1573/1793 / 1573/1793 | 0 | 1422/1594 / 1422/1594 / 1422/1594 | 0 |
| shin_r | 1408/1747 / 1408/1747 / 1408/1747 | 0 | 1524/1840 / 1524/1840 / 1524/1840 | 0 |
| foot_l | 1081/1224 / 1081/1224 / 1081/1224 | 0 | 881/999 / 881/999 / 881/999 | 0 |
| foot_r | 932/1021 / 932/1021 / 932/1021 | 0 | 953/1084 / 953/1084 / 953/1084 | 0 |
| neck_strip | 266/266 / 29/266 / 266/266 | 237 | 265/316 / 20/316 / 316/316 | 245 |

## Necessary-condition bounds and mutants

These optimistic bounds are not proposed collision sets and are not passing
approach measurements. Removing all trunk/girdle blockers leaves many directions,
so head blockers alone do not explain the failure. Preserving actual covered skin
is the stronger constraint.

| Rig / neck blend | Bound preserving outside narrow strip | Bound preserving outside whole axial slab |
|---|---:|---:|
| f01 .15 | 2 | 10 |
| f01 .50 | 0 | **3** |
| f02 .15 | 66 | 117 |
| f02 .50 | 14 | 69 |

- Candidate run: **`checks=150 failures=34`**.
- **OLD_THORAX_CAP**, `--old-thorax-cap`: restores the full original blocker set
  while retaining the skin sockets. **`checks=150 failures=30`**; all four neck
  approaches are zero, and nine of ten sockets are buried (each repeated for
  the two candidate arms).
- **CAPSULE_CENTRE_ANCHOR**, `--centre-mutant`: replaces each socket with the
  literal candidate target capsule midpoint, without a target-radius fallback.
  **`checks=150 failures=70`**; all neck approaches are zero. Neck skin distances
  are 41.151151 mm (f01) and 46.131440 mm (f02).
- Both controls are red. Since the candidate is also red, this is **rejection
  evidence, not mutation validation of a green implementation**.

Reproduce using the installed Godot console executable with `--headless --path
Godot --script tools/c211_collision_fit_probe.gd`, optionally followed by `--
--old-thorax-cap` or `-- --centre-mutant`. Read the check/failure totals: inherited
SceneTree quit still exits zero after printed assertion failures. No parse or
GDScript runtime errors occurred in these three diagnostic runs.

## Gates and delivery

- Parse before execution: **`CHECK total=3 fails=0`**, covering the new collision
  probe, inherited anchor probe and unchanged reachability witness. Repeated
  after the final diagnostic edit.
- Required production witness: **`checks=24 failures=8`**; neck .15/.50 remain
  zero on both rigs. This required green gate was **not achieved**.
- Requested bounded gate, exactly
  `python Godot/tools/run_tests.py --only capsule,reach,fight_pose,fight_hold,fight_collision,grip,contact,separation --jobs 2`:
  **branch `SUITE total=25 fails=3`; pinned master `SUITE total=25 fails=3`**.
- Master snapshot: **`83a8ada18730e0eae9a1b9b4a790f16f06fc70fc`**. Origin/master
  advanced during the run; this is the exact revision exported and executed.
  Git archive supplied scripts/tests/tools/project, with 2,086 exported files
  byte-verified on write. Assets/scenes/shaders/import cache were shared with
  the working checkout; rig models, animation assets, scenes and shaders have
  no tracked branch/master differences. Portrait/manifest differences were not
  reconstructed. This is a bounded shared-asset runtime comparison, not an
  independently imported all-assets master certification.
- Identical failures and measurements in both runs:
  - `fight_contact_stop_test.gd`: landed low kick does not satisfy the occurrence
    and contact assertion; 141 checks, 1 failure. `contacts=5`,
    `overlap=[483, 90]`, `leg_frames=[298, 16]` on both.
  - `fight_separation_test.gd`: MMA below-floor run is 25 ticks versus the
    9-tick cap; 33 checks, 1 failure on both.
  - `fighter_reachability_contract_test.gd`: all four neck counts zero;
    24 checks, 8 failures on both.
- The other 22 selected tests passed on both, including fight_collision.
  No production behavior was changed. No full suite was run.
- Candidate/mutant direct runs emitted texture UID fallback warnings but no
  script parse/runtime errors; their assertion failures are intentional
  rejection evidence. Branch and master gate logs were compared separately.
- Deliverable: new collision-fit probe, this digest and one mailbox line to
  Claude, committed and pushed on `codex/c211-neck-reach`; **STOP, not complete**.

The explicit fourth-run branch/digest instructions superseded generic
rebase/brief/inbox intake. TASK_C211.md is still absent. No HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md was read or edited; no full suite was run.
Existing untracked work was preserved. No HANDOFF block is appropriate for this
stopped diagnostic-only delivery. The temporary master snapshot is untracked.

---

## Historical third-run record (collision-fit scope superseded above)

# C211 third run - STOP: surface-anchor candidate rejected

**C211 is NOT complete. No production GRIP-ANCHOR lookup was installed in
FightPoseSolver or the reachability witness.** The new evidence is
`Godot/tools/c211_grip_anchor_probe.gd`; production geometry, solver and witness
remain exactly as they were at intake `7cc929c5`. This is a stopped investigation,
not an accepted implementation or proof that every possible anchor rule fails.

## What was tried, and the exact scope boundary

One rule for both rigs: start at the existing bone-axis blend; derive lateral
from RightUpperArm minus LeftUpperArm; derive the anterior ray as the negative
cross product of lateral and the target bone segment; take its first intersection
with the fully weighted posed skin. No rig identifier, fitted distance, capsule
clearance search, or hand-tuned offset participates in selecting the anchor.
The imported initial pose is composed parent-first from local bone poses; all
skin weights and inverse binds deform the indexed triangles. Capsule grounding
is applied equally to skin and anchors. The same frozen anchors are used in the
optional inset control, independently of its changed collision endpoints.

For a surface socket the hand centre is `anchor + direction * hand_radius`.
The old `target_radius` belongs to an interior capsule-axis target; adding it
again after projection to the skin would introduce an air gap. Blocker checks
retain the corrected subject body, target-name exclusion, 128 directions,
other-rig hand radius and blocker-radius-plus-hand-radius clearance. Neck still
requires five approaches. The probe separately rejects any anchor inside ANY
capsule, including its own target capsule, and checks exact nearest-triangle
distance (interiors and edges, not nearest vertex) to 0.01 mm.

**STOP reason:** the derived neck surface anchors remain inside the thorax
collision capsule, so all four neck counts remain zero. If an anchor lies
strictly inside a blocker, moving a hand centre one hand radius from it cannot
clear that blocker by blocker radius plus hand radius (triangle inequality).
Wiring these rejected points into both consumers would therefore not make the
witness green. Chest .80 also loses approaches on both rigs. I did not ship a
lookup which violates the user's explicit surface/non-burial and no-loss guards.

For this candidate to work, the collision fit would have to change: thorax
must stop claiming the measured neck skin while retaining real upper-chest
coverage; the remaining hand-sphere blockers must then permit five directions.
That is an anatomy/collision-fit change beyond the separate-lookup change
performed in this run. Weakening blocker checks, keeping an extra target-radius
air gap, relocating a neck socket to arbitrary clear chest/shoulder skin, or
accepting the chest losses would violate the guardrails. The prior simple inset
is still insufficient (control below) and previously lost upper-chest coverage.
No request for further authorization was made mid-run.

Limit: this rejects this explicit bone-derived surface rule, not all conceivable
skin landmark rules. Its oblique ray can also land below the intended neck level;
triangle membership alone is not proof of anatomical neck placement. A new
anatomically certified landmark rule is another unresolved avenue, not a claimed
fix. No authored-pose/socket transport or shared solver integration is claimed.

## Before / candidate after: every spot, every rig

Counts out of 128. These are rejected candidate measurements, not shipped
behavior. Production before = production after everywhere.

| Spot | f01 before -> candidate | f02 before -> candidate |
|---|---:|---:|
| neck .15 | 0 -> 0 | 0 -> 0 |
| neck .50 | 0 -> 0 | 0 -> 0 |
| head .50 (unchanged) | 96 -> 96 | 91 -> 91 |
| thorax .65 | 28 -> 39 | 40 -> 79 |
| thorax .70 | 31 -> 35 | 39 -> 70 |
| thorax .80 | 35 -> 25 **LOSS** | 40 -> 39 **LOSS** |
| pelvis .50 (unchanged) | 64 -> 64 | 53 -> 53 |
| pelvis .60 (unchanged) | 66 -> 66 | 56 -> 56 |
| femur_r .25 (unchanged) | 58 -> 58 | 71 -> 71 |
| femur_r .40 (unchanged) | 59 -> 59 | 74 -> 74 |

## Every candidate anchor: exact skin distance and capsule margin

Millimetres. Negative capsule margin means inside; the deepest capsule in every
row is thorax. The probe prints each position as well. These are fresh Godot
measurements, not reused second-run JSON measurements.

| Rig | Spot | Nearest skin triangle (mm) | Capsule margin (mm) |
|---|---|---:|---:|
| f01 | neck .15 | 0.000011 | -43.442354 |
| f01 | neck .50 | 0.000008 | -37.240692 |
| f01 | thorax .65 | 0.000016 | -4.674800 |
| f01 | thorax .70 | 0.000008 | -12.961648 |
| f01 | thorax .80 | 0.000012 | -34.597620 |
| f02 | neck .15 | 0.000009 | -5.622838 |
| f02 | neck .50 | 0.000004 | -42.564024 |
| f02 | thorax .65 | 0.000122 | +1.524280 |
| f02 | thorax .70 | 0.000008 | -7.558380 |
| f02 | thorax .80 | 0.000015 | -41.005929 |

## Mutants and controls

- Candidate probe: `checks=40 failures=15`; ten intersections found, all ten
  on skin, nine capsule-burial failures, four neck floor failures, two chest
  no-loss failures.
- **CAPSULE_CENTRE_ANCHOR** (`--centre-mutant`): replaces each surface socket
  with `(p0+p1)/2`, with no fallback radius. **`checks=40 failures=30`**; all
  ten anchors are off skin, buried, and fail their approach floor. Neck centre
  skin distances are f01 41.151151 mm and f02 46.131440 mm; thorax centres
  117.501125 / 140.368298 mm. Both neck blends use the literal midpoint.
- **OLD_THORAX_CAP**: the existing adapter returning unchanged `CAPS.build`
  was rerun through the corrected witness's `--capsules=` hook.
  **`checks=24 failures=8`**, neck 0/0 on both rigs, still red.
- `--inset-control` retains the candidate skin anchors but insets thorax with
  the existing helper. **`checks=40 failures=11`**; neck f01 0/0, f02 4/0;
  chest counts are the same as the rejected candidate. It is not a fix.
- There is no green production anchor baseline, so these red runs are rejection
  evidence, **not mutation proof of a successful implementation**.

Reproduce with Godot headless, `--path Godot --script
tools/c211_grip_anchor_probe.gd`, optionally followed by `-- --centre-mutant`
or `-- --inset-control`. The probe deliberately prints assertion failures;
its inherited SceneTree quit returns zero, so read `checks/failures`, not rc.

## Gates and delivery

- Parse before execution: `CHECK total=2 fails=0`, covering the new probe and
  unchanged corrected witness. Repeated after the literal-midpoint mutant edit.
- Corrected production witness: `checks=24 failures=8`, both rigs red.
- Requested bounded gate including grip: **`SUITE total=18 fails=1`**;
  only `fighter_reachability_contract_test.gd` fails.
- Master comparison at `142f2ee6884b44e47d608213a04dd057845bef1a`:
  **`SUITE total=18 fails=1`**, only reachability fails. Scripts, tests, runner
  and project were exported to an isolated snapshot and byte-verified against
  that commit. Assets/scenes/shaders/import cache were shared with the working
  checkout; rig/model assets and scenes/shaders have no branch/master diff.
  Unrelated portrait/manifest assets do differ and were not independently
  reconstructed. This bounded runtime comparison is no worse; it is not an
  all-assets master certification.
- Direct probes emitted imported-texture UID fallback warnings, no script
  parse/runtime failures. Assertion failures above are intentional evidence.
- No full suite; no HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md read.
- `TASK_C211.md` is absent locally and on fetched master. User's explicit
  third-run authorization and this digest supplied the task. Explicit branch
  intake superseded generic rebase/brief/inbox; no HANDOFF block was written.
- Only the new diagnostic tool and this digest are owned deliverables. Existing
  untracked files were left alone. The master comparison snapshot is untracked.

---

## Historical second-run record (scope authorization superseded above)

# C211 second run - witness corrected; geometry acceptance NOT met

The authorized witness correction is committed as `ac2cc50b` on
`codex/c211-neck-reach`. `hand_radius` still comes from the opposite rig;
blocker iteration and lookup now use the subject's capsule map. The reason
is recorded at the top of the test. Target exclusion, 128 directions,
radius-sum clearance and the five-direction floor are unchanged.

**C211 is NOT complete. No production anatomy change is shipped.** The
corrected witness remains red on both neck spots on both rigs. None of the
explored geometry arms met both anatomical coverage and the no-loss requirement.
This is a failed geometry investigation, not a claim that no possible fix exists.

## Delivered files and exceptions

Owned delivered paths: `Godot/tests/fighter_reachability_contract_test.gd` and
this digest. The second-run user authorization overrides the task's exclusion
of the test, only for the specified body-selection correction. The explicit
branch/task intake overrides generic rebase/mailbox intake. No HANDOFF,
CURRENT_STATUS, HANDOFF_ARCHIVE, full GameState, or full suite was read/run.

## Before / after on the corrected subject-body comparison

All counts are usable directions out of 128. The shipped geometry is unchanged.

| Rig | Neck .15/.50 before -> after | Head .50 | Chest .65/.70/.80 | Pelvis .50/.60 | Femur .25/.40 |
|---|---|---:|---|---|---|
| f01 | 0/0 -> 0/0 | 96 -> 96 | 28/31/35 -> 28/31/35 | 64/66 -> 64/66 | 58/59 -> 58/59 |
| f02 | 0/0 -> 0/0 | 91 -> 91 | 40/39/40 -> 40/39/40 | 53/56 -> 53/56 | 71/74 -> 71/74 |

The original cross-rig baseline is retained in the first-run section below;
it is not the correct no-loss comparator for production geometry.

## Positive control and named burial mutant

The exact corrected witness was launched with its existing `--capsules=` hook.
A temporary adapter returned
`FighterCapsules.inset_endpoints(FighterCapsules.build(skel, scale), ["thorax"])`
and delegated `ground` unchanged. This is **INSET_CONTROL**, not a proposed fix:

| Rig | Neck .15/.50 | Chest .65/.70/.80 |
|---|---|---|
| f01 | 7 / 7 | 16 / 19 / 19 (regresses from 28 / 31 / 35) |
| f02 | 11 / 10 | 28 / 31 / 31 (regresses from 40 / 39 / 40) |

INSET_CONTROL reports `checks=24 failures=0`, demonstrating that a green witness
alone does not enforce the task's additional chest no-loss requirement.

**OLD_THORAX_CAP** is the named mutant. It restores the original joint-to-joint
thorax by returning `FighterCapsules.build(skel, scale)` without the inset.
Against the same corrected witness it restores neck `0/0` on both rigs and
reports **`checks=24 failures=8`**. Thus the corrected witness still detects
neck burial. This is a control/mutant comparison, not mutation proof of an
accepted production fix (there is no accepted fix).

Reproduction adapter (use the existing witness's `--capsules=res://...` hook):

```gdscript
extends RefCounted
const CAPS = preload("res://scripts/FighterCapsules.gd")
static func build(skel: Skeleton3D, scale: float) -> Array:
    return CAPS.inset_endpoints(CAPS.build(skel, scale), ["thorax"])
static func ground(caps: Array) -> Array:
    return CAPS.ground(caps)
```

For OLD_THORAX_CAP replace only the build return with `CAPS.build(skel, scale)`.

## Posed-skin coverage rejects the simple inset too

Weighted initial-pose vertices were reconstructed with every skin weight and
inverse bind, as in the first run, then given the same grounding translation as
the capsules. Coverage here means a vertex is inside the union of body capsules
(point-to-segment distance <= radius); it is not a triangle-area measurement.

| Rig | UpperChest-dominant vertices covered, baseline -> inset | Head-dominant vertices covered, baseline -> inset |
|---|---|---|
| f01 | 449 -> 135 of 897 (314 newly uncovered) | 708 -> 672 of 834 |
| f02 | 462 -> 105 of 986 (357 newly uncovered) | 592 -> 580 of 723 |

Hips, Spine and Chest-dominant coverage is unchanged by the thorax-only inset.
Neck has no dominant vertices on either rig. Therefore neither preserving the
neck capsule length nor keeping its centre inside skin proves that an inset has
preserved adjacent anatomy. A torso relocation/shortening arm was not accepted
merely because its counts improved. A pelvis-sphere exploratory arm also lost
real skin coverage and was rejected; pelvis was not changed in production.

An additional initial-pose surface diagnostic checks each sampled hand sphere
against all indexed, weighted skin triangles. It computes closest distance to
triangle interiors/edges and rejects centres inside the mesh by odd/even ray
crossing (deduplicated intersections along normalized (.913,.173,.369)). At the
unchanged neck spots and radii, the available sampled directions are:

| Rig | neck .15 | neck .50 |
|---|---|---|
| f01 | 1: [32] | 3: [32,40,53] |
| f02 | 3: [19,32,40] | 3: [32,40,53] |

This is a diagnostic on the imported initial pose, not a certified watertight
mesh collision system or an authored-hold result. It reinforces the need to
calibrate actual grip anchors and retain shoulder/upper-chest coverage rather
than accept capsule-only clearance. The before/after neck spot coordinates and
skin distances remain exactly those in the first-run table below.

## Current scope question / proposed next change

Shortening `thorax.p1` also changes the chest grip location, because both the
witness and `FightPoseSolver.grip_gap` interpolate the collision endpoints.
A reviewable next design is optional `grip_p0` / `grip_p1` anchors, transported by
`ground` and `posed`, with a shared grip-spot lookup and fallback to p0/p1.
This would preserve existing anatomical chest target positions when collision
geometry is refitted. It must be accompanied by a skin-supported upper-chest
fit; anchor separation alone does not repair the coverage loss above.

The user has been asked whether to authorize the additional witness target
lookup, since the second-run authorization says **exactly** the body-selection
correction. No extra witness edit or solver/production change has been made
while that answer is pending. Approval is not inferred from elapsed time.

## Gates

- Parse: `CHECK total=1 fails=0` for the changed witness. The temporary
  control/mutant adapters also parsed: `CHECK total=3 fails=0` including witness.
- Corrected production witness: `checks=24 failures=8`; all four neck cases 0.
- Requested bounded gate:
  `python Godot/tools/run_tests.py --only capsule,reach,fight_pose,fight_hold,fight_collision --jobs 2`
  returned **`SUITE total=18 fails=1`**. Only reachability failed.
- Fetch succeeded after the filesystem permission escalation. Remote master was
  `db4c725a3c4a688594186f4946ffe00744087ca1`. FighterCapsules is identical there;
  master itself was not independently rerun. The earlier first-run bounded
  baseline was `SUITE total=17 fails=1` without fight_collision.
- Direct diagnostic launches emitted local log/certificate warnings; their
  printed checks/counts are diagnostic evidence, not clean suite verdicts.
- No full suite. The required all-green neck acceptance has **not** been met.

---

## First-run record (historical; authorization status superseded above)

# C211 — posed neck diagnosis; acceptance remains blocked

Status: **NOT FIXED**. Branch `codex/c211-neck-reach`, baseline `021eb16d`.
No production proxy, rig, target, test, or clearance was changed. The only
owned deliverable is this digest. Do not mark C211 complete from its existence.

## Two defects must not be conflated

The thorax hemisphere buries the neck even when measuring the subject's own
body. However, C158's acceptance witness uses `other_capsules` for both the
attacker's hand radius **and the blocking body**, while the spot and target
radius come from `subject_data[1]`. Both bodies are independently grounded at
the same origin. It therefore asks whether f01's neck clears f02's torso (and
vice versa), not whether the gripping hand clears the neck owner's anatomy.
There is no attacker placement or pose in this comparison.

Concrete proposed witness correction, requiring authorization because the task
excludes the test: keep `hand_radius` from the other rig; iterate blockers from
`subject_data[1]` and resolve `other` from that same map. Retain the target-name
exclusion, all 128 directions, radius-sum clearance, and the five-direction
floor. This correction alone remains red; it is not presented as the fix.

## Posed mesh, not the rest box

Measured the imported initial pose using every vertex's skin weights:
`sum(weight * bone_global_pose * inverse_bind * vertex) * height_scale`.
Indexed surface triangles use these deformed vertices. Coordinates below are
in scaled skeleton space before the capsule grounding translation. No animation
was applied; these measurements do not establish clearance in an authored hold.

| Rig / blend | Target xyz (m), before = after | Nearest skin vertex (mm) | Posterior -Z triangle intersection (mm) | Anterior +Z intersection (mm) |
|---|---|---:|---:|---:|
| f01 / .15 | (.004731, .704685, -.065384) | 41.560 | 45.645 | 111.051 |
| f01 / .50 | (.004644, .727443, -.056851) | 41.903 | 43.380 | 119.140 |
| f02 / .15 | (.003693, .748982, -.066872) | 43.107 | 48.206 | 127.667 |
| f02 / .50 | (.003833, .776147, -.051781) | 48.211 | 47.756 | 122.443 |

Each target has one distinct outward triangle intersection along normalized
(.913, .173, .369), consistent with being inside the skin. Nearest-vertex
distance is not an exact nearest-surface distance. The separate axial values
above are actual ray/triangle intersections, not AABB measurements.

These targets are on the posterior neck/shoulder-root axis. In particular,
**inside the mesh does not mean inside an isolated neck cylinder**: at blend
.15, horizontal +X exits are 308.045 mm (f01) and 322.481 mm (f02), through the
shoulder mass. The .50 lateral exits are 92.306/96.675 mm on f01 and
123.002/136.330 mm on f02 (+X/-X). Moving a point until the witness is green
would not resolve this anatomy question.

Skin landmark selection: chin = lowest Head-dominant posed vertex within
20 mm of the neck's X midline, anterior to `neck.p1.z + neck.r`, above neck.p0;
shoulder top = highest posed vertex within a 20 mm XZ neighbourhood of either
upper-arm root. f01 chin/shoulder Y = .725790/.723365 m, gap **2.425 mm**;
f02 = .767700/.761930 m, gap **5.771 mm**. These are reproducible vertical
landmark differences, not shortest gaps or proof that a hand fits there.

## Proxy measurements and every rejected f01 lower-neck direction

| Rig | Neck radius | Head radius | Thorax radius | Shoulder radius | Forearm radius used by opposite rig |
|---|---:|---:|---:|---:|---:|
| f01 | .055000 | .149612 | .143900 | .050000 | .067143 |
| f02 | .055000 | .148949 | .162614 | .050000 | .079851 |

All values are metres. f01's grounded neck .15 target is approximately
(.004731, 1.819069, -.065384). The f02 thorax blocking it is the segment
(.004192, 1.564347, -.012975) -> (.003633, 1.909302, -.073340), radius .162614.
The neck target is about 90 mm below the other rig's thorax endpoint.

The diagnostic printed all 128 rejected directions individually, with both
the witness's first blocker and the deepest penetration. Lossless index groups:

- First blocker `thorax`: indices 0–61, 63, 64, 66, 68, 69, 71, 74, 77, 79
  (71 directions).
- First blocker `pelvis`: every remaining index through 127 (57 directions).
- Deepest blocker `shoulder_span`: 51 and 55. Its endpoints are
  (.262338, 1.848935, -.075735) -> (-.255071, 1.848935, -.070944), radius .05.
- Deepest blocker `thorax`: all other indices (126 directions). The thorax
  also intersects the two shoulder-dominated directions. First-blocker labels
  depend on capsule iteration order and are not a deepest-overlap census.

## Directional controls; rejected changes

Existing diagnostic arms were applied only in memory, never shipped. Counts
are usable directions out of 128; pairs list neck .15 / .50.

| Arm | f01, unchanged C158 comparison | f02, unchanged C158 comparison | Why rejected |
|---|---|---|---|
| Baseline | 0 / 0 | 0 / 0 | Original failure |
| Thorax endpoint inset only | 0 / 0 | 15 / 4 | Neck still fails; chest loses approaches |
| split_skin | 0 / 0 | 0 / 0 | Neck still fails; chest loses approaches |
| split_inlet | 0 / 0 | 15 / 3 | Neck still fails; chest loses approaches |

With subject-body blockers and the same other-rig hand radii, baseline neck
counts are still 0/0 on both rigs. Thorax-only inset gives f01 7/7 and f02
11/10, but this is NOT an acceptance result. Even that comparison loses
thorax .65/.70/.80 approaches: f01 28/31/35 -> 16/19/19 and f02 40/39/40 ->
28/31/31. The inset also changes the thorax's grip interpolation, so a neck
pass would conceal another target moving. D11's cleared-versus-erased warning
applies; this arm is not a safe production fix.

Unchanged official baseline counts for all other spots:

| Rig | head .50 | thorax .65/.70/.80 | pelvis .50/.60 | femur_r .25/.40 |
|---|---:|---|---|---|
| f01 | 71 | 22 / 23 / 25 | 41 / 45 | 61 / 58 |
| f02 | 110 | 42 / 47 / 53 | 76 / 80 | 67 / 74 |

## Validation and reproduction

- Parse ran before the focused witness. The existing diagnostic
  `Godot/tools/c211_neck_probe.gd` was already untracked at intake; it was read
  and executed without editing or staging it. It supports `--inset`,
  `--split_skin`, `--split_inlet`, and `--same-body`.
- `python Godot/tools/run_tests.py --only fighter_reachability_contract --jobs 2`:
  `SUITE total=1 fails=1`, eight assertion errors; all four neck cases remain
  zero. The witness itself reports `checks=24 failures=8`.
- `python Godot/tools/run_tests.py --only capsule,reach,fight_pose,fight_hold --jobs 2`:
  **`SUITE total=17 fails=1`**, only fighter_reachability_contract failed.
- A temporary copy of the diagnostic added six cardinal ray/triangle
  intersections per neck target; parse `CHECK total=1 fails=0`. That copy is
  not a production change. Direct diagnostic launches printed local Godot
  log/certificate warnings; the test-runner results above are the gates.
- No full suite, render, HANDOFF, CURRENT_STATUS, HANDOFF_ARCHIVE, or
  GameState read. Explicit task intake superseded generic mailbox/rebase intake.

Research read: C158_DIGEST.md first; C153_CAPSULE_SET.md;
D11_HEAD_CAP_ANSWER.md; FighterCapsules' existing S48/S53/S55 derivations.

Next decision: authorize the body-selection correction, then calibrate the
proxy and anatomical grip anchors together against posed skin. A passing
number obtained by moving the neck into air, shrinking away anatomy, or
accepting lost chest approaches is not a C211 delivery. No claim is made that
all possible legitimate proxy fixes have been exhausted.
