# TASK_K69 — The "+ more" half: what these games are asked for and do not have

**Owner:** kalli
**Deliverable: PASTE THE FULL TEXT IN CHAT. Do NOT attach a file.** Your K68
arrived as a 15 kB attachment and could not be collected — attachments in this
group never reach the repo and the tool cannot download them. If it will not fit
in one message, split it and head each part `PART 1 of N`, then keep going
without waiting.
**No checkout, no Godot, no repo test commands. Research prose only.**

## Why you, and how this differs from K68

K68 was excellent and it is already in the repo. It surveyed the ESTABLISHED
titles — WMMA5, Title Bout, Boxing Manager, LEATHER, Pound for Pound — and
concluded that buyers of this genre reward management depth and believable
outcomes over 3D presentation.

**This task is the other half, and it is deliberately NOT a feature survey.**
Another agent is building the feature matrix for five specific competitors. Your
job is the demand side: **what do players of fight-management games ASK FOR and
not get?**

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

## The question

Mine reviews, forum threads, subreddits, Discord requests and wishlist comments
for **unmet demand** across this genre — including the five above and the K68
titles you already know.

1. **The most-requested missing features**, ranked by how often they recur.
   Quote the actual request where you can.
2. **The complaints that kill retention** — what makes people stop playing, as
   opposed to what makes them grumble. These are different and the difference
   matters.
3. **What the MIXED reviews of Boxing Club Manager (2022, €34.99) say.** It is
   the only shipped title in the operator's list and the most expensive; its
   negative reviews are the cheapest product research available to us.
4. **The thing nobody has built.** If there is a feature the audience keeps
   asking for and no title in the genre provides, that is the single most
   valuable paragraph you could write.

## Method — keep K68's, it is why K68 was usable

Label every claim **DOCUMENTED** (with source) or **INFERENCE**. A forum thread
proves a complaint EXISTS, not how common it is — say which you have. Sample
sizes and dates where they exist.

**I would rather have five well-sourced claims than forty assertions.**

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
- 323 automated tests

**The known weak half is the 3D presentation** — the operator's verdict is that
it is "painful to watch". Treat that as given; it is not what this task is about.

## Answer format

Lead with three lines: the most-requested missing feature, the top retention
killer, and the one thing nobody in the genre has built. Under 400 lines.

Out of scope: `HANDOFF.md`, any `.gd`, any `.tscn`, `Godot/assets/data/`. Do not
write git commands and do not try to clone anything.
