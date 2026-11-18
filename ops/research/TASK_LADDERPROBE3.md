# TASK LADDERPROBE3 - the ladder table over two years with newcomers, the R8 free week and the season close (probe only)

Status: OPEN (S517, Claude main line). Discipline: boxing. Model: qwen3-coder (or any seat that runs Godot).
Source: ops/research/LADDERWIRE_SCOPE_S515.md, last paragraph: every ladder stage needs "a probe that a season's table
stays sane (points spread 0-100, no boxer stuck at a cap, ranked top 3 turns over)". Map: DESIGN_LADDER1_V6_DOLA.md R1-R3.
Ladder points live on every amateur as key "rep" (0-100). scripts/state/LadderPoints.gd seeds them from the record
(seed_of) and moves both sides on every amateur bout (settle, the table in scripts/rules/LadderRep.gd change/apply).
The region's rivals box each other at club shows (scripts/state/Region.gd _rival_bout, called from the day loop);
our boxers' bouts move them too (Bouts.fight_step writes m["ladder_pts"]). The table: Region.rankings(c, div), sorted
by ladder points first since S516 (RankLine._before).

## What changed since LADDERPROBE1 (S516) and LADDERPROBE2 (S517, docs/LADDERPROBE2_RESULT.md)
tools/ladder_probe.gd is ON MAIN already (S517 collected it): EDIT it, do not rewrite it. Since then: (1) scripts/state/Newcomers.gd -
a novice with no legal name on her sheet gets a newcomer novice on it (r["newcomer"] true, at most 3 a sheet); (2)
Region._free_week - the idle clock waits while our boxer is booked, injured or has no legal name in reach (map R8);
(3) scripts/state/LadderSeason.gd - 1 January keeps each division's final table in c.seasons and writes our boxers'
season lines. LADDERPROBE2 (clock on, before these fixes) found our novices frozen with no legal name in 23 of 30 runs
and drained to ~1 point by day 728.
Add to the result: (a) "no legal name at end" and "same points at both marks" again (both should fall to ~0); (b)
newcomers: how many arrived a division-run, their bouts at day 728; (c) the season tables: c.seasons has one entry a
division with rows at day 365 and 730 (run 735 days); our boxers' place in each; (d) everything LADDERPROBE1 reported,
same tables, so the three can be compared. Write docs/LADDERPROBE3_RESULT.md (change the DOC constant), last line
`LADDERPROBE3 done`.

## Contract
OWNS: tools/ladder_probe.gd, docs/LADDERPROBE3_RESULT.md
RED_TEST: tools/ladder_probe.gd -> LADDERPROBE3 done
REGRESSION: ladder_points_test, ladder_table_test, newcomers_test, ladder_season_test
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
