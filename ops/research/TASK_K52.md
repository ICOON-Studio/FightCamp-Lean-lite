# TASK K52 — KALLI — WHERE A PUNCH LANDS: THE POINT ON THE HEAD, THE ARM AT IMPACT, AND HOW FAR A GLOVE GOES IN

Owner: Kalli (research, no shell). Stage: S4a (the operator's "punches look fake") - forecast research for the hand
aim. Deliver as ONE markdown answer.

## Why this exists

We animate a boxing match in 3D with bought motion-capture punches performed against nobody. Measured in our room:
jabs and crosses pass 30-40 cm BELOW the opponent's head at contact and hooks pass about 30 cm wide of it. The next
build bends the striking arm toward the real target in the last instant before contact. To do that honestly we need
the REAL target: which point of the head a straight or a hook lands on, what the arm looks like at impact (how bent),
and how far the glove sinks in - today our allowance for a glove entering the target is our own guess of 5-15 cm.

## Questions (answer each with numbers where any exist)

1. **The point of impact**: for a jab, a cross, a lead hook, a rear hook and an uppercut to the head - where on the head
   real punches land (chin, jaw, cheek, nose, forehead, temple, ear), as a distribution where one exists (video
   analysis of amateur or professional bouts, instrumented mouthguard impact-location estimates), and the height of
   that point below the top of the head or relative to the chin (cm).
2. **The arm at impact**: elbow angle at impact for a jab, a cross and a hook (degrees, and whether 180 means straight),
   shoulder flexion/abduction at impact, and the fist's height relative to the puncher's own shoulder at impact (cm or
   degrees). Is a straight punch fully extended at contact, or does it land short of full extension?
3. **How far the glove goes in**: glove padding compression at impact for 10-16 oz boxing gloves (mm), soft-tissue /
   head indentation, contact duration (ms), and the fist's travel past first contact (K50 found ~11 cm of
   follow-through - is there a better or per-punch number?).
4. **The hook's path**: how wide the fist's path is (cm lateral from the straight line) and the angle it arrives at the
   head (degrees from straight ahead), for a lead and a rear hook.
5. **What games do**: how shipped fighting or boxing games make a punch meet its target (procedural hand IK toward the
   opponent, hit volumes, aim "magnetism", warping the attacker) - GDC talks, developer interviews, papers (e.g. EA
   Fight Night / EA UFC, Creed, Undisputed, Thrill of the Fight) - labelled game design, not biomechanics, with the
   numbers they give (blend times, reach limits).

## Sources wanted

Peer-reviewed biomechanics first (e.g. Whiting 1988, Kimm & Thiel 2015, Cheraghi 2014, Dinu & Louis 2020, Lenetsky
2013/2015, Walilko 2005, Viano 2005, glove impact-attenuation tests such as Smith & Hamill or Tong-Iam), then video
analyses of bouts, then coaching texts with numbers, then game-development sources. **Label every number: DOCUMENTED
(peer-reviewed / measured), SECONDARY (coaching text, secondary report, game talk), or INFERENCE.** Give the citation
(authors, year, journal or book, page/table where possible, or link and date). If a question has NO measured number
anywhere, write **NO STUDY** for it plainly - do not fill the gap with a guess.

## Format

Start the answer with the line `Collect as: K52_WHERE_A_PUNCH_LANDS.md`. Then a markdown file: `## DECISIONS` first (at
most 8 lines: the impact point for a straight and a hook with its height, the elbow angle at impact for each, the glove
compression and follow-through, and what games do - each with its label), then one section per question, then a
sources list.
