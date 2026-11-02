# TASK_COMBOFLOW1 - build your own combos: how well a chain of punches flows (Qwen)

Model: Cursor (cursor_task.cmd). Discipline: BOXING = demo work (operator Q-S294-71 "Yes, build it", Playbook build
step 3). Repo: **E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_COMBOFLOW1, branch `cursor/comboflow1`). Lean rules: its
CLAUDE.md, no script over 500 lines, Godot headless only, nothing opens on the screen.

## Why
The Playbook page (S348, `scripts/ui/areas/Playbook.gd`) gets a Combos tab: the player chains single moves (jab, cross, lead
hook, body hook, uppercut, slip, pivot, step in) and the game rates the chain. A chain thrown the way real boxers throw it
(the weight shift of one punch loads the next) rates better than a clumsy one, so knowing boxing pays. This task is the
rating, a pure rule module. Claude builds the tab on it.

## Spec - NEW `scripts/rules/ComboFlow.gd` (extends RefCounted, static functions only, NO preloads)
Moves (ids): `jab, cross, lead_hook, body_hook, rear_uppercut, lead_uppercut, rear_hook, slip, roll, pivot, step_in,
step_back`. `const MOVES` gives each one `{"hand": "lead"|"rear"|"", "level": "head"|"body"|"", "kind": "punch"|"defence"|
"step", "loads": "lead"|"rear"|""}`. `loads` = which side the move leaves her weight on, ready to fire next: a cross rotates
her onto the lead side, so it loads the lead hook; a lead hook loads the rear hand; a slip outside the jab loads the rear
hand; a roll under a hook loads the hook back the other way.
- `static func rate(chain: Array) -> Dictionary` returns `{"score": 0..100, "word": "flows"|"workable"|"clumsy",
  "notes": [plain-words reasons, one per finding]}`. The rules a coach uses (write each as a named const with a comment):
  1. Alternate hands: each switch to the loaded hand is good; the same power hand twice in a row (cross, cross; rear hook
     after a cross) is slow - it has to reload. A double jab is fine (the jab is the exception: it resets fast).
  2. Load: a punch thrown off the side the last move loaded scores; against it costs.
  3. Levels: going to the body then back to the head (or the other way) scores once a chain ("go downstairs, then up").
  4. Defence into offence: slip/roll then the loaded punch scores (a counter); a step in before the first punch is fine.
  5. Length: 2-4 punches is a combination; every punch past 4 costs (accuracy falls and she is open).
  6. A chain must start with a lead-hand punch, a defence or a step, unless it is a counter (after a defence).
  `word`: flows >= 70, workable 45-69, clumsy < 45.
- `static func energy(chain: Array) -> float`: the cost in the tank units of `scripts/rules/Combos.gd` (PUNCH_COST, FAST_PUNCH,
  POWER_MIX). Read that file: same formula for punches, defences and steps cost 0.5x a punch.

## The test - NEW `tests/combo_flow_test.gd` (extends SceneTree; prints `COMBO_FLOW failures=<n>`)
1. Every combo in `Combos.BOOK` (its `beats`), and the counter `slip 2-3` with its slip in front, rates "flows". The book is
   the coaches' set, so this is the control arm.
2. Clumsy: `cross, cross, cross`; `lead_hook, lead_hook, lead_hook`; `cross, rear_hook, rear_uppercut`; a 7-punch chain of
   jabs and crosses; `rear_uppercut` alone as an opener - each rates below the worst book combo, and at least three rate
   "clumsy".
3. Each rule moves the score the right way on a pair that differs only by it (e.g. `jab, cross, lead_hook` beats
   `jab, cross, rear_hook`; `jab, cross, body_hook, lead_hook` beats `jab, cross, lead_hook, lead_hook`).
4. Notes: every rated chain gives at least one note in plain words; a clumsy one names what made it clumsy.
5. Energy: a longer chain costs more; a 3-punch chain costs what Combos' formula gives for 3 (within 0.01).

## Contract
OWNS: Lean/scripts/rules/ComboFlow.gd, Lean/tests/combo_flow_test.gd
RED_TEST: tests/combo_flow_test.gd -> COMBO_FLOW failures=0
REGRESSION: combos_test, strike_map_test
VISUAL: no

## How to run (exact)
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/combo_flow_test.gd`
Test first, run it red, then the module. Never the `_console.exe`.

## The trap
Do not tune the numbers per test case. The weights are a coach's rules (one const each, explained), and the book is only
checked, never fitted to: if a book combo fails a rule, say so in your answer.

## Prior research
`python Tools/prior_research.py combo punch sequence` -> J_COMBOENERGY1_JOHN.md (energy numbers, already in Combos.gd),
STRIKEMAP_S335.md (the move map), CompuBox punch categories (jab vs power). Combos.gd BOOK (the 10 coach combos).

## What would a human do?
A boxing coach judges a combination by balance and rhythm: does each punch put her weight where the next one comes from,
does it switch levels, does it end with her guard home? The numbered system (1 jab, 2 cross, 3 lead hook, 4 rear hook,
5 lead uppercut, 6 rear uppercut, b = body) is how coaches call them on the pads; the rules above are those calls.

## Prefab check
No library rates punch sequences; fighting games hard-code their combo lists (cancel windows), which is the opposite of
letting the player build one. A small rule table is the right size.
