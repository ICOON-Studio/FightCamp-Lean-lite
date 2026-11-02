# I ran the corpus. The poses are good. The solver cannot reach them.

All eight standing poses failed and all five ground poses passed, and that
split is not about your authoring. Three things, in this order — and the first
one is most of the value.

## 1. Make `buildCapsules` read the DOFs it already lists

`listAllDOFs()` offers `pitch`, `roll` and nine `limbs` entries per body.
`buildCapsules` reads `state.x`, `state.y`, `state.z` and `state.yaw` and
nothing else. I measured it rather than assuming: perturbing each DOF by 0.35
and reading the cost change gives

```
F1.x  -232.74    F1.pitch  0    F1.limbs.rArm   0
F1.y  +579.64    F1.roll   0    F1.limbs.torso  0
F1.z  +334.26                   F1.limbs.rLeg   0
F1.yaw -16.38                   F2.limbs.neck   0
```

Exactly zero, not small. So 22 of the 30 DOFs you probe every sweep cannot
change the cost, "Full Refine" cannot differ from "Root Placement", and every
pose is two rigid statues slid and spun. That is why a grip lands 0.34 m from
the neck it is gripping: the hand is welded to the torso.

**Start with shoulders only.** I tested this. Same cost function, same
schedule, same start state, one change — each arm's distal end may rotate
about its own shoulder on a sphere of its rest length, so arm length is
preserved exactly. Two DOF per arm, eight in total.

| | grip, as delivered | grip, with shoulders |
|---|---|---|
| Collar Tie | 0.3406 | **0.0006** |

Penetration goes 0.0879 → 0.0000 with it. **The collar tie passes all four
thresholds.** Your pose was right the whole time.

The other seven improve to grip ~0.10–0.12 and stop, with declared penetration
stuck at 0.06–0.08 m. That floor is the **torso**: a rigid cylinder cannot put
a head outside a hip, flatten a back, or get a chest over a head. So after
shoulders, the next DOF is a spine bend — not elbows, which are not the
blocker.

## 2. Score penetration over ALL capsule pairs, and report `hold`

`worstPen` only looks at pairs you declared as contacts. An all-pairs audit of
the final state says the worst real interpenetration is **never** the pair you
score — for all thirteen poses:

| pose | your pen | real worst | the pair |
|---|---|---|---|
| Closed Guard | 0.0046 PASS | **0.2208** | F1.torso × F2.torso |
| Rear Naked Choke | 0.0039 PASS | **0.1143** | F1.back × F2.lArm |
| Armbar | 0.0000 PASS | **0.1093** | F1.torso × F2.rArm |
| Side Control | 0.0001 PASS | **0.0998** | F1.rArm × F2.back |
| Mount | 0.0004 PASS | **0.0868** | F1.rArm × F2.torso |

Closed guard passes on 4.6 mm while the two torsos are 22 cm inside each other.
Loop every F1 capsule against every F2 capsule.

And `hold` has no row in the panel at all. It is a soft penalty with a 15 mm
dead zone and nothing surfaces it, so: the sprawl's defender, authored on hands
and knees, finishes with his hands **0.333 m in the air**; the front headlock
**0.390 m**. Report the lift in metres with the offending part named, exactly
as you already do for the other four.

## 3. Drop `mob`, or give it authority

You set it deliberately per pose and said it is what separates an underhook
from an over-under. As written it is `(F1.y − F2.y) → (mob − 0.5) × 0.3` at
weight 80 — a height offset, not weight distribution.

Its signs also read backwards against your own comments (`mob: 0.7 // F1
driving low` asks F1 to sit 6 cm **higher**; the sprawl asks the man doing the
flattening to sit 6 cm **lower**). **But that is not the problem** — I flipped
all four and no metric moved by more than 0.003 m.

The problem is that it never binds. Asked against delivered across all 13
poses: median miss **0.124 m**, max **0.261 m** (sprawl asks −0.060, delivers
+0.201 — wrong sign and four times the size). At weight 80 against contact 1200
and grip 1500 it is outbid everywhere the pose is actually specified. It lands
only on the four poses that have no grips and almost no contacts.

Either cut it, or make it real: weight distribution needs a base of support and
a centre of mass over it, not a height nudge.

## What I am NOT asking for

**Do not author more poses.** The corpus is good and it is not the bottleneck —
you have already proved you can author these, and the collar tie result shows
the authoring is sound. This round is the solver only.

Keep the thresholds where they are. You did not widen them last time and that
was the right call.

## Report back

One runnable HTML file as before. In the panel, per pose: worst penetration
**over all pairs** with the pair named, worst contact error, worst grip error,
worst mat violation, **worst hold lift with the part named**, and the
evaluation count. Same thresholds.

Then tell me two things in the reply text: **which DOFs you made live**, and
**which poses moved from fail to pass** as a result. If a pose still will not
solve, report its residuals and name the pair that fights — that is worth more
than a green tick, same as last time.
