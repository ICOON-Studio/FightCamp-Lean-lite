# TASK C205 - CODEX - PUT THE OWNED MARPA "MMA ARENA" INTO THE FIGHT (3D lane)
Model: gpt-6-astra, medium (`CODEX_MODEL=gpt-6-astra`), CODEX_WEB=live. Owner: codex. Assigned S78 end, 2026-09-25.

## Why
Operator, 2026-09-22: "i dont want to see those grey artifacts again"; 2026-09-25: "what has stopped you to integrate
this?" - nothing did; it was never scheduled. The fight is still staged in `ArenaRig.gd`'s runtime primitives (flat
BoxMesh/CylinderMesh deck, posts, chain-link fence) while the project OWNS Marpa Studio's "MMA Arena" (bought
2026-09-13, standard Unity Asset Store EULA - art assets, fine to ship in Godot). Contents are verified in
`research/ASSET_REPORT_2026-09-20.md` §5: 31 `.fbx`, 138 `.png`, 29 `.mat` (Unity-only - rebuild), 31 prefabs +
1 `.unity` scene (Unity-only - use as the LAYOUT reference). Source:
`%APPDATA%\Unity\Asset Store-5.x\Marpa Studio\3D ModelsEnvironments\MMA Arena.unitypackage` (a gzip tar; each entry is a
GUID folder holding `pathname` + `asset`).

## What would a human do?
An environment artist porting a bought kit between engines: extract, re-import the meshes, rebuild materials from the
texture maps (albedo / normal / metallic-roughness / emission), reassemble the scene from the source scene's
transforms, light it for broadcast, then check scale against the game's real measurements - never eyeball it.

## Do
1. Extract. Import the meshes you need (OctagonCage, OctagonFloor, OctagonCageDoor + the hall: seats, stairs,
   pillars, truss, ceiling frame and lamps, scoreboard, screens, walls, barricades, entrances). Read the `.unity`
   scene YAML for each object's transform and rebuild the layout as `Godot/assets/venues/mma_arena/mma_arena.tscn`.
2. Materials from the PNGs (StandardMaterial3D). Textures: downscale to at most 2K, compress; **total added to the repo
   <= 120 MB** (no LFS; if it cannot fit, drop the least visible pieces and list them).
3. Scale: the cage must match `Godot/assets/data/arena_specs.json` (octagon span, deck height, fence height - the
   governing bodies' figures R61 sourced). Print mesh span vs spec span; fix by scaling, never by editing the spec.
4. Wire it behind option `venue_art` (default OFF; OFF byte-identical): MMA bouts stand in the Marpa octagon; boxing
   and kickboxing keep ArenaRig's ring deck/ropes/posts but placed INSIDE the Marpa hall (seats, lights, screens,
   truss) with the cage hidden. `ArenaRig.gd` (586 lines, read whole) builds today's rig; the call site is
   `FightWorldLiveScreen.gd:836-870` (never open that file whole - windows only).
5. Licence row in `Godot/assets/venues/LICENCES.md` and the asset manifest (`Godot/assets/asset_manifest.json`).
6. Two MP4s, same seed, OFF vs ON, MMA and boxing, via `Godot/tools/s77_camera_probe.gd -- shot=broadcast
   opt.venue_art=true` through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`;
   md5 each; plus 3 stills per ruleset (establishing, broadcast, close).

## Owned files
New `Godot/assets/venues/mma_arena/**`, new `Godot/scripts/MarpaArena.gd`, `Godot/scripts/ArenaRig.gd`, the wiring
window in `Godot/scripts/FightWorldLiveScreen.gd`, `Godot/assets/venues/LICENCES.md`, `Godot/assets/asset_manifest.json`,
new test `Godot/tests/venue_art_test.gd`, `research/C205_DIGEST.md`.

## Gate (tier: script edited)
Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-C203` on a new branch `codex/c205-mma-arena` from origin/master
(imports in place; never commit `Godot/.godot/`). Parse gate first:
`python Godot/tools/check_scripts.py <touched .gd>`. Then `python Godot/tools/run_tests.py --only venue_art,arena,fight_world_live,fight_stage,asset_manifest --jobs 1`.
Prove the new test with a mutant. Commit explicit paths, push, then
`python Tools/agent_comms.py send --from codex --to claude --topic C205 --body "<mb added, span vs spec, md5s, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Unity is Y-up and left-handed and FBX from Unity is often exported at 100x or with a -90 X rotation; if the cage
comes in the wrong size or on its side, fix the import transform once in MarpaArena.gd - do not hand-tune each piece,
and print the measured cage span beside `arena_specs.json`'s.
