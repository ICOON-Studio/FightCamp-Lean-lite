# G97 - How a fight broadcast tells the story (Grok, Expert, collected S75 2026-09-25)

Source chat: https://grok.com/c/ba54966c-fe45-4d29-92fe-2bf037a60b6b . Brief: `G97_BRIEF.md`. Saved verbatim (tables
flattened to tab-separated rows by the page's innerText; "133 sources" listed in the chat UI). Research only - real
athlete names below never enter shipped data.

---

WHAT A HUMAN WOULD DO

Director owns the air. EVS/LSM operators clip every camera in seconds and offer angles (“EVS 3, what do you have?”). Director picks one or two and calls “Replay — Video 1 in.” Producer owns story, rundown, commercial holes, and when graphics go up. Graphics desk (Chyron / Vizrt) punches the stat card the producer called. Nothing airs without the director. Cue hierarchy: knockdown / finish / foul / cut / big exchange / crowd spike. Clips are cut short because the rest is 60 s and the corner, unofficial card, and ads compete for the same window.⁠Thebackroomstaff

1. BETWEEN ROUNDS
Claim	Tag	Source
Official rest is 60 s (pro boxing, UFC, ONE MMA/MT)	SOURCED	sportsmonkie.com/how-long-are-boxing-rounds/; onefc.com martial-arts rules
CompuBox feed: total thrown/landed + %, jabs thrown/landed + %, power thrown/landed + %, plus/minus; body vs head added later	SOURCED	en.wikipedia.org/wiki/CompuBox; grokipedia.com/page/CompuBox; boxingscene CompuBox 40th
Typical on-air line shape: A 50/200 (25%) plus parallel jab and power rows	SOURCED	grokipedia CompuBox (“Fighter A: 50/200 (25% landed)… jabs 30/100, power 20/100”)
Stats reach the truck within seconds of the bell; operators recheck vs slo-mo	SOURCED	grokipedia CompuBox
CompuBox is a barometer, not a scorecard	SOURCED	boxrec.com/wiki/Compubox
UFC between-round / post-round stack: sig strikes L/A, TD L/A, control time; target (head/body/leg) and position (distance/clinch/ground) exist in UFC Stats	SOURCED	agentmma.com significant-strikes + control-time explainers; sportradar UFC detailed-results
How many discrete numbers on one live card	NOT FOUND (exact house spec). Observed pattern is 6–12 cells (2 fighters × total/jab/power × L/T/%)	JUDGEMENT from CompuBox graphic description
How many seconds the card stays up	NOT FOUND	—
How many replays fit in the 60 s break	NOT FOUND (no fight-sport house number). Tennis analog: 12 s window ≈ 1–2 replays, 25 s ≈ 2–4; Sky boxing: clips kept “pretty short” because time is the constraint	tvbeurope.com Bren Hester; svgeurope.org Sky Cardiff UHD
NY boxing IR review tries to finish inside the 1-min rest; +30 s optional	SOURCED	dos.ny.gov instant-replay-policy-boxing
Some telecasts take ads in the minute; others stay live on corner + replay + graphic	JUDGEMENT	mixed practice; no single rule found
Canobbio floated a future 30 s “every landed punch” package between rounds — not current standard	SOURCED	boxingscene CompuBox turns 40

Usable card (implement this, do not invent more fields):

Boxing: Total L/T/% · Jab L/T/% · Power L/T/% · Body landed (if tracked).

MMA: Sig L/A · TD L/A · Ctrl time · KD. Target split only if one target dominates.

Cap: 8 numbers on screen. One card. Do not stack CompuBox + UFC target + control on the same plate.

2. HIGHLIGHTS
Claim	Tag	Source
Director selects; EVS offers; producer can request a story clip; director still approves	SOURCED	thebackroomstaff.com Rodrigo Besteiro EVS; jobdescription.org UFC Broadcast Producer
UFC producer brief: serve KO / submission / tactical clip within seconds	SOURCED	jobdescription.org UFC Broadcast Producer
Combat coverage kit includes a dedicated high-fps replay camera	SOURCED	creativebroadcast.ae indoor-sports guide
Selection cues in use: knockdown, finish sequence, cut, big exchange, missed live angle	SOURCED	Bad Left Hook Rick Tugman (cuts); UFC producer JD; EVS interviews
Crowd reaction used as a production cue	NOT FOUND as a written rule. Used in practice as a director ear	JUDGEMENT
How many replays per round on a fight broadcast	NOT FOUND	—
Clip length in seconds	NOT FOUND. Operators describe clips as short so more than one can air	Sky SVG; tennis EVS
Slo-mo is default on strikes / KO / submissions	SOURCED	UFC 2007 TV Tech EVS; Sky 400 fps trial; EA/real-TV parallel
In-show post-fight highlight package length	NOT FOUND. Adjacent: UFC live post-fight show is ~1 h; DAZN YouTube highlights drop ~15 min after the bout	workinsports Becker; tomsguide Usyk-Fury 2
Social / VOD highlight videos commonly 3–15 min	JUDGEMENT from DAZN/UFC YouTube practice, not a truck spec	daznboxing channel analysis

Selection rule to implement (JUDGEMENT, scored from cues above):

Score a moment: KD/finish 10 · near-finish / ref look 7 · 3+ unanswered clean power 6 · momentum swing (lead change or first TD that sticks) 5 · cut opened 4 · crowd spike with a landed shot 3.

Keep top 1–2 clips per round. Each 4–7 s live or 6–10 s slo-mo. Post-fight reel = those clips + the finish, 25–45 s, not a second fight.

3. THE WHY — one-liners (real), by type
#	Line	Type	Backing stat	Tag
1	“Joshua landed 8 of 21 jabs per rnd (35%), controlling the 39-yr old Pulev.”	Distance / jab	Jab L/T %	SOURCED CompuBox @CompuBox Joshua-Pulev
2	“Spence has thrown 234 jabs but only landed 28.”	Failed jab	Jab accuracy	SOURCED Showtime Spence-Crawford call
3	“Accuracy is power — Crawford landed 52% of his punches in this round.”	Accuracy	Connect % this round	SOURCED same broadcast
4	“He’s outworking Rocky Juarez… winning on sheer volume of clean, effective punches.”	Volume	Thrown + landed	SOURCED John-Juarez II HBO
5	“John threw 120 punches… landing 31.”	Volume this round	Thrown/landed	SOURCED same
6	“99 of Cruz's 248 landed punches were body shots.”	Body work	Body landed	SOURCED CompuBox Cruz-Fierro
7	“42% of his landed punches were body punches.”	Body share	Body / total landed	SOURCED Barboza-McComb CompuBox
8	“Butaev landed 140… 64 of which were to the body.”	Body work	Body landed	SOURCED CompuBox Stanionis-Butaev
9	“Won by the more efficient & accurate Stanionis, who landed 42% of his power punches & 7 jabs per round.”	Efficiency	Power % + jab/rd	SOURCED same
10	“Jab controlled the distance” — Royval “probes with his jab… uses his reach to keep the younger man at bay.”	Distance	Reach + jab volume	SOURCED Sherdog Van-Royval R1
11	“Working downstairs trying to get to the body.”	Body	Body attempts	SOURCED Spence-Crawford Showtime
12	“The body shots made a huge difference.”	Body as plan	Body landed + TD defense	SOURCED ESPN MMA Yan-Merab desk
13	“He holds the center… sprawls and brawls.”	Cage generalship	TD defense / center time	SOURCED same
14	“Two for 29” (takedowns).	Grappling fail	TD L/A	SOURCED same
15	“Bell-to-bell a masterpiece.”	Control / shutout	Rounds + ctrl	SOURCED UFC 322 Makhachev-JDM call
16	“286 total strikes, 286 ground strikes, 4 takedowns, 13:11 ground control.”	Ground control	Ctrl + ground strikes	SOURCED @ufc post
17	“Chimaev 21:40 control… 529 total strikes but only 37 significant.”	Control ≠ damage	Ctrl vs sig	SOURCED agentmma Chimaev-DDP
18	“See all those calf kicks are starting to take.”	Accumulated damage	Leg strikes	SOURCED UFC 320 commentary clip
19	“I think DDP used round three as an active rest round.”	Pace / tank	Output drop vs prior rds	SOURCED Cageside DDP-Izzy desk
20	“Wardley’s power accuracy 44.2% vs Parker’s 33.5%.”	Power quality	Power connect %	SOURCED Independent Wardley-Parker
21	“Chris John 38/118, Juarez 21/72. John’s 24 power connects, high for him.”	Round snapshot	Power landed this rd	SOURCED John-Juarez II
22	“Crawford 42/139 jabs, Jean 7/81 through 4.”	Jab gap	Jab L/T	SOURCED Crawford-Jean HBO
23	“Just the wherewithal to go to the body and the discipline to stay with that approach.”	Body plan	Body damage visual	SOURCED EA UFC 5 commentary (game, mirrors TV idiom)
24	Producer data used to back a line	SOURCED	CompuBox / UFC Stats / unofficial card / replay	grokipedia; usbets Canobbio “we send a signal to DAZN or Fox or Showtime or ESPN”

Caption templates (stat that fires them):

Template	Trigger
{Name}’s jab owned the distance	jab landed lead ≥ +6 or jab acc ≥ +10 pts
Body work is slowing {Name}	body landed ≥ 8 this rd or body share ≥ 35%
Volume round — {Name} outworked him	thrown lead ≥ +15 and landed lead ≥ +5
Cleaner punching, not just busier	connect % lead ≥ +8 with landed lead
{n} minutes of control, little damage	ctrl ≥ 2:00 and sig ≤ 8
Takedown never stuck	TD att ≥ 4 and TD landed 0–1
Calf kicks compounding	leg strikes landed ≥ 8 this rd
First real hurt of the fight	KD or stun flag
Active rest round	output ≤ 60% of that fighter’s prior-rd mean
He held the center and made him miss	TD def high + sig absorbed low

One line per break. Never two claims.

4. PRIOR ART IN GAMES
Game	What it does	What worked	What players hate	Tag
Football Manager	Key / Extended / Comprehensive / Full / Dynamic (more clips if score is tight)	Layered density; skip + speed; result already computed	Key shows throw-ins; Extended 15–20 min of dead time; Comprehensive still drops attacks; full vs key can feel like different tactics	SOURCED SI forums FM26; Reddit FM; @Tumini_Ball; @ItsAdamFM
EA UFC 5	Cinematic KO replay (slo-mo, custom cams, audio swell); walkout/presentation package; commentator damage callouts	Finish feels like TV; skippable presentation	Replay cams clip through cage; rest of broadcast layer thin; career presentation repeats	SOURCED ea.com UFC 5 presentation; IGN; Dexerto
Fight Night Champion	Multi-angle KO replay, close-up of the finishing punch	Still the bar for “the punch”	Series ended 2011; no modern between-round card	SOURCED Wikipedia FNC
Undisputed	Instant multi-angle KO replay (incl. online if both on)	Players praise the replay vs EA’s locked package	Rest of broadcast thin; hit-detect complaints drown the feature	SOURCED FandomWire; Undisputed YT “Online Instant Replays”
Punch Club	Auto-sim fight; swap skills only between rounds; watch the whole thing	Prep → result loop	Fights are a spectator slog; no meaningful skip; “ok, enough already”	SOURCED Nintendo Life; COGconnected; Steam reviews
Boxing Manager / MMA Manager apps	Sim + corner prompts; compare engine vs result	Fast; stats-first	Watch layer is optional text, not TV	SOURCED App Store listings

Pattern: players skip the watch layer if it repeats or if the highlight picker is wrong. They keep it if (a) the clip is the actual turning punch and (b) skip never voids the result.

5. SKIP AND PACING
Claim	Tag
FM: skip-to-next-highlight, 1×–8× between clips, instant full-result; Dynamic reduces clips when the match is dead	SOURCED SI community FM26
EA UFC / FNC / Undisputed: button-skip the KO replay; result already locked	SOURCED presentation writeups
Punch Club: no first-class skip of the sim watch; players asked for it	SOURCED reviews
Formal “broadcast layer skip without losing result” design doc for a fight game	NOT FOUND

Controls to copy: result is computed before the first frame of the package. A skip this clip. Hold A skip the rest of this break. LT/RT 1× / 2× / instant. Key / Extended / Off. Off still shows the one-line caption + score.

VERDICT — broadcast-layer spec

Break budget (60 s wall, player-facing ~12–20 s at 1×):

0–2 s bell + score · 3–5 s stat card (≤8 numbers) · 4–14 s one or two replays · 2 s caption · remainder skippable corner atmos.

Stat card

Boxing: Tot L/T/%, Jab L/T/%, Power L/T/%. Optional 4th row: body landed.

MMA: Sig L/A, TD L/A, Ctrl, KD.

Never both sports’ full sheets. Card dies when the first replay rolls.

Highlight picker

Score moments as in §2. Ship max 2 per round, 1 if the round was quiet. Clip 4–7 s (or 6–10 slo-mo on KD/finish only). Post-fight package = ranked clips + finish, ≤45 s. No third angle unless it is a KD.

Caption

Exactly one template from §3. Fired by the trigger stat. If two triggers tie, prefer damage (KD/body/stun) over volume.

Skip

Result first. Skip clip / skip break / 2× / Off. Off keeps caption + card numbers in the log. Do not make the player sit through Punch Club. Do not make Key highlights out of throw-ins — if the score is below 5, do not play a clip.
