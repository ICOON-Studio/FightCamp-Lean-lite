# DRAW THE TEXTURES THE ARENA AND THE FIGHTERS NEED

**LONG-RUNNING TASK - it does not finish in one pass.** Operator ruling
2026-09-22: *"agents need to work 24/7 when they are green on opsboard give
long term tasks and keep checking on them on every new session how the
progress and improve the product."* Claude re-cuts this brief each session
from what actually landed - it is never restarted from scratch.

**EVERY PASS ENDS WITH AN ARTEFACT THE OPERATOR CAN JUDGE, and with a line
saying WHAT IS STILL WRONG.** A pass reporting everything fixed is the one
checked hardest.

**Owner:** kalli. Art, delivered as image files. No shell, no repo commands -
stage to `_kalli_delivery/` and Claude lands it.

## Why you

You drew the 272 technique icons in `Godot/assets/ui/icons/moves/`. They are the
only hand-made art in the project and they work. Everything in the 3D room is
flat-coloured primitives.

## What the room is short of, in priority order

1. **The canvas.** A 9.14 m mat rendered as one flat off-white plane. A real
   competition canvas has a weave, seams where the panels join, a printed
   centre, and scuffing where feet turn. Deliver a TILEABLE texture plus a
   normal map, sized so one tile is a real metre count - say which.
2. **The cage fence.** Currently a procedural chain-link generated in code
   (`ArenaRig._chain_link_texture`, a 64 px diamond weave). A drawn one with
   real wire, some sag, and worn galvanising would beat it. Same tiling rule.
3. **Post padding.** The posts are bare cylinders. Competition posts are padded
   - vinyl, seamed, with a sponsor-free face. This is also the surface a
   clinch animation presses against, so it is not only decoration.
4. **The floor beyond the cage.** Flat grey nothing today. Whatever you put
   there must NOT pull the eye off the fight.

## Rules

- **Tileable, power-of-two, and say the metres per tile.** A texture with no
  stated scale cannot be applied correctly and will be guessed at.
- **No logos, no sponsor marks, no real organisation's branding.** Ever.
- Albedo plus a normal map where the surface has relief. Roughness if you can.
- PNG. Name each file for what it is, not for the pass number.
- **Say which figure you worked to.** The arena dimensions are all in
  `Godot/assets/data/arena_specs.json` and every one carries its clause.
