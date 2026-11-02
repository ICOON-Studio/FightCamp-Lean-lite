# Q227 DIGEST - office + locker room, pass 2: textured, lit, alive

Owner: Qwen (room designer seat 2, qwen3.8-max vision). Branch `qwen/q227-office-locker-pass2`.
Loop followed: ROLE_QWEN_ROOM_DESIGNER - render as-is, sheet, score, change, re-render, re-score, open every sheet.

## Owned files touched (line ranges)
- `Godot/scripts/Office3D.gd` (1103 lines): `_apply_room_fx` 88-99 (drops U204's daylight shaft - unmotivated at
  night), `_look` 102-124 (AgX/SSAO/glow/adjustment from VenueRig._add_environment), procedural PBR maps
  126-305 (`_normal_map`, `_make_wood`, `_make_plaster`, `_make_tile`, `_make_steel`, `_make_dusk`) + `_pbr` 307-322,
  `_wood_floor` 403-422 (plane top, true 2 m plank tile), `_rug` 424-436 + `_make_rug` 1039-1103 (worn Persian, was a
  flat target mat), `_ring_view` 453-508 (dusk hall: lit ring under pendants, silhouettes, dusk sky), trophy wall
  754-806 (`_cutout` 773-806 frames our own cutout art through RawAsset, no import step), `_medal_cabinet` 808-838
  (plaques = GameState.get_gym_medal_entries), camera 896-908, `_practicals` 910-922 (lamp is the key, picture lights),
  `_daylight` 924-945 (evening: sun gone, ambient 0.18, strips 0.22), tags/desk dressing 553-585, 684-692.
- `Godot/scripts/OfficeRoomPanel.gd` (220 lines): `read_office` 42-86 now carries `medals` for the cabinet.
- `Godot/scripts/LockerRoom3D.gd` (554 lines): `layout_for` 29-52 (grey preset, scale in front of the bank, board up),
  `build` 54-75 (+`_look`, +`_daylight`), `_apply_room_fx` 77-86 (no shaft in a windowless room), shell 91-172 (tile
  floor+dado with grout, plaster walls, visible strip fittings, door leaf, mats, bin), `_mat` 174-188, `_trash_bin`
  190-199, `_build_lockers` 201-253 (brushed steel PBR, handles, bigger name plates, towels on two doors),
  `_build_board` 255-282 (angled 20 deg at the camera, 62 pt list), `_build_scale` 284-346 (LED column at the FRONT,
  tag off to the side), `_build_bench_and_wash` 348-410 (bench mid-room, open kit bag with gloves, shower on the back
  wall, mirror+poster+bottles on the right wall), `_weight_poster` 497-515 (yaw param), `_daylight` 517-530
  (fluorescent-bright cool), camera 532-545 (right-front high, the concept's composition), `_practicals` 547-554.
- `Godot/tools/q227_render.gd` (new, 90 lines): renders both rooms at 1920x1080, one booked bout, `pass=`/`hide=` args.
- `previews/q227/`: office/locker `before`, `pass1..3`, `after` renders + `office_review_before/after.png`,
  `locker_review_before/after.png`.

## Rubric (1-5, evidence) - OFFICE, concept `bot_art/gym_office.jpg`
| row | before | after | evidence |
|---|---|---|---|
| SILHOUETTE | 2 | 3 | desk/window/calendar/rug/safe all where the concept puts them; desk still lighter-scale than the concept's executive desk |
| LIGHT | 2 | 4 | was flat ambient; now the desk lamp is a warm shadowed key, dusk hall spills cool blue, AgX rolls the window off |
| MATERIAL | 1 | 3 | was flat fills; now plank wood with grain+normal at 2 m tile, plaster walls, woven rug; props still boxy |
| LIFE | 2 | 3 | trophy wall (our cutouts), honours cabinet from real medal entries, papers, return; hall sparring at dusk; right half still sparse |
| CLARITY | 2 | 3 | pass-1 tags piled on the desk; now separated and small; the house door floor-decal still clips at the frame edge (house style, all rooms) |
| BAR | 1 | 2 | reads as a lit game room; not yet an Undisputed screenshot |
Two lowest before: MATERIAL 1, BAR 1 -> 3 and 2. No row down.

## Rubric - LOCKER ROOM, concept `concepts/room_locker.jpg`
| row | before | after | evidence |
|---|---|---|---|
| SILHOUETTE | 1 | 3 | was a white box floating in the void; now bank/scale/bench/shower/mats in the concept's arrangement, room fills the frame |
| LIGHT | 1 | 3 | was blown flat white; now three visible cool strip fittings over bank/bench/wash plus a scale light, SSAO contact |
| MATERIAL | 1 | 3 | was flat white; now 0.5 m tile with grout and per-tile tone, tiled dado, brushed steel lockers, rubber mats |
| LIFE | 2 | 4 | weigh-in pair on the scale with LED kg, wrap pair on the bench, open bag with gloves, towels on doors, glove racks, bottles, bins |
| CLARITY | 1 | 3 | pass-1 piled three tags on one spot and a giant door slab; tags now separated, plates legible, door reads as a door |
| BAR | 1 | 2 | reads as a wet room; figures still low-poly |
Two lowest before: SILHOUETTE/MATERIAL/CLARITY/BAR at 1 -> 3/3/3/2. No row down.

## Gates
- Parse gate on every touched .gd, each pass: clean.
- `python Godot/tools/run_tests.py --jobs 2 --only office,locker,smoke` -> `SUITE total=7 fails=0`
  (office_room, office_nav_and_profile_overlay, office_hub_panel, office_hub_api, office_former, locker_room, smoke).
- Watchdog before each heavy run: GREEN first, AMBER (RAM 85 / CPU 88) before the suite - the suite ran anyway and finished.
- No new .png/.glb on disk, so the `--import` trap never armed: all new art is procedural or read raw through RawAsset.

## Found and fixed (worth knowing)
- U204 `RoomFx.light_shaft` is a DAYLIGHT shaft; in an evening office and a windowless wet room it rendered as a
  floating translucent slab across the room. Both rooms now drop the shaft and keep the dust.
- A `PlaneMesh` lies flat in XZ: pass-2's first cutout frames hung horizontally. Framed art uses a thin BoxMesh so the
  +z face carries it upright.
- BoxMesh top-face UVs did not take the intended world scale; floors are now PlaneMesh tops over a slab.

## Not done / next pass
- Office right half is still sparse (concept's credenza wall); the desk could take the concept's double pedestal scale.
- Locker board list is small at 1080p from this camera; a closer second camera or a bigger face would fix it.
- Figures are the house rigs; no shirt on the office owner (reads odd at a desk, but he is the LIFE in the room).
