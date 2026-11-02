# J42 — IS A HEAD A CAPSULE? THE SKULL AND NECK AS COLLISION VOLUMES

**Desk:** John (research). **Paper only** — no code, no checkout, no `.gd`.
**This is the direct continuation of J41, and J41 was used the day it landed.**

## WHAT J41 DID, SO YOU KNOW WHY THIS ONE MATTERS

You measured `r/L` for the shoulder girdle and concluded that a capsule is
**the wrong primary abstraction** where `r/L` is large — clavicle `0.039`
survives a double inset, upper arm `0.170` survives, scapula-as-capsule is a
thin plate wearing the wrong shape. Your line *"do not roll the uniform inset
beyond neck without per-segment policy"* was the right call.

**The same day, independently, our own rig measurement refused the rule for
exactly that reason — and it broke on the HEAD, not the girdle.** Our `head`
volume runs from the Head bone to the skull's vertex centroid, about **0.0774 m**
on a 1.88 m fighter, and its radius is a skull half-width, which is **larger
than that segment**. Insetting an endpoint by the volume's own radius ran one
end through the other; the volume collapsed to a point and measured **0.0%
present**. Our `neck` is `L ≈ 0.0594–0.0774 m` with `r = 0.0550 m` — `r/L ≈
0.71–0.93`, which is a **needle** by your own `L − 2r` test.

So your `r/L` framework is now the project's working tool for this, and we need
it pointed at the head and neck.

## THE QUESTIONS

**Q1. What are the real adult-male dimensions, with a denominator?**
- Skull: breadth, length, height — and what a single "radius" should be if one
  is used. Cite the survey (ANSUR II is already in our record and is fine).
- Neck: **length** (which vertebral landmarks define it — that choice is half
  the answer), circumference, and therefore radius.
- Give `r/L` for both, and say **which landmark pair** each length is taken
  between. A neck measured C7-to-occiput and one measured sternal-notch-to-chin
  are different numbers and we need to know which one our 0.0594 m is closer to.

**Q2. Is our neck length wrong, or is a real neck genuinely that short?**
This is the decisive one. If a real male neck is `r/L ≈ 0.9`, then a neck is
**anatomically a squat cylinder** and no rule that insets by a radius can ever
survive on it — that is a fact about necks, not a bug in our rig. If a real neck
is `r/L ≈ 0.4`, our rig's neck segment is too short and the fix is upstream of
every rule we have been arguing about. **Say which, with numbers.**

**Q3. What shape do other systems actually use for a head and neck?**
Not what they *could* use — what shipping systems do. Ragdolls, medical
collision models, crash-test dummies (Hybrid III has a published neck geometry),
motion-capture solvers. **Is the head a sphere, a capsule, an ellipsoid, or a
mesh, and is the neck a separate volume at all?** If most systems do not give
the neck its own volume, that is a finding and we want it stated plainly.

**Q4. Where on a head/neck is a grip actually taken?**
Our engine needs a collar tie, a rear naked choke and a guillotine to be
distinguishable. A collar tie takes the upper-posterior neck and base of skull;
a rear naked choke the mid-posterior neck; a guillotine the anterior neck at
laryngeal level. **Are those three separable on the anatomy** — by height, by
aspect, by anything a geometric model could express? If they are all within
0.03 m of each other, say so: that would mean one volume plus named anchor
points, and not three volumes.

## THE RULES YOU ALREADY KNOW, RESTATED

- **A number without a denominator is not a finding.** `n`, sex, population and
  the survey, every time.
- **NOT FOUND is a result.** Say it plainly rather than reaching for a proxy.
  J38's *"the ending-mode breakdown is NOT FOUND with a denominator"* was the
  most useful line in that memo.
- **Then argue against yourself.** Name the reading of your own answer that
  would be wrong, and what would settle it.

## DELIVERABLES

- `J42_THE_HEAD_AS_A_VOLUME.md` — the memo.
- `CLAUDE_LAND_NOTE_J42.md` — the one-line ask and the deciding table.

Stage to `_john_delivery/` as usual. **Do not edit `HANDOFF.md`** — Claude
writes your block.

**If the GitHub copy would be a stub, say so in the land note and give the box
path.** J41's memo landed as a 1.1 KB stub on GitHub while the real 19 KB file
sat on the box, and it was nearly read as the whole answer.
