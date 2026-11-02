# ZIVA clip review - S258 fight-motion clip (S262, saved verbatim by Claude)
Seat: Ziva (Godot editor agent, wt/ZIVA, model Ziva Smart), chat at http://127.0.0.1:7012/. Ziva decoded the mp4 with OpenCV (cv2) and read sampled frames + the sheets; no video playback. Chars: 10443

I did the review the way you asked (read-only — nothing of yours was edited; I only generated and then deleted my own temporary frames). Here is the complete answer.

(a) Did I watch the mp4, or only the frames?

Both, but neither as "video." Honest statement of what my eyes actually are:

I have no video player. I cannot press play on s258_fightmotion_ab.mp4 and watch it move.
I can and did decode the mp4 with OpenCV (cv2 is installed here): it is 1920×540, 30 fps, 600 frames, 20.0 s, side-by-side — left 960 px labelled BEFORE (master) (old root motion), right 960 px labelled AFTER (one root solver). I sampled real frames out of it at t = 1.0, 3.0, 4.90, 5.05, 5.20, 5.35, 5.50, 5.65, 5.60, 8.0, 9.0, 9.3, 9.6, 11.0, 13.5, 13.8, 14.0 s and read them.
I also looked at the sheets with my image tool: before_after_stack.jpg (top = BEFORE, bottom = AFTER), ab_every05s_1.jpg / ab_every05s_2.jpg (the AFTER half, every 0.5 s, t = 0–19.5 s), and before_every2s.jpg / after_every2s.jpg.

So: I saw your clip — as decoded frames, at whatever interval I chose. That is a flipbook, not motion. It is enough to judge poses, contact, spacing and silhouette; it is not enough to judge timing/feel, and it cannot measure world-space foot slip (that needs the foot probe below). Both halves carry the same beat captions and the same round clock (R2 2:55 → 2:46, “SLIP-CROSS COUNTER -2.4 HEAD” firing at the same instant in both), so they are the same fight, seed 95501 — a fair A/B.

(b) Frame-by-frame: what makes the motion not look human
Feet / stance — the worst offender
t = 1.0 s (BEFORE): the red lead boxer stands in an exaggerated lunge — front foot planted far forward, rear leg almost straight, heel lifted, both feet flat and splayed outward (duck-footed). AFTER narrows the stance and stands him more upright, but keeps the flat splay and the raised heel.
t ≈ 7.9–8.0 s (AFTER): red pitches forward onto the lead leg with the trailing rear leg stretched out behind and off the floor — a foot with no ground contact at all. Reads as falling, not footwork.
t ≈ 13.5–14.0 s: the same forward lunge / rear-leg-straight-back-and-high silhouette returns (both halves).
Dense sample, t = 4.90 → 5.05 → 5.20 → 5.35 → 5.50 → 5.65 s: the foot-contact regions translate smoothly with the body — there is no lift-then-plant. The cast shadow (the best ground-contact readout in this light) sweeps continuously across the floor and never stops. That is the skating signature.
Feet are almost never up on the balls; there is no pivot.
Hips / root
The pelvis moves in lockstep with the chest — no pelvis-vs-shoulder counter-rotation in any sampled frame. At t = 5.20 s and 5.50 s (the cross) the whole torso+hips hinges forward as one block (“poured forward, hinged at the hip”).
Root height is essentially constant across stance changes: at t = 1.0 the stance is far wider than at t = 5.5 yet the hip height is identical → the legs are being posed under a floating root, with no crouch/weight-drop.
Spacing between the two men
The gap snaps open and shut: heads overlapping at t ≈ 5.2 s and 8.0 s, a full body apart at t ≈ 11.0 and 14.0 s, inside ~0.3–0.5 s — and neither man steps to close; one root just translates.
Interpenetration: at t ≈ 8.0 s (AFTER) blue’s glove/forearm passes inside red’s head silhouette; at t ≈ 5.2 s the two heads occupy the same screen space. There is no “measuring” distance.
Guard (arms, elbows, gloves)
t = 4.90–5.20 s: red’s lead arm is fully extended low-and-left, nearly straight at the elbow, glove pointing down-left at nothing, and it stays there ~0.3 s while he “slips.” The lead never returns to the face. This is present in BOTH halves — the one-root-solver change did not touch the guard.
Elbows flare out from the ribs whenever the arm is out (t = 1.0 BEFORE; t = 4.90 both).
Gloves drift low — the lead glove sits at sternum/waist height at t ≈ 8.0 s and 14.0 s (the “floating glove”).
Gloves don’t present knuckles (palms read down/flat), and when both are up (t = 5.6 s) they overlap the face and each other rather than framing the chin.
Punches
No wind-up: at 4.90 → 5.05 the lead hand is already extended before the cross; the cross at 5.20 s arrives with the shoulder already forward — no hip/shoulder wind-up and no weight transfer onto the lead foot.
Extension: stiff, straight arm, no shoulder rotating over the top → it reads as a pole extending, not a punch.
Recovery: 5.35 → 5.65 returns the hand to the same low hang, not to the chin.
Same form repeats at t ≈ 13.5–14.0 s.
Head movement
The head is welded to the trunk: torso pitch carries the head (t = 1.0 BEFORE; t = 5.20) — no cervical counter-rotation. The “slip” at 5.2 is a whole-body lean, not a head slip. The chin never tucks behind the shoulder.
Weight shift
Lean without centre-of-mass transfer: the body pitches but the CoM doesn’t move over the lead foot, so punches have no push. At t ≈ 8.0 s (AFTER) the weight goes nowhere — pitched forward with the rear leg airborne.
Be fair to the AFTER half

It did improve: the stance is narrower and more upright, the extreme splayed lunge of BEFORE is reduced, and spacing is slightly more consistent. But every fundamental tell — skate, no step, dead lead arm, hinged hip, welded head, straight-arm punch, no recovery-to-guard — is the same in both halves. The change is root-motion/authoring unification, not motion quality. That matches the code: FightStagePlayer.gd still poses the arm by translating the Hand bone (_anim_translate_world, line 130, applied to the hands at 283–296 for fatigue/lift/glove-spring) and swivelling the elbow (_tuck_elbow, 170) — a well-positioned wrist can coexist with a stretched forearm.

Caveat I won’t paper over: these are discrete samples (0.1–0.5 s apart, 0.15 s in the punch window). I can call poses and contact confidently; I cannot call timing/feel, and I could not measure world-space slip. That needs the foot probe in item 2.

(c) What I can actually build here — ranked, with files/nodes and proof

Capability, honestly:

Author/edit clips on the MetaHuman skeleton: yes — I can create/edit Animation resources and write position_3d/rotation_3d tracks on bone paths. But hand-keyframing believable multi-second boxing motion is exactly what produced the tells above; I will do single-frame authored poses well and I will not claim I can hand-author athletic motion.
Build IK: yes, and the parts already exist here — res://addons/kickback/two_bone_ik.gd (class_name TwoBoneIK), arm_ik_solver.gd, foot_ik_solver.gd, res://scripts/FightLegIK.gd, plus the SkeletonModifier3D subclasses FighterFist.gd, FighterWrist.gd, MetaHumanTwist.gd, FightActiveRagdoll.gd (OutputPose), FightHitPhysics.gd (ArmFence), GymHall3D.gd (PostureLean).
Write the GDScript pass: yes.
Run the fight scene and capture frames: yes — run_scene screenshots the live game and I can drive inputs; and there are headless probes to reuse (tools/move_shape_probe.gd, guard_lift_still.gd, c223_production_gate.gd, probe_foot_lock.gd).
Limits: I can’t perceive motion as video; skin/deformation corrective-bone calibration is slow visual work; and FightLegIK.gd notes a SkeletonModifier3D doesn’t run in an _initialize-stepped test, so gates must read get_bone_pose after a GDScript pass or use the existing harness.

One fact worth flagging: res://scripts/rules/GuardPose.gd exists in this worktree but is referenced nowhere — FightStagePlayer.gd does not use it. The plan is written down but not wired in.

Rank	What I'd build	Files / nodes it touches	How I'd prove it on a game-camera frame
1	Guard replacement + arm IK (your plan). Author 5 base poses (traditional, high, peekaboo, long, philly); accumulate fatigue/lift/spring into effector targets, solve the arm once (never translate the hand after); per-arm guard weights that fade only the punching arm.	scripts/rules/GuardPose.gd (STYLES, elbow_for); scripts/FightStagePlayer.gd (_anim_pose_pass 203, guard_lift_weight 199, _guard_hand_clearance_pass 4100, _inside_uppercut_pose_pass 4130, drop the hand-translate at 283–296); a new SkeletonModifier3D modelled on FighterWrist.gd.	run_scene the fight scene; screenshot at the guard and at the cross; read glove→face gap and elbow→rib gap off the frame; execute_script to assert the wrist sits on its target and upper/forearm lengths are unchanged (<0.5%).
2	Foot-plant layer (kill the skate) — highest readability. Pin each ankle while planted; lift only during a step; solve the knee on its existing bend side.	scripts/FightLegIK.gd (solve); FightStagePlayer.gd (set_human_footwork 2157, walk_at 2199, _advance_shuffle 4139, _advance_human_shuffle 4206, _feet_under_body 4268, _carry_shuffle_plants 4283, _settle_shuffle_plants 4317, step_front_foot 3725).	run_scene sampled at 1/30 s across a step; assert the planted foot’s image-x is constant between plants and a real lift/plant event exists; reuse tools/probe_foot_lock.gd.
3	Punch mechanics: wind-up, shoulder-over, weight onto lead foot, recover-to-guard.	FightStagePlayer.gd (onset/retime 1315/1126, whole_phases 952); the strike clips; a spine/hip-yaw SkeletonModifier3D (model GymHall3D.gd PostureLean).	Capture contact frames; assert shoulder-yaw delta and hand returns within ~2 cm of the guard target during recovery; assert no pop at the join (_guard_join_weight 2077).
4	Head independence + chin tuck — small, high readability. Guard target uses the head-translated position but a torso-facing basis.	A SkeletonModifier3D on Neck/Head (model MetaHumanTwist.gd).	A frame where the torso pitches but the chin stays level and tucked.
5	Two-man spacing / step-to-range (harder — match AI).	FightStagePlayer.apply_spacing_flare 318 + the fight director (scenes/FightWorldLive.tscn).	Capture a close/open transition; show the gap changes via foot-lift events, not root glide.
6	Skin/deformation corrective-bone drive (MetaHuman helper bones).	MetaHumanTwist.gd-style modifier on the helper bones.	Close-up render at 90–140° elbow flexion; needs eyeball calibration — cheapest to defer.

Bottom line: your clip has been seen (decoded, frame-sampled). The right first move is #1 on the not-yet-wired GuardPose.gd, and #2 is the single biggest thing that makes it look human, because the skate + no-step is what sells "not human" at the game camera. I can build and prove #1–#4 in this project right now; #5–#6 are progressively more AI- and eyeball-bound. Nothing above is done yet — this was review only.

