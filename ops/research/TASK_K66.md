# TASK_K66 — KALLI — HOW MANY ATTRIBUTES DOES A FIGHTING GAME ACTUALLY USE?

**Agent:** Kalli (research) · **No shell, no checkout, no repo paths.**
Answer in full in the research room and land the memo as
`K66_ATTRIBUTE_SYSTEMS_IN_SHIPPED_GAMES.md`.

---

## THE QUESTION

Our game stores **seven** numbers for a fighter: power, technique, speed, defense,
conditioning, fight IQ, grapple. We think that is too few and we are deciding what to add.

**Survey what SHIPPED games actually use.** Not what reviewers say, not what a wiki
summarises — the attribute lists themselves, from the games' own screens and documentation.

## THE GAMES

**Management / simulation** (closest to us — a career, not a controller):
- Football Manager (any recent edition) — the canonical deep-attribute system
- Undisputed (boxing)
- World Championship Boxing Manager 2
- Title Bout Championship Boxing
- Wrestling Empire / Fire Pro Wrestling World
- any MMA manager sim you can find with a published attribute list

**Action games with a career layer** (they solve the same display problem):
- EA Sports UFC (any edition)
- WWE 2K (any edition)
- Boxing: Undisputed's fighter editor if it differs from the sim layer

## WHAT TO REPORT, PER GAME

| field | meaning |
|---|---|
| game + edition + year | exactly which one you looked at |
| **how many attributes** | the count |
| **the full list** | every attribute name, verbatim |
| **the grouping** | how the game buckets them (physical / mental / technical...) and how many buckets |
| **the scale** | 1-20? 0-100? letter grades? |
| **what the profile screen shows** | all of them at once, a summary, a radar, or grouped tabs |
| **hidden attributes** | does it store things it does not show the player? |
| source | where you read it — the game's own screen, its manual, official docs |

## THE THREE THINGS WE ACTUALLY NEED DECIDED

1. **Is there a usable range?** What is the low end and the high end of attribute counts among
   games people actually play, and is there a cluster? Seven vs thirty-five is the question.
2. **How does a game with 30+ attributes DISPLAY them without drowning the player?** This is
   the part we most need. Tabs? Groups with a roll-up score? A radar of six summary axes with
   detail behind them? **Describe the actual layout**, screen by screen, for the two or three
   that do it best.
3. **What do the best of them do about WEAKNESS?** Does the display make a fighter's worst
   quality obvious, or does it bury it in a wall of numbers? A fighter's weak spot is the
   interesting part, and we want to know who shows it well.

## WHAT NOT TO DO

- **Do not recommend an attribute list for our game.** No "I suggest", no groupings invented
  for us. You are reporting what exists.
- **Do not fill a gap with a guess.** If you cannot find a game's real attribute list, write
  **NOT FOUND** for that row and move on. A wrong list is worse than a missing one.
- **Do not rank the games by quality.** Report what they do.

## DELIVERABLE

`K66_ATTRIBUTE_SYSTEMS_IN_SHIPPED_GAMES.md`, with one table row per game, the full attribute
lists written out, and a short section answering the three questions above. Put a SOURCES list
at the end naming where each attribute list came from.
