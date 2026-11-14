# TASK TREEVALUE1 - is every move-tree node worth drilling against at least one style? (probe, no screen)

Status: OPEN (S463, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.
Spec: ops/research/PROGRESSION_MAP_S448.md line 280 (TREEVALUE1 row) and line 96 (Herd and Push off stay only if this clears them).

## Why now
NODEREAD1 (docs/NODEREAD1_RESULT.md, Claude rerun S463) found the 10 steps/defences read by no bout, and its bouts set
`fire_level = {}` (every planned line always fires), which hides mastery. S463 wired the STEPMASTERY1 gate
(scripts/rules/FireLevel.gd mastery_of: a step/defence arrow fires by its bar, StepMastery.fire_mastery). So a step's
mastery now reaches the bout ONLY through FireLevel with the game's shares. This probe MUST NOT set `fire_level` on the bout
(absent key = FireLevel.GAME_SHARES: Usable 0.5, Sharp 0.75, Signature 1.0). Print `fire_level key absent: GAME_SHARES` at start.

## What to build (tools/treevalue_probe.gd; start from tools/noderead_probe.gd on main - it parses and runs)
1. Same bout loop as noderead_probe._run_bout, minus the `"fire_level": {}` entry in f["bout"].
2. 60 GENERATED fighters of ours, not one Lucy: Data.fighter_state on varied Data templates or WorldGen boxers, seeded
   (7100-7159); print 5 samples (name, stats technique/fight_iq/footwork, rating). Never two identical fighters.
3. Four opponents of different styles from Data.OPPONENTS (Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher).
4. Plan: the same arrow list noderead_probe uses (every step/defence and combos covering every punch), on every fighter.
5. BASE: every node at 45 (Usable: punches in f["moves"], steps/defences in f["steps"], combos at 45).
6. For each of the 16 nodes, the same bouts (same seeds) with ONLY that node at 0, at 45 (= BASE), and at 70 (Sharp)
   (a punch also sets every combo containing it, MoveTree.COMBO_PUNCHES; print it). Per node per style: win% at 0 / 45 / 70.
   VALUE = win% at 70 minus win% at 0, per style.
7. ANSWERS curve: fighters with 6 and with 9 Usable answer nodes (the rest at 0; pick by PlanFight's answer lists, print
   which), same bouts: win% each.
8. CONTROL: BASE run twice gives the identical win count; and a mutant arm with FireLevel.probe_off = true (every line fires)
   must show every step/defence VALUE within +-0.5 (the gate is what makes them read). Print both.
9. Cap: pilot 10 bouts a cell, print projected minutes; target <= 90 min, else cut bouts per cell and say so.

## Pass lines (print each with yes/no)
- every node: VALUE >= 1.5 in 100 against at least one style (list the nodes that fail - Herd and Push off are the suspects)
- no node is the best (highest VALUE) against all four styles
- wins rise from 6 to 9 Usable answers
Final line: `TREEVALUE pass=<n of 16> fail=<list> best_everywhere=<node|none> answers6=<w> answers9=<w>`.

## Contract
OWNS: tools/treevalue_probe.gd, docs/TREEVALUE1_RESULT.md
RED_TEST: tools/treevalue_probe.gd -> TREEVALUE pass=
REGRESSION: plan_bout_test, fire_level_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Report a failing node; never change a rule to pass it.
The result page is WRITTEN BY THE PROBE (its own _write_result_doc from the run's numbers), never typed or edited by hand -
NODEREAD1's page showed columns its committed probe never writes; Claude reruns on the same seeds and diffs the page.
Runs only through `python ops/Tools/godot_slot.py run --who treevalue1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/treevalue_probe.gd`.
Under 500 lines. PR body: `RESULT: tools/treevalue_probe.gd -> TREEVALUE pass=<n> fail=<list> ...`.

## Prior research
PROGRESSION_MAP_S448.md sections 9-10; docs/NODEREAD1_RESULT.md; tools/noderead_probe.gd; scripts/rules/FireLevel.gd,
StepMastery.gd, MoveTree.gd, PlanFight.gd (read-only); S450 lesson: a probe reading the same in both arms is void.

## What would a human do?
A coach asks of each drill: against which kind of opponent does this ever win me a fight? A drill that wins nothing against
anyone comes off the board.

## Prefab check
None: the probe reuses the game's bout.

## The one trap
Setting `fire_level` on the bout (noderead_probe does) - then every line fires and no step can show a value. Leave the key out.
