# D13 — YOUR RULE SHIPPED, THE NECK DID NOT MOVE, AND THE CHEST'S DOME IS WHY

**Agent:** Dola (Cici desktop app, driven from the console by `Tools/cici/cici.py`).
**This follows D12 directly. Read the result before answering.**

## WHAT WE DID WITH D12, AND WHAT IT BOUGHT

We built your classify-on-load. Every capsule now carries its band — `SEGMENT`
below 0.25, `STOUT` to 0.50, `NEEDLE` to 1.00, `BALL` above — and the boundaries
are yours and C164's, which agreed independently.

**On our two rigs it reads exactly as you predicted.**

| capsule | f01 @1.78 m | f02 @1.88 m |
|---|---|---|
| `head` | 0.984 NEEDLE | **1.186 BALL** |
| `neck` | 0.926 NEEDLE | 0.710 NEEDLE |
| `pelvis` | 0.775 NEEDLE | 0.824 NEEDLE |
| `thorax` | 0.436 STOUT | 0.464 STOUT |

**We promoted the head to a sphere.** One departure from your rule, and we owe
you the reason: **you said `r/L >= 1.00` is "absorbed — discard the capsule
entirely"**, and we promote instead. Your reasoning holds when the containing
sphere belongs to a *neighbour*; ours is the head's **own** end cap, so
discarding it deletes the head from the body. Your other half — *"never
clamp-to-point"* — we kept exactly.

We also put the sphere at the **vertex centroid**, not at the segment midpoint
your table specifies. Our head is a `blob`: its radius is a p80 measured **about
that centroid**, not about the segment. Putting it at the midpoint would slide
the skull 0.065 m down the neck and re-bury the thing we were trying to expose.

## AND NOW THE RESULT YOU NEED, BECAUSE IT REFUSES TWO OF YOUR PREDICTIONS

**1. Promoting the head did NOT make the neck reachable.** 128 directions, both
rigs, every grip blend: **0.0% before, 0.0% after.** What changed was only the
name of the blocker.

| rig / spot | before: worst blocker | after: worst blocker |
|---|---|---|
| f01 `neck@0.50` | `head` 67 of 128 | **`thorax` 90 of 128** |
| f02 `neck@0.15` | `thorax` 89 | **`thorax` 114** |

**2. Your elevation band did not rescue it either.** You estimated the neck
would read **70–90%** over the upper hemisphere. **Measured on our rigs it reads
0.0% banded**, over 64 of 128 valid directions. Restricting the denominator
cannot help a numerator that is zero.

We shipped the band anyway, **as an instrument and never as a pass gate, exactly
as you insisted** — per region, with `clavicle` carried at the FULL SPHERE
because of your own self-objection, and an unknown region returning the full
sphere so it behaves as the code did before. Every band is labelled
`source: "estimate"` because not one of them has been measured.

## THE QUESTION

Our `thorax` capsule runs from the `Chest` bone to the `Neck` bone with a
**hemispherical cap** on each end. Its radius is **0.1231 m** (f01) and
**0.1418 m** (f02). The neck segment above it is **0.0594 m** and **0.0774 m**.

**So the chest's dome reaches roughly twice the length of the whole neck,
straight up through it.** S48 already narrowed that radius from 0.1909 to 0.1418
by deriving it on a measured depth axis and it moved the neck by **zero
directions**. The thorax is `STOUT` on both rigs, which is the band your own rule
says legitimately accepts an inset — so nothing in D12 touches it.

**Q1. Is a capsule the right abstraction for a rib cage at all?** A real thoracic
inlet is roughly a hand's width; a hemisphere of radius 0.14 m is not. Name what
you would use instead — a tapered volume, two stacked capsules, a box, a
truncated shape — and say what it costs the contact solver, which today takes
only `{name, p0, p1, r}` and computes segment-to-segment distance.

**Q2. If the answer is "keep the capsule and cap it flat", what is the exact
rule?** Give it as arithmetic over `p0`, `p1` and `r`, the way you gave D8 and
D12. **A cap is not an endpoint**, so say explicitly whether your change is a
bone move, an offset, a new field on the capsule, or a change to the distance
function — and it must scale with stature.

**Q3. What does it cost the chest's OWN collision?** Flattening the top of the
thorax removes volume that was protecting something. Tell us what stops being
covered, and whether a strike to the upper chest or a body lock would fall
through the gap.

**Q4. Is the neck worth rescuing at all?** We now have three independent results
saying a neck cannot be gripped on a capsule humanoid: ours, yours before the
fix, and a shipping third-party rig. **Make the case that the right answer is to
stop asserting on the neck and grip the TRUNK with named anchors instead** —
which is what J42 and G70 both arrived at separately. If that is the honest
answer, say so; we would rather delete a metric than ship one that is false on
every humanoid.

## THE TWO CONSTRAINTS ON ANY ANSWER

1. **A capsule endpoint is a BONE POSITION we cannot move.** Say for every change
   whether it is a bone move, an OFFSET, or a new quantity.
2. **It must scale with stature.** Our rigs run 1.78 m to 1.88 m and the roster
   is twelve.

## AND THEN ARGUE AGAINST YOURSELF

**Your self-objection on D12 was the best part of it and it is the reason the
elevation band shipped as an instrument rather than as a gate.** Do it again:
name the case where your Q1/Q2 answer will lie to us, the way you named the
clavicle. If your answer to Q4 is "keep asserting on the neck", make the
strongest case that we should not.

**RUN ANY HTML YOU WRITE BEFORE QUOTING A NUMBER FROM IT.** Your v4 passed every
threshold with bodies that could not bend, and a round-2 fix gave every limb a
single rotation about Y — which moves `head`, `neck` and `torso` by **exactly
0.00000 m**, measured. Perturb a degree of freedom and measure the displacement
before trusting it.
