# Kalli - design review of the coach's whiteboard (FightCamp, S357)

You are Kalli, FightCamp's game designer (boxing gym management sim, PC, Early Access at $19.99). Review a screen that is
now IN the game. Be blunt; rank problems by how much they hurt a player's first hour.

## Prior research
Your own KALLI_CORE3_S354 review warned of "a solved week" and of 14 picks a week by hand. Miro AI said the same. Both
were acted on in update 59 (Game/research/S356_DIGEST.md, TWIST_CARDS_REVIEW_S356.md, MIRO_AI_NOTES_S356.md).

## What would a human do?
A real amateur coach writes the camp on a whiteboard: the fight date circled, the week's sessions as magnets, the hard days
marked, a sticky for whatever went wrong this week. The fighter looks at it every morning; the coach changes one or two
days, not the whole week.

## Prefab check
Not applicable (a design review, no build).

## The screen: Fighters > (fighter) > Training, "the coach's whiteboard" (update 59)
- Top: "LUCY'S CAMP", "camp week 2 of 5", a tape chip with the camp phase (BUILD / PEAK / TAPER - counted back from fight
  night), and the fight date circled in red marker: "SAT 14 MAR - vs M. Ortega, 57.0 kg".
- Middle-left: seven day columns (MON-SUN). Each day: the kind in coach's shorthand (rest / hard / engine / skill), a
  MORNING magnet (session name + I/II/III for Light/Normal/Hard; red when Hard), an EVENING magnet (pads II or sparring III,
  or "~ off"), a fatigue bar and number (red with "!" over the line). Click a morning magnet: a pick list of every session
  card; picking the coach's card again undoes it ("yours" tag on a changed day; "twist" tag on a day the twist changed).
  Hover: the day's gains, kg, fatigue, and now which card a twist replaced.
- The camp PHASE writes the default week; the player edits only exceptions (0-3 picks a week, down from 14).
- Below the days: the coach's one line for the week, dials for diet (cut/hold), learn a new move, the combo on the pads,
  and "back to the coach's week".
- Right column, THIS CAMP: each goal line (e.g. conditioning to 70, weight to 57.0 kg, the combo opened) with where the camp
  lands by fight night (green met / amber close / red short), the injury load, and the week's TWIST on a yellow sticky:
  the card's name and line, two answer buttons with their price (e.g. "Gym heating breaks - FIX IT: pay $600 now; train as
  planned / WAIT: keep the cash; every morning counts as Light"); the coach's default is marked "(coach)"; Monday locks it.
  10 choice cards now, including a rare Short-notice swap (a tougher opponent on the same night, or withdraw and end camp).
- "Test it": 20 simulated bouts against the booked opponent as a win range; tape study narrows the range; 3 uses a camp.
- Peak camp: all three goal lines met on fight night = +1 to every stat for that bout.

## Answer (max 900 words)
1. The 3 biggest first-hour problems on this screen, each with a concrete fix (what to move, cut or merge).
2. Is the weekly decision now interesting (one twist + 0-3 edits)? If not, the one change that makes it so.
3. What a player will misread first, and the word or layout that prevents it.
4. One thing to cut.
