# S40 — the +367% was three faults, and bone proportions was the smallest of them

**The stage was "diagnose the +367.3%, do not tune the anchor's clamp". The
diagnosis is not proportions. It is that every bone arrives at a FIXED angle
from where the capture has it — the difference between the two rest poses,
carried into all 832 frames unchanged — and that the probe was measuring a code
path the game does not run.**

On 22/23_17, at p0, like-for-like:

| what is measured | p0 | p50 |
|---|---|---|
| S39 published | +367.3% | +268.5% |
| the same two points on both sides | **+56.9%** | +59.7% |
| …with the corrections the GAME builds | **+23.7%** | +25.6% |
| …plus the two segments those miss | **−10.7%** | −3.0% |

The RETARGET column never moved: `min=0.461 p10=0.494 p50=0.559 p90=0.667`,
byte-identical to S39's. Only what it is compared against, and what builds the
correction, changed.

---

## 1. The two columns were measuring different points, again

S39 fixed the SOURCE column by shifting both ends one node distal so it would
land on Q122's contact figure. Q122's figure is a fact about the CAPTURE. The
retarget column can only measure joints **the map gives it**, and `CMU_TO_OURS`
sends `lwrist → LeftHand` and `lradius → LeftLowerArm`. glb `lhand` is not a
key at all: no bone of our rig is driven by it and no rig joint stands where it
stands.

So the probe compared our wrist against a capture point 0.099 m further out
than anything on the rig follows, and our **elbow** against glb `lwrist` —
0.198 m down the capture's forearm. Both ends one node out, both the same way.

The correspondence is not asserted here. `Tools/s40_proportions.py --verify`
re-derives `glb[J] == asf[parent J]` by matching every measured glTF segment
length against the ASF file's own declared bone lengths: **HOLDS over 32 nodes**
on both subjects, so the segment ending at glb `rwrist` is the ASF bone
`rradius` and nothing else.

**The old gate could not have caught this, because it was written in the
vocabulary of the bug.** `_check_joint_convention` asserted "two parents above
the elbow node is the humerus" — a statement about NODE NAMES, and the names are
the thing that is one off, since glb `lhumerus` sits at the SHOULDER. It passed
for the pair that was one node distal and would have FAILED the pair the rig can
represent. It did not merely miss the defect; it required it.

`_check_measurable()` replaces it and derives the requirement from the map the
retarget actually uses: every source name must be a key of `CMU_TO_OURS` whose
image is the rig joint it is measured against. Shifting either constant one node
fails it by naming the bone that has no image.

The capture's own closest contact is still printed, as `contact A_wrist->B_arm`,
still 0.099 m, and labelled `CAPTURE ONLY - not representable on the rig`.

## 2. The mechanism: a constant per-bone angle, and it is the rest-pose gap

`probe_cmu_grip.gd -- dirs=1` prints, per bone, the angle between our retargeted
segment and the capture segment that drives it. Over 832 frames of a live
grapple, plain corrections:

```
our bone       from node    p50 deg  p90 deg  max deg
RightUpperArm  rhumerus       39.65    39.69    39.94
LeftUpperArm   lhumerus       34.39    34.42    34.71
RightShoulder  rclavicle      31.26    31.32    31.82
LeftHand       lwrist         16.81    16.84    17.13
LeftLowerArm   lradius         3.88     3.91     4.33
Spine          lowerback          -        -        -   undetermined on 832/832
```

**0.3 degrees of spread over a whole clip is not a pose error. It is a
constant**, and the only fixed thing in a rotation retarget is the correction
built from the two rest poses.

`Tools/s40_rest_gap.py` computes the rest gap directly — our rig's rest segment
against the capture rest's segment, in pure Python, no engine, no animation — and
reproduces Godot's live table **bone for bone to 0.01 degrees**: Chest 10.79,
LeftShoulder 28.91, LeftUpperArm 34.39, RightUpperArm 39.65, LeftLowerArm 3.88.

So the retarget is a faithful REST-RELATIVE rotation transfer: source-rest maps
to target-rest and motion is carried relative to each. The world direction of
every bone is therefore off by its rest gap, on every frame, and **a
rest-relative rotation retarget provably cannot hold a world-space contact when
the rest poses differ.** Only `Head` varies (p50 20.88, max 31.17); every other
bone is pinned to its rest gap.

## 3. The probe was measuring a code path the game does not run

This probe has always called `FightClipRetarget.build_corrections`. Every
shipped caller — `FightStagePlayer:631`, `PairedStagePlayer:147` and `:169` —
has called `build_silhouette_corrections` since S4a (a).

That is C100–C103's finding, arrived at again from the other end: C101 measured
the leftover as "a CONSTANT offset, not motion (elbows 89% constant), predicted
by each body's rest angle (r = 0.93–0.99)"; here it is 100% constant and
predicted by the rest angle exactly. C102's remedy — aim each segment of our
rest along the source's segment, parent before child — took the pooled bend
error 8.32 → 0.46 deg over 336 rows with 0 rows worse.

Switching the probe to the game's own corrections (`silhouette=1`) takes the
drift **+56.9% → +23.7%** and every bone whose segment is in
`SILHOUETTE_SEGMENTS` to 0.02 deg. Every bone whose segment is NOT in it keeps
its full rest gap, to the decimal. There is no unexplained residue.

## 4. What `SILHOUETTE_SEGMENTS` misses, and the one it cannot reach

Missing from the arm path: `Spine→Chest`, `UpperChest→Shoulder`,
`Shoulder→UpperArm`. Adding the two safe ones (`girdle=1`, passed as the
function's own `segments` ARGUMENT so no shipped constant moves) takes every arm
bone to 0.02–0.03 deg and the drift to **−10.7% at p0, −3.0% at p50**.

`UpperChest→Shoulder` **cannot be fixed this way and that is a finding.**
`silhouette_rest` aims the START bone of a pair, so aiming `UpperChest →
LeftShoulder` rotates `UpperChest`, which carries the right shoulder and the
neck with it. Listing both shoulders makes the two pairs fight over one bone and
the last one wins: measured, the right arm went to 0.03 deg and the **left went
to 51.43**, worse than the 34.66 it started at. A bone with three children
cannot be aimed at one of them. The clavicle keeps ~26 deg.

`Hips→Spine` is in the list and still reads `undetermined` on every frame:
the capture's `lowerback` segment has **length zero** — the node sits on the
root — so there is no direction to aim at. Nothing in the capture says where our
0.10 m Spine bone should point.

## 5. THE CONTROL ARM SAYS THE EXTRA SEGMENTS ARE NOT A FREE WIN

| fixture | plain | silhouette | girdle |
|---|---|---|---|
| 22/23_17 p0 | +56.9% (+0.167 m) | +23.7% (+0.070 m) | **−10.7% (−0.032 m)** |
| 22/23_17 p50 | +59.7% (+0.209 m) | +25.6% (+0.089 m) | **−3.0% (−0.011 m)** |
| 18/19_05 p0 | +9.5% (+0.013 m) | −2.3% (−0.003 m) | +18.9% (+0.026 m) |
| 18/19_05 p50 | +6.6% (+0.016 m) | −12.7% (−0.031 m) | +11.0% (+0.027 m) |

**Silhouette beats plain on both fixtures. Girdle beats silhouette on 22/23_17
and loses to it on 18/19_05.** Every 18/19_05 arm sits within 0.031 m of the
capture, so that fixture cannot separate them — which is S39's own warning
("use 18/19_05 to check reproducibility, never to validate a mechanism") coming
true a second time. Do not read the girdle row as a fix; read it as the size of
the prize, measured before anyone pays for it.

## 6. Proportions ARE non-uniform — and they are the residue, not the cause

`Tools/s40_proportions.py` measures every mapped segment against the bone it
drives, with `mount_scale` derived from the mesh's own POSITION accessors: it
reproduces the probe's 0.9633 and 1.8900 independently.

```
cmu node    segment is  our bone        capture    rig*s   ratio    err m
lowerback   root        Spine            0.0000   0.0997    inf   +0.0997
lhumerus    lclavicle   LeftUpperArm     0.1905   0.1301   0.683  -0.0605
lradius     lhumerus    LeftLowerArm     0.2965   0.2303   0.777  -0.0662
lwrist      lradius     LeftHand         0.1981   0.2691   1.358  +0.0709
```

Ratio spread **0.683 .. 1.360** on f05 and **0.759 .. 1.419** on f06, where a
uniform scaling would be one value. Root→hand worst case 0.34 m, net +0.07 m.
Two structural causes, both correspondence rather than size:

* **`lowerback → Spine` is a zero-length source segment on a real rig bone.** An
  infinite ratio, 0.10 m of our hand's position set by nothing in the capture.
* **CMU splits the forearm** into `radius` (0.198) + `wrist` (0.099); our rig has
  one forearm bone (0.269 scaled). The map pairs our whole forearm with the
  capture's proximal two thirds.

But `Tools/s40_predict.py` substitutes our lengths into the capture's own
directions — a model with no free parameter — and **fails on both fixtures in
opposite directions**: it under-predicts 22/23_17 by 0.14 m and over-predicts
18/19_05 by 0.10 m. Lengths alone are not the mechanism. They are what is left
once the directions are right, and once they are, the residue is ±0.03 m of
either sign.

## 7. What is not true any more

* **"the plain retarget is +367.3% at p0"** — it is +56.9% measured like-for-like
  and +23.7% through the corrections the game actually builds.
* **"the retarget is nearly four times out, so the anchor is a correction on top
  of a broken retarget"** — it is 0.07 m out on the shipped path, 0.03 m with the
  girdle segments.
* **"the joint naming is fixed, do not redo it"** — the SOURCE column's internal
  naming was fixed; its correspondence with the RETARGET column was not, and that
  is where three quarters of the headline lived.
* **"the rig's arm length being too short to reach"** — still ruled out (S39), and
  now for a second reason: with directions faithful, `reached` is not the binding
  constraint.

## 8. Corroboration from outside (Q125, delivered this session)

Unreal 5.8's IK Retargeter ships `EFKChainTranslationMode::None` as its **default
(`FKChainsOp.h:219`)** — it does not copy translation; the target keeps its own
bone lengths. Its scale option, when used, is a single whole-body scalar from the
pelvis-height ratio (`PelvisMotionOp.cpp:223-224`), exactly the shape of our
`mount_scale`. Contact is not a job for the rotation transfer there either: it is
`StretchChainOp` / IK goals on top. Our architecture is the industry default; the
defect was the correction, not the design.

## 9. Population

CMU subjects 22 vs 23 and 18 vs 19 — four different bodies, bone lengths
differing within each pair — onto f05 (MMA lightweight, 70.3 kg limit,
`mount_scale` 0.9633) and f06 (light-heavyweight, 93.0 kg, 1.8900). Two
different captures on two different meshes; no identical fighters anywhere in
this stage. The fixture's catalogue is `Godot/assets/anim/audition/cmu_paired/`,
converted by `Tools/cmu_bvh_to_glb.py`, which S39 proved exact to 2 µm.

## 10. Gate

```bash
python Godot/tools/check_scripts.py Godot/tools/probe_cmu_grip.gd
python Tools/s40_proportions.py --verify
python Tools/s40_rest_gap.py
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_cmu_grip.gd -- fps=120 fixture=22/23_17
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_paired_anchor_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_anchor_ik_test.gd
python Godot/tools/run_tests.py --only retarget
python Godot/tools/run_tests.py --only clip
```

Results: parse `total=1 fails=0`; `VERIFY ... HOLDS over 32 nodes` on all four
subjects; the rest table matching `dirs=1` to 0.01 deg; probe
`SOURCE min=0.294 / RETARGET min=0.461 / contact min=0.099`, `DRIFT p0 +56.9%`;
`checks_failed=0`; `FIGHT_ANCHOR_IK_TEST PASS`; `SUITE total=2 fails=0`;
`SUITE total=10 fails=0`.

**The probe's DEFAULT is unchanged — plain corrections — on purpose**, so S39's
published figures stay reproducible from this file and the three arms can be run
back to back as a control. `silhouette=1`, `girdle=1` and `dirs=1` are opt-in.
