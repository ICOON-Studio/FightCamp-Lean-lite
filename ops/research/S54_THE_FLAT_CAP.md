# S54 — THE FLAT CAP IS BUILT, MEASURED, AND DOES NOT SHIP

**Claude, 2026-09-22.** Tool: `Godot/tools/s54_flat_cap.gd`. Module:
`Godot/scripts/CapsuleDistance.gd`. Arms: `FighterCapsules.FLAT_CAP_ARMS`.
Blind contract test: `Godot/tests/capsule_distance_contract_test.gd` (Grok, G72).

**Population, named because a fixture is not a finding:** `f01_m_box_welter` at
1.78 m against `f02_m_box_heavy` at 1.88 m — two different rigs at two different
statures, never one man twice. Base set is `build_report`'s **shipped** capsules,
so the head is already a sphere and this measures ONE change, not two.

---

## THE VERDICT IN ONE LINE

**The flat cap works exactly as D13 said it would, gains almost nothing, and
costs real flesh — so it is recorded and reverted, not shipped.**

The neck goes from **0.0% to 3.1–7.0%** exposed, not to her demo's 100%. The
price is **155 and 162 skin vertices of upper chest that no capsule covers any
more**, up to 0.079 m outside the body. That is a bad trade, and it is the
**third** time this project has had to apply the rule that an informative
failure still does not ship.

---

## WHAT THE NECK DID — the question the stage was opened on

| rig | spot | control (dome) | flat cap | banded, control -> flat |
|---|---|---:|---:|---|
| f02 @1.88 m | `neck@0.15` | 0.0% | **7.0%** | 0.0% -> 14.1% |
| f02 @1.88 m | `neck@0.50` | 0.0% | **5.5%** | 0.0% -> 10.9% |
| f01 @1.78 m | `neck@0.15` | 0.0% | **3.1%** | 0.0% -> 6.3% |
| f01 @1.78 m | `neck@0.50` | 0.0% | **3.1%** | 0.0% -> 6.3% |

**This is the first non-zero neck exposure this project has ever measured**, and
it is worth saying plainly because every previous attempt — the endpoint inset
(D11, all three arms), the span fix (Q138, 3.2 mm short), the head sphere (S53) —
read 0.0% on both rigs at every blend. The cap really was part of the blocker.

**But D13's 100% is refused on our rigs.** Her figure was hers, from her own
demo, on her own parameters, and the standing rule about running her HTML before
believing a number held again. `thorax` remains the deepest blocker at both
spots even with a flat top — 82 and 70 of 128 directions on f02, 72 and 63 on
f01. **The dome was a minority of the problem; the radius is the rest of it.**

## WHAT THE SHOULDER GIRDLE DID — nothing, and that is the second finding

`shoulder_span` is not gripped by the corpus, so it was added as an explicit
probe target (labelled `ADDED` in the output) precisely to test D13's
self-objection.

| rig | spot | control | flat cap |
|---|---|---:|---:|
| f02 | `shoulder_span@0.50` | 0.0% | **0.0%** |
| f02 | `shoulder_span@0.25` | 0.0% | **0.0%** |
| f02 | `shoulder_span@0.75` | 0.0% | **0.0%** |
| f01 | all three | 0.0% | **0.0%** |

The blocked count falls (f02 centre 128 -> 108 directions blocked by `thorax`)
and the usable count **does not move off zero**. Flattening the cap does not
open the clavicle at all. J43 and J44 both predicted this from the
anthropometry, independently and blind, and the measurement agrees with them.

## WHY EXPOSURE COULD NOT HAVE ANSWERED THIS ON ITS OWN

**A flat-capped cylinder is a strict SUBSET of the capsule with the same
`p0`, `p1` and `r`.** Removing the domes cannot add volume, so `flat(q) >=
dome(q)` everywhere — which means **every exposure number in this table can only
rise and every overlap can only fall.** An instrument that can only move one way
cannot report a trade-off.

That is S41's "a control that cannot move" one level up, and it is why the
coverage table below exists. **It is also the thing to check first the next time
a shape change is proposed: ask whether the metric watching it is capable of
reading worse.**

## THE COVERAGE TABLE — and the column that decides it

Every skin vertex on the rig, tested against the thorax under both caps.
`DROPPED` is inside the dome and outside the flat cap. **`ORPHANED` is dropped
AND not inside any other capsule on the body** — flesh the man actually loses.

**f01_m_box_welter @1.78 m** — 11,363 vertices; 642 inside the dome; 331 dropped

| skinned to | in dome | dropped | **orphaned** |
|---|---:|---:|---:|
| Chest | 78 | 29 | **0** |
| Head | 84 | 84 | **28** |
| LeftShoulder | 1 | 1 | **1** |
| Spine | 49 | 49 | **0** |
| UpperChest | 430 | 168 | **126** |
| **TOTAL** | | **331** | **155** |

**f02_m_box_heavy @1.88 m** — 11,084 vertices; 654 inside the dome; 335 dropped

| skinned to | in dome | dropped | **orphaned** |
|---|---:|---:|---:|
| Chest | 50 | 16 | **0** |
| Head | 100 | 100 | **11** |
| Spine | 44 | 44 | **0** |
| UpperChest | 460 | 175 | **151** |
| **TOTAL** | | **335** | **162** |

Deepest orphaned vertex: **0.0793 m** (f01) and **0.0795 m** (f02) outside the
flat cap.

**THE ORPHAN COLUMN IS WHY THE RAW DROP COUNT WOULD HAVE MISLED.** `Spine`
drops 49 and 44 vertices and orphans **zero** — the thorax's LOWER cap sits
inside `pelvis`, which runs Hips->Chest and is declared adjacent, so that flesh
never leaves the man. `Chest` is the same story. **Reporting 331 dropped would
have overstated the cost by more than half.**

**AND THE COST THAT IS REAL IS `UpperChest` — 126 and 151 vertices, 81% and 93%
of all orphans.** That is the shoulder girdle's own bone. **D13's
self-objection was right**, and J44's coplanar acromion did not rescue it: ANSUR
says there is no mass above the *suprasternal notch*, but our thorax's `p1` is
the **Neck bone**, and the rig's upper-chest skin plainly rises above the plane
through it.

Set against a 3.1–7.0 point gain on a metric three agents now agree is the wrong
one to chase, that is not a trade worth making.

## WHAT SHIPS AND WHAT DOES NOT

**SHIPS:** `CapsuleDistance.gd`, `FLAT_CAP_ARMS`, `s54_flat_cap.gd` and the
blind contract test. The module is **not wired into any measurement path** —
`FLAT_CAP_ARMS` defaults to `current`, every capsule keeps its dome, and nothing
in the tree behaves differently. It is an instrument, kept because the next
trunk change will need exactly this comparison and rebuilding it would cost a
session.

**DOES NOT SHIP:** the flat cap as the body's shape.

---

## THE BLIND SPLIT PAID FOR THE FIFTH TIME, AND IT CAUGHT ME

**Grok (G72) wrote the contract test from the GEOMETRIC DEFINITION — never from
my formula — and it found a genuine defect in my contract**, verbatim:

> *"Ambiguity (Invariant 2). 'Strictly between the two end planes' is not
> 'nearest point on the barrel.' On-axis, 0.01 below the top cap, the projection
> is between the planes but the flat nearest point is the disk: flat = -0.01,
> dome = -0.14. An identity asserted on every between-planes sample is false
> under the signed-distance definition."*

**It is right.** My "barrel identity" was stated wrongly: for a point INSIDE and
near the cap, the nearest surface under `flat` is the disk, not the barrel. The
implementation handles it correctly; the contract wording did not, and **S54's
own non-vacuity check only sampled an OUTSIDE point beside the barrel, so it
could never have hit the clash.** The blind half found what my own gate was
blind to, which is the entire argument for the split.

**The test then passed against my module first time: `checks=1902
checks_failed=0`.** Two independent derivations of the same solid agree.

### AND THE MUTANT PROVES IT IS NOT AGREEING BY ACCIDENT

**D13's arithmetic is wrong at the rim and this is where it was caught.** Her
rule reads, past the rim, `sqrt(d_axial^2 + d_perp^2) - r` — which is the
distance to a **SPHERE of radius `r` centred at `p1`**, i.e. the dome she was
replacing. Past the rim the nearest point of a flat-capped cylinder is the
**rim circle**, so the distance is `sqrt(d_axial^2 + (d_perp - r)^2)`.

Patching my module to her literal expression and re-running her test:

```
BAD row 1_flat_axis_up:  expected 0.1      got -0.03999997615814
BAD row 4a_flat_rim:     expected 0.208806 got  0.14284274829944
BAD row 4a_not_sphere:   expected different got 0.14284274829944 vs 0.142843
BAD row 4b_flat_rim:     expected 0.19799  got  0.17304951151877
BAD row 4c_flat_rim:     expected 0.167631 got  0.16413813043449
```

**`4a_not_sphere` is a row Grok wrote specifically to assert the answer is NOT
the sphere-at-`p1` distance, and D13's formula produces exactly that number.**
Copying her expression verbatim would have produced an arm still hemispherical
precisely where the two shapes differ most, and the 7.0% would have been a
measurement of the dome wearing the flat cap's name.

Module restored clean (`git diff` empty) — the patch ran under a `finally`.

---

## NON-VACUITY — four checks, all green, all earned by a past defect

```
control path agrees to 0.000000000 m; subset invariant holds on 768 samples
(worst deviation 0.000000000 m); 0.0616 m above the Neck bone reads
dome=-0.0616 flat=+0.0616; barrel identity 0.000000000 m        [f01]
... 0.0709 m above the Neck bone reads dome=-0.0709 flat=+0.0709 [f02]
```

1. **The control must BE the control.** `dome` reproduces the tree's old
   `FightPoseSolver.segment_distance` path to **0.000000000 m** over 128
   directions on both rigs. Without this every `current` row would be a new
   measurement wearing the control's name.
2. **The subset invariant**, 768 samples per rig.
3. **The treatment must change the geometry** — a point half a radius above the
   Neck bone reads inside under the dome and outside under the flat cap.
4. **The barrel identity**, where the two solids must agree.

**Two defects in my own gate, found by running it:** the subset check used a
zero tolerance and reported 35 and 26 "violations" that were float noise at
3.0e-8 and 6.0e-8 m — 30 nanometres on a 1.8 m man; it now carries a named
`SUBSET_EPSILON_M = 1e-6`. And **`%e` is not a GDScript format specifier** — it
printed the literal `%.2e` and the number vanished. Both are in the tool.

---

## WHAT THIS LEAVES OPEN, AND WHAT IT CLOSES

**CLOSED: the cap shape is not the blocker.** Three arms have now been measured
on our own rigs and refused — the endpoint inset (D11), the span fix (Q138), and
the flat cap (here). Each removed a different piece of the thorax and none of
them made the neck reachable. **Stop changing the thorax's SHAPE to reach the
neck.**

**OPEN, AND IT IS THE SAME ANSWER FROM FIVE DIRECTIONS NOW:** the thorax's
**RADIUS** is the blocker, and the trunk is not one capsule. J43 measured our
radius at 4.9–5.7x the half-inlet; J44 measured that the breadth at that level
is **neck plus two shoulders, not chest**; D13's Q1 option B is a truncated
bi-capsule; D13's Q4, J42 and G70 all say to stop asserting on the neck and grip
the trunk with named anchors. **D14 now gives those five anchors as arithmetic**
(`research/D14_THE_SHOULDER_RIM.md`) with no new stored field.

**The next change is the trunk's shape at the top, not its cap** — and per
D14's own refusal rule, adopted here: *"Reject any anchor defined as 'the part
of X that is reachable.' Accept only anchors defined as 'Y anatomical landmark,
measure reachability to it.'"*

## REPRODUCE

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s54_flat_cap.gd
python Godot/tools/run_tests.py --only capsule_distance
```
