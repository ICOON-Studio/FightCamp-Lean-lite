# K58 — How combat games script a move before they animate it

Kalli, 2026-09-14 (task `research/TASK_K58.md`), delivered in chat at 12:11 in ~3 minutes; collected verbatim by Claude. Tables arrived tab-separated and are kept as sent. Operator's request: "Do research how to write proper scripts for combat sports 3d animation".

K58 — How combat games script a move before they animate it

Scope: how studios write execution of a move (attacker + defender, distance, contact, phases) — not Dustloop frame-data fields or EA UFC GDC 2015 as a move-list source (already on record).

Sources opened
URL	Studio / author	Year	What it says a move script / prep contains
https://www.gameanim.com/2016/05/03/motion-matching-ubisofts-honor/	Ubisoft / Simon Clavet (via Game Anim write-up of GDC 2016)	2016	Dance-card for mocap coverage (walks, repositions, starts/stops, circles, plant-turns 45–180°, strafe square/plants). Combat anims tagged: Tired, Heavy Attack, Stance, Pose, Range, Type of attack; outcomes Block / Miss / Parry / Hit wall. Animators mark events at significant moments (e.g. sword connect) — not clip start/end. Game logic = state machine; two-character throws/finishes owned by animation (anims drive displacement to stay in sync).
https://www.digitaltrends.com/gaming/sloclap-sifu-animation-interview/	Sloclap / Pierre Tarno, Kevin Roger	2022	~200 movements with video refs chosen with Pak Mei expert; hand-keyed for gameplay timing (fast/slow/power); mocap only for takedowns/finishers (synced + lots of contact). Can’t drop raw mocap into game — timing constraints force keyframe iteration.
https://www.pointnthink.fr/en/interview-kevin-roger-sifu/	Sloclap / Kevin Roger	~2022	Attack segmented build-up → force to impact → release. Design hands animator: time to impact, origin of blow, limb used. Build-up telegraphs direction/limb; impact = snappy style; release = power window + when control returns. Combo editor for move sequences. Takedowns ~80% hand-reworked after mocap.
https://www.gamedeveloper.com/business/postmortem-vivid-games-i-real-boxing-i-	Vivid Games / Real Boxing	2013	Three recorded distances per hit so game picks best clip; still needed collision + IK when both attack at once. Camera: one 3D vector per animation. Mocap with real boxers (Alvernia).
https://mocappys.com/how-to-plan-a-motion-capture-shoot-mocap-shot-list/	Mocappy	(undated guide)	Shot-list spreadsheet columns: Project, Date, Naming (rig, action type, shot/seq ID, prop, # characters, variation, numeric ID), Move Description, Props (+dims/weight), Scenery, Scene/Shot/Level, Duration, Number of Performers. Multi-character takes often split per performer then recombined.
https://www.sandboxactiondesign.com/workflow	Sandbox Action Design	(studio workflow page)	Pre-pro: Stunt Coord + Fight Choreographer + Stunt Vis decide blend points (where capture starts/ends), rig needs, post vs capture split. Capture with witness cams. MotionBuilder layout = geography + character interaction + timing. Cleanup must fix contacts between characters.
https://mastersingaming.com/2022/12/23/bringing-brawling-to-life-in-midnight-fight-express-playstation-blog/	Midnight Fight Express / Eric Jacobus, Jacob Dzwinel	2022	Shot list of combos/parries/finishers; each move × N/S/E/W (coverage matrix → 300→1200 takes). Per-shot loop: read shotlist → choreograph → confirm → slate → capture. Engine constraints (weapon pinned to hand) must be known before previs.
https://vorixo.github.io/devtricks/contextual-anim/	Unreal Contextual Animation (Devtricks / Doğa)	2024	CAS asset: Roles (e.g. Interactor / Target), Primary Role, AnimSets (montage per participant), Warp Point Definitions + Update Warp Points, Selection Criteria (Cone / Distance / Trigger Area). Needs MotionWarpingComponent + ContextualAnimSceneActorComponent; root motion + Motion Warping notify with matching Warp Target Name; Mesh-to-scene transforms.
https://www.quodsoler.com/blog/motion-warping-character-attacks-using-blueprints-no-c-required	Quod Soler	2026	Attack warp needs: named warp target (location or component + Follow), Anim Notify State (Skew Warp), root motion on clip during notify window, then clear warp target.
https://cascadeur.com/help/getting_started/scenes/scenes_with_multiple_characters	Cascadeur	(docs)	Two+ characters in one scene; move by Center of Mass; namespaces for FBX export.
https://cascadeur.com/blog/view/best-shots-how-to-use-references-for-better-action-animation-part-3	Cascadeur / Fjodor Mastikin	(blog)	Two-char action: key centerpieces of motion first; for AutoPhysics on both, Create Composite Center of Mass; clean contacts; optional collision shapes.
https://charios.com/blog/2d-attack-animation-anatomy	Charios	2026	Attack template: anticipation (≈3–8f @30) → action/impact (1–2f) → recovery (≈5–15f); power pose on contact; overlapping / secondary action on polish.
https://www.udit.es/en/timing-y-spacing-en-animacion-que-es-y-como-mejora-la-sensacion-de-peso/	UDIT	(guide)	Separate timing (when contact) vs spacing (accel). Punch fix: 2–3f anticipation, open→closed spacing into contact, 1f overshoot, 4–6f settle. Mark phases on paper from reference before keying.
https://mocaponline.com/blogs/mocap-news/cutscene-direction-game-cinematics	MoCap Online	2026	Pipeline: script → beat sheet (line → camera intent, blocking, gameplay state) → previs as shot list → capture with slate notes → cleanup/solve → layout. Floor plans + timing sheets before stage time.
https://blog.playstation.com/2024/10/02/undisputed-launches-oct-11-how-body-scans-deliver-boxing-authenticity/	Steel City / Undisputed	2024	Fighters in mocap for footwork, punches, slips, dodges, taunts; same moves repeated “from every angle”; days of process/apply to models. No public move-document field list in this article.
https://www.gdcvault.com/play/1021795/Animation-Bootcamp-UFC-Animation	EA / Dowsett & Harrower	abstract only	ABSTRACT: close-quarters grappling heavy on two-man animation; procedural solutions. Full talk NOT OPENED (Vault).
https://www.gdcvault.com/play/1025228/Real-Player-Motion-Tech-in	EA / Harrower UFC 3	abstract only	ABSTRACT: path generation vs RPM DB; RPM Event System for temporal constraints on queries. Full talk NOT OPENED.
NOT OPENED (attempted / blocked)
URL	Reason
https://dev.epicgames.com/documentation/en-us/unreal-engine/motion-warping-in-unreal-engine	Fetch 409
https://www.unrealengine.com/developer-interviews/crafting-a-unique-combat-experience-in-absolver	Fetch timeout
GDC Vault full videos (UFC Bootcamp, Fight Night rendering, etc.)	Paywall / video only — abstracts only
Cascadeur “Introducing Contact Animation…” tutorial video	Listing page only; no full transcript opened
EA Fight Night Champion animation-spec articles beyond rendering Vault abstract	No usable opened page found this pass
Fields a proper move script should have (merged; each names its source)
Field	Source(s)
Move / clip ID + naming (rig, action type, shot/seq, # performers, variation)	Mocappy shot list
Short move description (how performed)	Mocappy
Attacker role + defender role (e.g. Interactor / Target)	UE Contextual Anim
Limb / origin of blow	Sifu (Roger)
Phases: build-up / anticipation → impact / contact → release / recovery (+ optional overshoot/settle)	Sifu; Charios; UDIT
Time to impact (or frame of contact event)	Sifu; For Honor event marks; UDIT
Anticipation / action / recovery frame budgets	Charios; UDIT
Timing vs spacing notes (when vs how dense in-betweens)	UDIT
Range / distance band (and capture ≥3 distances per hit)	For Honor tags; Real Boxing
Stance / pose / attack type / weight (e.g. Heavy, Tired)	For Honor
Intended outcome variants: Hit / Miss / Block / Parry / Hit wall (+ slip)	For Honor
Direction / facing coverage (N/S/E/W or angle set)	Midnight Fight Express
Contact / sync ownership: one timeline for both bodies; contact cleanup	Sandbox Action Design; Cascadeur multi-char + composite CoM
Blend in / blend out points (where capture starts & ends)	Sandbox pre-pro
Root motion / warp target name + warp window (if engine syncs distance)	Contextual Anim; Quod Soler Motion Warping
Selection criteria for which pair clip plays (distance cone/range)	Contextual Anim Selection Criteria
Duration estimate	Mocappy
Props / gloves / scenery interacting	Mocappy; Sandbox
Witness / reference video	Sandbox; Sifu video refs; Cascadeur reference plane
Gameplay constraints known before shoot (e.g. hand pinned, cancel windows)	Midnight Fight Express; Sifu Tarno
Camera impulse / feedback vector (optional, per anim)	Real Boxing
Five sources most worth reading in full (best first)
https://www.pointnthink.fr/en/interview-kevin-roger-sifu/ — clearest execution script: build-up / impact / release + design fields (time to impact, limb, origin).
https://www.gameanim.com/2016/05/03/motion-matching-ubisofts-honor/ — dance-card + combat tags + event-at-contact + two-man sync ownership.
https://vorixo.github.io/devtricks/contextual-anim/ — what a paired attack/reaction asset must contain in-engine.
https://mocappys.com/how-to-plan-a-motion-capture-shoot-mocap-shot-list/ — concrete shot-list columns before capture.
https://www.gamedeveloper.com/business/postmortem-vivid-games-i-real-boxing-i-/ — boxing-specific: 3 distances per hit + IK when dual attack.
Gap (honest)

No opened page published a full studio “jab move document” PDF with every field filled for boxing. Closest process specs are Sifu’s phase language + For Honor tags/events + Real Boxing distance matrix + UE Contextual Anim roles/warps. Undisputed confirms fighter mocap variety but not a written move-spec schema.
