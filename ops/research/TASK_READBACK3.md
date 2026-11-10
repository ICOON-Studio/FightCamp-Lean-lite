# TASK READBACK3 - QWEN (qwen3-coder) - READBACK2's set-up rule never forgets a win: fix it, measure again

Status: OPEN (S425, Claude main). Discipline: boxing. Model: qwen3-coder. Start your branch FROM qwen/readback2.
Source: READBACK2 (branch qwen/readback2, PR 171, NOT merged) added scripts/rules/ReadBack.gd with two switched-off rules
and measured them: set-up 38.3%, wait-cost 1.5 38.0%, both 39.0% against waited 34.3% and the plain plan 41.3%. Its six
tests pass and its controls reproduce READBACK1 to the decimal. Claude's read of the diff found the fault that makes the
set-up numbers unusable:
- `lv["plan_won"] = true` (LiveRound.gd, about line 314) is set when a planned pick wins and is NEVER cleared. The rule is
  "after another planned line won an exchange earlier in the SAME ROUND"; as written it is "earlier in the bout", so from
  round 2 on nearly every use counts as set up.
- It also counts the waited line's own win as "another line".
- Arm i ("set-up from round 1, she waits from round 1") printed exactly arm d's numbers (38.3%, 986/552/434): the arm did
  not do what its name says.

## Contract
OWNS: scripts/rules/ReadBack.gd, scripts/state/LiveRound.gd, tests/read_back_test.gd, tools/read_back_probe.gd, docs/READBACK1_RESULT.md
RED_TEST: tests/read_back_test.gd -> READ_BACK failures=0
REGRESSION: plan_fight_test, plan_read_test, fight_flow_test, golden_path_test, file_limits_test
BASE: qwen/readback2
VISUAL: no

## The job
1. Make the rule what it says: track WHICH planned line won, per round (cleared when a round starts; find where the
   round's live state is reset and say in the result where). The waited line is set up only when a DIFFERENT planned
   line has won earlier in that round. Keep LiveRound at or under 469 lines; put the bookkeeping in ReadBack where you can.
2. tests/read_back_test.gd: add the cases that would have caught this and show them red on qwen/readback2's ReadBack
   first: a win in round 1 does not set up round 2; the waited line's own win does not set it up; a different line's
   win in the same round does.
3. tools/read_back_probe.gd: controls first (41.3 / 34.3 / 35.0 / 34.3 to the decimal, or stop). Then arms d, e (1.25),
   e2 (1.5), g, h again, and arm i built properly: she waits from ROUND 1 (the `covered` key set before the first bell),
   with and without set-up. For every arm also print, for round 2: how many uses of the waited line were set up and how
   many were not (the proof the arm does what its name says).
4. docs/READBACK1_RESULT.md: add "Round 3" under the existing text (keep rounds 1 and 2): the table, what changed
   against round 2's numbers and why, and the same five sentences. Never tune wait_cost; report 1.25 and 1.5.

## Prior research
ops/research/TASK_READBACK2.md (the rules and the keep / kill bar), docs/READBACK1_RESULT.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
"Thrown behind something" means behind something in THIS exchange of fire, not something that landed ten minutes ago.

## Prefab check
No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://<file> [-- 400]`. Only the tests named here.
RESULT lines for the PR body as in READBACK2, plus `RESULT: set-up uses in round 2 -> <set up> / <not>` per arm.
