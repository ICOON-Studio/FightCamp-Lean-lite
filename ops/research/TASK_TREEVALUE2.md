# TASK TREEVALUE2 - is each footwork / defence step worth 1.5-5 in 100 against its own style? (probe only)

Status: OPEN (S518, Claude main line). Discipline: boxing. Model: Goose (cloud) or qwen3-coder.
Source: map ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md section 9, gate 2 (TREEVALUE2): "each step at Sharp and OK
grade, against its style, lands in 1.5-5 (the section 5 targets within +-1). Against its wrong style it's negative;
against the others it's 0 to +1." The targets are scripts/rules/StepValue.gd TARGET (ESTIMATES). Since TREEVALUE1
(docs/TREEVALUE1_RESULT.md, S463: roll_out, feint, herd, push_off read 0.0 everywhere; step_back only +1.7) the game has
StepEffect (scripts/rules/StepEffect.gd: the ropes count and the steps' effects) and the ropes count in the live round
(scripts/state/StepWire.gd). Nobody has measured the steps since.

## The job
1. EDIT tools/treevalue_probe.gd (on main; keep TREEVALUE1's tables) so it reports TREEVALUE2: for each of the ten steps
   in StepValue.STEPS, against each of the six StepValue.STYLES, 400 bouts a cell, amateur 3 x 3 (the S427 convention:
   three seed sets), the step at Sharp mastery (StepMastery 60) and OK grade, against the SAME plan without that line.
   Win difference in 100 per cell. Do NOT set `fire_level` on the bout (absent key = FireLevel.GAME_SHARES), as
   TREEVALUE1's brief says; print `fire_level key absent: GAME_SHARES` at the start.
2. docs/TREEVALUE2_RESULT.md: a 10 x 6 table of measured win difference beside StepValue.TARGET; per step: its best
   style's cell in 1.5-5? its wrong style negative? the others 0 to +1? PASS / FAIL each, then a count.
3. One line per FAIL naming the StepEffect row that would move it (never change it).
Header line TREEVALUE2; last printed line `TREEVALUE2 done pass=<n>/10`.

## Contract
OWNS: tools/treevalue_probe.gd, docs/TREEVALUE2_RESULT.md
RED_TEST: tools/treevalue_probe.gd -> TREEVALUE2 done
REGRESSION: step_effect_test, fire_level_test, plan_bout_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py step value tree footwork probe`. Read docs/TREEVALUE1_RESULT.md, StepValue.gd,
StepEffect.gd, StepWire.gd, FireLevel.gd, the map sections 3, 5 and 9, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Fight the same boxer 400 times against each kind of opponent with and without one step in her plan, and see how many
more bouts she wins with it.

## Prefab check
None: our own rule; only our own sim can say what a step is worth.

## Rules for this seat
Headless Godot only, `--audio-driver Dummy`, `--fixed-fps 60`. Nothing outside OWNS; never touch scripts/fight3d/. No file
over 500 lines (split helpers into tools/treevalue_cells.gd if needed and add it to OWNS in the PR body). Never test
identical fighters: the two boxers differ in stats, techniques, frame and plan.

## The one trap
A step only acts when its line fires AND its situation comes up: report how often each step fired per bout beside its
win difference, so a 0.0 that means "never fired" is told apart from "fired and did nothing".
