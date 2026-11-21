# Turning pro - design map v13 (v12 with three changes; code lines re-read at main 0ea035621)

S536, TURNPRO13 side console. Task: `ops/research/TASK_TURNPRO13.md`. Scope: the pro offer, from the call to the debut and the first six pro fights the choice of house shapes. The pro ladder after that is a handoff.
Method (owner S530/S531: maps come from the code): **CODE** = file, function, lines. Sections 1 and 7 carry v12's citations (written at `65423f4a3`). `git diff --stat 65423f4a3 0ea035621 -- scripts/` touches two files this map cites, `rules/Matchmaking.gd` (+3 lines) and `state/ProLadder.gd`; every line number of those two was re-read and moved in this session, and `BoutRules.gd` :114-115, `BoutFinish.gd` :94-106, `DebutPick.gd` :15-17, `DebutRead.gd` :5-6, :17-24 and `ProFights.gd` :161-163 were opened for the new lines. The other citations hold at this commit (their files did not change). **ESTIMATE** = a proposal, a sum worked on paper, or a measured result that is not code. **CUT** = do not build or show it. **CHECK** = not confirmed. No game file was changed.
**PROBED (S536): PASS, 14 of 15 bars, every audit bar - `docs/TURNPROBE13_RESULT.md`** (222 rolls, 2,894 careers). The name stays: the ticket house ends 8.1 to 8.7 reputation ahead by week 40 with room (v12: 2.7 to 3.4), and the tune-up rule is what does it (2.3 with the rule off). The trade is $1,812 to $1,976 of gym cash against 28 debut wins in 100 with room; in a full gym the guarantee house is the one answer. The guarantee card shows 78.1 and plays 78.8. The one miss is the instrument's (cash error $253 against $250 in the full cell). Its limits are in the result's section 2: two options pass the audit bars more easily than three, and the bot does not read the +2 / +5 line. Next: two fresh critics (one code-checked), 8+ on DEPTH and 8+ on PLAY.
Inputs: map v12; `docs/TURNPROBE12_RESULT.md` (v12 FAIL, 10 of 15 bars; its section 2 is this map's brief); Claude's S536 decision (`ops/research/TASK_TURNPRO13.md`: drop the Softer ask, make the name last, the guarantee card at 78, every ask cut but Later +2); owner S534: mechanics need 8+ on DEPTH and 8+ on PLAY, probe first, free hand to remove, add or interconnect.

Words: the **ticket house** = Bow Lane. The **guarantee house** = Harrow & Finch. **Seats** = debut tickets the boxer sells. **Gap** = rating points the debutant sits under the boxer. **The table** = the boxer's professional division table (the pro ladder). **The name** = the gym's reputation. **A tune-up** = a pro fight the promoter offers as one (the kind chip on the row).

## 0. What v13 changes from v12, in six lines
1. **Softer is gone.** Probe 12: it was right in 0 of 4 cells, the guarantee house done worse. With probe 11's four failed asks that is every ask on the contract: none is a decision. The offer keeps one button, Later +2 weeks, a calendar tool.
2. **Turning pro is one decision: which house.** The ticket house = a hard first night in front of the hall, then step ups. The guarantee house = a safe first night, then tune-ups. v12's fork is kept whole (section 3).
3. **The name lasts.** A tune-up win makes +2 reputation, not +5; every other pro win stays +5. The table already pays a soft win one fan less; now the gym's name follows the same rule. The safe road still wins more fights, but it no longer buys the ticket house's name back one tune-up at a time.
4. **The card shows what plays.** The read runs low on a favourite (75.0 shown, 78.6 played); the card adds back a fifth of every point the read stands over 60, and the guarantee house aims that card at 78 (owner: "78 is fine"). The opponent it picks is the one it picks today.
5. **The road is visible fight by fight.** Every offered pro fight says the name a win makes (+2 or +5), so the first six fights are six small readings of the same trade, not one signature.
6. The probe is probe 12 again on the same population and pairing, with a control arm for the new lever (the tune-up rule switched off on the same rolls).

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
| Softer opponent | takes | takes | `_apply_softer` :204-208: gap +0.5, free, and the next 2 sets of pro offers are tune-ups only (`ProLean.extra` :14-17; `ProLadder.book` :342-343 spends a set on any booking) |
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
- **CODE - `ProLadder.result` :372-378:** the debut has no ladder opponent, so the function joins the boxer to the table and returns; the debut's result is not applied to a rank there.
- **CODE - `BoutFinish.gd` :117-122; `scripts/rules/Matchmaking.gd` `PURSE_UNRANKED` :50, `pay_of` :216-218:** later pro fights pay from the ladder ($1,500 unranked). `f["purse"]` steps up after a win (:122) but the booked purse comes from `pay_of` (`ProLadder.book` :355, :361). The contract's step and top, shown on the card (:155) and promised in the week review (`scripts/ui/ProWeekLines.gd` `next_line` :46-50), are never paid.
- **CODE - `ProWeekLines.lines_for` :15-42:** for 28 days after signing the review shows "amateur cut lost / stipend saved" with the assumed $75 a week; in the debut's week a ledger line (share, costs, net).
- **CODE - `scripts/state/GymDeals.gd` `pro_camp` :22-35:** the debut has no camp bill; a cutman on staff is still charged.

### The table after the debut (new in v12; lines re-read for v13)
- **CODE - `scripts/state/BoutFinish.gd` `run` :94-106, :110:** the debut's result is booked as any bout's: `pro_w` / `pro_l`, +8 members and +5 reputation on a win, -1 member and -2 reputation on a loss (-2 and -4 when stopped), then `ProLadder.result`.
- **CODE - `scripts/state/ProLadder.gd` `result` :372-378, `join` :93-107; `scripts/rules/Matchmaking.gd` `join` :68-82:** the debut has no table opponent (`opp_id == 0`, :377), so the function joins the boxer to the table and returns. The boxer arrives unranked, 0 fans, no rebuild flag, with the debut's record copied (:102-104). **A debut loss leaves no mark on the table; a debut win earns nothing there.**
- **CODE - `Matchmaking.apply_result` :230-270 (fans :242), `loss_fans` :290-291:** every LATER pro fight moves fans (+1 a win, +1 more for a step up, +1 for a stoppage, -1 for a mismatch 6 points under; a loss costs 0 to 2 by how the fight looked), sets `rebuild` on a loss (:252) and clears it on a win (:245).
- **CODE - `ProLadder._make_offers` :175-216 (:209), `Matchmaking.ask` :180-192 (:188-189):** while `rebuild` is set the promoter offers no step up and refuses an ask above the boxer's place.
- **CODE - `ProLadder._review_streak` :407-420, `REVIEW_WINS` :37:** an unranked boxer with 5 wins and a winning record is given the table's last ranked seat.
- **CODE - `Matchmaking.pay_of` :216-225, constants :50-53:** an unranked boxer's purse is $1,500; a ranked one's is $1,500 + $400 for every place above the bottom of a 20-place table; a ranked name above adds $150 a place; tickets are $150 x (fans + 5) x closeness. The gym keeps a quarter (`GYM_SHARE` :56).
- **CODE - `ProLadder.book` :337-368 (:360-361), `LEAD_DAYS` :32; `Matchmaking.next_weeks` :283-285:** a booked pro fight is six weeks out; the next night is 6 weeks after a mismatch, 8 after a level fight, 12 after a step up, 8 more after a stopped loss.
- **CODE - `scripts/state/ProLean.gd` `extra` :12-33, `LEAN_FIGHTS` :7, `LEAN_KIND` :8:** for the first 6 pro fights the house ADDS a row (a second tune-up or a second step up); the plain set stays, so today the lean never removes a fight from the table.

### The name and the room (new in v12; lines re-read for v13)
- **CODE - `scripts/rules/BoutRules.gd` `WIN_MEMBERS` :114, `WIN_REPUTATION` :115; `scripts/state/BoutFinish.gd` :96, :98:** every win pays 8 members and 5 reputation, whoever was beaten (only a short-notice win doubles the 5). The table already tells a soft win from a real one for FANS (`Matchmaking.apply_result` :242: a mismatch 6 points under, `SOFT_GAP` :43, costs the win one fan) and for growth (:236), but the gym's name does not. So a road of tune-ups buys the same name as a road of step ups, one win at a time.
- **CODE - `scripts/ui/ProFights.gd` :161-163; `ProLadder._make_offers` :175-216:** every offered pro fight already carries its kind (tune-up, step up, payday) and shows it as a chip on its row.
- **CODE - `scripts/rules/Membership.gd` `natural_members` :38-40, `BASE_MEMBERS` :15, `MEMBERS_PER_REPUTATION_POINT` :16, `step_members` :45-53, `settle_week` :90-102, `weekly_dues` :83-84:** the gym's name carries 48 members + 0.6 a reputation point; the count walks a quarter of the gap a week (6 at most) toward that, never past the gym's cap; each member pays $35 a month. One reputation point with room is about $4.85 a week.
- **CODE - `scripts/state/GymSpend.gd` `member_cap` :160-161; `scripts/rules/GymUpgrades.gd` :27-29:** the cap is the smallest of the premises' room (70 in the first unit, 140 and 250 after a move), what the coaches can carry and the places on the floor. Past it reputation brings nobody in.
- **CODE - `GymUpgrades.LOAN` :127, `GymSpend.move` :242-248:** the move to the bigger unit can be taken on a fit-out loan ($3,000 down, $750 a month for 12). The game's answer to a cash hole is here, not in a boxer's purse.
- **CODE - reputation is read elsewhere too:** `scripts/rules/ClubShow.gd` `draw` :26-27 (tickets for our own show), `scripts/rules/Grants.gd` `chance` :28-29, `scripts/rules/CardAsk.gd` `chance` :74-75. A name with no room still does those three things.

### Today's fork, as measured (ESTIMATE: `docs/TURNPROBE11_RESULT.md`, 1,498 careers, 8,400 scratch bouts; `docs/TURNPROBE12_RESULT.md`, 2,388 careers)
- On today's rules the guarantee house is best on money in 6 of 6 cells and its costs ask is the best option every time: +$909 in a healthy gym (error $0), +$1,128 in a crunch. That is one answer.
- The ticket house's gym cut on the night is $2 to $77 away from the guarantee house's; own ticket price adds $13 at most; $1,400 against $1,800 of guarantee purse is $104. One career's cash swings about $1,700 on the fights that follow.
- Members, morale and loyalty are within 2 members, a few morale points and 2 loyalty of each other by week 40, whatever is signed.
- What is real: the debut (56 wins in 100 at the ticket house, 76 at the guarantee house; 25 losses against 10), the softer opponent (+4.7 wins in 100) and the house's lean (it changes the bot's pick in 44% of offer sets at the ticket house, 20% at the guarantee house).
- Probe 12, on v12's rules: the ticket house ends $1,518 to $1,656 of gym cash ahead with room for 23 debut wins in 100, and only $619 ahead in a full gym. Softer was right in 0 of 4 cells. The ticket house's name was 8 to 9 reputation on the night and 2.7 to 3.4 by week 40. The guarantee card read 75.0 and played 78.6; the ticket card read 60.4 and played 59.9.

## 2. The human question (the brief)
A coach picks a promoter on who they will put in front of his boxer, not on a few hundred dollars: a builder who gives soft tune-ups, or a promoter who throws him in and gets him noticed. The money is the boxer's; the club's gain is the name.

## 3. The fork (ESTIMATE; the probe of section 9 sizes every number)
| | The ticket house | The guarantee house |
|---|---|---|
| The first night | aimed at 60 wins in 100 (CODE `DebutPick.AIM` :15), a crowd-pleaser ("Pressure fighter"), 4 weeks out | a cautious "Out-boxer", 6 weeks out. **The card is aimed at 78** (section 5); the opponent is the one today's aim of 75 picks (owner: "78 is fine") |
| A debut win | the usual +8 members and +5 reputation, **plus 1 reputation for every 4 seats sold on the night (20 at most)**: +14 at 56 seats, +18 at 72. **The boxer takes the table's last seat** (ranked: a $1,900 purse, and may ask five places up: CODE `Matchmaking.pay_of` :218, `BAND_UP` :35). Fans as any pro win | +8 members, +5 reputation. Unranked. Fans as any pro win |
| A debut loss | reputation -2 (-4 stopped) as today; **a rebuild fight before any step up**; fans by how it looked (an even fight lost: 1) | the same rule; the favourite who loses costs 2 fans (CODE `Matchmaking.loss_fans` :290-291) |
| The first six fights | **step ups** (read nearest 50 in 100) and the payday; no tune-up unless rebuilding. **A win: +5 reputation** | **tune-ups** (read nearest 82 in 100); a step up only after 3 pro wins; no payday. **A tune-up win: +2 reputation** (NEW in v13); a step-up win +5 |
| The money | the purse as today. Shown small, said honestly, not a lever | the same |
| Right when | the gym has room for the members a name brings, and the hall is big enough to make one | the gym is full or the hall is small (the name would be wasted), or the boxer's record or chin cannot take a 1-in-4 loss |

**The tune-up rule (NEW).** A pro win in a fight the promoter offered as a tune-up pays +2 reputation in place of `BoutRules.WIN_REPUTATION` (5, CODE :115; paid at `BoutFinish.gd` :98). The members (+8), the purse and the fans are untouched. It applies to every tune-up, on either road and after the sixth fight too: the rule is about the fight, not the house. The ticket house's rebuild fight after a loss is a tune-up and pays +2 as well.

Why this is a choice and v12 was only half of one. Probe 12 measured the trade (cash against debut wins) and found it real with room and gone in a full gym. But the thing the ticket house sells, the name, was 8 to 9 reputation on the night and 3 by week 40: the guarantee house's road wins 0.85 more fights, each at +5. Under the tune-up rule two thirds of that road pays +2, so what the hard road wins on the first night it keeps. One reputation point with room is about $4.85 a week (section 1), so the lasting lead is also what pays the ticket house's cash by week 40. In a full gym it still pays nothing until the player makes room: **the fork interconnects with the premises** (free hand, owner S534), and that is where it flips.

What a debut loss costs at week 40 (probe 12: $2,287 behind the same option's winners, today $972): the rebuild fight is a tune-up purse instead of a step up and one whole fight later on the table; at the ticket house it also forfeits the name and the seat.

## 4. The asks (ESTIMATE)
| House | Ask | Today (CODE) | v13 | Right when / wrong when |
|---|---|---|---|---|
| Both | **Later +2 weeks** | $150 off (`ProCall._apply_later` :197-201) | unchanged; the card shows about +2 in 100 (section 5). **A calendar tool, not a fork lever:** it is for an injury, the weight or a boxer new to the gym. It is measured on the night only and is outside the audit's bars | Right when the boxer is not ready. Otherwise skip it |
| - | Softer opponent | gap +0.5, free, 2 tune-up sets (`_apply_softer` :204-208) | **CUT** (probe 12: right in 0 of 4 cells; the promoter already picks the debutant to suit the boxer, DEBUTPICK1) | |
| - | Own ticket price | `_price_entry` :242-260 | **CUT.** A purse lever: $13 at most for the gym (probe 11) | |
| - | Costs from the purse | `_costs_entry` :263-283 | **CUT.** Today it is the one answer (+$909) | |
| - | Later +4, Better split | free or dominated | **CUT** (v10, v11) | |
Two probes say the same thing: nothing bolted onto the contract is a decision. No further ask is to be designed for this screen.

## 5. The read, the seats, the hold (ESTIMATE)
- **The card shows what plays** (probe 12 bar 4). `DebutRead.card` (CODE :17-24; its header :5-6 says the read "errs low by a point or two") gains two terms: +1 point for every week of `debut_weeks` over 4 (v12), and **+0.2 of every point the read stands over 60** (NEW: probe 12 stage A read 75.0 for 78.6 played and 60.4 for 59.9, so the shortfall grows with the favourite, not with the weeks). `DebutPick` searches on that card, and **the guarantee house's aim moves from 75 to 78 on it** (`DebutPick.AIM` :15), which lands on the debutant today's aim picks. The ticket house reads as today. Later +2 shows about +2.
- **Seats on the night** (v11, kept): one dashed number on the ticket bar, today's seats plus half the members the gym gains by the debut. It matters for one thing only: the name a ticket-house win is worth (seats / 4). The hover says so.
- **The room line** (new): when the forecast members by the debut are within 6 of the cap, both cards say "Your gym is nearly full: the name brings nobody in until there is room (Club, Money)".
- **The hold** (v10 and v11, kept whole): amber need and flag, so Continue runs; the lapse checked every day; one stop on the last day; no bout bookable for this boxer while the offer is open; the idle-loyalty count pauses.
- **Stay amateur** says the real next gate, terms x0.9 unless a title comes, loyalty -8, declines left. The returning house: the ticket house at 56 seats or more, the guarantee house below (v11).
- **The money, said honestly** (v10, kept): Cash today, The gym on the night, The boxer on the night, in small type under the road. CUT the step and top promise, the assumed $75 a week and the pays-back sentence.
- **The name a fight makes** (NEW): each row of NEXT FIGHT says "+2 reputation" (tune-up) or "+5" beside its kind chip, and the result page and week review repeat it after the fight.
- **The guarantee purse stays $1,800** (probe 11 item 8: $104 either way; it decides nothing, so nothing is changed and no test moves).

## 6. Probe 12's section 2, item by item
| # | Probe 12 | v13 | Where |
|---|---|---|---|
| 1 | CUT every ask on the offer except Later +2 | **Taken whole.** Softer is cut; the asks row is one button | Sections 0, 4 |
| 2 | KEEP one decision: which house | **Taken.** v12's fork unchanged | Section 3 |
| 3 | "Turning pro is one good decision, not a deep screen. The depth an 8 needs is in the six fights of the road and in the gym's room" | **Taken.** The tune-up rule puts the trade on every one of the six fights, where the player already picks a row; nothing is added to the offer screen | Sections 3, 5, 7 |
| 4 | (a) drop Softer | Done | Section 4 |
| 5 | (b) make the name last: a soft win makes less name than a hard one, as it already makes fewer fans | **The tune-up rule:** +2 reputation, not +5 | Section 3 |
| 6 | (c) aim the guarantee house's card at what plays, 78 | **The card adds the favourite's shortfall; the aim is 78 on it** | Section 5 |
| 7 | Run the probe again on 180 or more rolls | **Run in this task** with 36 call days asked a boxer (30 in probe 12) | Section 9 |
Kept from v12 without change: each house's own debutant, the name by seats and the table's last seat for a ticket-house debut win, the debut counted on the table (fans, the rebuild flag), the firm road, the room line, the hold, Stay's true hover, the returning house, the honest ledger, names only in headers.

## 7. Where it appears: CODE TODAY against TO BUILD (every menu the mechanic shows on, and what each is wired to)
| Menu | CODE TODAY (file, function, lines) | Wired to today | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|---|
| Top bar flag | `Needs.flags` :167-168 | red PRO OFFER, act "prooffer" | amber; days left |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83 | `Needs.blockers` :140-141 | runs while the offer is held; one stop on the last day |
| Home, needs | `Needs.needs` :67-70, `_pro_line` :199-206 (house names in the body) | act "prooffer", "Hear it" | amber; roles, not names |
| Office desk | `scripts/ui/OfficeDesk.gd` :39 | the contract icon for "prooffer" | none |
| Offer header | `ProOffer.build` :35-45 | `ProOfferWire.days_left`, `ProCall.age_line` | "Another boxer's call waits behind this one." |
| Offer ticket bar | `ProOffer._tickets` :90-106 | `ticket_parts` :211-225, one mark at 60 | both marks; seats on the night (dashed) and its hover: "The ticket house's win is worth 1 reputation for every 4 seats sold" |
| Offer house card | `ProOffer._house` :110-170 | `DebutRead.card`, `DebutPick.line/tip`, `ProOfferWire.money` | head THE TICKET HOUSE / THE GUARANTEE HOUSE and a role line ("a hard first night in front of the hall, then step ups" / "a safe first night, then tune-ups"); the debutant's style; win chance (what plays: the favourite's shortfall and the weeks past four counted; the guarantee house about 78); "A win: +N reputation and the table's last seat" / "A win: +5 reputation"; "A loss: a rebuild fight first, N fans"; "Your first six fights: step ups, +5 reputation a win" / "tune-ups, +2 reputation a win; a step up after 3 wins"; the room line when the gym is full ("Your gym is full: the name brings nobody in until there is room"); three money numbers in small type. CUT step/top, weekly-after, pays-back, "+N loyalty", "A win brings N members" |
| Offer asks | `ProOffer._ask` :174-195 | `ProOfferWire.answers/ask/back_to_plain`; acts "proask", "proplain" (`scripts/ui/RosterActs.gd` :96-104) | one ask, on both houses: Later +2 weeks, with what it changes on the card. CUT Softer, own ticket price, costs from the purse, better split, later +4. The six-button row becomes one button |
| Offer foot | `ProOffer.build` :56-81 | `ProOfferWire.morale_line`; acts "turnpro" :90-95, "declinepro" :105-108 | the table pick of the weight (WEIGHT2's hook, section 8); Stay's true hover; Review later; "Sign this offer". CUT the wish |
| Fighter, Next Step | `scripts/ui/areas/FighterPage.gd` :338, :344, :355-357; `scripts/rules/NextStep.gd` `road` :50, `pro_line` :73-88 | tickets against each house, age, declines left | "Offer open, N days"; roles, not names |
| Fighter, contract | `FighterPage.gd` :144 | fixed text "Club stipend, $250 a week / Until turning pro" | the pro share and house for a pro |
| Money, stipends | `scripts/ui/MoneyPanels.gd` :264, `_stipend_card` :360-367 | "signing ends it anyway" when the offer is this boxer's | none |
| World compare | `scripts/ui/WorldCompare.gd` :269 | the "offer waiting" mark | none |
| Fights (pro) | `scripts/ui/ProFights.gd` :117; `ProLean.line` :41-47 (house name in the body) | the lean's line under NEXT FIGHT | roles, not names; "Your house's road: step ups (N of 6 left)" / "tune-ups; a step up after 3 wins"; the rebuild line after a debut loss; no tune-up rider line. **Each row says the name a win makes: "+2 reputation" on a tune-up, "+5" on any other fight** (beside the kind chip, :161-163) |
| Week review | `ProWeekLines.lines_for` :15-42, `rows` :62-75 | `f["pro_signed"]` (`Roster.turn_pro` :294-295, `BoutFinish.gd` :123-124) | "seats now N (N at the call)"; the ledger with the true share, the reputation won and the table seat; after every pro fight the reputation line names the kind ("Tune-up win: +2 reputation"); CUT the NEXT promise and the $75 line |
| History | `scripts/ui/BoutHistory.gd` :45, :68 | "TURNED PRO WITH (house), (date)" header | none |
| Debut result | `BoutFinish.gd` :94-116; `Roster.debut_words` :254-261 | members, reputation, the pay label and news line | the name by seats and the table's last seat (ticket house win); fans from the debut; "a rebuild fight first" after a loss; the true share |
| Pro fight result (every later pro fight) | `BoutFinish.gd` :94-98, :170 (the win's news line) | +8 members, +5 reputation on any win | the rank earned (S428) and the name made: +2 reputation after a tune-up, +5 after any other win; the news line says which |
| Game plan / camp for the debut | `BoutRead._read_copy` :272 (the coach's plan against the opponent's style) | one style today | reads the house's debutant; no screen change |
| Toasts | `RosterActs.gd` :95, :108 | "(first name) is a pro. Debut on (date)." | "Your boxer is a pro. Debut on (date)." |
| World, the pro table | `scripts/state/ProLadder.gd` `road` :423-438 | rank, fans, "Coming off a loss: win a rebuild fight first" | the debut's result shows there: the last seat after a ticket-house win, the rebuild line after a loss |
| Money, members | `scripts/ui/areas/Money.gd` :123-124 | members / cap (`GymSpend.member_cap` :160-161) | none: it already shows the room the name needs |
| Test jump | `scripts/ui/TestJump.gd` :195-197 | opens the offer on the test club | keep working |
Not reopened this session and not claimed: the top bar's drawing code (`Shell.gd`), the home list's ordering (`HomeNeeds.gd`), the week review modal's call site, the roster table, the world news feed.

## 8. The weight class at turning pro (a hook only)
The weight a boxer turns pro at is OWNED by the WEIGHT2 design (`ops/research/TASK_WEIGHTMOVE1.md`, running now). v13 designs nothing of it and names one hook: **the table pick appears on this call**, in the offer's foot above "Sign this offer". Today the table follows the amateur class's limit with no choice (CODE `ProLadder.division_for` :43-49). Whatever WEIGHT2 decides plugs in there; the probe below runs every boxer on the table the code gives today.

## 9. The probe (run in this task: `tools/turnprobe13.gd`, rules copy `tools/turnprobe13_rules.gd`, tables `tools/turnprobe13_sum.py`, result `docs/TURNPROBE13_RESULT.md`)
- **Population and pairing: probe 12's.** The six people the game can sign, each played from signing to the first pro call, then called on 37 different weeks: 222 rolls (a boxer's call week is one roll: a bout's dice are the fight day's). Printed in the result.
- **Cells.** The gym on the day of the call: seats 48, 56 and 64 with room for more members, and a full gym (members at the cap, a name that draws 10 more). $12,000 in the bank.
- **Arms.** V13 = sections 3 to 5 (the ticket house, the guarantee house; no ask). TODAY = the game's own functions, in two cells. The MUTANT is today's costs ask (+$909): the instrument must read it. **FLAT** (new) = v13 with the tune-up rule off, in the same two cells on the same rolls: the new lever's control arm.
- **The bot** takes the offered pro fight read nearest 65 in 100 from what the house's road puts on the table, to week 40. It does not run the gym and does not read the +2 / +5 line: it measures the rule's size, not the player's use of it.
- **The pass rule** (probe 11 item 3). Every option is read against the plain guarantee house on the same roll. A beats B in a cell when A is ahead by the line on one axis ($1,000 of gym cash by week 40, or 3 debut wins in 100) and not behind by the line on the other. RIGHT = beaten by nobody. THE ONE ANSWER = beats every other option.

| # | Bar (bounds, never an exact count). The bars of probe 12; bar 10 was Softer's and is now the new lever's |
|---|---|
| 1 | Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played |
| 2 | Instrument: the error on every option's cash gap is $250 or less in every pooled cell |
| 3 | Played debut wins: ticket house 52 to 68 in 100, guarantee house 70 to 82 (the night, 200 scratch nights a row) |
| 4 | The card is honest: shown within 3 of played, each house |
| 5 | The fork is a trade somewhere: the ticket house is $1,000+ ahead on cash and 3+ debut wins behind in at least one cell |
| 6 | The fork flips: the guarantee house beats the ticket house in at least one cell |
| 7 | AUDIT: no option is the one answer in more than 6 cells of 10 |
| 8 | AUDIT: every option is right in at least one cell |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 wins in 100 |
| 10 | The lever is real: with the tune-up rule off, on the same rolls, the ticket house's reputation lead is 1+ smaller in every cell with room it is played in |
| 11 | Boxer by boxer (boxer x gym cells): no option the one answer in more than 6 cells of 10, every option right in at least 2 |
| 12 | A debut loss leaves a mark at week 40: $1,000+ of cash or 20+ points of ranked share behind the same option's wins |
| 13 | The roads differ: step ups are 25+ points more of the ticket house's bookings than of the guarantee house's |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 |
| 15 | The name stays: the ticket house ends 4+ reputation ahead of the guarantee house in every cell with room |
**PASS = 12 or more of the 15, with bars 7, 8 and 9 all passing** (probe 12's rule, unchanged). Then two fresh critics (one code-checked), 8+ on DEPTH and 8+ on PLAY (owner S534), before the owner's board.
- **If it fails:** the result says which lever broke and it goes back to Claude. A third fail in a row is a cut-or-keep question for the owner (`TASK_TURNPRO13.md`).
- **State tests for the build:** last day and reload; a double press on Sign; an amateur offer open at the call; Stay at 1 and 2 declines; the 10% share on the ledger; an old save's offer with no `opp_picked`; an old save's offer with the Softer ask already taken (it keeps today's terms); a debut loss then the first offer set (no step up); a ticket-house win when the table has no ranked boxer left to unseat; a tune-up win pays 2 and a short-notice tune-up win pays 4.
- **Golden path:** call, hold three days, Later +2 on and off, sign, the seats line on Monday, debut, the name and the seat on the result page, the first offer set on the house's road with its +2 / +5 line, one tune-up win and its line in the week review.

## 10. Owner rulings kept
- The debut opponent is picked to each boxer (Q-286): `DebutPick` stays the one search.
- The guarantee house about 75 in 100, "78 is fine": the debutant it picks does not change; its card now says 78, which is what plays.
- Names only in headers (S448). Only actionable information (C443): no gap, no aim, no assumed weekly figure; the room line shows only when the gym is nearly full.
- Tooltips explain (S532): the "+2 reputation" hover on a tune-up says why ("an easy win is not news") and what the name is for (members, when the gym has room).
- Every fight shows the rank earned (S428): the name made sits beside it on the result page.
- Amateur bouts need no camp (S428): untouched. The normal game starts with no boxer signed (S487): untouched.
- Board text short. The one line for his board, after the probe and two critics at 8+: "Turning pro: room and a big hall - the hard road. Full gym or a fragile record - the safe one. OK to build?"

## 11. Build order (ESTIMATE; nothing here is built)
1. The hold (v10): amber, daily lapse, the booking guard, the loyalty pause. Red test first: Continue with an open offer must advance the day.
2. The card shows what plays (the weeks past four, the favourite's shortfall, the guarantee aim at 78); the two debutants. Re-run DEBUTPICK1's 22 cells.
3. The debut counts on the table: fans, the rebuild flag (`ProLadder.result` :376 no longer returns early for the debut).
4. The ticket house's win: the name by seats, the table's last seat.
5. The firm road: `ProLean` removes rows as well as adding them.
6. The asks: CUT Softer, own price, costs, split, later +4; one button (Later +2).
6b. The tune-up rule: +2 reputation on a tune-up win (`BoutFinish.gd` :98 reads the booked kind, which `ProLadder.book` :337-368 must keep on the bout); the +2 / +5 line on the Fights rows, the result page and the week review.
7. The card and the other menus of section 7; the result page and week-review lines.
Tests that pin today's numbers and will move: `tests/pro_call_test.gd`, `tests/pro_offer_wire_test.gd`, `tests/debut_pick_test.gd`, `tests/debut_read_test.gd`, `tests/pro_ladder_test.gd` (the debut on the table, the road), and any test that reads +5 reputation after a tune-up win.

## 12. Cut list
- **CUT in v13 -** the Softer ask on either house (and its tune-up rider, already cut); Softer's hover; bar 10 as a Softer bar. No new ask is to be designed for the offer.
- **CUT from v11 -** the $1,400 guarantee purse; the win crowd by seats in members; the forgiven loss; loyalty from the boxer's pay; the wish; the $270 ticket ask; the gated and floored costs ask; the crunch cell; "worth it under 66 seats".
- **CUT, kept from v10 and v11 -** Later +4. Better split. The tune-up rider. "Won't" buttons. The step and top promise. The assumed $75 a week and the pays-back sentence. A dollar rate for morale or loyalty. The new fees and the manager's licence until the source is opened. The hard-camp line on the offer. A stipend switch on the hold. v9's loan, queue and versioned contract pay. A win-chance range. Raising the aims.
