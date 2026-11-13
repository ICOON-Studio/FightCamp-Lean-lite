# TASK PROGPROBE1R2 - GOOSE (cloud probe) - progression cadence and the hold rule, round 2: make the instrument train

Status: OPEN (S450, Claude main). Discipline: boxing. Model: Goose + qwen3-coder.
Round 1 (branch goose/issue-248, docs/PROGPROBE1_RESULT.md) is VOID: its own numbers show the instrument does not train. Start FROM
that branch (keep tools/prog_probe.gd and tools/prog_probe_rules.gd, fix them). The task, arms, bars and printed lines are those of
ops/research/TASK_PROGPROBE1.md (READ IT) - this brief only adds what round 1 got wrong.

## Contract
OWNS: tools/prog_probe.gd, tools/prog_probe_rules.gd, docs/PROGPROBE1_RESULT.md
RED_TEST: tools/prog_probe.gd -> PROG_PROBE done
REGRESSION: file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file (read, never edit): scripts/rules/MoveTree.gd, scripts/rules/LearnSlots.gd (SLOTS1, merged S450: use its
cards/slots/speed instead of re-modelling them), MoveMastery.gd, PadWeek.gd, Combos.gd, SkillAwards.gd, tools/career_harness.gd.

## What round 1 got wrong (read on its branch by Claude, S450)
1. STEPS NEVER TRAIN: prog_probe_rules.gd `drill_step_def` is defined and never called. Steps and defences stay at day 0, so row 3 never
   opens and no style is ever held (every style set has a step or a defence). Call it every week: a step or defence on the week's pad
   cards gets its pad minutes; every step and defence in the plan gets its share of the sparring night (PadWeek.spar_pool's 180 minutes
   shared over the plan's moves, the same share rule as punches); shadow mornings 0.85 an hour (map M1).
2. THE HOLD POLICIES NEVER RUN: `hold_targets` is defined and never used; WIDEST and DEEPEST print 0.0. Each policy must decide which moves
   get the week's top-up units, and apply_hold must read units counted move by move INCLUDING steps and defences (units_drilled only
   counts move: and combo: cards today).
3. NO CONTROL ROW: before any table, print `CONTROL jab_gain=<per week> project=<PadWeek.project's number>` for Lucy on a Standard week with
   a Jab card at share 1.0, and the same for one step via drill_step_def. They must agree within 10 % (punch) or the probe stops with
   `PROG_PROBE void: control`. Also print how many lines today's game crosses for Lucy in 26 weeks through tools/career_harness.gd's route
   (n=1, weeks=26) vs arm A: they must agree within 25 % or arm A is not "today's game".
4. "WEEKS TO USABLE" READS ITS CAP (20.0 in every row): report the real median weeks to 30 for the slot's move from the week it was picked,
   and print how many picks never reached 30 inside the run (do not clamp to 20).
5. "Crossed weeks 2 %" with "picks per fighter 35" in arm B means picks are made but never trained: the slot's move must be ON the pad
   cards that week (arm B's week = the slot's move first, then moves at 30+). Print one fighter's first 8 weeks in arm B: the cards, minutes,
   and mastery after each week.

## The bars (unchanged from TASK_PROGPROBE1)
Arm B crosses a line about 3 weeks in 4; row 2 opens inside the first season and row 3 in the second for a sensible plan; the first style
is held inside 2 seasons for at least half the walk-ins; hold units exist where a careful player holds 4 Sharp + 1 Signature AND brings a
new move to 30 within 4 weeks; plan size is a real trade (the 4-move plan holds a Signature, the 9-move plan does not).

## Traps
- Godot headless only, the plain binary; Dummy audio. Never two identical fighters. Measurement only: no rule module changes.
- Write the result page from the final run; the RESULT line copied exactly: `RESULT: tools/prog_probe.gd -> PROG_PROBE done ...`.

## Prior research
- docs/PROGPROBE1_RESULT.md on goose/issue-248 (round 1), PROGRESSION_MAP_S448.md M1-M4 and section 9.

## What would a human do?
Check the scale on a known weight before weighing anything: one drilled jab must gain what the game says it gains.

## Prefab check
None: round 1's files are the start.

Test command: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/prog_probe.gd -- seasons=2`
