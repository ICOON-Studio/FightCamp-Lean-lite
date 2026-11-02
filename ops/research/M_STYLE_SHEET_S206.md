<!-- Maria (gbot thread), M_STYLE_SHEET_S206 reply verbatim, collected S207 2026-10-12 -->
I'm on the one-page style sheet. I'm turning the gym brief into one page of exact, buildable numbers that every asset gets checked against.
# M_STYLE_SHEET_S206: gym asset style sheet (one page)

The direction is a chunky stylised gym in the spirit of Two Point Hospital, but a real boxing gym in the mood of Gleason's and Repton. Every hex is a proposal derived from the M43 real-gym samples. The wall is now brick (`#b8402e`) instead of the brief's painted red, to match the Gleason's/Repton mood you named.

## Palette
| Role | Hex | Note |
|---|---|---|
| Wall, brick red | `#b8402e`, mortar `#8e2f22` | Main walls, chunky brick blocks |
| Wall, dado band | `#d98039` | Glazed band from 0 to 1.1 m |
| Wall, upper plaster | `#efe4cf` | Above the posters |
| Floor, concrete | `#c9c2ad`, scuff `#b3ac98` | Warm light grey; scuffs are shapes, not grime |
| Floor lines | `#f2d04b` / `#f4f1e8` | Old court lines, 8 cm wide |
| Mat, ring zone | canvas `#3f78c9`, skirt `#2f5f9f` | The biggest colour block in the room |
| Mat, bags zone | `#b9473a` | Under the bag line |
| Mat, weights zone | rubber `#4a4f55` with an `#e8742c` edge strip | Plates are `#e8742c` too |
| Mat, cardio zone | `#e0a83a` | Strip under the machines |
| Mat, recovery zone | `#5fbf8a`, rollers `#4aa576` | Stretch mats |
| Steel | `#2b2f36`, edge highlight `#4a515c` | Rails, racks, posts, columns |
| Leather | red `#c62f2a`, black `#22201f`, white `#ecebe6`, old brown `#8a5232` | Bags, gloves, pads |
| Wood | `#c48a4a` | Boards, benches, plyo boxes |
| Ring | 4 ropes `#e23b3b`; corner pads red `#c62f2a`, blue `#2a5f9e`, white `#ecebe6` | |
| Skin range | `#f3d2b8` `#e2b08c` `#c98e64` `#a8704a` `#7d4e33` `#4f3122` | Six steps, used for every role |
| Accents | gold `#f0c233`, paper `#f6f0e0`, poster blue `#2a5f9e` | Small amounts only |
| UI-safe highlight | outline `#7fd0cf`, fill `#1f6f66` at 35% | Hover and selection ONLY; no asset may use teal |

## Shape language
- **Bevels:** every hard edge gets a 2-segment chamfer sized at 4% of the object's smallest dimension, at least 2 cm and at most 8 cm. No sharp edges.
- **Scale:** equipment is 1.2× real against the characters, while the ratios between props stay real.
- **Naming feature:** the one feature that names a prop is 25% bigger (the speed-bag board, the ring corner pads, the dumbbell ends, the treadmill console).
- **Thin parts:** at least 3× real thickness and never under 5 cm in the world. Ropes are 6 cm, chains and handles 5 cm.
- **Forms:** 2–4 primary forms per prop plus at most 2 details. Soft kit is rounded; hard kit is boxy with bevels.
- **Silhouette test:** filled solid black and seen from above, the prop can still be named.

## Materials
- Flat base colour, a subtle vertical gradient (the top 8–12% lighter) and baked ambient occlusion. Nothing else.
- No photo textures, no normal-map detail, no grime, dirt or rust maps. The only decals are posters and logos.
- Wear is shown by shape: tape wrapped round a bag, a dented pad, a sagging rope, a chipped bevel.
- Starting roughness values (EXAMPLE): leather 0.45, canvas 0.9, rubber 0.85, wood 0.7, painted steel 0.55 (not metallic), mirror 0.1.

## Lighting
- **Key:** warm 4800 K (`#ffe6c7`) from the window side at 55–65° elevation, with soft shadows.
- **Fill:** cool sky 7500 K (`#cfe0ff`) at 35–45% of the key. No zone falls below 80% of the hall's average brightness.
- **Lamps:** emissive ceiling strips (`#fff4dc`), about one every 4 m over each zone. The ring gets 4 strips, 15% brighter. Never a spotlight cone.
- A contact shadow or ambient-occlusion blob sits under every prop and character. No depth of field on the floor, light bloom only, no film grain.

## Characters (top-down camera)
- **Proportions:** the head is 1/6 of body height, hands and gloves 1.3×, feet and shoes 1.2× with chunky soles, shoulders 1.1×.
- **Weight class** shows in the silhouette, lean and long versus broad and heavy. Not chibi.
- **Acting:** key poses are held a beat longer than real. Faces are simple and readable when zoomed in.

| Role | Outfit |
|---|---|
| Boxer | Signature trunks with matching gloves (ours are green/red), a white tank or bare top, white shoes. One strong colour per fighter. |
| Sparring partner | Always in headgear, with blue gear `#2a5f9e` |
| Coach | Dark navy tracksuit `#23324a`, cream top `#efe4cf`, mitts or a towel on the shoulder |
| Member | Muted grey-blue tee `#7d8a99`, dark shorts `#3a4048`, black gloves |
| Staff (reception, cleaner) | Black polo `#22201f` with a gold name tag `#f0c233` |
| Physio | White tunic `#f2f2ee` with mint trim `#5fbf8a` |

## DO / DON'T
1. DO make every prop pass the one-second name test from the game camera at 1920×1080.
2. DO give each station its zone mat colour AND a shape cue; never colour alone.
3. DO fill the hall: at most 15% empty floor, and only for the skipping strip and walkways.
4. DO show wear by shape: tape, dents, sag.
5. DO put a contact shadow under everything.
6. DON'T mix realistic or scanned models with stylised ones, or ship plain placeholder boxes.
7. DON'T use photo textures, grime maps or rust.
8. DON'T put household objects on the floor: bath, fridge, TV cabinet, sofa, rugs, carpet, crates.
9. DON'T use teal on any asset; it belongs to the UI highlight.
10. DON'T make any part thinner than 5 cm in the world, and don't build tall props that block the camera.

The sheet is saved on my computer at `/workspace/fightcamp-gymstyle/M_STYLE_SHEET_S206.md`. It'll land on Beast with the brief and M44 as soon as Beast is back online.
