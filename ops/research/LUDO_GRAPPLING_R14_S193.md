# LUDO ROUND 14 (S193, 2026-10-10) - GRAPPLING: how to make realistic, humanlike BJJ / wrestling / takedowns in Godot

Operator S193 (verbatim): "continue with ludo ask it also to solve the grappling animation (how to make a realistic humanlike bjj fight ,
takedowns and everything that is related to animations needs to be solved by ludo nad passed on to codex if it is possible".
Question (verbatim, text only): `LUDO_ROUND13_14_S193.md` "Round 14". Ludo's answer below, verbatim (LaTeX markup simplified to plain
text; box-drawing kept). It stops inside section 5 at "Viewport 3D Geometric Overlays **G" (Ludo's own length limit) - section 6 of the
question ("what Codex can build alone vs what needs an animator or capture") was NOT reached; its content-table column 4 answers part of it.

## Ludo's answer (verbatim)

FightCamp MMA Update: Two-Body Grappling Implementation Architecture
1. Unified Architecture: The Hybrid State Pipeline

Grappling between two different body sizes breaks traditional skeletal systems because skeletal hierarchies are independent trees, while grappling forms a closed-loop kinematic chain.

Pure ragdolls produce limp noodles; pure paired clips slide and hover due to proportions; physics collision engines jitter when two heavy capsule networks violently interpenetrate on the mat.

We solve this using a Phase-Specific Hybrid Authority Pipeline:

```
[Phase]               [Root Authority]              [Skeletal Authority]             [Constraint Layer]
──────────────────────────────────────────────────────────────────────────────────────────────────────────
Standing Clinch  ──> Independent Roots (Driven)  ──> Paired Clips (_Att/_Vic)    ──> Grip Anchor FABRIK + Surface Push
Shot / Sprawl    ──> Independent Roots           ──> Velocity-Driven Clips       ──> Trajectory Alignment + Chest Plane
Lift / Throw     ──> Shared Dual-Root (Attacker) ──> Rigid Parented Paired Clips ──> Joint Limits + Pelvis Pin
Fall (Freefall)  ──> Dynamic COM Midpoint Ballistic ─> Blended Fall Pose        ──> Early Floor-Ray Predictor
Landing / Impact ──> Mat Lock (Z-Normal Clamped) ──> Inertial Dampener + Decal   ──> Kinetic Energy Absorb Springs
Ground Holds     ──> Master-Anchor Frame (Mat)   ──> 1-Frame Basis Poses         ──> Polar Distance Clamps + Breathing
Ground Scramble  ──> Dynamic Root Midpoint       ──> Short Paired Micro-Loops    ──> Pelvic Alignment Springs
Submissions      ──> Shared Anchor (Attacker)    ──> Hold Blend Tree + Procedural ──> 2-Bone Arm/Leg IK + Bone Limiters
```

Authority Matrix Rules

Standing Clinch (Independent Roots + Soft Constraint IK):

Both boxers own their root translations on the canvas.
FightStagePlayer synchronizes playhead times of paired clips (Clinch_OverUnder_Att, Clinch_OverUnder_Vic).
A bidirectional soft-distance spring keeps pelvises within [0.38 m, 0.48 m]. Hands resolve to named anchors via two-bone analytical IK.

The Throw / The Lift (Shared Master Root Authority):

The Attacker's root becomes the Master Transform. The Victim's root node is dynamically reparented or strictly constrained to the Attacker's Pelvis bone with an analytical offset.
Eliminates phase divergence, root drift, and sliding during dynamic suplexes, double legs, and hip tosses.

Freefall & Mat Landing (Kinematic to Mat Projected Anchor):

Freefall: Parabolic physics trajectory calculated for the combined Center of Mass (COM_combined).
Landing: At t_mat - 60 ms, raycasts query the mat surface normal. Roots lock their vertical axis (Y = 0 m) on contact; vertical kinetic energy is transferred into an additive, heavily damped impulse across the spines (Spine1, Spine2).

Ground Holds & Submissions (Ground-Plane Master Anchor + Closed-Loop Distance Solver):

Both fighters share a single invisible floor anchor point on the canvas: T_mat_anchor.
Instead of long running clips that drift, positions (Mount, Side Control, Guard) are anchored using 1-Frame Reference Stances + procedural micro-motion (breathing, weight redistribution, limb posting).
Limbs are locked to the opponent's body using our typed grip anchors via a cyclic distance-relaxation solver (FABRIK).
2. Prioritized Implementation Steps & Automated Test Thresholds
Pipeline Flow & Touch Points:
```
[20 Hz Sim (GrappleTick)] ──> [FightWorldLiveScreen (Root Pairing & Mat Anchors)]
                                        │
                                        ▼
[FightStagePlayer (Paired Clip Engine)] ──> [FightGrappleSolver (Two-Body Closed Chain IK)]
                                                          │
                                                          ▼
                                            [record_room.gd (CSV)] ──> [Tools/grapple_metrics.py]
```

Step 1: Paired Root Sync & Master-Slave Dynamic Handoff
Systems Touched: FightWorldLiveScreen.gd, FightStagePlayer.gd, record_room.gd.
Exact Mathematics & Rules:
When entering a unified grappling interaction (Throw, Takedown, Ground Seat), compute the shared reference anchor: P_anchor = (m_att P_att_pelvis + m_vic P_vic_pelvis) / (m_att + m_vic)
Transfer root ownership: P_vic_root(t) = P_att_root(t) + R_att(t) · O_offset
Transition interpolation: Cosine slerp over 120 ms (Δt = 0.12 s) to prevent positional snapping.
Pass/Fail Thresholds (grapple_metrics.py):
PASS: During throws and lifts, attacker-to-victim relative root trajectory jitter < 0.8 mm per frame; 0 instances of temporal desync between paired clip playheads (Δt_playhead < 1 ms).
FAIL: Playhead drift >= 16.6 ms (1 frame out of phase) or victim root sliding > 2.0 cm relative to attacker pelvis anchor during flight.
Non-Regression Guard: Free standing striking foot positions must remain 100% unconstrained when grappling state is IDLE.
Step 2: Surface-Contact Gap & Penetration Solver (The 2-Body Skin Clamp)
Systems Touched: FightGrappleSolver.gd (New Node), FightAliveStance.gd.
Exact Mathematics & Rules:
Define directional surface capsule envelopes for both bodies: Chest, Pelvis, Thighs, Upper Arms.
For each bone pair (A_i, B_j), compute closest distance vector D_ij = x_Ai - x_Bj.
Target contact distance D_target = r_Ai + r_Bj (where r is the capsule collision radius adjusted by athlete mesh thickness from MPFB rigs).
If |D_ij| < D_target (Penetration): Apply repulsive linear offset: Δx = (D_target - |D_ij|)/2 · D_ij/|D_ij|
If |D_ij| > D_target and state is IN_GRIP: Apply non-linear attractive spring: F_pull = -k_grip (|D_ij| - D_target) · D̂_ij, k_grip = 450.0 N/m
Pass/Fail Thresholds (grapple_metrics.py):
PASS: Contact surfaces maintain surface gap within [0.0 cm, 1.8 cm]; mesh-to-mesh penetration depth <= 0.5 cm over 98% of evaluated frames.
FAIL: Any capsule penetration > 1.5 cm (visible polygon clipping) or hovering gap > 3.0 cm for > 3 consecutive frames during a locked hold.
Non-Regression Guard: Solver iterations must be strictly clamped to 4 iterations per frame to guarantee a budget under 0.8 ms on CPU.
Step 3: Typed Grip Anchors & FABRIK Arm/Leg Latching
Systems Touched: FightGrappleSolver.gd, FightStagePlayer.gd.
Exact Mathematics & Rules:
Define 14 standard grip sockets per MPFB skeleton: Grip_Collar_L/R, Grip_Tricep_L/R, Grip_Wrist_L/R, Grip_Hip_L/R, Grip_Knee_L/R, Grip_Ankle_L/R, Grip_Back_Upper, Grip_Neck.
Sockets export a position and normal orientation vector n_surface.
Hand/Foot bone placement solved via 2-Bone IK with target pinned to the socket: P_wrist_target = P_socket + (n_surface × r_glove_offset)
Shoulder/Elbow angle adjustments clamped to anatomical limits: Elbow yaw/pitch clamped within [0°, 150°]; Wrist flex clamped within [-60°, 60°].
Pass/Fail Thresholds (grapple_metrics.py):
PASS: End-effector distance to target socket <= 1.2 cm across all active grip phases regardless of fighter scale differential (1.70 m vs 1.90 m).
FAIL: Hand detachment > 2.5 cm from locked grip point during standing clinch or submission setup.
Non-Regression Guard: If target socket moves beyond the physical reach limit of the limb (L_arm > L_upper + L_forearm), smoothly decay grip influence to zero over 80 ms rather than popping the shoulder joint.
Step 4: Mat-Normal Collision, Raycast Pinning & Ground Compression
Systems Touched: FightGrappleSolver.gd, FightWorldLiveScreen.gd.
Exact Mathematics & Rules:
Cast a dense grid of 6 vertical downward rays (3 per fighter: Pelvis, Mid-Spine, Head).
Raycast collision points define the local ground constraint height Y_mat = 0.0 m.
Lowest skeletal points (spine in guard, knees in mount, hips in side control) clamped strictly to: P_bone.y >= Y_mat + r_bone_radius
Visual impact squash: On heavy slam landings, apply a 1-frame squash scale to the bottom-most capsules (S_y = 0.88, S_x = 1.06, S_z = 1.06) recovering over 140 ms via damped spring (ζ = 0.70).
Pass/Fail Thresholds (grapple_metrics.py):
PASS: Zero instances of ground-plane clipping (Y < -0.5 cm) for any torso or head joint; maximum ground separation for the bottom fighter <= 1.0 cm (no hovering).
FAIL: Any torso bone dipping below canvas (Y < -1.0 cm) or hovering above canvas (Y > 3.0 cm) during ground seats.
Non-Regression Guard: Mat raycasts must ignore fighter collision capsules using Godot 4 Collision Mask layers (Mask 1: Mat Canvas, Mask 2: Fighter Meshes).
Step 5: Inertial Fall, Slam Trajectory & Kinetic Energy Transfer
Systems Touched: FightWorldLiveScreen.gd, FightStagePlayer.gd, record_room.gd.
Exact Mathematics & Rules:
Takedown apex triggers ballistic flight mode: P_COM(t) = P_0 + V_0 t + ½ g t², g = [0, -11.5, 0] m/s²
Impact prediction: Solve t_impact where P_COM(t_impact).y = h_floor.
Camera shake & ring canvas deformation dispatched on impact: Impulse_impact = (m_att + m_vic) × |V_impact| × 0.0035
At t = t_impact, clamp vertical velocity instantly to 0; inject restorative compression spring into both fighters' spines.
Pass/Fail Thresholds (grapple_metrics.py):
PASS: Transition from flight trajectory to ground seat occurs within 1 single physics frame (16.6 ms) without visual pop (< 1.0 cm root position discontinuity).
FAIL: Any frame where body ascends after floor contact without a deliberate kick-off force, or position snaps > 3.0 cm at impact moment.
Non-Regression Guard: Ring mat bounce animation must only trigger when fall impact velocity exceeds 2.8 m/s.
Step 6: Ground Seat Micro-Motion, Chest Alignment & Dynamic Breathing
Systems Touched: FightAliveStance.gd, FightGrappleSolver.gd.
Exact Mathematics & Rules:
For ground holds (Mount, Side Control), pin the relative chest orientations using a normal-matching vector: n_vic_chest · n_att_chest = -1.0 ± 0.15 (Chest-to-Chest Alignment)
Inject cyclical procedural respiration: ΔY_chest(t) = A_breath · sin(2π · f_breath · t) Where A_breath = 0.012 m fresh, 0.038 m exhausted (< 30 Stamina).
Micro-weight distribution: If top fighter shifts, calculate shift vector and translate the pelvis by ±3.5 cm with an antagonistic compensatory rotation in the head and neck.
Pass/Fail Thresholds (grapple_metrics.py):
PASS: Static ground holds exhibit continuous organic movement with RMS bone velocity between 0.8 cm/s and 4.0 cm/s (never zero/frozen, never jittery).
FAIL: Completely static poses (RMS velocity < 0.2 cm/s) for > 0.5 s (mannequin effect) or chaotic jitter (RMS > 8.0 cm/s).
Non-Regression Guard: Respiration layers must not push contact surfaces into penetration violation limits set in Step 2.
Step 7: Dynamic Scramble, Transition Sliders & Slip-Angles
Systems Touched: FightStagePlayer.gd, FightGrappleSolver.gd.
Exact Mathematics & Rules:
Transitions between seats (Guard → Half Guard → Side Control) do not use canned cutscenes; they use Normalized Transition Progress (u ∈ [0, 1]).
Linear blend between reference anchors with rotational quaternion spherical linear interpolation: q_bone(u) = slerp(q_start, q_end, 3u² - 2u³)
During scrambling, if friction check fails (Sweaty Fighter / Late Round → friction μ = 0.35), allow hip slip angle up to 18.0° of unconstrained roll before catch constraint re-engages.
Pass/Fail Thresholds (grapple_metrics.py):
PASS: Transition progress u tracks smoothly monotonically with zero angular jerk spikes (d²θ/dt² < 350°/s²).
FAIL: Positional pop > 2.0 cm or angular flip > 15.0° in a single frame during seat switching.
Non-Regression Guard: Transition cancel/reversal by the simulation tick must preserve current skeletal momentum using Godot's Inertializer without resetting progress to 0.
Step 8: Submission Lock Anchors & Anatomical Stress Limits
Systems Touched: FightGrappleSolver.gd, record_room.gd.
Exact Mathematics & Rules:
Joint strain vectors defined per submission:
Armbar: Elbow hyper-extension angle θ_elbow ∈ [0°, -25°] past 0° flat lock.
Kimura: Shoulder internal rotation θ_shoulder_yaw ∈ [80°, 125°].
Guillotine/RNC: Neck flexion/compression offset ΔP_neck = 2.5 cm toward attacker bicep anchor.
Resistance curves: Spring stiffness increases exponentially as the sub-lock deepens: k_joint_resist = k_0 · exp(3.2 · Strain/MaxStrain)
At Strain >= 0.90, activate involuntary anatomical shudder: High-frequency noise (18 Hz, amplitude 1.5 mm) injected into the victim's trapped limb.
Pass/Fail Thresholds (grapple_metrics.py):
PASS: Trapped joint hits target anatomical strain configuration within ±5% and remains locked without joint dislocation or mesh tears.
FAIL: Limb over-rotates beyond biological safety threshold (e.g. elbow past -30°, shoulder past 135°) or slips out of the attacker's grip box before the tap.
Non-Regression Guard: If the defender escapes via simulation event, joint resistance forces must collapse immediately (0 ms delay) to avoid phantom limb stiffness.
Step 9: Procedural Tapping Mechanics & Referee Stoppage Release
Systems Touched: FightAliveStance.gd, FightStagePlayer.gd.
Exact Mathematics & Rules:
Tap detection: Free hand evaluates closest surface (Opponent Body or Canvas).
Procedural Tap Generator: Rapid periodic kinematic slap targeting surface:
Frequency: 4.5 Hz (approx. 1 tap every 220 ms).
Amplitude: 8.0 cm strike cycle. Contact hold: 40 ms per slap.
Post-Tap Release Sequence:
Upon tap registration, Attacker grip spring authority drops to 0.0 over 120 ms.
Both fighters transition to loose passive ground rest pose via critically damped spring (ζ = 0.88).
Pass/Fail Thresholds (grapple_metrics.py):
PASS: Tap cycle executes between 3 and 5 distinct contacts with target surface before grip release; release sequence executes within 150 ms of referee whistle event.
FAIL: Tapping hand clips through the mat/body surface by > 1.0 cm or misses surface contact by > 2.0 cm; attacker fails to let go within 250 ms.
Non-Regression Guard: Referee whistle halts all joint-strain calculations instantly to eliminate post-match damage calculation bugs.
3. Content Strategy: The Minimum Viable Grappling Asset Pipeline

You do not need hundreds of motion capture clips. By separating Root Transitions from Static Stance Bases, a compact asset pack covers every legal match state.

Master Asset Requirement Table

| Position / Action | Type Needed | Asset Count | Asset Source & Production Method |
| :--- | :--- | :--- | :--- |
| Standing Clinch | Static Hold + Micro Loops | 3 Paired Poses | Over-Under, Double Unders, Collar Tie. Hand-keyed in Blender (1 day). |
| Takedowns: Double Leg | Dynamic Paired Clip | 1 Paired Clip | DoubleLeg_Att + DoubleLeg_Vic. Clean from CMU Mocap #22 (0.5 day). |
| Takedowns: Single Leg | Dynamic Paired Clip | 1 Paired Clip | SingleLeg_Att + SingleLeg_Vic. Clean from CMU Mocap #22. |
| Takedowns: Judo Trip/Throw| Dynamic Paired Clip | 1 Paired Clip | HaraiGoshi_Att + HaraiGoshi_Vic. CMU Mocap. |
| Sprawl / Stuffed Shot | Branching Reaction Clip | 1 Paired Clip | Attacker stalls at knees; Defender flattens hips. Blender tweak. |
| Ground Bases: Guard | 1-Frame Basis Pose | 2 Poses (Top/Bottom) | Closed Guard, Open Guard. Hand-pose in Blender (2 hours). |
| Ground Bases: Half Guard | 1-Frame Basis Pose | 2 Poses (Top/Bottom) | Half Guard Top, Half Guard Bottom. Hand-pose in Blender (2 hours). |
| Ground Bases: Side Control| 1-Frame Basis Pose | 2 Poses (Top/Bottom) | Side Control Top, Side Control Bottom. Hand-pose in Blender (2 hours). |
| Ground Bases: Mount | 1-Frame Basis Pose | 2 Poses (Top/Bottom) | High Mount Top, High Mount Bottom. Hand-pose in Blender (2 hours). |
| Ground Bases: Back Control | 1-Frame Basis Pose | 2 Poses (Top/Bottom) | Back Mount with Body Triangle. Hand-pose in Blender (2 hours). |
| Transitions (Passes/Sweeps)| Directional Slerp Paths | 6 Procedural Curves| Guard → Half → Side → Mount. Solved via procedural curve + IK. |
| Ground-and-Pound | Additive Upper Body Striking| 4 Single Clips | Postured Mount Punches, Guard Hammerfists. Hand-keyed in Blender. |
| Submissions: Armbar | 1-Frame Anchor + IK Solver | 1 Paired Pose | Classic J-Armbar from Guard/Mount. Blender hand-pose. |
| Submissions: RNC | 1-Frame Anchor + IK Solver | 1 Paired Pose | Back mount choke lock. Blender hand-pose. |
| Submissions: Triangle | 1-Frame Anchor + IK Solver | 1 Paired Pose | Triangle lock from Guard. Blender hand-pose. |
| Submissions: Guillotine | 1-Frame Anchor + IK Solver | 1 Paired Pose | Front Headlock / Guard Choke. Blender hand-pose. |
| Submissions: Kimura | 1-Frame Anchor + IK Solver | 1 Paired Pose | 2-on-1 Figure Four Lock from Side/Guard. Blender hand-pose. |
| The Tap | Procedural IK Generator | 0 Clips | 100% Procedural kinematic slap layer via FightAliveStance.gd. |

How to Exploit Existing Data Without Wasting Budget
The 38 Minutes of 3D Tracked Video Footage:
Discard ground frames entirely: Optical 3D tracking collapses into bone tangles during mat scuffles due to self-occlusion.
Use standing frames exclusively: Extract precise entry velocities, penetration distances, and stance angles for the standing clinch, level changes, and initial shot entries. Feed these into the simulation state parameters.
The 16 Paired Clips:
Use these as the exclusive foundation for high-acceleration dynamic maneuvers: Throws, Slams, and Takedown entries where procedural generation looks floaty.
Blender Master-Anchor Posing Protocol:
Never author running multi-second ground animations in Blender.
Author strictly 2-character 1-frame static rigs aligned at the world origin (0, 0, 0) on a virtual mat plane.
Let Godot’s runtime solver handle breathing, limb pinning, micro-struggles, and body size compensation. This cuts animation workload from weeks to 2 days.
4. The 60-Second Grappling Benchmark Scene

A fully scripted timeline exercising every system, running deterministically at 20 Hz simulation ticks / 60 Hz visual ticks.

Fighter A (Red Trunks): Viktor "The Bear" Morozov (Wrestler, Heavy Muscle Mass, Height 1.78 m, Mass 84 kg).
Fighter B (Blue Trunks): Lucas "Cobrinha" Silva (BJJ Specialist, Lean/Lanky Build, Height 1.88 m, Mass 77 kg).
Timeline (Seconds 00.00 -> 60.00):
```
00.0s ──── 08.0s ──── 15.0s ──── 24.0s ──── 32.0s ──── 41.0s ──── 50.0s ──── 56.0s ──── 60.0s
[Clinch/Tie] [Level/Shot] [Sprawl/Stuf] [Mat Slam]  [Half Guard] [Side Control] [Mount/GnP] [Armbar Ext] [Tap/Break]
```

Deterministic Event Breakdown
00.00s – 08.00s | Standing Collar-Tie, Hand Fighting & Stance Tension:
Morozov advances; Silva steps back into an angled southpaw stance.
Morozov grips Silva’s neck (Grip_Neck); Silva grabs Morozov’s right tricep (Grip_Tricep_R).
FABRIK pins hands to sockets; distance spring maintains 44.0 cm torso gap.
Both fighters exert antagonistic lateral pull; zero foot sliding.
Verifies: Step 2 (Surface Gap), Step 3 (Grip Anchors).
08.00s – 15.00s | Level Change, Blast Double Leg & Sprawl Defense:
Morozov changes level: drop height -42.0 cm, drives forward at 3.8 m/s.
Silva reacts with defensive sprawl: hips drive down, legs kick back into wide base.
Chest-to-shoulder contact envelope engages: Morozov’s forehead pins to Silva’s sternum.
Shot stalls out against mat friction. Roots remain level on canvas.
Verifies: Step 2 (Penetration Clamp), Step 4 (Mat Pinning).
15.00s – 24.00s | Re-Shot, High Amplitude Slam & Mat Impact:
Morozov switches to a high crotch, lifts Silva off the canvas (Victim root reparented to Attacker).
Parabolic flight trajectory to canvas at V_impact = 3.6 m/s.
t = 21.40 s: Impact on canvas. Both roots lock to Y = 0; mat squashes 12%; vertical impulse transfers into torso spring.
Camera shakes with amplitude proportional to impact velocity; Silva absorbs hit into spinal flex.
Verifies: Step 1 (Master Root Sync), Step 5 (Impact Trajectory).
24.00s – 32.00s | Guard Retention, Chest Pin & Respiration Micro-Motion:
Landing settles into Closed Guard: Silva on bottom (back on mat), Morozov in top posture.
Continuous chest-to-chest breathing oscillations active (0.03 m displacement at 155 BPM).
Silva clamps Morozov’s posture down via neck grip; surface envelopes prevent chest clipping.
Verifies: Step 4 (Mat Raycast), Step 6 (Micro-Motion & Breathing).
32.00s – 41.00s | Guard Pass, Hip Slide & Side Control Settling:
Morozov postures up, breaks guard with right knee slide.
Transition path (u: 0.0 → 1.0) drives Morozov’s hips over Silva’s right thigh into Side Control.
Silva’s hips exhibit dynamic slip angle (14.0°) before framing on Morozov's jaw.
Both fighters settle chest-to-chest perpendicular (90° orientation).
Verifies: Step 6 (Weight Balance), Step 7 (Transition Sliders).
41.00s – 50.00s | Mount Transition, Ground-and-Pound & Posture Up:
Morozov slides knee across belly into Full Mount (u: 0.0 → 1.0 over 1.8 s).
Morozov postures up to strike: knees lock into Silva’s ribs (Grip_Hip_L/R).
Morozov throws 3 downward hammerfists. Silva brings active forearm shell to absorb shots.
Additive hit reaction depresses Silva’s head into mat without penetrating canvas floor.
Verifies: Step 2 (Capsule Clamping), Step 7 (Transition Smoothness).
50.00s – 56.00s | Armbar Transition & Hyperextension Strain Lock:
Silva catches Morozov’s right wrist, swings hips around for an Armbar from the bottom.
Morozov’s right arm is trapped between Silva’s thighs; Silva arches hips upward.
Elbow hyper-extension solver activates: elbow angle forced to -14.0° past lockout.
Joint strain crosses 0.90: high-frequency muscle shudder (18 Hz) ripples through Morozov’s arm.
Verifies: Step 8 (Submission Joint Limits).
56.00s – 60.00s | The Tap, Joint Release & Referee Whistle:
Morozov’s free left hand rapidly taps Silva’s thigh: 3 clean, crisp impacts (220 ms period).
Referee calls fight at 58.20 s: Whistle event triggers instantly.
Silva releases arm lock immediately; both fighters collapse into a relaxed rest pose on the mat.
Verifies: Step 9 (Tapping Generator & Release).
5. What Makes Grappling Read as Human (Visual Realism) & Debug HUD
The 5 Visual Hallmarks of Human Grappling
Skin-on-Skin Surface Resistance:
Real fighters never pass through each other, nor do they hover. The illusion of grappling is sold at the boundaries of the chest, hips, and neck. When Morozov is in mount, his chest must visibly flatten against Silva's chest, not hover 4 cm above it.
Heavy, Asymmetric Hip Weight:
In a fight, the person on top feels heavy because their pelvis drops below their legs, focusing all gravitational mass onto the bottom fighter. If the top fighter’s hips stay level with their knees, they look like a buoyant plastic toy.
Active Grip Friction & Finger Tension:
Hands do not simply stay near a wrist; they wrap, cinch, and pull skin. When an arm is pulled, the attached torso must move with it. Independent limb movement breaks the illusion.
Respiration & Shudder Under Isometric Load:
Isometric holds require extreme muscular exertion. Static bodies look dead. Simulating chest expansion, neck veins, and high-frequency muscular trembles during deep submission locks instantly communicates agony and effort.
The Slap Physics of the Tap:
A human tap is frantic, rhythmic, and urgent. It must strike with audible and visual impact on the opponent's thigh or mat, and the release by the attacker must be sudden and total.
Real-Time Grappling Debug Overlay Additions

Activated alongside the standard boxing debug panel via F3.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ [F3] DEBUG OVERLAY: MMA / GRAPPLING ENGINE                                  │
│                                                                             │
│ TOP-LEFT: Attacker (Morozov - 84kg)       TOP-RIGHT: Defender (Silva - 77kg)│
│ State: MOUNT -> ARMBAR (Progress: 0.88)   State: SUBMISSION_STRAIN (ARMBAR) │
│ Root Authority: MASTER [SHARED_ROOT]      Root Authority: SLAVE [ATTACHED]  │
│ Contact Gap: 0.42 cm [STABLE]             Contact Gap: 0.42 cm [STABLE]     │
│ Mesh Penetration: 0.12 cm [PASS]          Mesh Penetration: 0.12 cm [PASS]  │
│ Joint Strain: R_ELBOW @ -14.2 deg (92%)   Muscle Tremor: ACTIVE (18 Hz)     │
│ Active Grips: [L_WRIST, R_ANKLE]          Active Grips: [POSTURE_HEAD]      │
│                                                                             │
│                            [3D VIEWPORT RENDERS]                            │
│                                                                             │
│                     (Mat Surface Rays: White Vectors)                       │
│                                     │                                       │
│                (Grip Anchor Constraints: Blue Link Bars)                    │
│                                     │                                       │
│                 (Contact Distance Springs: Yellow Lines)                    │
│                                     │                                       │
│              (Surface Contact Penetration: Red Flash Mesh)                  │
│                                     │                                       │
│               (Shared Center of Mass: Orange Double Sphere)                 │
│                                                                             │
│ BOTTOM-CENTRE: Grapple Contact Metrics                                      │
│ Surface Clearance: 4.2 mm | Solver Iterations: 3/4 | Mat Drift: 0.00 mm     │
└─────────────────────────────────────────────────────────────────────────────┘
```

Viewport 3D Geometric Overlays
**G
(answer ends here - Ludo's output limit)

Ludo's next offers (round 14): turn the architecture into a Godot 4 file-by-file Codex task list with typed GDScript signatures and feature
flags; define the exact 60-second benchmark timeline, CSV schema, metrics and automated pass/fail thresholds; generate a debug-overlay
concept showing grip anchors, contact gaps, centre of mass, solver constraints and phase authority.

## Rounds 15 / 15b / 15c (same day) - Ludo's follow-ups, all in one request
`LUDO_ROUND15_S193.md` (boxing code + grader + overlay; grappling ownership matrix, task list mapped to our files, contact specs 1-11) and
`LUDO_ROUND15C_S193.md` (clinch ties 11-13, the 60 s grader, the grappling overlay, the next 5 flaws, 4 pure modules).

## CLAUDE'S VERDICT - GRAPPLING (for the operator's approval on the board, D39 LUDO FIRST)
TAKE Ludo's phase-authority architecture whole:
- Standing clinch: both men own their roots; paired clips play in sync; hands latch to named grip sockets by two-bone IK.
- Lift / throw / takedown: the ATTACKER's root becomes master; the victim rides on an offset from the attacker's pelvis (no drift).
- Fall: one ballistic arc for the pair; the landing locks to the mat; the impact goes into a damped spine spring.
- GROUND: no long ground clips. Each seat (mount, side control, closed guard, half guard, back control) and each submission (armbar,
  RNC, triangle, guillotine, kimura) is ONE solved basis pose for the pair, made alive by procedural breathing, weight shift and tremor;
  seat changes slide between basis poses (u 0 -> 1, smoothstep slerp, 0.4 s inertialized). The TAP is procedural.
- This fits our record: FightPoseSolver (surface gaps for both bodies) and PairedStagePlayer already exist; the operator's 2026-09-20
  ruling "i dont mind too much if some body parts intertwine but the movements need to be accurate" allows a solver-made pose.
- BASIS POSES BY SCRIPT, NOT BY HAND: Ludo says (2.1, 2.3) Codex can solve every hold from a CONTACT SPEC (which hand on which socket,
  which bones pinned to the mat, chest alignment). We do it IN GODOT with FightPoseSolver (not Blender), and the operator judges each
  hold as a still from the game camera before it ships.
CORRECT before building (our record wins):
1. The contact specs are a DRAFT, checked by a validator before use: the triangle uses socket "HEAD", which is not in Ludo's own enum
   (add a HEAD socket); mount's alignment (both forward axes +Z, dot 1.0) says nothing about chest-to-chest - use chest normals (dot -1
   +/- 0.15, Ludo's own step-6 rule); the clinch ties list both men's hands in one grip list - every grip needs a source_body.
2. Thresholds of record = the per-step numbers in round 14 (root slide <= 2.0 cm, gap 0-1.8 cm, penetration <= 0.5 cm on 98% of frames,
   grip error <= 1.2 cm, mat dip >= -1.0 cm, ground RMS 0.8-4.0 cm/s, seat-switch pop <= 2.0 cm, tap 3-5 contacts, release <= 150 ms).
   Ludo's 15c grader used other numbers and windows that do not match its own timeline (slam graded at 8-14 s; the slam is at 15-24 s):
   the grader's windows come from the timeline (clinch 0-8, shot + sprawl 8-15, slam 15-24, guard 24-32, pass 32-41, mount + GnP 41-50,
   armbar 50-56, tap 56-60).
3. "CMU Mocap #22" for the double/single leg is UNVERIFIED (CMU 22/23 are two-person interaction takes; no wrestling in our record):
   takedown entries start from our 16 RamsterZ paired clips + the solver; check CMU before anyone relies on it.
4. Gravity 11.5 m/s2 (Ludo's slam feel) is a named const, judged on video. Bone names map through our rig, never literals.
5. Every step is a game switch defaulting OFF (headless tests are the control arm); the overlay is dev-only (F3).
ORDER (each a Codex/cloud task with Ludo's thresholds as the acceptance test):
- GRAPPLE-MATH1 (cloud, now, pure): GrappleSocketTable + ProceduralTapGen + BallisticFallSolver + SubmissionStrain + 13 corrected contact
  specs as data + a spec validator - test written from Ludo's numbers. `TASK_GRAPPLE_MATH1.md`.
- GRAPPLE-POSE1 (Codex): solve the 13 basis poses from the specs with FightPoseSolver on two DIFFERENT bodies (1.70 vs 1.90 m); a
  game-camera still per hold -> the board for the operator.
- GRAPPLE-H1 shared root + ballistic slam + landing (PairedStagePlayer) -> H2 mat clamp + ground micro-motion -> H3 seat-switch slider
  -> H4 submission strain + procedural tap + release -> GBENCH1 the 60 s Morozov-vs-Silva benchmark + grapple_metrics.py.
- WHEN: the demo is boxing (D27). Codex does the boxing HUMAN steps first; GRAPPLE-MATH1 runs now on a free cloud seat (it costs the
  demo nothing); GRAPPLE-POSE1 starts on Codex after HUMAN1-3 unless the operator says now.
Ludo's PART 3 (next 5 flaws): rope contact, glove impact compression, canvas footprints/decals, finger curl in grips, gaze to the referee
-> ANIM-NEXT1..5, for Ludo's next big round, not built yet.

## Claude's verdict - BOXING, round 15 Part 1
Ludo's rewritten code now follows our three constraints (switches default OFF, one base-pose cache per frame so layers never accumulate,
a rig map instead of bone literals): it is the reference code for HUMAN1-6 / BENCH1. Its grader windows (whiff at 16.5-20 s) do not match
the round-12 timeline (whiff at 2.5-8.5 s): BENCH1 takes the windows from the timeline and the thresholds from round 12.
