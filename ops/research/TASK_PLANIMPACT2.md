# TASK PLANIMPACT2 - the plan sharpens the corner only where it was drilled for THIS opponent (S550)

Kind: probe (one rule measured on real bouts with switches that live in `tools/`; nothing under scripts/ or tests/
changes). Model: claude-opus-5-5. Discipline: boxing (demo path). Seat: Claude worker in a console tab.
Estimate: about 4 hours, most of it bout runs.

## Why
The owner was asked (board Q-333, S550): "The written plan still adds only 1 to 2 wins. Run a second probe, or accept
it stays small?" He answered: **"Second probe"**. His standing word (Q-328, S548): "make it more impactful" - the
plan screen stays and the plan must be worth writing.
PLANIMPACT1 (`docs/PLANIMPACT1_RESULT.md`) measured three levers. None passed. Lever 2 came closest: a live corner
command whose moment the plan answers is carried out one grade higher. Its fault, from the check
(`ops/research/PLANIMPACT1_CHECK_S549.md`): it pays for HAVING a plan, not for a good one. A careless plan with the
lever is +4.2 / +6.5 over no plan; the best plan beats the careless one by only 2.3 at 3 rounds and 0.9 at 6. And it
is a corner buff: the corner over the file coach went from +10.0 / +12.4 to +14.8 / +19.8.

## METHOD (quote in your first message)
- MECHANICS NEED 8, PROBE FIRST (owner S534). This task measures ONE rule on a greybox. Nothing lands in the game.
- A WORKER'S NUMBERS CAN BE RIGHT AND ITS WHY WRONG: open the code lines first. CONTROL FIRST: with the rule off the
  probe reproduces PLANIMPACT1's lever-off arms bout for bout (its raw runs are in `E:/FightCamp/tmp/planimpact1/`;
  its tools are `tools/planimpact1_probe.gd`, `tools/planimpact1_rules.gd`, `tools/planimpact1_sum.py`).
- THE WRITTEN PLAN STAYS AND MUST MATTER. Never propose shrinking the plan screen.
- NO BALANCING NUMBER: the rule at the strength written below, plus one half-strength arm. Never tune a constant
  until a bar passes.
- NEVER TEST IDENTICAL FIGHTERS; name the population in the output: PLANIMPACT1's ten types and its five women.

## The rule (write it in `ops/research/DESIGN_PLANIMPACT2.md` and commit it BEFORE any run)
PLANIMPACT1's own "lever to design next": **a command is prepared only by a plan line that answers that moment on the
card where THIS opponent's style fights it** (`CoachPlan.cards(style)`: the same game cards the careless plan avoids).
A prepared command is carried out one grade higher (Poor -> OK -> Good); every other command at her own grade, as
today. Boxing reason: a camp drills for the man you are going to meet, not for every fight.
Before the run, write in the design page, from the code: for each of the six styles, which cards
`CoachPlan.cards(style)` gives; for each corner command (`tools/cornercmd2_rules.gd` CMDS), which plan lines prepare
it against each style (a table); and how many of the best plan's lines and the careless plan's lines prepare anything
against each style. If the careless plan still prepares more than a fifth of what the best plan prepares, say so
before running: the rule cannot pass bar 1 and the result page says why instead of spending the hours.

## Arms (reader corner, 3 and 6 rounds, PLANIMPACT1's harness)
No plan; the coach's plan (B58); the best written plan for the style (C); a plan written FOR the corner against that
style; the careless plan (E); one sensible line alone. Each with the rule off, on, and at half strength.
Plus the FILE coach arms needed for bar 3.

## The bars (written here before any run; real bouts, wins in 100, +- 2 SE; per boxer and over all)
1. CHOOSING WELL PAYS (the bar PLANIMPACT1 lacked): best plan minus careless plan, both with the rule on, is 6 or
   more, in most boxers (6 of 10 types).
2. THE PLAN PAYS: the best plan beats the coach's plan by 6 or more, in 6 of 10 types.
3. THE CORNER IS NOT JUST BUFFED: the reader over the FILE coach, with the best plan and the rule on, stays between
   +6 and +15. Over +15 the rule has made the live corner even more the whole game: a FAIL.
4. NOT ONE PLAN: against the six styles no single plan is the best in more than half the cells of a type.
5. A CARELESS PLAN COSTS: the careless plan sits 3 or more under the coach's.
6. NO TRAP: one sensible line alone is never more than 2 under the coach's plan.
7. THE CARD CAN SAY IT: name the read lines (`PlanReadFit.gd`, `BoutRead.gd`) that would have to follow, and whether
   `tests/plan_read_fit_test.gd` would go red. Not built here.
A rule that passes 2 and fails 1 or 3 is a FAIL. If it fails, say plainly whether any rule of this family can pass
bar 1, or whether the plan's worth is capped by something else in the ring: that is the owner's "keep it small" page.

## Not allowed
No change under scripts/ or tests/. One Godot process at a time through
`python ops/Tools/godot_slot.py run --who PLANIMPACT2 -- <command>`; watchdog before each job
(`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait). The owner's game
(ArcheAge) is open: never more than ONE Godot, runs in slices of 20 minutes or less, long runs write to a file under
`E:/FightCamp/tmp/planimpact2/`; headless, `--audio-driver Dummy`, never the `_console.exe`. Another Claude session
works in this checkout on `proto/boxcards/` and `ops/`: commit ONLY your own paths.

## Feedback loops
- The plan raises a command's grade -> the reader's calls win more -> nothing feeds back into the plan inside a bout
  (the plan is fixed at the first bell). One grade is the cap. Print, per arm and style, the share of the reader's
  commands that were raised. If it is over 80% under the best plan, the mapping is too wide; if it is under 10%, the
  rule is too narrow to move anything: say so before the full run.
- The corner's worth feeds the question "is the plan or the corner the game": capped by bar 3.
- One-rep trial before the full run: two types x two styles, 40 paired bouts an arm, all arms. Stop if two arms
  print identical outcome strings (an arm not wired) or if the control does not match PLANIMPACT1.

## Prior research
`docs/PLANIMPACT1_RESULT.md`, `ops/research/PLANIMPACT1_CHECK_S549.md`, `ops/research/DESIGN_PLANIMPACT1.md`,
`docs/PLANWORTH1_RESULT.md`, `docs/PLANREAD2_RESULT.md`, `docs/CORNERBASE1_RESULT.md`,
`ops/research/topics/plans_corner.md`, `ops/research/CORNERREAL1_JOHN_JOHN.md`. Kalli's change (a) on the coach map
(`ops/research/CRITIC_COACHMAP1_BRIEF_KALLI.md`: the corner coach's tactics = how well the boxer hears the call) is
the same lever with a different owner; say in the result whether one rule can serve both or they must not both exist.
Memory notes that apply: probe populations and bout dice; long probes write to a file and wait on the done line.

## What would a human do?
He would first count, on paper, what a careless plan prepares under the new rule. If it is nearly as much as a good
plan, he would not run four hours of bouts to learn it.

## Prefab check
PLANIMPACT1's probe, rules and summary scripts are the harness: preload them, add the one switch.

## Contract
OWNS: tools/planimpact2_probe.gd, tools/planimpact2_rules.gd, tools/planimpact2_sum.py, ops/research/DESIGN_PLANIMPACT2.md, docs/PLANIMPACT2_RESULT.md
RED_TEST: tools/planimpact2_probe.gd
REGRESSION: none under tests/ (nothing in scripts/ changes): the control arm is the regression
VISUAL: none

## Result
`docs/PLANIMPACT2_RESULT.md`: the verdict in four lines for the owner first (plain words, wins in 100); the control;
the rule as written before the run; the seven-bar table, per type; best minus careless per type; the menu table if it
passes; honest limits; how to reproduce. Commit ONLY your own paths with `git commit -m "..." -- <paths>`; do not
push; do not ask questions: decide, and write what you decided.
