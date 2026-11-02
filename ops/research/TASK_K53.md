# TASK K53 — KALLI — HOW FAR THE BODY TRAVELS IN EACH PUNCH, AND FROM HOW FAR EACH PUNCH IS THROWN

Owner: Kalli (research, no shell). Stage: S4a (the operator's "bodies overlap" and "punches look fake") - forecast
research for the strike warp. Deliver as ONE markdown answer.

## Why this exists

We animate a boxing match in 3D. Our bought punches are performed in place, so at a real distance between the men
(1.23 m, your K50) the fist falls short: 0.26-0.32 m for a jab or a cross, 0.48-0.50 m for a hook. The fix moves the
puncher's body toward the target during the punch and back after. K50 gave one number for how far a body may move -
the hip travels ~28 cm in a maximal straight (Cheraghi 2014) - and we use it for every punch. A hook thrown from long
range is not how boxing works, so we need the travel PER PUNCH TYPE and the distance each punch is thrown from.

## Questions (answer each with numbers where any exist)

1. **Hip / pelvis / centre-of-mass travel toward the target** from the start of the punch to impact, and back after,
   for a jab (with and without a step), a cross, a lead hook, a rear hook and an uppercut (cm, and the time it takes).
2. **Front foot and rear foot travel**: how far the lead foot steps in a stepping jab or a cross (cm), whether the rear
   foot slides or pivots, and in a hook whether either foot moves.
3. **The distance each punch is thrown from**: the distance between the two men (or from the puncher's front foot to the
   target) at the moment a jab, a cross, a hook and an uppercut is launched or lands, from bout video, motion capture of
   sparring, or lab set-ups that placed the target at a chosen distance (cm).
4. **Trunk rotation and lean** at impact for a straight and a hook (degrees), and how much of the fist's travel comes
   from the trunk and legs rather than the arm (share, %).
5. **What games do**: how fighting games move an attacker toward an opponent during a strike (lunge, root motion,
   "magnetism", motion warping) and by how much - labelled game design.

## Sources wanted

Peer-reviewed biomechanics first (e.g. Cheraghi 2014, Whiting 1988, Piorkowski 2011, Stanley 2018, Dinu & Louis 2020,
Lenetsky 2013/2015/2018, Kimm & Thiel 2015, Filimonov 1985, Turner 2011, Schortgen's ECSS work), then bout video
analyses, then coaching texts with numbers, then game-development sources. **Label every number: DOCUMENTED
(peer-reviewed / measured), SECONDARY (coaching text, secondary report, game talk), or INFERENCE.** Give the citation
(authors, year, journal or book, page/table where possible, or link and date). If a question has NO measured number
anywhere, write **NO STUDY** for it plainly - do not fill the gap with a guess.

## Format

Start the answer with the line `Collect as: K53_BODY_TRAVEL_PER_PUNCH.md`. Then a markdown file whose first line is a
`# ` title, then `## DECISIONS` (at most 8 lines: hip travel and foot travel per punch type, the distance each punch is
thrown from, each with its label), then one section per question, then a sources list.
