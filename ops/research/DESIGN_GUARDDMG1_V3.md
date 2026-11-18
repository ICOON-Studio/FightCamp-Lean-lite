# GUARDDMG1 V3 - guard damage design map (Dola SQ219, from v2 + critics Dola 8/8/8, Goose 5/6/5; S516)

Source: ops/research/DESIGN_GUARDDMG1_V2_REVISE_DOLA_DOLA.md lines 895-1034 (Dola's reply; her self-scores dropped - critics score it). Verify numbers marked ESTIMATE.

GUARDDMG1_V2.1 — Damage Through the Guard (S514, 2026-11-18)
Owner's premise: "the punches and the guards need real numbers for damage and reduction, the guard should negate the punch's damage, if not some damage goes through". Every (ESTIMATE) label marks values drawn from biomechanical research, existing combat-sport systems, and critic input — not yet playtested in-game. All agreed rules from V2 are retained; changes address every critic item below.
0. What the game builds on (from the code)
A round runs as six 30-second exchanges. Each punch LANDS, is BLOCKED, or MISSES. Only landed punches score, mark body damage, take energy, and can cause stoppages.
A blocked punch currently does nothing to the defender. The existing GUARD bar shows shoulder fatigue — in V2.1 it doubles as guard capacity, with wear rate modified by shoulder endurance (not a direct subtraction).
Defence profile determines whether an incoming punch is blocked, slipped, weaved, or pulled.
Body damage bands: Fine (>55), Hurt (≤55), Critical (≤35), Doctor (≤15).
Damage values already exist per punch type. This mechanic sits on top — it does not replace or rewrite the existing damage model.
1. Core Rules
1.1 — Punch Force, Transmission & Combo Multiplier
Every punch has a base damage value. When blocked, a percentage of that force transmits through to the defender — this is real damage of the same type (head/body) and follows the same body-part thresholds.
Table
Punch type	Base damage	Transmission — fresh guard (ESTIMATE)	Guard wear per block	Body transmission adjustment
Jab	1.0	25%	1	Body punches: −5% transmission (35–40% instead of 40–55%) — ribcage absorbs force differently
Cross / Hook	2.5	42.5%	3	
Uppercut / Heavy shot	4.0	55%	5	
Combo multiplier (NEW — addresses Goose P3): Punches 1–2 in a combination: base values above. Punch 3+: ×1.5 wear, ×2.0 transmission. Resets when the opponent stops throwing for one full exchange. This makes volume combinations wear guards faster and leak more damage — pressure fighters become a genuine threat to the guard; breaking up combinations becomes critical.
Damage distribution (NEW — addresses Goose P12):
Blocked head punch → 85% head / 15% eyes
Blocked body punch → 70% targeted rib side / 30% core fatigue (energy cost)
High guard posture active → head transmission −20%, body transmission +20%
Low guard posture active → head transmission +20%, body transmission −20%
1.2 — The Guard Bar & Leak Curve
Guard = 0–100. Transmission % = base transmission × (100 ÷ current guard). No arbitrary "broken guard = 1-in-3 lands" rule — removed in V2, confirmed kept.
Table
Current guard	Multiplier	Jab transmits	Power transmits	Big shot transmits	Visual cue
100	×1.0	6.3%	18.1%	27.5%	Green — Holding well
75	×1.33	8.3%	24.0%	36.6%	—
50	×2.0	12.5%	34.0%	55.0%	Yellow — Arms tiring
25	×4.0	25.0%	68.0%	110.0% (capped at 80%)	Orange — Leaking heavily
15	×6.67	—	—	—	Red — Arms dropping
Weight-class scaling (NEW — addresses Goose P10):
Lightweight: Max guard 80, transmission ×0.9
Middleweight: Max guard 100, transmission ×1.0
Heavyweight: Max guard 120, transmission ×1.3
1.3 — Guard Wear & Recovery
Wear: Every blocked punch subtracts wear points from the guard bar. Shoulder endurance training: −2% wear rate per point above 50 (min 60% of base). Shoulder endurance is a multiplier on wear rate, NOT a direct subtraction from guard value — endurance at 50% = wear ×1.5, endurance at 75% = wear ×0.5 (addresses Goose P7).
In-round recovery (DEFINED — addresses Goose P1): +3 guard points per exchange where the opponent throws 0 punches; +1–2 points when they throw 1–2 punches. 0 recovery while actively blocking. Rewards creating space and breaking rhythm.
Corner minute recovery:
Table
Source	Guard recovery	Notes
Base recovery	+15	Capped at max for weight class
"Hands up" call	+5 additional	
Good cutman	+5 additional	Only when no active cut to treat
Clinch recovery (NEW)	+10	Once per round; costs position
Amateur/Pro scaling clarified (addresses Dola P5, Goose P8):
Amateur bouts: Max guard = 80, wear +20% faster, in-round recovery +33% faster (+4 pts/quiet exchange). Recovery is faster but guard is lower and degrades quicker — close rounds are decided by accumulated leakage, not total breakdown.
Pro bouts: Full weight-class max guard, normal wear/recovery. Guard breakdown becomes a defining strategic factor in longer bouts.
Camp screen permanent note: "Amateur bouts: guard max 80, wears 20% faster — don't carry tired arms into round 3."
1.4 — Defensive Paths & Posture — Expanded
Three core styles + three guard postures (NEW — addresses Goose P6):
Table
Defence Style	What it costs	What you gain	When costly	When it shines
Cover Up	Guard wears per block; transmission grows; effective-strike credit to opponent	No stat check; legs/energy preserved; predictable intake	Below ~40 guard → leakage accelerates	Late round; hurt; legs empty; vs light hitters
Move / Slip	Stamina cost per exchange; success falls as stamina drops (50% at <40% stam)	0% transmission on clean miss; opponent wastes energy	Fresh legs needed; readable opponent rhythm	Mid-round; vs wild/swing-heavy opponents
Parry / Redirect	Higher failure vs power punches; Defence ≥50 unlock	Minimal wear (0.3 pts/block); 8% transmission; counter opportunity	Defence <55 unreliable; fails vs combos	Mid-range; counter-punching plan
Guard Posture (set in Fight Plan, per round group):
Table
Posture	Effect	Best used
High Guard	Head transmission −20%, body +20%; guard wear +10%	Opponent head-focused
Neutral	No modifier	Default
Low Guard	Head transmission +20%, body −20%; counter speed +10%	Opponent body-focused; counter-punching
Peek-a-Boo	Balanced head/body; slip chance +12%; guard wear +15%	Aggressive opponent; reactive counter
Parry success refined (addresses Dola P3): Base rates, shifted ±15% across Defence skill 30–70: Jab 70%, Cross 55%, Hook 40%, Uppercut 35%. Documented in Handbook.
Judge scoring clarified (resolves V1 contradiction — addresses Goose P5): Every 3 punches blocked = +1 effective strike credited to opponent — for scoring ONLY. Blocked punches never count as landed for damage, knockdowns, or hurt moments. Leak damage is separate from judge scoring.
Clinch — Emergency Valve (NEW — addresses Goose P2, Dola P4): Available once per round per fighter. Call costs: opponent gets one free exchange; you lose position; −10 stamina. Benefit: +10 guard points recovered; action paused briefly; referee breaks automatically. Cannot be called if guard >50 — it is an emergency tool, not a rest mechanic. Restricted to once per minute (twice/3min round) per Dola P4.
1.5 — The Puncher's Cost & Interactions
Blocked punch costs thrower +0.25 arm fatigue. Feint interaction (NEW — addresses Goose P7): A successful feint that draws a block costs the defender +2 guard wear (flinching raises arms unnecessarily) — no transmission damage, just wear. This makes feinting a viable offensive tool against a tired guard.
2. Player Decisions — Updated
Before the Bout — Fight Plan Screen (ENHANCED)
Defence style selector per round group (R1–2 / R3–4 / R5+) — replaces single global setting (Dola P2). Options: Cover / Move / Parry. Transmission estimate shown vs this opponent.
Guard posture selector — High / Neutral / Low / Peek-a-Boo. Modifiers visible.
Per-opponent presets — Save your preferred style + posture per opponent type (Dola P2). "vs pressure fighter: R1–2 High/Cover, R3+ Low/Move" — one-click recall.
During the Fight — Per Exchange
Defensive options row updates contextually — Parry hidden if Defence <50; Clinch only appears when guard <50 and available this round.
Feedback tiers (NEW — addresses Dola P3):
Yellow guard: "Arms tiring — damage starting to show"
Orange guard: Corner comment "Watch it — they're getting through your guard" + subtle impact sound change
Red guard: Visual pulse on damage numbers + corner comment "Drop your hands and you'll get caught"
Corner Minute — Calls Updated
Table
Call	Effect	Trade-off	Best used when
Hands Up	+5 guard recovery next round	Punch output −10%	Guard low but you're winning
Move, Don't Cover	Switch to movement	Energy drain +15% next round	Guard failing, legs still fresh
Back Off, Recover ✅ (replaces Go to the Arms here)	+20 guard recovery over next round	Give up exchanges; opponent controls range	Guard critical; need to reset
Clinch and Rest	+6–8 guard points immediately	Lose position; opponent free exchange	Emergency only; guard broken
Go to the Arms	Moved to Offensive Plan — opponent guard wear ×1.8	Your arm fatigue +15%	Ahead on points; wearing their defence down
Note on "Go to the Arms": It belongs in the offensive playbook as an attack tactic, not a defensive call (Goose P9). It still exists but is no longer in the guard corner panel.
Result Screen — Enhanced Summary (addresses Dola P4)
Punches thrown • Landed • Blocked • Damage through guard (% total)
Guard points used/recovered per round
Defence style breakdown: "Cover 42% / Move 38% / Parry 20% — blocks cost you 11 effective strikes on the cards"
Guard trajectory visual: bar graph per round
Opponent File / Tape Room — Reads Added
"Combination heavy" → punches 3+ leak significantly more — break rhythm, don't trade
"Feint-heavy" → your guard will wear faster on fakes — don't bite; stay relaxed
"Body puncher" → switch to Low guard; body transmission matters more
3. Menu Integration — Full Wiring Table
Table
Menu	What Shows	Wired To
Fight Screen — Status Bars	Guard bar (0–100 weight-class adjusted) + colour + 1-line status; hover shows exact transmission % at current guard + combo multiplier active	Current guard value; transmission curve (Rule 1.2); combo state; weight class
Fight Screen — Exchange Panel	LANDED panel expanded: Clean hits • On guard • Got through • Combo bonus active	Block count; damage-through calculation; combo multiplier
Fight Screen — Per Exchange	Defensive options row: Cover / Parry / Move / Clinch (context-aware; greyed when unavailable)	Current plan; Defence skill; stamina; guard level; clinch cooldown
Corner Minute — Call Panel	Five calls split: Guard Recovery (Hands Up, Back Off) / Switch Style (Move, Don't Cover) / Emergency (Clinch) — effects previewed	Section 2 call values; guard level; clinch limit
Fight Plan Screen — Defence Tab	Round-group selectors; style + posture dropdowns; transmission estimate vs opponent; Save Preset button	Rule 1.2; opponent file; bout length
Result Page — Bout Summary	Punches, blocked/through, damage %, guard trajectory graph, defence mix %, judge strike differential	Bout record; exchange log; round-by-round guard state; judge scoring
Camp Screen	Permanent amateur guard note; opponent style warning if known	Amateur/pro guard rules; scouting file
Training — Fighter Week	Shoulder endurance: "Guard wear −X%, max +Y"	Rule 1.3
Opponent File / Tape Room	6 defensive reads now: covers under pressure, light/heavy hands, shoulder endurance, combo volume, feint usage, body focus	Section 2 opponent reads
Boxer Profile — Attributes	Guard endurance max value; current training progress; weight-class cap	Rule 1.3; weight-class scaling
4. Balance, Testing & Open Questions
Transmission Values — Locked for Testing (Dola P1)
Jab: 25% fresh guard → config value: GUARD_TRANS_JAB=0.25
Cross/Hook: 42.5% → GUARD_TRANS_POWER=0.425
Uppercut/Heavy: 55% → GUARD_TRANS_HEAVY=0.55
All three in one editable config row. Track across 1,000+ simulated bouts: target total damage increase +8–12%; stoppage rate ±3% baseline; amateur round 3 finish rate. Adjust down if needed.
Guard Trajectory — Example Round-by-Round (6×3 Pro, Middleweight)
Table
Round	Opponent Style	Punches/round	Blocks	Start→End Guard	Leak Damage	Key Decision
R1	Pressure	45	22	100 → 78	4 total	Cover works — transmission low
R2	Pressure	50	25	78 → 55	7 total	Arms tiring — consider switching
R3	Pressure + combos	55	28	55 → 42	12 total	Crossover: Move now
R4	Adjusts, mid-range	30	8	42 → 68	2 total	Recovering — space works
R5	Counter rhythm	25	6	68 → 75	1 total	Moving dominates
R6	Final barrage	55	24	75 → 38 (1 clinch used)	15 total	Survive — clinch at 38 guard
Amateur 3×3 equivalent: Guard dips but rarely breaks below 40; total leak per bout 8–15 damage — meaningful but fight-changing only vs heavy-handed opponents.
What Changed vs What Stayed
Added in V2.1: Per-round defence planning; guard postures; combo multiplier; defined in-round recovery; clinch emergency tool; parry-by-punch-type success; explicit feedback tiers; weight-class scaling; damage zone mapping; feint interaction; result-screen defence breakdown; amateur guard note; moved "Go to the Arms".
