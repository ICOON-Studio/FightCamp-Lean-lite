# PLANWORTH1 - what the player's WHOLE fight plan is worth today against the coach's plan, in real bouts (S544)

Kind: probe (a measurement; no design, no new rule). Model: claude-opus-5-5 (console tab). Commit only your paths
(`git commit -m "..." -- <files>`), do not push. Godot only through `python ops/Tools/godot_slot.py run --who PLANWORTH1 --
<cmd>` (headless, Dummy audio), ONE run at a time, output to a file, wait on its done line (a killed waiter leaves Godot
running: check by PID). Before each run: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1
-Once`; RED = wait; the owner's game (ArcheAge) in the top list with memory AMBER = wait. Estimate: 2 hours. Size each
full run under 45 minutes on one slot (a real bout cost 18 ms in TELLPLAY1); run the FULL size before any verdict.

## Why
The owner named "make the fight plan fun to design" one of three mechanics to get right before Early Access (S354).
TELLPLAY1 (`docs/TELLPLAY1_RESULT.md`) measured ONE line added on top of the coach's plan: 0.1-0.9 points in the ring. It
did not measure a whole plan, and its arm (the coach's arrows + one player line) may not exist in the game: `BoutNight.gd`
l.197-200 lets the coach write ONLY when the player's plan is empty. Before the owner is asked who should write the plan,
we need today's numbers. Nothing under scripts/ or tests/ changes.

## Questions to answer, in this order
1. CODE READ (file and line for each): when the player writes one line on the plan board and leaves the rest, does the
   bout run the coach's arrows as well, or only that one line? Follow the plan from the board (`PlanBoard`, the fighter's
   `arrows`) to `BoutNight` round 1 and to `BoutRead` l.272. If one written line switches the coach's plan OFF, say so in
   the first line of the result: that is a trap in play today (measure it as arm D below).
2. How many cards does the coach read at 40 / 58 / 74 (`CoachPlan.READ_AT` = [50, 70]) and how many lines may the player
   write (`PlanBoard.arrow_limit`, `StyleName.limit`)?
3. THE MEASUREMENT, real bouts (`BoutNight.play_out`, exactly as `tools/tellplay1_probe.gd` `bout()` plays it: copy from
   it, do not edit it), paired dice, the same ten types and the 180 opponent files (sample at least 30 files a type,
   spread over styles, weapons and weaknesses; name them). Arms:
   - A. NO PLAN, no coach (`Sim.NO_COACH_RATING`).
   - B. THE COACH'S PLAN at 40, 58 and 74 (the player writes nothing).
   - C. THE BEST PLAN A PLAYER CAN WRITE knowing only the opponent's STYLE: fill the arrow limit greedily, each step the
     line that raises the read most (`PlanLines.options`, the read as the chooser only), then play it in real bouts.
   - C2. The same, knowing the whole FILE (style, weapon, weakness; `when` lines allowed). C2 minus C = what the tape adds.
   - D. ONE LINE ALONE: the player's single best line and nothing else (only if question 1 says the coach's plan goes).
   - E. A CARELESS PLAN: the arrow limit filled with the boxer's highest-mastery moves on the cards where they are not
     the best answer (what a player who does not read the cards would write).
   - F. THE WORST PLAN the read can find (the price of a wrong plan).
   Print, per type and over all: wins in 100 for each arm, the differences C-B58, C-B74, C2-C, E-B58, F-A, each with 2 SE.
   Because the read over-read the fade line 4 to 8 times (TELLPLAY1), also print the read's number beside each arm's bout
   number and flag every arm where they differ by more than 3 points.
4. WHERE THE WORTH SITS: for arm C, drop one line at a time and replay (the plan minus line i): which lines carry the
   gain? Is it one line (then the plan is one decision) or spread?
5. DOES THE BEST PLAN DIFFER: over the sampled files, how many different best plans (arm C2) does one type have? If one
   plan is best against more than half of the files, the plan is written once and never again: say so.

## Findings bars (this is a measurement: report against them, do not tune anything to pass)
- (1) PLANNING PAYS: C beats B58 by 5 wins in 100 or more and B74 by 3 or more, for at least 6 of the 10 types.
- (2) THE TAPE PAYS: C2 beats C by 3 or more for at least 6 types.
- (3) A CARELESS PLAN COSTS: E is under B58 for at least 6 types (else writing anything beats thinking).
- (4) NOT ONE LINE: no single line carries more than 60% of C's gain for more than half of the types.
- (5) NOT ONE PLAN: no type has one plan best against more than half of its files.
- (6) NO TRAP: D is not below B58 by more than 2 (a player who writes one line must not be punished for it).

## Result
`docs/PLANWORTH1_RESULT.md`: the answer to question 1 first, then the six bars as PASS / FAIL with the numbers, the
per-type table, where the read and the bout disagree, honest limits. Then, in plain words, which of these is true:
(a) designing the plan pays today and only the one-line-on-a-tell case is small; (b) the plan pays but the tape adds
nothing; (c) the plan barely beats the coach's. No design proposal: the coordinator takes the numbers to the owner.

## Feedback loops
None in the game: nothing is changed, and every arm plays the game's own bout. In the probe: the greedy chooser uses the
read to pick lines and the bout to score them, so a read that over-reads a line (the fade answer) can pick a plan the
bout does not pay - that is why each arm prints both numbers. ONE-REP TRIAL FIRST: one type against six files, every arm,
one bout each printed with its arrows; STOP and fix the probe if arm B58's arrows are not exactly `CoachPlan.write`'s, if
arm C's plan is the same as arm B's, or if the control arm does not reproduce TELLPLAY1's "usual" read for that type.

## Prior research
`docs/TELLPLAY1_RESULT.md`, `ops/research/TELLPLAY_SCOPE_S543.md`, `docs/TURNPROBE18_RESULT.md`, `tools/plan_effect_probe.gd`
(S397: none 45.0%, coach one card 52.8%, two 57.2%, a well-read plan 69.0%, one presser, 600 close bouts - the engine has
changed since), `scripts/rules/CoachPlan.gd` header, `ops/research/DEPTH_AUDIT_S534.md` row 25 (good plan 59.0%, none
45.8%, bad 42.8%: a header comment, not re-measured), `tests/plan_bots_test.gd`, `ops/research/topics/plans_corner.md`.
Run `python ops/Tools/prior_research.py plan worth coach plan arrows` and say which earlier number this replaces.

## What would a human do?
Play the same fifty fights three ways - no plan, the coach's, the one you thought about - and count. If thinking about it
does not win more fights than letting the coach do it, nobody will open the plan board twice.

## Prefab check
None (our own modules; `tools/tellplay1_probe.gd` and `tools/plan_effect_probe.gd` are the starting code).

## Contract
OWNS: tools/planworth1_probe.gd, tools/planworth1_sum.py, docs/PLANWORTH1_RESULT.md
RED_TEST: tools/planworth1_probe.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.
