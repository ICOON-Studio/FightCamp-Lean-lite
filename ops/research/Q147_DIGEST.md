# Q147 DIGEST — Grapple Naming Contract Test

**Branch:** `qwen/q147-named-and-legal`
**Test:** `Godot/tests/grapple_naming_contract_test.gd`

## What it measures

Five clauses over seven grappling rulesets (judo, freestyle_wrestling, greco_roman, bjj, sambo, muay_thai, mma), 8 bouts each, seeds 565000+i, two different men per ruleset with `carry_progress: true`.

1. **Coverage:** ≥85% of non-stall grapple events carry a non-empty `technique`
2. **Learned:** every named technique is in the actor's `technique_progress`
3. **Legal for ruleset:** technique's catalogue discipline is in `FightMoves.disciplines_for(ruleset_id)`
4. **Legal for phase:** ground-only catalogue techniques never name a standing/clinch event, and vice versa. Phases from the CATALOGUE node, ruleset from `disciplines_for` — never from the namer.
5. **Stalls stay unnamed:** `kind == "stall"` events have empty `technique`

Event phase field resolution: `to_stance` > `from_stance` > seat inference (ground seats → ground, over_under → clinch).

## Results on today's tree

| Clause | Status | Detail |
|--------|--------|--------|
| 1 Coverage | **RED** | 6/7 rulesets fail. Judo 12.2%, muay_thai 0.0%, bjj 49.4%, sambo 64.5%, greco 54.4%, freestyle 51.7%. Only MMA passes at 97.6%. |
| 2 Learned | GREEN | 0 violations |
| 3 Legal for ruleset | GREEN | 0 violations |
| 4 Legal for phase | **RED** | 205 violations — ground-only techniques naming standing/clinch events |
| 5 Stalls unnamed | GREEN | 0 violations |

## Non-vacuity proof

Clause 1 fails on 6 of 7 rulesets — the test is not vacuous. Clause 4 fails with 205 real violations.

## Mutant injection proof

A fake event naming ground-only technique `wrestling_gut_wrench` (phases: `["ground_top"]`) during a standing event is correctly REJECTED by the phase compatibility check.

## Key numbers

- 304 grapple nodes indexed from the catalogue
- Phase source: catalogue node `match.phases`, not the namer
- Ruleset source: `FightMoves.disciplines_for()`, not the namer
