# TASK WHYGRADE1 - why a good plan reads GOOD less often since CARDFIX1: count each line's fires by situation (measure only)

Status: OPEN (S487, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why
tests/fight_why_test.gd: "a good plan reads GOOD in two fights of three" is red, 276-279 of 540 (bar 360). S487 bisected
it (7b7ac6e6..0faaf983) to ONE commit, 3fd32033 (S466 CARDFIX1): 375 before, 279 after. That commit changed two things in
scripts/rules/PlanFight.gd and scripts/state/LiveRound.gd: (1) GAME_CARD counter -> outside (a counter-puncher waits
outside); (2) she_tired / she_hurt no longer put the boxer on a fixed card (inside / own_ropes): she is tired or hurt where
she stands, a lost exchange moves her (where_next). The 05:00 review found that putting (1) back alone gives 324. Adding a
counter answer (feint) to the good plan changed nothing (276). The test's good plan is 1-1, step_back, pivot_out, tie_up
against Maria Ortega (a pressure fighter), steps at 85.

## What to do (measure only - no change to the game or the test's bars)
1. tools/why_fires_probe.gd (extends SceneTree, under 300 lines): the test's own _bout() setup (copy it), 540 bouts
   (days 40..579) with the GOOD plan and with no plan. Per bout and summed: for each situation the exchange had (press,
   range, counter, counter_late, loadup, tiring, hurt, she_tired, she_hurt, ...), the place it was on, how many exchanges,
   which plan line fired (move id) or none, and won/lost. Print one table row per situation:
   `WHYFIRES sit=<s> place=<p> n=<exchanges> fired=<n> by=<move:n,...> won_plan=<%> won_none=<%>`
   and the FightWhy grade counts (`WHYFIRES graded_good=<n> of 540`).
2. Run it on main AND on a worktree of 3fd32033^ (the commit before CARDFIX1). Write both tables and the difference in
   docs/WHYGRADE1_RESULT.md: which situation lost the most plan edge, and why (the line no longer fires there / fires
   on a place where it is a wrong answer / the situation now happens elsewhere).
3. Nothing else. Claude makes the design call from the table.

## Pass lines
RESULT: tools/why_fires_probe.gd main -> graded_good=<n> of 540 (fight_why_test prints 276-279)
RESULT: tools/why_fires_probe.gd 3fd32033^ -> graded_good=<n> of 540 (fight_why_test printed 375)
RESULT: docs/WHYGRADE1_RESULT.md -> the situation that lost the most edge: <sit, place, fires before -> after>

## Contract
OWNS: tools/why_fires_probe.gd, docs/WHYGRADE1_RESULT.md
RED_TEST: tools/why_fires_probe.gd -> graded_good printed for both commits (no such file on main)
REGRESSION: tests/fight_why_test.gd
(read-only: it must print the same 276-279 after your work; `--headless --audio-driver Dummy --fixed-fps 60`)
VISUAL: no
NOT YOURS: every other file. Work on qwen/whygrade1, commit, push, never merge. A worktree of 3fd32033^ for step 2: `git worktree add --detach`, seed it with ops\Tools\seed_godot_cache.ps1, remove it after.

## Prior research
tests/fight_why_test.gd (S461 design note on the two-in-three bar); docs/CARDFIX1_RESULT.md (S466 card table arms);
ops/AgentComms/nightly/reviews.md (2026-11-15 entry); scripts/rules/FightWhy.gd (the grade).

## What would a human do?
Watch the same fights with and without the plan, before and after the change, and note where the plan stopped helping.

## Prefab check
None: our own fight rules.
