# TASK GUARDREV8 - guard v8: the stance merged into the guard lines; the natural stance as a trait (owner S536 "Yes, merge it")

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Bar (owner S534): probe first; 8+ DEPTH and 8+ PLAY from two fresh critics; FREE HAND (remove / add / interconnect).

## Why (Claude, S536)
- Guard v7 (ops/research/DESIGN_GUARDDMG1_V7.md, GUARDPROBE7 PASS) made the guard a fight-plan WHEN-line. GUARDPROBE8
  (docs/GUARDPROBE8_RESULT.md) FAILED: a guard line costs no punch line - "the slot is free", so it is never a trade.
- STANCEPROBE1 (docs/STANCEPROBE1_RESULT.md, map ops/research/DESIGN_STANCE1.md) FAILED twice: the 9-cell stance pad's
  choices are too close (1 of 10 cells clear). Its own way out: the feet grade the guard lines.
- The owner's decision (S536, on that choice): merge. Each boxer keeps a NATURAL stance from his frame as a TRAIT, shifted
  one step by pad weeks (the probe's "keep it small" option); the stance's per-fight weight lives in the guard.

## Do
1. Map v8 `ops/research/DESIGN_GUARDDMG1_V8.md` from v7 + DESIGN_STANCE1 (CODE file:line for every claim): the guard WHEN-line
   is paid for by the FEET - a guard line (Hands High / Hands Loose / ...) works fully only in a stance width that suits it
   and costs step speed or leg drain otherwise, so choosing a guard line is choosing how he stands for that part of the fight.
   The natural stance (a trait on the fighter page and the tape, moved one step by pad weeks) sets which guard lines are cheap
   for this boxer. Include the weight lean only with a new trade (probe 1: Back won everywhere) or drop it. The menu table:
   fighter page (natural stance), camp (pad weeks to shift it), fight plan (guard WHEN-lines with their foot cost), corner,
   fight analysis line, the 3D feet.
2. Probe 9 `tools/guardprobe9.gd` (copy the pattern of guardprobe7/8 and stanceprobe1: real boxers, real bouts, paired dice,
   40 seeds, errors per cell). PASS (all): every effect moves the result; a guard line now COSTS something measurable
   (the probe 8 bar); no line/stance pair best in more than 6 of 10 cells; at least 4 cells clear of the noise; the natural
   stance is not always the cheapest answer. `docs/GUARDPROBE9_RESULT.md`.
3. PASS -> critic briefs (chat via `python ops/Tools/design_loop.py critic GUARDDMG1_V8 research/DESIGN_GUARDDMG1_V8.md --seat kalli`
   and a code-checked `ops/research/TASK_GUARD8CRIT.md` for Arena), not run by you. FAIL -> which bar broke; one resize; a
   second FAIL comes back to Claude.

## Prior research
DESIGN_GUARDDMG1_V7.md, docs/GUARDPROBE7_RESULT.md, docs/GUARDPROBE8_RESULT.md, DESIGN_STANCE1.md, docs/STANCEPROBE1_RESULT.md,
docs/mockups/s536/stance.png, memory S531 (the guard protects the head), research/topics/footwork.md.

## What would a human do?
A coach does not pick "hands high" in a vacuum: a high guard wants planted feet, a loose guard wants light feet. He sets
both together, and he starts from how the boxer naturally stands.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_GUARDDMG1_V8.md, tools/guardprobe9.gd, docs/GUARDPROBE9_RESULT.md, ops/research/TASK_GUARD8CRIT.md
RED_TEST: tools/guardprobe9.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who guardrev8 -- <command>`, ONE run at a time (a killed waiter leaves
its Godot running outside the queue). If the queue says RED for memory, wait for it - do not start Godot outside the queue.
Commit ONLY your paths: `git add -- <new file>` then `git commit -m "..." -- <paths>`. Never stage LineGrade.gd, LiveRound.gd,
StepWire.gd, MHRig.gd, tools/export.sh. Commit to main with the Co-Authored-By line, push, report in two lines, stop.
