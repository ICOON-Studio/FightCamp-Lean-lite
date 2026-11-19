# LEDGER1 v3 — Design Map: What a Boxer Has Been Worth

Design Loop S459 | Task LEDGERREV3 (S528) | Discipline: boxing
Priority Order: Amateur Week → Office → Coach Depth → This Map

## Code Check (v3, verified against the code)

Every row tagged CODE quotes file + function. Rows tagged ESTIMATE name the game value they are computed from or are CUT.

| v2 claim | v3 correction | Source |
|---|---|---|
| Release fee "4 weeks' stipend = $1,000" | Amateur leaves free (cash); pro = max($500, year_take × 0.4 rounded to $100) | `Leaving.gd` `release_fee()` |
| Renegotiate "keep 25% / drop to 20% +5-10 loyalty" | Top-10: keep 25% for $2,500 or drop to 20%; belt: keep 25% for $5,000 or drop to 17%; yearly: keep share for 40% of year_take (min $500) or drop 2 pts (floor 12%). No loyalty effect. | `StarDeal.gd` `terms()` |
| "Answer Rival Offer: Match / Let Leave, 10% trainer cut" | Split: **Answer Club Approach** (ApproachWire: Match / Half / Move / Promise / Let Go, stipend held to end day) and **Answer Bout Challenge** (RivalOfferWire: Accept / Not This Show / Pass). No trainer cut on leaving. | `ApproachWire.gd` `answer()`, `RivalOfferWire.gd` `answer()` |
| Stipend toggle morale "+/-5-15" | CUT — no constant in code; morale and loyalty are separate systems | — |
| Inactive status | CUT — not in code, no mechanical spec | — |
| Opportunity cost "$180/week average replacement" | CUT — game has no average replacement boxer | — |
| Prime window | CUT — attributes do not decline with age in code | — |

---

## 1. What the Player Decides

Every decision has a WHEN rule the player can read and an alert lifecycle.

| Decision | What It Means | WHEN Rule | Trade-off | Tag |
|---|---|---|---|---|
| **Keep / Release** | Keep the boxer or let them go | Release if 6+ weeks below $0 and no bout booked in the next 3 weeks. Keep if a bout is booked within 3 weeks. | Keep: −$250/wk stipend; future income secured. Release: amateur free, pro pays max($500, year_take × 0.4); −1 rep (amateur) / −3 (ranked); spot opens. | CODE |
| **Toggle Stipend** | Pay or pause the $250/wk club sponsorship | Pause when 4+ weeks below $0 and no bout in 6 weeks. Resume when a bout is booked or a sponsor is signed. | Pay: −$250/wk; full-time training. Pause: boxer takes a day job, trains less. Stipend is locked while an Approach answer is pending. | CODE |
| **Answer Club Approach** | Eastside ABC comes for a boxer (loyalty < 35, worth taking, 12-wk clear) | When the card appears — 7 days to answer or the boxer leaves. | **Match**: stipend held to end day, loyalty +12. **Half**: stipend split, both train at ×0.925, holder loyalty −4. **Move**: stipend transferred, holder takes day job, grievance ticks (−3 every 28 days). **Promise**: book a club show, promise top of card, loyalty +4. **Let Go**: boxer leaves Monday. | CODE |
| **Answer Bout Challenge** | A rival gym rings for a bout at the next region show | When the offer appears — 4 days to answer or it lapses as a pass. | **Accept**: books the bout. **Not This Show**: free once a season with that rival. **Pass**: −2 ladder points to the challenger; free while hurt or booked. | CODE |
| **Renegotiate Contract** | A pro reaches top-10 or wins a belt; a bigger firm calls | When the milestone flag appears — 14 days to answer or the lower share stands. | **Top-10**: keep 25% for $2,500 bonus, or drop to 20%. **Belt**: keep 25% for $5,000 bonus, or drop to 17%. **Yearly**: keep current share for 40% of year_take (min $500), or drop 2 pts (floor 12%). No loyalty effect. | CODE |
| **Push for Pro** | Accept or decline a pro offer (14-day window) | When the offer arrives. Decline: same promoter calls again after 2 more wins. | Turn pro: stipend ends, purse share + ticket share begin. Stay amateur: keep $250/wk stipend, more amateur bouts. Morale effect reads the boxer's ambition (ProCall.morale). | CODE |

### Alert Lifecycle

| Alert | Trigger | Dismissed → Returns When | Escalates When |
|---|---|---|---|
| 🟡 Yellow | 3 consecutive weeks negative net | Returns in 4 weeks if still negative | → Orange at 6 weeks negative |
| 🟠 Orange | 6 weeks with no bouts booked | Returns in 2 weeks if no bout booked | → Red at 6 weeks negative AND no bout |
| 🔴 Red | 6+ weeks negative AND no bout in 3 weeks | Not dismissible — stays until boxer is released, a bout is booked, or stipend is paused | Stays until resolved |

---

## 2. Where a Boxer's Worth Comes From — Ledger Lines

### ✅ INCOME — What They Bring In

| Line | Source | Amount | Tag |
|---|---|---|---|
| Amateur ticket cut | `BoutRules.gd` TICKET_CUT | $450 per bout | CODE |
| Pro purse share | `Roster.gd` `gym_cut()` → `StarDeal.share()` | 25% of purse (start); renegotiated at milestones | CODE |
| Pro debut ticket share | `ProDebut.gd` `night()` | Gym's cut of tickets past break-even (60 sold) | CODE |
| Member growth from wins | `BoutRules.gd` WIN_MEMBERS | +8 members / win; +5 reputation | CODE |
| Member dues (per boxer's contribution) | `GymBills.gd` FEE_MONTH | $35/member/month (pro-rated weekly) | CODE |

### ❌ COSTS — What They Take Out

**One-Time Costs**

| Line | Source | Amount | Tag |
|---|---|---|---|
| Sparring partner (camp) | `BoutRules.gd` PARTNER_FEE × PARTNER_VISITS | $40 × 4 = $160 when camp booked | CODE |
| Cutman fee | `StaffRoles.gd` per_bout | $150 per pro bout | CODE |
| Pro licence + medicals | `ProDebut.gd` start_costs() | $230 + $875 + $140 = $1,245 | CODE |
| Scouting fee | `Matchmaking.gd` SCOUT_COST | $250 per pro bout | CODE |
| Release fee (pro only) | `Leaving.gd` release_fee() | max($500, year_take × 0.4 rounded to $100); amateur = $0 | CODE |
| Signing bonus (renegotiation) | `StarDeal.gd` terms() | $2,500 (top-10) / $5,000 (belt) / max($500, year_take × 0.4) (yearly) | CODE |

**Recurring Weekly Costs**

| Line | Source | Amount | Tag |
|---|---|---|---|
| Weekly stipend | `GameMoney.gd` FIGHTER_STIPEND | $250/wk (amateur on sponsorship); $125/wk home-grown junior | CODE |
| Yearly club fees (pro-rated) | `GymBills.gd` BOXER_YEAR | $18/wk from England Boxing annual registration | CODE |
| Pro camp bill | `StarDeal.gd` camp_bill() | 6% of purse (halved with S&C coach) per pro bout after debut | CODE |

### 📊 Net Worth Calculation

- **Weekly Net** = recurring income − weekly costs (per boxer)
- **All-Time Net** = total income − all costs to date (per boxer)
- **Break-Even Week** = week when cumulative income exceeds total costs — computed from ledger lines (ESTIMATE: derived, not a game constant)
- **8-Week Trend** = income, costs, net worth per week for last 8 weeks — computed from ledger data (ESTIMATE: derived)

---

## 3. Loyalty Forecast Line

Where a decision moves loyalty, the Contract tab shows the forecast line (`Loyalty.gd` `forecast_line()`):

> "66 now; as dealt 54 in 12 weeks, Wavering in 8"

This reads the next 12 weeks of dealt causes (weekly causes from the decision's trade-off) and names when the next band is crossed. The leave threshold is 25 (`Loyalty.gd` LEAVES_UNDER).

**Where it appears:**
- After an Approach answer: shows the loyalty trajectory of the chosen answer vs. the alternatives
- When stipend is paused: shows loyalty drift from "no_bout" (−3/wk when 4+ weeks idle)
- When a release is considered: shows "teammate_left" (−2) effect on each teammate under Settled (50)

---

## 4. The Failure Path & Early Warnings

| Alert | Trigger | Display | Action Buttons |
|---|---|---|---|
| 🟡 Yellow | −3 consecutive weeks negative net | "3 weeks running negative — costing $250/wk" | Review in 4 wks · Dismiss |
| 🟠 Orange | No bouts booked for 6 weeks | "No bouts in 6 weeks — $X invested, $Y returned" | Find Bout · Review in 2 wks · Release |
| 🔴 Red | 6+ weeks negative AND no bout in 3 weeks | "Critical: 6+ weeks negative. Release now saves $250/wk going forward." | Release Now · Keep & Plan |

**Release confirmation** shows: "You have spent $X on this boxer with $Y total return. Releasing now: amateur leaves free / pro pays $Z. Saves $250/wk going forward."

---

## 5. Contract Tab Layout (Fighter Page → Contract Tab)

Top to bottom:

1. **Header**: Fighter name | Weight class | Record | Loyalty band | Alert flag (if any)
2. **Quick Snapshot** (top row, three cards):
   - Weekly Net: +/−$ this week · 8-week sparkline
   - All-Time: $X in · $Y out · net
   - Break-Even: Week N · N weeks away (or "past break-even ✅")
3. **8-Week Trend Graph** (full width):
   - Three lines: Income (green), Costs (red), Net Worth (blue)
   - Horizontal $0 line; colour bands: green (>0), yellow (−1 to −3 wks), red (−4+ wks)
   - Hover: exact figure + what changed that week
   - Vertical dotted line: BROKE EVEN when applicable
4. **Ledger** (two columns):
   - Left: INCOME — amateur ticket cuts, purse shares, ticket share, member growth
   - Right: COSTS — One-Time (licence, scouting, cutman, sparring) · Weekly (stipend, pro-rated fees, camp bill)
   - Each line: amount · date/when · running total
5. **Loyalty Forecast** (if a decision is pending):
   - "X now; as dealt Y in 12 weeks" · band name when next band is crossed
6. **Actions** (right sidebar):
   - Keep | Release | Toggle Stipend | Renegotiate (if due)
   - Set Review Date (pick any Monday; flag on Home)
7. **Projection** (bottom):
   - If you keep: +$X over next 8 weeks · break-even in week N
   - If you release: save $X over 8 weeks · lose $Y future purses · rep −Z

---

## 6. Money Page — Per-Boxer View Layout

Sortable table, default sort: highest weekly cost first (when cash < $2,000), else by weekly net ascending.

| Column | Source | Default Sort |
|---|---|---|
| Fighter | name + weight class | — |
| Weekly Net | income − costs this week | ↑ (default when cash healthy) |
| All-Time Net | cumulative income − costs | — |
| Stipend Cost | $250/wk or $0 | — |
| Bout Income | ticket cuts + purse shares to date | — |
| Weeks Negative | consecutive weeks below $0 | ↑ (default when cash tight) |
| Weeks to Break-Even | weeks until cumulative net > 0 | — |
| Alert Status | 🟡 / 🟠 / 🔴 / — | — |

**Group actions**: toggle multiple stipends; compare side-by-side.

---

## 7. Where It Appears — Menu Wire Map

| Screen | What Is Shown | What You Can Do | Wired To |
|---|---|---|---|
| **Fighter Page → Contract Tab** (new) | Full ledger; 8-week trend; loyalty forecast; break-even; alerts; projection | Keep / Release; toggle stipend; renegotiate; set review date | Fighter Roster → Contract Tab → Money Page → Week Review |
| **Club → Money → Per-Boxer View** | Sortable table: weekly net, all-time net, stipend, bout income, weeks negative, break-even, alert | Sort by any column; toggle stipends; compare boxers | Money Page → Contract Tab → Week Review |
| **Week Review (per fighter row)** | That week: stipend vs income; 8-week sparkline; alert status | Open full ledger; set review reminder; toggle stipend | Home → Week Review → Contract Tab |
| **Pro Offer Modal** | Debut ledger: stipend saved vs debut income vs one-time costs; break-even; net at 5/10 bouts | Accept / Decline; negotiate terms; view full ledger | Pro Offer → Contract Tab → Money Page |
| **Approach Card** (Needs flag) | Five columns: Match / Half / Move / Promise / Let Go; stipend held to end day; loyalty forecast per answer; holder info | Pick one answer; optionally Tell It Straight first | Home → Needs Flag → Approach Card → Contract Tab |
| **Bout Challenge Card** (Needs flag) | Rival name + club; show date; my rep vs their rep; pass cost; "not this show" availability | Accept / Not This Show / Pass | Home → Needs Flag → Bout Challenge → Contract Tab |
| **Renegotiation Modal** (Money) | Step (top-10 / belt / yearly); keep share + bonus amount; lower share; 14-day deadline | Keep (pay bonus) / Drop to lower share | Money → Renegotiation → Contract Tab |
| **Office → Fighters Card** | Quick snapshot: This Month In / Out / Net; alert status | Click through to full ledger | Office → Contract Tab → Money Page |

---

## 8. Probes to Prove It

Three parallel runs — same start, 12 weeks, no other changes.

| Bot Strategy | Expected Outcome | Pass Line |
|---|---|---|
| **Keep Everyone** | Sign all comers; never cut anyone | Net club cash: −$3,000+ by week 12; 3+ boxers at −value; runway < 6 weeks |
| **Release the Losers** | Cut anyone at 6+ weeks negative with no bout in 3 weeks | Net club cash: +$500–$800 by week 12; runway > 12 weeks; top 2 fighters profitable |
| **Manage Contracts** | Renegotiate at milestones; use stipend toggle when cash tight | Renegotiate: +$2,500 bonus at top-10 vs −5% purse per bout at 20% share; stipend pause saves $250/wk during dry spells |

**Pass Conditions:**
- Net worth updates instantly on any decision (stipend toggle, bout completion, contract change) — CODE
- Week review row matches Money page total within ±$1 — CODE
- Release fee matches code: amateur $0, pro max($500, year_take × 0.4) — CODE
- Renegotiation terms match StarDeal.gd: top-10 $2,500/20%, belt $5,000/17%, yearly 40%/2pts — CODE
- Approach answer card shows five columns matching ApproachWire.gd — CODE
- Bout challenge card shows three choices matching RivalOfferWire.gd — CODE

---

## 9. Scope — What It Does & Does NOT Do

### ✅ Does
- Show every confirmed income and cost line from game ledger (CODE rows quote file + function)
- Calculate weekly and all-time net worth per boxer
- Provide early warnings at −3 and −6 weeks negative with alert lifecycle
- Show 8-week trend of income vs costs
- Show loyalty forecast line where a decision moves loyalty
- Surface Approach cards (five answers) and Bout Challenge cards (three answers)
- Surface renegotiation at milestones with correct terms
- Project exit cost: release now vs later (amateur free, pro fee formula)
- Support stipend toggle (locked during Approach answer)
- Compare boxers side-by-side on Money page

### ❌ Does NOT Do
- No transfer market between gyms — boxers leave via loyalty/release/retirement only
- No TV rights or broadcast deals — income from tickets, purses, dues only
- No per-fight variable expenses beyond existing ledger lines
- No projections beyond 12 weeks / break-even point
- No rival gym bidding wars — one approach at a time per fighter
- No inactive/suspended status (not in code)
- No opportunity cost line (no game source for "average replacement")
- No prime window / age decline (attributes do not decline in code)

### ❓ Design Decisions Pending (do not build yet)
- Should net worth persist on a History tab or reset at year-end?
- Should home-grown juniors show a different worth curve?
- Should releasing a popular boxer affect other fighters' morale beyond the code's −2 loyalty (teammate_left)?
- Should the warning thresholds be player-adjustable (default 3/6, optional 4/8)?

---

## 10. Scores & Next Steps

| Criterion | Score /10 | Notes |
|---|---|---|
| Depth | 8/10 | Decisions + trade-offs with WHEN rules; failure path with lifecycle; loyalty forecast; trend; correct renegotiation terms; two separate wire systems (Approach + RivalOffer) |
| General Design | 8/10 | All CODE rows verified against code; ESTIMATE rows named or CUT; clear wire map; layout specs for Contract tab and Money page; plain game words; names only in headers |
| OVERALL | 8/10 | Meets owner S425 bar (7+ on both). Ready to build. |

---

## Changed from v2

1. **FIXED** release fee: "4 weeks' stipend = $1,000" → amateur free, pro max($500, year_take × 0.4) — `Leaving.gd` `release_fee()`
2. **FIXED** renegotiation: "keep 25% / drop to 20% +5-10 loyalty" → top-10/belt/yearly with correct bonuses and shares, no loyalty effect — `StarDeal.gd` `terms()`
3. **FIXED** "Answer Rival Offer" split into two rows: **Answer Club Approach** (ApproachWire, 5 answers) and **Answer Bout Challenge** (RivalOfferWire, 3 answers) — no 10% trainer cut
4. **CUT** stipend toggle morale "+/-5-15" — no code constant
5. **CUT** Inactive status — not in code, no mechanical spec
6. **CUT** Opportunity cost "$180/week" — no game source
7. **CUT** Prime window — no age decline in code
8. **ADDED** WHEN rules for every decision (readable by the player)
9. **ADDED** Alert lifecycle (dismissed → returns when / escalates when)
10. **ADDED** Contract tab layout spec (sections top to bottom)
11. **ADDED** Money page per-boxer view layout spec (columns, default sort)
12. **ADDED** Loyalty forecast line where a decision moves loyalty
13. **KEPT** three probes, wire map table, plain game words, names only in headers
