# Ludo round 66 - verdict (Claude, S226): the New Career globe, from "amateur" to shipped

Operator Q-S225-3 (verbatim): "the outliner and pin still looks very amateur ai made . also what about colours ?"
Ludo's reply: a reference picture (`research/captures/globe1/ludo_r66_globe_reference.jpg`) + a 33,242-char spec
(`LUDO_ROUND66_REPLY_S226.txt`, Ludo's longest reply so far).

## Why ours reads amateur (Ludo A, I agree with all six)
1. Every line is the same 1 px cream - coastlines and inner borders have no hierarchy, Europe is a tangle.
2. The pin is a "Google Maps" red ball on a stick - no style, no base, no shadow.
3. The picked country is a flat sticker fill - no shading, blurry fringe.
4. The globe sits in a grey/white letterbox - no backdrop, no vignette.
5. The orange rim light glows on empty ocean instead of lighting the pick.
6. The right panel floats - thin text, no card, a plain yellow button.

## What we build (Ludo C, taken as numbers)
- **Globe:** shifted left to sit centred between the screen edge and the 480 px panel. Ocean #121417 deep -> #1b222c on the shelves.
  Land #242220 graphite, warmed by combat popularity (0-30 none, 31-70 #3a281e, 71-100 #4d3319) - the colour now MEANS something.
- **Lines:** coastline 3.0 px brushed brass #d4af37 (metallic, faint sheen); inner borders 1.2 px dark iron #3d3a35 (recessed
  hairline) - coasts dominate, Europe reads.
- **The pick:** 4.0 px gold rim #f0c233 with a soft glow, a 1.5 px oxblood #c62f2a pinstripe inside it, a translucent gold-to-
  burgundy fill that keeps the land shading, a 2.4 s sine pulse. **Hover:** 2.5 px champagne #fae29c, 80 ms in / 120 ms out.
- **Marker:** replaces the pin - an octagonal brass medallion (56 px across at 1080p) with an oxblood enamel disc and a raised gold
  boxing glove, on a tapered brass stem in a stepped collar, soft shadow. Drops in over 420 ms with two small bounces and a gold
  shockwave ring on impact. A parchment name tag (#f6f0e0, steel border, 24 px charcoal text) to its right, flipping left near the panel.
- **Backdrop:** warm cast-iron slate with a vignette, an antique chart and three faint brass rings (420/580/780 px) behind the globe -
  no grey or white void anywhere.
- **Light:** warm key light on the picked side, cool indigo fill, brass rim - not an orange halo on empty ocean.
- **Right panel:** a dark charcoal card #1d1c1a with a 2 px brass inner border, a title bar (flag + country name + tier line in
  ochre), the numbers in a clear stack, and a chamfered brass CHOOSE MARKET button.

## What I change
- The marker is built from Godot meshes + one glove icon (no paid model needed); Ludo's medallion picture is the target.
- Ludo's "Godot-Globe" sample shader snippets are a guide only; our shader keeps the S226 ID-map edge method (it already draws crisp
  lines at every zoom) and adds the coast/inner split (a country next to ocean id = coast).

## Next (after his OK on the board)
TASK_GLOBE2 to cloud Cursor (GlobePicker.gd, globe_earth.gdshader, the globe branch of CreationFlowPanel), stills on the PC by
Claude (`tools/capture_globe_creation.gd`) side by side with Ludo's picture, then the board.
