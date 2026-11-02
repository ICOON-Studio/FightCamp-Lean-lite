# C149 CMU source measurement

The independent source reader parses subjects 18 and 19 as separate ASF
skeletons and their frame-synchronised `18_05.amc` and `19_05.amc` motions.
Forward kinematics composes each bone's local rotation as `C * M * C^-1`,
where `C` is the ASF axis rotation and `M` uses the frame channels in that
bone's declared DOF order. Bones without a DOF line remain in the hierarchy
with identity local rotation. Positions are converted from ASF units to metres
using `0.056444`, including root translation. Percentiles use linear
interpolation between sorted samples.

## Measured distances

`CMU SOURCE 18/19_05 frames=438 fps=120`

| pairing | min (m) | p10 (m) | p50 (m) | p90 (m) | max (m) |
|---|---:|---:|---:|---:|---:|
| A_lhand -> B_lhand | 0.487099 | 0.746139 | 1.327536 | 1.820255 | 2.012378 |
| A_lhand -> B_rhand | 0.850552 | 1.587153 | 2.056368 | 2.307305 | 2.432344 |
| A_rhand -> B_lhand | 0.320026 | 0.600379 | 0.834626 | 0.955955 | 1.077535 |
| A_rhand -> B_rhand | 0.732284 | 0.836205 | 1.201802 | 1.998743 | 2.031996 |
| closest_hand_pair | 0.320026 | 0.586582 | 0.811375 | 0.943977 | 1.050415 |

Root-to-root separation:

| min (m) | p10 (m) | p50 (m) | p90 (m) | max (m) |
|---:|---:|---:|---:|---:|
| 0.765420 | 0.842156 | 0.993449 | 1.512095 | 1.711768 |

## Derived self-checks

1. **PASS — frame counts:** subject 18 = 438, subject 19 = 438.
2. **PASS — distinct skeletons:** three differing bone lengths (metres):
   `lhipjoint 0.136482 / 0.135409`, `lfemur 0.420188 / 0.423161`, and
   `ltibia 0.429001 / 0.460967` (subjects 18 / 19).
3. **PASS — rigid bone lengths:** maximum spread recomputed from world
   positions at frames 0, 219, and 437 was `0.000000000 m`, below `0.001 m`.
4. **PASS — root separation:** `min=0.765420`, `p10=0.842156`,
   `p50=0.993449`, `max=1.711768 m`; each is within `0.02 m` of R155's
   `0.77 / 0.84 / 0.99 / 1.71 m`.

---

## CORRECTION — Claude, S34 integration, 2026-09-21

**The numbers above this line were wrong, and all four of this task's own gates
passed while they were wrong.** C149 was commissioned as a BLIND second reader
of the same files. It disagreed with Claude's independent reader, and the
collision was settled in the data rather than by either side conceding. Three
bugs, all in `Tools/cmu_source_probe.py`, all now fixed in place with a comment
at each site:

1. **Every bone was placed with its PARENT's rotation** — `_mat_vec(parent_rotation,
   bone["direction"])`. That is the BVH convention (BVH puts rotation on the
   JOINT) applied to ASF data, where the rotation belongs to the BONE:
   `tip(b) = tip(parent) + M_b @ direction_b * length_b`. Every bone lagged one
   joint down the chain.
2. **Euler angles composed in the wrong order** — `Rx @ Ry @ Rz` where ASF order
   "XYZ" means X is applied first and so composes as `Rz @ Ry @ Rx`.
3. **Every motion channel was applied about Z.** `bone["dof"]` parses to
   `["rx","ry","rz"]` and was handed straight to `_axis_rotation`, which tests
   `== "x"` and `== "y"` and returns Z for anything else. The axis triple took
   the correct branch, which is why the skeleton still looked like a body —
   only the ANIMATION was collapsed onto one axis.

**WHY THE GATES DID NOT CATCH ANY OF IT.** Frame counts and skeleton-difference
never touch the rotation chain. Root separation is read straight off the AMC and
bypasses it entirely — which is why it was correct to six decimals from the
start and stayed correct through all three bugs. And recomputed bone rigidity is
true by construction: `tip = parent + length * (R @ direction)` preserves length
for ANY rotation `R`, so it reported `max_spread` of exactly `0.000000000 m`
against a pose that was badly wrong. **Three of the four gates could not fail,
and the fourth measured a quantity the bugs could not reach.**

**WHAT DID CATCH IT WAS ANATOMY**, and it is the check this task should have
been given: a foot **1.887 m in the air** in a capture of two people standing
and pulling, and no hand ever closer than **0.376 m** to an elbow in a trial CMU
names *"A pulls B by the elbow"*. A capture's own label is ground truth and it
is free.

**AFTER THE THREE FIXES THE TWO READERS AGREE TO 21 MICROMETRES** — worst joint
disagreement `0.000021203 m` across all 438 frames, which is float rounding from
a different multiplication order. The confirmed source figures are:

| series | min | p10 | p50 | p90 | max |
|---|---:|---:|---:|---:|---:|
| `A_hand->B_elbow` | **0.130** | 0.153 | **0.203** | 0.982 | 1.286 |
| `A_rhand->B_lhand` | 0.232 | 0.251 | 0.316 | 0.932 | 1.226 |
| `root->root` | 0.765 | 0.842 | 0.993 | 1.512 | 1.712 |

The elbow series is the contact the trial is named for. **0.130-0.203 m is a
hand ON an elbow** — that is the grip our retarget has to preserve, and the
number S34's second half is measured against.
