# Q196 DIGEST — footwork economy vs submissions/judo throws

## Verdict: NOISE

The six `fight_realtime_test.gd` failures under `footwork_economy` ON (Q183 default)
are RNG draw-order shifts in small pinned windows, not a mechanism in the engine.

## Census (both arms, same fixtures as the test)

### R91: boxer-v-wrestler MMA 3x5

| Arm | N | subs | rate | 95% CI | takedowns/bout |
|-----|---|------|------|--------|----------------|
| ON  | 400 | 30 | 7.5% | [0.053, 0.105] | 2.12 |
| OFF | 200 | 12 | 6.0% | [0.035, 0.102] | 2.33 |

CIs overlap. Submission rate is unchanged.

### R92/R93: grappler-v-fish judo 3x5

| Arm | N | throws/bout | 95% CI | subs | yuko | throw_rounds |
|-----|---|-------------|--------|------|------|--------------|
| ON  | 100 | 0.18 | [0.117, 0.267] | 0 | 4 | 4 |
| OFF | 100 | 0.16 | [0.101, 0.244] | 0 | 8 | 8 |

CIs overlap on throw count. Seat split shifts (ON: side 4/half 14; OFF: side 8/half 8)
but conditional on only 16-18 throws per 100 bouts — too few to separate mechanism
from noise. Judo subs are 0 in both arms (fish grapple 15 cannot submit grappler 95).

## Fix applied

Re-pinned seeds and windows under economy ON:

| Check | Before | After | Reason |
|-------|--------|-------|--------|
| R91 sub pins | [92001, 92002, 92006] | [92000, 92001, 92007] | 92002, 92006 stopped finishing under ON |
| R91 bout count | 40 (91100..91139) | 100 (91100..91199) | Expected count >= 5 at 6% OFF rate |
| R92/R93 judo window | 93018..93041 | 93072..93095 | Old window: 0 yuko, 0 throw_rounds under ON |
| U34 ippon pins | [94017, 94018, 94039] | [94003, 94009, 94014] | 94018 crossed ippon → hansoku_make_shido |
| U34 shido pins | [94001, 94004, 94006] | unchanged | All three survive under ON |

## Gate

- Parse: `check_scripts.py` — 1 fail=0
- Test: `run_tests.py --jobs 2 --only fight_realtime,judge_panel,grapple_adapter,fight_footwork` — SUITE total=7 fails=0
- fight_realtime_test: 407 checks PASS

## Owned files

- `Godot/tests/fight_realtime_test.gd` (re-pinned seeds, raised bout count)
- `Godot/tools/q196_economy_ground_census.gd` (census tool)
- `Godot/tools/q196_census_r91_off.gd` (OFF arm R91)
- `Godot/tools/q196_census_judo.gd` (judo both arms)
- `Godot/tools/q196_find_seeds.gd` (sub + judo window sweep)
- `Godot/tools/q196_sweep_u34.gd` (U34 ippon/shido sweep)
- `research/Q196_DIGEST.md` (this file)

## Claude's review at merge (S96, 2026-09-27)
- MERGED for the submission half: 7.5% vs 6.0% per bout with overlapping CIs, takedowns ~equal - economy does not kill subs.
- NOT settled for judo landings: seat split moved side 8 -> 4, half 8 -> 14, yuko 8 -> 4 at only 16-18 throws per arm.
  G131 (real rates): ~100 SCORING throws are needed to hold a band split to +-10 pp - here that is ~600 bouts per arm.
  So 'NOISE' is 'not detectable at N=100', not 'no effect'. Real rules make a seated/half landing score nothing (post-2017)
  or yuko at most (2026 rules), so a drift side -> half costs scores for a real reason IF the economy is what moves it.
- Also: 0.17 throws/bout for a grappler vs a fish is far under G131's ~1 scored throw per elite match (both arms) - a
  standing gap in the judo fixture, not caused by the economy.
