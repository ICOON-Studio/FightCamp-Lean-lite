# TASK STREAKPROBE1 - how often a boxer is ON A RUN, and how often corners DUCK her or come to OWE her (probe only)

Status: OPEN (S518, Claude main line). Discipline: boxing. Model: qwen3-coder (or any seat that runs Godot).
Source: map ops/research/DESIGN_LADDER1_V6_DOLA.md R6. Built S518: scripts/state/HotStreak.gd (on a run = won the last 3
AND +15 ladder points in the last 8 weeks, read from c.results rows' "pts"), scripts/state/AskLadder.gd (a corner 0-8
points above leans No by -20 when our boxer is on a run; OWED = score 95 = Yes), scripts/state/AskFlow.gd book (a No
from such a corner = DUCKED, once a week; two inside 8 weeks = OWED; booking an owed bout clears it). tests/hot_streak_test.gd.
The thresholds (3 wins, 15 points, 8 weeks, the 0-8 window) are the map's ESTIMATES. Nobody has measured how often any
of it happens in a real career.

## The job
1. NEW file tools/streak_probe.gd (SceneTree, headless, under 500 lines). Population: 30 seeds x 2 clubs, a quick-start
   club with Lucy and the TEST CLUB (scripts/state/TestClub.gd), each stepped 735 days through Sim.step_day. Copy the
   minimal career set-up and the open-needs answering from tools/ladder_probe.gd (_career, _answer, _week) - do NOT edit
   ladder_probe.gd. Answer every sheet offer as ladder_probe does, EXCEPT: each Monday when AskFlow.open(c, f) is open
   and our boxer is on a run (HotStreak.hot), ask (AskFlow.book, kind "name", the soonest show from AskFlow.shows) for
   the highest-points name on AskFlow.answers(c, f)["cards"] whose ladder points are 0-8 above hers; record the lean
   (AskLadder.lines yes/no), whether it booked, and HotStreak.ducks_of / is_owed after it.
2. Report per club and boxer: share of weeks ON A RUN (of weeks with 3+ bouts fought), longest run, runs a season;
   asks made while on a run; Yes / No; ducks; OWED reached (count, and weeks from first duck to owed); owed bouts booked
   and their w-l; how the boxer's ladder points at day 728 compare with docs/LADDERPROBE4_RESULT.md's same boxer.
3. One line each at the end: is ON A RUN rare enough to feel earned (target: 10-30% of active weeks)? Do ducks happen
   a few times a season (not never, not weekly)? Does OWED ever fire? If a threshold is clearly off, name the number
   that would hit the target - never change it.
4. docs/STREAKPROBE1_RESULT.md, header line STREAKPROBE1, last printed line `STREAKPROBE1 done`.

## Contract
OWNS: tools/streak_probe.gd, docs/STREAKPROBE1_RESULT.md
RED_TEST: tools/streak_probe.gd -> STREAKPROBE1 done
REGRESSION: hot_streak_test, ask_wire_test, ladder_table_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py hot streak ducked owed ladder`. Read HotStreak.gd, AskLadder.gd, AskFlow.gd (open,
answers, shows, book), tests/hot_streak_test.gd, tools/ladder_probe.gd (the loop to copy), docs/LADDERPROBE4_RESULT.md,
ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Play two seasons, and every time a boxer strings three wins together, ask for a name just above her and note who says
No - then count how often that happens and whether anyone ever ends up owing the bout.

## Prefab check
None: our own rule; only our own sim can say how often it fires.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`, `--log-file E:/FightCamp/tmp/<run>.log`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/. No file over 500 lines. Never test identical
fighters (the clubs' own distinct boxers against the game's own named rivals).

## The one trap
A boxer is only "on a run" after 3 bouts in a row are wins: count the share over weeks where she had fought 3+ bouts,
never over all weeks (a 0-0 boxer is never on a run, which says nothing about the threshold).
