# LEDGER1 v5 — Design Map: What a Boxer's Books Actually Say

Design Loop S459 | Task LEDGERREV5 (S530) | Discipline: boxing
Priority Order: Amateur Week → Office → Coach Depth → This Map

## Claude's check on v5 (S530)

Two v4 critics scored Dola 8/8 and Arena 6/5. This version answers every Arena item and the Dola items the task names.

**Build change named first.** `Career.pay(amount, what)` today writes `{d, t, amount}` — no boxer id, no kind. A per-boxer
view needs one change: `pay(amount, what, fid := "", kind := "")` stores the boxer id and a kind (bout, camp, bill,
stipend, dues, club). The weekly stipend and dues are not ledger lines today: `Sim.gd` lines 303-312 write cash
directly (`GameMoney.settle_week` adds income and accrues costs; the month bill is one line "Month-end bill: wages
and upkeep"). The per-boxer view must add the stipend from `f["weekly_salary"]` per week paid, and the dues from
`Membership.weekly_dues` split across boxers — both as ESTIMATE lines never added to cash, until the build adds them.

**Release fee is money in.** `Leaving.gd` line 93: `c.pay(fee, "Release fee: ...'s new manager")` — positive, the
pro's new manager pays the gym. v4 put it under Cash Out in every table. The real choice is "fee now vs the share
this pro brings per bout" (break-even in bouts from `StarDeal.gym_net`).

## 1. The Build Change

### Current `Career.pay(amount, what)` — writes `{d, t, amount}`

Every call site the per-boxer view needs:

| File | Line | Call | Kind |
|---|---|---|---|
| `BoutFinish.gd` | 114 | `c.pay(int(tickets["gym"]), "Debut tickets: ...")` | bout |
| `BoutFinish.gd` | 120 | `c.pay(Roster.gym_cut(purse, f), "Purse share ...")` | bout |
| `BoutFinish.gd` | 138 | `c.pay(BoutRules.TICKET_CUT, "Ticket cut: ...")` | bout |
| `Leaving.gd` | 93 | `c.pay(fee, "Release fee: ...'s new manager")` | club |
| `ProLadder.gd` | 307 | `c.pay(-MM.SCOUT_COST, "Scouting ...")` | camp |
| `GymDeals.gd` | 29 | `c.pay(-bill, "Pro camp for ...")` | camp |
| `GymDeals.gd` | 33 | `c.pay(-cut, "Cutman for ...")` | camp |
| `GymDeals.gd` | 64 | `c.pay(-int(t["bonus"]), "Signing bonus: ...")` | club |
| `GymDeals.gd` | 105 | `c.pay(int(c.grant["amount"]), "Club grant: ...")` | club |
| `Sim.gd` | 65 | `career.pay(int(once["cash"]), "...")` | club |
| `Sim.gd` | 474 | `career.pay(-GameMoney.COACH_SIGNING_FEE, ...)` | club |

### What is NOT in the ledger today

| Receipt or cost | Where it lands | Code line |
|---|---|---|
| Weekly stipends | `f["weekly_salary"]` summed by `GameMoney.athlete_payroll()` into the month bill | `GameMoney.gd` `athlete_payroll()` |
| Weekly dues | `Membership.weekly_dues()` → `GameMoney.weekly_income()` → cash | `Sim.gd` line 303-305 |
| Month bill | One line: "Month-end bill: wages and upkeep" | `Sim.gd` line 319 |

### The change

`Career.pay(amount: int, what: String, fid := "", kind := "")` stores the boxer id and a kind. Every call site
above passes its `fid` and `kind`. The per-boxer view reads `fid` to filter, never matches on text. The weekly
stipend and dues become ESTIMATE lines (labelled, never added to cash) until the build writes them to the ledger.

---

## 2. What the Player Decides

Every decision has a WHEN rule, an alert lifecycle, and the rule file that governs it.

| Decision | What It Means | WHEN Rule | Trade-off | Tag |
|---|---|---|---|---|
| **Keep / Release** | Keep the boxer or let them go | Release when legal (no booked bout); the fee is cash in for a pro. Keep when a bout is booked or the pro's share pays more than the fee. | Keep: −stipend/wk; future income secured. Release: amateur free (no stipend saved if on a day job), pro brings in max($500, year_take × 0.4). −rep (−1 amateur, −3 ranked; −2 loyalty, −5 if ranked). Spot opens. | CODE — `Leaving.gd` `let_go()`, `leave()` |
| **Toggle Stipend** | Pay or change the club sponsorship (amateurs only) | Three states: full ($250/wk), half ($125/wk, one work morning), day job ($0, two work mornings). Pause when cash is tight; half when a middle step helps. | Full: −$250/wk, full training. Half: −$125/wk, trains ×0.925, loyalty +3 up / −4 down. Day job: $0, trains 4 of 6 days, loyalty −8 once at pause / +5 once at resume. A pro cannot be paused ("a pro lives on purses"). Stipend locked from the answer to an approach, for 84 days. | CODE — `GymSpend.gd` `set_stipend()`, `set_half()` |
| **Answer Club Approach** | Eastside ABC comes for a boxer (loyalty < 35, worth taking, 12-wk clear) | When the card appears — 7 days to answer (`Approach.ANSWER_DAYS`) or the boxer leaves. | Five answers with cash and loyalty (see Section 5). | CODE — `ApproachWire.gd` `answer()` |
| **Answer Bout Challenge** | A rival gym rings for a bout at the next region show | When the offer appears — 4 days to answer or it lapses as a pass. | Accept / Not This Show / Pass. Free while hurt or booked. | CODE — `RivalOfferWire.gd` `answer()` |
| **Renegotiate Contract** | A pro reaches top-10 or wins a belt; a bigger firm calls | When the milestone flag appears — 14 days to answer or the lower share stands. | Top-10: keep 25% for $2,500 or drop to 20%. Belt: keep share for $5,000 or drop to 17%. Yearly: keep share for 40% of year_take (min $500) or drop 2 pts (floor 12%). A belt also opens a title sponsor on Money > Deals. | CODE — `StarDeal.gd` `terms()`, `GymDeals.gd` `answer_talks()`, `check_talks()` |
| **Push for Pro** | Accept or decline a pro offer (14-day window) | When the offer arrives. Decline: same promoter calls again after 2 more wins (third decline: door closed). | Turn pro: stipend ends, purse share begins. Stay amateur: keep stipend, more amateur bouts. | CODE — `ProOfferWire.gd`, `ProCall.gd` |

### Alert Lifecycle

| Alert | Trigger | Dismissed → Returns When | Escalates When |
|---|---|---|---|
| 🟡 Yellow | Next bill leaves projected club cash below $0 | Returns at the chosen Review Monday unless the reason clears or severity rises | → Orange at 6 weeks negative |
| 🟠 Orange | Projected cash path threatens the gym's closure rule with a bout bookable | Returns in 2 weeks if no bout booked | → Red when projected no-bout cash path threatens the gym's 8-week closure rule |
| 🔴 Red | Projected no-bout cash path threatens the gym's 8-week closure rule (`GymBills.CLOSE_AFTER_WEEKS`) | Not dismissible — stays until a club lever clears the cash risk | Stays until resolved |

The yellow and orange alerts are NOT BUILT as per-boxer rules today. The red alert is club-wide (`GymBills.status`).

---

## 3. True Cash — What the Books Actually Record

### The Club Column (shared, never split across boxers)

| Line | Source | Amount | Why shared |
|---|---|---|---|
| Member dues | `Membership.weekly_dues()` → `Sim.gd` line 303 | Members × fee(band) / WEEKS_A_MONTH | Members are a club pool; no per-boxer attribution |
| Rent | `GymBills.week()` → `rent_month / WEEKS_A_MONTH` | ~$415/wk | Facility cost |
| Coaching | `GymBills.week()` → `coach_hours × COACH_HOUR` | Varies | Shared resource |
| Governing-body fees | `GymBills.week()` → `(CLUB_YEAR + boxers × BOXER_YEAR + coaches × COACH_YEAR) / 52` | $18/boxer/year pro-rated | Annual registration; per-boxer but billed to the club |
| Power | `GymBills.week()` → `power_month() / WEEKS_A_MONTH` | $65-130/wk by season | Facility cost |
| Insurance | `GymBills.week()` → `INSURANCE_YEAR / 52` | ~$24/wk | Club policy |
| Staff wages | `GymSpend.costs()` → `StaffRoles.wages()` | Varies | Shared resource |
| Kit budget | `GymSpend.costs()` → `kit(c)["week"]` | $0/45/80 by level | Shared resource |
| Upgrades upkeep | `GymSpend.costs()` → `GymUpgrades.upkeep()` | Varies | Shared resource |
| Juniors' coach | `GymSpend.costs()` → `JUNIORS_COACH` | $168/wk if youth section on | Shared resource |

### Per-Boxer Cash In (tagged in the ledger by `Career.pay()`)

| Line | Source | Amount | Ledger tag |
|---|---|---|---|
| Amateur ticket cut | `BoutFinish.gd` line 138 → `BoutRules.TICKET_CUT` | $450 per amateur bout (0 for a championship, club show, or host-kept gate) | "Ticket cut: Name vs Opponent" |
| Pro purse share | `BoutFinish.gd` line 120 → `Roster.gym_cut()` → `StarDeal.share()` | Gym's % of purse (start 25%; renegotiated) | "Purse share (X%): Name vs Opponent" |
| Pro debut ticket share | `BoutFinish.gd` line 114 → `Roster.debut_night()` → `ProDebut.night()` | Gym's cut of tickets past break-even | "Debut tickets: X sold, the gym's Y%..." |
| Release fee (pro only) | `Leaving.gd` line 93 → `release_fee()` | max($500, year_take × 0.4 rounded to $100); amateur = $0 | "Release fee: Name's new manager" |

### Per-Boxer Cash Out (tagged in the ledger by `Career.pay()`)

| Line | Source | Amount | Ledger tag |
|---|---|---|---|
| Signing bonus | `GymDeals.gd` line 64 → `answer_talks()` | $2,500 (top-10) / $5,000 (belt) / max($500, year_take × 0.4) (yearly) | "Signing bonus: Name stays on X%" |
| Scouting | `ProLadder.gd` line 307 → `Matchmaking.SCOUT_COST` | $250 per pro opponent scouted | "Scouting X for Y" |
| Pro camp bill | `GymDeals.gd` line 29 → `StarDeal.camp_bill()` | 6% of purse (halved with S&C coach) per pro bout after debut | "Pro camp for Name: sparring partners and meals" |
| Cutman | `GymDeals.gd` line 33 → `StaffRoles.per_bout()` | $150 per pro bout (if on staff) | "Cutman for Name's night" |
| Pro licence + medicals | `ProDebut.gd` `start_costs()` | $230 + $875 + $140 = $1,245 (first time) | In the debut costs; paid once |

### What is NOT tagged with a boxer (ESTIMATE lines, never added to cash)

| Receipt or cost | Current code | Per-boxer view shows |
|---|---|---|
| Weekly stipend | `f["weekly_salary"]` summed into the month bill | ESTIMATE: "$250/wk × N weeks" from the boxer's own salary |
| Weekly dues | `Membership.weekly_dues()` → cash directly | ESTIMATE: club dues divided across boxers or shown as a club line |
| Member growth from a win | `BoutFinish.gd` adds `WIN_MEMBERS` (8) to `c.members` | ESTIMATE: the real effect from `Membership.settle_week` replay (see Section 4) |

### Cash Reconciliation Rule

The sum of all per-boxer tagged entries + the CLUB column entries = `Career.cash` (to rounding). The per-boxer
view shows only tagged entries. ESTIMATE lines are labelled and never added into cash.

Words: "Cash in / Cash out / Net", never "worth".

---

## 4. Dues From a Win — The Real Effect

A win adds `BoutRules.WIN_MEMBERS` (8) to `c.members`. The dues effect is NOT a flat "$65 a week". It depends on
where the gym sits relative to its target.

### Replay of `Membership.settle_week` after a win

The walk closes a quarter of the gap to the target, capped at 6 members a week. A win adds 8 members at once, but
the target may be lower. Example:

- Before the win: 80 members, target 90 → gap 10.
- Win adds 8: now 88. Gap to target: 2.
- Week 1 after: walks 1 (quarter of 2, at least 1) → 89.
- Week 2: walks 1 → 90. Target reached.

The dues effect depends on the band (cheap $25, standard $35, premium $45 a month). At standard:
- 8 members × $35 / 4.33 weeks = ~$65/wk IF the target allows all 8 to stay.
- But if the gym was already near target, some leave: the walk goes both ways.

**The per-boxer view shows an ESTIMATE line:** "Win vs X: +8 members, about +$Y/wk for N weeks" — computed from
`Membership.settle_week` replayed with the win, never added to cash. No flat "$65 a week" figure.

---

## 5. The Approach — Five Answers With Cash and Loyalty

Each answer shows its cash cost, loyalty effect and training change. Deadline: 7 days (`Approach.ANSWER_DAYS`).

| Answer | Cash | Boxer loyalty | Holder loyalty | Training | Availability | Refusal reason |
|---|---|---|---|---|---|---|
| **Match** | On a keep offer: −$3,000 (84 days × $250 stipend restart). On a bout offer: $0. | +12 | — | ×1.0 | Always | — |
| **Half** | $0 (splits the stipend in two). | +6 (or +10 if the talk landed) | −4 | Both ×0.925 | Needs a holder (most loyal teammate on stipend, not the boxer, not a pro, no day job, paid) AND the talk did not fail AND it is a stipend offer | "the talk failed" / "nobody holds the stipend" / "not a stipend offer" |
| **Move** | $0 (moves the stipend to the approached boxer). | +12 | −12 at once, −3 every 28 days | Approached ×1.0; holder ×0.85 | Needs a holder | "nobody holds the stipend" |
| **Promise** | −$3,500 for the club show (`Approach.SHOW_COST`). | +4 now, +10 if kept | — | ×1.0 | Needs a bookable club show (`ClubShow.can_book()` and `HomeBout.reason() == ""` and `c.cash >= ClubShow.COST`) | "no show can be booked now" |
| **Let Go** | $0. Boxer leaves next Monday. | — | Each teammate under loyalty 50: −2 | — | Always | — |

**Tell It Straight** (optional, once per approach): free. Landed: 0 loyalty. Failed: −4. Blocked 8 weeks after a talk.

**Lapse:** Unanswered past 7 days → the boxer leaves for Eastside ABC.

---

## 6. One Comparison From the Same State

Keep as is / Half stipend / Pause stipend (day job) / Release (when legal) on one eight-week view from
`CashForecast.project()`:

| Row | Keep as is | Half stipend | Pause stipend (day job) | Release (when legal) |
|---|---|---|---|---|
| Next bill | Date and amount from `CashForecast.bill_split()` | Same bill; stipend line halved | Same bill; stipend line drops | Same bill; all per-boxer costs stop |
| Lowest projected club cash | From `CashForecast.project()` | Higher (stipend halved) | Higher (stipend saved) | Higher still (all costs stop) + release fee if pro |
| Next booked bout | Date from `f["bout"]` if set; dashed line if not booked | Same; training pace ×0.925 | Same; training pace 4/6 | None — bout goes with the boxer or is withdrawn |
| Avoidable spend | Stipend × 8 weeks | $125 × 8 weeks saved | $0 stipend | $0 stipend + release fee if pro |
| Release fee | $0 | $0 | $0 | max($500, year_take × 0.4) for pro; $0 amateur |
| Loyalty change | Forecast from `Loyalty.forecast_line()` | +3 when it goes on; −4 when it comes off | −8 once at pause; +5 once at resume | "teammate_left" (−2) on each Settled teammate; −1 rep (amateur) or −3 (ranked) |
| Roster place | Filled | Filled | Filled | Opens |

A bout that is not booked is a dashed conditional line, never an exact break-even date. The release fee is shown
ON the comparison where Release is chosen: "Release now: +$X fee this week, +$Y saved weekly from week 1".

---

## 7. One Warning Table — Club-Wide Levers for the Red Alert

The red alert is a club-wide cash crisis. The answers are club levers, not just per-boxer.

| Lever | Eight-week cash effect | Source |
|---|---|---|
| **Dues band** (cheap $25, standard $35, premium $45 a month) | Cheap draws 15% more members; premium 15% fewer. Switch to cheap: +members, −per-member dues. | `Membership.DUES` |
| **Kit budget** (low $0, standard $45, good $80 a week) | Low saves $45/wk but raises injury risk ×1.25. Good costs $35 more but lowers risk ×0.90 and adds 2 members. | `GymBills.KIT_BUDGET` |
| **Half stipend** (one amateur) | Saves $125/wk × 8 = $1,000. Boxer trains ×0.925. | `GymSpend.set_half()` |
| **Pause a stipend** (one amateur) | Saves $250/wk × 8 = $2,000. Boxer takes a day job, trains 4/6. | `GymSpend.set_stipend()` |
| **Release one boxer** (amateur) | Saves stipend × 8 weeks; costs −1 rep (−3 if ranked), −2 loyalty per Settled teammate. | `Leaving.gd` `let_go()` |
| **Release one boxer** (pro) | Brings in max($500, year_take × 0.4); costs −1 rep (−3 if ranked), −2 loyalty per Settled teammate. | `Leaving.gd` `release_fee()` |
| **Evening coach** (let go) | Saves $350/wk × 8 = $2,800. Classes income stops. | `GymSpend.costs()` → `StaffRoles.EVENING_WAGE` |
| **Overdraft** (after 12 weeks trading) | 16% a year on the drawn balance; limit = 100% of last 4 weeks' income. Changes whether the red alert is reached. | `Overdraft.gd` |

This needs `CashForecast.project(c, weeks, change)` where `change` is an optional dictionary applied to a copy
(`CashForecast._copy` already exists).

---

## 8. The Reward Side

### Self-funding state

When a boxer reaches break-even (cumulative tagged cash in ≥ tagged cash out) AND has a bout booked AND no alert
is active:
- Contract tab: green line "✅ Self-funding — brings in $X/bout above cost"
- Week Review row: small +$X badge showing the last bout's net contribution

### Milestone value line (CONDITIONAL)

After the debut a pro's bout pays purse × share (`BoutFinish.gd` line 120). No ticket cut after the debut.
Each tier from `StarDeal.gym_net(purse, 0, share, strength)`:

| Milestone | Source | Computation | Label |
|---|---|---|---|
| Top-3 rank | `StarDeal.gym_net()` at current purse step | `(purse) × share − camp_bill` per bout × projected bouts/year | CONDITIONAL — "at a top-3 rank: ~$X/bout" |
| Pro debut | `ProDebut.night()` at current forecast | `gym_cut` from tickets sold | CONDITIONAL — "at debut: ~$X" |
| Belt | `StarDeal.gym_net()` at belt purse step | Same as top-3 with higher purse | CONDITIONAL — "at a belt: ~$X/bout" |

These are never added into cash. They are shown as "CONDITIONAL — depends on rank and bookings".

---

## 9. Conditional Choices

Each answer shows its availability and refusal reason from the rule. Deadlines and lapse outcomes are shown before choosing.

### Answer Club Approach (`ApproachWire.gd`)

| Answer | Availability | Refusal reason | Deadline | Lapse |
|---|---|---|---|---|
| Match | Always | — | 7 days | Boxer leaves for Eastside ABC |
| Half | Needs a holder AND the talk did not fail AND it is a stipend offer | "the talk failed" / "nobody holds the stipend" / "not a stipend offer" | 7 days | Same |
| Move | Needs a holder | "nobody holds the stipend" | Same | Same |
| Promise | Needs a bookable club show | "no show can be booked now" | Same | Same |
| Let Go | Always | — | Same | Same |

### Answer Bout Challenge (`RivalOfferWire.gd`)

| Answer | Availability | Refusal reason | Deadline | Lapse |
|---|---|---|---|---|
| Accept | Always (if the rival is still in the club); can still fail at booking | "that boxer is gone" / "the bout could not be booked" | 4 days | Lapses as Pass |
| Not This Show | Once a season with that rival (`not r["not_this_show_used"]`); a second use counts as a pass (−2 ladder points unless hurt or booked) | "Already used this season — counts as a pass" | Same | Same |
| Pass | Free while hurt or booked (no ladder cost); otherwise −2 ladder points to challenger | — | Same | Same |

The `_free()` function in `RivalOfferWire.gd` returns true when the boxer is NOT booked and NOT hurt — the name
is inverted. A builder should rename it `_charged()` and fix the comment at line 98.

### Renegotiate (`StarDeal.gd`, `GymDeals.gd`)

| Answer | Availability | Refusal reason | Deadline | Lapse |
|---|---|---|---|---|
| Keep share (pay bonus) | `c.cash >= bonus` | "$X short of the price" | 14 days | Lower share stands |
| Drop to lower share | Always | — | Same | Same |

A belt also opens a title sponsor on Money > Deals (`GymDeals.check_talks`).

### Push for Pro (`ProOfferWire.gd`, `ProCall.gd`)

| Answer | Availability | Refusal reason | Deadline | Lapse |
|---|---|---|---|---|
| Sign | `c.day < expires` | "Offer ran out" | 14 days | Promoter walks; calls again after 2 more wins; third decline: door closed |
| Stay amateur | Always | — | Same | Same |

Deals are committed only on their existing screens; the ledger links there.

---

## 10. Where It Appears — Menu Wire Map

| Screen | What Is Shown | What You Can Do | Wired To |
|---|---|---|---|
| **Fighter Page → Contract Tab** | Full ledger (tagged entries only, week number + source on each line); 8-week club cash plot with per-boxer conditional paths dashed; loyalty forecast; alerts; comparison | Keep / Release; toggle stipend (full / half / day job); renegotiate; set review date; compare | Fighter Roster → Contract Tab → Money Page → Week Review |
| **Club → Money → Per-Boxer View** | Sortable table: cash in, cash out, net, weeks to break-even, alert, next bout | Sort by any column; toggle stipends; compare boxers | Money Page → Contract Tab → Week Review |
| **Week Review (per fighter row)** | That week: stipend vs tagged income; alert status; self-funding badge if applicable | Open full ledger; set review reminder; toggle stipend; Find Bout (from 🟠 row → Fights > Ask for a Fight) | Home → Week Review → Contract Tab |
| **Pro Offer Modal** | Debut terms side by side; forecast; ask answers with availability | Accept / Decline; negotiate terms | Pro Offer → Contract Tab → Money Page |
| **Approach Card** | Five columns with cash, loyalty, training, availability and refusal reasons; holder info; 7-day deadline | Pick one answer; optionally Tell It Straight first | Home → Needs Flag → Approach Card → Contract Tab |
| **Bout Challenge Card** | Rival name + club; show date; my rep vs their rep; pass cost; "not this show" availability; free exemption when hurt/booked | Accept / Not This Show / Pass | Home → Needs Flag → Bout Challenge → Contract Tab |
| **Renegotiation Modal** | Step (top-10 / belt / yearly); keep share + bonus amount; lower share; 14-day deadline; cash check | Keep (pay bonus) / Drop to lower share | Money → Renegotiation → Contract Tab |
| **Office → Fighters Card** | Quick snapshot: club cash, next bill, alert count | Click through to per-boxer view | Office → Contract Tab → Money Page |

---

## 11. Probes to Prove It

Decision probes hold the start state and seed and change ONE decision. Fixtures:

| Fixture | Start state | Decision changed | Pass line |
|---|---|---|---|
| Cash-rich gym | $40,000 cash, 3 amateurs, 12 weeks | Keep all vs release the weakest at week 6 | Keeping all: net cash > $20,000 at week 12; releasing the weakest: net cash > $25,000 but −1 rep. Both legal; neither dominates. |
| Cash crisis | $2,000 cash, 4 boxers, all negative | Half all stipends vs pause 2 vs release 2 | Half: gym survives 12+ weeks; pause 2: survives 16+ weeks; release 2: survives 20+ weeks but −2 rep and −4 loyalty (teammates). Half wins on rep; release wins on cash. |
| Suspended prospect | 1 boxer, 8 weeks post-bout rest, no income | Keep paying stipend during rest vs pause | Keep: loyalty holds, cash drops $2,000; pause: loyalty −8 once, cash holds. Neither dominates — keep wins on loyalty, pause wins on cash. |
| Two boxers sharing a stipend | Approach card: Half or Move available | Half vs Move | Half: both train ×0.925, holder −4; Move: boxer full training, holder −12 at once and −3 every 28 days, trains ×0.85. Half wins on holder loyalty; Move wins on the approached boxer's training. |
| Pro on reduced share | Pro at 25% share, top-10 reached, talks open | Keep 25% for $2,500 vs drop to 20% | Keep: cash −$2,500 now, +5% × purse per bout after; Drop: cash saved, −5% × purse per bout after. At $1,500 purse, keep pays back after ~33 bouts. At $5,000 purse over 10 bouts, keep wins. Neither dominates everywhere. |
| Pro release vs keep | Pro at 25% share, $2,000 purse, 4 bouts/year | Release now (+$X fee) vs keep (5% × purse × 4 bouts/year) | Release: +max($500, year_take × 0.4) now, −rep, −loyalty; Keep: +5% × $2,000 × 4 = $400/year. At year_take $3,000, fee = $1,200; release wins on cash, keep wins on rep and loyalty. |

**Pass conditions:**
- Each decision is best somewhere (no policy wins everywhere)
- Warning lifecycle matches the table in Section 7
- Cash reconciliation: sum of per-boxer tagged entries + CLUB = `Career.cash` to ±$1
- Locks and booked-bout guards hold (stipend locked from the answer for 84 days; release blocked when any bout is booked)
- Release quotes match code: amateur $0, pro max($500, year_take × 0.4)
- Renegotiation terms match `StarDeal.gd`: top-10 $2,500/20%, belt $5,000/17%, yearly 40%/2pts
- Approach card shows five columns matching `Approach.answers()` with correct cash, loyalty and availability
- Bout challenge card shows three choices matching `RivalOfferWire.view()` with correct free exemptions
- Review date shows what changed against the earlier plan

---

## 12. Scope — What It Does & Does NOT Do

### ✅ Does
- Show every tagged receipt and payment per boxer from `Career.ledger` (Cash in / Cash out / Net) with week number + source
- Keep shared bills in the CLUB column, never in a boxer's total
- Label ESTIMATE lines (stipend, dues, membership effect) separately and never add them into cash
- Compare Keep / Half / Pause / Release on one eight-week view from `CashForecast.project()`
- Show the release fee ON the comparison where Release is chosen
- Show one warning table with yellow / orange / red; the red alert offers club-wide levers
- Show all three stipend states (full / half / day job) for amateurs only
- Show conditional choices with availability, refusal reasons, cash and loyalty from the rules
- Show self-funding state in green and milestone value as CONDITIONAL (from `StarDeal.gym_net`, no ticket cut after debut)
- Compare 2-3 boxers side by side from the Money page
- Wire Find Bout and Release buttons from alert rows to existing screens
- Surface Approach cards (five answers with cash and loyalty), Bout Challenge cards (three answers), renegotiation at milestones
- Support stipend toggle (locked from the answer for 84 days)
- Project exit cost: release now vs later, with break-even in bouts for a pro

### ❌ Does NOT Do
- No transfer market between gyms — boxers leave via loyalty/release/retirement only
- No TV rights or broadcast deals — income from tickets, purses, dues only
- No per-boxer break-even date from unbooked bouts — shown as conditional only
- No projections beyond 8 weeks / the next bill
- No rival gym bidding wars — one approach at a time per fighter
- No rest/break option (not in code: only compulsory rest `Bouts.AFTER_FIGHT` and injury)
- No opportunity cost line (no game source for "average replacement")
- No prime window / age decline (attributes do not decline in code)
- No per-boxer attribution of member dues (build work: needs the `pay()` change)

---

## Changed from v4

1. **RELEASE FEE IS MONEY IN.** Every table, the comparison and the probes now show the release fee as cash in for a pro. The real choice is "fee now vs the share this pro brings per bout" (break-even in bouts from `StarDeal.gym_net`).
2. **BUILD CHANGE NAMED FIRST.** `Career.pay(amount, what, fid := "", kind := "")` stores the boxer id and a kind. Every call site listed. The weekly stipend and dues as ESTIMATE lines until the build writes them.
3. **DUES FROM A WIN — REAL EFFECT.** Replay `Membership.settle_week` for the win; show the real effect as an ESTIMATE line. No "$65 a week" figure.
4. **MILESTONE VALUE CORRECTED.** After the debut a pro's bout pays purse × share (`BoutFinish.gd` line 120). No $450 ticket cut in the top-3, belt or debut lines. Each tier from `StarDeal.gym_net`.
5. **RED ALERT GETS CLUB-WIDE LEVERS.** Dues band, kit budget, half stipend, pause a stipend, release (amateur or pro), evening coach, overdraft — each with its eight-week cash effect.
6. **DOLA ITEMS.** Release fee shown ON the comparison where Release is chosen. "Find a bout" on the orange row (opens Fights > Ask for a fight). Week number + source on each ledger line. Rest/Break dropped (not in code: only compulsory rest and injury).
7. **ARENA ITEMS.** Three stipend states (full / half / day job). Approach answers with cash and loyalty. Rival "not this show" second use counts as a pass. Probe arithmetic corrected (pro share: keep 25% vs drop 20% is 5% of purse; $2,500 at $1,500 purse takes ~33 bouts). File paths corrected (`scripts/rules/`). CODE tags removed from rules not in the code.
8. **KEPT** wire map table, plain game words, names only in headers, no critic scores in the map.
