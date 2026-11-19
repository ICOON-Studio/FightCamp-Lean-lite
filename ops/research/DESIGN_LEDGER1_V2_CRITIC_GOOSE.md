# LEDGER1 v2 Critic — Goose (independent, fresh read)

Read: the full critic pack (sections 1–8, S448/S451 code checks, the sandbox rule), then the design map at the end with Claude's code check at its top. I read `scripts/state/Leaving.gd`, `scripts/rules/StarDeal.gd`, `scripts/state/RivalOfferWire.gd`, `scripts/state/ApproachWire.gd`, `scripts/rules/Loyalty.gd`, `scripts/state/GymDeals.gd` to verify claims.

---

## Scores

SCORE depth=6 general=5

---

## 1. DEPTH — 6/10

**What works:**
- The three-tier alert system (yellow/orange/red) gives the player escalating pressure and clear action points.
- The 8-week trend graph with hover detail is a strong visual tool for spotting patterns.
- Break-even week and opportunity cost are the right questions to ask — they force the player to think about future value, not just current cost.
- The inactive status option for injured fighters is a real decision with real trade-offs (save cash now vs. lose training gains and loyalty).

**What's missing or weak:**
- **No dominant strategy emerges from the design.** The "Manage Contracts" bot is supposed to beat "Release the Losers" by $1,700+ (inactive saves $1,000+, renegotiate adds $1,200), but the design doesn't explain *when* to use each tool. A player reading this map won't know if they should always toggle inactive for any injured boxer, or only for injuries over 4 weeks. Without a threshold, the option is either always right or always wrong — not a trade-off.
- **The "Answer Rival Offer" decision conflates two different systems.** The design says "Match Offer / Let Leave, club keeps 10% trainer cut" — but the code shows RivalOfferWire is a rival gym offering a *bout* (accept/not this show/pass), while ApproachWire is a club coming for your boxer (stipend held to end day, five-column answer card: Match / Half / Move / Promise / Let Go). The design map's "Answer Rival Offer" row doesn't match either system. This is not a depth problem — it's a wrong problem.
- **The "Push for Pro Deal" decision is already in code** (ProOfferWire: two promoters, 14-day window, comeback after 2 wins) but the design treats it as a fresh choice without referencing the existing mechanics. The trade-off "earlier debut = smaller audience" is not backed by numbers — what's the debut ticket formula? How much smaller is "smaller"?
- **No interaction with morale or loyalty.** The design says stipend toggle moves morale "+/-5-15" (ESTIMATE) but doesn't say how that affects the fighter's performance, goal completion, or likelihood of leaving. A boxer with Low morale (0.7 of corner's word taken in) is a different fighter — does the ledger show that cost?
- **Opportunity cost is unmoored.** "$180/week net with an average replacement" — where does this number come from? The game has no "average replacement" boxer. The design doesn't explain how to calculate it from the roster of prospects or walk-ins. Without a source, it's a guess.

**What each option changes (owner S403):**
- **Keep / Release:** Clear. Keep = −$250/week, future income secured. Release = +$250/week saved, lose future income, −1–2 reputation. But the design doesn't say *when* to release. Is −3 weeks negative the right threshold? What if the boxer has a bout booked in 2 weeks? The alert says "Release Now" at −6 weeks + no bouts, but what about −4 weeks + a bout in 3 weeks? The design needs a decision rule, not just a trigger.
- **Toggle Stipend:** The trade-off is cash vs. morale/loyalty, but the design doesn't quantify the morale effect on performance. A Fired Up boxer (1.05 multiplier) vs. a Low boxer (0.7) is a 35% difference in corner calls taken — that's worth more than $250/week in fight outcomes. The ledger should show that cost.
- **Inactive Status:** The trade-off is $0/week stipend vs. no training gains, no bout offers, −10 loyalty. But the design doesn't say *how long* a boxer can stay inactive, or what happens when loyalty hits 25 (the fighter leaves). If a boxer is injured for 8 weeks and loyalty drops from 60 to 50, that's fine — but if they start at 35, they leave at week 5. The design needs to show the loyalty forecast.
- **Push for Pro Deal:** The trade-off is earlier debut (stipend ends sooner) vs. bigger ticket base (more amateur bouts). But the design doesn't say how much bigger. A pro debut pays 25% of purse + ticket share — what's the expected purse at debut? What's the ticket formula? Without numbers, the player can't compare.
- **Renegotiate Contract:** The trade-off is keep 25% (no bonus) vs. drop to 20% (+5-10 loyalty). But the code shows the real options are: top-10 keep 25% for $2,500 bonus or drop to 20%; belt keep 25% for $5,000 bonus or drop to 17%; yearly keep current share for 40% of last year's earnings or drop 2 points (floor 12%). The design's "20%" is wrong — it's 20% at top-10, 17% at belt, and a sliding scale yearly. The loyalty effect is also wrong — the code doesn't tie loyalty to the share choice.
- **Answer Rival Offer:** This row is wrong. The design says "Match / Let Leave, club keeps 10% trainer cut" — but the code shows no 10% trainer cut on leaving. The real systems are: RivalOfferWire (bout challenge: accept / not this show / pass) and ApproachWire (club poaching: Match / Half / Move / Promise / Let Go, with stipend held to end day, holder grievance ticks). The design needs to pick one or split the row.

---

## 2. GENERAL DESIGN — 5/10

**What works:**
- The wire map is thorough — it shows every screen that touches the ledger and how they connect.
- The split between one-time and recurring costs is clear and useful.
- The three probes (Keep Everyone / Release the Losers / Manage Contracts) are a good way to test the design.
- Claude's code check at the top is honest — it flags three WRONG CODE claims.

**What's wrong or missing:**
- **Three WRONG CODE claims that the design doesn't fix.** The CLAUDE CHECK says:
  1. Early release fee "4 weeks' stipend = $1,000" — wrong. Code: amateur leaves free (no cash fee), pro's release fee = max($500, year_take * 0.4). The design's "Release Now: Save $1,000 over next 4 weeks" is based on the wrong number.
  2. Renegotiate "keep 25% / drop to 20% +5-10 loyalty" — wrong. Code: top-10 keep 25% for $2,500 bonus or drop to 20%; belt keep 25% for $5,000 bonus or drop to 17%; yearly keep current share for 40% of last year's earnings or drop 2 points (floor 12%). No loyalty number is tied to it.
  3. "Answer Rival Offer: Match / Let Leave, club keeps 10% trainer cut" — wrong. Code: RivalOfferWire is a bout challenge (accept / not this show / pass); ApproachWire is club poaching (Match / Half / Move / Promise / Let Go, stipend held to end day). No 10% trainer cut on leaving exists.
  
  The design map marks these as CODE but they're wrong. A critic can't score a design that misrepresents the code it's built on.

- **The "Inactive Status" is marked ESTIMATE but has no mechanical spec.** The design says "no stipend deducted, no offers received, no training gains" — but how is this implemented? Does the fighter's page show an "Inactive" button? What triggers it (injury, suspension, player choice)? How does the game know when to re-activate? The design needs to specify the UI and the state machine.

- **The "Opportunity Cost" estimate is unmoored from any game system.** "$180/week net with an average replacement boxer" — the game has no "average replacement" boxer. The design doesn't explain how to calculate it from the roster of prospects or walk-ins. Is it the expected net worth of a 3-star prospect? A 2-star? The design needs to specify the source.

- **The "Prime Window" is vague.** "X years at peak performance before decline begins" — the design says this is read from the boxer's age/attributes (CODE), but the code doesn't have a "prime window" calculation. The attributes don't decline with age in the current code (ageing is BUILT in the world model but the fighter's attributes don't drop). The design needs to specify what "prime window" means and where it's calculated.

- **The 8-week trend graph's hover card is marked ESTIMATE with no detail.** "Exact figure + what changed that week (bout income, stipend paid, fee incurred)" — how is this displayed? A tooltip? A side panel? What if multiple things changed in one week? The design needs to specify the UI.

- **The wire map doesn't specify what happens when a boxer has no bouts for 12+ weeks.** The orange alert triggers at 6 weeks, the red at −6 weeks + no bouts — but what if the player dismisses the red alert and keeps the boxer for 12 weeks? Does the alert come back? Does it escalate? The design needs to specify the alert lifecycle.

- **The "Keep Everyone" bot strategy doesn't account for the roster limit.** The code gives 3 places base, +2 per premises tier, +1 per second coach (5 and 7 at the larger premises). The bot can't "sign all comers" if the roster is full. The design needs to specify what the bot does when it can't sign.

- **The design doesn't address how the ledger interacts with the existing morale/loyalty systems.** The stipend toggle moves morale, the release moves reputation, the inactive status moves loyalty — but the design doesn't show how these interact. A boxer with Low morale is a different fighter — does the ledger show that cost? A boxer with loyalty under 25 leaves — does the ledger warn before that happens?

- **The "Review in N weeks" reminder is not specified.** The yellow alert says "Review in 4 weeks" — but is this automatic or manual? Does the game set a reminder that fires in 4 weeks? Does the player set it? The design needs to specify.

- **The design doesn't specify the Contract tab's layout.** The wire map says "Full ledger: income + costs (split one-time/recurring); running net worth; 8-week trend; loyalty; pro readiness; prime window; break-even week; opportunity cost" — but how is this laid out? A table? A chart? A card per section? The design needs to specify the UI.

- **The design doesn't specify the Money page's per-boxer view.** The wire map says "Sortable list: weekly net, all-time net, stipend cost vs bout income, runway impact, break-even week, opportunity cost" — but how is this sorted? By weekly net? By all-time net? By break-even week? The design needs to specify the default sort and the columns.

---

## 3. PLAY — not scored (the brief asks for DEPTH and GENERAL DESIGN only)

But a note: the design is missing the *fun* of managing a club's money. The ledger is a spreadsheet, not a story. The design needs to show the *drama* of a boxer's worth — the moment when a walk-in becomes a star, the moment when a veteran's decline forces a hard choice. The 8-week trend graph is a start, but it's not enough. The design needs to show the *narrative* of a boxer's value — not just the numbers.

---

## 4. Which options are missing, which are useless, and what each changes

**Missing:**
- **A decision rule for when to release.** The alerts trigger at −3 and −6 weeks, but the design doesn't say what to do at −4 weeks with a bout in 2 weeks. The player needs a rule: "Release if −4 weeks + no bout in 3 weeks, keep if −4 weeks + bout in 2 weeks."
- **A loyalty forecast for the inactive status.** The design says −10 loyalty per inactive period, but doesn't show when the boxer will leave. The player needs to see: "Inactive for 4 weeks: loyalty drops from 60 to 50. Inactive for 8 weeks: loyalty drops from 60 to 40. At 25, the boxer leaves."
- **A morale cost for the stipend toggle.** The design says "+/-5-15 morale" but doesn't show the effect on performance. The player needs to see: "Pause stipend: morale drops from 75 (Fired Up, 1.05) to 60 (Steady, 1.0). Corner calls taken: −5%."
- **A pro debut projection.** The design says "earlier debut = smaller audience" but doesn't show the numbers. The player needs to see: "Turn pro now: debut purse $1,500, ticket share $400, gym net $475. Wait 4 weeks: debut purse $1,500, ticket share $800, gym net $650."
- **A release fee calculator.** The design says "Release now saves $1,000" but the code shows the fee is max($500, year_take * 0.4) for pros, $0 for amateurs. The player needs to see: "Release now: amateur leaves free, pro pays max($500, year_take * 0.4)."

**Useless:**
- **The "Prime Window" line.** The code doesn't have a prime window calculation, and the attributes don't decline with age. The design needs to either implement the decline or remove the line.
- **The "Opportunity Cost" line.** The game has no "average replacement" boxer, so the $180/week is a guess. The design needs to either specify the source (e.g., "expected net worth of a 3-star prospect") or remove the line.
- **The "Answer Rival Offer" row as written.** The design conflates two different systems (RivalOfferWire and ApproachWire). The design needs to split the row into two: "Answer Bout Challenge" (RivalOfferWire: accept / not this show / pass) and "Answer Club Approach" (ApproachWire: Match / Half / Move / Promise / Let Go).

**What each option changes:**
- **Keep / Release:** Keep = −$250/week, future income secured, reputation stable. Release = +$250/week saved, lose future income, −1–2 reputation (amateur) or −1–3 (ranked), open roster spot. For pros: release fee = max($500, year_take * 0.4).
- **Toggle Stipend:** Pay = −$250/week, +5-15 morale, faster loyalty growth. Pause = +$250/week, −5-15 morale, loyalty grows slower. Effect on performance: Fired Up (75+, 1.05) vs. Steady (50+, 1.0) vs. Flat (30+, 0.85) vs. Low (under 30, 0.7).
- **Inactive Status:** Inactive = $0/week stipend, no training gains, no bout offers, −10 loyalty. Active = full stipend, normal progress. Loyalty forecast: "At current rate, boxer leaves in N weeks."
- **Push for Pro Deal:** Earlier = stipend ends sooner, smaller debut audience, risk −10 morale if declined. Later = more amateur bouts, bigger ticket base, full stipend continues. Projection: "Turn pro now: gym net $475. Wait 4 weeks: gym net $650."
- **Renegotiate Contract:** Keep 25% = full income per bout, pay bonus ($2,500 at top-10, $5,000 at belt, 40% of last year's earnings yearly). Drop share = −5% to −8% purse income per bout, no bonus, loyalty unchanged (code doesn't tie loyalty to share).
- **Answer Bout Challenge (RivalOfferWire):** Accept = books a bout at the next region show, pass = −2 points to challenger, free while hurt or booked. Not this show = free once a season with that rival.
- **Answer Club Approach (ApproachWire):** Match = retain boxer, stipend held to end day. Half = retain boxer, stipend halved, holder grievance ticks. Move = retain boxer, stipend moved from another boxer, grievance ticks. Promise = retain boxer, promise a bout or debut, stipend ask ticks again after the night. Let Go = boxer departs, reputation cost.

---

## 5. To reach 10/10

**Most important first:**

1. **Fix the three WRONG CODE claims.** The design map says "Early release fee = 4 weeks' stipend = $1,000" — change to "Amateur leaves free, pro's release fee = max($500, year_take * 0.4)". The design says "Renegotiate: keep 25% / drop to 20% +5-10 loyalty" — change to "Top-10: keep 25% for $2,500 bonus or drop to 20%; belt: keep 25% for $5,000 bonus or drop to 17%; yearly: keep current share for 40% of last year's earnings or drop 2 points (floor 12%). No loyalty effect." The design says "Answer Rival Offer: Match / Let Leave, club keeps 10% trainer cut" — split into two rows: "Answer Bout Challenge (RivalOfferWire): Accept / Not this show / Pass" and "Answer Club Approach (ApproachWire): Match / Half / Move / Promise / Let Go, no trainer cut on leaving."

2. **Add a decision rule for when to release.** The alerts trigger at −3 and −6 weeks, but the player needs a rule: "Release if −4 weeks + no bout in 3 weeks. Keep if −4 weeks + bout in 2 weeks. Release if −6 weeks + no bout in 1 week. Keep if −6 weeks + bout booked." Add a "Recommendation" line to the red alert: "Release now saves $X over next Y weeks" or "Keep — bout in Z weeks."

3. **Add a loyalty forecast for the inactive status.** Show the loyalty trajectory: "Inactive for 4 weeks: loyalty drops from 60 to 50. Inactive for 8 weeks: loyalty drops from 60 to 40. At 25, the boxer leaves." Add a "Weeks until boxer leaves" line to the inactive confirmation.

4. **Add a morale cost for the stipend toggle.** Show the morale trajectory: "Pause stipend: morale drops from 75 (Fired Up, 1.05) to 60 (Steady, 1.0) in 2 weeks. Corner calls taken: −5%." Add a "Performance impact" line to the stipend toggle confirmation.

5. **Add a pro debut projection.** Show the numbers: "Turn pro now: debut purse $1,500, ticket share $400, gym net $475. Wait 4 weeks: debut purse $1,500, ticket share $800, gym net $650." Add a "Compare" button to the pro offer modal that shows the projection at different dates.

6. **Implement or remove the "Prime Window" line.** The code doesn't have a prime window calculation, and the attributes don't decline with age. Either implement the decline (e.g., "Speed drops 1 point per year after 30") or remove the line from the ledger.

7. **Specify the source of the "Opportunity Cost" estimate.** The game has no "average replacement" boxer. Either specify the source (e.g., "expected net worth of a 3-star prospect from Find a Fighter") or remove the line from the ledger.

8. **Specify the Contract tab's layout.** The wire map says "Full ledger: income + costs (split one-time/recurring); running net worth; 8-week trend; loyalty; pro readiness; prime window; break-even week; opportunity cost" — but how is this laid out? Specify: "Top section: 8-week trend graph (three lines: income, costs, net worth). Middle section: two columns — Income (amateur ticket cut, home bout gate share, pro purse share, member growth) and Costs (one-time: sparring partner, cutman, pro licence; recurring: weekly stipend, yearly club fees). Bottom section: Running totals (weekly net, all-time net, break-even week, opportunity cost, prime window)."

9. **Specify the Money page's per-boxer view.** The wire map says "Sortable list: weekly net, all-time net, stipend cost vs bout income, runway impact, break-even week, opportunity cost" — specify the default sort (by weekly net, ascending) and the columns (fighter, weekly net, all-time net, stipend cost, bout income, break-even week, opportunity cost, alert status).

10. **Specify the alert lifecycle.** The yellow alert triggers at −3 weeks, the orange at 6 weeks no bouts, the red at −6 weeks + no bouts — but what if the player dismisses the red alert? Does it come back next week? Does it escalate? Specify: "Yellow alert: dismissible, returns in 4 weeks if still negative. Orange alert: dismissible, returns in 2 weeks if no bouts booked. Red alert: not dismissible, stays until the boxer is released or a bout is booked."

11. **Specify the "Review in N weeks" reminder.** The yellow alert says "Review in 4 weeks" — specify: "Automatic reminder: the game sets a reminder that fires in 4 weeks, shown as a yellow flag on the top bar. The player can dismiss the reminder, but it returns if the boxer is still negative."

12. **Add a release fee calculator to the ledger.** The design says "Release now saves $1,000" but the code shows the fee is max($500, year_take * 0.4) for pros, $0 for amateurs. Add a "Release fee" line to the ledger: "Amateur: free. Pro: max($500, year_take * 0.4) = $X."

13. **Add a morale effect to the stipend toggle.** The design says "+/-5-15 morale" but doesn't show the effect on performance. Add a "Performance impact" line: "Fired Up (75+, 1.05) vs. Steady (50+, 1.0) vs. Flat (30+, 0.85) vs. Low (under 30, 0.7). Corner calls taken: −5% to −35%."

14. **Add a loyalty effect to the inactive status.** The design says "−10 loyalty" but doesn't show when the boxer will leave. Add a "Loyalty forecast" line: "At current rate, boxer leaves in N weeks (loyalty drops to 25)."

15. **Add a narrative to the ledger.** The ledger is a spreadsheet, not a story. Add a "Story" section to the Contract tab: "Week 1: Signed as a walk-in, 3-star prospect. Week 4: First bout, win by decision, +8 members. Week 8: Second bout, loss by stoppage, −2 members. Week 12: Third bout, win by decision, +8 members. Current: 2-1 record, regional rank 8, 4 weeks to break-even." This turns the numbers into a story the player can feel.

---

## 6. The 10/10 design as a 1920x1080 page

**Top section (400px): The Story**
A narrative card at the top: "Week 1: Signed as a walk-in, 3-star prospect. Week 4: First bout, win by decision, +8 members. Week 8: Second bout, loss by stoppage, −2 members. Week 12: Third bout, win by decision, +8 members. Current: 2-1 record, regional rank 8, 4 weeks to break-even." The story turns the numbers into a narrative the player can feel.

**Middle section (600px): The 8-Week Trend Graph**
A large graph with three lines: Total Income (green), Total Costs (red), Net Worth (blue). Horizontal line at $0. Colour bands: Green (>0), Yellow (−1 to −3 weeks), Red (−4+ weeks). Hover card: exact figure + what changed that week (bout income, stipend paid, fee incurred) + story beat ("Week 8: loss by stoppage, −2 members").

**Bottom section (800px): The Ledger**
Two columns:
- **Left column (Income):** Amateur ticket cut ($450 x 2 = $900), Home bout gate share ($200), Pro purse share (none yet), Member growth (+8 members / win = $280/month). Total: $1,380 + $280/month.
- **Right column (Costs):** One-time: Sparring partner ($160), Cutman ($150), Pro licence ($1,245). Recurring: Weekly stipend ($250/week = $1,000 over 4 weeks), Yearly club fees ($18/week = $72 over 4 weeks). Total one-time: $1,555. Total recurring: $1,072 over 4 weeks.

**Bottom bar (200px): The Decision**
Three boxes:
- **Weekly Net:** −$268/week (stipend $250 + fees $18 = $268, income $0 this week). Break-even: Week 16.
- **All-Time Net:** −$672 (income $1,380, costs $2,052). Opportunity cost: $180/week with a 3-star replacement.
- **Recommendation:** Keep — bout in 2 weeks. Release now saves $536 over next 2 weeks, but bout adds $450. Net: keep saves $84.

**Right sidebar (full height): The Actions**
Five buttons:
- **Toggle Stipend:** Pay $250/week (+5-15 morale, faster loyalty) or Pause $250/week (−5-15 morale, loyalty grows slower). Performance impact: Fired Up (1.05) vs. Steady (1.0) vs. Flat (0.85) vs. Low (0.7).
- **Set Inactive:** $0/week stipend, no training gains, no bout offers, −10 loyalty. Loyalty forecast: "At current rate, boxer leaves in 8 weeks."
- **Push for Pro:** Turn pro now (gym net $475) or wait 4 weeks (gym net $650). Compare button shows projection at different dates.
- **Renegotiate:** Top-10: keep 25% for $2,500 bonus or drop to 20%. Belt: keep 25% for $5,000 bonus or drop to 17%. Yearly: keep current share for 40% of last year's earnings or drop 2 points (floor 12%).
- **Release:** Amateur leaves free. Pro pays max($500, year_take * 0.4) = $X. Confirmation: "You have spent $2,052 on this boxer with $1,380 total return. Releasing now saves $268/week going forward."

**Top bar (full width): The Alerts**
Three flags:
- **Yellow (−3 weeks):** "3 weeks running negative — costing $250/week." Review in 4 weeks (automatic reminder).
- **Orange (6 weeks no bouts):** "No bouts in 6 weeks — $1,500 invested, $450 returned." Find bout / Review in 2 weeks / Release.
- **Red (−6 weeks + no bouts):** "Critical: 6+ weeks negative. Release now saves $250/week going forward." Not dismissible — stays until boxer is released or bout is booked.

This is the 10/10 design: a story, a graph, a ledger, a decision, and a set of actions — all in one view, all with clear numbers and trade-offs, all with a narrative the player can feel.
