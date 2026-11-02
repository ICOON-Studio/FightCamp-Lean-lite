# K44 — FOOT-LOCK IK IN GODOT 4.7: HOW SHIPPED GAMES KEEP A PLANTED FOOT STILL, AND WHAT GODOT GIVES US

**Desk:** Kalli (Grok Bot), research. **Delivered:** 2026-09-14 02:19. **Captured by Claude from the chat transcript** (`grokbots.py read --to Kalli --out`), not reworded; tab-separated tables kept as delivered.

## DECISIONS
Build on TwoBoneIK3D (Godot 4.6+, in 4.7.2) — one setting per leg: root=*UpperLeg, middle=*LowerLeg, end=*Foot/*Toes, target_node = locked Marker3D, pole_node = knee pole. Drive SkeletonModifier3D.influence as plant weight. Only write your own two-bone solve if you need Orange Duck’s soft max-extension without a pole.
Contact start: enter plant when toe speed < 0.15 m/s AND height above floor < 0.08 m; exit when either exceeds 1.5× (hysteresis). Sources: Orange Duck (0.1–0.5 m/s, ~0.1 m) + Kovar-style practice (8 cm/s / 4 cm).
Blend in/out: 0.10–0.15 s inertialization / smooth plant weight (~6–9 frames @ 60). Source: Orange Duck cubic inertialize; Vulkan/StraySpark ~0.1–0.2 s / 8–15 frames.
Contacts: precompute per clip (offline annotate → curve/markers) for fight mocap; runtime detect only as fallback for between-clip room drift.
Pivot: lock the toe / ball, not the heel — heel free to lift/rotate (boxer’s rear foot on a cross).
Test first: hyper-extension / knee pop when the shorter Tripo leg can’t reach the locked world point — soft-clamp reach; prefer a few cm slide over yanking the pelvis down (“dinosaur”).
1. Godot IK nodes (4.6–4.7)
Node	Arrived	Role	Target / pole / blend	After AnimationPlayer?	Label	Source
SkeletonModifier3D (base)	4.4	Runs modifications after AnimationMixer; child order = apply order	influence (0–1 blend vs animated pose)	Yes — always after AnimationMixer	DOCUMENTED	Design article; class
LookAtModifier3D	4.4	One-bone aim (ankle/toe orient)	Aim target node; influence	Same	DOCUMENTED	IK returns 4.6 article (16 Dec 2025)
IKModifier3D	4.6	Base for multi-bone IK	setting_count, mutable_bone_axes	Same	DOCUMENTED	IKModifier3D; article
TwoBoneIK3D	4.6	Analytic two-circle leg/arm IK	target_node, pole_node, pole_direction / vector; root / middle / end bone names; influence via parent	Same	DOCUMENTED	TwoBoneIK3D 4.7
ChainIK3D	4.6	Base for longer chains	—	Same	DOCUMENTED	Article tree
SplineIK3D	4.6	Spine-like deterministic chain	—	Same	DOCUMENTED	Article
IterateIK3D	4.6	Iterative base (deterministic option)	—	Same	DOCUMENTED	Article
FABRIK3D	4.6	Position FABRIK	Target via chain settings	Same	DOCUMENTED	FABRIK3D
CCDIK3D	4.6	Cyclic coordinate descent (better with limits)	—	Same	DOCUMENTED	CCDIK3D
JacobianIK3D	4.6	Jacobian iterate	—	Same	DOCUMENTED	Article
SkeletonIK3D	Pre-4 / kept	Old FABRIK + bones_global_pose_override	target_node, magnet pole, influence (was interpolation)	Modifier path, but Deprecated	DOCUMENTED	SkeletonIK3D 4.7: “Deprecated: This class may be changed or removed”

Foot-lock stack: AnimationPlayer (MANUAL advance) → Skeleton3D update → TwoBoneIK3D (plant) → optional LookAtModifier3D on foot/toes for sole alignment.

2. Contact detection
Finding	Numbers	Precompute vs runtime	Label	Source
Kovar, Schreiner & Gleicher 2002	Assumes footplant intervals are given; does not publish height/speed thresholds — focuses on IK cleanup once plants exist	Constraints / markers	DOCUMENTED	Paper page; PDF
Height- or speed-only heuristics	Unreliable on noisy mocap (skids, markers on top of shoe)	Often runtime	DOCUMENTED	Ikemoto et al. “Knowing when to put your foot down” (summarised DOI); Arikan PDF
Orange Duck (2026) practical heuristic	Toe velocity ~0.1–0.5 m/s; height ~0.1 m; prefer velocity; majority-vote ~5 frames @ 60 Hz; keep 60 Hz data	Annotate offline → meta; runtime threshold OK	SECONDARY (expert recipe, dated 30 Jul 2026)	theorangeduck.com
Kovar-style implementer defaults	Enter: ankle < 8 cm/s AND < 4 cm height; exit 1.5×; min plant frames; short blend	Offline pass	SECONDARY	s&box FootPlant.cs
UE5 Foot Placement	Plant when joint speed < SpeedThreshold (Graph root-motion or Manual speed curve); UnalignmentSpeedThreshold for roll-out alpha	Runtime from curves / graph	DOCUMENTED	FootPlacementPlantSettings; FAnimNode_FootPlacement
3. Locking method
Step	Practice	Label	Source
Lock target	World position of toe at plant enter (snap Y to floor); hold while locked	SECONDARY	Orange Duck
Release	Contact false or current vs input distance > unlockDistance (overstretch escape)	SECONDARY	Orange Duck
Blend	Cubic inertialization between “follow anim” and “follow contact”; typical blendTime ~0.1 s class	SECONDARY	Orange Duck; Vulkan tutorial plant weight ~0.1–0.2 s (Khronos foot placement)
Overstretch	Soft-clamp target to maxExtension − softening (e.g. soften 0.005 m); prefer slide over big pelvis drop	SECONDARY	Orange Duck (“Avoid the dinosaur”); KSG02 knee-damping + limited bone-length adjust when near straight
Hips	Lower pelvis by max needed downward foot offset (never push up); apply before IK	SECONDARY	Vulkan / StraySpark pelvis stage
Godot mapping	Move Marker3D to contact; set TwoBoneIK influence = plant weight; optional CopyTransform / LookAt on ankle	DOCUMENTED (nodes)	TwoBoneIK3D + SkeletonModifier3D
4. Unreal 5 equivalents (one line each)
Feature	One line	Label	Source
IK Retargeter IK goals	Preserve foot/ball world goals across proportion mismatch when retargeting (not a runtime plant lock).	DOCUMENTED / SECONDARY	Epic IK Rig retargeting; StraySpark guide
Foot Placement node	Runtime plant: lock feet when speed < threshold, trace/adjust to ground, pelvis settings, plant weight from Graph or Manual speed curves.	DOCUMENTED	FAnimNode_FootPlacement / PlantSettings APIs above
Leg IK	Solves FK legs toward IK targets (often after Foot Placement has written those targets).	SECONDARY	Community ABP order (Foot Placement → Leg IK)
5. Pitfalls
Pitfall	Note	Cost	Label	Source
Knee pop / flip	Near-full extension + sudden target change; use soft extension limit + stable pole / knee side vector	TwoBoneIK = closed-form, cheap; 2 legs ≪ skin	SECONDARY + DOCUMENTED (TwoBoneIK needs pole)	Orange Duck; TwoBoneIK3D docs
Release pop	Hard unlock snaps foot; need inertialize / unlockDistance	Same	SECONDARY	Orange Duck
Heel lock vs toe pivot	Locking heel fights athletic / boxing ball pivot; lock toe	Same	SECONDARY	Orange Duck (“The toe is what needs locking”)
Dinosaur pelvis	Over-dropping hips to reach plant looks worse than slight skate	Same	SECONDARY	Orange Duck
IK during swing	Must gate with plant weight or swing foot gets yanked to floor	Same	SECONDARY	Vulkan foot placement
Between-clip drift	Room moves bodies cm between clips → re-detect or re-seed contact on clip change	Same	— (your case)	Operator brief
GAPS
Exact default blendTime numeric in Orange Duck sample UI: NOT FOUND in prose (API takes blendTime; start 0.1–0.15 s).
KSG02 does not give detection thresholds — only cleanup given plants.
