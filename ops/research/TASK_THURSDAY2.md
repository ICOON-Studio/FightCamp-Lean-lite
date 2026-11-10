# TASK THURSDAY2 - QWEN (qwen3-coder) - the Thursday count again, on camps that really differ. Measure only

Status: OPEN (S427, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: THURSDAY1 (PR 176, branch qwen/thursday1, tools/thursday_probe.gd + docs/THURSDAY1_RESULT.md) counted how many
problems a camp week has open on Thursday. Its table is VOID: the 40 "different seeds" gave two identical results
(camp weeks: 40 with 0 open, 40 with 1, 80 with 3, nothing else; tired and card never). Setting `c.seed` after
`Career.quick_start()` changed nothing the count depends on: the same Lucy, the same opponent, the same tells, the same
weeks. So "half the camp weeks have two or more problems open" is unproven. This task makes the camps really differ and
counts again. It changes no game file.

## Contract
OWNS: tools/thursday_probe.gd, docs/THURSDAY2_RESULT.md
RED_TEST: tools/thursday_probe.gd -> THURSDAY2 camps=40 distinct_opponents>=10 distinct_rows>=12 (measure only)
REGRESSION: golden_path_test (the probe changes no game file; this proves the career still runs)
VISUAL: no

## The job
1. Start from PR 176's probe (`git fetch --no-write-fetch-head origin refs/pull/176/head:refs/remotes/origin/pr176`, then
   take tools/thursday_probe.gd from origin/pr176; keep its five problem definitions and thresholds exactly, bend none).
2. FIRST find out why the 40 camps were the same: print, per camp, the opponent's name, her stats line, the camp length in
   days, the tells opened and the boxer's habits. Say in the result which of these never changed and why (read the code:
   where does the offer come from, what does Career.seed feed, is it read before or after quick_start).
3. Make the camps differ in the ways a real player's camps differ, using only calls the game itself makes:
   a) the boxer: at least 4 different boxers (different signing focus / trait picks at the reception, and recruits the
      game offers later), not only Lucy;
   b) the bout: the 1st, 2nd, 3rd and 4th bout of a career (later camps have other opponents, other habits, more cards);
   c) the opponent: whatever the game offers at that point, with the seed set where the game reads it;
   d) the week: every camp week of each camp, not only one.
   40 camps at least. PROVE the spread before counting: print `THURSDAY2 spread opponents=<n distinct> boxers=<n>
   camp_lengths=<set> rows=<n distinct THU lines>`; under 10 opponents or under 12 distinct rows the run is void: say so
   and stop, write no table.
4. Print one line per Thursday as before: `THU camp=<n> boxer=<name> opp=<name> bout=<k> week=<k> days_to_bell=<d>
   tape=<0/1> habit=<0/1> weight=<0/1> tired=<0/1> card=<0/1> open=<sum>`.
5. For each camp-week Thursday with 2+ open ALSO record which single change would be best, by the simplest honest rule
   you can run in the game (say which): e.g. the problem whose answer is worth most wins, if the plan test / forecast the
   game already has can price it. Report how often the SAME kind of problem is the best one (7 times in 10 or more = the
   choice is a lookup). If the game cannot price a kind, write "cannot price <x>" and leave it out of that share.
6. docs/THURSDAY2_RESULT.md: the spread line; why THURSDAY1 collapsed; the table of Thursdays with 0, 1, 2, 3+ open, camp
   and quiet weeks apart; which problem is most common and which never appears; the lookup share from step 5; then five
   sentences: is "one change on Thursday" a real choice in today's game (2+ open in at least half the camp weeks AND no
   kind best 7 times in 10), what the quiet week would need, what you could not measure.

## Prior research
ops/research/TASK_THURSDAY1.md, ops/research/WEEK_DESIGN_V2_S425.md (the Thursday section and its measurement table),
docs/mockups/s425/week_v2_critic_coach.md item 8, tests/golden_path_test.gd, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A coach's Thursdays differ because his boxers, their opponents and the weeks differ. A count on one boxer against one
opponent is one camp, however many times it is run.

## Prefab check
No asset or library applies: a count on the game's own career.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://tools/thursday_probe.gd -- 40` (the plain win64 exe, never the console one).
RESULT lines for the PR body: `RESULT: tools/thursday_probe.gd -> THURSDAY2 camps=<n> opponents=<n> camp weeks with 2+ open <x>% lookup <y>%`.
