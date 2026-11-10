# TASK READBACK2 - QWEN (qwen3-coder) - she waits for your best plan line, round 2: two ways back as switched-off rules, measured

Status: OPEN (S425, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: READBACK1 (on main: tools/read_back_probe.gd, docs/READBACK1_RESULT.md) measured that when her corner waits for
Lucy's best plan line the bout is 7.0 points worse (41.3% -> 34.3%), most of it in round 2, and that neither dropping the
line (35.0%) nor swapping it (34.3%) wins anything back. The arms a real coach would try could not be measured without a
rule in the game. This task adds those rules SWITCHED OFF (no bout key = the game exactly as today) and measures them.
The operator: "more interactive with deicions/choices"; a mechanic that only takes points away cannot be built.

## Contract
OWNS: scripts/rules/ReadBack.gd, scripts/state/LiveRound.gd, tests/read_back_test.gd, tools/read_back_probe.gd, docs/READBACK1_RESULT.md
RED_TEST: tests/read_back_test.gd -> READ_BACK failures=0
REGRESSION: plan_fight_test, plan_read_test, fight_flow_test, golden_path_test, file_limits_test
VISUAL: no

## The job
1. A new pure module scripts/rules/ReadBack.gd (static functions, no preloads beyond what it needs, under 120 lines). Move
   the S423 probe hook out of LiveRound into it: LiveRound.gd line 286-287 today reads `bout.covered` ({} = the game today;
   0..1 keeps that share of a planned line's edge; below 0 = waited for, a wrong answer). LiveRound is 469 lines and its
   cap is 470 (tests/file_limits): after your change it must be 469 lines or fewer. Read the 30 lines around the hook
   first; change nothing else in LiveRound.
2. Two new rules in ReadBack, each read from a bout key and OFF when the key is absent:
   - `set_up` (bool): a waited line that is used AFTER another planned line of hers won an exchange earlier in the same
     round is NOT waited for on that use (it keeps its full edge and is not a wrong answer): thrown behind something.
   - `wait_cost` (float, e.g. 1.25): while her corner waits for a line, Lucy's OTHER planned lines earn their edge times
     this in that round: the corner looking for one thing sees the others late.
   LiveRound passes what ReadBack needs (the bout, the arrow, the pick, what has won this round); keep the call one line.
3. tests/read_back_test.gd (pure, no scene): no keys -> exactly today's factor for a plain, a covered (0.5) and a waited
   (-0.5) line; set_up on -> waited before another line won, full after; wait_cost on -> other planned lines x1.25, the
   waited line unchanged; unplanned picks never changed. Print `READ_BACK failures=<n>`. It must be red before ReadBack
   exists.
4. Extend tools/read_back_probe.gd (400 bouts a cell, the same seeds, paired). CONTROLS FIRST and they must reproduce
   READBACK1 to the decimal: plan 41.3, waited 34.3, drop 35.0, swap 34.3. If they do not, the move changed the game: stop
   and say so. Then the arms, she waits from round 2 in all:
   d) set_up on; e) wait_cost 1.25; e2) wait_cost 1.5; g) set_up and wait_cost 1.25; h) g and the swap;
   i) set_up on from ROUND 1 with her waiting from round 1 (a line the region has already seen).
   For each: bouts won, difference to waited, difference to the plain plan, and Lucy's 1-1 uses / won / lost in round 2.
   An arm "wins it back" only if within 2 points of the plain plan AND at least 3 above the waited arm.
5. docs/READBACK1_RESULT.md: add "Round 2" under the existing text (keep round 1 as it is): the table, then five
   sentences: which rule gives a real way back and how much, what the player would have to do for it (in the plan, in the
   corner minute, in the week before), whether any arm now beats the PLAIN plan (a rule that makes being read an
   advantage is wrong: say so), and what is still unmeasured.

## Prior research
docs/READBACK1_RESULT.md, ops/research/R25_ADAPTS_DESIGN_MAP.md, tools/read_back_probe.gd and tools/cover_probe.gd,
ops/research/GDSCRIPT_TRAPS.md. Trap from S420: a seat's test that can only pass proves nothing; show the red run.
Trap: never tune wait_cost to hit a target; report what 1.25 and 1.5 give.

## What would a human do?
A coach whose boxer's best shot is being waited for throws it only behind something else, or makes her pay for looking
for it. These are those two, as rules.

## Prefab check
No asset or library applies: two small rules and a measurement on the game's own bout.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://<file> [-- 400]` (never the _console.exe). Tests one at a time, only the ones named here.
RESULT lines for the PR body: `RESULT: tests/read_back_test.gd -> READ_BACK failures=0`, one per regression test with its
printed pass line, and `RESULT: tools/read_back_probe.gd -> plan <x> waited <y> d <..> e <..> g <..>`.
