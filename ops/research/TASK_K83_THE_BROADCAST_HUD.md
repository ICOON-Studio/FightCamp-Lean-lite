# TASK K83 - the live fight's broadcast look: a scorebug a viewer reads in one glance (Kalli)
Operator 2026-10-01: "use grokbots mostly for visual refining our rooms and the arena", "everything to be integrated at
AAA game level (how pros do it, how AAA games do it, what best reviews praise)", "use icons when its possible to skip
text (with the necessary tooltip of course)". No repo: the still is attached; answer in this chat.

## Attached
`76_bout_live.png` - the live bout in today's build (1920x1080): a round clock box top-left ("R1 2:59", "CORNER - NO
INSTRUCTION"), speed buttons top-right (1X 2X 4X SIM TO RESULT), the fighter's name in the top bar. Nothing tells a viewer
who is in which corner, their records, the score, or how the round is going.

## Deliver (one answer)
1. A SCOREBUG spec as TV boxing does it (DAZN / Sky Sports / ESPN / UFC style - name the broadcaster you copy): exact
   placement in pixels on 1920x1080, sizes, the elements (corner colour bar red/blue, surname, record W-L-D, flag or
   country code, round + clock, optional knockdown pips), font sizes, colours hex, what animates and when (round change,
   knockdown, a big shot).
2. A between-rounds stat card (what punch stats appear, layout, how long it stays) and the end-of-fight card.
3. Which of today's elements to KEEP, MOVE or DROP (the corner instruction line, the speed buttons) and why.
4. Where an ICON replaces a word (with what tooltip) - e.g. knockdowns, cuts, stamina.
5. A mock image of the scorebug over the attached still, if you can make images.
No real broadcaster logos, no real fighter names. Keep it buildable from flat panels, text and simple icons.
