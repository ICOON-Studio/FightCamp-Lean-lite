# Turning pro — design map v9 (written from the code at main 55fa5a15)

> S533 NOTE (main session): every number quoted here from TURNGAP1 (the debut gap curve, e.g. lines ~81, 114-118, 165) is WRONG - that probe ran one boxer on three nights. The measured curve, the fixed read and the new gaps (ticket house 3.0 = ~60 % wins, guarantee house 6.0 = ~75 %) are in docs/TURNPRO6_RESULT.md; critics judge against that page.


Scope: the pro offer, from the call to the debut ledger: the two houses side by side, the debut opponent gap, the purse, ticket and costs asks, Stay amateur and the lapse. The ladder after the debut is a handoff only. Method (owner S530): section 1 is written only from code opened for this map at main `55fa5a15c898741fe9bda9f1cb6051d59d8aab3e`. Every **CODE** line names the file, the function and the lines, and is true at that commit. **ESTIMATE** means a proposal, a sum worked on paper or a measured result that is not code. **CUT** means do not build or show it. Inputs: map v8, its critic (6/6/7), the critic from the earlier review (6/7/6; the v8 review queued as SQ261 has not landed, so `DESIGN_TURNPRO1_V8_CRITIC_DOLA.md` holds only the brief), `docs/TURNGAP1_RESULT.md` and `ops/research/CRITIC_PACK.md`. Godot was not run.

Words used in this map: the **ticket house** is the house that pays from the gate. The **guarantee house** pays a fixed purse. **Base sales** means the debut ticket forecast. A **gap** is the number taken off the opponent's rating, so a higher gap means an easier opponent.

## 1. What the game does today (CODE only)

### The call
- **CODE — `scripts/state/Roster.gd` `check_pro` :199–204:** while `c.pro_offer` is not empty, the function only runs the lapse check and returns. The gym has one live offer at a time.
- **CODE — `Roster.gd` `check_pro` :205–213:** the call goes to the first boxer in roster order who is `pro_ready`, has waited out any lapse, has no booked bout and is not in an active championship run. There is no queue, and nothing records who else was ready.
- **CODE — `Roster.gd` `pro_ready` :185–195:** a pro, or a boxer with 3 declines, gets no call. A national finalist with 0 declines is ready at any record. With 0 declines the gate is 7 wins and a rank of 1–3, or 9 wins. With 1 decline it is 9 wins and top 3, or 11 wins. With 2 declines only a No. 1 rank qualifies.
- **CODE — `scripts/state/ProOfferWire.gd` `make` :24–27 and `scripts/rules/ProCall.gd` `calls_open` :331–332:** with 0 declines, no offer is made at age 32 or older. With 1 or more declines the age check is skipped.
- **CODE — `scripts/rules/NextStep.gd` `road` :46–50:** the Pro offer step counts as done once `pro_ready` and the lapse wait are met. It never checks age, so a boxer aged 32 or older with 0 declines can show the step as done while `check_pro` skips that boxer every time (:208–210).
- **CODE — `scripts/rules/ProDebut.gd` `tickets_sold` :27–32 and `ProOfferWire.gd` `forecast` :19–20:** base sales are 20, plus half the members rounded down, plus 2 per amateur win, plus 10 per title, plus the club-show followers, capped at 100.
- **CODE — `ProCall.gd` `who_calls` :63–69, const `BAND` :10:** at 75 or more base sales only the ticket house calls. At 45 or fewer only the guarantee house calls. From 46 to 74 both call.
- **CODE — `ProOfferWire.gd` `make` :30–32 and `on_decline` :166–168:** after a decline, the house saved in `pro_last_house` calls alone at any forecast. `on_decline` saves `offers[0]`, and `who_calls` lists the ticket house first, so after refusing two cards the ticket house is the one that comes back.
- **CODE — `ProCall.gd` `terms` :73–95 and `ProOfferWire.gd` `make` :33:** each decline multiplies purse, step and top by 0.9 (0.81 after two), unless a title has been won since the last refusal.

### The two deals
- **CODE — `ProCall.gd` `promoters` :35–59:** ticket house: $1,500 purse, $500 step, $3,000 top, break-even 60, 50% share, 4 weeks, gap 1.0. Guarantee house: $1,800 guaranteed, $400 step, $3,000 top, break-even 70, 30% share, 6 weeks, gap 1.5.
- **CODE — `ProCall.gd` `debut_purse` :99–108:** the ticket house takes $25 off for each seat short of break-even, down to a $500 floor. The guarantee house pays its purse at any sales.
- **CODE — `ProCall.gd` `money` :112–139:** the ticket share is seats above break-even × the deal's price (default $50; :117) × the share rate. The gym's cuts of the purse and of the share are rounded separately. "Gym at signing" is those cuts minus costs. "Weekly after" is the stipend (if paid) minus an assumed $75 (const `LOST_CUT_A_WEEK` :13). `even_week` counts weeks of that weekly figure. None of this is a dated cash flow.
- **CODE — worked from `debut_purse` and `money`:** plain gross for the ticket house vs the guarantee house is $1,150 vs $1,800 at 46 base sales, $1,650 vs $1,800 at 66, and $1,850 vs $1,860 at 74. Wherever both houses call, the guarantee house pays more gross, and its gap is also bigger (1.5 vs 1.0).
- **CODE — `Roster.gd` `turn_pro` :303–310 and `debut_day` :320–321:** the opponent's rating is fixed once, at signing: the boxer's no-camp fight power minus the deal's gap. The bout is on the Saturday `debut_weeks` weeks out, and the camp never changes the opponent.
- **CODE — `scripts/rules/WeekPhase.gd` `phase` :43–51:** for a pro bout the last week is Taper, the week before it is Peak, and every earlier week is Build. Extra weeks before the debut are Build weeks.

### Signing
- **CODE — `ProDebut.gd` `start_costs` :18–24 and `Roster.gd` `turn_pro` :274–281:** the bill is a $230 licence, plus $875 medicals if the boxer has never been licensed, plus $140 if the coach has no pro licence. Cash pays it at signing unless costs are covered.
- **CODE — `Roster.gd` `turn_pro` :286–290, `signing_share` :222–223 and `scripts/rules/Loyalty.gd` `pro_share` :230–233:** under 50 loyalty the gym share is set to 10%. Loyalty then rises by 5 (const `MOVES` :61, `"turn_pro": 5`), but the share was read before that rise.
- **CODE — `Roster.gd` `turn_pro` :277, `ProCall.gd` `morale` :298–308 and `scripts/rules/Recruit.gd` `ambition` :122–126:** signing costs 5 morale when the ambition text contains "title" and `Champs.check` (`scripts/state/Champs.gd` :40–41, basic eligibility only) passes. `Recruit.ambition` never returns text containing "pro", so the +5 sign / −5 stay branch can never fire for a generated goal.
- **CODE — `Roster.gd` `turn_pro` :300 and `scripts/rules/GameMoney.gd` `athlete_payroll` :24–28, `settle_week` :59–67:** the stipend drops to 0, which lowers the payroll that accrues each week. That accrual is billed every 28 days, so the saving shows up on the next bill, not as cash each Monday.
- **CODE — `scripts/rules/DayJob.gd` `count_of` :37–40 and `scripts/state/GymSpend.gd` `gain` :99–100:** an amateur with a day job gains stats at 4/6 of the normal rate (5/6 on a half job). A pro counts 0 lost mornings, so signing restores full gain. `scripts/state/WeekData.gd` never references GymSpend or DayJob (file search), so the week plan's forecast leaves out the day-job cut.
- **CODE — `Roster.gd` `turn_pro` :301–302:** every open amateur sheet offer for the boxer is marked answered.
- **CODE — `Roster.gd` `turn_pro` :264–316 and `scripts/state/Bouts.gd` `accept` :192–210:** `turn_pro` writes the debut into `f["bout"]` (:308) without checking that the slot is empty, and `accept` never checks `c.pro_offer`. A repo search finds `pro_offer` in no amateur booking file (Bouts, AskFlow, HomeBout, ApproachWire, RivalOfferWire, LateAskWire, Champs). `HomeBout.reason` :38–45 checks pro status and an existing bout, but not the offer.

### Holding, staying, lapsing
- **CODE — `scripts/state/Needs.gd` `needs` :66–69, `flags` :166–167, `blockers` :139–140; `scripts/ui/Main.gd` `on_go` :196–200; `scripts/state/Clock.gd` `stop_now` :77–81:** the offer is a red need and a red flag. Continue opens the first blocker instead of running, and the clock stops on any blocker.
- **CODE — `Main.gd` `_unhandled_input` :283–293:** Esc closes the offer modal because it is not in the locked list. The offer stays open, and Continue opens it again.
- **CODE — `ProOfferWire.gd` `lapse_if_due` :172–184 and `ProCall.gd` `expires` :336–337:** the lapse runs only inside `check_pro`, which is called from `scripts/state/Sim.gd` `end_week` :417, `Bouts.gd` `after_fight` :456 and `scripts/state/BoutFinish.gd` `run` :214. Continue cannot move time past a red blocker, so the 14-day lapse cannot happen through Continue. When it does run, it clears the offer and sets `pro_wait_w` to wins + 2, with no loyalty, morale or decline change.
- **CODE — `Roster.gd` `decline_pro` :325–335 and `Loyalty.gd` `commit` :137–147:** Stay adds a decline, saves the house and the title count, applies morale through the ambition, and moves loyalty by −8 (clamped to 0–100). The news line comes from const `DECLINE_NEWS` :39.
- **CODE — `scripts/ui/modals/ProOffer.gd` `build` :73:** the Stay tooltip always says the house calls again after 2 more wins on 0.9x terms. With 1 decline the next gate is really a No. 1 rank (`pro_ready` :192–193), and with 2 declines the door closes.
- **CODE — `scripts/state/Leaving.gd` `_go` :94–95:** when the boxer leaves the gym, the offer is cleared.
- **CODE — `scripts/rules/Promises.gd` const `TURN_PRO` :12, `listed` :26–28, `resolve` :110–113, `can_decline_pro` :73–78:** a "turn pro" promise is defined, but nothing makes one and nothing calls `can_decline_pro`. A repo search finds only `ApproachWire.gd` `answer` :199 making a promise, and that one is show_top.
- **CODE — `scripts/state/LoyaltyWire.gd` `idle_week` :44–53:** a fit boxer with no bout counts idle weeks and loses loyalty (`no_bout`) at `IDLE_WEEKS`. Nothing pauses this for an open offer.

### The asks
- **CODE — `ProCall.gd` `ask_answers` :156–194, `ProOfferWire.gd` `ask` :74–89, `back_to_plain` :92–96:** each house allows one taken ask. A "wont" answer is not spent. Back to plain restores the terms but leaves the ask spent.
- **CODE — `ProCall.gd` `_price_entry` :242–260, `_costs_entry` :263–283, `_split_entry` :211–239:** price is for the ticket house only and costs for the guarantee house only. Split takes at 20 or more over break-even and counters at 5–19. On a first call the guarantee house only calls at 74 or below, at most 4 over its 70, so its split is always "wont". The ticket house can counter from 65 and only takes at 80 or more, where it calls alone.
- **CODE — `ProOfferWire.gd` `money` :117–129, `night` :131–141 and `ProCall.gd` `money` :117:** the price ask means $40 tickets and 15 more seats, capped at 100. At a 25% cut it adds $370 gross at 46, $270 at 66 and $230 at 74. It ties plain at 92 and loses from 93. It has no fee and no other cost.
- **CODE — `ProOfferWire.gd` `money` :119–122, `night` :133–134, `signed` :107–113; `ProCall.gd` consts :28–30 and `_costs_entry` :265; `scripts/rules/GymBills.gd` `runway_weeks` :62–67:** with costs covered, the costs plus a fee come off the purse before the split. The fee is $200 below 8 runway weeks, otherwise $100. Runway reads 999 when the week's net is zero or better. Worked at $1,245 costs, a 25% cut and the $100 fee: the gym gets +$114 and the boxer $341, against plain at gym −$795 and boxer $1,350. The boxer carries 75% of the costs.
- **CODE — `Roster.gd` `turn_pro` :293–294:** with costs covered, `pro_signed.costs` is saved as 0, so the week review ledger shows no costs.
- **CODE — `ProCall.gd` `_apply_later` :197–201, `_apply_softer` :204–208 and `Roster.gd` `turn_pro` :311:** later adds 2 or 4 weeks for $150 or $300 off the base. Softer adds 0.5 to the gap and saves 2 tune-up sets.
- **CODE — `scripts/state/ProLadder.gd` `book` :341–346 and `scripts/state/ProLean.gd` `extra` :14–17:** `book` uses up a tune-up set before it checks an asked fight. `extra` filters the offers to tune-ups only when one exists.

### The debut and the handoff
- **CODE — `BoutFinish.gd` `run` :91–92, :111–116 and `Roster.gd` `debut_night` :246–250:** the debut pays the gym its cut of sales counted on the night. Wins and titles stop rising after signing (`Bouts.gd` `day_events` :124 skips pros), so only members and followers move the count. The ledger label prints `Roster.GYM_SHARE` (25%) even when the cut paid was 10%.
- **CODE — `scripts/state/GymDeals.gd` `pro_camp` :20–35:** the debut has no camp bill, but a cutman on staff is still charged a per-bout fee.
- **CODE — `BoutFinish.gd` `run` :117–122, `ProLadder.gd` `book` :354–361 and `scripts/rules/Matchmaking.gd` `pay_of` :215–224:** later pro bouts pay the gym its share of the booked ladder pay: a $1,500 unranked base (`PURSE_UNRANKED` :49), plus rank and draw additions, plus fan tickets. `f["purse"]` rises by the contract step after a win (:121–122), but a repo search finds nothing that reads it for pay. The contract's purse, step and top are not live pay.
- **CODE — `ProLean.gd` `extra` :12–33, `line` :41–47:** for the first 6 pro fights the guarantee house adds a second tune-up and the ticket house a second step-up, but only when a distinct candidate exists. The ticket house adds no step-up after ducks or a rebuild (:22–23).
- **CODE — `scripts/ui/ProWeekLines.gd` `lines_for` :15–42, `next_line` :46–50:** for 28 days after signing, a line compares the stipend saved with an assumed $75 a week of lost cut. The weeks are clamped to 1–4, so weeks 5 and 6 of a guarantee-house wait show nothing. In the debut week the line shows the gym's share minus signing costs, then promises the contract step that the ladder does not pay.
- **CODE — `scripts/rules/StarDeal.gd` `terms` :41–44:** the yearly "lower" share is max(12%, share − 2%), so a boxer on 10% is "offered" 12%.

### What the screens show today
- **CODE — `ProOffer.gd` `build` :32–42:** the header shows the house names, the boxer's first name, the record and rank, the days left, the age line only from age 29, and the declines left.
- **CODE — `ProOffer.gd` `_tickets` :84, :90:** the debut card's title and the ticket bar use $50 and break-even 60 for both houses, even after the price ask or on a guarantee-only call.
- **CODE — `ProOffer.gd` `_house` :123–144:** each card shows the purse, the share past break-even, the weeks and the gap as "a debutant 1.0 under", the step and top, gym at signing, gym each week after, and the boxer from the debut. The button reads "Turn pro with" plus the house name.
- **CODE — `ProOffer.gd` `_ask` :149–170:** all six asks are shown in a grid, and "wont" ones are disabled with the promoter's words as the tooltip.
- **CODE — `NextStep.gd` `pro_line` :73–89:** the body text names both houses and says the guarantee house "pays from 70", although it pays its purse at any sales.
- **CODE — `NextStep.gd` `_need_for` :136–141:** the unranked sentence can print "1 more wins". The debut line always says 4 weeks after signing, even for a 6-week house or a later ask.
- **CODE — `scripts/ui/ProFights.gd` `_row` :217–221 and `Matchmaking.gd` const `GYM_SHARE` :55:** the gym's pay shows at a fixed 25%, and purse plus tickets is labelled "purse".
- **CODE — `scripts/ui/MoneyPanels.gd` `_earns` :281–285:** any booked bout shows +$450 (the amateur ticket cut), pro bouts included.
- **CODE — `scripts/ui/RosterTable.gd` `_boxer_cells` :44–46:** a pro row shows the amateur win-loss record with " pro" added, and the amateur rank.
- **CODE — `scripts/ui/areas/FighterPage.gd` `_tab` :143–144:** the contract card says "Club stipend, $250 a week, until turning pro" even for a pro.
- **CODE — `scripts/state/Career.gd` `add_news` :179–182 and `scripts/ui/areas/World.gd` `_news` :35–37:** mail news is marked own, and World > News skips own news, so the call, signing and lapse lines never reach the world feed.
- **CODE — `scripts/ui/BoutHistory.gd` `make` :40–42, `_milestone` :67–71:** the milestone header names the house, and `make` returns before the milestone when there are no rows.

## 2. What the code means for the three choices (ESTIMATE reading of section 1)

- **ESTIMATE — which house is dominated today.** Inside the two-house band, the guarantee house gives more gross at every count (CODE sum above), a bigger gap and more weeks. The ticket house's only edges are a debut 2 weeks sooner, a $500 step that is not live pay, and a step-up lean.
- **ESTIMATE (measured evidence, not code) — `docs/TURNGAP1_RESULT.md`:** with the opponent rating set the same way as `turn_pro` (night − gap), the win share was 35.5% at −4, 41% at −2, 67% at −1, 78.5% at 0, 79% at +1 and +2, 83.5% at +4 and 96.5% at +8 (20 boxers × 10 seeds per gap). Today's gaps of 1.0 and 1.5, and the softer +0.5, sit on the flat part of that curve, so they buy no measured safety. The steep part runs from −1 to 0.
- **ESTIMATE — the asks today.** The price ask is free money for the ticket house across 46–74. Covered costs moves most of the bill onto the boxer. The guarantee house's split is never available on a first call. Softer buys nothing measured. Later +4 gives little over +2. Hold is not a real option, because the red blocker forces an answer before any day passes.
- **ESTIMATE — when to turn today.** Stay is the only way to say no. Lapse looks like a free alternative (no −8 loyalty, no 0.9 terms), but play cannot reach it. Nothing in the call stops an amateur booking that collides with it.

## 3. Choice one: which house. A safer start, or an earlier and bigger gate

- **ESTIMATE — terms.** Keep the ticket house as it is. Set the guarantee house to a **$1,650** base with a **30% share above 75**. Set the gaps to **−1.0 for the ticket house and 0.0 for the guarantee house**. Keep the call band anchored at 60 ± 15. This changes `ProCall.promoters` only. The numbers it moves are `opp_gap` → the opponent's rating (`Roster.turn_pro` :306) → the fight, `purse`/`share` → `BoutFinish.run` pay → cash, and `debut_weeks` → the bout day → Build/Peak/Taper weeks.
- **ESTIMATE — plain debut money at a 25% cut, members held flat (worked from the `ProCall.money` formulas with the v9 terms):**

| Base sales | Ticket house gross / gym | Guarantee house gross / gym | Measured win share for the gap (TURNGAP1) | The trade |
|---:|---:|---:|---|---|
| 46 | $1,150 / $288 | $1,650 / $413 | 67% vs 78.5% | Guarantee: more money, safer, 2 weeks later. A thin gate should take it. |
| 66 | $1,650 / $413 | $1,650 / $413 | 67% vs 78.5% | Same money. Earlier and harder, or later and safer. |
| 74 | $1,850 / $463 | $1,650 / $413 | 67% vs 78.5% | Ticket: +$50 to the gym and earlier pay, for a harder opponent. |

- **ESTIMATE — no dominant pick:** the money crosses at 66, and above that the ticket house pays more while the guarantee house is safer. The win shares are pooled figures, not a card's chance. Show them as words ("harder start", "safer start") until section 9 calibrates a number.
- **CUT —** direct house switching, a guaranteed two-house call after a title, and win percentages on the cards.

## 4. Choice two: when to turn. Sign now, hold the offer, or free the amateur calendar

- **ESTIMATE — make hold real.** Make the offer an amber need and flag, not red, so the 14 days can actually pass. In `Sim.step_day`, before the blocker check, run `lapse_if_due` once per day (not only at `end_week`), and run it again on load and before sign or ask. The last usable day is `day < expires`. No offer is replaced on the same tick.
- **ESTIMATE — hold reserves only this boxer's calendar.** While the offer is live, `Bouts.accept`, `AskFlow.book`, `HomeBout.reason`, `ApproachWire` (before any show promise or payment), `RivalOfferWire.answer`, `LateAskWire` and `Champs.enter` refuse this boxer with "Answer the pro offer to book" and leave all state unchanged. `Roster.turn_pro` checks again that `f["bout"]` is empty. Offers already open when the call came keep their own deadlines. If one expires during the hold, it closes with no `Bouts.passed` loyalty charge and the news says it was missed. `LoyaltyWire.idle_week` pauses (does not reset) during the hold.
- **ESTIMATE — why holding costs something:** an entry or bout that needs answering inside the 14 days makes Stay worth its −8 loyalty and 0.9 terms. A quiet fortnight makes holding worth more than an early answer. Numbers it moves: loyalty (`Loyalty.MOVES` decline_pro −8), terms (`ProCall.terms`), `pro_wait_w`, and the bookings the boxer misses.
- **ESTIMATE — Stay and lapse, stated exactly.** Stay shows the real clamped loyalty change, the morale change, the next gate from `pro_ready` ("9 wins and top 3, or 11 wins" / "Only a No. 1 rank" / "No more calls"), the 0.9 terms and which house returns. The lapse shows "2 more wins after the offer runs out, then the normal call rules". This fixes the tooltip at `ProOffer.build` :73.
- **ESTIMATE — the queue.** Keep one active offer. Add `c.pro_queue` in arrival order: each entry saves the boxer id, the arrival day and the age, and is only an eligibility flag. Terms are made when the entry becomes active, and its 14 days start then. An entry that arrived before age 32 keeps the call. Skip a boxer who is booked or in a draw without losing the place. Drop a boxer who has left or turned pro (next to `Leaving._go` :94–95). Show the count on the offer header. No popup.
- **ESTIMATE — the route difference is real.** Signing ends a day-job boxer's training cut (`DayJob.count_of` :38 → `GymSpend.gain` :100: 4/6 → 6/6 of the stat gain) and ends the stipend accrual. Show "Training mornings after signing: 6 of 6 (now 4)" on the boxer strip. This is the honest day-job reason to turn sooner, and no gate needs changing.
- **CUT —** a separate "wait until the nationals" contract (Stay already covers it), an extra lapse penalty, and a guessed return week.

## 5. Choice three: what to ask for. One change per house

| House calling | Ask | Effect (v9) | Numbers it moves | Tag |
|---|---|---|---|---|
| Ticket house | Own ticket price | $40 tickets, +15 seats (cap 100), a **$45** selling fee now at a 25% cut (round(180 × cut), $18 at 10%) | gym cash now, night sales, purse and share | ESTIMATE |
| Ticket house, calling alone (75+) | Safer opponent | Gap −1.0 → −0.5 (the steep part of the curve) for $150 off the base | `opp_gap` → opponent rating; purse | ESTIMATE |
| Ticket house, calling alone (80+) | Harder for a bigger share | +10 share points and a gap of −1.5, both shown on the button | share; opponent rating | ESTIMATE |
| Either | Later debut +2 weeks | $100 off the base. Shown only when the weight plan or a recovery date differs between the two Saturdays | bout day → Build weeks; purse | ESTIMATE |
| Guarantee house | Cover costs (a loan) | $0 at signing. The balance plus the fee is repaid only from the gym's pro cuts, `min(balance, gym cut)` per paid bout. Any remainder is due from the gym when the boxer leaves or retires. The boxer's cut is unchanged | cash now; gym cut per bout; a balance on the boxer | ESTIMATE |
| Guarantee house | Safer opponent | Gap 0 → +0.5 sits on the flat part of the curve (78.5% → 79%) | none measured | CUT |
| Both | Later +4, the split counter, the guarantee-house split and price, the ticket-house cover | Clones, never available, or dominated (section 1) | none | CUT |

- **ESTIMATE — the price ask now has a downside (worked from the formulas, 25% cut, $45 fee, sales held flat):** the gym gets +$47 at 46, +$22 at 66 and +$12 at 74, ties at 84, and loses $1 at 85 and $95 at 100. The boxer gets $131–$278 more from 46 to 85, ties at 92 and loses from 93. In the two-house band its rival is +2 weeks, because a house allows only one ask. Hide the ask when the projected night range makes it strictly worse.
- **ESTIMATE — the ticket house alone at 85 base sales (gym, 25% cut):** plain $531, price $530, safer $494 at a gap of −0.5, harder share $563 at a gap of −1.5. Money and risk pull in different directions, so no single ask dominates.
- **ESTIMATE — cover as a loan, worked:** guarantee house $1,650, 25% cut, $1,245 costs, $100 fee. The debut cut of $413 repays the loan and $932 remains. The boxer gets $1,237, the same as plain. Once the loan is repaid, the gym has paid exactly the fee more than plain. Cover is for a gym that needs cash today. No loyalty charge.
- **ESTIMATE — sweep to run before shipping:** 46, 66, 74, 75, 80, 83–87, 92, 100 base sales at 25% and 10% cuts, with flat, rising (+6 members a week) and falling members, for a poor gym, a ready boxer and a boxer whose weight is at risk.

## 6. Money: one dated source, and the contract handoff

- **ESTIMATE — one helper.** A new `ProMoney.quote(c, f, deal)` returns cash out today, the next bill day and amount (`GameMoney.next_bill_day`, the accrual), the gym and boxer cuts on the booked Saturday, the loan balance after the debut, and the change to the weekly payroll. `ProOffer`, `ProWeekLines`, `MoneyPanels` (booked income), `ProFights._row` and the `BoutFinish` ledger all read it, using the boxer's actual share (`Roster.share_of`). Counterfactual amateur income stays labelled as an estimate. No break-even date is shown until it agrees with the 28-day bill.
- **ESTIMATE — the handoff.** Version new deals (`deal.v = 9`). Save the refusal-adjusted base, step and top before any one-off ask. For a versioned contract, `Matchmaking.pay_of` uses that base in place of `PURSE_UNRANKED`, keeping the rank and draw additions and the fan tickets. The base rises once per settled **post-debut** win, capped at top. A booked fight is never repriced. Old saves keep the current formula and have no step promise. Until this ships, delete the step promise in `ProWeekLines.next_line` and on the card.
- **ESTIMATE — 10% stays 10%:** `StarDeal.terms` year-lower becomes `minf(share, maxf(FLOOR, share − YEAR_STEP))`.
- **ESTIMATE — ledger:** forecast at signing → sold on the night, signing outlay, gym cut, repayment, balance left, and stipend saved vs the **estimated** lost cut. Cover the full wait (6 weeks or 8 with +2), not a clamp at 4.

## 7. Goals and the boxer, told truthfully

- **ESTIMATE —** save a stable goal at recruitment (`f.goal_kind`: title / pro / record) and mark it met when it is reached. Add the pro goal for recruits with bout experience so the existing +5 sign / −5 stay runs. Charge the title −5 only when `Champs.cannot_enter` is "" (entry open, no run this year). Show the real morale and loyalty changes, zero and clamping included, on each button.
- **ESTIMATE —** the age warning from 29 only on a first call. The first-card return lock and the separate lapse wait of +2 wins stay as they are.
- **CUT —** a separate −5% debut performance for the title goal. Morale already carries the cost.

## 8. Where it appears

| Menu | CODE TODAY (file · function · lines) | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|
| Top bar | CODE `Shell.gd` `_build_top` :152–159 → `Needs.flags` :166–167, red "PRO OFFER" outside Home | Amber flag. No countdown in the bar |
| Continue | CODE `Main.gd` `on_go` :196–200, `Clock.stop_now` :77–81: blocked by the offer | Runs while the offer is held; daily lapse check |
| Home | CODE `HomeNeeds.gd` `build` :43–55 (via `ranked`) → `Needs.needs` :66–69, red note, house names in the body (`_pro_line` :198–205), "Hear it" | Amber note: days left, no names in the body |
| Offer header | CODE `ProOffer.gd` `build` :32–42 | Days left, the exact gate after Stay, the queue count; names here only |
| Offer cards | CODE `ProOffer.gd` `_house` :103–145, `ProOfferWire.money` :117–129 | Equal cards with a card-local "Sign". Date, Build weeks, matchmaking words, cash now / on the night / boxer, from `ProMoney.quote` |
| Offer asks | CODE `ProOffer.gd` `_ask` :149–170 → `ProOfferWire.ask` :74–89: six buttons | Only the asks in section 5's table, each with its live change; spent state; back to plain |
| Offer tickets | CODE `ProOffer.gd` `_tickets` :83–99, fixed $50 / 60 | Per-house break-even marks, the deal's price |
| Boxer strip | none (CODE: morale only in button text, `_mood` :173–174) | Goal and morale, training mornings after signing, stipend that ends |
| Offer footer | CODE `ProOffer.gd` `build` :54–79 → `RosterActs.act` "declinepro" :88–91 → `Roster.decline_pro` | Stay with the gate and terms. Review later (closes, keeps everything). A link to the week plan |
| Fighter → Next Step | CODE `FighterPage._road_input` :323–339 → `NextStep.road` :15–68, `pro_line` :73–89 | "Offer open · N days" when the offer belongs to this boxer, an age check on the step, singular/plural, no names |
| Fighter → contract | CODE `FighterPage._tab` :143–144, fixed stipend text | Pro share, house in the header, loan balance |
| Roster table | CODE `RosterTable._boxer_cells` :44–49 | Pro record and world rank for a pro |
| Money → stipends / booked | CODE `MoneyPanels._fighter` :241–264, `_earns` :281–285, `_stipend_card` :360–369 | Pro quote from `ProMoney.quote`, net of the loan |
| Fights → ladder | CODE `ProFights._row` :217–221, `ProLean.line` :41–47 (names the house in the body) | Actual share, "pay" not "purse", no names in the body |
| Week review | CODE `ProWeekLines.rows` :62–75 / `lines_for` :15–42 | The full ledger in section 6, no step promise |
| History | CODE `BoutHistory._milestone` :67–71, `make` :40–42 | The milestone even with no rows; house in the header only |
| News / mail | CODE `Career.add_news` :179–182; `World._news` :35–37 filters it out | Keep it in mail and Records. CUT a world-feed copy |
| Office desktop | CODE `OfficeDesk.gd` icon table :39 maps "prooffer" to the contract icon | No change |
| Toasts | CODE `RosterActs.act` :73–91 | No names; the debut date |

## 9. Evidence to collect before any number goes on a card (ESTIMATE)

- **ESTIMATE —** 200+ paired real-path debuts per house, on the same boxers and seeds. Book through `turn_pro` and run the real camp to settlement. Split by day job, readiness and weight risk, and include draws and cancellation. Expected order: roughly 62–72% for the ticket house and 75–83% for the guarantee house (from the TURNGAP1 points at −1 and 0). Calibrate on separate bouts, and show a range only where reliability is within 10 points. Otherwise use words.
- **ESTIMATE —** test cases: a near-deadline title entry (Stay should win), a quiet fortnight (holding should win), a fit early debut (signing should win), and a cash-short guarantee call (cover should win). Pick rates are there to find dominance, not to hit a quota.
- **ESTIMATE —** state tests: last day and reload, a double press on Sign, a pre-existing amateur offer, a show promise during the hold, age 31→32 while queued, leaving before and after the debut with a loan open, and a 10% share through talks and timeout.

## 10. The critics' lists, answered

### The v8 critic's nine points (6/6/7)
| # | Point | v9 answer |
|---|---|---|
| 1 | Make the hold playable and fair | ESTIMATE §4: amber need, daily lapse, write-path guards in seven named files, the `turn_pro` bout check, idle pause |
| 2 | Queue other boxers | ESTIMATE §4: `c.pro_queue`, the clock starts on activation, the age at arrival is kept |
| 3 | One dated money source | ESTIMATE §6: `ProMoney.quote`, the 28-day bill, cover as a loan, departure and retirement settle the loan |
| 4 | The contract handoff | ESTIMATE §6: versioned base in `pay_of`, post-debut step, no repricing, the step promise deleted until it ships |
| 5 | Asks that differ | ESTIMATE §5: per-house table, the fee, single-house risk asks, +2 kept, +4 cut, a sweep list |
| 6 | Training and forecasts as one calculation | ESTIMATE: `WeekData.plan_of` applies `GymSpend.gain`'s day-job share (CODE gap in §1). Until then the +2 ask shows only weight and recovery facts, and the strip shows mornings, not stat forecasts |
| 7 | Truthful goals and gates | ESTIMATE §7 and §4: stable goal, `cannot_enter`, exact gates, age line on first calls only, fixed tooltip |
| 8 | 200-bout paired validation | ESTIMATE §9 |
| 9 | Finish the surfaces | ESTIMATE §8: each leak in §1 has a row |
| — | Its ten missing interactions | All ten are covered by points 1–9 above. The show promise is the `ApproachWire` guard, the 10% rise is `StarDeal.terms`, and the names are the §8 rows |

### The earlier critic's list (6/7/6)
| Point | v9 answer |
|---|---|
| Review later, no penalty | ESTIMATE §4 (it works only once the offer is amber) |
| Hide the dead asks | ESTIMATE §5: shown only when available and different, the rest CUT |
| Explicit expiry and decline rules | ESTIMATE §4 exact lines, using the real gate, not "2 more wins" for every case |
| Fix lapse beating Stay | ESTIMATE §4: lapse costs time and the calendar is held; Stay frees bookings now. CUT the extra lapse penalty |
| Boxer strip: goal, route, gate | ESTIMATE §4, §7, §8 |
| Night forecast on the delay ask | ESTIMATE: two scenarios (members flat; members drifting, at most +6 a week) on +2 only; +4 CUT |
| Price warning on the button | ESTIMATE §5: crossover with the fee, from the live forecast |
| Real numbers on cover | ESTIMATE §5: loan balance, fee tier and runway shown |
| Career lean on each card | ESTIMATE §8: one line per card, no names in the body, "when a candidate exists" |
| Win chance range | CUT until §9 calibrates it. `docs/TURNGAP1_RESULT.md` shows the signing read (45.3% / 50.5%) is below the measured win share (67% / 78.5%) |
| Decline ladder visible | ESTIMATE header and Stay button |
| Link to the week | ESTIMATE footer link |
| Forecast vs night in the review | ESTIMATE §6 ledger |
| Fix the ambition wiring | ESTIMATE §7 (a saved goal, not a one-string change that would flip with the record) |
| Missing: day-job status | ESTIMATE §4: real mornings 4/5/6, from `DayJob.count_of` |
| Useless: softer, split, +4 | Softer and split are kept only for the ticket house calling alone, where they change risk on the steep part of the curve; +4 CUT |

### Earlier versions (carried from v8 §7, rechecked against the code)
- **ESTIMATE —** the v4–v7 requests keep their v8 decisions: equal cards, no column swap, price from the deal (CODE `ProCall.money` :117), the age warning from 29, cover stops being a subsidy, no early-gate badge for day jobs (CODE: no such gate in `pro_ready`), and History and Week review carry the milestone.
- **ESTIMATE —** the brief's rule 2 names "the v4 critic". This map reads that as the critics named in the brief's inputs and answers their lists above. The v4–v7 points are carried here.

## 11. Owner rules kept
- **ESTIMATE (rules, not code) —** names only in headers (S448: "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule"). Gender-neutral game text (S412). Scope ends at the debut, and the handoff only pays what was signed (S428). No new screen. Only actionable information (S425: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it"). A 14-day offer. A Taper week before the fight. One top bar and one modal; nothing opens by itself. Everything ships switched on. Hover explains every number, and costs are visible without hover.

## 12. The offer at 1920×1080 (ESTIMATE)
- **ESTIMATE —** the existing warm-wall modal, 1240 wide with two cards (CODE `ProOffer.build` :28). Header: boxer and house names, days left, declines left and the next gate, queue count. Ticket bar with both break-even marks. Two equal cards, each showing: date and Build weeks, matchmaking words, cash out today, gym on the night, boxer on the night, the one ask with its live change, and Sign. Strip: goal and morale, training mornings after signing, stipend that ends. Footer: Stay amateur (gate, terms, loyalty), Review later (closes and keeps everything), the week-plan link. No second modal, no win percentages.

## 13. Cut list
- **CUT —** Later +4. The split counter. The guarantee-house split, price and safer asks. The ticket-house cover. Win percentages on the cards. Direct house switching. An extra lapse penalty. The world-feed copy of the call. A −5% debut performance for title goals. A separate nationals hold. A guessed return week.
