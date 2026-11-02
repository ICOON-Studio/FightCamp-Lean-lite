# Q211 DIGEST - boxing KO+TKO (game arm) 63.3% -> 45.0%

## Root cause
`BOXING_OUTPUT_CONTACT_LADDER` at 0.74 multiplied the clean/glancing contact
thresholds (`clean_at`, `glance_at`) too low, making it too easy for punches to
land clean. Every extra clean land feeds the shock→knockdown→KO pipeline:
shock_chance > 0 for clean head shots and liver shots, a second roll drops the
man, and a third stops the fight. The other four boxing_output constants
(CLOSE_BIAS, RANGE_MULT, JAB_USAGE_MULT, DEFENSE_BONUS) shape volume and
style but do not gate the contact→shock seam directly.

## Fix
`BOXING_OUTPUT_CONTACT_LADDER`: 0.74 → 0.60 (FightRealtime.gd:111)

## Before / after table (census: bouts=20, ruleset=boxing, switch=feint, 3 pops pooled)

### BEFORE (CONTACT_LADDER = 0.74)

| arm | sig/min | acc | finish | KO+TKO | KD_bouts | draw |
|---|---:|---:|---:|---:|---:|---:|
| all switches OFF | 5.77 | 52.9% | 33.3% | 33.3% | 20.0% | 11.7% |
| the GAME (all ON) | 10.83 | 40.6% | 75.0% | 63.3% | 45.0% | - |
| all ON minus feint | 9.24 | 39.6% | 71.7% | 65.0% | 50.0% | - |

### AFTER (CONTACT_LADDER = 0.88, first attempt, WRONG direction)

| arm | sig/min | acc | finish | KO+TKO | KD_bouts | draw |
|---|---:|---:|---:|---:|---:|---:|
| the GAME (all ON) | 12.31 | 47.7% | 98.3% | 68.3% | 53.3% | 1.7% |

Higher ladder = easier contact = MORE KOs. Direction confirmed.

### AFTER (CONTACT_LADDER = 0.60, final)

| arm | sig/min | acc | finish | KO+TKO | KD_bouts | draw |
|---|---:|---:|---:|---:|---:|---:|
| all switches OFF | 5.77 | 52.9% | 33.3% | 33.3% | 20.0% | 11.7% |
| the GAME (all ON) | 8.40 | 33.0% | 48.3% | 45.0% | 31.7% | 11.7% |
| all ON minus feint | 7.52 | 32.2% | 50.0% | 50.0% | 26.7% | 11.7% |
| only feint | 3.92 | 54.1% | 21.7% | 21.7% | 13.3% | 8.3% |

## Target check

| metric | before | after | target | status |
|---|---:|---:|---|---|
| KO+TKO | 63.3% | 45.0% | 40-55% | ✅ |
| KD_bouts | 45.0% | 31.7% | <40% | ✅ |
| acc (connect) | 40.6% | 33.0% | 27-35% (G99) | ✅ |
| finish | 75.0% | 48.3% | ~47% real (G108) | ✅ |
| draw | - | 11.7% | report only | same as OFF |

## Draw share
11.7% of all_on bouts are draws (unanimous/majority/split), identical to the
all-OFF arm. The draw share is not caused by boxing_output; it is the judge
panel's baseline rate for these three matchups at this condition level. Task
says report, not fix.

## Populations (not made identical)
Same three census matchups, unchanged:
- counter vs pressure
- out-boxer vs boxer-puncher
- swarmer vs tall

## Incidental fix
Added `const TitleHonours = preload(...)` to GameState.gd:90 - a documented
Q192 blocker that prevented all autoload-dependent tests from running in a
fresh worktree.

## Gate
- parse: FightRealtime.gd, u195_engine_census.gd, GameState.gd - 0 fails
- boxing_output_test: 1/1 pass
- fight_feint (blind + standard): 2/2 pass
- judge_panel_test: 1/1 pass
- fight_strike_whole_test: 1/1 pass
- no pinned expectations moved
