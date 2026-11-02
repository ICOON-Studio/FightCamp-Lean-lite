# TASK FLOORTPM1 - the gym floor plays like Two Point Museum: camera, rooms, people, stations, item placement (S275)

Status: CANCELLED (S358: the Game repo is read-only since the 10-28 restart in E:/FightCamp/Lean; Codex holds no task, S228)
Seat: CODEX - owner of the WHOLE GYM FLOOR (operator S275, verbatim: "no need for question assign it and lets get over with it, i expect
the animation and movement inside the gymfloor to be like 2point museum"; "codex has full rights on the project"; "access to animations
what the station do etc"). This lifts the S228 Codex freeze for this area. You may edit ANY file in the project the floor needs
(scripts, data, animations, tests, tools); the one limit is the shared-file rule at the bottom.
Worktree `E:/FightCamp/wt/ANIMSOURCE1` (folder name is historical), branch `codex/floortpm1` from master 2491c647, import cache already seeded.
Model: gpt-6-astra, high. Discipline: BOXING (the demo's club). Claude collects each step by diff the session it lands.

## How you deliver (one step at a time, in this order)
Work the steps below IN ORDER. Finish one step fully (its red-first test green, its stills taken and opened by you, its bounded gate
green), commit it on `codex/floortpm1`, `git push origin codex/floortpm1`, write a line `STEP <n> DONE <sha>` plus the RESULT lines in
your out file, then start the next step on the same branch. Claude merges each pushed step while you work the next one; merge
`origin/master` into your branch at the start of every step. If a step is blocked, write `STEP <n> BLOCKED: <why>` and go on to the next one.
Every new behaviour goes in a GAME_ON switch in `Godot/scripts/GameSwitches.gd`, read with `GameSwitches.on("<name>")` (operator S221:
everything new ships ON). Plain `--script` tests are the OFF control arm; `-- as_game` turns the switches on.

## STEP 0 - read Two Point Museum's numbers for people, animation and items (research, no game code)
The operator authorised studying his install (S243, "we are not copying anything do it"): NUMBERS AND RULES ONLY, raw dumps stay in
`E:/FightCamp/tmp/tpm_study` (never in the repo). Install: `E:/SteamLibrary/steamapps/common/Two Point Museum` (Unity 6000.0.63f1, IL2CPP).
Method that works: UnityPy 1.25.3 (installed), `UnityPy.config.FALLBACK_UNITY_VERSION = "6000.0.63f1"`, configs in
`StreamingAssets/aa/StandaloneWindows64/configs_assets_all.bundle`, `obj.read_typetree()`. Identifiers: `tmp/tpm_study/metadata_strings.txt`
(it has WalkSpeed, StepStrideLength, UseLocomotion, stateWalk, stateLocomotion, roomWalking, obstacleAvoidanceType, WalkableWidth,
HasNavigationTargetFacing). Run scans at IDLE priority (psutil nice) and never scan all 9,223 bundles - pick bundles by name.
Already measured (use, do not redo): camera `tmp/tpm_study/configs/Config_CameraLogic.asset.json`, build rules `Config_BuildLogic`,
rooms/items `rooms_full.json`, `items_full.json`, `items_placement.json` -> summarised in `research/TWOPOINT_ALIGNMENT.md`.
Find and write down: walk speed(s) by person type, run vs walk, turn rate / facing smoothing, start/stop (accel) times, path smoothing
or corner cutting, avoidance radius/type, how a person uses an item (walk to an interaction slot, turn to face, enter/loop/exit
animation, how long, idle fidgets), queueing at an item, how staff go to their job item, crowd density per cell.
Output: `research/TPM_FLOOR_NUMBERS_S275.md` - a table per topic: TPM field, value, our mapped value. Commit + push = STEP 0 DONE.

## STEP 1 - free camera (switch `free_camera`) - fixes "why the camera movement is not free and is locked behind the fighter"
TODAY (read in code by Claude S274): the floor camera has NO pan - only 3 preset zooms (`ClubRoomBase.gd:14 FLOOR_ZOOMS`,
`set_zoom` at ClubRoomBase.gd:503), `floor_close` FOLLOWS the fighter (`GymClub3D.gd:1340 _follow_fighter`), floor_view's target is fixed
data, Q/E = 90-degree turns (`GymClub3D.gd:1786`), wheel = steps between presets (`GymClub3D.gd:1740`), input in `_unhandled_input`
(`GymClub3D.gd:1676`). Keep our lens (perspective FOV 17, TASK_CAMFOV17) and the 4 wall-cut yaws (ISOWALL1, IsoWallCut.gd).
BUILD (Two Point numbers, Config_CameraLogic):
- right-drag = grab pan (PanMouseButton 1); a right click WITHOUT movement (PanMovedThreshold 0.05) stays "train there" (today's action);
- WASD/arrow pan 15 m/s scaled 0.5x (near) .. 4x (far) by zoom (PanSpeedMin/MaxZoomMultiplier);
- CONTINUOUS wheel zoom toward the cursor (ZoomSpeed 0.55, ZoomScalarSmoothTime 0.10 s), pitch offset by zoom as TPM
  (+21 deg near, 0 far - TWOPOINT_ALIGNMENT s1); the old three presets become zoom levels you can still reach, not the only stops;
- focal point smooth 0.10 s (0.02 s while grabbing), post-grab glide (PostGrabVelocityDampingTime 0.075 s);
- follow ONLY when the player asks (click a person's name/portrait or key F; FrameTrackedObjectSmoothTime 0.10 s); ANY pan breaks follow;
- focal point clamped to the building footprint (+ a 2 m margin); Q/E keep the 90-degree turn, smoothed (RotationSmoothTime 0.05 s).
TEST (red on master first): `tests/free_camera_test.gd` - OFF arm: presets as today; ON arm: a simulated right-drag moves the focal point
by the drag's ground distance (+-10%) and does NOT issue a train order; a right click without movement DOES; 10 wheel ticks give >= 8
distinct zoom heights; follow off by default and broken by a pan; focal clamped at the building edge.

## STEP 2 - rooms are areas of the one camera (switch `free_camera`) - fixes "the transition between the room is extremely bad"
Two Point has NO room mode: entering a room = the same camera glides there; front rooms stay drawn (walls cut as the camera faces them).
TODAY: `_enter_room` (ClubRoomBase.gd:1499, public `enter_room` :1628) swaps camera mode, hides the front block in floor_view, swaps
labels and the HUD = the jump the operator sees. BUILD: entering a room = a focal-point + zoom glide (0.4-0.6 s, ease in-out) to the room
on the SAME camera; the floor and other rooms stay drawn and lit; the room's HUD/info appears without the rest of the floor HUD
vanishing; leaving = glide back or simply pan away (no "exit" needed). The wall cut (IsoWallCut/IsoWallShell) keeps working at every yaw.
TEST: extend `tests/room_camera_flow_test.gd` - ON arm: entering each room keeps the same Camera3D node, its projection and FOV; the
floor's meshes stay visible; the glide takes 0.3-0.7 s with no frame where the focal point jumps > 1.5 m; OFF arm unchanged.

## STEP 3 - people walk and animate like Two Point (switch `floor_people_tpm`) - fixes "he is walking but not moving wtf"
Operator S274 playtest item 3: a floor walker plays the walk clip but stays in place. Find why (walk plan `GymClub3D.gd:842 _walk_plan`,
`_make_walker` :959, `_walker_clip` :1003, `walk_schedule` :1074, route progress :2779-2789 via ClubRoutes; GymHall3D.gd:903 pace,
:4228-4336 MH walk clip paced to walk_speed_mps). Then, with STEP 0's numbers: every person on the floor (fighter, coach, staff, walk-in
applicants) moves along a smoothed path at a speed that matches the clip's stride (no foot skate: root speed / clip stride speed within
0.9-1.1), turns smoothly (TPM facing numbers), accelerates/stops over TPM's times, avoids other people (TPM radius), and idles with small
fidgets when waiting. Coach walks, never runs (operator C106).
TEST (red on master first): `tests/floor_people_move_test.gd` - a walker given a 6 m route covers 6 m (+-0.3) in route time; root speed vs
clip stride 0.9-1.1 for every walking person type; no two people's capsules overlap for > 0.2 s in a 60 s busy day; OFF arm = today.

## STEP 4 - what the stations do (switch `floor_people_tpm`)
Two Point item use: walk to the item's interaction slot, turn to face it, enter -> loop -> exit animation for a set time, then leave or
queue. Make every boxing station work that way for fighters and coaches: heavy bag, speed bag, double-end bag, pads (coach + fighter
pair), ropes, shadow boxing / mirror, treadmill, bike, weights/racks, ring sparring. Each station gets: interaction slot(s) (position +
facing), the clip(s) it plays (the club's existing station clips; list what is missing instead of inventing motion), a duration from the
Day Plan, a queue when busy, and the effect it already has in the rules (do not change training maths). Data in `assets/data/gym_club.json`
(stations) - one entry per station, no hard-coded per-station branches.
TEST: `tests/station_use_test.gd` - every station in the hall has >= 1 slot; a fighter sent to each station ends inside its slot (<= 0.25 m)
facing it (<= 15 deg) and plays that station's clip; a second fighter queues; the station's training effect equals master's.

## STEP 5 - item placement, Two Point style (switch `build_mode`)
Rules are measured and written: `TWOPOINT_ALIGNMENT.md` s2-s4 + `scripts/rules/PlacementRules.gd` (pure module, NOT wired to the game
yet - wire it). BUILD a build mode on the floor and in every room: pick an item from a catalogue (rooms' items `gym_club.json
rooms.<id>.props` + hall stations), ghost on the cursor on the 0.5 m grid (1.0 m big platforms), stations rotate 90, decor 45, free
placement for small decor only (Tab), the invalid reason on the cursor ("Outside the gym", "Too close to the ring", "No aisle path",
"Can't afford"), 100% refund while building / 65% once used, move and sell existing items, wall items snap to wall planes. Rooms keep
their REQUIRED slots (s3 table) - a room missing one says so. People re-path around a moved item (STEP 3).
TEST: extend `tests/placement_rules_test.gd` + new `tests/build_mode_test.gd` - place/rotate/move/sell round trip, each invalid reason
fires on its case, the aisle check refuses a placement that cuts the last path to a station, money moves by the refund rule.

## Stills (every step that changes what is seen - 1, 2, 3, 4, 5)
Windowed Godot ONLY via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>` (hidden desktop; nothing on the
operator's monitors; Dummy audio - `Godot/override.cfg` is in your worktree, never commit it). Use the REAL career route:
`Godot/tools/s274_realfloor_stills.gd -- as_game` (CareerRoot + training_floor), plus `tools/isowall_stills.gd` (4 yaws) and
`tools/placement_audit.gd` (no FLOAT/AISLE/OVERLAP). Open every still yourself with your file tool and say what you see. For motion
(steps 3-4) render a short clip with `--fixed-fps 30` and check feet do not skate. Never open an image viewer, explorer or browser on
his screens. Put stills under `previews/floortpm1/step<n>/`.

## Gates
- Parse gate before any test: `python Godot/tools/check_scripts.py <touched .gd>`.
- One test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd` (NEVER _console.exe).
  The exit code alone is not a pass: read the output for SCRIPT ERROR / FAIL.
- Bounded gate per step (never the full suite, never `--only` matching > 40 tests): `python Godot/tools/run_tests.py --jobs 2 --only
  gym_floor_view,iso_camera,iso_wall_rotation,room_camera_flow,rooms_doors,rooms_near_wall,rooms_training_hud,room_info_hud,
  see_through_occluders,placement_rules,gym_club_layout,club_rooms_split,<your new tests>` + every test that names a script you touched
  (`grep -l <script> Godot/tests/*.gd`). Codex rooms round 2 shipped 4 reds because its gate was narrower than what it touched.
- PC: before any Godot run, `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`; exit 1 (RED) = wait.
  Use `--jobs 1` when it is not GREEN.

## Contract
OWNS: Godot/scripts/GymClub3D.gd, Godot/scripts/club_rooms/ClubRoomBase.gd, Godot/scripts/club_rooms/IsoWallCut.gd, Godot/scripts/club_rooms/IsoWallShell.gd, Godot/scripts/rules/PlacementRules.gd, Godot/scripts/GameSwitches.gd, Godot/assets/data/gym_club.json, Godot/tests/free_camera_test.gd, Godot/tests/floor_people_move_test.gd, Godot/tests/station_use_test.gd, Godot/tests/build_mode_test.gd, research/TPM_FLOOR_NUMBERS_S275.md
RED_TEST: Godot/tests/free_camera_test.gd -> FREE_CAMERA failures=0
REGRESSION: gym_floor_view_test, iso_camera_test, room_camera_flow_test, placement_rules_test
VISUAL: yes

## Shared-file rule (the one limit)
`GymHall3D.gd` (5,457 lines) is also edited by Cursor (top bar/dock, Day Plan drawer) and Claude: touch it only for input pass-through and
camera hooks, in small hunks, and say each hunk in your out file. Never read GymHall3D.gd, GymClub3D.gd or GameState.gd whole - grep, then
`sed -n` windows. The top bar / dock / HUD panels belong to Cursor; leave them.

## Prior research
TWOPOINT_ALIGNMENT.md (camera s1, build s2, rooms s3, items s4), TWOPOINT_MUSEUM_STUDY_S243.md, PLACEMENT_VERDICT_S243.md, TASK_PLACEMENT1.md,
TASK_CAMFOV17.md, S274_DIGEST.md items 7, 9, 10 (the diagnosis above), ROOMS3CD_DIGEST.md (your rooms rounds), GDSCRIPT_TRAPS.md (read before
writing GDScript).

## What would a human do?
Two Point Museum: you grab the floor with the mouse and drag, the wheel zooms smoothly toward the cursor, rooms are just parts of the
building you glide to, people walk at a real pace and use each item from its spot, and you drop items on a grid with the reason shown when
you cannot. Match it, using its own numbers.

## Prefab check
Godot has no stock RTS/sim camera worth taking; NavigationServer3D (built in) for paths/avoidance if our ClubRoutes cannot do avoidance.
Nothing of Two Point's enters the repo - numbers and rules only.

## The one trap
Right mouse button already means "train there". The pan must only start after the drag passes the threshold, or every pan sends the
fighter across the gym.
