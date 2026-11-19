# LEDGER1_V1 Critique — Goose (Sports Management-Sim Designer)

Critic: Goose | Discipline: Boxing management simulation | Date: 2026-11-19

---

## SCORES

**DEPTH: 7/10**

**GENERAL DESIGN: 6/10**

---

## DEPTH — Reasons

**Strengths:**
- Five decisions with real trade-offs that interact with morale, loyalty, and cash flow
- The failure path ("Too Late to Cut") is excellent design — it teaches the player through consequences, not tutorials
- Probes are specific and measurable (three bot strategies with pass lines)
- Decisions have immediate and long-term consequences (release now saves $250/week but loses future income)

**Weaknesses:**
- No opportunity cost display — the player cannot see what else that roster spot could earn if filled by a different boxer
- No prime window indicator — a 28-year-old boxer with 3 years left at peak is worth more than a 34-year-old with 1 year, even if their current net worth is identical
- No break-even analysis — the player cannot see when a boxer will become profitable (critical for amateurs with 0-3 bouts)
- No comparison view — how does this boxer's worth compare to others on the roster? The player needs relative value, not just absolute
- No exit cost calculator — what's the total cost if I release now vs in 4 weeks? The failure path teaches this after the fact, but the player needs it before the decision
- Historical trend is mentioned as missing (8-week graph) but the design doesn't specify what the trend should show — just "net worth week-by-week" is not enough; it needs to show income vs costs separately so the player sees the trajectory

**Missing Interactions:**
- The design doesn't account for how releasing a boxer affects other boxers' morale ("if they cut him, will they cut me?")
- No consideration of reputation impact — releasing a popular boxer hurts member retention
- No rival gym bidding — if a boxer's loyalty is low, the design says they leave, but doesn't show the player a competing offer to match

---

## GENERAL DESIGN — Reasons

**Strengths:**
- All income and cost lines are from existing game ledger — nothing invented
- Clear menu wire map showing where the mechanic appears
- Scope boundaries are explicit (no transfer market, no TV rights, no per-fight variable expenses beyond ledger lines)
- The failure path is actionable and teaches through the UI

**Weaknesses:**
- **CRITICAL: Two cost lines do not exist in code**
  - "Signing bonus" (income) — NOT IN CODE. The CLAUDE CHECK (S525) confirms this. The design says it comes from "Pro contract talks" but no such payment exists. This is a design flaw — either remove it or specify how to build it.
  - "Bout entry fee per event" (cost) — NOT IN CODE. England Boxing fees are yearly ($315 club + $18 a boxer + $35 a coach), not per event. This line is wrong and should be removed or corrected.
- **"Sell / Let Leave" is confusing** — is this a rival gym making an offer, or the player selling the contract? Real boxing doesn't have transfer fees. The design says "Lose: club keeps only 10% trainer cut" but doesn't explain the mechanism. Is this a rival gym poaching? If so, where does that appear in the menu wire map?
- **Menu wire map references "Contract Tab" but the fighter page doesn't have one** — section 5.5 shows tabs: Overview, Week, Fight prep, Playbook, History. No Contract tab. The design needs to specify where this tab goes or which existing tab it replaces.
- **No consideration of time value** — a dollar earned today is worth more than a dollar earned in 10 weeks. The design treats all dollars equally, which is fine for a game, but the projection should discount future income (or at least note the assumption).
- **One-time costs vs recurring costs are mixed** — the ledger shows "Pro licence + medicals" ($1,245 total) as a single line, but this is only paid once at pro signing. The design should separate one-time costs from recurring weekly costs so the player sees the cash flow impact clearly.

---

## Which Options Are Missing

1. **Opportunity cost display** — "This roster spot could earn $X/week with a replacement from the prospect pool" — shows the player the cost of keeping a underperforming boxer
2. **Prime window indicator** — "3 years at peak, then decline" — helps the player decide whether to invest in a boxer or cut them before they age out
3. **Break-even week** — "This boxer becomes profitable at week 14 (after 3 amateur bouts)" — critical for amateurs with no income yet
4. **Comparison view** — "Your boxers ranked by net worth" — shows relative value, not just absolute
5. **Exit cost calculator** — "Release now: save $1,000 over 4 weeks. Wait 4 weeks: cost $1,000 more" — helps the player time the release decision
6. **Morale impact preview** — "Releasing this boxer will lower other boxers' morale by -3" — shows the hidden cost of the decision
7. **Reputation impact preview** — "Releasing a 5-0 boxer will cost -2 reputation and -5 members" — shows the member retention cost

---

## Which Options Are Useless

1. **Signing bonus (income)** — NOT IN CODE. Remove it or specify how to build it. A critic should not judge a mechanic that doesn't exist.
2. **Bout entry fee per event (cost)** — NOT IN CODE. England Boxing fees are yearly, not per event. Remove it or correct it to "Yearly England Boxing fees: $315 club + $18 a boxer + $35 a coach" and spread that cost across the year.
3. **"Sell / Let Leave" as written** — confusing terminology. If this is a rival gym poaching, rename it "Rival offer" and show it in the menu wire map. If this is the player selling the contract, explain the mechanism (real boxing doesn't have transfer fees).

---

## What Each Option Changes

**Keep / Release:**
- Keep: −$250/week stipend, +future ticket cuts/purse share, roster spot occupied
- Release: +$250/week saved, −future income, roster spot open, morale impact on other boxers, reputation impact if boxer was popular
- **Changes:** cash flow, roster capacity, morale of other boxers, reputation, member retention

**Pay / Stop Stipend:**
- Pay: −$250/week, +morale, +loyalty growth, boxer feels valued
- Stop: +$250/week, −5–15 morale, slower loyalty growth, boxer feels undervalued
- **Changes:** weekly cash flow, morale, loyalty, training quality (morale affects performance), risk of boxer leaving

**Push for Pro Deal:**
- Push: stipend ends, debut purse/ticket share begins, risk of −10 morale if declined
- Wait: stipend continues, no pro income yet, boxer may lose patience
- **Changes:** cash flow (stipend vs purse share), morale, loyalty, career progression

**Renegotiate Contract:**
- Keep 25%: no bonus paid, risk of −5 loyalty, boxer may leave at top-10
- Drop to 20%: −5% income per bout, +5–10 loyalty, boxer feels rewarded
- **Changes:** gym's share of purse, loyalty, risk of boxer leaving, long-term income

**Sell / Let Leave (as written):**
- Let Leave: lose boxer, club keeps only 10% trainer cut, roster spot open
- Keep: pay signing bonus match (DOESN'T EXIST) + retain 25% purse share
- **Changes:** roster spot, income share, loyalty (if kept), morale (if lost)
- **Note:** This option is broken because "signing bonus match" doesn't exist in code. Fix the terminology or the mechanic.

---

## To Reach 10/10

**Most important first:**

1. **Fix the code discrepancies** — Remove "Signing bonus" and "Bout entry fee per event" from the cost/income lines, or specify how to build them. A design that references non-existent mechanics is not buildable. (Specific: delete lines 2 and 7 from the ❌ COSTS table, or add a build spec for each.)

2. **Add break-even analysis to the Contract tab** — Show "This boxer becomes profitable at week X (after Y amateur bouts)" with a progress bar. This is the single most important number for an amateur boxer with no income yet. (Specific: add a card to the Contract tab showing break-even week, calculated from weekly stipend cost vs average amateur ticket cut.)

3. **Add opportunity cost display** — Show "This roster spot could earn $X/week with a replacement" based on the prospect pool's average potential. This teaches the player that keeping an underperforming boxer has a hidden cost. (Specific: add a line to the Contract tab showing "Opportunity cost: $X/week" calculated from the average net worth of available prospects.)

4. **Add prime window indicator** — Show "X years at peak, then decline" based on age and age curve. A 28-year-old with 3 years at peak is worth more than a 34-year-old with 1 year, even if their current net worth is identical. (Specific: add a line to the Contract tab showing "Prime window: X years" calculated from age and the age decline curve in the world model.)

5. **Clarify "Sell / Let Leave"** — Rename to "Rival offer" if this is a rival gym poaching, and show it in the menu wire map (Home → Needs flag → Rival offer modal). If this is the player selling the contract, explain the mechanism (real boxing doesn't have transfer fees; the only cost is the 10% trainer cut if the boxer leaves). (Specific: rewrite the decision table to show "Rival offer" with a modal that shows the rival's offer, the player's counter, and the morale/loyalty impact.)

6. **Add historical trend graph** — Show 8-week net worth week-by-week, with income and costs as separate lines (not just net). This lets the player see the trajectory, not just the current number. (Specific: add a chart to the Contract tab with three lines: income, costs, net worth, each week for the last 8 weeks.)

7. **Add comparison view** — Show "Your boxers ranked by net worth" on the Money page. This lets the player see relative value, not just absolute. (Specific: add a sortable table to the Money page showing each boxer's net worth, weekly net, and all-time net, sortable by any column.)

8. **Add exit cost calculator** — Show "Release now: save $X over 4 weeks. Wait 4 weeks: cost $X more." This helps the player time the release decision. (Specific: add a button to the Contract tab "Calculate exit cost" that shows the cost of releasing now vs in 4/8/12 weeks, based on weekly stipend and projected income.)

9. **Add morale and reputation impact preview** — Show "Releasing this boxer will lower other boxers' morale by -3 and cost -2 reputation" before the player confirms. This shows the hidden cost of the decision. (Specific: add a preview to the Release confirmation modal showing morale impact on other boxers and reputation impact.)

10. **Separate one-time costs from recurring costs** — The ledger should show "One-time costs: $X" and "Recurring weekly costs: $Y" separately, so the player sees the cash flow impact clearly. (Specific: split the ❌ COSTS table into two tables: "One-time costs" and "Recurring weekly costs".)

---

## 10/10 Description — 1920x1080 Page

**Layout:**

**Top bar (1920x60):** Back arrow, gym name, date/week, flags, cash with "running +/- $N a week", big button, Menu.

**Left panel (600x1020):** Fighter portrait, name, age, record, rank. Below: **PRIME WINDOW** card showing "3 years at peak, then decline" with a progress bar. Below: **BREAK-EVEN** card showing "Profitable at week 14 (after 3 amateur bouts)" with a progress bar. Below: **OPPORTUNITY COST** card showing "This roster spot could earn $300/week with a replacement" with a comparison to the prospect pool.

**Center panel (800x1020):** **NET WORTH LEDGER** with two tables:
- **INCOME** (amateur ticket cut, home bout gate, debut tickets, debut purse share, pro purse share, member growth) with amounts and totals
- **COSTS** split into **One-time** (sparring partner, cutman fee, pro licence + medicals, scouting fee, release fee) and **Recurring weekly** (weekly stipend)
- **NET WORTH** running total with a chart showing 8-week trend (three lines: income, costs, net worth)

**Right panel (520x1020):** **DECISIONS** card with five buttons:
- **Keep / Release** with preview: "Release now: save $1,000 over 4 weeks. Morale impact: -3. Reputation impact: -2."
- **Pay / Stop Stipend** with preview: "Stop: +$250/week. Morale: -10. Loyalty: -5."
- **Push for Pro** with preview: "Stipend ends. Debut purse: $X. Risk: -10 morale if declined."
- **Renegotiate** with preview: "Drop to 20%: -$240/bout. Loyalty: +8."
- **Rival offer** (if any) with preview: "Match: pay $X bonus. Let leave: keep 10% trainer cut."

**Bottom panel (1920x200):** **COMPARISON VIEW** table showing "Your boxers ranked by net worth" with columns: name, net worth, weekly net, all-time net, prime window, break-even week. Sortable by any column.

**Action:** Click a decision button to open a modal with full preview and confirm/cancel.

---

SCORE depth=7 general=6
