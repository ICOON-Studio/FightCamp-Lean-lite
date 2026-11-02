# TASK_D7 - DOLA - IS YOUR NECK REACHABLE?

**Owner:** dola
**Delivery:** reply in chat with the numbers and the HTML you ran. No checkout.

## Why this is short, and why it decides something

D6 came back 0/13 authored, 9/13 derived, 13/13 with stature-scaled bounds, and
recommended we adopt both. We adopted the FORM of your offset rule - a gap that
is a function of the radii rather than an absolute metre - and we did not adopt
the k values, because your own note says they were "chosen to recover ~original
offsets at 1.0 m scale", which is fitting to the old number rather than deriving
a new one.

Then our own run found something your rig may be unable to see, and this task is
the one-question control for it.

**On our rig the `neck` capsule is 0.0% reachable.** We sampled 512 points around
the neck's own surface, offset outward by a hand's radius, and asked how many of
them a hand could occupy without being inside another capsule OF THE SAME BODY.
The answer was zero, on both fighters. The neck sits 0.121-0.161 m inside the
`thorax` capsule, because our thorax radius is 0.1909 m on a segment only 0.3054
m long - it is a ball whose cap covers the shoulders and the whole neck.

If that is true on our rig and false on yours, it explains the whole D5/D6
non-transfer in one number, and we stop comparing your pass counts to ours.

## What to run - one measurement, three lines of answer

For your nine-limb rig, at BOTH 1.00 m and 1.85 m scale:

1. For each limb you use as a grip target (`neck` or whatever carries the collar
   tie, plus `back`/`thorax`, `rHip`/`pelvis`, `rArm`), sample **at least 256
   points** spread over that limb's own surface, offset outward by a hand's
   radius.
2. Count a sample as REACHABLE if it lies outside every OTHER limb of the same
   body by at least the hand's radius.
3. Report **exposure %** per target, plus which limb buries it worst and by how
   many metres.

Print a table. Lead with three lines: your neck's exposure %, whether it changes
between 1.00 m and 1.85 m, and the one thing you are least sure about.

## The one thing that would make this useless

**Do not tune any radius to make the neck reachable.** The question is what your
rig ALREADY reports. If your neck is also 0% exposed, that is the more
interesting answer of the two - it means the defect was in the source build both
our rigs descend from, and it has been invisible in every pass count either of us
has ever produced.

Also report, plainly: **what is your `thorax`/`back` radius as a fraction of its
own segment length?** Ours is 0.625. A capsule whose radius exceeds half its
length is a sphere, and that single ratio may be the whole story.
