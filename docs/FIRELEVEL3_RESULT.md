# FIRELEVEL3 result (S450, Claude): move levels switched on, first-season re-measure

## What changed
- `FireLevel.GAME_SHARES = {usable 0.5, sharp 0.75, signature 1.0}`; `FireLevel.shares_for(bout)` = the bout's own `fire_level` key when
  present (a probe arm), the game's shares when absent. `FireLevel.OFF` (all 1.0) and the probes-only `FireLevel.probe_off` (an empty
  dict = today's game before S450, under-30 combinations included).
- `LiveRound.gd` (the planned-line roll) reads `FireLevel.shares_for(f["bout"])`. Steps and defences keep 100 (mastery_of): unchanged
  until STEPMASTERY1.
- `tools/fire_level_probe.gd`: every cell sets its key explicitly (`{}` = the old control), so its 41.3 % control still reads.
- `tools/career_harness.gd`: `fire=off` (the rule-off arm) and `plan=combos` (a player who writes the fighter's two most-drilled
  throwable combinations on the plan before each fight).

## The re-measure (career_harness, 20 careers x 26 weeks, both players, seeds = career index, same seeds both arms)
Command: `career_harness.gd -- n=20 weeks=26 [plan=combos] fire=off|on` through godot_slot.

| Run | Player | Gym closed | Wins a career | Bouts a career | Cash end median |
|---|---|---|---|---|---|
| coach's plan, OFF | careless | 4 of 20 (20 %) | 5.8 | 4.5 | 1,795 |
| coach's plan, ON | careless | 4 of 20 (20 %) | 5.8 | 4.5 | 1,795 |
| coach's plan, OFF | sensible | 0 | 6.2 | 4.8 | 15,135 |
| coach's plan, ON | sensible | 0 | 6.2 | 4.8 | 15,135 |
| combination plan, OFF | careless | 4 of 20 (20 %) | 5.5 | 4.5 | 1,759 |
| combination plan, ON | careless | 4 of 20 (20 %) | 5.3 | 4.5 | 1,759 |
| combination plan, OFF | sensible | 0 | 5.7 | 4.8 | 13,921 |
| combination plan, ON | sensible | 0 | 5.7 | 4.8 | 13,824 |

("Wins a career" is the record's w, which includes the fighter's record at signing; the change between arms is what counts.)

## Reading
- With the coach's own plan the rule never bites: CoachPlan.write only plans moves at full rate and, in these careers, the plan held no
  combination line (the identical rows are the instrument showing that, not a pass). The arm that can read worse is the combination
  plan: there the rule moves the result (careless -0.2 wins over 4.5 bouts, about 4 in 100; sensible unchanged).
- PASS on the brief's bars: sensible still closes 0 %, careless stays inside 5-25 % (20 %), and a new fighter's first-season drop is
  under 5 in 100. The S442 paired measurement agrees (FIRELEVEL2_ADAPT1_RESULT_S442.md: a Usable line costs 4.5 in 100, a Signature
  gives +1.3).
- Small sample (about 90-100 bouts an arm): it bounds the season, it does not price a single line. The paired probe does that.
- The fight-week probe (FIGHTWEEKPROBE1) was run before this switch with the old behaviour on its bouts (its fighters carry no plan
  lines, so its numbers are unaffected).

## Tests
fire_level_test FIRE_LEVEL failures=0 (6 new checks: no key = the game's shares, an explicit key wins, steps stay full);
plan_fight, combos, golden_path, balance_harness, first_week, file_limits, no_pronoun: all failures=0.
