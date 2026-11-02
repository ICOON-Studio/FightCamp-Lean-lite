# Next: the standing wrestling chain, same engine, same pose format

Not a new simulator — the same build, extended. What is wanted is the POSE
CORPUS, not another engine, because the engine is already right.

## Why standing, and why wrestling specifically

The gap that matters is **standing grappling**. Ground positions are the ones
nobody can verify: depth error in two-person video tracking blows past ±0.5 m
below knee height, so there is no way to check a ground pose against real
footage. Standing positions can be checked, from any side-on camera.

And it is the measured gap: in a corpus of 2,477 grappling events, the
clinch-engage moment is 3.8% — the single biggest visually actionable hole, and
it is entirely standing.

## The eight

Author these as two-body poses in exactly the format you already use — `mob`,
`hold`, `touch`, `anchors`, `ik` with `GA("B.<cap>", blend)`:

1. **collar tie** — one hand on the back of the neck, the other on the elbow
2. **double collar tie / Thai plum** — both hands behind the neck, elbows in
3. **underhook** — one arm inside and under his armpit, chest on chest
4. **over-under** — one arm over, one under, heads outside the same shoulder
5. **double-leg entry** — penetration step, both arms around both thighs, head
   on the outside of his hip
6. **single-leg** — one leg trapped and lifted, his hands framing down
7. **sprawl** — the defensive answer: hips down onto his shoulders, legs kicked
   back, chest flattening him
8. **front headlock** — after the sprawl: one arm under the chin, one under the
   armpit, his head below your chest

## What matters in the authoring

- **`hold` is what touches the mat.** In a sprawl it is the attacker's feet and
  the defender's hands and knees. In a standing clinch it is four feet. Say so
  explicitly per pose; do not leave it to the solver.
- **`ik` grips are where this pays.** A collar tie is not "a hand near his neck"
  — it is a hand at a PLACE on the back of the neck. Use the blend parameter to
  say where along the capsule. A contact alone cannot express that, which is
  exactly what a wrestling grip is made of.
- **Weight distribution is the whole difference between these.** An underhook
  and an over-under have nearly the same silhouette and completely different
  pressure. If `mob` carries that, set it deliberately per pose and say what
  you set it to.
- **The head position is not decoration.** On a double-leg the head is outside
  the hip; on a single it is inside. That one difference is the whole technique.
  Author it.

## Report per pose

Worst penetration, worst contact error, worst grip error, worst mat violation,
evaluation count, and the worst offending pair by name. Same thresholds:
`pen ≤ 0.006`, `touch ≤ 0.012`, `mat ≤ 0.012`.

**Do not widen a tolerance to make a pose pass.** A pose that will not solve is
more useful reported with its residuals and its worst pair named — that tells us
whether the authored pose is wrong rather than the solver.

## And start each one broken

Initialise every pose with the two bodies deliberately overlapping, so the
solver has to dig out. A pose validated from an already-good start reports
success for doing nothing.

## One thing that is NOT wanted

Do not restructure the match engine or the BJJ positions to accommodate these.
The wrestling chain should sit alongside what exists. If a standing position
already exists under a BJJ name (the clinch), extend it rather than duplicating
it, and say which you did.
