# LUDO ROUND 9 (S192, 2026-10-10) - "the animations are not feeling smooth"

Operator S192 (verbatim): "the animations are not feeling smooth , use ludo which is expert in 3d animation to solve our
animations with the help of codex on that". Asked in Ask Ludo (project FightCamp, his Chrome), text only. Prompt summary:
our pipeline (20 Hz sim -> scheduled clips ~3.5 s behind; mocap retargeted to MPFB, AnimationPlayer, linear crossfade
0.1 s strike / 0.25 s locomotion; procedural shuffle legs; root from the sim capped 3 cm / 10 deg per frame; guard held
between actions; gloves on hand bones; broadcast follow camera) + what the S192 frames show (overlap in exchanges, frozen
guard, feet slide, snaps at joins, camera re-frames in small jumps). Asked for A) 5 causes ranked, B) shipped technique +
numbers, C) build order, D) a number per step to measure.

## Ludo's answer (verbatim, read in slices; maths markup kept as he wrote it)

FightCamp 3D Animation Lead Report: Fluidity & Visual Fidelity Overhaul

As your 3D Animation Lead, here is the diagnosis and tactical blueprint. In combat sports simulations, "not feeling smooth" is almost never an issue with raw framerate or mocap keyframe density. It is the visual friction caused by a discrete 20 Hz logical state machine fighting a continuous physical world.

When characters snap at clip boundaries, slide their planted feet across the canvas, freeze into mannequin idles between rounds of action, clip through each other's chests, and twitch under a jittery camera, the eye immediately flags the simulation as disjointed.

Below is the diagnosis, the exact math and architecture shipped fight games use, the sequential implementation pipeline for Codex, and measurable validation metrics.

A) The 5 Root Causes (Ranked by Perceived Visual Jitter)
Foot Sliding (Skating) Under External Translation:
Why it breaks smoothness: When the root node translates across the canvas via your 3 cm/frame procedural shuffle while an AnimationPlayer clip plays back fixed foot keyframes, the feet have zero friction against the ring floor. The human brain tracks feet relative to the canvas grid instantly; foot skating immediately destroys the illusion of mass, weight transfer, and grounded combat.
Hard State Boundaries & Pose Incoherence (Snapping at Joins):
Why it breaks smoothness: Standard linear crossfading (cross_fade_to / Slerp) across mismatched velocities causes bone velocity to drop to near zero at mid-blend before accelerating into the next clip. When a 0.8s right cross cuts into a hit reaction or another strike, the momentum curve kinks, causing a visible hitch or snap at the join.
Mannequin Guard Freezing (Static Idle Dead Zones):
Why it breaks smoothness: Between action events, holding a static guard clip makes the fighters look paralyzed. Real boxers never freeze; they bounce rhythmically on their toes, shift weight between the lead and rear foot, pump their guard subtly, and cycle breathing in their shoulders and torso. Absolute stillness between action bursts reads as animation stall.
Mesh Interpenetration & Distance Collapse (Clipping):
Why it breaks smoothness: Because the 20 Hz simulation drives positions independently of skeletal limb geometry, infighting causes character capsules to overlap. When biceps clip through an opponent's jaw or torsos merge, the visual physics collapse, making strikes appear to phase through rather than impact.
Camera Micro-Jitter (Discontinuous Tracking):
Why it breaks smoothness: Moving the broadcast camera target directly based on raw sim positions (which are quantized at 20 Hz and capped per frame) injects high-frequency stepping into the viewport. Even if an animation is pristine, a jittering view frustum makes everything on screen look stuttery.

B) Industry-Standard Techniques & Exact Constants
1. Two-Bone IK Foot Locking with Velocity Thresholding
The Technique: Do not let the root position glide across the floor while feet animate freely. Use Godot's SkeletonIK3D (or a custom 2-bone analytical IK solver) on the leg chain (Thigh -> Shin -> Foot). Detect when a foot is planted using an animation curve track or an ankle height/velocity check. When planted, lock the foot's world position and orient the ankle to the canvas plane, driving the shin and thigh backwards as the body shifts forward until a liftoff threshold is reached.
Concrete Values:
Plant detection height threshold: $\le 4.5\text{ cm}$ above canvas plane.
Ankle velocity threshold to engage lock: $\le 0.12\text{ m/s}$.
Max allowable leg extension before forced unlock / step pop: $96%$ of total leg length ($L_1 + L_2$).
IK blend-in / blend-out smoothing: $0.08\text{ s}$ cubic ease.
2. Inertialization Blending (Replacing Linear Crossfade)
The Technique: Ditch standard linear slerp blending between clips. Shipped fighting games use Inertialization (or hermite cubic spline velocity matching). When a clip switch occurs mid-motion, do not evaluate both animations simultaneously. Instead, take the current bone transforms and their instantaneous angular/linear velocities, instantiate a decaying offset spring polynomial toward the target animation's incoming curve, and evaluate only the incoming animation plus the decaying offset. This preserves momentum and eliminates midpoint dead stops.
Concrete Values:
Strike Entry Blend Duration: $0.12\text{ s}$ (high-speed punch snap).
Strike Recovery to Guard: $0.22\text{ s}$.
Hit Reaction Interruption: $0.06\text{ s}$ (near-instant redirection of momentum).
Decay Half-Life ($t_{1/2}$ for inertial dampening): $0.05\text{ s}$.
3. Procedural Additive Idle, Rhythmic Sway & Respiratory Layer
The Technique: Run an additive animation node (AnimationNodeAdd2 in an AnimationTree) that constantly injects procedural oscillation into the spine, neck, and clavicle bones, multiplied by fighter conditioning and heart rate (BPM). Even when holding a "neutral guard" clip, a continuous sine/perlin noise driver breathes life into the upper body, shifts weight laterally, and creates natural head motion.
Concrete Values:
Weight-Shift (Lateral Hip Sway): $1.2\text{ Hz}$ frequency, amplitude $\pm 2.5\text{ cm}$ along the local lateral axis.
Guard Head Bob: $2.4\text{ Hz}$ (synced to foot rhythm), amplitude $\pm 1.8\text{ cm}$ vertical, $\pm 1.5^\circ$ pitch/roll.
Breathing Layer (Clavicle & Spine): Frequency derived from telemetry BPM / 60.0 Hz; vertical clavicle excursion: $0.8\text{ cm}$ at rest ($60\text{ BPM}$), expanding to $2.6\text{ cm}$ at peak exertion ($180\text{ BPM}$).
4. Capsule Separation & Procedural Arm Flaring (Infighting Spacing)
The Technique: Enforce a hard physical exclusion zone between character roots, supplemented by procedural shoulder offset adjustments. If the 20 Hz simulation drives the fighters inside a minimum separation distance, a client-side spring pushes the visual roots apart. When in a tight clinch, procedurally flare the elbows outward using an additive rotation on the upper arms so gloves rest against the opponent's guard rather than stabbing through their geometry.
Concrete Values:
Absolute Minimum Root Spacing: $58\text{ cm}$ (chest-to-chest standoff limit).
Separation Push Spring Stiffness ($k$): $450\text{ N/m}$, Damping Ratio ($\zeta$): $1.0$ (critically damped; zero oscillation).
Clinch Elbow Flaring: Up to $+35^\circ$ roll on UpperArm bones when opponent distance drops below $72\text{ cm}$.
5. Critically Damped Dual-Target Broadcast Camera
The Technique: The camera must never track raw fighter nodes directly. It must track a virtual midpoint anchor smoothed through a 2nd-Order Critically Damped Spring-Damper System (or exponential moving average with lookahead). The camera framer calculates the bounding box between both fighters' heads and feet, smoothly interpolates focal length/distance to maintain framing, and filters out high-frequency position spikes.
Concrete Values:
Midpoint Position Spring Damping ($\zeta$): $1.0$ (critically damped, zero overshoot).
Spring Natural Frequency ($\omega_n$): $6.0\text{ rad/s}$ (fast enough to keep rapid advances in frame, soft enough to eliminate micro-steps).
Camera Rotation Smoothing Half-Life: $0.25\text{ s}$.
Minimum Ring Margin Framing: Keep both bounding capsules within the central $65%$ of the viewport width.
C) Phased Implementation Order for Codex

Each phase produces a distinct, immediately visible improvement on its own:

[Phase 1: Camera Smoothing] -> (Baseline view stops jittering; true animation flaws become clearly visible)
[Phase 2: Additive Idle & Breathing (AnimationTree)] -> (Fighters look alive; eliminates the "frozen statue" guard)
[Phase 3: Separation Spring & Clinch Spacing] -> (Stops ugly chest-to-chest mesh clipping in phone-booth exchanges)
[Phase 4: Inertialized Transitions & Hit Reaction Blends] -> (Strikes snap crisply; eliminates jarring clip join hitches)
[Phase 5: Two-Bone IK Foot Locking] -> (Fighters plant, drive, and pivot cleanly against the canvas)

Step 1: Broadcast Camera Spring Damper (Immediate Viewport Stabilization)
Why First: If the camera is jumping, you cannot accurately assess animation quality. Stabilizing the camera provides a clean baseline.
Step 2: Switch to AnimationTree with Additive Idle/Breathing
Why Second: Replaces static AnimationPlayer.play() calls with a state machine combining base poses, procedural breathing, and sway. Instantly fixes the frozen look between attacks.
Step 3: Root Separation & Procedural Push-Back
Why Third: Solves the catastrophic visual glitch of fighters walking through each other during forward actions before tackling individual foot mechanics.
Step 4: Smooth Inertial Blending on Transitions & Hit Snaps
Why Fourth: Ensures that transitioning from guard to punch, or punch to hit reaction, smoothly carries momentum rather than popping bones.
Step 5: Planted Foot Locking & Two-Bone Leg IK
Why Fifth: Ground the fighters permanently onto the ring canvas. This is the most technically involved step, but with steps 1-4 active, it elevates the presentation to commercial quality.

D) Video Acceptance Metrics (Measurable over a 30-Second Clip)
To verify each step objectively, capture a 30-second 60 FPS video recording and measure these exact quantitative indicators:

| Step / System | Quantitative Metric to Measure | Pass Target |
| 1. Camera | Viewport Center-of-Mass Delta Acceleration: Standard deviation of camera frame-to-frame velocity ($\Delta v_{\text{cam}}$). | $\sigma < 0.015\text{ m/s}^2$ (Zero high-frequency camera stutter) |
| 2. Idle/Breathing | Inter-Action Bone Velocity: Minimum linear speed of Spine1 and Clavicle bones during non-action periods ($>1.0\text{ s}$ between punches). | $0.8\text{ cm/s} \le v \le 3.5\text{ cm/s}$ (Never drops to 0.0) |
| 3. Separation | Mesh Penetration Volume / Inter-Capsule Distance: Minimum distance between character pelvic root origins during infighting. | $\ge 55.0\text{ cm}$ (Zero torso/chest mesh overlap at all times) |
| 4. Blend Transitions | Joint Angular Acceleration Spikes: Peak angular jerk ($\frac{d^2\omega}{dt^2}$) of UpperArm and Forearm bones across clip transition frames. | No frame-to-frame jerk $> 180^\circ/\text{s}^2$ (Smooth acceleration curve) |
| 5. Foot Locking | Planted Foot Canvas Drift: Total lateral/longitudinal displacement of the lead foot while contact curve is flagged as "Planted". | $< 0.8\text{ cm total drift}$ per stance plant (Eliminates foot skating) |

(Ludo's follow-up offers: the Godot 4.7 scheduler with inertialized blending + foot locking + a headless test; the boxing state
machine / transition graph; a visual mockup of camera framing and debug overlays.)

## Claude's verdict (S192) - taken, with these corrections against our own record

1. ORDER TAKEN as Ludo gives it: camera, alive idle/breathing, separation, inertialization, foot lock. Each step behind its own
   switch (default OFF until the operator OKs its video), one game-camera video per step posted to 8787/review.
2. WHAT ALREADY EXISTS (Codex audits before writing): the camera already aims through `_cam_fit_dir.step_aim` (S191 broadcast +
   follow); `FightAliveStance.gd` (72 lines, C204 event-based weight/head/shoulder/level/breathe) is ON in the game; the engine has
   `FightSeparation.gd` (engine min hips gap) and the room clamps root writes 3 cm / 10 deg. Steps 1-3 EXTEND these, never a second copy.
3. NUMBERS: Ludo's blend times match our settled G147 (strike in 80-150 ms, strike-to-strike <=100 ms, >400 ms = cliff) - keep.
   Breathing from the S192 live pulse (Cardio BPM, already on the HUD). Two of his gates are unit-confused (camera "sigma of velocity
   < 0.015 m/s^2"; "jerk > 180 deg/s^2" is an acceleration) - Codex measures camera frame-to-frame ACCELERATION sigma and per-bone
   angular ACCELERATION spikes at joins, and reports OFF vs ON (a green instrument must read worse on the shipped tree first).
4. SPACING 58 cm root-to-root is a placeholder: our engine already owns a min gap read off the meshes' skin weights
   (FightBodyRadius, S4) - Codex reports the current min pelvis distance in exchanges first, then sets the push to the measured
   torso radii (bounded, never a guessed constant).
5. Seed for videos: NOT 94301 (S192 census: that seed ends in a rare 0:30 referee TKO; 0 of 90 game bouts stop before 2:00).

## LUDO ROUND 10 (S192) - the transition graph for step 4 + the AI doctor rule (verbatim)
Asked: per allowed transition among GUARD_IDLE, STEP, JAB, CROSS, hooks, uppercuts, BODY_SHOT, SLIP, ROLL, BLOCK, PARRY, FEINT,
CLINCH_ENTER/HOLD/BREAK, HIT_REACT, STAGGER, KNOCKDOWN, GET_UP: blend type, duration, earliest exit (cancel window), combo chaining;
which never blend. And: keep "AI corner waves on below 4 pips, towel at 4+"?

1) Boxing State Transition Graph
Clip Normalization Note: Exit point fraction ($F_{\text{exit}}$) is based on the source clip duration normalized to $[0.0, 1.0]$.

| Source State Class | Target State | Blend Type | Duration ($s$) | Earliest Exit ($F_{\text{exit}}$) | Combo Chain Enabled? |
| GUARD_IDLE | Any STRIKE (Jab, Cross, Hooks, Uppers, Body) | Inertialize | 0.08 | 0.00 | No (Starter) |
| GUARD_IDLE | STEP (Fwd / Back / Lat / Pivot) | Pose-Match | 0.16 | 0.00 | No |
| GUARD_IDLE | SLIP (L/R) / ROLL | Inertialize | 0.07 | 0.00 | No |
| GUARD_IDLE | BLOCK / PARRY | Inertialize | 0.05 | 0.00 | No |
| GUARD_IDLE | FEINT | Inertialize | 0.06 | 0.00 | No |
| GUARD_IDLE | CLINCH_ENTER | Inertialize | 0.20 | 0.00 | No |
| STEP (All) | Any STRIKE | Pose-Match | 0.10 | 0.35 | No |
| STEP (All) | GUARD_IDLE | Pose-Match | 0.18 | 0.70 | No |
| STEP (All) | SLIP / ROLL / BLOCK | Inertialize | 0.08 | 0.20 | No |
| JAB | CROSS / REAR_HOOK / REAR_UPPER | Inertialize | 0.09 | 0.52 (Impact + 1f) | Yes (1-2 Chain) |
| JAB | GUARD_IDLE | Inertialize | 0.18 | 0.75 | No |
| CROSS | LEAD_HOOK / LEAD_UPPER / BODY_SHOT | Inertialize | 0.11 | 0.55 (Impact) | Yes (Weight transfer) |
| CROSS | GUARD_IDLE | Inertialize | 0.22 | 0.80 | No |
| HOOKS (Lead/Rear) | Opposite Hand STRIKE / BODY_SHOT | Inertialize | 0.12 | 0.58 (Impact) | Yes (Torso torque) |
| HOOKS (Lead/Rear) | GUARD_IDLE | Inertialize | 0.24 | 0.82 | No |
| UPPERCUTS (L/R) | Opposite HOOK / CROSS | Inertialize | 0.12 | 0.56 (Apex) | Yes (Drive upward) |
| UPPERCUTS (L/R) | GUARD_IDLE | Inertialize | 0.22 | 0.78 | No |
| BODY_SHOT | Same/Opposite Hook or Uppercut | Inertialize | 0.10 | 0.54 (Impact) | Yes (Level change) |
| BODY_SHOT | GUARD_IDLE | Inertialize | 0.20 | 0.75 | No |
| SLIP (L/R) | Counter STRIKE (Cross / Hooks / Uppers) | Pose-Match | 0.08 | 0.45 (Weight loaded) | Yes (Counter chain) |
| SLIP (L/R) | GUARD_IDLE | Inertialize | 0.16 | 0.80 | No |
| ROLL | Counter HOOK / UPPERCUT | Pose-Match | 0.10 | 0.50 (Bottom roll) | Yes (Spring load) |
| ROLL | GUARD_IDLE | Inertialize | 0.18 | 0.85 | No |
| BLOCK / PARRY | Counter JAB / CROSS / HOOK | Inertialize | 0.07 | 0.30 | Yes (Riposte) |
| BLOCK / PARRY | GUARD_IDLE | Inertialize | 0.12 | 0.60 | No |
| FEINT | Any Real STRIKE / STEP | Inertialize | 0.06 | 0.38 (Pre-extension) | No |
| CLINCH_ENTER | CLINCH_HOLD | Cut | 0.00 | 1.00 (Contact snap) | No |
| CLINCH_HOLD | CLINCH_BREAK | Pose-Match | 0.25 | 1.00 (Ref call) | No |
| CLINCH_BREAK | GUARD_IDLE | Inertialize | 0.20 | 0.70 | No |
| ANY NON-STAGGER | HIT_REACT (Head Light/Heavy, Body) | Inertialize | 0.04 | 0.00 (Full interrupt) | No |
| HIT_REACT (All) | STAGGER / KNOCKDOWN | Inertialize | 0.06 | 0.20 | No |
| HIT_REACT (All) | GUARD_IDLE | Inertialize | 0.16 | 0.75 | No |
| STAGGER | KNOCKDOWN | Cut | 0.00 | 0.00 (Full interrupt) | No |
| STAGGER | GUARD_IDLE | Inertialize | 0.30 | 0.90 | No |
| KNOCKDOWN | GET_UP | Cut | 0.00 | 1.00 (Count $\ge 7$) | No |
| GET_UP | GUARD_IDLE | Inertialize | 0.35 | 0.95 | No |

Strict Transition Constraints (Never Blend / Immediate Cut or Lock)
NEVER BLEND (Must HARD CUT):
* -> KNOCKDOWN (Must freeze velocity instantly; dynamic physics/ragdoll take over; blending turns drops into floaty mush).
CLINCH_ENTER -> CLINCH_HOLD (Must snap to shared anchor coordinate root).
NEVER INTERRUPT (Must Wait for $F_{\text{exit}} = 1.0$):
KNOCKDOWN -> GET_UP (Cannot transition out until get-up sequence is fully reached).
CLINCH_HOLD cannot transition to strikes until CLINCH_BREAK clears separation ($>58\text{ cm}$).

2) Doctor AI Towel Rule
Change: The AI corner throws the towel at $\ge 4$ Pips unless the fighter leads on the scorecards going into the final round with
Composure $\ge 45$; at 5 Pips, the AI always throws the towel regardless of state.

### Claude's verdict (round 10)
- The table is the spec for ANIM-SMOOTH2's join step (inertialize/pose-match/cut + cancel windows); it is consistent with G147
  (into a strike 80-150 ms; hit reaction near-instant). "Clinch break > 58 cm" uses our measured torso radii instead (round-9 verdict 4).
- Doctor rule: Ludo CHANGES it (towel at 4+ pips EXCEPT leading into the final round with composure >= 45; 5 pips = towel always).
  Note V15: 5 pips is already an instant doctor stoppage, so the 5-pip clause never reaches the corner. Needs composure live
  (CORNER2A) for the exception. Put to the operator on the board (D39).

## LUDO ROUND 11 (S192) - QUEUED, NOT YET SENT (Chrome extension disconnected 05:35)
Operator S192 after the everything-on video (verbatim): "this so much better , some hits do not get a reaction , some misses do not
show the fighters head moving backward, the legs animation still look weird some times it seems like it is missing sidestep, hopping on
one foot etc , are these things will be addressed later on ?"
Claude: NOT covered by SMOOTH2 (spacing + joins) or SMOOTH3 (foot lock) -> two new parts:
- ANIM-SMOOTH4 REACTIONS + EVASION: every landed blow shows a reaction (additive on a defender who is mid-clip); a miss shows the
  defender's head/torso evasion (lean back / slip / pull) timed to the punch's extension.
- ANIM-SMOOTH5 FOOTWORK: a boxer's step vocabulary (step-drag, lateral shuffle, pivot, push-off retreat, bounce) chosen from the sim's
  movement; no one-foot hopping (feet alternate, max time on one foot).
Question for Ludo (send verbatim when Chrome is back): for each - A) what Fight Night Champion / Undisputed do, B) the rule set with
numbers (reactions: which contacts always react, additive vs whole, head/torso cm + deg per power band, recovery, layering on a defender
mid-punch; misses: evasion amplitude, timing vs the punch's extension, when not to show it; footwork: step vocabulary, speed/direction
thresholds that pick each step, stride length, step duration, the anti-hop rule), C) build order, D) one number per item to measure.

## LUDO ROUND 11 (S192, sent from the built-in browser pane - Chrome extension down) - "what is missing to make the animations humanlike"
Operator S192 (verbatim): "ask ludo what is missing to make the animations like humanlike and do whatever it says".
Asked: everything still missing for the boxers to move like real humans, ranked by how much a viewer notices, incl. the operator's three
(hits without reaction, misses without head motion, legs: missing sidestep / one-foot hopping); per item A) Fight Night / Undisputed,
B) rule with numbers, C) build order, D) one number for a 30 s video.

### Ludo's answer (verbatim; LaTeX markup simplified)

FightCamp 3D Animation Lead: The Complete "Humanlike" Overhaul Plan

This is the comprehensive diagnosis of the visual gap between a discrete 20 Hz simulation and a believable, living athlete on screen.

When viewers see:

Hits that don't get a reaction
Misses where the head doesn't pull back or flinch
Legs hopping or dragging during sidesteps

...it is because human movement is reactive, continuous, and physical, while the current system is playing disconnected clips sequentially. A real fighter never awaits an explicit simulation slip event to flinch away from an incoming leather glove, and real fighters never discard hit reactions just because their punch clip hasn't finished playing.

Below is the complete architectural roadmap of everything needed to achieve lifelike boxing animations, ranked by viewer perception.

1. Ranked Missing Systems: Breakdown & Formulas
Rank 1: Additive Procedural Hit Reactions (Layered on Current Action)
What Shipped Games Do (Fight Night, Undisputed): They do not cancel current attacks to play a full-body hit reaction clip for minor hits, nor do they ignore damage. Light and medium hits are computed as additive physics impulses on the upper torso/neck/head spine chain. If a boxer throws a right cross and eats a jab mid-punch, his head snaps back, his punch trajectory destabilizes, but his body continues through the strike.
Exact Mathematical Rule:
Define an additive hit impulse vector on Head, Neck, and Spine2.
Head snap pitch/yaw: theta_snap = Damage x 0.42 deg (capped at 24 deg for light/medium, >25 damage triggers full clip interrupt).
Duration: Quick snap-back over 45 ms, spring-damped return over 180 ms (zeta = 0.85).
Displacement: Additive root/chest translation push-back: 1.2 cm to 4.5 cm backward along the punch impact vector.
Build Order: Step 1 (Instantly fixes the "punches landing with zero visible reaction" complaint).
30-Second Video Metric: Hit Reaction Coverage: 100% of simulation-logged landed strikes show >= 4.0 deg angular head deflection or >= 1.5 cm spine displacement within 50 ms of contact.
Rank 2: Four-Way Stance-Aware Locomotion (Replacing the Procedural "Shuffle")
What Shipped Games Do: Neither Fight Night nor Undisputed uses procedural leg dragging for movement. They use an 8-way or 4-way blend space with strict push-pull foot logic. In boxing, if you move forward, the lead foot steps first, then the rear foot follows. If you move backward, the rear foot steps first. If you circle left, the left foot steps first. The "hopping on one foot" glitch occurs because the procedural shuffle is moving roots while blending clips that assume zero translation.
Exact Mathematical Rule:
Replace the procedural shuffle with 4 directional step loops: Step_Fwd, Step_Back, Step_Left, Step_Right, and Pivot_45.
Drive them via a 2D Blend Space (Vector2(movement_x, movement_y) normalized).
Push-Pull Cadence: Stride cycle length = 48 cm. Maximum translation speed = 1.8 m/s.
Phase Synchronization: Force foot plants at normalized clip phases 0.25 (lead foot plant) and 0.75 (rear foot plant). Never allow foot lifts if the other foot is not confirmed planted.
Build Order: Step 2 (Completely eliminates the "missing sidestep" and "hopping on one foot" issues).
30-Second Video Metric: Foot Contact Alternation: In any continuous >1.0 m movement sequence, zero frames occur where both feet are airborne (unless knocked down) and stance width never contracts below 32 cm.
Rank 3: Proximity Flinch & Anticipatory Head Tracking on Whiffs
What Shipped Games Do: When a punch misses by inches, fighters don't stand rigid like department store mannequins. Even without an explicit slip command in the logic tick, games cast a proximity sphere around the head. If an incoming glove enters that perimeter, an additive procedural flinch triggers: the neck tenses, chin tucks, and the head pulls back or tilts away from the trajectory.
Exact Mathematical Rule:
Proximity trigger cylinder: Radius 28 cm around Head bone origin.
If opponent glove enters cylinder with velocity > 2.5 m/s and defense state != hit:
Compute defensive evasion vector D = normalize(HeadPos - GlovePos).
Drive additive procedural head retreat: delta P_head = D x 6.5 cm max retreat.
Add chin tuck: Pitch +8 deg downward.
Engage time: 60 ms; recovery time: 160 ms.
Build Order: Step 3 (Solves "misses do not show the fighter's head moving backward").
30-Second Video Metric: Whiff Flinch Rate: >85% of punches passing within 25 cm of the defender's head trigger >= 3.0 cm head displacement away from the strike vector.
Rank 4: Kinetic Chain Stance Mechanics (Hip Rotation, Knee Bend & Rear Foot Pivot)
What Shipped Games Do: Punches do not originate from the shoulders. In real boxing, power starts at the ball of the foot, drives through knee extension and pelvis torque, travels up the spinal column, and discharges into the fist. When retargeted clips drop this, punches look weak ("arm punches").
Exact Mathematical Rule:
Rear Foot Pivot (Cross / Rear Hook): Rear ankle local yaw rotation twists inward by +55 deg +- 5 deg; rear heel elevates by +4.5 cm onto the toe.
Pelvis Torque: Pelvis yaws along the strike axis by 22 deg (Jab), 48 deg (Cross), 58 deg (Hooks).
Knee Flexion: Lead knee compresses down by 4.0 cm on hooks/uppercuts, dipping the Center of Mass (CoM) to load power.
Build Order: Step 4 (Transforms floaty punches into heavy, grounded strikes).
30-Second Video Metric: Pelvic Rotation Precedence: In 100% of power strikes, pelvic angular acceleration peaks between 30 ms and 60 ms before glove peak velocity.
Rank 5: Gaze & Neck Target Tracking (Look-At IK)
What Shipped Games Do: Real humans look at their opponent's chest and eyes, tracking incoming threats. If the head remains locked forward relative to the chest bone, fighters look dead-eyed and blind.
Exact Mathematical Rule:
Apply a 2-bone Look-At IK solver on Neck and Head targeting the opponent's Spine2 (upper chest) 80% of the time, and opponent's active glove 20% of the time.
Weighting: 70% head orientation, 30% neck orientation.
Clamp max tracking angles: Yaw +-42 deg, Pitch +-22 deg.
Saccadic shift smoothing: critically damped spring (zeta = 1.0, speed = 14 rad/s).
Build Order: Step 5 (Instantly creates genuine psychological tension in the ring).
30-Second Video Metric: Gaze Alignment: Fighter head forward vector stays within 12 deg of opponent's upper torso center during all non-hit-reaction frames.
Rank 6: Punch Velocity Profiles (Non-Linear S-Curve Snapping)
What Shipped Games Do: Raw mocap retargeted to game rigs often drags out punch windups and softens the final snap. Real elite punches feature an asymmetric velocity curve: explosive initial burst, near-instant terminal acceleration, a sudden stop at maximum extension (0 ms hang time), and a rapid, guarded recovery.
Exact Mathematical Rule:
Re-map punch playback curves using a custom cubic Hermite curve:
Extension phase (0.0 -> 0.45 time): Acceleration exponent 2.8 (violent snap into impact).
Impact hold: Exactly 1 frame (16.6 ms) at full extension.
Retraction phase (0.45 -> 1.0 time): Quick spring recoil (0.22 s duration), returning immediately along a defensive corridor toward the chin.
Build Order: Step 6 (Makes strikes look lethal and professional).
30-Second Video Metric: Punch Extension Ratio: Strike extension-to-retraction duration ratio is between 1:1.6 and 1:2.0.
Rank 7: Center of Mass (CoM) Balancing & Weight Transfer
What Shipped Games Do: A fighter's torso and pelvis automatically shift laterally and vertically to maintain balance over the base of support (the feet). When slipping left, the weight shifts 80% to the lead leg; when throwing a cross, it transfers from rear leg to lead leg.
Exact Mathematical Rule:
Calculate dynamic Center of Mass projection onto the canvas ground plane.
Base of Support (BoS): Polygon formed by the two planted foot contacts.
Slip L: CoM shifts 14 cm laterally toward the lead foot; lead knee flexes by 12%.
Cross: CoM moves forward 18 cm from initial stance midpoint, stabilizing exactly over the lead ankle at punch impact.
Build Order: Step 7.
30-Second Video Metric: CoM Ground Projection: CoM never exceeds the outer perimeter of the foot support polygon by more than 6.0 cm during un-rocked states.
Rank 8: Dynamic Fatigue Posture & Composure Degradation
What Shipped Games Do: As stamina falls and composure degrades into Shaken or Broken, a boxer's posture changes completely. The hands drop, the shoulders round forward, the chin comes up, and footwork slows down.
Exact Mathematical Rule:
Additive posture blend layer driven by Stamina (0-100) and Composure (0-100):
Guard height drop: Up to -12 cm vertical drop on wrists as Stamina drops <30%.
Spine hunch: +14 deg thoracic spine flexion (Spine1 pitch forward).
Breathing depth multiplier: Expands clavicle movement up to 3.2 cm amplitude at peak exhaustion.
Locomotion speed penalty: Step animation playback rate scales down to 0.78x.
Build Order: Step 8.
30-Second Video Metric: Wrist Height vs. Stamina Correlation: When stamina falls from 100 to 20, average guard wrist elevation drops measurably by 8 cm to 14 cm.
Rank 9: Glove Secondary Dynamics & Arm Inertia
What Shipped Games Do: Boxing gloves are heavy (10 oz padding). When a boxer steps, punches, or stops abruptly, the gloves have micro-overshoot and settle time. When gloves land on a guard or face, they deform slightly and halt without penetrating.
Exact Mathematical Rule:
Attach a secondary spring-damper to the wrist/hand bone offset:
Spring frequency omega_n = 28 rad/s, damping zeta = 0.72.
Translation limit: Capped at +-1.8 cm local displacement to prevent sloppy rubber-arm visuals.
Build Order: Step 9.
30-Second Video Metric: Wrist Settle Overshoot: Glove motion demonstrates 1.0 cm to 1.8 cm damped rebound settling upon abrupt movement stops.
2. Master Implementation Pipeline

Codex should implement these systems in the following precise order. Each step yields an immediate, unmistakable upgrade in visual quality:

[Step 1: Additive Procedural Hit Reactions] - Fixes "ghost punches" and missing impact reactions immediately.
[Step 2: 4-Way Push-Pull Locomotion System] - Fixes leg dragging, hopping on one foot, and missing sidesteps.
[Step 3: Proximity Flinch & Whiff Head Evasion] - Fixes static heads on missed punches.
[Step 4: Kinetic Chain (Ankle Pivot & Pelvis Torque)] - Eliminates weak "arm punches"; makes strikes look powerful.
[Step 5: Look-At IK Head/Eye Tracking] - Eliminates "dead mannequin" stare; fighters lock eyes.
[Step 6: S-Curve Punch Snapping Curves] - Gives punches professional speed and snap.
[Step 7: Center of Mass & Weight Shift] - Grounds balance realistically across the two feet.
[Step 8: Dynamic Fatigue/Composure Posture] - Ties fight management state visually into the 3D models.
[Step 9: Glove Secondary Micro-Inertia] - Final touch of weight and polish.

3. Concrete Acceptance Table for the Complete Pass

| Step | System | Key Numbers / Constants | Visual Pass Criteria in 30s Recording |
| 1 | Additive Hit Reacts | Snap time: 45 ms, Return: 180 ms, Max head yaw: 24 deg | 100% of landed punches cause visible head/neck deflection. |
| 2 | 4-Way Locomotion | 4-way blend space, stride 48 cm, stance min 32 cm | Zero instances of hopping or dragging; clean alternating push-pull footwork. |
| 3 | Proximity Flinch | 28 cm cylinder, max head pull 6.5 cm, chin tuck 8 deg | >85% of near-miss punches trigger realistic evasive flinches. |
| 4 | Kinetic Chain | Rear ankle yaw +55 deg, heel +4.5 cm, pelvis yaw 48 deg | Pelvis rotates 30 ms before fist extension on power shots. |
| 5 | Look-At IK Tracking | 80% chest target, max yaw 42 deg, spring omega_n = 14 rad/s | Boxer gaze stays within 12 deg of opponent at all times. |
| 6 | Punch S-Curves | Acceleration exp 2.8, 1 frame impact hold, 0.22 s return | Extension-to-retraction ratio stays within 1:1.6 to 1:2.0. |
| 7 | Weight Transfer | Slip lateral shift 14 cm, cross forward shift 18 cm | Dynamic CoM projection stays inside base-of-support boundaries. |
| 8 | Fatigue Posture | Guard drops up to -12 cm, spine hunch +14 deg | Measurable posture drop as stamina depletes below 30%. |
| 9 | Glove Inertia | Spring omega_n = 28 rad/s, max offset +-1.8 cm | Gloves exhibit clean micro-settle bounce on sudden stops. |

### Claude's plan (operator: "do whatever it says") - all nine, Ludo's order, each behind its own switch + a game-camera video
- Running now: ANIM-SMOOTH2 (spacing spring + inertialized joins, rounds 9-10) continues - the additive layers sit on it.
- HUMAN1 (Codex, after SMOOTH2): Ludo step 1 additive hit reactions + step 3 proximity flinch (both additive upper-body layers).
- HUMAN2 (Codex): step 2 four-way push-pull locomotion replacing the shuffle; absorbs the queued foot lock (SMOOTH3) - Ludo's plant
  phases ARE the lock. HUMAN3: steps 4 + 6 (kinetic chain + punch S-curves). HUMAN4: step 5 look-at. HUMAN5: step 7 centre of mass.
  HUMAN6: step 8 fatigue/composure posture (composure live = CORNER2A). HUMAN7: step 9 glove inertia.
- PURE MATH IN PARALLEL on cloud seats (zero preloads, tested, no engine edits) so Codex only wires it: FightHitAdditive, FightFlinch,
  FightLookAt, FightPunchCurve, FightGloveSpring.
- Where a gate mixes units (velocity vs acceleration) we measure the quantity it describes.
