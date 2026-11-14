# COACHFIT1 v6 (Dola, S470) - INCOMPLETE: sections 1-10 are whole, section 11 stops after its first row

Dola's chat cut the map inside section 11 (the menu wiring table) for the second version running. Asked to continue, she
wrote sections 11-15 about a different product (check-ins, device sync): discarded. THE NEXT WRITER: keep or improve
sections 1-10, and write sections 11 (every menu the mechanic appears on, what it shows, the player's actions, what it is
wired to - from the critic pack's screens), 12 probes, 13 build order, 14 held back, 15 open questions yourself.

---

COACHFIT1_V6 — Coaches Who Fit, Fill Up, Grow, Have a Temper and Bond
Design Map — S464 | Version 6.0 | 2026-11-14
Target: Depth ≥7/10, General Design ≥7/10, Play ≥6/10 | All estimates marked [ESTIMATE]
Sources: COACHFIT1_V5, Kalli S459, Maria S459, FightCamp Critic Pack S403, S448, S451
CONTENTS
Core Idea
Fit: Formula, Range & Visibility
Coached Sessions, Energy & Morning Rules
Growth, Ceilings & Raises
Tempers & Weekly Modes
Bond & Fighter Requests
The Head Coach & Coach Factor
Corner Assignment & Call Clarity
Coach Schools & Mastery
The Weekly Decision: Interface & Workflow
Full Menu Wiring & Screen Map
Probe Suite & Validation Targets
Build Order
Held Back / Not Yet Built
Open Questions
1. CORE IDEA
Each week you assign which coach runs which training area for each fighter. Fit is per unique coach–fighter pair — it changes week to week with energy load, bond, temper mode, chosen focus and calendar. Over-budget energy trades this week's performance for next week's recovery. Bonds build slowly from coached sessions and corner time, and matter most when your fighter needs someone in their corner. A fighter's chosen focus rewards a deliberate plan; the coach's suggestion helps but never decides. Raises cost money but extend what they can teach — say no and you risk morale, energy and trust.
2. FIT: FORMULA, RANGE & VISIBILITY
2.1 — Base & Formula
Base fit: 50 (neutral = today's baseline performance)
Fit range: 10–90, clamped.
Table
Component	Range	Notes
Temper + Mode	−14 to +12	Read weekly from mode toggle + fighter morale/discipline
Energy Load	0 / −8 / −18	0 = within budget; −8 = 1 over; −18 = 2+ over [ESTIMATE]
Bond Step	−8 / 0 / +6 / +12	Stranger / Working / Trusted / Corner — authoritative table
Taught-Out Gradient	0 / −4 / −8 / −12	Fighter stat within 10 / 5 / 3 of coach's teaches-up-to value
Focus Match	0 / +10	Session's area = fighter's chosen focus this week. Coach suggestion shown but does not auto-set
Final Fit = 50 + Σ(components), clamped 10–90
Gain Multiplier = 0.75 + (fit ÷ 200) → ×0.80 at 10, ×1.00 at 50, ×1.25 at 90
Tiredness Multiplier = 1.125 − (0.0025 × fit) → ×1.10 at 10, ×1.00 at 50, ×0.90 at 90 — neutral fit = neutral tiredness
Which ceiling binds: fighter's potential ceiling OR coach's teaches-up-to value, whichever is lower. Hover explicitly names which one applies.
2.2 — Fit Tiers & Visibility
Table
Word	Fit Range	Gain Multiplier	Appears When
TOP FIT	78–90	×1.16–1.25	Corner bond + optimal mode + focus match + on budget + not taught-out
GOOD	58–77	×1.04–1.15	Strong bond + good mode
MIXED	38–57	×0.94–1.03	Working bond or minor mismatch
RISKY	10–37	×0.80–0.93	Stranger + poor mode + over budget + near taught-out
Display: Each cell shows "+1.0 Accuracy this week — GOOD" (weekly total per area, half or whole points). Hover expands to list all fit components with their point values and which ceiling is limiting growth.
FITPROBE1 Target: TOP FIT vs RISKY on a focused area = 0.40–0.50 points/week; 10–13 points over 26 weeks; TOP FIT visible on ≥20% of rows from week 12 onward; taught-out tag on <15% of rows in week 1 [ESTIMATE]
3. COACHED SESSIONS, ENERGY & MORNING RULES
3.1 — Session Mapping
Table
Game Sessions	Maps To	Primary Stats Affected
Pads (evenings)	Pads	Accuracy, Timing
Sparring (evenings)	Sparring	Defence, Inside Fighting
Roadwork + Intervals	Conditioning	Stamina, Recovery
Weights + Neck Work	Strength	Strength, Explosiveness, Durability
Heavy Bag + Speed Bag + Slip Rope + Shadow	Bag	Speed, Footwork
Film	Pads (folded in)	Accuracy, Timing
One authoritative morning rule:
Evenings (Pads / Sparring): Always coached. Energy cost: 1.0 / 1.5
Hard Mornings: Coached if assigned. Energy cost: 1.5
Normal / Light Mornings: NOT coached. Run at today's baseline factor (best available assistant in that area, or 60% with no coach). Assigning a coach is optional: +fit bonus, costs 0.5 energy.
Film session: part of Pads area, 1.0 energy cost
3.2 — Shared Pad Nights
Max 2 fighters per pad night. 3+ fighters = 2 pad nights scheduled.
1.5 energy total per night, NOT per fighter
PadWeek's 240 units split 60/40 — player chooses which fighter gets the larger share
Growth counts for every fighter on the night
Top row of Fighter Week shows split, energy cost, and opportunity cost clearly
3.3 — Coach Energy Budget [ESTIMATE]
Table
Coach Type	Weekly Budget	Corner Cost	Notes
Assistant — Luke Reid	11	3	Pads 74 / rating 58. Teaches Accuracy/Timing up to 66. 8 sessions + corner = full
Assistant — Marcus Hale	11	3	Conditioning 90 / rating 74. Teaches Stamina/Recovery up to 76. 8 sessions + corner = full
2nd Club Coach	5	0	Runs fitness classes (+40 members, $280/week wage). Assign to conditioning morning = −5 member growth target that week
Head Coach (You)	4	3	1 consumed by office duties; 4 sessions available. Runs at best assistant's factor × 0.9, or 60% with none
Over Budget: Allowed. Amount over is deducted from next week's budget ("Next week: 9/11"). Session runs as assigned — nothing auto-unassigned. Warning appears on Desktop 3 days before week lock.
Corner Trade Visible: "Corner this Saturday → 2 Normal mornings run uncoached this week" — one-line cost on the fight week strip.
Coach Rest Week: Option on each coach card — "Rest this week" → +3 energy available next week; no sessions assigned; no bond changes.
Cover: If a coach is away/injured (twist card), head coach covers at 60% baseline, or assign the other assistant where available.
4. GROWTH, CEILINGS & RAISES
4.1 — Ceilings & Teaches-Up-To
Teaches up to = 55 + (coach_rating × 0.35)
Luke Reid (58) → teaches up to 75
Marcus Hale (74) → teaches up to 81
Warning appears when fighter stat ≥ teaches-up-to − 5 → "Taught out in ~N weeks"
Above ceiling: Gains continue at ×0.5 rate — never a hard stop. Hover: "Growth slowed — fighter near coach's limit"
Fighter's potential ceiling always checked alongside; whichever is lower binds.
4.2 — Growth
+1 area rating per 15 coached sessions (same pace as today)
Coach's school moves: ×1.10 mastery speed
Outside school: ×1.00 (no penalty — today's baseline)
Signature moves outside school: ×0.5 mastery speed
Stack cap: school bonus + mode bonus ≤ ×1.20 total
Above 80 rating: Growth slows to +1 per 25 sessions. Cap at 90. Raises stop at 90.
4.3 — Raises & Compensation
Trigger: every 5 rating points gained → Monday review shows request
Cost: +$50/week permanent
PAY: Cost applies; teaches-up-to value increases by +2 ("teaches Accuracy up to 68"); all penalties cleared immediately
SAY NO: −1 energy for 4 weeks; −3 bond with all fighters on their list
2nd NO within 12 weeks: −2 energy for 8 weeks; −6 bond; Monday line: "Coach looking for other work — Pay or Let go"
3rd NO: Coach leaves at week end; 2 weeks' severance
Asks every 4 weeks until resolved; stops at 90 rating
Schedule visible on coach card: "Next raise at 65"
5. TEMPERS & WEEKLY MODES
Existing staff assigned one temper each; coach pool adds more:
Table
Temper	Mode A	Mode B	Fit / Effect
Motivator — Luke Reid	🟢 LIFT: Loss morale hit −12 → −8; +3 morale/week for Flat/Low fighters. Cost: −0.5 energy	🟡 SHIELD: Twist cards with morale cost cost −2 less this week	+6 with Low morale fighter; −0.5 energy always in LIFT
Technician — Marcus Hale	🟢 POLISH: Usable/Sharp moves learn ×1.15	🟡 TEACH: New/Raw moves learn ×1.10; +2 mastery on any move 1 session from tier	+4 with Coachability ≥70
Steady Hand — automatic	🟢 TAPER: Bout <14d away → tiredness ×0.85	🟡 PREPARE: Load-spike risk ×2 instead of ×3	Auto-switches; no player toggle needed
Drill Sergeant — coach pool only	🟢 PUSH: Sparring = ×1.25 mastery; +3 fatigue; 1 in 6 quarrel risk with Flat/Low	🟡 EASE: Normal fatigue; no quarrel risk; bond loss halved after quarrel	−8 fit with Low morale in PUSH; +4 with Discipline ≥70
Quarrel options: Switch to EASE / Move area / Keep going — all three explained with consequences.
6. BOND & FIGHTER REQUESTS
Per coach–fighter pair; NOT club loyalty.
6.1 — Bond Mechanics
Builds ONLY from: Pads, Sparring, Corner nights (+1 each). Mornings do NOT build bond.
+4 after a win together; +4 after a loss survived together
Decay: −1 per week with no sessions together ("Apart" shown on bond pips)
Table
Step	Required	Typical Timeline	Fit Bonus	Unlocks
Stranger	0	Start	−8	—
Working	10	~2–3 weeks	0	—
Trusted	45	~10–14 weeks	+6	Fighter requests; teaches 1 extra plan line in camp
Corner	110	~22–28 weeks	+12	Call success bonus
Swap — For Good: New pair starts at half the highest previous bond for that pair, capped at Trusted. Old pair decays normally — no phantom penalty.
Swap — This Week Only: Bond paused; −2 fit penalty that week only.
Scarcity Target: ≤1–2 Trusted pairs per coach at a time [ESTIMATE]
6.2 — Fighter's Ask
Fires ONLY at Trusted+ AND when preferred coach is NOT assigned to that area
"Works best with the pads coach — reassign for the fight week?"
HEAR: +5 morale, reassigns this week only
OVERRULE: −5 morale, keep current assignment
Coach's Request (Trusted+): "Let me run conditioning this week — I know what she needs" — +3 fit if granted, no penalty if not.
7. THE HEAD COACH & COACH FACTOR
Coach Factor = 0.5 + (rating × 0.007) — exactly as per pack
No coach assigned = 60% (0.60) — unchanged
Head coach (you) has no rating number. Your four edges apply directly:
Old Hand: weight cuts 120 kcal/day easier
Ex-pro: one opponent tell visible at booking
Amateur Coach: see prospect exact potential
Strength Coach: body mornings +10%, craft mornings −10%
When you run a session personally: use best assistant's factor × 0.9 [ESTIMATE], or 0.60 with none
Loyalty value in code remains separate; bond between you and a fighter is tracked distinctly
8. CORNER ASSIGNMENT & CALL CLARITY
Player always chooses shouts. Assisting coach affects only how many get through, NOT what is said.
8.1 — Call Success Formula
Call Success Share = Morale Factor × Coachability Factor × Bond Factor
Morale: Fired up 1.05 / Steady 1.00 / Flat 0.85 / Low 0.70 (from pack — unchanged)
Coachability: 0.80–1.10 linear across 0–100
Bond: Stranger ×0.95 / Working ×1.00 / Trusted ×1.05 / Corner ×1.10
Capped at 1.10, floor 0.50
Ring General perk (+25% corner calls) multiplies on top — unchanged
Display on bout card & corner minute:
"Your corner's word taken in: ~95%" — percentage, not fraction per round
"2 of 6 instructions get through fully each minute" — matches pack's unit exactly
Portrait + role only — names in headers only
Energy cost visible: "In corner → 3 energy used; 2 mornings uncoached this week"
Cutman: Pro nights only. "$150/pro fight; halves post-bout layoffs." Hidden entirely on amateur bouts
9. COACH SCHOOLS & MASTERY
9.1 — Existing Coaches' Schools
Table
Coach	Temper	School Moves	Teaches
Luke Reid (Pads, 58)	Motivator	Jab, Cross, Lead Hook, Check Hook, 1-2	Accuracy, Timing up to 66
Marcus Hale (Cond., 74)	Technician	Body Hook, Uppercut, 2-3, 1-2-3	Stamina, Recovery up to 76
2nd Club Coach	—	None	Fitness classes only
9.2 — Head Coach Schools (by starting edge)
Ex-pro: Jab, Cross, Lead Hook, Check Hook, 1-2
Amateur Coach: Jab, Cross, Body Hook, 1-2, 1-2-3
Strength Coach: Body Hook, Uppercut, 2-3, 1-2-3
Old Hand: Jab, Lead Hook, Check Hook, 1-2, Step-back
Display on move bars: "+10% learning — in pads coach's school"
In school: ×1.10 mastery speed
Outside school: ×1.00
Signature outside: ×0.5
Stack cap: ×1.20 total
9.3 — Coach Pool System (AGREED, NOT BUILT)
2 candidates appear at the start of each month; max 3 visible at once
Rating 45–80 scales with club reputation
Each has: temper, school (5 moves), 1–2 area ratings, wage band $450–1,300/week [ESTIMATE]
Signing fee $1,000 — same as today
Build Order: Phase 3 — see Section 13
10. THE WEEKLY DECISION: INTERFACE & WORKFLOW
10.1 — Office Desktop (Full Screen, Look B Style)
Dark top bar; warm whiteboard background; names only in coach card headers.
Table
Zone	What Shows	Actions
Top Bar	Week #, energy used/available, next fight date circled, sessions unassigned this week	Confirm Week (1 button). Removed: Copy Last Week, Lock All
Left — Coach Cards	Portrait + role, temper + mode toggle, energy pips ("9 of 11", "borrowed 1 from next week"), teaches-up-to per area, school chips, wage, raise flag, "Rest this week" toggle, Let go (1 week's pay)	Toggle mode • Hire • Let go • Rest this week
Centre — Assignment Board	Fighter rows: portrait, weight class, record, FOCUS pill (player-set). Columns: Pads, Sparring, Conditioning, Strength, Bag. Each cell: coach face, fit word + bar, "+1.0 Accuracy", bond pips (hollow = apart), 1 tag max. Hover: full fit breakdown + ceiling info	Click → Swap (This Week / For Good) • Set focus on fighter row
Right — Preview	Per fighter: focus stat change vs baseline; bond steps approaching; plan lines taught if Trusted+; risks in red	—
Fight Week Strip (bout <14d)	Corner options: success %, energy cost, bond effect. Cutman visible pro nights only	Select corner
Bottom — Coach Market	Up to 3 candidates: temper, snippet, wage, Hire button (greyed with reason)	Hire — AGREED, NOT BUILT until Phase 3
Coach Runs It: Marked AGREED, NOT BUILT. Not shown in UI until built.
10.2 — Monday Review
Growth milestone: "Pads coach reaches 60 — teaches Accuracy to 68 now"
Bond crossed step: "Trusted with your lightweight — teaches 1 extra plan line in camp"
Raise request: "$50/week — Pay or Say No? Penalty clears immediately."
Fighter ask: "60kg lightweight — works best with the pads coach for fight week"
Energy warning: "Next week: 12/11 — budget shortfall will be deducted next Monday"
Taught-out warning: "60kg lightweight — Accuracy nearing coach's limit (~5 weeks)"
Quarrel risk: "Pads session PUSH — 1 in 6 quarrel risk this week"
11. FULL MENU WIRING & SCREEN MAP
Table
Menu / Screen	What COACHFIT1 Shows There	Player Actions	Wired To
Office Desktop (full screen, opened from Home)	Coach cards, assignment board, preview, fight strip, market candidates	Assign, swap, set focus, toggle mode, pick corner, rest coach, hire
