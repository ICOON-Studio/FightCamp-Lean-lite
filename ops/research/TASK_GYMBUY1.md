# TASK GYMBUY1 - QWEN (qwen3-coder) - does buying equipment change a club's results

Status: OPEN (S415, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: ops/research/GYM_SLOTS_S415.md, section "Numbers, worked out, not played". The operator's "Yes, start small" is built; nothing has played the rule yet.

## Contract
OWNS: tests/gym_buy_bots_test.gd, docs/GYMBUY1_RESULT.md
RED_TEST: tests/gym_slots_test.gd -> GYM_SLOTS failures=0
REGRESSION: gym_slots_test, gym_spend_test
VISUAL: no

## Prior research
ops/research/GYM_SLOTS_S415.md. scripts/rules/GymSlots.gd, scripts/state/GymSpend.gd (member_cap, member_limit, buy_slot), scripts/rules/Membership.gd (settle_week), scripts/state/Sim.gd (the weekly pass). tests/balance_harness_test.gd and tests/gym_slots_test.gd show how a career is made and stepped. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Run the same club several times, once never buying kit and once buying whenever the floor is full, and look at the members and the bank.

## Prefab check
tests/balance_harness_test.gd already steps careers. Reuse its way of doing it.

## The job
You measure. You change no game code and no number. Print the population in the output: seeds, weeks, reputation, what each bot does.
1. tests/gym_buy_bots_test.gd: Career.quick_start, a hired coach, standard dues, 30 seeds, 156 weeks through the game's real weekly pass. Three bots:
   a. NEVER: never buys equipment.
   b. BUYER: each week, when GymSpend.member_limit is "equipment", buys the cheapest piece per place that GymSlots.blocked allows, keeping at least 8 weeks of costs in the bank.
   c. WHOLE: gym_slots = [] from the start (the whole gym stands: the rule switched off, the control).
2. Without fighters a club's reputation does not move, and at reputation 10 the floor never binds. So run each bot at four fixed reputations: 10, 30, 50, 80, held for the whole run, and also at premises tier 0 and tier 1 (premises set at the start, no move cost).
3. Print one line per cell: bot, reputation, tier, median members at weeks 26, 52, 104, 156; median cash at week 156; share of careers closed; median first week the limit was equipment; share of weeks limited by equipment, coaches, premises; for BUYER, median pieces bought and money spent, and the three piece names bought most.
4. Print `GYM_BUY failures=<n>`. Only two checks, as instruments: WHOLE's members are never below NEVER's in any cell, and in at least one cell WHOLE ends with more members than NEVER (if the rule can never bite, this test must say so by failing).
5. docs/GYMBUY1_RESULT.md: the table, then one short paragraph with numbers only: in which cells the floor changed the members by 5 or more, and what the buyer's spending returned in dues by week 156. No proposed rule and no new prices.

## Rules
scripts/ and assets/ are out of bounds. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script tests/gym_buy_bots_test.gd`. Under 500 lines. Keep the run under 10 minutes: cut seeds to 15 before cutting weeks, and say so.

## The one trap
Career.quick_start fills gym_slots and the weekly pass reads c.day: advance the day the way the game does, or a bought piece never finishes its fitters' week and the BUYER looks useless.

## Result lines (PR body)
RESULT: tests/gym_slots_test.gd -> GYM_SLOTS failures=0
