# TASK GLOBE2 (S226) - the New Career globe + its menus in Ludo's round-66 look

Seat: cloud Cursor (label `cursor`), branch cursor/issue-<n>, PR to master; never master. Godot 4.7.2 GDScript.
Operator (verbatim): Q-S225-3 "the outliner and pin still looks very amateur ai made . also what about colours ?" -> Ludo round 66 ->
Q-S225-6 "build it with the appropriate menus and show it back to ludo". Ships ON (it is the existing `globe_picker` switch's screen;
no new switch). Plain --script tests stay the OFF arm.

## THE SPEC (numbers are binding; read the verdict first)
- `research/LUDO_ROUND66_VERDICT_S226.md` (what we take, what changes) - wins over the reply.
- `research/LUDO_ROUND66_REPLY_S226.txt` part C (every hex, px, ms) - the detail.
- Target picture: `research/captures/globe1/ludo_r66_globe_reference.jpg`. Today: `.../ludo_globe_now_s226.png`.

## THE CODE THE GAME RUNS (exact - do not edit other paths)
- `Godot/shaders/globe_earth.gdshader` (54 lines): `fragment()` - keep the S226 ID-map edge method (`_differs`, one screen pixel via
  `fwidth`), split it: an edge where one side's id is OCEAN (the id_map's ocean value = the colour at a known sea UV; expose it as a
  uniform `ocean_id`) = COAST 3.0 px brass #d4af37 (metallic sheen); id vs id = INNER 1.2 px iron #3d3a35. Ocean #121417 -> #1b222c,
  land #242220 tinted by a per-country popularity value (see below), picked: 4.0 px rim #f0c233 + emission glow, 1.5 px oxblood
  #c62f2a pinstripe inside, translucent gold->burgundy fill that KEEPS the land shading (mix, not replace), 2.4 s sine pulse
  (uniform `time_s` from GDScript or TIME). Hover: 2.5 px #fae29c, 80 ms in / 120 ms out (`hover_id`, `hover_mix`).
- `Godot/scripts/creation/GlobePicker.gd` (348 lines): `_build_viewport()` (~92-170: environment, light, sphere, the pin, camera),
  `_update_pin()` (~317), `_update_shader_selection()` (~333), `_gui_input` (~193, add hover via `_ray_pick_market`).
  * Popularity tint: a 256x1 (or id-indexed) data texture or uniform array built from `_markets` combat_popularity (0-30 none, 31-70
    #3a281e, 71-100 #4d3319) - look up by the ID colour.
  * Replace the pin with the MEDALLION: octagonal brass coin (CylinderMesh radial_segments 8, bevel look via a second slightly larger
    darker ring), oxblood enamel disc, a gold glove icon on it (Sprite3D/Decal from the game's own icon set - grep `glove` in
    Godot/assets/icons; if none, a flat gold disc and report), tapered brass stem in a stepped collar, soft blob shadow. ~56 px across
    at 1080p (size it from the camera distance). Drop-in 420 ms: from +120 px above, impact at 240 ms with a 12 px gold ring
    expanding/fading over 180 ms, bounces +14 px at 300 ms, +3 px at 370 ms, rest at 420 ms (Tween).
  * NAME TAG: a parchment Label (#f6f0e0 panel, 1.5 px #2b2f36 border, 4 px chamfer look, 24 px #22201f text) beside the medallion
    (screen-space overlay Control positioned from `_camera.unproject_position`), flips to the left side when x > 1380.
  * Light: warm key #fff4e0 on the picked side, cool fill #141b24, brass rim - remove the orange halo on empty ocean.
- `Godot/scripts/CreationFlowPanel.gd` (890 lines): `_build_country_globe()` (~273-316) and the right panel via `_action(...)`
  (~665) with `panel_x = GLOBE_PANEL_X` (1440).
  * BACKDROP behind the globe for the whole step: slate #181716 + radial vignette (#22201f -> #0a0a09), a faint antique chart, three
    brass rings r 420/580/780 px at 1.5 px #d4af37 22% - NO grey or white void anywhere at 1920x1080 or 1280x720.
  * Globe centred between x=0 and the 480 px panel.
  * The MENUS in the same look: SEARCH MARKET field and MARKET LIST toggle (top left) restyled to dark charcoal with brass borders;
    the list/sort strip when open; the RIGHT CARD (x 1440..1920, full height) #1d1c1a with a 2 px brass inner border, title bar
    84 px (flag if the game has one, the country name, an ochre #d4af37 tier line), the readout numbers stacked clearly, and a
    chamfered brass CHOOSE MARKET button. Reuse UIKit styles where they exist; no teal except the UI selection.

## Gate (CI)
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
- `godot --headless --path Godot --script tests/globe_picker_test.gd` and `tests/globe_uv_sphere_test.gd` stay green (do NOT weaken).
- NEW `tests/globe2_look_test.gd` (red on master first, paste it): the pin is gone and a `Medallion` node with an 8-sided coin exists;
  `NameTag` exists after a pick and flips left past x 1380; shader has `coast_px`=3.0, `inner_px`=1.2, `pick_rim_px`=4.0 and the
  colours above; a `GlobeBackdrop` with 3 rings exists and covers the full step rect; the right card `GlobeCard` spans x 1440..1920.
- You cannot render the look in CI: Claude renders it on the PC (`tools/capture_globe_creation.gd`) side by side with Ludo's picture
  and shows it back to Ludo. Do not claim it "looks" like anything.

## Prior research
LUDO_ROUND61_VERDICT_S223.md (the globe's design), LUDO_ROUND66_* (this look), S225/S226 globe fixes (ID map is DATA: no source_color,
nearest filter, exact match), M_STYLE_SHEET_S206.md (palette).

## What would a human do?
An artist sets the globe's materials and the marker against the reference picture, then skins the menus around it in the same kit.

## Prefab check
No new asset: meshes from Godot primitives, the glove from the game's own icons.

## The one trap
The ID map is data (exact 1/255 steps, nearest filtering, no source_color). Any colour edit that touches `id_map` sampling breaks the pick.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
(S230: this brief is a screen/room look, not a fight clip - steps 2-3 read as: captures of the game's own screen at 1920x1080
and 1280x720, the defect named in the brief before and after, no fighter bodies other than the MetaHuman cast.)
