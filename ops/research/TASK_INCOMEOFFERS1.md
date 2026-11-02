# TASK INCOMEOFFERS1 - this week's early-income offers as one pure module + test (STARTECON income channels)

Model: Arena (cloud, FightCamp-lite, pure module). Discipline: BOXING (demo) - gym economy, GYMBUILD step 3.
Operator approved Ludo's S277 new-start economy (board Q-S273-7 "build the rest"). Ludo's table, verbatim:
research/ludo_rx/LUDO_S277_BLANKSTART_raw.txt L105-L114. The channel rows are already on master in
`Godot/scripts/rules/StartEconomyRules.gd` `income_channels()` (L126) and `channel_pay(id, quality01)`. THIS task decides WHICH offers the
player sees in a given week; a later Cursor task shows them as office / Day Plan offers and Claude wires the accept into the career.

## Spec - Godot/scripts/rules/IncomeOffers.gd (new, extends RefCounted; preload only rules/StartEconomyRules.gd; no file I/O; all
## randomness from a passed-in seed through RandomNumberGenerator)
`static func weekly_offers(week: int, facts: Dictionary, seed: int) -> Array` - one Dictionary per offer:
{"id", "label" (plain English, Ludo's names), "pay": int, "day": "Mon".."Sun" or "", "cost": String (plain words), "fatigue": int,
"expires_day": String}. Rules per channel (Ludo's table):
- pad_session "Morning pad session": up to 3 offers, one each on Tue / Thu / Sat; needs facts.coach_or_owner_minutes >= 90 per offered
  day (always true while the owner coaches - the caller passes it); cost "90 min of coach time"; pay = channel_pay(quality01).
- bag_circuit "White-collar evening bag circuit": max 1 a week, days Mon / Wed / Fri (one block); needs facts.heavy_bags >= 1;
  cost "heavy bags locked 2 h".
- sparring_hire "Travelling sparring hire": max 1 a week; needs facts.boxers >= 1; fatigue 25; cost "your boxer takes 25 fatigue".
- banner_sponsor "Local business banner": once per 4 weeks (facts.last_banner_week, missing = never: offered when week -
  last_banner_week >= 4); needs facts.wall_space == true; pay 800 upfront, label shows "$800 (4 weeks)".
- short_notice_undercard "Short-notice undercard": at most ONE in weeks 1-4 (facts.undercards_taken_month1 < 1), on a seeded week;
  needs facts.boxers >= 1; cost "fought on 3 days' prep". After month 1: `const UNDERCARD_CHANCE_AFTER_MONTH1 := 0.0  ## OPEN for Ludo
  - his table gives no rate after month 1` (keep it a named constant so Ludo's number drops in).
- quality01 for every pay = clamp(facts.quality01, 0, 1) (missing = 0.5): `## OPEN for Ludo - what sets the yield inside its range`.
- Same (week, facts, seed) -> identical Array (determinism). Unmet needs -> that channel simply absent, never an offer with pay 0.

## Test - Godot/tests/income_offers_test.gd (extends SceneTree, PASS/FAIL lines, last line `INCOME_OFFERS failures=<n>`, quit(1) on any)
Each channel both sides of its need (heavy_bags 0 vs 1, boxers 0 vs 1, wall_space false vs true, minutes 89 vs 90); pad days exactly
Tue/Thu/Sat and never more than 3; banner at week-last 3 (absent) vs 4 (present); undercard: exactly one across weeks 1-4 for a fixed
seed, none when undercards_taken_month1 == 1, none in week 5-8 while the constant is 0.0; pay inside each channel's min..max and equal
to channel_pay at quality 0 / 1; determinism (two calls equal) and a different seed may differ. Mutant check: flip one `>=` to `>` in
your head - a boundary case must catch it.

## Contract
OWNS: Godot/scripts/rules/IncomeOffers.gd, Godot/tests/income_offers_test.gd
RED_TEST: Godot/tests/income_offers_test.gd -> INCOME_OFFERS failures=0
REGRESSION: start_economy_rules_test
VISUAL: no

PR body: `RESULT: tests/income_offers_test.gd -> INCOME_OFFERS failures=0` + the regression's last line. Never delete or weaken a test.

## Prior research
LUDO_S277_BLANKSTART_VERDICT.md (approved), ludo_rx/LUDO_S277_BLANKSTART_raw.txt L105-L120 (table + example week 2 ledger),
TASK_STARTECON1.md (the rows), MGT2_STUDY_S277.md, GDSCRIPT_TRAPS.md (Variant `:=`, integer division).

## What would a human do?
Write the five rows' needs as a table first, one boundary test per need, then the week loop with one seeded RNG.

## Prefab check
None - our own approved numbers.

## The one trap
Pure module only: do NOT touch GameState.gd, any scene or data file. No preloads in the test except the two rules modules.
