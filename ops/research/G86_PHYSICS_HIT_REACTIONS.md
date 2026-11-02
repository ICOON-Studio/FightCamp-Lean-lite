# G86 - physics-driven hit reactions over animation, in Godot 4 (Grok, delivered S65 2026-09-24)

Captured verbatim from Grok (Expert mode, 109 sources, 12,417 chars) by Claude in S65. Task: `TASK_G86_PHYSICS_HIT_REACTIONS.md`.
Asked because the operator asked "do we have physics and ik?" (IK: yes, four hand-written solvers; physics: none).

---

Shipped fight games: PARTLY. Standing hits are authored clips + procedural overlay; physics/ragdoll owns KOs, secondary flesh, and (from UFC 6) knockdown blend. Best sources: Ueno GDC 2010 (UFC 2009) and EA's UFC 6 Driven Ragdoll copy.

Godot 4.7 smallest slice: YES. PhysicalBoneSimulator3D.physical_bones_start_simulation(subset) + influence blend is official. Two fighters @ 60 fps is INFERRED viable for 4–8 bones each if root/hips stay animated and collision exceptions are set. No published two-fighter bench.

Recommendation: Add a visual-only head/neck/upper-torso impulse on the struck fighter. Engine still owns root, knockdowns, and clips. Do not expect physics to fix inter-body clipping. Measure with A/B contact-frame film, not FPS.

## 1. How shipped fight games do hit reactions

**UFC 2009 Undisputed — PARTLY physics, documented.**
Hiroki Ueno, GDC 2010 / CEDEC 2011: Havok ragdoll under the animated pose; Ragdoll Rigid Body Controller drives bones toward the clip; hit applies force so the head/body recoils then returns. Pipeline: play reference pose → simulate Havok → adjust ragdoll speed → skin. They also play strike-response animations. Hard problems they named: fighters sticking together, unstable sim, self-collision. Fixes: limit closeness, fence limits, temporarily disable collision, connect fighters with constraints, full-body IK targeting. DOCUMENTED (GDC slides + 4Gamer/GameWatch writeups). Media.gdcvault

**EA UFC 4/5 — PARTLY. Standing hits: clips + procedural. Ragdoll: KO / replay.**
UFC 5 presentation: impact = reworked strike anims + Frostbite physics/procedural animation + facial deformation + VFX + audio. Eurogamer interview lists "Pose Driven Rag Doll" next to Relative IK, Strike IK, full-body blend, pose-trajectory matching. Official text: ragdoll physics "updated" for slow-mo KO replay (hair/cloth/ragdoll). Not a claim that every standing jab is a physics solve. DOCUMENTED for KO/replay ragdoll + procedural layer; INFERRED that in-fight flinches are still clip-selected. Eurogamer

**EA UFC 6 (Jun 2026) — MORE physics on KD/KO/hit contact.**
EA: first franchise use of a new Frostbite physics engine for "ragdoll physics, strike contact, hit reactions, dynamic deformations"; "Knockdowns and knockouts blend handcrafted animation with Frostbite physics." Press: Driven Ragdoll replaces "closest pre-authored knockdown clip" with force through a skeletal body (mass, velocity, contact, pose). Tradeoff admitted: implausible limb poses. DOCUMENTED as marketing/engineering claim, not a GDC paper. Instagram

**Fight Night Champion — PARTLY. Physics is secondary + KD ragdoll, not the hit-choice brain.**
Art blog: muscle flex/jiggle/body ripple driven by punch power, angle, flushness, region. Physics sim 120 Hz; game sim 60; render 30 (dev interview). Edge: "ring physics, ragdolls and cloth… different class to Round 3." Player footage of ragdoll knockdowns. Standing hurt still looks clip-authored with physics flesh on top. DOCUMENTED secondary physics + ragdoll KD; INFERRED standing reactions. Forums.operationsports

**Undisputed — PARTLY. Devs: model physics + more hit-stun clips. Community: "ragdoll KOs," often weightless.**
May 2024 roundtable: "improved fighter model physics" / "realistic secondary motion"; reactions scale with stamina/health; "more animated hit stuns and stumbles." No GDC paper. KO look is mixed clip + limp body. DOCUMENTED secondary motion + extra stun clips; ragdoll ownership UNKNOWN/INFERRED from footage. YouTube

**Thrill of the Fight / TOTF2 — PARTLY, more physics than the console sims (VR).**
Steam update #3 (2016): "Enemy hit reactions are now partially physics based, instead of just being a canned animation." Punch/block damage from relative fist velocity × assumed mass. TOTF2 2026: AI body is physically simulated so you can push the guard; body-shot reactions by location + force; multiplayer knockdowns still shipping as authored animation sets (dev video asks if players want more ragdoll). DOCUMENTED. Store.steampowered

**Tekken / Street Fighter — NO body-physics hit reactions.**
Tekken: 3D bone-trajectory hit detection (Harada), per-frame collision; reactions are authored hitstun with frame data. SF6 CEDEC 2024: physics is cloth + stage destruction ("anime physics"), not the hit reaction. Gameplay needs deterministic stun. DOCUMENTED.

Motion matching: UNKNOWN as the primary hit-reaction tech in these titles. UFC 5 lists pose-trajectory matching for movement/alignment, not as the hit-react chooser.

Pattern: shipped combat-sports games keep the decision (what event, how hard, do they fall) in rules/animation, and use physics as (a) KO/fall variety, (b) secondary flesh, (c) a short additive on the struck segment. Full Euphoria-style standing fight is not what UFC/Fight Night shipped. Light flinches stay clips (also the generic industry split in mocap-pipeline writeups).

## 2. What Godot 4.7 actually offers

**Built-in (official 4.7 docs).**
- PhysicalBone3D — physics body bound to a skeleton bone. Joint types: none / pin / cone / hinge / slider. apply_impulse / apply_central_impulse. Mass, damp, joint limits.
- PhysicalBoneSimulator3D (SkeletonModifier3D) — parent of the physical bones; writes sim result onto Skeleton3D after AnimationMixer.
- physical_bones_start_simulation(bones: Array[StringName] = []) — empty = all; named list = subset. Docs: pass bone names, not node names; bad names fail silently.
- physical_bones_stop_simulation().
- influence (0–1, default 1) — Skeleton3D blends modifier pose vs animated pose. Official tip for partial-ragdoll vs animation.
- Collision exceptions: physical_bones_add/remove_collision_exception.
- Docs warn: wrong layers → CharacterBody capsule hits its own inactive ragdoll → bounce/stick. Docs.godotengine

**Documented / confirmed limits.**
- influence is global, not per-bone. Blend-out softens every simulated bone at once. DOCUMENTED by Kickback's Godot 4.7 notes; matches SkeletonModifier3D API.
- Mid-range influence (≈0.001–0.999) glitches the physics step (bone pose written outside the solver). Tokage, PR #96270 — they fixed follow-when-not-simulating; mid-blend remains a known footgun. DOCUMENTED.
- start_simulation(list) adds those bones; it does not stop bones already simulating. To swap subsets you must stop then start, which can snap. Proposal #15150 (Jul 2026). DOCUMENTED.
- PhysicalBone3D is a thin PhysicsBody: no apply_force at offset, no apply_torque, no body_entered, no contact monitor (proposal #8008). Fine for a one-shot impulse; poor for active motors. DOCUMENTED.
- 4.3 regression: physical bones stopped following animation unless simulating (issue #96202). Fixed 4.4 (#96270). 4.7 should have the fix. Do not copy 4.2 ragdoll tutorials blindly.
- Self-collision / two-fighter collision will throw bodies if layers/exceptions are wrong. Official warning.

**Performance, two skinned fighters @ 60 fps.**
UNKNOWN officially. INFERRED: 4–8 capsule bones + cone/hinge joints, 1–2 frames of impulse, then influence tween, is cheap vs a full 16–20 bone always-on ragdoll. Kickback ships a 20-character stress demo of the heavier RigidBody spring rig; that implies the built-in partial slice is well under a 60 fps budget if Jolt is on and you are not simulating legs/root. Measure; do not assume.

**Projects / addons (licence).**
- Kickback (blugart-dev/kickback) — MIT, Godot 4.7+, Jolt required. Active ragdoll = 16 RigidBody3D + velocity springs (they abandoned PhysicalBone for the real system). Demo includes the exact built-in slice: subset sim → impulse → hold ~0.18 s → tween influence → 0 over ~0.4 s (demo/partial_ragdoll_controller.gd).
- CBerry22 Active-Ragdoll (Godot 4.0, PhysicalBone, YouTube + GitHub).
- PiCode9560 Godot-4-Active-ragdoll (PhysicalBone + Hooke motors toward an animated twin skeleton).
- R3X Godot-Active-Ragdolls — RigidBody + 6DOF; old, Bullet-oriented.

No shipped Godot boxing/MMA title using this as the fight-react layer. UNKNOWN beyond those addons/demos.

## 3. Smallest useful slice for FightCamp

Do this, only this. On a landed impact the engine already scored (force + dir + region you already have):
1. Map region → bone chain. First slice: Head, Neck, one upper-spine / chest bone. Not arms (your ARM IK owns those). Not hips/root/legs (LEG IK + plant + 20 Hz balance own those).
2. physical_bones_start_simulation(chain) on the struck fighter only. Wait one physics frame.
3. apply_impulse(dir * scaled_force, local_hit_offset) on the hit bone.
4. Hold 0.15–0.20 s.
5. Tween simulator influence 1 → 0 over 0.20–0.40 s (matches your existing 0.2 s blend language).
6. stop_simulation(). Reset influence to 1 so the next hit is clean.
Keep AnimationTree running. Physics is an overlay, not a takeover.
Collision: physical bones on their own layer; exceptions vs the other fighter, the floor, and self. Never simulate the root / hip. CharacterBody / your sim root stays the authority.

**Cost.** One extra SkeletonModifier, a PhysicalBone set authored once per humanoid, a short impulse + tween per landed shot. CPU: small. Authoring: joint limits and bone-name map. Tuning: impulse scale vs clip amplitude so physics doesn't fight the hurt clip.

**Risks.**
- Physics must not move the root. If hip/root simulate, the 20 Hz separation/balance model and the pose diverge; fighters slide or leave the pocket.
- Global influence will slightly soften the whole simulated chain, including bits your ANCHOR / CONTACT solver just planted, if you ever expand the chain into clinch bones.
- Mid-blend influence glitch: prefer hold-at-1 then snap/tween quickly, or stop-sim then let the clip take over.
- Two PhysicalBone sets colliding = new clipping and launches. Exceptions are mandatory.
- Knockdowns stay clips. Full ragdoll on drop is a later, separate product decision (UFC themselves only leaned into Driven Ragdoll at UFC 6, and it still looks wrong sometimes).

**How to measure "looks better" (not "it runs").** Same recorded strike, same camera, clip-only vs clip+slice, 10–20 hits (jab/cross/hook, head/body):
- Head linear/angular velocity aligns with punch dir on frames 1–8 after contact (today two clips meet with no shared force axis — that's the "abrupt / no limb return" complaint).
- Time-to-neutral: head/torso back within ~0.3–0.4 s of the clip, no hang.
- Penetration: mesh-mesh depth at contact frames should not get worse (if it does, physics is fighting the contact solver — fail the slice).
- Operator checklist: "clipping / abrupt / no return to neutral" scored blind on A/B. If scores don't move, kill the layer.
- Perf: two fighters, 60 fps, physics tick 60 or 120, frame time + Jolt island count. Gate: no drop below 60 on the target box.
If the slice only looks good on clean single shots and explodes in clinch/ground, keep it stand-up, struck-fighter, head/torso only.

## 4. Does physics help clipping?

Mostly no. Inter-body collision of two animated skeletons is a different problem — yours is already the contact solver + IK.

UFC 2009 treated these as separate systems: ragdoll-for-reaction and "limit how close / connect with constraints / temporarily kill collision / full-body IK." EA still lists Relative IK + Strike IK + interaction alignment beside Pose Driven Rag Doll. Physics hit-react does not replace paired-pose solving. Media.gdcvault

| Symptom | Physics partial ragdoll | Contact solver / IK |
|---|---|---|
| Head doesn't yield along punch dir; two clips unaware | YES — impulse on head/torso | No |
| Hands never return to guard | NO — that's clip + ARM IK | ARM IK / clip blend |
| Meshes occupy the same volume (clinch, ground, pocket) | NO — and naive bone-vs-bone collision makes it worse | YES — your gap closer + grips |
| Root walks through the other body | NO — do not give physics the root | Separation floor you already have |
| Abrupt clip cuts | Maybe, if the overlay hides the cut for 0.2 s | Blend / motion match / longer tails |

Specific: if PhysicalBone capsules on fighter A collide with fighter B's mesh or bones, you get pops and new clips, not fewer. The correct setup is no inter-fighter physical-bone collision; keep solving contact in the existing solver; use physics only to deform the struck upper chain in the direction the impact already decided.

Bottom line. Physics is not the missing fight brain. It is a 0.2–0.4 s visual spring on the bone that got hit. That can answer "no physical awareness when two clips meet" for the head/torso. It will not answer clipping, limb return, or IK. Do the slice; keep the solver; do not simulate the root.

109 sources
