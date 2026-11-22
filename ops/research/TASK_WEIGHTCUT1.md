# TASK WEIGHTCUT1 - weight becomes plain facts: the diet choice is removed, the diet follows the booking (S537)

Model: claude-fable-5-2 (headless on the API credit). Discipline: boxing (demo).
OWNER S537, on six failed weight probes (docs/WEIGHT2_PROBE5.md, docs/WEIGHT3_PROBE.md): "cut the weight choices and keep
weight as plain facts" -> "ok". No weight decision for the player is real (STAY best for our boxer; reading the opponent's
cut moves no plan), so the player is not asked.

## Do
1. Find every place the player picks a weight option today: the week's diet HOLD/CUT (scripts/rules/WeekPlan.gd ctx diet,
   scripts/state/ClubWeek.gd diet(), the week screen that shows it, CardAsk / GuideLines lines that mention it) and any
   move-up / class-change ask. List them with file:line in the result.
2. Remove the CHOICE, keep the FACTS: the diet is decided by the game - CUT only when a booked bout's class limit is below
   the boxer's walking weight by more than the free margin, else HOLD; the screen shows it as a line ("Making 60 kg for
   Saturday: eating light this week"), not a toggle. Weight class, the scales on the tape, walking weight, class match at
   booking, the cost of a forced drain: all stay. Tooltips explain, never repeat the label (S532).
3. Tests red-first: a test that the week screen offers no diet control and that the diet follows the booking; then the tests
   the change touches + golden_path_test (`TESTS="a_test b_test" JOBS=2 sh tools/run_tests.sh`). New features ship ON.
4. `docs/WEIGHTCUT1_RESULT.md`: what was removed, what the player now sees, tests run.

## Prior research
docs/WEIGHT2_PROBE5.md, docs/WEIGHT3_PROBE.md, docs/DEPTHPRICE1B_RESULT.md (diet was a no-op), ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A coach doesn't ask the boxer whether to diet - if he is booked below his walking weight, he eats light that week.

## Prefab check
None.

## Contract
OWNS: scripts/rules/WeekPlan.gd, scripts/state/ClubWeek.gd, the week screen script that draws the diet, any CardAsk /
GuideLines line about the diet, tests/<new>_test.gd, docs/WEIGHTCUT1_RESULT.md
RED_TEST: tests/<new>_test.gd (no diet control; diet follows the booking)
REGRESSION: golden_path_test + the week tests the change touches
VISUAL: no (a later still)

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who weightcut1 -- <command>`. No script over 500 lines. Never stage
LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. `git add -- <new>` then `git commit -m ... -- <your
paths>` with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
