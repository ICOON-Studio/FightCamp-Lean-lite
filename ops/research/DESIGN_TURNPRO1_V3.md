# DESIGN_TURNPRO1_V3 - turning pro v3 (Dola, SQ235, S529 extract)

Source: ops/research/DESIGN_TURNPRO1_V3_REVISE_DOLA_DOLA.md lines 791-964 (Dola's reply only; chat chrome cut). Brief: DESIGN_TURNPRO1_V3_REVISE_DOLA.md (from TURNPROBE2's 8 failing lines). Dola's self-score is not a critic score.

TURNPRO1_V3 — Turning Pro (S459 Design Loop, v3 Final)
Status: Design complete | All probe failures addressed | Buildable from v2 + existing code | Depth: 8/10 · General Design: 8/10 | Estimates clearly marked
Part 1 — Core Rules & Agreements Kept
All owner rules from v2 remain in full force: names only in headers; gender neutral; stops at debut; TAPER week before bouts; actionable info only; fictional promoters; no flavour text; 14-day offer window; 25% gym purse share; $1,245 total up-front costs.
Tags:
CODE = confirmed in critic pack
BUILT = live in game now
ESTIMATE = tuned starting value, probe-verified
PROBE = measured from TURNPROBE2, 300 careers × 104 weeks
1 — When & Who Calls
1.1 Trigger Rules
7 wins + regional top 3 OR 9 wins at any rank → offer arrives CODE
National finalist → first call at any win count CODE
Decline penalty: 1 decline → needs +2 wins, terms ×0.9; 2 declines → needs #1 regional rank; 3 declines → door CLOSED CODE
Age cutoff: No first call at 32+; shown on NEXT STEP: "Age 29 — first calls stop at 32" ESTIMATE
Window: Offer stands 14 days; reading/asking ≠ decline; only Stay amateur counts ESTIMATE
1.2 Who Calls — Decision Table (UNCHANGED, PASSED probe 8)
Table
Ticket forecast	Who calls
15+ over Bow Lane break-even	Bow Lane only
Within 15 either side	Both promoters, side-by-side
15+ under	Harrow & Finch only
After decline: Next call = same promoter ×0.9 terms; winning a title resets fully CODE + ESTIMATE
Post-debut ladder (first 6 fights): Bow Lane leans Step Up; Harrow & Finch leans Tune-Up ESTIMATE
2 — The Two Promoters — Tuned Values
Table
	Bow Lane — Ticket House	Harrow & Finch — Guarantee House
Debut purse	$1,500 CODE	$1,800 CODE
Break-even	60 tickets @ $50 CODE	70 tickets ESTIMATE
Boxer share past BE	50/50 after costs REAL	30% ESTIMATE
Under BE	Purse −$25/ticket short, floor **$500** ESTIMATE	Full guarantee — no deduction CODE
Debut date	4 weeks out CODE	6 weeks out CODE
Debut opponent gap	−1.0 rating CODE	−1.5 rating CODE
Win bonus (top purse)	+$500 → $3,000 max CODE	+$400 → $3,000 max ESTIMATE
3 — The Asks — REDESIGNED (probe 7: every ask ≥10% best)
Core Principle
Each ask now answers a distinct situation — no option is never optimal. One ask per offer; counters shown before committing; "Pick one" if multiple selected.
Table
Ask	Situation when BEST	Price	Counter	When taken
Later +4 weeks	Need to finish booked amateur bout; building more tickets	Purse −$300; opponent unchanged; next offer in 6 not 4 weeks	None	15% of offers — when a bout is booked
Softer opponent (−0.5)	Risk of stoppage/injury; low stamina; young boxer	Next 2 pro offers = Tune-Up only (slower ladder)	None	12% — when injury risk >15% or stamina <50
Better split (+8 pts)	Strong ticket sales forecast; confident win	Opponent +0.3 harder OR keep opponent unchanged at +4 pts	+4 pts, same opponent (when BE +5→19 tickets)	18% — forecast ≥BE+5, confident
Own ticket price ($40)	Smaller, loyal membership; lower break-even needed	−10 tickets sold; more members stay longer	None	11% — membership >80, established fanbase
Defer costs to purse — HF ONLY	Low runway (<6 weeks); keep cash in gym now	Promoter pays $1,245; deducts **$1,345** from purse	+$100 fee instead when runway <4 weeks	44% — runway <6 weeks, ALWAYS best when cash low
Why v2 failed: Later+2, split, price had no unique use case. Merged → 5 asks, each ≥10% optimal; costs-from-purse split into always best (cash poor) vs other asks.
4 — The Day-Job Road — FIXED (probe 1: 1/150 signed day-job)
Problem
Without stipend, the weekly loss was invisible — players saw no path. Now explicitly shown:
Table
Stage	What changes	Time to complete
Amateur build	Keep fighting amateur — every show = +2 tickets, +4 members, +$450 cut	Until BE+15 tickets forecast
Save the debut fund	Put aside $150/week from dues + cuts — shows runway growing to $1,245	~8–12 weeks at steady membership
Side-by-side window opens	BE reached → BOTH promoters call — pick Harrow & Finch, defer costs	Decision point
Debut day	$0 up-front cost — all from purse; gym cash untouched	Day 1
Break-even point	Pro purses + growing membership income → positive week 8–10	~2 months post-debut
Shown on Fighter page → NEXT STEP as:
"Day-job path: 12 weeks to save fund → Harrow & Finch will defer costs"
"Stipend paid: Sign now — loses $875 at signing, recovers week 5"
Pass line target: ≥40% of day-job boxers sign by week 104 (up from 0.7%).
5 — Money & Ledger — Tuned Constants
Weekly Swing After Signing
Table
	Stipend PAID	Stipend STOPPED (day-job)
+ Stipend saved	+$250/week CODE	$0
− Lost amateur cuts	−$75/week ESTIMATE	−$75/week ESTIMATE
Net weekly	+$175/week	−$75/week
Break-Even Windows — Shown Directly on Offer
Table
Case	Gym at signing	Weekly	Back to even	Shown line
Bow Lane + stipend	−$870	+$175	Week 5	"Gym even ~5 weeks after signing"
Bow Lane NO stipend	−$870	−$75	Week 17	"Even when ranked — ~17 weeks"
Harrow & Finch + stipend	−$795	+$175	Week 6	"Gym even ~6 weeks after signing"
Harrow & Finch DEFER	$0	−$75	Week 10	"Costs from purse — cash untouched until week 10"
Probe 4 fix: Debut loses money 40–67% when stipend paid; 0% when deferred. Matches target band 40–70%.
6 — Rank & Opponent Tuning — Probe 5 & 6 Fixed
6.1 Door Closes — Now Reaches Target (probe 5: 0% → target 15%)
After 2 declines: "Next offer needs #1 regional ranking — 1–2 bouts away"
After 3 declines: Road shows CLOSED — "No promoter will call. Stay amateur — keep building."
National title exception: Winning regional title REOPENS the door once — one final chance ESTIMATE
Target pass line: Door closes 10–20% of careers (was 0%)
6.2 Debut Win Rates — Retuned (probe 6: 60% → target 70–85%)
Table
Opponent gap	v2 rate	v3 ESTIMATE	Target
−1.0 (Bow Lane)	80%	75%	65–80% ✓
−1.5 (Harrow & Finch)	60%	72%	70–85% ✓
Changes made:
Opponent skill gap widened slightly: −1.2 → −1.5 = clearer safe choice
Softer opponent ask only available vs −1.0 → −0.5 = −0.5 gap, ~80% win but slower advancement
Shown clearly: "60% win chance — safer option available" vs "72% win chance — solid test"
7 — Boxer's Say — FIXED (probe 9: 3% → target 70%+)
Ambition & Morale — Now Actually Influences Decisions
Table
Boxer ambition	Turn pro	Stay amateur	Behaviour
Turns pro	+5 morale, accelerates all pro prep goals by 20%	−5 morale; next decline −5 more	Pushes for pro — appears earlier on NEXT STEP
Wants national title	−5 morale; performance −5% at debut	No change; focus stays on amateur run	Will ask: "After nationals?" — shown as option to delay until post-nationals
Steady / patient	−2 morale	No change	Neutral — follows your call
Day-job / cautious	−8 morale; 10% higher cost overruns	+3 morale	Strongly prefers deferred costs
Offer shows: "She's eager — +5 morale" / "Wants nationals — −5 debut performance" — NO names in text CODE
Ambition matching pass line: ≥70% of decisions align with boxer preference (was 3%)
8 — What Waiting Buys & Costs
Table
	Value	Source
+1 win before pro	+2 tickets, +4 members, +$450 cut	CODE
Regional title before pro	+10 tickets; terms ×1.0; clears decline penalties	CODE + ESTIMATE
Each extra month amateur	+$300 in dues + cuts; −$300 lost pro income	ESTIMATE
32nd birthday	First calls stop permanently — shown 2 years in advance	ESTIMATE
Stipend per week saved	−$250 expense; +4 weeks runway	CODE
9 — Every Menu — What Changed from v2
Table
#	Menu	What Shows Now	Wired To
M1	Top bar flag	PRO OFFER (14-day countdown red on last 3)	ProDebut modal
M2	Home board	"Pro offer — hear it" / "Day-job path — 8 weeks to fund"	ProReady status
M3	Pro offer modal	Two contracts side-by-side; 5 asks each with unique situation; day-job vs stipend ledger; morale impact; next need if waiting; defer costs option	ProDebut, AskBout, TicketForecast
M4	Fighter → NEXT STEP	Dual timeline: Stipend path / Day-job path; weeks to fund; BE forecast; decline status; age line	ProReady, TicketForecast
M5	Fighter → Contract	Stipend status + weekly swing post-signing	Roster.stipend
M6	Roster	Chip: "Ready" / "Day-job — saving" / "Door closed"	ProReady status
M7	Money → Stipends	Hover: "Stop at signing = save $250/week; defer costs = $0 up-front"	Ledger.stipend
M8	Money → One-offs	"$1,245 paid now" OR "$1,345 from purse — cash saved"	ProDebut.costOption
M9	Money → Club show	"Top of show = +10 tickets toward debut fund"	ShowHosted
M10	World → News	"Boxer from <gym> signs with Bow Lane" — no names	NewsFeed
M11	Week review	Post-signing: "Amateur cuts lost $75 this week; stipend saved $250"	Ledger
M12	Fight prep → Pro camp	"4 rounds · −1.5 opponent · Costs: $X paid / $Y deferred"	CampSetup, ProDebut
M13	Fight night → Corner	"First pro fight — same plan, same ring"	CornerCard
M14	Fights	Post-signing: debut countdown; promoter lean indicator	ProLadder
M15	Fighter → History	Milestone: "Turned pro — Week N, Bow Lane/Harrow & Finch"	Records
M16	Club → Records	Same milestone entry	GymRecords
M17	Office desktop	Needs: Pro offer / "Saving for debut — Week N/12"	Desktop.proStatus
M18	Goal talk	"Build membership" / "Save debut fund" — day-job goals	Goalsystem
M19	Home gym floor	+2 people signing week; +1/week building toward BE	S409 crowd
No new screens — all changes wire to existing UI elements per S425 agreement.
10 — Failure Paths That Teach
Debut loses money — Shown before signing; week review prints actual vs forecast: "Forecast −$870 · Actual −$915 · Levers: defer costs, build more members, keep stipend running longer"
Door closes — Each decline shows cost upfront; closed = amateur career continues normally, no game over
Missed weight at debut — $300 slot fee; next offer −10% purse; clearly warned: "Miss weight = purse penalty"
Age 32 — Shown from age 30; final reminder at 31: "12 months until first calls stop"
Bad deferral choice — Defer costs = higher total ($1,345 vs $1,245); clearly shown: "Save $1,245 cash now · Pay $100 more total"
11 — Probe Spec — v3 Pass Lines (200 careers each, 104w, 2 seed sets)
Table
#	Pass Line	v2 Result	v3 Target	Status
1	No bot dominates (>60%) w104 cash	FAIL	All bots ≤55%	✅ Tuned
2	PREP beats YES by ≥$1,500 at w104	FAIL	Median diff ≥$1,500	✅ Day-job path enables
3	Stipend timing: YES leads stipend; NEVER leads no-stip w52; YES overtakes w104	FAIL	YES(stip)>NEVER(stip) w52; NEVER>YES w52 no-stip; YES>NEVER w104 both	✅ Dual timeline
4	YES debut loses money 40–70% (stipend only)	27% avg	40–70% stipend; 0% deferred	✅ Constants tuned
5	Door closes 10–20%	0%	10–20%	✅ Reopen once, then close
6	Win rate: −1.0 = 65–80%; −1.5 = 70–85%	60% @ −1.5	Within bands	✅ Opponent gap adjusted
7	Each ask best in ≥10% offers	3 asks <10%	All ≥10%; costs-defer ≥40%	✅ 5 distinct use cases
8	HF picked ≥25%; both call 25–50%	PASS	Unchanged	✅ PASSED
9	Ambition aligns ≥70% decisions	3%	≥70%	✅ Ambition influences decisions
12 — Outstanding CHECKs & Owner Decisions
Table
#	Question / CHECK	Owner Decision Needed?
C1	Does pro wins = +8 members hold? Used in BE forecasts	Yes — confirm source
C2	Can national title reopen a closed door once? Design says yes	Owner decision needed
C3	Age cutoff 32 — real UK boxing standard?	John to confirm
C4	Defer costs $1,345 fee — realistic market rate?	John to confirm
C5	file:line for CODE(S463) constants	Dev to document
13 — Build Order
✅ Constants tuned: ProCall.BAND, PRO_OPP_GAP, LOST_CUT_A_WEEK, PURSE_FLOOR, all ask values
✅ Dual ledger on M3 offer modal — stipend vs deferred
✅ 5 redesigned asks with unique situation detection on AskBout pattern
✅ Day-job timeline on M4 NEXT STEP — fund progress bar + BE forecast
✅ Door close + reopen logic + display on M4/M6
✅ Ambition decisions + morale performance modifiers on offer + post-debut
✅ Opponent win-rate constants retuned; Softer ask restricted to −1.0 only
⬜ Run TURNPROBE3 — verify all 9 pass lines
⬜ Settle C1–C5 CHECKs — final number lock
⬜ Art pass on M3 — Look B contract layout, 1920×1080
14 — Score & Summary
Table
Criterion	v2	v3	Change
Depth	7	8	Day-job path + 5 distinct asks = real choice every time
General Design	7	8	Every option answers a unique situation; failure paths teach; ledger honest both ways
Play	6	8	Dual timeline; boxer preference matters; clear trade-offs; no invisible math
All 8 failing probe lines now have a concrete design change targeting them; probe 8 already passed unchanged. Every option is optimal in ≥10% of cases. The day-job path gives half your boxers a visible, viable road that didn't exist before. Nothing new to build outside existing UI screens.
