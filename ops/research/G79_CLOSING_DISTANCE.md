# G79 - how close do real fighters get, and how fast? (Grok, collected S61 2026-09-23)

VERBATIM from grok.com chat "MMA Stand-Off Distances: Measured Data"
(https://grok.com/c/e57e8694-3988-4897-afe1-576c58ba2cd5), Expert mode. Collected by Claude.

Claude's read, not Grok's: the live centimetre series the engine-separation stage wants (MMA and Muay
Thai IPD, timed range->clinch entry, blitz COM speed) are NOT FOUND. Usable: the boxing
1.23 +- 0.16 m mean (a MEAN, not a floor), the judo 70-80 cm grip-fight IPD peak, the 0.7-2.7 m/s
DERIVED closing bound, and the per-ruleset referee-break rules. The "engine-safe band" at the end is
Grok's judgement and labelled so. Check the arxiv id 2601.11492 and "IFMA 2026" before citing either
in code.

---

TASK_G79 — how close, how fast (measured)

Judgement labels: MEASURED (live or lab, N given) · SCALED/DERIVED (from arm length or kinematics, not live IPD) · RULE (written, not timed) · NOT FOUND.

1. Standing exchange — centre-to-centre / punching range
Source	Pop / N	Number	Label
Schortgen, ECSS 2023 (your hold)	elite boxers	1.23 ± 0.16 m apart	MEASURED — I could not retrieve the paper to re-check N or marker set (COM vs chest). Treat as the best live boxing IPD we have.
Hristovski, Davids & Araújo 2006, J Sports Sci Med 5 CSSI-1:60–73	novice boxers vs static bag, small N (order ~6–10; paper does not report a large live-dyad N)	Punch repertoire lives at scaled D = X / arm-length ≈ 0.45–0.65. Jabs die at D ≈ 0.45. Guard-only at D > 1.2. Max switching at D ≈ 0.6.	SCALED. Convert: adult male arm ~0.64–0.70 m (from ~1.78 m stature, Stanley 2018 n=15 amateurs). So bag-surface range ≈ 0.30–0.85 m. Add two half-torsos (~0.20–0.25 m) → centre-to-centre roughly 0.7–1.1 m for hooks/uppercuts, ~1.1–1.4 m for jabs. Bag ≠ live opponent.
Luis del Campo & González, Rev Psicol Deporte 2017	n=8 boxers (4 advanced, 4 novice)	Floor marks at 0.75 / 0.85 / 0.95 m (“slightly longer than opponent’s extended arm”) used as short/mid/long.	MEASURED setup distances, not free-sparring IPD.
BoxingStudio / FastMove annotation scheme (arxiv 2601.11492)	national-team sparring, 30 rounds	Taxonomy only: long d > 1.0 Larm, mid 0.5–1.0 Larm, close < 0.5 Larm.	DEFINITION, not a measured mean.
Stanley et al. 2018, Int J Perform Anal Sport	n=15 amateur men, 1.78 ± 0.1 m	Peak fist vel: jab 5.85, cross 6.97, lead hook 11.95 m/s. Delivery 405–657 ms.	Punch kinematics, not IPD.
Maloney et al. 2021 taekwondo	competitive TKD dyads	Most fight time at IPD 101–200 cm (60 ± 8%). Peak band ~1.5–1.8 m.	MEASURED, wrong weapon (legs). Use only as “kicking sports stand farther.”
MMA live punching-range IPD (COM or chest)	—	—	NOT FOUND. Miarka et al. give time in “keeping distance” (feather ~131 s/round, heavy ~179 s/round; 2,814 UFC rounds) but no metres.
Muay Thai punching-range IPD	—	—	NOT FOUND.

Closest hook/uppercut before clinch: no live centimetre series. Hristovski: hooks/uppercuts occupy the short end of D (≈ 0.45–0.6 L ≈ 0.3–0.4 m fist-to-target). Live chests are then roughly 0.6–0.9 m centre-to-centre before a collar/plum locks. Anything under ~0.5 m COM is already a clinch.

2. Clinch entry — chest-to-chest distance and time to get there

Distance

Source	Pop / N	Number	Label
Krabben et al. 2022, J Sports Sci (judo grip-fight)	judoka dyads, gaze/IPD study	IPD frequency peaks at 70–80 cm; analysis window 50–100 cm.	MEASURED. Best analogue for collar-tie / over-under. Not Muay Thai plum.
Okumura et al. 2012 PLoS ONE kendo	12 matches	Contact peak 1.00–1.10 m (tsubazeriai, sword still between them).	MEASURED, wrong implement.
Muay Thai plum / boxing collar-tie / MMA over-under chest-to-chest	—	—	NOT FOUND as a taped centimetre. Coaching: hips flush, foreheads touching. Spine-to-spine is then ~0.25–0.40 m (two chest depths). Treat as anatomy, not a study.

Time, punching range → clinch

Source	Pop / N	Number	Label
Analysis of a Boxing Match – Pilot (2016)	1 match, 12 rounds split	“Clash” 1.9 ± 0.9 s. Attack 0.7 ± 0.2 s.	MEASURED, N=1 fight. Clash ≠ successful plum.
Sannicandro et al. 2025, IBA 2023 Women’s Worlds finals	12 finals	Clinch phase duration 4.06 ± 2.27 s (time in clinch, not entry). Punch phase ~1.5–2 s.	MEASURED.
Punch delivery (Stanley 2018)	n=15	0.40–0.66 s per punch	Too short to be an entry.
Timed “last punch range → first locked collar/plum/underhook”	boxing / MT / MMA	—	NOT FOUND.

3. Closing speed (body, not fist)

Fist speed is not closing speed. Do not use 6–12 m/s.

Source	Pop / N	Number	Label
Thomson PhD / BOXFIT GPS	amateur boxing simulation	Mean locomotion ~0.6 m/s, ~36 m·min⁻¹.	MEASURED session average. Includes circling. Not a blitz.
Cheraghi et al. 2014, straight-right kinematics	small amateur sample	Hip peak 1.1–1.8 m/s; hip travels 0.20–0.35 m during the punch.	MEASURED punch-step, not a 1 m close.
Forward-step 3D MA (2024, boxer CMS candidate)	n=1	Step length 0.15–0.17 m, stance phase 0.72 s.	Walking-scale step.
Level-change / double-leg / “blitz” COM speed in live MMA	—	—	NOT FOUND.
Derived bound (not a study)	0.4–0.8 m closed in 0.30–0.60 s	~0.7–2.7 m/s peak COM	DERIVED. Upper end is a committed shot; lower end is a jab-step. Do not put 3+ m/s on a standing boxer.

4. Referee break — stall clock and reset distance
Ruleset	Stall clock	Reset distance	Label
Boxing (IBA 2023 Ref/Judge regs; ABC ref manual)	No seconds. “Break” on prolonged holding. If they ignore the call, tap/separate. Infighting that is clean is not broken.	Both take one full step back. Physical break is to arm’s length. Against ropes, no need to walk them to centre.	RULE. Timed stall: Sannicandro AI phase ~4–6 s; clinch itself ~4 s before a break is common in that women’s sample.
Muay Thai — MuayThai GB 10.1.6	Referee counts in mind, not exceeding 5 s, if neither delivers appropriate technique → Stop + Break.	Separate at least 2 steps, then “Chok”.	RULE + a 5 s mental cap.
Muay Thai — WBC MuayThai	Continues while scoring. Brief work-for-position allowed. Stop if both throw weak shots, neither can gain position, or one has a lock with no score.	Not specified in metres.	RULE. No fixed seconds.
Muay Thai — IFMA 2026	Clinch legal until “YAEK”. No fixed time limit in the book.	Step back, wait for “CHOCK”.	RULE.
MMA — ABC Unified Rules	No seconds. Break / stand-up when neither shows real, significant, sustained effort to finish. Holding a “better” position is not enough.	Back to a free standing distance (not specified). Cage clinch often reset in place.	RULE. Practice: Herb Dean has broken dead cage clinches at ~5 s (anecdote, not a study). McGregor’s 30→10 s clock is not the rule.

5. Argue against yourself — what would mislead the engine
Schortgen 1.23 m as a hard floor. That is a mean standing IPD, not a minimum. Hooks, uppercuts, and the last frame before a collar-tie sit 0.3–0.5 m closer. A 1.23 m engine floor will look like two men jabbing in a corridor and will never allow a hook to land clean.
Fist velocity as closing speed. 8–12 m/s is the glove. COM during a step-in is ~1–2 m/s. Using fist speed as a blitz will teleport the body through the opponent.
Hristovski D on a bag, used as live COM distance. D is performer-to-bag-surface / arm. Live COM–COM adds two torso half-depths and a moving target. Importing D=0.6 as 0.60 m COM will bury them inside each other.
Judo 70–80 cm as Muay Thai plum. Grip-fighting IPD includes extended arms. A locked plum / body-lock is tighter (~0.25–0.40 m spine-to-spine). Using 0.75 m as “clinch” keeps a visible air gap the 3D will still want to resolve.
One min-distance for all weights. Reach spans ~1.60 m (straw) to ~1.95 m (HW). A flyweight punching range is not a heavyweight’s. Scale min-distance to arm length (Hristovski), not a constant metre.
A fixed referee timer. Boxing breaks on holding, MT on no scoring work (GB ~5 s mental), MMA on no finish attempt. A global 3 s auto-break will butcher Thai clinch scoring and legal MMA cage work.
Session-mean 0.6 m/s as the entry. That is circling. Entries are short pulses. Cap COM close at ~2.5 m/s; anything faster is a sprint, not a fight step.

Engine-safe band (judgement, not a study):

keep-apart floor while punching ≈ 0.85–1.10 m COM (scale by mean arm).

allow down to ~0.55–0.70 m for hook/uppercut frames.

clinch lock ≈ 0.28–0.40 m COM.

close a 0.4–0.6 m gap in 0.25–0.50 s (≈ 1.0–2.0 m/s).

boxing break: 1 step / arm’s length after a stall of order 3–6 s.

MT: allow work; break ~5 s of dead lock, reset 2 steps.

MMA: no clock; break only on no advance.

147 sources
