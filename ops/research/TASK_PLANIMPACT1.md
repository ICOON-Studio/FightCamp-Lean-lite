# TASK PLANIMPACT1 - make the written fight plan matter (S548)

Kind: probe (levers measured on real bouts with switches that live in `tools/`; nothing under scripts/ or tests/
changes). Model: claude-opus-5-5. Discipline: boxing (demo path). Seat: Claude worker in a console tab.
Estimate: 4-5 hours, most of it bout runs.

## Why
The owner was asked (board Q-328): "A written fight plan adds 2 wins in 100; live corner calls add 10 to 18. Shrink
the plan screen?" He answered, S548: **"make it more impactful"**. So the plan screen stays and the plan must be WORTH
writing. Today it is not: the best plan a player can write knowing the opponent's style wins +1.7 in 100 over the
coach's and +3.0 over no plan (`docs/PLANWORTH1_RESULT.md`, `docs/PLANREAD2_RESULT.md`), while the live corner is
worth about +10 over a coach who reads the file (`docs/CORNERBASE1_RESULT.md`).
Two measured facts say where the worth went:
- The opponent's combo counter (`scripts/rules/ComboCounter.gd`, S540) takes 35% of every repeated plan line's
  exchanges (61% against a counter-puncher). With it off the same 4-line plan is worth +6.4, not +2.7 (PLANREAD2).
  A plan is by nature the same answer repeated, so the counter taxes exactly what a plan is.
- The live corner commands stand on the blind call underneath and ignore the plan (CORNERBASE1 "Honest limits").
  Camp and corner do not talk to each other: what the boxer drilled for this opponent changes nothing about how well
  she carries out a shouted instruction.

## METHOD (quote in your first message)
- MECHANICS NEED 8, PROBE FIRST (owner S534). This task measures LEVERS on a greybox. No rule lands in the game here.
- A WORKER'S NUMBERS CAN BE RIGHT AND ITS WHY WRONG: open the code lines first; every lever has a control arm that
  cannot share its effect. CONTROL FIRST: with every lever off the probe reproduces PLANWORTH1's arms A, B58 and C on
  two types bout for bout (its plans are frozen in `E:/FightCamp/tmp/planread2/plans.json`,
  `E:/FightCamp/tmp/planworth1/`); if the files are gone, rebuild them by its probe and say so.
- THE FIGHT'S DEPTH STAYS IN THE CORNER, LIVE. A lever that makes the corner worth under +6 over the FILE coach
  (CORNERBASE1's reader arm) has moved the depth, not added to it: report it as a FAIL of that lever.
- NO BALANCING NUMBER: a lever is a rule with a boxing reason, at one stated strength, plus one half-strength arm to
  show the slope. Never tune a constant until a bar passes.
- NEVER TEST IDENTICAL FIGHTERS; name the population in the output. Use PLANWORTH1's ten types, plus CORNERBASE1's
  two built boxers (Cara, raw; Jade, all-round) for the lever-2 arms.

## The levers (write each rule in `ops/research/DESIGN_PLANIMPACT1.md` and commit it BEFORE any run)
1. VARIETY BEATS THE COUNTER. Real: a counter-puncher times what he has seen twice; a camp gives two looks for the
   same moment. Rule: when the plan holds TWO OR MORE lines for the same situation, she alternates them, and the
   counter counts each line on its own (as today) - so a doubled situation is read half as fast. Today's rule on which
   line fires for a situation (`PlanChain`, `LiveRound` l.150-330) decides how much is already true: read it first and
   say so. Arms: the C plan; the C plan re-chosen by a greedy that may spend lines on second answers; the counter off
   (the ceiling). The cost is real and must show: a second answer for one moment is a line not spent on another.
2. THE PLAN IS WHAT SHE DRILLED: IT SHARPENS THE CORNER. Real: John's `ops/research/CORNERREAL1_JOHN_JOHN.md` and
   `J55_THE_CORNER_BETWEEN_ROUNDS.md` - a corner gives one or two things to act on, and a boxer acts on what camp
   rehearsed. Rule: a live corner command whose answer is on the written plan (the same call or the same situation's
   line; write the mapping from `tools/cornercmd2_rules.gd` CMDS to plan lines as a table) is carried out one grade
   higher (Poor -> OK -> Good); a command the plan never prepared is carried out at her own grade, as today.
   Arms on CORNERBASE1's harness (reader, 3 and 6 rounds): no plan; coach's plan; C plan; a plan written FOR the
   corner (lines chosen for the commands the reader will need against that style); the careless plan.
   This is the interconnection the owner allowed (S534: "interconnect current and current with needed mechanics").
3. ROUND ONE BELONGS TO THE PLAN. Real: nobody can coach round one from the stool; the first minute is the camp's.
   Rule: no corner command before the first bell's rest (the reader holds its first call until the round-1 corner);
   round 1 is fought on the plan alone. Read first how the game times commands today (`CornerBar.gd`, the live
   corner; CORNERCMD2's probe) and say whether this is already the case. Arms: reader with and without the rule,
   crossed with no plan / C plan.
Then ONE combined arm: the levers that passed alone, together (interactions are the usual surprise).

## The bars (written here before any run; real bouts, wins in 100, +- 2 SE; per type and over all)
1. THE PLAN PAYS: the best written plan beats the coach's plan (B58) by 6 or more, in 6 of 10 types.
2. THE CORNER STILL PAYS: with the lever on, the reader beats the FILE coach by 6 or more (CORNERBASE1 table (a)).
3. NOT ONE PLAN: against the six styles no single plan is the best in more than half the cells of a type.
4. A CARELESS PLAN COSTS: the careless plan (PLANWORTH1 arm E) sits 3 or more under the coach's.
5. NO TRAP: one sensible line alone is never more than 2 under the coach's plan.
6. THE CHOICE IS A TRADE: for lever 1, the plan with second answers and the plan without are each the better one
   against at least two styles (else variety is a free upgrade, not a decision).
7. THE CARD CAN SAY IT: name the read lines (`PlanReadFit.gd`, `BoutRead.gd`) that would have to follow each passing
   lever, and whether `tests/plan_read_fit_test.gd` would go red. Not built here.
A lever that passes 1 and fails 2 is a FAIL. Report every lever's seven bars in one table; say which lever, or which
pair, is the one to design, and what it would show on which menu (the plan board, the bout card, the corner bar, the
result page: a table, as CLAUDE.md "EVERY NEW MECHANIC: WIRED, SHOWN" asks). If no lever passes, say so plainly and
say which single change in the ring's own rules is taxing the plan most: that is the owner's "cut it or keep it".

## Not allowed
No change under scripts/ or tests/. One Godot process at a time through
`python ops/Tools/godot_slot.py run --who PLANIMPACT1 -- <command>`; watchdog before each job
(`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait); long runs write
to a file under `E:/FightCamp/tmp/planimpact1/`; headless, `--audio-driver Dummy`, never the `_console.exe`. Another
worker (MATCHBOTS2) shares this checkout and the Godot queue: its test must run alone, so keep your runs in
slices of 20 minutes or less.

## Feedback loops
- Lever 1: variety -> fewer countered exchanges -> more won exchanges -> her card moves -> different situations
  come up -> different lines fire. Capped by the counter's own chance (0.35 / 0.61) and the line limit (6 with the
  gym's coach). Print the countered share per arm; if it reaches 0 the lever is the counter-off arm in disguise: stop.
- Lever 2: the plan raises a command's grade -> the reader's calls win more -> nothing feeds back into the plan
  inside a bout (the plan is fixed at the first bell). One grade is the cap; print the share of commands that got it.
  If over 80% of the reader's commands are raised under the C plan, the mapping is too wide: narrow it once, with
  the reason written, before the full run.
- Lever 3: none inside a bout (it removes a call).
- The card's read follows the plan (`BoutRead`): not touched here, named in bar 7.
- One-rep trial before every full run: two types x two styles, 40 paired bouts an arm, all arms. Stop if two arms
  print identical outcome strings (an arm not wired) or if the control does not match PLANWORTH1.

## Prior research
`docs/PLANWORTH1_RESULT.md`, `docs/PLANREAD2_RESULT.md`, `docs/CORNERBASE1_RESULT.md`, `docs/CORNERCMD2_RESULT.md`,
`docs/TELLPLAY1_RESULT.md`, `docs/REPEATBITE1_RESULT.md` if present (the counter's numbers),
`ops/research/DESIGN_CORNERCMD1.md`, `ops/research/topics/plans_corner.md` (G70 "plan and corner as one"),
`ops/research/CORNERREAL1_JOHN_JOHN.md`, `ops/research/J55_THE_CORNER_BETWEEN_ROUNDS.md`. Run
`python ops/Tools/prior_research.py fight plan corner drilled camp` and name the study each lever follows.
Memory notes that apply: probe populations and bout dice (quick_start is one boxer whatever the seed; the dice are
the fight day), long probes write to a file and wait on the done line.

## What would a human do?
A designer told "the plan is worth 2, make it matter" would not multiply the plan's edge by three. He would ask what
the ring does to a plan (it counters it) and what a real camp buys (two looks, and a boxer who can do what the corner
shouts), then let the plan decide how good the live corner is - so the two screens need each other.

## Prefab check
None to take: PLANWORTH1's, PLANREAD2's and CORNERBASE1's probes, rules and summary scripts are the harness to reuse
(preload them; copy a function only when it must be switched).

## Contract
OWNS: tools/planimpact1_probe.gd, tools/planimpact1_rules.gd, tools/planimpact1_sum.py, ops/research/DESIGN_PLANIMPACT1.md, docs/PLANIMPACT1_RESULT.md
RED_TEST: tools/planimpact1_probe.gd
REGRESSION: none under tests/ (nothing in scripts/ changes): the control arm is the regression
VISUAL: none

## Result
`docs/PLANIMPACT1_RESULT.md`: the verdict in four lines for the owner first (plain words, wins in 100); the control;
each lever's rule as written before the run; the seven-bar table per lever and for the combined arm, per type; the
menu table for the lever to design; honest limits; how to reproduce. Commit ONLY your own paths with
`git commit -m "..." -- <paths>`; do not push; do not ask questions: decide, and write what you decided.
