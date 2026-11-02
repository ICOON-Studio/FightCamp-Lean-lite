# BRIEF — one clinch pose, posed for real

You are being asked for **one static two-man clinch pose**, authored as real
per-bone keyframes in Blender and exported as GLB. Not a library, not a
transition, not a state machine. One pose, correct.

This brief is self-contained. Everything you need is in it.

---

## FIRST: THREE THINGS IN YOUR LAST DELIVERY ARE BROKEN

Not style notes — each is a single checkable fact, and the same bugs will recur
if you do not see them.

**1. Your animations move nobody.** `PairedGrapplingRig.py` creates every
`CHILD_OF` constraint at `influence = 0.0`:

```python
c = pb[f"{side}Hand_IK_Target"].constraints.new('CHILD_OF')
c.target = anchor; ...; c.influence = 0.0
```

and **no script in your archive ever raises it**. Your seven `Anim_*.py` files
keyframe only `anchor.location` — four to seven XYZ points on an empty. No bone
is ever posed. Played back, both fighters stand perfectly still while an empty
slides through the air between them. The "complete move library — 4 transitions
+ 3 submissions + 3 escapes" animates nothing.

**2. `GrapplingSystem.cs` does not compile.**
`anim.SetLayerWeight("Grapple_L", gripStrength)` — Unity's `SetLayerWeight`
takes `(int layerIndex, float weight)`. There is no string overload; the lookup
is `GetLayerIndex`.

**3. Every submission resolves at chance zero.** `submissionOffense` and
`submissionDefense` are `public float` with no initialiser and nothing in any of
your nine scripts ever assigns them, so `CheckSubResult` computes
`0*0.8 − 0*0.6 + stamina delta`, clamped.

**And your one mocap example points at the wrong trial.**
`FILE_PAIRS = [("19_03_A.bvh", "19_03_B.bvh", 0)]`. We measured all six paired
trials on disk. In **18/19_03 the closest a hand comes to an elbow across 592
frames is 0.239 m** — it contains no grappling contact at all:

| trial | frames | closest hand→elbow | frames in contact (≤0.20 m) |
|---|---:|---:|---:|
| 18/19_**03** | 592 | **0.239 m** | **0** |
| 18/19_04 | 405 | 0.283 m | 0 |
| 18/19_05 | 438 | 0.141 m | 222 |
| 18/19_06 | 407 | 0.121 m | 307 |
| 22/23_01 | 782 | 0.152 m | 129 |
| 22/23_17 | 832 | **0.099 m** | **643** |

Your subject list (18, 19, 22, 23) was exactly right — the most accurate line in
your whole document. The trial was the one that cannot show the feature. If you
want a contact reference, **22/23_17** is the best one: 832 frames, 77% of them
in contact, closest approach 0.099 m.

---

## THE ENGINE IS GODOT. NOT UNITY.

Do not send C#. The decision was measured, not preferred: the 3D presentation
another engine would replace is ~7,000 lines inside a 97,606-line tree with 320
tests. A prefab replaces about 7% and forces a rewrite of the other 93%.

Blender Python is welcome and is what we want from you.

---

## THE TASK

Produce a **single, static, readable, anatomically correct two-man clinch pose**.

### Hard constraints — these are measured, not preferences

**SEPARATION IS 0.72 m.** Not 0.4–0.6 m as your preset table says. Two
independent measurements:

| source | method | figure |
|---|---|---|
| tracked broadcast footage | hip-to-hip | **0.719 m** |
| CMU paired mocap 18/19_05 | root-to-root minimum | **0.766 m** |

Two different methods landing within 5 cm of each other, both ~20 cm looser than
your upper bound. Author to 0.4–0.6 m and every position inheriting from the
clinch is unreally tight.

**BONE NAMES ARE THESE, EXACTLY.** Not `LeftArm` / `LeftForearm`:

```
Hips, Spine, Chest, UpperChest, Neck, Head,
LeftShoulder,  LeftUpperArm,  LeftLowerArm,  LeftHand,
RightShoulder, RightUpperArm, RightLowerArm, RightHand,
LeftUpperLeg,  LeftLowerLeg,  LeftFoot,  LeftToes,
RightUpperLeg, RightLowerLeg, RightFoot, RightToes
```

**DO NOT INVENT BONE LENGTHS.** Your `BONE_LENGTHS` dict authors an arm at
0.32 m and a thigh at 0.42 m against no source. Our fighters are different
sizes and are **not in metres** — the meshes export at arbitrary scale and a
separate height factor puts them at the athlete's real stature. So build the
pose as **rotations**, on a rig whose proportions come in from outside. A pose
baked to fixed lengths will not transfer.

**KEY THE BONES.** Every joint that moves gets a keyframe. If you use IK to
reach the pose, **bake it down to FK rotations before export** — an anchor track
alone is not a pose, which is defect 1 above. In our engine IK solvers do not
run in a headless test at all, so anything unbaked is invisible to the check
that has to prove it.

### What a real clinch is

A clinch is **18% of total UFC fight time** (Fightnomics/FightMetric, 2013), and
about a quarter of standing time. Elite Olympic male boxers enter one **2.5 /
3.2 / 4.8 times per round**, for **12.6 / 17.2 / 28.7 s per round in total**
(Davis 2015, 29 London 2012 bouts, 39 boxers).

It is a **held, loaded, weight-bearing** position: heads close and often in
contact, hands fighting for inside position on the neck or biceps, elbows in,
hips back and braced, weight forward through the front foot. Both men are
pushing. It is **not** two people reaching for each other at arm's length, and
it is not symmetrical — one man has inside position.

Per-episode duration in MMA, the ending-mode split and torso/hip separation in a
clinch specifically are **not published anywhere** — we looked. Do not invent
numbers for them and do not cite any; say "not found" if you need them.

### Deliver

1. One `.py` that runs headless in Blender and builds the pose.
2. The `.glb` it writes.
3. A short note saying which joint angles carry the pose and why.

**Send the code as text in your reply.** Your attachment channel does not accept
`.py` or `.glb`, so do not try to attach them.

---

## HOW THIS WILL BE JUDGED

Opened in Blender and looked at, then measured: hip-to-hip separation against
0.72 m, and whether the arms are actually in an inside/outside relationship
rather than interpenetrating. If it reads as a real clinch, we will come back
for the other four holds — side control, guard, half guard, back control — which
is real paid work we have no film for.

One pose. Get it right.
