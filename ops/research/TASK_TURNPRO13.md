# TASK TURNPRO13 - turning pro v13: drop the Softer ask, make the name last, re-probe (S536 FREE HAND decision)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Bar (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe. FREE HAND (owner S534): remove / add /
interconnect to reach 8, then report.

## Why (Claude, S536, reading docs/TURNPROBE12_RESULT.md, 66833a990)
Probe 12 = FAIL 10/15, the second FAIL in a row (11 and 12). What works: the house fork is a real trade - the ticket house
+$1,518..+$1,656 for -23 debut wins in 100 with room in the gym, only +$619 in a full gym, so the right house depends on the
moment (DEPTH rule: a choice is real when its value depends on the moment). What fails: Softer is right in 0 of 4 cells, and
the name does not stay. Decision: take the probe's own v13 - DROP the Softer ask (a choice that is never right is not a
choice), make the name last across the first six fights, card at 78, every other ask cut but Later +2.

## Do
1. Map v13 `ops/research/DESIGN_TURNPRO1_V13.md` from v12 with those changes; CODE file:line for every claim; the menu table
   (which screen shows the fork, the name, Later) kept.
2. Probe 13 on tools/turnprobe12* (copy to turnprobe13*), same population and pairing as 12; the bar of 12 (audit bar 8
   included); `docs/TURNPROBE13_RESULT.md`.
3. PASS -> critic briefs: a chat critic via `python ops/Tools/design_loop.py critic TURNPRO1_V13 research/DESIGN_TURNPRO1_V13.md
   --seat john` and a code-checked brief `ops/research/TASK_TURNPRO13CRIT.md` (form of TASK_WEIGHT2V2CRIT.md) - do not run it
   yourself. FAIL -> stop and write which lever broke; it comes back to Claude (a third fail = cut-or-keep to the owner).

## Prior research
docs/TURNPROBE11_RESULT.md, docs/TURNPROBE12_RESULT.md, ops/research/DESIGN_TURNPRO1_V12.md, DEPTH_AUDIT_S534.md.

## What would a human do?
A manager offered two promoters weighs money now against a safe first run; nobody asks for a softer opponent when the
promoter picks a debut opponent to suit the boxer anyway (DEBUTPICK1).

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V13.md, tools/turnprobe13.gd, tools/turnprobe13_rules.gd, tools/turnprobe13_sum.py,
docs/TURNPROBE13_RESULT.md, ops/research/TASK_TURNPRO13CRIT.md
RED_TEST: tools/turnprobe13.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who turnpro13 -- <command>`. Never stage LineGrade.gd, LiveRound.gd,
StepWire.gd, MHRig.gd, tools/export.sh. Stage explicit paths, commit to main with the Co-Authored-By line, push, report in two
lines, stop.
