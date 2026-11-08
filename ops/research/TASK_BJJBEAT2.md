# TASK BJJBEAT2 - CURSOR (Grok 4.7 High) - BJJBEAT1 round 2: the last two bars, with a key that does not trade them

Status: OPEN (S404, Claude main). Round 2 of PR #91 (branch cursor/bjjbeat1, NOT merged). Model: Grok 4.7 High. Discipline: no-gi BJJ.

## Contract
BASE: cursor/bjjbeat1
OWNS: scripts/rules/BjjBeat.gd, scripts/rules/BjjTree.gd, scripts/rules/BjjWalk.gd, tests/bjj_beat_test.gd, tests/bjj_beat_on_test.gd
RED_TEST: tests/bjj_beat_on_test.gd -> BJJ_BEAT_ON failures=0
REGRESSION: bjj_, golden_path_test
VISUAL: no

## Where round 1 stopped (read from PR #91's body and CI)
Every bar passes at 1000 bouts except two, and both round-1 levers trade one against the other:
- Four-stripe blue wins 0.796 against a cap of 0.76 (BJJ_BEAT_ON).
- Brown submission attempts 0.479 a minute against a floor of 0.50 (BAR 4a in tests/bjj_tree_sim_test.gd).
- `MAT_ATT` / `MAT_DEF`: 0.66 / 0.94 holds the belt floors, four-stripe blue 0.796. 0.58 / 0.85 gives 0.751, but black over purple, black over blue and brown over blue fall to about 0.82, 0.91, 0.85.
- `BEAT2_S`: 11 s gives 0.479 attempts. 10.4 s gives 0.507, but black over brown rises to 0.728 (cap 0.72).

## Do
1. Stop using those two global levers. Each one moves every belt row, which is why they trade.
2. Four-stripe: add one key that acts only on the stripe edge inside a belt (stripes against a fresh same-belt opponent), so belt-gap rows do not move.
3. Attempts: add one key that raises how often a brown belt chooses to attempt a submission inside a beat, not how many beats there are. It must leave win shares alone, so check the whole belt table after it.
4. PR #91's body gives 4-stripe as both 0.729 and 0.796. State which row each number is, from one run.
5. All bars at once, n >= 1000. Do not loosen a bar and do not drop samples. If a bar still cannot be met, STOP and write both numbers and the key that trades them in the PR body.
6. Not yours: `boxer_footwork_test` and `ring_feet_test` already fail on main; `pro_ladder_test` failed on #91's CI from an older base. Do not touch boxing, scripts/ui, ops/ or tools/run_tests.sh. BjjWalk is 488 lines: new code goes in BjjBeat.gd.
7. Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`. Work in small commits.

## Result lines (PR body)
RESULT: BJJ_BEAT_ON failures=<n>
RESULT: BJJ_TREE_SIM failures=<n> brown attempts <x>
RESULT: white subs <x> attempts <x> ref <x> | first scorer <x> | stall white <x> black <x>
RESULT: belt table one <x> white->blue <x> brown->black <x> two <x> 4-stripe blue <x> 4-stripe white <x>
RESULT: keys changed <KEY old -> new, ...>

## Prior research
ops/research/BJJ_REALISM_S397.md (v2 table and the five paper rounds); ops/research/TASK_BJJBEAT1.md (the bars); PR #91's body.

## What would a human do?
A coach knows a four-stripe blue is only a little better than a fresh blue, and a brown belt goes for the finish often. Those are two separate facts about people, so they get two separate dials.

## Prefab check
None: this is tuning our own rule tables.
