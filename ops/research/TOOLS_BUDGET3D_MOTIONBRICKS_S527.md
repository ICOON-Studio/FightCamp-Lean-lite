# Budget3D and MotionBricks - do they help FightCamp? (S527, owner asked; pages + repos + arXiv read by a web reader)

## Budget3D (budgetany.github.io/budget3d, github BudgetAny/Budget3D)
One image in -> 3D Gaussian splats (.ply) out. Code MIT, weights Apache-2.0 (Hugging Face), "unofficial" implementation.
Needs a CUDA (NVIDIA) GPU, ~7-10 GB; Windows not stated. No mesh, no rig, no animation.
VERDICT: not useful. Splats are not a Godot mesh; we already have Tripo + Ludo for props (S334).

## MotionBricks (nvlabs.github.io/motionbricks, arXiv 2604.24833, SIGGRAPH 2026)
Last 4 poses + 1-4 target poses (+ speed / style) -> 30 Hz motion between them, very fast (claimed 2 ms). Code Apache 2.0;
models under the NVIDIA Open Model Agreement (commercial use allowed on its terms); sample motions evaluation-only.
Runtime = TensorRT = NVIDIA GPU only (our PC has an AMD GPU). Fixed skeletons (SOMA, Unitree G1): MetaHuman needs our own
retarget. No FBX/GLB/BVH export stated. One character only: no opponent, no hit reaction, no contact.
VERDICT: not now, maybe later. The idea (motion generated toward a planner's target pose) matches FIGHTPLAYER2's planner,
but it cannot run on this PC and does nothing for two boxers in contact - the part our critics mark down. Revisit only if a
build machine with an NVIDIA GPU appears AND a two-person / reaction model is released. Bought clip licences forbid AI over
their data (reference_asset_ai_clauses_s495): MotionBricks' own training data is NVIDIA's (BONES sets), not ours.
