# TASK J8 — THE MEMBERS: WHO WALKS IN, AND WHAT MAKES THEM (John)

**Status: ASSIGNED 2026-09-07.** Research only. Depends on J5 (`b508488`),
J6 (`b508488`), R43 (`b300d3c`), C27 (`5afdfed`). Feeds R44 THE MEMBERSHIP,
which is assigned to Claude and awaiting the operator's go-ahead.

Model: top tier, effort high, Fast off. One delivery.

## Why this exists

J5 G3 ruled the honest post-R43 floor: **a gym lives on its training floor,
not on a cut of the purse.** J5 G1 then refused to author a sport-wide dues
number, and G24 made that a hard constraint — no sport-wide dollar without
`evidence`. R44 will ship the membership line as an **authored, labelled**
weekly credit, because that is all J5 permits.

R44 alone gives the desk a flat number. The operator's call (2026-09-07) is
that the number should **move**: a gym with a famous fighter on the roster
and a real floor of equipment in a big city should draw members that a
back-room in a small town does not. That is a demand model, and nobody has
researched whether any of it is published, customary, or pure invention.

This pack is that research. It does **not** reopen J4 E1–E3 or J5 G10: there
is still no `gym_cut`, and members are not a way to smuggle one back in.

## The four questions

**Number your decisions N1–Nn**, so nothing collides with J3's D1–D16,
J4's E1–E34, J5's G1–G34, J6's A1–A18 or J7's P-series.

### Area 1 — Demand: what actually draws a member to a combat gym
What is **published** (industry association data, franchise disclosure
documents, operator surveys, trade bodies such as IHRSA/HFA, municipal
business filings) about why people join a boxing / MMA / Muay Thai gym, and
in what proportion? Separate, in J5's voice, a **published figure** from
**CUSTOMARY trade journalism** from **UNKNOWN**.

Specifically test the operator's three hypotheses, each as its own call:
1. **Gym fame** — does a gym's own standing draw members, and is that
   measured anywhere? Live game object: `gym["reputation"]`, already exported
   as `gym_reputation` (`GameState.gd:2834`).
2. **A famous athlete on the roster** — is the "a champion trains here" halo
   an evidenced demand driver or a marketing claim? Live object:
   `leading_athlete_fame` (`GameState.gd:2844`).
3. **The coach** — is a named head coach a bigger or smaller draw than
   either? The game already has staff with their own quality.

If the evidence ranks them differently from the operator's guess, **say so**.

### Area 2 — Equipment: attraction, or capacity?
`Godot/assets/data/equipment_catalog.json` (v2) already carries
`purchase_cost`, `weekly_upkeep`, `station_capacity`, `quality_tier`,
`base_safety` and a footprint per item, and `equipment_market_filter_test.gd`
and `gym_floor_layout_test.gd` are live.

The question is which of two mechanics the evidence supports:
- **capacity** — equipment sets how many members the floor can physically
  hold and how many can train at once (hard, countable, arguably honest); or
- **attraction** — better equipment pulls members in from rival gyms (soft,
  and easy to fabricate as a multiplier).

Is there anything published on either — floor-area-per-member norms, station
ratios, occupancy or utilisation figures, equipment spend per member, what a
fit-out actually costs? Rule on whether **attraction** is shippable at all or
whether the honest model is **capacity + upkeep**, with attraction as
authored scenery. This is the most decision-shaped question in the pack.

### Area 3 — Location, and the screen that already asks for it
Career creation already makes the player pick **country → city → gym**
(`CreationFlowPanel.gd:37`; reads `GameState.get_creation_city_board()`
`:12640` and `get_creation_gym_take()` `:12670`), and
`Godot/assets/data/gym_distribution.json` already authors, per country,
`population`, `gdp_per_capita_usd`, `culture_tier` and `gym_count`.
`WorldPopulation.gd:348` already derives `talent_depth` and
`combat_popularity` from those.

What is published about location as an economic input for a gym — catchment
population, local income, **market saturation** (`gym_count` as competitors,
not as capacity), and **rent/lease cost** as the other side of the ledger?
Does the evidence support the choice at creation being an economic choice
with a real trade-off (cheap small-town rent and few members vs expensive
big-city rent and many), and can any of it be sourced, or must the whole
curve be authored and labelled? Say plainly which of the four existing
`gym_distribution.json` fields can legitimately drive membership demand and
which cannot.

### Area 4 — The shape of the number, and the ceiling
Members are a recurring revenue line, so the study must end with the shape,
not just the drivers: how many members a gym of this size plausibly holds,
what **churn / retention** does to a monthly cohort, whether joining is
seasonal, and whether dues are ever the majority of a combat gym's revenue
(as against class packages, day passes, personal training, merchandise).

Then the ceiling question, and answer it in J5's voice: **at what point does
this stop being FightCamp and become a fitness-chain sim?** J5 G17 already
ruled UFC Gym / a promotion's own facility as scenery. Name what must be
refused so the membership line stays the gym's floor, not a second career.

## What the pack must end with

- A **decisions page** up front, one recommendation and one line why per
  call, in J6's table shape.
- Every number marked **evidenced / customary / invented / UNKNOWN**, and
  every evidenced number carrying its source, in the shape C27's ledger read
  (`source ∈ {evidenced, invented, absent}`) and M8's AUTHORED chip already
  consume.
- An explicit **"do not build"** list, as J4 and J5 both carry.
- A **priority ruling**: what R44 should ship now with a flat member count,
  and what a follow-up build (R45) would need before the count is allowed to
  move. If the honest answer is that the count should never move, say that.
- **One question in plain words** for the operator, as J5 and J6 both ended.

## Constraints (not negotiable)

- **No sport-wide dollar without `evidence`** (J5 G24). An authored number is
  fine; an authored number wearing a citation is not.
- **No `gym_cut`** (J4 E3, J5 G10). Membership does not become a purse skim.
- **No default percentage** anywhere (J5 G9), including a member-growth %.
- Do not reopen J4 E1–E3, J5 G1–G18 or R40. Cite them and move on.
- Deliverable is `research/J8_*.md` plus
  `research/CLAUDE_LAND_NOTE_J8.md`. John pushes research only and
  never edits `HANDOFF.md`; Claude writes John's block.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J8_THE_MEMBERS.md
```
