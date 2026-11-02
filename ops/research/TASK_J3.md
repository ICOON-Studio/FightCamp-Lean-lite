# TASK J3 — THE DECISION QUEUE: WHAT WE HAVE TO RULE ON NEXT (John)

**Status: COMPLETE 2026-09-06** (landed by Claude; J4 cut from its priority ruling). No dependency — start whenever.

Model: top tier, effort high, Fast off.

Third task of the RULES AND JUDGES arc, and the one that looks past it. J1
established what the 18 organizations fight under. J2 established how a fighter
gets into the five that are not promotions, and who pays whom. Both were
written to answer a question the build had already hit.

**This one is written to find the questions before the build hits them.**

## Why this exists

The arc is closing. R38 landed today: three judges, one scoring path, and a
decision that can finally be split or majority. R39 landed the sanctioning
spine, C24 the organization read, and R40 (the entity pathways, from your J2
D6) is scoped and waiting on one operator call.

After that the game runs out of researched ground. The systems queued behind it
— the title picture, the commission, the weigh-in, what a fighter is actually
paid — are all things the game **already half-models from invention**. Every
one of them will produce an operator decision, and every one of those decisions
will be made either from evidence or from whatever seemed reasonable at 2am.

J1 and J2 both cost a stage of delay because nobody had asked first. This
study is the one that stops that happening a third time.

## Scope: four areas, then a priority ruling

Cover these four. Do not add a fifth; if you find one that outranks them, say
so in the decisions page and leave it scoped for a J4.

### 1. The championship picture

The game has rankings (R30) and booking (R33), and no theory of a title. Per
the tiers of organization the catalog actually ships:

- What makes a title fight a title fight — mandatory challengers, contender
  status, how long a champion can sit, what vacates a belt.
- **Interim titles**: when they are created, what they are worth, what happens
  when the champion returns. This is a real mechanic with real published
  precedent, and the game has no concept of it at all.
- Unification, undisputed status, and what happens when a fighter holds two
  belts in two weight classes at once.
- **The sanctioning bodies that are not promotions** — boxing's alphabet
  organizations rank and sanction but do not promote, which is a fourth
  behaviour on top of J2's three pathways. Establish whether it is genuinely
  a fourth pathway or a variant of one, and say which.
- What a ranking is computed from where it is published, and where it is
  openly discretionary. Say **UNKNOWN** rather than reverse-engineering a
  formula from results.

### 2. The commission layer: what actually stops a fighter fighting

The game lets an athlete fight whenever they are booked. In reality a licence,
a medical, and a suspension sit in front of that.

- Licensing: who issues it, what it costs, what refuses it, and whether it is
  per-bout, per-year or per-jurisdiction.
- **Medical suspensions**: the standard periods after a knockout, a technical
  knockout, a cut, and how a clearance lifts one early. This is the single
  most gameplay-relevant thing in this whole study — the game has a fight
  camp system and no reason a fighter cannot fight again next week.
- Drug testing: who runs it in the jurisdictions the game's organizations sit
  in, what a violation costs in time, and what happens to the result of the
  bout it was found around.
- Overturned results and No Contest — what turns a win into one, and what the
  record shows afterwards.
- Where this differs between an athletic commission and a self-regulating
  jurisdiction, because the game ships organizations in both.

### 3. The weigh-in

The game has weight classes and no weigh-in.

- The calendar: when the weigh-in happens relative to the bout, and where
  same-day and day-before are each used.
- **Missing weight**: the penalty, who it is paid to, what percentage is
  standard and where that is published rather than customary. What happens to
  the bout, and whether a belt can still change hands.
- Catchweight bouts: who agrees them and what they cost.
- Rehydration limits and where they are actually enforced rather than
  discussed.
- The health picture around cutting, stated as the published position of the
  bodies that have one, and **not** as a mechanic recommendation. Say plainly
  where the evidence is contested.

### 4. Fighter pay past the purse

J2 did the money for the five non-promotions. This is the other half: the 13
the game already models, where the purse is currently one number.

- The published structures: show money, win bonus, and where each is
  disclosed by law rather than reported.
- Performance and fight-night bonuses — which promotions publish them and at
  what size.
- Pay-per-view participation: what is actually known versus what is reported,
  and be brutal about that boundary.
- Outfitting and sponsorship policy: where a promotion controls what a fighter
  can wear and what that replaced. `Sponsorship.gd:224` already receives
  `entity_type` and branches on nothing — this is the evidence that would let
  it.
- What a mid-card fighter's year actually looks like against what the game
  pays one today (`GameState.gd:5492` `get_promotion_bout_offer`,
  `:5483` `_promotion_purse_multiplier`).

## What each area must produce

Per area, in this order:

1. **The decisions that are coming** — the specific operator calls this area
   will force, named as calls, not as topics.
2. **The evidence for each**, cited, with the same UNKNOWN discipline as J1
   and J2: a fee, a period, a percentage or a formula that is not published is
   **UNKNOWN**, and a national or promotional overlay is labelled as one.
3. **What the game does today**, with `file:line` anchors, and whether it is
   honest, invented, or absent.
4. **The minimum change** that would make the area honest — the J2 D6
   discipline: one concrete recommendation, not a range.
5. **Issues, each with a solution**, as in J1 §4 and J2 §6, including the
   brand/licensing constraint wherever a real body's name would be shipped.

## Open it with a decisions page, and close it with a priority ruling

The decisions page first, as always — every call with your recommendation and
one line of why. That page is what gets read.

Then, at the end, the thing only you can write after doing all four: **the
order**. Which of these four the project should research or build next, and
which can wait a year, judged on how much of it the game already gets wrong
and how much a player would feel it. Defend the order. If one of the four
turns out to be scenery — real, but not worth a mechanic — say so as plainly
as J2 §5.1 said it about the Olympic federations.

## What NOT to do

- No `.gd`, no `.tscn`, no edits under `Godot/assets/data/`, no `HANDOFF.md`.
  Research and proposals only. Claude writes your block.
- Do not design screens or write UI copy.
- Do not re-litigate J1 or J2. Cite them.
- Do not invent a suspension period, a fine percentage, a bonus figure or a
  ranking formula. UNKNOWN is a finding.
- **No real officials', athletes' or executives' names as data.** Standing rule
  for this desk since J1.
- Do not recommend a second career mode. J2 §6.2 already ruled on the
  unplayed-mode trap and it applies to every area here.

## Anchors

- `research/J1_ORGANIZATION_RULES_AND_JUDGES.md` — the 18 organizations,
  their rulesets, the UNKNOWN policy and §4.1's brand constraint.
- `research/J2_THE_FEDERATION_PATHWAY.md` — the three pathways, the
  money-flow table (§2.6), and §6.2's unplayed-mode ruling.
- `Godot/assets/data/real_organizations.json` — `entity_types`, tiers, HQ.
- What the game does today: `GameState.gd:5492`, `:5483`, `:5288`,
  `Sponsorship.gd:224`, `WorldPopulation.gd:174`, and the rankings and booking
  systems (R30, R33 — see their blocks in `HANDOFF.md`).
- R38's engine, for what a decision now is:
  `Godot/scripts/JudgePanel.gd`, `Godot/tests/judge_panel_test.gd`.

## Deliverable

One file: `research/J3_THE_DECISION_QUEUE.md`, plus your usual
`research/CLAUDE_LAND_NOTE_J3.md`. Push only those.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J3_THE_DECISION_QUEUE.md
research/CLAUDE_LAND_NOTE_J3.md
```
