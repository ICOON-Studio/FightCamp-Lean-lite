# S147 DIGEST - 2026-10-02 (night): the real boxing glove is on both fighters in the live room

Operator at start: the S146 handover block. His questions during the stage: "is the new gloves finished on the fighters" (S146: no),
"are you running the glove test on metahuman model" (no - only the MPFB man at first; now both), "check existing research on
undisputed ... what they did on the glove and animation palette".

## 1. What now works
- **GLOVES C241 run 4 DONE for boxing** - 946b12e0 on master (branch codex/c241-glove-asset f5e15838). The CC-BY 4.0 Sketchfab glove
  (Incg5764) is ONE closed 1,950-triangle mesh in metres (0.26 m cuff-to-front, front 0.16 m past the wrist so no hit distance
  moves, 0.14 x 0.125 m across, 44 KB, no textures). The cuff band is a vertex colour; `CCFighterSkin._paint_whole_glove` paints fist
  and cuff per fighter with a small shader; the left hand mirrors depth; `FighterFist` now folds the thumb as well. MMA and mitt keep
  the Codex Fist/Cuff meshes. Credits: `Godot/assets/models/gloves/CREDITS.md` + `.txt` (the export filter packs `.txt`); manifest
  entry `fight_gloves` approved (CC BY 4.0, NoAI tag noted).
- **Evidence (opened):** LIVE room stills `docs/previews/c241/live/close_1.png`, `wide_1.png` (both corners, real seeded bout, tool
  `Godot/tools/c241_live_stills.gd`); review rig `review/boxing_after_sheet.png`, `zoom/cmp10.png`; MetaHuman boxer
  `zoom_mh/cmp_mh.png` (fronts clean). Tests: cc_skin_contract 76/0, ruleset_gloves 38/0, fighter_gloves_both_corners ok for
  boxing/kickboxing/muay_thai/mma. asset_manifest_test still fails on 35 PRE-EXISTING room/crowd references (none about gloves).
- **How Undisputed does it** (R121 method, metadata only, nothing extracted): separate L and R skinned glove meshes of ~2,200
  vertices, a 168-vertex hand-wrap mesh, strap-driver bones, per-fighter "Default Gloves P1/P2" objects plus DLC gloves. Their
  animation palette is 2,699+ named fighter clips with motion matching (R121); ours stays the 22 certified moves for the demo.

- **The live room's fighters are TRIPO bodies (22 bones, no finger chain) - the first stills (MPFB man) did not show it.** The operator
  sent a live still: the fighter's own thumb out beside the glove, fists turned inside. Fixes (CCFighterSkin): (1) the Tripo glove is
  oriented from the HAND bone's rest-derived axes (fingers along hand - lower arm, thumb +Z at rest), not the forearm guess; (2) a
  closed boxing glove now REPLACES the hand: `hide_hand_meshes` cuts every triangle with a vertex weighted >=0.25 to a hand bone out of
  the body mesh (per-instance copy), which is what a pro does - no fit can keep a finger-less rigid hand inside a glove from every
  angle; (3) a roomier un-leaned `boxing_glove_tripo.glb` (0.18 x 0.16 m, front 0.23 m: the Tripo hand is longer). Evidence: live
  sweeps `docs/previews/c241/live/sheet_g1_all.png` (glove-centred cameras, 3 moments, front/side/top/under) - no finger, thumb or skin
  patch left; `closes.png` (four live moments). Tool: `Godot/tools/c241_live_stills.gd`.

## 2. What is NOT done
- The shipped build has no credits SCREEN; CC BY needs the credit shown to players. Add one before the ship build.
- MPFB / MetaHuman gloves (finger-chain rigs) keep their hand mesh: a small thumb crease shows skin at grazing side/top angles. The
  same hand-cut could be applied there if they reach the live room; they are not the demo fighters yet.
- The demo .exe is NOT rebuilt with the glove yet.

## 3. Lessons (for the next fit)
- Splitting one continuous surface into two meshes scaled separately tears it open at the seam (the white wedge was the hand through
  that tear). Decimating before welding UV-seam vertices opens cracks. Weld first, keep it one mesh.
- Fit to the render, not to a skinned-vertex dump: `get_bone_global_pose()` read outside the skeleton update misses the
  FighterFist fold, and the dump's x side disagreed with the render. A uniform 1.4x glove test told "geometry" from "draw order".
- Harness: `Godot/assets/models/gloves/review.gd`, `review_zoom.gd`, `review_mh.gd` (hidden renders via godot_hidden.ps1).
