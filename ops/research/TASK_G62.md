# TASK_G62 — Survey these five competitors, feature by feature

**Owner:** grok
**Mode:** Expert. **NEVER Build mode.**
**No checkout, no Godot, no repo test commands. Research only.**
**Reply in chat with the full text — do NOT attach a file, you have no checkout.**

The operator put these five on their Steam wishlist and asked, in their words:
*"i want these surveyd and make sure we have all their features + more"*.

## The five titles, exactly as the operator's Steam wishlist shows them

| # | title | release | reviews | price | Steam user tags |
|---|---|---|---|---|---|
| 1 | **MMA Sim King** | COMING SOON | — | — | Simulation, Immersive Sim, Sports, Martial Arts, **2D** |
| 2 | **Believr Pro Wrestling** | 29 Jan 2026, **Early Access** | MOSTLY POSITIVE | €14.79 | Simulation, Wrestling, Sports, Management, Indie |
| 3 | **PROMOTER: The Fight Game** | COMING SOON, **Early Access** | — | — | Sports, Simulation, Boxing, **Economy**, Management |
| 4 | **THE FIGHT BUSINESS: BOXING MANAGER** | COMING SOON | — | — | Simulation, Sports, **Strategy**, Management, Boxing |
| 5 | **Boxing Club Manager** | 7 Oct 2022 | **MIXED** | €34.99 | Sports, Strategy, Simulation, Boxing, Management |

Four of five are unreleased or in Early Access. **That is the most important
fact about this list**: it is a live competitive window, not a retrospective.
The one shipped title (Boxing Club Manager, 2022) sits at MIXED and is the most
expensive of the lot — find out why, because that is the failure mode to avoid.

## What I need, and the shape it must come in

**A FEATURE MATRIX. One row per feature, one column per game, plus a FightCamp
column.** That is the deliverable — not five paragraphs of review prose. Build
the row list from what the games actually advertise, not from a template.

Cover at least: roster/scouting, contracts & negotiation, finances & sponsorship,
promotion/event booking, matchmaking, training & progression, injuries, weight
management, staff hiring, facilities/gym upgrades, rankings & titles, media &
storylines, rival promotions, fighter personality/morale, career length &
retirement, save/scenario/sandbox options, modding, multiplayer, and **how the
fight itself is presented** (text, 2D, 3D, tick-by-tick, skippable).

## Where to look, in order

Steam store pages and their feature bullets; Steam reviews (positive AND
negative, and sort by most helpful); developer update posts and roadmaps on the
Steam news tab; official Discords and subreddits; any dev blog or devlog; and
for the unreleased ones, **trailers and screenshots are often the only evidence
— say so when that is all you have.**

## Labelling, because four of these are not out yet

**Label every cell: DOCUMENTED (with source), ANNOUNCED (dev says it is coming,
not verifiable), INFERRED (from a screenshot or a tag), or UNKNOWN.** An
unreleased game's feature list is a promise, not a fact, and I will make
decisions off this — do not let a roadmap bullet read as a shipped feature.
**UNKNOWN is a perfectly good answer** and much better than a guess.

## Then the two questions that matter

1. **What do all five have that FightCamp does not?** That is the parity gap.
2. **What does the ONE SHIPPED title (Boxing Club Manager, 2022) get criticised
   for in its MIXED reviews?** Rank the complaints by how often they recur. A
   competitor's negative reviews are the cheapest product research that exists.

## What FightCamp already has — compare against THIS, not a guess

A Godot fight-management game: run a gym, sign and develop fighters, bouts
simulated by a calibrated engine and presented in 3D. Shipped systems, read off
the codebase rather than remembered:

- **Roster & recruitment** — recruitment candidates and signing
- **Development** — fight camps, combo training, grades/progression, aging
- **Physical** — weight moves, weight cuts, injuries (with clearance flags)
- **Career** — ambitions, career goals, retention, fighter requests, rivalries
- **Booking** — matchmaking with weight class and sex enforcement, contracts,
  short-notice bouts, tournaments
- **World** — a media/news system, a day feed, weekly and daily advancement
- **The fight itself** — a simulation engine calibrated against published MMA
  statistics (knockdown incidence, takedown accuracy, leg-strike share, strike
  rates), a balance model, a grappling model, and 3D presentation
- about 380 automated tests (S65, 2026-09-24)
- **Caveat (S64 career walk):** the career's own fight night still shows a 2D card; the 3D
  room is reached separately. So "presented in 3D" is true of the engine, not yet of the career loop.

**The known weak half is the 3D presentation** — the operator's verdict is that
it is "painful to watch". Treat that as given; it is not what this task is about.

## Answer format

Lead with three lines: the single biggest parity gap, the single biggest
opportunity nobody in this list has taken, and whether any of these five looks
like a genuine threat. Then the matrix. Then the two questions. Under 400 lines.

Be specific or be silent. If you cannot find a game's feature set, say
**UNKNOWN** and move on — I would rather have four solid columns than five
padded ones.
