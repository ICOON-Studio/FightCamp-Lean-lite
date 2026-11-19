# MONEYFOUR2 result - class nights on the built club week: is the money worth the pad time lost?

Probe run: 2026-11-19T08:25:59. 30 seeds x 5 arms = 150 runs of 182 days (seeds 4421..4450), 315s. A measurement only: no rule or constant was changed.

## Population

- The **TEST CLUB** (scripts/state/TestClub.gd): Lucy (women's lightweight), Kira (women's featherweight), Josh (men's welterweight) - three boxers, three classes - and Ana on the mats (no-gi; her mat side is NOT in these numbers), Reid the sessional coach hired. Past the first-week guide and the first hour; rivals' invented pasts re-seeded to the run seed (ladder_probe's own set-up), so a replay agrees. No fighter is synthesized or copied: no two fighters in a measurement are identical.
- 30 seeds from 4421, 182 days each through Sim.step_day - the real day loop: offers, camps, fight weeks, weigh-ins, the game's own bout sim, injuries, pull-outs, late asks, the region's shows. Every sheet offer accepted, the fight week drafted and locked, pro offers declined, a rival gym's call answered by the run seed's policy (seed % 3: accept / not_this_show / pass) - tools/ladder_probe.gd's own _career / _answer / _week, reused by preload, not edited. **No cash floor**: LADDERPROBE4 floors cash at $20,000 because money is not its measurement; here it is.
- Arms, set through ClubClasses.toggle on c.coach on day 0: **N0** no class night, **N1** Wednesday, **N2** Tuesday+Thursday, **N5** every weekday, **CASH-SHORT** the N2 nights with cash set to 4 weeks of the day-0 costs (Sim.weekly_costs). A class night pays +$117 that week (ClubDeal.class_cash), brings a member every 16 class nights (MEMBER_A_NIGHT 0.0625, an ESTIMATE; joins clamped by the member cap), and puts every boxer on pads that evening on the bag (BAG_SHARE 0.5: half the minutes).
- **The trap, kept out:** the coach's usual $350 adult class (GameMoney.CLASSES_WITH_COACH) is NOT the extra class night - it is the same in every arm (Reid hired in all) and never counted here. Class cash is the week's own class_nights income line (GymSpend.income), sampled at every week end. Mastery is read per boxer (sum over f["moves"], last seen minus day 0), never pooled with Ana. A class halves only PAD evenings (DrillWeek._class_bag): the default pad nights are Mon/Wed/Fri and Thursday is a sparring night, so N2's Tue+Thu cost pads only in the weeks the club's state lays pads there (a fight week's sparring nights take pad nights, a twist card can turn sparring to pads) - the mastery cost is state-dependent, and the tables show it.

## The money (means a run; min-max across seeds)

| arm | nights | class cash | members joined | cash w4 | cash w8 | cash w13 | cash at end | weeks below $0 | closed | ticket cut |
|---|---|---|---|---|---|---|---|---|---|---|
| N0 | none | 0.0 (0-0) | 0.0 (0-0) | 11642.0 (10742-11642) | 9336.0 (7610-9336) | 8044.0 (5289-8628) | 464.0 (-2466-2684) | 1.5 (0-5) | 0/30 | 6075.0 (4950-6750) |
| N1 | Wed | 3042.0 (3042-3042) | 0.0 (0-1) | 12110.0 (11210-12110) | 10272.0 (8546-10272) | 9565.0 (6810-10255) | 3384.5 (576-5726) | 0.0 (0-1) | 0/30 | 6075.0 (4500-6750) |
| N2 | Tue+Thu | 6084.0 (6084-6084) | 1.0 (1-2) | 12578.0 (11678-12578) | 11216.0 (9490-11216) | 11094.0 (8339-11678) | 6564.0 (3626-8776) | 0.0 (0-0) | 0/30 | 6075.0 (4950-6750) |
| N5 | Mon-Fri | 15210.0 (15210-15210) | 4.0 (2-5) | 13990.0 (13090-13990) | 14064.0 (12338-14064) | 15729.0 (12942-16404) | 15632.5 (12817-17974) | 0.0 (0-0) | 0/30 | 6075.0 (4500-6750) |
| CASH-SHORT | Tue+Thu | 6084.0 (6084-6084) | 1.0 (1-2) | 4346.0 (3446-4346) | 2984.0 (1258-2984) | 2862.0 (107-3446) | -1668.0 (-4606-544) | 7.0 (4-10) | 0/30 | 6075.0 (4950-6750) |

Cash at end is day 182's cash (at the close day for a closed run). Weeks below $0 counts the week-ends under zero (26 samples); the gym closes after 8 consecutive ones. Ticket cut is money_four_probe's own ledger sampler - the bouts' money, beside the class money.

## The record (means a run over the three boxers; win rate pooled)

| arm | bouts | wins | win rate | mastery gained (sum over moves, 3 boxers) | ladder points at end (3 boxers) | pad boxer-nights halved |
|---|---|---|---|---|---|---|
| N0 | 13.5 (11-15) | 8.0 (5-9) | 56.5% | 322.6 (316.2-327.9) | 77.5 (57-89) | 0.0 (0-0) |
| N1 | 13.5 (10-15) | 8.0 (5-9) | 57.0% | 315.7 (308.1-325.1) | 78.5 (57-107) | 75.0 (71-77) |
| N2 | 13.5 (11-15) | 8.0 (5-9) | 56.5% | 322.6 (316.2-327.9) | 77.5 (57-89) | 6.0 (3-8) |
| N5 | 13.5 (10-15) | 7.0 (5-9) | 56.0% | 291.5 (277.0-316.6) | 77.0 (57-107) | 232.0 (225-233) |
| CASH-SHORT | 13.5 (11-15) | 8.0 (5-9) | 56.5% | 322.6 (316.2-327.9) | 77.5 (57-89) | 6.0 (3-8) |

Mastery gained is net of the weekly fade on undrilled moves and under the technique cap (MoveMastery.gain flattens as a move nears its cap, so a halved evening costs less late in the run); a boxer who left mid-run keeps her last-seen numbers (the left column below). Bouts are the run's own (Career.results, amateur), not the walk-in's past. Ladder points are RankLine.rep at the last day seen. **Pad boxer-nights halved** counts the evenings the class actually took from a boxer's pads (BAG_SHARE applied): a class on a sparring or rest evening halves nothing, so an arm can earn its money without touching mastery - the mechanism the bar below reads.

## Per boxer (means a run; min-max across seeds)

| arm | boxer | division | mastery gained | bouts | w-l-d | win rate | points at end | left mid-run |
|---|---|---|---|---|---|---|---|---|
| N0 | Josh Harper | mww | 87.1 (85.6-91.8) | 4.0 (2-4) | 1.7-1.7-0.0 | 50.0% | 33.0 (13-42) | 0 |
| N0 | Kira Mensah | wfw | 97.3 (92.5-99.2) | 5.0 (3-5) | 2.2-2.5-0.0 | 46.8% | 9.0 (1-33) | 0 |
| N0 | Lucy Jackson | wlw | 138.2 (133.6-140.8) | 5.0 (4-6) | 3.5-1.5-0.0 | 70.0% | 34.0 (16-41) | 0 |
| N1 | Josh Harper | mww | 85.3 (83.9-94.7) | 4.0 (2-4) | 1.7-1.8-0.0 | 49.0% | 33.0 (13-42) | 0 |
| N1 | Kira Mensah | wfw | 94.7 (87.6-97.1) | 5.0 (3-5) | 2.2-2.3-0.0 | 48.9% | 9.0 (1-33) | 0 |
| N1 | Lucy Jackson | wlw | 135.7 (129.9-139.4) | 5.0 (4-6) | 3.5-1.5-0.0 | 70.0% | 34.0 (16-41) | 0 |
| N2 | Josh Harper | mww | 87.1 (84.9-91.8) | 4.0 (2-4) | 1.7-1.7-0.0 | 50.0% | 33.0 (13-42) | 0 |
| N2 | Kira Mensah | wfw | 97.3 (92.9-99.2) | 5.0 (3-5) | 2.2-2.5-0.0 | 46.8% | 9.0 (1-33) | 0 |
| N2 | Lucy Jackson | wlw | 138.2 (133.6-140.8) | 5.0 (4-6) | 3.5-1.5-0.0 | 70.0% | 34.0 (16-41) | 0 |
| N5 | Josh Harper | mww | 96.5 (92.7-98.6) | 4.0 (2-4) | 1.6-1.8-0.0 | 47.1% | 32.5 (13-38) | 0 |
| N5 | Kira Mensah | wfw | 72.1 (66.5-90.0) | 5.0 (3-5) | 2.2-2.4-0.0 | 47.4% | 9.0 (1-33) | 0 |
| N5 | Lucy Jackson | wlw | 122.8 (113.3-133.2) | 5.0 (4-6) | 3.5-1.5-0.0 | 70.0% | 34.0 (16-41) | 0 |
| CASH-SHORT | Josh Harper | mww | 87.1 (84.9-91.8) | 4.0 (2-4) | 1.7-1.7-0.0 | 50.0% | 33.0 (13-42) | 0 |
| CASH-SHORT | Kira Mensah | wfw | 97.3 (92.9-99.2) | 5.0 (3-5) | 2.2-2.5-0.0 | 46.8% | 9.0 (1-33) | 0 |
| CASH-SHORT | Lucy Jackson | wlw | 138.2 (133.6-140.8) | 5.0 (4-6) | 3.5-1.5-0.0 | 70.0% | 34.0 (16-41) | 0 |


## The trade, one line per arm (paired on the same seeds against N0)

- N0: the baseline - $0 more, 0 mastery, 0 wins (every pad evening kept).
- N1: $3042 more for 6.92 mastery lost and 0.0 wins more (cash at the end $+2999, ladder points +1.17, paired on the same seeds).
- N2: $6084 more for 0.02 mastery lost and 0.0 wins more (cash at the end $+6094, ladder points -0.03, paired on the same seeds).
- N5: $15210 more for 31.12 mastery lost and 0.1 wins fewer (cash at the end $+15212, ladder points -0.50, paired on the same seeds).
- CASH-SHORT: $6084 more for 0.02 mastery lost and 0.0 wins more (cash at the end $-2138, ladder points -0.03, paired on the same seeds). Its cash delta carries the poor start (4 weeks of costs against N0's full bank); the class cash is the money the nights themselves pay.

**The price of the money** (mastery lost per $1,000 of class cash, paired on the same seeds, cheapest first): N2: 0.00 mastery per $1,000 ($6084 class cash, mastery -0.02); N5: 2.05 mastery per $1,000 ($15210 class cash, mastery -31.12); N1: 2.28 mastery per $1,000 ($3042 class cash, mastery -6.92). CASH-SHORT buys N2's nights from a poor start - its question is survival, not the rate.

**Free lunch within noise: N2** - $6094 more cash, wins +0.0 and mastery -0.02: the record is not worse within the bout sim's noise (half a win, one mastery point over the run), so the money is effectively free. The number that would fix it: $117 (ClubDeal.class_cash): only 5.6 of a possible 156 boxer-nights were pad evenings (4%), so BAG_SHARE barely applies at any value - the money lever is what touches this arm; lower it (making a class take the whole evening, sparring included, is a rule change, not a number). The members (MEMBER_A_NIGHT 0.0625, an ESTIMATE) compound the money side.

**Does the money save the gym?** CASH-SHORT starts on $7968 (4 weeks of the $1992 weekly costs, against N0's start 16200.0 (16200-16200)) with Tue+Thu classes: 0/30 runs closed, mean 6.7 weeks below $0, cash at the end -1668.0 (-4606-544); the same nights on the normal start (N2) closed 0/30, and N0 closed 0/30. Cash marks: w4 4346.0 (3446-4346), w8 2984.0 (1258-2984), w13 2862.0 (107-3446), w26 -1668.0 (-4606-544). The two nights pay $6084.0 (6084-6084) over the run and bring 1.0 (1-2) members (the cap clamps joins). The gym closes after 8 consecutive week-ends below $0 (GymBills.CLOSE_AFTER_WEEKS). The class money keeps the doors open but does not restore the bank: two nights are a lifeline, not a repair.

## Read

- **The answer depends on the week's state.** N2's Tue+Thu are sparring or rest evenings on the coach's default week: only 5.6 of a possible 156 boxer-nights were pads (4%), so the class took almost nothing from training (mastery -0.02, wins +0.0) yet paid $6084. The cost appears only in the weeks a fight week or a twist card lays pads on those evenings. N1's Wednesday is a pad night almost every week (75.0 halved boxer-nights): it pays 6.92 mastery for $3042.
- **The record cost is mastery, not wins, over 26 weeks.** N5 pays 31.12 mastery yet wins move -0.1 and points -0.50: the halved evenings slow the moves, and the bout sim barely notices in 26 weeks. The cost is not uniform across boxers: under N5, Josh Harper gains +9.4 mastery against N0 (the coach's learning target shifts when the minutes halve) while Kira Mensah loses 25.1.
- **The choice the numbers put on the table.** N0 keeps every pad evening and ends on 464.0 (-2466-2684), below $0 on 1.5 (0-5) weeks - the TEST CLUB's money is tight. N2 ends on 6564.0 (3626-8776) with the record intact on the default weeks; N5 ends on 15632.5 (12817-17974) for 31.1 mastery. A club short on cash takes the nights; a club protecting its boxers' mastery keeps Wednesday's pads. The bar above names the number to change if the Tue+Thu money stays free.

## What could not be measured

- 182 days is 26 weeks, not a year: the members' dues compound slowly (a member every 16 class nights), so a full year would widen the money side of every class arm. MEMBER_A_NIGHT is an ESTIMATE (ClubDeal.class_members_4w / 4), not a measured rate.
- The mastery cost lands only on pad evenings: N2's Thursday is a sparring night in the default and camp weeks, so its cost is small and state-dependent (it grows in Hard-load and camp-protocol-3 weeks, when Tuesday is a pad night). N1's Wednesday is a pad night in almost every week; N5 pays on Mon/Wed/Fri. A different pad layout (the player's own evening edits) would move the cost again - this probe plays the coach's default weeks.
- The bout record is noisy over ~4 bouts a boxer in 26 weeks: the paired seeds cancel the set-up, not the fight sim's own divergence once mastery differs. The win-rate spread (min-max) is the honest error bar.
- Ana's mat side (BJJ dues, her own classes) is untouched by the boxing class nights and is not in these numbers; the $350 adult class is in every arm's cash alike and cancels in every difference.

Reproduce: `python ops/Tools/godot_slot.py run --who moneyfour2 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/moneyfour2.log --path . --script res://tools/money_four2_probe.gd -- seeds=30 seed=4421 days=182`
