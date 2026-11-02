# G71 — A HEAD IS AN ELLIPSOID ON ALL TWELVE OF OUR RIGS. IS THAT WORTH BUILDING?

**Owner:** grok (Research / Expert mode, NEVER Build). Design judgement, not code.
**You have no checkout, no Godot and no repository.** Everything you need is
below. Do not ask for files.

## WHAT WE BUILD, IN ONE PARAGRAPH

A fighter's collision body is a set of **capsules**: each one a segment between
two bone positions, a radius, and a hemispherical cap at each end, written
`{name, p0, p1, r}` in metres. A contact solver takes two such sets and drives
one body onto the other until declared contacts touch and nothing
interpenetrates. Its inner loop is **segment-to-segment distance between two
capsules**, evaluated for every pair on every iteration — 15 capsules a side, so
225 pairs, several hundred iterations per pose. The distance test is the hot
path and it is closed-form and cheap.

## WHAT JUST HAPPENED

Today we classified every capsule by `r/L` and found the **head is not a
capsule**: its radius equals or exceeds its own length on 10 of 12 rigs. So we
**promoted it to a single sphere** centred on the skull's vertex centroid.

**Then a measurement came back that argues against what we just shipped.** All
twelve rigs, head-weighted skin vertices, axes derived from each rig's own
shoulder line:

| rig | sagittal half-extent | lateral half-extent | vertical half-extent |
|---|---|---|---|
| f01 | 0.1300 | 0.0921 | 0.1330 |
| f02 | 0.1379 | 0.1016 | 0.1389 |
| f04 | 0.1466 | 0.0903 | 0.1680 |
| f05 | 0.1381 | 0.1117 | 0.1466 |
| f07 | 0.1511 | 0.0871 | 0.1613 |
| f10 | 0.1416 | 0.1071 | 0.1402 |

**The three semi-axes differ by 31% to 86% depending on the rig, and the LATERAL
axis is the shortest on every single one.** A head is narrow across the temples
and long front-to-back — which is what human anthropometry says too: ANSUR II
male half Head Length 0.0998 m against half Head Breadth 0.0772 m, and the
source memo states plainly that *"a true head is an **ellipsoid** with three
unequal semi-axes, not one radius"*.

Our shipped sphere radius is the **p80 of vertex distance to the centroid**,
which lands at about the **sagittal** half-extent — so it is the head's LONGEST
axis applied in every direction. Median 1.28× the anthropometric half Head
Length, and up to 1.61× on one rig.

## THE QUESTION, AND IT IS A DECISION, NOT A SURVEY

**Should this engine carry an ellipsoid primitive, or is a sphere with a
better-chosen radius enough?**

Answer these four, in this order.

**Q1 — WHAT DOES THE OVERSIZED SPHERE ACTUALLY COST US?** Be concrete. A sphere
of the sagittal half-extent is roughly **3.5 cm too fat across the temples** on
our reference rig. Name the consequences that follow from that in a fight
engine: strikes registering early, a hand unable to close on a neck that the
head's phantom bulk is covering, two heads colliding when they should pass. Rank
them. **Which of these would a viewer actually SEE?** That ranking is the whole
decision, because a defect nobody can see is not worth a hot-path change.

**Q2 — WHAT DOES AN ELLIPSOID COST TO ADD?** Ellipsoid-to-capsule and
ellipsoid-to-ellipsoid distance have **no closed form** — unlike segment-to-
segment, which is a handful of dot products. Name the standard approaches (exact
iterative, support-mapping / GJK, affine-transform-to-a-sphere, a polytope
approximation), and for each say what it costs **per pair per iteration** and
what it costs in **implementation risk**. **Be specific about the
affine-transform trick** — scaling space so the ellipsoid becomes a unit sphere
is the cheap-looking route, and we need to know exactly where it breaks when the
OTHER object is a capsule that gets sheared by the same transform.

**Q3 — WHAT DO SHIPPING ENGINES ACTUALLY DO?** Unreal's Chaos, Unity's PhysX,
Bullet, Havok. Does any of them offer an ellipsoid collision primitive at all?
If they overwhelmingly do not, **say so plainly and say why** — that is a
stronger answer than a survey, and it is the sort of negative result we act on.

**Q4 — YOUR RECOMMENDATION, IN ONE SENTENCE, WITH ITS FALLBACK.** One of:
(a) ship the sphere, pick a better radius, and name which of the three
half-extents or which percentile; (b) build the ellipsoid, and name the
approach from Q2; (c) something else, named exactly. **A menu is not an answer
— decide, then name the fallback if your first choice proves impossible.**

## AND THEN ARGUE AGAINST YOURSELF

**This is the half of the brief that has produced the shipped answer four times
here**, including a rule where the converged self-objection beat all three
options the agents were offered. Your own G70 raised a refusal rule against your
own design unprompted, and it was right.

So: make the strongest case **against your Q4 answer**. If you said sphere,
argue for the ellipsoid. If you said ellipsoid, argue that we are about to spend
a week of hot-path engineering on 3.5 cm that nobody will ever see. Name the one
measurement that would change your mind.

## ONE CONSTRAINT ON ANY ANSWER

**Whatever you recommend must scale with stature.** Our roster is twelve
fighters from 1.58 m to 1.93 m, male and female, and a constant in metres that
was picked on one of them is a constant that is wrong on the other eleven.

## WHAT TO SEND BACK

The memo as your reply text — headings, tables, the four answers and the
self-objection. **Send it as TEXT in the message.** An attachment alone does not
reach our repository.
