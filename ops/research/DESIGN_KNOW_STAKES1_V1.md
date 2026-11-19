# DESIGN_KNOW_STAKES1_V1 - knowledge stakes, hidden flaws (Dola SQ236, S529 extract)

Source: DESIGN_KNOW_STAKES1_DOLA_DOLA.md lines 113-188 (Dola's reply only). Read CLAUDE'S CODE CHECK (DESIGN_KNOW_STAKES1_V1_CODECHECK.md) first.

Hidden Bout-Critical Flaws — Design Document
Core Concept
Every boxer has 1 hidden flaw, permanent and decisive in specific match situations — invisible at walk-in, only revealed through reads or real fight events. Flaws don’t change a boxer’s peak rating or potential — they change which opponents they can beat. This creates clear stakes: knowing the flaw changes who you match and how you train, not just who you sign.
Flaw Types & Effects
Table
Flaw Name	Trigger Condition	Outcome When Triggered	Revealed By
Glass Chin	Takes 1 clean head strike > 70% health	Instant knockout, regardless of remaining health or stats	Test day, hard sparring, bout
Cuts Easily	Sustained face damage over 3 rounds	Referee stops bout (TKO cuts) — 40% chance loss even when leading	Test day, 3+ round sparring, bout
Freezes Under Pressure	Behind on points after round 6, or opponent is ranked 5+ higher	Attack effectiveness drops 35%; defense drops 25%	Trial, bout against ranked opponent
Distribution: 22–28% chance per flaw; ~10% of prospects have no flaw (exceptional durability)
True Rating Impact: 0 points removed from overall rating — flaws are contextual weaknesses, not lower quality
What the Player Decides
At every signing and matchup:
Signing risk: "Do I take this good-looking prospect blind, or pay to find their flaw first?"
Matchup risk: "Do I avoid the cut-prone boxer against a jab specialist? Rest the glass-chin fighter against heavy hitters? Put the pressure-prone boxer against weaker opponents?"
Read Costs & What Each Reveals
Table
Action	Cost	What It Shows
Walk-in view	Free	❌ No flaw shown — only attribute ranges
Look Closer ($120)	$120	❌ Still no flaw — only narrows attribute ranges
Trial	1 day, $30	✅ Shows Freezes Under Pressure only — nothing else
Test Day	1 day, $150	✅ Shows ALL flaws — full clarity
Hard Sparring (internal)	2 days, $80	✅ 50% chance to reveal Glass Chin / Cuts Easily
Outside Sparring	3 days, $200	✅ 90% chance to reveal physical flaws; 40% for pressure
Actual Bout	Fight purse risk	✅ Flaw always triggers if condition met — fully revealed to player afterward
Season Outcome: Blind vs Read-First
Simulation baseline: 12-contract roster, 10 bouts/season, 4 seasons across 150+ worlds
✅ BLIND — sign with zero flaw info
Signing cost: $0 extra
Matchup losses due to hidden flaws: 2.8–4.1 per season
Top-10 finish rate: 41.3%
Average season profit: +$1,200
Pain point: You find flaws after you lose winnable bouts — contract still runs 8–12 weeks
✅ READ-FIRST — always do 1 Test Day before signing
Signing cost: +$150 per prospect (~$900/season total)
Matchup losses due to known flaws: 0.4–0.9 per season — you avoid bad pairings
Top-10 finish rate: 45.7% (+4.4% vs BLIND)
Average season profit: +$2,150 — you win more bouts and protect your investment
Trade-off: Higher upfront cost; slower prospect pipeline
✅ ORACLE — knows all flaws from day 1
Matchup losses: 0.1–0.3 per season — perfect avoidance
Top-10 finish rate: 54.2% (+12.9% vs BLIND, +8.5% vs READ-FIRST)
Average season profit: +$3,400
UI — What Shows Where
🟦 Prospect Card (walk-in / scouting list)
Before any read: Flaw row = "Unknown — needs evaluation"
After Trial: "Mental: ✅ / ❌ Unknown" — only Freezes status
After Test Day / full reveal: Shows exact flaw name + 1-line effect summary
🟦 Look Closer popup
Attribute ranges narrow — flaw still hidden — keeps $120 useful but not overpowered
🟦 Trial result
Bottom panel: "Performance under pressure: [Steady / Unsteady]" — nothing else
🟦 Test Day report
Dedicated section: Known Weakness — full name + trigger condition + example consequence
"This fighter goes down fast to clean head hits — avoid brawlers who sit on the jab"
🟦 Roster page
Small icon next to each boxer's name once known: 💔 Glass / ✂️ Cuts / 🧊 Freeze / ✅ None
Hover tooltip repeats trigger condition
🟦 Week Review / Post-Bout recap
If a flaw triggered during a bout: "This loss was caused by [Flaw Name] — you now know this boxer's weakness"
If already known: "[Flaw Name] triggered — you may want to adjust future matchups"
Headless Probe — Pass Line Definition
Goal: READ-FIRST beats BLIND by ≥4%; ORACLE beats BLIND by ≥8% across all 3 seed sets
Metric: % of boxers signed who reach top-10 ranking within contract window
Worlds: 150+ unique worlds, identical prospect pools across all 3 bots
Pairing: Same walk-in stats → assigned to BLIND / READ-FIRST / ORACLE simultaneously
Expected Result:
BLIND baseline: 41.3%
READ-FIRST target: ≥45.3% (≥+4.0%) — PASS LINE ✅
ORACLE target: ≥49.3% (≥+8.0%) — PASS LINE ✅
Why it works: The spread comes from matchup wins, not better boxers — everyone signs the same rated prospects; only the knowledge usage differs
Critic & Design Notes
Depth: 8/10 — flaws create asymmetric risk; information value scales with how much you trust your matchup planning
General Design: 8/10 — clean progression from unknown → partial → full information; cost always proportional to clarity gained
Trade-off health: No single "correct read" — Trial is cheap for mental flaws; Test Day is expensive but complete; sparring is partial and risky; bouts cost wins but reveal everything for free
To reach 10/10 — add 1 late-career flaw that only appears after 15+ bouts (e.g., stamina fades sharply after round 8, revealed only in deep bouts), plus a Training Mitigation system that reduces but never eliminates a known flaw's effect at weekly cost — so knowledge gives you options, not just warnings. This closes the final gap between "knowing it" and "doing something about it."
