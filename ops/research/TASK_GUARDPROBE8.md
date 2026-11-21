# TASK GUARDPROBE8 - guard v7: does a guard line cost a move line? (the trade, before critics)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).

## Why
docs/GUARDPROBE7_RESULT.md (commit fae139c06): guard v7 PASS - right guard lines +5 in 10/12 cells, wrong -5 in 11/12, a 70%
read still up in 12/12, no line best in more than 7/12. NOT measured: the three guard lines were ADDED to the four-move plans,
never traded for a move line; all seven lines together run 9 to 20 wins up. If a plan has a fixed number of lines (the coach's
arrow limit, BoutNight.arrow_limit / StyleName.limit), a guard line must take a slot from a move line - that trade is the decision.

## Do
Extend tools/guardprobe7.gd into tools/guardprobe8.gd: plans at the game's real line limit; arms = the best four-move plan; the
same plan with ONE move line swapped for the right guard line (each of the three); a wrong swap; and today's control. Same 12
cells, 200 bouts a cell, paired seeds, an sd per difference. PASS = a guard line is worth its slot in some cells and not in others
(a swap beats the four-move plan by 3+ in at least 3 cells AND loses by 3+ in at least 3), no single plan best in more than 7 of 12.
If the game has no hard line limit, say so with the code line and measure what the extra line costs instead (the coach's limit).
Write docs/GUARDPROBE8_RESULT.md. If PASS, write the code-checked critic brief ops/research/TASK_GUARD7CRIT.md in the form of
ops/research/TASK_DMGCLASS1V3CRIT.md (do not run it) and queue the chat critic:
`python ops/Tools/design_loop.py critic GUARDDMG1_V7 research/DESIGN_GUARDDMG1_V7.md --seat john`.

## Prior research
docs/GUARDPROBE6_RESULT.md, docs/GUARDPROBE7_RESULT.md, ops/research/DESIGN_GUARDDMG1_V7.md, DEPTHPRICE1A (flat prices make no choices).

## What would a human do?
A corner has one minute and a few words: "tight guard when he loads up" is said instead of something else. Measure that.

## Prefab check
None.

## Contract
OWNS: tools/guardprobe8.gd, docs/GUARDPROBE8_RESULT.md, ops/research/TASK_GUARD7CRIT.md
RED_TEST: tools/guardprobe8.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who guardprobe8 -- <command>`. Never stage LineGrade.gd, LiveRound.gd,
StepWire.gd. Stage explicit paths, commit to main with the Co-Authored-By line, push, report in two lines, stop.
