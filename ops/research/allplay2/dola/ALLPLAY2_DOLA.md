[message 76 of this playtest]
ALLPLAY2_DOLA.md — FightCamp Full Playtest Report
✅ Verdict
Overall result: 0–4 across four bouts — every bout was close on the cards (26–30, 27–29, 28–29 twice), but consistent patterns of overcommitting and feint vulnerability cost each one. Tells gave a measurable edge but were undermined by fake tells and poor range discipline. The mechanics are solid and learnable; my decision-making and adaptation lagged behind the information available.
⚠️ NOT SURE / UNRESOLVED
Fake tell detection rate: I could not reliably distinguish genuine tells from fakes — The Jabber's rear-shoulder-drop was fake 3/6 times in R2, Bout 1 — no clear secondary tell existed to cross-reference.
Clinch timing window: Exact distance/beat requirements for clinch success were not explicitly documented — I guessed wrong at Long range (Bout 4, R3, beat 1) and wasted critical recovery options.
Stamina cost structure: It's unclear whether missed punches, blocked punches, or retreats carry different stamina costs — I ran low in Bout 4 without understanding exactly why.
Counter-punch priority: Feint→punch sequences consistently beat my guard reset — no clear rule for when "don't bite" vs. "cover anyway" is optimal.
2 — FUN: Point-by-Point Evidence & Judgement
Table
#	Criterion	Bout/Round/Beat	Observation	Rating
F1	Tells feel meaningful and readable	Bout 1 R1 beat 1; Bout 2 R1 beat 1	Front-foot creep → step-in was 100% true; knee bend → body attack was 100% true in Bout 2 R1	✅ Strong
F2	Fake tells create interesting mind games, not frustration	Bout 1 R1 beat 3, 4, 6; R2 all beats	Rear shoulder drop faked 3–4 times per round without clear warning → felt cheated, not challenged	⚠️ Mixed
F3	Each opponent has a recognisable, learnable style	Bout 3 all bouts; Bout 4 R1	Jabber = range → body hook → overhand; Body Snatcher = feint→step→body cross → clear pattern in hindsight but learned too late	✅ Strong
F4	Clinch is a meaningful survival tool, not a panic button	Bout 3 R3 beat 6; Bout 4 R3 beat 3	Clinch saved me repeatedly at Inside; useless at Long/Mid — range rule creates real tactical tension	✅ Strong
F5	Mistakes feel like my errors, not system gotchas	Bout 4 R2 beat 4; Bout 3 R3 beat 5	Stepped into feint every single time; dropped guard for the uppercut combo — 100% my reads, not the game	✅ Strong
F6	Comebacks feel possible even when hurt	Bout 4 R3 beat 2→3→4→5→6	1 HP → knockdown → survive 4 straight beats on the ropes — genuine tension, not a foregone conclusion	✅ Strong
3 — SCORES (1–10)
Table
Category	Score	Notes
FUN	7/10	Tells and opponent patterns work great; fake tells without cross-cues create frustration that slightly undermines the read-and-react loop
DEPTH	8/10	Range management + tells + stamina + clinch timing + feint discipline = genuine depth; multiple valid approaches exist (pressure vs. counter vs. survive)
CLARITY	6/10	What happened is always clear; why some tells were fake vs. true was never explained; clinch/stamina rules opaque until learned through failure
VARIETY	8/10	Two distinct opponents with multiple sequences each; tell system changes per round; damage state changes decision-making dramatically — never felt repetitive
Could NOT judge from text alone: Visual feedback timing, animation readability, UI clarity during high-pressure sequences, controller/input feel — all critical to actual in-the-moment decisions but absent from text simulation.
4 — TO REACH 10/10: Concrete Changes (Priority Order)
Each fix tied directly to a specific beat where it would have changed the outcome:
🥇 1. Add secondary "tell reliability" cue or fake-pattern learning
Where needed: Bout 1 R2, all 6 beats — rear shoulder drop faked 4/6 times with zero distinction
Change: Give fakes a subtle difference (timing delay, foot position) OR track "this tell has been faked X% against this opponent" across rounds so players can learn the bluff
Impact: Stops "information that's wrong" from feeling like bad design; turns fakes into a readable skill check
🥈 2. Explicitly teach/remind clinch range requirement once
Where needed: Bout 4 R3 beat 1 — wasted critical recovery beat trying to clinch from Long range
Change: One-time UI tooltip or tutorial: "Clinch only works at Inside range — step in first"
Impact: Clinch becomes a usable planned option, not a remembered guess; survival rounds become strategic instead of panicked
🥉 3. Show opponent stamina visibly
Where needed: Bout 2 R1 beat 3 — Body Snatcher at 1/8 stamina but I couldn't tell; kept backing off instead of pressuring
Change: Stamina bar visible above health
Impact: Creates clear windows to press vs. conserve; rewards tracking the full fight state, not just current beat
4. Add a "feint→punch" distinct animation/tell
Where needed: Bout 4 R3 beat 2 — identical setup for feint vs. real body cross; got dropped on the exact same sequence twice
Change: Feint = shoulders move first but hips stay; real = everything moves together — one consistent difference
Impact: Feints remain dangerous but readable; stops the "I know this is coming and still can't stop it" losses
5. Add beat summary recap between rounds
Where needed: Bout 3 R3 — didn't realise "backing off less" won R2 on cards; adjusted strategy wrong for R3
Change: Between rounds: "You won Round 2: landed more clean punches, backed off less"
Impact: Players can adjust tactics during the fight, not just after reviewing the full log
REPORT END

## THE OWNER'S QUESTION (follow-up message, S563 - the driver's report prompt had not asked it)
(a) WHOLE PLAN SHOWN BEFORE YOU CHOOSE
Verdict: Too much information removes the core tension — turns boxing into simple counter-picking, not reading and timing.
Proof: Bout 1, Round 1, beat 2 — I saw "Lead hook, Back off, Cross" and would have just picked Block → every beat becomes a solved puzzle, no risk, no reading skill involved. You win by looking at the answer key, not by learning your opponent.
(b) ONE BODY TELL, MOSTLY TRUE, ONE LEARNABLE LIE PER OPPONENT
Verdict: Best balance — readable enough to feel skilled, occasional fake keeps you honest and creates genuine mind games.
Proof: Bout 2, Round 1, beat 5 — "bends knees" told me body attack coming, I acted on it and landed clean. Bout 1, Round 2, beat 1 — same tell was faked once that round; after that I learned to watch when he used it and adjust. The fake wasn't random — it was a pattern I could actually figure out.
(c) AS IT IS NOW: LAST THREE BEATS + HAND HISTORY ONLY
Verdict: Too little information — forces you to guess more than deduce; feels like you're playing the deck, not the fighter.
Proof: Bout 4, Round 3, beat 2 — I had his last three beats ("Feint→Step→Body Cross") but zero early warning it was coming again. Same sequence dropped me twice in one round — I could see what he just did, but nothing about what he was about to do. Pattern-spotting felt rewarded but the gap between "what happened" and "what's next" was too wide.
✅ MY PICK: OPTION (b) — ONE TELL, MOSTLY TRUE, ONE LEARNABLE LIE
It gives you a genuine read to act on, but the one fake per opponent means you can't blindly trust — you have to watch him, not just the signal.
For it to work: the fake tell must follow a consistent rhythm — never random — so over 2–3 rounds you can actually learn when he bluffs rather than just feeling tricked.
SCORES — NO TELLS vs WITH TELLS
Table
Category	NO TELLS (Bouts 3+4)	WITH TELLS (Bouts 1+2)
FUN	6/10	8/10
DEPTH	5/10	8/10
CLARITY	5/10	7/10
VARIETY	7/10	8/10
NO TELLS: You're fighting a memory of what just happened, not a live opponent — every beat feels like starting over, patterns exist but you can't spot them in time to matter.
WITH TELLS: Every round builds — you learn what's real, what's fake, and that progress makes every successful read feel earned, every fake seen through a small victory.
OWNER QUESTION END
