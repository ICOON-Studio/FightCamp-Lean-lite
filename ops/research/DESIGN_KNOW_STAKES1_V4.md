# DESIGN_KNOW_STAKES1_V4 — Knowledge Stakes Mechanic Design Map
Purpose: What does knowing a boxer's hidden habits change? Built from code; addresses all critic feedback from v3; maintains every agreed owner rule. Tags: CODE = existing implementation, ESTIMATE = target to verify, CUT = no code lever. Names appear only in headers.
1. What the Game Already Does with a Habit
1.1 Habit Storage & Discovery
Table
Item	Details	Source	Tag
Habit bank	20 entries in assets/data/fight_habits.json — each with id, name, trigger, beat, effect, punish, three corner notes	fight_habits.json	CODE
Fighter habits	Stored as f["habits"] — array of habit IDs assigned at creation; no new habits develop over time	Data.fighter_state	CODE
Coach's notebook	Tracks observed items in f["notes_seen"] as "habit:<id>" or "trait:<key>"; permanently retained once revealed	CoachNotes.gd seeable(), reveal()	CODE
Initial state	Notebook empty at signing; one habit shown on the recruitment card is visible but not written to notes_seen until confirmed in training/bouts	KnowWire.gd start(), Recruit.gd	CODE
Opponent habits	Stored separately in OppFile; revealed through tape study; persists across rematches via OppFile.remember()	OppFile.gd tape(), open_all(), remember()	CODE
1.2 Reveal Paths
Table
Path	What It Reveals	Probability / Timing	Source	Tag
Punished in bout	One habit that cost in that exchange added to notebook	Deterministic — fires on payment	LiveRound.gd ln 423-427	CODE
Post-bout coach note	One unseen item (habits first, then notable traits)	Deterministic — fires after every bout	BoutFinish.gd coach_note() → CoachNotes.reveal()	CODE
Sparring session	One unseen item from notebook	35% chance per session	CoachNotes.gd SPAR_ODDS := 0.35	CODE
Full tape study (opponent)	Next hidden tell in fixed order: weapon → non-free mode → habits → remaining modes	One tell per full tape session	OppFile.gd tape(), ModeTells.gd	CODE
Half-tape session	Progress banks; two half-sessions = one full tape reveal	One tell every two sessions	OppFile.gd half_tape()	CODE
Complete bout against opponent	Entire opponent file unlocked	Deterministic — after first full 3-round bout	OppFile.gd open_all()	CODE
1.3 Cost & Punishment
Table
Item	Details	Source	Tag
Base habit cost	Fixed value: HABIT_COST = 6.0 power points per triggering exchange	HabitFix.gd header & cost()	CODE
Bout multiplier	HABIT_BOUT = 1.75 → effective cost = 10.5 power before fixes	Exchanges.gd ln 21	CODE
Punishment mapping	17 of 20 habits have a defined punished situation; 3 have no penalty	HabitFix.gd PUNISHED_BY	CODE
Fix effectiveness	Cost reduced: cost = HABIT_COST × (1 - uptake × trust) where uptake = coachability factor	HabitFix.gd cost(), Exchanges.uptake()	CODE
Clock-triggered habits	slow_starter — exchanges 1–2 of Round 1; fades_late — exchanges 3+ of final round	HabitFix.gd EARLY := 2, LATE := 3	CODE
No-penalty habits	digs_body_when_hurt, switches_stance_under_pressure, talks_when_ahead — appear in notebook but carry no cost	HabitFix.gd PUNISHED_BY	CODE
Resolution order	When multiple triggers match, only the first in list order applies	HabitFix.gd punished()	CODE
1.4 Existing Fix Levers
Table
Lever	Effect	Duration	Source	Tag
Corner fix	Reduces cost of one known habit	Next round only; selected from seen, punishable habits	HabitFix.gd offers(), LiveRound.gd	CODE
Signing focus: "Fix the habit"	Removes first observed habit entirely	Permanent; 4-week cycle	Recruit.gd FOCUS["habit"], HABIT_WEEKS := 4	CODE
2. Decisions That Change — The Stakes
2.1 Pre-Signing — Reads & Information Trade-offs
Table
Read Option	Price	What It Actually Narrows	What It Does NOT Reveal	Source	Tag
Look closer	$120	Clears hype OR narrows one widest attribute group by half	Does NOT show habits	KnowReads.gd PRICE_LOOK_CLOSER, apply()	CODE
Test day	$60	+8 body exposure; +16 if <5 bouts; narrows physical attribute ranges	Does NOT show habits	KnowReads.gd PRICE_TEST_DAY, _apply_test_day()	CODE
Trial	$500	4 weeks × half stipend; +24 body/skills exposure	Does NOT show habits	KnowReads.gd PRICE_TRIAL_WEEKS, _apply_trial()	CODE
Recheck	$40	Halves stale attribute widening; 21-day cooldown	Does NOT show habits	KnowReads.gd PRICE_RECHECK, Knowledge.recheck()	CODE
Hard spar (club)	$0; ×2 injury; +15 fatigue	+7.25 under-fire exposure	Does NOT show habits	KnowReads.gd risk(), Knowledge.hard_spar()	CODE
Hard spar (external)	$160; ×2 injury; +15 fatigue	+10.875 under-fire exposure	Does NOT show habits	KnowReads.gd PRICE_HARD_SPAR_OUTSIDE	CODE
Decision rule: Show the one recruitment habit separately from attribute estimates. Display "Coach suspects this — not yet confirmed." Reads only narrow attribute uncertainty; they do not reveal habits. Recheck only appears on stale files, not fresh prospects.
To address Arena critic #1: Reads with no actionable decision are hidden. If both ends of the narrowed range still fit your budget and contract plan, the read button is disabled with reason: "No decision changes — save your money."
2.2 Bout Offer — Risk Warning
Logic: HabitFix.PUNISHED_BY[habit] ∩ Exchanges.STYLE_MODES[opponent_style] = intersecting situation → risk banner appears. Only known, punishable habits trigger it. Clock-triggered habits show separate wording. State-triggered habits show condition-based phrasing.
Table
Your Known Habit	Punished Situation	Opponent Styles Most Likely to Trigger	Tag
drops_right_after_jab	counter	Counter-puncher (0.55), Spoiler (0.4)	CODE
freezes_on_ropes	press	Pressure fighter (0.55), Swarmer (0.65), Stalker (0.5)	CODE
switches_stance_under_pressure	press	Pressure fighter (0.55), Swarmer (0.65), Stalker (0.5)	CODE
talks_when_ahead	counter	Counter-puncher (0.55), Spoiler (0.4)	CODE
wide_hook_tell	counter, range	Counter-puncher (0.55), Out-boxer (0.6)	CODE
retreats_straight_back	press	Pressure fighter (0.55), Swarmer (0.65)	CODE
admires_her_work	counter	Counter-puncher (0.55), Spoiler (0.4)	CODE
lunges_with_jab	range	Out-boxer (0.6), Boxer-puncher (0.35)	CODE
head_down_inside	press	Pressure fighter (0.55), Swarmer (0.65)	CODE
low_lead_hand	loadup	Slugger (0.45), Boxer-puncher (0.25)	CODE
one_and_done	press	Pressure fighter (0.55), Volume puncher (0.45)	CODE
chases_stoppage	hurt	Opponent state trigger — applies universally	CODE
slow_starter	Round 1, Exchanges 1–2	Clock trigger — applies to all opponents	CODE
fades_late	Final round, Exchanges 3+	Clock trigger — applies to all opponents	CODE
clinches_when_tired	she_tired	Your fighter state — depends on fatigue	CODE
loads_up_when_hurt	she_hurt	Your fighter state — depends on damage	CODE
covers_up_when_hurt	she_hurt	Your fighter state — depends on damage	CODE
digs_body_when_hurt	(helpful — no penalty)	—	CODE
Banner text examples:
Standard risk: "Your boxer tends to drop the right hand after the jab. Opponent fights off counters — expect this to cost exchanges."
Clock risk: "Slow starter — first two exchanges of Round 1 are vulnerable regardless of opponent."
State risk: "When hurt, tends to load up — watch for counter opportunities but expect higher cost when damaged."
No penalty: "Digs body when hurt — this habit can work in your favour; no penalty risk."
To address Arena critic #2: Banner only appears when a known habit intersects the opponent's actual dominant mode (ModeTells.free_mode or top STYLE_MODES value). No warning for hidden risks — unknown = no warning. No "safe" badge shown.
2.3 Game Plan — Available Responses
Table
Habit	Plan Situation	Available Response	Tag
fades_late	tiring	"Start busy — don't let her settle"	CODE
slow_starter	tiring	"Push early — bank Round 1"	CODE
admires_her_work	tiring	"Stay busy — don't pause"	CODE
drops_right_after_jab	range	"Go to the body — under her jab"	CODE
lunges_with_jab	press	"Stay at range — make her miss"	CODE
digs_body_when_hurt	hurt	"Press up — don't let her settle on your body"	CODE
loads_up_when_hurt	hurt	"Stay calm — don't chase"	CODE
All other 13 habits	No mapping in PlanLines.HABIT_SITS	Observed in notebook — no plan line available. Label: "Not yet mapped — corner fix only"	CODE
To address Dola critic #1: 13 unmapped habits are clearly labelled "Observed — no plan answer yet" rather than appearing as missing/empty space. They remain visible in the notebook and eligible for corner fixes. Full plan-line mapping is a future scope item, not v4 — marked explicitly so no player confusion.
2.4 What Each Menu Shows — Complete Wire Table
Table
Menu Screen	What Displays	Interactions / Actions	Owner Rule	Tag
Roster — fighter card	Notebook summary: count known / total; highest-risk habit flagged	Click → Fighter page	S425	CODE
Fighter page — Overview tab	Coach's Notebook section: all confirmed habits; trigger description; penalty status; plan-line availability; fix eligibility	Click habit → jump to relevant screen (Plan / Week / Corner notes)	S425	CODE
Recruitment / Prospect card	One suspected habit shown separately: "Coach suspects — unconfirmed"; attribute ranges shown with current uncertainty	Sign with focus / Pass / Eligible reads only (disabled when no decision changes)	S425, S448	CODE
Bout offer page	Risk banner — colour coded: RED = high intersection, AMBER = clock/state trigger, GREEN = helpful habit with no risk	Accept / Inspect file / Pass	S425	ESTIMATE
Fight prep — Plan tab	Situations with plan lines unlocked where mapped; unmapped opponent habits shown as "Observed — no line yet"	Write line / Clear / Rate / Test	S425	CODE
Week screen	Signing focus shown when active: "Fixing [habit] — week X of 4"; no weekly drill lever exists in code — NOT ADDED	Plan week / Set focus / Change camp	S425	CODE
Post-bout recap	Newly revealed habit: "Coach saw this during the fight — [habit description + trigger]"	Continue → next week	S425	CODE
Opponent file	Tape-study order: weapon → mode → habits; each marked Revealed / Hidden (what unlocks it)	Watch tape / Scout / Close	S425	CODE
Corner card (mid-bout)	Fix options limited to seen, punishable habits; one selectable per round	Select fix / No change	S309	CODE
Corner result (next round)	Fix outcome: "Came up N times — saved X% of cost this round. Did not appear"	Continue	S320	CODE
3. Changes from V3 — Addressed Critic Feedback
Table
Critic Feedback	Change Made	Rationale
Test day/trial misleadingly suggest they reveal habits	All reads explicitly state: "Narrows physical attributes only — does not reveal habits." Reads disabled when no decision changes.	They never revealed habits in code — v3 text was the issue, not the mechanic
13 unmapped habits appear as dead space	Show clearly: "Observed — plan line not yet built. Available as corner fix only." No empty/missing UI space	Adding 13 plan mappings = new feature work outside scope; clarity solves the dead-end problem without scope creep
Single cost value lacks distinction	Cost shown consistently: "−10.5 power per triggering exchange before fixes." No invented tiers — what the code uses is what displays.	Dola critic #2 requested tiers; Arena critic #1 warned against invented numbers — transparency about what the code actually does wins
No active targeting of specific habits to reveal	NOT ADDED — CoachNotes.reveal() returns first unseen item deterministically; no code supports priority targeting. Stated plainly: "Reveal order is automatic — coach reports what appears first, cannot be directed."	No code lever = cannot build; explicit limitation > promising what doesn't exist
No weekly mitigation drills	NOT ADDED — no per-habit training lever in code. Only two fixes exist: 4-week focus and corner fix. Shown clearly on the habit row.	Dola critic #3 requested this; code simply does not have it — honest display > invented mechanics
Recruitment habit not written to notebook	Clarified: "Shown at interview = coach's suspicion. Confirmed in action = written to notebook." Not auto-confirmed at signing — avoids false positives per Arena critic	Code distinction was real but unclear in v3 text
Recheck appears on fresh prospects	Recheck button hidden on all prospects <21 days old; appears only when file is stale	Fix per Arena critic #1
Clock/state triggers merged into generic risk	Separate wording: clock triggers ("Round 1 only") vs opponent-style triggers vs your-state triggers	Per Arena critic — distinction matters for decision clarity
"One-and-done" habit mapped correctly	Added to table — missed in v3; confirmed in PUNISHED_BY	Correction from v3 oversight
No penalty habits look like broken entries	Distinct green label: "✅ HELPFUL — No penalty cost. Build around it rather than fix it." Positive framing instead of empty space	Visual distinction solves the confusion
4. Items CUT — No Code Lever; Will Not Build
Table
Proposed Change	Why Not
Per-habit cost tiers (−4/−7/−10)	Code uses one fixed value: HABIT_COST = 6.0. Inventing values outside code = misrepresentation.
Weekly habit mitigation drills	No function in code reduces habit cost gradually. Only two fix paths exist.
Active targeting / priority reveal	Reveal order is deterministic first-unseen; no priority parameter in CoachNotes.reveal().
Full 20-habit plan-line coverage	13 habits have no entry in PlanLines.HABIT_SITS. Adding them = new feature work, not iteration on existing design. Clearly labelled as limitation instead of empty space.
Test-day reveals one habit	KnowReads._apply_test_day() modifies attributes only. Would require new RevealOneHabit function outside current scope.
5. Probe Metrics & Verification Targets — ESTIMATE
Probe setup: 150+ worlds × 4 seasons; fixed matchmaking bot; roster = 4 weight classes + 3 boxers + 1 BJJ athlete (S428).
Table
Metric	BLIND (sign blind)	READ-FIRST (eligible reads only)	ORACLE (all habits known)
Top-10 finish rate	Baseline	≥+4% vs BL	
Today 14:23
Chat
Create Videos
Create Images
Writing
Homework
Translate
