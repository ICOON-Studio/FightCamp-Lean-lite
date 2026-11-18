# TASK MORNINGSPROBE2 - coached mornings on the BUILT club week: does the week plan make a real choice? (probe)

Status: OPEN (S520, Claude main line). Discipline: boxing. Model: qwen (any seat that runs Godot headless).
Source: club week v11 built S519 (ops/research/CLUBWEEK1_BUILD_S519.md, "Not built": "MORNINGSPROBE2 ... should measure
the ESTIMATES above on the built code"). MORNINGSPROBE1 (docs/MORNINGSPROBE1_RESULT.md) measured the multipliers on a
hand-made loop BEFORE the wiring and found the multiplier is not the lever (S513 control: SHARED x1.35 moved points, not
the record). Now the coach deals the mornings by himself (CoachedMornings.week_deal through scripts/state/MorningWire.gd,
read by WeekPlan.day via Sim.week_ctx): the player's only lever is each boxer's WEEK PLAN (which ability each morning
trains). Two boxers on the same ability the same morning = a SHARED slot; different = SOLO turns. This probe asks whether
that lever is a real choice in the real game.

## Contract
OWNS: tools/mornings_probe2.gd, docs/MORNINGSPROBE2_RESULT.md
RED_TEST: tools/mornings_probe2.gd -> MORNINGSPROBE2 done
REGRESSION: morning_deal_test, club_week_walk_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py coached mornings shared solo`. Read docs/MORNINGSPROBE1_RESULT.md (its S513 reading),
scripts/rules/CoachedMornings.gd (week_deal, day_mult; SOLO 1.25 / SOLO_WEAK 1.40 / SHARED 1.15 are ESTIMATES),
scripts/state/MorningWire.gd, WeekPlan.days_of and the plan edit the Training screen uses (grep scripts/ui/areas/Training.gd
for the act), scripts/state/TestClub.gd, and tools/streak_probe.gd / tools/ladder_probe.gd for a career stepped through
Sim.step_day with bouts fought by the sim. ops/research/GDSCRIPT_TRAPS.md first.

## What would a human do?
Run the same four-boxer club through 16 weeks three ways - every boxer on the SAME week template (many shared mornings),
every boxer's plan aimed at her own weakest ability (solo turns), and the plans the club starts with - on many seeds, and
see which ends with the better boxers and the better record. Then a control where no morning is coached.

## Prefab check
None needed: a measurement on our own code, reusing the probes above.

## The job
1. tools/mornings_probe2.gd (SceneTree, headless). The TEST CLUB (TestClub.gd: three boxers + Ana; mornings are dealt to
   the boxers), coach Reid sessional AND, as a second arm, full time. 40 seeds from 4421, 112 days each through
   Sim.step_day; sheet offers accepted and bouts fought as tools/ladder_probe.gd does (reuse by preload or copy, never edit).
2. Four policies, set on day 0 and again each Monday through the game's own plan setter:
   ALIGNED (every boxer the same template: the most common default week in the club), WEAKEST (each boxer's mornings on
   her own lowest fight ability), DEFAULT (the plans the club starts with, untouched), CONTROL (DEFAULT plans with no
   coached mornings: run it with one boxer's deal emptied by the probe if Sim allows it without a game edit; if it needs
   a game file change, say so and skip the arm).
3. Report per policy and coach kind: shared slots / solo slots dealt a week (MorningWire.deal), stat points gained (sum
   and on each boxer's weakest), win rate over the bouts fought, ladder points at day 112, and on how many seeds each of
   ALIGNED / WEAKEST / DEFAULT is best by win rate (ties split). Bar (map 3.5): each best on 30-70% of seeds = a real
   choice; over 70% = dominant (name what would move it: a multiplier, or WHICH ability the shared slot trains).
   CONTROL vs DEFAULT = what coached mornings are worth at all.
4. docs/MORNINGSPROBE2_RESULT.md: the population named in its own text, the tables, the reproduce line. Last printed
   line: `MORNINGSPROBE2 done`.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who morningsprobe2 -- <godot> --headless --audio-driver Dummy
--fixed-fps 60 --log-file E:/FightCamp/tmp/morningsprobe2.log --path . --script res://tools/mornings_probe2.gd`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/. No two identical fighters in a measurement.

## The one trap
Headroom clamps gains (potential - stat): WEAKEST trains the abilities furthest under potential and gains more points
anyway. Compare policies on the SAME boxers and seeds, and report win rate beside points - MORNINGSPROBE1's lesson is
that points moved while the record did not.
