# TASK G126 - GROK - A FIGHTER GENERATOR IN THE GAME WITHOUT PAYING REALLUSION (S92)
Owner: grok (grok.com, Research mode - never Build). Assigned S92, 2026-09-26. Reply inline, <= 900 words, titled
G126_A_FIGHTER_GENERATOR_WITHOUT_REALLUSION. Tag every claim SOURCED (with URL) / PROXY / JUDGEMENT.
Model: Grok Expert (research). Tier: research only - no repo, no test.

## Why
The operator asked: "will we have a generator in the game without paying reallusion?" Today the game has twelve base
bodies (AI-generated meshes, rigged on a 22-bone Godot humanoid skeleton), and each athlete is scaled to his own height
and girth. Reallusion Character Creator is installed as a TRIAL only; nothing from it may ship without a licence. We
want every fighter in the world to look like a different person - face and body - generated in the game (Godot 4.7),
from a commercially free source.

## What would a human do?
A studio making a sports game with hundreds of athletes (EA UFC's create-a-fighter, Football Manager's regens, 2K's
MyPlayer) builds ONE base mesh with a library of blend shapes (morph targets) for face and body, and a set of skin/hair
textures, then mixes them per athlete from a seed. Find out how they actually do it and what a two-person team can use.

## Questions
1. MakeHuman / MPFB (Blender) - the EXACT licence of the base mesh, targets (morphs), skins and exported characters for
   a commercial game (quote the licence page). Same for any close alternative (e.g. Anny / Meta Human Body ...,
   CharMorph, Human Generator, UMA): licence, what ships, what it costs.
2. How to get MANY distinct faces/bodies into Godot 4: export N blend shapes on one mesh vs N baked meshes; glTF
   morph-target limits and cost; driving blend weights from a seed at runtime.
3. Keeping it on OUR skeleton (22-bone SkeletonProfileHumanoid names): how MPFB's rig maps, and whether retargeting
   clips onto a morphed body needs per-body corrections.
4. Skin, hair, ethnicity and age variety without a real person's likeness: textures that are licence-clean.
5. JUDGEMENT for us: the pipeline in steps, the licence verdict in one line, the cost in days, and the ONE trap.

## Owned files
None. Reply inline in the Grok chat; Claude saves it as `research/G126_A_FIGHTER_GENERATOR_WITHOUT_REALLUSION.md`.
