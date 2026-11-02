# G77 - generate two-person grappling without filming (Grok, Expert, verbatim)

Source: grok.com/c/aa15e63e-d431-4358-91db-20bd8ee5909c, collected 2026-09-23 (S60) by Claude
from the in-app browser. Task: `TASK_G77_GENERATE_TWO_BODIES.md`. 128 sources cited in-chat.
Tables were tab-separated in the chat and are kept as such.

---

G77 — generation route only. Numbers below are paper-measured or labelled judgement.

## 1. Two-person skeleton generators

Joint-level contact: only InterControl does what InterControl claims. Per-joint pair {j1, j2, t_start, t_end, contact|avoid, distance_m} + IK/BFGS. Matches your contact-probe (attacker hand → victim neck). Everyone else is text / actor-motion / implicit tokens.

Model	Out	Joint-distance control	Win + 1 NVIDIA	Code	Weights	Train data	Combat in data	Commercial game
InterControl (NeurIPS 2024)	22-j skeleton + SMPL .npy/.obj	Yes — pair distance + time window	Yes (CUDA, one GPU)	MIT	Released, MIT	HumanML3D / KIT (single-person). Zero-shot pairs	AMASS sliver of martial arts; no paired grappling	Code/weights: yes. AMASS-derived prior is the residual legal risk on shipping weights, not baked clips. Best academic licence of the set.
InterGen	SMPL 22-j .npy	No. Spatial regularizers only	Linux official; Win = WSL (judgement)	CC BY-NC-SA 4.0	Same NC	InterHuman BY-NC-SA, no redistribute	Yes. Paper split: Daily 39%, Taekwondo 11%, Latin 11%, Shaolin 6%, Tai Chi 6%, Xingyi 5%, Bagua 5%. Boxing in captions. Not BJJ.	No — dataset + weights NC
in2IN + DualMDM	InterHuman motion	No	1 GPU	LICENSE file present; text not reviewed here	Released	InterHuman + HumanML3D	Same as InterHuman	InterHuman NC poisons weights
InterMask (ICLR 2025)	22-j or Inter-X 56-j SMPL-X	No. Reaction mode exists (freeze one person)	1 GPU	MIT	GDrive ckpts	InterHuman + Inter-X	InterHuman martial arts; Inter-X = 40 daily categories	MIT code; weights trained on NC/research data. Baked clip = lawyer call. FID 5.15 vs in2IN 5.54 (InterHuman), 0.399 vs InterGen 5.21 (Inter-X).
TIMotion (CVPR 2025)	Same family as InterGen	No. In-betweening demo exists	Train listed as 8 GPU; infer 1 (judgement)	Repo up; licence not explicit	Ckpts listed	InterHuman + Inter-X	Same	Treat as NC via data. 32% of InterGen params.
ReMoS	Reactor BVH/CSV, body+hands	Contact loss + guidance, not arbitrary pair+metres	1 GPU. ~24 s / 50 frames measured	MPI: commercial use of code and data strictly prohibited	Research	ReMoCap (Lindy + Ninjutsu) + 2C/ExPI. Kickboxing shown as transfer	Closest combat set (Ninjutsu + kickboxing demos)	No
Duolando	Follower dance tokens	No	Multi-GPU train	NTU S-Lab 1.0	Released	DD100 dance	Dance only	Effectively research; wrong domain
FreeMotion	N-person text-to-motion	Spatial control borrowed from single-person methods	1 GPU typical	CC BY-NC-SA 4.0	Same	InterHuman	Same as InterHuman	No
PINO (ICCV 2025)	Same as backbone	Physics penalties on noise, not joint API	Same as InterGen	Training-free wrapper	None new	Uses InterGen	Same	Inherits InterGen NC. Overlap 0.119→0.000, penetration 3112→276 cm³ on InterHuman 2-person.
InterSyn (ICCV 2025)	Dual-human motion	No	Unknown	"will be open-sourced"	Unreleased at paper	InterHuman	Same	Not usable yet. Claims FID 6.33 vs InterGen 13.40.

Inter-X: ~11.4k seq, 8.1M frames, SMPL-X + hands, 40 daily categories. Download = research-purpose form. Not a commercial grant.

Hi4D: 100 seq, 11k frames, close contact (hug/dance/sport), vertex contact labels. Research. Too small to train a generator.

Harmony4D: in-the-wild wrestling/MMA video, not a released two-skel trainer.

Windows: none of the academic stacks advertise a native Windows trainer. One NVIDIA GPU is enough for inference on InterControl / InterGen / InterMask / ReMoS. Training InterGen-class is multi-day, not required if you only sample.

## 2. Cascadeur 2026 AI (owned Pro)

Tool	What it does	Two bodies in contact	Python
Inbetweening / AI interpolation (2025.1→2025.3)	Fills selected timeline interval from ≥2 keys. Styles include Combat. 2026.1 Root Motion is looser, optional style-ref clip.	Official limit: ignores other characters, colliders, environment. Per-body only.	Interpolation type on a track. Python can set keys + interpolation via layers_editor / scene modify. No documented inbetween() one-liner.
AutoPosing	Drag few controllers → full pose.	Several characters in scene, one character's controllers at a time. Cannot multi-select two characters' AutoPosing points (documented in 2-character tutorials).	session API exposes AutoPosing controllers. Codex already poses from a still — this is that path.
AutoPhysics	Makes a keyframed clip physically consistent. 2024.2 contact animation: body colliders mark contacts, composite CoM, both bodies treated as one unit while touching. 2026.1 adds penetration cleaning.	Yes, for sustained contact, if colliders exist and you build composite CoM. Ballistic takedown (flight → slam) is not the documented target.	Physics commands exist in the command/Python surface; contact colliders live on the rig.

Your 4–5 still plan: Codex pose each checked still → Inbetweening per character → AutoPhysics on composite CoM for the contact interval. This is the only route that is already licensed for a commercial game and already producing verified closed-guard holds.

Hard limit: Inbetweening will not keep a collar tie or underhook on the other body. You will key the contact joints or let AutoPhysics + your Godot probe reject misses.

## 3. Physics controllers (two keys → simulate contact → bake)

System	Two-person contact from keyframes?	Offline bake	Licence
MaskedMimic (SIGGRAPH Asia 2024, NVIDIA)	Masked single humanoid inpainting + objects. Not a two-fighter contact solver.	Yes, Isaac	Paper CC BY-NC-SA 4.0. Later NVIDIA ProtoMotions bits Apache-2.0 — not a grappling baker.
PHC	Single-person AMASS tracker. Multi-person demo = two video-tracked bodies + collision on. Does not invent a double-leg from 2 poses.	Yes	IsaacGym + AMASS stack. Puffer-PHC MIT, data is not.
InterPhys	Sit / carry / lie vs objects.	Yes	Research
InterMimic (CVPR 2025)	Human–object, not human–human fight.	Yes, Isaac Gym	Research code public

Judgement: none of these take two authored keyframes of two people and bake a takedown. Usable only as a cleaner after a kinematic generator, and even then they were not trained on wrapped guards.

## 4. Video tricks for trackability

Solid-colour full-body suits (red vs blue) + SAM2 first-frame masks: standard chroma logic. No paper found that validates this on generated two-person grappling.
Marker-suit / mocap-dot prompts: used in single-person T2V folklore. No published two-person combat pipeline.
Colour hold in T2V: judgement — not reliable. Hue drift, wrinkles, lighting, and limb-crossing recolor are normal. Distinct saturated suits help frame 0 SAM2; wrapped phases still merge identities (same failure G76 saw).
SAM2 identity persistence across prolonged mesh-overlap is the unsolved part, not the segmenter.

Expected lift vs raw Seedance: modest. Not a 376-clip factory.

## 5. Rank by expected yield / hour on 376 clips

Yield = usable Godot clip after retarget + contact-probe accept. All rates judgement.

Rank	Route	Clips / hour (steady state)	Why
1	Cascadeur 4–5 verified stills → Codex pose → Inbetweening → AutoPhysics	1–3 after the first week, 0.3–0.5 on day one	Already works for holds. Combat style exists. No NC dataset. Failure mode is known (other body ignored).
2	InterControl contact plans from your probe	2–8 raw, 0.2–1 after cleanup	Only model that speaks joint-pair metres. Untrained on takedowns → rubber contacts. MIT lets you bake.
3	InterMask / TIMotion text-to-pair, then Cascadeur clean	1–4 raw, low accept on wraps	Better FID than InterGen; no contact API; InterHuman NC.
4	ReMoS: author attacker in Cascadeur, generate reactor	0.5–2	Ninjutsu is the closest data. Licence forbids commercial. Dead for ship.
5	PINO-on-InterGen	same as 3 + less penetration	NC. Useful as a cleanup idea, not a product path.
6	Color-suit T2V → SAM2 → video-mocap	<0.3 accepted	Tracking still dies on closed guard / north-south.
7	MaskedMimic / PHC bake from two keys	~0 for grappling	Wrong problem.

Pilot first, one double-leg: Cascadeur. Five stills — setup, penetration, lift, landing, settle — Codex pose to checked images, Inbetweening each body, composite-CoM AutoPhysics on frames that touch, export FBX, run your joint-pair probe. Measure: hours to first probe-green clip, penetration frames, how many extra keys Inbetweening demanded.

Second pilot (same takedown, parallel): InterControl plan with pairs attacker_hands→victim_legs, heads_apart, pelvis_gap timed to those five stills. Compare accept rate vs Cascadeur. If InterControl lands usable flight, it scales faster than keying 376 clips by hand.

## Argue against the ranking

Cascadeur #1 assumes AutoPhysics contact colliders survive a double-leg level change. Official Inbetweening does not see the other body; a shot that works for closed guard (static wrap) can fail when both COM leave the ground. If that is true, rank 1 collapses to "more keyed holds" and InterControl or ReMoS-quality reaction becomes the real generator — except ReMoS cannot ship.

InterControl #2 assumes LLM/hand plans plus IK equal weight transfer. It was trained on HumanML3D walks and dances. A 0.05 m hand–neck constraint does not create a sprawl. High raw count, low fight accept, and rank 2 overstates factory yield.

InterMask FID wins do not equal collar-tie geometry. Ranking 3 on metrics overfits InterHuman's scripted boxing, not BJJ wraps.

Color-suit rank 6 may be too low if Seedance holds two flat albedos for 4 seconds. Unproven; one double-leg test is cheap. If colours hold, SAM2+video-mocap jumps over InterMask.

376 clips × 1–3/h Cascadeur = 125–376 hours of operator time, not compute. That is the real bottleneck the ranking hides.

## What I could not find

- Cascadeur docs stating Inbetweening is a first-class Python function (only interpolation type + timeline UI).
- Any commercial exception for InterHuman / Inter-X / ReMoCap.
- A two-human physics controller that takes two keyframes and bakes a takedown.
- A paper that prompts T2V for two solid-colour mocap suits and then tracks them.
- Measured colour-consistency % for Seedance (or any T2V) on full-body suits.
- Native Windows support matrices for InterGen/InterMask/TIMotion.
- Exact in2IN and TIMotion commercial licence text.
- Combat fraction inside Inter-X's 40 classes (paper frames them as daily).
- Higgsfield / ARDY two-body skeleton (still one body, as you said).
