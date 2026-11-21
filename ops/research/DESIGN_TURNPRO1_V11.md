# Turning pro - design map v11 (written from the code at main 7e26cfbd9)

S534, TURNPRO11 side console. Scope: the pro offer, from the call to the debut's money and what the debut leaves behind. The pro ladder after it is a handoff, except the first six pro fights, which the choice of house touches.
Method (owner S530/S531: maps come from the code): section 1 is written ONLY from files opened in this session at main `7e26cfbd9e926ce878191e2519be428783c30a8a`. **CODE** = file, function, lines, true at that commit. **ESTIMATE** = a proposal, a sum worked on paper from the code's formulas, or a measured result that is not code. **CUT** = do not build or show it. **CHECK** = not confirmed. Godot was not run. No game file was changed.
Inputs: map v10; its two critics (John 6/7/7, Kalli 6/7/6: DEPTH one short on both); `docs/TURNPRO6_RESULT.md`, `docs/DEBUTPICK1_RESULT.md`, `docs/TURNPROBE1..3B_RESULT.md`. This map follows v10 as corrected by those two critics.

Words: the **ticket house** = Bow Lane (paid from the seats; v10's "bigger gate"). The **guarantee house** = Harrow & Finch (paid in full; v10's "safer start"). Both words are already in the game's text (`ProCall._price_entry` :258, `_costs_entry` :281), which answers Kalli's point that "safer start" was coined. **Seats** = debut tickets the boxer sells. **Gap** = rating points the debutant sits under the boxer.

## 0. What v11 changes, in eight lines
1. Every lasting effect of the debut is priced by house, not only money: members, reputation, morale, loyalty, the chin (section 3).
2. A loss in the ticket house's test is forgiven (half the morale and reputation cost, no member leaves). The chin is never forgiven.
3. The ticket house's win crowd follows the seats on the night; the guarantee house's stays 8.
4. The boxer's pay now does something: it moves loyalty.
5. The costs ask is gated to a real cash crunch and has a floor; it stops deciding the fork.
6. The ticket ask costs $270 and stops paying at 66 seats, inside the band.
7. The card's win chance counts the camp weeks, so Later +2 shows its gain. Each house brings its own kind of debutant.
8. The probe measures the brief's question (a second pro fight with money in the club, the boxer still here), through 40 weeks, on today's rules as the control.

## 1. What the game does today (CODE only)

### The call
- **CODE - `scripts/state/Roster.gd` `check_pro` :200-214:** one offer at a time. With one open, the function only runs the lapse check (:201-205). Otherwise the first boxer in roster order who is `pro_ready`, has waited out a lapse, has no bout booked and is not in a championship run gets the call. It is called from `Sim.gd` :415, `Bouts.gd` :457, `BoutFinish.gd` :219 (and the test jump, `TestJump.gd` :167, :195).
- **CODE - `Roster.pro_ready` :186-196:** a pro, or a boxer with 3 declines, gets none. A national finalist with 0 declines is ready at any record. 0 declines: 7 wins and rank 1-3, or 9 wins. 1 decline: 9 wins and rank 1-3, or 11 wins. 2 declines: rank 1 only.
- **CODE - `scripts/state/ProOfferWire.gd` `make` :25-41; `scripts/rules/ProCall.gd` `calls_open` :331-332, `AGE_STOP` :14:** no first call at 32 or older (a boxer who has declined is not age-checked).
- **CODE - `scripts/rules/ProDebut.gd` `tickets_sold` :27-32; `ProOfferWire.forecast` :20-21; `scripts/state/HomeBout.gd` :13, :69:** seats = 20 + half the members + 2 a win + 10 a title + followers (10 for topping our own club show), capped at 100.
- **CODE - `ProCall.who_calls` :63-69:** 75 seats or more: the ticket house alone. 45 or fewer: the guarantee house alone. 46 to 74: both.
- **CODE - `ProOfferWire.make` :31-33, `on_decline` :181-183:** after a Stay one house calls alone: `offers[0]`, which is the ticket house whenever both called (list order, not a rule).
- **CODE - `ProCall.terms` :73-95:** each decline multiplies purse, step and top by 0.9, unless a title came since.

### The two houses
- **CODE - `ProCall.promoters` :35-59:** ticket house: $1,500 purse, break-even 60, 50% of tickets past it, debut 4 weeks out. Guarantee house: $1,800 guaranteed, break-even 70, 30% past it, debut 6 weeks out.
- **CODE - `ProCall.debut_purse` :99-108, `money` :112-139:** the ticket house loses $25 a seat under 60 (floor $500); past 60 it adds half of each $50 ticket. So its total is $25 a seat across the whole band. The guarantee house pays in full at any count.
- **CODE - `scripts/rules/DebutPick.gd` `AIM` :15, `NOISE` :17, `target` :34-36, `pick` :48-67, `apply` :71-78; called from `ProOfferWire.make` :38:** each house searches the gap (6 over to 14 under, steps of 0.1) until the card's own read sits on its aim for THIS boxer: 60 in 100 for the ticket house, 75 for the guarantee house, each moved up to 4 points by a misjudgement fixed by boxer, house and day. The offer keeps `opp_gap`, `opp_target`, `opp_picked`, `opp_day`.
- **CODE - `scripts/rules/DebutRead.gd` `card` :17-24, header :5-6:** the shown chance reads the debutant the bout will have through `BoutRead.round_edges` on a 4-round card, the boxer as today, on the usual camp (`{"protocol": BoutRead.USUAL_CAMP}`, :22). The function never reads `debut_weeks`; its own header says the weeks to come "are not counted, so the read errs low by a point or two".
- **CODE - `scripts/rules/DebutOpp.gd` consts :15-17, `name_for` :22-24, `rating` :32-33, `make` :37-41:** every debutant is a 0-0 "Boxer-puncher" with "Heavy right hand" and "Fades after round 3", rated the boxer's no-camp strength less the gap. Only the name and the gap differ by house.
- **CODE - `scripts/rules/BoutRead.gd` `_read_copy` :272, `_games` :277-280, `_tiring` :301, `_round_edges` :328, :337:** the read does use the opponent's style (the mix of games, and the plan the coach writes against that style) and three scouting words ("walks in", "Fades", a body threat). So a different style per house would change the bout, with no new system.
- **CODE - `Roster.turn_pro` :305-309, `debut_day` :319-320:** signing books that debutant for the Saturday `debut_weeks` out, 4 rounds; the rating is taken from the boxer's stats on the signing day.
- **CODE - `scripts/state/ProLean.gd` `LEAN_FIGHTS` :7, `LEAN_KIND` :8, `extra` :12-33; `scripts/state/ProLadder.gd` :23-25, :204-214:** for the first 6 pro fights the house ADDS one row to each set of offers: a second tune-up (nearest a read of 0.82, inside 0.70-0.93) for the guarantee house, a second step up (nearest 0.50) for the ticket house. The plain set (one tune-up, one step up, one payday) is still there, so the lean widens the choice; it never forces a fight.

### Signing
- **CODE - `ProDebut.start_costs` :18-24, `Roster.turn_pro` :275-282:** the gym pays at signing: $230 licence, $875 medicals if never licensed, $140 if the coach has no pro licence ($1,245 at most), unless the costs ask was taken.
- **CODE - `Roster.signing_share` :223-224, `turn_pro` :288-291; `scripts/rules/Loyalty.gd` `pro_share` :230-233, `MOVES` :61:** the gym keeps 25% of the boxer's money; under 50 loyalty an outside manager signs the boxer and the gym keeps 10%. Signing then adds 5 loyalty, after the share was read.
- **CODE - `ProCall.morale` :298-308, `ambition_kind` :312-318; `scripts/rules/Recruit.gd` `ambition` :122-126; `ProOfferWire.morale_line` :162-170:** a boxer's goal reads "A regional title within a year" (potential 78 or more) or "A winning record by the summer". Only the title goal moves morale: signing costs 5 while the boxer could still enter the nationals (`Champs.check`, `scripts/state/Champs.gd` :40-41). No goal contains "pro", so the +5 / -5 branch (:300-301) never runs.
- **CODE - `Roster.turn_pro` :301-303, :307; `scripts/state/Bouts.gd` `accept` :192-200:** the stipend ends and open amateur offers are closed. `turn_pro` writes the debut over `f["bout"]` without checking it is empty, and `accept` (lines opened) does not look at the open pro offer.

### The asks (one a house)
- **CODE - `ProCall.ask_answers` :156-194; `ProOfferWire.ask` :76-90, `back_to_plain` :94-98; `scripts/ui/modals/ProOffer.gd` `_ask` :174-195:** six buttons a house, each tagged "will take it", "counters" or "won't" (a won't button is disabled and not spent).

| Ask | Ticket house | Guarantee house | What the code does (CODE) |
|---|---|---|---|
| Later +2 / +4 weeks | takes | takes | `_apply_later` :197-201: $150 / $300 off the purse, 2 / 4 more weeks. The card's win chance cannot move (the read ignores weeks) |
| Softer opponent | takes | takes | `_apply_softer` :204-208: gap +0.5, free, and the next 2 sets of pro offers are tune-ups only (`ProLean.extra` :14-17; `ProLadder.book` :341-342 spends a set on any booking) |
| Better split | won't under 65 seats, counters +5 share points at 65-79, takes +10 (gap -0.5) at 80+ | won't under 75 (it calls at 74 or less) | `_split_entry` :211-239 |
| Own ticket price | takes: $40 tickets, 15 more seats, free | won't | `_price_entry` :242-260; `ProOfferWire.money` :125 |
| Costs from the purse | won't | counters: the promoter pays the signing costs and takes them plus $100 ($200 under 8 weeks of runway) off the purse before the split | `_costs_entry` :263-283; `ProOfferWire.money` :122-124, `night` :135-136; `scripts/rules/GymBills.gd` `runway_weeks` :62-67. `maxi(0, ...)` is the only floor: the boxer's pay can reach $0 |

### The offer screen
- **CODE - `ProOffer.build` :35-45:** header "A CALL FROM (house names)", "TURN (first name) PRO?", then one line: record and rank, days the offer stands, the age line, declines left.
- **CODE - `ProOffer._tickets` :90-106, `ticket_parts` :211-225:** one ticket bar, who buys, one break-even mark at 60 (`bar.break_even = ProDebut.BREAK_EVEN` :97; the guarantee house's 70 is not drawn).
- **CODE - `ProOffer._house` :110-170:** per house: badge and name, and "VS (debutant's name)" in the card head (:139-143, now committed); Debut purse; Ticket share and seats today; "Debut, N weeks out: Picked as a winnable first night / Picked to test your boxer" with a hover (`DebutPick.line` :88-91, `tip` :96-100); "Win chance: about N%, a draw N%" (:154); "After the debut: +$ a win, up to $" (:155); "The gym at signing", "The gym each week after" (the stipend minus an assumed $75, `ProCall.LOST_CUT_A_WEEK` :13), "The boxer from the debut" (:161-163); the pays-back sentence (:165); the asks; "Turn pro with (house name)" (:167).
- **CODE - `ProOffer.build` :56-69:** what the gym pays at signing, itemised; WHAT ENDS; the 10% line under 50 loyalty.
- **CODE - `ProOffer.build` :72-81:** the MORALE line when morale moves; "Stay amateur", whose tooltip always says "the same house calls again after 2 more wins, on 0.9x terms" (:80). After one Stay the real gate is 9 wins and top 3, or 11 wins; after two, rank 1 (`pro_ready`).

### Holding, staying, lapsing
- **CODE - `scripts/state/Needs.gd` `needs` :67-70, `blockers` :140-141, `flags` :167-168; `scripts/ui/Main.gd` `on_go` :195-199; `scripts/state/Clock.gd` `stop_now` :79-83:** the open offer is a red need and a red top-bar flag. Red needs are blockers: Continue opens the offer and the clock stops.
- **CODE - `ProOfferWire.lapse_if_due` :187-197, `ProCall.expires` :336-337:** the 14-day lapse runs only inside `check_pro`, which needs a week to end or a bout to finish. With time blocked, the lapse and the "14 more days" on the card cannot be reached by playing.
- **CODE - `Roster.decline_pro` :324-334; `Loyalty.MOVES` :61:** Stay adds a decline, saves the returning house, applies morale by the goal (0 for every goal that exists) and costs 8 loyalty.
- **CODE - `scripts/state/LoyaltyWire.gd` `idle_week` :44-53, `IDLE_WEEKS` :19:** a fit amateur with nothing booked loses 3 loyalty every 4 Mondays; it does not pause for an open offer.
- **CODE - `scripts/rules/FighterProfile.gd` :25:** "month_no_fight: -6" is a table entry; this session did not find a caller (v10 searched `scripts/` and found none).

### The night and what it leaves (the part v10 priced only in members)
- **CODE - `scripts/state/BoutFinish.gd` :92, :111-116; `Roster.debut_night` :247-251; `ProOfferWire.night` :133-142:** the debut pays on the seats counted ON THE NIGHT. The ledger label prints 25% even when the cut was 10% (:114-115).
- **CODE - `BoutFinish.gd` :94-106; `scripts/rules/BoutRules.gd` :114-123:** a win brings 8 members and 5 reputation. A loss costs 1 member and 2 reputation; a stopped loss 2 and 4. The same for both houses.
- **CODE - `BoutFinish.gd` :176; `FighterProfile.MORALE_EVENTS` :18-20, `apply_morale` :147-170:** morale +8 on a win (x0.9 to 1.1 by confidence), -12 on a loss (x1.3 to 0.7 by heart).
- **CODE - `BoutFinish.gd` :177-178; `Loyalty.MOVES` :60:** loyalty +2 on a win, -1 on a loss, -3 when stopped.
- **CODE - `BoutFinish.gd` :101-102; `scripts/rules/Attrs.gd` `wear_stoppage` :127-129, `STOP_DROP` :42:** a stoppage loss (not a corner retirement) lowers the boxer's durability ceiling by 2 for good.
- **CODE - `scripts/rules/Membership.gd` :15-16, :19, :29, `step_members` :45-53:** the gym can carry 48 members + 0.6 a reputation point (before the dues band); the count walks a quarter of the gap a week, 6 at most. So reputation is members later, and seats can grow between signing and the night.
- **CODE - `ProLadder.result` :371-377:** the debut has no ladder opponent, so the function joins the boxer to the table and returns; the debut's result is not applied to a rank there.
- **CODE - `BoutFinish.gd` :117-122; `scripts/rules/Matchmaking.gd` `PURSE_UNRANKED` :49, `pay_of` :215-217:** later pro fights pay from the ladder ($1,500 unranked). `f["purse"]` steps up after a win (:122) but the booked purse comes from `pay_of` (`ProLadder.book` :354, :360). The contract's step and top, shown on the card (:155) and promised in the week review (`scripts/ui/ProWeekLines.gd` `next_line` :46-50), are never paid.
- **CODE - `ProWeekLines.lines_for` :15-42:** for 28 days after signing the review shows "amateur cut lost / stipend saved" with the assumed $75 a week; in the debut's week a ledger line (share, costs, net).
- **CODE - `scripts/state/GymDeals.gd` `pro_camp` :22-35:** the debut has no camp bill; a cutman on staff is still charged.

### Today's fork, worked from the code (ESTIMATE: sums from the lines above; shares from DEBUTPICK1's 6,600 played bouts)
Played shares, win / draw / loss in 100: ticket house 58.7 / 19.9 / 21.4; guarantee house 78.5 / 14.1 / 7.4 (means of the 11 rows a house in `docs/DEBUTPICK1_RESULT.md`). Both critics worked their sums with loss = 100 less the win; a debut is drawn 1 time in 5 to 7, so their losses are too high. The direction of their point stands.

| Expected from one debut, today | Ticket house | Guarantee house |
|---|---|---|
| Money for gym / boxer at 46, 60, 74 seats | $288/$862, $375/$1,125, $463/$1,387 | $450/$1,350 up to 70, $465/$1,395 at 74 |
| Members | +4.5 | +6.2 |
| Reputation | +2.5 | +3.8 |
| Morale (before the boxer's character) | +2.1 | +5.4 |
| Loyalty | +1.0 | +1.5 |
| Chance of a loss (each can be a stoppage: chin ceiling -2 for good) | 21 in 100 | 7 in 100 |

- **ESTIMATE - one answer.** The guarantee house wins every row at every seat count where both call. The ticket house only passes it with its free ticket ask, from 61 seats, by $5 to $55 for the gym.
- **ESTIMATE - the costs ask is the largest number on the screen** (John): plain, the gym ends the night $795 down at $1,800 and full costs; covered, $114 up. That is about $900 for nothing the gym feels, at every seat count.

## 2. Evidence (ESTIMATE: measured, not code)
- `docs/TURNPRO6_RESULT.md`: 10 boxers, 66,000 played bouts. About 4.7 points of win share a rating point. Two more camp weeks are worth about 2 points for most boxers, 7 to 15 for a newcomer still growing. A draw is 1 bout in 5 near level.
- `docs/DEBUTPICK1_RESULT.md`: 13,200 played bouts. Picked, the ticket house plays 58.7 in 100 (52 to 69 by boxer), the guarantee house 78.5 (72 to 85): 3.5 above its aim, because its debut is 2 weeks later and the read does not count weeks ("the clean fix is in the read"). Owner on 78: "78 is fine".
- `docs/TURNPROBE1..3B_RESULT.md`: 300 to 360 careers each, but ONE boxer (quick_start's), and of 15 day-job careers 0 or 1 ever signed. They cannot judge a fork between boxers; section 9 does not reuse their population.

## 3. The fork: every lasting effect priced by house (ESTIMATE)
The human question (the brief): which contract gets THIS boxer to a second pro fight with money in the club?

| Lever | Today (CODE) | v11 | What it moves |
|---|---|---|---|
| Guarantee purse | $1,800 | **$1,400** (v10, kept) | Money crosses at 56 seats |
| A win's crowd | 8 members, either house | **Ticket house: 5 + 1 for every 10 seats sold on the night** (9 at 46, 11 at 60, 12 at 74, 15 at most). **Guarantee house: 8** | Members follow the hall, not a flag on the house (Kalli 8). Expected members cross near 56 to 60 seats |
| A loss in the test | morale -12, reputation -2 (-4 stopped), 1 member (2 stopped), either house | **Ticket house: morale -6, reputation -1 (-2 stopped), no member leaves.** Guarantee house: as today | "A loss here is forgiven" (Kalli 1): a prospect who loses a hard first fight is judged more gently than one who loses a gimme |
| The chin | a stoppage loss takes 2 off the durability ceiling | **unchanged, both houses** | The test's risk that nothing forgives: 21 losses in 100 against 7 |
| The boxer's pay | does nothing | **+1 loyalty for every $150 of debut pay over $1,000, +4 at most**, with the +5 for signing | The boxer's 75% now reaches the gym (Kalli 2). Every ask's price is felt in full, not at a quarter (John) |
| The boxer's wish | none | **two wishes, frozen at the call** (below) | Morale and loyalty pull against money or against safety, never with them |
| Each house's debutant | one boxer-puncher | **two kinds** (below) | The boxer's style and the plan decide which night is easier to prepare |
| Aims | 60 and 75 | unchanged | Owner: 70-80 for the guarantee house, "78 is fine" |
| Weeks out | 4 and 6 | unchanged | The ticket house reaches the ladder 2 weeks sooner; the guarantee house has 2 more weeks for the seats to grow |

**The same table after v11** (shares as measured; 60 seats on the night; a stoppage not assumed):

| Expected from one debut, v11 | Ticket house | Guarantee house | Who it favours |
|---|---|---|---|
| Money, gym / boxer, at 46 seats | $288 / $862 | $350 / $1,050 | guarantee |
| at 56 | $350 / $1,050 | $350 / $1,050 | level |
| at 66 | $413 / $1,237 | $350 / $1,050 | ticket |
| at 74 | $463 / $1,387 | $365 / $1,095 | ticket |
| Members (at 46 / 60 / 74 seats) | +5.3 / +6.5 / +7.0 | +6.2 | guarantee under about 58 seats, ticket above |
| Reputation | +2.7 | +3.8 | guarantee, by about 1 (0.6 of a member the gym can carry) |
| Morale | +3.4 | +5.4 | guarantee, by 2 (was 3.3) |
| Loyalty from the boxer's pay (at 66 / 74) | +1 / +2 | 0 | ticket |
| Chin at risk | 21 losses in 100 | 7 in 100 | guarantee |
| Debut date | 4 weeks | 6 weeks | ticket |

Read plainly: **the ticket house is right when the hall is full and the boxer can take a hard night; the guarantee house is right when the gym is small, the chin is the worry or the mood is low.** Safety stays the guarantee house's edge on purpose; it is now a price (about 1 reputation, 2 morale, 14 losses in 100), not a free win on every row.

**The boxer's wish (Kalli 7, John 4).** Read once when the promoter calls, saved on the offer, never moved by an ask.
- A boxer on a day job (`f["day_job"]`) wants **the guaranteed purse**: certainty before leaving work. It pulls against money above 56 seats.
- Otherwise a boxer with the title goal (potential 78 or more) wants **the test**. It pulls against safety.
- Any other boxer has no wish. Where one house calls there is no wish.
- Signing the wished house: morale +5. The other: morale -5, loyalty -3. Said once, in the MORALE line, never on a button (owner S534).

**Each house's debutant (Kalli 6).** `DebutOpp.make` takes the house: the ticket house puts up a crowd-pleaser ("Pressure fighter", weakness "Loads up when hit"); the guarantee house a cautious "Out-boxer" (weakness "Backs onto the ropes"). Both styles and both weakness words are already in the game's tables (`scripts/rules/AttrGen.gd` :14, :16, :59-60). `DebutPick` still searches the gap to 60 or 75, so the shown chance holds; what changes is the plan the player writes for the camp and which of the boxer's moves count. CHECK before building: the threat words for each style, and a re-run of DEBUTPICK1's 22 cells on the two styles.

## 4. The asks: each with a price, none with one answer (ESTIMATE)
Only asks the house will grant are drawn; no "won't" buttons. Each button shows its price and the card's numbers after it, before it is pressed.

| House | Ask | Today (CODE) | v11 | Right when / wrong when |
|---|---|---|---|---|
| Ticket | Own ticket price | $40 tickets, +15 seats, free | **$270 off the purse before the split** (Kalli 4). In money: +$100 at 46 seats, $0 at 66, -$40 at 74. The 15 extra seats also count for the win crowd (+1 or +2 members on a win) | Right under 66 seats. Above it, it is paying $20 to $40 for a fuller hall: right only for a gym that wants members. The button says "worth it under 66 seats" on the night's forecast |
| Ticket | Softer opponent | gap +0.5, free, 2 tune-up sets | **gap +1.0 (about 5 in 100), $300 off, no tune-up rider** (v10, kept) | Right when the chin or the mood cannot afford the loss. Wrong when the boxer's pay would fall under a loyalty step |
| Both | Later +2 weeks | $150 off | unchanged. **The card now shows about +2 in 100** (section 5) and the seats forecast for the later night | Right when the boxer is injured, over the weight or new to the gym, or the seats are still climbing. Wrong when the ladder matters more |
| Guarantee | Costs from the purse | costs + $100/$200 off the purse; boxer's pay can reach $0 | **Gated and floored** (John 1), below | Right only in a real cash crunch. Wrong at loyalty 50 to 55 |
| - | Later +4, Better split, Softer on the guarantee house | free or dominated | **CUT** (v10; both critics agree) | |

**The costs ask, gated and floored.**
- Shown only when cash is under the signing costs, or runway is under 8 weeks (`GymBills.runway_weeks`). A healthy gym never sees it.
- The promoter covers the smaller of: the costs, or the purse less the fee less $500. The gym pays the rest in cash. So the boxer keeps at least $375 and the gym $125.
- Worked at $1,400, full costs $1,245, fee $100: covered $800, the gym pays $445 today, the boxer boxes for $375. The gym ends the night $320 down instead of $895 down.
- Loyalty -6, taken when the ask is pressed, before the share is read. A boxer at 50 to 55 loyalty drops under 50 and an outside manager signs the boxer (the gym keeps 10%); the button says so. That is the cell where the rescue is the wrong pick.
- It is first in the probe's tuning order.

## 5. The read, the seats, the hold (ESTIMATE)
- **The win chance counts the camp weeks (John 2, Kalli 5).** `DebutRead.card` adds 1 point a week of `debut_weeks` (TURNPRO6's measure). `DebutPick` searches on the same read, so each house still lands on its aim and the guarantee house's played mean comes back toward 75 (DEBUTPICK1 named this the clean fix). An ask is applied after the pick, so Later +2 shows about +2. What the cards will NOT show is the 2 weeks between the houses: the pick absorbs them, and each card says its date. Refused: playing the camp ahead for each boxer (a second model of the fight); a newcomer still reads low, and the hover says "a new boxer gains most from the camp".
- **Seats on the night (Kalli 3, John 10).** One number on the ticket bar, a dashed run from today's seats: today's count plus half the members the gym gains by the debut, from `Membership.step_members` run forward for the weeks out. Hover: "Paid on the seats sold on the night. Every 2 new members is 1 more seat: dues band, classes, a club show." Both cards' money and the ticket ask's "worth it under 66" read that number. During the hold and the camp, Monday's review says "seats now N (N at the call)".
- **The hold (v10 section 5, kept whole; both critics: keep).** Amber need and flag, so Continue runs; the lapse checked every day; one stop on the last day; no bout can be booked for this boxer while the offer is open (this also closes the overwrite in `turn_pro`); the idle-loyalty count pauses for this boxer.
- **Stay amateur** says the real next gate, terms x0.9 unless a title comes, loyalty -8, declines left. **The returning house follows the money (John 5):** the ticket house at 56 seats or more on the day of the Stay, the guarantee house below.
- **The money, said honestly (v10 section 6, kept):** three numbers a card (Cash today, The gym on the night, The boxer on the night, with "+N loyalty" beside the boxer's when it applies); both break-even marks; CUT the step and top promise, the assumed $75 a week and the pays-back sentence; the ledger prints the share that was paid and "sold N on the night (N at the call)", the members won and whether the wish was kept (John 10).

## 6. Kalli's "To reach 10/10", one by one (6/7/6)
| # | Her point | v11 | Number it moves |
|---|---|---|---|
| 1 | Price the whole debut result by house: a test loss costs morale -6, reputation -1 | **Take**, and no member leaves (section 3). The chin is not forgiven | Morale gap 3.3 to 2.0; reputation gap 1.3 to 1.1; role line "a loss here is forgiven" |
| 2 | Make the boxer's money count: +1 loyalty per $150 over $1,000, cap +4 | **Take** as written | Ticket house +1 at 66 seats, +2 at 74; every ask's price now costs the gym through loyalty |
| 3 | Show seats on the night, from the member drift | **Take** (section 5) | One forecast number; both cards and the ticket ask read it |
| 4 | A ticket-ask price that crosses inside the band: $270, at 66 | **Take** | "No ask" becomes best for the ticket house in money from 67 seats |
| 5 | `DebutRead.card` reads the camp weeks | **Take** the read; **refuse** showing the houses' 2 weeks as win points (the pick aims each house, so the weeks are inside the 60 and 75) | Later +2 shows about +2; the guarantee house's played mean returns toward 75 |
| 6 | Each house its own debutant | **Take**, from styles and words the game already has; CHECK the threat words and re-measure 22 cells | The plan and the boxer's style enter the choice |
| 7 | Rewrite the wish so each case pulls against one force | **Take** as written, plus John's freeze | Day job against money above 56; title goal against safety; others none |
| 8 | Win crowd from seats: 6 + 1 per 10 for the ticket house, 8 flat | **Take the rule, at 5 + 1 per 10** (6 + puts the ticket house ahead from 50 seats once a forgiven loss loses no member); the probe sizes it | Members cross near 56 to 60 seats |
| 9 | The sweep measures the brief's question and the long tail; no dollar rate for morale | **Take** (section 9): 40 weeks, outcomes only | The pass metric |
| 10 | One number on the first 6 pro fights | **Take if the probe shows the lean changes a pick**: "First 6 fights: an extra tune-up each time, about 80 in 100" / "an extra step up, about 50 in 100" (the code's aims are 0.82 and 0.50, not 75). The lean only adds a row (CODE), so if the bot's pick differs by house in under 1 set in 10 the line is CUT as not actionable | Shown or cut on a measured bound |
| 11 | Hold the new fees ($238, $150, $438) until the source is opened | **Take.** CHECK, out of the build order. John tags them sourced; no session here has opened the source. The manager's licence is CUT (it changes no choice) | `start_costs` stays $230 / $875 / $140 |
| 12a | Delete "the same on average" | **Taken**: the claim is gone; section 3 prices each row | |
| 12b | Write the bot's population and outcome measure | **Taken** (section 9) | |
| 12c | "The safer start" past the glossary | **Taken another way**: the card heads use the game's own words, THE TICKET HOUSE and THE GUARANTEE HOUSE. `Glossary.gd` has neither word today (searched): add both when built | |
| 12d | Keep the hold, the Stay hover, the returning house, the ledger fix, the age check | **Kept**; the returning-house rule is John's corrected one | |
| - | Useless: "worth it under 84"; the day-job wish as written; the gym's money line as the deciding number; the manager's licence | Fixed by 4; fixed by 7; answered by section 3 (five rows beside money); CUT | |
| - | Play: nothing invites the player to grow the seats; a test loss feels as bad as a soft one | Answered by 3 and 1 | |

## 7. John's "To reach 10/10", one by one (6/7/7)
| # | His point | v11 | Number it moves |
|---|---|---|---|
| 1 | Gate and floor the cover ask | **Take** as written (section 4): shown in a crunch only; the boxer keeps $375, the gym $125; loyalty -6 | The $900 swing leaves the fork; in a crunch it is $575 for -6 loyalty |
| 2 | The read counts the camp weeks; re-check DEBUTPICK1 | **Take** (section 5; the re-check is in section 9) | Later shows +2 |
| 3 | Balance the win crowd on expected value, losses included; a full-gym cell | **Take the aim, another way**: the crowd follows seats and a test loss loses no member; reputation stays the guarantee house's edge by about 1 (refused: +7 reputation a win, which would leave safety with no price). The full-gym cell is in the probe | Members level near 58 seats |
| 4 | Freeze the wish at the call; tie rule; fix the day-job row | **Take the freeze.** The tie rule is no longer needed: no wish compares the two cards' pay | The wish cannot be gamed by an ask |
| 5 | The returning house follows the money | **Take**: 56 seats | Stay's hover names the right house |
| 6 | "With a hard camp: about N in 100" on each card | **Refuse on the card**: both houses get the same camp, so the line cannot help choose between them. The read does take a camp (`DebutRead.card` :22), so the line belongs on the debut's camp screen: handoff | none here |
| 7 | Names: the debutant in the card head; the toast; ask about History | **Built** for the head (CODE `ProOffer._house` :139-143). **Take** the toast: "Your boxer is a pro. Debut on (date)." History's row is a header: keep | Three body lines lose names (section 8) |
| 8 | Fees: retag as sourced, $1,263 / $1,701 | **Hold** (Kalli 11): CHECK until the rulebook is opened in a session | none yet |
| 9 | Sweep cases: cover gated against ungated, loyalty 52, a full gym, a day-job boxer at 50-56 | **Take all four** (section 9) | |
| 10 | Play: "seats now N (N at the call)"; the ledger shows members won and the wish | **Take** (section 5) | |
| 11 | Return to amateurs within 6 pro bouts | **Handoff**: turning pro is one-way in code; a later map | |
| - | His check: cover can push the boxer's pay below zero | Fixed by the floor. Today's code stops at $0 (`maxi(0, ...)`), not below | |
| - | His check: ask prices are quoted on the full purse but the gym pays a quarter | Answered by the loyalty-from-pay rule: the other three quarters now cost something | |
| - | His check: Softer is 4.7 points, not 5 | Agreed: the button says "about 5 in 100" | |
| - | Missing: a link from the hold to the week | **Take as words** on Later's hover: "Use Review later to fix weight or an injury first" | |
| - | Missing: stop the stipend during the hold | **Refuse**: the stipend card already says signing ends it (`scripts/ui/MoneyPanels.gd` :360-367); a second switch for 2 weeks of $250 is one more thing to read | |
| - | His refusals agreed: no range, no pulse on Sign, aims kept, the four cuts | Kept | |

## 8. Where it appears: CODE TODAY against TO BUILD
| Menu | CODE TODAY (file, function, lines) | Wired to today | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|---|
| Top bar flag | `Needs.flags` :167-168 | red PRO OFFER, act "prooffer" | amber; days left |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83 | `Needs.blockers` :140-141 | runs while the offer is held; one stop on the last day |
| Home, needs | `Needs.needs` :67-70, `_pro_line` :199-206 (house names in the body) | act "prooffer", "Hear it" | amber; roles, not names |
| Office desk | `scripts/ui/OfficeDesk.gd` :39 | the contract icon for "prooffer" | none |
| Offer header | `ProOffer.build` :35-45 | `ProOfferWire.days_left`, `ProCall.age_line` | "Another boxer's call waits behind this one." |
| Offer ticket bar | `ProOffer._tickets` :90-106 | `ticket_parts` :211-225, one mark at 60 | both marks; seats on the night (dashed) and its hover |
| Offer house card | `ProOffer._house` :110-170 | `DebutRead.card`, `DebutPick.line/tip`, `ProOfferWire.money` | head THE TICKET HOUSE / THE GUARANTEE HOUSE and a role line ("paid on the seats; a loss here is forgiven" / "paid in full; debut 2 weeks later"); the debutant's style; win chance with weeks counted; "A win brings N members"; three money numbers and "+N loyalty"; the first-6-fights line if the probe keeps it. CUT step/top, weekly-after, pays-back |
| Offer asks | `ProOffer._ask` :174-195 | `ProOfferWire.answers/ask/back_to_plain`; acts "proask", "proplain" (`scripts/ui/RosterActs.gd` :96-104) | granted asks only (3 / 1, or 2 in a crunch), each with its price and the numbers after it |
| Offer foot | `ProOffer.build` :56-81 | `ProOfferWire.morale_line`; acts "turnpro" :90-95, "declinepro" :105-108 | the wish in the MORALE line; Stay's true hover; Review later; "Sign this offer" |
| Fighter, Next Step | `scripts/ui/areas/FighterPage.gd` :338, :344, :355-357; `scripts/rules/NextStep.gd` `road` :50, `pro_line` :73-88 | tickets against each house, age, declines left | "Offer open, N days"; roles, not names |
| Fighter, contract | `FighterPage.gd` :144 | fixed text "Club stipend, $250 a week / Until turning pro" | the pro share and house for a pro |
| Money, stipends | `scripts/ui/MoneyPanels.gd` :264, `_stipend_card` :360-367 | "signing ends it anyway" when the offer is this boxer's | none |
| World compare | `scripts/ui/WorldCompare.gd` :269 | the "offer waiting" mark | none |
| Fights (pro) | `scripts/ui/ProFights.gd` :117; `ProLean.line` :41-47 (house name in the body) | the lean's line under NEXT FIGHT | roles, not names; no tune-up rider line |
| Week review | `ProWeekLines.lines_for` :15-42, `rows` :62-75 | `f["pro_signed"]` (`Roster.turn_pro` :294-295, `BoutFinish.gd` :123-124) | "seats now N (N at the call)"; the ledger with the true share, members won, the wish; CUT the NEXT promise and the $75 line |
| History | `scripts/ui/BoutHistory.gd` :45, :68 | "TURNED PRO WITH (house), (date)" header | none |
| Debut result | `BoutFinish.gd` :94-116; `Roster.debut_words` :254-261 | members, reputation, the pay label and news line | the crowd by seats; the forgiven loss; loyalty from the pay; the true share |
| Game plan / camp for the debut | `BoutRead._read_copy` :272 (the coach's plan against the opponent's style) | one style today | reads the house's debutant; no screen change |
| Toasts | `RosterActs.gd` :95, :108 | "(first name) is a pro. Debut on (date)." | "Your boxer is a pro. Debut on (date)." |
| Test jump | `scripts/ui/TestJump.gd` :195-197 | opens the offer on the test club | keep working |
Not reopened this session and not claimed: the top bar's drawing code (`Shell.gd`), the home list's ordering (`HomeNeeds.gd`), the week review modal's call site, the roster table, the world news feed.

## 9. The probe that must pass before any board (ESTIMATE)
**TURNPRO11 probe**, a headless tool on a cloud seat, two stages. Its output names its population, seeds and rules arm in its first lines.
- **Population.** The six boxers of DEBUTPICK1 with both of their picks (11 rows), who differ in stats, style and time in the gym; never quick_start's one boxer (TURNPROBE1-3B's limit). Plus two made cases: a boxer on a day job, a boxer at 52 loyalty. The share of calls that reach a day-job boxer is reported.
- **Arms.** CONTROL = today's rules at this commit. V11 = sections 3 to 5. MUTANT = v11 with the guarantee purse back at $1,800 (the instrument must be able to read worse).
- **Stage A, the night (cheap).** Each boxer x house x ask x 300 played bouts, on the two debutant styles with the weeks in the read.
- **Stage B, 40 weeks.** Seats 48, 56, 64, 72 on the day of the call x gym (healthy; runway under 8 weeks; cash under the costs; full gym at its member cap) x wish (none, the test, the guaranteed purse) x every signable option (house x granted ask, and no ask) x 10 seeds, played from the call through the debut to week 40. Stage B uses the six boxers once each: about 19,000 careers, about 8 core-hours at TURNPROBE1's pace (300 careers of 104 weeks in 19 minutes), run in shards on a cloud seat with the Actions minutes counted first.
- **What is measured (the brief's question, no dollar rate for morale or loyalty).** PASS for a career = a second pro fight booked within 16 weeks of the debut with cash at or above the day of the call, AND the boxer still at the gym at week 40. Read out beside it at week 40: cash, members, reputation, morale, loyalty, durability ceiling, pro record. An option is "right" in a cell when its pass rate is within 5 points of the cell's best.

| Bound (never an exact count) | CONTROL must read | V11 must read |
|---|---|---|
| The guarantee house right, share of both-call cells | 85% or more, and the ticket house under 30% (dominated: if not, stop - the probe cannot see the fault) | each house right in 30% to 70% of cells, and right alone in at least 15% |
| Any one seat count from 52 to 68 | - | neither house right in more than 85% of its cells |
| Each ask | the ticket ask right wherever it shows | right in at least one cell and not right in at least one cell where it shows |
| "No ask" | never right for the ticket house | right in at least one cell a house |
| The costs ask | right in every cell | never shown in a healthy cell; in crunch cells right in under 100% (the 52-loyalty case must make it wrong) |
| The wish | - | the wished house is right more often than in the same cells with no wish, and not always |
| Played debut wins, mean by house (stage A) | - | ticket house 52 to 68 in 100; guarantee house 70 to 82; four boxers in five within 10 of their target |
| Later +2 | card shows +0 | card shows +1 to +4; played gain not below 0 |
| The house's lean | - | reported: the share of offer sets where the pick differs by house. Under 10%: the card line is CUT |
| MUTANT | - | must FAIL the first row |

- **Tuning order if V11 fails:** the costs ask's gate and floor; the ticket ask's fee ($270); the win crowd (5 + 1 per 10 seats); the forgiven loss (-6, -1); the guarantee purse ($1,400); the wish's loyalty (-3). The aims do not move.
- **State tests:** last day and reload; a double press on Sign; an amateur offer open at the call; Stay at 1 and 2 declines (the hover matches `pro_ready`); the 10% share on the ledger; an old save's offer with no wish and no `opp_picked`; the costs ask at 55 and 49 loyalty.
- **Golden path:** call, hold three days, one ask, sign, the seats line on Monday, debut, the ledger.
- **Then:** two fresh critics, 7 or more on DEPTH from both, before anything reaches the owner's board (S425).

## 10. Owner rulings kept
- The debut opponent is picked to each boxer (Q-286): `DebutPick` stays the one search; the two styles go through it.
- The guarantee house about 75 in 100, "78 is fine": the aims do not move; the weeks in the read bring the played mean back toward 75.
- Names only in headers (S448): the head keeps the house's name and the debutant's; the button, the needs line, the Next Step line, the lean line and the toast lose them.
- Only actionable information (C443): no gap, no aim, no range, no assumed weekly figure; the first-6-fights line is shown only if the probe says it changes a pick.
- Morale off the buttons, one MORALE line (S534). Amateur bouts need no camp (S428): untouched.
- Board text short. The one line for his board, after the probe and two critics at 7+: "Turning pro: full hall or hard chin - ticket house. Small gym or low mood - guarantee house. OK to build?"

## 11. Build order (ESTIMATE; nothing here is built)
1. The hold (v10): amber, daily lapse, the booking guard, the loyalty pause. Red test first: Continue with an open offer must advance the day.
2. The read counts weeks; the two debutants. Re-run DEBUTPICK1's 22 cells.
3. The fork's effects: $1,400; the crowd by seats; the forgiven loss; loyalty from the pay; the wish, frozen.
4. The asks: three and one, prices, the gated and floored costs ask, the numbers after on each button.
5. The probe (section 9). Numbers are final only after it.
6. The card and the other menus of section 8; the ledger and week-review lines.
Tests that pin today's numbers and will move: `tests/pro_call_test.gd` (:44, :79-80, :117, :146), `tests/pro_offer_wire_test.gd` (:55-58, :66, :70), `tests/debut_pick_test.gd` (:150-152), `tests/debut_read_test.gd` (the weeks in the read).

## 12. Cut list
- **CUT -** Later +4. Better split. Softer on the guarantee house. The tune-up rider. "Won't" buttons. The step and top promise. The assumed $75 a week and the pays-back sentence. "The same on average." A dollar rate for morale or loyalty. The new fees and the manager's licence until the source is opened. The hard-camp line on the offer. A stipend switch on the hold. Showing the houses' 2 weeks as win points. v9's loan, queue and versioned contract pay. A win-chance range. Raising the aims.
