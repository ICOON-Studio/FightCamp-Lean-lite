# U176 — both corners wear ruleset gloves

## Cause
The live room’s default boxing pair was `f01` (painted boxing gloves) + `f09` (bare hands). `MESHES_BY_DISCIPLINE` swapped meshes for MMA and bare rulesets only, so boxing (and kickboxing / muay thai / taekwondo) kept the illegal pair. With `fighter_skin=cc`, corner A got procedural CC gloves while B stayed on `f09`.

## Fix
- `FightWorldLiveScreen.discipline_demo_meshes()` picks legal Tripo pairs per ruleset (gloved box meshes, MMA meshes, bare meshes + procedural mitts for karate).
- `CCFighterSkin.mount_procedural_gloves()` builds Tripo-hand gloves when the mesh is bare but the ruleset is not.
- `corner_gloves()` reports each corner’s effective glove state for tests.

## Proof
- `fighter_gloves_both_corners_test.gd`: 22 checks, 0 fails (mutant: skip B procedural mount → 2 fails).
- Subsets (direct Godot): `fighter_gloves_both_corners`, `fight_cc_skin`, `cc_skin_contract`, `ruleset_gloves`, `fight_world_live` — all green.
- Stills: `previews/u176/boxing_broadcast_5150.png`, `mma_broadcast_5150.png` (seed 5150, broadcast).
