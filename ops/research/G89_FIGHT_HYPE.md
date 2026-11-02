# G89 - FIGHT HYPE

> Grok (Expert), reply to `G89_BRIEF.md`, collected verbatim by Claude in S70
> (2026-09-24) from https://grok.com/c/d728f18a-f9d0-4848-b21c-a9a3904077d1 .
> innerText of the reply; table cells tab-separated as rendered. 79 sources.
> Feeds S73 (hype).

What makes a fight feel big, and what can be measured. Research only. FightCamp, 2026-09-24.

Operator ask: make hype feel real, especially vs rival gyms and high-stake tournaments.

## What already exists

Read on Guru-Meditation/FightCamp @ c48d0c68.

Godot/scripts/Rivalries.gd — fighter-pair only. One record, HEAT 0–100. Stoked by a fight (draw > decision > finish; rematch bonus), callouts, same-belt chase, sparring war, teammate poach. Cools 1 point per week with no contact. Read by: grudge-match purse (purse_multiplier), sim (attack bonus, earlier hurt, extra gas), morale/fame at settlement, rematch ask. No gym object.

Godot/scripts/PressConferences.gd — fight-week 2–3 questions from bout context (rival, short notice, title, Grand Prix, rematch, loss, streak, cut, hometown). Answers move bout HYPE, pair heat, morale, fame, gym reputation; some BACKLASH. base_hype starts from card tier + rivalry heat + title + short notice + tournament + rematch. Hype already pays purse (hype_purse_per_point) and fame-on-win. Unanswered = "no comment".

Godot/scripts/Tournaments.gd — one-night Grand Prix (4 or 8), seeded bracket, partial recover between bouts, doctor pull, purses climb by round, champion bonus / fame / title on record. Tournament flag already feeds presser base hype. No separate finals-hype track, no team scoring, no crowd/ticket.

Godot/scripts/PromotionsBoard.gd — org identity, sanctioning provenance, belts, upcoming cards, money owed. Display, not a demand engine.

Missing (confirmed): gym-vs-gym rivalry object; weigh-in face-off; betting line; ticket/PPV number driven by hype; crowd composition; 3D fight-week content.

## 1. What drives real interest — measured

Demand here means PPV buys, gate, attendance, linear/streaming viewers, betting handle. UFC stopped publishing US PPV buys after UFC 236 (ESPN+ era). Treat post-2019 UFC PPV tables as unofficial.

### Star + personal feud (largest observed numbers)

Event	What it was	Measured
Mayweather–Pacquiao, 2015	Five-year delayed rematch, two global stars, 50–0 vs national hero	4.6M US PPV; ~$72.2M gate; 16,219 at MGM Grand; $600M+ total revenue (Boxing Insider; Tapology archive)
Mayweather–McGregor, 2017	Crossover + trash-talk summer	4.3M North America PPV (Showtime); global revenue cited >$600M (Sherdog)
UFC 229 Khabib–McGregor, 2018	Title + ethnic/national insult arc + bus attack	2.4M PPV (UFC record); 20,034 att; $17,188,895 gate; $86.4M LV economic output (UFC 229; UFC.com)
UFC 205 Alvarez–McGregor, 2016	Title, first MSG numbered card, hometown-ish NY Irish draw	$17.7M gate (long UFC record until Sphere / later McGregor cards)
UFC 202 Diaz–McGregor 2	Immediate rematch after upset	~1.6–1.65M PPV, non-title
UFC 66 Liddell–Ortiz 2	Grudge rematch	~929k PPV; contemporary "record million" talk

McGregor headlines 8 of the 10 highest reported UFC PPVs. Average buyrate ~1.26–1.43M when he headlines vs ~500–700k for long-run champs (GSP, Jones, Silva) — Meltzer/Tapology compilations, not a league release.

### Title stakes (econometrics, not anecdotes)

- McGowan & Mahon, Demand for the UFC (2015): mean buyrate 2008–12 ≈ 526k. Title cards +15% vs that mean; non-title −27%. Featherweight title +496k, HW +274k, LHW +189k, WW +153k vs baseline in their spec.
- Tainsky, Salaga & Santos, JSM 27(1) 2013: HW title main ≈ +295k buys; each extra consecutive title defense ≈ +31k. Holiday weekend and co-main quality also positive. TUF-roster count on the card is in the model and partly supports the "TUF grew the UFC" story.
- Watanabe, Sport Marketing Quarterly 26(4) 2017 — rivalry antecedents on UFC PPV: conflict (not peer/bias) is the rivalry dimension that moves buys. Two-fighter poster +150,161. Co-main rematch +215,131. Main-event rematch not significant. Similarity in recent win% helps; career win% gap helps. Marketing poster was the strongest single predictor in that paper.
- Reams & Shapiro / related star-power work (ESMQ 2017): current/former champions and high rank dominate; media-mention "popularity" is weaker than in-cage status. "Put a title on every PPV" is the practical implication.

Title is necessary, not sufficient. Late-era flyweight / women's title mains without a crossover star sit at 85–175k (UFC 215, 224, 228). Championship without a name does not print money.

### Rematch

Split by sport.

- Boxing (Butler, Butler & Maxcy, ESMQ 2020, HBO/Showtime 2006–18): fans prefer rematches on Nielsen main-event ratings. Mayweather dummy dominates PPV. Domestic boxer dummy positive. Outcome-uncertainty hypothesis is weak / contradicted for PPV.
- UFC: McGowan — rematch dummy generally null after controls. Watanabe — main rematch null, co-main rematch large. Case table still shows the famous rematches selling (Diaz 2, Silva–Sonnen 2 925k, GSP–Penn 2 920k, Liddell–Ortiz 2 929k) because those rematches were also grudges + stars.

Rule of thumb for the game: rematch alone is a modest bump; rematch × unfinished argument × star is the spike.

### Undefeated records

No published UFC/boxing regression isolates "0-loss" as its own dummy. It is absorbed into recent win%, rank, and star status. Observed, not estimated: Mayweather 50–0 was the PPV product; McGregor's 0-loss run through Aldo (UFC 194, 1.2M) and Alvarez (UFC 205, 1.3M) sold; Rousey's 0-loss run sold until Holm. Once the 0 is gone, the name still sells (McGregor after Diaz 1 still did 1.6M+ twice). Treat undefeated as a narrative multiplier on an already famous fighter, not a standalone demand lever.

### Hometown / national draw

- UFC 83 GSP–Serra 2, Montreal: huge gate, modest PPV — Tainsky uses it as the textbook split between local affiliation and mediated demand.
- UFC 129 GSP–Shields, Rogers Centre: 55k+ attendance, ~800k PPV — hometown fills the building; PPV still needs the US star.
- Butler boxing: domestic boxer raises linear ratings.
- UFC 229: 40% of visitors international (Applied Analysis via UFC) — national/ethnic feud travels.

Hometown moves gate and crowd mix more reliably than PPV.

### Trash talk / presser incidents

Not isolated in the published demand papers. The closest coded variables are "conflict" rivalry items and "TUF appearance." Case evidence is the actual PPV table: McGregor's press-tour style is the product; Sonnen–Silva 1 was mid-card-ish until the talk, then Silva–Sonnen 2 did 925k; Jones–Cormier 1 did 800k after a year of TV hatred. Incidents are how conflict gets televised, not a separate coefficient.

### Gym vs gym / team rivalries

NOT FOUND as a PPV, gate, or handle regressor. Coverage is heavy (see §3). No paper prices "AKA vs ATT" as a buyrate shifter.

### Tournament finals

Event type	Measured	Caveat
K-1 World GP 2000 Final, Tokyo Dome	65–70k attendance (sources disagree; Wikipedia lists 70,200)	Live spectacle, not a Western PPV series
PRIDE GP 2000 Finals	38,429 Tokyo Dome	Same
PRIDE/K-1 Shockwave 2002	71–91k (disputed)	Largest MMA crowd claimed
PFL World Tournament finals on ESPN, Aug 2025	286k–356k P2+	Linear cable, not PPV (USTVDB)
"2023 PFL Championships 300k PPV"	Appears on aggregator pages	Weak / directional; not a league release

Tournament structure (one night, last man standing, Japan GP tradition) fills buildings. US PFL playoffs do not approach UFC numbered-PPV demand. The hype is the bracket collapsing to a final, not the logo.

### Betting handle / line movement

- Mayweather–McGregor: Vegas directors estimated up to $85M handle, 16-of-17 tickets on McGregor, six separate $1M+ Mayweather bets, line moved all summer (ESPN).
- Regular UFC cards: handle exists, not published at event grain in a form usable as a demand study.
- Line movement is a thermometer of public heat, not a cause of PPV. Books moved because casual money showed up.

### What the regressions actually rank (UFC PPV era)

1. Named star in the main (or a defining-moment poster of two names)
2. Title, especially HW / historically WW–FW when that star sat there
3. Conflict-type rivalry / stacked co-main (including co-main rematch)
4. Holiday timing, co-main quality, TUF residue
5. Rematch-as-rematch, outcome uncertainty, media-mention counts — weak or null

Trash talk, gym wars, undefeated streaks, Embedded episodes: measured only as case studies, not coefficients.

## 2. How the build-up is staged

Real sequence, combat sports, fight-week plus camp:

1. Announcement / poster — tickets go on sale; PPV pre-order window opens. Watanabe: two-fighter poster is the strongest marketing dummy they tested. This is the only stage with a published buyrate coefficient.
2. Camp content — UFC Embedded (6 episodes, fight week), Countdown, old 24/7 (HBO boxing), social callouts. No demand regression. Function: keep the announcement alive for 6–8 weeks and feed clips to people who will not watch a presser.
3. Media day / open workout — quotes and pad-work clips. Rarely the story unless someone misses weight-talk or a sparring clip leaks.
4. Press conference — where conflict becomes footage. Famous because they broke format: Jones–DC shove (UFC 178, Jones fined $50k + 40 hours community service); Silva shoulder after Sonnen week (UFC 148); McGregor bus attack (2018) then UFC 229 face-off kick; Strickland–Chimaev UFC 328, police on stage. These do not have a buys delta in a paper. They are how "conflict" gets into the Watanabe sense of the word.
5. Ceremonial weigh-in / face-off — last public event, packed arena, staredown is the thumbnail. Official commission weigh-in is earlier and dry. Missed weight is a negative shock (Chiesa UFC 226) that kills hype and sometimes the bout.
6. Walkout / crowd — not a pre-sale driver; it is the payment for the work above.

What measurably moves interest: announcement + who is on the poster + whether a title/feud already exists. Fight-week theatre is how that interest is performed. Incidents become famous when they confirm a feud the audience already bought (Jones–DC, Khabib–McGregor), not when two unranked fighters shove.

PressConferences.gd already models the presser slice (questions → hype/heat/backlash). It does not model announcement, Embedded-style episodes, face-off, or missed-weight shock.

## 3. Gym vs gym

How they form:

- Split camps. ATT → Blackzilians (2011, Boca vs Coconut Creek). TUF 21 was explicitly ATT vs Blackzilians, $500k team prize. Documented as coverage and TV product, not as a PPV study (FOX Sports).
- Poach / teammate rule. AKA's public code: teammates do not fight each other, even when UFC asks (Koscheck–Fitch era; Cormier moving up rather than fight Velasquez). That prevents intra-gym PPV and creates inter-gym wars when the other side will take the fight.
- Coach defection. Team Alpha Male: Ludwig leaves, Dillashaw follows, Garbrandt stays → two title fights + TUF coaches. Heat was personal, gym-branded.
- In-house collapse. ATT: Covington vs Masvidal / Poirier / Jedrzejczyk; owner-imposed "no ripping teammates" rule failed; Covington left (ESPN, 2020). Nunes later left ATT citing Harrison sharing coaches — conflict-of-interest split.
- Boxing stables. Mayweather Promotions vs Golden Boy was a promoter war that starved Mayweather–Pacquiao for years; the delay itself became the story and the 4.6M buyrate. Not a gym war in the MMA sense.
- Amateur / TUF team scoring. TUF seasons with named gyms (ATT/Blackzilians, Jones/DC, Garbrandt/Dillashaw) are the only time "team score" is a broadcast stat. No published lift vs a normal TUF season.

Interest data for gym-vs-gym as a product: NOT FOUND. What exists is qualitative: media treats "AKA vs ATT" as a color line on a fighter-vs-fighter card. The buyrate still belongs to the two names and the belt.

For FightCamp this is the gap the operator asked about: rivalry is currently fighter-pair. Real coverage treats the gym as the faction, the fighter as the champion of the faction. Poaching already stokes pair heat in Rivalries.gd; there is no gym-level heat, no "we sent our #1 at their #1," no team record in a tournament.

## 4. How games do it

Game	Input	What it changes	Verdict
EA UFC 4/5 Career	Hype meter, social-feed posts, finish predictions, sponsor challenges, limited callouts	Cash, follower count, sometimes opponent willingness	Reviews: Career is the hook; social copy-paste from UFC 4; "doesn't go far enough on personality drama" (Game Informer); players explicitly ask for presser dialogue, weigh-ins, real callouts (EA forums, IGN user reviews). Shallow on feud, decent on "I posted and got paid."
Fight Night Champion Legacy	Calendar, sponsors, fight challenges (cut him, don't take damage)	XP, perks, ranking	Works as grind. Champion Mode (scripted Andre Bishop) is what people still cite in 2026 as the thing that made a fight feel like it mattered. Online gym seasons existed on paper. Crowd/presentation secondary.
WWE 2K / TEW	Feud heat, promo mini-games / written promos, TV ratings	Match importance, crowd reaction, ticket/TV money in TEW	Closest systemic model of "heat is an object." Combat sports games have not copied it.
Football Manager	Derby flag, media previews, fan expectation, board pressure	Match importance, player nerves, press questions	Works because the fixture list already knows the rival. Combat equivalent = gym war baked into the booking calendar, not a random presser line.
Punch Club / boxing managers	Narrative weeks, rumor boards	Story flags, sometimes purse	Tone, not an economy. Players remember the writing, not a hype number.

What players say works: a visible meter that money and the crowd obey; being able to pick the fight; a presser that can go wrong. What they call shallow: canned tweets, hype that does not change the building or the walkout.

FightCamp already has the two systems those games fake (pair heat, presser with backlash). It does not yet spend those numbers on tickets, crowd, or the 3D fight.

## 5. Propose for FightCamp

Ranked. Gym-vs-gym and high-stakes tournaments first, per brief. Each: evidence → extends → changes → cost.

### 1. Gym rivalry object (GYM HEAT)

(a) Real coverage of ATT/Blackzilians, AKA-vs-everyone, TAM split, boxing-stable wars is how fans parse "our house vs theirs." No buyrate coefficient exists; the feeling is factional. Poaching and "we don't fight teammates" are the documented mechanics.

(b) Extends Rivalries.gd (pair heat already stoked by poach). New gym-pair record, parallel 0–100. Presser context already has %GYM%. PromotionsBoard can show the war on the org/gym row later; not required for v1.

(c) Changes: booking a rival-gym fighter adds purse and HYPE on top of pair heat; poaching their prospect spikes gym heat and pair heat; tournament team score (below) reads this; morale of the whole roster moves when "ours" beats "theirs"; fame/reputation at gym level, not only fighter. Crowd mix in the 3D fight: more away colors when gym heat is high. Sim: corner extra aggression already exists at pair level — do not double-apply; gym heat should hit money and crowd first.

(d) Medium. Data + settlement + one office widget. Large only if 3D crowd livery is in scope.

### 2. Tournament finals as a hype season, not one night

(a) K-1 / PRIDE GP filled domes; PFL playoffs lift linear ratings vs their own prelims (229k semi → 356k final, ESPN 2025) but stay far below UFC PPV. The structure fans recognize: bracket, blood, last man standing, purses climb.

(b) Extends Tournaments.gd (already one-night GP, recover, doctor, champion bonus) and PressConferences.gd (tournament already in base_hype).

(c) Changes: each round won adds bout HYPE to the next fight on the same night (final starts hotter than the quarter). Optional multi-week playoff track (PFL-style) so the final is a dated event with its own presser and face-off. Team cup: gyms enter two fighters, gym heat + team points. Winner gym takes reputation and a recruiting bump (the thing amateur team trophies actually do). Money: final purse already scales; add a gate/ticket multiplier so the final looks sold.

(d) One-night hype carry: small. Multi-week playoff + team cup: medium.

### 3. Tickets / gate / PPV number that read HYPE

(a) UFC 229 vs UFC 226 at the same building: $17.2M vs $5.67M gate. Mayweather–Pacquiao $72M gate on 16k seats. Title +15% / −27% PPV split (McGowan). Poster and star are the rest. This is the missing receipt: hype that does not change the take is a flavor number.

(b) Extends PressConferences.gd (purse_bonus already exists) and whatever books the card. PromotionsBoard is the place to show the number, not compute it.

(c) Changes: bout HYPE + pair heat + gym heat + title + hometown + tournament-round → attendance fill and a displayed buy/stream number. Money hits the gym and the promotion cut. A dead presser can leave seats empty. Fame-on-win already scales with hype; keep that.

(d) Small if it is a formula and a UI line. Medium if arena capacity and price tiers exist.

### 4. Weigh-in face-off (fight-week capstone)

(a) Last public event; source of the thumbnail; Jones–DC, Cruz–Garbrandt, UFC 229, 328 are the clips that outlive the presser. Missed weight is the documented negative shock. No buys regression.

(b) Extends presser context and WeightCut (already in the repo via PromotionsBoard's WeightCut preload). New short scene, not a new economy.

(c) Changes: staredown can add heat or trigger backlash (shove, fine, doctor look). Missed weight dumps HYPE and can scratch the bout. Hometown weigh-in fills the room (gate already sold; this is show). Feeds 3D walkout intensity if that pipeline exists later.

(d) Small as a 2D desk scene with three outcomes. Large as a 3D arena weigh-in.

### 5. Betting line as a public thermometer

(a) May/Mac ~$85M handle, line walked all summer because casual money arrived. Not a cause of PPV; a readout of who the public has decided matters.

(b) New. Reads the same inputs as tickets (fame, record, heat, title). Does not need a sportsbook sim.

(c) Changes: displayed moneyline; heavy public lean = extra HYPE (the McGregor ticket flood); upset vs a short price = extra fame (Holly Holm). No need to let the player bet.

(d) Small.

### 6. Announcement / poster beat

(a) Watanabe: two-name poster +150k buys. This is the one marketing action with a number.

(b) Extends PromotionsBoard (cards already listed) + presser base_hype.

(c) Changes: booking confirmation is an event. Player picks poster focus (two faces vs whole card). Two-face poster on a heated pair costs reputation if you bury a title fight to sell a grudge — or pays if the grudge is the title. Starts the HYPE clock so camp weeks are not silent.

(d) Small.

### 7. Camp content beat (Embedded-style, not a 3D show)

(a) Embedded/Countdown/24/7 are how fight week is consumed. No coefficient. Games that skip this feel like the fight teleports in (EA UFC complaint).

(b) Extends presser question pool; can reuse callout source already in PressConferences.gd.

(c) Changes: 1–2 scripted clips per camp (open workout quote, hospital cut, rival tweets). Each is a small HYPE/heat/morale roll with backlash risk. Cheap way to make the weeks before the bell exist.

(d) Small as text/photo events. Large if 3D.

### 8. Crowd composition in the 3D fight

(a) Hometown gates (UFC 83, 129) and UFC 229's 40% international visitors. Crowd is how "this is big" is felt in the room after the money is already taken.

(b) New consumer of HYPE + gym heat + hometown. Arena scripts exist (ArenaRig.gd etc.); this is a dress pass, not a new sim.

(c) Changes: volume, chant side, color mix, how fast the room dies if the fight is a grind. Does not change who wins. This is the "feel" the operator asked for.

(d) Medium (audio + livery). Large if individual crowd agents.

### 9. Hometown / national card flag

(a) Butler domestic dummy; Tainsky Montreal split; MSG McGregor gate.

(b) Presser already has hometown as a question trigger. Wire it into tickets (proposal 3) and crowd (8).

(c) Changes: booking a local on a local card fills the gate more than it fills the PPV. National-feud pair (already heat) fills both.

(d) Small once tickets exist.

### Do not build first

- Isolated "undefeated" meter — no coefficient; win-streak presser questions already cover the talk.
- Full sportsbook / player betting — handle is flavor; gambling loop is out of scope for "feel."
- Scripted 24/7 documentary series — cost large, evidence of demand lift absent.

### Suggested build order

Gym HEAT + tournament-round hype carry + tickets-from-hype. Then face-off and announcement. Crowd dress when the 3D fight can read a number. That is the shortest path to "rival gyms and high-stake tournaments feel big," using systems that already store HEAT and HYPE.

Still unknown: no study prices gym-vs-gym or a single press-conference incident in PPV buys, and UFC has not released US PPV numbers since UFC 236.
