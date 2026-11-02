# TASK J18 — JOHN — THE 71% OF A FIGHT THAT IS NOT A PUNCH

Research only. No code, no repository access, no test command.
Owner: john. Deliverable: `research/J18_THE_OTHER_SEVENTY_PERCENT.md`.

## Why this exists — a number that landed an hour after J17

Your J17 rewrote our purchase list and it was right to. But a measurement
landed the same hour that exposes a gap **J17's ten roles do not cover at all**:

> **Only 28.7% of ticks in a boxing bout are inside striking range.** The other
> **71%** is spent at distance — circling, closing, retreating, resetting.

Our purchase list budgets **one clip** for all of it, called `idle`. So the
majority of what a viewer will actually watch is currently one looping stance.
That is the biggest single hole in the plan and nobody had noticed it, because
everyone was costing punches.

## What is already settled — cite it, do not reopen

- **J17 (yours): buy punch TYPE not target; NO reach variants; block and slip
  are held poses and analog leans, not purchased clips; 2–3 knockdown clips.**
- **M14/M15 (Maria): the camera is FIXED during live action** — fov 50, pitch
  −20 to −22°, eye 3.8–4.2 m, stand-off 9–11 m, shooting over the near ropes.
  So footwork is seen from a fixed elevated three-quarter angle, at distance.
- **G42, and it is not negotiable: the ENGINE owns translation, clips are
  IN-PLACE, never root motion.** Whatever locomotion we buy has to be an
  in-place cycle whose speed is matched to the sim's own movement.
- The engine already names an intent per decision tick: **close, hold, retreat,
  circle** (`FightIntent`). That is four named states, not one.

## The question

1. **How many locomotion clips does a boxing or MMA game actually carry for
   the out-of-range game?** Forward, back, lateral both ways, pivot, reset,
   bounce/stance-idle — what is the real list, and which titles publish it?
2. **Is it a clip set or a blend space?** Shipped titles may carry four or eight
   directional cycles and blend between them continuously rather than playing
   one at a time. Which is it, and does the answer change what we BUY (a blend
   space still needs its corner clips bought)?
3. **The in-place problem.** Our clips cannot carry root motion, so a forward
   cycle plays while the engine slides the body. **How badly does that read, and
   at what speeds does it break?** This is the "foot sliding" question and it is
   the one thing Maria said the elevated three-quarter angle partly masks — is
   she right, and what is the tolerance?
4. **Does the stance-idle need to change with the fight?** A fresh fighter and
   an exhausted one stand differently; so do a man who is winning and a man who
   is hurt. Do shipped titles carry multiple idles keyed to condition, and is
   that a purchase or a procedural lean? We already model stamina and per-region
   damage continuously, so we could drive it if it is worth driving.
5. **What is the cheapest set that reads as a fight at distance?** Same shape as
   J17 §7 — name the smallest locomotion list a real title got away with, and
   name the title. If Punch-Out is again the tell, say so.
6. **The ordering question, and answer it plainly:** given a fixed budget, is
   the next clip after the six punches a **seventh punch**, a **locomotion
   cycle**, or a **second knockdown**? You now have the numbers to have an
   opinion: 71% of ticks are out of range, 47.5% of scored strikes land in the
   top two distance buckets, knockdowns occur in 41.5% of bouts.

## Standards

- Cite sources; grade them the way J15 and J17 did (DIRECT / INHERITED /
  UNVERIFIED_SECONDARY / UNKNOWN). **Say NOT FOUND where it is not found** — a
  fabricated locomotion count would send real money in the wrong direction, and
  J17's refusal to invent a per-fighter SKU census is exactly the standard.
- Do not price anything, do not name a vendor, do not write GDScript.
- Do not reopen J17's decisions; this extends them, it does not revisit them.

## Deliverable shape

`J18_THE_OTHER_SEVENTY_PERCENT.md`, with a **DECISIONS** section at the top —
typeable lines Claude can act on without reading the body, including a
one-line answer to question 6 and a revised total clip count that ADDS
locomotion to J17's ten. Body and citations below.

Land it the way you landed J15/J16/J17 (deliverable plus
`CLAUDE_LAND_NOTE_J18.md`). **Do not edit `HANDOFF.md`** — Claude writes your
block.
