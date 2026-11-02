# K51 — WHAT A HIT MAN'S HEAD AND BODY DO IN THE FIRST HALF-SECOND

Kalli, 2026-09-14 (task `research/TASK_K51.md`), delivered in chat in ~3 minutes; collected verbatim by Claude.
Tables arrived tab-separated from the chat and are kept as sent.

## DECISIONS
Onset: head acceleration peaks ~3–4 ms after contact; the impact pulse is only ~11–15 ms — DOCUMENTED (Walilko 2005). The “fake” look is often a reaction that starts too late or lasts too long.
Straight to the face (Hybrid III): ~58 g linear, ~6343 rad/s² rotational (mostly yaw about vertical for a jaw/chin hit in their setup), head Δv ~3.0 m/s — DOCUMENTED.
Hook: highest of the measured punches — ~71 g, ~9306 rad/s² — DOCUMENTED (Viano et al., 2005). Uppercut lower (~24 g, ~3181 rad/s² in the same punch-type series as cited later) — DOCUMENTED via Viano punch-type range.
Peak head rotation in degrees / cm at 50–100–200 ms: NO STUDY for free boxers (labs report accel/Δv, not pose degrees or timed centimetres).
Trunk with the head: receiver torso bend/turn degrees — NO STUDY. Neck shear is large (~1 kN); bracing/anticipation reduces head ΔV and Δω — DOCUMENTED (Eckner et al.), but high-speed impact coupling is debated.
Body punches (liver / solar plexus): clinical fold / breath loss — SECONDARY; flexion/side-bend degrees and ms — NO STUDY.
Recovery to guard (non-hurt vs hurt): NO STUDY in biomechanics. Use game hitstun only as design, not truth (~0.15–0.35 s stuck — SECONDARY).
Clip retiming: snap the head in the first ~10–20 ms; keep motion through ~100–200 ms; don’t wait a full half-second to start the head.
1. Head rotation (degrees + axis + time to peak)
Punch	Peak head rotation (°)	Axis	Time to peak (ms after contact)	Label
Jab / cross to face	—	—	Peak rotational accel ~3 ms (not peak angle)	Degrees: NO STUDY. Timing of peak accel: DOCUMENTED Walilko
Hook to jaw	—	—	—	Degrees: NO STUDY
Uppercut to chin	—	—	—	Degrees: NO STUDY

What was measured instead (acceleration / velocity, dummy or video):

Punch / study	Linear	Rotational	Axis notes	Label	Source
Olympic straight to jaw (Hybrid III)	58 ± 13 g; pulse ~11.4 ms	6343 ± 1789 rad/s²	Calculated about y (lateral axis → head nod/pitch component in their 2D method for that setup)	DOCUMENTED	Walilko, Viano, Bir, 2005, BJSM 39:710–719
Example flyweight straight	Peak rot 5209 rad/s² @ ~3 ms; peak lin 68 g @ ~4 ms; contact ~13 ms	—	—	DOCUMENTED	Same, Fig. 5
Olympic hook (Hybrid III + torso)	71.2 ± 32.2 g	9306 ± 4485 rad/s²	Highest of four punch types; more rotational share than NFL	DOCUMENTED	Viano et al., 2005, Neurosurgery (“Boxing Head Impacts—Part 10”)
Uppercut (same Viano punch series, as cited)	24.1 ± 12.5 g	3181 ± 1343 rad/s²	Lower than hook	DOCUMENTED (via later citations of Viano)	Sensors 2023 iMG validation citing Viano boxing reconstructions
Amateur jab vs hook (older Hybrid III mount)	Jab 21.5 ± 4.6 g; hook 43.6 ± 15.6 g	Jab 293 ± 72; hook 676 ± 231 rad/s²	Hook > jab	DOCUMENTED	Smith, Bishop, Wells, 1988, IRCOBI
Volunteer boxing (Pincemaille et al.)	—	Accel up to ~13 600 rad/s²; rot. vel. ~48 rad/s (~2750 °/s)	No concussion reported in that series	DOCUMENTED	Cited in Walilko discussion (SAE 892435)
KO vs non-KO video angular velocity	—	KO pitch 1200 ± 202 °/s; yaw 744 ± 64 °/s; roll 502 ± 59 °/s (vs lower NKO)	Axis-split peak ω, not ° of turn	DOCUMENTED	“Concussions in Boxers: Head Rotations and Neck Stiffness” journal article

INFERENCE for animation (not measured °): straights = short back/side snap; hooks = larger yaw/tilt; uppercuts = more pitch (chin up). Peak angle arrives after the ~10 ms accel spike as the head keeps swinging on the neck — don’t treat peak accel time as end of the reaction.

2. Head translation (cm at 50 / 100 / 200 ms) + Δv / accel
Window after contact	Head translation (cm)	Label
0–50 ms	—	NO STUDY (pose cm in free boxers)
0–100 ms	—	NO STUDY
0–200 ms	—	NO STUDY

Measured kinematics (impulse window):

Quantity	Number	Label	Source
Head Δv (straight, Hybrid III)	2.97 ± 0.81 m/s	DOCUMENTED	Walilko 2005
Peak translational accel	58 ± 13 g (straight); 71 ± 32 g (hook)	DOCUMENTED	Walilko; Viano 2005
Peak rotational accel	~6.3×10³ (straight); ~9.3×10³ rad/s² (hook)	DOCUMENTED	Same
Effective punch radius about head cg	Boxing ~65 mm vs football ~34 mm (more rotation per unit force)	DOCUMENTED	Viano 2005
MMA iMG (spar + fights)	Mean PLA 38.0 ± 24.3 g; PAA 2567 ± 1739 rad/s²; concussive-bout peaks ~87 g, ~7561 rad/s²	DOCUMENTED	Tierney / MMA mouthguard concussion study, 2020
Boxing vs MMA exposure	MMA often higher angular accel than boxing	DOCUMENTED	Characterizing head impact exposure boxing/MMA, 2021
Lab iMG validation range (rugby/boxing-like drops)	16–171 g, 1330–10 164 rad/s², 11.3–41.5 rad/s, 6–18 ms	DOCUMENTED	Sensors 2023 mouthguard paper

Rough impulse displacement (INFERENCE only): if Δv ≈ 3 m/s builds over ~11 ms, head cg moves on the order of ~1–2 cm during the contact pulse. Visible travel over 50–200 ms is mostly post-impact neck swing and is unmeasured in cm — scale reaction clips so the first centimetres are early, not delayed.

3. Neck and trunk
Claim	Answer	Label
Torso rotation/bend with the head (°) for a faced punch	—	NO STUDY
Neck shear load (straight)	994 ± 318 N	DOCUMENTED
Hook average neck load	855 ± 537 N	DOCUMENTED
Greater isometric neck strength → lower head ΔV and Δω after impulsive loads (all planes)	Yes; correlations r ≈ 0.42–0.66	DOCUMENTED
Anticipatory cervical activation (“brace”) → lower ΔV and Δω vs relaxed	Yes (independent of strength)	DOCUMENTED
High-speed blunt impacts: muscle state may change kinematics only ~few % (weak short-term coupling)	Mixed; some models ~6% class differences	DOCUMENTED debate
Kickboxing aware vs unaware punch (neck EMG + ROM)	Aware vs unaware flexion/extension angles differ (e.g. extension ~6° vs ~29° in one report)	DOCUMENTED (kickboxing, not boxing)

FightCamp: seen punches → smaller head whip; surprise/hurt → larger. Trunk can follow slightly after the head, but don’t invent torso °.

4. Body punches (liver / solar plexus)
Measure	Answer	Label
Trunk flexion / side-bend (°) and time	—	NO STUDY
Clinical / coaching	Liver: delayed shutdown, fold, hard to stand; solar plexus: winded, forward crumple	SECONDARY

Animate a torso-first crumple (side bend for liver, forward for solar plexus), not a head snap — without claiming measured degrees.

5. Onset and recovery
Event	Timing	Label
Contact → peak head accel	~3–4 ms	DOCUMENTED
Contact pulse ends	~11–15 ms typical boxing dummy	DOCUMENTED
First passive head motion	Starts with the pulse (immediate)	INFERENCE from accel onset
First voluntary postural correction	Often ~100–250+ ms (neck/step literature)	INFERENCE / related DOCUMENTED step latencies (K48)
Back in guard / countering (clean, not hurt)	—	NO STUDY
Hurt / rocked recovery	—	NO STUDY

Clip rule: reaction animation should be front-loaded. If mocap “winds up” for 100 ms before the head moves, retime so motion begins at contact (or add 2–4 frames of hit-stop — see §6).

6. What games do (design, not biomechanics)
Concept	Typical published values	Label	Source
Hitstun	Defender stuck in reel; duration move-specific	SECONDARY (game design)	Capcom SF Seminar / SF6 Game Data (SuperCombo)
Hitstop / hit freeze	Both chars freeze on impact; heavier = longer; helps readability	DOCUMENTED as design intent	Capcom / SF6 wiki
SF light hitstun (community example)	Order of ~10–14 frames (~167–233 ms at 60 fps)	SECONDARY	Community frame breakdowns (not official universal table)
SF6 frame data	Official sheets give advantage on hit/block, not a single “reaction length” for all moves	DOCUMENTED	streetfighter.com character frames
Tekken	Move-specific on-hit advantage; some moves note hitstop 20f (~333 ms)	SECONDARY	TekkenDocs / char frame sites
UFC / Fight Night published ms for hit reactions	—	NOT FOUND	

Use: ~2–8 frames (33–133 ms) of shared freeze for “weight,” then a 150–400 ms reel for a clean hit — game design, not a claim about human physiology.

Retiming checklist for “punches look fake”
Symptom	Likely cause	Fix from evidence
Head waits then slowly turns	Reaction starts after ~100 ms	Start head at contact; peak snap by ~20–40 ms
Head barely moves on a hook	Under-rotation vs Viano hook severity	Hooks need more rotational response than straights
Uppercut looks like a jab	Wrong axis	Uppercut → pitch; hook → yaw/tilt
Same reaction every time	No brace variation	Seen punch → damp; surprise → amplify
Endless stun on a jab	Overlong recovery	Clean hit: recover toward guard inside ~0.3–0.5 s (design band; NO STUDY)
Sources
Walilko TJ, Viano DC, Bir CA. (2005). Biomechanics of the head for Olympic boxer punches to the face. Br J Sports Med 39:710–719.
Viano DC et al. (2005). Concussion in Professional Football: Comparison with Boxing Head Impacts—Part 10. Neurosurgery.
Smith TA, Bishop PJ, Wells RP. (1988). 3D linear and angular accelerations of the head in boxing. IRCOBI.
Pincemaille Y et al. (1989). Volunteer boxer head tolerance data. SAE 892435 (as cited by Walilko).
Tierney et al. / MMA instrumented mouthguard concussion severity study (2020), Proc Inst Mech Eng H.
Characterizing head impact exposure in boxing and MMA (2021), Orthop J Sports Med.
Instrumented mouthguard lab validation (2023), Sensors 23:7068.
Eckner JT et al. (2014). Neck strength and anticipatory activation vs head kinematics. Am J Sports Med.
Eckersley / Duke head-neck modelling on cervical muscle role in blunt impact (mixed effect sizes).
Kickboxing aware/unaware neck EMG study (2023), BMC Musculoskelet Disord.
Video KO vs NKO head angular velocities (pitch/roll/yaw) — combat sports journal article on rotations and neck stiffness.
Capcom SF Seminar / SF6 Game Data — hitstun, blockstun, hitstop.
Official SF6 frame data (streetfighter.com); TekkenDocs hitstop notes — SECONDARY for exact frames.

GAPS: peak head degrees by punch type; head cm at 50/100/200 ms; receiver trunk °; body-punch kinematics; human recovery-to-guard times; EA sports hit-reaction ms.
