# TASK GUARDREV9 - guard v9: the guard lines follow the OPPONENT (owner S537: "try v9")

Model: claude-fable-5-2 (headless on the API credit). Discipline: boxing (demo).
Bar (owner S534): probe first; 8+ DEPTH and 8+ PLAY from two fresh critics; FREE HAND (remove / add / interconnect).

## Why
docs/GUARDPROBE9_RESULT.md FAILED twice: the feet price is real and the natural stance decides per boxer, but "High lines, one
step wider" is best in 6-7 of 10 opponent cells, 1 of 10 cells clear. Cause: the High lines sit on the boxer's OWN trouble
(hurt / tired), so they pay against everyone. Probe 9's own way on: its points 1 + 3, read by boxer as well (2).

## Do
1. Map v9 `ops/research/DESIGN_GUARDDMG1_V9.md` from v8 (CODE file:line for every claim):
   - Guard WHEN-lines ONLY on the opponent's moments (loads up, presses, boxes at range, throws to the body, tiring, hurt).
     "Cover when your boxer is hurt / tired" leaves the plan: a corner shout (v7 2.1 has it).
   - Fewer line sets, each built to beat a different opponent style (e.g. High vs the loader/head-hunter, Loose/elbows-in
     vs the body puncher, Light vs the out-boxer) so they stand apart.
   - The shifted stance has a price on the night (STANCE1 "not owned yet": slower steps + energy until N bouts in it).
   - Menu table: fighter page, camp, fight plan, corner, fight analysis line, 3D feet.
2. Probe 10 `tools/guardprobe10.gd` (guardprobe9's instrument and self-checks; same real boxers, opponents, paired dice, 40
   seeds). Add generated boxers so each natural stance has 2+ boxers (point 2), and read it by boxer AND by opponent cell.
   PASS (all, bars written before the run): every effect moves the result; a guard line costs something measurable; no
   line/stance pair best in more than 5 of 10 opponent cells; at least 4 cells clear of the noise; the best set changes with
   the opponent's style for every boxer; the natural stance is best in some cells and beaten in others.
   `docs/GUARDPROBE10_RESULT.md` with a plain-words section first.
3. PASS -> critic briefs (`python ops/Tools/design_loop.py critic GUARDDMG1_V9 research/DESIGN_GUARDDMG1_V9.md --seat kalli`
   and a code-checked `ops/research/TASK_GUARD9CRIT.md` for Arena), not run by you. FAIL -> which bar broke, one resize; a
   second FAIL comes back to Claude with the cheap build (probe 9 way 4) costed.

## Prior research
docs/GUARDPROBE9_RESULT.md (all), ops/research/DESIGN_GUARDDMG1_V8.md, DESIGN_GUARDDMG1_V7.md, DESIGN_STANCE1.md,
docs/STANCEPROBE1_RESULT.md, memory S531 (the guard protects the head).

## What would a human do?
A coach sets the guard for the man in the other corner: elbows tight against a body puncher, gloves high against a
head-hunter, light and long against a jabber. He doesn't set it for his own boxer getting tired - that is a corner shout.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_GUARDDMG1_V9.md, tools/guardprobe10.gd, docs/GUARDPROBE10_RESULT.md, ops/research/TASK_GUARD9CRIT.md
RED_TEST: tools/guardprobe10.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who guardrev9 -- <command>`, ONE run at a time, output to a file.
If the queue says RED for memory, wait. Commit ONLY your paths: `git add -- <new>` then `git commit -m "..." -- <paths>`.
Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. Co-Authored-By: Claude Opus 5.5
<noreply@anthropic.com>, push, report in two lines, stop.
