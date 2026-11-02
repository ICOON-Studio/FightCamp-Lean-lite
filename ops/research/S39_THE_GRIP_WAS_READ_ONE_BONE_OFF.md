# S39 — 22/23_17 reads 0.099, and the conversion was never the fault

**The stage was "make 22/23_17 read 0.099 by fixing `Tools/cmu_bvh_to_glb.py`".
The conversion is exact to 2 micrometres and always was. The probe was reading
the wrong two joints, and then reading them at a quarter of the capture's rate.**

Both gates pass:

```
fixture=22/23_17   SOURCE A_hand->B_elbow min=0.099   (Q122's figure)
fixture=18/19_05   SOURCE A_hand->B_elbow min=0.141   DRIFT p0 +8.8%   (the control, both halves)
```

---

## How it was split, and why it cost no Blender and no Godot boot

`now` proposed a control arm: re-convert 18/19_05 through the new tool and see
whether it also reads wrong. That is a good split and it needs a Blender run
plus a Godot run. A cheaper one answers more.

The pipeline is ASF/AMC -> BVH -> GLB -> Godot. Two of those stages can be read
in pure Python: `Tools/cmu_asf_amc.py` already does the forward kinematics, and
a GLB's animation samplers can be composed directly. Measuring **the same
quantity at both ends, on both fixtures**, took one script and no engine:

| fixture | ASF/AMC | GLB | root -> root |
|---|---|---|---|
| 18/19_05 (control) | 0.1407 | 0.1399 | identical, 0.7654 |
| 22/23_17 | **0.0987** | **0.2938** | identical, 1.2860 |

Both ends reproduced the two figures in dispute exactly. And the **root
separation was byte-identical at both stages on both fixtures** — which rules
out axes and scale in one line, because either would have moved the roots too.
Whatever was wrong was in the joints, not in the transform.

## The fault: two conventions, opposite ends of the same bone

Per-joint, root-relative, the GLB's `ltibia` sat exactly where the ASF's
`lfemur` was. Tested against the ASF hierarchy itself, over every joint and
three frames of both fixtures:

```
max |glb[J] - asf[J]|         = 0.429005 m
max |glb[J] - asf[parent J]|  = 0.000002 m
```

**`glb[J] == asf[parent(J)]`, to 2 micrometres.** CMU's ASF names a *bone* and
`joint_world_positions` returns that bone's **distal** end under its name, so
ASF `lwrist` is the wrist. A glTF/BVH node sits at its bone's **proximal** end,
so glTF `lwrist` is the **elbow** and the wrist is one node further out, at
`lhand`.

So `SOURCE_HANDS = ["lwrist","rwrist"]`, `SOURCE_ELBOWS = ["lradius","rradius"]`
was measuring **elbow to shoulder**. Meanwhile `OUR_HANDS`/`OUR_ELBOWS` were
right, because our rig already uses the glTF convention. **The two columns of
this probe were different quantities, and every drift percentage between them
was uninterpretable.**

In ASF terms, confirmed on both fixtures:

| | 18/19_05 | 22/23_17 |
|---|---|---|
| true hand -> elbow | 0.1407 | 0.0987 |
| what the probe read (elbow -> shoulder) | **0.1399** | **0.2938** |

**On 18/19_05 the wrong quantity lands 0.8 mm from the right one.** That is the
whole reason it survived: the one number that was ever checked agreed by
coincidence. The distribution never did — p10 0.1745 against 0.1564, p50 0.2437
against 0.1960 — and nobody looked, because the gate compared a single extremum
against a remembered figure.

`CMU_TO_OURS` is unaffected and correct: a retarget map drives rotations, and
glTF node `lradius` really is our `LeftLowerArm`'s origin.

## The second fault: every clip is baked at 30 Hz

With the joints fixed, 22/23_17 landed on 0.099 exactly but the control read
**0.146** where both Python readers said 0.141.

`GLTFDocument.generate_scene()` resamples onto a `bake_fps` grid and **the
engine default is 30**. A 120 Hz capture arrives with three frames in four
interpolated back in. Resampling my Python series to 30 Hz reproduced the
probe's output on all five percentiles of both fixtures:

| | 120 Hz | via 30 Hz | probe printed |
|---|---|---|---|
| 18/19_05 min | 0.1407 | **0.1455** | 0.146 |
| 18/19_05 p90 | 1.0212 | **1.0336** | 1.034 |
| 22/23_17 min | 0.0987 | **0.0987** | 0.099 |
| 22/23_17 p50 | 0.1516 | **0.1521** | 0.152 |

**A resample destroys single-frame extrema and leaves distributions alone.**
18/19_05's closest approach is a one-frame dip, so it lost 4.8 mm; 22/23_17's
grip is sustained over 620 frames, so it lost nothing. That is also the second
reason the fixture hid both defects.

`_load_fbx` now takes `bake_fps`, defaulting to 30 so every existing caller is
unchanged, and `_source_frames` passes the rate the caller is already sampling
at. **Both shipped callers pass `RETARGET_FPS = 30.0`** (`FightStagePlayer:23`,
`PairedStagePlayer:14`), so the game's output is byte-identical; only a probe
asking for more receives it.

## 18/19_05 is the weakest control in the corpus

| defect | 18/19_05 | 22/23_17 |
|---|---|---|
| wrong joints | 0.140 -> 0.141 | 0.099 -> 0.294 |
| 30 Hz bake | 0.141 -> 0.146 | 0.099 -> 0.099 |

The two partly cancelled, so **the published `+8.8%` at p0 came back unchanged
after both were fixed.** That is a coincidence of this fixture, not evidence the
old reading was sound. The probe's header now says so, and says to quote
22/23_17 where possible.

## What the corrected probe says

Plain retarget, 22/23_17 — and it is much worse than 18/19_05 ever suggested:

```
SOURCE   min=0.099 p10=0.126 p50=0.152 p90=0.283
RETARGET min=0.461 p10=0.494 p50=0.559 p90=0.667
DRIFT p0 +367.3%   p10 +292.3%   p50 +268.5%
```

Shared anchor on, same fixture:

```
SHARED  pair=rhand(B)->rwrist(A)  dominant=0.59  gripped=716/832 (86.1%)
SHARED  cmu_22_17  RightLowerArm  changed=716 reached=0   skipped=116
SHARED  cmu_23_17  RightHand      changed=716 reached=551 skipped=116
DRIFT p0 -70.1%   p10 -61.5%   p50 -8.4%   p90 +116.9%
```

Two independent confirmations of the joint fix fall out of that run:

1. **The dominant pair is `rhand(B)->rwrist(A)` at 0.59.** In ASF names that is
   `B.rwrist -> A.rradius` at 0.60 — exactly what Q122 reported, from a reader
   that shares no code with this one. Before the fix the probe was counting a
   different pair entirely.
2. **`reached=551`.** S38 reported `reached=0` on both chains and concluded the
   shared anchor is never physically reachable, queueing "the rig's arm
   proportions" as the next stage. With the correct joints B's hand reaches the
   anchor on 551 of 716 gripped frames. **That stage is not needed.** The
   elbow chain still never reaches, on either fixture — that is the real
   residue, and it is about driving a MIDDLE joint as a chain tip, not about
   limb length.

The anchor now over-closes at the tight end: 0.029 m where the capture has
0.099 m, −70.1%. Correcting an overshoot is a different problem from the +367%
it replaced, and it is the next question.

## What is NOT true any more

- "The fault is in the conversion, not the probe, and that is already proven" —
  `Tools/cmu_bvh_to_glb.py` is exact to 2 µm on both fixtures. Nothing was
  wrong with it. The 9 KB vs 27 KB rest-GLB difference is real but irrelevant
  to this symptom: the SOURCE column never reads a rest file.
- "The shared anchor was never physically reachable" — artefact of the joints.
- S38's `-27.9%` / `-39.1%` shared-anchor result — computed against the wrong
  source column, superseded by the figures above.

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/probe_cmu_grip.gd Godot/scripts/FightClipRetarget.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_cmu_grip.gd -- fps=120 fixture=22/23_17
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_paired_anchor_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_anchor_ik_test.gd
python Godot/tools/run_tests.py --only retarget
python Godot/tools/run_tests.py --only clip
```

Results: parse `total=2 fails=0`; `min=0.099`; `checks_failed=0`;
`FIGHT_ANCHOR_IK_TEST PASS`; `SUITE total=2 fails=0`; `SUITE total=9 fails=0`.

**The fixture allowlist banner is gone.** It named 18/19_05 as the validated one
and pointed at the wrong culprit for a stage. In its place
`_check_joint_convention()` asserts the invariant that was actually broken,
reading the loaded clip's own hierarchy: the hand node must be the elbow node's
child, and two parents above the elbow must be a humerus. Adding a fixture
cannot bypass it, and reverting the constants fails it by name.

## Population

CMU subjects 18 vs 19 and 22 vs 23, four different bodies. Bone lengths differ
within each pair (18/19: lfemur 0.420 vs 0.423 m, ltibia 0.429 vs 0.461 m;
22/23: lfemur 0.413 vs 0.434 m, ltibia 0.441 vs 0.447 m), verified by Q122's
`skeletons_differ`. No identical fighters anywhere in this stage.
