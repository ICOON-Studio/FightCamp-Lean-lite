# GUARDDMG1_V2 — Damage Through the Guard (S512, 2026-11-18)
Owner's premise: "the punches and the guards need real numbers for damage and reduction, the guard should negate the punch's damage, if not some damage goes through". Every (ESTIMATE) label marks values drawn from biomechanical research and existing combat-sport systems — not yet playtested in-game.
0. What the game builds on (from the code)
A round runs as six 30-second exchanges. Each punch LANDS, is BLOCKED, or MISSES. Only landed punches score, mark body damage, take energy, and can cause stoppages.
A blocked punch currently does nothing to the defender. The existing GUARD bar only shows shoulder fatigue — it provides no protection.
Defence profile determines whether an incoming punch is blocked, slipped, weaved, or pulled.
Body damage bands: Fine (>55), Hurt (≤55), Critical (≤35), Doctor (≤15).
Damage values already exist per punch type. This mechanic sits on top — it does not replace or rewrite the existing damage model.
1. Core Rules
1.1 — Punch Force & Transmission
Every punch has a base damage value. When blocked, a percentage of that force transmits through to the defender — this is real damage of the same type (head/body) and follows the same body-part thresholds.
Table
Punch type	Base damage	Transmission — fresh guard (ESTIMATE)	Guard wear per block
Jab	1.0	25%	1
Cross / Hook	2.5	45%	3
Uppercut / Heavy shot	4.0	55%	5
Body punches on the arms: transmission reduced by ~5% (35–40% instead of 40–55%) — the ribcage absorbs force differently than the head.
1.2 — The Guard Bar & Leak Curve
Guard = 0–100. Leverage the smooth curve proposed by critic Dola — remove the hard "broken = 1-in-3 lands" rule. Transmission % = base transmission × (100 ÷ current guard). This produces natural escalation without arbitrary thresholds:
Table
Current guard	Multiplier	Jab transmits	Power transmits	Big shot transmits	Visual cue
100	×1.0	6.3%	20.3%	30.3%	Green — holding well
75	×1.33	8.3%	27.0%	40.3%	—
50	×2.0	12.5%	40.5%	60.5%	Yellow — arms tiring
25	×4.0	25.0%	81.0%	—	Orange — leaking heavily
15	×6.67	—	—	—	Red — arms dropping
Rule clarification: Nothing counts as landed unless it actually lands via the existing roll. The curve means poor guard = more damage gets through on blocks — that is the entire mechanic. The 1-in-3 rule from V1 is removed — it created confusion and is not needed.
1.3 — Guard Wear & Recovery
Wear: Every blocked punch subtracts wear points from the guard bar (table above). Shoulder endurance training reduces wear rate — −2% wear per point above 50 (min 60% of base).
During the round: 0 recovery while actively being struck. When opponent is not throwing (between bursts): +2–3 guard points per 30-second exchange (ESTIMATE). This rewards creating space and working out of range.
Corner minute recovery:
Base: +15 guard points (capped at max)
With "Hands up" call: +5 additional
With good cutman: +5 additional (applies only when no active cut to treat)
Max guard: Base 100. Amateur bouts: max = 80, wears +20% faster, recovery between rounds +20% faster. Pro bouts: full 100, normal wear rate. This means guard breakdown is possible in amateur round 3 but becomes a defining strategic factor in longer pro fights.
1.4 — Two Defensive Paths — Plus One Balanced Option
Table
Defence style	What it costs	What you gain	When it becomes costly	When it shines
Cover up	Guard wears with every block; transmission grows over time	100% reliable — no stat check needed; preserves legs/energy	Once guard falls below ~40, leak damage accelerates fast	Late in round when legs are empty; under fire while hurt
Move / Slip	Costs energy/legs per exchange; success rate drops as stamina falls	0% transmission on a successful miss	Stamina <40% → slip success rate halves	Fresh legs; opponent rhythm is readable; building round control
Parry / Redirect	Minimal guard wear (0.3 pts/block); moderate skill check cost	Only 8% transmission through a successful parry	Fails 2× more often vs power punches and combinations; Defence skill <55 → unreliable	Mid-range exchanges; counter-punching opportunities
Judge scoring: Every 3 punches blocked = +1 effective strike credited to the opponent. Slipped/missed punches = 0. This prevents "just cover everything" from being a free strategy — you give away rounds on the cards if you never answer back. Rule 5 from V1 updated: Blocks never count as landed for damage OR knockdowns — but they do accumulate effective-strike credit for scoring.
1.5 — The Puncher's Cost
A blocked punch costs the thrower +0.25 extra arm fatigue compared to landing cleanly. Hitting elbows and forearms is mechanically less efficient than hitting air or flesh. This makes "make him miss, force him to hit arms" a viable long-term pressure strategy — especially against high-volume opponents.
2. Player Decisions — What You Actually Choose
Before the Bout — Fight Plan
Per phase: Cover up / Move head / Parry and counter — sets default defensive behaviour
Plan note: "Parry" unlocks only when Defence skill ≥50
During the Fight — Per Exchange & Corner Minute
Per exchange (new): One defensive tweak available every 30 seconds. Options reflect your plan but you can override for that single exchange at no penalty. Choices shown only when that style is viable (e.g., Parry hidden if skill too low).
Corner calls between rounds:
Table
Call	Guard effect	Trade-off	Best used when
Hands up	+5 extra guard recovery next corner	Punch output −10% for next round	Guard dropped low but you're still winning the round
Move, don't cover	Switch defence priority to movement	Leg/energy drain +15% next round	Guard below 40 and legs still fresh enough to slip
Go to the arms	Opponent guard wear ×1.8	Your arm fatigue +15%	You're ahead on cards; forcing a late stoppage isn't urgent
Clinch and rest	Recover +6–8 guard points	Lose position; opponent gets a free exchange	Short bursts of relief — not a round solution
Training & Preparation
Shoulder endurance: Raises max guard (+1 per 2 points trained above 50) and reduces wear rate (−2% per point)
Defence skill: Raises parry success rate and slip reliability
Opponent file reads (from scouting/tape):
"Covers up under pressure" → Guard breaks predictably under volume; Go to the arms works well
"Light hitter" → Transmission % is low; covering is safe and effective
"Heavy hands" → Transmission % is high; avoid extended covering — move or parry instead
"Strong guard" / "Tired shoulders" → Shows relative shoulder endurance level
3. Menu Integration — Full Mapping
Table
Menu	What Shows	Wired To
Fight Screen — Status Bars	Guard bar (0–100) with colour gradient + 1-line status; hover shows exact % transmission at current level	Current guard value; transmission curve (Rule 1.2)
Fight Screen — Exchange Panel	LANDED panel expanded: Clean hits • On guard • Got through	Block count; damage through calculation
Fight Screen — Per Exchange	Defensive options row: Cover / Parry / Move / Clinch (context-aware)	Current plan; Defence skill; stamina level
Corner Minute — Call Panel	Four guard-management calls with effects previewed	Section 2 call values
Result Page — Bout Summary	Punches thrown • Landed • Blocked • Damage through guard • Guard points used/recovered per round • Judge effective-strike differential from blocks	Bout record; exchange log; round-by-round guard state
Fight Plan — Defence Lines	Cover up / Move head / Parry and counter per phase; transmission estimate vs opponent style	Rule 1.2; opponent file
Training — Fighter Week	Shoulder endurance: "Guard max +X, wear −Y%"	Rule 1.3
Opponent File / Tape Room	Four defensive-style reads	Section 2 opponent reads
Boxer Profile — Attributes	Guard endurance max value; current training progress	Rule 1.3
4. Balance, Risks & Testing Notes
Dominant Pick — Solved
The smooth curve means the crossover point emerges naturally: covering is cheaper early and through mid-round, but once transmission passes ~35% total damage taken overtakes the energy cost of moving. At that exact point — different for every fighter based on stats and opponent — switching becomes the clearly better choice. No arbitrary trigger required.
What This Changes vs What Stays
Changes: Blocked punches now leak damage; guard is a depletable resource; three defensive approaches; judge scoring from blocks; puncher fatigue on blocks
Unchanged: Existing damage model on clean hits; knockdown/stoppage thresholds; judge scoring on landed punches; exchange timing; all existing plan lines and corner calls
Playtest Checklist (Estimated Balance Targets)
Amateur 3×3: Guard should rarely drop below 25. Transmission creep should decide close rounds on accumulation, not sudden disaster. Target: guard-break crisis in ~5% of amateur bouts.
Pro 6×3: Guard breakdown should be a usable strategy — target: becomes the deciding factor in ~25% of bouts.
Plan readjustment cost: Changing defence mid-round per exchange must feel like a genuine tactical lever, not something you need to do every single 30 seconds.
Damage harness: Leak damage adds ~8–12% total fight damage on average. Knockdown/stoppage rates must stay within ±3% of current baseline after implementation — if stoppages rise too much, scale transmission down slightly.
5. Open Questions Remaining
Transmission percentages: Dola research suggests 25/45/55; Goose cites 30–40/40–50/50–60. Both agree original V1 numbers were too low. Final tuning needed in live tests — start at the midpoint values above.
Parry success rates vs individual punch types — does it fail more predictably against hooks than jabs? Refine once in-code.
Clinch recovery timing — should it be available every exchange or limited to once per minute? Start at once per exchange and restrict if overused.
Visual/audio language — at what exact transmission threshold does the player deserve explicit feedback beyond the bar colour? Current plan: status text updates at each colour band; corner vocal at orange.
DEPTH: 8/10 (ESTIMATE) — three distinct defensive paths with smooth cost crossover; evidence-based numbers; interacts with plan, training, scouting, corner calls, and judge scoring.
GENERAL DESIGN: 8/10 (ESTIMATE) — rules integrate cleanly with existing exchange structure; every menu hookup is wired; no clunky exceptions; amateur/pro scaling built in from the start.
