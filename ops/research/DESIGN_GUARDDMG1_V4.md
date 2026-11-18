# GUARDDMG1 V4 - guard damage design map (Dola SQ225, from v3 + critics Goose 7/6/5, Dola v3; S520)

Source: ops/research/DESIGN_GUARDDMG1_V3_REVISE_DOLA_DOLA.md lines 812 on (Dola's reply; her self-scores dropped - critics score it). Verify numbers marked ESTIMATE.

Version: 4 | Date: 2026-11-18 | Source: V2.1 + Goose + Dola critic feedback | Scores Target: DEPTH ≥7, GENERAL DESIGN ≥7
Every critic item from both reviewers is addressed below. All rules the owner agreed in V2.1 are retained unless explicitly revised. All values marked (ESTIMATE) require playtest confirmation.
0. Foundation (Unchanged)
A round = six 30-second exchanges. A punch LANDS / BLOCKS / MISSES. Only landed punches score.
Guard bar = shoulder fatigue + guard capacity. Defence profile determines block/slip/miss.
Body damage bands: Fine >55 · Hurt ≤55 · Critical ≤35 · Doctor ≤15
This mechanic sits on top of existing damage — it never replaces it.
1. Core Rules — Revised & Extended
1.1 — Punch Force, Transmission & Combo Multiplier
Revised transmission formula (Goose P3):
Transmission % = Base × (0.5 + (100 − Guard) ÷ 100)
Table
Punch type	Base damage	Fresh guard transmission (ESTIMATE)	Guard wear per block	Notes
Jab	1.0	25%	1	—
Cross / Hook	2.5	42.5%	3	—
Uppercut / Heavy shot	4.0	55%	5	—
Table
Current guard	Multiplier	Jab transmits	Power transmits	Big shot transmits	Visual cue
100	×1.0	25%	42.5%	55%	Green — Holding well
75	×1.25	31%	53%	69%	—
50	×1.5	38%	64%	83%	Yellow — Arms tiring
25	×1.75	44%	74%	80% cap	Orange — Leaking heavily
0	×2.0	50%	85%	80% cap	Red — Arms dropping
Combo multiplier (retained): Punches 1–2 = base. Punch 3+ in same sequence: ×1.5 wear, ×1.5 transmission. Resets after one full exchange with no throws. Combo threat indicator shows "1/3 · 2/3 · ⚠️ COMBO" during buildup (Goose P8).
Damage distribution (simplified, Goose P3):
Blocked head → 100% head damage
Blocked body → 100% body damage
Both add energy cost equal to 8% of damage value
Posture modifiers (revised, Goose P2):
Table
Posture	Effect	Wear modifier	Best used
High Guard	Head −20% · Body +15%	+8%	Opponent targets head
Neutral	No modifier	—	Default
Low Guard	Head +15% · Body −20% · Counter speed +10%	—	Opponent targets body
Removed: Peek-a-Boo (Goose P2). If needed later, implement as a fighter trait, not global posture.
Ring generalship interaction (NEW — Goose P4):
Opponent has you trapped on ropes/corner: guard wear +12% (ESTIMATE)
Moving freely: guard wear −5%
Weight-cut interaction (NEW — Goose P5):
Current condition <70: guard wear +10%
Missed weight entirely: guard wear +18%
1.2 — Shoulder Endurance — Clarified (Goose P1)
Where it lives: Shoulder Endurance = Stamina × 0.7 + Strength × 0.3 — derived from two existing attributes, no new stat.
Training: Builds via Cover Up usage — each blocked punch contributes small permanent progress toward proficiency.
Effect: At 50 baseline; 65 = −12% wear rate; 80 = −20% wear rate (capped at −25%).
1.3 — Guard Wear, Recovery & Proficiency
Defence Style Proficiency — NEW (Dola P1):
Each path builds independently 0–100 like moves:
Table
Tier	Effect	Gained by
Usable 30	−10% cost	Blocking (Cover) / clean misses (Move) / successful parries
Sharp 60	+10% effectiveness	Continued usage
Signature 85	+15% recovery bonus	Mastery unlock
In-round recovery (retained + refined):
Opponent throws 0 punches: +3 guard
Opponent throws 1–2: +1 guard
Active rest option (Dola P4): Choose to slip without counter attempt → +2–3 guard + +4 stamina over 2 quiet exchanges; you give up initiative
Clinch — Revised (Goose P4, Dola):
Available once per round only; guard <50 required
Base: +10 guard immediately; −10 stamina; lose position; opponent gets one free exchange
Skilled clincher bonus (BJJ background/trait): +13 guard instead of +10 (Dola P4)
Corner recovery (retained):
Table
Source	Recovery	Notes
Base between rounds	+15	Capped at weight-class max
Hands Up call	+5 additional	Next round only
Good cutman	+5 additional	Only when no active cut
Back Off, Recover	+20 over next round	No exchanges; cedes range
Amateur / Pro scaling (revised per Dola P6):
Table
	Amateur	Pro
Max guard	70	Weight-class max
Wear rate	+15% faster	Normal
In-round recovery	+4/quiet exchange	+3/quiet exchange
Note on Camp screen	✅ "Amateur: guard recovers fast but degrades quick — don't trade non-stop"	Standard rules apply
Weight-class scaling (retained):
Table
Class	Max guard	Transmission
Lightweight	80	×0.9
Middleweight	100	×1.0
Heavyweight	120	×1.3
1.4 — Trait & Habit Interactions — NEW (Dola P2)
Existing traits now affect guard behaviour:
Table
Trait	Effect
Slow starter	R1–2 wear −12% · R3+ wear +12%
Fades late	Recovery −25% after round 4
Chases stoppage	Parry success +8% · Recovery −10%
High coachability	Corner guard calls +15% effective
Low morale	Recovery −20%
Chin ≥70	Leak damage −8% (Goose P9)
1.5 — Defensive Paths — Refined
Table
Style	Cost	Gain	Best against	Proficiency bonus
Cover Up	Guard wears per block; transmission rises as guard falls	0 stamina cost; predictable damage	Late rounds; hurt fighters	Usable: −10% wear · Sharp: +8% recovery
Move & Slip	Stamina −4/ exchange; 50% effectiveness below 40% stamina	0% transmission on clean miss; opponent wastes shots	Volume punchers; wild swingers	Usable: −15% stamina cost · Sharp: +10% success
Parry / Redirect	Fails vs power punches; Defence ≥50 unlock; 15% failure baseline	0.3 wear · 8% transmission · counter opportunity	Mid-range; counter style	Usable: +10% success · Sharp: +5% counter damage
Parry success by punch type (retained): Jab 70% · Cross 55% · Hook 40% · Uppercut 35% ± Defence skill shift.
Judge scoring (retained): Every 3 blocked punches = +1 effective strike to opponent — for scoring only. Never counts as landed for damage/KD.
2. Player Decisions — Extended
Before the Bout — Fight Plan Screen
Round groups: R1–2 · R3–4 · R5+ (retained)
Defence style: Cover / Move / Parry
Guard posture: High / Neutral / Low
Presets — NEW (Dola P5): Save up to 5 profiles by opponent archetype (Pressure / Counter / Volume / Brawler / Body). One-click load. Example: "vs Pressure: R1–2 High/Cover → R3+ Low/Move"
Estimate preview: Shows projected guard range per round group vs scouted opponent
During the Fight — Per Exchange
Contextual options row — Clinch appears only when guard <50 and available this round; Parry hidden below Defence 50
Combo threat meter: 0/3 → 1/3 → ⚠️ 2/3 → 🔥 COMBO ACTIVE — visible before damage spikes
Ring position cue: "Trapped on ropes — guard wearing faster" / "Open ring — recovering"
Clinch counter: "Clinch available: 0/1 this round"
Corner Minute — Extended (Goose P6)
Posture switch option: Change posture between rounds — costs one of two instructions that minute
"Protect the Lead" — NEW (Goose P7): One-click defensive mode — High Guard + Cover Up combined; punch output −15%; guard wear −8%; visible indicator: ⭐ PROTECTING LEAD
Calls panel:
Table
Call	Effect	Trade-off	Best used
Hands Up	+5 guard next round	Punch output −10%	Guard low, ahead on points
Move, Don't Cover	Switch to Move instantly	Stamina +15% next round	Guard failing, legs fresh
Back Off, Recover	+20 guard over next round	Cedes range/initiative	Critical guard — full reset needed
Clinch & Rest	+10 guard immediately; resets rhythm	Lose position; opponent free exchange	Emergency — guard <40, 1/1 remaining
Protect the Lead	High+Cover auto; −15% output; −8% wear	No offensive pressure needed	Final round, ahead on cards
Result Screen — Enhanced (Goose P10, Dola)
Punches thrown · Landed · Blocked · Got through (% of total)
Guard trajectory: bar graph per round (start · end · peak leak)
Defence breakdown: "Cover 42% / Move 38% / Parry 20% — blocks cost 11 effective strikes on cards"
✅ Plan success moment: If guard stayed above 55 through a pressure round → "They threw everything and your guard held — great management"
Next week button: "Train shoulder endurance" / "Practise parries" / "Work on movement conditioning" — matches which defence wore most poorly
Opponent File / Tape Room — Extended Reads (Dola P3)
Original 6 retained + 4 new:
✅ Combination heavy → break rhythm, don't trade
✅ Feint heavy → don't bite; guard wears +2/fake
✅ Body puncher → switch Low guard
✅ Falls into combos late → finish with movement R4+
✅ Feints when ahead → don't overcommit
✅ Goes to body when tired → anticipate R3+
✅ Traps on ropes → keep centre; avoid corners
✅ Switches plan after 2 rounds → adapt yours too
Opponent adaptation: If same posture used 3+ rounds running → opponent shifts target (High → body; Low → head) — visible: "They've spotted your pattern"
3. Menu Integration — Full Wiring Table
Table
Menu Area	What Shows	Wired To
Fight Screen — Status Bars	Guard bar (colour-coded green/yellow/orange/red) + value + transmission % on hover · Combo threat 0–3 · Position cue · Clinch counter	Current guard · Revised curve · Combo state · Ring position · Clinch cooldown
Fight Screen — Exchange Panel	Clean hits · On guard · Got through · Combo bonus active · Active rest option when safe	Block count · Damage-through calc · Combo multiplier · Stamina state
Fight Screen — Defensive Row	Cover / Move / Parry / Clinch — greyed when unavailable; proficiency badge next to each option	Current plan · Defence skill · Stamina · Guard level · Clinch limit · Proficiency tier
Corner Minute — Call Panel	5 calls grouped: Recovery / Switch / Emergency / Protect Lead · Posture switch dropdown · Effect previews	Section 2 values · Guard level · Clinch limit · Round state · Points lead estimate
Fight Plan — Defence Tab	Round-group selectors · Style + Posture dropdowns · Transmission estimate vs opponent · Preset Save/Load button	Rule 1.1 values · Opponent scouting · Bout length · Saved profiles
Result Page — Summary	Punch stats · Damage through % · Guard trajectory graph · Defence mix · Plan success highlight · Next week training button	Bout log · Round guard state · Judge scorecard · Performance analysis
Camp Screen	Permanent amateur guard note · Opponent style warning if scouted (combo/feint/body/rope)	Amateur rules · Scouting file
Training — Fighter Week	Shoulder endurance: "Guard wear −X% · Tier: Usable/Sharp" · Defence proficiency progress bars per style	Rule 1.2 · Usage history · Stamina+Strength derived value
Opponent File	10 defensive reads total; locked lines say what unlocks them	Scouting progress · Tape study completion
Boxer Profile — Traits	Trait effects summary line: "Slow starter — guard wears 12% less early"	Section 1.3 trait map
4. Balance & Testing Plan
Config-locked values: GUARD_TRANS_JAB=0.25 · GUARD_TRANS_POWER=0.425 · GUARD_TRANS_HEAVY=0.55
Targets (ESTIMATE): Total damage increase vs pre-guard system: +7–11% · Stoppage rate ±3% baseline · Amateur R3 finish rate unchanged
Test cases: Rope pressure · 10-punch combo · Dehydrated fighter · Late-round recovery · Preset recall vs adaptive opponent
Tune down if: Guard >60 still leaks >35% on power; or amateur R3 ends 8% more often than baseline
5. Critic Action Log — Every "To Reach 10/10" Item
Goose — All 10 items ✅ Resolved
Table
#	Request	Resolution
1	Clarify shoulder endurance	Derived from Stamina×0.7 + Strength×0.3 — explicit mapping
2	Remove Peek-a-Boo	Removed; can return later as fighter trait if needed
3	Smooth transmission curve	100/guard → gentler linear formula; max ×2.0 not ×4.0
4	Ring generalship interaction	Trapped on ropes = +12% wear; open ring = −5%
5	Weight cutting compromise	Condition <70 = +10% wear; missed weight = +18%
6	Mid-fight posture switch	Added to corner minute — costs one instruction
7	Protect the lead mode	One-click option in corner minute
8	Visible combo buildup	Combo threat 0/3 → 1/3 → 2/3 → active
9	Guard ↔ chin interaction	Chin ≥70 → −8% leak damage
10	"Guard held" moment	Result screen shows success highlight when applicable
Dola — All 5 items ✅ Resolved
Table
#	Request	Resolution	
1	Defence proficiency per style	0–100 tiers; gains from usage; bonuses at each tier	
2	Wire guard to traits & habits	6 trait interactions added; all from existing trait list	
3	Expand opponent reads	6 → 10; opponent adapts to repeated patterns	
4	Flexible recovery options	Active rest; skilled clincher bonus; feint fatigue loop	
5	Preset library & quick switch	5 archetype presets; load from plan or corner minute	
6	Tune amateur balance	Max 70, +15% wear, +4 recovery; clearer on-screen note	✅ Done
