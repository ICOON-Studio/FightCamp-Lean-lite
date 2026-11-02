# S126 - Unreal 5.8 AnimGen, evaluated for FightCamp (Claude, 2026-09-29)

Operator asked: "evaluate this: https://www.youtube.com/watch?v=vksuxAECgI8" (Smart Poly, "Unreal Engine's NEW AI Animation
System Is Crazy (UE5)", 10:07, 2026-08-14). Judged on the PRIMARY source, not the video: the plugin is installed on this PC
(`C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/Experimental/Animation/AnimGen`, v0.1, Experimental, off by default) and
Epic's sample listing (fab.com/listings/df37eb46-09bf-4604-9307-cdc39c769790).

## What it is (read from the source)
- `Content/Python/train_controller.py`: a **flow-matching denoiser** (MLP, 12 layers x 2048 units) that predicts the next
  pose from the previous pose + a control vector, then **distilled** into three LOD networks for runtime; trained in PyTorch
  (CUDA if present), run in-engine on `NNERuntimeBasicCpu` through a UAF anim-graph node (`AnimNode_AnimGenController.h`).
  `train_autoencoder.py` first compresses poses. Autoregressive, ONE body.
- Control = "Behaviors" (`AnimGenBehavior.h`): Uncontrolled (random walk of the data), Idle, Trajectory following, Velocity
  following ("more useful for offline generation"), Move-to-target, Trajectory + prop interaction through one bone, Tagged
  (style tags over frame ranges), Optional/Encoded/Multi (composition).
- It recombines the mocap database it is trained on; it does not invent technique absent from the data.
- Sample: a player controller (walk + pistol aim/fire, retrainable) and a pre-trained NPC controller (many walking styles +
  props, training data NOT provided). Fab: Standard License, **"Allows usage with AI: No"**.

## Fit for FightCamp - verdict: NOT for the demo road; a post-demo candidate for locomotion/style variety only
1. **Engine.** Runtime is an Unreal anim-graph node + NNE; Godot is SETTLED (DECISION_LEDGER, engine choice). This is not new
   evidence to reopen it. The only Godot route is OFFLINE: generate in UE, bake to FBX, retarget through our existing pipeline.
2. **It does not touch our blocker.** C223 fails on two-body contact: glove on target, G147 clipping, the guard-glove pin.
   AnimGen is single-character; its only interaction is a prop on one bone. No opponent, no contact targeting.
3. **Data.** A flow-matching model needs a large database of the motion it must produce. We hold ~61 Mixamo boxing clips + the
   RamsterZ H2H pack + 38 min of paired mocap - far short, and Epic's sample data is walking/pistol and flagged no-AI-use.
4. **Cost.** Training the 12x2048 denoiser is GPU-hours on a PC with a thermal limit and a two-agent ceiling.

## Where it could earn a place later (backlog, not queued)
Footwork and idle VARIETY and STYLE: Tagged behaviors ("tired", "aggressive", a guard style from D64) over our own boxing
footwork/idle clips, generated offline in UE and baked for Godot. Precondition: enough owned footwork mocap, and a check that
the UE EULA lets baked output ship in a non-Unreal game.

## What would a human do?
A studio animator uses a learned controller for LOCOMOTION volume (thousands of walk/turn/start/stop variants) and keeps
hand-authored or mocap'd, individually reviewed clips for the hero actions - strikes and contact. That is our split too.

## Prefab check
AnimGen IS the prefab under evaluation (Epic, Experimental, UE-only runtime). Not used now for the reasons above.

## Prior research
searched: AnimGen (0 hits); `unreal learned animation motion matching` -> J49_MECHANICS_MEET_PRESENTATION.md, J19_THE_JOINS.md,
J28_HOW_FIGHT_MOVES_FLOW.md (fight games keep mocap'd hero actions + a runtime join system; nothing on learned generators).
