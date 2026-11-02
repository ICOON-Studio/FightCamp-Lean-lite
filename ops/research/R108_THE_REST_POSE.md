# R108 — The Rest Pose, and the First Retargeted Clip

**Measured at:** `e04ff1b` (working tree; module and harness land with this digest)
**Harness:** `Godot/tools/measure_r108_retarget.gd`
**Probes:** `Godot/tools/probe_r108.gd`, `Godot/tools/probe_r108b.gd`, `Godot/tools/probe_r109_hip.gd`
**Module:** `Godot/scripts/BoneRestFixer.gd`
**Blind test:** `Godot/tests/bone_rest_fixer_test.gd` (U50, Cursor) — 19 checks, 0 failures

```
R108_RETARGET clip=H2H_HitReaction01.FBX source_abduction=89.8 f01_abduction=92.1
gap=2.2 max_correction=177.6 fixed_mean=7.21 fixed_max=19.64 naive_mean=31.77
naive_max=136.99 over_floor=1/9 current_animation=r108/hit_reaction
```

---

## 1. The stage's premise was wrong, and that is the first finding

R108 was scoped as "the UE4 Mannequin is an A-POSE, our profile rest is a T-POSE,
a name map alone puts the arms in the wrong place." Measured:

| | mean shoulder abduction |
|---|---|
| RamsterZ source rest (`T_pose.fbx` hierarchy) | **89.8°** |
| f01 rest (`SkeletonProfileHumanoid`) | **92.1°** |

90° is a T-pose; an A-pose is about 135°. **Both rigs rest in a T-pose and the
gap is 2.2°, not 45°.** The A-pose problem this stage was written to solve does
not exist between these two rigs.

That does **not** make the rest fixer unnecessary — see §4, where the naive graft
is wrong by up to 137°. It makes it necessary for a *different reason*: per-bone
**axis conventions**, not pose. The largest correction is **177.6° on RightToes**
— a bone whose local axis is flipped end-for-end between the two rigs.

---

## 2. `T_pose.fbx` is not what it looks like, and a clip file is not a rest pose

Two facts that cost the first two measurement runs, both now recorded in the
harness header:

**`T_pose.fbx` carries ONE animation track and it is on
`root/ik_hand_root/ik_hand_gun/ik_hand_l` — an IK helper, not a skeleton bone.**
There is nothing to play. **The file's own node hierarchy IS the T-pose.** Any
code that "plays the T-pose reference" plays a 0.067-second nudge of an IK
handle and reads the rest of the body unchanged.

**A CLIP FILE'S HIERARCHY IS NOT A REST POSE.** The same 68-node rig inside
`H2H_HitReaction01.FBX` sits at **127.5°** abduction — its own saved pose,
mid-reaction. Read "the rig's rest" off a clip and you read a lie that happens
to look like an A-pose. The rest is only available from `T_pose.fbx`, which is
precisely why the vendor ships one in **both** packs.

The first run of this harness compared `T_pose.fbx` against itself and reported
an "A-pose drop" of **0.0°**. The number was real; the comparison was empty.

---

## 3. The engine trap: a cache read as a measurement

**In a headless `--script` run, `Skeleton3D.get_bone_global_pose()` returns the
REST pose and nothing moves it.** Not being in the scene tree, not
`force_update_all_bone_transforms()`, not awaiting a `process_frame`. It is
byte-identical to `get_bone_global_rest()` while `get_bone_pose()` on the *same
bone* correctly shows the rotation just written. Measured in `probe_r108b.gd`:

```
after set 90deg about Z   pose_rot=(0, 0, 0.707107, 0.707107)  global dir=(0.997,-0.028,0.066)
after force_update        pose_rot=(0, 0, 0.707107, 0.707107)  global dir=(0.997,-0.028,0.066)
after one process_frame   pose_rot=(0, 0, 0.707107, 0.707107)  global dir=(0.997,-0.028,0.066)
```

It does not error. So runs one and two reported FIXED and naive as **identical
to two decimals across all nine joints** — and both columns were simply f01's
rest angles read back.

**This is R103's lesson wearing different clothes: the quantity asserted was not
the quantity acted on.** There the report said `strike_head` while the
AnimationPlayer held `jab`; here the report said "global pose" while the engine
held "rest". The fix is the same shape — measure the thing that actually moved.
`_posed_origins()` now composes the global pose from `get_bone_pose()` down the
parent chain and never asks the engine for a cached one.

---

## 4. The result, against a floor that makes it falsifiable

The metric is **frame-invariant joint angles** — an elbow bend is an angle
between two segments of one body, so the two rigs need not face the same way in
world and there is no alignment step to get wrong. The control is the **naive
path-only graft**, which is what `BoneTrackGraft` does today.

The bar is not zero. The two rigs are different **bodies**: f01 rests with a
15.7° bend in the elbow where the source rests dead straight. No retarget can
erase that, and calling the residual an error would be calling anatomy a bug.
So each joint is judged against its own **rest-geometry floor** —
`|source rest angle − f01 rest angle|`.

Mean `|clip − f01|` over 9 samples of `H2H_HitReaction01` (3.03 s, 47 tracks):

| joint | FIXED err° | naive err° | rest floor° | verdict |
|---|---:|---:|---:|---|
| elbow_l | 14.35 | 12.10 | 15.66 | ok |
| elbow_r | 14.30 | 8.18 | 15.64 | ok |
| knee_l | 1.81 | 0.76 | 1.88 | ok |
| knee_r | 2.74 | 0.05 | 2.89 | ok |
| shoulder_abduction_l | **0.79** | **51.88** | 2.22 | ok |
| shoulder_abduction_r | **0.90** | **20.66** | 2.22 | ok |
| hip_l | **19.64** | 2.90 | 7.40 | **OVER** |
| hip_r | 1.31 | **136.99** | 8.24 | ok |
| neck_lean | 9.06 | 52.45 | 9.25 | ok |

```
FIXED  mean  7.21°   max  19.64°   joints over the rest floor: 1 of 9
naive  mean 31.77°   max 136.99°
```

**Eight of nine joints sit at or under the floor — the residual is the two
bodies' anatomy, not the retarget.** Shoulder abduction, the joint a viewer
reads first, lands within **0.79° and 0.90°**.

**The naive graft is not "slightly worse", it is broken:** the right hip is
wrong by **137°**, the left shoulder by **52°**, the neck by **52°**. At
mid-clip the naive right hip reads **23.7°** where the clip says **160.5°** —
the leg folded the wrong way entirely. Without this control, "the clip plays"
would have been reported as success.

### `hip_l` is NOT a defect — the floor was, and here is the correction

R108 first reported `hip_l` at 19.64° against a 7.40° floor as "the one
outstanding defect" and "an asymmetry that large in a symmetric rig is a real
finding". **That was wrong, and the check that settles it is now in the
harness.**

**PIPELINE IDENTITY: feed the pipeline the source's own reference pose and f01
must land exactly on f01's rest.** It exercises the whole chain — global
composition, `correction`, `pose_frame`, `to_local`, the skeleton write and the
read-back — against a known answer. Measured: **largest joint deviation
0.0000°. PASS.** The retarget is not wrong anywhere.

What `hip_l` actually shows is **the floor metric's own limit**. A joint angle is
the angle BETWEEN two segment directions, so two rigs can agree on the ANGLE at
rest while disagreeing badly on the directions — the errors cancel. Measured at
rest, between the two rigs:

| segment | source vs f01 |
|---|---:|
| `thigh_l` | 5.2° |
| `thigh_r` | 6.5° |
| **`pelvis → spine_01`** | **16.8°** |

`hip_l` and `hip_r` are both measured against that 16.8° lower-spine
disagreement. At rest it cancels to 7.4° and 8.2°; once the body moves it stops
cancelling. **`hip_l` at 19.64° is inside 16.8° + 5.2°. `hip_r` at 1.31° is the
lucky one, not the correct one.** `shoulder_abduction` is measured against
`Chest → UpperChest`, where the two rigs agree closely — which is why it lands
at 0.79°/0.90°.

**So: the rest-geometry floor is a floor AT THE REFERENCE POSE, not a bound over
all poses.** It is still the right bar to publish — it is falsifiable and it is
honest about anatomy — but it must be read with `identity=0.0000` beside it, and
a joint that exceeds it is a candidate for rig disagreement before it is a
candidate for a bug. **R109 should not go hunting a left-hip defect; there
isn't one.**

---

## 5. It plays

Not a pose written to a skeleton — a real `Animation` on a real
`AnimationPlayer`, asserted the way R103 insists:

```
AnimationPlayer   : current_animation = "r108/hit_reaction"  pos 1.52s / 3.03s
moves_bones (U42) : 20 of 22 driven off rest BY THE PLAYED CLIP
```

**20 of 22, not 22 of 22, and that is correct**: `spine_03` and `hand_l` carry
no rotation track in this clip. Measured in `probe_r108.gd`, not assumed.

---

## 6. The module, and the blind test that did not see it

`Godot/scripts/BoneRestFixer.gd` — statics only, zero preloads:

```gdscript
correction(reference_global, target_rest_global) -> Basis   # reference⁻¹ · target_rest
retarget_global(source_global, corr)             -> Basis   # source · corr
to_local(parent_global, child_global)            -> Basis   # parent⁻¹ · child
pose_frame(source_globals, corrections, parent_of) -> Dictionary
```

`reference_global` is the source rig posed to match the target's rest. Using the
source's own bind instead is the classic error that **adds** the rest difference
to every frame: an arm authored 30° above horizontal arrives at 75°.

U50 (Cursor) wrote `Godot/tests/bone_rest_fixer_test.gd` from the contract
alone, in parallel, without reading the module — including the negative
assertion that the P4 result is **not** the 75° failure. **19 checks, 0
failures**, verified by re-running it here. Module and blind test agree.

---

## 7. What this settles, and what it opens

**Settled:** a bought RamsterZ clip plays correctly on f01. One `BoneRestFixer`
plus the confirmed 22-row map is the whole integration cost. The A-pose fear was
unfounded; the axis-convention problem was real and is solved.

**Open:**
1. ~~`hip_l` is a defect~~ — **withdrawn, see §4.** `identity=0.0000°` proves the
   chain. The two rigs' `pelvis → spine` directions differ by 16.8° and that
   propagates into every joint measured against the lower spine. Nothing to fix
   in the retarget; it is a rig-proportion fact.
2. **Root motion is not carried.** Only rotations are retargeted; `H2H_HitReaction01`
   has 18 position tracks including `root` and `pelvis`. In-place is correct for a
   reaction; a travelling clip will need the translation path.
3. The paired ground clips (R106) are still untouched. Single body worked first,
   as scoped — the pair is now unblocked.
