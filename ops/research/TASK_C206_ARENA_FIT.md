# TASK C206 - CODEX - MAKE THE MARPA ARENA FIT THE FIGHT (3D lane, follow-up to C205)
Model: gpt-6-astra, medium (`CODEX_MODEL=gpt-6-astra`), CODEX_WEB off. Owner: codex. Assigned S80, 2026-09-25.

## Why
C205 is merged (db138cfe) behind `venue_art`, default OFF. Claude recorded boxing with it ON (S80,
`previews/s80_sound/boxing_sound.mp4`, frame 8 s = `frame8.jpg` beside it) and it cannot ship:
1. **The ring does not match the engine's ring.** The left fighter stands OUTSIDE the ropes on the apron. The engine
   keeps fighters inside its own ring bounds, so the visible ring is in the wrong place or the wrong size.
2. **A pale octagon patch on the boxing canvas**, flagged in your own C205 digest.
3. **The hall is a black void** past the seats, and the seats have harsh white edges.
4. **One fighter wears no gloves** in that boxing frame. This may predate C205, so run the control arm first.

## What would a human do?
An environment artist fitting a bought venue to a game's gameplay space. The GAMEPLAY bounds are the truth and the art
is placed to them, never the other way round. So: read the engine's ring from the data, then place and scale the
visible ring/cage to it, and check with an overlay of the engine bounds drawn on the render before judging anything
by eye. Lighting: a broadcast venue is lit so the crowd area reads dim and the ring bright. It is never pure black.

## Do
1. **Control arm first.** Record the same seed (5150, boxing, `shot=broadcast`) with `venue_art` OFF and ON:
   `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/record_room.gd --write-movie <ABS>.avi --fixed-fps 30 --resolution 1280x720 --quit-after 300 -- seed=5150 discipline=boxing shot=broadcast venue_art=1`
   (`venue_art=1` is accepted by record_room since S80). Say in the digest whether the missing gloves happen OFF too.
   If they do, it is not yours: name it and move on. If only ON, fix it.
2. **Ring fit.** Read the engine's ring bounds (`Godot/scripts/RingSpace.gd`, `Godot/assets/data/arena_specs.json`).
   Print engine ring half-width vs the visible rope line / cage fence in world metres for boxing AND MMA. Fix the
   placement/scale in `MarpaArena.gd` / the ArenaRig call so they agree within 5 cm. Add that assertion to
   `venue_art_test.gd` (mesh bounds vs spec, not metadata), and prove it with a mutant.
3. **Octagon patch.** Hide or remove the octagon floor piece in boxing/kickboxing (the cage is hidden there already).
4. **Hall light.** No pure-black void: dim ambient on the hall and a soft fill on the seats, the ring the brightest
   thing. Soften the seat edge highlight (roughness/specular). The operator ruled that dark scenes read as abandoned.
5. Stills (establishing + broadcast, boxing and MMA, ON) into `previews/c206/`, and look at them yourself
   before the digest says anything about them.

## Owned files
`Godot/scripts/MarpaArena.gd` (91 lines, read whole), `Godot/scripts/ArenaRig.gd` (read whole),
`Godot/assets/venues/mma_arena/**`, `Godot/tests/venue_art_test.gd`, `research/C206_DIGEST.md`. The call site in
`Godot/scripts/FightWorldLiveScreen.gd` (4,422 lines, NEVER open whole; `grep -n venue_art` and read `sed -n` windows
around the hits) only if the fit cannot be done from MarpaArena/ArenaRig.

## Gate (tier: script edited)
Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-C203`: `git fetch origin && git checkout -B codex/c206-arena-fit origin/master`
(C205 is on master now). Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`. Then
`python Godot/tools/run_tests.py --only venue_art,arena,fight_world_live,asset_manifest --jobs 1`. Commit explicit
paths (never `Godot/.godot/`, never `.c205_source/`), push, then
`python Tools/agent_comms.py send --from codex --to claude --topic C206 --body "<fit numbers before/after, gloves verdict, tests, stills>"`.
Do not end on a question: take the conservative reading, write it in the digest, push.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Do not move the ENGINE's ring to match the art. `RingSpace`/`arena_specs.json` drive footwork, ropes and cornering for
every bout, and changing them re-baselines the fight engine. The art moves; the numbers do not.
