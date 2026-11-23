# TASK STEPPAY3 - footwork: give the five steps with no moment a moment (S537)

Status: DONE (collected 263bf5d30; marked S540)

Model: claude-fable-5-2 (Code Mode console). Discipline: boxing (demo).
WORK IN A WORKTREE (probes read the fight code in main right now): `git worktree add E:/FightCamp/wt/s537_steppay3 -b
s537/steppay3 main`, then `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1 -Worktree
E:/FightCamp/wt/s537_steppay3`, and work ONLY there. Push the branch; do not merge into main (Claude merges after the probes).

## Why (docs/STEPPAY2_PHASE4.md, "What is left" 1)
STEPPAY2 made the place pay (PlaceEdge). Five steps still sit under the band because the fight never gives them their moment:
herd fires 0.15-0.2 a bout; push_off is never "best" (0 %); roll_out is best 9 % of its fires; step_in fires 0.4-1.0 a bout
at 7-34 % best; step_out is best 34-48 % but only in your own trouble. No StepEffect.TABLE number fixes that (measured). The
lever is PlanFight.ANSWERS (which situation a step answers) and where the fight deals those situations.
DEPTH rule (S534): a step is a real choice when its VALUE depends on the moment - each of the five needs a moment where it is
the best answer and others where it is wrong.

## Do
1. Measure first with tools/step_fire_fit_probe.gd: for each of the five, the situations it fires in and how often it is best.
2. Give each a moment, boxing-true (topics/footwork.md): herd = the opponent drifting off the ropes toward the open side;
   push_off = a clinch / smother at short range on the inside; roll_out = under a hook flurry on the ropes; step_in = the
   opponent's punch falling short / resetting; step_out = after landing your own shot (exit before the return). Put each in
   PlanFight.ANSWERS and make the fight deal that situation at a real rate (not every round). One rule per step, its own small
   file if needed (no script over 500 lines).
3. Re-gate all ten steps with the STEPPAY2 gate (docs/STEPPAY2_PHASE4.md's table, same population, fighters all differ);
   rewrite the "others 0..+1" leg BY SITUATION (item 3 there). Pass = the five reach the band and the five that pass stay in.
   Result `docs/STEPPAY3_RESULT.md` with the before/after table.
4. Tests: the ones your change touches + golden_path_test, red-first for each new rule.

## Prior research
docs/STEPPAY2_PHASE3.md, docs/STEPPAY2_PHASE4.md, ops/research/STEPS_PAYOFF_SCOPE_S533.md, research/topics/footwork.md.

## What would a human do?
A coach teaches each step for one situation: step out after you land, roll under the hooks on the ropes, push off when he
smothers you, herd him back to the ropes, step in when his jab falls short.

## Prefab check
None (our own fight rules).

## Contract
OWNS: scripts/rules/PlanFight.gd (ANSWERS), new rule files under scripts/rules/ for the moments, tests/<new>_test.gd,
docs/STEPPAY3_RESULT.md, tools/step_fire_fit_probe.gd
RED_TEST: one new test per moment, red on main
REGRESSION: tests/golden_path_test.gd and the step tests STEPPAY2 used
VISUAL: no

## Rules
Godot ONLY through `python ops/Tools/godot_slot.py run --who steppay3 -- <godot.exe> --headless --audio-driver Dummy
--fixed-fps 60 --path <worktree> --script res://...` (never `_console.exe`); long probe output to a file, wait on its done
line, one probe at a time. Read ops/research/GDSCRIPT_TRAPS.md. Commit in the worktree with explicit paths (`git commit -m ...
-- <paths>`), end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push s537/steppay3, report in two lines, stop.
