# TASK K28 — KALLI — ONE CLIP, TWELVE DIFFERENT BODIES

Study. No code, no repository access, no test command.
Owner: kalli. Deliverable: `research/K28_ONE_CLIP_TWELVE_BODIES.md`.

## Why this exists

We have twelve rigged 3D fighters and we are about to buy a small set of shared
animation clips. **One clip, retargeted onto all twelve, costs us nothing extra
— that is the whole reason the plan is affordable.** The clips are mesh-free and
their 22 bones already match the standard humanoid profile, so there is no
per-fighter conversion cost.

But the twelve are not the same body. They span a flyweight woman and a
heavyweight man — different heights, different limb lengths, different mass.
The clip does not know that. **The question this study answers is what breaks,
and what shipped games do about it.**

## The question

1. **What actually goes wrong** when one animation plays on bodies of different
   size? Name the specific failure modes, not the general worry — feet sliding
   or sinking through the floor, a punch that lands short or passes through the
   opponent's head, hands that clip into the torso, a stance that reads
   correctly on one build and bow-legged on another. For each, say **whether it
   is visible at our camera distance**: our fight camera sits 9–11 m back, 3.8–
   4.2 m up, at a 20° downward pitch, shooting over the ropes. A defect nobody
   can see at that distance is not a defect we should pay to fix.
2. **Height disparity between the two fighters.** Two men on a canvas, one 165
   cm and one 195 cm, both playing the same in-place punch clip aimed at "head
   height". Where does the taller man's fist actually go? What do games do —
   scale the clip, aim with IK, ignore it, or forbid the matchup?
3. **What shipped games actually do.** Boxing and MMA titles have solved this;
   so have team sports games with wildly different body sizes. Which approach
   wins in practice: retarget-and-accept, per-size clip sets, procedural
   correction, or constraining the roster so bodies do not differ much?
4. **The cheap fixes, ranked.** If we do nothing, how bad is it? If we do ONE
   thing, what is the highest-value single fix — foot planting, a hand-aim IK
   chain, uniform scaling of the whole clip, or simply matching each fighter's
   height to a small number of body archetypes?
5. **Does weight class save us?** Our booking already matches weight classes,
   and females never fight males. So the two bodies on the canvas are always
   roughly similar. **Does that constraint make most of this moot?** Answer
   honestly — if the answer is "yes, and you are worrying about a case your
   rules already prevent", that is the most valuable finding in the study and it
   should be the headline.

## Standards

- Cite sources: animation-programming references, retargeting documentation,
  GDC talks, engine documentation on humanoid retargeting and IK.
- **Mark what is not published as NOT FOUND.** Do not derive a tolerance and
  present it as a measured one.
- Do not write GDScript and do not propose an implementation in code.
- Rank your recommendations by cost. We are optimising for the smallest amount
  of work that makes the fight read correctly, not for correctness in the
  abstract.

## Deliverable shape

A **DECISIONS** section at the top — short typeable lines Claude can act on
without reading the body, including a one-line answer to question 5. Body and
citations below.

Push only your own `research/` deliverable. **Do not edit `HANDOFF.md`**
— Claude writes your block.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real
regardless: Claude collects the answer and writes the file below. Naming it here
is what lets `python Tools/agent_comms.py done --task K28` mean *"has this been
collected yet?"* rather than passing on nothing.

- `research/K28_ONE_CLIP_TWELVE_BODIES.md`

**The agent is not asked to create it and must not be given a git command.**
