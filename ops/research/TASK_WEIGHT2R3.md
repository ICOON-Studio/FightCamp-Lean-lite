# TASK WEIGHT2R3 - weight map v2: the owner's answers + John's real numbers, probe round 3, then two fresh critics

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S535: "Go deep with weight mechanic for 10/10 it should be manageable to a certain point and affect various things about
fighters performance,scaling etc". Bar (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe.

## Inputs
- `ops/research/DESIGN_WEIGHT2.md` (map v1, from the code) and `docs/WEIGHT2_PROBE.md` (round 2 PASS on ESTIMATES: STAY 5, CUT 2,
  UP 2, DOWN 1 of 10 cells; 20 seeds x 12 bouts).
- John SQ278: `ops/research/JOHN_WEIGHT2_RESEARCH_JOHN.md` - verify each number you use against his source line; keep his tags.
  Key: a cut costs REPEAT EFFORT (tank, late rounds) far more than punch power (3% cut: punch -3 to -5%, repeat efforts -19 to -28%);
  pros regain ~7.2% body mass and each 1% regained x1.13 the odds; elite amateurs regain 1.5-2.1% in 3-12 h, ~0.3-1% in 1 h
  (ESTIMATE); safe: <= 5% (<= 3% by water) with <= 6 h to recover, <= 8% with > 12 h; camp pace 0.7%/week keeps lean mass;
  growth ~1 amateur class a year at 16-18; the lighter boxer on the night is stopped more (Baribeau 2023).
- Owner answers: Q-292 "Add men's 65 kg" (on branch s535/dmgfix, "mlm"); Q-293 "Yes, he can refuse" (a boxer may refuse a class
  move: his goal, morale and loyalty decide; say what it costs to push him); Q-294 "Yes, after the probe" (the 3D body shows his
  weight - design the read: which bones / blend, bounds; built only after critics pass).

## Do
1. Map v2 `ops/research/DESIGN_WEIGHT2_V2.md`: replace every ESTIMATE John answers with his number (tagged), add the refusal
   (Q-293) and the 3D body read (Q-294), the 65 kg class in the class ladder, keep "three decisions, one screen". CODE file:line
   for every claim.
2. Probe round 3: `tools/weight2_probe.gd` with John's numbers; 20 seeds x 12 bouts; add the refusal (a boxer who refuses a move
   sometimes) and print an error (sd) per cell so a "best" inside the noise is called a tie. PASS = the round-2 bars hold with
   John's numbers. `docs/WEIGHT2_PROBE3.md`.
3. If PASS: critic briefs with `python ops/Tools/design_loop.py critic WEIGHT2_V2 research/DESIGN_WEIGHT2_V2.md --seat kalli`
   (chat critic, queued) AND write a code-checked critic brief `ops/research/TASK_WEIGHT2V2CRIT.md` in the form of
   `ops/research/TASK_DMGCLASS1V3CRIT.md` (it checks every CODE claim) - do not run that critic yourself; Claude launches it.
   If FAIL: say which lever broke and resize once; a second FAIL comes back to Claude.

## Prior research
DESIGN_WEIGHT2.md section 7 (risks), BOARD_WEIGHT1_R5_S478.md, DEPTH_AUDIT_S534.md, memory project_s535_weight_deep_guard_plan_line.

## What would a human do?
Weigh the evidence, not the guess: the drain is a stamina story first; the pro gets most of it back, the amateur boxes with it.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_WEIGHT2_V2.md, tools/weight2_probe.gd, docs/WEIGHT2_PROBE3.md, ops/research/TASK_WEIGHT2V2CRIT.md
RED_TEST: tools/weight2_probe.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who weight2r3 -- <command>` (busy queue; the owner may be playing - be
patient). Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. Stage explicit paths, commit to main
with the Co-Authored-By line, push, report in two lines, stop.
