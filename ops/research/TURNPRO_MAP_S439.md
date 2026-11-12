# TURNPRO1 - Turning pro: three answers, each with its price (design map, round 3, S439)

Owner's yes: "put the comparison on the cards". Round 1 scored depth 4 and 4; round 2 scored 5 and 6. Round 3 changes the MECHANIC where
the critics found lookups and wrong code claims:
- NOT YET gets its own pick, **Enter the nationals too / Club shows only**. HOLD is now compared with the line a coach would really take.
- HOLD gets a prize only it can get: **Bow Lane pays $150 a week toward the stipend** while it holds. A miss now warns that a third no shuts the door.
- The day job gets a real price instead of a flat x0.85: **3 training mornings a week, none Hard, camps at most Standard**. That costs about 5 in 100 at the regional final.
- The 4-or-8-week debut gets a real price: **the club pays the stipend until the debut** (8 weeks costs $1,000 more). The pick shows the scale and the opponent.
- Mood is priced in the ring, read from the code paths: a pro booking gives no morale, an amateur booking gives +5, and trust enters BoutRead. "Best mood" without a band move is gone.
- Every money figure takes each answer's own branches (a call that comes back is taken), at two dates: 12 Jul (26 weeks) and 10 Jan 2028 (52 weeks, TURNPROBOT1's date).
- Pro nights are 8 weeks apart by default (a tune-up chosen by a read of 0.82 that includes the usual camp often sits less than 6 points under her). Ducks are counted.
- The Tune-ups / Step up pick is cut: it bound nothing. Both nightly offers and the duck rule are one line in the pro road row.
- New row: **Coach's pad nights** (AGREED, NOT BUILT cost; the clash weeks come from camp dates the game already has).
- One best tag per row, each on one measure all three columns share.
Drawn: `docs/mockups/s439/turnpro/screen_r3.png` (source `screen_r3.html`). Forecast model behind every figure: `docs/mockups/s439/turnpro/forecast_r3.py`
(40,000 runs per answer, fixed seed; it encodes the rules below and marks each one CODE or NEW).
Sources read: CRITIC_PACK.md (whole), CORE_LOOP_MAP_S432.md (C28, C31, PRO OFFER), rounds 1-2 of this map and the four critic notes and pictures.
Code read this round: `scripts/state/Roster.gd` 160-287 (pro_ready, check_pro, debut_sheet, turn_pro, debut_day, decline_pro), `scripts/state/ProLadder.gd`
(consts, book 303-334, the duck at 316), `scripts/rules/Matchmaking.gd` (pay_of 215, apply_result 235, next_weeks 280, DUCKS_BLOCK, SOFT_GAP),
`scripts/state/Champs.gd` 30-110 (cannot_enter, enter), `scripts/state/GymSpend.gd` (gain 89, member_cap 115, member_target 132),
`scripts/rules/GymUpgrades.gd` 27-29 (premises caps), `scripts/rules/FighterProfile.gd` (MORALE_EVENTS 18-31, TRUST, mood, trust, apply_morale 147-170),
`scripts/rules/BoutRead.gd` 215-240 (trust enters the read), `scripts/state/Bouts.gd` 190-200 (booking gives +5), every `apply_morale(` call in scripts/,
`scripts/state/Clock.gd` (day 0 = Mon 5 Jan 2026), `scripts/rules/SeasonPath.gd` consts.

## 1. The idea in five lines
1. When a promoter calls, the offer shows the three answers side by side: TURN PRO NOW, HOLD FOR THE NATIONALS, NOT YET. Each has its own button and its own price.
2. Every figure is a forecast from the rules that will run, at two dates (12 Jul and 10 Jan). Each bout counts at its win chance, every branch is followed, and the new members' dues are counted.
3. Each answer leads on a different row. TURN PRO gives the most cash and the soonest ladder, but overrules a boxer who wants the nationals. HOLD gives a title bet with holding money and a seat, and a miss costs two noes. NOT YET gives the smallest risk: the call comes back almost surely, 10% worse and unseated.
4. Two settings sit inside the answers and carry their own prices. The stipend or day job (above the columns) trades $6,500 for training mornings and the boxer's wish. The debut in 4 or 8 weeks trades $1,000 of stipend for 4 in 100 and a safer cut.
5. Turning pro now touches the rest of the gym: a pro is in a 6-week camp 6 weeks of every 8, and those camps share the coach's pad nights with the other three fighters.

## 2. What is built today (read in the code)
| Piece | Where | What it does |
|---|---|---|
| The call | `Roster.pro_ready` 174, `check_pro` 188 | 7 wins and a top-3 rank, or 9 wins at any rank. A national finalist is called whatever the record, but only with 0 noes. Not while booked or while `Champs.active`. Each no raises the bar by 2 wins, as an ABSOLUTE count (`need = PRO_WINS + declines * PRO_RETURN_WINS`), so a 9-1 boxer who says no is called again the next week. At 2 noes only No. 1 is called (line 182, whatever the wins). At 3 noes, never (line 175). |
| The terms | `check_pro` 194-197 | terms 1.0 from Bow Lane, 0.9 from Harrow & Finch (a 2nd call). The 0.9 reaches ONLY `bout.terms` -> `ProDebut.night` (the debut ticket share, about $14 in the case). `ProLadder.book` 325 stores `MM.pay_of` with no terms. Today a no costs nothing on ladder nights. |
| Saying yes | `Roster.turn_pro` 240-272 | Pays the licence $230, medicals $875 the first time, and the trainer's licence $140 if the coach has none. Sets `weekly_salary` 0 at signing. Does NOT clear `f.day_job` (so `GymSpend.gain` 90 keeps x0.85 for a pro). Debut on `debut_day` = the Saturday 4 weeks on (PRO_DEBUT_WEEKS 4, no choice). Opponent named `PRO_OPP_NAMES[posmod(day, 4)]`, rating = `BoutRules.fight_power(stats, {}, 0, "")` - 1.0. Applies no morale event (no "booked"). |
| Saying no | `Roster.decline_pro` 281 | `pro_declines += 1` and a news line. Nothing else: no hold, no terms change on the ladder, no wins counted from the no. |
| Booking morale | `Bouts.gd` 198 | An amateur booking applies "booked" +5. `turn_pro` and `ProLadder.book` do not. The other callers are only bout results (`BoutNight` 423), goals (432), corner calls (`CornerTrust` 46-48) and twist cards (`Sim` 65). "rest_week" and "month_no_fight" are in the table but never applied. |
| Trust in the ring | `FighterProfile.TRUST`, `trust()`; `BoutRead` 227 | Fired up 1.05, Steady 1.0, Flat 0.85, Low 0.7 by band. `BoutRead._game_edge_of` multiplies the corner's uptake by `trust(f)`, so the read (the win chance on screens) moves with the band. A move inside a band changes nothing. |
| Morale scaling | `apply_morale` 147-170 | A negative event x lerp(1.3, 0.7, heart). The coachability factor lerp(1.4, 0.7, coachability) applies only when `kind == "overruled"` (line 162). A positive event x lerp(0.9, 1.1, confidence). |
| Debut money | `ProDebut`, `BoutNight` 378-382 | Tickets = 20 + members/2 + 2 a win + 10 a title, at most 100, $50 each. The boxer gets half of what is sold past 60, times the terms; the gym 25% of that. Paid win or lose. |
| After the debut | `ProLadder.join`, `result` 336 | The debut gives no ladder growth. Bout 2 is booked for 8 weeks after the debut. |
| Ladder cadence | `Matchmaking.next_weeks` 280 | 6 weeks if the last opponent was 6 or more points below (SOFT_GAP), 12 if more than 2 above, else 8 (+8 after a stopped loss). |
| Offers | `ProLadder._make_offers` 148-185 | A tune-up whose read is nearest 0.82 (inside 0.70-0.93), a step up nearest 0.50 (an unranked boxer reaches No. 15-20 only), a payday 0.20-0.45 in the top 10. The read includes the usual camp (BoutRead USUAL_CAMP 2), so a tune-up can sit under 6 points below her: then the cadence is 8 weeks. |
| Ducks | `ProLadder.book` 312-317, `Matchmaking.note_choice` 195, DUCKS_BLOCK 2, `stakes` 432 | Taking an offer while the step up is on the table is a duck: one fan lost. At 2 ducks the step up is no longer offered (line 177), and asks for names rated at or below her are refused (`MM.ask` 189). |
| Ladder pay | `Matchmaking.pay_of` 215 | Purse $1,500 unranked (ranked: +$400 a place above 21) + $150 a place for a ranked name above her; tickets 150 x (fans + 5) x closeness (1 + gap/15 when below). The gym takes 25% (GYM_SHARE) and pays a camp bill of 6% of the same field. |
| Table seat | `ProLadder._review_streak` 369, REVIEW_WINS 5 | An unranked pro takes the bottom seat at 5 pro wins on a winning record. |
| Amateur money | `BoutNight` 393-396, `BoutRules.TICKET_CUT` | A club bout pays the gym $450 win or lose; a championship bout pays nothing. |
| Results and members | `BoutRules` 89-99, `Membership.step_members`, `GymSpend.member_target` 132 | Win +8 members and +5 reputation; loss -1 and -2. Target = min(natural_members, `member_cap`); the count walks 25% of the gap a week. Without room under the cap, a win's lasting members disappear. Caps: Unit 70, Bigger unit 140, Club building 250 (`GymUpgrades` 27-29). |
| Stipend / day job | `GymSpend.set_stipend` 101, `gain` 89-90, DAY_JOB_GAIN 0.85 | Stipend $250 a week, or a day job: $0, and every training gain x0.85. That is the only price today. |
| The nationals | `SeasonPath`, `Champs` | Entries Mon 18 Jan to Mon 15 Mar 2027 (close = day 70 of the year: day 434). `cannot_enter` allows a boxer with any number of noes, and allows a booked bout before the semi minus 2 days. `enter` answers every club offer. Regional semi Mon 29 Mar, final Mon 5 Apr, nationals from Mon 26 Apr (rounds on days +0, +1, +7, +8). Titles go to `Roster.titles` (+10 debut tickets each). |
| The screen | `scripts/ui/modals/ProOffer.gd` (99 lines) | Ticket bar, the boxer's half, the gym's 25%, THE GYM PAYS NOW, WHAT ENDS; footnote "$1,500 a bout, +$500 a win, up to $3,000" (untrue for ladder bouts); Turn pro / Stay amateur. |

## 3. What was thin after round 2 (the critics, checked against the code)
1. HOLD was dominated by a line the screen did not show: Not yet, then enter the nationals (`cannot_enter` accepts a boxer with a no). CONFIRMED. Fixed by NOT YET's own pick and by HOLD's holding money.
2. The day job was a $6,500-for-1-in-100 lookup. CONFIRMED. Fixed with a structural price (D2).
3. Prices printed as facts were NEW: 10% terms on ladder nights, the hold, "2 more wins from the no", "free full-time pro training" (turn_pro keeps day_job). CONFIRMED. They are build tasks that land BEFORE the screen (section 8 order), and section 6 marks each one.
4. "Debut loss mood -12" ignored the heart scaling: -10.7 for Jade. CONFIRMED. One critic's "Low 38" is wrong: 38 is Flat (Low is under 30).
5. "Heard 64 to 74, BEST MOOD" moved no band. CONFIRMED. Round 3 follows the next booking (+5, Bouts 198), which takes her to Fired up 79. The band moves, so the tag has a ring effect (about +1 in 100).
6. Dues assumed room. CONFIRMED: 96 members is over the Unit's 70. The case now names the Bigger unit (140), and the header shows "96 of 140".
7. The 6-week tune-up cadence was drawn as fact. CONFIRMED. The default is now 8 weeks, and the 6-week case is a hover note.
8. HOLD's and NOT YET's money ignored their success branches. CONFIRMED. The model follows every branch.
9. The tune-ups path left out ducks. CONFIRMED (`book` 316). Counted in the model; a DUCKS line is on the screen.
10. The 4/8-week debut read off one number. CONFIRMED. Now it carries a stipend price, the scale and the opponent.

## 4. The mechanics, each a decision with its options and their prices
### D1. The answer to the call (three columns, three buttons)
| Answer | Price | Prize |
|---|---|---|
| TURN PRO NOW | $1,245 today (CODE). The stipend runs to the debut, then stops (NEW; $1,170 in the case). The $450 club cuts and the nationals end (CODE). A boxer who wants the nationals is overruled: -15 for Jade, Flat 49, and no pro booking lifts her (CODE: turn_pro applies no "booked"), so she boxes the debut Flat: 66 to 63 in 100 (BoutRead with trust 0.85). A debut loss (37 in 100) costs -1 member, -2 reputation, -10.7 mood (Flat 38, the next night 82 to 79) and delays the 5-win seat (CODE). Two weeks in three in a 6-week camp, sharing the coach's pad nights (AGREED). | The most cash at both dates in the drawn case: -$700 to July, +$2,830 to January. The ladder soonest: pro from 13 Feb, a seat by January 61 in 100 (CODE review). Full terms. The day job ends at signing (NEW, F14). |
| HOLD FOR THE NATIONALS (only while entries are open and `cannot_enter` is clear) | The boxer must be entered by Mon 15 Mar (a Home need). No club bouts once entered, and no cut at the championships (CODE). A miss (64 in 100) counts as TWO noes: only a No. 1 rank AND 2 more wins than at the miss bring a call (CODE No. 1 line + NEW count), from Harrow & Finch at 10% less (NEW reach), and a third no shuts the door for good (CODE). 37 in 100 are called again by January. | Bow Lane pays $150 a week toward the stipend until the run ends (NEW): about $1,990 in the case. A title (36 in 100) brings Bow Lane back the Monday after the run at full terms, and the debut seats her at No. 20 (NEW): about $465 a tune-up night to the club instead of $390. The boxer is heard (NEW event): 74, then Fired up 79 after the next booking. |
| NOT YET, with its own pick: Enter the nationals too (default when she can enter) / Club shows only | One no. Harrow & Finch call at 2 more wins than at the no and a top 3 rank, or 4 more at any rank (NEW count from the no; CODE values). 10% less on every ladder night until the first contract talks: about $350 a tune-up night instead of $390 (NEW reach of CODE 0.9). No seat. Club shows only: overrules a "nationals first" boxer (Flat 49 until the 13 Feb booking adds 5: no bout is fought Flat) and gives up the title. | The smallest risk: a miss leaves one no, and the call comes back in nearly every run (95 in 100 by July). Club shows only: $450 a bout and no camps (the least clash on the coach's pads). Enter: the same bouts and title chance as HOLD. |

Why it is a decision, not a lookup (drawn case, stipend, section 5): TURN PRO leads on money and ladder, HOLD on the pro start, bouts and mood in the ring, NOT YET on risk. HOLD against Not yet + enter is now a real bet. It pays +$1,990 to July and wins on a title (+$3,780 against +$1,100 by January), but loses on a miss (-$2,590 against -$120). The miss is the likelier branch (64 in 100), so neither one dominates.

### D1b. TURN PRO's own pick: the debut date (NEW)
| Option | Price | Prize |
|---|---|---|
| 4 weeks: Sat 13 Feb | 63 in 100 (Jade overruled, Flat). The weight cut has 4 weeks: 59.8 kg of 60 on the scale the day before (ESTIMATE in this case; the screen reads the game's scale forecast). | The stipend for 4 weeks only. |
| 8 weeks: Sat 13 Mar | 4 more weeks of stipend, -$1,000; with the later ladder, -$1,170 to July and -$1,340 to January. | 67 in 100 (4 more weeks of training and a camp). 59.4 kg: twice the time to make the weight. |
The deciding numbers sit on the pick itself: the date, the chance, the scale and the price. When it flips: a boxer 2 or more kg over flips it to 8 weeks, and so does an injury, a boxer who is Flat, or a debut whose loss would cost a cash-poor gym its members. A cash-poor gym on the weight flips it to 4 weeks. The opponent (Paige Whitlow 0-0, from `PRO_OPP_NAMES[posmod(371, 4)]`) and the injury state are printed beside it.

### D1c. NOT YET's own pick: this season (NEW binding)
| Option | Price | Prize |
|---|---|---|
| Enter the nationals too | No club bouts once entered; championship bouts pay no cut (CODE); 3 weeks of camps beside Kofi's (AGREED cost). | Title chance 36 in 100 (+$1,100 by January in that branch, with 10 more debut tickets); a "nationals first" boxer is not overruled. |
| Club shows only | No title. A "nationals first" boxer is overruled (no ring effect, see D1). | $450 a bout, and the call comes sooner (87 in 100 by July). No camps, so no clash. -$3,230 / +$160 against -$3,530 / +$320. |
Pressing "Not yet, enter the nationals" sets a Home need to enter when entries open (or enters at once if they are open). It binds as HOLD's need does. It is not a lens.

### D2. While an amateur: stipend or day job (the Club > Money setting, now with a real price; NEW DAYJOB2)
| Option | Price | Prize |
|---|---|---|
| Club stipend | $250 a week (CODE) = $6,500 to 12 Jul. | Seven training mornings and any camp intensity. |
| Day job | Only 3 training mornings a week (the other four read "Work" on the week board), none Hard, and camps at most Standard (NEW; replaces the flat x0.85). ESTIMATE: club bouts 65 to 62 in 100 by July, regional final 55 to 50, title 36 to 31 in 100. The boxer then wants to turn pro: HOLD and NOT YET overrule her. With no ring effect (her next amateur booking lifts her back to Steady), it is printed as a band, not as a chance. | $0. |
Each stay column prints its day-job figures in small print. On a day job the money order flips: HOLD +$2,410 / +$6,530, NOT YET + enter +$290 / +$4,100, TURN PRO -$680 / +$2,880. So the setting changes the best answer, and each setting has a price in the ring, not only in cash.

### D3. Amateur bouts near the line (folded)
The existing versus screen row "what a win and a loss change" gains one pro line when the boxer is within 2 wins of a call. No chip.

### D4. The boxer's wish (NEW, from traits and the setting)
- On a day job: TURN PRO. Otherwise confidence 65+ wants TURN PRO, and heart 65+ with entries open wants THE NATIONALS FIRST (the higher trait wins). Otherwise there is no wish, and the mood row shows "no change" for all three.
- Events: `call_heard` +10, `call_overruled` -16. The coachability factor in `apply_morale` (line 162) is extended to `call_overruled` (NEW, one line).
- Jade (heart 68, confidence 55, coachability 50, morale 64): overruled -16 x 0.892 x 1.05 = -15.0, Flat 49; heard +10 x 1.01 = 74.1.
- What the mood row prints is the band at her next bout, from the CODE booking rules. Pro: no booking event, so Flat 49 at the debut, 66 to 63 in 100. Amateur: +5 at the next booking, so heard means Fired up 79 on 13 Feb (+1 in 100), and an overruled amateur is back to Steady 54 before she fights.

### D5. Coach's pad nights (AGREED, NOT BUILT cost; the clash weeks are computable today)
The row counts the weeks to 12 Jul in which two of the gym's boxers are in camp on the head coach's 3 pad nights. The camp dates come from booked bouts (pro LEAD_DAYS 42, nationals camps). The case: TURN PRO 3 weeks (her 10 Apr camp from 27 Feb meets Kofi's nationals camp 8-29 Mar, and then she is in a 6-week camp 6 weeks of every 8); HOLD 3 weeks (both in nationals camps); NOT YET + enter 3; NOT YET club shows only 0 (an amateur club bout is a fight week, not a camp). What a shared night costs the other fighter waits for the AGREED pad-sharing build (CRITIC_PACK 4.2). Until then the row says only how many weeks clash.

### 4.5 No answer always best (the TURNPROBOT1 cases; model figures, stipend unless named)
| Case | Most cash to Jan | Best pro start | Smallest risk | Best in the ring | Least clash |
|---|---|---|---|---|---|
| A. Jade 7-2 No. 2, entries open, wish nationals | TURN PRO +$2,830 (Hold -$300, Not yet + enter +$320) | HOLD (36 in 100 seated) | NOT YET | HOLD (Fired up) | NOT YET club shows only |
| A2. Jade on a day job (wish turns to pro) | HOLD +$6,530 (Not yet + enter +$4,100, pro +$2,880) | HOLD (31 in 100) | NOT YET | TURN PRO (heard, debut 66 not 63) | NOT YET club shows only |
| B. 9-1 No. 1, no wish | TURN PRO +$3,090 (Hold +$960, Not yet + enter +$900) | HOLD (45 in 100 seated) | NOT YET (call at 11 wins, from the no) | none (no wish: no row) | NOT YET club shows only |
| C. 7-2 No. 3, April (entries closed), day job, wish pro | NOT YET club shows only (about +$3,860 against +$2,880) | TURN PRO (only one) | NOT YET | TURN PRO | NOT YET |
| D. 8-1 No. 2, 3 kg over, stipend | TURN PRO in 8 weeks (the 4-week cut is unsafe) | HOLD | NOT YET | depends on wish | NOT YET club shows only |
| E. 9-3 No. 5, entries closed, confidence 70, stipend | TURN PRO | TURN PRO | NOT YET (one no, the call at 11 wins) | TURN PRO (heard) | NOT YET |
Case E is still the weak spot: with the stipend paid and no nationals open, TURN PRO wins every row except risk and clash. The real choice there is the strip (a day job makes NOT YET the money best). TURNPROBOT1 holds the bar across the whole matrix: no answer is best on its measure in more than 2 of 3 situations, and HOLD must be best somewhere outside the mood row (it is: money on a day job, and the pro start).

## 5. One week, played (Week 54, Mon 11 Jan 2027, day 371)
The gym: Anvil Street Gym, Bigger unit (cap 140), 96 members, head coach Reid (no pro licence yet), cash $8,420, running +$135 a week.
The four: Jade Kirwan (women's lightweight 60 kg, 22, amateur 7-2, No. 2 London, stipend, morale 64 Steady, heart 68, confidence 55,
coachability 50); Kofi Mensah (men's lightweight, to be entered for the nationals, camp 8-29 Mar); Dean Walsh (welterweight, club show 13 Feb, a
fight week); Ana Ribeiro (no-gi, on the no-gi coach's mat). Jade has 9 bouts and over 91 days registered: eligible.
- Sat 9 Jan: Jade wins a club show (7-2; +8 members, +5 reputation, +$450). `check_pro` fires: Bow Lane Promotions.
- Mon 11 Jan: CONTINUE stops on PRO OFFER (red need). The screen:
  - Header: "Jade wants the nationals first (heart 68), mood Steady 64". "If she signs: cash $7,175 today, the stipend runs to the debut, then the week is +$385; gym 96 of 140 members."
  - Strip: Club stipend picked. The day job keeps $6,500 to 12 Jul, but she gets 3 mornings, none Hard, and camps at most Standard: regional final 55 to 50, club bouts 65 to 62 by July.
  - TURN PRO NOW (debut 4 weeks: Sat 13 Feb, 63 in 100, 59.8 kg of 60; 8 weeks: Sat 13 Mar, 67, 59.4 kg, -$1,170), vs Paige Whitlow 0-0. Bouts 13 Feb, 10 Apr, 5 Jun (3 by July, 6 by January). Money -$700 to July / +$2,830 to January: licences -$1,245, stipend to the debut -$1,170, debut tickets +$138 (82 sold), pro nights about +$390 each after the camp bill (ducks counted), and dues from wins. Seat by January 61 in 100. Debut loss 37 in 100. Mood: overruled, Flat 49 at the debut. Pad nights: 3 weeks clash.
  - HOLD. Bouts 13 Feb (66: Fired up), 13 Mar (65), regional 29 Mar (65) and 5 Apr (55), nationals 27 Apr-4 May (about 50 a round); after a title, a debut on Sat 12 Jun, seated; after a miss, club shows 22 May and 3 Jul. Money -$1,380 / -$300 (title: +$3,780 by January; miss: -$2,590), including about +$1,990 of holding money. Miss 64 in 100: two noes, 37 in 100 called again by January, and a third no shuts the door.
  - NOT YET (Enter the nationals too). The same bouts, with no holding money; the call comes back after the run (95 in 100 by July) at 10% less, unseated. Money -$3,530 / +$320 (club shows only: -$3,230 / +$160).
- The player clicks Day job on the strip. The header turns to "Jade wants to turn pro". TURN PRO's mood cell becomes "Heard: 74, Steady; the debut 66". HOLD's becomes "Overruled: Flat 49 until the 13 Feb booking". HOLD reads +$2,410 / +$6,530 and becomes the most cash, but its title chance drops to 31 in 100. The player clicks back to the stipend.
- The player presses HOLD FOR THE NATIONALS. Jade goes 64 to 74. News: "Bow Lane Promotions will hold the offer through the nationals and pays $150 a week toward Jade's stipend." A Home need (amber): "Enter Jade for the nationals by Mon 15 Mar (Bow Lane is holding)". Club > Money gains an income line "Bow Lane holding money +$150 a week".
- Tue 19 Jan: a club offer for Sat 13 Feb is accepted. "Booked" +5 takes Jade to 79, Fired up. The offer card shows her read at 66.
- Week review Mon 18 Jan: "Jade: heard on the pro call (Fired up after the booking). Bow Lane holds the offer until the nationals end: +$150 a week."
- The other branch, same Monday: TURN JADE PRO, debut 4 weeks. Cash $8,420 to $7,175. The stipend runs to 13 Feb, then the weekly line rises $250. Home's next fight is the debut, Sat 13 Feb, vs Paige Whitlow. Jade drops 64 to 49 (Flat), and the debut card reads 63.

## 6. Every number (CODE = read in the code, file named; NEW = a rule this map adds; ESTIMATE = forecast or design value)
| Number | Tag | Source |
|---|---|---|
| Call at 7 wins + top 3, or 9 wins; finalist with 0 noes; No. 1 only at 2 noes; never at 3 | CODE | Roster.PRO_WINS, PRO_RANK, PRO_WINS_ANY_RANK, pro_ready 174-184 |
| 2 wins a no, counted ABSOLUTE today | CODE | pro_ready 180 |
| "2 more wins than at the no" (and "and 2 more wins" at 2 noes) | NEW | f.pro_back_wins (PROHOLD1) |
| x0.9 second promoter on ladder nights until contract talks; about $350 instead of $390 a tune-up night | NEW reach of CODE 0.9 | PRO_SECOND_TERMS; ProLadder.book (PROTERMS1); talks = StarDeal |
| Licence $230 + medicals $875 + trainer $140 = $1,245 | CODE | ProDebut.LICENCE, MEDICALS, CORNER_LICENCE |
| Stipend from signing to the debut ($1,170 in the case: 33 days) | NEW | turn_pro keeps weekly_salary until the debut night (PROHOLD1) |
| turn_pro clears day_job | NEW (F14) | PROHOLD1 |
| Debut on the Saturday 4 weeks on; 8 weeks as an option | CODE / NEW | debut_day, PRO_DEBUT_WEEKS; turn_pro(c, weeks) |
| Opponent Paige Whitlow (posmod(371, 4) = 3), rating = fight_power - 1.0 | CODE | PRO_OPP_NAMES, PRO_OPP_GAP |
| Debut 66 / 70 in 100 (4 / 8 weeks, Steady), 63 / 67 when Flat | ESTIMATE (CODE path) | the screen reads BoutRead.likely; trust enters the read at BoutRead 227 |
| Scale 59.8 / 59.4 kg of 60 | ESTIMATE (case) | the game's scale forecast (CampForecast) |
| 82 tickets, the gym $138 | CODE (computed) | 20 + 48 + 14; 22 x $50 x 0.5 x 0.25 |
| Bout 2 is 8 weeks after the debut; then 8 weeks a night (6 if the tune-up is 6+ points under) | CODE / ESTIMATE (the gap) | ProLadder.join, LEAD_DAYS; Matchmaking.next_weeks, SOFT_GAP |
| Tune-up 82 in 100; step up 50 | CODE (targets) | TUNE_AIM, STEP_READ |
| Tune-up night at gap -4: purse $1,500 + tickets 150 x 5 x 0.733 = $550; the gym $512, the bill $123, net $389; +$21 a fan | CODE (computed on the gap ESTIMATE) | pay_of, GYM_SHARE, camp bill 6% |
| Seated at No. 20: purse $1,900, net about $465 | CODE (computed) | PURSE_PER_PLACE |
| Step up to No. 16 unranked: $2,250 + $750, net $570 | CODE (computed) | OPP_DRAW_PER_PLACE |
| A duck costs a fan; at 2 ducks the step up stops | CODE | ProLadder.book 316, DUCKS_BLOCK, _make_offers 177, stakes 432 |
| Seat at 5 pro wins on a winning record | CODE | REVIEW_WINS, _review_streak |
| Seat at No. 20 from the debut for a held champion | NEW | PROHOLD1, ProLadder.join |
| Holding money $150 a week toward the stipend, until the run ends; about $1,990 (13.3 weeks expected) | NEW (design value) / ESTIMATE | PROHOLD1; c.pay weekly while f.pro_hold |
| Club cut $450 win or lose; none at the championships | CODE | TICKET_CUT, BoutNight 393-396 |
| Club show dates 13 Feb, 13 Mar, 24 Apr, 22 May, 3 Jul (4 and 6 weeks apart) | CODE (computed) | 14-day show grid, AFTER_FIGHT 10, booking 2-4 weeks |
| Entries Mon 18 Jan - Mon 15 Mar; semi 29 Mar, final 5 Apr; nationals 26 Apr - 4 May | CODE | SeasonPath, Champs.stage_day |
| Club bout 65, semi 65, final 55, a national round 50 | ESTIMATE | the screen reads BoutRead and Champs ratings |
| Regional champion 36 in 100 (day job 31) | ESTIMATE | 0.65 x 0.55 (0.62 x 0.50) |
| Win +8 members, +5 reputation; loss -1, -2 | CODE | BoutRules |
| A win's dues: about $89 from the surge + $24.2 a week from the 3 that stay; only with room under member_cap | CODE (computed) | Membership.step_members, member_target 132, $35 / 4.33 |
| Gym cap 140 (Bigger unit) | CODE value, case choice | GymUpgrades 28 |
| Stipend $250 a week | CODE | GameMoney.FIGHTER_STIPEND |
| Day job: 3 mornings, none Hard, camps at most Standard (replaces x0.85) | NEW | DAYJOB2 |
| Day job costs: club bouts 65 to 62 by July, final 55 to 50 | ESTIMATE | DAYJOB2's bot measures it (4 to 7 in 100 by July is its bar) |
| Morale: booked +5 (amateur only), win +8, loss -12, scales by heart / confidence / coachability | CODE | MORALE_EVENTS, Bouts 198, apply_morale |
| call_heard +10, call_overruled -16 (coachability scaling extended) | NEW (design values) | FighterProfile (PROWISH1) |
| Jade 64 to 49 overruled, 74 heard, 79 after a booking; a debut loss from Flat 49 lands Flat 38 | CODE (computed on NEW values) | apply_morale |
| Trust 1.05 / 1.0 / 0.85 / 0.7 by band | CODE | TRUST |
| Fired up: about +1 in 100; Flat: about -3 | ESTIMATE | BoutRead with trust |
| All money totals (-$700 / +$2,830; -$1,380 / -$300; -$3,530 / +$320; -$3,230 / +$160; title / miss splits; day-job figures; -$1,170 for 8 weeks) | ESTIMATE (CODE pieces x chances, every branch) | forecast_r3.py, case A and A2 |
| Seat by January 61 / 36 / 16 in 100; pro by July 100 / 36 / 95; called again after a hold miss 37 in 100 | ESTIMATE | forecast_r3.py |
| A No. 1 rank after a miss = 4 straight club wins | ESTIMATE (stand-in for the regional table) | forecast_r3.py; PROFORECAST1 reads RankLine |
| Pad-night clash weeks 3 / 3 / 3 / 0 | ESTIMATE (case dates; computable from booked camps) | LEAD_DAYS 42, camp dates |
| Horizons 26 and 52 weeks | design | the bot's measure is 52 |

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Pro offer (modal; the drawn screen) | Header: boxer, record, rank, entries window; the wish with the mood band; cash after signing and the weekly line after the debut; the gym's room (members of cap). Strip: stipend / day job with the day job's mornings and chances. Three columns: TURN PRO with the Debut pick (date, chance, scale, the stipend price), the opponent and injury; HOLD with the holding money and the deal in one sentence; NOT YET with the This season pick. Six rows: Bouts (dots; dashed = moves), The club's money (to 12 Jul and to 10 Jan, title/miss bar, day-job figures), The pro road (where she stands by January; both nightly offers; DUCKS), If it goes wrong (chance and cost; third-no warning), Jade's mood (band at the next bout, in-ring effect), Coach's pad nights (clash weeks). One best tag per row. Three buttons with their consequences; Turn pro is disabled with its reason when the cash is below $1,245 | NEW `scripts/rules/SeasonCompare.gd` (rows and tags from plain inputs); NEW `scripts/state/ProForecast.gd` (inputs from the Career: BoutRead.likely with the band after the answer, the promoter's real tune-up preview and its gap -> next_weeks, Champs field ratings, the show grid, the scale forecast, camp dates of the other fighters, member_cap); NEW `scripts/rules/ProWish.gd`; `scripts/state/ProCall.gd` turn_pro(c, weeks) / hold_pro / decline_pro(c, enter); GymSpend.set_stipend |
| Top bar flag PRO OFFER | opens the modal (exists) | Needs.gd 128 |
| Home notice board | Red: "A promoter wants to sign Jade: Hear it" (subline: promoter, wish). Amber while held or "not yet, enter" and not entered: "Enter Jade for the nationals by Mon 15 Mar (Bow Lane is holding)", button Nationals | Needs.gd 58; NEW lines from f.pro_hold / f.enter_pending + Champs.entries_open |
| Fighters > Roster cards and table "The Road" | flag "Pro offer" (exists); while held "Held: nationals, +$150 a week"; after a no "Pro call at 9 wins, top 3"; after a held miss "Pro call: No. 1 and 2 more wins (last chance)" | RosterFlag; NextStep.road; f.pro_hold, f.pro_back_wins, pro_declines |
| Fighter page > Overview NEXT STEP | the same lines in full, with the promoter and the terms | NextStep.road + the new fields |
| Fighter page > Week (week board) | on a day job: four mornings read "Work" (greyed, hover: "day job: Club > Money or the pro offer's strip"); Hard is not offered | NEW DAYJOB2 in TrainingPlan.plan_of / WeekBoard |
| Fight prep > Set camp | on a day job: Hard is greyed, reason "day job: camps at most Standard" | NEW DAYJOB2 in Bouts.start_camp |
| World > Championships | under a held boxer: "A title brings Bow Lane back at full terms with a seat at No. 20; no title: two noes" | Champs page; f.pro_hold |
| Fights > amateur versus screen ("what a win and a loss change") | one pro line within 2 wins of a call | BoutCompare; Roster.pro_ready on the record after the bout |
| Fights > pro offers (after signing) | each night's tune-up and step up with chance and the club's pay; the duck line (exists in `stakes`); "10% less until the first contract talks" for a second-promoter pro; the seat from the debut for a held champion | ProFights; ProLadder.stakes; f.terms (PROTERMS1) |
| Club > Money | STIPENDS switch (the strip's setting, now with the mornings price in its hover); income line "Bow Lane holding money +$150 a week" while held; PAID OUT shows the licences (exists); CONTRACT TALKS end the 10% | GymSpend.set_stipend; c.pay; StarDeal.due -> f.terms = 1.0 |
| Fighter page > Week, "Coach's pad nights" row (AGREED, NOT BUILT) | two in camp: who shares the 3 nights | the agreed pad-sharing build; this map adds no rule to it |
| Week review (Monday) | "Jade: heard / overruled on the pro call (band)"; when a hold ends: "Regional champion: Bow Lane is back at full terms with a seat" or "Out in the semi: two noes, only No. 1 and 2 more wins bring a call; a third no ends it" | WeekReview rows; Champs._finish -> NEW ProCall.resolve_hold |

## 8. Build tasks (each under 500 lines, one owner, its test red first; in this order: the screen lands LAST, so it never prints a price the code does not charge)
| Id | Owner | What | Owned files (lines now) | Test, red first |
|---|---|---|---|---|
| PROCALL0 | Claude | Move the turning-pro block (pro_ready, check_pro, debut_sheet, debut_night, debut_words, turn_pro, debut_day, decline_pro) out of Roster.gd into NEW `scripts/state/ProCall.gd`; Roster keeps thin wrappers. No behaviour change | Roster.gd (286), NEW ProCall.gd (~140) | the existing pro debut tests stay green; parse gate |
| PROTERMS1 | Claude | f.terms set at signing; ProLadder.book multiplies bout.purse by f.terms until StarDeal talks (then 1.0); the dead purse/purse_step/purse_top and BoutNight's raise removed; old saves default 1.0 | ProLadder.gd (446: +6), BoutNight.gd (479: -2), ProCall.gd | tests/pro_terms_test.gd: a second-promoter pro's first ladder bout.purse is 90% of a first-promoter pro's on the same opponent (red today: equal) |
| PROHOLD1 | Claude | ProCall.hold_pro (f.pro_hold; $150 a week via c.pay while held and the stipend is paid); resolve_hold from Champs._finish (title: the offer back at 1.0 with seat = true; miss: pro_declines 2 + back_wins); f.pro_back_wins set on every no; decline_pro(c, enter) sets f.enter_pending; turn_pro(c, weeks) 4 / 8; the stipend runs until the debut night; turn_pro clears day_job (F14); ProLadder.join seats a held champion at the bottom place | ProCall.gd, Champs.gd (303: +1 call), ProLadder.gd (join: +6), GymSpend.gd (day_events: +3) | tests/pro_hold_test.gd: hold, then a regional title: the offer returns at 1.0 and the debut joins ranked; the holding money is paid each week of the hold and stops at the run's end; a semi loss leaves 2 noes and needs No. 1 + 2 wins; a third no closes it; a 9-1 boxer who says no is NOT called the next week; turn_pro(c, 8) books 8 weeks on and pays the stipend until then; turn_pro clears day_job. Red before the functions exist |
| DAYJOB2 | Cursor | Day job = at most 3 training mornings (the rest "Work"), no Hard morning, camps at most Standard; GymSpend.gain drops the x0.85 | TrainingPlan.gd (169: +15), WeekBoard.gd (471: +10), Bouts.gd start_camp (+4), GymSpend.gd (gain: -1) | tests/day_job_week_test.gd: a day-job week has 3 training mornings and none Hard; start_camp(protocol Hard) on a day job returns Standard; a 26-week bot pair (stipend vs day job, same boxer) differs by 4 to 7 in 100 on BoutRead against the same opponent. Red today (x0.85 gives about 1) |
| PROWISH1 | Qwen (cloud: pure) | NEW `scripts/rules/ProWish.gd`: wish(traits, day_job, entries_open, eligible); the event per answer; the band at her next bout (pro: no booking; amateur: +5); call_heard / call_overruled in MORALE_EVENTS; coachability scaling for call_overruled | NEW ProWish.gd (~90), FighterProfile.gd (170: +3), NEW tests/pro_wish_test.gd (~100) | Jade: overruled 49 Flat at the debut; heard 74 -> 79 Fired up after an amateur booking; day job: the wish is pro; no wish: "no change" |
| SEASONCMP1 | Qwen (cloud: pure) | NEW `scripts/rules/SeasonCompare.gd`: the three columns from plain inputs (dated bouts with chances, pay per bout, holding money, the stipend to the debut, terms, members drift and cap), chance-weighted money at two dates with every branch, the title/miss split, one best tag per row on a shared measure | NEW SeasonCompare.gd (~260), NEW tests/season_compare_test.gd (~180) | asserts section 5's case-A figures within $100 (the model file's numbers, ported as the fixture) and that each tag goes to the column with the best value on its row; fails before the module exists |
| PROFORECAST1 | Claude | NEW `scripts/state/ProForecast.gd`: the inputs from the Career. It previews the promoter's real tune-up and step up for a boxer not yet on the table (generates the division with join's seed if empty; a temporary row, nothing appended) and reads its gap through next_weeks. It gives BoutRead chances at the band after each answer, Champs field, the show grid, the scale forecast, the other fighters' camp dates and member_cap | NEW ProForecast.gd (~200), NEW tests/pro_forecast_test.gd (~120) | a bot signs and takes the promoter's tune-up each time for 26 weeks; its real fight dates equal the forecast's (red before the module) |
| PROOFFER2 | Cursor | The drawn screen: ProOffer.gd rewrite + NEW ProAnswerCol.gd + NEW SeasonDots.gd, each under 250 | ProOffer.gd (99) | tests/pro_offer_ui_test.gd: three columns and buttons; the money labels equal SeasonCompare's; HOLD and NOT YET's pick are absent after 15 Mar or for a boxer who cannot enter; the debut pick shows the scale; Turn pro is disabled under the bill. Claude checks the still |
| PROROAD2 | Cursor | The other menus' lines (section 7): Needs, NextStep, RosterFlag / The Road, Championships, the versus row, WeekReview, ProFights 10% note, Money holding line | Needs.gd, NextStep.gd, RosterFlag.gd, BoutCompare.gd, WeekReview rows, ProFights.gd, MoneyPanels.gd | tests/pro_road_lines_test.gd: a held boxer's NEXT STEP, Home need, Championships and Money lines; a 6-2 No. 3's versus row says "Win: the promoter calls"; red today |
| TURNPROGOLD1 | Grok Dev | Golden path: 6-2 boxer, win, the offer, the strip to day job and back, HOLD, enter, the holding money paid, a regional title, the call back at full terms, sign (4 weeks), the stipend to the debut, the debut paid, the seat, the first ladder purse at full terms | NEW tests/golden_turnpro_test.gd | red until all above land |
| TURNPROBOT1 | Arena | 1,000 careers at the call across stipend / day job x wish (pro, nationals, none) x entries open / closed x rank 1 / 2 / 3 x weight over / on, with the arms TURN PRO 4 / 8, HOLD, NOT YET + enter, NOT YET club shows only, measured at week 52 (club money + titles + the ladder place) | NEW tests/turnpro_bots_test.gd | red if one answer is best on its measure in more than 2 of 3 situations, or if HOLD is never best outside the mood row |
Every new feature ships on (GAME_ON). PROCALL0 lands first. PROTERMS1, PROHOLD1, DAYJOB2 and PROWISH1 land before PROOFFER2.

## 9. Rejected, and why
- The Tune-ups / Step up pick (round 2): it bound nothing. It is one line in the pro road row plus the DUCKS warning.
- Holding money paid while the boxer is on a day job: it would go to the boxer, not the club, so the club's figure would be 0. With the day job HOLD is a pure title bet. A day-job retainer that cuts her work days was considered and cut: it would be a second rule for the same setting.
- Making the pro debut a "booked" +5 event: it would erase the overruled boxer's Flat debut, the one in-ring price TURN PRO's mood row has. It stays as the code is, and the map names it.
- "Heard" as a lasting loyalty effect: loyalty (a kept promise builds it, a broken one may make a fighter leave) is AGREED, NOT BUILT. The row prints only the band at her next bout.
- A counter-offer row (ask for the licences paid, or the 8-week debut): every refusal would need a price, or it is a free roll. Later, with the promoters of the small living world.
- Age against the pro best years: the club's boxers do not age in code (`night(f)` overwrites the entry), so the row would show a cost the game never charges. It returns when the small living world ages them.
- Round 1's fight strength row: `pro_rating_bonus` is read only by the table. CUT (unchanged).
- An answer-by date: the offer is a red need and the clock cannot run, so waiting gains nothing.
- Hard-disabling Turn pro under 8 weeks of runway: closing is the player's risk. Disabled only when the cash is below the bill.
- The PRO ROAD chip on amateur offer cards: it informs but never decides. One line in the versus row instead.
- +10 debut tickets as a title prize (about $63): too small to feel. It stays in the money cell, not as a headline.
- The licence body, the manager / trainer split: nothing to act on. Hover only.
- A third horizon (two years): the pro column would depend on picks not yet made. 52 weeks is the bot's measure.

## 10. Risks
- The forecast is a model of the rules. PROFORECAST1 reads the real offers, gaps and fields; SEASONCMP1's fixture pins the arithmetic. If the real tune-up gap is 6 or more points, the pro nights come 6 weeks apart and TURN PRO gains about one bout by July. The screen redraws from ProForecast, so it stays true. Only section 5's figures move.
- The holding money ($150) makes HOLD the money best on a day job in case A2. That is intended (a day-job boxer costs the club nothing to keep). TURNPROBOT1 fails the design if it makes HOLD best in more than 2 of 3 situations; the lever is the amount, never a hidden bonus.
- The "No. 1 after a miss" stand-in (4 straight wins) is crude. PROFORECAST1 must read the regional table; until then the 37 in 100 is ESTIMATE and hovered as such.
- DAYJOB2 changes every day-job boxer's week, not only the pro decision. Its bar (4 to 7 in 100 by July) is measured by its own bot, and the Week board explains the greyed mornings. Old saves keep the setting.
- Two noes for a No. 2 who loses the regional final is harsh. It is printed on the button, in "If it goes wrong", and the third-no line warns before the next answer.
- PROTERMS1 changes what existing pros earn in old saves: terms default to 1.0 when missing.
- The modal carries six rows and two picks. Each row has one tag and one figure per column; the sums live in hovers.
- The pad-night row shows clash weeks before the cost exists. It is labelled as weeks only, and gains its cost when the AGREED pad-sharing build lands.
