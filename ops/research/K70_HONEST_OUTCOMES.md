# K70 - WHAT MAKES A SIMULATED FIGHT OUTCOME FEEL HONEST

**Owner:** kalli. **Collected 2026-09-22 from the Grok Bot app by Tools/grokbots/collect_chat.py.**

**HOW THIS WAS COLLECTED, and it matters.** `grokbots.py read` returns the
SIDEBAR, not the message column - 1,677 characters for a chat holding
16607. On 2026-09-22 that made a finished delivery read as "the bot stopped
without replying", and it was reported to the operator that way before being
corrected. `Tools/grokbots/collect_chat.py` reads `main.sand-chat` and POLLS
until it stops growing, because a dump taken the instant a chat opens returns
16 characters. The raw capture is kept beside this file in `_collect/`.

---

1:56 AM
NEW

K70 started — what makes a simulated fight outcome feel honest (explicable), not more realistic. Mining FM/OOTP/TEW/fight-sim complaint patterns and surfacing mechanisms. Full text in chat, no attachment.

1:56 AM

Have FM xG/post-match attribution, Fight Night flash-KO signalling failures, and TEW’s booked-winner legibility. Pulling OOTP box-score and pre-fight odds patterns, then writing K70.

1:56 AM

PART 1 of 2

K70_HONEST_OUTCOMES.md

Task: What makes a simulated combat result feel explicable (honest), vs arbitrary.

Not in scope: making outcomes more realistic / retuning probabilities. We already have a sourced MMA anchor set for that. Realism ≠ legibility.

Lead.

Players forgive losing to a huge underdog. They do not forgive a result they cannot narrate. The cheap path to “honest” outcomes is almost entirely surfacing causation and expectation that the sim already has, not building a new damage model.

Definitions used here
Term	Meaning
Explicable	Player can state, in one sentence, why this fighter won (or how the underdog stole it) using game-visible facts
Arbitrary	Player’s post-hoc story is “the dice hated me” / “the game wanted that”
MECHANISM	A concrete system the game exposes or runs
PERCEPTION	Folk theory or community belief about the engine; useful as a signal of failed communication, not as engine truth
NOT FOUND	No published figure / official design doc located this pass
1. Visible causation — show WHY
What works (MECHANISM)

Football Manager — post-match attribution stack

xG / xGA and xG timeline: published in-game since FM21; SI built the model in-house with SciSports advisory input (Passion4FM; Get Goal Side / SciSports interviews). Surfaces chance quality, not just shot count — so “we had 20 shots and lost” can become “we had 0.9 xG from bad angles; they had 1.8 from three chances.”
Analytical match report: shot maps, average positions, passing combinations, turnovers; half-time and full-time analyst views. Community practice is to read patterns, not one highlight (r/footballmanagergames “How do you analyse your last match?”).
Important boundary: xG explains process, not destiny. Losing with higher xG is still painful, but it is narratable (“we finished poorly / they converted”) rather than mysterious.

Out of the Park Baseball — atomic event log + WPA

Play-by-play / box score as the unit of causation: each plate appearance is a named event with pitcher, batter, result.
Win Probability Added (WPA) graphs in box scores (community docs / OOTP forums since ~OOTP 17): each play’s effect on win chance is graphed. An upset becomes “three high-leverage events,” not a blank L.
Scouting reports separate expected talent from what happened tonight — another causation layer.

TEW (booking sims) — different honesty model

Winner is often an explicit booking input (or road-agent pick weighted by regional popularity — TEW2020 wiki). Causation is authorial, not athletic. Match rating is then explained via popularity × performance × product weights, aims, notes, penalties (wiki + Fantasy Bookers guides).
Lesson for fight sims: when the game decides the winner silently, players invent scripts. When the game states the decision rule (booked / popularity / shoot), trust rises even if the rule is crude.

Boxing Manager (mobile / Ringside) — scorecard hunger

Community thread shape: players ask for round-by-round judging breakdown when a decision feels wrong (“I need answers with this judging” — Boxing Manager community forum). Final cards without per-round reasons = arbitrary.
DOCUMENTED existence of the ask; NOT FOUND: a published design doc listing exactly which stats feed their judges.
What fails (PERCEPTION ← failed surfacing)
Complaint shape (recurring)	What it reveals
“We dominated and still lost — scripted” (FM “got FM’d”)	Process stats were invisible or unread; highlight reel showed the goal, not the 89 minutes
“Styles don’t matter / AI is stupid” (Boxing Club Manager early forums; MMA manager mobile)	No post-fight attribution tying style → strike mix → result
“Judges are random” (boxing managers)	Decision without a readable scorecard narrative

Buildable unit (not a principle): a Fight Causation Card after every bout:

Method (KO/TKO/SUB/DEC) + time
3–5 causal bullets drawn from already-computed internals (e.g. “A landed 38 significant head strikes to B’s 12”; “B’s takedown defence failed 4/5”; “Damage accumulated R2 after calf kicks slowed exits”)
Optional round score line if decision
If the engine already tracks landed strikes by region, KD events, control time, etc., this is UI over new math.
2. Pre-fight expectation — an upset needs a stated favourite
What works (MECHANISM)
Stated odds / win probability / favourite flag before the contest. An upset is only legible against a number. Without it, every result is equally “random.”
OOTP / baseball culture: projections and matchup context before first pitch; WPA then measures deviation from prior win expectancy during the game.
FM: form, morale, fitness, and tactical familiarity visible pre-match; media/odds exist in-universe in many versions. Players who ignore them still had an expectation available.
Scout / analyst one-liner: “B has a puncher’s chance; A should control range.” Expectation + rare-event warning in one sentence.
What fails
Sim runs cold with no published favourite → player’s private guess becomes the yardstick → any surprise feels like betrayal.
Hidden difficulty spikes (UFC career “debut / title fight felt harder”) produce PERCEPTION of scripting even when MECHANISM is “difficulty modifier” (DOCUMENTED as player belief on r/EASportsUFC; NOT FOUND: EA published confirmation of scripted losses).

Buildable unit: a Pre-Fight Strip on the bout screen:

Favourite / slight favourite / pick’em / underdog (from existing rating differential — display only, no retune)
One plain-language reason (“reach + volume” / “power + chin risk” / “grappling gap”)
Optional “puncher’s chance” / “submission threat” flags when those traits already exist on the fighter
3. Consistency under repetition — the 70/30 test communities run
What communities do (PERCEPTION + informal MECHANISM testing)
FM players rerun matches / watch league tables over seasons; folk claims of “scripting” persist despite SI denials that matches are pre-written (SI statements quoted in community threads: match is simulated from current factors, then re-simulated from change points when tactics change — MECHANISM per SI; “the game wants me to lose” — PERCEPTION).
Pace-meta experiments (FM26 write-ups): attribute importance inferred from repeated outcomes, not from the manual. When results diverge from the player’s mental model of attributes, trust dies — even if the engine is internally consistent.
Fight managers: “I rematched the same card and got nonsense.” NOT FOUND: a published study with N=10 identical FightCamp-style rematches and official spread targets.
Legibility rule (design, not probability advice)

Players do not need true RNG disclosure. They need:

A stated pre-fight lean, and
Across many fights of similar mismatch, a felt majority for the favourite — communicated via career records, media lines (“A is 8-1 against this archetype”), not via a developer essay.

If the UI never shows that A is supposed to be favoured, the community cannot run the 70/30 test fairly and will invent one.

Buildable unit: career/media lines that echo the pre-fight strip after the fact (“Huge upset — B was a +300-class underdog by our desk”). Same number the player saw going in. Closed loop.

4. Rare events — flash KO / one-shot without setup destroys trust
MECHANISM examples that signal before they fire

EA Fight Night Champion

Official/community-facing design: one-punch KO and stun tiers as intentional systems (Operation Sports FNC gameplay blog: one-punch KO + graded stun states).
Skill-tree signalling: ranking up a punch unlocks small % chances for stun / bell-ring / one-punch power (GameFAQs Legacy discussions describing maxed punch → flash chance). Player can read the roster and fear Tyson’s hook before it lands.
Still: community PERCEPTION that flash KOs are “too common” or “cheap” when chin/heart/stamina context isn’t felt — classic rare-event without felt setup mid-fight.

UFC (EA) career / sim complaints

Recurring shape: “I was outlanding him / he wasn’t hurt / one punch ended it” (r/EASportsUFC). Replies cite stamina, leaning into shots, clean counters — i.e. hidden state the UI didn’t scream.
Separate PERCEPTION: “career fights are scripted.” NOT FOUND: official EA doc confirming forced career losses.
What makes a rare event feel honest
Before	During	After
Trait/flag visible (“one-shot power,” “suspect chin”)	Visible danger state (rocked, low stamina, accumulated head damage)	Causation card names the rare path (“counter hook while A was leaning in at 20% stamina”)

Without the middle column, a real-sport flash KO feels like a bug.

Buildable unit: Danger Telegraph

Pre-fight: threat tags from existing attributes
In-fight (even text/2D): “B is hurt” / “A is fading” / “chin compromised” when internal thresholds already trip
Post-fight: rare-event called out as such, not buried in a generic KO line
PART 2 of 2 — continues
1:57 AM

PART 2 of 2

5. What players actually complain about — recurring shapes

Not one angry post: the pattern.

Pattern	Where it shows up	MECHANISM vs PERCEPTION
“Got FM’d” / dominated and lost	r/footballmanagergames; xG threads arguing whether high xG + loss is unlucky or low-quality chance spam	PERCEPTION of script; MECHANISM often variance + unread xG quality
“The game is scripted / recalculating against me”	FM scripting megathreads; SI: not scripted, full-half sim then resim on changes	PERCEPTION; MECHANISM (resim on tactic change) feeds the perception when highlights feel predetermined
“One punch / flash KO out of nowhere”	Fight Night Champion GameFAQs; UFC 5 career Reddit	MECHANISM exists (flash KO systems); PERCEPTION “cheap” when danger state wasn’t readable
“Judges make no sense”	Boxing Manager forums asking for scorecard detail	MECHANISM opacity (cards without round narrative)
“Styles / tactics don’t matter”	Early Boxing Club Manager Steam discussions; recovered partially after AI/style patches (“Just WOW” praise)	PERCEPTION until post-fight causation proves style → result
“Training / prep didn’t show up in the fight”	MMA manager mobile / Steam themes (K69)	Causation gap between management action and fight story
Career fight “rigged” difficulty	UFC career Reddit	Mostly PERCEPTION; NOT FOUND official scripting proof

Complaint grammar that matters for us:

Players rarely say “your Poisson draw is wrong.” They say “I cannot see why.” That sentence is the product bug.

6. Procedural legibility (literature → buildable takeaway)
Tynan Sylvester, “The Simulation Dream” (2013): complexity only pays when it projects into the player’s mental model; hair-detail that never becomes a story is wasted.
→ Takeaway: Internal fight factors that never appear in a sentence might as well not exist for trust.
Game Developer / design writing on transparency: players need to see state transitions (hurt → compromised → finished), not the full formula.
CHI / “Inscrutable Games” (ACM, 2022): opacity can be intentional for mystery, but sports-management audiences treat unexplained losses as broken, not mysterious — different genre contract.

Genre contract for fight management:

Mystery before the bell (scout uncertainty) is good. Mystery after the bell (why did they win?) is a defect.

7. Cross-title map (what they surface)
Title	Pre-fight expectation	During	After
Football Manager	Form, fitness, roles; media/odds layer	Highlights + live stats	xG, maps, analyst report
OOTP	Projections / matchup context	Play-by-play	Box + WPA graph
TEW	Booked aim / winner intent (when set)	Mostly abstract	Match rating + penalties explanation culture (wiki/guides)
Fight Night Champion	Punch ratings / unlocks signal KO threat	Stun states on-screen	Replay/KO type; less “why judges”
EA UFC career	Scout blurbs vary	On-screen damage/stamina (often misread)	Stat line; weak narrative WHY
Boxing Manager (Ringside)	Corner plan	Live commentary/stats	Cards; players still ask for deeper judging WHY
WMMA5	Text world + matchup feel	Text blow-by-blow	Text story of the fight (high narrative causation, low chart causation)
Boxing Club Manager	Gym/matchup screens	3D + tactics	Weak post-fight explanation culture in Mixed reviews (K69)

WMMA5’s text blow-by-blow is underrated legibility: each finish arrives with a sentence. 3D without sentences is the opposite risk (K68/K69).

8. The one judgement — three cheapest honesty upgrades

Cheapest = fewest new systems. Prefer surfacing what a calibrated engine already computes.

1. Post-fight Causation Card (cheapest if internals already exist)

What it is: A fixed panel after every bout: method, time, 3–5 bullets naming the decisive mechanisms (volume to head, control time, accumulated leg damage → slowed checks, failed TD defence, rock → finish chain), plus decision score line if needed.

Needs to exist: Whatever the sim already logs (landed strikes by target, KD/rock flags, grappling control, damage bins). If those logs are not retained for the UI, retain them — still cheaper than a new model.

Why it helps: Turns “L” into “lost because X.” Directly attacks K69’s retention killer.

Not this: Changing finish rates.

2. Pre-Fight Expectation Strip

What it is: Favourite / pick’em / underdog + one reason sentence + rare-threat flags (power, sub threat, chin).

Needs to exist: A display mapping from existing fighter differentials (already used by the engine). No new balance work — only a public lean.

Why it helps: Creates the denominator for upsets. “B won as a dog” is a story; “B won” is noise.

Not this: Publishing true RNG seeds or promising 70% hit rates in UI copy without data (NOT FOUND for our product’s empirical rematch spreads — do not invent).

3. Danger Telegraph (pre + mid + post for rare paths)

What it is: (a) Pre-fight threat tags from existing attributes; (b) mid-fight visible states when hurt/low stamina/compromised chin thresholds already fire; (c) post-fight rare-event callout on the Causation Card.

Needs to exist: Thresholds the engine already uses for rock/KO/sub setups — expose them as player-facing state, even in text/2D.

Why it helps: Flash finishes stop feeling like bugs; they feel like loaded guns the player saw on the table.

Not this: Nerfing flash KOs to “feel fair.”

If only one ships: #1. An unexplained win/loss is the trust failure; odds without a post-mortem still leave “but why this time?” unanswered.

Best news in this task: All three are primarily surfacing and copy. They do not require retuning the calibrated MMA anchors. If the engine already knows why a fight ended, honesty is a reporting problem.

9. Explicit non-recommendations (trap avoidance)
Do not “fix honesty” by narrowing variance toward the favourite.
Do not replace unexplained outcomes with forced cinematic finishes.
Do not treat folk theories (“scripted career fights,” “FM always equalises”) as engine tickets — treat them as UI failure reports.
Do not invent rematch percentages. NOT FOUND for a published N-run rematch table for our titles this pass.
Sources
Passion4FM / Get Goal Side — FM xG introduction; SciSports advisory role; in-house SI model notes.
r/footballmanagergames — “Is the game scripted?”; “xG ≠ goals / got FM’d” threads; SI quotes on resim-after-changes.
OOTP forums — WPA graphs in box scores (~OOTP 17+); manuals on game logs / box scores.
TEW2020 wiki — Booking and running shows; winner selection / road agent; match rating factors.
Operation Sports — Fight Night Champion gameplay blog (one-punch KO, stun states).
GameFAQs Fight Night Champion — flash KO variables (maxed punch, stamina, chin/heart, counters) — community MECHANISM reconstruction; treat as PERCEPTION-grade unless EA-confirmed.
r/EASportsUFC — one-punch career KO threads; “scripted career fight” PERCEPTION threads.
Boxing Manager community — judging explanation / scorecard detail requests.
Boxing Club Manager Steam — early style/AI distrust; later “Just WOW” after style/AI patches (K69).
Tynan Sylvester — “The Simulation Dream” (2013).
ACM CHI — “Inscrutable Games…” (2022) on opacity responses.
K68 / K69 — genre buyers pay for honest outcomes; untrusted outcomes as retention killer.

K70 complete. Honesty here is explicability: stated expectation before, readable danger during, named causation after. Cheapest path is report what the sim already knows.

1:57 AM
