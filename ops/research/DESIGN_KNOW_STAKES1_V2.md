# DESIGN_KNOW_STAKES1_V2 - Dola's map (SQ239) + Claude's code check (S530)

## Code check (Claude, S530) - read before any critic or build
Dola writes without the repo, and v2 again puts invented numbers on systems that already exist:
- Habits: `assets/data/fight_habits.json` holds 20 habits (id, name, trigger, beat, effect, punish) - WORDS, no per-habit
  costs. The cost is ONE value, `HabitFix.HABIT_COST` = 6 power points in an exchange whose situation punishes the habit
  (`HabitFix` header). v2's -6 rows match it; its -4 / -5 / -7 / -8 and "defence -25%" are invented; it names 6 of the 20.
- Reveal: the coach's notebook already reveals a punished habit at the bell (HabitFix); reads and their prices exist in
  `scripts/rules/KnowReads.gd` (the reads table) on `Knowledge.gd` ranges ("the range never lies"). KnowReads (all ESTIMATE in the
  code): look_closer $120 (v2 matches), trial 4 weeks on the $250 stipend (v2: 1 day $30), test_day $60 (v2: $150),
  recheck $40, hard sparring outside $160 + injury x2 / tiredness +15 (v2: $200 and 70/90/40% chances, invented).
  A v3 must use KnowReads' rows.
- Mitigation (v2 4.3) duplicates `HabitFix` (the corner fixes ONE habit for the next round, held by uptake) and the
  signing focus "Fix the habit" (Recruit). "Penalty -50% / -60%" are invented.
- "Emerging habits" (v2 4.5) is a new system with no lever in the code - out of scope for this mechanic.
- KEPT from v2 (sound): one rule "once revealed, shown everywhere"; the risk banner on the bout offer when the opponent's
  style punishes a KNOWN habit of ours (Exchanges.MODES + HabitFix's punish map already give the pairing); the plan line
  that answers a known habit; the menu wiring table; the BLIND / READ-FIRST / ORACLE probe.
NEXT: v3 written FROM THE CODE (Goose, like LEDGER1 v3 and TURNPRO1 v4), then two fresh critics. Not another chat-seat round.

---
DESIGN_KNOW_STAKES1_V2 — Hidden Habits & Knowledge Stakes
Purpose: Turn existing fighter habits into hidden information that shapes signing, scouting, training, and matchup decisions. Knowledge reveals what punishes each habit — so you avoid bad pairings and build answers into your plan.
Estimates: All simulation percentages and financial outcomes are TARGETS until measured across ≥150 worlds.
1. Core Concept
Every fighter carries permanent habits — tendencies that cost power points when their trigger situation happens in a fight. Habits are hidden at walk-in. You reveal them through reads, sparring, or real bouts. Knowing a habit does not remove it — it shows you which opponents punish it and which plan lines answer it.
The fighter's quality never changes — only which matchups are safe or risky
Information always costs time or money — never free
Three tiers of clarity: Unknown → Partial → Known
2. What Exists — The Hidden Truth
All from fight_habits.json and FighterProfile.gd:
Table
Habit Name	Trigger Situation	Punished By (Opponent Style/Action)	Cost When Punished	Revealed By
Drops right after jab	Exchanges starting with jab	Counter-puncher; opponent slips then counters	−6 power points	Trial, bout
Slow starter	First 2 rounds	Aggressive/pressure fighter; high output early	−4 power points rounds 1–2	Trial, 2+ rounds sparring, bout
Fades late	Round 3 onward; tired	High pace; opponent pushes rounds 2–3	−5 power points from round 3 onward	Test day, 3+ round sparring, bout
Bites on feints	Opponent feints then attacks	Feint-heavy style; counter from feint	−7 power points	Bout only
Head down inside	Clinch/inside exchanges	Uppercut/body hook specialist	−8 power points	Test day, inside sparring, bout
Freezes on ropes	Pressed against ropes	Pressure fighter; corner volume	−6 power points; defence −25%	Trial, bout against ranked opponent
Durability (Glass Chin equivalent): already a primary attribute — range hidden at walk-in; narrows with every read; revealed fully at Test Day
Composure: primary attribute — ranges with pressure situations; revealed at Trial
~10% of prospects have No Punished Habit — shown as "Clean record — no known habits" once fully revealed
3. Reveal Actions — Cost & What You Learn
Each action has a clear price and a fixed set of things it can show. No action reveals everything at once.
Table
Action	Cost	What It Reveals	Chance
Walk-in view	Free	❌ No habits shown — only trait description	—
Look closer	$120	Narrows attribute ranges; zero habits	—
Trial	1 day, $30	✅ Freezes on ropes status ✅ Slow starter status; Composure range	100% for listed habits
Hard sparring (internal)	2 days, $80	✅ Drops right after jab ✅ Fades late	70% per listed habit
Outside sparring	3 days, $200	✅ Above two + Head down inside	90% physical habits; 40% Freezes
Test day	1 day, $150	✅ All habits — full list with triggers and punishments	100% complete
Actual bout	Fight result risk	✅ Any habit that triggers → permanently revealed afterward	100% for triggered habits
Rule: Once a habit is revealed anywhere — Trial, sparring, bout — it appears everywhere that fighter is listed (roster, opponent file, scouting list). It never re-hides.
4. What You Actually Do With It — The Decisions
4.1 Signing Decision
Every prospect card shows:
Before reveal: "Habits — unknown. Evaluate to see risks"
Partial reveal: only the rows that are known
Full reveal: complete table — habit name → what triggers it → which styles punish it → your plan answer
Choice: sign now blind, or pay to know first before committing to a contract
4.2 Matchup Decision — The Core Loop
Opponent file already shows: style, favoured range, weapons.
Add: Once your fighter's habit is known → the bout page explicitly flags:
⚠️ RISK — [Opponent Style] punishes [Habit Name]: triggers in [situation]. Consider a plan line that answers it or pick a different opponent.
Example:
⚠️ RISK — Counter-puncher punishes Drops right after jab. When you jab then reset, she slips and counters.
✅ Your answer: Plan line — After jab → Step back / feint then counter
Three choices when you see the risk:
✅ Take the bout → write the answering plan line; adjust pace to avoid the trigger situation
⏭️ Pass → pick a different opponent who does not punish the habit
📋 Accept with caution → know the risk; keep the habit in mind during corner calls
Without knowing the habit → that risk line never appears. You enter the fight blind — the habit punishes you and you learn it from the loss.
4.3 Training Mitigation (Weekly Choice — KNOWN ONLY)
Once a habit is known, the fighter's Week → What to Work On offers one specific mitigation option per habit — it does not remove the habit, but reduces its penalty while it is your active focus:
Table
Known Habit	Weekly Training Option	Cost / Trade-off	Effect (ESTIMATE)
Drops right after jab	Drill jab recovery	1 pad slot per week; 4–6 weeks to master	Penalty −50% when triggered
Slow starter	Opening 30s drills	1 morning session per week	First-round penalty −60%
Fades late	Round 3+ pace / conditioning blocks	Taper week intensity −1 tier	Fatigue trigger threshold +15%
Head down inside	Posture drills in clinch	Sparring focus 2 weeks	Inside penalty −40%
Freezes on ropes	Pressure simulation sparring	Needs partner; sparring cost +$80/week	Defence penalty −40%
Bites on feints	Feint reaction drills	Pad nights only; 6 weeks minimum	Feint success rate −30%
Rule: You can only work on ONE habit per fighter at a time. Progress bar shown on the habit card. If you stop drilling it — progress pauses; partial progress stays. Penalty reduction is permanent once fully drilled — no ongoing cost after completion.
4.4 Plan Integration
Playbook → Game Plan adds a dedicated row per known habit:
When [habit trigger happens] → [answer line]
This line becomes available ONLY after the habit is known
The line behaves like any other plan line — it uses mastery, adapts with repeat use, and appears in your coach's notebook after the bout.
4.5 Late-Developed Habits
New category: Emerging Habits — appear only after a fighter reaches 15+ bouts / 12+ months active. These represent accumulated ring habits or ageing effects. They start unknown and reveal gradually through bouts — no Test Day can find them early.
Table
Emerging Habit	Trigger	Revealed	Mitigation
Late-round drop-off	From round 4 onward; stamina drain accelerates	Revealed only in bouts past round 4	Endurance blocks; conditioning focus
Hesitates behind	Behind on points / losing rounds → output drops	Revealed after 3+ losses on cards	Confidence talks; pace adjustment
Design Goal: Extends the knowledge lifecycle — even fully scouted veterans still carry things you learn over time.
5. Probe Spec — Keep & Update
Goal: Measure whether paying for information actually delivers better outcomes across identical pools
Pass Lines (TARGETS):
READ-FIRST beats BLIND by ≥4% in top-10 finish rate
ORACLE beats BLIND by ≥8% in top-10 finish rate
Setup:
3 groups — identical prospect pool, same bouts, same opponents
BLIND — sign zero info; learn only from losses
READ-FIRST — Test Day every prospect before signing (+$150/signing; slower pipeline)
ORACLE — all habits visible from day one (perfect information — upper bound benchmark)
150+ worlds; 4 seasons each; same 12-contract roster; same matchmaking bot logic across all groups
Metrics tracked: top-10 finish rate; losses attributed to known/unknown habits; win rate when habit risk flagged vs not flagged; cost vs profit per season
Numbers in v1 (41.3%, +$2,150, etc.) moved to TARGETS table — replaced with live probe output when available.
6. Menu Wiring — What Appears Where
Table
Menu	What It Shows	Wired To / Action Opens
Roster — fighter card	Habit icon (Lucide: ⚠️ / ✅ / ❓) next to name; hover shows known habits only	Click → Fighter page → Habits tab
Fighter page → Overview	Section: Known Habits — list, triggers, punishments	Open Plan → adds answering line; Open Week → mitigation training
Fighter page → History	Bout result lines: "Loss caused by [Habit] triggered in round X"	Opens habit detail card
Scouting / Prospect card	Row: Habits — Unknown / Partial / Known	Trial / Test Day buttons → run reveal action then refresh card
Bout offer page	Risk banner when opponent style punishes a known habit	Write plan line / Pass bout
Fight prep → Plan	Available answer lines expand as habits become known	Plan lines save to plan; locked lines: "Requires more knowledge"
Week → What to Work On	Mitigation option appears for each known habit	Assign to pad/morning session; progress bar updates weekly
Post-bout recap	Newly revealed habit: "You discovered [Habit] — triggered in round X"	Add to plan / Set training focus
Opponent file	Only opponent habits that YOUR scouting reveals — never free	Scout → may reveal opponent habits too (same reveal rules)
Icons used: ❓ Unknown / ⚠️ Known risk / ✅ No known habits — all Lucide line icons per scripts/ui/Icons.gd. No emoji. Names only in headers.
7. Rules Kept From Owner Agreements
Information never opens automatically — you always choose what to pay for and when
No flavour text — plain words: trigger, punishment, answer, cost
Knowing is not fixing — knowledge creates choices, not immunity
Attributes and habits remain separate systems — one is ability, one is tendency
The Why screen already records what went wrong — habit reveals extend that system, do not replace it
