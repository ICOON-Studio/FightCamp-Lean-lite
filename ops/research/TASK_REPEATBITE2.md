# TASK REPEATBITE2 - the plan-line counter, refined (P2 + one rule), then build the winner (S539)

Model: claude-opus-5-5 (Code Mode tab). Discipline: boxing (demo). Same Why, owned files, rules and bars as
ops/research/TASK_REPEATBITE1.md (owner Q-S294-306 "Yes, make it bite").

## Where it stands
docs/REPEATBITE1_RESULT.md (ffd91083a): counting every throw taxes everyone (read in 89-97 of 100 bouts for the varied plan).
P2 - the read follows the PLAN's own repeated line, memory across rounds, last bout's top move half-read from film, read at 2 -
passed a, b, c, e and failed d by 2 bouts (varied plan read in 17 of 100, bar under 15; SPAM 34, bar 25-60).

## Do
1. From tools/repeatbite1*, probe P2 plus each of the two rules its result names, separately and together:
   R1. a line repeated for a DIFFERENT situation each time does not count toward the read (a spread plan shares moves across
       situations);
   R2. only uses that WON count toward the read (an opponent studies what hurts him).
   Same population (60 boxers x 6 styles x 3 nights), same bars (a)-(e) unchanged, written before the run.
2. Pick the smallest passing variant and BUILD it exactly as TASK_REPEATBITE1 step 3 says (GAME_ON, PlanRead.gd, the counter in
   the settle, the read_adj record; the live line and the Plan tab line say the counter: "countered: they timed your one-two").
   Red test first tests/repeat_bite_test.gd; REGRESSION as in REPEATBITE1. If none passes: write it, build nothing.
3. Append the tables and the pick to docs/REPEATBITE1_RESULT.md as "REPEATBITE2".

## Contract
OWNS: as TASK_REPEATBITE1 plus tools/repeatbite2.gd, tools/repeatbite2_rules.gd
RED_TEST: tests/repeat_bite_test.gd
REGRESSION: tests/plan_read_shown_test.gd, tests/plan_read_test.gd, tests/result_tabs_test.gd, tests/plan_chart_test.gd, tests/golden_path_test.gd
VISUAL: no

## Rules
As TASK_REPEATBITE1 (godot_slot, one run at a time, output to E:/FightCamp/tmp/repeatbite2/, no script over 500 lines, commit
only your paths, push). End with `python ops/Tools/idle_guard.py ok REPEATBITE2-done`, report in two lines, stop.
