# Turning pro - design map v16 (v15 with the code-checked critic's list taken in order: the favour is spent, the ticket house's tune-up is a home night, the guarantee house's test night takes the last seat, the big club meets both houses, the payday leaves the road)

S540, TURNPRO16 worker session. Task: `ops/research/TASK_TURNPRO16.md`. ONE clean document: v15's override section is folded in, every "+2", "4 days" and "only its own kind" text is gone, the three FALSE code claims and the moved lines the v15 critic found are fixed (section 1). Scope as v15: from the pro call to the debut and the five sets of offers after it (the road); the ladder after that is a handoff.
Method (owner S530/S531): **CODE** = file, function, lines (v15's citations as the code-checked critic re-opened them at `ee2e54762`, plus the lines v16 adds, opened at `c78a9efca`). **ESTIMATE** = a proposal or a measured number that is not code. **CUT** = do not build or show it. No game file was changed.
**PROBED (S540):** NOT YET. The probe was written and timed (one roll = 48 careers in 130-170 s) and its bars fixed (section 9) before the batch started at 11:56 on 23 Nov; Claude Code's low-memory guard stopped it during stage A (the PC had 794 MB free of 32 GB, mostly other apps). No result exists; nothing below is measured by probe 16. Rerun command: `python ops/Tools/godot_slot.py run --who TURNPRO16 -- sh <batch>` (stage A, B at 9 call weeks a boxer, F at 2), about 2 h 35 min.
Inputs: map v15 and its probe (`docs/TURNPROBE15_RESULT.md`, 17 of 17); the code-checked v15 critic, 6 / 6 / 6 (`ops/research/DESIGN_TURNPRO1_V15_CRITIC_OPUS.md`); Kalli and Dola's v15 critics (SQ304, SQ305) had not answered when v16 was written; owner S534: 8+ on DEPTH and PLAY, probe first, free hand to remove, add or interconnect.

Words: the **ticket house** = Bow Lane. The **guarantee house** = Harrow & Finch. **Seats** = tickets the boxer sells. **The name** = the gym's reputation. **A tune-up** = a pro fight offered as one (green chip); **a step up** = a ranked name above the boxer (gold chip). **The road** = the debut and the five sets of offers after it. **Favour** = how the boxer's house feels about your gym, 0 to 10. **Top of the bill** = favour 8+; **bottom of the bill** = favour under 3.

## 0. What v16 changes (ESTIMATE, sized by probe 16)
The critic's core finding: "do what the house wants is never wrong" - the favour only piled up, so obeying was a habit, not a decision. v16 makes obeying cost something and gives each house's other road a reason.
1. **The favour is spent (critic item 1).** At favour 8+ either house puts its **area title shot** on the set for **3 favour** (any record; it drops the boxer from the top of the bill until the favour is rebuilt). The ticket house's free shot (favour 8 and 4 pro wins) stays. Under 3 the house dates a fight 3 weeks late **unless it is the house's own kind**: one booking of its kind lifts the late date for that night. The spend is a WHEN question: spend early on a shot read 50, or keep the top-of-the-bill money and wait.
2. **The ticket house's tune-up is a home night (critic item 2).** A tune-up (or rebuild fight) with the ticket house is a small-hall night where the club sells its seats: the gym is paid **$10 a seat the boxer sells** (`ProOfferWire.forecast` on the night; about $600-700 a fight at 60-70 seats). A **step-up or title LOSS** on the ticket house's posters costs **2 favour**. So at the ticket house the tune-up is the cash road and the step up the name and rank road, and a step up read 40 is a risk to the favour, not a free swing.
3. **The guarantee house's test night won takes the table's last seat (critic item 3)**, as at the ticket house; the name by seats stays 1 for every 8.
4. **The big club meets both houses (critic item 6).** At 75+ seats the guarantee house counter-calls: its usual terms and debutants, and **$500 to the gym at signing**. Probe 15 skipped 142 of 216 full-gym calls because one house called.
5. **No payday row on the road (critic item 11).** No bot booked one in 2,000+ road sets; the first six pro fights offer a tune-up, a step up and, when open, a title shot. After the road the payday is as today.
6. **The bars (critic items 4, 5, 9, 10):** the road is read on cash, name and RANKED share with no record axis; a READER bot must beat every fixed road (the depth bar); stage F reads keeper against name-chaser at the guarantee house with the favour's rewards on and off; bars true by construction are instruments; the card's cost is timed; every option is read against a no-pro control (section 9).
7. **The two v15 rewards and the new ones are on screens (critic item 7):** section 7 names a menu for top of the bill, the late date, the spend, the home night, the poster loss and the counter-call.



## 1. What the game does today (CODE only; v15's section with the v15 critic's corrections at `ee2e54762`: three FALSE claims fixed, two partly-true ones restated, moved lines updated)

### The call
- **CODE - `scripts/state/Roster.gd` `check_pro` :200-214:** one offer at a time. With one open, the function only runs the lapse check (:201-205). Otherwise the first boxer in roster order who is `pro_ready`, has waited out a lapse, has no bout booked and is not in a championship run gets the call. It is called from `Sim.gd` :414, `Bouts.gd` :466, `BoutFinish.gd` :222 (and the test jump, `TestJump.gd` :167, :195).
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
- **CODE - `scripts/rules/DebutOpp.gd` consts :15-17, `name_for` :22-24, `rating` :32-33, `make` :37-41:** every debutant is a 0-0 "Boxer-puncher" with "Heavy right hand" and "Fades after round 3" (one set of constants for both houses), rated the boxer's no-camp strength less the gap. By house only the name, the gap and the club line ("(house) stable", :39) differ; the name list is by sex. **v16 keeps this: no per-house style** (v13's probe gave each house its own style; that is dropped).
- **CODE - `scripts/rules/BoutRead.gd` `_read_copy` :272, `_games` :277-280, `_tiring` :301, `_round_edges` :328, :337:** the read does use the opponent's style (the mix of games, and the plan the coach writes against that style) and three scouting words ("walks in", "Fades", a body threat). So a different style per house would change the bout, with no new system.
- **CODE - `Roster.turn_pro` :305-309, `debut_day` :319-320:** signing books that debutant for the Saturday `debut_weeks` out, 4 rounds; the rating is taken from the boxer's stats on the signing day.
- **CODE - `scripts/state/ProLean.gd` `LEAN_FIGHTS` :7, `LEAN_KIND` :8, `extra` :12-33; `scripts/state/ProLadder.gd` :23-25, :204-214:** for the first 6 pro fights, **the debut counted** (`pro_fights` = pro_w + pro_l + pro_d, :36-37), so the debut and the five sets after it, the house ADDS one row to each set of offers: a second tune-up (nearest a read of 0.82, inside 0.70-0.93) for the guarantee house, a second step up (nearest 0.50) for the ticket house. The plain set (one tune-up, one step up, one payday) is still there, so the lean widens the choice; it never forces a fight.

### Signing
- **CODE - `ProDebut.start_costs` :18-24, `Roster.turn_pro` :275-282:** the gym pays at signing: $230 licence, $875 medicals if never licensed, $140 if the coach has no pro licence ($1,245 at most), unless the costs ask was taken.
- **CODE - `Roster.signing_share` :223-224, `turn_pro` :288-291; `scripts/rules/Loyalty.gd` `pro_share` :230-233, `MOVES` :61:** the gym keeps 25% of the boxer's money; under 50 loyalty an outside manager signs the boxer and the gym keeps 10%. Signing then adds 5 loyalty, after the share was read.
- **CODE - `ProCall.morale` :298-308, `ambition_kind` :312-318; `scripts/rules/Recruit.gd` `ambition` :122-126; `ProOfferWire.morale_line` :162-170:** a boxer's goal reads "A regional title within a year" (potential 78 or more) or "A winning record by the summer". Only the title goal moves morale: signing costs 5 while the boxer could still enter the nationals (`Champs.check`, `scripts/state/Champs.gd` :40-41). No goal contains "pro", so the +5 / -5 branch (:300-301) never runs.
- **CODE - `Roster.turn_pro` :301-303, :307; `scripts/state/Bouts.gd` `accept` :194-201:** the stipend ends and open amateur offers are closed. `turn_pro` writes the debut over `f["bout"]` without checking it is empty, and `accept` (lines opened) does not look at the open pro offer.

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
- **CODE - `scripts/rules/FighterProfile.gd` :25, `scripts/rules/AskDates.gd` `wait_words` :119-122:** "month_no_fight: -6" is READ once, as words: the sentence "A month without a fight costs 6 morale" was CUT in S539 (`AskDates.wait_words` :119-122 now returns only the wait for the sheet; comment :120). `FighterProfile.MORALE_EVENTS` still holds `month_no_fight: -6` (:25) and nothing applies it. Not part of turning pro; build item 0 is DONE.

### The night and what it leaves (the part v10 priced only in members)
- **CODE - `scripts/state/BoutFinish.gd` :92, :114-119; `Roster.debut_night` :247-251; `ProOfferWire.night` :133-142:** the debut pays on the seats counted ON THE NIGHT. The ledger label prints 25% even when the cut was 10% (:114-115).
- **CODE - `BoutFinish.gd` :94-109 (members :99, reputation :101, `Attrs.wear_stoppage` :104-105); `scripts/rules/BoutRules.gd` :114-123:** a win brings 8 members and 5 reputation. A loss costs 1 member and 2 reputation; a stopped loss 2 and 4. The same for both houses.
- **CODE - `BoutFinish.gd` :179; `FighterProfile.MORALE_EVENTS` :18-20, `apply_morale` :147-170:** morale +8 on a win (x0.9 to 1.1 by confidence), -12 on a loss (x1.3 to 0.7 by heart).
- **CODE - `BoutFinish.gd` :180-181; `Loyalty.MOVES` :60:** loyalty +2 on a win, -1 on a loss, -3 when stopped.
- **CODE - `BoutFinish.gd` :104-105; `scripts/rules/Attrs.gd` `wear_stoppage` :127-129, `STOP_DROP` :42:** a stoppage loss (not a corner retirement) lowers the boxer's durability ceiling by 2 for good.
- **CODE - `scripts/rules/Membership.gd` :15-16, :19, :29, `step_members` :45-53:** the gym can carry 48 members + 0.6 a reputation point (before the dues band); the count walks a quarter of the gap a week, 6 at most. So reputation is members later, and seats can grow between signing and the night.
- **CODE - `ProLadder.result` :372-378:** the debut has no ladder opponent, so the function joins the boxer to the table and returns; the debut's result is not applied to a rank there.
- **CODE - `BoutFinish.gd` :120-125; `scripts/rules/Matchmaking.gd` `PURSE_UNRANKED` :50, `pay_of` :216-218:** later pro fights pay from the ladder ($1,500 unranked). `f["purse"]` steps up after a win (:125) but the booked purse comes from `pay_of` (`ProLadder.book` :355, :361). The contract's step and top, shown on the card (:155) and promised in the week review (`scripts/ui/ProWeekLines.gd` `next_line` :46-50), are never paid.
- **CODE - `ProWeekLines.lines_for` :15-42:** for 28 days after signing the review shows "amateur cut lost / stipend saved" with the assumed $75 a week; in the debut's week a ledger line (share, costs, net).
- **CODE - `scripts/state/GymDeals.gd` `pro_camp` :22-35:** the debut has no camp bill; a cutman on staff is still charged.

### The table after the debut (new in v12; lines re-read for v13)
- **CODE - `scripts/state/BoutFinish.gd` `run` :94-106, :110:** the debut's result is booked as any bout's: `pro_w` / `pro_l`, +8 members and +5 reputation on a win, -1 member and -2 reputation on a loss (-2 and -4 when stopped), then `ProLadder.result`.
- **CODE - `scripts/state/ProLadder.gd` `result` :372-378, `join` :93-107; `scripts/rules/Matchmaking.gd` `join` :68-82:** the debut has no table opponent (`opp_id == 0`, :377), so the function joins the boxer to the table and returns. The boxer arrives unranked, 0 fans, no rebuild flag, with the debut's record copied (:102-104). **A debut loss leaves no mark on the table; a debut win earns nothing there.**
- **CODE - `Matchmaking.apply_result` :230-270 (fans :242), `loss_fans` :290-291:** every LATER pro fight moves fans (+1 a win, +1 more for a step up, +1 for a stoppage, -1 for a mismatch 6 points under; a loss costs 0 to 2 by how the fight looked), sets `rebuild` on a loss (:252) and clears it on a win (:245).
- **CODE - `ProLadder._make_offers` :175-216 (:209), `Matchmaking.ask` :180-192 (:188-189):** while `rebuild` is set the promoter offers no step up and refuses an ask above the boxer's place.
- **CODE - `ProLadder._review_streak` :407-420, `REVIEW_WINS` :37:** an unranked boxer with 5 wins and a winning record is given the table's last ranked seat.
- **CODE - `Matchmaking.pay_of` :216-225, constants :50-53:** an unranked boxer's purse is $1,500; a ranked one's is $1,500 + $400 for every place above the bottom of a 20-place table; a ranked name above adds $150 x (21 less that name's rank) (:220-221: it grows with how high the name sits, not with the places between); tickets are $150 x (fans + 5) x closeness. The gym keeps a quarter (`GYM_SHARE` :56).
- **CODE - `ProLadder.book` :337-368 (:360-361), `LEAD_DAYS` :32; `Matchmaking.next_weeks` :283-285:** a booked pro fight is six weeks out; the next night is 6 weeks after a mismatch, 8 after a level fight, 12 after a step up, 8 more after a stopped loss.
- **CODE - `scripts/state/ProLean.gd` `extra` :12-33, `LEAN_FIGHTS` :7, `LEAN_KIND` :8:** for the first 6 pro fights the house ADDS a row (a second tune-up or a second step up); the plain set stays, so today the lean never removes a fight from the table.

### The name and the room (new in v12; lines re-read for v13)
- **CODE - `scripts/rules/BoutRules.gd` `WIN_MEMBERS` :114, `WIN_REPUTATION` :115; `scripts/state/BoutFinish.gd` :99, :101:** every win pays 8 members and 5 reputation, whoever was beaten (only a short-notice win doubles the 5). The table already tells a soft win from a real one for FANS (`Matchmaking.apply_result` :242: a mismatch 6 points under, `SOFT_GAP` :43, costs the win one fan) and for growth (:236), but the gym's name does not. So a road of tune-ups buys the same name as a road of step ups, one win at a time.
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
- **CODE - `scripts/rules/DebutOpp.gd` `name_for` :22-24:** the debutant's name is `names[posmod(day + promoter.length(), 4)]`: it takes NO index, so two debutants of the same house on the same day get the SAME name (v15 said "the next name on the list": FALSE, a proposal). Build item 2 adds an index argument; the probe's two debutants share a name, which changes nothing it measures.

### The lines v16 adds (CODE, opened in this session at `c78a9efca`)
- **CODE - `scripts/state/ProLadder.gd` `offer_rows` :273-282:** every row the Fights screen shows carries its offer dictionary (`"offer": o`) and its kind. A row bought with the favour is one more offer with a flag; no new list.
- **CODE - `scripts/rules/Matchmaking.gd` `next_weeks` :283-285:** 6 weeks after a fight 6+ points under (`QUICK_WEEKS`), 12 after one 2+ over (`HARD_WEEKS`), else 8 (`NEXT_WEEKS`); 8 more after a stopped loss. **A tune-up is picked by read (0.70-0.93), not by gap, so it is usually an 8-week night** (v15 said 6: FALSE).
- **CODE - `scripts/state/ProOfferWire.gd` `make` :25-41, `forecast` :19-21; `scripts/rules/ProCall.gd` `who_calls`:** at 75 seats or more only the ticket house's terms are made; the guarantee house's terms come from the same `ProCall.terms` + `DebutPick.apply` (:38-39) whenever its key is in the list, so a counter-call is one more key, not a new search. `forecast` is the seats a boxer sells today (members, wins, titles, followers), the number a home night pays on.

## 2. The human question (the brief)
A manager with a new pro picks each early opponent with the promoter - "keep your boxer busy" against "test your boxer" - keeps the promoter sweet so the good dates keep coming, and cashes that goodwill in for something concrete (the title shot, the better night). Sometimes the manager refuses the house's pick because the boxer needs a different fight. Obeying the house must cost something.

## 3. The three decisions (ESTIMATE; probe 16 sizes every number)

### 3a. The house
| | The ticket house | The guarantee house |
|---|---|---|
| Calls when | 46+ seats (CODE `ProCall.who_calls`) | 74 or fewer; **v16: also at 75+, as a counter-call with $500 to the gym at signing** |
| The debut | 4 weeks out; its own night is the TEST | 6 weeks out; its own night is the BUILD |
| The kind it prefers | step ups (CODE `ProLean.LEAN_KIND` :8) | tune-ups |
| Top of the bill (8+) | $250 to the gym a fight (its ticket block); the area title shot FREE after 4 pro wins, or BOUGHT for 3 favour before | $250 to the gym a fight; $300 more a purse (the boxer's); the area title shot BOUGHT for 3 favour |
| Its other road | the tune-up is a HOME NIGHT: $10 a seat to the gym | the step up: +5 name and a ranked place, at the cost of the favour |
| What it punishes | a step-up or title loss: -2 favour | a step up booked over its tune-up: -1 favour |
| The money | the purse as today, shown small, not a lever | the same |

### 3b. The debut night (the player picks one of two)
| | Test | Build |
|---|---|---|
| The ticket house | the card reads about 60. A win: +5 reputation **and +1 for every 4 seats sold (20 at most), and the table's last seat**. Favour +1 | about 70. A win: +5. Favour -1 |
| The guarantee house | about 68. A win: +5 **and +1 for every 8 seats sold (20 at most), and (v16) the table's last seat**. Favour -1 | about 78 (owner: "78 is fine"). A win: +5. Favour +1 |
| A loss, either night | reputation -2 (-4 stopped) as today; a rebuild fight before any step up; fans by how it looked (CODE `Matchmaking.loss_fans` :290-291) | the same |
- Both debutants come from `DebutPick`'s own search (CODE `pick` :48-67) on the card of section 5, once at each aim; the house's misjudgement for this boxer moves both alike. Same style and threat (CODE `DebutOpp` :15-17), a different rating; the build gives `name_for` an index so the names differ (section 1, F1).
- Owner ruling Q-286 ("Pick to each boxer") holds: the promoter picks each debutant to this boxer; the player picks between the two it found.

### 3c. The kind of each fight on the road
- **Every road set carries a tune-up AND a step up** at both houses (the house's lean row from `ProLean.extra` :12-33 stays; where a kind is missing the nearest the table holds is added, tune band widened to 0.60-0.97). **No payday row on the road (v16).** No kind to be found: one line ("No tune-up this time: nobody suitable is free"), and booking the other kind moves no favour.
- **After a loss** the game's rule stands: no step up until a rebuild win (CODE `_make_offers` :209, `Matchmaking.ask` :188-189). The tune-ups of that set are REBUILD fights: a win pays +5, no favour move; at the ticket house a rebuild fight is a home night too.
- **What a booking and a win make** (the booking keeps the kind: `ProLadder.book` :360-362 gains `kind`; `BoutFinish.gd` :101 reads it):

| The fight booked | A win makes | Favour, ticket house | Favour, guarantee house | Money to the gym beside the purse share |
|---|---|---|---|---|
| Tune-up | +1 reputation ("an easy win is not news") | -1 | +1 | ticket house: $10 a seat sold (home night) |
| Step up (offered, or a name the player asks for) | +5 | +1; **a loss -2** | -1 | - |
| Area title shot, free (ticket house, 8+, 4 wins) | +5 and the belt | +1; **a loss -2** | - | - |
| Area title shot, bought (either house, 8+) | +5 and the belt | **-3 at booking**; a loss -2 more | **-3 at booking** | - |
| Rebuild fight | +5 | 0 | 0 | ticket house: home night |
| Any fight booked at favour 8+ | - | - | - | $250 (top of the bill); guarantee house +$300 to the purse |
| Any fight booked under 3, not the house's kind | dated 3 weeks later | | | |
The members (+8), the purse and the fans are as today. A refusal (-1) counts only when the house's kind was on the table.
- **What already pulls the kinds apart** (CODE, corrected): a tune-up is read near 82 in 100 and moves no place; the next fight is usually **8 weeks** later (`next_weeks` :283-285: 6 only when 6+ points under). A step up is read near 50, takes the beaten name's place (a ranked purse, `pay_of` :216-225) and, when the name is rated 2+ above, a fan more and 12 weeks to the next fight.

### 3d. House favour
- **One number a boxer, 0 to 10, starting at 5**, kept on the fighter with the house. It moves on the debut night picked (+1 / -1), on every booking (3c's table) and on a ticket-house loss on its posters (-2).
- **Top of the bill (8+):** the club's ticket block ($250 a fight), the guarantee house's +$300 a purse, and the **title shot on the set** (free at the ticket house after 4 wins, otherwise bought for 3).
- **Bottom of the bill (under 3):** a fight dated 3 weeks later, unless it is the house's own kind.
- **The duck count sleeps on the road** (CODE `Matchmaking.note_choice` :196-201): the favour is the promoter's patience there, on screen. After the road the duck rule runs as today.
- **Why it is a decision now:** the favour is a stock with a price. Keeping it pays $250 a fight; spending 3 buys a 10-round shot at a belt the boxer may lose; at the ticket house a lost step up burns 2 of it; at the guarantee house every step up costs 1. Which is right depends on the read of the shot, the boxer's last night and how far the favour is from 8.

## 4. The asks
| House | Ask | v16 |
|---|---|---|
| Both | **Later +2 weeks** | $150 off the purse (CODE `ProCall._apply_later` :197-201), the card shows about +2. **Drawn only when the boxer has a cause** (an injury or a weight to make on the debut day). A calendar tool |
| - | Softer, own ticket price, costs from the purse, better split, later +4 | **CUT** (probes 11 and 12) |

## 5. The card, the seats, the hold
- **The card reads the boxer's own nights.** When a house calls, the game plays this boxer's debut ahead, camp included, against two of the house's possible debutants (one the plain read puts at 72, one at 50), and lays what those nights add to the read on a straight line between them; every card of that house for this call reads off that line. Each card prints a band, not a point ("about 60, 56 to 64").
- **Its price (critic item 9, measured):** one hidden bout costs about 24 ms on this PC (timed in the probe's trial roll: 23.2 to 24.8 ms over 2,000 bouts), so v15's 2,000 own nights would cost 48 s at the call. **Build rule:** 400 nights a debutant (a band of about +/-5), computed once when the call is made and kept on the offer (the read does not change while the offer stands: the camp has not started); the call costs about 20 seconds on one thread, spread over the first day of the call (the offer letter opens the next morning). A save from before keeps the plain read.
- **Seats on the night:** one dashed number on the ticket bar, drawn on the TEST nights only.
- **The room, as arithmetic:** "Room for N more members. 3 reputation brings about 2." No sentence telling the player which house to pick.
- **The hold, Stay amateur, the honest ledger, names only in headers:** v13's, unchanged.

## 6. The v15 critics' lists, item by item
| # | Critic's item (code-checked Opus critic, "To reach 10/10") | v16 | Where |
|---|---|---|---|
| 1 | Make favour spendable; a spender bot; a bar | **Taken:** spend 3 at 8+ on the title shot at either house; under 3 the house's kind lifts the late date. The "name one band up" and "top of the bill for one fight" spends are NOT taken (each a second spend menu; one spend first). Bar S | 0, 3c, 3d, 9 |
| 2 | Give the ticket house's tune-up a reason | **Taken, both halves in spirit:** a step-up loss costs 2 favour (the critic's proposal), and the tune-up is a home night ($10 a seat). Bar T | 3a, 3c |
| 3 | The guarantee house's test night: reward or cut | **Rewarded:** a test win there takes the table's last seat. Bar 16 is read per house (16t, 16g) | 3b, 9 |
| 4 | Bars 7, 8, 11 without the record axis; a READER bot that must beat every fixed bot | **Taken:** ranked share replaces the record; the reader bar R is an audit bar | 9 |
| 5 | Stage F keeper against name-chaser at the guarantee house, favour on and off | **Taken:** bar F | 9 |
| 6 | A choice for the big gym | **Taken:** the counter-call with $500 at signing. Bar G; the share of real calls reading | 3a, 9 |
| 7 | The two v15 rewards on screens | **Taken** (and the new ones) | 7 |
| 8 | One document | **Taken:** this map | all |
| 9 | Price the card | **Taken:** timed, a build rule | 5 |
| 10 | Measure against a no-pro control | **Taken:** the AMATEUR arm (a reading) | 9 |
| 11 | The payday row on the road | **Cut on the road** | 3c |
| Missing | "The house asks YOU" (a short-notice slot for favour) | **Not in v16** (a new event; first see whether the spend alone makes the favour a decision) | 12 |
| Missing | A reason to read the boxer (stoppage, morale) | **Partly:** the reader bot reads the last night and the read; the game's own rule already adds 8 weeks after a stopped loss. A morale effect of the kind is NOT taken | 9, 12 |


## 7. Where it appears: CODE TODAY against TO BUILD (every menu the mechanic shows on, and what each is wired to)
| Menu | CODE TODAY (file, function, lines) | Wired to today | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|---|
| Top bar flag | `Needs.flags` :167-168 | red PRO OFFER, act "prooffer" | amber; days left |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83 | `Needs.blockers` :140-141 | runs while the offer is held; one stop on the last day |
| Home, needs | `Needs.needs` :67-70 | act "prooffer", "Hear it" | amber; roles, not names |
| **The offer letter: header** | `scripts/ui/modals/ProOffer.gd` `build` :35-45 | `ProOfferWire.days_left`, `ProCall.age_line` | at 75+ seats: "BOTH HOUSES CALLED - the guarantee house counters with $500 to the club at signing" |
| **The offer letter: ticket bar** | `ProOffer._tickets` :90-106 | one mark at 60 | both marks; seats on the night (dashed) with the hover "A test night won: 1 reputation for every 4 seats (ticket house) or 8 (guarantee house), and the table's last seat" |
| **The offer letter: house card** | `ProOffer._house` :110-170 | `DebutRead.card`, `DebutPick.line/tip`, `ProOfferWire.money` | head THE TICKET HOUSE / THE GUARANTEE HOUSE; two role lines ("prefers step ups; a tune-up with it is a home night, $10 a seat to the club; a lost step up costs 2 favour" / "prefers tune-ups; at favour 8 $300 more a purse"); the counter's $500 on the guarantee card when it counters; **the two DEBUT CARDS**; the room line as arithmetic; the boxer's take on the night. CUT: the three gym money rows, step/top, weekly-after, pays-back, "+N loyalty" |
| **The debut card (two a house)** | none (one "VS (name)" line, :139-143) | `DebutPick.apply` :71-78 keeps one `opp_gap` a house | the debutant's name, TEST or BUILD, the win chance as a band, "A win: +5 reputation" or "+5 and +1 for every 4 (8) seats: about +N tonight, and the table's last seat", "Favour +1" / "-1". Wired to two picks on the offer (`opp_gap_test`, `opp_gap_build`), the act "propick" (house, night), read by `Roster.turn_pro` :305 |
| **The offer letter: asks** | `ProOffer._ask` :174-195 | six buttons a house | Later +2, drawn only with its cause. CUT the other five |
| **The offer letter: foot** | `ProOffer.build` :56-81; acts "turnpro", "declinepro" (`RosterActs.gd` :90-95, :105-108) | `ProOfferWire.morale_line` | the weight table pick (section 8); Stay's true hover; "Sign with this house" |
| **Fights (pro): the head of NEXT FIGHT** | `scripts/ui/ProFights.gd` :117 (`ProLean.line` :41-47) | the lean's sentence | **the favour and the bill:** ten pips and one line by state - "Favour 8: TOP OF THE BILL - the club gets $250 a fight. Spend 3 for the title shot now, or keep it." / "Favour 6 of 10: two more of the house's fights put you top of the bill" / "Favour 2: BOTTOM OF THE BILL - fights 3 weeks late unless you take the house's kind". A small poster: MAIN EVENT / undercard with the boxer's slot marked. Wired to the fighter's `pro_favour` |
| **Fights (pro): each row** | `ProFights._row` :155-163 (`KIND_WORD` :21) | `ProLadder.offer_rows` :273-282 (kind from the offer) | beside the chip: the name a win makes ("+1 reputation" / "+5"), the favour it moves ("favour +1" / "-1"), and the house line where it applies ("home night: about +$650 to the club" on a ticket-house tune-up; "a loss: favour -2" on a ticket-house step up); the day struck through with "+3 weeks: bottom of the bill" when the booking would be late; a TITLE chip (free) and a **TITLE - SPEND 3 FAVOUR** button-row (bought: `offer.spend`); a REBUILD chip. Wired to the row's `kind` and `spend`, kept on the bout by `ProLadder.book` |
| **Fights (pro): name your opponent** | `ProFights.gd` :126, :142, :300; `ProLadder.ask_rows` :321-333 | act "probook" with "a" (`BoutActs.gd` :197-200) | each asked row reads STEP UP, "+5", and its favour move |
| Fighter, Next Step | `FighterPage.gd` :338, :344, :355-357; `NextStep.pro_line` :73-90 | tickets against each house, age, declines left | "Offer open, N days"; for a pro: the favour, the bill, and the next door ("2 more of the house's fights: top of the bill") |
| Fighter, contract | `FighterPage.gd` :144 | fixed text | the pro share, the house and the favour |
| Week review | `ProWeekLines.lines_for` :15-42, `rows` :62-75 | `f["pro_signed"]` | after every pro fight: the kind and its name ("Tune-up win: +1 reputation"), the favour ("Favour 7 of 10"), the house money ("Home night: +$650 to the club", "Top of the bill: +$250"), a poster loss ("The house lost a poster night: favour -2"); CUT the NEXT promise and the $75 line |
| Debut result | `BoutFinish.gd` :94-119; `Roster.debut_words` :254-261 | members, reputation, the pay label | the night picked (TEST / BUILD), the name by seats and the last seat after a test won (both houses); "a rebuild fight first" after a loss; the true share |
| Pro fight result | `BoutFinish.gd` :94-101, :173 | +8 members, +5 reputation on any win | the rank earned (S428), the name made by the kind, the favour after it, the bill's money; a title won shows the belt; a bought shot names what it cost ("You spent 3 favour on this night") |
| World, the pro table | `ProLadder.road` :423-438 | rank, fans, the rebuild line | the last seat after a test won; the area champion marked when the title shot is on the set |
| Money ledger | `MoneyPanels` :264 | the purse share | two new lines: "Home night (ticket house)" and "Ticket block (top of the bill)"; "Counter-call at signing" |
| World compare; Office desk; History; Toasts; Test jump | `WorldCompare` :269, `OfficeDesk` :42, `BoutHistory` :45, `RosterActs` :95, `TestJump` :195-197 | as today | roles in place of names in toasts |
Not reopened this session and not claimed: the top bar's drawing code, the home list's ordering, the week review modal's call site, the roster table, the world news feed.

## 8. The weight class at turning pro (a hook only)
Owned by WEIGHT2. The table pick appears on this call, in the offer's foot (CODE `ProLadder.division_for` :43-49). The probe runs every boxer on the table the code gives.

## 9. The probe and its bars (written before the run, S540; `tools/turnprobe16.gd`, rules copy `tools/turnprobe16_rules.gd`, tables `tools/turnprobe16_sum.py`, result `docs/TURNPROBE16_RESULT.md`)
- **Population and pairing: probe 15's** (the six people the game can sign, each called on different weeks; one call week = one roll). **Size (timed first):** one roll of stage B = 48 careers in about 130 s on one Godot slot (a hidden bout costs about 24 ms; 2.3 s a 40-week career), so the batch is stage A (6 boxers, 200 scratch nights a row, 500 own nights a card), stage B **9 call weeks a boxer (54 rolls)**, stage F **2 a boxer (12 rolls), 80 weeks**: about 2 h 35 min. Probe 15 had 216 rolls; the cash error line is widened to match (instrument I2).
- **Cells:** seats 48 and 64 with room, and a full gym ($12,000 in the bank), as probe 15. A club at 75+ seats now meets both houses (the counter-call), so no call is skipped for one house.
- **Arms.** V16 = sections 0b and 3 to 5. TODAY = the game's own functions (probe 13's bot); its costs ask is the MUTANT. FLAT = v16 with the tune-up name rule off (the win-chaser). AMATEUR = the call declined, the boxer stays amateur (the no-pro control, item 10). Stage F: the favour's rewards ON against OFF (the favour still moves, so the same fights are wanted).
- **Roads (bots).** name = the step up (a free title when there); win = the tune-up; keeper = the house's kind until favour 9, then the other kind (a free title read 45+); **spender** = the keeper that spends 3 favour on the title shot whenever the house offers it; **reader** = reads the moment: a free title read 45+, a bought one read 50+; at the ticket house a step up read 45+ unless the last fight was a stopped loss, else the home-night tune-up; at the guarantee house tune-ups to the top of the bill, then a step up read 45+ unless just stopped. Stage B option set: each house's own night x the five roads, the other night x keeper and reader.
- **Pass rules (lines fixed before the run).** A beats B when ahead by the line on one axis and not behind by the line on any other. THE HOUSE: gym cash $1,000, debut wins 3 in 100. **THE ROAD (no record axis, critic item 4):** gym cash $1,000, the name 3 reputation, **ranked share 10 points** (what the record buys). THE NIGHT: cash $1,000, debut wins 3, the name 3. The pro record is printed beside every road and is not an axis.

**Instruments (must all hold for the run to count; not scored):**
| # | Instrument |
|---|---|
| I1 | Today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100 |
| I2 | The error on every option's cash gap is $400 or less in every pooled cell (a $1,000 line is 2.5 errors; 54 rolls, not 216) |
| I3 | The card is honest (probe 15's bar 4): each debutant shown within 3 of played on the mean, no boxer's card more than 8 from its own nights. Honest by construction (the card IS the boxer's own nights), so it only checks noise and the line |
| I4 | Both kinds on 80%+ of the road's non-rebuild sets, at each house (probe 15's bar 17: measures the fill-in rule) |
| I5 | The name-chaser books 25+ points more step ups than the win-chaser, at each house (probe 15's bar 13: true by the bots' definition) |
| I6 | The card's cost: one hidden bout timed; the 2,000-bout card priced in seconds (a reading, item 9) |

**Scored bars (16):**
| # | Bar (bounds, never an exact count) |
|---|---|
| 3 | Played debut wins in 100: ticket test 52 to 68, ticket build 62 to 78, guarantee build 70 to 82, guarantee test 60 to 76 |
| 5 | The house is a trade somewhere: the ticket house (test, keeper) $1,000+ ahead and 3+ debut wins behind the plain guarantee house (build, keeper) in at least one cell |
| 6 | The house flips: the plain guarantee house beats it in at least one cell |
| 7 | AUDIT: inside a house no road (of the five) is the one answer in more than 6 of 10 house x gym cells, on cash / name / ranked |
| 8 | AUDIT: every FIXED road (name, win, keeper, spender) is right in at least one house x gym cell on cash / name / ranked, and in at least half the cells two roads differ by a line |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 debut wins |
| R | **AUDIT, the depth bar: the READER beats every fixed road (name, win, keeper, spender) by a line, house by house, in at least half the house x gym cells** (beats = the road rule above) |
| 10 | With the tune-up rule off the win-chaser ends 1+ reputation higher in every cell with room (the size of the rule; part two of probe 15's bar, true by construction, is dropped) |
| 11 | Boxer by boxer (boxer x house x gym, cash / name / ranked): no road the one answer in more than 6 cells of 10, every fixed road right in at least 2 |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 |
| 16t | The night at the TICKET house: test 3+ debut wins behind and 3+ name or $1,000 ahead in at least one gym cell, and neither night the one answer in more than 6 of 10 of the ticket house's cells |
| 16g | The same at the GUARANTEE house (critic item 3: read per house, not on the pool) |
| S | The spend is a choice: at each house the keeper and the spender differ by a line in at least one gym cell, and neither beats the other in more than 6 of 10 of that house's cells |
| T | The ticket house's tune-up has a reason: the win road is right (cash / name / ranked, no record) at the ticket house in at least 2 of 3 gym cells |
| F | The favour flips the road (stage F, critic item 5): at the guarantee house the verdict keeper against name-chaser (one beats, the other beats, a trade, no difference; cash / name / ranked) differs between the favour's rewards on and off in at least one gym cell |
| G | The big gym has a choice: in the full cell neither house's best own-night road beats the other house's best on the house axes (cash, debut wins) |
**PASS = 13 or more of the 16 with the four audit bars (7, 8, 9, R) all passing and every instrument holding.** Then two fresh critics (one code-checked), 8+ on DEPTH and 8+ on PLAY (owner S534).
**Readings (printed, not scored):** the debut loss's mark (probe 15's bar 12, unpaired); every option's cash and gym closure against the AMATEUR control in cell 64 (item 10); the share of real calls (the bot's own road, no forced members) at 46-74 seats (both houses today) and at 75+ (both houses only with the counter-call); probe 15's strict favour bar 15 (keeper gains, rebel loses), kept as a size; how often the spend row is offered and taken, and title wins from it; home-night pay a career.

**Result:** pending the rerun (see the PROBED line at the top).

## 10. Owner rulings kept
- The debut opponent is picked to each boxer (Q-286): `DebutPick` stays the one search, run at two aims.
- The guarantee house about 75 in 100, "78 is fine": its own night is the build at 78 on the card.
- Names only in headers (S448). Only actionable information (C443): no gap, no aim; the favour, the bill and the spend are shown because every booking moves them.
- Tooltips explain (S532): "+1 reputation" says why ("an easy win is not news"); the favour hover says what top and bottom of the bill do and what a spend buys; the home-night hover says where the $10 a seat comes from.
- Every fight shows the rank earned (S428). Amateur bouts need no camp (S428): untouched. The normal game starts with no boxer signed (S487): untouched.
- Board text short. After two critics at 8+: "Turning pro: pick the night, then each fight. Keep the house sweet, spend its favour, or go your own way. OK to build?"

## 11. Build order (ESTIMATE; nothing here is built)
0. **DONE (S539):** the "month without a fight" sentence is cut (`AskDates.wait_words` :119-122).
1. The hold (v10): amber, daily lapse, the booking guard, the loyalty pause. Red test first: Continue with an open offer must advance the day.
2. The card reads the boxer's own nights, priced (section 5), with a band; **two debutants a house** (`DebutPick` at two aims, `DebutOpp.name_for` gains an index, the act "propick").
3. The debut counts on the table: fans, the rebuild flag (`ProLadder.result` :376-378 no longer returns early for the debut); a test won: the name by seats and the last seat, at both houses.
4. **The kind on the bout:** `ProLadder.book` keeps `kind` and `spend`; `BoutFinish.gd` :101 pays 1 for a tune-up win.
5. **Both kinds on every road set**, no payday on the road, the "nobody suitable" line; the duck count off for the first six fights.
6. **The favour:** `pro_favour` on the fighter; the moves of 3c; top of the bill ($250 block, +$300 purse); bottom (3 weeks late unless the house's kind); the title row free (ticket, 8+, 4 wins) and bought (8+, -3); the poster loss (-2) in `BoutFinish`.
7. **The house money:** the ticket-house home night ($10 a seat on the night) and the counter-call ($500 at signing, `ProOfferWire.make` adds the guarantee key at 75+).
8. The asks: CUT five; Later +2 only with a cause.
9. The screens of section 7.
Tests that pin today's numbers and will move: `tests/pro_call_test.gd`, `tests/pro_offer_wire_test.gd`, `tests/debut_pick_test.gd`, `tests/debut_read_test.gd`, `tests/pro_ladder_test.gd`, `tests/matchmaking_bots_test.gd` if it reads ducks inside the first six fights, and any test that reads +5 reputation after a tune-up win.
**State tests for the build:** last day and reload; a double press on Sign; the night picked then the house changed; an old save's offer with one debutant a house; a debut loss then the first set (no step up, REBUILD chips, +5, a home night at the ticket house); a set with no tune-up to be found; favour at 0 and at 10 (clamped); the bought title row at 8 (and not at 7); spending 3 at 8 drops the bill to 5 (no $250 on the next booking); the free title row at the ticket house with 4 wins (no spend); a step-up loss at the ticket house (-2, never under 0); favour 2 then the house's kind booked (not late) and the other kind (late); a 75-seat call (both houses, $500 once at signing); an old save's booked pro fight with no kind (pays 5).
**Golden path:** call, pick the test night, sign, debut, the name and the seat on the result page, the first set with both kinds and the favour pips, one tune-up win at the ticket house with its "+1" and home-night lines in the week review, the favour at 8 and the TITLE - SPEND 3 row on the next set.

## 12. Cut list
- **CUT in v16 -** the payday row on the road; "under 3 the house brings only its own kind" and "offers stand 4 days" (cut in v15, now gone from every section); "+2" for a tune-up win (it is +1); the record as a road axis in the probe.
- **Not taken (each a new system) -** "the house asks you" (a short-notice slot for favour); two more spend menus (a name one band up; one fight at the top of the bill); a morale effect of the kind; switching house after fight 3; the boxer's wish; a same-year debutant on the other road; fewer seats after a debut loss; a one-click move to bigger premises.
- **CUT, kept from v13-v15 -** v13's firm road; the per-house debutant style; every ask but Later +2; the $1,400 guarantee purse; the forgiven loss; loyalty from the boxer's pay; "won't" buttons; the step and top promise; the assumed $75 a week and the pays-back sentence; a dollar rate for morale or loyalty; v9's loan, queue and versioned contract pay; raising the aims of each house's own night.
