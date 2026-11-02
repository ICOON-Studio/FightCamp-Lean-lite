# TASK J1 — THE ORGANIZATIONS, THEIR REAL RULES, AND THE JUDGES (John)

**Status: OPEN.**

Model: top tier, effort high, Fast off.

Welcome. You are John, research specialist, working in the Grok bot
environment alongside Maria (art) and Kalli (player-reading studies). You
push only your own deliverable under `research/` and **never edit
`HANDOFF.md`** — Claude writes your block. You write no `.gd`, no `.tscn`
and you do not edit any file under `Godot/assets/data/`; you propose data,
you do not author it.

This is the first task of a new arc the operator called for on 2026-09-06:
*"first off we need to make sure we have the real rules for every
organization and then we make the judges for each event."*

## Why this exists

FightCamp ships 18 real organizations and 30 researched competition
rulesets, and the fight simulation reads **neither of them** when it scores
a bout. It scores by DISCIPLINE. Every MMA promotion in the game — UFC,
PFL, ONE, RIZIN, Jungle Fight, LUX, ROAD FC, ARES, URCC, the Cyprus
federation — fights under one generic `mma` ruleset with one set of
scoring weights. In reality those promotions do not share a scoring system,
a round structure, a foul list, or even the number of judges.

Worse, the game has exactly **one omniscient judge**. `FightSimulation.gd`
appends ONE scorecard per round (`:2570`) and the decision sums it
(`:2682-2694`). There is no disagreement, so the sim can never produce a
split or majority decision — even though the UI already has the words for
one (`ProfileRevampPanel.gd:33` maps UD / SD / MD, and `FightLog.gd:123-127`
parses them out of imported records). Those words are currently a promise
the engine cannot keep.

Your study is what the build stages are written from. Be concrete enough
that a developer can implement from it without a second research pass.

## What to answer

### 1. The organizations, one by one

For each of the 18 in `Godot/assets/data/real_organizations.json`, establish
what it ACTUALLY runs under. At minimum, per organization:

- The ruleset and governing body it competes under (and the commission or
  sanctioning body where one applies), plus whether that differs by event,
  country or card.
- Round structure: count, length, rest, title-bout and tournament variations.
- The scoring system in full: judge count, criteria and — this matters —
  their PRIORITY ORDER, what a 10-8 requires, whether 10-10 is used, how
  draws are typed (unanimous / majority / split draw), and any system that
  is NOT round-by-round. ONE Championship's whole-bout criteria, the PFL's
  season points table, a Thai stadium's late-round emphasis, IBJJF's
  advantage/penalty hierarchy, World Taekwondo's electronic PSS, the IJF's
  ippon, UWW's freestyle/greco criteria: where a promotion genuinely differs,
  say precisely how.
- Fouls and the legality divergences that change what a fighter may throw
  (RIZIN's grounded strikes, soccer kicks, knees to a downed opponent; the
  12-6 elbow; Karate Combat's pit and its own foul set) — cross-check against
  `Godot/assets/data/technique_legality_matrix.json` and name what the
  matrix is missing.
- Weight classes actually used, and where they diverge from the game's
  `weight_classes.json`.
- Anything else that would make a knowledgeable fan say "that isn't how
  this promotion works."

**Say UNKNOWN when it is unknown.** `competition_rulesets_v2.json` already
uses that discipline (`"age_note": "not specified in source - UNKNOWN"`).
Never invent a rule to fill a gap, and cite a source for every claim you do
make — the existing catalog carries a `sources` block and yours must too.

### 2. What is missing, and what data shape fixes it

The gap in one line: an organization row today carries id, name, entity
type, headquarters, disciplines, tier, reputation, url and source — and
**not one rule**. Nothing links an organization to a ruleset.

Answer:

- What fields an organization needs so a bout knows which rules it is fought
  under, and where per-event overrides live (a promotion that runs a
  tournament night under different rounds than its main card).
- Whether the researched `competition_rulesets_v2.json` entries should
  become the machine ruleset, be merged into `combat_rulesets.json`'s
  structured `scoring_profile` shape, or sit beside it — and what breaks
  either way. Note that the researched entries carry `scoring` as PROSE
  ("10-Point Must, ≥3 judges; priority striking/grappling > aggressiveness
  > area control") which no code can read, while `combat_rulesets.json`
  carries a machine `scoring_profile` per discipline that no research
  informs. Reconciling those two is the heart of this section.
- A proposed JSON schema, written out, with one fully worked example
  organization and one fully worked ruleset. **Propose it in your document;
  do not write it into `Godot/assets/data/`.**
- Migration: 18 organizations, 30 researched rulesets, 11 playable ones and
  existing player saves. What has to happen so an in-progress career does
  not break.

### 3. The judges

This is the part the operator asked for by name, and the part that becomes
a build stage. Cover reality first, then implementation.

- **Reality:** how judging actually works per organization — who appoints
  judges, how many sit, what they are instructed to weigh and in what order,
  how the cards are collected, what produces a split, a majority, a
  majority draw. Where judging is known to be systematically criticised
  (round-by-round in a whole-fight sport, damage vs control, the takedown
  that changes nothing), say so: a fight game is more interesting when the
  judges can be wrong the way real ones are.
- **Implementation, with a recommendation.** Give the model you would build
  and defend it against the alternatives:
  - What a judge IS in data. A named persistent official with tendencies?
    A per-bout roll? Three anonymous weight-vectors? Do judges belong to an
    organization, a commission, a region? Are they generated, authored, or
    both? Do they persist across a career and build a reputation?
  - How disagreement is produced. Per-judge criteria weights, per-judge
    noise, a "what this judge notices" filter over the same round counters,
    or something else. Say how a close round becomes 10-9 one way on one
    card and the other way on another, without the result becoming a coin
    flip.
  - How this binds to what exists: `RoundScoring.gd` is pure and stateless
    and already turns per-round counters into a card for three scoring
    styles; `FightSimulation.gd` `_close_round` appends the single card.
    The smallest correct change is probably that the sim keeps an ARRAY of
    cards — say whether you agree, and what the contract should be.
  - **Ring generalship / area control.** The researched MMA scoring text
    names aggressiveness and area control as scored criteria and
    `RoundScoring`'s weights have neither. R35–R37 now give the engine a
    contested range band and a `range_owner` every exchange. Say whether
    owning the distance should score, under which organizations' criteria,
    with what weight, and how it must NOT distort the sim (a fighter who
    wins the range argument and does nothing with it should not win rounds).
  - Non-round-by-round systems: what ONE Championship's whole-bout model,
    the PFL's season points and a points-accumulation sport each need that a
    10-point-must judge does not.
  - What the player sees and controls, if anything. Does a manager know the
    judges before the bout? Is that a scouting read? Do NOT design the
    screen — Kalli or Maria will — but say what the player must be able to
    learn for the system to feel fair rather than random.

### 4. Issues, and a solution for each

Do not just list risks; land each one with a recommendation.

- **Brand and licensing.** `real_organizations.json` carries a
  `brand_assets_policy` and `entity_types`. Real promotion names are already
  in the game; real judges' names would be real people. Say what is safe to
  ship and what must be generated, and what the game should do instead where
  a real name cannot be used.
- Scope: 18 organizations × full rule detail is a lot of data. What is the
  minimum viable subset that makes the game feel real, and what is the
  order to do the rest in?
- Where the research genuinely cannot resolve a rule, what should the
  engine do by default?
- Testing: how does anyone prove a ruleset is implemented correctly? Propose
  the assertions.

## What NOT to do

- No `.gd`, no `.tscn`, no edits to `Godot/assets/data/` and no edits to
  `HANDOFF.md`. Research and proposals only.
- Do not design screens or write UI copy. That is Kalli's and Maria's work.
- Do not re-litigate R35–R37: the range system shipped and the rail is on
  screen. You may say how range should feed SCORING; you may not respecify
  the rail.
- Do not invent an unsourced rule, a judge's real name, or a statistic.

## Anchors

- Organizations: `Godot/assets/data/real_organizations.json` — 18 entries,
  keys `id, name, short_name, entity_type, headquarters_country,
  disciplines, discipline_weights, tier, reputation, official_url, source`,
  plus the file's own `brand_assets_policy` and `market_assignments`.
- Researched rules: `Godot/assets/data/competition_rulesets_v2.json` — 30
  rulesets, prose `scoring`, `win_methods`, `fouls`,
  `grounded_opponent_definition`, `medical`, `sources`.
- Playable rules: `Godot/assets/data/combat_rulesets.json` — 11 disciplines
  with the machine `scoring_profile` (`style`, `margin_wide`, `weights`,
  `zones`, `position_points`) the sim actually reads.
- Legality: `Godot/assets/data/technique_legality_matrix.json`;
  weight classes: `Godot/assets/data/weight_classes.json`.
- The judge that exists: `Godot/scripts/RoundScoring.gd` (whole file, ~120
  lines, pure) — `profile_for`, `round_points`, `card`, `throw_class`,
  `position_points`, `gap_win`, `uses_initiative`, `style`.
- The single card: `Godot/scripts/FightSimulation.gd` `_close_round`
  (`:2543-2578`, the append is `:2570`) and the decision sum (`:2682-2694`).
- The words the UI already promises: `ProfileRevampPanel.gd:33`,
  `FightLog.gd:123-127`.
- Range, if you take up ring generalship: `Godot/scripts/FightRange.gd`
  (`contest`, `intent_band`, `BANDS`) and `fight_state.range_owner`.
- Prior art for the house research format: `research/K22_RANGE_READ.md`
  and `research/M1_RANGE_VISUAL.md`. Match their density: tables,
  rulings, file-level anchors, no filler.

## Deliverable

One file: `research/J1_ORGANIZATION_RULES_AND_JUDGES.md`.

Structure it as the four sections above, and open it with a **decisions
page**: the five or six calls you are asking the operator to make, each with
your recommendation and one line of why. That page is what gets read first.

A per-organization table belongs in section 1 — one row per organization,
with UNKNOWN where it is unknown. Cite sources inline.

Push only that file. Claude writes your `HANDOFF.md` block and assigns the
build stages from your recommendations.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J1_ORGANIZATION_RULES_AND_JUDGES.md
```
