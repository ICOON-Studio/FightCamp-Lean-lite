# TASK PLANREAD2 - the card must not promise a plan the bout does not pay (S546)

Kind: build (find the cause with a measurement, fix the read, a test red first). Model: claude-opus-5-5.
Discipline: boxing (demo path). Seat: Claude worker in a console tab. Estimate: 3-4 hours, most of it bout runs.

## Why
PLANWORTH1 (`docs/PLANWORTH1_RESULT.md`, 122,400 real bouts, S544): the best plan a player can write wins +1.7 in 100
more than the coach's plan and +2.9 more than no plan. The card he reads before the bout (`BoutRead`) promises +11.6 for
the same plan. Read against bout, by arm (points of wins in 100): no plan and the coach's one or two lines within
1.6-3.3; one written line +8.5; a careless plan +8.3; a 6-line style plan +12.6; a whole-file plan +14.1; the worst
plan -5.3. The over-read grows with every line written. The player sees a number the fight pays a fifth of: a defect
whatever happens to the plan screen (the owner decides its future; this task does not touch that question).
TELLPLAY1 found the same on the fade line and S544 fixed that one place (`BoutRead.gd` l.247: "she_tired" and "tiring"
walk the card chain).

## METHOD (quote in your first message)
A WORKER'S NUMBERS CAN BE RIGHT AND ITS WHY WRONG: open the code lines first, and prove the cause with an arm that
cannot share the bug. The read is fixed to the BOUT, never the bout to the read. Mechanics first; no screen work here.
Nothing in `scripts/state/LiveRound.gd`, `BoutNight.gd` or the fight changes: the ring is the truth in this task.

## What the code says today (read these lines before any run)
- `scripts/rules/BoutRead.gd` `_round_edges` (l.322-380): the plan term is `PLAN_CARRY (1.9) x PlanChain.walk(arrows,
  moves, combos, steps, p_win, ["she_tired"], bars)` added to every round's edge; `PLAN_REACH` 0.75 x `PLAN_CARRY` on the
  she_tired line (l.247-248). `PLAN_CARRY` was fitted in S434 on 22 arms x 1,000 bouts with NO PLAN TO FOUR ARROWS
  (the const's own comment): today's plans hold 6 to 9 lines.
- `scripts/rules/PlanChain.gd` (86 lines): the walk adds, for every exchange and every situation share, the edge of the
  line chosen on the card she stands on (`PlanFight.choose`, `LineGrade.edge`, `FireLevel.share`).
- The ring: `scripts/state/LiveRound.gd` from l.231 - a line fires only in the exchanges where she stands on its card
  in its situation, on its fire level's share of uses.
Suspects, in the order to test (one arm each, each able to read worse):
1. `PLAN_CARRY` 1.9 multiplies the whole plan as if every line carried reads and pressure past its exchange: fitted on
   1-4 lines, applied to 6-9. Does the bout's gain per line fall off as lines are added while the read's stays flat?
2. `when` lines (a line for one situation) counted on exchanges where their situation's share is small but their card
   edge is taken whole; or counted in more than one situation.
3. The walk's `p_win` (`ComboOdds.win_odds(e)`) is read BEFORE the plan term is added, or after it compounds.
4. Lines the ring never reaches (a card she is rarely on against this style) still paid through the mix.
5. Anything the S434 fit could not see: FireLevel (S450), LineGrade (GRADE1), step mastery (S464), the six styles.

## Do, in this order
1. `python ops/Tools/prior_research.py bout read plan carry chain`. Read `docs/PLANWORTH1_RESULT.md` whole,
   `docs/TELLPLAY1_RESULT.md` (the fade fix), `tests/bout_read_test.gd` header, the lines above.
2. RED FIRST: a new `tests/plan_read_fit_test.gd` (`tests/plan_read_test.gd` already exists and is another thing)
   a check that reads PLANWORTH1's arms the cheap way: for 3 of its types x 2 opponent styles, arms A (no plan), D (one
   line) and C (the 6-line style plan), 300 paired bouts an arm through `tools/planworth1_probe.gd`'s own bout function
   (copy the function, do not preload a tool into a test), and asserts |read - bout| <= 4 points for every arm AND
   (read C - read A) <= 2 x (bout C - bout A) + 3 points. It must go RED on today's code; commit it red.
3. THE CAUSE: a probe `tools/planread2_probe.gd` (headless, through the queue, output to a file, a done line): for the
   ten PLANWORTH1 types x six styles, plans of 0, 1, 2, 3, 4, 6 lines (greedy on the read, PLANWORTH1's arm C chooser),
   500 paired bouts a cell; print read, bout, and the read's plan term split by suspect (the walk's sum before
   PLAN_CARRY, the carry's share, per line). One-rep trial first (see Feedback loops). Name the cause in one sentence
   with the table that shows it, and the arm that rules the other suspects out.
4. THE FIX, in `BoutRead.gd` / `PlanChain.gd` only (BoutRead.gd is at 499 lines: move a helper to PlanChain.gd or a new
   small rule module rather than passing 500). The read follows the ring's own firing rule; if a fitted constant stays,
   fit it on plans of 0 to 9 lines and all six styles, and write the fit's population and error in its comment the way
   `PLAN_CARRY`'s comment does. No constant may be fitted on the same bouts the red test reads (hold out: fit on five
   types, test on the other five).
5. GREEN: the red test passes; `tests/bout_read_test.gd` whole stays green (its S434 arms within their old bounds, or
   say which bound moved and why); `tests/the_read_test.gd`, `tests/plan_read_test.gd`, `tests/plan_read_shown_test.gd`, `tests/fade_read_test.gd`,
   `tests/pro_read_test.gd`, `tests/debut_read_test.gd` green. Then re-run PLANWORTH1's summary table (read v bout by
   arm) at 100 bouts a file and put it in the result beside the old one.

## Not allowed
No change to the fight or to what a plan does in the ring. No screen work, no new words on the card. No file over 500
lines. Headless Godot only, through `python ops/Tools/godot_slot.py run --who PLANREAD2 -- <command>`; watchdog before
each job (`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait, read
meanwhile). The PC is short of memory tonight: ONE Godot process at a time, never a sweep of parallel cells; split a
long sweep with `only=` and write each part to a file.

## Prior research
`docs/PLANWORTH1_RESULT.md`, `docs/TELLPLAY1_RESULT.md`, `docs/CORNERCMD1_RESULT.md`, `tests/bout_read_test.gd`
(S387, S434 PUNCHSTART1 rounds 1 and 2: the card chain), `ops/research/S434_DIGEST.md` and `S544_DIGEST.md`, memory note
"Probe populations and bout dice (S533)" (quick_start is one boxer whatever the seed; the dice are the fight day; read
per boxer).

## What would a human do?
A statistician shown a forecast that is right with no plan and wrong by more with every line added would regress the
error on the number of lines and on each line's kind, find the term that scales with lines, and re-fit it on data that
holds the long plans - then check on boxers the fit never saw.

## Prefab check
None to take: the read and the ring are ours. PLANWORTH1's probe and summary script are the harness to reuse.

## Feedback loops
The read feeds: the win band on the bout card, the pro pair's printed chance (`ProPair.read` uses its own walk: check
whether it shares the plan term - if it does, the pro bands in `ProStart` clamp it), the greedy chooser inside the
probes (a chooser that uses the read picks different plans once the read changes: fix the chooser's plans from the OLD
read for the before/after table, so both columns fight the same plans), `CoachPlan` (does the coach pick his lines by
the read? if yes his plan changes with the fix: say so and measure B58 again). Nothing feeds back into the bout.
Cap: the read is clamped to 0-1 by `CardOdds`. One-rep trial of the probe (one type, one style, every line count, 20
bouts) before the full run; stop if two cells print identical numbers.

## Contract
OWNS: scripts/rules/BoutRead.gd, scripts/rules/PlanChain.gd, scripts/rules/PlanReadFit.gd, tests/bout_read_test.gd, tests/plan_read_fit_test.gd, tools/planread2_probe.gd, docs/PLANREAD2_RESULT.md
RED_TEST: tests/plan_read_fit_test.gd
REGRESSION: tests/bout_read_test.gd, tests/the_read_test.gd, tests/plan_read_test.gd, tests/fade_read_test.gd, tests/pro_read_test.gd, tests/debut_read_test.gd
VISUAL: none

## Result
`docs/PLANREAD2_RESULT.md`: the cause in one sentence, the table that shows it, the arm that rules the others out,
what changed (lines), read v bout by arm before and after, the held-out error, test lines (`RESULT:
tests/plan_read_fit_test.gd -> <exact pass line>`), and what the read still gets wrong. Commit ONLY your own paths with
`git commit -m "..." -- <paths>` (collect them with `git diff --name-only --no-renames`); do not push; do not ask
questions: decide, and write what you decided.
