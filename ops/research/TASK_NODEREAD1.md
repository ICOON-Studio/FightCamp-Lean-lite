# TASK NODEREAD1 - which move-tree nodes does the played bout read? (probe, no screen)

Status: OPEN (S463, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.
Why: TREEVALUE1 (PROGRESSION_MAP_S448 section 9: "each node at Usable and Sharp ... every node 1.5 in 100 against at least one
style") cannot run until we know which of the 16 MoveTree.NODES the bout actually reads. Claude found that steps/defences are not
read by Bouts/LiveRound (grep: no StepMastery/MoveTree/FireLevel use in scripts/state), and that combos fire from f["combos"]
(LiveRound.gd:94). A node the bout does not read would make TREEVALUE1 void (S450: a probe reading the same in both arms is void).
This probe is the instrument that finds the void nodes.

## What to build (tools/noderead_probe.gd, start from tools/fire_level_probe.gd - it parses and runs)
1. Same bout loop as fire_level_probe._run_cell (Career.quick_start, Data.lucy(), Bouts.fight_step start/shout/corner/end,
   3 rounds, film 0, no shouts), bout["fire_level"] = {} (the game's shares).
2. Four opponents with DIFFERENT styles from Data.OPPONENTS (Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher;
   print each one's name, style and rating). Never two identical fighters.
3. A plan that uses every node the plan can name: take the arrows from PlanFight's situation table (best/ok lists) so that every
   step/defence id in MoveTree.STEP_IDS + DEFENCE_IDS and combos covering every PUNCH_ID appear (print the plan).
4. BASE: every node at 65 (punches in f["moves"], steps/defences in f["steps"], combos in f["combos"] at 65).
5. For each of the 16 nodes: the same 300 paired bouts per opponent (same seeds / c.day as BASE) with ONLY that node at 0, then
   ONLY that node at 95 (for a punch also set every combo containing it, per MoveTree.COMBO_PUNCHES, to the same value; print
   that you did). Count wins.
6. Print one row per node: node, branch, win% at 0 / 65 / 95 per opponent, and READ = yes when any opponent moves 1.0 in 100 or
   more between 0 and 95, else NO. Also print the bout-log difference count (how many of the 300 bouts ended with a different
   outcome or a different landed total vs BASE) - a node with 0 differences is certainly not read.
7. CONTROL: BASE run twice must give the identical win count (determinism). If it does not, stop and print why.
8. Cap: pilot 20 bouts a cell first, print the projected minutes; if over 60 min drop to 150 bouts a cell and say so.

## Pass line
The probe finishes and prints the 16-row table plus `NODEREAD read=<n of 16> unread=<comma list>`. There is no "good" answer:
the deliverable is the true list. The result page docs/NODEREAD1_RESULT.md is WRITTEN BY THE PROBE (its own _write_result_doc
from the run's numbers), never typed by hand. Claude reruns it on the same seeds before reading it.

## Contract
OWNS: tools/noderead_probe.gd, docs/NODEREAD1_RESULT.md
RED_TEST: tools/noderead_probe.gd -> NODEREAD read=
REGRESSION: plan_bout_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Do not "fix" an unread node - only report it.
Runs only through `python ops/Tools/godot_slot.py run --who noderead1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/noderead_probe.gd`.
Under 500 lines. PR body: `RESULT: tools/noderead_probe.gd -> NODEREAD read=<n> unread=<list>`.

## Prior research
PROGRESSION_MAP_S448.md sections 9-10; tools/fire_level_probe.gd; scripts/rules/MoveTree.gd, StepMastery.gd, FireLevel.gd,
PlanFight.gd (read-only); S450 lesson (void probes).

## What would a human do?
A coach checks whether drilling a move ever shows up in a fight before he spends pad nights on it: take it away, add it, watch.

## Prefab check
None: the probe reuses the game's bout.

## The one trap
Setting a node's mastery in a field the bout never reads, then reporting "not read" for the wrong reason. For each node print
WHICH field you set (moves / steps / combos) and read MoveTree.mastery() back to prove the value landed.
