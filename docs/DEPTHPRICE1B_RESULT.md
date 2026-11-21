# DEPTHPRICE1B result - a price for the four solved club choices, measured on a greybox

Run 2026-11-21 (S534, DEPTH_SCOPE_S534 change 1), probe `tools/depthprice1b_probe.gd`, game code at main 00b49e4ef-31d42481e.
MEASUREMENT ONLY: every price is a local rule inside the probe, applied after the game's own day (`Sim.step_day`).
Nothing under `scripts/` was changed.

## The answer in one table

| Row | Price tried | Does the choice move the result? | Best option by cell (of 10) | Verdict |
|---|---|---|---|---|
| 14 Class nights | The class takes the coach's whole evening: a boxer on pads that night drills nothing (today: half) | Yes: three class nights cost 10.8 wins in 100 and 17 of 45 pro calls, and pay $13,650 | none 5, one night 5, three nights 0 | **PASS** |
| 15 Stipend or day job | 1st: the stipend grows $50 a week per win. 2nd: the job takes pad evenings | Money only, and the other way round: today the DAY JOB ends $9,800 richer with the same record | today: day job 6, half 3, stipend 1. 1st price: day job 7 | **1st price FAIL; 2nd price queued, not yet run** |
| 17 Fit-out loan | 1st: a week below $0 while paying = a late fee ($173) and 4 reputation. Re-size: a fifth of the members do not follow the move and the sponsor waits for a half-full room | Yes, but one way: moving early ends $16,800 ahead of never moving | move early 10, with or without the 1st price | **1st price FAIL; re-size queued, not yet run** |
| 7 Diet Hold or Cut | 1st: a day on the cut builds 0.6 of the day's stat gains. Re-size: and 4 more fatigue | Barely: 3.0 wins in 100 at the re-size (0.9 today), inside the noise | Cut 5, Hold 2, tie 3 (the same today) | **FAIL as a price; the switch itself is the problem** |

Two findings matter more than the prices:
1. **Row 15's "one answer" was a probe fault, not the game.** The 3-of-180 number came from bots that never answered the
   rival club's approach, so the day-job boxer simply left (here: HALF 42 of 56 boxers on HALF and 43 of 56 on the day job
   left when unanswered; 0 on the stipend). With the approach answered, the day job wins as many bouts, gets the same pro
   calls and ends with $9,800 more cash. Today the weak option is the full STIPEND.
2. **Row 7's switch does almost nothing.** The camp and the amateur fight week already cut for the player: 97 cut days a
   career with the diet on Cut, 95 on Hold. No price on "a day on the cut" can separate two options that cut the same days.

## Population and method

- **Cells: 5 club kinds x 2 seed sets = 10.** Kinds: the game's three starts (`ClubStart` fresh / debt / backed), "short"
  (fresh on 4 weeks of costs, MONEYFOUR2's CASH-SHORT) and "test" (`TestClub`: three boxers in three weight classes).
  Seed sets 4421 and 9001; the career seed is set + index x 137, the same in every arm and rule of a cell (paired).
- Careers a cell and arm: 4 (rows 14, 15, 7), 3 (row 17). Weeks: row 14 = 52, row 15 = 78, row 17 = 104, row 7 = 52.
- Fighters are the game's own and all differ: the walk-in; the debt start's better walk-in, 2.2 kg over; three boxers
  in three classes in the test club. Rivals' pasts are re-seeded to the career seed so every arm meets the same field.
- Every arm: the real day loop, every sheet offer accepted, camps, weigh-ins, the bout by the game's sim, the first pro
  offer taken, sponsors on offer signed. Rows 15, 17 and 7 also run the careful owner's one Wednesday class night
  (GYMSURVIVE1: without it a fresh gym closes).
- **"Best in a cell"** (decided before the runs): fewer closures; else 3 or more wins per 100 bouts; else $1,000 or more
  cash at the end (net of what the loan still owes); else a tie. Wins rank above money, so an option that only pays more
  is "best" only where the record is level.
- **Bars** (the task): the choice moves the result (3+ wins in 100, or real money or closures), and no option best in more
  than 6 of 10 cells.
- **How sure:** an arm pools about 500 bouts (rows 14, 7), 680 (row 15), 1,050 (row 17): about 2 wins per 100 of noise on
  an arm, about 3 on a difference. A single cell has 31-140 bouts: a cell's "best" on wins alone can be luck.
- **The fresh, backed and short kinds share their bouts** in rows 14, 15 and 7 (same boxer, same seed; only the bank
  differs and no arm ran out of money there). So those rows have about 6 independent cells, not 10.

## Row 14 - class nights. PASS

**Price:** the class takes the coach's whole evening. A boxer who would have been on pads that night drills nothing
(today she goes on the bag for half the minutes). Applied on the game's own record of the night (`DrillWeek.NOTED`
minutes set to 0), so Sunday's drill runs the game's own code.

Options: N0 no class night, N1 Wednesday, N3 Monday + Wednesday + Friday (the coach's three pad nights).

| rule | option | class cash | mastery gained | wins per 100 bouts (bouts) | pro calls | cash at the end, net of the loan | closed | best in cells (of 10) |
|---|---|---|---|---|---|---|---|---|
| today | N0 | $0 | 434 | 63.6 (472) | 45 | $14,795 | 0/40 | 0 |
| today | N1 | $5,961 | 435 | 63.3 (493) | 44 | $18,690 | 0/40 | 3 |
| today | N3 | $17,316 | 353 | 60.0 (502) | 44 | $28,746 | 0/40 | 4 |
| priced | N0 | $0 | 434 | 63.6 (472) | 45 | $14,795 | 0/40 | 5 |
| priced | N1 | $5,949 | 421 | 60.5 (494) | 44 | $18,191 | 0/40 | 5 |
| priced | N3 | $17,532 | 25 | 52.8 (504) | 28 | $28,445 | 0/40 | 0 |
| today | (no best: a tie) |  |  |  |  |  |  | 3 |
| priced | (no best: a tie) |  |  |  |  |  |  | 0 |

- **Today:** "none" is never best. One night costs nothing measurable (63.3 against 63.6 wins per 100) and pays $5,961.
  Three nights pay $17,316 for 3.6 wins in 100. MONEYFOUR2's free lunch stands for one night.
- **Priced:** three nights now cost 10.8 wins in 100 (63.6 to 52.8), 17 of 45 pro calls, and nearly all the pad mastery
  (434 to 25), for $13,650 more cash. One night costs 3.1 wins in 100 (at the edge of noise) for $3,400.
- By cell: none 5, one night 5, three nights 0. Three nights is the cash-best option in all 10 cells and the worst record
  in all 10: a real trade between money and the record. No club needed the money to stay open in 52 weeks (0 closures in
  any arm), so the money never outranked the record here.

Priced, by cell (wins per 100 of bouts, cash):

| club / seed set | best | N0 | N1 | N3 |
|---|---|---|---|---|
| fresh/4421 | N1 | 62.9% of 35, $21,017 | 64.1% of 39, $23,919 | 53.8% of 39, $35,256 |
| fresh/9001 | N0 | 67.6% of 34, $20,276 | 62.2% of 37, $22,070 | 56.8% of 37, $33,958 |
| debt/4421 | N0 | 93.5% of 31, $7,985 | 75.0% of 32, $11,071 | 57.6% of 33, $19,741 |
| debt/9001 | N0 | 84.4% of 32, $5,161 | 69.7% of 33, $9,972 | 63.6% of 33, $20,082 |
| backed/4421 | N1 | 62.9% of 35, $32,919 | 64.1% of 39, $35,821 | 53.8% of 39, $47,150 |
| backed/9001 | N0 | 67.6% of 34, $32,178 | 62.2% of 37, $33,972 | 56.8% of 37, $45,852 |
| short/4421 | N1 | 62.9% of 35, $10,101 | 64.1% of 39, $13,003 | 53.8% of 39, $24,340 |
| short/9001 | N0 | 67.6% of 34, $9,360 | 62.2% of 37, $11,154 | 56.8% of 37, $23,042 |
| test/4421 | N1 | 54.9% of 102, $5,608 | 54.5% of 101, $11,346 | 47.7% of 107, $18,604 |
| test/9001 | N1 | 53.0% of 100, $3,343 | 53.0% of 100, $9,584 | 47.6% of 103, $16,426 |

**Constant to build:** `ClubClasses.BAG_SHARE` 0.5 -> 0.0 (a class night on a pad evening: no pad work, no bag drill
for the boxers that evening). The class money (`ClubDeal.class_cash`, $117 a night a week) stays.

## Row 15 - stipend or day job. **1st price FAIL; 2nd price queued, not yet run**

Options (every amateur boxer of the club): FULL the $250 stipend, HALF $125 and one work morning, JOB no stipend and two
work mornings. When the rival club comes for an unhappy boxer the owner keeps her the cheapest way the game allows:
the promised club show when one can be booked, else matching the offer (the stipend, held 12 weeks), then back to the
arm's deal.

**First price:** a winning amateur's sponsorship grows: +$50 a week per win on the full stipend (+$25 on half), up to 7 wins.

| rule | option | stipend paid | stat points gained | wins per 100 bouts (bouts) | pro calls | cash at the end, net of the loan | week ends below $0 | closed | best in cells (of 10) |
|---|---|---|---|---|---|---|---|---|---|
| today | FULL | $14,188 | 107.6 | 65.6 (672) | 56 | $29,314 | 0.0 | 0/40 | 1 |
| today | HALF | $7,481 | 105.3 | 64.4 (679) | 56 | $35,508 | 0.0 | 0/40 | 3 |
| today | JOB | $3,650 | 101.5 | 65.2 (687) | 56 | $39,098 | 0.0 | 0/40 | 6 |
| priced | FULL | $24,985 | 96.0 | 65.5 (568) | 43 | $16,325 | 6.1 | 7/40 | 0 |
| priced | HALF | $14,178 | 105.2 | 64.4 (679) | 56 | $28,807 | 0.0 | 0/40 | 3 |
| priced | JOB | $7,175 | 101.5 | 65.1 (688) | 56 | $35,611 | 0.0 | 0/40 | 7 |
| today | (no best: a tie) |  |  |  |  |  |  |  | 0 |
| priced | (no best: a tie) |  |  |  |  |  |  |  | 0 |

- **Today (approach answered): the day job is the better deal.** Wins per 100 are level (65.6 / 64.4 / 65.2), pro calls
  are identical (56 / 56 / 56), stat points gained differ by 6% (107.6 against 101.5), and the day job ends with $9,800
  more cash. By cell: JOB 6, HALF 3, FULL 1.
- Why the two work mornings barely show: a day-job boxer is matched onto the stipend for 12-week spells (1.5 matches a
  career in the fresh kind), turns pro at the same time, and a pro never works.
- **The first price points the wrong way.** A dearer stipend made the already-weak option ruinous: FULL closed 7 of 40
  clubs (6 of 8 in the test club, 1 of 8 in debt) and JOB became best in 7 of 10 cells. FAIL.
- The test club's fourth option, TOP1 (the stipend for the best prospect only, day jobs for the other two):
  today: 55.9 wins per 100 (295 bouts), stipend $18,031, cash $31,852, 0/8 closed; priced: 55.9 wins per 100 (295 bouts), stipend $30,969, cash $18,902, 0/8 closed. It sits between FULL and JOB on money with the same record.

Today, by cell:

| club / seed set | best | FULL | HALF | JOB |
|---|---|---|---|---|
| fresh/4421 | JOB | 68.6% of 51, $35,090 | 66.7% of 51, $39,618 | 70.6% of 51, $41,445 |
| fresh/9001 | HALF | 68.6% of 51, $33,342 | 69.4% of 49, $38,752 | 64.7% of 51, $40,740 |
| debt/4421 | JOB | 88.1% of 42, $29,968 | 86.0% of 43, $31,381 | 90.0% of 40, $34,179 |
| debt/9001 | JOB | 78.6% of 42, $21,646 | 76.7% of 43, $27,600 | 86.0% of 43, $29,892 |
| backed/4421 | JOB | 68.6% of 51, $42,000 | 66.7% of 51, $46,528 | 70.6% of 51, $48,355 |
| backed/9001 | HALF | 68.6% of 51, $40,252 | 69.4% of 49, $45,662 | 64.7% of 51, $47,650 |
| short/4421 | JOB | 68.6% of 51, $24,174 | 66.7% of 51, $28,702 | 70.6% of 51, $30,529 |
| short/9001 | HALF | 68.6% of 51, $22,426 | 69.4% of 49, $27,836 | 64.7% of 51, $29,824 |
| test/4421 | JOB | 56.5% of 138, $22,856 | 57.7% of 142, $35,604 | 60.1% of 148, $45,266 |
| test/9001 | FULL | 57.6% of 144, $21,388 | 53.6% of 151, $33,393 | 52.7% of 150, $43,102 |

**Second price** (the job takes evenings: a boxer on a day job misses Monday's and Wednesday's pads, on the half sponsorship Wednesday's; the stipend stays flat): QUEUED behind other sessions' Godot jobs when this page was written - not yet run.

## Row 17 - the fit-out loan. **1st price FAIL; re-size queued, not yet run**

Options: NEVER move; EARLY (move on the loan when the name draws 5 past the room and the $3,000 deposit + 2 weeks of
costs are banked); LATE (35 past the room, deposit + 8 weeks banked). Every arm grows the same way otherwise (recruits to
three boxers, fitness kit and assistant, youth section, kit).

**First price:** a week that ends below $0 while the loan runs is a missed payment: a late fee of one payment
(`GymUpgrades.LOAN.week`, $173) and 4 reputation (`BoutRules.STOPPED_LOSS_REPUTATION`).

| rule | option | moved | members at the end | wins per 100 bouts (bouts) | cash at the end, net of the loan | week ends below $0 | late fees | closed | best in cells (of 10) |
|---|---|---|---|---|---|---|---|---|---|
| today | NEVER | 0/30 | 73 | 62.2 (1084) | $12,273 | 0.1 | 0 | 0/30 | 0 |
| today | EARLY | 30/30 | 112 | 62.4 (1050) | $29,085 | 0.6 | 0 | 0/30 | 10 |
| today | LATE | 18/30 | 99 | 62.2 (1082) | $11,928 | 0.1 | 0 | 0/30 | 0 |
| priced | NEVER | 0/30 | 73 | 62.2 (1084) | $12,273 | 0.1 | 0 | 0/30 | 0 |
| priced | EARLY | 30/30 | 110 | 62.4 (1050) | $28,653 | 0.9 | 28 | 0/30 | 10 |
| priced | LATE | 18/30 | 99 | 62.2 (1082) | $11,928 | 0.1 | 0 | 0/30 | 0 |
| today | (no best: a tie) |  |  |  |  |  |  |  | 0 |
| priced | (no best: a tie) |  |  |  |  |  |  |  | 0 |

- **Moving early is best in 10 of 10 cells, with or without the price.** It ends $16,800 ahead of never moving. EARLY
  moved in week 17-66 (all 30 careers); LATE moved in week 80-102 (18 of 30), too late to earn inside two years.
- The price fired 28 times, 27 of them in the fresh kind (EARLY there spends weeks below $0 right after the move), and
  cost about $2,000 in the fresh kind ($430 averaged over all kinds) of a $16,800 lead. Nobody closed. FAIL.
- Why a late fee cannot work: the move pays from the first weeks. The sponsor a bigger club brings ($400 a week) covers
  the extra rent ($369 a week) by itself; the new members then pay the loan ($173 a week) several times over.

Priced, by cell:

| club / seed set | best | NEVER | EARLY | LATE |
|---|---|---|---|---|
| fresh/4421 | EARLY | 59.5% of 131, $13,517 | 59.5% of 131, $28,352 | 59.5% of 131, $12,223 |
| fresh/9001 | EARLY | 59.1% of 132, $9,125 | 59.1% of 132, $32,452 | 59.1% of 132, $11,803 |
| debt/4421 | EARLY | 77.2% of 79, $12,842 | 80.0% of 65, $39,159 | 77.2% of 79, $12,355 |
| debt/9001 | EARLY | 67.6% of 68, $9,562 | 74.0% of 50, $24,859 | 67.6% of 68, $9,562 |
| backed/4421 | EARLY | 59.5% of 131, $12,640 | 59.5% of 131, $25,135 | 59.5% of 131, $8,935 |
| backed/9001 | EARLY | 59.1% of 132, $8,516 | 59.1% of 132, $23,213 | 59.1% of 132, $5,089 |
| short/4421 | EARLY | 68.8% of 80, $9,642 | 68.8% of 80, $21,646 | 68.8% of 80, $11,839 |
| short/9001 | EARLY | 69.6% of 69, $13,266 | 69.6% of 69, $23,521 | 69.6% of 69, $10,223 |
| test/4421 | EARLY | 56.5% of 131, $18,668 | 56.6% of 129, $31,928 | 56.6% of 129, $17,884 |
| test/9001 | EARLY | 59.5% of 131, $14,955 | 59.5% of 131, $36,264 | 59.5% of 131, $19,366 |

**Re-size** (a fifth of the members do not follow the move; the sponsor signs only once the new room is half full): QUEUED behind other sessions' Godot jobs when this page was written - not yet run.

## Row 7 - diet Hold or Cut. FAIL as a price

Options: CUT (the diet on Cut all year) and HOLD (on Hold; the camp's and the amateur fight week's own cut still runs).
Every boxer starts 1.5 kg over her class (the debt walk-in 2.2 kg).

**First price:** a day on the cut builds less: the day's stat gains x 0.6 (`WeekPlan.TIRED_GAIN`), on every cutting
day, the player's or the game's.

| rule | option | cut days a career | stat points gained | missed weights | wins per 100 bouts (bouts) | cash at the end, net of the loan | closed | best in cells (of 10) |
|---|---|---|---|---|---|---|---|---|
| today | CUT | 97 | 91.4 | 0 | 61.0 (503) | $18,664 | 0/40 | 5 |
| today | HOLD | 95 | 89.2 | 1 | 61.9 (486) | $18,024 | 0/40 | 2 |
| priced | CUT | 97 | 89.8 | 0 | 59.7 (511) | $18,005 | 0/40 | 5 |
| priced | HOLD | 94 | 86.8 | 0 | 61.2 (495) | $17,305 | 0/40 | 2 |
| today | (no best: a tie) |  |  |  |  |  |  | 3 |
| priced | (no best: a tie) |  |  |  |  |  |  | 3 |

**Re-size:** and the cut leaves heavier legs: +4 fatigue on every cutting day.

| rule | option | cut days a career | stat points gained | missed weights | wins per 100 bouts (bouts) | cash at the end, net of the loan | closed | best in cells (of 10) |
|---|---|---|---|---|---|---|---|---|
| today | CUT | 97 | 91.4 | 0 | 61.0 (503) | $18,664 | 0/40 | 5 |
| today | HOLD | 95 | 89.2 | 1 | 61.9 (486) | $18,024 | 0/40 | 2 |
| priced, size 2 | CUT | 97 | 89.7 | 0 | 59.3 (511) | $18,450 | 0/40 | 5 |
| priced, size 2 | HOLD | 94 | 87.6 | 0 | 56.3 (496) | $17,322 | 0/40 | 2 |
| today | (no best: a tie) |  |  |  |  |  |  | 3 |
| priced, size 2 | (no best: a tie) |  |  |  |  |  |  | 3 |

- **The switch is nearly a no-op.** A boxer always has a bout booked, and a booked bout cuts by itself: 97 cut days a
  career on Cut, 95 on Hold. The two options differ by 2 days a year, so a price per cut day lands on both alike
  (size 1: the gap between them stays inside 1.5 wins in 100).
- The re-size opens a 3.0-win gap (Cut 59.3, Hold 56.3) because Hold's cut days sit in the fight week, where the extra
  fatigue reaches the bell. That is at the line of the bar and inside the noise; the cell count is unchanged from today
  (Cut 5, Hold 2, tie 3).
- Where the switch does matter today it is the opposite of the audit's reading: the debt walk-in (2.2 kg over, better
  boxer) does better on HOLD (7.0 wins of 7.9 bouts against 6.1 of 8.9; $3,100 more cash) - bouts are dated later for a
  boxer over the limit, so she boxes less often and wins more.
- Missed weights: 1 in 80 careers. The "fail state" does not happen to a bot that takes every offer.

Priced at size 2, by cell:

| club / seed set | best | CUT | HOLD |
|---|---|---|---|
| fresh/4421 | tie | 61.5% of 39, $24,330 | 59.0% of 39, $23,779 |
| fresh/9001 | CUT | 62.2% of 37, $23,699 | 62.2% of 37, $22,620 |
| debt/4421 | HOLD | 71.4% of 35, $10,577 | 78.1% of 32, $12,190 |
| debt/9001 | HOLD | 66.7% of 36, $9,371 | 69.7% of 33, $10,576 |
| backed/4421 | tie | 61.5% of 39, $36,232 | 59.0% of 39, $35,681 |
| backed/9001 | CUT | 62.2% of 37, $35,601 | 62.2% of 37, $34,522 |
| short/4421 | tie | 61.5% of 39, $13,414 | 59.0% of 39, $12,863 |
| short/9001 | CUT | 62.2% of 37, $12,783 | 62.2% of 37, $11,704 |
| test/4421 | CUT | 54.7% of 106, $10,186 | 47.1% of 102, $6,636 |
| test/9001 | CUT | 51.9% of 106, $8,307 | 44.6% of 101, $2,652 |

**Constants, if it were built:** stat gain x 0.6 on a cutting day and +4.0 fatigue (`WeekPlan` day, where
`diet == "cut"`). **Not recommended:** the measurement says the Hold / Cut switch is not a decision at all. Under the
free hand, the candidates are to remove the switch (the coach cuts when a bout needs it, as now) or to move the choice
to where the weight really bites - the offer: take the bout at this weight in N weeks, or box a class up. That is a
design change for the critics, not a number.

## What could not be measured

- 52 to 104 weeks, bots that take every offer. A player who passes on offers has gaps with no bout, where the diet switch
  would act; the bots have almost none.
- Closures are rare inside these windows (the careful owner's Wednesday class keeps a fresh gym open), so "money that
  saves the club" could not outrank the record in any row but the priced stipend.
- Row 14 measures the coach's default pad nights. A player who moves the pad nights moves the price with them.
- Row 17: only two timings of the move, and 3 careers a cell.

## Probe

`tools/depthprice1b_probe.gd` (391 lines). One row a run:
`-- row=14|15|17|7 [kinds=..] [seeds=..] [careers=n] [weeks=n] [rules=control,priced] [size=1|2] [arms=..]`.
It prints one `DP1B {json}` line a career; the tables above are built from those lines.

Reproduce (one row): `python ops/Tools/godot_slot.py run --who depthprice1b -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tools/depthprice1b_probe.gd -- row=14 careers=4`
(row 17: `careers=3`; the re-sizes: `size=2 rules=priced`). Wall time on a busy PC: row 14 about 15 min, row 15 about
35 min, row 17 about 40 min, row 7 about 20 min.
