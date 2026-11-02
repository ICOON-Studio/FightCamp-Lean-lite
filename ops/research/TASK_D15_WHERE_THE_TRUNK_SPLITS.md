# D15 — YOUR OPTION B, BUILT: WHERE EXACTLY DOES THE TRUNK SPLIT?

## WHAT HAPPENED TO D13 AND D14 — both were measured, and you were half right twice

**D13's flat cap was BUILT and MEASURED on our rigs, and it does not ship.**

- The neck went **0.0% → 3.1–7.0%** exposed. That is the first non-zero neck
  reading this project has ever taken, so the cap WAS part of the blocker —
  but it is nowhere near your demo's **100%**, and `thorax` remained the
  deepest blocker at every grip spot. **Your 100% is refused on our rigs.**
- `shoulder_span` did **not move off 0.0%** at any of three blends on either
  rig. Flattening the cap does not open the clavicle at all.
- **Your self-objection was right and the measurement proved it.** The flat cap
  leaves **155 skin vertices on f01 and 162 on f02 inside NO capsule at all**,
  up to 0.0795 m outside the body — and **126 and 151 of those are
  `UpperChest`**, the shoulder girdle's own bone. You said flat caps fail the
  shoulder girdle. They do.
- **Your arithmetic was wrong past the rim, and a blind test caught it.** Your
  else-branch `sqrt(d_axial^2 + d_perp^2) - r` is the distance to a SPHERE at
  `p1` — the dome you were replacing. Past the rim the nearest point is the
  **rim circle**: `sqrt(d_axial^2 + (d_perp - r)^2)`. Worked example at
  `r = 0.14`, 0.20 m out and 0.20 m up: yours reads 0.1428, the true one
  0.2088. Not a criticism — the first branch was exactly right and it is what
  moved the neck.

**D14: you retracted half the rim objection yourself, and the retraction was
correct.** Our solver descends on penetration depth with no friction model and
no stable stacking, so by your own test the rim is a feel issue here, not a
correctness one. **Your torus fillet is recorded and deliberately NOT built** —
it would smooth an edge on a shape we are not shipping. **And your refusal rule
for a sixth anchor is adopted verbatim.**

---

## THE ONE QUESTION

**Your Q1 option B is what gets built next: the truncated bi-capsule.** Broad
lower segment, narrow upper segment, one extra capsule, distance function
unchanged, no new field. Three independent sources now demand it:

- **J43** (anthropometry, blind): the bony thoracic inlet is **45–65 × 90–110 mm**,
  so our thorax radius is **4.9–5.7×** the half-inlet AP.
- **J44** (anthropometry, blind, N=4082): the acromion sits **2.14 mm** above
  the suprasternal notch — coplanar — and **the breadth at that level is neck
  plus two shoulders, not chest.** One fat cylinder there is wrong whatever cap
  it wears.
- **S54** (measured here): three shape arms refused, `thorax` still the blocker.

**So: WHERE DOES IT SPLIT, AND WHAT ARE THE TWO RADII?**

The bones available are `Hips, Chest, UpperChest, Neck, Head, LeftUpperArm,
RightUpperArm` (plus limbs). Today `thorax` runs `Chest → Neck` with ONE radius
derived as a p80 of the Chest bone's own skin, measured along a depth axis.

Give me:

1. **`p_mid` — the split point**, as arithmetic over those bones. **It must be
   an ANATOMICAL LANDMARK, not a tuned fraction.** If your answer is a lerp,
   say what landmark that lerp lands on and why that landmark is the right one.
   Your own D14 rule applies to this as much as to an anchor: I must be able to
   refuse a split defined as "wherever makes the neck pass".
2. **The two radii, each derived, neither stored.** The lower one is presumably
   the chest depth we already measure. The upper one is the hard half — J44
   says that level is neck-plus-shoulders, so what should a single capsule
   there actually enclose, and what does it deliberately NOT enclose?
3. **What happens to `shoulder_span`.** It runs `LeftUpperArm → RightUpperArm`
   and is currently 0.0% exposed on both rigs with `thorax` blocking 128 of 128
   directions at the centre. Does a narrow upper trunk free it, or does the
   girdle need to stop being a cross-body capsule? **Predict a number before I
   measure it** — that is the part I can check you on.
4. **Which capsules become adjacent**, since `FighterCapsules.adjacent()`
   suppresses overlap reporting between declared neighbours and a new segment
   changes that graph.

## THE GATE I WILL JUDGE IT BY, SO WRITE TO IT

The change is measured on two columns, and the second is the one that refused
your flat cap:

- **exposure** — the neck and `shoulder_span`, 128 directions, both rigs.
- **orphaned skin vertices** — vertices that after the change sit inside NO
  capsule at all, grouped by the bone they are skinned to. The flat cap scored
  155 and 162. **A two-capsule trunk that orphans more than that is worse than
  what we have**, however good the exposure looks.

Note why the second column exists: a change that only REMOVES volume makes
exposure monotone — it can only improve — so exposure alone cannot show a cost.
Your bi-capsule both removes and adds, so for the first time exposure could
genuinely go the wrong way. Say which way you expect it to go.

## AND ARGUE AGAINST YOURSELF AGAIN

Your self-objections have now been right twice and half-retracted once, which
is a better record than most of the arguments in this project.

The hardest case here: **two capsules is still a barrel on top of a barrel.**
If one constant-radius capsule cannot be a rib cage, why can two? Where does
this stop — four? eight? At what point are we just building a mesh badly, and
what is the principled reason to stop at two?

## FORMAT

Prose and small tables. **No HTML demo** — and note that the rule about running
your demo before believing its numbers has now fired twice in your favour and
once against, so a figure labelled as yours-and-unverified is worth more to me
than a confident one.
