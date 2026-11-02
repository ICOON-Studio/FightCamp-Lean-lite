booked boxing: KO+TKO 46.7%, draw 5.8% (census pairs 45.0% / 11.7%)

## Q212 - The booked-bout census (S119 send-back 1 fixed)

Measures boxing on the fights the GAME books, not hand-picked even matchups.
Boots a real career (Iron Fist Gym, Las Vegas), walks the offer board week by
week for 40 weeks, and runs every tier offer through the game's own opponent
generator and FightRealtime engine with DEMO_SWITCHES on.

**S119 fixes applied:**
1. Ruleset resolved per athlete via `WORLD_DISCIPLINE_RULESET` (not hardcoded
   "boxing"). Only bouts whose resolved ruleset is boxing are counted.
2. Decision-type histogram printed. 3 judges sit for boxing (JudgePanel.gd,
   RoundScoring.gd:59).

## Population
- Gym: Iron Fist Gym (boxing primary)
- Roster: 3 fighters
  - Nasir Duarte: Light Heavyweight, **boxing**, rating 33
  - Nasir Reyes: Flyweight, mma, rating 46 (skipped - not boxing)
  - Rico Novak: Flyweight, wrestling, rating 34 (skipped - not boxing)
- Weeks: 40 (career_week 1..40)
- Boxing bouts: 120 (40 per tier: local, regional, featured)
- Non-boxing bouts skipped: 120 (the two Flyweights' offers)
- Fails: 0

## Results

| tier     | bouts | KO+TKO% | dec%  | draw% | unanim% | split% | maj% | udraw% | sdraw% | mdraw% | KD%   | mean_gap |
|----------|-------|---------|-------|-------|---------|--------|------|--------|--------|--------|-------|----------|
| local    |    40 |   35.0% | 60.0% | 12.5% |   47.5% |  0.0% | 0.0% |  10.0% |   0.0% |   2.5% | 32.5% |      5.2 |
| regional |    40 |   55.0% | 40.0% |  5.0% |   35.0% |  0.0% | 0.0% |   5.0% |   0.0% |   0.0% | 37.5% |     17.4 |
| featured |    40 |   50.0% | 35.0% |  0.0% |   35.0% |  0.0% | 0.0% |   0.0% |   0.0% |   0.0% | 22.5% |     30.9 |
| POOLED   |   120 |   46.7% | 45.0% |  5.8% |   39.2% |  0.0% | 0.0% |   5.0% |   0.0% |   0.8% | 30.8% |     17.9 |

## Decision-type histogram (S119 fix 2)

54 decisions went to the judges (45.0% of 120 bouts). **Zero splits.**

| decision_type    | count | share of decisions |
|------------------|-------|--------------------|
| unanimous        |    47 | 87.0%              |
| split            |     0 | 0.0%               |
| majority         |     0 | 0.0%               |
| unanimous_draw   |     6 | 11.1%              |
| split_draw       |     0 | 0.0%               |
| majority_draw    |     1 | 1.9%               |

The three judges **never disagree**. Every decision is unanimous or unanimous_draw,
with one majority_draw (two judges agree, one scores it even). Split decisions
are absent from the booked population.

## Comparison

| metric     | Q212 booked | U195 even pairs | BoxRec anchor |
|------------|-------------|-----------------|---------------|
| KO+TKO     | 46.7%       | 45.0%           | 47%           |
| draw       | 5.8%        | 11.7%           | 2-3% (PROXY)  |
| decision   | 45.0%       | ~43%            | -             |
| KD bouts   | 30.8%       | -               | -             |
| split dec  | 0.0%        | -               | -             |

## Findings

1. **KO+TKO is stable**: 46.7% on the booked population vs 45.0% on even
   matchups. The engine's stoppage rate is robust to the matchup mix. Both
   match the BoxRec 47% anchor.

2. **Draws dropped further**: 5.8% pooled vs 11.7% on even matchups and 9.2%
   in the previous (broken) run. The booked population includes mismatched
   fights (mean gap 17.9 rating points), which reduces draws. But 5.8% is
   still 2-3x the PROXY anchor of 2-3%. Local shows draw most (12.5%, gap 5.2),
   featured least (0.0%, gap 30.9) - the gap-draw relationship is clear.

3. **Three judges, zero splits**: JudgePanel seats 3 judges for boxing
   (RoundScoring.judge_count=3 for ten_point_must). Each judge reads the SAME
   counters (damage, knockdowns) and carries a small multiplier on SECONDARY
   criteria only (volume, control, takedowns, positions, submissions). The
   primary criteria dominate, so the panel agrees. **The three judges disagree
   0% of the time** - no split decisions, no split draws in 120 bouts.

4. **Ruleset resolution works**: The two Flyweight fighters (MMA, wrestling)
   had their 120 offers correctly skipped. Only the Light Heavyweight boxer's
   120 offers were fought under boxing rules. The game's booking path resolves
   each athlete's ruleset via their discipline, not a hardcoded value.

5. **Tier structure works as intended**: local shows have small gaps (5.2)
   and more draws; featured bouts have large gaps (30.9) and fewer draws.
   The rating_range matchmaking produces the expected skill gradient.

## Population note

Only 1 of 3 roster fighters is a boxer (Light Heavyweight). The other two
(Flyweight MMA, Flyweight wrestling) have their offers correctly skipped.
To increase the boxing population, boot multiple careers with different gyms
or run more weeks. The current 120 bouts are sufficient to see the pattern:
zero splits.

## Run command
```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q212_booked_census.gd -- weeks=40
```

## Owned files
- `Godot/tools/q212_booked_census.gd` (new tool, S119 fixes applied)
- `research/Q212_DIGEST.md` (this file)
