# TASK STEPPLAN1 - a new fighter's coach plan is worth nothing since the step gate

Status: HELD for the main session (2026-11-14 nightly review). Discipline: boxing. Model: qwen3-coder once the design call is made.
Source: nightly 2026-11-14 (commit 7b7ac6e6): plan_bots_test and plan_test_it_test went red. Cause: f9791ce6 (S463 STEPMASTERY1 gate on).

## What the nightly showed
- plan_bots_test: "a better coach writes a better plan" and "the best coach's plan is worth something" fail.
  plan+corner 0.410, plan+sim 0.409, coach 74 0.348, coach 58 0.348, none 0.354. A coach's plan now does no better than no plan.
- plan_test_it_test: the plan that answers a presser and the one that walks into her win exactly the same (23/59 rounds, 9 bouts each).

## Why
FireLevel.mastery_of reads StepMastery.fire_mastery for steps and defences since f9791ce6. A new signing gets
StepMastery.start_values: step_in / step_out at max(30, 0.55 x footwork), every other step and defence (step_back,
pivot_out, tie_up, cut_off, herd, ...) at 0. A bar of 0 never fires. CoachPlan.write builds plans mostly from those
steps, so a quick-start fighter's coach plan fires none of its answers until they are drilled. The S463 session put the
fixtures of fight_why_test and phase_wire_test at Signature (85) for this reason, but plan_bots and plan_test_it were not
in its list.

## The decision the main session must make first (design, not a fixture)
Either (a) this is the intended game: a fresh fighter cannot use undrilled steps, and these two tests should set the
plan's steps the way fight_why does (they grade the plan, not the drilling); or (b) a coach's plan should be worth
something from day one: start values, CoachPlan.write picking only moves she can fire, or a floor share for a planned step.
(a) changes test fixtures only; (b) changes the game. Do not pick (a) just to go green: plan_bots is the check that a
coach's plan matters, and today in the game it does not for a new fighter.

## Contract (after the decision)
OWNS: (a) tests/plan_bots_test.gd, tests/plan_test_it_test.gd fixtures only; (b) scripts/rules/StepMastery.gd and/or scripts/rules/CoachPlan.gd
RED_TEST: tests/plan_bots_test.gd -> PLAN_BOTS checks=26 failures=0 ; tests/plan_test_it_test.gd -> no FAIL line
REGRESSION: plan_bout_test, fight_why_test, phase_wire_test, fire_level_test, plan_chain_test, bout_read_test, step_mastery_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py step mastery fire level coach plan`. docs/NODEREAD1_RESULT.md; S463_DIGEST.md.

## What would a human do?
A new boxer can only do in a fight what she has worked on; a good coach plans around what she can do.

## Prefab check
None needed.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- ...`, headless, `--audio-driver Dummy`. No thresholds
changed. PR body: `RESULT:` lines for the two red tests.

## The one trap
The forecast must keep mirroring the fight: since the 2026-11-14 review PlanChain.walk takes the step bars (BoutRead passes
fx.steps). Any change to how steps fire goes in FireLevel so both read it.
