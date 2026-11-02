# D12 — YOUR ARM C WAS MEASURED ON OUR RIGS AND IT DID NOT TRANSFER

**Owner:** Dola. Fresh chat, your own runnable page, no Godot, no checkout.
**This is the follow-up to D11.** Your Present Ratio is now built and running in
our engine — and the first thing it did was refuse your recommendation. That is
the control working, and it is why we want you on this.

---

## WHAT YOU GAVE US, AND WHAT WE DID WITH IT

You answered Codex's objection — *"accessibility can improve by DELETING
PROTECTIVE GEOMETRY"* — with a control instead of an argument:

```
Present Ratio = measured axial extent / authored extent x 100
Pass on:  Exposure >= 90%  AND  Present Ratio >= 95%
```

We built exactly that (`CapsulePresence.gd`), wired the denominator into the rig
builder so it is captured **before** any endpoint moves, and ran all four arms
side by side on **two different rigs at two different statures** —
f01_m_box_welter @1.78 m and f02_m_box_heavy @1.88 m.

---

## THE RESULT. YOUR NUMBERS ON THE LEFT, OURS ON THE RIGHT

| arm | your rig (1.85 m) | our f01 @1.78 m | our f02 @1.88 m |
|---|---|---|---|
| **current** (no inset) | neck 0.0% exposed | `0.0% \| 100.0%` OBSCURED | `0.0% \| 100.0%` OBSCURED |
| **A** thorax+neck | `92.7% \| 7.4%` DELETED | `0.0% \| 7.4%` **ABSENT** | `0.0% \| 29.0%` **ABSENT** |
| **B** head only | `91.8% \| 91.3%` | `0.0% \| 100.0%` OBSCURED | `0.0% \| 100.0%` OBSCURED |
| **C** both | `99.4% \| 100.0%` REACHABLE | `3.9% \| 7.4%` **ABSENT** | `5.5% \| 29.0%` **ABSENT** |

**Three things in that table, and the third is the one we did not see coming.**

**1. Arm A buys us nothing.** On your rig it took the neck to 92.7% exposed. On
ours it goes 0.0% → 0.0%. The blocker changes name and nothing else: under
`current` the neck's worst blocker is `thorax`; under arm A it is **`head`**,
blocking 106 of 128 approach directions. The neck was buried from **both** sides
the whole time. It also costs us the thorax — 100% present → 53.6%, and the
thorax's own exposure falls with it.

**2. Arm C does not transfer.** `3.9% | 7.4%` against your `99.4% | 100.0%`.

**3. Arm B deletes our head capsule outright — 0.0% present on f02.** Here is
why, and it is the part we want your answer on. Our `head` is a **blob**: it
runs from the Head bone to the skull's own vertex centroid, about **0.0774 m**,
and its radius is a skull half-width — **larger than that segment**. Insetting
an endpoint by the capsule's own radius runs one end through the other. Clamped,
it collapses to a point.

**And arm B's thorax exposure went UP by 5 to 10 points on both rigs** — because
the head had stopped existing. Without your Present Ratio beside it, arm B is
the most attractive number in the whole table. **Your control caught your own
recommendation. That is the result we are reporting, and we are glad we had it.**

---

## YOU PREDICTED THIS, ONE SEGMENT EARLY

> *"The rule `boneY ± r` tapers every joint segment to a needle at both ends —
> scale this to spine, shoulders, hips, and you do not have an anatomical rig
> any more; you have a stick figure with collision balloons."*

You named the **shoulder girdle** as the case you had not tested. It broke on
the **head** instead, for exactly the reason your sentence gives.

Our researcher John reached the same boundary independently from the
anthropometry, without seeing any of this: remaining length is `L − 2r`, so
**`r/L ≥ 0.5` is a needle**. His table: clavicle `r/L ≈ 0.039` survives, upper
arm `r/L ≈ 0.170` survives, and the scapula is *"the wrong capsule abstraction"*
outright. Our neck is `r/L ≈ 0.93` and our head blob is past `1.0`.

---

## THE THREE QUESTIONS

**Q1. What is the rule for a capsule whose radius exceeds its own length?**
An endpoint inset cannot apply to it — there is no segment to inset. Is such a
thing a sphere that should be declared and measured as one, a capsule whose
**radius** derivation is wrong, or a sign that the segment boundaries themselves
are in the wrong place? Give us the decision procedure, not just the diagnosis:
what should the engine *do* when it finds one?

**Q2. Our neck is blocked from above and below simultaneously. What clears it?**
The thorax's upper cap and the head's lower ball both reach into it, and
removing either one alone leaves the other. Your arm C removed both and the neck
still read 3.9% exposed. **What actually makes a neck reachable on a rig where
`r_neck / L_neck ≈ 0.93`?** If your answer is that it cannot be done with
capsules, say so plainly — that is a useful answer and we will act on it.

**Q3. Is 0.0% even the wrong number?** Before you answer Q2, consider this: we
ran the same measurement on the **Perchance build's own rig** — a working,
shipping capsule solver with a three-way trunk and slim authored radii — and
**its neck reads 0.0% too**, buried 0.0750 m inside its own chest. An assertion
that is false on every capsule humanoid we have ever measured, including one
that ships, may not be measuring the engine at all. A real neck **is** buried in
a chest; you reach it from above and from the side, never from below or from
inside. **Should exposure be banded by approach elevation rather than swept over
a whole sphere?** We already compute the mean elevation of the usable set and
throw it away.

---

## WHAT WE NEED BACK

1. Your answer to Q1, Q2 and Q3, in that order.
2. **A runnable page that demonstrates it**, the way your D7/D11 pages did —
   with the geometry visible and the numbers printed, not asserted. We run your
   HTML before believing any number; your v4 passed every threshold with bodies
   that could not bend, and you would not want us to take this one on trust
   either.
3. **Then argue against yourself.** Name the case where your Q2 answer fails,
   the way you named the shoulder girdle unprompted in D11. That half of the
   brief has produced the shipped answer three times on this project, and your
   own self-objection in D11 is the reason we built the control that caught
   this.

**Do not assume our rig is wrong.** Two of ours and Perchance's all read the
same way, and yours is the outlier at 92.7%. If the difference is in how your
rig is authored rather than in the rule, that is the most useful single thing
you could tell us — say what your `r_neck` and `L_neck` are, and what they are
as a ratio.
