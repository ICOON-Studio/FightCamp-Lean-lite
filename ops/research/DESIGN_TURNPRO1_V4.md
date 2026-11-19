# DESIGN_TURNPRO1_V4 — turning pro map v4

Status: Research complete | CODE rows verified against built game
Tags: **CODE** = verified in named file+function; **CHANGE** = v4 changes a built number (old → new, why); **ESTIMATE** = tuned starting value for probes; **BUILT** = live in the .exe today.

Owner rules kept: names only in headers (S448); gender-neutral text (S412); stops at the debut (S428); no new screen; actionable info only (S425); 14-day window; TAPER week before bouts.

---

## 1 — When & Who Calls

### 1.1 Trigger Rules

| Rule | Value | Tag | Source |
|---|---|---|---|
| First call: wins + ranked | 7 wins AND regional top 3 | CODE | `Roster.pro_ready()` — `w >= PRO_WINS and ranked` |
| First call: wins any rank | 9 wins, any ranking | CODE | `Roster.pro_ready()` — `w >= PRO_WINS_ANY_RANK` |
| National finalist | First call at any win count, 0 declines | CODE | `Roster.pro_ready()` — `nat_final and pro_declines == 0` |
| After 1 decline | Same promoter calls; need +2 wins; terms ×0.9 | CODE | `ProOfferWire.on_decline()` + `ProCall.terms()` |
| After 2 declines | Only regional rank 1 brings a call | CODE | `Roster.pro_ready()` — `pro_declines >= 2: return rank == 1` |
| After 3 declines | Door closed permanently | CODE | `Roster.pro_ready()` — `pro_declines >= 3: return false` |
| Age cutoff | No first call at age 32+ | ESTIMATE | `ProCall.calls_open()` — `age < AGE_STOP` |
| Age warning | Shown from age 29 | ESTIMATE | `ProCall.age_line()` — `age >= 29` |
| Offer window | 14 days | ESTIMATE | `ProCall.WINDOW_DAYS := 14` |
| Window expires | NOT a decline; promoter waits 2 more wins | CODE | `ProOfferWire.lapse_if_due()` — `RETURN_WINS := 2` |

**v3 error corrected:** v3 said "national title reopens a closed door once." The code has no reopen — after 3 declines the door is closed (`Roster.pro_ready` returns false unconditionally). v4 removes the reopen.

### 1.2 Who Calls

| Ticket forecast | Who calls | Tag | Source |
|---|---|---|---|
| ≥ 75 (Bow Lane BE 60 + BAND 15) | Bow Lane only | CODE | `ProCall.who_calls()` — `forecast >= bow_be + BAND` |
| 45–74 (within BAND of BE) | Both, side by side | CODE | `ProCall.who_calls()` — the else branch |
| ≤ 44 (Bow Lane BE 60 − BAND 15) | Harrow & Finch only | CODE | `ProCall.who_calls()` — `forecast <= bow_be - BAND` |
| After decline | Same promoter only | CODE | `ProOfferWire.make()` — `if declines > 0: keys = [last]` |
| Title won since decline | Terms reset to 1.0× | CODE | `ProCall.terms()` — `title_since_decline: factor = 1.0` |

### 1.3 The Two Promoters

| | Bow Lane (ticket house) | Harrow & Finch (guarantee house) | Source |
|---|---|---|---|
| Debut purse | $1,500 | $1,800 guaranteed | CODE `ProCall.promoters()` |
| Win bonus / top | +$500 / $3,000 | +$400 / $3,000 | CODE `ProCall.promoters()` |
| Break-even | 60 tickets | 70 tickets | CODE `ProCall.promoters()` / `ProDebut.BREAK_EVEN` |
| Boxer share past BE | 50% | 30% | CODE `ProCall.promoters()` |
| Under BE | Purse −$25/ticket short, floor $500 | No deduction (guaranteed) | CODE `ProCall.debut_purse()` |
| Debut date | 4 weeks out | 6 weeks out | CODE `ProCall.promoters()` |
| Opponent gap | 1.0 under boxer's night power | 1.5 under | CODE `ProCall.promoters()` |

---

## 2 — The Asks (Repaired End to End)

One ask per offer per house. Each shows its answer before pressing: take, counter, or wont. Pressing a counter shows its terms; the player can accept the counter or return to plain (still counts as the one ask). CODE: `ProOfferWire.ask()`.

### 2.1 Later +2 Weeks

| | Before | After |
|---|---|---|
| Purse | Full | −$150 |
| Debut weeks | 4 (Bow) / 6 (HF) | +2 |
| Counter | — | — |
| When best | An amateur bout is booked in weeks 3–4 that cannot be rescheduled | |

Tag: CODE `ProCall.LATER2_PURSE_CUT := 150`, `_apply_later()`. TURNPROBE2: best in 23% of offers.

### 2.2 Later +4 Weeks

| | Before | After |
|---|---|---|
| Purse | Full | −$300 |
| Debut weeks | 4 (Bow) / 6 (HF) | +4 |
| Counter | — | — |
| When best | Need 3–4 more weeks of ticket growth AND no amateur bout booked (later+2 insufficient) | |

Tag: CODE `ProCall.LATER4_PURSE_CUT := 300`, `_apply_later()`. TURNPROBE2: best in 3% — **marginal**. Kept because it covers the gap when later+2 is not enough but the player cannot afford to wait for a new offer cycle. Probe decides if 3% is enough or this merges into later+2.

### 2.3 Softer Opponent

| | Before | After |
|---|---|---|
| Opponent gap | 1.0 (Bow) / 1.5 (HF) | +0.5 (opponent rating drops 0.5) |
| Consequence | — | Next 2 pro offer rounds are tune-ups only |
| Counter | — | — |
| When best | Injury risk >15% OR stamina <50 OR coming off a stoppage loss | |

Tag: CODE `ProCall.SOFTER_OPP_ADD := 0.5`, `SOFTER_TUNE_UPS := 2`, `_apply_softer()`. The gap is positive in the code; adding 0.5 makes the opponent easier (opponent rating = boxer night power − gap). TURNPROBE2: best in 0% — **cut candidate**. Kept only if probe shows a niche (injury/stoppage recovery); otherwise cut in probe build.

### 2.4 Better Split

| | Before | After (take) | After (counter) |
|---|---|---|---|
| Share past BE | 50% (Bow) / 30% (HF) | +10 points | +5 points |
| Opponent | Plain | 0.5 harder (gap −0.5) | Unchanged |
| Threshold | — | Forecast ≥ BE+20 | Forecast ≥ BE+5 and <20 |
| Below BE+5 | Promoter wont: "forecast too close to break-even" | | |
| When best (take) | Strong forecast (BE+20+), confident win | | |
| When best (counter) | Moderate forecast (BE+5 to BE+19), cautious | | |

Tag: CODE `ProCall.SPLIT_TAKE_SHARE := 0.10`, `SPLIT_COUNTER_SHARE := 0.05`, `SPLIT_TAKE_OVER := 20`, `SPLIT_COUNTER_OVER := 5`, `SPLIT_TAKE_OPP := 0.5`, `_split_entry()`. TURNPROBE2: best in 0% — **cut candidate**. The counter at BE+5 gives the gym only ~$5 extra at 25% share of 5 tickets × $50 × 5pts. Probe decides if the threshold needs lowering or this ask is cut.

### 2.5 Own Ticket Price

| | Before | After |
|---|---|---|
| Ticket price | $50 | $40 |
| Extra tickets | 0 | +15 |
| Available | Bow Lane only | HF wont: "the purse is fixed" |
| Counter | — | — |
| When best | Membership >80 AND loyal fanbase (low price fills the room) | |

Tag: CODE `ProCall.PRICE_TICKET := 40`, `PRICE_EXTRA_TICKETS := 15`, `_price_entry()`. **BUG found (Arena):** `ProCall.money()` uses the fixed `ProDebut.TICKET_PRICE := 50` for surplus calculations, not the stored price. The ask stores `after["price"] = 40` but the money function never reads it. CHANGE required: `ProCall.money()` must use `int(t.get("price", ProDebut.TICKET_PRICE))` for the surplus calculation. Without this fix the ask is cosmetic. TURNPROBE2: best in 6%.

### 2.6 Costs from the Purse (Defer)

| | Before | After |
|---|---|---|
| Signing cost | Gym pays $230–$1,245 now | $0 now |
| Repayment | — | Deducted from gross purse before the 25% split |
| Fee | — | +$100 base; +$200 when runway < 8 weeks |
| Available | HF only (guaranteed purse) | Bow wont: "purse depends on the gate" |
| When best | Runway < 6 weeks (cash poor) — ALWAYS best when cash low | |

Tag: CODE `ProCall.COSTS_BASE_ADD := 100`, `COSTS_RUNWAY_ADD := 200`, `COSTS_RUNWAY_THRESHOLD := 8`, `_costs_entry()`. TURNPROBE2: best in 68%.

**v3 errors corrected:** v3 said "+$100 fee when runway <4 weeks." The code charges +$200 when runway <8 weeks. v3 also said "$1,345 from purse" as a flat number; the actual deduction is `costs + costs_from_purse` where costs vary ($230–$1,245) and the fee is $100 or $200.

### 2.7 No Ask (Plain Deal)

Return to the plain offer after viewing or countering an ask. The ask stays spent (one ask per offer per house). CODE: `ProOfferWire.back_to_plain()`. Needed when every ask worsens the outcome or the player changes their mind.

---

## 3 — One Dated Money Model

### 3.1 Costs at Signing

| Item | Amount | Condition | Source |
|---|---|---|---|
| BBBofC licence | $230 | Always (first pro licence) | CODE `ProDebut.LICENCE` |
| Brain scans / medicals | $875 | First licence only | CODE `ProDebut.MEDICALS`, `start_costs(first_licence=true)` |
| Corner licence | $140 | Trainer not already licensed | CODE `ProDebut.CORNER_LICENCE`, `start_costs(trainer_licensed=false)` |
| **Range** | **$230 – $1,245** | Depends on existing licences | CODE `ProDebut.start_costs()` |

**v3 error corrected:** v3 charged every boxer the full $1,245. The code's `start_costs()` only charges medicals when `first_licence` is true and corner licence when `trainer_licensed` is false. A boxer whose trainer is already licensed and who has held an amateur licence pays only $230.

### 3.2 The Dated Ledger — One Table

Example: 70-member gym, 7 wins, Bow Lane, stipend was $250/week, costs = $1,245 (worst case), 69 tickets forecast.

| Date | Event | Gym cash movement | Boxer cash movement |
|---|---|---|---|
| Day 0 (sign) | Costs paid | −$1,245 | $0 |
| Day 0 (sign) | Gym's 25% of purse ($1,500) | +$375 (receivable at debut) | — |
| Day 0 (sign) | Gym's 25% of ticket share (9 tickets × $50 × 50% × 25%) | +$56 (receivable at debut) | — |
| Week 1–4 | Stipend saved (was $250/wk, now $0) | +$250/wk | — |
| Week 1–4 | Amateur cut lost | −$75/wk (ESTIMATE) | — |
| Week 1–4 | Net weekly swing | +$175/wk | — |
| Debut day (wk 4) | Purse paid | (included above) | $1,500 − $375 gym cut = $1,125 |
| Debut day (wk 4) | Ticket share paid | (included above) | 9 × $50 × 50% − $56 gym cut = $169 |
| **Gym total at debut** | | **−$1,245 + $375 + $56 + $700 (4 wk swing) = −$114** | **Boxer: $1,294** |
| **Gym break-even** | | Week 5 (−$114 / $175 per wk ≈ 1 wk after debut) | |

### 3.3 Deferred Costs Scenario (HF, runway < 8 weeks)

| Date | Event | Gym cash | Boxer cash |
|---|---|---|---|
| Day 0 (sign) | Costs deferred | $0 | $0 |
| Day 0 (sign) | Fee added to purse deduction | — | −$200 (extra) |
| Week 1–6 | No stipend, no amateur cut | −$75/wk | — |
| Debut day (wk 6) | Gross purse $1,800 − $1,245 costs − $200 fee = $355 | 25% of $355 = $89 | $355 − $89 = $266 |
| Debut day (wk 6) | Ticket share (0 above BE at 70 tickets = 0) | $0 | $0 |
| **Gym total at debut** | | **$89 − $450 (6 wk loss) = −$361** | **Boxer: $266** |
| **Gym break-even** | | "Once ranked" (no clear path without pro income) | |

### 3.4 What Happens If...

| Scenario | What happens | Source |
|---|---|---|
| Bout cancelled | No purse paid; costs already spent; gym absorbs the loss. No code path yet — ESTIMATE for probe. | Not in code |
| Purse too small to cover deferred costs | `ProOfferWire.night()` uses `maxi(0, purse - costs - fee)`. Floor at $0. Unpaid balance is lost (the promoter absorbs it). | CODE `ProOfferWire.night()` |
| Missed weight at debut | $300 slot fee; next offer at 0.9× terms. ESTIMATE. | Not in code |

---

## 4 — Waiting as a Real Decision

### 4.1 The Exact Trigger for the Next Call

| Condition | Next call comes when | Uncertainty |
|---|---|---|
| 0 declines, offer expired (lapsed) | After 2 more amateur wins (`pro_wait_w`) | The promoter is the same; terms unchanged. CODE `ProOfferWire.lapse_if_due()`, `waited()` |
| 1 decline | After 2 more wins, same promoter, 0.9× terms | Terms compound: 0.9^declines. A title since resets to 1.0×. CODE `ProCall.terms()` |
| 2 declines | Only at regional rank 1 | Must win the regional title. CODE `Roster.pro_ready()` |
| 3 declines | Never | Door closed. CODE `Roster.pro_ready()` returns false |

### 4.2 "Not Yet" Is Not a Decline

A lapsed offer (14-day window expires with no answer) is NOT a decline. The promoter walks away and calls again after 2 more wins. No morale penalty, no loyalty change, no terms reduction. CODE: `ProOfferWire.lapse_if_due()` — only increments `pro_wait_w`, never `pro_declines`. The map (S523): "only Stay amateur counts" as a decline.

### 4.3 What Waiting Buys

| Buys | Number | Tag | Source |
|---|---|---|---|
| Tickets per amateur win | +2 | CODE | `ProDebut.PER_WIN := 2` in `tickets_sold()` |
| Members per win (as tickets) | +0.5 per member, ~+4 tickets at 80 members | CODE | `ProDebut.PER_MEMBER := 0.5` |
| Regional title | +10 tickets | CODE | `ProDebut.PER_TITLE := 10` |
| Amateur ticket cut | ~$450 per bout | CODE | Amateur bout payout |
| Crossing into both-call band | A real promoter pick | ESTIMATE | `ProCall.who_calls()` |

### 4.4 What Waiting Costs

| Costs | Number | Tag | Source |
|---|---|---|---|
| Stipend (if paid) | $250/week | CODE | `ProCall.money()` — `stipend_paid` branch |
| Lost amateur cut | ~$75/week | ESTIMATE | `ProCall.LOST_CUT_A_WEEK := 75` |
| Each decline | +2 wins needed; 0.9× terms; door closes at 3 | CODE | `Roster.pro_ready()` + `ProCall.SECOND_TERMS` |
| Age 32 | First calls stop permanently | ESTIMATE | `ProCall.AGE_STOP := 32` |
| Boxer's ambition | Morale effect (section 6) | CODE | `ProCall.morale()` |

### 4.5 Path When Only One House Calls

If the forecast is ≥75, only Bow Lane calls. If ≤44, only HF calls. The player can:
- Accept the one offer (no side-by-side comparison)
- Decline (Stay amateur) — same house calls next at 0.9×
- Let it lapse — same house calls after 2 more wins, full terms
- Make one ask (if available for that house)

There is no "wait for the other house" option. The band is determined by the ticket forecast, which grows with members, wins and titles.

---

## 5 — The Day-Job Road to Pro

The day-job path is for boxers whose gym is not paying a stipend. Without a stipend, the weekly swing after signing is −$75/week. The gym needs a reason to sign before the boxer is fully ranked.

### 5.1 Two Decisions on the Road

**Decision 1: Stop or keep the stipend**

| Option | Effect | Game value | Source |
|---|---|---|---|
| Keep stipend running | +$250/week until signing; then stops | `f["weekly_salary"]` | CODE `Roster.turn_pro()` — `weekly_salary = 0` at signing |
| Stop stipend before signing | Save the remaining weeks; gym cash higher at signing | Money > STIPENDS | CODE `ProCall.money()` — `stipend_paid` flag |

The player sees on NEXT STEP: "Stipend path: sign now, gym even ~5 weeks" vs "Day-job path: no stipend, gym even once ranked."

**Decision 2: Top a club show before signing**

| Option | Effect | Game value | Source |
|---|---|---|---|
| Host a club show | +10 ticket followers (one-time), costs $3,500 | ShowHosted, followers | ESTIMATE (v2 design, not yet built) |
| Skip the show | No followers boost; ticket forecast grows only from wins/members | — | — |

The club show's 10 followers push the forecast toward the both-call band (45–74), which can bring a second promoter and a real choice.

**Decision 3 (CUT from v3): "Save $150/week"**

v3 proposed an automatic $150/week saving toward the debut fund. The code has no such mechanism. An automatic transfer without disposable cash can starve the gym. CUT — replaced by the visible choice of stopping the stipend early and the club show decision.

### 5.2 The Day-Job Timeline

| Stage | What changes | Weeks |
|---|---|---|
| Amateur build | Keep fighting; every show = +2 tickets, +$75/wk cut equivalent | Until forecast reaches BE |
| Stop the stipend | Save $250/wk that would have been spent | 4–8 weeks before signing |
| Club show (optional) | +10 followers toward both-call band | One event, 2–3 weeks prep |
| Both-call band reached | Both promoters call — pick the guarantee house, defer costs | Decision point |
| Debut day | $0 up-front; costs from purse; gym cash untouched | Day 1 |

Shown on NEXT STEP: "Day-job path: stop stipend 6 weeks before signing → Harrow & Finch defers costs → $0 up-front."

---

## 6 — The Boxer's Voice

### 6.1 Ambition → Visible Preference

The signing card's ambition line (CODE `Recruit.ambition()`) maps to a preference:

| Ambition words | Kind | Turn pro | Stay amateur | Source |
|---|---|---|---|---|
| "A regional title within a year" | title | −5 morale; debut performance −5% (CHANGE) | No change | CODE `Recruit.ambition()` + `ProCall.morale()` |
| "A winning record by the summer" | other | No change | No change | CODE `ProCall.morale()` — returns 0 for "other" |
| "A first win in front of a home crowd" | other | No change | No change | CODE `ProCall.morale()` — returns 0 for "other" |

**Critical finding:** `ProCall.ambition_kind()` checks for "title" and "pro" in the ambition text. None of the three ambitions from `Recruit.ambition()` contain "pro." The "pro" morale path (+5/−5) is **never triggered** by the current signing card. Only the "title" path works (for pot ≥ 78 boxers).

**CHANGE:** Add a visible preference line on the offer that reads the ambition and shows a gender-neutral morale effect:
- Title ambition + before nationals: "Your boxer wants the title first — signing now costs −5 morale and −5% debut performance."
- All others: "Your boxer follows your call." (neutral)

The −5% debut performance for title ambition signing early is CHANGE (old: no performance effect; new: −5% on all stats at debut when `before_nationals` is true). Duration: one fight (the debut only). Source: `ProCall.morale()` already returns −5 for this case; the performance modifier is new.

### 6.2 The Age Line — Game Rule, Not Law

The age 32 cutoff is ESTIMATE, not a verified boxing regulation. It is a game rule that creates urgency. Shown from age 29: "Age 29 — first calls stop at 32." At 32+: "First calls have stopped." CODE: `ProCall.age_line()`, `ProCall.calls_open()`.

---

## 7 — Probe Pass Lines (All Nine v2 + v3 New)

| # | Pass line | v2 result | v4 target | Key constant |
|---|---|---|---|---|
| 1 | No bot dominates (>60%) at w104 cash | FAIL | All bots ≤55% | Day-job path diversifies |
| 2 | PREP beats YES by ≥$1,500 at w104 (paired) | FAIL (median $0) | Median diff ≥$1,500 | Day-job defer + club show |
| 3 | Stipend timing: YES(stip) > NEVER(stip) w52; NEVER > YES w52 no-stip; YES > NEVER w104 both | FAIL | As stated | `ProCall.LOST_CUT_A_WEEK` |
| 4 | YES debut loses gym money 40–70% (stipend only) | 27% avg | 40–70% stip; 0% deferred | `ProCall.PURSE_FLOOR` / `SHORT_TICKET` |
| 5 | Door closes 10–30% of careers | 0% | 10–30% | 3-decline hard stop (already CODE) |
| 6 | Win rate: 65–80% at gap 1.0; 70–85% at gap 1.5 | 80% / 60% | Within bands | `Roster.PRO_OPP_GAP` / `ProCall.promoters()` |
| 7 | Each ask best in ≥10% of offers (fork method) | 3 asks <10% | All kept ≥10% or cut | `ProCall` ask constants |
| 8 | HF picked ≥25%; both call 25–50% | PASS | Unchanged | `ProCall.BAND` |
| 9 | Ambition preference aligns ≥70% decisions | 3% | ≥70% | `ProCall.morale()` + visible preference |

Probe spec: 200 careers/bot × 5 bots × 2 seed sets; half stipend, half day-job. Preserve all v2 definitions. Add money event traces.

---

## 8 — Wire Map (Every Menu)

| # | Menu | What shows | Wired to |
|---|---|---|---|
| M1 | Top bar flag | PRO OFFER (14-day countdown, red last 3 days) | Opens M3; `ProOfferWire.days_left()` |
| M2 | Home board | "Pro offer — hear it" / "Day-job path — stop stipend 6 wk before" | `Roster.check_pro()` status |
| M3 | Pro offer modal | One or two contracts; 6 asks with before/after terms; morale line; age line; declines left; next-call condition if waiting | `ProOfferWire`, `ProCall`, `ProDebut` |
| M4 | Fighter → NEXT STEP | Wins of 7/9, rank, age line, declines left; ticket forecast over 8 weeks; stipend vs day-job path; fund progress | `Roster.pro_ready()`, `ProCall` forecast |
| M5 | Fighter → Contract | Stipend status; pro split after signing | `Roster.turn_pro()`, `StarDeal` |
| M6 | Roster | Chip: "Ready" / "Day-job — saving" / "Door closed" | `Roster.pro_ready()` |
| M7 | Money → Stipends | Hover: "Stop at signing saves $250/wk; defer costs = $0 up-front" | `ProCall.money()` |
| M8 | Money → One-offs | "$230–$1,245 paid now" or "from purse — cash saved" | `ProDebut.start_costs()` |
| M9 | Money → Club show | "Top of show = +10 followers toward debut fund" | ShowHosted |
| M10 | World → News | "A boxer from <gym> signs with Bow Lane" — no names | NewsFeed |
| M11 | Week review | Post-signing: "Amateur cut lost $75/wk; stipend saved $250/wk" | `ProWeekLines.lines_for()` |
| M12 | Fight prep → Pro camp | "4 rounds · opponent gap · costs paid/deferred" | `Roster.turn_pro()`, `ProDebut` |
| M13 | Fight night → Corner | "First pro fight — same ring, same plan" | CornerCard |
| M14 | Fights | Post-signing: debut countdown; promoter lean indicator | `ProLean.line()` |
| M15 | Fighter → History | Milestone: "Turned pro — Week N, Bow Lane/Harrow & Finch" | `f["pro_signed"]` |
| M16 | Club → Records | Same milestone | Records |
| M17 | Office desktop | Needs: Pro offer / "Saving for debut — Week N" | Desktop |
| M18 | Goal talk | "Build membership" / "Host a club show" | Goalsystem |
| M19 | Home gym floor | +2 people signing week; +1/week building toward BE | S409 crowd |

No new screens. All changes wire to existing UI elements.

---

## 9 — Failure Paths That Teach

| Failure | What the player sees | Lever |
|---|---|---|
| Debut loses money | Before: gym line + boxer line on offer. After: week review "Gym: share $X, costs $Y, net $Z" | More members; defer costs; keep stipend longer |
| Door closes | Each decline shows next need. After 3rd: "No promoter will call." Amateur career continues. | Nothing — the door is shut |
| Missed weight | $300 slot fee; next offer at 0.9× | Make weight |
| Age 32 | Shown from 30; final reminder at 31 | Sign before the cutoff |
| Bad deferral | "Save $X cash now · Pay $Y more total from the purse" | Compare pay-now vs defer on the offer |

---

## 10 — Changed from v3

1. **Removed "national title reopens door"** — the code has no reopen; after 3 declines the door is closed (`Roster.pro_ready()` returns false unconditionally).
2. **Corrected ask count** — the code has 6 asks (later2, later4, softer, split, price, costs), not 5. v3 merged later2 into later4; the code still has both.
3. **Corrected defer fee** — v3 said "+$100 when runway <4 weeks." Code: +$100 base, +$200 when runway <8 weeks (`ProCall.COSTS_RUNWAY_ADD := 200`, `COSTS_RUNWAY_THRESHOLD := 8`).
4. **Corrected costs range** — v3 charged every boxer $1,245. Code: $230–$1,245 depending on existing licences (`ProDebut.start_costs()`).
5. **Corrected deferred costs incidence** — v3 said "$1,345 from purse" as flat. Code: `costs + costs_from_purse` deducted from gross purse before the 25% split (`ProOfferWire.night()`), not from the gym's share.
6. **Flagged price ask bug** — `ProCall.money()` uses fixed `TICKET_PRICE := 50`, not the stored price. CHANGE required to use `t.get("price", ProDebut.TICKET_PRICE)`.
7. **Added dated money model** (section 3) — one table with dates, both parties' cash, what happens if bout cancelled or purse insufficient.
8. **Clarified lapse vs decline** (section 4.2) — a lapsed window is NOT a decline (S523). No morale, no loyalty, no terms change.
9. **Fixed ambition mapping** (section 6.1) — the "pro" morale path is never triggered because no ambition text contains "pro." Only "title" ambition has a morale effect. Added CHANGE for debut performance modifier.
10. **Day-job decisions tied to code** (section 5) — stop stipend (existing `weekly_salary`) and club show (existing ShowHosted). Cut v3's "save $150/week" (not in code).
11. **Age line framed as game rule** — ESTIMATE, not real-world law.
12. **Softer opponent direction clarified** — gap is positive; adding 0.5 makes opponent easier (opponent rating = night power − gap).
13. **Split ask thresholds corrected** — take at BE+20 (not "20+ over" vaguely), counter at BE+5 to BE+19.
14. **Added "no ask" option** — return to plain deal after viewing/countering; ask stays spent.

---

## 11 — Outstanding Questions

| # | Question | Owner |
|---|---|---|
| C1 | Does the price ask bug fix move it above 10% best? | Probe |
| C2 | Does the split ask need a lower threshold to reach 10%? | Probe |
| C3 | Does the softer ask have a niche (injury/stoppage) or should it be cut? | Probe |
| C4 | Does the day-job path (stop stipend + club show) move PREP above YES by $1,500? | Probe |
| C5 | Should the −5% debut performance for title ambition be built? | Owner decision |
| C6 | What happens to deferred costs if the bout is cancelled? | Owner decision (ESTIMATE: gym absorbs) |
