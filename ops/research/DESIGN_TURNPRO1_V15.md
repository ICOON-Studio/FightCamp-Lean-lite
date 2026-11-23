# Turning pro - design map v15 (v14 with the three bars its probe failed fixed: the favour is the slot on the card, the card reads the boxer's own nights, a tune-up win makes 1)

S537, TURNPRO15 side console. Task: `ops/research/TASK_TURNPRO15.md` (v14's text is kept where v15 changes nothing; **every v15 change is in section 0a** and wins over any older line below). Scope: the pro offer, from the call to the debut and the road after it (the debut and the five sets of offers that follow: the game's "first six pro fights"). The pro ladder after that is a handoff.
Method (owner S530/S531: maps come from the code): **CODE** = file, function, lines. Section 1 carries v13's citations, which the code-checked critic opened one by one (`ops/research/DESIGN_TURNPRO1_V13_CRITIC_ARENA.md`: 75 true, 4 partial, 1 false of about 80); the false one and the partial ones are corrected below, and every line this map ADDS (the booking, the lean, the duck count, the area belt, the ask path) was opened in this session at the working tree of 22 Nov 2026. **ESTIMATE** = a proposal, a sum worked on paper, or a measured result that is not code. **CUT** = do not build or show it. **CHECK** = not confirmed. No game file was changed.
**PROBED (S537):** probe 14 read v14 at PASS 14 of 17 with bars 4, 10 and 15 failed (`docs/TURNPROBE14_RESULT.md`); v15 is the fix of those three and is measured in `docs/TURNPROBE15_RESULT.md`. No critic has scored v14 or v15.
Inputs: map v13 and its probe (`docs/TURNPROBE13_RESULT.md`, PASS 14 of 15); the two v13 critics, both 5 DEPTH / 7 DESIGN / 5 PLAY (the code-checked one above, and `ops/research/DESIGN_TURNPRO1_V13_CRITIC_JOHN_JOHN.md`); Claude's S537 decision (`TASK_TURNPRO14.md`); owner S534: mechanics need 8+ on DEPTH and 8+ on PLAY, probe first, free hand to remove, add or interconnect.

Words: the **ticket house** = Bow Lane. The **guarantee house** = Harrow & Finch. **Seats** = debut tickets the boxer sells. **The table** = the boxer's professional division table. **The name** = the gym's reputation. **A tune-up** = a pro fight the promoter offers as one (the green chip on the row); **a step up** = a ranked name above the boxer (the gold chip). **The road** = the debut and the five sets of offers after it. **Favour** = how the boxer's house feels about your gym, 0 to 10.

## 0a. What v15 changes from v14 (the three bars probe 14 failed; ESTIMATE, sized by probe 15)
What a real promoter does: he puts the trainer who takes his fights on the better nights and freezes out the one who refuses.
1. **The favour is the boxer's slot on the house's card** (bar 15: v14's favour worked backwards, the rebel ended $1,036 to $1,383 better and the keeper gained nothing).
   - **Top of the bill, favour 8 or more** (both houses): the house hands the gym a block of tickets for the fight, **$250 to the gym a fight**. On top, as v14: the guarantee house pays $300 more a purse; the ticket house brings the area title shot after 4 pro wins.
   - **Bottom of the bill, favour under 3:** the house dates the fight **3 weeks later** than it would ("when a slot is free"). Nothing else: the purse, the kinds on the table and the offer days stay.
   - **CUT: "under 3 the house brings only its own kind" and "offers stand 4 days".** Being made to book the house's kind was a help, not a price (probe 14, stage F).
   - The slot is read when the fight is booked, from the favour before that booking moves it. Favour moves as v14 (+1 the house's kind or the title, -1 the other kind when the house's was on the table).
2. **The card reads the boxer's own nights** (bar 4: v14's card under-read some boxers by 8 to 14). When a house calls, the game quietly plays this boxer's debut ahead, camp included, against two of the house's possible debutants (one the plain read puts at 72, one at 50), 500 nights each. What those nights add to the read, on a straight line between the two, goes on every card of that house for this call. v14's flat lift ("+0.2 of every point over 60") is CUT. Both debutants a house names are then searched on that card, so "60" means this boxer wins about 60 of 100. **CHECK for the build:** the cost of 2,000 quiet bouts when the call arrives (spread over the days the call stands, or fewer nights behind a wider band).
3. **A tune-up win makes 1 reputation, not 2** (bar 10: the name-chaser's lead was 2.3 to 2.8 where the bar asks 3). A number change; the step up, payday, title and rebuild win stay at 5.
4. **The bots** (not the design): the favour-keeper books the house's kind until the favour is 9, then the other kind, so it stays at the top of the bill; it takes the title shot when the read is 45 or more. The name-chaser and win-chaser are v14's.
5. **Bar 15 is read more strictly than in probe 14** (fixed before the run): the keeper's line must be a GAIN, the rebel's a LOSS, and neither may have a line the other way. Bar 4's "own nights" are 1,000 scratch nights a boxer (v14: 200), a finer ruler on the same line of 8. The other bars and every line are probe 14's.

## 0. What v14 changes from v13, in seven lines
Both critics put the same item first: under v13 the house decided the kind of every fight after the debut, so the road played itself and the whole mechanic was ONE decision (which house), which the gym's room answered. v14 keeps the fork and gives the road to the player.
1. **The kind is the player's.** Every set of the road carries a tune-up AND a step up, at both houses. The house still sets the aims, the purse, the date and the split; it no longer removes a kind. v13's "firm road" is CUT.
2. **A fight's name follows its kind, and the booking keeps the kind.** Tune-up win +2 reputation; step up, payday or title win +5; a rebuild fight after a loss +5 (v13 paid it +2: a second fine on the loss); a named opponent the player asks for is a step up (+5).
3. **House favour, 0 to 10** (starts at 5). Each house prefers a kind (the ticket house step ups, the guarantee house tune-ups: the lean the code already has). Booking the house's kind +1, the other kind -1. **At 8:** the ticket house opens an area title shot once the boxer has 4 pro wins; the guarantee house pays $300 more a purse. **Under 3:** offers stand 4 days, not 7, and the house brings only its own kind until the favour is back at 3.
4. **The favour replaces the duck count on the road.** Today a tune-up taken while a step up is on the table is a hidden "duck" (two stop the step ups). On the road the favour is that patience, shown as a number.
5. **Pick the debut night.** Each house names two debutants, one to build your boxer (an easier night) and one to test (a harder night that makes a name), both found by the game's own search and both shown with their card. The house's own choice is +1 favour, the other -1.
6. **No per-house debutant style.** Every debutant is the game's own (v13's probe measured a boxer nobody was going to build).
7. The probe is probe 13 again on the same population and pairing, with bots that read the +2 / +5 line (a name-chaser, a win-chaser, a favour-keeper), probe 13's bars 10 and 15 merged into one, and bars 7, 8 and 11 rewritten for the new choice.

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
- **CODE - `scripts/rules/DebutOpp.gd` consts :15-17, `name_for` :22-24, `rating` :32-33, `make` :37-41:** every debutant is a 0-0 "Boxer-puncher" with "Heavy right hand" and "Fades after round 3" (one set of constants for both houses), rated the boxer's no-camp strength less the gap. By house only the name, the gap and the club line ("(house) stable", :39) differ; the name list is by sex. **v14 keeps this: no per-house style** (v13's probe gave each house its own style; that is dropped).
- **CODE - `scripts/rules/BoutRead.gd` `_read_copy` :272, `_games` :277-280, `_tiring` :301, `_round_edges` :328, :337:** the read does use the opponent's style (the mix of games, and the plan the coach writes against that style) and three scouting words ("walks in", "Fades", a body threat). So a different style per house would change the bout, with no new system.
- **CODE - `Roster.turn_pro` :305-309, `debut_day` :319-320:** signing books that debutant for the Saturday `debut_weeks` out, 4 rounds; the rating is taken from the boxer's stats on the signing day.
- **CODE - `scripts/state/ProLean.gd` `LEAN_FIGHTS` :7, `LEAN_KIND` :8, `extra` :12-33; `scripts/state/ProLadder.gd` :23-25, :204-214:** for the first 6 pro fights, **the debut counted** (`pro_fights` = pro_w + pro_l + pro_d, :36-37), so the debut and the five sets after it, the house ADDS one row to each set of offers: a second tune-up (nearest a read of 0.82, inside 0.70-0.93) for the guarantee house, a second step up (nearest 0.50) for the ticket house. The plain set (one tune-up, one step up, one payday) is still there, so the lean widens the choice; it never forces a fight.

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
- **CODE - `scripts/rules/FighterProfile.gd` :25, `scripts/rules/AskDates.gd` `wait_words` :119-122:** "month_no_fight: -6" is READ once, as words: the asks screen says "A month without a fight costs 6 morale", and nothing applies it (v13 said "no caller": FALSE, found by the code-checked critic). It is not part of turning pro: **dropped from this map**; the one-line fix (cut the sentence, since no rule stands behind it) is build order item 0.

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

### The lines v14 builds on (CODE, opened in this session)
- **CODE - `scripts/state/ProLadder.gd` `book` :337-368:** the booked fight is written at :360-362 with opponent, day, rounds, purse and `ladder` (the opponent's id) and NO kind. Nothing after the booking knows whether it was a tune-up. `book` does not check that the opponent was on the table (any id on the division table books when `asked` is false).
- **CODE - `ProLadder._make_offers` :175-216:** one tune-up (read nearest 0.82 inside 0.70-0.93), one step up (a ranked name the boxer may ask for, read nearest 0.50), one payday (a top-10 name read 0.20-0.45). The step up is left out while the boxer rebuilds or after two ducks (:209). A row beaten on every axis by another is dropped (`_drop_dominated`). So a set can already lack a kind.
- **CODE - `scripts/state/ProLean.gd` `LEAN_KIND` :8, `extra` :12-33:** the kind each house leans to is already data: `{"hf": "tune", "bow": "above"}`. **This is the kind the house prefers; v14 adds no new table.**
- **CODE - `scripts/rules/Matchmaking.gd` `note_choice` :196-201, `DUCKS_BLOCK` :39, `ask` :190; called from `ProLadder.book` :354:** booking a fight more than 2 rating points softer than an offered step up is a duck (not while rebuilding); a harder pick clears the count; two ducks stop the step ups (`_make_offers` :209) and refuse an ask for anyone not rated above the boxer (:190). The count is shown only in the row's "duck" line (`ProLadder.stakes`).
- **CODE - `ProLadder.ask_rows` :321-333; `scripts/ui/ProFights.gd` :126, :142, :300; `scripts/ui/BoutActs.gd` :197-200:** the player can NAME an opponent ("OR NAME YOUR OPPONENT"): anyone ranked above, inside the band (`Matchmaking._in_band` :324-331: an unranked boxer may ask from #15 down). An asked fight is booked with `asked` true and carries no kind either.
- **CODE - `scripts/world/WorldRank.gd` `BELT_LEVELS` :5, `champion_of` :164-168; `Matchmaking._take_belt` :303-311 (called :244); `ProLadder.book` :356-357, `ROUNDS_TITLE` :36:** every division table has an AREA champion (the lowest of four belt levels). Beating a belt holder takes the belt; a fight against one is 10 rounds. Today an unranked or low-ranked boxer cannot be offered the area champion unless the champion happens to sit inside the band.
- **CODE - `ProLadder.OFFER_DAYS` :31, `day_events` :134-137:** a set stands 7 days; a lapsed set is "the promoter will call again next week".
- **CODE - `scripts/state/Bouts.gd` :261:** a pro bout can never be a short-notice swap, so "a short-notice tune-up win" (v13's state test) cannot happen: CUT from the tests.
- **CODE - `scripts/rules/DebutOpp.gd` `name_for` :22-24:** the debutant's name is picked from a list of four by the day and the house name's length. A second debutant for the same house is the next name on the list.

## 2. The human question (the brief)
A manager with a new pro picks each early opponent with the promoter - "keep your boxer busy" against "test your boxer" - and keeps the promoter sweet so the good dates keep coming. The money is the boxer's; the club's gain is the name.

## 3. The three decisions (ESTIMATE; the probe of section 9 sizes every number)

### 3a. The house (v13's fork, kept)
| | The ticket house | The guarantee house |
|---|---|---|
| Calls when | the gym sells 46+ seats (CODE `ProCall.who_calls` :63-69) | the gym sells 74 or fewer |
| The debut | 4 weeks out; its own night is the TEST | 6 weeks out; its own night is the BUILD |
| The kind it prefers | step ups (CODE `ProLean.LEAN_KIND` :8) | tune-ups |
| Its door at favour 8 | an area title shot once the boxer has 4 pro wins | $300 more a purse |
| The money | the purse as today. Shown small, said honestly, not a lever | the same |

### 3b. The debut night (NEW: the player picks one of two)
| | Test | Build |
|---|---|---|
| The ticket house | the card reads about 60 in 100 (today's aim, CODE `DebutPick.AIM` :15). A win: +5 reputation **and +1 for every 4 seats sold on the night (20 at most), and the table's last seat**. Favour +1 | the card reads about 70. A win: +5 reputation. Favour -1 |
| The guarantee house | the card reads about 68. A win: +5 reputation **and +1 for every 8 seats sold (20 at most)**. Favour -1 | the card reads about 78 (owner: "78 is fine"). A win: +5 reputation. Favour +1 |
| A loss, either night | reputation -2 (-4 stopped) as today; a rebuild fight before any step up; fans by how it looked (CODE `Matchmaking.loss_fans` :290-291) | the same |
- Both debutants come from `DebutPick`'s own search (CODE `pick` :48-67) run twice on the card of section 5, once at each aim; the house's misjudgement for this boxer (`target` :34-36) moves both alike, so they stay about 10 points apart. Both are the game's debutant (CODE `DebutOpp` :15-17): the same style, threat and weakness, a different name (`name_for` :22-24, the next name on the list) and a different rating.
- "Seats make the name" now belongs to the NIGHT, not the house: it is what a test is for. The guarantee house's test pays half the ticket house's (it sells the night on its guarantee, not on your seats).
- Owner ruling Q-286 ("Pick to each boxer") holds: the promoter still picks each debutant to this boxer; the player picks between the two it found. The ruling "the debutant it picks does not change" holds for each house's OWN night (60 and 78 on the card).

### 3c. The kind of each fight on the road (NEW: the player's, at both houses)
- **Every set of the road carries a tune-up and a step up.** The promoter's set is made as today (CODE `ProLadder._make_offers` :175-216, the house's lean row added by `ProLean.extra` :12-33). Where it lacks a tune-up, the nearest one the table holds is added (the tune band widened from 0.70-0.93 to 0.60-0.97); where it lacks a step up and the boxer is not rebuilding, the ranked name read nearest 0.50 is added. A payday stays when the promoter has one.
- **No kind to be found:** the set says so in a line ("No tune-up this time: nobody suitable is free") and booking the other kind is not a refusal. A set with no row at all is today's lapse (CODE `day_events` :134-137: the promoter calls again in a week). Never a silent change of the rules.
- **After a loss** the game's rule stands: no step up until a rebuild win (CODE `_make_offers` :209, `Matchmaking.ask` :188-189). The tune-ups of that set are REBUILD fights: a win pays +5 and moves no favour.
- **The name a win makes** (the booking keeps the kind: `ProLadder.book` :360-362 gains `kind`; `BoutFinish.gd` :98 reads it):

| The fight booked | A win makes | Favour, ticket house | Favour, guarantee house |
|---|---|---|---|
| Tune-up | +1 reputation (v15; v14 +2: "an easy win is not news") | -1 | +1 |
| Step up (offered, or a name the player asks for) | +5 | +1 | -1 |
| Area title shot | +5 and the belt | +1 | - |
| Payday | +5 | 0 | 0 |
| Rebuild fight | +5 | 0 | 0 |
The members (+8), the purse and the fans are as today. A refusal (-1) counts only when the house's kind was on the table.
- **What already pulls the two kinds apart** (CODE, unchanged): a tune-up is read near 82 in 100, the next fight comes 6 weeks later, it moves no place and a mismatch 6 points under costs the win one fan (`Matchmaking.apply_result` :242, `next_weeks` :283-285); a step up is read near 50, takes the beaten boxer's place (a ranked purse: $1,500 + $400 a place, `pay_of` :216-225), earns a fan more, and the next fight is 12 weeks later. v14 adds the name (+2 against +5) and the favour.

### 3d. House favour (NEW)
- **One number a boxer, 0 to 10, starting at 5**, kept on the fighter with the house. It moves by 1 on the debut night picked and on every fight booked (the table above).
- **v15: the favour is the slot on the card** (section 0a, item 1; v14's two bullets here are replaced).
  - **Top of the bill (8 or more):** $250 to the gym a fight (its block of tickets) at both houses; the guarantee house also pays $300 more a purse (the boxer's money); the ticket house also carries the division's AREA CHAMPION as a TITLE row once the boxer has 4 pro wins (CODE `WorldRank.champion_of` :164-168; 10 rounds, `ROUNDS_TITLE` :36; a win takes the belt and the champion's place, `Matchmaking._take_belt` :303-311).
  - **Bottom of the bill (under 3):** the fight is dated 3 weeks later (CODE today: `ProLadder.book` :360 sets the day). Both kinds stay on the table.
- **On the road the duck count sleeps** (CODE `Matchmaking.note_choice` :196-201): the favour is the promoter's patience there, and it is on the screen. After the sixth pro fight the duck rule runs as today; the favour and its two thresholds stay.
- Why this is depth and not a second meter: the kind's value now depends on the moment. A tune-up is worth 2 reputation and a safer record; at the guarantee house it is also a step toward the top of the bill; at the ticket house it is a step toward the bottom of it, and later dates. A boxer coming off a hard night, a gym with no room for the name, a title shot two wins away: each changes which kind is right.

## 4. The asks (ESTIMATE; v13 unchanged)
| House | Ask | v14 |
|---|---|---|
| Both | **Later +2 weeks** | kept as v13: $150 off the purse (CODE `ProCall._apply_later` :197-201), the card shows about +2. A calendar tool. **It is drawn only when the boxer has a cause it fixes** (an injury or a weight still to make on the debut day); with no cause the offer has no ask (v13 critic: "one button plus dead numbers is worse than no button") |
| - | Softer, own ticket price, costs from the purse, better split, later +4 | **CUT** (probes 11 and 12; the pick of the debut night is what "softer" was reaching for) |

## 5. The read, the seats, the hold (ESTIMATE)
- **v15: the card reads the boxer's own nights** (section 0a, item 2), replacing the +0.2 lift in the next line. **The card shows what plays** (v13): `DebutRead.card` (CODE :17-24) gains +1 point for every week of `debut_weeks` over 4 and +0.2 of every point the read stands over 60. Each card prints a band, not a point ("about 60, 56 to 64"): stage A reads each boxer's own card against that boxer's own nights (v13 checked the mean of six).
- **Seats on the night** (kept): one dashed number on the ticket bar, drawn on the TEST nights only (it is what a test win pays on).
- **The room, as arithmetic** (v13 critic: the old room line printed the answer): "Room for N more members. 3 reputation brings about 2." No sentence telling the player which house to pick.
- **The hold, Stay amateur, the honest ledger, names only in headers:** v13's, unchanged.
- **The purses are equal on the card.** The guarantee house's $1,800 against $1,500 decided nothing in three probes ($104); v14 shows the boxer's take on each night and leaves the constant alone (no test moves).

## 6. The v13 critics' lists, item by item
| # | Critic's item | v14 | Where |
|---|---|---|---|
| A1, J1 | Give the player the kind on every set; the probe bot reads +2 / +5 | **Taken whole** | 3c, 9 |
| A2 | Let the player pick the debut night; styles in or out | **Taken; styles out** | 3b |
| A3 | Make the name worth something in a full gym, or make room cheap | **Not taken in v14.** The full cell is measured again; the arithmetic room line replaces the instruction. The premises are another map's | 5, 9 |
| A4 | Price the fork in members, not dollars | **Taken on the screen** (the room line; the cash rows go) | 5, 7 |
| A5 | The card honest per boxer, with a band | **Taken** (bar 4 is per boxer now) | 5, 9 |
| A6 | An asked fight must have a kind | **Taken:** an asked name is a step up, +5, and counts as one for the favour | 3c |
| A7 | Pair the debut loss, or drop the sentence | **The sentence is dropped.** Bar 12 stays as an unpaired reading and the map quotes no cost from it | 9 |
| A8 | An answer for an empty set | **Taken** | 3c |
| A9 | Cut the dead ink; give the one ask a cause | **Taken** | 4, 5, 7 |
| A10 | Three bot arms on the same rolls | **Taken** (name, win, keeper) | 9 |
| A (2.6.2), J8 | The rebuild fight should not pay +2 | **Taken:** +5 | 3c |
| A (FALSE) | `month_no_fight` is read by the asks screen | **Dropped from this map;** the fix is build item 0 | 1, 11 |
| J2 | A favour score 0 to 10 a house | **Taken**, with the S537 numbers | 3d |
| J3 | One switch of house after fight 3 | **Not in v14** (S537: only if the probe says the fork still solves itself) | 9 |
| J4 | The boxer's wish, from Confidence and Heart | **Not taken** (v11 cut the wish: no goal in the game reads it) | 12 |
| J5 | Fix the numbers and words | **Taken:** "+5, and +1 for every 4 seats"; no "hall"; "your boxer"; the name does NOT pay back the cash by week 40 and the map no longer says it does | 3, 7 |
| J6, J7, J9, J10 | A same-year debutant on the other road; an open night for seats; fewer seats after a debut loss; a one-click move | **Not taken:** each is a new system; the scope rule waits for the road to feel right | 12 |

## 7. Where it appears: CODE TODAY against TO BUILD (every menu the mechanic shows on, and what each is wired to)
| Menu | CODE TODAY (file, function, lines) | Wired to today | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|---|
| Top bar flag | `Needs.flags` :167-168 | red PRO OFFER, act "prooffer" | amber; days left |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83 | `Needs.blockers` :140-141 | runs while the offer is held; one stop on the last day |
| Home, needs | `Needs.needs` :67-70, `_pro_line` :199-206 | act "prooffer", "Hear it" | amber; roles, not names |
| **The offer letter: header** | `scripts/ui/modals/ProOffer.gd` `build` :35-45 | `ProOfferWire.days_left`, `ProCall.age_line` | unchanged |
| **The offer letter: ticket bar** | `ProOffer._tickets` :90-106, `ticket_parts` :211-225 | one mark at 60 | both marks; seats on the night (dashed) with the hover "A test night won is worth 1 reputation for every 4 seats (ticket house) or 8 (guarantee house)" |
| **The offer letter: house card** | `ProOffer._house` :110-170 | `DebutRead.card`, `DebutPick.line/tip`, `ProOfferWire.money` | head THE TICKET HOUSE / THE GUARANTEE HOUSE; one role line ("prefers step ups; at favour 8 an area title shot after 4 wins" / "prefers tune-ups; at favour 8 $300 more a purse"); **the two DEBUT CARDS** (next row); "A loss: a rebuild fight first"; the room line as arithmetic; the boxer's take on the night. CUT: the three gym money rows, step/top, weekly-after, pays-back, "+N loyalty", the $1,800 against $1,500 as a lever |
| **The debut card (two a house, NEW)** | none (one "VS (name)" line, `ProOffer._house` :139-143; the picked line `DebutPick.line` :88-91) | `DebutPick.apply` :71-78 keeps one `opp_gap` a house | a pair of cards inside each house card, one picked: the debutant's name, TEST or BUILD, the win chance as a band, "A win: +5 reputation" or "+5 and +1 for every 4 seats: about +N tonight, and the table's last seat", "Favour +1" / "-1". Wired to: two picks kept on the offer (`opp_gap_test`, `opp_gap_build` from `DebutPick` at the two aims), the chosen one written by a new act "propick" (house, night), read by `Roster.turn_pro` :305 when it books the debut |
| **The offer letter: asks** | `ProOffer._ask` :174-195; acts "proask", "proplain" (`scripts/ui/RosterActs.gd` :96-104) | six buttons a house | Later +2, drawn only with its cause. CUT the other five |
| **The offer letter: foot** | `ProOffer.build` :56-81; acts "turnpro" (`RosterActs.gd` :90-95), "declinepro" (`RosterActs.gd` :105-108) | `ProOfferWire.morale_line` | the table pick of the weight (section 8); Stay's true hover; "Sign with this house" |
| **Fights (pro): the head of NEXT FIGHT** | `scripts/ui/ProFights.gd` :117 (`ProLean.line` :41-47, the house's name in the body) | the lean's sentence | **the favour**: ten pips and one line by state - "The house wants a step up. Favour 6 of 10: at 8 it opens an area title shot (4 pro wins needed, you have 2)" / "Favour 2: the house brings only tune-ups until you take one. Offers stand 4 days". Roles, not names. Wired to the fighter's `pro_favour` |
| **Fights (pro): each row** | `ProFights._row` :155-163 (the kind chip from `KIND_WORD` :21) | `ProLadder.offer_rows` (kind from the offer) | beside the chip: **the name a win makes ("+2 reputation" / "+5") and the favour it moves ("favour +1" / "-1")**; a new TITLE chip and a REBUILD chip; the house's kind marked "the house's pick". The duck line is not drawn on the road. Wired to the row's `kind`, which `ProLadder.book` :360-362 now keeps on the bout |
| **Fights (pro): name your opponent** | `ProFights.gd` :126, :142, :300; `ProLadder.ask_rows` :321-333 | act "probook" with "a" (`scripts/ui/BoutActs.gd` :197-200) | each asked row reads STEP UP, "+5", and its favour move: an asked fight has a kind |
| Fighter, Next Step | `scripts/ui/areas/FighterPage.gd` :338, :344, :355-357; `scripts/rules/NextStep.gd` `road` :50, `pro_line` :73-90 | tickets against each house, age, declines left | "Offer open, N days"; for a pro: the favour and the next door ("2 more step ups open the title shot") |
| Fighter, contract | `FighterPage.gd` :144 | fixed text | the pro share, the house and the favour |
| Week review | `scripts/ui/ProWeekLines.gd` `lines_for` :15-42, `rows` :62-75 | `f["pro_signed"]` | "seats now N (N at the call)"; after every pro fight the reputation line names the kind ("Tune-up win: +2 reputation") and the favour ("Favour 7 of 10"); CUT the NEXT promise and the $75 line |
| Debut result | `scripts/state/BoutFinish.gd` :94-116; `Roster.debut_words` :254-261 | members, reputation, the pay label | the night picked (TEST / BUILD), the name by seats and the last seat after a test won; "a rebuild fight first" after a loss; the true share |
| Pro fight result (every later pro fight) | `BoutFinish.gd` :94-98, :170 | +8 members, +5 reputation on any win | the rank earned (S428), the name made by the kind, the favour after it; a title won shows the belt |
| World, the pro table | `ProLadder.road` :423-438 | rank, fans, the rebuild line | the last seat after a test won at the ticket house; the area champion marked when the title shot is open |
| Money, stipends; World compare; Office desk; History; Toasts; Test jump | as v13's table (`MoneyPanels` :264, `WorldCompare` :269, `OfficeDesk` :39, `BoutHistory` :45, `RosterActs` :95, `TestJump` :195-197) | as v13 | none, but roles in place of names in toasts |
Not reopened this session and not claimed: the top bar's drawing code, the home list's ordering, the week review modal's call site, the roster table, the world news feed.

## 8. The weight class at turning pro (a hook only)
Owned by WEIGHT2. The table pick appears on this call, in the offer's foot (CODE `ProLadder.division_for` :43-49 gives the table today). The probe runs every boxer on the table the code gives.

## 9. The probe (run in this task: `tools/turnprobe15.gd`, rules copy `tools/turnprobe15_rules.gd`, tables `tools/turnprobe15_sum.py`, result `docs/TURNPROBE15_RESULT.md`)
- **Population and pairing: probe 13's.** The six people the game can sign, each played from signing to the first pro call, then called on 37 different weeks: 222 rolls. A boxer's call week is one roll (a bout's dice are the fight day's).
- **Cells.** The gym on the day of the call: seats 48 and 64 with room for more members, and a full gym (members at the cap, a name that draws 10 more). $12,000 in the bank. (Probe 13's 56 cell read the same as 48 and 64 on every row and is left out.)
- **An option** = house x debut night x road bot. The bots read the kind chip and the +2 / +5 line: the **name-chaser** books the step up (the title when it is there), the **win-chaser** the tune-up, the **favour-keeper** the house's kind until the favour is 9 and then the other kind (v15: it stays at the top of the bill; it takes the title shot read at 45 or more). Eight options a cell: each house's own night with the three bots, and the other night with the keeper.
- **v15's run:** the same six boxers on 36 call weeks each (216 rolls) in stage B; stage A on 1,000 scratch nights a row; stage F on 36 rolls (6 call weeks a boxer, all six boxers; probe 14 read 36 rolls of three boxers), one Godot run a boxer.
- **Arms.** V15 = sections 0a and 3 to 5. TODAY = the game's own functions with probe 13's bot (the row read nearest 65), in two cells; its costs ask is the MUTANT (+$909). FLAT = v14 with the tune-up rule off (the win-chaser, same rolls). **Stage F** (the favour): to week 80 on 72 rolls, each house's keeper and its full rebel (the other night, the other kind), with the favour's rules on and off.
- **Three pass rules, lines fixed before the run.** A beats B when ahead by the line on one axis and not behind by the line on any other. THE HOUSE: gym cash $1,000, debut wins 3 in 100 (probe 13's). THE ROAD (three bots, one house): gym cash $1,000, the name 3 reputation, the record 1 pro win less loss. THE NIGHT (test against build): cash $1,000, debut wins 3, the name 3.

| # | Bar (bounds, never an exact count) |
|---|---|
| 1 | Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played |
| 2 | Instrument: the error on every option's cash gap is $250 or less in every pooled cell |
| 3 | Played debut wins in 100: ticket test 52 to 68, ticket build 62 to 78, guarantee build 70 to 82, guarantee test 60 to 76 |
| 4 | The card is honest: each of the four debutants shown within 3 of played on the mean, AND no boxer's card more than 8 from that boxer's own nights (v15: 1,000 of them) |
| 5 | The house is a trade somewhere: the ticket house (test, keeper) $1,000+ ahead and 3+ debut wins behind the plain guarantee house (build, keeper) in at least one cell |
| 6 | The house flips: the plain guarantee house beats it in at least one cell |
| 7 | AUDIT (the kind; rewritten): inside a house no road is the one answer in more than 6 of 10 house x gym cells |
| 8 | AUDIT (the kind; rewritten): every road is right in at least one house x gym cell, AND in at least half of them two roads differ by a line on some axis |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 debut wins |
| 10 | The name is the kind's (probe 13's bars 10 and 15 were one fact; merged): with the tune-up rule off the win-chaser ends 1+ reputation higher in every cell with room, AND with it on the name-chaser ends 3+ reputation ahead of the win-chaser in the same house in every cell with room |
| 11 | Boxer by boxer (boxer x house x gym; rewritten): no road the one answer in more than 6 cells of 10, every road right in at least 2 |
| 12 | A debut loss leaves a mark: $1,000+ of cash or 20+ points of ranked share behind the same option's wins (not paired: a reading; the map quotes no cost from it) |
| 13 | Inside one house two bots book different kinds: step ups are 25+ points more of the name-chaser's bookings than of the win-chaser's, at each house |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 |
| 15 | The favour moves the result (stage F, the favour's rules on against off, same rolls): a line on some axis ($500 of gym cash, 3 reputation, half a win less loss) for a keeper in at least one house AND for a full rebel in at least one house (v15, stricter: the keeper's line a gain, the rebel's a loss, neither with a line the other way) |
| 16 | The debut night is a trade: in at least one house x gym cell the test is 3+ debut wins behind and 3+ reputation or $1,000 ahead, and neither night is the one answer in more than 6 of 10 of them |
| 17 | Both kinds are on the table: 80%+ of the road's sets that are not rebuild sets carry a tune-up and a step up, at each house |
**PASS = 14 or more of the 17, with bars 7, 8 and 9 all passing** (probe 13's share: 12 of 15). Then two fresh critics (one code-checked), 8+ on DEPTH and 8+ on PLAY (owner S534), before the owner's board.
- **If it fails:** the result says which lever broke and it goes back to Claude. A fourth round under 8 is a cut-or-keep question for the owner (`TASK_TURNPRO15.md`).
- **What no bar can show:** the bots follow fixed rules; they do not read the boxer's form, the gym's room or a title two wins away. Whether a PLAYER feels the choice is the critics' and the play test's.
- **State tests for the build:** last day and reload; a double press on Sign; the night picked then the house changed; an old save's offer with one debutant a house (it keeps today's terms); a debut loss then the first set (no step up, REBUILD chips, +5); a set with no tune-up to be found (the line, no favour move); favour at 0 and at 10 (clamped); the title row when the area belt is vacant (not drawn) or the boxer holds it; an asked name books as a step up; a tune-up win pays 1; favour 8 then a booking (the $250 block, once); favour 2 then a booking (the date 3 weeks later, both kinds still there); an old save's booked pro fight with no kind (pays 5).
- **Golden path:** call, pick the test night, sign, debut, the name and the seat on the result page, the first set with both kinds and the favour pips, one tune-up win and its "+2" line in the week review, the favour line after it.

## 10. Owner rulings kept
- The debut opponent is picked to each boxer (Q-286): `DebutPick` stays the one search, run at two aims.
- The guarantee house about 75 in 100, "78 is fine": its own night is the build at 78 on the card.
- Names only in headers (S448). Only actionable information (C443): no gap, no aim, no assumed weekly figure; the favour is shown because every booking moves it.
- Tooltips explain (S532): the "+2 reputation" hover says why ("an easy win is not news") and what the name is for; the favour hover says what opens at 8, what closes under 3, and what the player can do about it.
- Every fight shows the rank earned (S428): the name made and the favour sit beside it.
- Amateur bouts need no camp (S428): untouched. The normal game starts with no boxer signed (S487): untouched.
- Board text short. The one line for his board, after the probe and two critics at 8+: "Turning pro: you pick the night, then the kind of every fight. Keep the house sweet or go your own way. OK to build?"

## 11. Build order (ESTIMATE; nothing here is built)
0. `AskDates.wait_words` :119-122: cut "A month without a fight costs 6 morale" (nothing applies it). One line, its own commit.
1. The hold (v10): amber, daily lapse, the booking guard, the loyalty pause. Red test first: Continue with an open offer must advance the day.
2. The card shows what plays, with a band; **two debutants a house** (`DebutPick` at two aims, the picks kept on the offer, the act "propick"). Re-run DEBUTPICK1's 22 cells per boxer.
3. The debut counts on the table: fans, the rebuild flag (`ProLadder.result` :376-378 no longer returns early for the debut); a test won: the name by seats, and at the ticket house the last seat.
4. **The kind on the bout:** `ProLadder.book` keeps `kind` (offered row, "above" for an asked name, "rebuild" after a loss); `BoutFinish.gd` :98 pays 2 for a tune-up win.
5. **Both kinds on every road set** (the two fill-in rows, the "nobody suitable" line); CUT v13's firm road. The duck count off for the first six fights (`Matchmaking.note_choice` skipped while `ProLean.pro_fights` < 6).
6. **The favour:** `pro_favour` on the fighter; +1 / -1 at the debut pick and in `book`; the title row at 8 with 4 pro wins (ticket house); +$300 a purse (guarantee house); under 3 the 4-day set of the house's kind.
7. The asks: CUT five; Later +2 only with a cause.
8. The screens of section 7: the debut cards, the favour head, the row line, the result and week-review lines.
Tests that pin today's numbers and will move: `tests/pro_call_test.gd`, `tests/pro_offer_wire_test.gd`, `tests/debut_pick_test.gd`, `tests/debut_read_test.gd`, `tests/pro_ladder_test.gd` (the debut on the table, both kinds, the favour), `tests/matchmaking_bots_test.gd` if it reads ducks inside the first six fights, and any test that reads +5 reputation after a tune-up win.

## 12. Cut list
- **CUT in v14 -** v13's firm road (the house removing a kind); the per-house debutant style; "the name pays back the cash by week 40"; the cost of a debut loss as a quoted number; the room line as an instruction; the three gym money rows on the house card; the duck line on the road; the short-notice tune-up state test; the "+5" printed on every row as the only number (each row now carries its own).
- **Not taken from the critics (each a new system) -** switching house after fight 3; the boxer's wish; a same-year debutant on the other road; an open night for seats; fewer seats after a debut loss; a one-click move to bigger premises.
- **CUT, kept from v13 and before -** every ask but Later +2; the $1,400 guarantee purse; the forgiven loss; loyalty from the boxer's pay; the wish; "won't" buttons; the step and top promise; the assumed $75 a week and the pays-back sentence; a dollar rate for morale or loyalty; the new fees and the manager's licence; a stipend switch on the hold; v9's loan, queue and versioned contract pay; raising the aims of each house's own night.
