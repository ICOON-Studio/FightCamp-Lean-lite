# DESIGN_CLUBWEEK1_V11 - Dola's club week v11 (SQ220, 2026-11-18)

Source: ops/research/DESIGN_CLUBWEEK1_V10_REVISE_DOLA_DOLA_2.md lines 863-1045 (Dola's reply; her self-scores dropped - critics score it). Verify numbers marked ESTIMATE.

CLUBWEEK1_V11 — the club week, with the fight weeks inside it (S459, S520, 2026-11-18)
This version: answers every v10 critic point; replaces v10; only this document stands.
Scores targeted: DEPTH ≥7, GENERAL DESIGN ≥7. Numbers marked ESTIMATE where not yet measured in code/probe; MEASURED where confirmed.
Owner rules kept verbatim:
"Just rename it 'gym sponsorship', the club pays." Never mixed with Sponsor deals on Club > Money.
"Names only on the header" — no names in buttons/rows/tooltips.
"The player runs any gym with any boxers." No fixed pronouns.
Every menu the mechanic appears on, and what each is wired to.
"Only actionable information." Plain words; one word per concept.
"Deeper, not wider." A quiet week = one click.
Weight classes unchanged; females never spar males.
"Gym" = facility; "camp" = pro pre-bout preparation; amateur pre-bout = fight week.
1. Idea in five lines
The Club week is Monday's deal of scarce coach time: pad turns, film sessions, coached mornings, gym sponsorship, and one conversation per week.
Sell pad hours as classes — full or short — that's your main lever for extra cash. Bag nights are the cost: half mastery that evening.
Fight weeks come first: every one needs all 3 pad turns. A class on a fight week = someone goes short OR pays extra cover. The collision line shows this before you accept a bout.
Coached mornings now work as a real choice: shared mornings train the lowest ability both boxers need to improve — the one thing solo mornings cannot do. Solo still targets one fighter's weakest stat; each has a clear best time to use.
Loyalty drifts toward 60 — shortages, broken promises and sponsorship decisions move it. Quiet week = one click, nothing changes.
2. When it appears
1 fighter only: Week tab works exactly as built today — nothing changes.
Second fighter signs: new Club Week tab appears under Fighters. Home shows note: "Two fighters now share coach time → Open Club week". Guide strip updates once.
Quiet week: no shortages, no twists, no fight weeks, no sponsorship changes → page shows counters + rows + "Coach deals it — same as last week" → one click Continue.
Always hidden: single-fighter mode; tab only activates at second fighter sign-in.
3. Full mechanic design
3.1 Pad turns — the core unit
Definitions (one word per concept):
Pad turn: ~20 minutes of coach time drilling moves/combinations. 3 turns = 1 full pad hour. CODE: 1 turn ≈ 80 drill units; full hour = 240 units.
Pad night: 3 turns at full pads rate (2.1 mastery/hr — CODE).
Bag night: same cards run without coach supervision — 1.05 mastery/hr (CODE).
Film session: coach evening reviewing tape/planning — separate counter, never a pad turn.
Coach capacity — CHECK 1 (ESTIMATE until confirmed in code):
Table
Coach	Pad hours/week	Nights	Total turns	Film sessions/week	Coached mornings
Sessional (Luke)	2	Tue, Thu	6	2	2
Full-time (Marcus)	3	Mon, Tue, Thu	9	3	3
You (head coach)	1	Wed	3	2	4
Sessional total	3	—	9	4	6
Full-time total	4	—	12	12	7
Per-night rule:
3 turns per pad hour; 1 boxer per turn; max 1 turn per boxer per night.
Full class = 3 turns sold → that night runs as bag night for everyone affected.
Short class = 2 turns sold → 1 turn remains; row order decides who keeps it.
No pad hours on Friday in weigh-in weeks — weigh-in is Friday, fight Saturday (CODE).
Need/Want per week type:
Table
Week type	Want	Need	Notes
Ordinary	3	2	Standard 3 pad nights (CODE)
PEAK (pro 2+ weeks out)	3	2	2 sparring nights — no turns taken
Fight week (Taper)	3	3	All 3 turns required; film session included
Status words (colour reinforces, never alone):
OK — spare turns available
FULL — all needs met
BAG n — n evenings running at bag rate
SHORT n — n turns below Need; shown as "SHORT 1 · BAG 2"
Capacity table (sessional coach — 9 turns):
Table
Situation	Asked/Need	Result	Film used
Ordinary week, 3 boxers	9/6	FULL	—
1 fight week	9/7	FULL	1 of 4
2 fight weeks	9/8	FULL	2 of 4
Full class (Thu)	6/6	BAG 3	—
Short class (Thu)	7/6	BAG 2	—
Full class + 1 fight week	6/7	SHORT 1 · BAG 3	1 of 4
Short class + 1 fight week	7/7	BAG 2	—
4 boxers, ordinary	9/8	BAG 1	—
4 boxers + 2 fight weeks	9/10	SHORT 1 · BAG 3	2 of 4
Full-time coach (12 turns): full class + 1 fight week = FULL; 4 boxers ordinary = FULL. All ESTIMATE until CHECK 1 confirms capacity numbers.
Coach's deal order: fight-week boxers first, then row order. Drag to reorder — persists week-to-week. ⭐ toggle per row: "Never short" — guarantees full pad needs every week; display shows exactly who loses turns instead. Second toggle: "Rotate who goes short" — cycles the penalty row each week so no single fighter always absorbs downtime. Plain editing: drag turns between rows on the same night; swap film slots with ↔ button. Lock removed — priority + rotation protect fairly.
3.2 Classes — the money lever
Pricing — all ESTIMATE until MONEYFOUR2 runs:
Table
Option	What it costs	What you gain	When available
Full class	3 turns → bag night for that group	+$117; member target +4 (capped by premises; CODE max +6/wk)	Any free pad hour
Short class	2 turns → 1 turn remains	+$78; member target +2	Any free pad hour
Cover coach	$130 one-off; 3 turns at full pads rate	Fixes SHORT immediately	Only when SHORT — never otherwise
Pads volunteer	$120/wk ongoing; 3 turns at 0.8× mastery rate	Extra capacity every week	Club > People → Staff jobs
Volunteer on call	$50/week, fight weeks only; 3 turns at 0.8× mastery rate	Extra capacity only when needed	Club > People → Staff jobs
Economy — DERIVED:
Full class weekly (sessional, 3 boxers): +$6,100/yr fees + ~$1,700/yr dues from extra members; ~$2,100/yr spent on cover across ~16 SHORT weeks/yr. Net positive — but ~30% of weeks run BAG nights unless you manage around them.
MONEYFOUR2 pass condition: class revenue > cost of cover + mastery loss. If always profitable → price drops to $90/short or member gain reduced to +2.
3.3 Coached mornings — REDESIGNED from MORNINGSPROBE1 findings
What the probe found: Solo out-gained shared on total points AND weak abilities — not because multipliers were wrong, but because shared was targeting the coach's default session rather than a shared priority. Multipliers alone couldn't fix this.
Revised system — NOW A REAL CHOICE:
Table
Morning type	Multiplier	What it trains	When best choice
Uncoached	×1.0 (CODE)	Coach's default session plan	Rest/light weeks
Solo	×1.25	That fighter's lowest individual ability	Fix a specific weakness; fight-week fine-tuning; fastest single stat gain
Shared — REDESIGNED	×1.15 each	The ONE ability BOTH boxers rank lowest in common — displayed in pairing card	Both lag in the same area; you want total squad gains over focused gains; fastest way to raise a shared gap across two people
Solo on Weak Spot	×1.40	The specific ability the upcoming opponent will target	3+ points behind opponent at that stat; final camp prep
Pads in morning	×0.8 pads rate	One move/combo on the pad card; consumes the morning	Heavy technical work; sparring injuries limit evening sessions
UI change: pairing two boxers on a morning shows clearly:
Shared focus: Conditioning — both 52/70 — fastest way to raise this for both at once.
Solo would raise one faster; shared raises both together.
No longer a blind choice. Each option has a clear best scenario — no universal dominant strategy. CHECK 7 (COACHFIT1): verify total coached mornings = 6 sessional / 7 full-time; confirm shared targeting logic does not over-allocate; rerun MORNINGSPROBE1 to confirm each policy wins 30–70% of the time across 40+ seeds.
3.4 Fight week structure
When: Taper week — 7 days pre-bout, amateur or pro (CODE WeekPhase.phase).
Structure: 3 one-to-one pad sessions + 1 film session — no turns consumed by film.
Table
Load switch	Turns used	Film	Sparring	Use case
Tick over (default)	3	1 coached session	None	Standard fight prep
Rest up	2	1 coached session	None	Tired fighter; coming off injury; short notice bout
Train through	3	1 coached session	1 sparring night (no turns)	2+ weeks between bouts; opponent styles unfamiliar
Film sessions:
Coached film → opens 1 opponent tell/weakness per session (CODE scouting progress)
Unassisted film — REVISED: watches alone → progress bar "Studying opponent style — 50% complete, opens next Monday". No immediate tell, but guaranteed partial insight next week. Never a dead end.
Swap button ↔ between rows when coached film is limited — manually assign which fighter gets coached film first. Cost: the other boxer watches alone.
3.5 Gym sponsorship & day job — expanded choices
Gym sponsorship = fighter stipend — one record, two labels (CHECK 3 confirmed):
$250/wk; billed/show in 4-week blocks of $1,000; Club > Money shows both labels clearly.
Amateurs/BJJ only — stops automatically at pro debut (CODE).
Day job — NEW expanded options:
Table
Option	Cost	Benefit	Who chooses
Full sponsorship	−$250/wk	0 lost mornings; WORK cleared	Default if fully funded
Half sponsorship	−$125/wk	1 lost morning (Tue WORK)	Player toggle — now always available
No sponsorship — Day job choice	1 lost morning (Tue WORK)	$0 cost	Default
Work evenings toggle	1 evening pad slot lost	No morning lost; WORK row shows evening instead	Player choice — "Negotiate hours"
BJJ athlete without sponsorship → misses 1 mat class every 3 sessions.
Cost estimate: ~−0.2 stat pts/week on that morning's focus → ~−2 pts over 10 weeks — ESTIMATE, DAYJOB1 will measure exact impact.
Sponsorship decisions:
Table
Action	Impact
Give to eligible fighter	+5 loyalty; WORK clears immediately
Renew	−$1,000 block cost; +2 loyalty; no gap in WORK status
Pass to another	Receiver +5; giver −3 loyalty
Let end	0 loyalty; WORK returns next Monday
Stop mid-block	−8 loyalty; repay remaining pro-rated portion
3.6 Loyalty — drift model + clearer display
What it is: the existing Loyalty trait from code — learned behaviour.
Display choice — owner decides:
Default: band words only — Loyal / Settled / Wavering / Leaving
Hover/always-on option: band + mini 4-week trend indicator (↑ rising / → steady / ↘ falling) — no raw number shown unless owner approves
Table
Band	Range	Behaviour
Loyal	70+	Drifts down toward 60; 1 short week/4 waived
Settled	50–69	Drifts toward 60 normally
Wavering	25–49	Drifts down −1/week; short weeks hurt more
Leaving	<25	−4 morale/week (directly impacts corner trust: 0.7× effectiveness)
Movement — all ESTIMATE until LOYAL1 runs:
Table
Cause	Loyalty change
All needs met, quiet week	Drift +1 → 60 if below; −1 → 60 if above
Short 1 week	−5; −8 if consecutive
Hold pads (Loyal 70+)	+3/week; max 4 weeks continuous; holder runs bag nights at 0.85 mastery
Promise kept / broken	+5 / −12
Sponsorship given / stopped	+5 / −8
Team-mate released	−5 each remaining fighter
Rest week	+4 morale; loyalty unchanged
Leaving state — owner decides (Option A/B):
Option A (strict): 2× "Wants a word" conversations with no improvement → fighter gives notice; leaves next Monday; turning pro under 50 → club's purse share drops 25%→10%
Option B (softer): no departure; only −4 morale/week at <25 loyalty
The conversation — 1/week max, per fighter ≤1/4 weeks:
Prioritise next week — guaranteed turn slot next week; +4 loyalty; shows who loses a turn
Make a dated promise — must be open goal/bout date; tracks in PROMISES OPEN; +5 kept / −12 broken
Tell it straight — no cost; coach's assessment in words ("listens: usually" = ~70%)
Cause stated directly: "Short weeks this month: 3 — that's why this is dropping"
3.7 Collision line & 4-week forecast
Collision line — appears above Accept on bout page when booking creates conflict:
Table
Message	Options
"Fight week + class week → SHORT 1. BAG nights lose mastery."	Short class (+$78), cover ($130), Rest up, Later date
"3 fight weeks → FILM 3 of 4. One boxer watches alone."	Reorder film slots, Later date, Accept with risk
"This bout lands Week 14 — that week already has 2 fight weeks. Need +2 turns available then."	View forecast, Later date, Accept with risk
4-week capacity forecast — NEW:
Club Week top bar: 4 mini-blocks showing each coming week — fight week count, pad need vs capacity, SHORT/BAG risk
Click any block to jump to that week's preview
Later date button — rule-based, never random: opens = next available show date opponent is free + weight can be made + season has space; greyed with clear reason shown
3.8 Twist cards — revised from v9
Retains code's 16-card deck; 7 evening-impacting cards have 2 priced choices. Rest week toggle also pinned directly to Club Week page (not only twist card).
Table
Twist	Trigger	Option 1	Option 2
Heating down	Any week	Repair −$120	Run cold → lose 1 turn; auto-cover if SHORT
Needs rest	Any week	Rest week: +4 morale, freed turns	Refuse: −4 morale
Partner sick	Sparring night planned	Pads instead: needs free turn → BAG night if none	Hire replacement: $160 (CODE camp rate)
Southpaw opponent booked	First southpaw matchup	Spar southpaw: $80; round-1 penalty removed	Pass: keep penalty
Former coach visits	Fight Saturday only	Guest pad session: +3 mastery that night	Guest corner: +3 morale
Photo request	Any week	Do shoot: +$150; lowest row loses 1 turn	Decline
Visiting pro	Any week	Spar session: 1 habit unlocked in coach's notes	Gym rental: +$60
4. Every menu — wired reference table (S425 requirement)
Table
Menu	Displays	Wired to
Guide strip	"Share coach time with your second fighter"	GuideLight, Roster.sign_fighter
Fighters > Club Week (NEW tab, 2+ fighters only)	Status row: Asked/Need/Film/Cover; 4-week forecast; week grid (nights × turns; PADS/BAG/CLASS); fighter rows (header name only, morale, loyalty band+trend, WORK flag, shared focus, load switch, ⭐ priority, rotate flag); FILM swap buttons; PROMISES OPEN; twist card; conversation card; sponsorship/day-job options; Coach's deal / Reset / Rotate Short / Start week	ClubDeal, PadWeek, DuesLevers, WeekPhase, SharedFocus, Loyalty, Week
