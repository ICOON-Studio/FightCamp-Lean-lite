# D14 — YOUR OWN OBJECTION, ANSWERED: THE SHOULDER RIM, AND THE TRUNK ANCHORS

## WHAT HAPPENED TO D13

**Your flat cap is being built and measured on our rigs today.** Q1's option A,
exactly as you gave it: `u = unit(p1 - p0)`, `d_perp`, `d_axial`, no bone moved,
no field added, stature scaling by construction. It is behind a named arm and
the control is the tree as it stands, so the two can be read side by side.

**Your `100% upper exposure` figure has NOT been taken as ours** — it is yours,
from your own demo, on your own parameters, and it is labelled that way in the
record. We are measuring it here before believing it. That is not distrust; it
is the same rule that caught your v4 passing every threshold with bodies that
could not bend.

**And the part of D13 that is driving this task is your self-objection, which
was the best thing in the document:**

> *"Flat caps fail the shoulder girdle. The dome was not just obstruction — it
> was the anatomical transition between chest and clavicle. Flattening it
> exposes the neck but creates a sharp rim where the collarbone should smoothly
> follow. Grazing the shoulder will now 'catch' instead of sliding."*

> *"Worse — we are editing the body to please the metric. When the shoulder
> blocks the clavicle, will we flatten the shoulder too? Every obstruction
> becomes geometry we trim until the number passes."*

**You were right to say it, so you get to answer it.** Three questions.

---

## Q1 — WHAT DOES "CATCH" ACTUALLY COST, AND CAN IT BE MEASURED?

You said a hand grazing the shoulder will now catch instead of sliding. Make
that precise enough to test.

A flat-capped cylinder's distance field is continuous but its **gradient is
discontinuous at the rim** — the direction to the nearest surface flips as you
cross the rim circle. Our contact solver is a descent on exactly that field.

- **Is the gradient discontinuity the mechanism you meant**, or did you mean
  something about the *shape* rather than the *field*? Say which.
- **What does a descent do when it lands on that rim?** Stall, oscillate,
  converge to the rim and stay there, or nothing unusual? Be concrete about the
  failure mode you expect, not just that there is one.
- **Name ONE number that would show it happening.** Something we can print from
  a solver run — iteration count, a pen-depth that stops improving, a contact
  point that sits on the rim circle more often than chance. One number.

**If your honest answer is that it does not matter for a descent that only ever
needs the sign and rough magnitude, say that.** A retracted objection is worth
more than a defended one.

## Q2 — THE CHEAPEST RIM TREATMENT THAT IS NOT A THIRD SHAPE

Suppose the rim does bite. Rank these by cost, and say which you would actually
do:

- **(a) Leave it.** The rim is a 2–3 cm band at the top, as you said yourself.
- **(b) Round the rim by a fixed fillet** — a torus of small radius at the rim
  circle, so the surface is smooth again but the dome does not come back.
- **(c) A shorter cylinder plus a small sphere at the notch**, which is your own
  Q3 suggestion turned into geometry.
- **(d) Shrink the radius near the top** — a truncated cone, your option C, with
  the `r1` field you already costed as "moderate".

**Constraint, and it is hard: no new stored field, and no bone moves.** (a)
through (c) can all be done as arithmetic over the existing `p0`, `p1`, `r`;
(d) cannot. If you think (d) is nonetheless right, say so and say what it buys
that (b) does not.

## Q3 — THE FIVE ANCHORS, AS ARITHMETIC

Your D13 Q4 named the replacement for gripping the neck, and two other agents
reached the same answer independently: **`trunk_upper`, `trunk_mid`,
`trunk_lower`, `head_base`, `jawline`.** That is the stage after this one and it
needs to stop being a table of names.

**Give each anchor as a position derived from bones we have**, with no new
stored field. The bones available on our rigs are:

`Hips, Chest, UpperChest, Neck, Head, LeftUpperArm, RightUpperArm,
LeftLowerArm, RightLowerArm, LeftHand, RightHand, LeftUpperLeg, RightUpperLeg,
LeftLowerLeg, RightLowerLeg, LeftFoot, RightFoot, LeftToes, RightToes`

For each of the five, give:

- the **arithmetic** — a lerp between two bones, an offset along a named axis,
  a point on a capsule's surface, whatever it is, written so it can be typed
  straight in;
- **which capsule it lives ON**, because a grip has to resolve to a surface;
- **its approach direction or cone**, if it has one — a jawline anchor gripped
  from behind the skull is not a jawline grip;
- **how it scales**, and it must scale with stature by construction rather than
  by a tuned constant.

**`head_base` is the one to be most careful with.** You defined it as
*"occipital / skull rear — NOT the neck cylinder"*, and our head is now a sphere
promoted at the skull's own vertex centroid, so "skull rear" has to be a
direction in the rig's frame rather than a bone.

---

## AND NOW ARGUE AGAINST YOURSELF AGAIN

**Your self-objections have been the most valuable part of every document you
have sent**, so this is not a formality.

The hardest version of the case against Q3: **named anchors are the same move as
the flat cap, one level up.** The neck could not be gripped, so we are replacing
the thing being gripped with five places that can be. If the anchors are chosen
because they are reachable, we have again edited the body to please the metric —
we have just moved the editing from the geometry to the vocabulary.

**Is that fair?** If it is, what distinguishes a legitimate anchor from one
invented to make a number pass? Give a rule we could apply to a proposed sixth
anchor to refuse it.

---

## FORMAT

Prose and small tables. **No HTML demo for this one** — the three questions are
design and arithmetic, and a demo we have to run before believing takes longer
than the answer is worth. If you want to give a figure from a demo anyway, label
it as yours and unverified, exactly as D13 did.
