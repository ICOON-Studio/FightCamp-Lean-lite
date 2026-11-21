# LOANPROBE1 result - does the careful gym grow with the fit-out loan?

Probe: `tools/gym_survive_probe.gd` on main 90b1e371 plus this branch's measurement-only additions (see "Probe changes").
Run 2026-11-21 (box): `-- arms=SENSIBLE,GROW,GROWLOAN careers=15 seeds=4421,9001,2718,6007`, one run, 180 careers,
104 weeks each. Done line: `GYMSURVIVE arms=SENSIBLE,GROW,GROWLOAN careers=60 done` (60 = careers per arm).
Probe wall time printed: 2863.8 s.

## Population

- `Career.quick_start()`: one walk-in boxer signed, the sessional coach hired, the shipped cash ($16,200 after this
  setup) and members. First week skipped (`FirstWeek.skip`). One boxer at the start; GROW and GROWLOAN
  recruit up to 3.
- 15 careers x 4 seed sets (4421, 9001, 2718, 6007) = 60 careers per arm. The career seed is
  `set + i*137 + arm*7919`, so the first 15 careers of sets 4421 and 9001 are the same careers GYMSURVIVE1 ran.
- Day loop: `Sim.step_day`; bouts: the probe's `_answer_open` (accept offers, camps, weigh-ins, fight by the sim).
- Arms (all three run one Wednesday class night and take the first pro offer):
  - **SENSIBLE**: signs a second walk-in when cash is above 3 months of costs. Never spends on the gym. The control.
  - **GROW**: each Monday signs deals on offer, recruits up to 3 boxers when 8 weeks of costs are banked, buys fitness
    classes + the assistant, then the youth section, then the cheapest kit while the name draws more than the room holds;
    moves only by paying the move price in cash (`GymSpend.move(c)`), with 8 weeks of costs still banked after.
  - **GROWLOAN**: GROW, but moves on the fit-out loan (`GymSpend.move(c, true)`) once the name draws 5+ past the room
    and cash is above 8 weeks of costs + the $3,000 deposit.
- "8 weeks of costs" is fixed at the start of each career: 8 x $1,321 = $10,568. So GROWLOAN moves only once cash passes
  $13,568, and the name passes 75 members (the unit holds 70) from a reputation of about 100 (`Membership.natural_members`).

## Step 1 - does GROWLOAN take the game's own loan?

Yes. `_grow` calls `GymSpend.move(c, true)` (the same function the "Move on a loan" button reaches). That function checks
`GymUpgrades.loan_blocked`, takes `LOAN["down"]` from cash, and sets `c.fitout_weeks = 52`; `Sim.weekly_costs` then bills
`GymUpgrades.loan_week` each week with the other costs. The probe makes no copy of the loan. No fix needed. One small note: the
probe's own cash check uses a constant `LOAN_DEPOSIT := 3000` instead of reading `GymUpgrades.LOAN["down"]`. They match
today. It only decides when the probe tries to move; the game still checks and takes the real deposit.

## Closure share by week (careers closed / 60; the four seed sets, 15 each, in brackets)

| arm | by week 26 | by week 52 | by week 78 | by week 104 |
|---|---|---|---|---|
| SENSIBLE | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] |
| GROW | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] |
| GROWLOAN | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] | 0/60 [0,0,0,0] |

As a bound: with 0 closures in 60, the true closure rate over two years is under about 5% for each arm (95% upper bound,
rule of three).

## Members, cash and the move (median [p10..p90] over 60; per-seed-set medians after the bar)

| arm | members wk 52 | members wk 104 | cash wk 104 | moved | took the loan |
|---|---|---|---|---|---|
| SENSIBLE | 66 [66..70] / 66-66 | 66 [66..69] / 66-68 | $7,200 [$3,680..$10,346] / $6,603-$7,813 | 0/60 | - |
| GROW | 75 [70..79] / 74-75 | 75 [70..79] / 73-76 | $4,480 [$3,804..$9,019] / $4,068-$6,712 | 0/60 | - |
| GROWLOAN | 73 [70..81] / 73-75 | 79 [73..149] / 77-140 | $4,791 [$3,801..$20,396] / $4,419-$5,584 | 28/60 (4-9 of 15 per set) | 28/60 |

- **When GROWLOAN moved** (first move, week): none by week 26, 4 by week 52, 12 more in weeks 53-78, 12 more in
  weeks 79-104; median week 76 [52..96]. Two careers took a second loan for the club building (weeks 94 and 96).
- **GROWLOAN split by the loan**:

| GROWLOAN group | careers | members wk 104 | cash wk 104 | member room wk 104 |
|---|---|---|---|---|
| took the loan once | 26 | 145 [132..149] | $10,170 [$5,003..$24,008] | 140 |
| took it twice | 2 | 153 and 153 | $10,065 and $20,280 | 150 |
| never moved | 32 | 75 [72..77] | $4,352 [$3,286..$5,109] | 70 |

- The 32 that never moved all wanted to: their reputation at week 104 was 131-189, which draws 126-162 members against a
  room of 70. What held them was the probe's cash rule ($13,568 banked). GROW and GROWLOAN cash sits around $4,500 from
  week 52 on (table above), so the careful owner banks it only after a cash spike.

## Did the loan ever sink a gym?

| loan-takers | closed | closed while paying | week ends below $0 while paying | lowest cash while paying |
|---|---|---|---|---|
| 28 careers, 30 loans | 0/28 | 0/28 | 0 (in 0 careers) | $4,024 [$2,240..$5,986]; lowest $250 |

- 3 of 28 loan-takers dropped under $2,000 while paying, and 1 under $1,000. The lowest ($250) was a career that took two
  loans (moves at weeks 44 and 96); the second loan runs alongside club-building rent.
- Limit of the window: only 4 of the 30 loans were taken by week 52, so only 4 were fully repaid inside the two years.
  16 had at least half their 52 weeks inside the window. A loan taken late (week 80+) is mostly unpaid at week 104;
  this run does not see its last months.

## Control - SENSIBLE against GYMSURVIVE1

| measure | GYMSURVIVE1 SENSIBLE (S531, 30 x 2 seeds) | this run (15 x 4 seeds) |
|---|---|---|
| closed by week 104 | 0/60 | 0/60 |
| cash wk 52 | $8,905 [$3,998..$9,655] | $8,979 [$6,039..$9,931]; seed sets $8,730-$9,148 |
| cash wk 104 | $7,011 [$2,401..$9,546] | $7,200 [$3,680..$10,346]; seed sets $6,603-$7,813 |
| members wk 52 / 104 | 66 [66..69] / 66 [66..68] | 66 [66..70] / 66 [66..69] |

**PASS**: every earlier number is inside this run's seed-set spread. On the 30 careers both runs share, the week-104 cash median
is $7,174 then and $7,200 now (4 of 30 identical to the dollar; the game's fight code has changed since S531).

The earlier GROWLOAN run (S531: 36/60 moved, members 140 [73..150]) also sits inside this run's spread. On the 30 shared careers,
16 ended above 100 members then and 14 now. The two new seed sets moved less (4/15 and 8/15), which pulls this run's arm
median to 79 members.

## S531 pass lines, re-measured (GROWLOAN against GROW)

| pass line (GROWTH_SCOPE_S531) | now | holds? |
|---|---|---|
| at least half the GROWLOAN gyms moved | 28/60 (47%); seed sets 27%-60% | borderline: no at 60, yes in 2 of 4 seed sets |
| GROWLOAN median members >= 85 | 79 [73..149]; loan-takers 145 | no for the arm; yes for the gyms that moved |
| GROWLOAN median cash >= GROW's | $4,791 vs $4,480 | yes |
| no more closures than GROW | 0/60 vs 0/60 | yes |

## Verdict

1. **Yes, the loan makes a careful gym grow.** 26 of the 28 gyms that took it reached 130-153 members by week 104, against
   70-85 without moving. The other 2 moved in week 104 itself and had not filled the new room yet.
   It also ended with more cash: $10,170 median, against $4,352 for the gyms that did not move. GROW, paying cash, never moved (0/60).
2. **It was never a trap in two years.** 0 of 28 loan-takers closed, and none spent a week below $0 while paying. The tightest
   case ($250 left) was a second loan for the club building. Only 4 loans were repaid inside the window.
3. **Down, month and months are not what's off.** The payments never pushed cash below zero, and the movers earned more than
   they paid. What limits growth is getting to the move at all: 32 of 60 careful gyms drew 126+ members but never banked
   8 weeks of costs plus the deposit, because cash sits near $4,500 after the first year. With a $0 deposit the bar would
   still be $10,568, so a smaller deposit would not change that by much (an estimate from these numbers, not run).
   The one number to watch is the move price on the second move: the club building costs $25,000 cash but goes on the same
   $3,000 + $9,000 loan, and the lowest cash in the run came there. Only 2 careers took it, so that is not measured enough
   to change anything.

## Probe changes (tools/gym_survive_probe.gd, measurement only, 428 -> 467 lines)

- Args `careers=<n>`, `seeds=a,b,...`, `out=<path>` (defaults unchanged: 30, [4421, 9001], the old doc paths).
- Per career: the weeks the gym moved, the weeks a loan was taken, the lowest week-end cash and the count of week ends
  below $0 while a loan was being paid, and whether it closed while paying. One `CAREER {json}` line per career, so a cut
  run can still be read.
- A last line `GYMSURVIVE arms=<arms> careers=<per arm> done`.
- No arm's behaviour changed; the loan path was already the game's own.

Reproduce: `godot --headless --audio-driver Dummy --path . --script res://tools/gym_survive_probe.gd -- arms=SENSIBLE,GROW,GROWLOAN careers=15 seeds=4421,9001,2718,6007 out=<file>`
(the tables above come from the run's `CAREER` lines; about 50-90 minutes on one core).
