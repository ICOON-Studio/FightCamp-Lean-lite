# TASK STEPPAY4 - footwork: the wrong style punishes the step (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: boxing (demo).
WORK IN A WORKTREE (other probes read main's fight code): `git worktree add E:/FightCamp/wt/s538_steppay4 -b s538/steppay4
main`, then `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1 -Worktree
E:/FightCamp/wt/s538_steppay4`, and work ONLY there. Push the branch; do not merge into main (Claude merges after reading).

## Why (docs/STEPPAY3_RESULT.md, table + "Not done" 1)
STEPPAY3 put all ten steps' FOR leg in the band (1.5..5 wins in 100). Only 5 of 10 pass all three legs: step_in, step_out,
step_back, pivot_out and herd FAIL THE WRONG LEG - the style that should punish the step reads >= 0 (step_in vs Pressure
+0.50, step_out vs Out-boxer +2.92, step_back vs Out-boxer +0.67, pivot_out vs Out-boxer +0.42, herd vs Pressure +1.25).
step_back also reads +5.17 vs the Slugger (over the band top). DEPTH rule (owner S534, "mechanics need an 8"): a step is a
real choice only when it is the best answer in its moment and a real mistake in the wrong one. Without the wrong leg, the
right plan is "take every step" - a solved choice.

## Do
1. Measure first: for each of the five, in the wrong style's bouts, what the step costs today (exchanges lost, damage taken,
   StepWire.holds) - tools/step_fire_fit_probe.gd and treevalue_probe.gd `when=best only=<steps>`.
2. Give each wrong situation a boxing-true cost (research/topics/footwork.md): step_in into a pressure fighter walks onto his
   punches (he meets you, you lose the exchange); step_out / step_back / pivot_out against an out-boxer give him the range he
   wants (free jabs, round slips away on points); herd against a pressure fighter wastes the step - he comes anyway and you
   are flat-footed. One rule each, small file(s) if needed, read from the situation the fight already deals. No new layer
   on top of StepEffect numbers if a situation rule does it; no StepEffect.TABLE tuning to force a sign.
3. Bring step_back vs Slugger under 5.0 by the same means (the Slugger moment, not a global number).
4. Fix tools/treevalue_cells.gd's summary line (prints the old leg, pass=0/10) so it prints the three legs as the result table.
5. Re-gate all ten with the STEPPAY3 gate (same population, 400 bouts x 3 seed sets, same bars, fixed BEFORE the run). Pass =
   the five now read < 0 on their wrong leg, FOR leg stays in 1.5..5 for all ten, the five that passed still pass. Also re-run
   tools/place_value_probe.gd's whole-game mix once (STEPPAY3 "Not done" 4) and report the shift.
6. docs/STEPPAY4_RESULT.md in STEPPAY3's shape (before/after table, thin margins said plainly).
7. Tests: one red-first test per new rule, the step tests STEPPAY3 used, tests/golden_path_test.gd.

## Prior research
docs/STEPPAY3_RESULT.md, docs/STEPPAY2_PHASE4.md, ops/research/STEPS_PAYOFF_SCOPE_S533.md, research/topics/footwork.md,
ops/research/DEPTH_SCOPE_S534.md.

## What would a human do?
A coach says: never step straight in on a pressure fighter, he meets you; never back off an out-boxer, you hand him his range.

## Prefab check
None (our own fight rules).

## Contract
OWNS: scripts/rules/PlanFight.gd, scripts/rules/StepWrong.gd (new, if needed), tests/step_wrong_test.gd (new),
tools/treevalue_cells.gd, tools/step_fire_fit_probe.gd, docs/STEPPAY4_RESULT.md
RED_TEST: tests/step_wrong_test.gd red on main
REGRESSION: tests/golden_path_test.gd and the step tests STEPPAY3 used
VISUAL: no

## Rules
Godot ONLY through `python ops/Tools/godot_slot.py run --who steppay4 -- <godot.exe> --headless --audio-driver Dummy
--fixed-fps 60 --path E:/FightCamp/wt/s538_steppay4 --script res://...` (never `_console.exe`); long probe output to a file,
one probe at a time. Read ops/research/GDSCRIPT_TRAPS.md. No script over 500 lines. Never stage LineGrade.gd, LiveRound.gd,
StepWire.gd, MHRig.gd, tools/export.sh unless the rule needs it (then say why). Commit in the worktree with explicit paths
(`git commit -m ... -- <paths>`), end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push s538/steppay4,
report in two lines, stop.
