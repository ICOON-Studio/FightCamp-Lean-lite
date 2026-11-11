# DUESSUMS1 result (S431): no balanced set among the 243, and why

Branch goose/issue-193 (issue 193): scripts/rules/DuesLevers.gd (pure, wired to nothing) + tests/dues_levers_test.gd.
NOT on main: its test is red by design ("at least one GOOD set exists" fails), so it cannot join run_tests.sh.
Run here by Claude (S431) from the branch's two files; the numbers below are from that run.

## The control holds
All levers at zero: Premium has the best 5-year total in 9 of 9 clubs (reputation 10 / 40 / 80 x cap 40 / 60 / 120).
Totals run from $97,560 (Cheap, cap 40) to $267,033 (Premium, reputation 80, cap 120).

## The search: 0 GOOD sets of 243
How the nine clubs split between Cheap / Standard / Premium, counted over all 243 sets (Claude's count, same module):
- 145 sets: Cheap wins 9 of 9. 23 sets: 8 / 0 / 1. 45 sets: 6 of 9. 15 sets: 5 of 9.
- Every set with a volunteer saving of 50 in 100 of the coach's wage gives Cheap 9 of 9 (81 sets); at 25 in 100, 57 of 81.
- With no volunteer saving (81 sets): 7 still give Cheap 9 of 9, 44 give Cheap 6 to 8, and only 15 give Premium the most.
- Standard wins at most 4 clubs, and in 203 sets it wins none.
- Exactly ONE set meets the win bars (2 / 2 / 5): grant chance 0.20, payout $18,750, no volunteers, show $1,000 a boxer,
  premium draw 0.65 at reputation 0. It fails the "no trap" bar in one club: a new club with room (reputation 10, cap 120),
  where Cheap earns $164,024 and Premium $124,130 (32 in 100 apart; the bar was 25).

## What it means
1. The volunteer coach is far too strong as drawn: half a sessional coach is $11,700 a year, more than the whole gap
   between the prices. If it stays, it must be small (5 to 15 in 100) or earned over years, not given with the price.
2. Grants and home shows are about the right size: they are what moves Cheap from never to sometimes.
3. Standard is squeezed: it is second at everything. It needs a reason of its own (John: "It is the keep fitters that
   sustain the club": the mixed club keeps its adults longest), or it will stay the answer nobody picks.
4. One knife-edge set is not a design. The next search asks for a REGION: a set whose neighbours are also balanced.

Next: DUESSUMS2 (ops/research/TASK_DUESSUMS2.md).
