# TASK LADDERPROBE1 - does the season ladder's table stay sane over two years of real play? (probe only, no rule change)

Status: OPEN (S516, Claude main line). Discipline: boxing. Model: qwen3-coder (or any seat that runs Godot).
Source: ops/research/LADDERWIRE_SCOPE_S515.md, last paragraph: every ladder stage needs "a probe that a season's table
stays sane (points spread 0-100, no boxer stuck at a cap, ranked top 3 turns over)". Map: DESIGN_LADDER1_V6_DOLA.md R1-R3.
Ladder points live on every amateur as key "rep" (0-100). scripts/state/LadderPoints.gd seeds them from the record
(seed_of) and moves both sides on every amateur bout (settle, the table in scripts/rules/LadderRep.gd change/apply).
The region's rivals box each other at club shows (scripts/state/Region.gd _rival_bout, called from the day loop);
our boxers' bouts move them too (Bouts.fight_step writes m["ladder_pts"]). The table: Region.rankings(c, div), sorted
by ladder points first since S516 (RankLine._before).

## Contract
OWNS: tools/ladder_probe.gd, docs/LADDERPROBE1_RESULT.md
RED_TEST: tools/ladder_probe.gd -> LADDERPROBE1 done
REGRESSION: ladder_points_test, ladder_table_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py ladder points rankings season`. Read LadderPoints.gd, LadderRep.gd, Region.gd
(rankings, _rival_bout, the show days), tests/ladder_points_test.gd, tests/two_boxers_two_years_test.gd (a long run of
the real day loop with decisions made in code), scripts/ui/TestJump.gd `_tidy` (how open needs are answered so the clock
never stalls). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Play two seasons at the club and look at the ranking table every month: does the order change, do points spread out
or bunch at 0 / 100, does anyone climb from the bottom half into the top three?

## Prefab check
None: the ladder points are our own rule; only our own sim can say where they settle.

## The job
1. tools/ladder_probe.gd (SceneTree, headless): 30 seeds x 2 clubs (a quick-start club with Lucy, and the TEST CLUB
   scripts/state/TestClub.gd), each stepped 728 days through `Sim.step_day`, accepting every sheet offer, every other
   open need answered as TestJump._tidy does. No identical fighters in a measurement.
2. Every 28 days, for every division that has rivals, read Region.rankings(c, div) and record each row's rep.
3. docs/LADDERPROBE1_RESULT.md: the population; per division at day 0, 364, 728: min / median / max points, how many
   rows at 0 and at 100, the share of rows whose points did not move in the last 84 days (stuck); top-3 turnover (how many
   different names held a top-3 place over the two years; how many of those started in the bottom half); our boxers'
   points at day 364 and 728. One line each: points spread 0-100? anyone stuck at a cap? does the top 3 turn over?
   Never change a rule or constant; report only.
Last printed line: `LADDERPROBE1 done`.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`, `--log-file E:/FightCamp/tmp/<run>.log`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/.

## The one trap
A row with no "rep" yet reads at its seed (RankLine.rep), so a rival who never boxes keeps a seed that never changes:
count "stuck" only for rows that had at least one bout in the window (her r["bouts"] newest first, RivalPast), and
report never-boxing rivals separately.
