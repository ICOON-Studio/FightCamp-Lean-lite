# TASK MH1 - one-fighter MetaHuman pilot (D29)

Model: Claude (lead developer), S138-S139. Written at merge time (S140): the pilot ran on the D29 ruling without a task
file; this file records its contract so the branch gate can check it.

## Spec
Operator 2026-10-01 (D29): "hybrid, start the metahuman pilot". One MetaHuman boxer, UE 5.8 MetaHuman Creator by
script -> FBX -> Blender GLB -> Godot; plays the certified jab through the production FightStagePlayer; portrait beside
the MPFB control; frame time with two MetaHumans in a dressed venue. Reopen D29 if it cannot retarget our clips or runs
under 60 fps with two MetaHumans in a dressed venue.

## Acceptance
Portrait vs MPFB judged by the operator (2026-10-02: "metahuman model is better" - PASSED); jab plays with 0 missing
bones (headless probe, mutant worse); perf.json two MetaHumans in Iron Parish 1080p (5.0 ms, control 4.6).

## Owned files
- `Godot/assets/models/metahuman/`
- `previews/mh1/`
- `research/MH1_DIGEST.md`
- `Godot/scripts/MetaHumanRig.gd`
- `Godot/tools/mh1_pilot.gd`
- `Tools/metahuman/`

## Test
`python Godot/tools/check_scripts.py Godot/scripts/MetaHumanRig.gd Godot/tools/mh1_pilot.gd`; headless
`--script tools/mh1_pilot.gd` (probe mode, see MH1_DIGEST.md).

## The one trap
The preset's default outfit builds 4K/8K clothing textures in the commandlet and froze the PC: clear the Outfits slot
before spawn_meta_human_actor.
