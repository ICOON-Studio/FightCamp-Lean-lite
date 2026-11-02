# TASK GYMLOOK3A_FIX3 - round 4: three defects left after round 3 (Cursor, branch cursor/gymlook3a)

Model: Cursor default. Spec `LUDO_ROUND44_VERDICT_S212.md`; your digest round 3; checker `Godot/tools/gymlook3a_pixel_check.py`.
## Prior research
GYMLOOK3A_DIGEST rounds 1-3, TASK_GYMLOOK3A_FIX1/FIX2.
## What would a human do?
Look at the wall up close: bricks must read as bricks; nothing may cover the club name; the ring centre shows the emblem only.
## Prefab check
Bricks085 (CC0) is already in the tree.

## Kept from round 3 (do not regress)
Maple floor, corners clean, FPS 44.7 >= 27.5, 4 pixel checks green.

## What Claude saw in YOUR round-3 stills (file tool, 2026-10-13)
1. BRICK IS SMEARED. after_03 (wall x 650-1900, y 120-340) and after_01 top wall: vertical streaks of orange/red, no brick
   courses or mortar lines. The texture is stretched along one axis (UV scale/triplanar on a thin box, or the wall mesh's UVs
   span its depth). Fix: plain UV with uv1_scale so one brick is ~0.25 m x 0.065 m in world size on the face the camera sees.
2. BLUE BANNER COVERS THE CLUB NAME. after_01 (x ~975-1015, y 250-300) and after_03 (x ~1650-1760, y 135-280): a blue
   rectangle sits on top of "DEV JUMP 303". Move the banner/poster so nothing overlaps the name (name stays centred).
3. SQUARE STILL ON THE RING EMBLEM. after_02 (x ~1060-1210, y ~265-350): a grey pad with a brown/tan square inside sits on the
   emblem centre. Your checker passed it on luminance stdev (the frame's edges). Find the remaining mesh (ring centre pad,
   corner-pad pack, or the emblem overlay's own quad) and remove it under look3a.

## Acceptance - extend the pixel checker (it must go RED on the round-3 stills first; paste both outputs)
- Brick: in the after_03 wall box, the luminance profile along a vertical line has >= 6 dark mortar dips per 100 px
  (horizontal courses), and along a horizontal line the autocorrelation is NOT > 0.9 at lag 20 px (no vertical streaks).
- Name: in after_01 box (x 860-1060, y 245-280) the fraction of strongly blue pixels (B > 140, B > R+60) is < 0.03.
- Emblem: in after_02 box (x 1080-1190, y 290-340) the fraction of tan/brown pixels (R 150-220, G 100-160, B < 110) is < 0.05.
- FPS after >= round 3 harness (state both + draw calls). Parse gate on touched .gd; `tests/gym_look2_shell_test.gd`, then
  `python Godot/tools/run_tests.py --only gym_look --jobs 1`. Stills only via `Tools\godot_hidden.ps1`; watchdog before each
  Godot run; never open an image on screen. Commit + push cursor/gymlook3a, digest "Round 4". Do not edit HANDOFF.md.

## Owned files
Same as FIX2 (club_look/*.gd, gym_look2.json, gymlook3a_stills.gd, gymlook3a_pixel_check.py, gym_look2_shell_test.gd, previews/gymlook3a/**, GYMLOOK3A_DIGEST.md).

## The one trap
Headless tests keep gym_look3a/gym_look2 OFF; never change either default in data.
