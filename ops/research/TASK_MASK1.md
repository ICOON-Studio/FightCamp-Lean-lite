# TASK MASK1 - the limb under the mouse lights up, from the 3D (S559)

Kind: build (picture tool + toy page). Model: claude-opus-5-5. Discipline: boxing (demo path).
Seat: console worker. Estimate: 2-3 hours, ~10 min of GPU renders.

## Why
Owner S559 on the body toy (`proto/twohands/body.html` + `body_ui.js`: round labelled spots on the gloves): "the body
look needs better view i think our 3d work can pay off here ... you break down the body to each limb (feet can be one
option when it is boxing match for movement options) , so when i say you highlight the arm i move my mouse on i do not
want text near the fighters (tubes or circles on the fighters are forbidden) make a pointer outlining to the available
options menu". RS3D1 (ops/research/RS3D1_ASSESSMENT.md, Option B) recommends exactly this as the next use of the 3D.

## Build
1. Masks from the 3D: for the pictures the page shows while the player PLANS (the guard and every hold run's frames,
   `blue_*` both corners, all three ranges: `*_both_*`, `*_lead_*`, `*_rear_*`, `guard`), render a second picture per frame
   with the same camera, one flat colour per part: blue's lead arm, rear arm, both legs (one "feet" part), torso; red's
   lead arm, rear arm, legs, torso (8 colours, no shading, no outline, background transparent). Per bone: the part of
   the bone with the most skin weight (a flat unshaded material swapped onto the bodies for the mask pass, or a vertex
   colour by bone). Save as `<run>_<k>_mask.png` (lossless) beside each picture; anim_web copies them (extend it, small).
2. `body_ui.js`: replace `find()`'s colour guess and the round spots with the mask: the part under the mouse (read the
   mask pixel at the mouse) gets a soft glow outline in its corner colour drawn from the mask (a canvas over the picture,
   the mask's edge dilated 3 px, 60% alpha) - NO circles, NO labels, NO text on or near the fighters. Click = that part's
   switches stay open. A thin pointer line runs from the lit part to the switch panel, which sits in ONE fixed place
   beside the ring (Claude's call on the owner's open questions: fixed panel; glow outline in the corner colour; his
   parts light too and show what that limb did in his last three beats; the torso opens the clinch; the legs = feet).
3. The page stays 1920x1080 with no scroll, and follows the compact board (small toggles with icons, details in the
   tooltip) as in order.html.
4. Check in the browser (the page server: `python proto/cardgame/serve.py 8797 twohands`, curl first): hover each of the
   8 parts at Long, Mid and Inside; screenshots to `ops/previews/s559_mask/`; one on the board
   (`python ops/Tools/review_add.py --stage S559 --rating "not scored: your eye" --title "Lit limbs from the 3D" <png>`).
Note: if `tools/pics2d_camera.json` appears while you work (the owner's new camera), finish the code, then render the
masks WITH it only when the main pictures are re-rendered with it too (tell the session; never mix two cameras).

## Contract
- OWNS: tools/pics2d_anim_more.gd (a mask pass), proto/twohands/tools/anim_web.py (copy masks), proto/twohands/body_ui.js,
  proto/twohands/body.html, the *_mask.png files
- RED_TEST: none (a new view); the check is the 8-part hover at three ranges
- REGRESSION: anim_check.mjs PASS; page_play_test.mjs 4 passed (order.html untouched)
- VISUAL: the screenshots, opened by you: a lit arm is the arm, nothing else lit, no circle or text on a man

## Not allowed
No change under scripts/, nor to order.html / kick.html rules. Godot only through godot_slot + hidden_desktop, never
`_console.exe`. HIS GAME FIRST (`Get-Process ArcheAgeChronicles`). Commit only your paths, by pathspec.

## Prior research
ops/research/RS3D1_ASSESSMENT.md (Option B); memory feedback_body_view_no_text_on_fighters_s559.md; docs/RINGANIM1_RESULT.md.

## What would a human do?
A UI artist exports an ID pass from the 3D scene beside each frame and lights the hovered region with an outline.

## Prefab check
Godot's own unshaded StandardMaterial3D for the ID pass; no addon.

## Feedback loops
None: a view.
