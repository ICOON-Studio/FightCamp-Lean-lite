# TASK GYMKIND1 - QWEN (qwen3-coder) - does each kind of kit build something worth its price

Status: OPEN (S416, Claude main). Discipline: boxing. Model: qwen3-coder. Launch only after FIGHTERMODEL4I is on main.
Source: ops/research/GYM_SLOTS_S415.md ("cardio is a fake buy until each kind builds something") and docs/GYMBUY1_RESULT.md. Measure first: the operator approves the rule before it is switched on.

Decided by Claude, S416: no place cap by premises. The premises already cap the members, so a piece past that cap adds no members. A hard cap would also stop him buying the full gym picture he chose in the opening unit.

## Contract
OWNS: scripts/rules/GymKinds.gd, scripts/state/GymSpend.gd, tests/gym_kinds_test.gd, tests/gym_kinds_bots_test.gd, docs/GYMKIND1_RESULT.md
RED_TEST: tests/gym_spend_test.gd -> GYM_SPEND failures=0
REGRESSION: gym_spend_test, gym_slots_test, golden_path_test
VISUAL: no

## Prior research
scripts/rules/GymSlots.gd (pieces, owned, places), assets/data/gym_slots.json (kind, places, start), scripts/rules/TrainingWeek.gd SESSIONS (the session and its stat), scripts/rules/GymUpgrades.gd gain_mult (the Strength corner's +10% is the size to copy and the hook to sit beside), scripts/state/GymSpend.gd line 86 (where gain multipliers meet), scripts/state/Sim.gd around line 213 (where they are used). tests/gym_buy_bots_test.gd and tests/balance_harness_test.gd show how a career is stepped. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Train the same boxer for three years in two gyms, one with the opening kit and one with everything of a kind, and look at the fighter at the end.

## Prefab check
GymUpgrades.gain_mult is the existing shape. Nothing new to buy.

## The rule to build and measure
1. scripts/rules/GymKinds.gd, pure. Kind to the session stats it builds: bag -> power, speed; rack and bench -> power, chin; cardio -> conditioning; mirror -> technique; mat -> defense. `gain_mult(rows, day, stat)`: for that stat, share = (places owned of its kinds minus the opening places of those kinds) / (all places of those kinds minus the opening places), clamped 0 to 1, and the multiplier is 1.0 + 0.10 x share. Empty rows (an old save, the whole gym stands) gives share 1.0. A ring builds nothing here: it cannot be bought up.
2. GymSpend.gain_mult multiplies by it only when `static var kit_gain_on := false` is true. It stays false: this task switches nothing on for players. Only the bots test sets it.
3. tests/gym_kinds_test.gd prints `GYM_KINDS failures=<n>`: the map, the clamp, opening rows give exactly 1.0, every piece bought gives exactly 1.10, unfitted pieces do not count.

## Measure
tests/gym_kinds_bots_test.gd prints `GYM_KINDS_BOTS failures=<n>`. Print the population: seeds, weeks, the boxer's starting attributes, what the week plan is. 15 seeds, 156 weeks, the game's real weekly pass, one boxer on a fixed week plan, the same in every arm.
Arms: OPENING (start rows), each kind bought whole on day 0 with kit_gain_on true (BAG, RACK, CARDIO, MIRROR, MAT; rack here means rack and bench), and ALL. Print per arm: median of each session stat at week 156, the gain over OPENING, and the price of that arm's pieces.
Then the win chance the gain is worth: MM.win_chance of the week-156 boxer of each arm against the OPENING boxer. Use Matchmaking the way tests/matchup_spread_test.gd does.
Two checks only, as instruments: OPENING's multiplier reads 1.0 on every stat, and ALL's stats are at or above OPENING's in every seed. If kit_gain_on has no effect, this must fail.
docs/GYMKIND1_RESULT.md: the table, then one short paragraph with numbers only: for each kind, the stat gain, the win chance gain, and dollars per point of win chance. No proposed rule and no new price.

## Rules
No file over 500 lines. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <test>`. Keep the bots test under 10 minutes: cut seeds to 9 before cutting weeks, and say so.

## The one trap
A training gain only shows if the session is in the boxer's week. A kind whose session is never picked reads zero and looks worthless. Print each session's share of the week for the fixed plan beside the table, and use a plan that gives every session in the map some time.

## Result lines (PR body)
RESULT: tests/gym_spend_test.gd -> GYM_SPEND failures=0
RESULT: tests/gym_kinds_test.gd -> GYM_KINDS failures=0
RESULT: tests/gym_kinds_bots_test.gd -> GYM_KINDS_BOTS failures=0
