# COACHDEEP8 - coaches v8: v7 plus the three changes its probe named, the same seven bars (S543)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -m "..." -- <files>`), do not
push. Godot only through `python ops/Tools/godot_slot.py run --who COACHDEEP8 -- <cmd>` (headless, Dummy audio), ONE run at a
time, output to a file, wait on its done line (a killed waiter leaves Godot running: check by PID). Before each run:
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait. Other workers share the Godot queue.
Estimate: 1.5-2 hours (the probe exists: v7's full run took 22 minutes). Run the FULL size (100 careers a cell per arm)
before any verdict.

## Why
Coaches v7 is the owner's design (`ops/research/COACH_INTERVIEW_S542.md`, 17 answers; map `DESIGN_COACHDEEP7.md`). Its
probe FAILED 4 of 7, each failing bar by ONE cell: `docs/COACHDEEP7_RESULT.md` (read sections 1, 4, 6, 7). Section 7 names
one change for each failed bar, each INSIDE the interview's answers. v8 = v7 + exactly these three; nothing else moves.

## The three changes
1. A WARNING COSTS SOMETHING WHILE IT STANDS (bar 3; interview 3 "a wrong call is felt as story", 15 "two warnings").
   A warned boxer trains and listens worse (learning and the corner's uptake down, morale down a little); a warned coach
   works worse (his areas count for less). The warning fades after a season (26 weeks) if no second one comes. Sizes are
   ESTIMATES to tune: start at -10% learning and -15% of the corner's uptake for a warned boxer, -10% of a warned coach's
   ratings. So WHO carries the warning decides the answer to a falling-out or a refused push, not only whether someone
   leaves two moments later.
2. A COACH WHO TEACHES TWO ARTS IS A SOLID-BAND WAGE (bar 1; grill Q17 "wages scale with ratings"). The local mat coach who
   also teaches the boxing class (card M, $250) moves to the solid band ($400-600; start at $450), so the two-art coach is
   a trade against a cheaper one-art local plus the $150 sessional mat coach.
3. THE CARD'S LINE COUNTS THE BOXERS TOO (bar 5; interview 6 "one plain line on whether the club can carry the wage"). The
   hire card and the raise pop-up say when a coach pays in results as well as in members: beside "pays for itself at
   about N members", a second plain line from the game's own coached-against-alone gain ("the boxers win about X more a
   season with this coach"). The careful line of the probe reads both lines when it answers a raise.

## Do
1. `ops/research/DESIGN_COACHDEEP8.md`: the v7 map carried over whole (copy it; mark each changed paragraph "v8:"), the
   three changes with their numbers and real-world reasons, the menu table updated (the warning's effect and its fade
   shown on the card; the second line on the hire card and the raise pop-up), feedback loops, and the SAME seven bars
   (v7 map s10), the same ten cells, the same score. Never loosened.
2. Probe `tools/coachdeep8.gd` + `tools/coachdeep8_rules.gd` (+ `tools/coachdeep8_sum.py`): copies of `tools/coachdeep7*`
   (do not edit v7's files) with the three changes. Each file under 500 lines. One-rep trial, then the full run.
3. Result `docs/COACHDEEP8_RESULT.md`: verdict first; the seven bars beside v7's numbers; what was tuned (before ->
   after); honest limits. Carry forward v7's build finding in its own section: the game's win read ignores the corner
   coach (`BoutRead.chance` returned the same chance at coach 0 to 100) - open the code today and say exactly where the
   coach argument is dropped and what the corner pick (build step 5) must wire.
4. PASS (7 of 7) -> `ops/research/CRITIC_COACHDEEP8_BRIEF.md` (opens with `ops/research/CRITIC_PACK.md` and
   `ops/research/CRITIC_ACCESS.md`; the game, the v8 rules and the probe's numbers, never our opinion or an earlier score;
   DEPTH and PLAY out of 10, the bar is 8 on both; missing and useless options and what each changes; the list to reach
   10; the critic's own 10/10 as a 1920x1080 HTML page), queued for kalli and dola (`python ops/Tools/seat_queue.py add
   --seat <seat> --brief research/CRITIC_COACHDEEP8_BRIEF.md`); say a code-checked critic is owed.
   FAIL -> which bar, the one change, stop. No further design round in this task.
Nothing under scripts/ or tests/ changes.

## Feedback loops
- NEW, change 1: a warning -> the warned boxer learns and listens worse -> loses more -> loyalty and morale down -> closer
  to the 25 line -> the next moment's blow makes her leave. Caps: only a MOMENT gives a warning (at most one a month, v7);
  a loss never gives one; the warning's cost is a fixed size and fades after 26 weeks. Print, per cell: how many people
  leave while carrying a warning, with the cost on against the cost off (a control arm). STOP if the careless line loses
  more than two people a career on average, or if the careful line loses more than it did in v7.
- NEW, change 1: a warned coach works worse -> his boxers win less -> no raise moment (it needs three straight wins) ->
  no loop back; say so.
- Change 2 is a price; change 3 is a printed line: neither feeds anything back.
- v7's six loops stand (map s13): print the same lines again.
- ONE-REP TRIAL FIRST: one career per cell per arm, printed in full. STOP and fix the page if every cell converges on the
  same best hire, if no arm loses a person, or if a v7 bar that passed now fails in the trial.

## Prior research
`docs/COACHDEEP7_RESULT.md`, `ops/research/DESIGN_COACHDEEP7.md`, `ops/research/COACH_INTERVIEW_S542.md`,
`ops/research/COACHDEEP_GRILL_S539.md`, `docs/COACHDEEP5_RESULT.md` and `docs/COACHDEEP6_RESULT.md` (the measured hiring
swings), `ops/research/topics/staff_coaches.md`.

## What would a human do?
A gym owner who sides against a boxer in a row with her coach gets a boxer who sulks for months before she ever leaves; a
coach who is refused does the minimum. A coach who can teach two things is paid for both.

## Prefab check
None (a rules probe on our own modules).

## Contract
OWNS: ops/research/DESIGN_COACHDEEP8.md, tools/coachdeep8.gd, tools/coachdeep8_rules.gd, tools/coachdeep8_sum.py, docs/COACHDEEP8_RESULT.md, ops/research/CRITIC_COACHDEEP8_BRIEF.md
RED_TEST: tools/coachdeep8.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.
