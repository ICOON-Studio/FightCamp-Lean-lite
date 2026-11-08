# TASK FIGHTERMODEL3C - CURSOR (Grok 4.7 High) - scouting has something to find again (round 3, from an audit)

Status: OPEN (S402, Claude main). Discipline: boxing. Model: grok-4.7-high. Mechanics list row R24: critics 9 and 8, the operator's build list.
BASE: cursor/fightermodel3b. FIRST: merge origin/main (22 commits behind) and keep every touched test green.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`. The last two rounds ran out of time: do the audit items below and nothing else.

## Contract
OWNS: scripts/rules/AttrGen.gd, scripts/rules/Attrs.gd, scripts/rules/BoutRead.gd, scripts/rules/BoutRules.gd, scripts/rules/ComboOdds.gd, scripts/rules/Duels.gd, scripts/rules/Exchanges.gd, scripts/rules/Knockdowns.gd, scripts/rules/Matchmaking.gd, scripts/rules/PadWeek.gd, scripts/rules/RoundStyle.gd, scripts/state/BoutNight.gd, scripts/state/LiveRead.gd, scripts/state/LiveRound.gd, scripts/state/ProLadder.gd, scripts/state/Region.gd, scripts/state/RingDuel.gd, scripts/state/Sim.gd, scripts/ui/AttrBoard.gd, scripts/ui/BoutCompare.gd, scripts/world/WorldBout.gd, scripts/world/WorldGen.gd, scripts/world/WorldSim.gd, tests/attr_board_test.gd, tests/balance_harness_test.gd, tests/bout_read_test.gd, tests/fighter_model_bars_test.gd, tests/fighter_model_test.gd, tests/matchmaking_bots_test.gd, tests/world_years_test.gd, tools/fighter_bars.gd, tools/round_reports.gd, scripts/rules/FightWords.gd
RED_TEST: tests/matchmaking_bots_test.gd -> MATCHMAKING_BOTS failures=0
REGRESSION: fighter_model_bars, fighter_model, bout_read, world_years, attr_board, balance_harness, golden_path_test
VISUAL: no

## Prior research
ops/research/TASK_FIGHTERMODEL3.md (the gate, what was built, traps), FIGHTER_MODEL_S397.md section 10, MATCHMAKING_S397.md.

## What would a human do?
Pay a scout because the tape changes who you take: some fighters at your level are a bad style for you and some are a gift.

## Prefab check
None needed.

## The audit (S402, Claude, measured on f6d607c0, 60 worlds, m_lw, your boxer at 64, opponents within 8 rating points, n = 1496)
Run on the PR branch: smart median place 14.0 vs hard 13.5 (bar: smart ahead by 1 or more). Scouting -8 top-10 finishes against blind (bar: +5 or more).
Cause 1, the matchup is too small to be worth finding. `MM.win_chance(p, b) - MM.win_chance(p, MM.level_only(b))`: median size 0.04, 90th percentile 0.11. main's hidden edge was uniform +-6 rating, median 3 rating points, and on this branch's level curve 3 points is 0.10 of chance (0 -> 0.500, +3 -> 0.601, +6 -> 0.753). Bar 1 passes because it looks at the best archetype pair, not the typical opponent.
Cause 2, a scouted read is biased down. Signed mean -0.015, and 59% of opponents read worse than level. The level read is not the centre of the real matchups, so a scouted look mostly scares the smart bot off.

## The rule
1. Typical matchup size: median |edge| at least 0.08 on the probe above, without moving bar 1 out of its 10-15 band.
2. Centred read: signed mean edge within +-0.01, share worse than level between 0.45 and 0.55. Fix the centre (value-weighted overall, shapes centred on it), not a constant added to the read.
3. Rule 2 held: tests/matchmaking_bots_test.gd passes all its bars, unweakened: smart beats hard's median by 1 or more; scouting +5 top-10 or more; fewer stoppage losses scouted.
4. Golden path: `corner call: calm` and `four rounds played` fail on this branch (tests/golden_path_test.gd line ~537). Find out why. If the new model simply stops the debut earlier on the path's fixed seed, do not edit the check: put the round, the cause and your proposal in the PR body.

## Do
1. Add `tests/matchup_spread_test.gd` (prints `MATCHUP_SPREAD failures=<n>`), the probe above as bars 1 and 2. It must fail on the branch as it stands.
2. Make it pass, inside OWNS (add that test to your own files). Under 500 lines per file.
3. Run REGRESSION. Do not change any number or threshold in an existing test.

## Result lines (PR body)
RESULT: tests/matchup_spread_test.gd -> MATCHUP_SPREAD failures=0
RESULT: spread median <x> signed mean <x> share worse <x>
RESULT: rule 2 smart median <x> vs hard <x>; scouting +<n> top-10; stoppage losses blind <x> scouted <x>
RESULT: regression <pass/fail per test>
The blind critics are run by Claude on the built branch: do not score your own work.

## The one trap
tests/matchmaking_bots_test.gd takes about 12 minutes alone, so run it last and once. Widening the matchup also widens BoutRead's shown odds: BoutRead must stay in step with the real bout (tests/bout_read_test.gd, within 0.06).
