# ROOMS3CD digest - office and physio (S234)

Implementation delivered on `codex/rooms3cd` for review. **Visual acceptance remains OPEN:** Claude opens every still; the operator closes it. No other repository task was taken.

## Result

- Office: warm parquet with a wear path, dark ash wainscot/cream plaster on inside wall faces, central 3000 K pendant, 2700 K desk light and restrained CRT bounce. Arena photograph, tactical chart, belt and supplemental portraits are visible from the game camera.
- Physio: sanitary wall tile, mosaic floor and brass drain, two 4000 K flush troughs, anatomy chart and readable cold-immersion warning. The existing infrared model has a ruby lower lens/rim material correction; its enamel hood, metal stand and source GLB are retained.
- Existing 13 approved floor models retained at their established fitted heights/yaws; layout measured on their loaded bounds rather than Ludo's nominal dimension table. All sit at the floor surface (y=.04). Office desk/chair moved forward; physio lamp/stool moved to front corners and skeleton behind the treatment table, opening the centre aisle. Floor labels are clear.
- The manager and shipped MetaHuman coach stand clear of the furniture. `coach_home=[1.65,18.0]` accounts for the existing live staff +1.3 m Z offset. The office visitor endpoint is now `[4.5,19.0]` on the clear approach.
- Wall skins inherit the existing cutaway wall transforms. No skin or graphic is mounted on the z=18 hall wall. Light masks are exactly office `1<<16` and physio `1<<19`; room visitors gain/shed only the relevant bit. Existing bounded reflection probes remain.
- Existing click routes retained; the test now checks the exact target ID as well as its route. No new gameplay screen, feature switch or generated model.
- Verdict HUD item 6 was already present on the fetched baseline: room info has a backing plate and the back chevron is separate. It was inspected and retained. New graphics were moved clear of the existing training controls; a ceiling housing can remain partly behind that overlay.

## Evidence and gates

Baseline: fetched/rebased `origin/master` at `4e60a89f9391049c8e0f9804aa5977765726482a`, before production edits. Supplied S234 stills were first inspected from the main checkout because the seeded worktree lacked them; fresh before captures came from this baseline.

- Shell RED: **121/139, 18 failures**, missing authored shells/lights/signs/visitor layers and buried floor labels. Original containment/overlap/doorway/route checks passed. Receipt: [red_gate.txt](../docs/previews/rooms3cd/red_gate.txt).
- Loaded path RED: **172/177**, inaccessible office chair/TV and physio lamp/tub/skeleton. Receipt: [walkpath_red.txt](../docs/previews/rooms3cd/walkpath_red.txt).
- Live staff RED: **203/204**, coach intersecting the moved desk. An OFF-control fixture initially passed and was rejected as evidence; the final fixture explicitly enables shipped MetaHuman staff. Receipt: [actor_red.txt](../docs/previews/rooms3cd/actor_red.txt).
- Final parse: all six scripts passed, with the later graphic edits reparsed. Final bounded suite: **8 tests, 0 failures; office/physio 204/204**. Receipts: [green_gate.txt](../docs/previews/rooms3cd/green_gate.txt), [green_rooms.txt](../docs/previews/rooms3cd/green_rooms.txt).
- Walking gate floods a 0.9 m footprint on a .1 m grid, includes .10 m inside finish clearance, and requires approach within .65 m of every loaded floor prop. It is a geometric access gate, not a claim of exported-player navigation automation.
- All eight before/after JPGs are 1920x1080, from `club_room_still.gd -- as_game gym3d_main gym4_club`, hidden desktop only. Both final rooms report `props_in_frame=true`. Office camera auto-fit is 68 degrees; physio 64 degrees. No camera/harness edits.
- Render logs contain no SCRIPT ERROR. Baseline-equivalent shutdown texture/ObjectDB/resource warnings remain; they are not treated as a rendering failure or silently represented as a clean log. Raw PC logs: `E:/FightCamp/tmp/rooms3cd/office_final.log` and `physio_final.log`.
- Independent source/image review found the live-coach collision, omitted wall thickness in route margins and route-only click assertions. All three were corrected. Final review: no remaining important defects; packaged executable behavior and unrelated staff/HUD design were not reviewed.

Required bounded gate (never the broad `--only room` filter):

```text
python Godot/tools/run_tests.py --jobs 2 --only rooms_office_physio,club_rooms_split,gym_club_3d,gym_club_layout,office_room,reception_desk,equipment_store,locker_room
```

## Visual review

[Ops-board review](http://127.0.0.1:8787/review), batch `2026-10-16_2335_rooms3cd_office_and_physio_before_after_`: eight files with room-form captions. The review manifest lives at `E:/FightCamp/review/2026-10-16_2335_rooms3cd_office_and_physio_before_after_/manifest.json`. Every source still was opened through the file-image tool; no image viewer/window was opened on the operator's desktop.

### [before_office/01_mid.jpg](../docs/previews/rooms3cd/before_office/01_mid.jpg)

BEFORE OFFICE - Frame: whole gym and front rooms, original office layout at lower left. Clipping/floating: fine prop contacts cannot be judged at this distance. Path: hall/front aisle visibly open; internal office routes require the loaded-mesh gate. Dark zones: flat room shell, shaded furniture backs. HUD: floor information, goals and training controls remain readable.

### [before_office/02_office.jpg](../docs/previews/rooms3cd/before_office/02_office.jpg)

BEFORE OFFICE - Frame: seven approved furniture models and old wall frames, plain shell. Clipping/floating: no obvious gross overlap in this view; loaded path gate later exposes inaccessible chair/TV. Path: doorway clear but rear approaches constrained. Dark zones: dark safe/credenza and no layered wall/floor finish. HUD: backing plate and separate back chevron already present; floor room label is buried under the chair.

### [before_physio/01_mid.jpg](../docs/previews/rooms3cd/before_physio/01_mid.jpg)

BEFORE PHYSIO - Frame: whole gym and front rooms, original narrow physio room. Clipping/floating: fine contacts cannot be judged at this distance. Path: hall/front aisle visibly open; interior access not established by this overview. Dark zones: plain physio shell with shaded props. HUD: floor information, goals and training controls readable.

### [before_physio/02_physio.jpg](../docs/previews/rooms3cd/before_physio/02_physio.jpg)

BEFORE PHYSIO - Frame: six approved props in plain walls/floor, cream lamp lens. Clipping/floating: rear props visually crowded; loaded route check later fails lamp/tub/skeleton access. Path: door strip clear, rear approach constrained. Dark zones: insufficient differentiation behind dark table/tub. HUD: backing and back chevron already separate; floor name under skeleton.

### [after_office/01_mid.jpg](../docs/previews/rooms3cd/after_office/01_mid.jpg)

AFTER OFFICE - Frame: whole gym/front rooms, warm finished office at lower left and clinical physio near centre. Clipping/floating: no new gross overlap visible; fine contacts checked in room close-ups. Path: gym/front aisle remains open. Dark zones: no obvious new office-window spill on the hall; existing strength-area shade remains. HUD: floor information/goals/training controls readable.

### [after_office/02_office.jpg](../docs/previews/rooms3cd/after_office/02_office.jpg)

AFTER OFFICE - Frame: all seven furniture models, central desk, parquet/beadboard, pendant, arena photograph, belt, tactical chart and wall portraits. Clipping/floating: no obvious furniture-wall intersections or floating; both live staff clear the desk. Path: front entry and side approaches visible; loaded 0.9 m route gate covers all seven props. Dark zones: safe/TV/credenza shaded but identifiable; warm desk and floor. HUD: backing and chevron clear; floor name unobstructed; new wall graphics clear of training controls.

### [after_physio/01_mid.jpg](../docs/previews/rooms3cd/after_physio/01_mid.jpg)

AFTER PHYSIO - Frame: whole gym/front rooms with tiled physio and finished office. Clipping/floating: no new gross overlap visible; fine contacts require the room view. Path: hall/front aisle remains open. Dark zones: no obvious new clinical-light spill on the gym floor; existing distant shade remains. HUD: floor information/goals/training controls readable.

### [after_physio/02_physio.jpg](../docs/previews/rooms3cd/after_physio/02_physio.jpg)

AFTER PHYSIO - Frame: all six furniture models, tiled shell, two flush troughs, anatomy chart, red cold-immersion warning and brass drain. Clipping/floating: no obvious wall/prop intersections or floating; red lower lamp lens/rim retains the cream enamel hood. Path: open centre aisle from door to treatment/rear props; loaded 0.9 m gate covers all six. Dark zones: tub/table are intentionally dark but ice, cushion silhouette and cabinet supplies remain visible. HUD: backing and separate chevron clear; floor name and warning unobstructed; training controls overlap part of a ceiling housing, not the treatment props.

## Assets, cost and rulings

**0 Ludo credits spent / 25 maximum.** No model regeneration was needed for a demonstrated D-rule failure on the room camera; the lamp material correction was explicitly allowed. Cabinet supplies, tub ice, safe controls, CRT silhouette, chair and skeleton remain readable in the submitted views. No model binary or import sidecar churn.

The arena image is a Library of Congress period photograph of **preparing Madison Square Garden in 1916**, not a claim that it depicts a live fight. This documented substitution provides real period imagery without inventing provenance. The caption identifies the venue/year. Original vector diagrams and reused belt/staff images are listed in [graphics provenance](../assets/textures/rooms3cd/PROVENANCE.md); the lamp override is recorded in [physio provenance](../assets/models/club/physio/provenance.json). Portable textures include their compressed pixel buffer and require no editor-wide import.

Task-specific rulings: followed the supplied task as the implementation plan; the room-form visual checklist superseded the generic boxing-pose checklist; the named eight-test ceiling superseded the generic full-suite habit. Watchdog preceded every engine launch via the scratch wrapper; all launches used `godot_hidden.ps1`. Two-worker suites started on GREEN, but the final receipt audit found later individual launches at AMBER (77-78 C); the wrapper allowed AMBER without reducing concurrency. The final evidence therefore includes a complete repeat of the same eight-test filter with **jobs 1**. Focused diagnosis also used jobs 1. No full suite, editor import, visible window, main-checkout edit or merge into master.

Master was fetched before each club-script/layout commit and inspected for overlapping owned-path changes; none required integration. Other agents' files were not staged. Claude retains integration and operator-review ownership; no acceptance/closure claim or other HANDOFF block was written.

## Commits and handoff

- `86421dd1` red shell checks and baseline captures.
- `97c139a8` office shell, graphics and bounded practical lighting.
- `6dfb1fec` loaded-mesh route regression gate.
- `b0dba5b1` physio shell, signs and ruby lamp material.
- `ff86fe16` furniture approaches, floor placement and live staff clearance.
- `493a6271` final wall-graphic visibility and four after captures; final gates run on this source.
- This digest, gate receipts and AgentComms note follow in a documentation commit on the same branch. Each step is pushed to `origin codex/rooms3cd`.

Claude handoff: [AgentComms note d570d5deba30](../../AgentComms/messages/20261016T203805Z_codex_to_claude_rooms3cd-review-ready-office-and-phy_d570d5deba30.json), followed by the [serialized-gate receipt correction](../../AgentComms/messages/20261016T204303Z_codex_to_claude_rooms3cd-final-receipt-correction-se_0d0054dd9833.json). The final jobs-1 repeat passed all eight tests and room 204/204; all eight current logs have RC=0 and no SCRIPT ERROR.

Next session prompt (Claude owns integration/review; if resumed in the PC Codex seat, use the task-specified **gpt-6-astra, high**):

> Review only ROOMS3CD on origin/codex/rooms3cd. Read research/ROOMS3CD_DIGEST.md and TASK_ROOMS3CD.md, inspect the diff and all eight before/after stills in the S234 review batch, and verify green_gate.txt/green_rooms.txt. Local engine gates are evidence, not operator visual acceptance. Keep ROOMS3CD visual acceptance OPEN until the operator responds. Preserve concurrent master work when integrating.


## ROOMS3CD round 2 / S235 - implementation delivered, visual acceptance OPEN

Task: `TASK_ROOMS3CD2.md`. Worktree `E:/FightCamp/wt/ROOMS3CD`, branch `codex/rooms3cd`. Clean merge of `origin/master` at `12480aae` includes round 1 collected as `1f4a7c3f`. Final implementation source: `7a51c9b6`. All five requested fixes were implemented in order with a separate commit and push after each. Independent review and the actual physio still then drove three additional scoped correction commits. No merge into master; Claude collects by diff.

All four operator `marked.png` files were opened from `E:/FightCamp/Game/Feedback/2026-10-17-01` through `-04`. The original toolkit path was read before work. No paid generation or visible Godot window was used.

### Changes and why

1. **Shared room cutaways.** `GymClub3D._build_building/_build_line` constructs the wall segments; `ClubRoomBase._update_wall_fade` uses the actual room Camera3D. Chose a 30 cm opaque stub with its box top edge instead of ghosted alpha: the floor boundary stays readable without a transparent slab covering the furniture. Wall finishes inherit the same cut. Room-edge/centre seams let near portions of side walls cut independently while rear portions remain solid. Unrelated walls require a finite eye-to-centre intersection; the diagonal camera witness no longer cuts the unrelated X=24.6 partition. Camera-pose caching avoids rebuilding the sightline traversal when the view is unchanged. Four camera sides are exercised for all five rooms.
2. **Eleven open door assemblies.** Shared `ClubRoomDoor.gd` makes jambs, lintel, panelled leaf, handle and hinge plates. Leaves stand open 100 degrees; physio is white, other doors use oak/brass colours. Existing route targets use the aperture. Doors stay opaque during room cutaways. Prefab check and rights are in `assets/models/club/PROVENANCE.md`: Ludo r65/current inventory, Kenney CC0 and Poly Haven CC0 did not provide a suitable independently hinged assembly. Original procedural geometry uses the repository project licence. Corridor review found blocked approaches: both hall openings moved Z=11 to 11.4; locker hall and office side hinges were mirrored. Both 0.9 m corridor floods now pass and leaves clear the corridor end walls.
3. **Facings.** Filing cabinet yaw -90 degrees, CRT +90, and the medical cabinet -90. Nine directional props have calibrated model-local fronts tested within 60 degrees of the room centre. Filing cabinet moves 25 cm deeper for the door and 1 cm inward after rotation; other working furniture positions remain covered by the loaded-mesh checks.
4. **Stool/bin separation.** The original single welded `physio_stool_bin.glb` is retained unchanged. `Tools/blender/rooms3cd_split_stool_bin.py` splits and caps its fused contact, preserving UVs/materials, into separate stool and bin assets. Source/output hashes are in `physio/stool_bin_separation.json`. Stool at [16.45,18.65], bin at [16.7,19.5], cabinet Z=20.2. Measured bounding-box gap **0.278 m**, minimum 0.25 m. Every data-prop pair in office/physio gets a volumetric overlap check, including wall attachments. Floor overlap tolerance is 0.0001 square metres. Open leaves are walking obstacles. The flood retains a 0.9 m body, 0.10 m wall margin and <=0.65 m approach; grid resolution is 5 cm so a real narrow passage is not missed by a 10 cm sampling grid.
5. **Room HUD.** Training strip, goals, cue bar and training overlays hide in an open room; the back control remains. Floor controls restore on return. FormCueBar refresh cannot bring itself back over a room. A newly reached minute-200 block stop stays hidden in the room and restores from current simulation state on return, not its entry-time visibility snapshot.

### Red lines and green lines

Red tests were run before each corresponding implementation. The first wall gate ran on the merged-master production source. Facing and spacing were first exercised sequentially before their data/asset changes. After completion, the final instruments were also replayed against **all changed existing production files from merged master `12480aae`**, with the new tests retained. This replay uses master's unchanged referenced assets; the new door script/assets are unreferenced there. A `finally` block restored all five production files byte-for-byte, with hashes recorded in [master_replay.json](../docs/previews/rooms3cd2/gates/master_replay.json). Both replay failures were assertion failures, with no SCRIPT ERROR.

Explicit merged-master replay:

```text
ROOMS_NEAR_WALL: 125/197 passed
FAIL office/tape_tv front points into room (148.39 degrees <= 60)
FAIL office/filing_cabinet front points into room (86.63 degrees <= 60)
FAIL physio/first_aid front points into room (101.05 degrees <= 60)
FAIL physio: bin is separate from fused stool mesh for measurable clearance
ROOMS_OFFICE_PHYSIO: 261/265 passed
```

Receipts: [master_wall_red.txt](../docs/previews/rooms3cd2/gates/master_wall_red.txt), [master_facing_spacing_red.txt](../docs/previews/rooms3cd2/gates/master_facing_spacing_red.txt).

First-pass red -> green history, retained under `docs/previews/rooms3cd2/gates/`:

| Gate | Red | Initial green | Receipt pair |
|---|---:|---:|---|
| Near walls | 149/164 | 164/164 | wall_red / wall_green |
| Framed doors | 0/11 | 208/208 | doors_red / doors_green |
| Facings | 241/244 | 244/244 | facing_red / facing_green |
| Independent bin/spacing | 244/245 | 317/317 | spacing_red / spacing_green |
| Room training HUD | 11/21 | 21/21 | hud_red / hud_green |

Additional review witnesses: wall segment/diagonal red 139/197; corridor red 211/214 (office leaf/end-wall collision and both routes blocked); HUD transition red 23/25 (block-stop leaks and fails to restore). Corresponding `*_review_red.txt` files are retained. Earlier test-fixture errors were corrected before these red receipts; they are not counted as regression evidence.

Final green evidence:

```text
ROOMS_NEAR_WALL: 300/300 passed
ROOMS_DOORS: 214/214 passed
ROOMS_TRAINING_HUD: 25/25 passed
BLOCK_STOP_FLOOR failures=0
ROOMS_OFFICE_PHYSIO: 329/329 passed
CLUB_ROOMS_SPLIT PASS checks=82
```

Receipts: `wall_review_green.txt`, `doors_review_green.txt`, `hud_review_green.txt`, `hud_block_green.txt`, `final_rooms_green.txt`, `final_split_green.txt`. Each named runner invocation reports `SUITE total=1 fails=0`; logs were inspected for SCRIPT ERROR, not just exit code. Parse gate passed on every touched `.gd`: GymClub3D, ClubRoomBase, ClubRoomDoor, ClubRoomLocker, ui/FormCueBar, rooms_near_wall_test, rooms_doors_test, rooms_training_hud_test, rooms_office_physio_test and club_rooms_split_test. Required final room/lifecycle runs were on the complete source `7a51c9b6`; the replay restored that exact source afterward.

Run named gates one at a time with `Godot/tools/run_tests.py --jobs 1 --only <exact_test_name> --verbose --timeout 60`; call `Tools/pc_watchdog.ps1 -Once` before **each** launch and wait on RED. All runs used the GUI sibling `Godot_v4.7.2-stable_win64.exe`, never `_console.exe`. No full suite or editor-wide import was run. Independent read-only review of source, raw receipts and physio stills found no remaining critical/important findings after the three corrections; this is not operator visual approval.

### Game-camera stills and board receipt

All 14 retained stills were opened through the file-image tool. Captures use `Tools/godot_hidden.ps1`, `club_room_still.gd -- as_game gym3d_main gym4_club room=<id>`, 1920x1080. Room fitting reported `props_in_frame=true`; no capture-camera override was introduced. Office pose (3.2,5.140314,16.65), FOV68; final physio (15.4,5.140314,16.65), FOV64; final reception (10,5.140314,16.65), FOV64. Reception's existing prop-fit camera chose a tighter pose after the old door assembly was replaced; this is a game-camera fit, not a hand-framed comparison. Room views have no training HUD; overview controls intentionally retain it.

Capture logs have no SCRIPT ERROR. Existing shutdown diagnostics remain: 7 texture RIDs, 3 ObjectDB instances and 1 resource still in use at exit. These are not described as clean shutdown logs. Source-GUI/game-camera and loaded geometry evidence only; no exported executable mouse/menu automation is claimed.

[Ops-board review](http://127.0.0.1:8787/review): **2026-10-17_0113_rooms3cd_round_2_walls_doors_facings_spa**, stage S235. `review_add.py` posted all 14 files and marked the prior round-1 batch as older. Verified all 14 copied hashes/captions against [stills.json](../docs/previews/rooms3cd2/stills.json); review endpoint returned HTTP 200. No operator approval has been received. Intermediate spacing images are explicitly labelled intermediate, not final.

Stills and direct observations (room-form visual checklist: frame, contacts, path, light, briefed defect, HUD):

- [before_office/02_office.jpg](../docs/previews/rooms3cd2/before_office/02_office.jpg): BEFORE OFFICE - Frame: office furniture and two staff visible. Contacts: no obvious gross furniture intersection. Path: empty main doorway; side walls remain tall. Light: CRT back and cabinet side dominate their silhouettes. Defect: drawers face away from the centre; CRT faces the wall; no framed main leaf. HUD: training strip, goals and cue bar cover the room.

- [before_office/01_mid.jpg](../docs/previews/rooms3cd2/before_office/01_mid.jpg): BEFORE OFFICE / FLOOR CONTROL - Frame: full gym and front rooms. Contacts: fine contacts require the room close-up. Path: hall/front aisle visible. Light: existing strength-area shade remains. Defect: overview establishes the live game camera context. HUD: training controls intentionally visible on the floor.

- [before_physio/02_physio.jpg](../docs/previews/rooms3cd2/before_physio/02_physio.jpg): BEFORE PHYSIO - Frame: tiled room, bed, tub, cabinet, lamp and fused stool/bin. Contacts: bin touches stool. Path: centre aisle visible, no framed main leaf. Light: large solid side-wall slab on the right. Defect: full-height near side portions hide the room edges. HUD: training strip, goals and cue bar visible.

- [before_physio/01_mid.jpg](../docs/previews/rooms3cd2/before_physio/01_mid.jpg): BEFORE PHYSIO / FLOOR CONTROL - Frame: full gym and front rooms. Contacts: fine contacts require the room close-up. Path: hall/front aisle visible. Light: existing strength-area shade remains. Defect: overview establishes the live game camera context. HUD: training controls intentionally visible on the floor.

- [before_reception/02_reception.jpg](../docs/previews/rooms3cd2/before_reception/02_reception.jpg): BEFORE RECEPTION - Frame: counter, bench, cabinet, coat stand and street opening. Contacts: no obvious gross prop intersection. Path: foreground aisle visible, tall side walls. Light: broad pale walls and a pale street-door-looking leaf. Defect: no consistent opaque framed open doors. HUD: training strip, goals and cue bar visible.

- [before_reception/01_mid.jpg](../docs/previews/rooms3cd2/before_reception/01_mid.jpg): BEFORE RECEPTION / FLOOR CONTROL - Frame: full gym and front rooms. Contacts: fine contacts require the room close-up. Path: hall/front aisle visible. Light: existing strength-area shade remains. Defect: overview establishes the live game camera context. HUD: training controls intentionally visible on the floor.

- [after_office/02_office.jpg](../docs/previews/rooms3cd2/after_office/02_office.jpg): AFTER OFFICE - Frame: seven furniture models, two staff and open oak doors. Contacts: no obvious furniture intersections; figures stand clear of the desk. Path: main aperture and centre floor visible; loaded 0.9 m route gate passes. Light: warm floor, shaded safe and CRT. Defect: near wall portions are low stubs, cabinet drawers and CRT face the room, framed leaves and handles visible. HUD: training controls absent; back chevron retained.

- [after_office/01_mid.jpg](../docs/previews/rooms3cd2/after_office/01_mid.jpg): AFTER OFFICE / FLOOR CONTROL - Frame: full gym and front rooms. Contacts: fine contacts require the room close-up. Path: hall/front aisle visible. Light: existing strength-area shade remains. Defect: overview establishes the live game camera context. HUD: training controls intentionally visible on the floor.

- [after_physio/02_physio.jpg](../docs/previews/rooms3cd2/after_physio/02_physio.jpg): AFTER PHYSIO - Frame: all furniture, open white door and tiled floor visible. Contacts: separate stool and bin with visible floor gap; loaded bounds measure 0.278 m. Path: clear centre aisle and open aperture; loaded 0.9 m route gate passes. Light: rear walls remain solid; near side halves are low stubs. Defect: no broad foreground slab; white leaf is edge-on beside the frame. HUD: training controls absent; back chevron retained.

- [after_physio/01_mid.jpg](../docs/previews/rooms3cd2/after_physio/01_mid.jpg): AFTER PHYSIO / FLOOR CONTROL - Frame: full gym and front rooms. Contacts: fine contacts require the room close-up. Path: hall/front aisle visible. Light: existing strength-area shade remains. Defect: overview establishes the live game camera context. HUD: training controls intentionally visible on the floor.

- [after_reception/02_reception.jpg](../docs/previews/rooms3cd2/after_reception/02_reception.jpg): AFTER RECEPTION - Frame: counter, bench, trophies, coat stand and three open oak door assemblies. Contacts: no obvious gross prop intersections. Path: open apertures and foreground floor visible. Light: solid rear wall portions and low near stubs; no dark wall band across the foreground. Defect: opaque framed leaves and handles replace the pale street panel. HUD: training controls absent; back chevron retained.

- [after_reception/01_mid.jpg](../docs/previews/rooms3cd2/after_reception/01_mid.jpg): AFTER RECEPTION / FLOOR CONTROL - Frame: full gym and front rooms. Contacts: fine contacts require the room close-up. Path: hall/front aisle visible. Light: existing strength-area shade remains. Defect: overview establishes the live game camera context. HUD: training controls intentionally visible on the floor.

- [spacing_physio/02_physio.jpg](../docs/previews/rooms3cd2/spacing_physio/02_physio.jpg): INTERMEDIATE, NOT FINAL - Frame: physio after separating the welded asset. Contacts: stool and bin have a visible floor gap. Path: white door and centre aisle visible. Light: large right side slab remains at this stage. Defect: spacing corrected before the side-wall refinement. HUD: training controls still present; compare the AFTER close-up.

- [spacing_physio/01_mid.jpg](../docs/previews/rooms3cd2/spacing_physio/01_mid.jpg): INTERMEDIATE FLOOR CONTROL - Frame: gym and front rooms after asset separation. Contacts: fine spacing cannot be judged here. Path: hall/front aisle visible. Light: existing strength-area shade. Defect: see the paired intermediate physio close-up. HUD: training controls remain visible on the floor.


### Delivery and rulings

- `0ae8530f` shared near-wall cuts; `944058ad` open doors; `6b825a97` facings; `9b5b2aca` independent stool/bin; `f03ca52a` room HUD. Each committed and pushed in task order.
- `d676b6bc` side-wall visual/diagonal correction; `f9294e91` corridor door routes; `7a51c9b6` live block-stop restoration. Each correction separately committed and pushed after its red/green gate.
- This digest, before/after captures, source hashes and final/master gate receipts follow in the evidence commit. Branch/worktree preserved for Claude's collection by diff.
- Task-specific merge instruction superseded the generic intake rebase. Named bounded gates superseded the finishing skill's full-suite suggestion. The supplied task is the plan; no approval menu/PR/merge was substituted for the user's explicit commit/push/digest workflow. Room framing/checklist supersedes the boxing-only body/nose/wrist/feet checklist. The asset CLI was unavailable; the task-authorized local Blender/toolkit path was used. No paid generation, new task, main-checkout edits, broad cleanup, or edits in the reserved GymClub3D windows (~40-60/~1540-1620).
- Visual acceptance stays **OPEN** under the task and `.claude/skills/visual-gate/SKILL.md`: "A visual change is closed by THE OPERATOR". The board evidence is ready for that decision; this digest does not close it.

Next-session prompt (task model **gpt-6-astra, high**):

> Review only ROOMS3CD round 2 on origin/codex/rooms3cd. Read TASK_ROOMS3CD2.md and the S235 section of ROOMS3CD_DIGEST.md. Inspect the diff from 12480aae, the master-red/final-green receipts and all before/after room stills in review batch 2026-10-17_0113_rooms3cd_round_2_walls_doors_facings_spa. Preserve concurrent master work when collecting by diff. Keep visual acceptance OPEN until the operator's board response. Do not treat local gates as exported-executable automation or operator approval.

## S236 round 3 - regression repair and corridor/label review

Local validation: **15/15 bounded tests passed**, plus **29/29 corridor/label checks**. Visual acceptance remains **OPEN**: Claude must open the stills; the operator closes the visual change.

### Causes and corrections

- Merged `origin/master` as `65d9fe1e` before repair; master baseline `d855a27e1d3e6ebfcee32f9e7c66777bf028adeb`. This obeys the task-specific merge instruction instead of the generic intake rebase. No merge into master.
- Furniture scans treated the entire new door assembly (both jambs plus open leaf) as a solid furniture bounding box across the aperture. Architectural meshes now use `Door_*`; empty legacy `F_door_*` interaction anchors retain routes. Crucially, the actual individual leaves participate in the reception, equipment, locker and office/physio walking checks. Furniture counts and original route thresholds were not reduced.
- The wall query used a different cut rule from rendering. Both now share the camera-side cut predicate; the original 132-check floor-view test passes at both resolutions.
- Room HUD hiding removed the fighter-information backing. The room retains backed fighter identity and the back chevron while training controls are hidden. Camera fitting waits one frame for the loaded Label3D bounds, restoring the store's gear-bay sign to the frame.
- The merged decision/load overlays also needed hiding in rooms. Hidden timed decisions now pause and resume, including cards opened while already in a room; room exit restores current state rather than an old snapshot. This has a real timed red/green witness.
- Actual-leaf review found additional blocked paths: reception street/main/office routes, the hall route outside reception, the store's 2 m aisle and the locker's second 0.9 m route. Reception main/street leaves fold outward flat; its office leaf is M45's 0.90 m leaf in the retained 1 m frame. Store and locker main leaves fold inward flat; the locker uses a right-hand hinge to clear its scale. These named 180-degree exceptions supersede the general 100-degree preference to preserve both fixed walking networks. Other leaves remain 100 degrees. Exact angle expectations changed; no clearance threshold changed.
- The dark strip is the existing 1.6 m front hall aisle, not a floor-edge face or void. A 4 mm concrete finish covers that aisle only, using exact `#8C8780`, roughness .72 and isolated fill (emission 1.5). Layer 16 excludes direct room/key lights; GI is disabled for the finish so it cannot brighten the room. Existing room materials/lights and layout are retained. Office's default camera also faces this internal hall aisle, not the exterior pavement.
- Reception, store and locker floor words moved onto exposed floor. The new test checks all five labels against leaf floor AABBs and camera rays through actual visible furniture, door frames and wall stubs. Office/physio labels retain their existing positions.

### Red/green receipts

All paths below are under `previews/rooms3cd3/gates/`. Read actual result lines; exit code zero alone is not proof.

| Gate | Red | Final green |
|---|---|---|
| equipment_store_props | `120/131`; seven furniture blockers, zero-width sweeps, camera/HUD failures | `138/138` |
| reception_club_props | `35/63`; zero-width routes and missing backing | `63/63` |
| gym_floor_view | `FAILS=10 checks=132`, hall wall queries at both sizes | `PASS checks=132` |
| room_info_hud | `16/21`; all five backing bounds | `21/21` |
| rooms_corridor_strip, master's shipped source | `3/6`; all three sampled materials fail colour, `master_strip_red.txt` | `29/29` |
| full-word camera-ray witness | `26/29`; reception/store/locker furniture obscures words | `29/29` |
| live training/overlay witness | `52/53`, then timed decision `54/56` | `56/56` |
| reception physical leaves | `43/63`; street and desk routes | `63/63` |
| reception hall leaf | `214/215`; hall route width 0 | `215/215` |
| equipment physical leaf | `137/138`; original 2 m aisle fails | `138/138` |
| locker physical leaves | `85/87`; second route 0.460 m in both booked states | `87/87` |
| folded locker/scale contact | `85/87`; left folded leaf touches scale | `87/87` |

Master replay replaced only the named source/data files, ran the independent six-check colour witness, then restored every byte and verified SHA-256 (`master_replay.json`). No master branch modification. The later 29-check all-label extension is branch red/green evidence, not falsely described as a master replay.

The final bounded command is the task's exact 15-name filter, never `--only room` or a 50-test suite. Watchdog GREEN selected `--jobs 2`; all 15 completed: `SUITE total=15 fails=0` (`final_bounded.txt`). Exact filter: `rooms_office_physio,club_rooms_split,gym_club_layout,office_room,reception_desk,rooms_doors,rooms_near_wall,rooms_training_hud,equipment_store_props,reception_club_props,gym_floor_view,room_info_hud,locker_club_props,see_through_occluders,room_camera_flow`. Separate new test: `SUITE total=1 fails=0`, `ROOMS_CORRIDOR_STRIP: 29/29 passed`. Final parse: `CHECK total=6 fails=0`. Individual result lines are indexed in `final_summaries.json`. Raw final logs are in `gates/final/`. The new corridor/label test is run separately. Additional targeted decision-card/floor-wire checks passed after the timer repair. Parse receipts cover touched GDScript before tests.

An earlier partial bounded run was cancelled when physical-leaf coverage gaps were found; it is not final evidence. A later shared-door launch was blocked before Godot by watchdog RED (85 C, CPU100%, rc75); `watchdog_blocked_doors.txt` preserves it. No other agent's editor/process was stopped. Task-private TEMP logs avoid other agents overwriting shared test receipts. Every Godot process used `godot_hidden.ps1` through a wrapper that checks the watchdog first; no visible editor/window was opened for this task.

### Strip measurements and stills

| Room | Strip mean RGB | Room-floor mean RGB | Ratio |
|---|---|---|---|
| office | (171.41, 157.44, 147.81) | (225.34, 207.49, 181.90) | **0.7754** |
| physio | (173.06, 170.00, 163.36) | (214.72, 216.06, 215.45) | **0.7836** |
| reception | (172.86, 169.56, 162.96) | (203.34, 195.49, 183.47) | **0.8679** |
| equipment_store | (173.63, 170.57, 164.25) | (177.14, 171.07, 164.42) | **0.9919** |
| locker_room | (162.35, 145.13, 133.90) | (183.38, 175.42, 164.01) | **0.8442** |

The brief explicitly requests the 0.7-0.9 image target for office, physio and reception: all three pass. Store and locker captures are supplementary label/route evidence. The store floor sample is shaded and its ratio **0.9919 is outside that band**; this is not presented as a five-room brightness pass. The common bottom-band ROI includes edge masonry in the office/locker views. Same-pixel round-2 ratios are comparisons, not proof of identical illumination after door/camera fitting changes.

RGB arithmetic is `sum(mean strip RGB) / sum(mean floor RGB)`, reproduced by `measure_strips.py`. Coordinates, unrounded values, same-ROI round-2 comparison and source hashes are retained in JSON. The bottom strip ROI is `(100,990)-(1820,1070)` at 1920x1080. Room-floor samples exclude props; reception uses the open left aisle because the folded foreground door covers the old sample. These explicit samples differ from the brief's approximate samples; no claim that its exact .28/.63 numbers were reproduced.

[Ops-board review](http://127.0.0.1:8787/review), stage **S236**: **2026-10-17_0303_rooms3cd_round_3_final_evidence**. All ten final images were opened and posted; copied hashes and captions verified against the manifest, endpoint HTTP 200. Together with the 18 diagnostic and 10 calibration images, all 38 generated stills have been opened and posted.

The diagnostic/calibration batches are explicitly superseded, never final proof. All generated stills were opened with the file-image tool and posted at stage S236, including rejected iterations. `final_stills.json` records each final source hash and a separate caption covering RGB/ratio, word readability, clipping, floating, paths, dark zones and HUD. Overview controls are labelled N/A for the room-strip ratio and fine contacts; they intentionally retain the gym training HUD. Only default game cameras (`club_room_still.gd -- as_game`) were used.

- [office](../docs/previews/rooms3cd3/ship_office/02_office.jpg): ROUND 3 REVIEW OPEN - OFFICE: strip RGB (171.41, 157.44, 147.81), room-floor ratio 0.7754; ROI coordinates in strip_measurements.json. Seven furniture models and two staff framed; YOUR OFFICE clear; staff stand clear of desks; dark safe and CRT retain readable edges. No obvious gross prop clipping or floating in this still; supported desk/bench items retained. Walking routes checked with actual leaves and unchanged clearance thresholds. Backed fighter name and back chevron visible; training/decision/load controls hidden in the room. Local game-camera evidence; operator acceptance remains OPEN.

- [physio](../docs/previews/rooms3cd3/ship_physio/02_physio.jpg): ROUND 3 REVIEW OPEN - PHYSIO: strip RGB (173.06, 170.00, 163.36), room-floor ratio 0.7836; ROI coordinates in strip_measurements.json. Bed, tub, cabinet, lamp, stool and bin framed; PHYSIO clear; stool/bin remain separated; dark tub and bed details remain readable. No obvious gross prop clipping or floating in this still; supported desk/bench items retained. Walking routes checked with actual leaves and unchanged clearance thresholds. Backed fighter name and back chevron visible; training/decision/load controls hidden in the room. Local game-camera evidence; operator acceptance remains OPEN.

- [reception](../docs/previews/rooms3cd3/ship_reception/02_reception.jpg): ROUND 3 REVIEW OPEN - RECEPTION: strip RGB (172.86, 169.56, 162.96), room-floor ratio 0.8679; ROI coordinates in strip_measurements.json. Counter, trophies, bench, coat stand and doors framed; RECEPTION clear on the left aisle; oak leaves fold beside the apertures; dark coat stand retains its silhouette. No obvious gross prop clipping or floating in this still; supported desk/bench items retained. Walking routes checked with actual leaves and unchanged clearance thresholds. Backed fighter name and back chevron visible; training/decision/load controls hidden in the room. Local game-camera evidence; operator acceptance remains OPEN.

- [equipment_store](../docs/previews/rooms3cd3/ship_equipment_store/02_equipment_store.jpg): ROUND 3 REVIEW OPEN - EQUIPMENT_STORE: strip RGB (173.63, 170.57, 164.25), room-floor ratio 0.9919; ROI coordinates in strip_measurements.json. Storage furniture and gear-bay sign framed; EQUIPMENT STORE clear; folded main leaf leaves the 2 m central aisle open; shaded bags and shelving remain readable. No obvious gross prop clipping or floating in this still; supported desk/bench items retained. Walking routes checked with actual leaves and unchanged clearance thresholds. Backed fighter name and back chevron visible; training/decision/load controls hidden in the room. Local game-camera evidence; operator acceptance remains OPEN.

- [locker_room](../docs/previews/rooms3cd3/ship_locker_room/02_locker_room.jpg): ROUND 3 REVIEW OPEN - LOCKER_ROOM: strip RGB (162.35, 145.13, 133.90), room-floor ratio 0.8442; ROI coordinates in strip_measurements.json. Lockers, bench, scale, shower and sink framed; LOCKER ROOM clear; right-hinged main leaf clears the scale and both routes; dark locker and shower details remain readable. No obvious gross prop clipping or floating in this still; supported desk/bench items retained. Walking routes checked with actual leaves and unchanged clearance thresholds. Backed fighter name and back chevron visible; training/decision/load controls hidden in the room. Local game-camera evidence; operator acceptance remains OPEN.

Capture logs retain existing exit diagnostics (7 texture RIDs, 3 ObjectDB instances and 1 resource still in use). All five final captures report `props_in_frame=true` and no SCRIPT ERROR. The suite also retains existing asset-read/shutdown warnings; passing results are not described as clean logs. Captures are serial. Reception was blocked before launch once by a second RED watchdog (86 C/CPU100%); it resumed after GREEN without rerunning the already-passing suite. This is local loaded-geometry and game-camera evidence, not exported-executable mouse/menu automation or operator approval.

### Delivery

Each implementation correction was pushed to `codex/rooms3cd`; publication records:

- `7c2ea121` fix(rooms): keep door architecture out of furniture bounds
- `361437c9` fix(rooms): share camera-side cut rule with wall queries
- `8457c9b1` fix(rooms): retain backed fighter identity while hiding training controls
- `c2e16c5d` fix(rooms): wait for label bounds before framing room camera
- `8c22eda3` fix(rooms): hide merged floor decision and load overlays in room views
- `186d85de` fix(rooms): preserve hidden decision countdowns during room visits
- `fdae571d` fix(rooms): clear reception walking routes of physical door leaves
- `bf4495b9` fix(rooms): fold reception leaves clear of both walking networks
- `5de3494a` fix(rooms): fold store and locker leaves clear of loaded routes
- `06dff91d` fix(rooms): apply folded store and right-hinged locker leaves
- `a40a138b` fix(rooms): preserve UTF-8 back chevron in staged source
- `39e445d1` docs(rooms): notify Claude of watchdog-blocked final validation
- `386ea83b` fix(rooms): give the front corridor an isolated concrete finish
- `07a0b944` fix(rooms): keep every room label clear in the game camera

Independent review found the initially omitted physical leaves, the hidden decision countdown and the locker-scale contact; those findings drove real red witnesses and production corrections. Final source/GLB review found no further actionable door issues; runtime receipts remain the authority for passing gates.

One selective index patch failed, so the strengthened equipment/locker tests were published separately (`5de3494a`) before the production fold (`06dff91d`). A Windows staging decoder changed the back-chevron byte sequence only in that commit; `a40a138b` immediately restores UTF-8. The working source and tested/captured runtime retained the correct chevron throughout. No published history was rewritten.

Task-specific bounded gates override generic full-suite habits. The supplied brief is the implementation plan; no approval menu replaces the explicitly authorized commit/push/digest workflow. No paid generation, new prefab, unrelated task, or main checkout edit. AgentComms completion note to Claude is `58832ca2e3b3`, included in the evidence commit; the earlier watchdog coordination note is `3f4f03eeeaa6`.

Next-session prompt (task model **gpt-6-astra, high**):

> Review only ROOMS3CD round 3 on origin/codex/rooms3cd. Read TASK_ROOMS3CD3.md and this S236 round-3 digest section. Inspect the diff from merge 65d9fe1e, the four original red receipts, strengthened actual-leaf witnesses, exact final 15-test gate and corridor/label result. Open every final room/control still in 2026-10-17_0303_rooms3cd_round_3_final_evidence; compare the recorded RGB ROIs and ratios. Preserve concurrent master work when collecting by diff. Keep visual acceptance OPEN until the operator responds. Do not treat local tests as exported-executable automation or operator approval.
