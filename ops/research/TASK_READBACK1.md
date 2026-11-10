# TASK READBACK1 - QWEN (qwen3-coder) - she waits for your best plan line: where the points go, and what wins them back. Measure only

Status: OPEN (S425, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator chose "the opponent adapts to your plan by round 2" (R25) and asked for mechanics deep enough for 7 of
10: "the focus needs to be for the player to have things to do during a week ... more interactive with deicions/choices".
S423 measured (tools/cover_probe.gd, ops/research/R25_ADAPTS_DESIGN_MAP.md): when her corner WAITS for Lucy's best plan line
(the line's edge x -0.5 and it counts as a wrong answer for the round's reads), Lucy loses 6.5 points of win share
(41.3% -> 34.8%), and NOTHING wins it back: dropping the line 35.0%, swapping it for another right answer 34.3%, the swap
drilled to 50 like her others 34.5%. A mechanic that only takes points away cannot be built. This task finds where the 6.5
points go and which answer gives the player a real way back. It changes no game file.

## Contract
OWNS: tools/read_back_probe.gd, docs/READBACK1_RESULT.md
RED_TEST: tools/read_back_probe.gd -> CTRL plan 39 to 44% and CTRL waited 32 to 38% (measure only; change no game file)
REGRESSION: plan_fight_test, plan_read_test (the probe changes no game file; these prove the plan rules still load)
VISUAL: no

## The job
Start from tools/cover_probe.gd (copy its set-up: Lucy, Data.lucy, 1-1 and 1-2 at 50, against Maria Ortega,
Data.OPPONENTS[0], the GOOD plan, no film, no shouts, 3 rounds, the same days as dice; the `covered` hook on the bout that
LiveRound reads). 400 bouts a cell, the same seeds in every cell so cells are paired. Print the population first.
1. CONTROLS first: no plan; the plan, nobody waiting; she waits from round 2 (x -0.5). If the last two are not inside the
   RED_TEST bands, stop and write why.
2. WHERE THE POINTS GO. For the plain-plan arm and the waited arm, per round, print: each plan line's uses, its exchanges
   won and lost, its planned edge earned; the round's reads for each corner; the round's score on the cards; stoppages.
   Then one table: of the 6.5 points, how much is the line's own lost exchanges, how much the reads it hands her, how much
   the rounds that flip on the cards. Bound each share, never claim one exact number.
3. THE WAY BACK. One arm each, the player's corner answering after round 1 (she waits from round 2):
   a) drop the line (the control from S423); b) swap it for the next-best right answer to the same situation (S423's arm);
   c) swap AND the waited line stays in the plan at a lower pick weight (a decoy: she still waits for it, he uses it less);
   d) the waited line is used ONLY after another plan line landed in the same round (a set-up);
   e) her wait costs HER: while she waits for that line, the plan's other lines earn x1.25 against her (she is looking at
      the wrong thing); f) e and b together.
   For c to f read how LiveRound applies `covered` and build the arm from the probe (set the bout's fields or wrap the
   call from the probe); where an arm cannot be built without editing a game file, say so in the result and skip it.
4. One table: arm -> win share, difference to the waited arm, difference to the plain plan. An arm "wins it back" only
   if it is within 2 points of the plain plan AND at least 3 above the waited arm.
5. docs/READBACK1_RESULT.md: the tables, then five sentences: where the points go, which arms win it back, which do not,
   what the player would have to DO (in the corner minute, in the week before) for the best arm, and what you could not
   measure.

## Prior research
ops/research/R25_ADAPTS_DESIGN_MAP.md (S423's numbers and the open question, lines 1 to 20), tools/cover_probe.gd and
tools/adapt_probe.gd headers, tools/plan_effect_probe.gd (the GOOD plan), ops/research/GDSCRIPT_TRAPS.md.
Trap: a probe arm that cannot differ from its control proves nothing: print one bout's round-2 line uses for each arm so
the reader sees the arm did what its name says.

## What would a human do?
A coach whose boxer's best shot is being waited for does one of three things: stops throwing it, throws it only behind
something else, or makes her pay for waiting. The arms are those three.

## Prefab check
No asset or library applies: a measurement on the game's own bout.

Run every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tools/read_back_probe.gd -- 400` (never the _console.exe).
RESULT lines for the PR body: `RESULT: tools/read_back_probe.gd -> CTRL plan <x>% CTRL waited <y>%` and one per arm.
