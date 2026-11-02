# The timeline of a punch: when feet, hips, shoulders and fist move, and when the body comes back

Kalli, 2026-09-14 (task `research/TASK_K54.md`), delivered in chat in ~5 minutes; collected verbatim by Claude.
Tables arrived tab-separated from the chat and are kept as sent.
COLLECTION NOTE (Claude): (1) Kalli's 'Operator ease body clip-start to contact' is Claude's warp design note, not an operator figure. (2) OPERATOR, 2026-09-14, verbatim, while this study was running: 'Trying to find how to do a jab by studies and calculate it with cm I think is dumb, there is no way we will find this kind of data because no one has done such detailed study, it is not how sports work. You need to find other ways' - kept as context only; technique detail now comes from the motion capture itself, our rig's limits, paired captures, real fight video measured in body proportions, and the operator's eye.

## DECISIONS
Onset order (cross, measured): ankle → knee → elbow extension begins ~45% / 60% / 80% of the punch cycle (ankle-onset→impact). Peak angular vel before impact: ankle ~71 ms, knee ~95 ms, hip ~148 ms, elbow ~212 ms (means; wide SDs). Fist linear peak 8–21 ms before contact. DOCUMENTED (Cheraghi 2014; Whiting 1988).
Jab/cross show proximal→distal at shoulder/elbow (shoulder peaks ~8–12% of the clip before elbow). Hooks/uppercuts do not — elbow peaks before shoulder. DOCUMENTED (Stanley 2018).
Hip curve: hip angular peak ~109–148 ms before impact (Cheraghi). Linear hip still-moving-at-impact: NO STUDY. Do not ease body from frame 1 of the clip. DOCUMENTED / NO STUDY.
Fist back to guard (retract): experienced ~169 ms (cross/hook), ~171 ms (uppercut), ~262 ms (jab) after release. DOCUMENTED (Menzel & Potthast 2021). Hip/body return cm & ms: NO STUDY.
Combinations: CONTACT₁→CONTACT₄ ~1.04–1.06 s (alternate-hand) / 1.35 s (same-hand); next PROJ waits for previous IMPACT. Per-gap jab–cross ms not published as a named pair. DOCUMENTED (Piorkowski 2011).
Games: startup / active / recovery are hitbox frames; published root-motion / warp window vs hit frame for boxing titles: NO STUDY.
Operator “ease body clip-start→contact, then return”: wrong shape — legs start early; fist peaks late; retract is ~0.17–0.26 s for the fist alone. INFERENCE.
Lead-foot onset ms before impact (all punch types): NO STUDY.
1. Onset order (kinetic chain)

Times are before impact unless noted. Conventions differ by paper (cycle %, clip %, absolute ms).

Straight right / cross — Cheraghi 2014 (best segmental clock)

Punch cycle = ankle onset → impact. Fist duration (fist onset→impact) = 310±60 ms.

Event	When	Label
Ankle / knee / elbow extension begins	~45% / 60% / 80% of punch cycle	DOCUMENTED
Elbow concentric (extend) onset	ConTime 105±20 ms before impact	DOCUMENTED Table 2
Elbow peak angular vel	MaxωTime 212±350 ms before impact (huge SD)	DOCUMENTED
Hip peak angular vel	148±40 ms before impact	DOCUMENTED Table 3
Hip peak angle	109±30 ms before impact	DOCUMENTED
Knee peak angular vel	95±60 ms before impact	DOCUMENTED Table 4
Ankle peak angular vel	71±50 ms before impact	DOCUMENTED
Shoulder near max angle	~2±10 ms before impact (essentially at impact)	DOCUMENTED
Attacker head Vₓ / V_z peaks	~75% / ~85% of cycle	DOCUMENTED
Fist max linear vel	reached before impact (Whiting: 8–21 ms prior)	DOCUMENTED Whiting 1988

Order (cross): distal leg drive starts first in the cycle → hip peaks mid-late → elbow extends late → fist peaks in the last ~20 ms → contact. DOCUMENTED.

Lead foot / rear foot onset as separate markers in ms: NO STUDY (Cheraghi tracks ankle angle, not which foot’s translation starts).

Jab & cross — Stanley 2018 (shoulder/elbow % of delivery)

Delivery = initiation→contact. Peak timing (% of movement):

Punch	Peak shoulder %	Peak elbow %	Prox→distal?
Jab	87±7	98±2	Yes (~12% earlier at shoulder)
Cross	91±8	99±1	Yes (~8.5%)
Lead hook	92±12	81±10	No (elbow first)
Rear hook	97±2	84±11	No
Lead uppercut	96±1	76±5	No
Rear uppercut	96±1	75±7	No

DOCUMENTED (Stanley Table 2). Example jab delivery 405 ms → shoulder peak ~53 ms before contact, elbow ~8 ms before (INFERENCE from %×delivery).

Delivery times (initiation→contact): jab 405±150, cross 495±150, lead hook 657±145, rear hook 586±96, lead UC 627±103, rear UC 606±100 ms. DOCUMENTED.

Hooks — qualitative sequence

Shoulder: abduction → flexion → protraction → adduction from start to contact; elbow ~fixed ~90°. DOCUMENTED (Piorkowski 2011; Whiting 1988; Gatt 2021 citing). Absolute onset ms for each shoulder phase: NO STUDY.

Trunk onset ms

Trunk/torso start time before impact by punch type: NO STUDY (Atha separates a 201 ms pre-punch trunk advance from the punch proper — build-up/feint, not the committed punch). DOCUMENTED (Atha 1985, one subject).

2. The hip’s own curve
Question	Answer	Label
When hip forward travel starts (ms vs fist onset / impact)	Absolute start of hip AP translation: NO STUDY. Cycle-wise, hip moves within the leg-drive phase after ankle onset (Cheraghi).	NO STUDY / pattern DOCUMENTED
When hip is fastest	Hip Maxω 148±40 ms before impact; HipMaxV 1.6±0.2 m/s (peak speed magnitude, not timed)	DOCUMENTED Cheraghi
When hip stops	Hip MaxAngle 109±30 ms before impact (angular). Linear AP stop time: NO STUDY	DOCUMENTED / NO STUDY
Still moving forward at impact?	Total HipXDisplacement 27.8±6 cm is to impact — does not prove V_hip>0 at contact. Linear hip velocity at impact: NO STUDY	NO STUDY
Hip vs fist onset	Fist duration 310 ms; hip peaks ~110–150 ms pre-impact → hip peaking while fist still accelerating.	INFERENCE from Cheraghi tables

Warp timing read: body travel should ramp with leg/hip, not from fist-frame 0; peak body ease near mid–late clip; do not assume hip is frozen at contact without data. INFERENCE.

3. After impact (return)
Fist back to guard

Menzel & Potthast 2021 (Sensors 21:7882) — experienced athletes; phases = throw (guard→first contact) / contact / retraction (release→defensive position):

Punch	Throw	Contact	Retraction	Total
Cross	111±41	122±18	169±41	402±65
Hook	91±50	141±29	168±97	441±104
Jab	117±25	144±27	262±42	523±63
Uppercut	71±36	143±34	171±33	385±65

All ms. DOCUMENTED (Table 6, experienced). Jab retracts slowest.

Whiting: peak fist vel 8–21 ms before bag contact (already decelerating into the hit). DOCUMENTED.

Hips / body return
Hip or COM return time (ms) and distance (cm) after impact: NO STUDY.
Whether body is still forward while fist retracts: NO STUDY.
Inside a combination (2nd punch vs 1st impact)

Piorkowski 2011: for combinations, PROJ (forearm toward target) does not start until IMPACT of the previous punch. CONTACT ≈ 20 ms before IMPACT. DOCUMENTED.
→ Second punch’s arm drive starts at/after first contact, not mid-retract of a measured body reset. Body reset between punches: NO STUDY.

4. Combinations
Inter-punch intervals

Piorkowski 2011 — four-punch sequences; combination sequence time = CONTACT₁ → CONTACT₄:

Mode	CONTACT₁→CONTACT₄	Implied mean gap (÷3)
In-synch left lead (L-R-L-R)	1.06±0.46 s	~353 ms
In-synch right lead	1.04±0.42 s	~347 ms
Out-of-synch (same hand)	1.35±0.27 s	~450 ms

Sequence times DOCUMENTED; per-gap ÷3 is INFERENCE (assumes equal spacing — not verified).

Named jab–cross or jab–cross–hook intervals only: NO STUDY (in-synch is alternate-hand fours, not that labelled string).

Delivery ACTION→CONTACT shorter in combinations than single maximal (single max mean 607±221 ms vs in-synch ~320 ms). DOCUMENTED. Less counter-movement in combos (qualitative). DOCUMENTED.

Bout rates (not inter-punch ms): ~20 punches/min, ~1.4 actions/s, 2-punch combos common (Davis 2015). DOCUMENTED activity profile; not lab inter-punch timing.

Body travel across punches

Whether COM keeps drifting forward through a combo or resets: NO STUDY.

5. What games do (game design)
Source	What is published	Body-move vs hit frame	Label
Fighting-game frame data (SF etc.)	Startup (to first active) / Active (hitbox live) / Recovery (return) at 60 fps	Describes when the move can hit, not when root motion translates the body	SECONDARY
Example: Ryu-style standing MP often cited ~7f startup, few active, ~12f recovery	Gameplay frames	No official “lunge starts on frame X of startup” for boxing sims	SECONDARY
EA MMA / UFC / Fight Night	Relative IK, touch tags, layered blends	No published warp window (ms/% of clip) vs contact frame	SECONDARY (prior K52/K53)
UE Motion Warping	Designer sets notify window on montage	Engine tool, not a shipped boxing number	SECONDARY

Published timing of lunge / root-motion / warp relative to the hit frame in boxing/fighting games: NO STUDY.

FightCamp read: drive body with leg/hip early (Cheraghi 45–60% of cycle); keep fist peak in the last ~20 ms; after contact, fist guard return ~170–260 ms (Menzel) — body return still unknown, so don’t invent a matching hip slide-back; in combos, next arm PROJ at previous IMPACT (Piorkowski), not after a full body reset.

Sources
Cheraghi M et al. (2014). Kinematics of Straight Right Punch in Boxing. Ann Appl Sport Sci 2(2):39–50.
Whiting WC, Gregor RJ, Finerman GA (1988). Kinematic analysis of human upper extremity movements in boxing. Am J Sports Med 16(2):130–136.
Stanley E et al. (2018). 3D kinetics and kinematics of maximal effort punches… Int J Perform Anal Sport 18(5):835–854.
Piorkowski BA, Lees A, Barton GJ (2011). Single maximal versus combination punch kinematics. Sports Biomech 10(1):1–11.
Menzel T, Potthast W (2021). Application of a Validated Innovative Smart Wearable… Sensors 21(23):7882.
Atha J et al. (1985). The damaging punch. BMJ 291:1756–1757.
Dinu D, Louis J (2020). Biomechanical Analysis of the Cross, Hook, and Uppercut… Front Sports Act Living.
Davis P et al. (2015). The Activity Profile of Elite Male Amateur Boxing. Int J Sports Physiol Perform 10(1):53–57.
Lenetsky S et al. (2020). Defining the phases of boxing punches: a mixed-method approach. J Strength Cond Res 34(4).
Loturco I et al. (2016). Strength and power qualities… punching impact. J Strength Cond Res 30(1):109–116. (sequence qualitative, not ms.)
Fighting-game frame-data primers / SuperCombo wikis — startup–active–recovery (SECONDARY).
EA MMA / UFC procedural animation write-ups (K52/K53) — no warp-ms vs hit.
7:52 AM
How was this result?
👍
👎
