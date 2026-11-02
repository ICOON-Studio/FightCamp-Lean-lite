# G70 — NAMED GRIP ANCHORS ON THE HEAD AND NECK

**Agent:** Grok, Expert mode, in-app browser. **Delivered in 2m 28s.**
**Landed by Claude, S52, 2026-09-22.** Task:
`research/TASK_G70_TYPED_GRIP_ANCHORS.md`.

> **CAPTURED FROM THE CHAT SURFACE, NOT FROM ITS FILES.** Grok wrote
> `artifacts/G70_NAMED_GRIP_ANCHORS.md` and `artifacts/g70_grip_anchors.py` in
> its own sandbox, which we cannot reach — it has no checkout. What follows is
> the full answer as it delivered it in the chat, which contains all four
> requested deliverables. If the module file is ever wanted, ask it to print the
> file inline rather than to write one.

## WHY THIS EXISTS

The neck has been unreachable for weeks and four attempts to fix it geometrically
have now failed — see `S52_THE_PRESENT_RATIO.md`. Dola offered a second model
alongside her endpoint inset and it was never followed up: **one continuous neck
capsule for collision, plus three or four named anchor points as grip targets.**
This is that anchor set. It sidesteps the geometry fight — a named anchor does
not have to be exposed on a swept sphere, it has to be reachable **from the
directions the hold actually comes from**.

## THE ANCHOR SET

`t` is the fraction from the base of the neck to the crown. Azimuth `0°` is
anterior (facing the target's front); elevation is from horizontal.

| id | t | aspect | approach axis | half-angle |
|---|---|---|---|---|
| `nuchal_base` | 0.27 | posterior | az 0°, el +50° | 35° |
| `mid_nuchal` | 0.14 | posterior | az 180°, el +5° | 40° |
| `laryngeal` | 0.16 | anterior | az 0°, el −30° | 30° |
| `mastoid` | 0.24 | lateral | az ±70°, el 0° | 28° |

**Every cone is an ESTIMATE and it says so**, unprompted and in its own words:
*"All cones are estimates; measure from latch-frame hand vectors in the target
neck frame."* That is the measurement it names as the one that would settle
them, and we have the data for it — the 17 MediaPipe tracks with 98,136
two-person frames.

## THE HOLD MAP

| hold | anchor | hands |
|---|---|---|
| collar tie | `nuchal_base` | 1 |
| double collar tie / Thai plum | `nuchal_base` | 2 |
| rear naked choke | `mid_nuchal` | 1 (the neck hand) |
| guillotine | `laryngeal` | 1 |
| front headlock | `mastoid` | — |

**It gave front headlock its own anchor and justified it**, which was the one
judgement call in the brief: *"side latch after the head is already down, not an
occipital pinch from above."* That is the right reading — a front headlock is
taken once the head is below the shoulder line, and an occipital anchor would
put it in the same place as a collar tie.

## THE REFUSAL RULE

Refuse the hold outright on any of:

1. **cone miss** — the approach ray falls outside the anchor's half-angle,
2. **wrong hemisphere** — anterior approach on a posterior anchor or vice versa,
3. **wrong hand count**,
4. **the approach ray hits a non-target capsule** on the way in.

And two prohibitions, both of which matter to us:

- **"No snap to another hold's anchor."** A refused guillotine does not quietly
  become a collar tie.
- **"Do not shorten neighbours."** It reached that independently, with no
  knowledge of S52 — which is exactly what the three refused arms did.

## ITS SELF-OBJECTION, VERBATIM

> *"Against: the cones were chosen not to overlap, not measured. The next choke
> will not fit. Once the head flexes, bind-pose `t` and 'anterior' are no longer
> on the throat — weakest number is `mastoid` ±70°."*

**All three are real and the second is the one to act on.** The anchors are
defined on the bind pose, and a head that has flexed forward — which is exactly
the state a guillotine and a front headlock are taken in — moves the anterior
neck out from under an anchor fixed in bind space. **An anchor set has to be
defined in the neck's own frame and follow the bone**, or it describes a
position nobody is ever in.

## WHAT TO DO WITH THIS

**Do not ship it as a constant table.** Two things must happen first:

1. **Resolve the anchors in the neck bone's CURRENT frame**, not the bind pose —
   its own second objection.
2. **Measure the cones** from the paired mocap rather than keeping the
   non-overlapping estimates. It named the measurement; we have the corpus.

It is a good scaffold and its refusal rule is better than anything we had.
