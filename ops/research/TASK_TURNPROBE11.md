# TASK TURNPROBE11 - run the probe the turning pro map v11 defines, BEFORE any critic scores it (S534 DEPTH METHOD)

Model: claude-fable-5-2 console in this checkout. Measurement only: tools/ and docs/, nothing under scripts/.

## Why
DEPTH_AUDIT_S534: five maps passed critics at 7+ and failed when measured. v11 (`ops/research/DESIGN_TURNPRO1_V11.md`)
names its own probe (its probe section) with today's rules as the control. Run it on a greybox: the map's proposed numbers
applied INSIDE the probe tool (a local copy of the rule, flagged), never in scripts/.

## Do
1. Read v11's probe section and the existing turning pro probes (tools/turn*_probe*.gd, docs/TURNPROBE*_RESULT.md,
   docs/TURNPRO6_RESULT.md, docs/DEBUTPICK1_RESULT.md); extend one of them rather than writing a new one when you can.
2. Arms: today's rules (control) and v11's rules. Population: the probes' own boxers across 46-74 seats (name them in the
   output). Bars from v11 + the audit's: no house and no ask best in more than 6 of 10 cells; each ask best somewhere.
3. Write `docs/TURNPROBE11_RESULT.md`: the table, PASS/FAIL per bar, and what to change if it fails. Plain words.

## Contract
OWNS: tools/turnprobe11.gd (or the extended probe), docs/TURNPROBE11_RESULT.md
RED_TEST: tools/turnprobe11.gd (a measurement probe)
REGRESSION: tests/debut_pick_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who turnprobe11 -- <command>`. Other sessions have uncommitted edits
(LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them. Commit to main, push, report in two lines, stop.
