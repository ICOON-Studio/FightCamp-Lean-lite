# K48 — WHEN A PUNCH LANDS: HOW FAR THE MAN WHO TAKES IT MOVES HIS FEET

Kalli, 2026-09-14 (task `research/TASK_K48.md`), delivered in chat in ~2 minutes; collected verbatim by Claude.
Tables arrived tab-separated from the chat and are kept as sent. COLLECTION NOTE (Claude): the 2025 force-plate
impulse row (jab 63.8 N s above cross 57.9 N s) carries an imprecise citation and reads like a ground-reaction
impulse, not an impact impulse; Atha et al. 1985 (41 N s into a ballistic target) is the solid impact number.

## DECISIONS
Boxing receiver foot travel after a landed punch (steps / cm / s): NO STUDY — no peer-reviewed bout or lab measure of the receiver’s step count, step length, or total displacement. Your mocap 0.37–1.44 m is not validated as real.
Nearest measured analogue (sudden push / waist-pull): young adults often take 1 (sometimes 2) compensatory step(s); first step ~25–33 cm; foot-off latency ~250–360 ms — DOCUMENTED (Maki & McIlroy line; training studies).
Impulse (DOCUMENTED): punch impulse roughly ~42–64 N·s (Atha; recent force-plate impulse papers). That does not require a 1+ m whole-body slide if the hit is mostly head rotation.
Clean head rock (INFERENCE from analogue + impulse, not bout data): 0–2 short steps, mostly straight back or slightly off-line; total travel often ≲ ~0.5–0.7 m before stance resets; reset time on the order of ~0.5–1 s from perturbation (foot-contact ~450–550 ms in lab steps).
Body punch that hurts but doesn’t drop him: foot travel NO STUDY; behaviour is often bend / brace / hold more than a long retreat — SECONDARY (coaching / clinical description).
Pre-knockdown stagger metres / step counts: NO STUDY. Do not author a fixed 1.44 m “realism” number.
FOOT LOCK: on a hit reaction that needs steps, release the plant; do not translate locked feet 0.37–1.44 m. Prefer short unlock + 1–2 steps over a skating root.
Games: hit travel is authored pushback per move, not measured boxing — Capcom says each attack has its own pushback (DOCUMENTED); metres for UFC/Fight Night/Tekken/Absolver reactions NOT FOUND.
1. Clean head punch that does not drop him
Question	Answer	Label
Does the receiver step?	Unknown in measured boxing data	NO STUDY
How many steps / step length (cm) / total displacement (cm) / direction / time to set stance (s)	No published numbers for receivers of jab/cross/hook	NO STUDY

What was measured (head / dummy — not feet):

Number	What it is	Label	Source
Peak punch force 3427 ± 811 N; hand velocity 9.14 ± 2.06 m/s; effective punch mass 2.9 ± 2.0 kg; head translational accel 58 ± 13 g; rotational 6343 ± 1789 rad/s²; impact ~11–13 ms	Olympic boxers → Hybrid III face	DOCUMENTED	Walilko, Viano, Bir (2005), Br J Sports Med 39:710–719
Impulse 41 N·s; peak force 4096 N; impact velocity 8.9 m/s; head model accel 53 g; “lift a 100 kg opponent ~8 mm”	Frank Bruno vs ballistic target	DOCUMENTED	Atha et al. (1985), BMJ 291:1756–1757

INFERENCE (physics, not fight footage): Atha’s impulse into a 100 kg whole-body mass gives Δv ≈ 0.41 m/s if all impulse coupled to COM — enough for a small rock, not a metre of skating. Most boxing head impacts dump energy into head rotation (Walilko), so COM Δv is smaller still. Feet may plant and brace (no step) or take short recovery steps; long 1+ m slides are not required by published impulse.

Direction: lab compensatory steps to AP perturbations are mostly backward (or forward for forward pulls). Lateral hooks would favour side / turn steps — INFERENCE from perturbation literature, not boxing video metrics.

2. Body punch (liver / solar plexus — hurts, doesn’t drop)
Metric	Answer	Label
Step count / length / total cm / time	—	NO STUDY
Bend vs step vs hold ground	Common description: torso folds, breathe, clinch or short retreat; clean liver shot can shut legs down without a measured stroll	SECONDARY (Wikipedia liver shot; coaching / fighter reports)

No peer-reviewed paper found that tracks foot markers of the receiver after a body shot. Do not invent a body-shot travel distance.

3. Stagger before knockdown / standing count
Metric	Answer	Label
Distance (m), steps, duration until fall / ropes / recover	—	NO STUDY

Bout time–motion papers count fighting/clinch/pause phases; they do not publish hurt-stagger displacement (e.g. women’s World Championships TMA, Sports 2025). AI tracking of sparring movement patterns exists but does not report knockdown-stagger metres in the abstracts reviewed.

INFERENCE: multi-step, irregular, often toward ropes — useful for animation variety, not a fixed 1.44 m claim.

4. Momentum — impulse and effective mass
Impulse / force (impact to target)
Punch / study	Number	Label	Source
Heavyweight max (Bruno)	Impulse 41 N·s; peak 4096 N (to padded target); est. up to 6320 N to unpadded head	DOCUMENTED	Atha et al., 1985
Olympic straight to Hybrid III	Peak force 3427 ± 811 N; effective punch mass 2.9 ± 2.0 kg; hand speed 9.14 ± 2.06 m/s	DOCUMENTED	Walilko et al., 2005
Trained boxers, force plate (jab / cross / hooks)	Impulse jab 63.80 ± 15.36 N·s; cross 57.90 ± 11.82 N·s; lead hook 42.39 ± 7.38 N·s; rear hook 43.87 ± 7.62 N·s	DOCUMENTED	Wąsik et al. / Appl. Sci. style punching study (2025), impulse table
Same cohort — effective mass (F/a)	Jab ~30.4 kg; cross ~31.2 kg (hooks lower EM despite high peak force)	DOCUMENTED	Same paper
Separate jab/cross EM study	Jab 18.95 ± 5.29 kg (~21.5% BM); cross 18.50 ± 5.56 kg (~21% BM)	DOCUMENTED	Appl. Sci. 2024, 14(17):7785 — different method/cohort; do not average blindly with the ~30 kg set
Lenetsky review	Conceptual EM; cites Walilko-scale ~2.9 kg punch EM for dummy work	DOCUMENTED review	Lenetsky et al., 2015, Hum Mov Sci

Physics bridge to feet (INFERENCE):

Whole-body Δv ≈ J / m_receiver if fully coupled. Example: J = 50 N·s, m = 75 kg → Δv ≈ 0.67 m/s.
Hof XcoM / capture-point rule: change foot placement by ≈ Δv / ω₀, with ω₀ = √(g/ℓ) ≈ 3.3 s⁻¹ for ℓ ≈ 0.9 m → ≈ 0.20 m for that Δv — order of one short step, not 1.4 m.
Multiple steps / leaning / unfinished capture → larger total path; still, 0.37–1.44 m as a default hit reaction is cinematic unless the fighter is already off-balance.
5. Nearest measured analogue — compensatory stepping
Young-adult numbers (platform / waist-pull — DOCUMENTED)
Measure	Typical range	Source
First step length (AP)	~0.25–0.33 m (25–33 cm)	Older-adult training study tables (young controls); Maki & McIlroy age-stepping line (~few cm age difference)
Posterior waist-pull step lengths (young vs old)	Young 29 cm and 14 cm (two cited studies); older 16.2 cm and 9 cm	Cited in age/threshold thesis summarizing Luchies; Schulz et al., 2005
Number of steps	Young often ~1.0–1.3 mean after learning; older higher (~1.5–2)	PMC4612504 tables
Step latency (perturbation → foot-off)	~0.25–0.36 s (250–360 ms)	Same
Foot-contact from onset (Maki & McIlroy 1996-style)	On the order of ~450–550 ms	J Gerontol A 51A:M289–M296 (timing columns in abstract/results extracts)
Hof placement rule	Foot/CoP shift ≈ Δv / ω₀	Hof et al., 2005, J Biomech; Hof, 2008, Hum Mov Sci
How far is this from a punch?
Factor	Punch	Lab push / waist-pull
Duration of force	~10–15 ms	Tens–hundreds of ms belt/waist pull
Point of application	Fist → head (high, rotational)	Trunk / platform (whole COM)
Expectation / sport set	Fighter braced, feet already staggered	Quiet stance, unexpected
Analogue quality	Rough for COM recovery steps; poor for head snap	Best available foot numbers

Label: compensatory-step magnitudes are DOCUMENTED; applying them as “what a jab does to feet” is INFERENCE with a large gap.

6. Fighting / sports games that publish hit-reaction travel
Title	Published travel distance / foot contacts on hit	Label
Street Fighter (Capcom seminar)	Each attack has its own unique pushback; stronger ≠ automatically more pushback in modern titles	DOCUMENTED — Capcom Shadaloo C.R.I. “Damage Part II”
SFV datamine	KnockBack float → distance ≈ KnockBack + KnockBack/RecoveryAnimationFramesDefender	SECONDARY (community reverse engineering) — game units, not metres of boxing
Tekken	Harada: manga-like launches, not real boxing physics	DOCUMENTED interview (feel); travel metres NOT FOUND
EA UFC / Fight Night	Planted-foot power on throwing punches marketed; hit-reaction travel / foot IK on receive NOT FOUND	—
Absolver	Stance-to-stance attack ends; hit travel metres NOT FOUND	—

No GDC/studio doc found that says “our hit reaction moves the defender X cm with N foot plants.”

Foot-lock implication (for S4a)
Clip travel	Realism status	Lock behaviour
≲ ~0.3–0.5 m, 1 step	Compatible with lab compensatory steps + impulse	Unlock lead/trail for that step; re-plant
0.37–1.44 m as default rock	Unvalidated vs boxing + overshoot vs Δv/ω₀	Prefer clip edit / root scale-down, or only use long travel for hurt / pre-KD states
Locked feet dragged 1 m	Fake skate	Never
Sources
Walilko TJ, Viano DC, Bir CA. (2005). Biomechanics of the head for Olympic boxer punches to the face. British Journal of Sports Medicine, 39(10), 710–719.
Atha J, Yeadon MR, Sandover J, Parsons KC. (1985). The damaging punch. British Medical Journal (Clin Res Ed), 291(6511), 1756–1757.
Lenetsky S, Nates RJ, Brughelli M, Harris NK. (2015). Is effective mass in combat sports punching above its weight? Human Movement Science, 40, 89–97.
Jab/cross effective mass ~21% BM — Applied Sciences 14(17):7785 (2024).
Impulse by punch type (jab ~64 N·s, cross ~58 N·s, hooks ~42–44 N·s) — punching biomechanics Applied Sciences / related 2025 force-plate study (Wąsik et al. lineage).
McIlroy WE, Maki BE. (1996). Age-related changes in compensatory stepping… J Gerontol A, 51A(6), M289–M296.
Older adults compensatory stepping training study — PMC4612504 (step length ~0.25–0.33 m; latency ~0.25–0.36 s).
Luchies / Schulz et al. posterior waist-pull step lengths — as summarized in age/threshold literature (young ~14–29 cm).
Hof AL, Gazendam MGJ, Sinke WE. (2005). The condition for dynamic stability. Journal of Biomechanics, 38, 1–8. (XcoM)
Hof AL. (2008). The extrapolated centre of mass concept… Human Movement Science, 27(1), 112–125.
Capcom — SF Seminar Hour 11: Damage Part II (pushback unique per attack). https://game.capcom.com/cfn/sfv/column/131545
Harada — Tekken systems / manga physics interview — Game Developer.
Liver shot physiology descriptions — Wikipedia / secondary clinical–coaching accounts (no foot metrics).

GAPS: receiver foot markers after live punches; body-shot foot travel; measured stagger-before-KD distance; published game hit-reaction metres for UFC/Fight Night.
