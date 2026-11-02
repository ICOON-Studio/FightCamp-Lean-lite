<!-- J65 collected S180 2026-10-08 from `python Tools/gbot.py thread --to john --full` (John Research, Grok bot), verbatim. Summary line from John: 29 of 37 rows have a usable free model, 2 partial, 6 NOT FOUND (image-to-3D candidates). -->
# J65 - Free models for the new club

**Task:** find a free, game-licensed model for every prop in the new FightCamp club (Godot 4.7, glTF/GLB). The operator said "Keep none" (2026-10-08), so every prop needs a new model. Target look: Gleason's / Repton / Peacock, one semi-realistic style, not cartoon.
**Date:** 2026-10-08 (Asia/Nicosia) | **Owner:** John Research | **Scope:** research only, no game code. Not repeated here: R142 Mixall, G114 $16 pack, PREFAB2 Marpa, Kenney Furniture Kit.
**Tag legend:** **[S]** = SOURCED: URL in the same cell or line, checked live on 2026-10-08 (page or API returned the model). **[J]** = JUDGEMENT (often made from the thumbnail only).
**Tris:** Sketchfab = API `faceCount`. Poly Haven = API `polycount`; the site labels this "tris" (metal_office_desk: 6898 in the API, "7K tris" on the page) [S]. Blendkit = `faceCount` param, may be quads. Flag: >100k tris = needs decimation.

## 0. Answer first
- **Two families win:** **Poly Haven (CC0)** for furniture, office, street and surfaces, plus **Sketchfab CC-BY 4.0** for boxing and gym kit. Sketchfab offers glTF as the standard export for every downloadable model [S https://sketchfab.com/features/gltf]. [J]
- **Coverage (37 rows):** 29 have a usable free model, 2 are partial (only the shelf or rack exists), and 6 are NOT FOUND. Missing sub-parts: the heavy-bag ceiling rail and the shop sign. [J]
- **No CC0 boxing gear on Sketchfab:** every ring, bag, glove and headgear hit was CC-BY 4.0 (API search, 3 pages per query). The only CC0 boxing gear is on Blendkit: Vintage boxing gloves and Facesaver headgear, both heavy and .blend-only [S]. [J]
- **Biggest gaps:** speed bag + platform, double-end bag, teardrop/uppercut bag, slip rope, boxing round timer and plyo box. Send these to image-to-3D. Rail, mirror and rollers are easy primitives. [J]
- **Style risk:** the Sketchfab picks come from about 20 authors. Unify them with one material pass (worn leather, black steel, matte paint). Prefer author clusters: maxsbond.work (bag + gloves) and Sousinho (treadmill, bench, hook rack, exam table, frames). [J]
- **Licence risk:** brand names in model titles ("Assault Bike") are trademarks. Remove logos and use generic names in-game. [J]

## 1. Prop table
| Prop | Best free model (name + URL) | Licence | Format | Tris | Style | Second choice (name + URL + licence) |
|---|---|---|---|---|---|---|
| Ring (16 ft, 4 ropes, pads, platform, steps) | Professional Boxing Ring, A1905 https://sketchfab.com/3d-models/professional-boxing-ring-a2b5a268fc5149e78ccf4bbe2a64b399 [S] | CC-BY 4.0 | glTF (SF export) | 447,634, decimate | realistic [J] | BOXING RING, dilan https://sketchfab.com/3d-models/boxing-ring-b7deecd8ae654bfbb61f07364b58639d CC-BY 4.0, 74,426 [S]. Neither checked for 16 ft or rope count: rescale to 4.88 m [J] |
| Heavy bag + chain + ceiling rail | Vintage / Old punching bag, maxsbond.work https://sketchfab.com/3d-models/vintage-old-punching-bag-487e01cd3eea41c8a49062956c79eb66 [S]. Rail NOT FOUND: use a black I-beam primitive [J] | CC-BY 4.0 | glTF | 44,472 | realistic, worn leather [J] | Punching Bag/Boxing Bag, CAL21 https://sketchfab.com/3d-models/punching-bagboxing-bag-6b195883ada144d0a5d92f7ddcdfaf05 CC-BY 4.0, 54,816 [S] |
| Teardrop / uppercut bag | NOT FOUND (SF "uppercut bag", "maize bag", "teardrop bag": 0 relevant hits) [S] | - | - | - | - | image-to-3D |
| Double-end bag | NOT FOUND (SF "double end bag" / "double end ball boxing": 0 relevant hits) [S] | - | - | - | - | image-to-3D |
| Speed bag + wall platform | NOT FOUND realistic. SF "Speedbag" (rodgercarr13601) thumbnail shows a figure, not a speed bag [J]. Poly Pizza "Speedbag" is low-poly [S https://poly.pizza/search/boxing] | - | - | - | - | image-to-3D. Platform = wood board + bracket primitive [J] |
| Wall mirror | Wall Mirror, rickmaolly https://sketchfab.com/3d-models/wall-mirror-6177cc5abd5746a4b5ff6986b8b81edc [S] | CC-BY 4.0 | glTF | 1,626 | realistic [J] | Primitive: frameless plane + ReflectionProbe. A gym mirror is a flat panel, so this may suit better [J] |
| Treadmill | Treadmill Machine, Sousinho https://sketchfab.com/3d-models/treadmill-machine-faed3a2a275b4fd68089e1d8bdfb7f89 [S] | CC-BY 4.0 | glTF | 6,106 | realistic | Treadmill Tunturi T85, dima051983 https://sketchfab.com/3d-models/treadmill-tunturi-t85-327b6f6cb02c41df99a8d6f6b0796a74 CC-BY 4.0, 5,112 [S] |
| Air bike | Assault Bike, msertybif https://sketchfab.com/3d-models/assault-bike-cee7ae6b7b25493e82bf783a6bceef9a [S]. Brand name: strip logos [J] | CC-BY 4.0 | glTF | 27,576 | realistic [J] | None. SF "Air Bike" (aeliseev) is a sci-fi hover bike, rejected [J] |
| Dumbbell rack + dumbbells | Weight Room Set 2, Tytan https://sketchfab.com/3d-models/weight-room-set-2-fa481412927e43dfbeab9f6da464c15b [S] | CC-BY 4.0 | glTF | 5,172 | realistic, simple [J] | Dumbbell Rack, MH https://sketchfab.com/3d-models/dumbbell-rack-868439c605cf441e83d54a5fcfd64ab6 CC-BY 4.0, 10,182 [S] |
| Flat bench | Flat Bench, Sousinho https://sketchfab.com/3d-models/flat-bench-b56ab6e2b50246c88c7f72a4f16fc857 [S] | CC-BY 4.0 | glTF | 10,687 | realistic | Weight Bench, Kroko.blend https://sketchfab.com/3d-models/weight-bench-7d3f36991a0c41daa7b142a82fc10a3c CC-BY 4.0, 5,256 [S] |
| Kettlebells | Old Iron Kettlebell, tomarranskinner https://sketchfab.com/3d-models/old-iron-kettlebell-7bd9ef79fda142f98e224ef57996312b [S] | CC-BY 4.0 | glTF | 4,000 | realistic | "CC0 - Kettlebell", plaggy https://sketchfab.com/3d-models/cc0-kettlebell-801a68fa3ed449258bac6ee023446c15. The title says CC0 but the SF licence field says CC Attribution, so treat it as CC-BY 4.0. 2,454 tris [S] |
| Plyo box | NOT FOUND (SF "plyo box" / "plyometric box": 0 hits). "Jumping Box" (ti.ego) is a crate [J] | - | - | - | - | image-to-3D, or a box primitive + plywood texture [J] |
| Pull-up bar | BENCHK: PULL-UP BAR D9 (wall-mounted) https://sketchfab.com/3d-models/benchk-pull-up-bar-d9-20be6ad730c24514a0896a82f3217302 [S] | CC-BY 4.0 | glTF | 4,084 | realistic | Pull Up Bar (tower), clon6767 https://sketchfab.com/3d-models/pull-up-bar-f5b6dc0cd95d4430886ece65096d6f11 CC-BY 4.0, 4,682 [S] |
| Floor mats | Poly Haven "Rubber Tiles" texture on a thin box https://polyhaven.com/a/rubber_tiles [S] | CC0 | glTF/maps (PH) | box | realistic | Gym Props. Mat..., draakon_4d https://sketchfab.com/3d-models/gym-props-mat-and-push-up-equipment-4bd89c4f43374912b9421b2b127108b4 CC-BY 4.0, 10,436 [S] |
| Foam rollers + shelf | PARTIAL. Shelf: Steel Frame Shelves 01 https://polyhaven.com/a/steel_frame_shelves_01 [S]. Rollers NOT FOUND (SF/Blendkit "foam roller": 0 hits) [S] | CC0 | glTF | 4,348 | realistic | Rollers = cylinder primitives [J] |
| Slip rope + 2 posts | NOT FOUND (no search hit) [J] | - | - | - | - | image-to-3D, or Path3D rope + 2 post primitives [J] |
| Gym bench | Painted Wooden Bench https://polyhaven.com/a/painted_wooden_bench [S] | CC0 | glTF | 630 | realistic | Locker room bench, tboiston https://sketchfab.com/3d-models/locker-room-bench-14a60c19ae654f7aaf75902fb6363029 CC-BY 4.0, 484 [S] |
| Water fountain | Drinking Fountain, MooKorea https://sketchfab.com/3d-models/drinking-fountain-796e0b2660a440e3a2e8a24c6ed0fe72 [S] | CC-BY 4.0 | glTF | 35,664 | realistic | Water cooler, tboiston https://sketchfab.com/3d-models/water-cooler-4b88c4c4e94c497ca39f831f374e89fc CC-BY 4.0, 2,188 [S] |
| Round timer (wall) | NOT FOUND as a boxing timer (SF "boxing timer" / "gym timer": 0 hits) [S]. Nearest: Digital Clock, oscarherry3d https://sketchfab.com/3d-models/digital-clock-29f2859da57b491dbca907164a8014f0 CC-BY 4.0, 164 tris [S] | - | - | - | - | image-to-3D, or box + emissive Label3D [J] |
| Glove rack / open locker with gloves | PARTIAL. Wooden hook rack, Sousinho https://sketchfab.com/3d-models/wooden-hook-rack-b7928bccdd1344b79c0b67e7a9878016 [S], with the gloves below hung on it [J] | CC-BY 4.0 | glTF | 2,520 | realistic | Open locker = locker row model; whether its doors are separate is not shown [J] |
| Boxing gloves + headgear (loose) | Gloves: Vintage / Old boxing gloves, maxsbond.work https://sketchfab.com/3d-models/vintage-old-boxing-gloves-b41079124d1e420d8549d088917b1dff [S]. Headgear: Boxing headgear fbx, Chillax https://sketchfab.com/3d-models/boxing-headgear-fbx-9a43d1767d9e4296bdd0e8b51f80d20a (thumbnail untextured) [S] | CC-BY 4.0 | glTF | 115,264, decimate / 18,740 | realistic | Blendkit Vintage boxing gloves https://www.blendkit.com/asset-gallery-detail/7a526c99-4ea9-4955-822e-829bb962965f/ CC0, 257,738 faces, .blend + Facesaver https://www.blendkit.com/asset-gallery-detail/8973b1cd-2706-4fec-93cb-ab161a099caf/ CC0, 126,747 faces [S] |
| Lockers | Metal Gym/Boxing Locker, CAL21 https://sketchfab.com/3d-models/metal-gymboxing-locker-975fe97634ad4812bc3b7450e7de6efb [S] | CC-BY 4.0 | glTF | 5,998 | realistic | Metal Painted Rusty Wardrobe Lockers, Ottto3d https://sketchfab.com/3d-models/metal-painted-rusty-wardrobe-lockers-f2a7e2593f884ae4bb6aa59c575b2dc4 CC-BY 4.0, 7,104 [S] |
| Locker-room bench | Old Locker Room Bench, Garlovisuals https://sketchfab.com/3d-models/old-locker-room-bench-d0e0c591dae34724a90a4ce1f08d9a5f [S] | CC-BY 4.0 | glTF | 3,416 | realistic | Painted Wooden Bench https://polyhaven.com/a/painted_wooden_bench CC0, 630 [S] |
| Scale | Vintage Bathroom Scales, InfiniteMoose https://sketchfab.com/3d-models/vintage-bathroom-scales-dcdf315d19204fdaa08b1fe9cbce3d64 [S]. The thumbnail suggests a column scale; confirm in the viewer [J] | CC-BY 4.0 | glTF | 3,006 | realistic [J] | Scales Body weight, 星医療酸器 https://sketchfab.com/3d-models/scales-body-weight-4893e3c43f834112bd83de3e2227b3ae CC-BY 4.0, 7,990 [S] |
| Shower stall | shower-stall, debbie-s https://sketchfab.com/3d-models/shower-stall-73c889b7561d4487aa4d67547d084ae7 [S] | CC-BY 4.0 | glTF | 31,696 | realistic, plain [J] | Blendkit "Shower Corner (Shower Cabinet)", Mohammad Saeed: Royalty Free, 26,157 faces, .blend. Page not fetched, so it is search-API only [S API] |
| Physio treatment table | WULOP Massage Table, federico.scappiti https://sketchfab.com/3d-models/wulop-massage-table-44bdcb008ae94521806ee2808f673f6f [S] | CC-BY 4.0 | glTF | 60,967 | realistic | Post apocalyptic examination table, Sousinho https://sketchfab.com/3d-models/post-apocalyptic-examination-table-41c14888e60b4910bd5edddf5d0d16c6 CC-BY 4.0, 7,260 [S] |
| Ice bath tub | Ice Bath, explosivemonkey9 https://sketchfab.com/3d-models/ice-bath-d910e70043214b35a5a2430f12a78f59 [S] | CC-BY 4.0 | glTF | 99,989, borderline | realistic | Vintage Metal Bathtub FREE Low Poly, Lady Lion Studios https://sketchfab.com/3d-models/vintage-metal-bathtub-free-low-poly-d06c028a89a54c469e4af9cac50606fa CC-BY 4.0, 4,100 [S] |
| First-aid cabinet | Wall mount first aid kit, AlexKurts https://sketchfab.com/3d-models/wall-mount-first-aid-kit-e6177c57f52e4e76970d1349472a21eb [S] | CC-BY 4.0 | glTF | 1,126 | realistic | Medical Box https://polyhaven.com/a/medical_box CC0, 3,718 [S] |
| Reception desk + bell | Desk: Reception Desk, Yvonne DeBandi https://sketchfab.com/3d-models/reception-desk-d23cfdf8128345d7b886ebb9affad2e8 [S]. Bell: Reception Bell. Wood, shiny copper, Rylae Shylna https://sketchfab.com/3d-models/reception-bell-wood-shiny-copper-5d754602e590417b889e500a06b67146 [S] | CC-BY 4.0 | glTF | 600 / 2,308 | realistic | Metal Office Desk (PH, CC0) as the counter [J] + Blendkit Antique Reception Desk Bell https://www.blendkit.com/asset-gallery-detail/568fd8b6-f080-4175-bf95-65bddd097bc8/ Royalty Free, 8,854 faces [S] |
| Office desk + chair | Metal Office Desk https://polyhaven.com/a/metal_office_desk + Modern Arm Chair 01 https://polyhaven.com/a/modern_arm_chair_01 [S] | CC0 | glTF | 6,898 / 8,916 | realistic | Office Chair, artvolodskikh https://sketchfab.com/3d-models/office-chair-a7fefb5dde954c84896949246dde5be6 CC-BY 4.0, 5,488 [S] |
| Filing cabinet | Filing Cabinet - 6MB, Mehdi Shahsavan https://sketchfab.com/3d-models/filing-cabinet-6mb-d217a4bbdfa2426eb32ebf3b1007a8c3 [S] | CC-BY 4.0 | glTF | 6,806 | realistic | Blendkit File cabinets, Free poly https://www.blendkit.com/asset-gallery-detail/0d9f69aa-2758-4fe9-a5ce-bb16882880ed/ CC0, 4,882 faces, .blend [S] |
| Framed photos / posters / belts | Hanging Picture Frame 01 https://polyhaven.com/a/hanging_picture_frame_01 (CC0, 2,586) [S] + belt: Championships belt, wrestling, early 20th C, urheilumuseo https://sketchfab.com/3d-models/championships-belt-wrestling-early-20th-c-6941903a55824949bf46eec776eb0893 (CC-BY 4.0, 72,398) [S] | CC0 + CC-BY 4.0 | glTF | see cell | realistic | Picture frame collection, Sousinho https://sketchfab.com/3d-models/picture-frame-collection-987f8659bdd34549955c38ea1f4a6fe9 CC-BY 4.0, 412 [S]. Skip the WWE-branded belts [J] |
| TV (office) | Television 02 (CRT) https://polyhaven.com/a/television_02 [S] | CC0 | glTF | 2,310 | realistic | Television 01 https://polyhaven.com/a/Television_01 CC0, 1,918 [S] |
| Street: sidewalk + road | PH textures Worn Asphalt https://polyhaven.com/a/worn_asphalt + Concrete Pavement https://polyhaven.com/a/concrete_pavement on planes / curb boxes [S] | CC0 | maps | planes | realistic | Sidewalks, Caboose3d https://sketchfab.com/3d-models/sidewalks-367535935e694b84a539216b5b474074 CC-BY 4.0, 1,567 [S] |
| Street: shop-front facade + sign | Modular Urban Apartments Facade https://polyhaven.com/a/modular_urban_apartments_facade + Rollershutter Door https://polyhaven.com/a/rollershutter_door [S]. Sign NOT FOUND: use Label3D or decal [J] | CC0 | glTF | 118,215, use a subset / 1,104 | realistic | Storefronts with opening doors, Jungle Jim https://sketchfab.com/3d-models/storefronts-with-opening-doors-empty-stores-151b488b26dd4ff4b15c4c03dc0711e6 CC-BY 4.0, 60,100 [S] |
| Street: lamp | Street Lamp 01 https://polyhaven.com/a/street_lamp_01 [S] | CC0 | glTF | 30,610 | realistic | Street Lamp 02 https://polyhaven.com/a/street_lamp_02 CC0, 20,338 [S] |
| Street: parked car | Volvo 240 styled sedan car downloadable, Libau Media https://sketchfab.com/3d-models/volvo-240-styled-sedan-car-downloadable-66697669831b47cea7874fc8c4544e74 [S] | CC-BY 4.0 | glTF | 63,396 | realistic | Covered Car https://polyhaven.com/a/covered_car CC0, 12,592 [S] |
## 2. Which family covers most rows in one style
- **Poly Haven (CC0, photoreal PBR, glTF at 1k–8k):** 12 rows: mats, shelf, gym bench, office desk + chair, TV, frames, first-aid (second choice), sidewalk/road, facade, lamp, car (second choice), locker bench (second choice). It is the most consistent family, but it has no gym or boxing equipment at all: a model-list scan of about 520 assets found no bag, ring, dumbbell or treadmill [S https://api.polyhaven.com/assets?t=models]. Licence: [S https://polyhaven.com/license]. [J]
- **Sketchfab CC-BY 4.0:** fills about 22 rows (all boxing and gym gear, locker room, physio, reception), and every model comes as a glTF download [S]. It is not one family: the authors vary, so set texel density and roughness consistently on import. Cleanest clusters: **maxsbond.work** (bag + gloves, worn vintage leather) and **Sousinho** (treadmill, flat bench, hook rack, exam table, frames, plus a "Rusted old taxi" https://sketchfab.com/3d-models/rusted-old-taxi-a31187a1168b400594e2a4f21b6cb418, CC-BY 4.0, 18,108). [J]
- **Recommended combo:** Poly Haven for everything it has, and Sketchfab CC-BY for gear. Then do one shared material pass (red paint, grey concrete, black steel, worn leather). [J]
- **Oxygen3D "GAME READY GYM ENVIRONMENT ASSET PACK"** https://sketchfab.com/3d-models/game-ready-gym-environment-asset-pack-8aef4a478bbe49d483280968aff59064 (CC-BY 4.0, 19,756 tris in total; lists 3 rings, 5 punching bags, treadmill, bike, kettlebells, mats [S]). It is the only single pack covering about 10 gym rows, but the thumbnail looks untextured and low-poly, so it is stylised. Rejected. [J]
- **Kenney** (CC0, e.g. City Kit Commercial https://kenney.nl/assets/city-kit-commercial [S]), **Quaternius** (CC0, Modular Streets / Ultimate Home Interior https://quaternius.com/packs/modularstreets.html [S]), **Poly Pizza** and **KayKit (itch.io)** are all low-poly toy style and have no boxing gear. Rejected for this look. [J]
- **Blendkit (formerly BlenderKit):** free assets are "Royalty Free" (commercial use allowed, no reselling the asset itself) or CC0 [S https://www.blendkit.com/docs/licenses/]. Good realistic second choices, but they are .blend files that need the add-on and an account, then a glTF export from Blender. [J]
- **Godot Asset Library** (gym / boxing / fitness / street / office searches) returned no 3D props [S, API 2026-10-08]. **OpenGameArt** 3D boxing / gym / treadmill searches found nothing usable [S]. [J]

## 3. NOT FOUND rows: send to image-to-3D
1. Teardrop / uppercut bag (worn leather, chain).
2. Double-end bag with floor and ceiling cords.
3. Speed bag + wooden rebound platform (Gleason's style).
4. Slip rope + 2 posts (primitives work too).
5. Boxing round timer (wall, red/green LEDs). A box + Label3D primitive also works.
6. Plyo box (a primitive works too).
- Sub-parts with no model: the heavy-bag ceiling rail (black I-beam primitive), foam rollers (cylinders), the shop sign (Label3D/decal) and a dedicated glove rack (use the hook rack). [J]

## 4. Credits block (CC-BY 4.0 picks; format: "Title" by Author, URL, CC BY 4.0, http://creativecommons.org/licenses/by/4.0/)
Sketchfab licence slug `by` = http://creativecommons.org/licenses/by/4.0/, "Author must be credited" [S https://api.sketchfab.com/v3/licenses]. Author names below are as shown on Sketchfab.
- "Professional Boxing Ring" by A1905: https://sketchfab.com/3d-models/professional-boxing-ring-a2b5a268fc5149e78ccf4bbe2a64b399
- "Vintage / Old punching bag" by maxsbond.work: https://sketchfab.com/3d-models/vintage-old-punching-bag-487e01cd3eea41c8a49062956c79eb66
- "Vintage / Old boxing gloves" by maxsbond.work: https://sketchfab.com/3d-models/vintage-old-boxing-gloves-b41079124d1e420d8549d088917b1dff
- "Boxing headgear fbx" by Chillax: https://sketchfab.com/3d-models/boxing-headgear-fbx-9a43d1767d9e4296bdd0e8b51f80d20a
- "Wall Mirror" by rickmaolly: https://sketchfab.com/3d-models/wall-mirror-6177cc5abd5746a4b5ff6986b8b81edc
- "Treadmill Machine" by Sousinho: https://sketchfab.com/3d-models/treadmill-machine-faed3a2a275b4fd68089e1d8bdfb7f89
- "Flat Bench" by Sousinho: https://sketchfab.com/3d-models/flat-bench-b56ab6e2b50246c88c7f72a4f16fc857
- "Wooden hook rack" by Sousinho: https://sketchfab.com/3d-models/wooden-hook-rack-b7928bccdd1344b79c0b67e7a9878016
- "Assault Bike" by msertybif: https://sketchfab.com/3d-models/assault-bike-cee7ae6b7b25493e82bf783a6bceef9a
- "Weight Room Set 2" by Tytan: https://sketchfab.com/3d-models/weight-room-set-2-fa481412927e43dfbeab9f6da464c15b
- "Old Iron Kettlebell" by tomarranskinner: https://sketchfab.com/3d-models/old-iron-kettlebell-7bd9ef79fda142f98e224ef57996312b
- "BENCHK: PULL-UP BAR D9" by BenchK: https://sketchfab.com/3d-models/benchk-pull-up-bar-d9-20be6ad730c24514a0896a82f3217302
- "Drinking Fountain" by MooKorea: https://sketchfab.com/3d-models/drinking-fountain-796e0b2660a440e3a2e8a24c6ed0fe72
- "Metal Gym/Boxing Locker" by CAL21: https://sketchfab.com/3d-models/metal-gymboxing-locker-975fe97634ad4812bc3b7450e7de6efb
- "Old Locker Room Bench" by Garlovisuals: https://sketchfab.com/3d-models/old-locker-room-bench-d0e0c591dae34724a90a4ce1f08d9a5f
- "Vintage Bathroom Scales" by InfiniteMoose: https://sketchfab.com/3d-models/vintage-bathroom-scales-dcdf315d19204fdaa08b1fe9cbce3d64
- "shower-stall" by debbie-s: https://sketchfab.com/3d-models/shower-stall-73c889b7561d4487aa4d67547d084ae7
- "WULOP Massage Table" by federico.scappiti: https://sketchfab.com/3d-models/wulop-massage-table-44bdcb008ae94521806ee2808f673f6f
- "Ice Bath" by explosivemonkey9: https://sketchfab.com/3d-models/ice-bath-d910e70043214b35a5a2430f12a78f59
- "Wall mount first aid kit" by AlexKurts: https://sketchfab.com/3d-models/wall-mount-first-aid-kit-e6177c57f52e4e76970d1349472a21eb
- "Reception Desk" by Yvonne DeBandi: https://sketchfab.com/3d-models/reception-desk-d23cfdf8128345d7b886ebb9affad2e8
- "Reception Bell. Wood, shiny copper" by Rylae Shylna: https://sketchfab.com/3d-models/reception-bell-wood-shiny-copper-5d754602e590417b889e500a06b67146
- "Filing Cabinet - 6MB" by Mehdi Shahsavan: https://sketchfab.com/3d-models/filing-cabinet-6mb-d217a4bbdfa2426eb32ebf3b1007a8c3
- "Championships belt, wrestling, early 20th C" by urheilumuseo: https://sketchfab.com/3d-models/championships-belt-wrestling-early-20th-c-6941903a55824949bf46eec776eb0893
- "Volvo 240 styled sedan car downloadable" by Libau Media: https://sketchfab.com/3d-models/volvo-240-styled-sedan-car-downloadable-66697669831b47cea7874fc8c4544e74
- Any second choice that gets used needs the same line format (names and URLs are in Section 1). Poly Haven and Blendkit CC0 models need no credit.

## 5. Limits
- Style was judged from 256 px thumbnails only. Nothing was downloaded or imported into Godot, so scale, pivots, materials and rope count are unverified. [J]
- Sketchfab downloads need a logged-in account. The real glTF file size and texture resolution were not checked. Results came from relevance search (3 pages × 24 per query), so better models may exist further down. [J]
- The Sketchfab `license=cc0` search filter returned 0 results for every query, so licences were filtered locally from the result fields. Each pick's licence was re-checked through `/v3/models/<uid>` [S]. [J]
- Author names are Sketchfab display names. Re-check the model page before shipping, because authors can change their licence. [J]
- Fab and Unity Store were not searched (prior research covered paid packs). Blendkit "Shower Corner" was seen in the search API only; its page was not fetched. [J]

---

That's the whole document. A copy is on my computer at `/workspace/j65/J65_FREE_MODELS_NEW_CLUB.md`, so Claude can land it as `research/J65_FREE_MODELS_NEW_CLUB.md`.
