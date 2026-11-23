# HOSTPROBE1 RESULT - host your own club show (map v4), code check and greybox probe before any critic

S539, task `ops/research/TASK_HOSTPROBE1.md`. Map: `ops/research/DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI.md` (S463, Kalli; scored
John 7/7, Dola 8/8 from the critic pack, not the code). Measurement only: nothing under `scripts/` changes. v4's new rules are a
flagged local copy, `tools/hostprobe1_rules.gd`; the runner is `tools/hostprobe1.gd`. Sections 1 and 3 (the code check and the
bars) were written and committed BEFORE the run; the bars were not loosened afterwards.

## 1. Code check: every CODE claim of the map at today's tree (main, S539)

true = as the map says; partial = there, but different in a way that matters; false = the code says otherwise; gone = the
symbol or rule no longer exists (it becomes NEW in the probe).

| # | Map claim (CODE) | file:line today | Verdict | Note |
|---|---|---|---|---|
| 1 | `ClubShow.EVERY_DAYS` 112 | scripts/rules/ClubShow.gd:12 | true | |
| 2 | `LEAD_DAYS` 28 | ClubShow.gd:13 | true | the map's 8 weeks (56) is NEW |
| 3 | `COST` $3,500, `TICKET` $25, `HALL` 400 | ClubShow.gd:8-10 | true | one hall, one price today |
| 4 | draw = 40 + 0.7 members + 1.0 rep + 2.5 juniors + 25 home boxers | ClubShow.gd:14-18, 26-27 | true | |
| 5 | `LUCK` 0.70-1.15, `RAFFLE` $600-$1,400 | ClubShow.gd:19-20 | true | |
| 6 | +1 member per 40 tickets on a night that pays | ClubShow.gd:22, 49 | true | |
| 7 | `GymSpend.book_show` / `day_events`: pays up front, settles the draw, one news line | scripts/state/GymSpend.gd:341, 352-378 | partial | the night also keeps a promised "top of our show" (ApproachWire.show_night, HomeBout.sweep, S487-S488) |
| 8 | Today's show has no card / no matchmaking (map s3.1) | scripts/state/HomeBout.gd:1-60 | partial | S488 HOMEBOUT1: one boxer can be booked a legal novice on our own show night (no ticket cut, BoutFinish.gd:130; CashForecast.gd:160). There is still no card, no asks, no hall choice |
| 9 | Away bout `TICKET_CUT` $450 (`BoutRules` 89) | scripts/rules/BoutRules.gd:113 | true | line moved |
| 10 | win +8 members +5 rep; loss -1/-2; stoppage -2/-4 | BoutRules.gd:114-125 | true | |
| 11 | Region shows every 14 days from day 12 (`Data` 101-102) | scripts/state/Data.gd:107-108 | true | |
| 12 | `Region.SHOW_BOUTS` 2 a division | scripts/state/Region.gd:17, 147 | true | |
| 13 | `busy` = rivals already in one of our bouts (HOLD1 not built) | Region.gd:131-136 | true | nothing on a show card is held (there is no card) |
| 14 | novice rule both ways at region shows | Region.gd:150; scripts/rules/AmateurBooking.gd:31 | true | |
| 15 | `rankings` sorts net wins -> wins -> rating; ours at rating 0.0 lose every tie (RANKTIE1) | Region.gd:200-212; scripts/rules/RankLine.gd:17-29 | partial | since S516 LADDERWIRE the table sorts by LADDER POINTS first (LadderPoints, seeded 8 + 4 x net wins + bouts); ours still carry rating 0.0 (Region.gd:209) but that decides only after points, net wins and wins: RANKTIE1 is a corner case now |
| 16 | `Roster.pro_ready`: 7 wins + top-3, or 9 wins | scripts/state/Roster.gd:34-38, 186-197 | true | plus: a national finalist is called at once; each decline raises the bar by 2 wins |
| 17 | `check_pro` runs only when `f.bout` is empty (BoutNight 459, Bouts 413, Sim 406) | Roster.gd:200-215; callers BoutFinish.gd:222, Bouts.gd:457, Sim.gd:414 | true | also needs ProOfferWire.waited and not Champs.active; line numbers moved |
| 18 | goals judged on bout night (`BoutNight` 426-432) | scripts/state/BoutFinish.gd:186-194 | true | moved to BoutFinish (S326 split); GOALFIX1 not built |
| 19 | `FighterGoal.progress` 96-158 | scripts/rules/FighterGoal.gd:112 | true | |
| 20 | morale win +8, loss -12, booked +5 | scripts/rules/FighterProfile.gd:18-27 | true | scaled by heart / confidence (FighterProfile.gd:147-171), never by the current mood |
| 21 | `month_no_fight` -6 has no caller (MOODIDLE1) | FighterProfile.gd:25; read only by AskDates.gd:120 | true | worse than the map says: AskDates.wait_words TELLS the player "A month without a fight costs 6 morale" and nothing applies it (a screen promise the code breaks) |
| 22 | `Sim.weigh_forecast` | scripts/state/Sim.gd:135 | true | |
| 23 | `Bouts.weigh` day-before, `WEIGH_TOLERANCE` 0.05, miss $300 | scripts/state/Bouts.gd:361-397; BoutRules.gd:111-112 | false for amateur shows | since S481 FIGHTWEEK2 an amateur show matches WALKING weights inside the England Boxing gap (WeighGap: 2.5 kg to 65 kg, 5.0 above), with TRAIN IT OFF (0.3 kg, +8 tired) and ASK FOR A KILO (+1 kg, one favour with the host) built (S513). The 0.05 kg limit applies only to camps and pro bouts. FAVOURPROBE1 measured 0 kilo asks and 0 missed weights in 160 club-years |
| 24 | `BoutRules.stale_energy` (-2 Energy a fatigue point over 50, max 20) | BoutRules.gd:33-36, 203-205 (`tank_parts`) | gone (renamed) | the rule lives on as tank_parts' "tired" part |
| 25 | `WeekPlan` burn, `CUT_DEFICIT` 500 | scripts/rules/WeekPlan.gd:75, 327 | true | lines moved |
| 26 | `member_target` = min(natural, cap); `member_limit` names the cap; equipment = places x 3; 22 opening places | GymSpend.gd:160-195; scripts/rules/GymSlots.gd:60-68; GymPlaces.MEMBERS_PER_PLACE 3 | true | quick start reads 22 places (probe scan) |
| 27 | natural members 48 + 0.6 x rep | scripts/rules/Membership.gd:15-16, 38-40 | true | times the dues band's draw |
| 28 | `Career.favours` (map: NEW, cap 2, lapse 26 wks, 0 or 1 at start) | scripts/state/Career.gd:87-90; FightWeekPlan.gd:31, 137-148; FightWeekEvents.gd:8-9, 77-94; LateAskWire.gd; PullOutWire.gd | partial (exists, different) | BUILT since S481/S514/S515: {club: n}, every host STARTS AT 1, cap 3, no lapse; earned by filling a host's late ask (+1) and by every 2nd bout boxed on a host's show (FAVOURS2); spent on outside sparring partners, the kilo, a missed weight, a pull-out's next-month slot. FAVOURPROBE1/FAVOURS2: 0.24 -> 0.77 a touched host after a year. The map's favour is a second, different favour on the same dictionary |
| 29 | `Bouts.short_notice` = our boxer fills another club's short-notice slot | Bouts.gd:280-297 | false | short_notice swaps OUR bout to a tougher opponent after a pull-out; filling another club's gap is LateAskWire (S514) |
| 30 | `Bouts.withdraw_bout` | Bouts.gd:300-312 | true | |
| 31 | `Bouts.fighting_today` | Bouts.gd:105 | true | |
| 32 | `Region._rival_bout` (visiting bouts would resolve through it) | Region.gd:168-190 | true | WorldBout.fast, 3 rounds, LadderPoints.settle |
| 33 | `Region.update_rank` | Region.gd:246-252 | true | |
| 34 | `Champs.active` | scripts/state/Champs.gd:26 | true | |
| 35 | `BoutRead.band` and the pack's "5 pt = 72%" curve (-3 pts = 37, +1 pt = 54) | scripts/rules/BoutRead.gd:399-403 (band), 382-396 (chance) | false | band returns {lo, hi} over the tape's rating range; there is no rating-point curve. Measured (probe scan, Lucy 3-1 as signed): a name +1.0 rating = 36 in 100, +2.0 = 18, +4.0 = 18, -1.5 = 56. The map's win numbers are not the game's |
| 36 | `RankLine.after` / `before` | RankLine.gd:60, 99 | true | |
| 37 | `GymSlots` places (gym floor needs 16) | GymSlots.gd:60 | true | the 16 is NEW |
| 38 | `OppFile` (no tape on an outside novice) | scripts/rules/OppFile.gd | true | |
| 39 | `PadWeek` rate (75 min = ~2.6 mastery) | scripts/rules/PadWeek.gd | partial | file exists; the 2.6 was not re-derived (the probe prices a pad evening, it does not replay it) |
| 40 | `WeekTwist` Monday weights | scripts/rules/WeekTwist.gd | true | |
| 41 | `Sim.daily_gain` (taper cuts the goal's gain) | Sim.gd:164; WeekPhase.gd:22 (taper: volume halved) | true | |
| 42 | pull-outs (map: ESTIMATE 25 in 100 a bout) | scripts/rules/FightWeekEvents.gd:5-6, 25-60; scripts/state/PullOutWire.gd:40-60 | partial (exists, different) | BUILT S490: 35 in 100 on fight week's Monday, three answers (take the replacement x2 rep, go home -6 mood, next month's slot for a favour). PullOutWire.eligible skips OUR home bout |
| 43 | DATAFIX1: "London" names carry far clubs | Data.gd:66-110 | true | e.g. Maria Ortega, Guadalajara Boxing Club, in the London women's lightweight table |
| 44 | `ClubSpend._show` on Club > Money | (no ClubSpend._show found by git grep) | gone | the show is booked from the club pages through GymSpend.book_show |

**What the check changes for the probe.** (a) Favours already exist with different rules: the probe measures v4's favour as
written (cap 2, lapse, service-only earn) AND notes where it collides with the built one. (b) The weight section (4.4) is
written against a rule amateur shows no longer use: the probe measures v4's four answers as written and, beside them, how often
the decision would even arise under today's WeighGap. (c) Win chances come from the game's own `BoutRead.chance`, never the
map's curve. (d) Ranks come from the game's own `Region.rankings` with ladder points (`LadderPoints.settle`), and pro offers
from `Roster.pro_ready`. (e) Pull-outs: v4's 25 in 100 (the map's number) is measured; today's 35 is a side arm.

## 2. Method (fixed before the run)

- **Population.** The TEST CLUB (scripts/state/TestClub.gd on Career.quick_start: Lucy, women's lightweight, 3-1; Kira, women's
  featherweight, 1-0; Josh, men's welterweight, 4-2), each against the game's own named rivals of their class (11, 5 and 4
  names), so no two fighters in a measurement are identical. Each boxer in four states: as signed (WEAK), +5 every stat
  (STRONG), and each of those with the record moved to 6 wins (a win from 7: the PRO-CHASE stage; ladder points re-seeded from
  the record by the game's own LadderPoints.seed_of). The three clubs of map s9: young 40 members / rep 10 / 16 places,
  mid 58 / 24 / 22, grown 120 / 60 / 40. Many seeds; a bout's dice are the night's (seeded by seed x show day x bout), the same
  dice for every option of a cell (common random numbers), so options differ only by the rule.
- **Game modules used:** ClubShow.draw parts, BoutRead.chance (our bouts), WorldBout.fast (rival bouts, as Region._rival_bout),
  LadderPoints.settle + Region.rankings + Roster.pro_ready (rank and pro offer), FighterProfile.apply_morale (morale, with each
  boxer's own personality), BoutRules member/rep constants, WeighGap.margin (the code arm of weight).
- **One value per option, to say which is "right" in a cell.** The exchange is the audit bar's own: $1,000 = 3 reputation =
  3 in 100 pro offer, so 1 reputation = $333 and 1 in 100 pro offer = $333. A seat at our show = $30 ($25 ticket + v4's $5 raffle).
  A member = $100 (members drift back to the target, Membership.step_members: a win's members are worth a few months of dues).
  A morale point = $25 and a pad mastery point = $40 (ESTIMATES of this probe, named so a critic can move them). A favour = the
  measured value of the first favour in the card stage (best plan with 1 favour less best plan with 0, mean over cells), not a
  number picked. Each metric is also printed on its own.
- **Lazy bot:** Community hall, ask the name above as it is, no reserves, Keep the cut, Keep at the ticket read.

## 3. Bars (written before the run; map s9 first, then the audit bars every probe carries)

- **B1 favours.** (a) v4's earn rules give 4-6 favours earned a year across all clubs (test club season); (b) "as it is" beats
  "with a favour" in at least 1 of 3 card cells where both exist; (c) the swap is best in at most 2 of 3 cells where it is legal.
- **B2 halls.** Each hall is best (net cash + reputation) for at least one of the three clubs; the gym floor is never best on net
  cash for the mid or the grown club.
- **B3 routes.** Each of above as it is / with a favour / with a promise / below / below + swap / wait is best in at least one
  card cell and in at most 50% of them.
- **B4 weight.** Over 0.05 / 0.25 / 0.65 kg x (0, 1 favour) x two win levels, each of Keep / Ask the corner / Harder week / Stand
  down is best at least once.
- **B5 boxer C.** Over goal safe + Steady / goal safe + Flat / goal tight, each of Outside novice / Skills bout / Leave off is
  best at least once.
- **B6 rank number.** The printed "No. 3 or better: N in 100" (v4's method: our win chance x the condition tree over the named
  region bouts, each bout's chance taken alone) is within 1 point of the measured Region.rankings result in every cell
  (4,000 seeds a cell).
- **B7 cut rule (a list).** Any option whose gain over the next best is under $150 AND under 1 reputation AND under 3 in 100 pro
  offer in every cell it appears is CUT.
- **A1** no option is the one answer in more than 6 of 10 cells of its decision.
- **A2** every option is right in at least one cell of its decision.
- **A3** the best plan beats the lazy bot by $1,000 or 3 reputation or 3 in 100 pro offer in at least half the show cells
  (club x boxer state x favours).

## 4. Run

`python ops/Tools/godot_slot.py run --who hostprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/hostprobe1.gd -- stage=all rolls=2000 out=E:/FightCamp/tmp/hostprobe1/run2000.jsonl`
(126 s, S539, seed 5390; a 400-roll run gave the same verdicts). 2,000 rolls a card cell, 8,000 nights a hall option, 10,000
day-scales a weight option, 20,000 seeds a rank cell, 2,000 seasons a favour arm. Raw lines: the jsonl above (outside the repo).
Measured favour value (the first favour, best plan with 1 less best plan with 0, mean of 12 cells): **$45**.

## 5. Verdict: FAIL - 2 of 10 bars pass (B1c, A3), and both pass for the wrong reason

| Bar | Result | Measured |
|---|---|---|
| B1a favours earned 4-6 a year | **FAIL** | 6.8 a year as written (service-only, cap 2, 26-week lapse); 15 a year if "an away slot on that club's show" means any away bout. On top of the BUILT favour (every host starts at 1, cap 3, FAVOURS2), which v4 does not know exists |
| B1b "as it is" beats "with a favour" in at least 1 of 3 | **FAIL** | 4 of 16 (25 in 100) |
| B1c swap best in at most 2 of 3 | pass (empty) | best in 0 of 8 legal cells: the swap is never right (best edge -$57) |
| B2 each hall best for one club; gym floor never best on cash for mid/grown | **FAIL** | the TOWN HALL with 2 reserves is best for all three clubs, young included ($2,796 against Community's $2,485 for the young club). The gym floor loses money for the young club (-$179) and is never best |
| B3 each route best at least once, none over 50% | **FAIL** | promise 16, below 17, favour 2, wait 1, as it is 0, below + swap 0 (36 cells) |
| B4 each weight answer best at least once | **FAIL** | Harder week best in 12 of 12; Keep, Ask the corner and Stand down never |
| B5 each boxer-C answer best once | **FAIL** | Outside novice best in 9 of 9; Steady and Flat give identical values (the code scales morale by personality, never by the mood) |
| B6 printed rank number within 1 point | **FAIL** | within 1 in 4 of 8 cells; off by 13 (printed 100, measured 87) and 19 (printed 0, measured 19): a stoppage moves ladder points more than a decision (LadderPoints.settle "stop"), and v4's condition tree counts only who wins |
| A1 no option the one answer in over 6 of 10 | **FAIL** | hall 3 of 3 (Town), weight 12 of 12 (Harder week), boxer C 9 of 9 (Novice) |
| A2 every option right somewhere | **FAIL** | never right: ask as it is, below + swap, gym floor, community hall, 0 reserves (one tie), door price, move down, cancel, Keep / Ask / Stand down (weight), Skills bout, Leave off |
| A3 best beats lazy by $1,000 / 3 rep / 3 pro in half the cells | pass | 72 of 72 (44 of 72 without the hall) - but the "best" is the SAME plan everywhere (Town + 2 reserves + boxers sell + promise), so this measures a dominant strategy, not a decision |

## 6. What is real, what is solved, what is worthless

**Real (the only live choices):**
- **Who to ask, by stage.** With the record as signed the promise to the name above is best in 12 of 18 cells; at the pro
  chase (6 wins) the name below is best in 11 of 18 (a name above at 17 to 37 in 100 costs reputation the pro chance does not
  repay). Wait was right once (Josh, weak, pro chase, +$183).
- **Boxers sell or keep at the read**: sell in 15 of 27 cells (worth $250-$890), keep where the hall already fills.
- **1 or 2 reserves**: 2 in 5 of 9 cells, but the gap is $0-$184 - nearly solved.

**Solved (one answer):** the hall (Town), the weight answer (Harder week), boxer C (Outside novice), the read's door /
move down / cancel (never), reserves (never 0).

**Worthless (CUT by B7, never $150 / 1 rep / 3 pro better than the next option anywhere):** ask with a favour (best edge
$23), ask as it is (always under the promise, -$85), below + swap (-$57), door price ($0: ties keep at best), move down ($0),
Keep the cut / Ask the corner / Stand down on weight, the Skills bout (-$379), the gym floor hall.

**Why (read in the code and the rules copy):**
1. **The promise has no price.** v4's only price is "locks the boxer for 4-12 weeks", and nothing in the game counts a lock:
   no offer is lost that the probe or the game can see. It also EARNS a favour back (v4 4.5 earn 2: the return bout on their
   show). So it is the favour's yes chance for free, plus a favour. The ask with a favour pays the favour and gets it back
   (4.5 earn 3: that club's boxer boxed on our card), so the favour is near free too ($45 measured).
2. **The pro chase has no name above for 2 of 3 classes.** At 6 wins Kira (women's featherweight) and Josh (men's welterweight)
   have no LEGAL name above on ladder points: every one is open class (over 10 bouts) and the novice rule (AmateurBooking.gd:31)
   forbids them. The map's main lever - ask a name above to reach the top 3 - exists only for Lucy's class (11 names).
3. **The hall multiplier is on everything.** v4 multiplies the WHOLE draw by the hall's reach (x1.25 for Town), followings and
   visitors included, and Town's 10 visiting pairs bring 30 more supporters. Town then out-sells Community for a 40-member club.
4. **The weight section is written for a rule amateur shows no longer use.** Under today's WeighGap (walking weights within
   2.5 kg) the boxer 0.05 / 0.25 / 0.65 kg over the class limit is 1.85 to 2.45 kg INSIDE the gap in every cell: the question
   never comes up (FAVOURPROBE1: 0 kilo asks in 160 club-years). Under v4's own rule the Harder week is $166 of win chance for
   ~10 points of "the bout happens", so it always wins.
5. **Boxer C: seats beat morale.** The outside novice brings 22 seats ($660) and +0.5 rep on average; a missed goal costs
   12-21 morale. Leave off beats it only if a morale point is worth more than ~$45 (the probe prices it at $25). The Skills
   bout is the novice bout without its upside.
6. **The printed rank number ignores how a bout ends.** Ladder points move more on a stoppage; a tree over "who wins" is off
   by up to 19 points when a stoppage can cross a line.

## 7. What to change (FREE HAND, owner S534: remove, add, interconnect) - then probe again before any critic

1. **One favour, the built one.** Drop v4's favour ledger (cap 2, lapse, earn rules). The show's asks spend from
   Career.favours (FightWeekPlan.favours, FAVOURS2: ~0.77 a touched host a year), so a favour is scarce for real. No earn
   from our own card (it made spending free).
2. **Price the promise with something the game counts.** The locked boxer has a bout booked, so Roster.check_pro (Roster.gd:200-215, the f.bout check)
   skips them: a promise DELAYS THE PRO CALL until the return bout is boxed, 4-12 weeks later. Make that the price, show it
   on the tile ("No pro offer until the return bout"), and remove the favour it earns.
3. **Halls: reach by name, not by building.** The multiplier goes on the club part only (members + reputation), never on
   followings or visitors; Town fills only from a reputation the young club does not have (e.g. its walk-in reach rises with
   reputation). Re-measure that each hall wins for one club.
4. **Cut the weight section (4.4).** Today's fight week already has the club-show weight answers (train it off, ask for a kilo,
   WeighGap). Nothing to add.
5. **Cut the Skills bout, door price, move down and the ladder swap.** Keep Cancel only as an emergency line (no choice).
6. **Boxers sell needs its real price**: a fight-week pad evening off is the coach's read and the drilled move (PadWeek); price
   it from the game, not $40 a mastery point, and re-measure.
7. **The pro chase needs a legal name above**: interconnect with Newcomers (a novice newcomer arrives when a novice of ours has
   nobody legal, Newcomers.arrive) so the top of the novice ladder is a real ask in every class, or let the map drop the "name
   above" tile where none is legal and lean on the below/wait choice.
8. **Print the rank number with stoppages** (each bout's stop share, LadderRep's method), or print a band.
9. **Side defect found (not fixed here: no scripts/ change in this task):** AskDates.wait_words (AskDates.gd:118-122) tells
   the player "A month without a fight costs 6 morale" and no code applies month_no_fight. Fix the text or wire MOODIDLE1.

## 8. Limits (read before using the numbers)

- Bots follow fixed rules; a bout's result is BoutRead.chance (the game's own read of its bout maths, S398), not a full
  BoutNight; our wins never count as stoppages (PROBE). The region show before our night is one show with the game's pairing
  rule; the card is Community hall's yes chances for every route.
- Morale ($25 a point) and a pad mastery point ($40) are this probe's prices; the favour is measured ($45). Boxer C flips to
  Leave off for a tight goal above ~$45 a morale point.
- The hall nights use v4's own numbers (map 4.2-4.10) and a 25 in 100 pull-out a bout; the game's built pull-out is 35 in 100
  (FightWeekEvents.gd:5).

## 9. Card cells (value $ = seats x $30 + rep x $333 + members x $100 + pro offer x $333 a point + favours x $45)

| cell (boxer / form / record / favours) | above / below | best | gap $ | all routes |
|---|---|---|---|---|
| Lucy|weak|asis|f0 | Maria Ortega / Aisha Rahman | above_promise | 379 | above_promise 1337; above_asis 958; below 558; wait 551 |
| Lucy|weak|asis|f1 | Maria Ortega / Aisha Rahman | above_promise | 121 | above_promise 1255; above_favour 1134; above_asis 942; below 546; wait 541; below_swap 488 |
| Lucy|weak|asis|f2 | Maria Ortega / Aisha Rahman | above_promise | 92 | above_promise 1168; above_favour 1076; above_asis 854; below 501; wait 497; below_swap 442 |
| Lucy|weak|chase|f0 | Erin Doyle / Priya Nair | above_promise | 155 | above_promise 6386; above_asis 6231; below 5632; wait 5561 |
| Lucy|weak|chase|f1 | Erin Doyle / Priya Nair | above_promise | 31 | above_promise 6218; above_favour 6187; above_asis 6133; below 5709; wait 5673 |
| Lucy|weak|chase|f2 | Erin Doyle / Priya Nair | above_favour | 9 | above_favour 5976; above_promise 5967; above_asis 5880; below 5604; wait 5514 |
| Lucy|strong|asis|f0 | Maria Ortega / Aisha Rahman | above_promise | 547 | above_promise 2322; above_asis 1775; below 1082; wait 814 |
| Lucy|strong|asis|f1 | Maria Ortega / Aisha Rahman | above_promise | 203 | above_promise 2323; above_favour 2120; above_asis 1748; below 1084; below_swap 1026; wait 738 |
| Lucy|strong|asis|f2 | Maria Ortega / Aisha Rahman | above_promise | 146 | above_promise 2250; above_favour 2104; above_asis 1723; below 1039; below_swap 980; wait 765 |
| Lucy|strong|chase|f0 | Erin Doyle / Priya Nair | above_promise | 557 | above_promise 13288; above_asis 12731; below 11606; wait 11447 |
| Lucy|strong|chase|f1 | Erin Doyle / Priya Nair | above_promise | 15 | above_promise 13623; above_favour 13608; above_asis 13088; below 12087; wait 12069 |
| Lucy|strong|chase|f2 | Erin Doyle / Priya Nair | above_favour | 23 | above_favour 12482; above_promise 12459; above_asis 11897; below 10884; wait 10796 |
| Kira|weak|asis|f0 | Grace Adeyemi / Megan Price | below | 24 | below 561; wait 537; above_asis 210; above_promise 105 |
| Kira|weak|asis|f1 | Grace Adeyemi / Megan Price | below | 30 | below 593; wait 563; below_swap 535; above_asis 312; above_promise 169; above_favour 124 |
| Kira|weak|asis|f2 | Grace Adeyemi / Megan Price | below | 21 | below 528; wait 507; below_swap 471; above_asis 223; above_promise 51; above_favour 47 |
| Kira|weak|chase|f0 | (none legal) / Nina Kowalski | below | 181 | below 4487; wait 4306 |
| Kira|weak|chase|f1 | (none legal) / Nina Kowalski | below | 144 | below 3944; wait 3800 |
| Kira|weak|chase|f2 | (none legal) / Nina Kowalski | below | 162 | below 3529; wait 3367 |
| Kira|strong|asis|f0 | Grace Adeyemi / Megan Price | below | 30 | below 1028; wait 998; above_asis 870; above_promise 751 |
| Kira|strong|asis|f1 | Grace Adeyemi / Megan Price | below | 26 | below 1039; wait 1013; below_swap 980; above_asis 893; above_favour 772; above_promise 753 |
| Kira|strong|asis|f2 | Grace Adeyemi / Megan Price | below | 33 | below 977; wait 944; below_swap 920; above_asis 838; above_favour 698; above_promise 694 |
| Kira|strong|chase|f0 | (none legal) / Nina Kowalski | below | 216 | below 7307; wait 7091 |
| Kira|strong|chase|f1 | (none legal) / Nina Kowalski | below | 179 | below 7831; wait 7652 |
| Kira|strong|chase|f2 | (none legal) / Nina Kowalski | below | 145 | below 7450; wait 7305 |
| Josh|weak|asis|f0 | Ryan McBride / - | above_promise | 1149 | above_promise 2606; above_asis 1457; wait 966 |
| Josh|weak|asis|f1 | Ryan McBride / - | above_promise | 312 | above_promise 2589; above_favour 2277; above_asis 1427; wait 948 |
| Josh|weak|asis|f2 | Ryan McBride / - | above_promise | 256 | above_promise 2451; above_favour 2195; above_asis 1354; wait 890 |
| Josh|weak|chase|f0 | (none legal) / Ryan McBride | wait | 183 | wait 6752; below 6569 |
| Josh|weak|chase|f1 | (none legal) / Ryan McBride | below | 83 | below 7243; wait 7160 |
| Josh|weak|chase|f2 | (none legal) / Ryan McBride | below | 283 | below 7156; wait 6873 |
| Josh|strong|asis|f0 | Ryan McBride / - | above_promise | 1531 | above_promise 3484; above_asis 1953; wait 1276 |
| Josh|strong|asis|f1 | Ryan McBride / - | above_promise | 450 | above_promise 3408; above_favour 2958; above_asis 1877; wait 1228 |
| Josh|strong|asis|f2 | Ryan McBride / - | above_promise | 374 | above_promise 3233; above_favour 2859; above_asis 1812; wait 1180 |
| Josh|strong|chase|f0 | (none legal) / Ryan McBride | below | 83 | below 8919; wait 8836 |
| Josh|strong|chase|f1 | (none legal) / Ryan McBride | below | 67 | below 8955; wait 8888 |
| Josh|strong|chase|f2 | (none legal) / Ryan McBride | below | 117 | below 8394; wait 8277 |

## 10. Halls (read = keep; V = cash + rep x $333)

| club | options, best first |
|---|---|
| young | town/r2: V2796 cash2968 p10 1540 rep-0.52 full0% half12% short1%<br>town/r1: V2612 cash2875 p10 1490 rep-0.79 full0% half17% short6%<br>community/r2: V2485 cash2290 p10 1220 rep0.58 full15% half0% short1%<br>community/r1: V2351 cash2250 p10 1220 rep0.3 full10% half0% short5%<br>town/r0: V2175 cash2622 p10 1280 rep-1.34 full0% half26% short16%<br>community/r0: V1989 cash2070 p10 1070 rep-0.24 full4% half3% short17%<br>gym/r1: V707 cash-268 p10 -320 rep2.93 full100% half0% short4%<br>gym/r0: V706 cash-179 p10 -280 rep2.66 full100% half0% short17%<br>gym/r2: V653 cash-343 p10 -360 rep2.99 full100% half0% short1% |
| mid | town/r2: V3931 cash3864 p10 2250 rep0.2 full4% half1% short1%<br>town/r1: V3751 cash3775 p10 2200 rep-0.07 full2% half2% short6%<br>community/r2: V3570 cash2998 p10 1790 rep1.72 full43% half0% short1%<br>community/r1: V3446 cash2964 p10 1780 rep1.45 full39% half0% short5%<br>town/r0: V3333 cash3522 p10 2000 rep-0.57 full1% half7% short16%<br>community/r0: V3058 cash2791 p10 1650 rep0.8 full28% half0% short16%<br>gym/r0: V1428 cash539 p10 440 rep2.67 full100% half0% short17%<br>gym/r1: V1426 cash451 p10 400 rep2.93 full100% half0% short4%<br>gym/r2: V1373 cash377 p10 360 rep2.99 full100% half0% short0% |
| grown | town/r2: V7649 cash6354 p10 4470 rep3.89 full65% half0% short2%<br>town/r1: V7514 cash6322 p10 4410 rep3.58 full62% half0% short6%<br>town/r0: V7130 cash6152 p10 4230 rep2.94 full54% half0% short16%<br>community/r1: V5471 cash4221 p10 3550 rep3.75 full96% half0% short5%<br>community/r2: V5471 cash4164 p10 3560 rep3.93 full99% half0% short1%<br>community/r0: V5328 cash4231 p10 3430 rep3.29 full91% half0% short17%<br>gym/r1: V3583 cash2610 p10 2560 rep2.92 full100% half0% short4%<br>gym/r0: V3571 cash2687 p10 2600 rep2.65 full100% half0% short17%<br>gym/r2: V3533 cash2537 p10 2520 rep2.99 full100% half0% short1% |

No critic brief was written: the probe failed, so per TASK_HOSTPROBE1 step 3 the map goes back for the changes in s7 and a
second probe before any critic sees it.
