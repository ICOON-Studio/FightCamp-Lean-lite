# Q190 DIGEST — Sparring-Partner Market (Qwen, 2026-09-26)

## What
`Godot/scripts/SparPartnerMarket.gd` — a market module that generates fightable
sparring partners for S88's hire screen. Each partner is built from his own level
and style (not a jittered copy of the fighter), with the same contract shape
FightRealtime.begin expects.

## Contract
- `LEVELS := ["amateur", "regional", "world"]`
- `DAY_PRICE := {"amateur": [0, 80], "regional": [200, 600], "world": [400, 1200]}`
- `candidates(fighter, spec, level, seed, count=4) -> Array` — returns `count`
  partners sorted by match_pct descending. Each partner: same sex, same
  discipline, +-1 weight class, own stats/name/height/reach, id prefixed
  `"partner|"`, plus `"partner": {level, price_per_day, travel_days, match_pct}`.
- `match_pct(partner, spec) -> int` — stance +40, height within 3cm +30 (linear
  to 0 at 12cm), style +30. Empty spec keys give their share in full.
- `price(level, days, roll) -> int` — lerp of DAY_PRICE band by roll x days.
- Deterministic for a seed.

## Population
3 rulesets (boxing, kickboxing, mma) x 3 levels x 10 seeds x 4 partners = **360
candidates** tested for legality. All 360 legal (sex/discipline/+-1 class). All
90 candidate groups unique (no duplicate partners within a group).

## Sample (4 partners, boxing/regional/seed 190099)
| Name            | Match | Weight Class | Stance   | Price/day |
|-----------------|-------|--------------|----------|-----------|
| Joana Bianchi   | 98%   | Lightweight  | ORTHODOX | 400       |
| Thiago Larkin   | 100%  | Welterweight | ORTHODOX | 400       |
| (2 others)      | 70-85%| +-1 class    | mixed    | 200-600   |

## Spar runs (1 per ruleset, light intensity)
- **boxing**: 64 punches landed, partner Joana Bianchi (98% match)
- **kickboxing**: 71 punches landed, partner Thiago Larkin (100% match)
- **mma**: 153 punches landed, partner Thiago Larkin (100% match)

All spars ran through FightRealtime.begin + run_to_completion with no script
error.

## Mutants caught
1. **Wrong sex**: female partner for male fighter — caught by sex gate
2. **Identical-fighter clone**: partner with fighter's own stats+height — caught
   by uniqueness gate (stats identical, height match)

## Test
`Godot/tests/spar_partner_market_test.gd` — 10 checks, 0 failures.
Parse gate: clean. No suite (new module + new test tier).

## Owned files
- `Godot/scripts/SparPartnerMarket.gd` (new)
- `Godot/tests/spar_partner_market_test.gd` (new)
- `research/Q190_DIGEST.md` (this file)

## Notes
- Loads weight_classes.json and technique_catalog.json directly (no autoload
  dependency) so the module works even when autoloads fail to initialize.
- Name pool: 52 first names (13 female) x 15 last names, deterministic per seed.
- Rating by level: amateur=40, regional=60, world=80 (mean-preserving stat
  generation, same algorithm as FightOpponentGenerator).
