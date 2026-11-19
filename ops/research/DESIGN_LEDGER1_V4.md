# LEDGER1 v4 — Design Map: What a Boxer's Books Actually Say

Design Loop S459 | Task LEDGERREV4 (S530) | Discipline: boxing
Priority Order: Amateur Week → Office → Coach Depth → This Map

## Claude's check on v4 (S530)
- "Tagged in the ledger by Career.pay()": `pay(amount, what)` writes `{d, t, amount}` - NO boxer id; "tagged" today means
  the boxer's name inside the text `t`. Per-boxer cash in/out therefore needs ONE build change first: `pay()` takes the
  boxer's id and stores it (`fid`), and every call site in the per-boxer tables passes it. Name matching on text is not a
  design the build may use.
- The weekly stipend is not a ledger line at all: `GameMoney.athlete_payroll()` sums `f["weekly_salary"]` into the week's
  club costs. The per-boxer view must add it from the boxer's own weekly salary per week paid, not from the ledger.

## Code Check (v4, verified against the code)

The club's books are `Career.ledger`: an array of `{d, t, amount}` entries written by `Career.pay()`. Cash is `Career.cash`. Every row tagged CODE quotes file + function. Rows tagged ESTIMATE are computed from game constants or are CUT.

| v3 claim | v4 correction | Source |
|---|---|---|
| "Member growth from wins" listed as income per boxer | The code adds members (`BoutRules.WIN_MEMBERS` in `BoutFinish.gd`) to `c.members` but does NOT tag the resulting dues to a boxer. Dues are a CLUB line (`GymBills.week` reads `c.members × FEE_MONTH`). A boxer's row shows the *effect* as a labelled estimate, never added to cash. | `BoutFinish.gd` line 96, `GymBills.gd` `week()` |
| "Weekly Net = recurring income − weekly costs (per boxer)" | The code has no per-boxer weekly net. Costs accrue at the club level (`GameMoney.settle_week`). A boxer's stipend is in `f["weekly_salary"]`; bout income is in the ledger tagged with the boxer's name. Everything else is shared. | `GameMoney.gd` `settle_week()`, `GymSpend.gd` `costs()` |
| Release fee "amateur = $0" | Correct — `Leaving.gd` `release_fee()` returns 0 for non-pro. | `Leaving.gd` `release_fee()` |
| "Break-Even Week" as a computed date | The code has no per-boxer break-even. `CashForecast.project()` projects club cash only. A boxer's break-even is an estimate from tagged receipts vs tagged costs. | `CashForecast.gd` `project()` |
| Scouting cost listed as per-bout | `Matchmaking.SCOUT_COST` ($250) is paid by `ProLadder.gd` and tagged "Scouting X for Y" — it IS tagged with the boxer. | `ProLadder.gd` line 307 |
| Sparring partner fee "$40 × 4 = $160" | `BoutRules.PARTNER_FEE × PARTNER_VISITS` is used in `FightWeekPlan.gd` line 290 but the cost is bundled into the camp bill, not a separate ledger line. The camp bill is per-bout and tagged. | `BoutRules.gd` lines 50-51, `FightWeekPlan.gd` line 290 |

### What the code does NOT tag with a boxer today

| Receipt or cost | Where it lands | What would tag it |
|---|---|---|
| Member dues from a boxer's win | `c.members` → `GymBills.week()` income | A function in `BoutFinish.gd` that attributes `WIN_MEMBERS × FEE_MONTH / WEEKS_A_MONTH` to the winner for N weeks |
| Membership growth effect | Added to `c.members` globally | Same — needs a per-boxer attribution window |
| Rent, power, insurance, governing-body fees | `GymBills.week()` costs (club-level) | Not attributable to a boxer; stays in CLUB |
| Staff wages | `GymSpend.costs()` → `StaffRoles.wages()` | Not attributable; stays in CLUB |
| Kit budget | `GymSpend.costs()` → `kit(c)["week"]` | Not attributable; stays in CLUB |

---

## 1. What the Player Decides

Every decision has a WHEN rule the player can read, an alert lifecycle, and the rule file that governs it.

| Decision | What It Means | WHEN Rule | Trade-off | Tag |
|---|---|---|---|---|
| **Keep / Release** | Keep the boxer or let them go | Release if 6+ weeks below $0 and no bout booked in the next 3 weeks. Keep if a bout is booked within 3 weeks. | Keep: −stipend/wk; future income secured. Release: amateur free, pro pays max($500, year_take × 0.4); −rep; spot opens. A bout booked inside 14 days is boxed first. | CODE — `Leaving.gd` `let_go()`, `leave()` |
| **Toggle Stipend** | Pay or pause the club sponsorship | Pause when 4+ weeks below $0 and no bout in 6 weeks. Resume when a bout is booked or a sponsor is signed. Stipend is locked while an Approach answer is pending (`ApproachWire.stipend_locked()`). | Pay: −$250/wk (or $125 home-grown junior); full-time training. Pause: boxer takes a day job, trains at `DayJob.WEEK_DAYS - DayJob.LOST` / `DayJob.WEEK_DAYS`. | CODE — `GymSpend.gd` `set_stipend()`, `GameMoney.FIGHTER_STIPEND` |
| **Answer Club Approach** | Eastside ABC comes for a boxer (loyalty < 35, worth taking, 12-wk clear) | When the card appears — `Approach.ANSWER_DAYS` to answer or the boxer leaves. | Five answers: Match / Half / Move / Promise / Let Go. Each shows availability and refusal reason from `ApproachWire.columns()`. | CODE — `ApproachWire.gd` `answer()` |
| **Answer Bout Challenge** | A rival gym rings for a bout at the next region show | When the offer appears — 4 days to answer or it lapses as a pass. | Accept / Not This Show / Pass. Free while hurt or booked. | CODE — `RivalOfferWire.gd` `answer()` |
| **Renegotiate Contract** | A pro reaches top-10 or wins a belt; a bigger firm calls | When the milestone flag appears — 14 days to answer or the lower share stands. | Top-10: keep share for $2,500 or drop to 20%. Belt: keep share for $5,000 or drop to 17%. Yearly: keep share for 40% of year_take (min $500) or drop 2 pts (floor 12%). | CODE — `StarDeal.gd` `terms()`, `GymDeals.gd` `answer_talks()` |
| **Push for Pro** | Accept or decline a pro offer (14-day window) | When the offer arrives. Decline: same promoter calls again after 2 more wins. No morale or loyalty change from the window running out. | Turn pro: stipend ends, purse share + ticket share begin. Stay amateur: keep stipend, more amateur bouts. | CODE — `ProOfferWire.gd`, `ProCall.gd` |

### Alert Lifecycle

| Alert | Trigger | Dismissed → Returns When | Escalates When |
|---|---|---|---|
| 🟡 Yellow | 2 completed 4-week blocks with negative direct net, OR the next bill leaves projected club cash below $0 | Returns at the chosen Review Monday unless the reason clears or severity rises | → Orange at 6 weeks negative |
| 🟠 Orange | Eligible and unbooked for 6 weeks with no valid booking in the next 3. The idle count pauses during compulsory rest (`Bouts.AFTER_FIGHT`) or blocked entry windows and shows the return date. | Returns in 2 weeks if no bout booked | → Red when projected no-bout cash path threatens the gym's 8-week closure rule |
| 🔴 Red | Projected no-bout cash path threatens the gym's 8-week closure rule (`GymBills.CLOSE_AFTER_WEEKS`) | Not dismissible — stays until boxer is released, a bout is booked, or stipend is paused and the cash risk clears | Stays until resolved |

---

## 2. True Cash — What the Books Actually Record

### The Club Column (shared, never split across boxers)

| Line | Source | Amount | Why shared |
|---|---|---|---|
| Member dues | `GymBills.week()` → `c.members × FEE_MONTH / WEEKS_A_MONTH` | $35/member/month pro-rated weekly | Members are a club pool; no per-boxer attribution in code |
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
| Amateur ticket cut | `BoutFinish.gd` → `BoutRules.TICKET_CUT` | $450 per amateur bout (0 for a championship or club show) | "Ticket cut: Name vs Opponent" |
| Pro purse share | `BoutFinish.gd` → `Roster.gym_cut()` → `StarDeal.share()` | Gym's % of purse (start 25%; renegotiated) | "Purse share (X%): Name vs Opponent" |
| Pro debut ticket share | `BoutFinish.gd` → `Roster.debut_night()` → `ProDebut.night()` | Gym's cut of tickets past break-even | "Debut tickets: X sold, the gym's Y%..." |

### Per-Boxer Cash Out (tagged in the ledger by `Career.pay()`)

| Line | Source | Amount | Ledger tag |
|---|---|---|---|
| Weekly stipend | `GameMoney.FIGHTER_STIPEND` | $250/wk (amateur); $125 home-grown junior; $0 pro or day-job | In `f["weekly_salary"]`; summed by `GameMoney.athlete_payroll()` |
| Release fee (pro only) | `Leaving.gd` `release_fee()` | max($500, year_take × 0.4 rounded to $100); amateur = $0 | "Release fee: Name's new manager" |
| Signing bonus | `GymDeals.gd` `answer_talks()` | $2,500 (top-10) / $5,000 (belt) / max($500, year_take × 0.4) (yearly) | "Signing bonus: Name stays on X%" |
| Scouting | `ProLadder.gd` → `Matchmaking.SCOUT_COST` | $250 per pro opponent scouted | "Scouting X for Y" |
| Pro camp bill | `GymDeals.gd` `pro_camp()` → `StarDeal.camp_bill()` | 6% of purse (halved with S&C coach) per pro bout after debut | "Pro camp for Name: sparring partners and meals" |
| Cutman | `GymDeals.gd` `pro_camp()` → `StaffRoles.per_bout()` | $150 per pro bout (if on staff) | "Cutman for Name's night" |
| Pro licence + medicals | `ProDebut.gd` `start_costs()` | $230 + $875 + $140 = $1,245 (first time) | In the debut costs; paid once |

### What is NOT tagged with a boxer (build work needed)

| Receipt or cost | Current code | Function that would tag it |
|---|---|---|
| Member dues from a win | `BoutFinish.gd` adds `WIN_MEMBERS` to `c.members` | A new function in `BoutFinish.gd` that attributes `WIN_MEMBERS × FEE_MONTH / WEEKS_A_MONTH` weekly for a window |
| Sparring partner fee | Bundled in camp bill (`FightWeekPlan.gd` → `PartnerMatch.cost()`) | Already in the camp bill line; no separate tag needed |

### Cash Reconciliation Rule

The sum of all per-boxer tagged entries + the CLUB column entries = `Career.cash` (to rounding). The per-boxer view shows only tagged entries. The CLUB column shows the rest. Estimates (membership effect of wins, allocated fees) get their own labelled line and are never added into cash.

Words: "Cash in / Cash out / Net", never "worth".

---

## 3. One Comparison From the Same State

Keep as is / Pause stipend / Release (when legal) on one eight-week view from `CashForecast.project()`:

| Row | Keep as is | Pause stipend | Release (when legal) |
|---|---|---|---|
| Next bill | Date and amount from `CashForecast.bill_split()` | Same bill; stipend line drops | Same bill; all per-boxer costs stop |
| Lowest projected club cash | From `CashForecast.project()` | Higher (stipend saved) | Higher still (all costs stop) but release fee deducted if pro |
| Next booked bout | Date from `f["bout"]` if set; dashed line if not booked | Same; training pace changes | None — bout goes with the boxer or is withdrawn |
| Avoidable spend | Stipend × 8 weeks | $0 stipend | $0 stipend + release fee if pro |
| Exit fee | $0 | $0 | max($500, year_take × 0.4) for pro; $0 amateur |
| Loyalty change | Forecast from `Loyalty.forecast_line()` | "No bout" drift (−3/wk when 4+ weeks idle) | "teammate_left" (−2) on each Settled teammate |
| Roster place | Filled | Filled | Opens |

A bout that is not booked is a dashed conditional line, never an exact break-even date. Booked but unsettled returns go in a conditional case; a no-bout case sits alongside.

---

## 4. One Warning Table

| Colour | Trigger | What clears it | What a Review snooze does | Where the button goes |
|---|---|---|---|---|
| 🟡 Yellow | 2 completed 4-week blocks with negative direct net, OR next bill leaves projected cash below $0 | A bout is booked, a sponsor is signed, or stipend is paused and cash clears | Snoozes to the chosen Monday; returns early if the reason clears or severity rises | Week Review → Contract Tab |
| 🟠 Orange | Eligible and unbooked for 6 weeks (idle count pauses during compulsory rest from `Bouts.AFTER_FIGHT` and shows the return date) with no valid booking in the next 3 | A bout is booked or the boxer becomes ineligible (injured, rest) | Snoozes to the chosen Monday; returns early if a booking window opens | Find Bout → Fights > Ask for a Fight |
| 🔴 Red | Projected no-bout cash path threatens the gym's 8-week closure rule (`GymBills.CLOSE_AFTER_WEEKS`) | A bout is booked, stipend is paused and cash risk clears, or the boxer is released | Cannot snooze — stays visible | Release Now → Leaving.gd `let_go()` / Book Bout First → Fights |

The idle count on Orange pauses during compulsory rest and blocked entry windows and shows the return date. Cash risk still applies during rest.

---

## 5. Conditional Choices

Each answer shows its availability and refusal reason from the rule. Deadlines and lapse outcomes are shown before choosing.

### Answer Club Approach (`ApproachWire.gd`)

| Answer | Availability | Refusal reason | Deadline | Lapse |
|---|---|---|---|---|
| Match | Always available | — | `Approach.ANSWER_DAYS` | Boxer leaves for Eastside ABC |
| Half | Needs an eligible holder (most loyal teammate on stipend, not the boxer, not a pro, no day job, paid) | "No eligible teammate" | Same | Same |
| Move | Same holder requirement | "No eligible teammate" | Same | Same |
| Promise | Needs a bookable club show (`ClubShow.can_book()` and `HomeBout.reason() == ""` and `c.cash >= ClubShow.COST`) | "No show available" or "$X short" | Same | Same |
| Let Go | Always available | — | Same | Same |

### Answer Bout Challenge (`RivalOfferWire.gd`)

| Answer | Availability | Refusal reason | Deadline | Lapse |
|---|---|---|---|---|
| Accept | Always (if the rival is still in the club) | "That boxer is gone" | 4 days | Lapses as Pass |
| Not This Show | Once a season with that rival (`not r["not_this_show_used"]`) | "Already used this season" | Same | Same |
| Pass | Free while hurt or booked (no ladder cost); otherwise −2 ladder points to challenger | — | Same | Same |

### Renegotiate (`StarDeal.gd`, `GymDeals.gd`)

| Answer | Availability | Refusal reason | Deadline | Lapse |
|---|---|---|---|---|
| Keep share (pay bonus) | `c.cash >= bonus` | "$X short of the price" | 14 days | Lower share stands |
| Drop to lower share | Always | — | Same | Same |

### Push for Pro (`ProOfferWire.gd`, `ProCall.gd`)

| Answer | Availability | Refusal reason | Deadline | Lapse |
|---|---|---|---|---|
| Sign | `c.day < expires` | "Offer ran out" | 14 days | Promoter walks; calls again after 2 more wins |
| Stay amateur | Always | — | Same | Same |

Deals are committed only on their existing screens; the ledger links there.

---

## 6. The Reward Side

### Self-funding state

When a boxer reaches break-even (cumulative tagged cash in ≥ tagged cash out) AND has a bout booked AND no alert is active:
- Contract tab: green line "✅ Self-funding — brings in $X/bout above cost"
- Week Review row: small +$X badge showing the last bout's net contribution

### Milestone value line (CONDITIONAL)

Computed only from existing purse and ticket rules:

| Milestone | Source | Computation | Label |
|---|---|---|---|
| Top-3 rank | `StarDeal.gym_net()` at current purse step | `(purse + TICKET_CUT) × share − camp_bill` per bout × projected bouts/year | CONDITIONAL — "at a top-3 rank: ~$X/bout" |
| Pro debut | `ProDebut.night()` at current forecast | `gym_cut` from tickets sold | CONDITIONAL — "at debut: ~$X" |
| Belt | `StarDeal.gym_net()` at belt purse step | Same as top-3 with higher purse | CONDITIONAL — "at a belt: ~$X/bout" |

These are never added into cash. They are shown as "CONDITIONAL — depends on rank and bookings".

---

## 7. Compare 2-3 Boxers Side by Side

From the Money page: checkboxes on rows → Compare Selected button.

Side-by-side snapshot:

| Column | Source |
|---|---|
| Cash in (tagged) | Sum of per-boxer `Career.ledger` entries with positive amount matching the boxer's name |
| Cash out (tagged) | Sum of per-boxer tagged costs (stipend, scouting, camp, cutman, release, bonus) |
| Net | Cash in − Cash out |
| Weeks to break-even | Weeks until cumulative net > 0 (dashed if no bout booked) |
| Alert status | 🟡 / 🟠 / 🔴 / — |
| Next bout | Date or "none booked" |

One-click swap → Contract tab for any fighter.

---

## 8. Where It Appears — Menu Wire Map

| Screen | What Is Shown | What You Can Do | Wired To |
|---|---|---|---|
| **Fighter Page → Contract Tab** | Full ledger (tagged entries only); 8-week club cash plot with per-boxer conditional paths dashed; loyalty forecast; alerts; comparison | Keep / Release; toggle stipend; renegotiate; set review date; compare | Fighter Roster → Contract Tab → Money Page → Week Review |
| **Club → Money → Per-Boxer View** | Sortable table: cash in, cash out, net, weeks to break-even, alert, next bout | Sort by any column; toggle stipends; compare boxers | Money Page → Contract Tab → Week Review |
| **Week Review (per fighter row)** | That week: stipend vs tagged income; alert status; self-funding badge if applicable | Open full ledger; set review reminder; toggle stipend; Find Bout (from 🟠 row) | Home → Week Review → Contract Tab |
| **Pro Offer Modal** | Debut terms side by side; forecast; ask answers with availability | Accept / Decline; negotiate terms | Pro Offer → Contract Tab → Money Page |
| **Approach Card** | Five columns with availability and refusal reasons; loyalty forecast per answer; holder info; deadline | Pick one answer; optionally Tell It Straight first | Home → Needs Flag → Approach Card → Contract Tab |
| **Bout Challenge Card** | Rival name + club; show date; my rep vs their rep; pass cost; "not this show" availability; free exemption when hurt/booked | Accept / Not This Show / Pass | Home → Needs Flag → Bout Challenge → Contract Tab |
| **Renegotiation Modal** | Step (top-10 / belt / yearly); keep share + bonus amount; lower share; 14-day deadline; cash check | Keep (pay bonus) / Drop to lower share | Money → Renegotiation → Contract Tab |
| **Office → Fighters Card** | Quick snapshot: club cash, next bill, alert count | Click through to per-boxer view | Office → Contract Tab → Money Page |

---

## 9. Probes to Prove It

Decision probes hold the start state and seed and change ONE decision. Fixtures:

| Fixture | Start state | Decision changed | Pass line |
|---|---|---|---|
| Cash-rich gym | $40,000 cash, 3 amateurs, 12 weeks | Keep all vs release the weakest at week 6 | Keeping all: net cash > $20,000 at week 12; releasing the weakest: net cash > $25,000 but −rep. Both legal; neither dominates. |
| Cash crisis | $2,000 cash, 4 boxers, all negative | Pause all stipends vs release 2 | Pausing: gym survives 10+ weeks; releasing: gym survives 16+ weeks but −2 rep and −2 loyalty per teammate. Both legal; pausing wins on rep, releasing wins on cash. |
| Suspended prospect | 1 boxer, 8 weeks post-bout rest, no income | Keep paying stipend during rest vs pause | Keep: loyalty holds, cash drops $2,000; pause: loyalty drifts −3/wk, cash holds. Neither dominates — keep wins on loyalty, pause wins on cash. |
| Two boxers sharing a stipend | Approach card: Half or Move available | Half vs Move | Half: both train at ×0.925, holder loyalty −4; Move: boxer full training, holder takes day job, grievance ticks. Half wins on holder loyalty; Move wins on the approached boxer's training. |
| Pro on reduced share | Pro at 20% share, top-10 reached, talks open | Keep 20% for $2,500 vs drop to 17% | Keep: cash −$2,500 now, +5% × purse per bout after; Drop: cash saved, −3% × purse per bout after. At $1,500 purse, keep pays back after ~4 bouts. At $800 purse, drop wins. Neither dominates everywhere. |

**Pass conditions:**
- Each decision is best somewhere (no policy wins everywhere)
- Warning lifecycle matches the table in Section 4
- Cash reconciliation: sum of per-boxer tagged entries + CLUB = `Career.cash` to ±$1
- Locks and booked-bout guards hold (stipend locked during Approach; release blocked when bout inside 14 days)
- Release quotes match code: amateur $0, pro max($500, year_take × 0.4)
- Renegotiation terms match `StarDeal.gd`: top-10 $2,500/20%, belt $5,000/17%, yearly 40%/2pts
- Approach card shows five columns matching `ApproachWire.columns()` with correct availability
- Bout challenge card shows three choices matching `RivalOfferWire.view()` with correct free exemptions
- Review date shows what changed against the earlier plan

---

## 10. Scope — What It Does & Does NOT Do

### ✅ Does
- Show every tagged receipt and payment per boxer from `Career.ledger` (Cash in / Cash out / Net)
- Keep shared bills in the CLUB column, never in a boxer's total
- Label estimates (membership effect, allocated fees) separately and never add them into cash
- Compare Keep / Pause / Release on one eight-week view from `CashForecast.project()`
- Show one warning table with yellow / orange / red, each with trigger, clear, snooze and button
- Pause the idle count during compulsory rest and show the return date
- Show conditional choices with availability and refusal reasons from the rules
- Show self-funding state in green and milestone value as CONDITIONAL
- Compare 2-3 boxers side by side from the Money page
- Wire Find Bout and Release buttons from alert rows to existing screens
- Surface Approach cards (five answers), Bout Challenge cards (three answers), renegotiation at milestones
- Support stipend toggle (locked during Approach answer)
- Project exit cost: release now vs later

### ❌ Does NOT Do
- No transfer market between gyms — boxers leave via loyalty/release/retirement only
- No TV rights or broadcast deals — income from tickets, purses, dues only
- No per-boxer break-even date from unbooked bouts — shown as conditional only
- No projections beyond 8 weeks / the next bill
- No rival gym bidding wars — one approach at a time per fighter
- No inactive/suspended status (not in code)
- No opportunity cost line (no game source for "average replacement")
- No prime window / age decline (attributes do not decline in code)
- No per-boxer attribution of member dues (build work: needs a new function in `BoutFinish.gd`)

---

## Changed from v3

1. **TRUE CASH FIRST**: separated CLUB column (shared bills) from per-boxer tagged entries; named what the code does NOT tag with a boxer and the function that would; switched from "net worth" to "Cash in / Cash out / Net"
2. **ONE COMPARISON**: replaced separate sparkline + trend + break-even card with one eight-week Keep/Pause/Release comparison from `CashForecast.project()`; unbooked bouts are dashed lines
3. **ONE WARNING TABLE**: unified yellow/orange/red with trigger, clear, snooze and button; idle count pauses during compulsory rest
4. **CONDITIONAL CHOICES**: each answer shows availability and refusal reason from the rule file; deadlines and lapse outcomes before choosing
5. **REWARD SIDE**: added self-funding state (green badge) and milestone value line (CONDITIONAL, from existing purse/ticket rules)
6. **COMPARE**: added 2-3 boxer side-by-side view from Money page
7. **FIND BOUT / RELEASE BUTTONS**: wired from alert rows to existing screens
8. **PROBES**: replaced 3 strategy probes with 5 decision fixtures (cash-rich, cash crisis, suspended prospect, shared stipend, reduced-share pro); each requires that no policy wins everywhere
9. **CUT** break-even as an exact date — replaced with conditional projection
10. **CUT** 5/10-bout projections presented as forecasts
11. **KEPT** wire map table, plain game words, names only in headers
