# TASK K54 — KALLI — THE TIMELINE OF A PUNCH: WHEN THE FEET, HIPS, SHOULDERS AND FIST MOVE, AND WHEN THE BODY COMES BACK

Owner: Kalli (research, no shell). Stage: S4a (the operator's "punches look fake") - forecast research for the strike
warp's timing. Deliver as ONE markdown answer.

## Why this exists

We animate a boxing match in 3D. Our bought punches are performed in place, so we move the puncher's whole body toward
the target during the punch (your K53: only the maximal cross has a measured hip travel, ~28 cm) and back after. WHEN
that body travel starts, peaks and returns decides whether the punch reads as thrown from the legs or as a man sliding
on ice. Today we ease the body from the first frame of the clip to the contact frame and give it back over the rest of
the clip - our own guess.

## Questions (answer each with numbers where any exist)

1. **Onset order**: for a jab, a cross, a lead hook and a rear hook - the time before impact (ms) at which the rear foot
   / ankle, the lead foot, the hip (pelvis), the trunk, the shoulder, the elbow and the fist each START to move and
   reach PEAK velocity (the kinetic-chain sequence).
2. **The hip's own curve**: when the hip's forward travel starts, when it is fastest and when it stops, relative to the
   fist's onset and to impact (ms); whether the hip is still moving forward at impact.
3. **After impact**: how long until the fist is back at the guard (ms), and whether and when the hips / body return
   (ms, cm) - for a single punch, and inside a combination (the second punch's start relative to the first's impact).
4. **Combinations**: inter-punch intervals for jab-cross and jab-cross-hook (ms) and whether the body resets between
   punches or keeps travelling (Piorkowski 2011 and successors).
5. **What games do**: published timing of lunge / root-motion / warp windows relative to the hit frame in fighting games
   (startup, active and recovery frames; when the attacker's body moves inside them) - labelled game design.

## Sources wanted

Peer-reviewed biomechanics first (e.g. Cheraghi 2014, Whiting 1988, Piorkowski 2011, Stanley 2018, Dinu & Louis 2020,
Menzel 2021, Lenetsky 2018, Kimm & Thiel 2015, Loturco 2016), then bout video analyses, then coaching texts with
numbers, then game frame data. **Label every number: DOCUMENTED (peer-reviewed / measured), SECONDARY (coaching text,
secondary report, game frame data), or INFERENCE.** Give the citation (authors, year, journal or book, page/table where
possible, or link and date). If a question has NO measured number anywhere, write **NO STUDY** for it plainly - do not
fill the gap with a guess.

## Format

Start the answer with the line `Collect as: K54_THE_TIMELINE_OF_A_PUNCH.md`. Then a markdown file whose first line is a
`# ` title, then `## DECISIONS` (at most 8 lines: the onset order with ms, the hip's curve, the return after impact, the
combination intervals, each with its label), then one section per question, then a sources list.
