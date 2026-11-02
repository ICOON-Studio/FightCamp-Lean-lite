# TASK ANGLE1B - measure angle_guard on fighters it can act on (NO engine change) - cloud Qwen

Model: Qwen (cloud-agent workflow, label `qwen`). Never open a window.

## Owned files
- `Godot/tests/switch_gate_angle_guard_test.gd` (take it from branch `qwen/issue-79`; change ONLY the population + the printed lines)
- `research/ANGLE1_FINDINGS.md` (append a "## ANGLE1B" section)
DO NOT edit `Godot/scripts/FightRealtime.gd` or any other engine file. A temporary probe under `Godot/tools/` is fine; do not commit
counters into the engine state.

## Prior research
`research/ANGLE1_FINDINGS.md` (your own counts + Claude's verdict at the end - read it first). C228's rule: only fight_iq >= 60
seeks the outside of the opponent's LEAD foot, and the ropes still win when the outside has less floor than the inside by more than
CIRCLE_ROOM_DEADBAND_M (`research/TASK_C228_ANGLES_GUARD.md`).

## What would a human do?
Re-run the same measurement on the people the rule is FOR: a smart boxer (fight_iq >= 60) against an orthodox opponent, 12 seeds.

## Spec
Population: fighter A = fight_iq 65 out-boxer, fighter B = ORTHODOX swarmer fight_iq 45 (two DIFFERENT legal boxers; print both stat
blocks). 12 seeds. Measure the angled-landed share (same definition as the test) ON vs OFF, plus how often `_c228_circle_outside`
returns a direction different from its input (count it in the probe by calling the static function with the same arguments, not by
editing the engine). Print a paired per-seed table + mean + paired diff.

## Done
`$GODOT --headless --path Godot --script tests/switch_gate_angle_guard_test.gd` with the new population: report PASS or FAIL honestly; the
mutant `G158_MUTANT=angle_guard` must FAIL if the ON arm passes. `python3 Godot/tools/check_scripts.py` on the test. Append the numbers to
ANGLE1_FINDINGS.md under "## ANGLE1B". If ON is still no better than OFF for a fighter the rule is meant for, say so plainly - that is the
real engine bug and the next task fixes it.

## The one trap
Never identical fighters, and never change the engine to make the gate green.
