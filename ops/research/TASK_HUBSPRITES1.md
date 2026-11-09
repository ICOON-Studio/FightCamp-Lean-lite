# TASK HUBSPRITES1 - QWEN (qwen3-coder) - our real boxers as small moving figures for the painted gym

Status: OPEN (S408, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/bake_hub_sprites.gd, docs/HUBSPRITES1_RESULT.md, assets/ui/art/hub_sprites/mh_boxer_01_idle.png, assets/ui/art/hub_sprites/mh_boxer_01_jab.png, assets/ui/art/hub_sprites/mh_boxer_01_walk.png, assets/ui/art/hub_sprites/mh_boxer_02_idle.png, assets/ui/art/hub_sprites/mh_boxer_02_jab.png, assets/ui/art/hub_sprites/mh_boxer_02_walk.png
RED_TEST: tests/gym_hub_test.gd -> GYM_HUB failures=0
REGRESSION: gym_hub_test
VISUAL: no

## Prior research
Operator S408 said yes to the gym as the menu: scripts/ui/GymHub.gd draws assets/ui/art/gym_hub_1.jpg to _4.jpg, a painted isometric club, on Home. It needs people who move. tools/bake_promo.gd already renders our MetaHuman boxers with their kit on the hidden desktop: copy how it builds the body, kit and light. scripts/fight3d/RkClips.gd and FightClips.gd give the clips. ops/research/GDSCRIPT_TRAPS.md. MetaHuman bodies only, never a generated body.

## What would a human do?
Film each boxer side-on against a clear background, then cut the film into a strip of frames.

## Prefab check
tools/bake_promo.gd is the base. No new generator, no new model.

## The job
1. tools/bake_hub_sprites.gd: for mh_boxer_01 and mh_boxer_02, a strip PNG per clip with a transparent background, frames side by side: idle = pro_idle, jab = the game's jab clip, walk = rk_loc_walk. 16 evenly spaced frames across one loop, each 192 x 256 px, head to feet in every frame, the same floor line in every frame, the camera high and to the side as in an isometric game (30 degrees down, 45 degrees round from her front), so the small figure matches the painted isometric club (assets/ui/art/gym_hub_3.jpg), the hips kept in place so the walk does not travel out of the frame.
2. Soft lighting from above like a bright room, no rim colours, no floor, no shadow baked in.
3. Self-check before writing: alpha at the frame's four corners is 0, and the body's top and bottom sit inside the frame on all 16 frames; print the worst margin per strip. A strip that fails is not written.
4. docs/HUBSPRITES1_RESULT.md: the strips made, their sizes and file sizes, the margins, and the command that makes them.

## Rules
scripts/ is out of bounds. Windowed Godot only on the hidden desktop: `python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1280x720 --audio-driver Dummy --script res://tools/bake_hub_sprites.gd`. Headless cannot render. Never _console.exe. Nothing opens on the operator's monitors. Keep each strip under 2 MB.

## The one trap
A transparent background needs the SubViewport's own transparent background and an Environment with no sky. If the corners read opaque, the check in step 3 must stop the run instead of saving a black box.

## Result lines (PR body)
RESULT: tests/gym_hub_test.gd -> GYM_HUB failures=0
