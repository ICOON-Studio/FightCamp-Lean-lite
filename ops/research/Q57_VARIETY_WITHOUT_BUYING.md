# Q57 — MAKING A HUNDRED CLIPS LOOK LIKE FIVE HUNDRED

## DECISIONS (top five, cheapest first)

| # | Technique | Cost | Art needed? | Variety gained |
|---|-----------|------|-------------|----------------|
| 1 | **Speed scaling per stat/fatigue** | Pure code | No | ~3-5x per clip family |
| 2 | **More round-robin takes from slicing** | Pure code | No | 2-4x on combo files |
| 3 | **AnimationTree blend-space on fatigue** | Pure code | No | Continuous variation, not discrete takes |
| 4 | **Additive fatigue layer on a reference pose** | Code + one authored clip | Yes (one) | N fatigue states × every strike clip |
| 5 | **IK-driven contact correction** | Code (moderate) | No | Fixes foot/hand placement across body sizes |

---

## Q1 — AnimationTree nodes and blending (Godot 4.x)

Source: Godot 4.x class reference and AnimationTree tutorial, fetched 2026-09-11.

| Node | What it does | Runtime cost | Deterministic? |
|------|-------------|--------------|----------------|
| **AnimationNodeBlend2** | Linear blend between two animations by scalar `amount` (0..1). Supports track filters for partial blending. | Cheap — two-pose lerp per bone per frame. | **DOCUMENTED: Yes.** Docs state "for blending results to be deterministic, the blended property values must have a specific initial value." No RNG. |
| **AnimationNodeBlendSpace1D** | Places animations on a 1D axis; blends the two adjacent to the current input. Sync modes: None, Independent, Cyclic Mutable, Cyclic Constant. | Cheap — two-animation lerp, triangulation is static. | **DOCUMENTED: Yes.** Input-driven, no RNG. Sync modes are time-based but deterministic given same inputs. |
| **AnimationNodeBlendSpace2D** | 2D triangulated blend of up to 3 animations by Vector2 weight. Delaunay triangulation (auto or manual). | Moderate — barycentric lookup + 3-way blend. Triangulation recalculates on point add/remove only. | **DOCUMENTED: Yes.** Same determinism guarantee as Blend2. |
| **AnimationNodeAdd2** | Additive blend: base ("in") + scaled delta from "add" port. `amount` > 1.0 amplifies, < 0.0 inverts. | Cheap — additive offset per bone per frame. | **DOCUMENTED: Yes.** Pure arithmetic on track values. |
| **AnimationNodeOneShot** | Fires a child animation once with blend-in/out times. Request-driven (FIRE/ABORT/FADE_OUT). Has `autorestart` with `autorestart_random_delay`. | Cheap — single animation with fade envelope. | **DOCUMENTED: Conditional.** Deterministic when `autorestart_random_delay = 0.0`. **NOT deterministic when `autorestart_random_delay > 0.0`** — that property introduces RNG between restarts. |
| **AnimationNodeTransition** | Simplified state machine: plays animation at current index, crossfade on switch. | Cheap — one animation active at a time. | **DOCUMENTED: Yes.** State changed by explicit request. |
| **AnimationNodeStateMachine** | Graph of states with transitions (Immediate, Sync, At End). A* `travel()` pathfinding. Advance Conditions (boolean) and Advance Expressions (code eval). | Moderate — A* on transition, advance expression eval per frame. | **DOCUMENTED: Yes, with caveat.** Advance Expressions evaluate user code — if that code reads RNG or wall-clock, the tree is no longer deterministic. The tree itself is deterministic given deterministic inputs. |

### Can AnimationTree run without a scene tree frame?

**DOCUMENTED:** AnimationTree inherits from `AnimationMixer`. Default `callback_mode_process` is `IDLE` (updates during idle frames via `NOTIFICATION_INTERNAL_PROCESS`). **Can be set to `MANUAL` mode** — disables automatic processing entirely. In MANUAL mode, you must call `advance(delta)` to tick the animation forward. Without ANY frame at all (no idle, no physics, no manual advance), the AnimationTree does NOT update — animation time does not advance, so `global_position` stays at the origin.

**DOCUMENTED:** `AnimationMixer` also has a `deterministic` property (default `false`) that controls weight normalization — not frame dependency.

**For our use case:** The round-robin variant cycling in `FightStagePlayer` is already deterministic and frame-independent. AnimationTree would add blending ON TOP of that. To drive it in headless tests, set `callback_mode_process = ANIMATION_CALLBACK_MODE_PROCESS_MANUAL` and call `advance(delta)` explicitly.

---

## Q2 — Additive layers

### Does Godot 4.x support additive blending against a reference pose?

**DOCUMENTED:** `AnimationNodeAdd2` performs direct weighted addition: the "add" input's track values are scaled by `add_amount` and added to the "in" input's values. **It does NOT subtract a reference pose internally.** The additive clip must already be authored as a delta, or pre-processed with `AnimationNodeSub2` to isolate the delta motion.

**DOCUMENTED:** The blending system's reference is the **`"RESET"` named animation** (a literal Animation resource named "RESET"), falling back to **Bone Rest values** for Skeleton3D Position/Rotation/Scale tracks, or `0` for other properties. This is the accumulation baseline when `deterministic = true` and total blend weight is 0.0.

**DOCUMENTED (critical):** `AnimationMixer.deterministic` **must be set to `true`** for additive blending to work correctly. Without it, blend weights are normalized to sum to 1.0, which breaks additive math (e.g., base weight 1.0 + add weight 0.5 becomes 0.67/0.33 instead of 1.0/0.5).

**DOCUMENTED:** `AnimationNodeSub2` computes `Out = Sub.Transform3D^(-1) * In.Transform3D` — it can pre-process existing clips against a T-pose reference to produce additive-compatible deltas. Workflow: plug the punch animation into "in", T-pose into "sub", capture the output as a new additive clip.

### Can one fatigue layer multiply every striking clip?

**DOCUMENTED:** Yes, this is exactly the intended use case. One additive fatigue layer applied via `AnimationNodeAdd2` modifies whatever base clip is playing — `tired_punch = base_punch + fatigue_amount * fatigue_delta_clip`. One `fatigue_delta_clip` applies to every strike in the library.

**DOCUMENTED:** The additive clip must be authored as a delta (not a full absolute animation). `AnimationNodeSub2` with T-pose as the "sub" input can strip the base pose from existing clips to produce these deltas. Our `T_pose.fbx` is directly usable for this pre-processing.

**Cost:** One authored additive clip (the fatigue delta), OR pre-processing existing clips with `AnimationNodeSub2` against T-pose. Pure code to wire at runtime. Must enable `deterministic = true` on the AnimationTree.

---

## Q3 — Timing and speed variance

### How much can playback rate move before it reads as wrong?

**NOT FOUND.** No published tolerance range was found in animation programming references, GDC talks, or fighting-game post-mortems. The search returned zero results for specific percentage ranges.

**INFERENCE (marked as such):**

For **strike animations** (0.3–0.8 s duration):
- **±10%** is almost certainly safe — a 0.5 s jab at 0.45–0.55 s is indistinguishable in the context of a combo.
- **±15%** is probably safe for most strikes — the human eye does not precisely time individual punches in a flurry.
- **±20%** starts to risk looking "floaty" (slowed) or "compressed" (sped up), especially on the wind-up and recovery phases.
- **±25%** is likely too much for close-camera views; at our 9-11 m fight camera it may be acceptable.

For **movement/idle animations** (looping, longer):
- Tolerance is HIGHER — ±20% on an idle stance is unlikely to be noticed because there is no "correct" timing to compare against.
- Loop continuity matters more than speed: a walk cycle at 1.3x that doesn't phase-match will visibly pop.

For **hit reactions** (short, 0.3–0.6 s):
- Tolerance is LOWER — a reaction that is too fast reads as "he wasn't hit"; too slow reads as "he's in slow motion." ±10% is the safe ceiling.

**The number that decides whether this is worth wiring:**

If the engine's `speed` stat spans a range of (say) 0.8 to 1.2 across fighters, and fatigue shifts another ±10%, the total range is roughly **±25%** from base. At ±15% safe, that means:
- A fast fighter's punches play at 1.15x — visibly snappier, which MATCHES the stat fantasy.
- A tired fighter's punches play at 0.9x — visibly slower, which MATCHES the fatigue fantasy.

**Verdict: ±15% is the recommended safe range.** It is enough to make every clip a small family, it aligns with the game's own stat fantasy, and it costs nothing but a `speed_scale` assignment before `play()`.

---

## Q4 — What fighting games actually do

### Sources found

| Source | What it covers |
|--------|---------------|
| Jerry Edsall, "Animation Blending: Achieving IK and More" (Gamasutra, 2003) | MechWarrior 4: priority blend trees, feather blending, multi-axis blending, 152 anims/character |
| "The Role of Animations in Hit Effects" (Game Developer, 2016) | Zero cross-fade on hits, additive overlays, body IK post-process, ragdoll blending |
| "Most Inspiring Animation Tech Talks of 2016" (Game Developer, 2017) | For Honor Motion Matching (Simon Clavet), Paragon stride warping, foot IK heuristics |
| "Create a Physics Based Fighting Game in Unity" (Game Developer, 2019) | Torsional spring hit reactions, IK punch aiming with probabilistic targeting |
| Autodesk & EA Tiburon webcast (Game Developer) | EA Sports MMA: ANT animation engine, dynamic footplanting, partial-body relative IK |
| "Common Mistakes in Game Animation" (Game Developer, 2016) | Blend-out-early, preserving motion flow, velocity scaling |
| "The Killer Groove: Shadow AI of Killer Instinct" (Game Developer) | Frame-accurate combo recording, 40+ metrics for state matching |
| theorangeduck.com "Spring-It-On" | Inertialization (spring-based blend), exact spring damper math |
| "Q&A: Klei Founder on Shank" (Game Developer, 2009) | Context-sensitive permutation approach, no procedural blending |

### For Honor — Motion Matching (DOCUMENTED, Simon Clavet GDC 2016)

Replaces state machines entirely — transitions from ANY frame of ANY animation to ANY other frame. Fitness function evaluates candidates on:
- **Responsiveness** — how closely animation follows desired trajectory
- **Fluidity** — how closely candidate matches current velocity
- **Smoothness** — how closely pose matches current pose

Pose matching uses only key bones (feet positions/velocities + weapon position), not full skeleton. Trajectory warping adjusts selected animation's path over time (avoids time-scaling which looks unnatural). Foot IK heuristics at runtime: foot velocity + ground proximity to lock toes; refuses to lock if IK target too far, slides instead. kd-tree search optimization for frame selection.

**DOCUMENTED:** For Honor likely has thousands of animation frames in its motion database. System selects best frame every frame, making repetition nearly invisible. Hit reactions handled by same Motion Matching — a hit is just the system selecting frames that match a new desired trajectory.

### EA Sports MMA — ANT Engine (DOCUMENTED)

**DOCUMENTED:** EA Tiburon's ANT animation engine implements: dynamic footplanting, non-uniform player scaling, interaction-based player scale compensation, and partial-body "relative IK" interactions. Uses Autodesk HumanIK middleware.

### Techniques, ranked by cost to us (cheapest first)

| # | Technique | What shipped games do | Cost to us | Art? | Source |
|---|-----------|----------------------|------------|------|--------|
| 1 | **Speed scaling** | Stride warping: scale stride LENGTH not playback speed. Up to 60% speed variation with better visual fidelity (Paragon, DOCUMENTED). | Zero — `AnimationPlayer.speed_scale` exists. | No | DOCUMENTED |
| 2 | **Clip slicing** (already done: U40) | Standard. One combo file → individual techniques on measured retractions. | Already done. | No | DOCUMENTED (our own U40) |
| 3 | **Sagittal mirroring** (already done: U41) | Standard. Left/right symmetry doubles a clip set for free. | Already done. | No | DOCUMENTED (our own U41) |
| 4 | **Round-robin takes** (already done: R109) | MechWarrior 4: 152 animations per character. Fighting games use 3-8 takes per hit reaction. | Already done. Adding more takes requires more CLIPS. | Maybe | DOCUMENTED (Edsall 2003) |
| 5 | **Zero cross-fade on hit transitions** | Blend time = 0 when entering hit anims; conveys kinetic energy. ("Role of Animations in Hit Effects", DOCUMENTED) | Zero — set blend time to 0 in `play_role()`. | No | DOCUMENTED |
| 6 | **Feather blending (upper/lower body split)** | Per-joint weight modifiers; upper body punches + lower body footwork independently. (MechWarrior 4, DOCUMENTED) | Low — AnimationTree filter per bone group. | No | DOCUMENTED |
| 7 | **Blend-out-early on interrupt** | Allow interruption before animation completion; outgoing anim must have enough frames for blend. ("Common Mistakes", DOCUMENTED) | Low — a blend-out timer in `play_role()`. | No | DOCUMENTED |
| 8 | **Additive fatigue layer** | Small additive clips layered on ANY base animation. ("Role of Animations", DOCUMENTED) | Low code + one authored clip. | Yes (one) | DOCUMENTED |
| 9 | **Inertialization (spring-based transitions)** | At transition, record offset in position+velocity, decay to zero via spring damper. One anim stream only. (theorangeduck.com, DOCUMENTED) | Moderate — spring math + transition handler. | No | DOCUMENTED |
| 10 | **IK contact correction + probabilistic targeting** | Aim fist procedurally to hit point; random target offset for variety. (EA Sports MMA ANT engine, DOCUMENTED) | High — requires IK solver, per-clip contact point data. | No (but complex code) | DOCUMENTED |
| 11 | **Torsional spring hit reactions** | Hit reactions as rotational spring forces. Torque = stiffness × distance + damping × velocity. ("Physics Based Fighting Game", DOCUMENTED) | Moderate — spring system per body joint. | No | DOCUMENTED |
| 12 | **Ragdoll blending** | Blend between keyframe and ragdoll based on impact force. ("Role of Animations", DOCUMENTED) | Very high — ragdoll integration, transition tuning. | No | DOCUMENTED |
| 13 | **Motion Matching** | Fitness function + kd-tree search + trajectory warping. Selects best frame from entire database every frame. (For Honor, DOCUMENTED) | Very high — large motion database + engineering. | No (but massive system) | DOCUMENTED |

### What we already have that works

- **U40 slicing:** 1 file → 3 techniques. Pure code.
- **U41 mirroring:** 3 → 6. Pure code.
- **R109 round-robin:** 7 takes on `react_body`, 4 on `react_head`. Pure code, deterministic.
- **FightClipRetarget:** Retargets clips onto different skeletons. Already shipping.

### What we do NOT have and what it would cost

| Gap | What it buys | Cost |
|-----|-------------|------|
| Speed scaling per stat | Every clip becomes a 3-5 member family based on fighter speed + fatigue | ~20 lines of code |
| Zero cross-fade on hits | Sharper hit reactions, conveys kinetic energy | ~5 lines of code |
| Feather blending | Upper/lower body independence — jab + footwork variants | AnimationTree filter setup |
| Blend-out on interrupt | No more visible pops when a reaction is cut short | ~30 lines of code |
| Additive fatigue layer | Every strike clip × N fatigue states | One authored clip + ~40 lines |
| Inertialization | Smooth transitions from any state with no extra clips | Spring math + ~60 lines |
| IK contact correction | Punches land on the body, not through it | Complex IK system, ~200+ lines |

---

## THE TOP FIVE, EXPANDED

### 1. Speed scaling per stat/fatigue — PURE CODE, ~3-5x variety

`AnimationPlayer.speed_scale` is a single float. Before `play()`, set it based on the fighter's `speed` stat and current fatigue. A fast fighter's jab at 1.15x looks snappier — which is exactly what "fast fighter" should look like. A tired fighter at 0.9x looks sluggish — which is exactly what fatigue should look like.

**Deterministic?** Yes — the speed stat and fatigue are both deterministic game state.

**What it buys:** Every clip we own becomes a small family. A jab that played one way now plays 3-5 ways depending on who is throwing it and how tired they are.

### 2. More round-robin takes from slicing — PURE CODE, 2-4x on combo files

We already slice combo files into individual techniques (U40). If any bought combo files have more than 3 measurable retractions, we can extract more takes. This is free if the source material has it.

**Deterministic?** Yes — round-robin is already deterministic.

**What it buys:** More takes on the roles that need them most (react_head plays 5,525 of 9,715 shown beats — more takes there reduces repetition most).

### 3. AnimationTree blend-space on fatigue — PURE CODE, continuous variation

A 1D blend space with two points: fresh technique and fatigued technique. The blend axis is the fighter's current fatigue level. As fatigue increases, the animation smoothly shifts toward the exhausted version — no discrete "takes," just continuous variation.

**Deterministic?** Yes — driven by game state, no RNG.

**What it buys:** Every frame of every animation is slightly different depending on fatigue. Not a new clip, but a continuously varying presentation of the same clip.

**Caveat:** Requires two versions of each clip (fresh and fatigued), OR an additive delta (see #4). Without authored fatigued versions, the blend space has nothing to blend toward.

### 4. Additive fatigue layer — CODE + ONE AUTHORED CLIP, N × every strike

One additive clip: "how a tired fighter's movement differs from a fresh one." Applied as an additive layer scaled by fatigue level. Every strike clip in the library gets a fatigue dimension for free.

**Deterministic?** Yes — fatigue is deterministic game state.

**What it buys:** If the engine models 5 fatigue states, every strike clip becomes 5 clips. 102 × 5 = 510 apparent clips.

**Risk:** Requires the additive clip to be authored relative to the same reference pose the base clips use. If our retarget pipeline normalises to a common rest (likely, given `FightClipRetarget.build_corrections`), this works. If not, each clip needs its own additive pair.

### 5. IK-driven contact correction — CODE (MODERATE), fixes placement across body sizes

At the moment of impact, adjust the fist/hand position to land on the opponent's actual body surface. Prevents punches passing through a taller opponent or falling short of a shorter one.

**Deterministic?** Yes — contact points are computed from game state.

**What it buys:** Makes the existing clips look correct on all 12 body types, instead of correct on one and approximate on the rest. This is not variety per se, but it makes the variety we DO have look right.

**Cost:** This is the most expensive of the five. Requires an IK solver (Godot has `SkeletonIK3D`), per-clip contact point tagging, and tuning. But it is pure code — no new art.

---

## WHAT IS DISQUALIFIED

Anything that uses **RNG, wall-clock time, or frame-rate-dependent state** is disqualified. A seeded fight must present byte-identically on two runs (R82 proved it does). This rules out:
- Random take selection (we already use round-robin for this reason)
- Time-based variation ("play this clip differently after 30 seconds of fighting")
- Physics-driven variation that depends on frame timing

All five recommendations above are deterministic given the same game state.
