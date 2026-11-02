# LUDO ROUND 12 (S192, 2026-10-10) - Codex checklist with thresholds, the 30 s benchmark scene, the debug overlay

Operator S192: "maybe ask all these ?" (Ludo's three follow-up offers after round 11 - see LUDO_ANIMATION_S192.md round 11).
Asked as TEXT (no images): 1) the 9-step overhaul as a prioritized Codex checklist with test thresholds, touch points and
non-regression guards; 2) a 30-second benchmark scene (two DIFFERENT boxers) as a forced timeline; 3) the debug overlay in text.

## Ludo's answer (verbatim; LaTeX markup simplified, box-drawing kept)

FightCamp Animation Overhaul: Codex Implementation Spec, Benchmark Script & Debug Overlay
1. Prioritized Codex Implementation Checklist & Automated Test Harness

Each step is self-contained, specifies touch points across our existing architecture, sets hard pass/fail thresholds in Tools/smooth_metrics.py, and defines strict non-regression guardrails.

Pipeline Flow & Touch Points:
[20 Hz Sim (FightSimTick)] --> [FightWorldLiveScreen (Root Spacing & Camera)] --> [FightStagePlayer (State Graph & Inertializer)] --> [FightAliveStance (IK, Additive Springs, Posture)] --> [record_room.gd (CSV)] --> [smooth_metrics.py]

Step 1: Additive Procedural Hit Reactions
Touch Points:
FightStagePlayer.gd: Cease full-clip replacement for light/medium hits (damage < 25). Fire apply_hit_impulse(hit_vector, damage, region) signal instead of cutting the active attack/recovery clip. Full interruption remains reserved for damage >= 25 and staggers.
FightAliveStance.gd: Implement an additive spring-damper layer affecting Spine2, Neck, and Head.
record_room.gd: Add columns lead_head_rot_delta_deg, rear_head_rot_delta_deg, hit_impulse_active_weight.
Exact Implementation Spec:
Snap phase: 45 ms cubic rise. Recovery phase: 180 ms critically damped relaxation (zeta = 0.85).
Angular deflection: theta_snap = damage x 0.42 deg (clamped to [4.0 deg, 24.0 deg]).
Linear displacement: 1.2 cm to 4.5 cm pushed backward along the impact normal vector.
Pass/Fail Threshold (smooth_metrics.py):
PASS: 100% of sim hit events logged with damage > 0 exhibit >= 4.0 deg angular deflection or >= 1.5 cm translation delta within 50 ms post-contact.
FAIL: Any hit logged where defender head bone delta remains < 2.0 deg across the 6 frames following impact.
Non-Regression Guardrail:
Ongoing offensive strike clips must maintain their playback velocity and normalized progress without resetting to frame 0.
Step 2: 4-Way Push-Pull Locomotion & Stance-Aware Directional Steps
Touch Points:
FightStagePlayer.gd: Deprecate the procedural sliding shuffle. Route all positional updates through a 2D Blend Space (BlendSpace2D inside AnimationTree) holding step_forward, step_backward, step_left, step_right, and pivot_45.
FightWorldLiveScreen.gd: Feed relative displacement vectors (dx, dz) normalized to the fighter's current facing vector directly into the locomotion blend space.
record_room.gd: Add columns lead_foot_planted_flag, rear_foot_planted_flag, inter_stance_width_cm.
Exact Implementation Spec:
Advance-step enforces push-pull sequence: moving forward lifts the lead foot first while the rear foot drives; moving backward lifts the rear foot first.
Step stride cycle = 48 cm. Stance width floor = 32 cm.
Pass/Fail Threshold (smooth_metrics.py):
PASS: Zero instances of double-airborne frames during locomotion (> 0.2 m/s ground speed). Inter-stance width never contracts below 30.0 cm.
FAIL: Any frame where both feet register upward velocity > 0.05 m/s (hopping) or foot separation falls below 28.0 cm (crossing feet).
Non-Regression Guardrail:
Absolute coordinate distance to opponent must track the simulation's positional intent within +-6.0 cm at all times.
Step 3: Proximity Flinch & Whiff Head Evasion
Touch Points:
FightAliveStance.gd: Add a proximity detection sphere/cylinder check between the opponent's glove bones (L_Hand, R_Hand) and the boxer's Head bone origin.
record_room.gd: Add columns glove_to_head_dist_cm, procedural_flinch_deflection_cm.
Exact Implementation Spec:
Detection envelope: Cylinder radius 28.0 cm, height 35.0 cm centered at Head.
Trigger gate: Opponent glove speed > 2.5 m/s, defender state not currently in HIT_REACT.
Response vector: D = normalize(P_head - P_glove).
Evasion curve: Head retreat dP = D x 6.5 cm max; chin tuck pitch down +8.0 deg. Rise: 60 ms; recovery: 160 ms.
Pass/Fail Threshold (smooth_metrics.py):
PASS: >= 85% of whiffs passing within 25.0 cm of the head bone trigger >= 3.0 cm of head retreat and chin tuck.
FAIL: Static head (< 1.0 cm delta) during an opponent punch extension where minimum glove distance reached < 22.0 cm.
Non-Regression Guardrail:
Flinch displacement must zero out immediately if the incoming punch registers an actual hit, allowing Step 1's impact impulse to take full priority without additive compounding.
Step 4: Kinetic Chain Stance Mechanics (Ankle Pivot & Pelvic Precedence)
Touch Points:
FightStagePlayer.gd & FightAliveStance.gd: Inject procedural rotational offsets into Rear_Ankle, Hips, and Spine1 during power strike playback (CROSS, REAR_HOOK, LEAD_HOOK, UPPERCUT).
record_room.gd: Add columns pelvis_yaw_deg, rear_heel_lift_cm, punch_hand_speed_m_s.
Exact Implementation Spec:
Cross & Rear Hook: Rear ankle inward yaw +55.0 deg +- 5.0 deg; rear heel upward translation +4.5 cm.
Pelvic rotation precedes glove maximum extension: Pelvis yaw accelerates 30 ms to 60 ms prior to punch apex.
Pelvic rotation amplitudes: Jab 22.0 deg, Cross 48.0 deg, Hooks 58.0 deg.
Pass/Fail Threshold (smooth_metrics.py):
PASS: 100% of landed or extended power punches log peak pelvic angular velocity occurring between 25 ms and 65 ms before peak glove velocity.
FAIL: Peak pelvic rotation occurs simultaneously with or after glove apex (t_pelvis - t_glove >= 0 ms), indicating a disconnected arm punch.
Non-Regression Guardrail:
The planted lead foot rotation must remain locked to the canvas (d theta lead_foot < 3.0 deg) during rear-hand kinetic chain pivots.
Step 5: Look-At IK Head & Eye Tracking
Touch Points:
FightAliveStance.gd: Add analytical two-bone look-at solver on Neck and Head nodes targeting the opponent's upper chest (Spine2) by default, tracking the active glove during inbound strikes.
record_room.gd: Add columns gaze_to_target_angle_deg.
Exact Implementation Spec:
Bone distribution: 30% rotational compensation applied to Neck, 70% applied to Head.
Angular clamps: Yaw +-42.0 deg, Pitch +-22.0 deg. Smoothing: Critically damped spring (zeta = 1.0, omega_n = 14.0 rad/s).
Pass/Fail Threshold (smooth_metrics.py):
PASS: Gaze alignment vector holds within 12.0 deg of opponent chest center across all non-rocked, non-knockdown frames.
FAIL: Head forward vector drifts > 20.0 deg away from the opponent while in neutral or offensive states.
Non-Regression Guardrail:
Additive hit reaction snaps from Step 1 must override Look-At IK rotation instantly (0 ms delay), blending back in smoothly over 180 ms.
Step 6: Punch S-Curve Velocity Snapping
Touch Points:
FightStagePlayer.gd: Implement non-linear timeline sampling curves (Curve resource) for all offensive striking animations.
record_room.gd: Add columns strike_phase_normalized, fist_acceleration_m_s2.
Exact Implementation Spec:
Extension phase (0.0 -> 0.45 time): Cubic acceleration curve (exponent 2.8).
Apex impact hold: Exactly 1 frame (16.6 ms) at terminal reach.
Recovery phase (0.45 -> 1.0 time): Hermite spring recoil lasting 0.22 s directly to guard pose.
Pass/Fail Threshold (smooth_metrics.py):
PASS: Measured punch extension-to-retraction duration ratio falls within [1:1.6, 1:2.0].
FAIL: Punch velocity curve displays a flat linear slope (dv/dt ~ const) or extension time exceeds retraction time.
Non-Regression Guardrail:
Animation duration must match the logical frame ticks defined in the 20 Hz simulation so strike cancel windows remain synchronized.
Step 7: Center of Mass (CoM) Balancing & Dynamic Weight Transfer
Touch Points:
FightAliveStance.gd: Calculate analytical center of mass projection P_CoM from skeletal mass weights; apply lateral/longitudinal compensation to the root pelvis.
record_room.gd: Add columns com_proj_x, com_proj_z, bos_min_margin_cm.
Exact Implementation Spec:
Base of Support (BoS): Convex 2D polygon defined by the contact points of both shoes on the canvas.
Slips: CoM shifts 14.0 cm toward the slipping side; lead knee compresses by 12%.
Crosses: CoM advances 18.0 cm forward, resting directly over the lead ankle at punch apex.
Pass/Fail Threshold (smooth_metrics.py):
PASS: CoM ground projection remains strictly inside the convex hull of the BoS (with a minimum safety margin of +3.0 cm) during all un-rocked actions.
FAIL: CoM excursions beyond the BoS perimeter by > 4.0 cm without triggering a stumble or fall state.
Non-Regression Guardrail:
Weight shifts must not induce root floating or cause foot anchors to slide out of their IK constraints.
Step 8: Dynamic Fatigue Posture & Composure Degradation
Touch Points:
FightAliveStance.gd: Drive additive blend shapes and postural drop using live telemetry: Fighter.stamina (0-100) and Fighter.composure (0-100).
record_room.gd: Add columns guard_vertical_drop_cm, thoracic_flexion_deg.
Exact Implementation Spec:
Wrist height drop: -12.0 cm vertical drop as stamina falls below 30%.
Spine hunch: +14.0 deg thoracic flexion (Spine1 pitch forward).
Breathing amplitude scaling: Clavicle vertical displacement increases to 3.2 cm at elevated heart rates (> 160 BPM).
Step cadence multiplier: Locomotion animation playback scales to 0.78x speed.
Pass/Fail Threshold (smooth_metrics.py):
PASS: When stamina drops from 100% to < 25%, the resting wrist position measures an average downward drop between 8.0 cm and 14.0 cm.
FAIL: Boxer at < 20% stamina maintains the identical upright thoracic angle (< 3.0 deg variance) as a fresh fighter.
Non-Regression Guardrail:
Dropped guard posture must not compromise the hit reaction or flinch systems; bone transforms remain cleanly additive.
Step 9: Glove Secondary Dynamics & Wrist Inertia
Touch Points:
FightAliveStance.gd: Add damped spring-mass logic driving local rotational and translational offsets for glove attachment sockets.
record_room.gd: Add columns glove_spring_offset_cm.
Exact Implementation Spec:
Spring stiffness omega_n = 28.0 rad/s, damping ratio zeta = 0.72.
Translational offset hard-clamped to +-1.8 cm local deviation from the wrist bone.
Pass/Fail Threshold (smooth_metrics.py):
PASS: Gloves exhibit a clear 1.0 cm to 1.8 cm damped rebound settling over 3 to 4 frames upon sudden stoppage of high-velocity movement.
FAIL: Gloves freeze rigidly with 0 sub-frame overshoot upon punch return or abrupt stance stops.
Non-Regression Guardrail:
Secondary spring displacement must clamp to zero during active punch contact frames to prevent glove clipping through the opponent's guard or face.
2. The 30-Second Animation Benchmark Scene

A deterministic, repeatable test segment pairing two mechanically distinct fighters.

Fighter A (Red Corner): Leo Vance (Super Welter, Orthodox, In-Fighter, high chin, compact guard, fresh stamina 95%).
Fighter B (Blue Corner): Ray "Meat-Axe" Miller (Slugger, Orthodox, wide looping punches, fatigued stamina 28%, Composure 35 / Shaken).
Timeline (Seconds 00.00 -> 30.00):
00.0s - 04.5s - 08.5s - 12.5s - 16.5s - 20.5s - 24.5s - 30.0s
 [Stance/Gaze] [Jab/Flinch] [Whiff/Slip] [Landed Cross] [Lateral Steps] [Clinch/Break] [Heavy Combo] [Exhaustion]

Deterministic Timeline Script
00.00s - 02.50s | Neutral Stance, Breathing & Eye Tracking:
Both fighters hold guard at 1.8 m distance.
Vance exhibits steady rhythmic pulse sway (85 BPM); Miller displays heavy breathing (165 BPM) with a visibly dropped guard (-10.0 cm) and hunched posture (+12.0 deg).
Verifies: Step 5 (Look-At IK), Step 8 (Fatigue Posture).
02.50s - 04.50s | Advance, Probe Jab & Proximity Flinch:
Vance executes an advance step forward (48 cm stride). Fires a probing lead jab.
The jab misses outside Miller's left ear by 8.0 cm.
Miller's head procedurally flinches away: pulls back 4.5 cm, chin tucks 8.0 deg.
Verifies: Step 2 (Locomotion Push-Pull), Step 3 (Proximity Flinch), Step 6 (S-Curve Snap).
04.50s - 08.50s | Counter Miss, Slip & Kinetic Chain Torque:
Miller throws a heavy, looping right hook (rear heel pivots +55.0 deg, pelvis rotates 52.0 deg).
Vance slips under the hook to the outside: CoM shifts 14.0 cm laterally to the lead leg, lead knee bends 12%.
Miller's hook whiffs completely; Vance tracks Miller's chest continuously throughout the roll.
Verifies: Step 3 (Whiff), Step 4 (Kinetic Chain), Step 7 (CoM Balance).
08.50s - 12.50s | Landed Straight Right & Additive Hit Reaction:
Vance rises out of the slip and throws a right cross to the chin.
Punch lands flush (damage: 18, light/medium threshold).
Miller does not play a canceling full-body clip; an additive hit impulse snaps his head backward by 16.0 deg and drives his upper torso back 3.2 cm. He remains upright with his guard partially intact.
Verifies: Step 1 (Additive Hit Reaction), Step 6 (Impact Snap).
12.50s - 16.50s | Lateral Footwork, Circling & Pivot:
Vance initiates lateral movement, circling clockwise (two 45.0 cm lateral steps).
Miller pivots on his lead foot (45.0 deg pivot), keeping his guard squared. Stance width remains above 32.0 cm for both boxers; zero foot-dragging or hopping.
Verifies: Step 2 (Directional Footwork / Push-Pull).
16.50s - 20.50s | Forward Rush, Clinch Entry & Clinch Break:
Miller charges forward into infighting range (< 55.0 cm).
Body separation springs engage: mutual penetration is blocked; both boxers enter CLINCH_HOLD with arms wrapped over the shoulders.
Referee calls break at 19.00 s: Fighters push off cleanly (CLINCH_BREAK) and step back 60.0 cm with zero animation popping.
Verifies: Mesh Separation, Clip Transition Graph.
20.50s - 24.50s | Heavy Strike, Interruption & Stagger:
Vance delivers a clean 1-2 combination: Jab (distraction) followed by a power Left Hook to the jaw (damage: 34, heavy threshold).
Heavy threshold triggers full clip interrupt: Miller breaks into HIT_REACT_HEAD_HEAVY transitioning into STAGGER.
Miller takes two unsteady backward steps, heels striking the floor; CoM momentarily shifts to the rear edge of the base-of-support polygon.
Verifies: Step 1 (Interrupt Thresholds), Step 7 (CoM Recovery).
24.50s - 30.00s | Deep Fatigue, Retreat & Glove Inertia Settle:
Vance holds ground, maintaining an active high guard.
Miller retreats back against the ropes: shoulders heavily rounded (+14.0 deg), mouth open, guard sagging by -12.0 cm.
Miller stops abruptly: both gloves display an elastic 1.4 cm overshoot bounce before coming to rest.
Camera smoothly eases to a rest framing both fighters with zero jerk.
Verifies: Step 8 (Fatigue State), Step 9 (Glove Inertia), Broadcast Camera Damping.
3. Real-Time Debug Overlay Specification

A dedicated developer HUD implemented directly inside FightWorldLiveScreen.gd.

Activation Toggle Key: F3 (Cycles: OFF -> MINIMAL -> DETAILED).
(Ludo's ASCII mock-up, summarised exactly: TOP-LEFT red-corner panel and TOP-RIGHT blue-corner panel, each "State: JAB -> CROSS
(Blend: Inertial)", "Blend Progress: [bar] 0.72", "Punch Phase: RETRACT (S-Curve 0.68)", "Hit React Weight: 0.74 (16.2 deg)",
"CoM Offset: (+2.1cm, +14.2cm) [STABLE|WARN]", "Lead Foot: [LOCKED] | Rear Foot: [FREE]"; the 3D viewport in the middle with the neck
gaze vector (cyan ray), head flinch cylinder (yellow mesh), CoM (magenta sphere), base of support (green convex hull); BOTTOM-CENTRE
"Metrics Engine: Inter-Root Distance: 78.4 cm | Cam Accel Delta: 0.008 m/s^2 [PASS]".)

Viewport 3D Geometric Overlays (Immediate Canvas Renderers)
Center of Mass (CoM) & Base of Support (BoS):
BoS Polygon: Ground-plane convex hull connecting both shoe soles. Rendered with a solid 2.0 mm line: Bright Green (#00FF44) when CoM is fully contained inside; Flashing Red (#FF2200) if CoM approaches within 2.0 cm of the edge.
CoM Projection: A Magenta Sphere (#FF00FF, radius: 3.5 cm) floating at the calculated physical center of mass, projecting a vertical dashed plumb line down to a dot on the ring canvas.
Foot Lock & IK Contact Anchors:
Planted State: A Solid Cyan Disc (#00E5FF, radius: 6.0 cm) rendered flat on the canvas under the locked ankle.
Liftoff/Free State: An Hollow Orange Ring (#FF9100, radius: 6.0 cm) indicating the foot is free to step or pivot.
Proximity Flinch Cylinder:
A translucent wireframe cylinder around each fighter's head (Light Yellow (#FFEE58, alpha: 0.35), radius: 28.0 cm, height: 35.0 cm). Turns Bright Red (#FF1744) when an opponent glove penetrates the volume.
Target Tracking Gaze Rays:
A continuous ray cast originating between the eyes: Teal Ray (#1DE9B6, length: 1.2 m) pointing directly toward the tracked target anchor point (opponent chest or incoming glove).
On-Screen 2D Text Panels (Fixed Canvas Layer)
Top-Left (Red Fighter Telemetry) & Top-Right (Blue Fighter Telemetry):
Current animation state, target state, blend mode (Inertial, Pose-Match, Cut, Additive).
Horizontal progress bar showing transition blend fraction and punch execution phase (WINDUP, EXTEND, APEX_HOLD, RETRACT).
Live Additive Hit Reaction Weight (0.00 to 1.00) and angular head displacement in degrees.
Foot lock status flags (LEAD: LOCKED, REAR: UNLOCKED).
Bottom-Center (Physics Engine Diagnostics):
Fighter-to-fighter root spacing in centimeters (turns red if < 58.0 cm).
Live camera acceleration jerk metric (sigma dv_cam).
Frame CSV logger status: indicator showing whether record_room.gd is actively recording to file (REC in red).
(Ludo's next offers: Godot 4 pseudocode + file-by-file Codex task list; the CSV schema + Python metrics grading the benchmark; a visual
overlay mock-up.)

## Claude's verdict (round 12) - taken
- The checklist's thresholds are the acceptance gates for HUMAN1-7 (LUDO_ANIMATION_S192.md round 11 plan). Two corrections from our
  record: (a) the debug overlay goes in its OWN script (FightDebugOverlay.gd) mounted by one line from FightWorldLiveScreen - the screen is
  6,400 lines and Codex is editing it; (b) the overlay's top panels sit BELOW the Ludo HUD cards (the cards own the top corners).
  The overlay must never be ON in the game (dev key only, and record_room flag `debug_overlay=1` for review videos).
- AnimationTree/BlendSpace2D for step 2: we do not convert the player wholesale (TASK_ANIM_SMOOTH1 prefab note) - the four step loops
  are blended inside FightStagePlayer's existing play path; Codex decides at HUMAN2 with the transcript as evidence.
- BENCHMARK (BENCH1): Leo Vance vs Ray "Meat-Axe" Miller are the cast of record (LudoCast) and differ - legal. The timeline needs a
  forced-action hook in the sim (a scripted action queue fed to the engine); built once, it makes every HUMAN step measured on the same
  30 s. Brief for Codex after SMOOTH2 (shares smooth_metrics + record_room).
- Ludo's next offer "CSV schema + Python metrics grading the benchmark" - ask in round 13 when BENCH1 starts.
