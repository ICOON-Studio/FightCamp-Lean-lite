# TASK WEIGHT2R4 - weight probe round 4: re-size so a hard cut can cost and cells clear the noise, then critics

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S535: "Go deep with weight mechanic for 10/10 it should be manageable to a certain point and affect various things about
fighters performance,scaling etc". Bar (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe.

## Why round 4 (Claude's read of docs/WEIGHT2_PROBE3.md, S536)
Round 3 "PASS, weak": best CUT 4 / STAY 2 / UP 2 / DOWN 2, but 0 of 10 cells clear of the noise and CUT is in the leading group
of ALL 10 cells - cutting harder is never worse. Two causes in the probe's own table:
1. AMATEUR: CUT = STAY + a flat 2 kg. Its water part (1.5-2.4 % of body) sits under John's free first 2 % (Reale 2018, SOURCED),
   so its Stamina cost is 0.0-0.5 % in every amateur cell except the drained cutter. A flat-kg choice cannot reach the costly band.
2. PRO: regain 7.2 % (Murugappan & Reale 2022, SOURCED) leaves "dry at the bell" 0.0 % in every pro cell, and the knee is 5 %, so
   CUT (1.5-2.4 % by water) and most DOWNs pay nothing on the night; their only price is a rare miss.
And the noise: +- 0.4-0.6 rungs at 20 seeds against gaps of ~0.3-1 rung.

## Do
1. Re-size in `tools/weight2_probe.gd` (scratch model only; nothing under scripts/):
   - Size the cut choices as a SHARE OF BODY WEIGHT, not kilos: CUT = the class line reached with about 4 % of body by water
     (above the free 2 %, inside John's amateur cap 5 % / 3 % by water marked unsafe), DOWN = the class below; STAY as now.
   - Pro regain is not a constant: tie it to John's numbers (the 7.2 % mean, one in five 10 %+) as a share of what was cut by
     water, so a pro who cut 6-8 % does box short of it; keep the knee and his 8 % cap. Tag every number; no new ESTIMATE
     without saying so.
   - The camp cost of the diet (diet_cost) must show in the pro cells: a long diet costs training weeks (John: 0.7 %/week keeps
     lean mass) - check it is actually applied in the cell runs, print it as a column.
   - 40 seeds a cell (paired, same dice per seed). If the queue is slow, 40 seeds on the 10 cells only; levers at 3 seeds.
2. PASS (all): every lever moves; no choice best in more than 6 of 10 cells; at least 4 of 10 cells CLEAR (no other choice
   inside the noise); CUT-harder in the leading group of at most 6 cells; at least one amateur cell where CUT is clearly WORSE
   than STAY. Write `docs/WEIGHT2_PROBE4.md` (same tables as round 3 + the diet column).
3. If PASS: update map `ops/research/DESIGN_WEIGHT2_V2.md` (sizes as shares, the regain rule; CODE file:line kept) and update the
   inputs of `ops/research/TASK_WEIGHT2V2CRIT.md` to probe 4. Do NOT run that critic yourself (it must be a fresh read):
   Claude launches it. If FAIL: name the lever that broke; one more resize;
   a second FAIL comes back to Claude with the numbers.

## Prior research
docs/WEIGHT2_PROBE3.md, ops/research/DESIGN_WEIGHT2_V2.md, ops/research/JOHN_WEIGHT2_RESEARCH_JOHN.md (verify each number
against its source line), DEPTH_AUDIT_S534.md (a choice is real when its value depends on the moment).

## What would a human do?
An amateur coach knows a boxer weighed an hour before boxes with the cut: a big cut is a gamble on a short fight. A pro coach
cuts hard because the day back pays - unless the cut is so big the day cannot give it back.

## Prefab check
None.

## Contract
OWNS: tools/weight2_probe.gd, docs/WEIGHT2_PROBE4.md, ops/research/DESIGN_WEIGHT2_V2.md, ops/research/TASK_WEIGHT2V2CRIT.md
RED_TEST: tools/weight2_probe.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who weight2r4 -- <command>` (busy queue - be patient). Never stage
LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. Stage explicit paths, commit to main with the Co-Authored-By
line, push, report in two lines, stop.
