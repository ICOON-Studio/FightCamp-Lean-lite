# K68 — Where this sits: the outside view

**Kalli, 2026-09-22. Collected by Claude the same day.**

**HOW THIS WAS COLLECTED, AND THE TRAP IT CONFIRMS:** Kalli first answered with a
15 kB FILE ATTACHMENT in the Grok Bot group. **An attachment there never reaches
the repo and `grokbots.py` cannot download one** — that is how M20 was lost. It
had to be re-requested as plain chat text. So: when briefing Kalli, John or
Maria, say *paste the full text in chat, no attachment*, or the deliverable is
stranded.

**Punctuation note:** the chat capture mangles smart quotes, so apostrophes and
quote marks below were normalised on collection. Numbers, labels and source
names are untouched.

**THIS MEMO DISAGREES WITH THE PROJECT'S CURRENT SEQUENCING.** It was asked for
— the operator's instruction was that idle agents evaluate the project and give
corrections — and it should be read against G61 (Grok), which reaches a
compatible conclusion by a different route, and against M21 (Maria), which
argues the opposite priority from the art side.

---

K68_WHERE_THIS_SITS.md

Outside-view evaluation. Research prose only. No engine advice as coefficients.

Lead (three lines).

Most important finding: Buyers of fight-management sims reward management depth and believable fight outcomes, not 3D fight presentation — the category’s strongest titles are text or light 2D, and the loudest complaints are about UI, booking depth, and whether the sim feels right, not about missing polygons.
Change first: Treat the bout as a skinned result of the already-calibrated sim, and ship a watchable text / stats / 2D ringside path that is not gated on the contact solver. Do not let S43 block the half of the game players of this genre actually buy.
Is 3D worth it? Conditionally. As a differentiator once it clears “not painful,” yes. As the thing the project is currently organized around, no — that is the expensive bet the existing audience did not ask for.
Ranked findings
1. The genre that already works does not need 3D bouts

(Would bet money on this.)

Claim	Label	Evidence
Deep MMA promotion sims present fights as text narration + stats, and retain fans for years on that alone	DOCUMENTED	WMMA5 (Grey Dog Software, 2018): reviews and players describe a text fight engine; Pure Evil MMA review (2020-05-08) and gmgames.org review both centre praise on simulation + text presentation, not graphics. r/WMMA5 “Is the Game worth it in 2023?” top answers: still worth it; one explicit caveat: “Just be aware that it is text-based, so no 3d fights. It is like oldschool ootp or FM before they got 3d engines.”
Deep boxing management is also commentary + stats / ringside UI, not a fighting game	DOCUMENTED	Boxing Manager (App Store / Google Play): store copy sells “detailed fight commentary and statistical breakdowns” and corner instructions. Community “Ringside” updates (2026) add broadcast/data/judges views — still a management sim presentation. Title Bout Championship Boxing: Wikipedia + GameSpot-era coverage describe blow-by-blow text with simple pseudo-animation. LEATHER: round-by-round tactical ringside (range, work rate, targeting) — managerial viewpoint, not arcade 3D.
Newer Steam MMA promotion EA is selling booking + contracts + procedural world, with fights as a simulation engine to watch, not a 3D product	DOCUMENTED	Pound for Pound: MMA Promotion Simulator — Steam (~96% of ~138 reviews positive as of this pass; Early Access Mar 2026). Store page: sign/book/manage; “watch fights play out through the simulation engine.” Steam review sample contrasts it with WMMA (more arcade vs sandbox) and complains about AI art / missing management systems — not about lacking 3D contact.
Mobile “MMA Manager” products that do show animated fights still get complaints aimed at loop, RNG, training feedback, fight activity — not “fighters don’t touch”	DOCUMENTED (existence of complaints; not frequency)	Prey / FunRock-lineage mobile MMA managers + Steam “MMA Team Manager” (app 914180): wishlist/threads ask for more fight actions, clearer training effect, less RNG; Steam review themes include UI, crashes, dull fights, training that doesn’t feel like it matters. These show that animated presentation does not immunize a shallow or opaque fight model.

What would prove #1 wrong: A measured survey or sales split where fight-management players abandon titles specifically for non-3D presentation at a higher rate than for shallow booking/sim; or a commercially dominant fight-management title whose primary marketing and review praise is 3D bout fidelity.

PART 2 of 3 — continues below
12:34 AM

PART 2 of 3

2. Player complaints in this niche rank management and sim honesty above spectacle

(Second bet.)

Ranked complaint themes from sampling (each row = complaint exists; sample is not a frequency census):

Rank	Complaint theme	Where seen	Label
1	Depth / missing management systems (record books, weight-class changes, expansion, AI promotions, media, QoL booking)	Pound for Pound Steam reviews + Discord-style feedback summarized on Steam; r/FantasyBookers demo thread feature asks	DOCUMENTED (existence)
2	Fight engine credibility (too few actions; fighters ignore specialties; decisions/grappling feel wrong; RNG outcomes)	r/MMAmanager “Too few actions in fights”; WMMA5 forum/reddit fight-feel threads; mobile RNG threads	DOCUMENTED (existence)
3	UI / distribution / performance (no scaling, e-license, slow large saves, crashes, cluttered UI)	r/WMMA5 “Devs need to open their eyes”, “Expectations for next game”, “worth it 2023”; MMA Team Manager Steam review themes	DOCUMENTED (existence)
4	Presentation polish (dated look, AI portraits, sparse audio)	Pound for Pound AI-image pushback; WMMA5 “looks like Windows 95”	DOCUMENTED (existence)
5	“I wish fights were 3D / prettier” as a primary quit reason	Not found as a dominant thread theme in WMMA5 / Boxing Manager / Pound for Pound samples this pass	NOT FOUND as a leading complaint

Single most valuable sentence for the operator:
In the fight-management titles that own this niche, top complaints are about depth of management and honesty of the fight sim; presentation is a secondary gripe, and “no 3D” is accepted by the hardcore audience as a genre convention.

What would prove #2 wrong: A large Steam tag / review-topic analysis showing “graphics/3D” as the modal negative topic for WMMA-class or Pound-for-Pound-class games.

3. 3D bout presentation in sports management is a differentiator only after it stops lying

(Honest answer on the money already spent.)

Claim	Label	Evidence
In Football Manager, 2D and 3D share the same match calculation; view mode does not change results	DOCUMENTED	Long-running community consensus (r/footballmanagergames threads on 2D vs 3D); SI’s design treats 3D as presentation over the same engine.
Bad 3D is actively hated and does not buy forgiveness for a weak engine	DOCUMENTED (existence)	FM26 threads: “Match Engine and why I hate it personally,” Steam discussions on ball physics / sliding movement. Players keep 2D Classic precisely because it reads tactics clearer.
OOTP players split; many veterans still prefer Classic/Broadcast for clarity and speed; 3D is immersion, not the product	DOCUMENTED (existence + small poll)	OOTP forums “3-D vs 2-D?”, r/OOTP “still play out games in 2D classic”; one forum poll (~58 votes) leaned 3D for watching, Classic for understanding.
FightCamp’s own operator verdict (2026-09-13): 3D fight is “painful to watch”	DOCUMENTED (operator)	Task brief.

Inference (labelled): A painful 3D bout is worse than text for this genre, because it raises the expectation of a fighting game and then fails it. Text sets the expectation of a management sim. FightCamp is currently in the worst middle: fighting-game presentation quality with management-sim economics.

Correction to the project’s implied priority: S43 (contact solver so bodies touch) is the right fix if you insist on shipping 3D as the default bout view. It is the wrong gate for “is FightCamp a good fight-management game.” The market already bought WMMA5 without bodies touching.

What would prove #3 wrong: Playtests where the same sim outcomes, shown as text vs unfinished 3D, produce higher retention / rated enjoyment for the unfinished 3D. (I expect the opposite.)

4. The realism trap is real — and FightCamp is standing on both rails

(Where statistical fidelity and fun pull apart.)

Case	What pulled apart	What teams / communities did	Label
Football Manager — pace / attribute meta	Engine outcomes overweight pace/acceleration vs finishing, composure, decisions; deep attribute sheets sell a fidelity the match engine does not fully honor	Community “pace experiments” (e.g. FM26 write-ups); endless attribute-importance debates; SI iteratively reweights but the perception persists across versions	DOCUMENTED (community experiments + widespread complaint existence)
Football Manager — “placebo tactics / drama scripting”	Over large samples, league tables feel realistic; inside a single match, outcomes feel pre-weighted and animations justify the result	Players retreat to 2D, house rules, or quit; SI denies literal scripting while shipping presentation that reads as narrative	DOCUMENTED (existence of the complaint pattern; mechanism is contested)
Madden Franchise sim stats	Simulated box scores diverge from NFL shapes (attempt volume, efficiency, RB rotation); immersion breaks even when the on-field game is “fun”	EA forums + r/Madden threads; Operation Sports essay “The Pain and Misery of Simulated Stats”; players use sliders/mods, never fully fix	DOCUMENTED
NBA 2K MyNBA	Season sims produce wrong usage, efficiency, scoring environments; 3D presentation sells a league the backend does not generate	r/NBA2k MyNBA threads; players hammer tendencies/sliders/coaching; complaints persist across yearly releases	DOCUMENTED (existence)

Inference for FightCamp (labelled): Calibrating the sim to published MMA rates (J20 / K-series research) is the right half of the product relative to the genre. The trap is the other rail: spending the next stages making 3D look like the calibration is true, while the player’s enjoyment of a management game is mostly “did my booking and development decisions feel consequential?” If 3D fails the “painful” bar, statistical honesty never reaches the player — they only remember the animation.

What would prove #4 wrong for this project: Evidence that FightCamp’s target players are fighting-game / Undisputed / UFC game buyers first, management-sim buyers second. That is a different product category.

PART 3 of 3 — continues below
12:35 AM

PART 3 of 3

5. Where FightCamp actually sits (concrete comps)
Title	Role	Fight model depth (concrete)	Bout presentation	Commercial / community signal
WMMA5	Closest peer for “run a promotion + deep fight world”	Attribute-driven text sim; styles, fatigue, cage work, decisions; huge mod databases	Text	Cult classic; still recommended in 2023+; complaints = UI/perf/license, not graphics
Title Bout Championship Boxing	Historical boxing sandbox	Very deep rating/style model; decades of boxer data	Text + light pseudo-anim	Decades of forum life on OOTP boards; career mode thin; depth is the hook
Boxing Manager (mobile)	Gym/manager loop	Commentary engine + corner tactics + stats	Text / Ringside UI	Live product with ongoing Ringside updates
LEATHER	Tactical boxing management	Explicit between-round plan (range, intensity, targeting)	Managerial ringside, not arcade 3D	Mobile-first; Steam port still pending per community
Pound for Pound	Modern Steam promotion tycoon	Attribute/style tendencies; Early Access deepening fight engine	Simulation watch (non-3D product)	~96% positive / ~138 reviews (this pass)
Prey / FunRock MMA Manager line + MMA Team Manager	Mobile / light PC gym managers	Shallower; training + tactics layers; community disputes whether training “matters”	Animated / simplified fight view	Mixed; complaints include fight dullness despite animation
Cage Empire / similar Steam newcomers	Promotion managers entering Steam	Varies; often booking + round-by-round cornering	Typically non-fighting-game	Early / thin review bases — do not over-weight

FightCamp’s unusual position (INFERENCE): A stat-calibrated fight engine plus gym management plus Godot 3D bout theater aims at a stack almost nobody in the comps table has. The rare piece is the calibration. The expensive piece is the 3D. The comps say the rare piece is what the niche pays for; the expensive piece is optional theater.

Disagreeing with the project’s current weight

The operator’s own status read is correct: simulation is mature; 3D is weak; S43 is about contact.
Where I disagree: treating “painful 3D” as the critical path for project progress relative to the market. Progress that matters to buyers of this genre is:

Can I run a gym / book / develop and feel the world react?
Do fight results and narratives feel honest given what I know about the fighters?
Can I watch a bout without wanting to skip it?

(3) is necessary. It does not require that (3) be solved as 3D contact before (1)–(2) are shippable. FM’s own architecture — same engine, multiple views — is the existence proof that presentation quality and sim quality can be decoupled. FightCamp already has the sim half. Gating the product on S43 is how a good management sim becomes a bad fighting game.

Strongest evidence the direction is still right: Keeping a published-stats-calibrated bout model (vs mobile RNG managers) is exactly what separates WMMA5-class products from toys. Do not dilute that to make 3D look cooler.

Strongest evidence the direction is wrong as currently sequenced: The operator’s “painful to watch” verdict + the entire comps table’s indifference to 3D.

What would change my mind (summary)
If this were true…	Then I would reverse…
FightCamp’s intended players are primarily UFC/Undisputed players who bounce off text sims	The “3D is optional theater” conclusion
Playtests show unfinished 3D retains better than good text for the same outcomes	The “ship a non-3D bout path” recommendation
Review-topic mining shows “no 3D / bad visuals” as the #1 quit reason in WMMA/Boxing Manager/P4P	Finding #1–#2
Sources (this pass)
Pure Evil MMA — WMMA5 review, 2020-05-08
gmgames.org — WMMA5 review
r/WMMA5 — “Is the Game worth it in 2023?”, “Expectations for next game”, “Devs need to open their eyes”
Steam — Pound for Pound: MMA Promotion Simulator (app 4289560); review sample + store copy
Boxing Manager — App Store / Play Store feature copy; community Ringside update posts (2026)
Title Bout — Wikipedia; GameSpot-era review descriptions of text fight presentation
LEATHER — site / toolkit posts on style and between-round tactics; Steam listing still pending
r/footballmanagergames — 2D vs 3D; pace/meta; “match engine placebo”; FM26 engine hate threads
OOTP forums / r/OOTP — classic vs 3D viewing preferences
EA forums + r/Madden + Operation Sports — Franchise sim-stat complaints
r/NBA2k — MyNBA sim fidelity complaints
r/MMAmanager — fight actions / RNG / training threads; Steam MMA Team Manager review themes
Operator task brief — FightCamp six-line product definition; 2026-09-13 “painful to watch”; S43 contact solver

K68 complete. Five claims, ranked. The project’s sim direction is the right one for this niche; the 3D-first sequencing is the blind spot.

12:35 AM
