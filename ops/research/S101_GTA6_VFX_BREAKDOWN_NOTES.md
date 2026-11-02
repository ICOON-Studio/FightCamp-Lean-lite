# S101 - WHAT GTA 6's TRAILER BREAKDOWN MEANS FOR FIGHTCAMP (2026-09-27)
Source: Corridor Crew, "VFX Artists Breakdown GTA 6's IMPOSSIBLE Graphics" (youtube.com/watch?v=ULM2OIj5o0I,
29:51, 2026-09-20), read from its transcript at the operator's request. Paraphrased; only what bears on us.

## What they said, in six points
1. **Active ragdoll ("Euphoria", the real-time version of NaturalMotion's Endorphin).** Motion capture runs alongside a
   physics solver. When a body is hit, the solver takes over. It reads the centre of mass, where the feet are and the
   impulse. It drives joint MOTORS toward a target pose, inside joint limits. A small "nervous system" of states and
   triggers switches between BALANCE (shot in the right leg -> load the left) and SELF-PRESERVATION (an object is close
   -> arms up to protect). Canned clips cannot touch the ground physically; a pure ragdoll is "infinitely floppy". The
   motors are what put life back into it.
2. **Probe-grid global illumination.** The world is divided into a grid of light probes: little 360 degree
   low-resolution lighting renders, updated a bit each frame so the bounces build up over frames. Characters are lit by
   whichever probes they walk through, and the haze samples the same probes. Most of the ray-tracing budget goes here.
   Only a few hero surfaces (a glass door, one cocktail glass) get real reflections; the vase next to it gets none.
3. **Detail where the eye is.** The budget is spent on the hero object and taken from the rest. A 30 fps target at about
   1400p is upscaled, and a denoiser plus the previous frames smooth out low sample counts.
4. **Procedural rooms from tags.** Every object carries tags: where it may exist, what it may sit next to or on top of,
   and in what order it is placed. Rooms build themselves from these rules. "If you have to do it three times, build a
   system."
5. **Sweat is a small fluid sim flattened into a texture.** It is simulated, rasterised to 2D, and applied to the
   body's UVs, so it reads as wet skin at almost no cost.
6. **Show off what you are good at.** Rockstar repeats its strongest features everywhere: plants, hair, fabric weave.

## What we take, ranked
1. **Active-ragdoll hit reactions and knockdowns (the biggest fit).** Our reactions are canned clips (C214's 0.60 s
   StaggerSmall01; the heavy collapse at CRITICAL). Point 1 is exactly the "one man down, the other standing" state the
   operator just asked for, and a hurt leg that cannot bear weight is our own limb-damage model (S97). Godot 4 has
   `PhysicalBoneSimulator3D` with joint limits, and Jolt joints have motors. Proposal: research first. Can a
   motor-driven partial ragdoll run blended over a clip on our Tripo/MPFB rigs at 60 fps, for two bodies, on this PC?
   This is a Codex spatial task (gpt-6-astra). It is queued after the MMA-states study, because the states come first.
2. **Sweat and wet skin over rounds.** A per-fighter wetness value driven by the engine's stamina and round, fed to one
   shader parameter (roughness and specular) on the skin. Cheap, visible from round 2, and it tells the story of the
   fight. A small presentation task.
3. **Gym lighting (the road's "lighting and camera for the gym").** Godot's LightmapGI with light probes for the static
   gym, and SDFGI or VoxelGI only if it fits the budget. Bake the room and let the fighters sample the probes. That is
   point 2's idea, done the way our engine does it cheaply.
4. **Hero budget.** Full detail on the two fighters and the ring; crowd and gym props on cheap materials and LODs; FSR
   upscaling on weaker PCs.
5. **Decor rules as tags.** This is already our direction (S90 decor places pieces by rule). Point 4 confirms it: give
   every decor and prop item tags for where it may stand.

## What we do NOT take
Strand hair, fluid fire and bespoke ray tracing: a decade and a studio's budget. Our look is the fighters and the ring.
