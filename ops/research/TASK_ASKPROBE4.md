# TASK ASKPROBE4 - QWEN (qwen3-coder) - does the fight week make the show date a real choice?

Status: OPEN (S511, Claude main line). Discipline: boxing (amateur). Model: qwen3-coder.
Source: ops/research/ASKFIGHT_MAP_S441.md v4 STATUS: Ask for a fight stopped at critics 5/6 because "a later date buys
NOTHING" - an amateur bout had no camp. The amateur FIGHT WEEK is built now (scripts/rules/FightWeek.gd,
scripts/state/FightWeekPlan.gd): the last 7 days pick a load stop + 0-2 sparring nights (they cost THE TANK at the first
bell), round 1 opens sharp or flat, sparring nights ready plan lines, and nights 8+ days out ("the week before") cost a pad
night's mastery, never the tank - they exist only when the bout is booked 8+ days ahead. Critic round 4 (SQ206-208) asks
whether a NEAR show (7-13 days: fight week only) against a FAR one (14-28 days: the week before + a full fight week) now
trades something. This probe gives them and the map v5 the numbers. Pure measurement: no game code changes.

## Contract
OWNS: tools/ask_probe4.gd, docs/ASKPROBE4_RESULT.md
RED_TEST: tools/ask_probe4.gd -> ASKPROBE4 done
REGRESSION: ask_bout_test, fight_learn_test, fight_week_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py ask probe fight week tank`. Read tools/ask_probe2.gd (S445: the seed 4421 bout loop,
60 fighters, real bouts through the game's path) and docs/ASKPROBE2_RESULT.md - same method, same population. Read
scripts/rules/FightWeek.gd header (tank, round_one, banked, spar_night, assistant_spar) and
scripts/state/FightWeekPlan.gd draft/read/lock (what the game does with a plan). ops/research/GDSCRIPT_TRAPS.md first.

## What would a human do?
Book the same boxer against the same opponent twice, once 10 days out and once 21 days out, play the weeks the way a
sensible coach would (the assistant's default nights, Tick over), then the bout through the game's own path, many seeds;
compare what each date leaves: win rate, tank at the first bell, sharp/flat, lines readied, pad mastery kept, injuries.

## Prefab check
None (our own probe on our own rules).

## The job
1. tools/ask_probe4.gd (SceneTree, headless): the ask_probe2 population (60 fighters, seed 4421, the same opponents).
   For each fighter and opponent play two arms through the game's real code path (FightWeekPlan draft -> lock with
   the assistant's default choices, then the bout as ask_probe2 plays it):
   - NEAR: bout 10 days out (no week-before nights).
   - FAR: bout 21 days out (week-before nights as the assistant places them, then the fight week).
   Also a third arm with the player's best reasonable choice per arm (Rest up vs Tick over vs Train through, 0/1/2
   sparring nights: pick the best of the 9 by win rate on half the seeds, report it on the other half).
2. Print and write docs/ASKPROBE4_RESULT.md: per arm the win rate, mean tank at the first bell, share sharp in round 1,
   plan lines readied, pad mastery banked/lost, injury rate, and for how many of the 60 fighters NEAR beats FAR, FAR
   beats NEAR, or they tie (inside 2 points of win rate). The map's bar: a real choice = neither date best for more
   than 6 of 10 fighters, and at least one measure (win, mastery, injury) moves 3+ points between the dates.
3. Last line printed: `ASKPROBE4 done`.

## Do
1. Parse check, then run the probe headless (godot_slot, --log-file under E:/FightCamp/tmp).
2. Run the REGRESSION tests (you change no game file, so they must stay as they are).
3. PR body: the result table and `RESULT: tools/ask_probe4.gd -> ASKPROBE4 done`.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`, `--log-file E:/FightCamp/tmp/<run>.log`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/ (the animation session owns it). Every number is a
measurement with its population named in the output (fighters, opponents, seeds) - never two identical fighters.

## The one trap
FightWeekPlan reads the career's day: set c.day so the bout is really 10 or 21 days out BEFORE draft(), and run the days
between (the week-before nights happen only if the clock passes them). A probe that books both arms on the same day and
skips the clock measures nothing.
