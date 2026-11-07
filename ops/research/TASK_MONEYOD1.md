# TASK MONEYOD1 - QWEN (qwen3-coder) - an overdraft with interest: the bank's lever before the 8-week close (rules only)

Status: OPEN (S399, Claude main). Discipline: gym money (all disciplines). Source: MONEY_BITES_S397.md s10 "Credit: an overdraft
with interest" (critic B: a lever before the close). Rules + tests only - NO screen work in this task.

## Contract
OWNS: scripts/rules/Overdraft.gd, tests/overdraft_test.gd, scripts/rules/GymBills.gd:62-86, scripts/state/Sim.gd:300-340
RED_TEST: tests/overdraft_test.gd -> OVERDRAFT failures=0
REGRESSION: money_close_test, game_money_test, first_hour, golden_path_test
VISUAL: no

## Real-world numbers (benchmark, not ours)
A UK/US small-business arranged overdraft: limit about one month of turnover, 12-20% a year on the drawn amount, an arrangement
fee about 1% of the limit, reviewed yearly; the bank pulls it when the account sits drawn for months.

## The rule (GAME numbers from the benchmark)
- Overdraft.limit(income_4w): 100% of the last 4 weeks' income, rounded down to $100, at least $0. Offered only after the gym
  has traded 12 weeks (no history = no overdraft).
- Arranged once by the player (a flag on the career: `overdraft_on`); arrangement fee 1% of the limit, charged on the day.
- Interest: 16% a year on the drawn (negative) balance, charged weekly = drawn * 0.16 / 52, rounded up to $1.
- The 8-week close clock (GymBills.next_below) counts weeks below MINUS the limit instead of below $0 when `overdraft_on`.
- The bank pulls it: 12 weeks in a row drawn -> limit drops to 0 (the clock then counts below $0 again, from that week).
- Off (default) = today's game exactly.

## Do
1. tests/overdraft_test.gd FIRST: limit maths, fee, weekly interest, the clock with/without it, the 12-week pull, and the
   default-off path identical to main (same cash every week for a 52-week scripted career). Run it on main before the rule:
   it must fail to load or fail its rule checks (there is no Overdraft.gd yet).
2. Build scripts/rules/Overdraft.gd (pure static functions, under 150 lines) and wire it into Sim.gd's weekly step and
   GymBills.next_below inside the OWNS windows. Save/load: the flag and the drawn-weeks counter go in the career dict with
   defaults (an old save loads with it off).
3. Measure with the money harness (start every Godot run through
   `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`):
   `tools/career_harness.gd -- n=10 weeks=104 money=1`, careless and sensible, with `overdraft=1` forced on (add that harness
   switch only if career_harness.gd reads switches already; otherwise set the flag in your test career). Bars:
   - careless: still closes in >= 9 of 10 careers by week 104 (main: 10 of 10) - the overdraft delays, it does not rescue;
   - sensible: never draws more than 4 weeks in a row, and its quarterly months-of-costs stays within 1.0-2.2 (main);
   - the interest paid shows in the ledger as "Overdraft interest".
4. Write main's numbers and yours in the PR body. Do not loosen any bar. Do not touch scripts/ui, the fight model (scripts/rules
   Exchanges/LiveRound/BoutRules/BoutNight), ops/ or tools/run_tests.sh.

## Result lines (PR body)
RESULT: OVERDRAFT failures=0 (checks=<n>)
RESULT: careless closed main 10/10 -> after <n>/10 (weeks <a>-<b>)
RESULT: sensible max drawn run <n> weeks; months-of-costs quarters <list>
RESULT: regression <pass/fail per test>

## What would a human do?
Ring the bank when the account dips, pay the interest, and still close if the gym never earns it back.
