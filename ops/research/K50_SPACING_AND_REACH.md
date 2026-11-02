# K50 — HOW FAR APART BOXERS STAND, AND HOW FAR A PUNCH GOES INTO THE MAN IT HITS

Kalli, 2026-09-14 (task `research/TASK_K50.md`), delivered in chat in ~3 minutes; collected verbatim by Claude.
Tables arrived tab-separated from the chat and are kept as sent.
COLLECTION NOTE (Claude): Schortgen's 1.23 m is between the two men's FLOOR positions (feet midpoints), the room's gap is between node origins on the floor - the same kind of distance. The recommended bands (mid ~1.20-1.25, long ~1.35-1.50, close ~0.70-0.90 m) are Kalli's INFERENCE anchored on that mean.

## DECISIONS
Bout average spacing: 1.23 ± 0.16 m between boxers — DOCUMENTED (Schortgen et al., ECSS 2023). Measured from feet joint / feet-midpoint positions on the ring plane (homography), not chest-to-chest.
Your room (0.80 / 0.95 / 1.10 m c–c) sits below that average. Mid should live near ~1.20–1.25 m; treat 0.80 m as deep inside / clinch approach, not “close fighting range.”
Share of round at long / mid / close (metres): NO STUDY published yet from Schortgen’s distance bins (they mention combat profiles; numbers not in the abstract).
Distance at the moment a jab/cross/hook lands: NO STUDY released (15 464 hits annotated for later merge with tracking).
Puncher travels in (max straight, lab): hip ~28 cm, fist path ~66 cm, front-foot-to-target ~50 cm — DOCUMENTED (Cheraghi 2014). In-place punches will look fake at real spacing.
Landed punch “into” the target: follow-through ~11 cm past impact (DOCUMENTED, Atha); head Δv ~3.0 m/s in ~11 ms (DOCUMENTED, Walilko); glove foam compresses a few cm (SECONDARY/damping studies); face compression cm — NO STUDY.
Anti-overlap: Capcom collision / push boxes keep bodies from occupying the same space — DOCUMENTED. Separate hit/hurt volumes for punches.
Clinch: ~13 / 17 / 29 s total clinch time in rounds 1–3 (Olympic male TMA) — DOCUMENTED; restart separation after break — NO STUDY (metres).
1. Spacing by range
Measured bout average
Number	What is measured	Label	Source
1.23 ± 0.16 m mean distance between boxers	Feet joints → ring-plane position via homography; distance between the two athletes’ floor positions	DOCUMENTED	Schortgen, Goyallon, Reveret, et al., ECSS Paris 2023 oral — 32 French elite fights, 33 boxers, 96 rounds
155 ± 28 m travelled per round	Same tracking	DOCUMENTED	Same
Tracking error ~0.3 m vs multi-cam reference	Method paper	DOCUMENTED	Schortgen et al., J Sports Sci 2025 — monocular markerless tracking

Not published in that abstract: metres for “long / mid / close” bins, or % of round in each bin (they list “combat profiles (clinch phases, distances…)” as addressed, without numbers).

Operational range bands (arm-length, not bout metres)
Range	Definition	Label	Source
Long	d > 1.0 × L_arm (cannot land without stepping in)	DOCUMENTED (system definition)	BoxMind / 2024 Olympics strategy paper (arXiv)
Mid	0.5–1.0 × L_arm (straights/hooks from stance)	DOCUMENTED	Same
Close	d < 0.5 × L_arm (infighting / uppercuts)	DOCUMENTED	Same

INFERENCE (not measured in bouts): for a ~0.70–0.75 m arm (typical ~176 cm elite height), that maps roughly to long ≳ 0.7–0.75 m, mid ~0.35–0.75 m, close ≲ 0.35–0.38 m if d were fist-reach space. Schortgen’s 1.23 m feet-midpoint average is larger because it includes stance depth, guard, and out-boxing — do not set mid to 0.95 m thinking it matches elite bouts.

vs your invented room
Your band	vs Schortgen mean	Read
0.80 m	~0.43 m short	Inside / clinch-adjacent
0.95 m	~0.28 m short	Still tight mid
1.10 m	~0.13 m short	Lower end of bout average (±0.16)

Recommendation: mid ≈ 1.20–1.25 m; long ≈ 1.35–1.50 m; close ≈ 0.70–0.90 m (feet-midpoint), with clinch near chest contact — INFERENCE anchored on Schortgen mean + arm-length logic.

% time at each range: NO STUDY (published).

2. Spacing when a punch lands
Punch	Inter-boxer distance at contact	Puncher body travel during punch	Label
Jab	—	—	NO STUDY (live bout)
Cross	—	—	NO STUDY
Lead hook	—	—	NO STUDY
Rear hook	—	—	NO STUDY

Schortgen 2023 explicitly saved 15 464 expert-annotated landed punches for “more in-depth analysis in combination with our tracking data” — that merge is not in the oral abstract.

Lab bag / pad (single boxer → fixed target)
Number	Measure	Label	Source
0.496 ± 0.08 m (0.387–0.648)	SelectiveDistance = perpendicular distance front foot → target at ready	DOCUMENTED	Cheraghi et al., 2014, straight right
0.278 ± 0.06 m	Hip anterior displacement during punch	DOCUMENTED	Same
0.655 ± 0.07 m	Fist anterior path, onset → impact	DOCUMENTED	Same
Trunk advance 201 ms before commit; fist travel 490 mm start→impact (one HW)	—	DOCUMENTED	Atha et al., 1985 (Bruno)

FightCamp read: a landed straight is not arm-only. ~25–30 cm of hip/COM toward the target is normal in max lab punches. Keep root/step or lean into contact when spacing is real.

Self-selected distance beats a fixed full-extension mark for jab impact (Loturco et al., 2016) — DOCUMENTED direction; cm of that preference NO STUDY.

3. How far a landed punch goes in
Quantity	Number	Label	Source
Head Δv (Hybrid III)	2.97 ± 0.81 m/s	DOCUMENTED	Walilko, Viano, Bir, 2005
Impact duration (accel)	~11.4 ms mean	DOCUMENTED	Same
Head displacement during contact (cm)	Not reported as cm	Integrate roughly → order ~1–2 cm of cg travel if Δv builds over ~11 ms from rest — INFERENCE only; neck/dummy fixed base ≠ free boxer	
Follow-through past impact	110 mm (11 cm)	DOCUMENTED	Atha et al., 1985
Residual fist velocity after impact	1.8 m/s	DOCUMENTED	Same
Rise time to peak force	14 ms	DOCUMENTED	Same
“Lift” equivalent of impulse on 100 kg	~8 mm vertical	DOCUMENTED metaphor	Same
Glove foam thickness (sparring IMF)	often ~40–50 mm	SECONDARY	Industry/padding guides
Glove compression ratio at high energy	~70% of padding (new/worn similar at high energy)	DOCUMENTED	Glove damping / compression-ratio apparatus papers
Absolute glove crush (cm)	~3–3.5 cm if 5 cm pad × 70%	INFERENCE from thickness × ratio	
Face / soft-tissue compression (cm)	—	NO STUDY in Walilko (frangible face loads, not mm crush)	

Watchability: fist should enter the contact volume ~5–15 cm (glove crush + follow-through), with a short head/torso give — not stop dead on a rigid surface, and not tunnel through the torso.

4. Reach — arm extension at contact
Claim	Answer	Label
Jab / cross / hook extension as % of full arm length	—	NO STUDY
Lab note: taller boxers sometimes hit the bag before full elbow extension (fixed plate setup)	qualitative	DOCUMENTED caveat
Self-selected stance distance > fixed “full arm” mark improves jab impact	direction	DOCUMENTED
How different reaches set bout distance	Prefer longer range if reach advantage; post-2013 elite profile “more long range / straights”	SECONDARY / Davis 2018 tactical summary

Use BoxMind’s L_arm bands (§1) until someone publishes contact elbow angle or % extension.

5. Inside fighting and the clinch
Measure	Number	Label	Source
Total clinch time / round (elite male Olympics)	R1 12.6 ± 11.0 s; R2 17.2 ± 12.1 s; R3 28.7 ± 17.7 s	DOCUMENTED	Davis et al., 2015, IJSPP activity profile
Clinch frequency / round	R1 2.5 ± 2.0; R2 3.2 ± 2.1; R3 4.8 ± 2.6	DOCUMENTED	Same
What “clinch” is	Fighters lock / hold, reduce space	DOCUMENTED (TMA definitions)	Women’s Worlds TMA 2025; Davis line
Chest contact distance (cm)	—	NO STUDY (metres between chests)	
Referee break → restart separation	—	NO STUDY	

Clinch ≈ body contact (overlap allowed only as grappling/hold state). After “break,” push them out to at least close/mid (~0.9–1.1 m feet-mid) — INFERENCE, not measured.

6. Other sports and games (labelled)
Combat sports
Claim	Label
Kickboxing / MMA published striking distances as bout means like Schortgen	NO STUDY found here matching 1.23 m-style boxing track
Taekwondo area tracking accuracy papers exist	DOCUMENTED but different sport
Games — anti-interpenetration
Claim	Label	Source
Capcom: collision box (push) keeps characters from overlapping; centred on body, not arms/legs; walking into someone pushes them	DOCUMENTED	Capcom SF Seminar Hour 7 — “Basics of Boxes”
Hitbox ≠ hurtbox ≠ collision box	DOCUMENTED	Same
UFC / Fight Night / Undisputed published metres for fighter spacing / capsule size	NOT FOUND	
Industry practice: kinematic pushboxes/capsules, resolve overlap horizontally	SECONDARY	Unity/Godot FG discussions

FightCamp: keep a body capsule / push volume so torsos never occupy the same space; allow fist hit volumes to enter the opponent’s hurt volume ~5–15 cm; drive contact with hip travel, not frozen roots.

Watchability checklist
Problem	Fix from evidence
Men pass through each other	Pushboxes; min separation ≥ ~0.7 m feet-mid except clinch
Punches miss visually	Raise mid to ~1.2 m; add ~20–30 cm hip/step into straights
Punch stops on surface	~11 cm follow-through + glove crush + short head give
Everything feels “inside”	Your 0.80–1.10 band is systematically short of elite 1.23 m mean
Sources
Schortgen A, Goyallon T, Reveret L, Moussa I, Sauliere G, Brezephin L. (2023). Automatic quantification of displacement and ring generalship… ECSS 28th Congress, Paris. https://www.ecss.mobi/DATA/EDSS/C28/28-2883.pdf
Schortgen et al. (2025). Monocular markerless position tracking of elite amateur boxing fighters… Journal of Sports Sciences (method / ~0.3 m error).
Sauliere / Schortgen et al. (2023). Quantifying and characterizing punches… ECSS — IMU + 15k+ annotated hits (companion).
Cheraghi M et al. (2014). Kinematics of straight right punch. Ann Appl Sport Sci 2(2):39–50.
Atha J, Yeadon MR, Sandover J, Parsons KC. (1985). The damaging punch. BMJ 291:1756–1757.
Walilko TJ, Viano DC, Bir CA. (2005). Biomechanics of the head for Olympic boxer punches to the face. Br J Sports Med 39:710–719.
Davis P et al. (2015). The activity profile of elite male amateur boxing. IJSPP 10:53–57. (clinch times)
Davis P et al. (2018). Activity profile after 2013 rule changes. JSCR 32:3450–3455. (long-range tactical note)
Loturco I et al. (2016). Strength and power… punching impact. JSCR 30:109–116.
Stanley E et al. (2018). 3D kinetics/kinematics of punches. Int J Perform Anal Sport 18:835–854.
BoxMind (arXiv, 2024 Olympics validation) — Long/Mid/Close = arm-length bands.
Capcom Shadaloo C.R.I. — Hour 7: Basics of Boxes (collision / push boxes).
Boxing glove damping / compression-ratio apparatus papers; IMF padding thickness guides (SECONDARY for cm crush).
Women’s Worlds finals TMA — Sports 2025 (clinch as lock phase).

GAPS: % time at long/mid/close in metres; inter-fighter distance at contact by punch type; arm extension %; face compression cm; referee restart metres; game capsule sizes in metres.
