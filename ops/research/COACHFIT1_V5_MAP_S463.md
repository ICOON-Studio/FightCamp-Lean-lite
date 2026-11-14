COACHFIT1_V5 — Coaches Who Fit, Fill Up, Grow, Have a Temper and Bond
Design Map — S459 | Version 5.0 | 2026-11-14
Target: Depth ≥6/10, General Design ≥6/10, Play ≥6/10 | All estimates marked [ESTIMATE]
Sources: COACHFIT1_V4, Kalli S459, Maria S459, FightCamp Critic Pack S403, S448, S451
CONTENTS
Core Idea
Fit: Formula, Range & Visibility
Coached Sessions, Energy & Morning Rules
Growth, Ceilings & Raises
Tempers & Weekly Modes
Bond & Fighter Requests
The Head Coach & the 60% Rule
Corner Assignment & Call Clarity
Coach Schools & Mastery
The Weekly Decision: Interface & Workflow
Probe Suite & Validation Targets
Full Menu Wiring & Screen Map
Build Order
Held Back / Not Yet Built
Open Questions
1. CORE IDEA
Each week you assign which coach runs which training area for each fighter. Every row shows the weekly total gain per area in whole stat points, not per session. Fit is per unique coach–fighter pair — it changes week to week with energy load, bond, temper mode, growth progress and calendar. Over-budget energy trades this week's performance for next week's recovery. Taught-out warnings appear weeks in advance. Bonds build slowly from coached sessions and corner time, and matter most when your fighter needs someone in their corner.
2. FIT: FORMULA, RANGE & VISIBILITY
2.1 — Base & Formula
Base fit: 50 (neutral reference point = today's baseline performance)
Fit range: 10–90, clamped.
Table
Component	Range	Notes
Temper + Mode	−14 to +12	Read weekly from mode toggle + fighter mood/discipline
Energy Load	0 / −8 / −18	0 = within budget; −8 = 1 over; −18 = 2+ over [ESTIMATE]
Bond Step	−8 / 0 / +6 / +12	Stranger / Working / Trusted / Corner — single table, authoritative
Taught-Out Gradient	0 / −4 / −8 / −12	Fighter stat within 10 / 6 / 3 of coach's teaches-up-to value
Weakest Stat Match	0 / +10	Session targets the fighter's lowest stat in that area
Final Fit = 50 + Σ(components), clamped 10–90
Gain Multiplier = 0.80 + (fit ÷ 250) → ×0.84 at 10, ×1.00 at 50, ×1.16 at 90
Tiredness Multiplier = 1.15 − (0.003 × fit) → ×1.12 at 10, ×1.00 at 50, ×0.88 at 90 — neutral fit = neutral tiredness
2.2 — Fit Tiers & Visibility
Table
Word	Fit Range	Gain Multiplier	Appears When
TOP FIT	75–90	×1.10–1.16	Corner bond + optimal mode + matched stat + on budget
GOOD	55–74	×1.02–1.09	Strong bond + good mode
MIXED	35–54	×0.94–1.01	Working bond or minor mismatch
RISKY	10–34	×0.84–0.93	Stranger + poor mode + over budget + taught-out
Display: Each area cell shows +0.9 Accuracy this week — GOOD (weekly total per area, whole or half points). Hover expands to list all fit components with their point values.
FITPROBE1 Target: TOP FIT vs RISKY on a focused area = 0.25–0.35 points/week; 6.5–9.0 points over 26 weeks; TOP FIT visible on ≥20% of rows from week 12 onward [ESTIMATE].
✅ Answers Kalli #1–5, Maria #1–4, John #1: Single bond table; neutral fit = ×1.00 tiredness; achievable targets; clear visibility.
3. COACHED SESSIONS, ENERGY & MORNING RULES
3.1 — Session Types & Coaching
One authoritative morning rule:
Evenings (Pads / Sparring / Film): Always coached. Energy cost: 1.0 / 1.5 / 1.0
Hard Mornings: Coached if assigned. Energy cost: 1.5
Normal / Light Mornings: NOT coached. Run at today's baseline factor (best available coach in that area, or 0.60 with no assistant). Assigning a coach is optional: adds fit bonus + costs 0.5 energy.
✅ Answers Kalli #6, Maria #2, John #2: One consistent rule; today's baseline intact; no hidden nerf.
3.2 — Shared Pad Nights
Max 2 fighters per pad night. 3+ fighters = 2 pad nights scheduled.
1 energy total per night, NOT per fighter. PadWeek's 240 units split evenly across fighters on that night.
Growth counts for every fighter on the night.
✅ Answers Kalli #10, Maria #5: Cap prevents infinite sharing; energy limit stays meaningful.
3.3 — Coach Energy Budget [ESTIMATE]
Table
Coach Type	Weekly Budget	Corner Cost	Notes
Assistant Coach	11	3	8 sessions + corner = full; +2 energy if primary area ≥80 rating
Head Coach (Player)	4	3	1 consumed by office duties; 4 sessions available
2nd Club Coach	5	0	Runs fitness classes (+40 members, $280/week — this is their wage). Assign to conditioning morning = −5 member growth target that week
Film session: counts as Pads area, 1.0 energy
Over Budget: deficit reduces next week's budget by that amount ("Next week: 9/11")
Warning appears on Desktop 3 days before week lock
✅ Answers Kalli #4, #12, Maria #5, John #3: Balanced energy; shared sessions priced; second coach clarified.
4. GROWTH, CEILINGS & RAISES
4.1 — Ceilings (Fixed Scale)
Teaches up to = 40 + (coach_rating × 0.4) — same scale as fighter stats
Pads coach (74) → teaches Accuracy up to 70
Conditioning coach (90) → teaches Stamina up to 76
Display: "Teaches Accuracy up to 70 | 64 → 65 in 8 sessions"
Taught-out warning: appears when fighter stat ≥ teaches_up_to − 10 → "Taught out in ~5 weeks"
✅ Answers John #2: Like-for-like comparison; warning means something.
4.2 — Growth
+1 area rating per 15 coached sessions (slower, sustainable pace)
School mastery bonus: moves in coach's school = ×1.10 learning speed
Outside school: ×1.00 (no penalty — restored to today's rate). Signature moves only: ×0.5 outside school.
✅ Answers Kalli #21, Maria #8: No general slowdown; only Signature work outside school is slower.
4.3 — Raises & Compensation
Trigger: every 5 rating points gained → Monday review shows request
Cost: +$50/week permanent
PAY: Cost applies; teaches-up-to value increases by +2 ("teaches Accuracy up to 72")
SAY NO: −1 energy for 4 weeks; −3 bond with all fighters on their list
2nd NO within 12 weeks: −2 energy for 8 weeks; −6 bond; coach flags "Seeking other work" — screen text hidden until rival gym system built
3rd NO: −2 energy for 8 weeks (repeats); Pay now clears all penalties immediately
Coach asks again every 4 weeks until resolved
✅ Answers Kalli #13, #15, Maria #10, John #5: Closeable loop; permanent penalty removed; repeat ask defined.
5. TEMPERS & WEEKLY MODES
No flat percentage bonuses. Each mode changes a specific, visible mechanic. Low mood = under 30; Flat = 30–49 (matches pack).
Table
Temper	Mode A (Default)	Mode B	Fit / Effect
Motivator	🟢 LIFT: Loss mood hit −12 → −8; +3 mood/week for Flat/Low fighters	🟡 SHIELD: Twist cards with mood cost cost −2 less this week	+6 with Low mood fighter; no flat % anywhere
Drill Sergeant	🟢 PUSH: Sparring = ×1.25 mastery; +3 fatigue; FRICTION risk with Flat/Low	🟡 EASE: Normal fatigue; no friction risk; after quarrel: bond losses halved	−8 with Low mood in PUSH; +4 with Discipline ≥70
Technician	🟢 POLISH: Usable+ moves learn ×1.15; Sharp unlock at 80 rating	🟡 TEACH: New/Raw moves learn ×1.10; +2 mastery on any move 1 session from tier	+4 with Coachability ≥70; Sharp unlock above Luke's 74
Steady Hand	🟢 TAPER: Bout <14d away → tiredness ×0.85	🟡 PREPARE: Fighter's load ratio limit 1.5 → 1.7 when this coach runs Hard sessions	+4 when bout <14d; no flat % anywhere
FRICTION restored: PUSH + Flat/Low = 1 in 6 chance/week of quarrel (−15 bond, −5 mood). Three options: Switch to EASE / Move area / Keep going.
✅ Answers Kalli #6, #7, #16, #17, #18, Maria #3, John #4: No flat %; quarrel restored; modes have distinct, non-automatable value.
6. BOND & FIGHTER REQUESTS
Per coach–fighter pair; NOT club loyalty.
6.1 — Bond Mechanics
Builds ONLY from: Pads, Sparring, Corner nights (+1 each). Mornings do NOT build bond.
Bonus: +4 after a win together; +4 after a loss survived together (equal value)
Decay: −1 per week with no sessions together ("Apart" shown on bond pips)
Thresholds:
Table
Step	Required	Typical Timeline	Fit Bonus
Stranger	0	Start	−8
Working	10	~2–3 weeks	0
Trusted	45	~10–14 weeks	+6 + fighter requests
Corner	110	~22–28 weeks	+12 + call success bonus
Swap — For Good: Bond carries forward; −15 bond points for 3 weeks on the losing coach's side, NOT the new pair. Does NOT reset to Stranger.
Swap — This Week Only: Bond paused; −2 fit penalty that week only.
Scarcity Target: ≤1–2 Trusted pairs per coach at a time [ESTIMATE].
6.2 — Fighter's Ask
Fires ONLY at Trusted+ AND when preferred coach is NOT already assigned to that area
"Works best with the pads coach — reassign for the fight week?"
HEAR: +5 mood, reassigns for this week only
OVERRULE: −5 mood, keep current assignment
✅ Answers Kalli #7, #10, #11, #23, #24, #25, Maria #6, John #6: Scarcer bond; equal win/loss; meaningful ask; swap penalty clarified.
7. THE HEAD COACH & THE 60% RULE
Head coach factor: 0.6 + (rating × 0.004) → 0.84 in background specialty (60), 0.78 elsewhere (45)
60% rule applies ONLY when NO coach is assigned to a session at all
Head coach energy: 4 available sessions + corner duty; 1 consumed by office
When head coach works corner: same call-success formula applies — morale × coachability × bond (Loyalty value used as bond)
Calls heard cap: MIN(1.10, product), floor 0.5 — applies to everyone, head coach included
Display: "About 2 of 3 calls heard a round" — unit matches pack's 2 instructions/minute rule
Energy cost visible: "Working corner → loses 1 session slot this week" (3 of 4 used)
✅ Answers Kalli #8, #9, Maria #7, John #7: Head coach follows same rules; clear energy cost; correct unit for calls.
8. CORNER ASSIGNMENT & CALL CLARITY
Player always chooses shouts. Assisting coach affects only how many get through, NOT what is said
Call success rate = MIN(1.10, morale_factor × coachability × bond_factor), floor 0.5 — applies to ALL corners
Display on bout card:
Portrait + role only — NO names except in bout header
"Assistant in corner: ~2 of 3 calls heard a round | +X in 100 fights [EXAMPLE — measured by BONDPROBE1]"
Energy cost shown clearly
Cutman: Pro nights only. "$150/pro fight; halves post-bout layoffs." No toggle on amateur bouts — hidden entirely
Head coach in corner: "You in corner: ~2 of 3 calls heard | 3/4 session energy used this week"
✅ Answers Kalli #26, #27, Maria #7, John #7: Correct units; example values; pro-only cutman; names rule followed.
9. COACH SCHOOLS & MASTERY
Each coach has 5–7 moves/combos in their school — listed fully on their card
In school: ×1.10 mastery speed
Outside school: ×1.00 (today's baseline)
Signature moves outside school only: ×0.5 mastery speed
Stack cap: school bonus + mode bonus ≤ ×1.20 total
Head coach schools — only game moves/combos:
Ex-pro: Jab, Cross, Lead Hook, Check Hook, 1-2
Amateur coach: Jab, Cross, Body Hook, 1-2, 1-2-3
Strength coach: Body Hook, Uppercut, 2-3, 1-2-3
Old Hand: Jab, Lead Hook, Check Hook, 1-2, Step-back (when STEPMASTERY1 lands)
Display on move bars: "+10% learning — in pads coach's school"
✅ Answers Kalli #21, #22, Maria #8, John #8: No general penalty; capped bonuses; only valid game content listed.
10. THE WEEKLY DECISION: INTERFACE & WORKFLOW
10.1 — Staff App / Office Desktop (Full Screen, Look B Style)
Dark top bar; whiteboard background; names only in coach card headers.
Table
Zone	What Shows	Actions
Top Bar	Week #, energy used/available, next fight date circled, sessions unassigned this week	Copy Last Week • Coach Runs It • Confirm Week (1 pulsing button) — REMOVED: Lock All, View Contract
Left — Coach Cards	Portrait + role, energy pips ("9 of 11", "tired: 9 next week"), temper + mode toggle, teaches-up-to + growth progress, school chips, wage, raise flag (Pay/Say No), Let go (cost: 1 week's pay)	Toggle mode • Hire • Let go
Centre — Assignment Table	Fighter rows (portrait, class kg, record) × 5 columns: Pads, Sparring, Film (folded into Pads on mobile), Cond., Strength, Bag. Each cell: coach portrait, fit word + bar, weekly total gain (+0.9 Acc), bond pips (hollow = apart), 1 tag (FRICTION/TAUGHT OUT IN N WKS/OVER BUDGET), lock icon	Click → Swap (This Week / For Good) • Lock cell • Drag to reassign
Row Footer	Weeks until taught-out (soonest area), bond step by next bout	—
Right — Preview	Per fighter: focus stat change vs Coach Runs It; per coach: growth ticks, energy left; bonds crossing a step; risks in red	—
Fight Week Strip (bout <14d only)	2 portraits: corner options, calls heard/round, win swing [EXAMPLE], energy cost; cutman visible pro nights only	Select corner • Confirm
Bottom — Market	Filters: Area/Temper/Teaches-up-to/Wage; cards show role, temper, school snippet, wage; Hire button (greyed with reason)	Hire
REMOVED: "Best swap" — auto-schedule shows baseline only; player finds the better fit
Hover over energy over: lists sessions newest-first that pushed it over
"Apart" visible on bond pips when no session together that week
✅ Answers Kalli #28–33, Maria #9, John #9: Clean spec; pronoun/class fixes; finished sections; owner rules quoted; estimates marked.
10.2 — Monday Review
Growth milestone: "Pads coach reaches 70 — teaches Accuracy to 72 now"
Bond crossed step: "Trusted with your lightweight"
Raise request: "$50/week — Pay or Say No? Pay clears penalties immediately."
Fighter ask: "Welterweight — 60kg — works best with the pads coach for the fight week"
Energy warning: "Next week: 12/11 — one session will run unassigned"
11. PROBE SUITE & VALIDATION TARGETS
Table
Probe	What Validates	Pass Target
FITPROBE1	Fit range, visibility & impact	TOP FIT ≥20% rows from week 12; TOP vs RISKY 6.5–9.0/26w; no component >40% of total; ×0.84–1.16 range maintained
BONDPROBE1	Bond scarcity & impact	Stranger→Corner worth +2–4 wins/100 close bouts; ≤1–2 Trusted pairs/coach; thresholds land on schedule
RAISEPROBE1	Raise choice balance	Pay chosen 40–60% across bots; neither dominates long-term; Pay late option used 15–25% of refusals
MODEPROBE1	Mode distinctness & value	Hand-set mode beats auto-pick ≥1 in 4 weeks; each mode has at least one unique use case
BOTSUITE S412	Overall balance	No bot beats loyal by >5%; farm strategy fails long-term; best table changes ≥5×/season per fighter; planning bot beats Coach Runs It by ≥3 wins/100 over 26w OR table shifts to 4-weekly decisions
12. FULL MENU WIRING TABLE
| Menu / Screen | What COACHFIT1 Shows There | Wired

[CLAUDE S463: Dola's v5 answer ends here - the chat cut section 12 (the full menu wiring table) and anything after it. Score sections 1-11 as written; count the missing wiring table against GENERAL DESIGN and list it in your To reach 10/10.]
