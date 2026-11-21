# Turning pro — design map v10 (written from the code at main b47d9ad57)

S534, TURNPRO10 side console. Scope: the pro offer, from the call to the debut's money. The pro ladder after the debut is a handoff only.
Method (owner S530/S531: maps come from the code): section 1 is written only from files opened for this map at main `b47d9ad5766dba7c09e96333616584f9e877efc9`. **CODE** = file, function, lines, true at that commit. **ESTIMATE** = a proposal, a sum worked on paper from the code's formulas, or a measured result that is not code. **CUT** = do not build or show it. Godot was not run. No game file was changed.
One file differs in the working tree: `scripts/ui/modals/ProOffer.gd` carries another session's uncommitted edit (the debutant's name moves from the Debut row to a "VS NAME" line in the card head). Line numbers below are the committed file.
Inputs: map v9; its two critics (John 6/6/7, Dola 7/8/7); `docs/TURNPRO6_RESULT.md` (66,000 played bouts); `docs/DEBUTPICK1_RESULT.md` (13,200 played bouts). Prior research run: `python ops/Tools/prior_research.py turning pro debut offer` (v1-v9 and their critics; this map follows v9 as corrected by TURNPRO6 and DEBUTPICK1).

Words: the **bigger gate** = Bow Lane, the house that pays from tickets. The **safer start** = Harrow & Finch, the house that guarantees the purse. **Sales** = the debut tickets the boxer would sell today. **Gap** = rating points the debutant sits under the boxer (a higher gap is an easier night).

## 0. What changed since v9, in six lines
1. BUILT: each house picks the debutant to fit the boxer (aim 60 in 100 and 75 in 100). v9's fixed gaps and every TURNGAP1 number are gone.
2. BUILT: the card shows the win chance of the bout as it will be fought, and names the debutant and why the house picked them.
3. BUILT: morale is off the buttons; one MORALE line gives the reason.
4. STILL TRUE: the offer cannot be held (it blocks time), the safer start pays more at every sales count where both call, four of six ask buttons are free or dead, the contract's step and top are promised but never paid.
5. v10's core change: make the two houses a real fork (section 3), cut the asks to three a house with a price each (section 4), make the hold real (section 5), show three honest money numbers (section 6).
6. v10 drops v9's loan, queue, versioned contract pay and `ProMoney.quote`: each was a new system for a one-night decision. The cheaper answer is in sections 5-6.

## 1. What the game does today (CODE only)

### The call
- **CODE — `scripts/state/Roster.gd` `check_pro` :200-214:** one offer at a time. While one is open the function only runs the lapse check (:201-205). Otherwise the first boxer in roster order who is `pro_ready`, has waited out a lapse, has no bout booked and is not in a championship run gets the call (:206-214). Called from `Sim.end_week` (`scripts/state/Sim.gd` :415), `Bouts.gd` :457 and `BoutFinish.gd` :219 only.
- **CODE — `Roster.gd` `pro_ready` :186-196:** a pro or a boxer with 3 declines gets none. A national finalist with 0 declines is ready at any record. 0 declines: 7 wins and rank 1-3, or 9 wins. 1 decline: 9 wins and rank 1-3, or 11 wins. 2 declines: rank 1 only.
- **CODE — `scripts/state/ProOfferWire.gd` `make` :25-41, `scripts/rules/ProCall.gd` `calls_open` :331-332:** no first call at 32 or older (a boxer who has declined is not age-checked). `scripts/rules/NextStep.gd` `road` :50 never checks age, so the Pro offer step can show done for a boxer who will never be called.
- **CODE — `scripts/rules/ProDebut.gd` `tickets_sold` :27-32, `ProOfferWire.forecast` :20-21:** sales = 20 + half the members + 2 a win + 10 a title + club-show followers, capped at 100.
- **CODE — `ProCall.who_calls` :63-69:** 75 or more: the bigger gate alone. 45 or fewer: the safer start alone. 46 to 74: both.
- **CODE — `ProOfferWire.make` :31-33, `on_decline` :181-183:** after a Stay, one house calls alone at any sales count: `offers[0]`, which is the bigger gate whenever both called (list order, not a rule).
- **CODE — `ProCall.terms` :73-95:** each decline multiplies purse, step and top by 0.9, unless a title came since.

### The two houses
- **CODE — `ProCall.promoters` :35-59:** bigger gate: $1,500 purse, break-even 60, 50% of tickets past it, debut 4 weeks out. Safer start: $1,800 guaranteed, break-even 70, 30% past it, debut 6 weeks out. Each also carries step, top and a fixed `opp_gap` (3.0 / 6.0) that the pick below replaces.
- **CODE — `ProCall.debut_purse` :99-108:** the bigger gate loses $25 a seat under 60, floor $500. The safer start pays in full at any sales.
- **CODE — `scripts/rules/DebutPick.gd` `AIM` :15, `NOISE` :17, `target` :34-36, `pick` :48-67, `apply` :71-78; called from `ProOfferWire.make` :38:** when the promoter calls, each house searches the gap (6 over to 14 under, steps of 0.1) until the card's own read sits on its aim for THIS boxer: 60 in 100 for the bigger gate, 75 in 100 for the safer start, each moved up to 4 points by a misjudgement fixed by boxer, house and day. The offer keeps `opp_gap`, `opp_target`, `opp_picked`, `opp_day`.
- **CODE — `scripts/rules/DebutRead.gd` `card` :17-24:** the shown chance reads the same debutant the bout will have (`DebutOpp.make`) through `BoutRead.round_edges` on a 4-round card (`CardOdds.result`), the boxer as today on the usual camp. It does not count the camp weeks still to come, and it does not read `debut_weeks`.
- **CODE — `scripts/rules/DebutOpp.gd` `make` :37-41, `rating` :32-33, `name_for` :22-24, consts :15-17:** the debutant is a 0-0 boxer-puncher ("Heavy right hand", "Fades after round 3"), rated the boxer's no-camp strength less the gap. The name comes from the offer's day and the house, so two houses put up two debutants.
- **CODE — `Roster.gd` `turn_pro` :305-309, `debut_day` :319-320:** signing books that debutant (the deal's gap and `opp_day`; the rating is taken from the boxer's stats on the signing day) for the Saturday `debut_weeks` out, 4 rounds.
- **CODE — `scripts/state/ProLean.gd` `LEAN_KIND` :8, `extra` :12-33:** for the first 6 pro fights the safer start adds a tune-up to each set of offers and the bigger gate adds a step up.

### Signing
- **CODE — `ProDebut.start_costs` :18-24, `Roster.turn_pro` :275-282:** the gym pays at signing: $230 licence, $875 medicals if never licensed, $140 if the coach has no pro licence ($1,245 at most), unless the costs ask was taken.
- **CODE — `Roster.signing_share` :223-224, `turn_pro` :288-291, `scripts/rules/Loyalty.gd` `pro_share` :230-233, `MOVES` :61:** the gym keeps 25% of the boxer's money; under 50 loyalty an outside manager signs the boxer and the gym keeps 10%. Signing then adds 5 loyalty, after the share was read.
- **CODE — `ProCall.morale` :298-308, `ambition_kind` :312-318, `scripts/rules/Recruit.gd` `ambition` :122-126, `ProOfferWire.morale_line` :162-170:** at the call a boxer's goal reads "A regional title within a year" (potential 78 or more) or "A winning record by the summer". Only the title goal moves morale: signing costs 5 when the boxer could still enter the nationals (`Champs.check`, `scripts/state/Champs.gd` :40-41). No goal contains "pro", so the +5 sign / -5 stay branch (:300-301, and the second sentence of `morale_line` :170) never runs.
- **CODE — `Roster.turn_pro` :301-303, `scripts/rules/DayJob.gd` `count_of` :37-40, `scripts/state/GymSpend.gd` `gain` :99-100:** the stipend ends, open amateur offers are closed, and a boxer with a day job trains 6 mornings of 6 again (was 4, or 5 on a half job).
- **CODE — `Roster.turn_pro` :307 and `scripts/state/Bouts.gd` `accept` :192-211:** `turn_pro` writes the debut over `f["bout"]` without checking it is empty, and `accept` never looks at the open pro offer. A boxer can take an amateur bout while the offer is open and lose it on signing.

### The asks (one a house)
- **CODE — `ProCall.ask_answers` :156-194, `ProOfferWire.ask` :76-90, `back_to_plain` :94-98, `scripts/ui/modals/ProOffer.gd` `_ask` :167-188:** six buttons a house, each with "will take it", "counters" or "won't" (a won't button is disabled, `UI.button`'s fourth argument, and is not spent).

| Ask | Bigger gate, sales 46-74 | Safer start, sales 46-74 | What the code does (CODE) |
|---|---|---|---|
| Later +2 weeks | takes | takes | `_apply_later` :197-201: $150 off the purse, 2 more weeks. The card's win chance does not move (the read ignores weeks) |
| Later +4 weeks | takes | takes | $300 off, 4 more weeks |
| Softer opponent | takes | takes | `_apply_softer` :204-208: gap +0.5, free, and the next 2 sets of pro offers are tune-ups only (`ProLean.extra` :14-17; `ProLadder.book` :341-342 spends a set even on a fight the player asked for) |
| Better split | won't under 65, counters +5 share points at 65-74, free | won't (`_split_entry` :211-239 needs 5 over its break-even of 70; it calls at 74 or less) | takes (+10 points, gap -0.5) only at 80+, where the bigger gate calls alone |
| Own ticket price | takes: $40 tickets, 15 more seats, free (`_price_entry` :242-260; `ProOfferWire.money` :125) | won't | |
| Costs from the purse | won't | counters (`_costs_entry` :263-283): the promoter pays the signing costs and takes them plus $100 ($200 under 8 weeks of runway, `GymBills.runway_weeks` `scripts/rules/GymBills.gd` :62-67) off the purse before the split (`ProOfferWire.money` :122-124, `night` :135-136) | |

### The offer screen
- **CODE — `ProOffer.gd` `build` :35-45:** header: "A CALL FROM (house names)", "TURN (first name) PRO?", then one line: record and rank, days the offer stands, the age line (`ProCall.age_line` :322-327), declines left.
- **CODE — `ProOffer._tickets` :90-106, `ticket_parts` :204-219:** one ticket bar, who buys, one break-even mark at 60 (the safer start's 70 is not drawn).
- **CODE — `ProOffer._house` :110-163:** per house: badge and name; Debut purse; Ticket share past the break-even and seats sold today; "Debut, N weeks out: (debutant's name), picked as a winnable first night / picked to test your boxer" (`DebutPick.line` :88-91) with a hover (`DebutPick.tip` :96-100: threat, weakness, "Spend the ask on a softer opponent"); "Win chance: about N%, a draw N%" (:147); "After the debut: +$ a win, up to $" (:148); "The gym at signing" (:154, the night's cut minus today's costs in one number); "The gym each week after" (:155, the stipend minus an assumed $75, `ProCall.LOST_CUT_A_WEEK` :13); "The boxer from the debut" (:156); the pays-back sentence (:158, `ProCall.pays_back_line` :143-147); the asks; "Turn pro with (house name)" (:160).
- **CODE — `ProOffer.build` :56-69:** what the gym pays at signing, itemised; WHAT ENDS (stipend, amateur bouts, the club ticket cut); the 10% line under 50 loyalty.
- **CODE — `ProOffer.build` :72-81:** the MORALE line when morale moves; "Stay amateur" with a tooltip that always says "the same house calls again after 2 more wins, on 0.9x terms". After one Stay the real gate is 9 wins and top 3, or 11 wins; after two it is rank 1; after three the door is closed (`pro_ready` above).

### Holding, staying, lapsing
- **CODE — `scripts/state/Needs.gd` `needs` :67-70, `flags` :167-168, `blockers` :140-141; `scripts/ui/Main.gd` `on_go` :195-199; `scripts/state/Clock.gd` `stop_now` :79-83:** the open offer is a red need and a red top-bar flag. Continue opens it and time does not pass.
- **CODE — `ProOfferWire.lapse_if_due` :187-197, `ProCall.expires` :336-337:** the 14-day lapse runs only inside `check_pro`, which needs a week to end or a bout to finish. Since time is blocked, the lapse and the "14 more days" on the card cannot be reached by playing.
- **CODE — `Roster.decline_pro` :324-334, `Loyalty.MOVES` :61:** Stay adds a decline, saves the returning house, applies morale by the goal (0 today for every goal that exists) and costs 8 loyalty.
- **CODE — `scripts/state/LoyaltyWire.gd` `idle_week` :44-53, `IDLE_WEEKS` :19:** a fit boxer with nothing booked loses 3 loyalty every 4 Mondays. It does not pause for an open offer.
- **CODE — `scripts/rules/FighterProfile.gd` :25, `scripts/rules/AskDates.gd` `wait_words` :119-122:** "a month without a fight costs 6 morale" is a table entry and a sentence on the ask screen; a search of `scripts/` finds nothing that applies it. There is no such loss to pause.
- **CODE — `scripts/state/Leaving.gd` `_go` :94-95:** a boxer who leaves takes the offer away.

### The night and after
- **CODE — `scripts/state/BoutFinish.gd` :92, :111-116, `Roster.debut_night` :247-251, `ProOfferWire.night` :133-142:** the debut pays on the seats counted ON THE NIGHT (members and followers as they are then), not the offer's count. The gym is paid its cut of purse and ticket share; the ledger label prints 25% even when the cut was 10% (:114-115).
- **CODE — `BoutFinish.gd` :94-106, `scripts/rules/BoutRules.gd` :114-123:** a debut win brings 8 members and 5 reputation; a loss costs 1 member and 2 reputation (2 and 4 when stopped). The same for both houses.
- **CODE — `BoutFinish.gd` :117-122, `scripts/state/ProLadder.gd` `book` :354-361, `scripts/rules/Matchmaking.gd` `pay_of` :215-224, `PURSE_UNRANKED` :49:** later pro fights pay from the ladder ($1,500 unranked base plus rank, draw and fan tickets). `f["purse"]` steps up after a win (:122) but nothing reads it for pay. The contract's step and top, shown on the card (:148) and promised in the week review (`scripts/ui/ProWeekLines.gd` `next_line` :46-50), are never paid.
- **CODE — `ProWeekLines.lines_for` :15-42, `scripts/ui/modals/WeekReview.gd` :152:** for 28 days after signing the review shows "amateur cut lost / stipend saved" with the assumed $75 a week; in the debut's week a ledger line (gym share, costs, net).
- **CODE — `scripts/state/GymDeals.gd` `pro_camp` :22-35:** the debut has no camp bill; a cutman on staff is still charged.

### The money today, worked from the code (ESTIMATE: sums from `debut_purse` and `ProCall.money` at a 25% cut)
| Sales | Bigger gate: gym / boxer | Safer start: gym / boxer | Bigger gate + own price (free today): gym / boxer |
|---|---|---|---|
| 46 | $288 / $862 | $450 / $1,350 | $380 / $1,140 |
| 56 | $350 / $1,050 | $450 / $1,350 | $430 / $1,290 |
| 60 | $375 / $1,125 | $450 / $1,350 | $450 / $1,350 |
| 66 | $413 / $1,237 | $450 / $1,350 | $480 / $1,440 |
| 74 | $463 / $1,387 | $465 / $1,395 | $520 / $1,560 |

- **ESTIMATE — the fork has one answer today.** The safer start pays more at all 29 sales counts where both call, wins 15 in 100 more often, and a debut win is worth 8 members (about $65 a week in dues at $35 a month). The bigger gate only wins with its free price ask, from 61 sales up, by $5 to $55 for the gym.
- **ESTIMATE — the asks have one answer a house today.** Bigger gate: own price is free money at every count in the band and beats the split counter everywhere. Safer start: softer is free, and the costs ask moves about $900 from the boxer to the gym at no cost the gym feels (plain: gym -$795 after the night, boxer $1,350; covered: gym +$114, boxer $341).

## 2. Evidence (ESTIMATE: measured, not code)
- `docs/TURNPRO6_RESULT.md`: 10 boxers, 66,000 played bouts. About 4.7 points of win share a rating point; 2 more camp weeks are worth about 2 points; the fixed read is within 5 points of played bouts in 57 of 60 cells on fight night.
- `docs/DEBUTPICK1_RESULT.md`: 11 boxers, 13,200 played bouts. Picked: the bigger gate plays 58.7 in 100 (52 to 69 by boxer), the safer start 78.5 (72 to 85). 18 of 22 cells within 7 points of the target. The owner on the safer house's 78: "78 is fine". Left open there: a newcomer still growing reads low on the card (the camp builds the tank and a new punch).

## 3. The fork: two houses, no right answer (ESTIMATE)
The human question (the brief): which contract gets THIS boxer to a second fight with money in the club?

| Lever | Today (CODE) | v10 | Why |
|---|---|---|---|
| Safer start's purse | $1,800 guaranteed | **$1,400 guaranteed** | The money now crosses at 56 sales: below it the safer start pays more, above it the bigger gate does (by $63 for the gym and $187 for the boxer at 66; $98 and $292 at 74) |
| A debut win's crowd | 8 members, either house | **bigger gate 10, safer start 8** | 0.60 x 10 = 0.75 x 8 = 6 members expected: the same on average, the bigger gate swings wider. Without this the safer start's 15 points are worth about $10 a week for good and it dominates again inside two months |
| The boxer's wish | none | **one wish a boxer, in the MORALE line** | Below |
| Aims | 60 and 75 in 100 | unchanged | Owner: 70-80 for the safer house, "78 is fine" |
| Weeks out | 4 and 6 | unchanged | The bigger gate reaches the ladder 2 weeks sooner |
| First 6 pro fights | step ups / tune-ups | unchanged, said on the card in a few words | It is the long tail of the choice |

**The boxer's wish (replaces John's "lean", uses only saved fields).** A boxer working a day job (`day_job`) wants **the bigger purse on the night** (whichever card shows more for the boxer). A boxer with the title goal (potential 78+) wants **the test**. Any other boxer wants **the winnable first night**. Signing the wished house: morale +5. Signing the other: morale -5, loyalty -3. Where only one house calls there is no wish. It is written once, in the existing MORALE line ("Your boxer wants the test. That offer: morale +5. The other: morale -5, loyalty -3."), never on a button (owner S534). The existing title rule (signing costs 5 morale while the nationals are open) stays and is said in the same line.

**Who should pick what (the design intent the sweep must confirm):**
| Sales | Money says | A boxer who wants the test | A boxer who wants the winnable night | A boxer on a day job |
|---|---|---|---|---|
| 46-49 | safer start (even against the priced ticket ask) | split: wish against money and safety | safer start, clear | safer start |
| 50-56 | safer start plain; bigger gate with its ticket ask | bigger gate | split | whichever pays the boxer more: the bigger gate with the ask |
| 57-74 | bigger gate | bigger gate, clear | split: wish and safety against money | bigger gate |

No house is right across the band; the clear cells are at the ends, where one house nearly calls alone anyway.

## 4. The asks: three a house, each with a price, each best somewhere (ESTIMATE)
Only asks the house will grant are drawn. No "won't" buttons. Each button shows its price and the card's numbers after it (the win chance through `DebutRead.card` on the ask's terms, the money through the same sums as the card), before it is pressed.

| House | Ask | Today (CODE) | v10 | Best pick when |
|---|---|---|---|---|
| Bigger gate | Own ticket price | $40 tickets, +15 seats, free | the same, **$180 off the purse before the split** | sales are under 84: worth +$190 at 46 and +$50 at 74 between gym and boxer; the button says "worth it under 84 seats" |
| Bigger gate | Softer opponent | gap +0.5, free, 2 tune-up sets | **gap +1.0 (about 5 in 100 more), $300 off the purse, no tune-up rider** | a loss would hurt most: a boxer who wants the winnable night but whose money sits with this house |
| Both | Later +2 weeks | $150 off | unchanged; the words say "+2 Build weeks, the opponent stays as picked" | the boxer is injured or far over the weight at the call, or is new to the gym (the card reads a newcomer low; the camp is where that boxer grows) |
| Safer start | Costs from the purse | costs + $100/$200 off the purse | the same, **and loyalty -6** (the boxer boxes the debut for almost nothing: $41 at $1,400 and full costs) | cash cannot carry $1,245 today, or runway is under 8 weeks |
| Safer start | Softer opponent | free | **CUT** | the house already aims at 75 |
| Both | Later +4, Better split (counter and take) | free or dominated | **CUT** | the split counter loses to the ticket ask at every count; the take only exists at 80+ |

- **ESTIMATE — at 75+ sales (the bigger gate alone)** the three asks stay; own price stops paying at 84 and is hidden from there.
- **ESTIMATE — prices are per win point, on purpose different:** Later about $75 a point and two weeks; Softer about $60 a point and no delay; so Later is only right when the time itself is needed. The sweep in section 8 checks it.

## 5. Holding, staying, lapsing (ESTIMATE)
- **Review later is real.** The need and the top-bar flag turn amber (not red), so Continue runs. `lapse_if_due` is checked every day (`Sim.step_day`), and the clock stops once on the last day. The card's "14 more days" becomes true.
- **While it is open:** no bout can be booked for this boxer (`Bouts.accept` and the ask flows refuse with "Answer the pro offer first"), which also closes the overwrite in `turn_pro`. The idle loyalty count pauses for this boxer (the month-without-a-fight morale loss John names is not applied by any code today, so there is nothing else to pause). Other boxers are untouched.
- **Holding is not free training against a frozen opponent:** the debutant's rating is taken from the boxer on the signing day (CODE above), so it rises with the boxer. The hold costs up to two more weeks of stipend and two weeks later on the ladder.
- **Stay amateur says what it does**, on the button's hover: the real next gate (from `pro_ready`), terms x0.9 unless a title comes, loyalty -8, declines left. And **which house returns is a rule**: the one whose break-even is nearer the sales on the day of the Stay (said in roles: "the bigger gate calls back").
- **Another boxer ready:** one line in the header, "Another boxer's call waits behind this one." No count, no queue system: `check_pro` already calls the next ready boxer when this offer clears.
- **CUT:** the queue list, an extra lapse penalty, a countdown in the top bar.

## 6. The money, said honestly (ESTIMATE)
- **Three numbers a card**, replacing "the gym at signing", "the gym each week after" and the pays-back sentence: **Cash today** (the signing costs, or $0 when covered), **The gym on the night**, **The boxer on the night**. All at today's sales, from the sums the card already runs.
- **Paid on the night's seats.** The ticket row's hover: "Paid on the seats sold on the night. Every 2 new members is 1 more seat." It is the one thing the player can do about it. No range.
- **Both break-even marks** on the ticket bar (60 and 70).
- **CUT — the step and top promise** ("After the debut: +$ a win, up to $" on the card and the NEXT line in the week review) until pro pay reads it. The ladder already pays by rank; a second pay rule for the contract is out of scope (S428: the scope ends at the debut).
- **CUT — the assumed $75 a week** and the pays-back week: a number the player cannot check or change (owner C443).
- **Fix:** the debut ledger prints the share that was paid (10% or 25%), and adds "sold N on the night (N at signing)".
- **WHAT ENDS** gains, for a boxer on a day job: "The day job ends: 6 training mornings of 6 (now 4)."
- **Names:** "Turn pro with (house)" becomes "Sign this offer" (names only in headers; the card's head keeps the house's name and, under it, THE BIGGER GATE / THE SAFER START).

## 7. Where it appears
| Menu | CODE TODAY (file, function, lines) | Wired to today | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|---|
| Top bar | `scripts/ui/Shell.gd` :152-153 | `Needs.flags` :167-168, red PRO OFFER | amber |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83 | `Needs.blockers` | runs while the offer is held; stops once on the last day |
| Home, needs | `scripts/ui/HomeNeeds.gd` `ranked` :25-26 | `Needs.needs` :67-70, `_pro_line` :199-206 (house names in the body) | amber; days left; roles, not names |
| Office desk | `scripts/ui/OfficeDesk.gd` `NEED_ICON` :39 | the contract icon for "prooffer" | none |
| Offer header | `ProOffer.build` :35-45 | `ProOfferWire.days_left`, `ProCall.age_line` | "Another boxer's call waits" line |
| Offer ticket bar | `ProOffer._tickets` :90-106 | `ticket_parts` :204-219, one mark at 60 | both marks; the night's-seats hover |
| Offer house card | `ProOffer._house` :110-163 | `DebutRead.card`, `DebutPick.line/tip`, `ProOfferWire.money` | role line under the name; three money numbers; first-6-fights words; CUT step/top, weekly-after, pays-back |
| Offer asks | `ProOffer._ask` :167-188 | `ProOfferWire.answers/ask/back_to_plain`, act "proask" / "proplain" (`scripts/ui/RosterActs.gd` :96-104) | three granted asks, each with price and the numbers after |
| Offer foot | `ProOffer.build` :56-81 | `ProOfferWire.morale_line`, acts "turnpro" :90-95, "declinepro" :105-108 | the wish in the MORALE line; Stay's true hover; Review later; "Sign this offer" |
| Fighter, Next Step | `scripts/ui/areas/FighterPage.gd` :336-339 | `NextStep.road` :15-68, `pro_line` :73-89 (house names in the body) | "Offer open, N days" for this boxer; the age check; roles, not names |
| Fighter, contract | `FighterPage.gd` :144 | fixed text "Club stipend, $250 a week / until turning pro" | the pro share and house for a pro |
| Money, stipends | `scripts/ui/MoneyPanels.gd` :264, `_stipend_card` :360-369 | "Signing the open pro offer ends it anyway" | none |
| World compare | `scripts/ui/WorldCompare.gd` :269 | the "offer waiting" mark | none |
| Fights (pro) | `scripts/ui/ProFights.gd` :117-119 | `ProLean.line` :41-47 (house name in the body) | roles, not names; no tune-up rider line |
| Week review | `WeekReview.gd` :152 | `ProWeekLines.rows` :62-75 | the fixed ledger line; CUT the NEXT promise and the $75 line |
| History | `scripts/ui/BoutHistory.gd` :45-68 | "TURNED PRO WITH (house), (date)" milestone | none |
| Result of the debut | `BoutFinish.gd` :111-116, `Roster.debut_words` :254-261 | news line and pay label | the true share; members by house |
| Toasts | `RosterActs.gd` :95, :108 | "(first name) is a pro. Debut on (date)." | none |
| Test jump | `scripts/ui/TestJump.gd` :192-197 | opens the offer on the test club | keep working |
v9's rows for the roster table and the world news feed were not reopened for this map; they are not claimed here.

## 8. Depth: the test before any number is final (ESTIMATE)
- **The sweep (John 13).** A bot that values cash, members, morale and loyalty at the game's own prices plays the real route (`check_pro` to the settled debut and 12 weeks after) over sales 46-74, the six signable people, three wishes, three cash states (safe, under 8 weeks, cannot pay the costs), one injured-at-the-call case. Pass: each house is picked 30-70% of the time across the band and by no more than 85% in any single sales count from 50 to 70; each of the four asks is the best pick in at least one cell; "no ask" is best in at least one cell a house. Its output names the population. Control arm: today's numbers, which must read as dominated (the safer start near 100%).
- **Tuning order if it fails:** the bigger gate's win crowd (10), then the safer start's purse ($1,400), then the wish's loyalty (-3). The aims do not move.
- **State tests:** last day and reload; a double press on Sign; an amateur offer open at the call; Stay at 1 and 2 declines (the hover matches `pro_ready`); the 10% share on the ledger; an old save's offer with no `opp_picked`.
- **Golden path:** call, hold three days, one ask, sign, debut, week review ledger.

## 9. John's 13 points (6/6/7), one by one
| # | Point | v10 |
|---|---|---|
| 1 | Pick the opponent to each boxer | **BUILT.** CODE `DebutPick.pick` :48-67 via `ProOfferWire.make` :38; frozen in the offer. Measured 18 of 22 within 7 points (John asked 90%; the misses are newcomers the card reads low). Aims 60 / 75, owner "78 is fine" |
| 2 | Show the win read on each card | **BUILT.** CODE `ProOffer._house` :147. The range is refused: one number the two houses differ on and the asks move; a range adds nothing to act on (C443) |
| 3 | Safer start $1,400 | **Take** (section 3). Moves DEPTH: the crossover goes from none to 56 |
| 4 | The boxer's lean | **Take, smaller** (section 3): from saved fields, no new `goal_kind`; one MORALE line, not a line a card. Moves DEPTH and PLAY |
| 5 | Price-ask fee off the gross | **Take:** $180 off the purse before the split, "worth it under 84 seats". Today the ask is free (CODE) |
| 6 | A night range on the ticket card | **Refuse the range, take the fact:** the hover says pay is on the night's seats and what moves them |
| 7 | Always show Later +2 | **Built** (always shown today); take the words. Later +4 CUT |
| 8 | Re-price the lone-call asks | **Take for softer** ($300, gap +1.0); **cut harder** (John's own alternative). TURNPRO6 puts 0.5 of gap at 2.4 points, not "many" |
| 9 | Hold = Review later only | **Take** (section 5): amber, daily lapse, the idle-loyalty pause. His second pause (month without a fight, morale -6) has no code to pause: the number is only words today (CODE, section 1) |
| 10 | The returning house by a rule | **Take** (section 5) |
| 11 | Real costs | **Take the two fees** ($238 licence, $150 trainer; ESTIMATE until his BBBofC source is opened) and the manager's licence ($438, once a coach) as a signing cost. The yearly medical is a ladder bill: handoff note, not this map |
| 12 | One pulsing button; no names in card titles | **Take the names** (button and body lines, section 6). **Refuse the pulse-after-pick:** it adds a click to pick a card before signing it; two equal choices, neither pulses |
| 13 | The bot test | **Take** as the gate (section 8) |
| - | His evidence: real debutants win 90 in 100 | **Refuse** raising the aims: the owner's shape is a debut "expected to win but can lose", 70-80 for the safer house |
| - | Costs off the top is the real BBBofC model | **Keep the code's model**, add the loyalty cost; v9's loan is CUT |

## 10. Dola's list (7/8/7), one by one
| # | Point | v10 |
|---|---|---|
| 1 | Make the hold work: amber, daily lapse, block only this boxer, pause idle loyalty | **Take**, all four (section 5) |
| 2a | Three numbers a card | **Take** (section 6), from the card's own sums; no `ProMoney.quote` |
| 2b | Remove the step/top promise until it is paid | **Take** (CUT, section 6) |
| 2c | Full ledger in the week review | **Take, short:** the true share and sold-against-signing; no loan lines (no loan) |
| 2d | The crossover on the price ask | **Take** ("worth it under 84 seats") |
| 3a | One pro and one con a house | **Take:** the role line and the first-6-fights words |
| 3b | Stay shows exactly what happens | **Take** (section 5); today's tooltip is wrong after the first Stay (CODE) |
| 3c | Training mornings on the strip | **Take**, only for a boxer on a day job, in WHAT ENDS |
| 3d | The cost of waiting on the hold | **Take:** "No bout can be booked for your boxer while the offer is open." |
| 4 | Thin the asks: hide dead ones, at most 3, no "won't" buttons | **Take** (section 4): three a house at most |
| 5 | Validate, then show confidence in words only | **Built / refuse the words:** 79,200 played bouts stand behind the read (section 2); the number stays because the asks move it by known steps and the owner reviewed that card (C442/C443) |
| 6a | "Next in line" in the header | **Take as words**, no count (section 5) |
| 6b | Next Step says why now and what a pass costs | **Take:** the Stay hover's gate line, reused |
| - | Her "missing" table: real hold, cost of waiting, queue, day-job benefit, plain contract terms | all five answered above (1, 3d, 6a, 3c, 2b) |

## 11. Owner rulings kept
- Amateur bouts need no camp (S428): untouched; the debut keeps its camp (`WeekPhase.phase` :43-51).
- The debut is 70-80 in 100 for the safer house; "78 is fine" (DEBUTPICK1). The aims do not move.
- Names only in headers (S448): the button and three body lines that carry a house's name today are in the build list.
- Only actionable information (S425, C443 "can he do anything about them?"): no gap, no aim, no range, no assumed weekly figure; every number left is one the choice or an ask changes.
- Morale off the buttons, one MORALE line (S534): the wish lives in that line.
- One offer screen, no new screen; everything ships switched on.
- Board text short. The one line for his board, when two fresh critics have scored this map 7+: "Turning pro: safer house pays less, bigger gate wins bring more members, the boxer has a wish. OK to build?"

## 12. Build order (ESTIMATE; nothing here is built)
1. Hold: amber, daily lapse, the booking guard, the two pauses. Red test first: Continue with an open offer must advance the day.
2. Asks: three a house, prices, numbers-after on each button; cut the rest.
3. The fork: $1,400, the win crowd by house, the wish. Then the sweep (section 8) before the numbers are final.
4. The card: three money numbers, both marks, roles and names, Stay's hover, the returning-house rule.
5. Ledger and week-review fixes; the fees.
Tests that pin today's numbers and will move: `tests/pro_call_test.gd` (:44, :79-80, :117, :145, :160), `tests/pro_offer_wire_test.gd` (:52-58, :66, :70), `tests/debut_pick_test.gd` (:150-151 softer on the safer start).

## 13. Cut list
- **CUT —** Later +4. Better split (counter and take). Softer on the safer start. The tune-up rider. "Won't" buttons. The step and top promise. The assumed $75 a week and the pays-back week. v9's loan, queue list, `ProMoney.quote` and versioned contract pay. A win-chance range or word bands. The pulse-after-pick. A countdown in the top bar. An extra lapse penalty. Raising the aims to 65 / 80.
