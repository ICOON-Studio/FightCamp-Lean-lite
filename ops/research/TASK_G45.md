# TASK G45 — GROK — THE VIEW SHOWS 66 PUNCHES AND THE CARD HAS 896

Model: Grok, **Expert** tier. Research only.
Assigned by Claude, 2026-09-10. Owner: grok.

Driven in the in-app browser by Claude. **No code, no GDScript, no module.** You
have no checkout and no Godot. Your output is prose; Claude splices it verbatim.

## The number that makes this a question

R97 landed today. It is the adapter that gathers the 20 Hz fight into beats a
screen can present, built to your own G42 rule: *show an exchange, never a
different exchange; dropping a punch from the view is not dropping it from the
card.*

**We now have the measurement, and it is much larger than G42 assumed.** In a
seeded three-round boxing bout:

- the engine emitted **896 impacts**
- the view presented **66**
- **830 were dropped** — 92.6%

G42 licensed dropping and was right to. But it argued the case at the scale of
"a broadcast does not show every punch." At 92.6% we are not omitting a punch
here and there — **the player sees roughly one exchange every fourteen seconds
while the judges score sixty-odd blows in that window.** Every downstream read is
computed from the 896, not the 66: the scorecards, the damage model, the
per-minute punch rates, the stoppage.

So: **the picture and the card are now honest but wildly different in density,
and nobody has designed the surface that sits between them.** That is this task.

## The question

**What must the screen say, and how, so that a player watching 7% of the fight is
not being lied to about the other 93%?**

## §1 — THE SHIPPED RECORD, AGAIN, BUT ON DENSITY

You covered *whether* games drop events in G42. This is *how they tell you they
did.*

- **Madden Super Sim / GameCast**: when the 3D drops out, what replaces it? What
  is the fidelity of the text/stat layer, and does it claim to be complete?
- **Football Manager's match text vs 2D vs 3D**: the same match at three
  densities. What does the commentary layer do with events the 2D pitch does not
  animate? Does FM ever show a highlight that contradicts the stats panel?
- **Out of the Park / baseball text sims**: play-by-play as the primary surface.
- **Boxing and MMA broadcast graphics themselves** — CompuBox is the important
  one. A televised fight shows every punch and *still* runs a counter, because
  the viewer cannot count. What does CompuBox display, at what cadence, and how
  is it framed (live totals, per-round, landed/thrown, power vs jab)? What is
  its known accuracy and how do broadcasters caveat it? **If CompuBox's numbers
  are contested, say by whom and how much** — that bears directly on how much
  authority our own counter should claim.
- **Any game or broadcast that explicitly signals "there was more here than we
  showed you"** — an ellipsis, a montage, a density meter, a "highlights"
  label. Named examples if they exist; say so if they do not.

## §2 — THE HONEST-SUMMARY PROBLEM

Our beat already knows, per window: how many impacts occurred (`candidates`), how
many were dropped (`dropped`), and which one was chosen and why.

- Is a visible **"12 exchanges in that minute"** style density read a good idea,
  or does surfacing the gap make it worse? Argue both sides and pick.
- Should the chosen punch be labelled as **representative** rather than
  exhaustive — and is there a shipped precedent for a game admitting that in the
  UI?
- Where does a **live running count** (CompuBox-style) sit? It is computed from
  all 896 and is therefore complete and honest. Does a complete counter beside an
  incomplete animation reconcile the two, or does it advertise the discrepancy?
- **What about the player's own eyes?** If a man is knocked down having been
  visibly hit twice, does the knockdown read as arbitrary? Is that a real risk or
  a designer's worry — is there a named case of a sim-authoritative game where
  players complained the outcome did not match what they were shown?

## §3 — THE SELECTION RULE, JUDGED

R97 chooses which single impact to show, in this order: any **knockdown** first
(earliest), then any **shocked** (earliest), then the **highest total wear**,
ties to the earliest tick.

- Is consequence-first the right ranking for a *watchable* fight, or does it
  produce a highlight reel with no rhythm — every shown punch a big one, and no
  sense of the jabbing that set it up?
- Would a broadcast editor cut it differently? What does a real fight-highlights
  package actually include, and in what proportion?
- Is there a case for sometimes showing a **representative ordinary exchange**
  instead of the biggest one — and if so, on what rule, given it must stay
  deterministic and draw no randomness?
- **The refusal check:** does any alternative you propose risk showing a
  *different* fight rather than a thinner one? Kill your own suggestions where
  they do.

## §4 — THE ROUND BOUNDARY

Between rounds the engine has the complete truth: the round's card, both totals,
the damage, the trauma. G44 (yours, today) put the corner minute here.

- Is the rest the right place to **reconcile** the round — to show the player
  what the 60 punches they did not see amounted to?
- What do broadcasts do in the corner minute, graphically? Name the standard
  package.
- Does a between-rounds summary make the live view's thinness acceptable, the
  way a half-time stats screen makes a highlights-only football broadcast
  acceptable?

## §5 — THE REFUSALS

Name the traps. I expect at least: fabricating punches to pad the animation;
speeding the clip to fit more in (you already refused this in G42 §5, cite
yourself); a density meter nobody understands; making the counter disagree with
the card; and anything that turns the honest gap into a UI apology.

## §6 — THE ONE-SENTENCE CALL

Given a 92.6% drop rate: what is the ONE thing the screen must show that it does
not show today? One sentence, then at most a paragraph.

## Deliverable

One markdown paper. Claude splices it into
`research/G45_SEVEN_PERCENT_OF_A_FIGHT.md`. Cite inline as you did in G42
and G44; anything that is shop talk rather than sourced gets **marked unsourced**
— that habit produced the single most useful line in both papers.

## The one trap specific to G45

**Do not solve this by proposing we drop fewer punches.** The drop rate is a
consequence of a 20 Hz engine meeting a screen with a 1.4-second beat, and the
engine is authoritative by ruling. The question is what the *surface* does about
a gap that is not going away.
