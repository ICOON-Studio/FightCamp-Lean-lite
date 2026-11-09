# TASK FIGHTERMODEL4B - CURSOR (Grok 4.7 High) - scouting has something to find again, on the 10 attributes

Status: OPEN, after FIGHTERMODEL4G lands (S411, Claude main). Discipline: boxing. Model: grok-4.7-high. Mechanics list row R24: critics 9 and 8, the operator's build list.
FIRST: merge origin/main into this branch. It merges together with FIGHTERMODEL4F and 4G, so main stays green.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`.

## Contract
BASE: cursor/fightermodel4g
OWNS: scripts/rules/AttrGen.gd, scripts/rules/Attrs.gd, scripts/rules/BoutRead.gd, scripts/rules/Duels.gd, scripts/rules/Exchanges.gd, scripts/rules/Matchmaking.gd, tests/matchup_spread_test.gd
RED_TEST: tests/matchup_spread_test.gd -> MATCHUP_SPREAD failures=0
REGRESSION: matchmaking_bots_test, plan_bots_test, bout_read_test, world_years_test, golden_path_test
VISUAL: no

## Prior research
ops/research/TASK_FIGHTERMODEL3C.md (the same audit on the old attribute list; those numbers are NOT today's), TASK_FIGHTERMODEL3.md (the gate and its traps), FIGHTER_MODEL_S397.md section 10, MATCHMAKING_S397.md, TASK_FIGHTERMODEL4E.md.

## What would a human do?
Pay a scout because the tape changes who you take: some fighters at your level are a bad style for you and some are a gift.

## Prefab check
None needed.

## The audit to repeat first
`MM.win_chance(p, b) - MM.win_chance(p, MM.level_only(b))` over 60 worlds, m_lw, your boxer at 64, opponents within 8 rating points. On the old list the median size was 0.04 (90th percentile 0.11), the read was biased down (signed mean -0.015, 59% of opponents read worse than level), and scouting cost the bot 8 top-10 finishes against going blind. Those numbers are from before the 10 attributes. Print today's first, in the PR body, before changing anything. If rule 1 and 2 already hold, stop and say so.

## The rule
1. Typical matchup size: median |edge| at least 0.08 on the probe, without moving bar 1 of fighter_model_bars_test out of its band.
2. Centred read: signed mean edge within +-0.01, share worse than level between 0.45 and 0.55. Fix the centre (value-weighted overall, shapes centred on it), not a constant added to the read.
3. Rule 2 of the fighter model: tests/matchmaking_bots_test.gd passes all its bars, unweakened: the smart bot's median place beats the hard bot's by 1 or more, scouting earns +5 top-10 finishes or more, fewer stoppage losses scouted.
4. The plan's lead stays: plan_bots_test green, with the watched form spread at 5 as FIGHTERMODEL4E left it. Do not change `FORM_SD`.

## Do
1. Add tests/matchup_spread_test.gd, printing `MATCHUP_SPREAD failures=<n>`, the probe as bars 1 and 2. It must be run on main first: state in the PR body whether it was red.
2. Make it pass inside OWNS. Under 500 lines per file (BoutRead.gd is at 497: split before adding).
3. Run REGRESSION. Do not change any number or threshold in an existing test.

## Result lines (PR body)
RESULT: tests/matchup_spread_test.gd -> MATCHUP_SPREAD failures=0
RESULT: spread median <x> signed mean <x> share worse <x>, before and after
RESULT: rule 2 smart median <x> vs hard <x>; scouting +<n> top-10; stoppage losses blind <x> scouted <x>
RESULT: CI tests job duration
The blind critics are run by Claude on the built branch: do not score your own work.

The branch's own fighter_model_test, fighter_model_speed_test and fighter_model_bars_test stay green too (they are not on main, so the contract cannot name them).

## The one trap
tests/matchmaking_bots_test.gd takes about 12 minutes alone, so run it last and once. Widening the matchup also widens BoutRead's shown odds: BoutRead must stay in step with the real bout (tests/bout_read_test.gd, within 0.06).
