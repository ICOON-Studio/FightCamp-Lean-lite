# TASK G48 — GROK — HOW FAR CAN YOU WARP A PUNCH BEFORE IT BREAKS?

Tier: **Expert**. Research only — no code, no module, no test.
Owner: grok. You have no checkout and no Godot; you are never given a repo
command. Deliver as **plain chat text**, pasted into the conversation.

## Why this exists — your G46 offered five strategies and one has been chosen

G46 named five ways to handle the disagreement between a simulation's distance
and an animation's reach. **The choice is made, and it was made on evidence
from a second desk**: no reach variants. One clip per punch, adjusted at
runtime — bounded IK, a step-in, or a warp toward the contact. The reason is
that shipped titles do it that way, and the expensive lesson is *Real Boxing*,
which captured three distances **and still needed IK**.

Your own G46 rule governs how far we may go: **warp toward the contact with
BOUNDED IK, refuse the clip rather than snapping the body, and never play a
miss against a scored hit.**

**Nobody has told us what "bounded" is in centimetres.** That number is now the
single most important unknown in the animation plan, because it decides how much
of our measured distance spread one clip can cover — and therefore how many
clips we buy.

## What we now know, and it is measured — use it, do not re-derive it

- Our engine scores strikes across a continuous band from **0.0 m to 1.1 m**
  centre-to-centre, median **0.885 m**, with **47.5% of them in the top two
  0.1 m buckets** (`[0.9, 1.1)`).
- The one animation clip we own has **0.747 m** of measured rear-hand forward
  travel — which your G47 established is the same *kind* of quantity as
  Cheraghi 2014's measured **0.66 ± 0.07 m** of guard-to-impact fist travel, and
  is *not* directly comparable to centre-to-centre separation.
- G47: a real cross also carries a **0.28 ± 0.06 m hip step**, and the guard
  already parks the fist in front of the chest.

So one clip may have to serve contacts spread over roughly **half a metre** of
centre-to-centre distance. The question is whether runtime adjustment can cover
that, and by what means.

## The question

1. **The bound, in centimetres.** How far can an IK chain pull a hand toward a
   target, off a clip authored for a different distance, before the arm reads as
   wrong — over-extended, rubbery, elbow inverted, shoulder detached? Give a
   number or a band, and say what the failure looks like at each stage past it.
2. **Which joint pays.** When the hand is dragged 15 cm further, does the
   correction live in the elbow, the shoulder, the spine, or the root? Which
   choice looks acceptable and which looks broken, and what do shipped rigs
   actually do?
3. **Warp versus step versus refuse — the ranking.** Three ways to close a gap:
   move the whole body toward the target before the punch (a step-in or
   "heat-seeking" translation), stretch the arm at the end (IK), or decline to
   play the clip. Which is used for which size of gap? **Specifically: at what
   gap does the industry stop stretching and start stepping?**
4. **Root translation is FORBIDDEN for us and this is the constraint that makes
   the question hard.** Our engine owns position absolutely — clips are
   in-place, no root motion, and the sim decides where the bodies are. So a
   "step-in" for us cannot move the body; it can only be an *animation* of a
   step over a translation the engine already performed. **Does that break the
   step-in strategy for us, and if so, does that push everything back onto IK
   and lower the usable bound?** Answer this one plainly — it is the one where
   our constraints differ from a normal game's.
5. **The vertical case.** G47 found a 195 cm man's knuckle sits 0.18–0.27 m
   above a 165 cm man's chin. That is an IK correction too, and a bigger one
   than most horizontal gaps. Is aiming *down* at a shorter opponent harder or
   easier for a rig than reaching *further*, and does it need its own answer?
6. **What does it cost at runtime?** Is bounded IK on two humanoid rigs cheap
   enough to run every frame of a fight, or is it something games apply only on
   the contact frames? We need to know which before we design around it.

## How to answer

- Cite sources: animation-programming references, IK/FABRIK/two-bone solver
  documentation, engine docs (Unreal's Motion Warping and its own punch example,
  Unity/HumanIK), GDC talks, rigging literature.
- **Where no published figure exists, say NOT PUBLISHED** and say what the
  practitioners' rule of thumb is instead, marked as such. G47 was valuable
  precisely because it separated MEASURED from NOT PUBLISHED and refused to
  dress one as the other. Do the same here.
- The deliverable is **a number or band in centimetres for question 1**, and the
  ranking for question 3. Prose supports them.
- Close with a section headed **VERDICT** answering in one line each: *how many
  centimetres of gap one clip can cover with bounded IK*, and *whether our
  no-root-motion constraint changes that answer*.

## Constraints

- Research only. Do not write GDScript. Do not propose an implementation.
- Do not reopen G46's rules, G47's metres, or the no-reach-variants decision.
- Paste the document as plain chat text — the in-app browser blocks downloads,
  so a file attachment cannot be landed.
- Verify the tier chip reads **Expert** before you submit.
