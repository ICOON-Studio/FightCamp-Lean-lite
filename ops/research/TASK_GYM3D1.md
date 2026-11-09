# TASK GYM3D1 - AGY (Argon High) - can the floor be a real 3D scene? A test, not a feature

Status: OPEN (S411, Claude main). Discipline: boxing. Model: Argon High.

## Contract
OWNS: tools/gym3d_test.gd, docs/GYM3D1_RESULT.md
RED_TEST: tests/gym_plan_test.gd -> GYM_PLAN failures=0
REGRESSION: gym_plan_test
VISUAL: stills, opened by you, then by Claude

## Prior research
The target look: docs/mockups/s411/open/floor/small_unit.png and grown_club.png (AI paintings: mood only). ops/research/FLOOR_PLACES_S411.md (what the floor will show). ops/research/S411_GYM_CRITICS/art.md and SUMMARY.md: why today's flat picture reads small. scripts/fight3d/RingSet.gd (the fight's ring), tools/bake_hub_sprites.gd (how a MetaHuman boxer is posed and rendered orthographically), scripts/rules/GymPlan.gd + assets/data/gym_plans.json (the building as data).

## What would a human do?
Build one rough room from the parts already in the shop, light it, stand two boxers in it and look at it, before ordering anything.

## Prefab check
The ring and the MetaHuman boxers exist. Bags, racks, walls and floor: plain primitives with materials are enough for this test. No new asset purchases.

## The job
A throwaway tool scene, tools/gym3d_test.gd, nothing in scripts/ or the game. From the `front_of_house` plan, scaled down to one room of about 16 x 12 cells:
1. Tall brick-coloured back walls (cut away on the two near sides), a wood floor, big window light from one side with real shadows, warm and directional, dark surround.
2. The fight's ring. Four heavy bags hung on the wall side, one weights rack, a small reception desk by a door. Primitives are fine, in believable proportions.
3. Three or four real MetaHuman boxers from assets/models/metahuman, in kit, playing a guard or bag clip, about 100-130 px tall on a 1920x1080 frame.
4. The same room from THREE cameras, each a still (operator S411: "what about top down view ?"): the high cutaway angle of the paintings (orthographic), straight top-down (looking directly at the floor, walls seen only as their tops), and a steep top-down of about 65 degrees that still shows faces and the front of the body. The room fills most of each frame.
5. A stamina bar over each boxer and a row of place dots over each station: quick Label3D or Sprite3D is enough.
Then answer, with numbers, in docs/GYM3D1_RESULT.md:
- Stills at 1920x1080: the room, and the same room with one boxer selected.
- Frame time with it running live: measured, windowed, with the GPU in use.
- Per camera: can you tell one boxer from another, and see who is fatigued, at a glance? Are all the stations visible with nothing hidden behind a wall or the ring? Which camera makes dragging a boxer to a station easiest?
- Does it read as the same world as the fight? Does a boxer read at that size? What is missing to match the paintings?
- Live scene, or pre-rendered to one picture plus moving boxers? Which, and why.

## Rules
Scripts stay in tools/. Windowed runs through `python ops/Tools/godot_slot.py run --who agy -- python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/gym3d_test.gd -- <out_dir>`. Hidden-desktop stills are 1009 px tall. Nothing opens on the owner's monitors. Save stills to E:/FightCamp/tmp/gym3d1, and copy the two best into docs/mockups/s411/gym3d/. No file over 500 lines.

## The one trap
A nice still of a scene that runs at 15 frames a second answers nothing. Measure it.

## Result lines (PR body)
RESULT: tests/gym_plan_test.gd -> GYM_PLAN failures=0
RESULT: frame time, ms, at 1920x1080 with four boxers
