# TASK GLOBE2B (S226) - Ludo's review of GLOBE2: 4.8/10 -> his 3 fixes (+ land + backdrop)

Seat: cloud Cursor (label `cursor`), branch cursor/issue-<n>, PR to master; never master. Builds on master (GLOBE2 merged S226 with
Claude's render fixes - read `git log -3 -- Godot/scripts/creation/GlobePicker.gd` first and keep those fixes: source_color colours,
coast on the land side, transparent viewport, world-space medallion visibility, name tag above the viewport + sized from its text).
Operator Q-S225-6: "build it with the appropriate menus and show it back to ludo". Ludo's review of the build (binding numbers):
`research/LUDO_ROUND66B_REVIEW_S226.txt` (section 1 per item, section 4 = the 3 fixes). What it saw:
`research/captures/globe1/globe2_uk_s226.png`. Target: `.../ludo_r66_globe_reference.jpg`.

## FIX 1 - the medallion (GlobePicker.gd `_build_viewport` medallion block + `_update_medallion` + `_update_name_tag`)
Replace the 3D coin lying on the normal with a SCREEN-SPACE billboard drawn as Controls on top of the globe (like the NameTag), placed
each frame from `_camera.unproject_position(anchor)`; hide it when the anchor faces away (keep the world-space dot test):
- coin 52 px: 4 px brass bezel #f0c233 (a lighter 1 px top highlight #fae29c for the metal read), oxblood face #8b1e1b, centred GOLD
  glove emblem 24 px = `res://assets/icons/lucide/hand-fist.svg` tinted #f0c233 with a 1 px dark shadow #1a0505;
- tapered brass needle under it, 28 px tall, 4 px wide at the top -> 1.5 px at the tip, #d4af37; the tip sits on the anchor;
- contact shadow ellipse 36 x 16 px, #000 at 70%, soft (blur look), offset (+3, +5) from the tip;
- the coin is tilted look: draw it upright (Ludo: "vertical relative to the camera view") - no 3D coin mesh any more;
- NameTag: 140 px min x 28 px, aligned with the coin head, x offset +34 px, y -6 px from the needle base (flip left past x 1380);
- keep the 420 ms drop-in (drop the coin+needle from -120 px, impact at 240 ms + the 12 px gold ring, bounces +14 px @300, +3 @370).

## FIX 2 - the picked country (globe_earth.gdshader)
- fill: amber velvet #d49a24 at 55% over the land, with a 15 px gold edge gradient (#f0c233) fading to an oxblood core (#421210 at 40%);
- rim: 3.5 px #f0c233 with EMISSION multiplier 1.4 x the 2.4 s sine pulse (and turn on WorldEnvironment glow in the globe viewport so
  it blooms: glow_enabled, intensity ~0.8, hdr_threshold ~0.9);
- land base -> graphite #1e1d1b (no muddy brown); popularity warmth stays but subtler (31-70 +8%, 71-100 +15% toward #4d3319);
- coast 2.0 px #b8933b (metallic 0.70, roughness 0.35), inner borders 1.0 px #2e2b27 at 40%.

## FIX 3 - the right card (CreationFlowPanel.gd `_build_globe_card`, ~line 350-420)
- header block 110 px #242220: the country FLAG (`res://assets/icons/flags/4x3/<iso2>.svg` if the market row has an iso code - find
  where flags are already used in the creation flow; otherwise skip the flag), title 28 px Oswald/display #f6f0e0, subtitle ochre
  #c29b38 12 px ("TIER 1 COMBAT MARKET - <REGION>" from the row's data; no invented values - use what the row has);
- 2 px brass divider #8c6f2d;
- three labelled BARS (10 px, track #181716): COMBAT POPULARITY gold #f0c233, TALENT oxblood #c62f2a, ECONOMY brass #b8933b, each
  "label .... value / 100" in cream 13 px; then the cities/gyms line;
- CHOOSE MARKET: 6 px chamfer look, gradient #f0c233 -> #cf9b1b, 1 px #fae29c inner lip, 4 px dark shadow, dark bold text.
- SEARCH field: #1b1a18 with a 1.5 px #8c6f2d border, cream 14 px text, a 16 px brass `search` lucide icon on the left;
  MARKET LIST: chamfered pill #2b2f36, 1.5 px #d4af37 border, hover #4a2c1b.

## Backdrop (CreationFlowPanel `GlobeBackdropControl`)
Base #141312 (not black) + radial glow #211f1d at r 450 -> #0a0a09 at r 1100 around the globe centre; rings stay (#b8933b at 25%).

## Gate (CI)
Parse + `tests/globe_picker_test.gd`, `globe_uv_sphere_test.gd`, `globe2_look_test.gd` green (update globe2_look_test for the billboard
medallion: `MedallionBillboard` Control with `Coin`, `Glove`, `Needle`, `Shadow` children; 52 px coin; the card has 3 bars named
`BarPopularity`, `BarTalent`, `BarEconomy`; shader uniforms pick_rim_px=3.5, coast_px=2.0, inner_px=1.0). Do not weaken any test.
Claude renders it on the PC and shows it back to Ludo.

## The one trap
The ID map is data (exact 1/255 steps in blue, nearest filter, no source_color, ocean = (0,0,0)). Do not touch its sampling.
