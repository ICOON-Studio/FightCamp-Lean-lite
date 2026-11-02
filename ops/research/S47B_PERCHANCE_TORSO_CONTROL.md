# S47B — PERCHANCE'S OWN TORSO, AS AN INDEPENDENT CONTROL

**Session:** S47, 2026-09-22, after the operator asked whether to put Perchance
on grappling. **Answer: not yet — but ask it one question first**, and this is
the answer it gave.

## Why this was worth one measurement

S47 found `neck` 0.0% reachable on both our rigs and blamed the thorax capsule:
r = 0.1909 m on a 0.3054 m segment, because `FighterCapsules` takes the radius
as the p80 of the **Chest** bone's skin and the Chest bone owns the deltoids.
S48 was written to derive that radius from chest DEPTH, with "split the trunk"
as the named fallback.

`FightPoseSolver.gd` is a **port of the solver in the operator's
`perchance.org/gro5f7k2s5` BJJ build**. That build is a working implementation of
the same algorithm on a different body model, so it is the one independent
control available for "is our torso wrong, or is the model wrong?" — and it cost
nothing, because the whole rev10 source is already on disk at
`research/perchance/PERCHANCE_gro5f7k2s5_rev10_pending_recovered_2026-09-22.json`.

## Its rig, transcribed verbatim from that source (lines 699–714)

```js
{ n:"pelvis", cap:{a:[0,-0.115,0], b:[0,0.12,0], r:0.120}, part:"torso" }
{ n:"spine",  cap:{a:[0,0,0],      b:[0,0.17,0], r:0.126}, part:"torso" }
{ n:"chest",  cap:{a:[0,0,0],      b:[0,0.20,0], r:0.130}, part:"torso" }
{ n:"neck",   cap:{a:[0,0,0],      b:[0,0.09,0], r:0.055}, part:"neck"  }
{ n:"head",   cap:{a:[0,0.015,0],  b:[0,0.10,0], r:0.100}, part:"head"  }
```

**Two structural differences from ours, and both were what S48 was planning:**

1. **It splits the trunk into THREE capsules** — pelvis / spine / chest — where
   we have two (pelvis / thorax). That is S48's named fallback, already shipped
   in the reference implementation.
2. **Its trunk radii are authored constants and they are much slimmer.** Chest
   0.130 m on a 1.662 m body. Ours is **0.1909 m** on a 1.88 m body — 47% fatter
   than the widest trunk capsule a working build uses, and our `pelvis` at
   0.1946 is 62% fatter than its 0.120.

Its neck radius is **0.055 m — identical to ours**, which is authored in
`FighterCapsules.RADII_M` for the same reason (a neck has no meaningful skin
weight to measure).

## THE RESULT, and it closes both of S48's roads

S47's own reachability method, run on Perchance's rig with its own hand radius
(0.044 m):

| capsule | r | len | ratio | exposed | buried by | depth |
|---|---|---|---|---|---|---|
| pelvis | 0.1200 | 0.2350 | 0.511 | 46.5% | hipR | 0.0680 |
| spine | 0.1260 | 0.1700 | 0.741 | 51.6% | armR | 0.0560 |
| chest | 0.1300 | 0.2000 | 0.650 | 70.3% | armR | 0.0600 |
| **neck** | **0.0550** | **0.0900** | **0.611** | **0.0%** | **chest** | **0.0750** |
| head | 0.1000 | 0.0850 | 1.176 | 100.0% | — | 0.0000 |
| armL | 0.0520 | 0.2600 | 0.200 | 71.9% | chest | 0.0600 |
| hipL | 0.0880 | 0.3700 | 0.238 | 59.8% | pelvis | 0.1320 |
| shinL | 0.0740 | 0.4000 | 0.185 | 77.1% | shinR | 0.0360 |

**Perchance's neck is ALSO 0.0% exposed** — buried 0.0750 m inside its own chest
— on a rig that already splits the trunk three ways and already uses slim
authored radii.

**So neither of S48's two planned roads fixes it.** Splitting the trunk does not.
Slimming the radius does not. The reference implementation has the same
condition and ships.

## Why Perchance works anyway, and this is the whole answer

**It never scores a hand against its own body.**

```js
const LIMBS = ["kneeL","kneeR","elbL","elbR","handR","handL","footR","footL"];
```

Eight limb POINTS, tested against the OTHER body. There is no all-pairs
self-collision term anywhere in it. An unreachable neck costs it nothing because
nothing ever asks.

**We inherited the cost function and applied it to a fifteen-capsule all-pairs
comparison the original never performed.** That is not a mistake to undo —
S46's header records exactly why all-pairs is right: scoring only the declared
contacts let closed guard pass at 4.6 mm while the two torsos were 0.2208 m
inside each other. But it is the reason the port surfaced a condition the source
never had to face.

## So the diagnosis changes, and it splits in two

**The reachability audit's PASS CRITERION was wrong, not its measurement.** A
neck is buried in a chest on any capsule humanoid, and that is anatomically
correct: you cannot touch a neck from below or from inside it. You reach it from
ABOVE and from the side, over the shoulder line. "Can a hand touch this target
from anywhere on its full surface" is too strong a question. **The right question
is whether the hand can reach the specific spot the grip names, from the
direction the hold actually uses.**

**What is genuinely broken is that the penetration term punishes the hold
itself.** In a real collar tie the forearm DOES lie against the opponent's chest
and shoulder — that is what the hold is. Our solver scores `forearm_r/thorax` as
a 0.1223 m violation while the hand sits 0.0061 m from its target, so it is
being told that the correct pose is catastrophically wrong and is driven away
from it.

**And the thorax is still too fat — that part stands.** Two independent lines:
Q131 showed a 0.55× thorax probe removes all 11 refused live-overlap frames on
seed 810039; and arithmetic on S47's own anatomy probe says a 0.130 m thorax
(Perchance's value) would cut the collar-tie overlap from 0.1223 to about
0.062 m, and a depth-derived ~0.11 m to about 0.04 m. **Narrowing it helps a lot
and does not close it.** These are two defects, and until now they were one.

## What S48 should do, in order

1. **Derive the thorax radius from chest DEPTH** as planned — Q131 and this
   control both support it, and the target band is confirmed by an independent
   build at 0.120–0.130 m for a trunk capsule on a ~1.7 m body. **Carry the
   `leg=leg` allowance Q131 found in the same change.**
2. **Do NOT split the trunk to fix the neck.** Measured here: it does not.
   (Three capsules may still be worth having for bend, which is a different
   argument on different evidence.)
3. **Exempt the capsule pairs a pose's own declared contacts and grips
   deliberately put together** from the penetration term, or bound them
   separately. The exemption must be DERIVED from the pose's contact and grip
   lists, never a hand-written pair list — a fossil list is how a gate stops
   tracking its subject.
4. **Fix the reachability audit's criterion** in `s47_contact_offsets.gd`:
   directional reachability at the grip's own spot and blend, not 360° exposure.
   TASK_C158 was written against the old criterion and must be re-scoped before
   it is launched, or it will assert something that is false on every capsule
   humanoid including the one that works.

## On the original question: should Perchance build grappling?

**Not yet.** Its value here was the algorithm and now this control; it has no
information we need about poses. Until the penetration term stops punishing the
hold, any grappling it produced would land on scoring that drives the solver
away from correct contact. **After S48, yes** — and the thing to ask it for then
is its own pose corpus and the contact lists it declares, not motion.
