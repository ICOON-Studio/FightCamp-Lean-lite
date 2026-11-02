# TASK J2 — THE FEDERATION PATHWAY: HOW YOU GET IN, AND WHO PAYS (John)

**Status: OPEN.** No dependency — start whenever.

Model: top tier, effort high, Fast off.

Second task of the RULES AND JUDGES arc. J1 established what each of the 18
organizations fights *under*. J2 establishes how a fighter gets *into* the
four federations and the one tournament operator, and what it costs them.
This study is what R40 is written from.

## Why this exists

The catalog is honest — 13 promotions, 4 federations, 1 tournament_operator,
each with a real definition in the `entity_types` block. The game ignores it.
`entity_type` is copied in `WorldPopulation.gd:254` and handed to sponsors in
`Sponsorship.gd:224`, and **nothing branches on it**. The org pool filters by
country only (`GameState.gd:585`), every merged org "receives its own opening
event" (`WorldPopulation.gd:174`), and `get_promotion_bout_offer`
(`GameState.gd:5492`) builds a purse and a win bonus for any organization id.

So today the **IJF signs you to a contract and pays you a purse exactly like
the UFC**. So does World Taekwondo. So does IBJJF — an organization you in
reality *pay* to enter.

The operator's ruling (2026-09-06): this is a **behaviour** distinction, not
an identity one. One organizations table, one `Sanctioning` resolver, three
pathways. Your job is to establish what those three pathways actually are.

## Scope: five organizations

`ijf`, `united_world_wrestling`, `world_taekwondo`, `cyprus_mmaf` (federations)
and `ibjjf` (tournament operator). The 13 promotions are the baseline the game
already models — cover them only where a federation contrast needs them.

## What to answer

### 1. How a fighter gets in

Per organization: what actually puts an athlete on the mat. National
federation membership and licensing? A ranking list? A qualification event? An
open entry anyone can pay for? A national team selection made by someone other
than the athlete? Name the gate, name who controls it, and say how far in
advance it is decided.

Where an athlete competes **for a country rather than for themselves**, say so
plainly and say what that implies for a manager who has one fighter.

### 2. The money, and which direction it flows

This is the part the game has backwards. Per organization:

- Is there a purse at all? A win bonus? Prize money at the championship only?
- Entry fees — IBJJF's are published. Registration, membership, annual
  licence, belt/grade fees, travel.
- Stipends, national funding, Olympic-programme support, medal bonuses paid by
  a national body rather than the federation.
- What a realistic *year* costs a competitor versus what it pays.

Cite figures where they are published and say **UNKNOWN** where they are not.
J1's UNKNOWN policy stands: never invent a number.

### 3. Exclusivity

Does competing here stop a fighter competing elsewhere? Promotional contracts
are usually exclusive; federation competition usually is not. Establish which
combinations are real (an IBJJF competitor who also takes ONE grappling bouts;
a judoka who does not fight MMA; a wrestler who leaves for MMA entirely) and
which are not. Amateur/professional status boundaries matter here — say where
turning pro closes a door.

### 4. What a win is worth

A promotion win moves you up the promotion's rankings toward its belt. What is
the equivalent here? Ranking points, world-championship seeding, continental
qualification, an Olympic cycle, a medal, a circuit season, a belt promotion.
Give the actual progression ladder per organization, and the calendar it runs
on — federations run cycles, not cards.

### 5. What this means for a manager game

The part only you can answer, and the part R40 is cut from:

- Is a federation career **playable** in FightCamp's manager frame, or is it
  scenery the player reads about? Defend the answer either way.
- If playable: what does the player actually decide week to week? Entering a
  tournament, paying a fee, choosing a qualification path, sending a fighter
  to a camp instead of a card?
- Does the game's `tier` / `reputation` model (S/A/B/C, purse multipliers)
  even fit a federation? If not, what replaces it?
- Amateur-to-professional: is the federation route a *feeder* into the
  promotions the game already models, and should the game let a fighter cross?
- **The minimum change** that stops the current lie without building a whole
  second career mode. R40 will be scoped from this line, so make it a real
  recommendation, not a range.

### 6. Issues, each with a solution

Same discipline as J1 §4. At least: brand/licensing for federation names and
Olympic marks (the IOC's are the most protected marks in sport — say what is
safe); the risk that a federation career is a mode nobody plays; how to keep
UNKNOWN economics from becoming invented ones; and what a test would assert.

## Open it with a decisions page

Five or six operator calls, each with your recommendation and one line of why,
exactly like J1's. That page is what gets read first and it is what R40 is
written from.

## What NOT to do

- No `.gd`, no `.tscn`, no edits under `Godot/assets/data/`, no `HANDOFF.md`.
  Research and proposals only. Claude writes your block.
- Do not design screens or write UI copy.
- Do not re-litigate J1. Its rules, judges and evidence grades stand; cite them
  rather than restating them.
- Do not invent a fee, a stipend, a ranking formula or a qualification quota.
- No real officials' or athletes' names as data.

## Anchors

- `Godot/assets/data/real_organizations.json` — the `entity_types` block and
  its three definitions; the 5 in scope are `ijf`, `united_world_wrestling`,
  `world_taekwondo`, `cyprus_mmaf`, `ibjjf`.
- What the game does today: `GameState.gd:585` (country-only pool),
  `:5492` `get_promotion_bout_offer` (purse + win bonus for any org),
  `:5483` `_promotion_purse_multiplier`, `:5288` `accept_signing_offer`;
  `WorldPopulation.gd:174` (every org gets an event), `:254` (`entity_type`
  copied, never read); `Sponsorship.gd:224`.
- Your own J1: `research/J1_ORGANIZATION_RULES_AND_JUDGES.md` — §1.7
  (CMMAF), §1.9 (IBJJF), §1.14 (UWW), §1.15 (IJF), §1.16 (WT) already carry
  the rules; this study is the pathway and the economics around them.
- House format: match J1's density. Tables, rulings, `file:line` anchors,
  inline citations, no filler.

## Deliverable

One file: `research/J2_THE_FEDERATION_PATHWAY.md`, plus your usual
`research/CLAUDE_LAND_NOTE_J2.md`. Push only those.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J2_THE_FEDERATION_PATHWAY.md
research/CLAUDE_LAND_NOTE_J2.md
```
