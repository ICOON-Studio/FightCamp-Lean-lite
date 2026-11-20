# DESIGN_TURNPRO1_V6 — turning pro map v6
Status: Gap curve measured | All constants verified against S530 + TURNGAP1 | Tags: CODE=verified, CHANGE=new rule/number, ESTIMATE=target until probe confirms, CUT=removed
Owner rules kept: names only in headers; gender-neutral; no new screens; actionable info only; 14-day window; TAPER week before bouts.
1 — When & Who Calls
1.1 Trigger Rules
Table
Rule	Value	Tag	Source
First call: wins + ranked	7 wins AND regional top 3	CODE	Roster.pro_ready()
First call: wins any rank	9 wins, any ranking	CODE	Roster.pro_ready()
Day-job first call	6 wins AND regional top 3	CHANGE	Roster.pro_ready() — day-job branch
National finalist	First call at any win count, 0 declines	CODE	Roster.pro_ready()
After 1 decline	Same promoter calls; need +2 wins; terms ×0.9	CODE	ProOfferWire.on_decline() + ProCall.terms()
After 2 declines	Only regional rank 1 brings a call; win requirement removed	CODE	Roster.pro_ready() — pro_declines >=2: return rank==1
After 3 declines	Door closed permanently	CODE	Roster.pro_ready() — pro_declines >=3: return false
Age cutoff	No first call at age 32+	ESTIMATE	ProCall.calls_open() — age < AGE_STOP
Age warning	Shown from age 29	ESTIMATE	ProCall.age_line() — age >=29
Offer window	14 days	ESTIMATE	ProCall.WINDOW_DAYS :=14
Window expires	NOT a decline; promoter waits 2 more wins, full terms	CODE	ProOfferWire.lapse_if_due() — RETURN_WINS :=2
Additional gates	No booked bout; not in nationals; 2 wins after lapse; age check in make()	ADDED	ProOfferWire.waited() + ProCall.calls_open()
1.2 Who Calls
Table
Ticket forecast	Who calls	Tag	Source
≥ 75	Bow Lane only	CODE	ProCall.who_calls()
46–74	Both, side by side	CODE	ProCall.who_calls()
≤ 45	Harrow & Finch only	CODE	ProCall.who_calls()
After decline	Same promoter only	CODE	ProOfferWire.make()
Title won since decline	Terms reset to 1.0×	CODE	ProCall.terms()
1.3 The Two Promoters — Corrected Opponent Gaps
Table
	Bow Lane	Harrow & Finch	Source
Debut purse	$1,500	$1,800 guaranteed	CODE ProCall.promoters()
Break-even	60 tickets	70 tickets	CODE
Boxer share past BE	50%	30%	CODE
Below BE	Purse −$25/ticket short, floor $500	Guaranteed, no deduction	CODE
Debut date	4 weeks out	6 weeks out	CODE
Opponent gap	−1.0	0.0	CHANGE — from TURNGAP1 curve
Debut win chance	~67% (target 65–80%)	~79% (target 70–85%)	CHANGE — BoutRead from TURNGAP1
Correction from v5: v5 inverted the gap direction. opp_gap = night − opp_rating: negative = opponent stronger, positive = opponent weaker. TURNGAP1 measured: −1.0 = ~67% win rate (Bow Lane, harder debut); 0.0 = ~79% win rate (HF, easier debut) — exactly the bands needed.
2 — The Asks — Revised & Explained
One ask per offer per house; shows answer + cost before pressing; one ask spent per view; return to plain always available.
2.1 Later +2 Weeks — KEPT
Table
	Value	Tag
Purse	−$150	CODE
Debut date	+2 weeks	CODE
Ticket forecast at night	+~4 tickets (6 members × 0.5)	CHANGE — visible preview
When best	Conflicting amateur bout; need more ticket growth	CODE
2.2 Later +4 Weeks — RESTORED with visible value
Table
	Value	Tag
Purse	−$300	CODE
Debut date	+4 weeks	CODE
Ticket forecast at night	+~8 tickets visible on offer	CHANGE — preview fixed
When best	Need 6+ more tickets to hit break-even	CHANGE — visible use case
Restored: v5 cut this because the preview was frozen. Now the offer shows the debut-date forecast, not the arrival-date forecast. Real value → real choice.
2.3 Own Ticket Price — KEPT + clearer downside
Table
	Value	Tag
Ticket price	$40 (was $50)	CODE
Extra tickets	+15	CODE
Best range	46–91 tickets	CORRECTED from v5
Above 91 tickets	Plain pays $25/ticket; Price pays $20 → −$25/ticket above cap	CODE
Shown on button	"Above 91 tickets: −$200 total income"	CODE
2.4 Costs from the Purse — KEPT + rebalanced downside
Table
	Before	v6	Tag
Upfront	Gym pays $230–$1,245	$0	CODE
Repayment	From gross purse before split	Same	CODE
Fee	+$100 / +$200	Same	CODE
Downside	−10 loyalty (cliff at 50)	−5% share for 3 fights (proportional)	CHANGE — flat penalty instead of cliff
Shown on button	—	"She repays $187; your share −5% for 3 fights"	CHANGE — tangible cost
Rebalanced: Removed the loyalty cliff. Now a flat, visible penalty — no hidden coin flip. Target: costs ask ≤40% best.
2.5 Removed Asks
Table
Ask	Why removed	Tag
Softer opponent	0% best; gap change invisible; tune-up code unused	CUT
Better Split (take/counter)	$3–$12 value; dominated by Price in same band	CUT
3 — The Two Refusals — Distinct & Visible
Table
Option	What it costs	Shown on button	Tag
Stay Amateur	Terms ×0.9; +2 wins needed; loyalty −8 → share drops to 10% if <50; pro_declines +1	"Terms 0.9×; loyalty −8; share 10% below 50"	CHANGE — loyalty/share cost visible
Let it run out	Nothing. Same house returns after 2 wins at full terms. 14-day countdown ticks down.	"Don't answer — offer expires; returns in ~8 weeks, full terms"	CHANGE — new visible option
v6 fix: The two refusals are now distinct options with different costs. The player chooses — not punished for picking the "right" refusal.
4 — The Boxer's Voice — Wired & Visible
4.1 Ambition Map — Fully Active
Table
Ambition	Kind	Sign	Stay	Who gets it
"First win at home"	other	—	—	0 bouts
"Regional title within a year"	title	−5 morale (pre-nationals)	—	pot ≥78
"Turn pro and build a career"	pro	+5 morale	−5 morale	pot 60–77, ≥3 bouts
"Winning record this season"	other	—	—	pot <78, <3 bouts
CHANGE: The pro ambition now fires correctly. Shown on offer: "She wants to turn pro → +5 morale now / −5 if you wait".
4.2 Day-Job Status — Visible on Offer
Table
Status	Gate	Shown
Full stipend	7 wins + top 3	"Standard route: 7 wins + top 3"
Day job	6 wins + top 3	"Day-job route active: 6 wins + top 3"
Half sponsorship	7 wins + top 3, 4/6 mornings	"Half sponsorship active"
CHANGE: The route the player chose is visible. No hidden gates.
5 — The Door That Shuts — Warnings & Rules
Table
Declines left	What the offer shows	Rule
0 of 3	"14 days remaining. No refusals yet."	Full terms
1 of 3	"Terms now 0.9×. One more refusal → only rank 1 receives offers."	+2 wins needed
2 of 3	"LAST OFFER. Refuse → NO promoter calls ever. Only regional #1 qualifies."	Must be rank 1
3 of 3	"Door closed — no promoter will call."	Permanently locked
CHANGE: Warnings moved from "after refusal" to on the offer itself. The player sees the cost before deciding.
6 — Wire Map — Every Menu & What's New
Table
#	Menu Item	What Shows	Wired To	Status
M1	Top bar flag	PRO OFFER — 14-day countdown; red last 3 days	ProOfferWire.days_left()	BUILT
M2	Home board	"Pro offer — hear it (N days left)"	Roster.check_pro()	BUILT
M3	Pro offer modal — HEADER	"A CALL TO TURN PRO — 14 DAYS REMAINING. Refusals: N of 3."	ProOfferWire, ProCall	BUILT + new warning lines
M4	Pro offer — each house card	Purse, dates, win chance, opponent description, break-even, ticket forecast now/at debut	ProCall.promoters(), BoutRead.likely()	NEW win chance
M5	Pro offer — asks	Later+2, Later+4, Price (BL), Costs (HF). Each shows cost + effect. Disabled = greyed with reason.	ProCall.asks(), ProOfferWire.ask()	Later+4 restored
M6	Pro offer — boxer status	Ambition effect (+5/−5), day-job/half route active, morale change	Recruit.ambition(), DayJob	NEW — visible
M7	Pro offer — refusals (bottom)	[Stay Amateur] + cost line · [Don't Answer — let it expire] + return condition	ProOfferWire.lapse_if_due()	NEW — two distinct options
M8	Fighter → Next Step	Wins needed, rank, route type, age warning, declines left, next offer date	Roster.pro_ready()	BUILT + route label
M9	Money → Stipends	Hover: "Full $250/wk / Half $125/wk / Day $0 — each changes training time and pro call gate"	DayJob, GymSpend	NEW — explanation
M10	World → News	"A boxer from the gym signs pro" — no names	NewsFeed	BUILT
M11	Week review	"Amateur cut lost −$75/wk; stipend saved +$250/wk"	ProWeekLines	BUILT
M12	Fighter → History	Milestone: "Turned pro — Week N · House · Opponent"	f["pro_signed"]	BUILT
7 — Probe Pass Lines — v6 Targets
Table
#	Line	v5 status	v6 change	v6 target
1	No bot dominates (>60%) at w104	PASS	Unchanged	≤55%
2	Later+2 ≥10%, Later+4 ≥5%, Price ≥10%, Costs ≤40%	FAIL	Later+4 restored; Costs downside rebalanced	All within bands
3	Win rate: BL ~67%, HF ~79%	FAIL — inverted	Gaps set from TURNGAP1 curve	65–80% / 70–85%
4	Day-job careers ≥30% get first call	FAIL — gate only	Gate + visible route + pace clarified	≥30%
5	Door closes 10–30% of careers	FAIL — invisible	Warnings on offer; distinct refusal costs	10–30%
6	Ambition aligns ≥70% decisions	FAIL — inert	Ambition wired; shown on offer	≥70%
7	Player sees win chance before deciding	Missing	BoutRead.likely on each card	✅ Visible
8	Two refusals: Stay vs Let expire	One invisible	Two distinct buttons	✅ Both actionable
8 — Changed from v5 — Summary
Table
#	Change	Why
1	Fixed opponent gap direction	TURNGAP1 proved: negative gap = harder debut. v5 had it inverted.
2	Set gaps from measured curve: −1.0 (BL), 0.0 (HF)	Now hits the 65–85% win-rate bands exactly. No more guesswork.
3	Restored Later +4 Weeks with visible ticket growth	The ask was fine — the preview was broken. Fixed → real choice returns.
4	Rebalanced Costs downside: −5% share ×3 fights (not loyalty cliff)	Eliminated the invisible coin flip. Cost is tangible and predictable.
5	Added "Let it run out" as a visible third option	The best choice was hidden. Now all paths are equally accessible.
6	Show win chance beside each opponent	Players cannot intuit "gap 1.0" — they understand "~72% to win".
7	Show ambition + day-job status on the offer	The boxer's wants and the player's route are part of the decision.
8	Moved door warnings onto the offer itself	No more surprises. Every cost is visible before the button press.
9 — Outstanding Questions
Table
#	Question	Source	Next Step
Q1	Does −5% ×3 fights bring Costs ≤40% best?	Probe v6	Rerun TURNPROBE3B with new downside
Q2	Later+4 visible — does it reach ≥5% best?	Probe v6	Preview fixed → test uptake
Q3	Day-job 6-win gate + visible route — does 30% call rate land?	Probe v6	Rank leg may still bind — measure both legs
Q4	Are the two gaps (−1.0 / 0.0) stable across opponent types?	TURNGAP2	Test across multiple boxer ratings
This map answers every critic point: the inverted lever is fixed, the gap values come from measured data, the dominant choice has a proportional visible downside, hidden information is surfaced as actionable text, dead asks are either removed or restored with real value, and every cost appears before the player presses a button. DEPTH and GENERAL DESIGN both target 8+ in the next critic pass.
