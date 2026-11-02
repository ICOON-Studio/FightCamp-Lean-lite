# TASK GYM5-LOOK - make the club look like the operator's reference (art pass on GymClub3D)

Operator S182, verbatim: "https://www.artstation.com/artwork/DAg4wy   can you make it look that good ?"
The reference (Good Day Studios concept art, used as a LOOK REFERENCE ONLY - nothing copied, nothing shipped from it): a cut-away
3/4 top-down view of a whole fight gym - reception/lounge, a merch/rest corner, two boxing rings + a cage (sparring area), a training
area with green turf lane, racks and machines, blue grappling mats, changing rooms, offices, all inside one building on a street.

## Gap, read by Claude S182 against our club still (docs/previews/s182_club_walk/08_home.png, game camera)
| Reference has | Ours has now | Fix |
|---|---|---|
| Real materials: dark polished concrete, brick, wood panels, rubber mats, chequer tiles | flat beige/white untextured walls and floor | CC0 PBR textures (ambientCG / Poly Haven, licence CC0) per surface; concrete floor dark, walls brick + painted band |
| Colour-coded ZONES: blue mats, green turf lane, red ring aprons, white canvas | one grey floor, beige rooms | each zone gets its floor material + one accent colour; zone labels like the reference's hand-lettered callouts (as tooltips/labels, D icons rule) |
| DENSE props: 10+ bags, racks, benches, tyres, machines, lockers, posters, flags, trophies, lounge tables | a handful of bags, two boxes, empty rooms | prop list from J65 (free models already found) + CC0 kits (Kenney, Quaternius, Poly Haven); every room dressed, nothing floating |
| Warm interior light pools + soft AO, slight contrast, saturated accents | dim, sepia, flat | SDFGI or VoxelGI + SSAO, warm OmniLights over each zone, ACES tonemap, +10% saturation; bright and alive (product rule) |
| Walls with a cap (cut-away thickness drawn dark) and wall dressing (banners, logos, clock) | thin walls, pale | wall caps, banners/posters on every wall, the club name sign |
| The street/parking outside, blurred (tilt-shift) and a vignette | brown void / painted room behind a framed inset | ground plane with street + cars (CC0), DOF far blur, vignette; the club fills the screen (no framed inset over a photo) |
| Higher 3/4 camera that shows the whole floor plan | lower angle, cut by the HUD frame | camera pitch ~50-55 deg, whole building in frame at the far zoom |

Boxing first: our club keeps boxing zones (rings, bags, pads, conditioning, office, changing room). The cage and BJJ mats wait for the
MMA update; a boxing club may still have a mat area for conditioning.

## How (proposal for the next session)
1. Claude: one look-dev still first (materials + lighting + camera only, same props) -> send it to the operator side by side with
   the reference; ask what is wrong BEFORE dressing (feedback_gloves_show_a_still_early).
2. Then props per zone (Cursor on GymClub3D dressing data; John's J65 list for sources), each zone a still on the game camera.
3. Gate: the club tests stay green; a frame-time check (the club must hold 60 fps on the operator's PC); stills opened by Claude.
Prior research: `python Tools/prior_research.py gym art lighting props` before step 1 (J65 free models, M41 Maria scene pictures,
the S154 lighting bisect, "Gym art is bright and alive").
