# TASK_J33 — JOHN — WHAT DOES THE SPORT ACTUALLY MEASURE ABOUT A FIGHTER?

**Agent:** John (deep research) · **No shell, no checkout, no repo paths.**
Answer in full in the research room and land the memo as
`J33_WHAT_THE_SPORT_MEASURES.md`.

---

## THE QUESTION

Our game stores **seven** numbers for a fighter: power, technique, speed, defense,
conditioning, fight IQ, grapple. That is almost certainly too few, and we are deciding what to
add. **Do not tell us what to add — tell us what the SPORT measures**, and we will decide.

**What attributes or qualities does combat-sports analysis actually distinguish, with real
published numbers behind them?**

Cover MMA, boxing, kickboxing/muay thai, and grappling (BJJ/judo/wrestling).

## WHAT MAKES AN ANSWER USEFUL HERE

**A quality earns a place on this list only if somebody MEASURES it.** For each one give:

| field | meaning |
|---|---|
| the quality | e.g. "takedown defence" |
| what is actually measured | the statistic, with its exact denominator |
| a real number | the published value, with spread if there is one |
| the source | paper, book, or official stats provider, with sample size |
| label | **DOCUMENTED** / **INFERENCE** / **NOT FOUND** |

**Name every denominator.** "Takedown defence 65%" is meaningless without "as a share of
takedown attempts against, per UFC Stats, career minimum 5 fights". We have been burned
repeatedly by a number with no denominator.

**Where a quality is talked about constantly but never measured, say NOT FOUND and say it
loudly.** That is as valuable as a number — it tells us the attribute would be authored rather
than grounded. "Heart" and "fight IQ" are the obvious candidates; do not invent evidence for
them.

## SPECIFIC THINGS WE NEED SETTLED

1. **Is DURABILITY / CHIN a measurable quality, separate from defence?** Our engine already
   has a `chin_penalty` function taking a chin value, career knockdowns and stoppage losses,
   but no stored chin attribute. Is there published evidence that some fighters absorb more
   before being dropped, independent of how often they are hit? If the evidence is that
   knockdown resistance is mostly *accumulated damage* rather than a fixed trait, that is the
   answer and it changes what we build.
2. **Is CARDIO one thing or two?** Does the literature distinguish aerobic capacity from
   repeat-effort/power endurance in fight sports, with numbers?
3. **Does GRAPPLING decompose?** Our single `grapple` number is currently just the average of
   the other six, so it carries no information at all. What does analysis actually separate —
   takedowns, takedown defence, top control time, guard retention, submission attempts,
   submission defence, scrambles? Give the measured statistic for each you can.
4. **Is ACCURACY separate from TECHNIQUE?** Significant-strike accuracy is published per
   fighter; is there evidence it is a distinct quality rather than a product of shot selection
   and opposition?
5. **What does AGE do to each quality, and at what rate?** We already hold J10/J12 on the
   years; this is specifically about which attributes decay first and fastest, with numbers.
6. **REACH and physical frame** — already measured in the sport. Which physical measures have
   published effects on outcomes, and how big are the effects?

## WHAT NOT TO DO

- **Do not design an attribute list for the game.** No recommendations, no groupings, no "I
  suggest". You are supplying the evidence base.
- **Do not invent or estimate a number.** NOT FOUND is a complete answer.
- **Do not reuse J20's or J32's figures without re-checking them** — cite freshly.

## DELIVERABLE

`J33_WHAT_THE_SPORT_MEASURES.md` with a SOURCES table at the end: URL, who, year, sample,
what it says, and a grade (A = primary paper/official stats with sample; B = secondary
analysis; C = summary site). Same shape as your J32 memo, which was exactly right.
