# BODYTEX2 - muscle skin on every boxer, the shoulder seam, and why no body shape was changed - S535

Stills (fight ring, the game's light; opened and checked): `ops/previews/s535_bodytex2/` and the review board, stage S535.
`0_game_camera_before_after.jpg` (the game's own camera, both boxers head to feet), `1_..5_bodies_*_before_after.jpg`
(four bodies a sheet, torso from the front, three-quarter and side; top row before, bottom row after),
`6_seam_shoulder_before_after.jpg`.

## 1. Skin - done, all 19 boxers
- Every boxer (men 01 02 03 07 08, women 10-23) now has `<body>_mh02_body_albedo_2k.jpg` and `_normal_2k.jpg` beside its
  .glb. JPEG quality 92: 17.4 MB for all 19 (0.7 to 1.1 MB a body; boxer 01 alone was 5.4 MB as PNG, those two PNGs are gone).
  `MHRig` reads JPEG or PNG; `tools/export.sh` copies the JPEGs beside the exe. `-- nobodytex` is still the before arm.
- Which of Epic's nine sets, after putting all nine side by side:
  - Chr0023 (a trained man: abdominal wall, serratus, chest line) on men 01, 02, 07, 08.
  - Chr0035 (a man's abdominal grid, softer) on man 03, so the five men are not one torso.
  - Chr0012 on the 14 women: the lean one (centre line, a hint of ribs, flat belly). 0011 and 0013 draw belly folds,
    0018 is flat, 0021 is an old hairy man, 0005 is what the game had.
  - The two dark men get the relief 1.25 times stronger and man 03 1.15: dark skin shows relief only in its highlights.
- Each body keeps its own tone. Found on the way: most bodies' 1K tone map is made of 32-pixel blocks with hard steps; the
  builder now smooths those steps (real edges such as palms and soles stay).
- What the stills show: abs, chest line and serratus on all five men where there was a smooth tube; the women wear a full
  singlet, so on them the change is finer skin on the arms, shoulders and collarbones only.
- Rebuild: `python ops/Tools/metahuman/bodytex1_make.py export <dds_dir>` (the sets out of UE 5.8, about 50 s, no window),
  then `python ops/Tools/metahuman/bodytex1_make.py <dds_dir> all`. The table of who wears which set is at the top of that file.

## 2. Shape - measured, NOT changed (the stop the brief asked for)
- The re-export route works again: a headless UE 5.8 run rebuilt bodies 02, 03 and 07 from their preset and body numbers.
  With the ORIGINAL numbers the new export's skeleton is the shipped one exactly (07: 0.00 mm on all 341 joints; 03: at most
  0.47 mm). So the pipeline is reproduced. (`-nullrhi` cannot build a MetaHuman body - UE asserts in
  SkinnedMeshComponent - so it runs with the old pipeline's `-AllowCommandletRendering`, still without a window.)
- With more muscle (muscularity 0.3-0.5 -> 1.2-1.3, fat -1.5 -> -1.3, chest +2 cm, waist +3-4 cm) the Creator moves the
  SKELETON too: the main joints by 1 to 9 mm (hand 8.5-8.8, spine_03 5.8-7.0, thigh and calf 4.3-5.0), the helper joints
  the correctives drive by 9 mm in the middle and up to 13-16 mm. Limb lengths change as well (02: inseam 71.9 -> 70.6 cm,
  upper arm 35.5 -> 34.6 cm). It also thickens what was not asked for (02: hip 89.6 -> 98.0, thigh 48.5 -> 55.3 cm).
- So a re-export cannot keep the skeleton identical. Per the brief no mesh was changed: every .glb is byte for byte as it was.
- The way forward, his call (it changes how three men look): keep each shipped skeleton and carry only the new SURFACE onto
  it (same vertex order, checked: the control export sits on the shipped vertices, median 0.000 mm), fading to nothing at
  the neck, wrists and ankles, with hip and thigh pinned to today's numbers. The exports are kept in
  `E:/FightCamp/tmp/bodytex2/shape/` (02, 03, 07; control and new). Until then the stomach of 02 and 07 keeps its shape;
  the new skin now draws an abdominal wall on it, which hides part of the hollow in the stills but does not fill it.

## 3. Seam - found and fixed
- What it was: the line where the head's skin (which runs down to the collarbones) meets the body's. The head's open rim
  has 92 places, the body's 46: every second head vertex sits in the middle of a body edge, up to 1.7 mm off it, and each
  rim kept a different four bones of the same set. In any pose the rims part and the dark behind shows as dashes.
- Measured in a bent pose (shoulders, arms, neck turned), all 19 boxers: the rims part by 5.8 to 8.6 mm at most as
  exported (1.8 to 2.9 mm on average); welded 0.00 mm on every body.
- The fix, `scripts/fight3d/NeckSeam.gd` (called by `MHRig.load_fighter`; a body loads in 0.3 to 0.4 s with it or without it):
  the body's rim triangles are split so the body has the head's extra places, and both rims take one set of bones and
  weights. No file changes; `-- noseamfix` (and `-- nobodylook`) leave the rims as exported.
- It lives in its own script because it took MHRig past the 500-line rule.

## Tests
mh_dna_correctives_test, arm_build_test, player2_test, body_look_test, male_bodies_test, file_limits_test: all PASS.
file_limits_test was red before this work (Player2.gd at 501 lines since MHCORR2): one blank line removed.
The seam probe (both arms, 19 bodies) is `E:/FightCamp/tmp/bodytex2/seam_check.gd`; it is not in the repo (tests/ was not
this task's to touch) - worth adding as a test.

## Not done / open
- Body shape (above): needs his yes on the surface-only route.
- The licence note from BODYTEX1 stands (his "Use them anyway", Q-S294-295).
- The head and neck sheet still wears the old flat detail; at the weld the two normal maps meet. No line shows in the stills.
