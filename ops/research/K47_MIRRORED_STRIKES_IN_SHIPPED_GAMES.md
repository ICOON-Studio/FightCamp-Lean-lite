# K47 — REAR HOOKS AND SOUTHPAWS IN SHIPPED FIGHTING GAMES: MIRRORED, LAYERED, OR AUTHORED?

Kalli, 2026-09-14 (task `research/TASK_K47.md`), delivered in chat in minutes; collected verbatim by Claude.
Tables arrived tab-separated from the chat and are kept as sent.

## DECISIONS
No shipped title documents “rear hook = whole-body L↔R mirror of lead hook.” That exact pipeline is NOT FOUND in GDC abstracts / studio blogs for UFC, Fight Night, Undisputed, Tekken, SF6, VF5, Creed, TOTF.
Closest documented AAA pattern (EA): shared mocap library + procedural / layered overrides on body parts (EA MMA; UFC 3 RPM + layers on top) — DOCUMENTED — not “mirror the punch and hope the feet land.”
Stance-as-content pattern (Tekken Hwoarang): LFF and RFF are separate authored movesets; stance change is its own Motion Switch transition — SECONDARY (move lists / wiki), strong gameplay evidence against naive whole-body mirror.
FightCamp choice: prefer (a) upper-body-only over unmirrored legs and/or (b) authored/bought rear hook; treat (c) stance switch as its own short move — whole-body mirror is what creates the 0.27 s foot jump and is not what studios publish as their method.
Southpaw capture counts (“N moves per stance”): NOT FOUND for any listed game.
Undisputed proves switch-stance exists in a boxing sim and that southpaw timing/quality diverged enough to need patch rebalance — DOCUMENTED patch notes — cheap reuse of the other stance is risky.
Foot lock during strikes: UFC marketed planted-foot power transfer in locomotion — DOCUMENTED (Brian Hayes quote); public foot-IK recipe during punches — NOT FOUND.
Strongest single source for layering punches over footwork: Geoff Harrower, GDC — Real Player Motion Tech in EA Sports UFC 3 (layers over RPM without wrecking locomotion) — DOCUMENTED abstract.
1. Mirroring — whole body, part body, or capture both?
Title	Mirror whole body?	Mirror upper only?	Capture both sides?	Label	Notes
EA UFC 3/4/5	NOT FOUND	NOT FOUND (layers exist; split point not published)	UFC 3 marketed 5000+ new captured anims from the ground up	DOCUMENTED (marketing + GDC abstract)	RPM = motion database query for locomotion/striking while moving; Harrower: layered techniques over top of RPM. Does not say southpaw = mirrored orthodox.
EA Fight Night R4 / Champion	NOT FOUND	NOT FOUND	NOT FOUND	—	Physics/reaction system evolved from R4 (DOCUMENTED Hayes interview). Southpaw = reverse stick directions in guides (SECONDARY). No published mirror pipeline.
Undisputed	NOT FOUND as studio statement	NOT FOUND	Per-fighter mocap of “footwork, punches, slips…” (DOCUMENTED PS Blog 2024-10-02)	Studio says capture authenticity; does not say “we mirror for southpaw.” Community reports different southpaw punch timing (SECONDARY).	
Thrill of the Fight	N/A for player (tracked body)	—	Opponent AI pipeline NOT FOUND	—	Sim/VR; not a traditional animation-mirror case.
Creed: Rise to Glory	NOT FOUND	—	Xsens MVN mocap, then exaggerated (DOCUMENTED Xsens case + Survios interviews)	Player punches are tracked; AI uses captured/edited clips — mirror policy NOT FOUND.	
Tekken 7/8	Not the default for stance chars	—	Authored both for Hwoarang LFF/RFF	SECONDARY	Separate move lists; missing RFF input falls back to LFF move — evidence of authored, not auto-mirror of every limb.
Street Fighter 6	Facing flip of inputs/playback	—	Moves authored for P1 facing; other side is standard FG flip	DOCUMENTED (Capcom command docs: commands reverse when facing left)	No orthodox/southpaw boxing stance. Not a rear-hook problem.
Virtua Fighter 5	NOT FOUND	—	Heavy authored content; Softimage Animation Mixer blends (DOCUMENTED Softimage/SEGA article)	Half-circulars change with which foot is forward (SECONDARY community) — stance-aware, mirror pipeline NOT FOUND.	

Takeaway for rear hook: shipped games do not publicly endorse whole-body mirroring of a lead hook into a rear hook. Where they talk, they talk capture volume, motion matching/databases, procedural layers, or authored stance moves.

2. Orthodox vs southpaw — mirrored set, separate capture, or mix?
Claim	Label	Source
UFC: unique fighter styles / personality locomotion captured into RPM	DOCUMENTED	EA UFC 3 RPM marketing (2017-11); GDC RPM abstract
UFC: published count “N anims for orthodox + N for southpaw”	NOT FOUND	
EA MMA (Ignite era): “All fighters share the same source animations” + procedural retune	DOCUMENTED	GameDev.net — Building Brawl-Handling Interacting Characters in EA Sport's MMA (Simon…)
Fight Night: southpaw reverses TPC stick directions	SECONDARY	GameFAQs / GameSpy guides
Fight Night: separate southpaw mocap session stated by EA	NOT FOUND	
Undisputed: mocap individual fighters’ moves	DOCUMENTED	PlayStation Blog, Ash Habib, 2024-10-02
Undisputed: switch to southpaw; Switch Hitter perk avoids penalties	SECONDARY / patch-adjacent	Community + patch context
Undisputed 1.5: “Rebalanced speed stats for fighters when switching to Southpaw”	DOCUMENTED	Patch notes (Aug 2025 coverage / changelog quotes) — proves both stances are live and were unequal
Published “we captured N moves per stance” for any listed title	NOT FOUND	
Tekken Hwoarang: different attacks available in LFF vs RFF	SECONDARY	Official-style move lists / Tekken Wiki

INFERENCE (labelled): Undisputed’s southpaw speed exploit + patch rebalance implies they are not using a single perfectly symmetric mirrored set for every punch — or cleanup failed. Do not treat as proof of whole-body mirror; treat as proof that stance reuse is hard.

3. Stance switching — own animation / transition? Timing?
Game	Stance switch behaviour	Timing numbers	Label
Undisputed	Explicit switch-stance (player action; some fighters have Switch Hitter)	Frame/ms for foot swap	Feature DOCUMENTED via patches/community; timing NOT FOUND
Tekken (Hwoarang)	Motion Switch (e.g. 3+4) is a listed transition; many moves end in the other stance	Per-move frame data in community tools	SECONDARY — pattern: stance change = its own move/transition, not a side effect of mirroring a punch
Absolver	Attacks start and end in defined stances; deck chains stance-to-stance	—	DOCUMENTED (Sloclap interviews) — different genre, useful pattern
UFC / Fight Night	Stance is a fighter attribute; mid-fight switch timing	—	NOT FOUND as published transition anim specs
SF6 / VF5	Foot-forward / facing systems exist in VF; SF uses screen-side facing	—	Boxing-style switch NOT FOUND

FightCamp read: option (c) — author a short stance-switch (or cancel into it) rather than letting a mirrored rear hook relocate the feet inside a punch blend.

4. Upper / lower body layering
Claim	Label	Source
UFC 3: layered techniques applied over RPM so pose variety does not wreck RPM locomotion quality	DOCUMENTED	GDC Vault abstract — Geoff Harrower, Real Player Motion Tech in 'EA Sports UFC 3'
Exact bone split (spine vs pelvis) for punch-over-footwork in UFC	NOT FOUND	Abstract does not name bones
EA MMA: layer / override / subtract / add animation to any part of the body (“like Photoshop layers”)	DOCUMENTED	GameDev.net MMA article
How they stop hips twisting against steps	NOT FOUND for listed titles	
Fight Night Absolute Control: upper-body lean / torso control on triggers	SECONDARY	Contemporary reviews / feature writeups — gameplay lean, not a published bone-filter punch layer
SF6: RE Engine cloth/jiggle (Chain); Fighter Tool for FG data	DOCUMENTED	Capcom tech PDF / CEDEC 2024 coverage — not punch/footwork bone split
Generic Unreal “Layered Blend per Bone from spine_01”	Engine docs / tutorials	Not a claim about these shipped games

FightCamp read: option (a) matches the only clearly published AAA fighting-sports pattern: locomotion/base feet stay, layers add upper variety. Hip conflict mitigation is unpublished — expect to solve with pelvis ownership on the footwork layer (your K45 direction), not by copying a public recipe.

5. Foot planting / foot IK during strikes
Claim	Label	Source
EA UFC locomotion: eliminate skating; when throwing an overhand right, plant the foot and transfer power up the chain	DOCUMENTED	Brian Hayes, Creative Director — EA “Feel the Fight” gameplay series (widely quoted; original EA URL now 404)
UFC 3 RPM: uninterrupted footwork + strikes while maintaining momentum	DOCUMENTED	EA UFC 3 RPM marketing (2017-11-10)
Public GDC recipe for foot-lock IK thresholds during punches (UFC / Fight Night / Tekken)	NOT FOUND	
Fight Night: physics-driven reactions / secondary muscle rigs	DOCUMENTED	FNC art blog; Hayes: same physics lineage as R4
Tekken: authored frame data, not physics foot plant	INFERENCE from genre practice; studio foot-IK talk	NOT FOUND
Creed / TOTF VR: player feet/hands tracked — different problem	DOCUMENTED / obvious	Survios / community

FightCamp read: marketing confirms planted feet matter; it does not give you a shipped foot-lock graph. Keep using K44/K46 numbers; do not invent a UFC IK parameter set.

Recommendation map (a / b / c)
Option	What shipped games support	Risk
(a) Mirror upper only over unmirrored legs	Closest to UFC RPM + layers / EA MMA body-part layers	Hips may fight; need pelvis on legs layer
(b) Author or buy a real rear hook	Matches Tekken authored both sides and Undisputed’s per-fighter capture ethos	Cost / content volume
(c) Stance switch as its own move	Matches Tekken Motion Switch / Absolver stance ends	Extra clip; clearest fix for foot jump
Whole-body mirror rear hook	NOT FOUND as a published shipped solution	Exactly your 0.27 s foot-slide

Practical ship order: (c) short stance/foot settle if the punch truly needs opposite lead foot; else (a) for same-stance rear hook (upper only); (b) when the mirrored upper still looks wrong.

Sources
Geoff Harrower — Real Player Motion Tech in 'EA Sports UFC 3' — GDC Vault, https://www.gdcvault.com/play/1025228/Real-Player-Motion-Tech-in
Lee Dowsett, Geoff Harrower — Animation Bootcamp: UFC Animation System — GDC Vault, https://www.gdcvault.com/play/1021794/Animation-Bootcamp-UFC-Animation
Geoff Harrower, Jeremy Mathiesen — Embracing Animation Complexity in EA UFC 2 Through Procedural Techniques — GDC Vault / GameAnim summary, 2016–2017
EA — UFC 3 Real Player Motion marketing — PlayStation Lifestyle / UFC.com video, 2017-11
Brian Hayes — EA UFC “Feel the Fight” / locomotion plant quote — EA gameplay series (cached quotes; ea.com page 404 as of 2026-09-14)
Brian Hayes interview — Fight Night Champion physics lineage from Round 4 — GamingBolt
EA Fight Night Champion Art Blog — secondary muscle/physics rigs — ea.com
GameDev.net — Building Brawl-Handling Interacting Characters in EA Sport's MMA — shared source anims + body-part layering
PlayStation Blog — Ash Habib, Undisputed launches Oct 11 – how body scans deliver boxing authenticity — 2024-10-02
Undisputed patch 1.5 notes — southpaw switch speed rebalance — Aug 2025 changelog coverage
Capcom — Street Fighter command basics (facing reverses commands) — Shadaloo C.R.I. / Capcom
Capcom IR tech PDF 2023 — SF6 mocap + Fighter Tool
Softimage/SEGA — Virtua Fighter 5 Animation Mixer workflow article
Xsens case study — Creed: Rise to Glory mocap (Survios)
Survios interviews (Elkin / Marlis) — Creed cinematic exaggeration, Phantom Melee
Tekken Wiki / move lists — Hwoarang Left Stance, Right Stance, Motion Switch (SECONDARY)
Sloclap Absolver interviews — stance-start/stance-end attacks (DOCUMENTED for Absolver, not boxing)
TransPerfect Games — UFC 5 animation cleanup case (MotionBuilder) — pipeline note, not mirror policy

GAPS: whole-body vs upper-only mirror policy for any boxing title; N clips per stance; bone name for punch layer; stance-switch duration (ms); foot-IK parameters during strikes.

