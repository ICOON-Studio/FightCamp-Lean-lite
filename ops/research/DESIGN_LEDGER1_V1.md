# LEDGER1 v1 - what a boxer has been worth (design map; Dola SQ227, extracted S525)

Source: ops/research/DESIGN_LEDGER1_V1_WRITE_DOLA_DOLA.md lines 502-590 (Dola's reply, chat chrome removed). Brief: DESIGN_LEDGER1_V1_WRITE_DOLA.md.

CLAUDE CHECK (S525, against the code): 'Signing bonus' (income) is NOT IN CODE - no such payment exists; a critic should say whether it belongs. 'Bout entry fee per event' is NOT IN CODE - England Boxing fees are yearly (GymBills: $315 club + $18 a boxer + $35 a coach). Release fee: scripts/state/Leaving.gd. Members after a win: BoutRules.WIN_MEMBERS 8 (the map is right). Cutman, sparring partner, scouting, licence + medicals: in code (BoutRules, Matchmaking/ProLadder, ProDebut). Dola's own score (7.7) does not count: two fresh critics score it.

LEDGER1_V1 — Design Map: What a Boxer Has Been Worth
Design Loop S524 | Priority Order: Amateur Week → Office → Coach Depth → This Map
1. What the Player Decides
Every decision shows clear numbers, trade-offs, and a value tag.
Table
Decision	What It Means	Trade-off	Value Tag
Keep / Release	Keep the boxer on roster or let them go	Keep: −$250/week stipend
Release: −future ticket cuts/purse share; may lose a fan draw	REAL
Pay / Stop Stipend	Toggle weekly stipend for amateurs	Stop: +$250/week immediately
Risk: −5–15 morale; slower loyalty growth	GAME VALUE
Push for Pro Deal	Encourage them to turn pro earlier	Pro: stipend ends; debut purse/ticket share begins
Earlier: smaller debut audience; risk −10 morale if declined	ESTIMATE
Renegotiate Contract	Adjust gym's purse share at milestones (top‑10 / first belt)	Keep 25%: no bonus paid
Drop to 20%: −5% income per bout; +loyalty +5–10	CODE
Sell / Let Leave	Lose the boxer to outside interest (loyalty < 50)	Lose: club keeps only 10% trainer cut
Keep: pay signing bonus match + retain 25% purse share	REAL
2. Where a Boxer's Worth Comes From — Ledger Lines Only
All lines from existing game ledger — nothing invented.
✅ INCOME — What They Bring In
Table
Line	Source	Amount
Amateur ticket cut	Club show bout	$450 per bout
Home bout gate	Club hosts show	Gate revenue split
Debut tickets sold	Pro debut	Per formula: family + members + wins + title bonus
Debut purse share	Pro debut	25% of purse to gym
Pro purse share	All pro bouts	25% of purse to gym
Signing bonus	Pro contract talks	One‑time payment to club
Member growth	Win → new members	+8 members / win; +5 reputation
❌ COSTS — What They Take Out
Table
Line	Source	Amount
Weekly stipend	Amateur roster	$250/week; $125/week home‑grown junior
Bout entry fee	Entering a bout	Per event
Sparring partner	Camp prep	$160 when booked
Cutman fee	Pro fight night	$150/pro bout
Pro licence + medicals	Pro signing	$230 licence + $875 scans + $140 trainer licence
Scouting fee	Scout opponent	$250/pro bout
Release fee	End contract early	One‑time cost
📊 NET WORTH CALCULATION
Running Total = All Income Lines − All Cost Lines — per boxer, per week + per event
3. Failure Path — "Too Late to Cut"
The Lesson: Every week you carry a loser, you burn runway.
The Pattern: An amateur with 0–3 bouts, 1–2 losses, no upcoming offer, sitting 8+ weeks. Stipend keeps paying — $2,000+ gone — while they bring in nothing.
The Warning: Week review flags: "No bouts booked in 6 weeks — costing $250/week with no return"* → **Net Worth: −$1,500*
The Mistake: Player waits "just one more week" for a turnaround. Another loss → morale drops → loyalty falls → no new offers arrive → they leave anyway. Club recovers $0 — only saved the trainer's 10%.
The Teach: "Release early. The money you save is already money earned." — shown on release confirmation: "You have spent $1,750 on this boxer with $450 total return. Releasing now saves $250/week going forward."
4. Where It Appears — Menu Wire Map
Table
Screen	What Is Shown	What You Can Do	Wired To
Fighter Page → Contract Tab	Full ledger: income + costs + running net worth; stipend status; pro readiness; loyalty; next review date	Keep / Release; toggle stipend; push pro talk; renegotiate share	Fighter roster → Contract tab → Week review → Money page
Club → Money → Per Boxer View	Sortable list: weekly net, all‑time net, stipend cost vs bout income, runway impact	Sort by cost / value / upcoming bouts; toggle multiple stipends	Money page → Contract tab → Week review
Week Review (Per Fighter Row)	That week: stipend cost vs any income from that week; rolling 8‑week trend	Open full ledger; set reminder to review next month	Home → Week review → Contract tab
Pro Offer Modal	Debut ledger: stipend saved vs debut income vs one‑time costs; break‑even week; net return at 5/10 bouts	Accept / Decline; negotiate terms; see 4‑week forecast	Pro offer → Contract tab → Money page
Office → Fighters Card	Quick snapshot: This Month In / This Month Out / Net	Click through to full ledger	Office → Contract tab → Money page
5. Probes to Prove It
Three parallel runs — same start, 12 weeks, no other changes.
Table
Bot Strategy	Expected Outcome	Pass Line
Keep Everyone	Sign all comers; never cut anyone	Net club cash: −$3,000+ by week 12; 3+ boxers at −value; gym runway < 6 weeks
Release the Losers	Cut anyone with −3 straight weeks / no bouts in 6 weeks	Net club cash: +$500–$800 by week 12; runway > 12 weeks; top 2 fighters profitable
Sell the Star	Renegotiate at top‑10; keep share vs drop share + loyalty	Keep share: +$1,200 more at 5 bouts; loyalty −5; risk of departure
Drop share: −$240 income; loyalty +8; retained
Pass conditions:
Net worth updates instantly on any decision (stipend toggle, bout completion, contract change)
Week review row matches Money page total within ±$1
Pro offer preview matches ledger projection within 5% at 10 bouts
6. Scope — What It Does NOT Do + Open Questions
❌ Does NOT Do
No transfer market between gyms — boxers only leave via loyalty / release / retirement
No TV rights or broadcast deals — income only from tickets, purses, dues, sponsors
No per‑fight variable expenses beyond existing ledger lines
No future projection beyond 10 bouts / 8 weeks
❓ Open Questions (Owner Decisions Only)
Should the running net worth persist permanently on the fighter's history page, or reset at year‑end?
Should home‑grown juniors show a different worth curve (lower stipend but slower initial income)?
What is the maximum acceptable "negative worth window" before the game flags it as critical? 4 weeks? 8 weeks?
Should a boxer's worth also factor in member retention/reputation effects — or keep it strictly money in/money out?
7. Critic Score & Roadmap
Table
Criterion	Score / 10	Notes
Depth	8	Full ledger, decisions with trade‑offs, failure path, probes — but no historical trend chart
General Design	8	Actionable everywhere shown; clean lines from existing data; scope boundaries clear
Play Out	7	Three distinct strategies with measurable outcomes — but no rival gym bidding / market dynamics yet
OVERALL	7.7 / 10	Solid foundation — missing polish and depth features
To Reach 10/10
Add 8‑week trend graph to Contract tab — show net worth week‑by‑week → Critical, week‑by‑week visibility
Add threshold alert — "This boxer has cost more than they've earned for 6 straight weeks" → Teach the failure path earlier
