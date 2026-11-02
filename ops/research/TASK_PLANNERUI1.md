# TASK_PLANNERUI1 - the BUILD window becomes the Life Fitness gym planner (right catalogue with pictures, left tool rail, 2D/3D, rotate ring)

Model: cursor. Discipline: boxing = demo (the gym every boxer career builds).

## Operator, verbatim (S287, 2026-10-22)
1. "https://www.lifefitness.com/en-us/customer-support/gym-planner/builder check their builder and improve our own"
2. (his screenshot of the planner) "this is how i want it pretty simple check the webiste link and try to fit their designer in our game"
3. "check how it rotates items and rotates the view"
4. The session goal it serves: "i want to be able to build the rooms quickly put the objects i need and the gymfloor assets and start training"

## What their planner does (Claude built a gym in it S287 - stills `research/planner_study_s287/01..03_*.jpg`, open them)
- LAYOUT: thin floating tool rail on the LEFT (rounded white pill, 7 icon buttons stacked: select, area-select, pan hand | measure, grid,
  walls, rotation-snap). The 3D view fills the rest. TOP-RIGHT of the view: snapshot, a 3D | 2D segmented toggle, a small view cube
  (shows FRONT/BACK/TOP; click a face = snap the camera to it). Top bar: project name, undo / redo, help, settings.
- CATALOGUE on the RIGHT (~360 px): a category DROPDOWN ("All", then groups) + a search button; a 3-column GRID of square tiles = a
  product photo on a light card, the name in 2 lines under it. DRAG a tile into the room = it lands where you drop it, already standing
  square to the room (not to the camera). Clicking a tile does nothing extra; drag is the gesture.
- SELECT an item: it highlights (blue), a name tag floats over it, two round buttons float above it (edit, delete), and a RING lies on the
  floor round its base with tick marks. DRAG ALONG THE RING = rotate it (free; with the rail's "45" toggle ON it snaps in 45 deg steps).
  Drag the item itself = move. Esc / click empty = deselect.
- VIEW: left-drag on empty space ORBITS (horizontal = turn round the room, vertical = tilt from eye level to straight down), wheel
  zooms, walls on the camera side drop away by themselves. 2D = orthographic straight-down plan (items as top silhouettes).
- ROOM SETUP (not this task): shape presets rectangle / L / T / draw + W x L x H.

## What to build in OUR game (fit, not copy - our dark brass shell look, Lucide icons via IconKit, our money and rules)
BuildMode.gd keeps every rule, price and placement check; this task changes how the window SHOWS them and adds three gestures.

1. CATALOGUE DOCKED RIGHT (BuildWindow.gd): the 340 px window moves to the RIGHT edge under the top bar, ~380 px wide. Its top row =
   a category OptionButton + a search LineEdit (filters by name, live). Categories: All, Rooms, Training floor, Equipment, then one per
   built room's furniture ("Reception", "Locker room" ...) - the same rows `_fill_rooms` / `_fill_objects` make today. Each row becomes
   a TILE in a 3-column GridContainer: a square picture (TextureRect, `res://assets/ui/build_thumbs/<id>.png` when the file exists,
   else today's IconKit icon large and centred), the name (2 lines, autowrap), the price under it (red when he cannot afford it,
   "BUILT"/"LOCKED - <words>" as today). KEEP every node name the tests use: `Close`, `Cash`, `List`, `PlacingCard`, `Tab_rooms`,
   `Tab_objects` (keep them as hidden-or-visible quick switches if the dropdown replaces them), `Room_<type>`, `Piece_<prop>`,
   `Shop_<id>`, `Item_<room>_<item>`, `Floor_<surface>`, `Draft_*` and `draft_summary_overlaps_item_rows()` /
   `draft_status_overlaps_buttons()` (tests/room_draft_flow_test.gd). The room DRAFT card (permit/floor/items total, FINISH/CANCEL, door
   first) stays as the top of the right panel while a draft is open.
2. DRAG FROM A TILE: press on a Piece_/Item_ tile and drag into the 3D view = `pick_station` / `pick_item` then, on release over the
   floor, the same call a click makes (`place_station(ground)` / `place_item(ground)`, ground from `club.free_camera_ground(screen)`).
   A plain click on a tile keeps today's behaviour (pick, then click the floor). Room tiles keep "pick then drag a rectangle".
3. LEFT TOOL RAIL (new `Godot/scripts/ui/BuildRail.gd`, ~52 px wide pill at the left edge, under the top bar, only while BUILD is
   open): Select (default), Pan (left-drag pans while on), Rotate view left / right (90 deg - `club.iso_turn(-1/1)`), Rotation snap
   45/90 toggle, Walls cut on/off if the club has it, and at its foot 3D | 2D (`club.set_plan_view(bool)` / `club.plan_view_on()` -
   ALREADY ON MASTER S287 in ClubRoomBase.gd + FreeFloorCamera.gd PLAN_PITCH_DEG). Tooltips via UIKit.tip like the window's buttons.
4. SELECTION RING (BuildMode.gd + a small new `Godot/scripts/club_rooms/RotateRing.gd` Node3D): when a placed station is selected
   (today click selects it - find the select path near `turn_station` L2039 / `move_station` L2051 / `sell_station` L2069,
   `_station_centre` L1938, `_station_yaw` L1944), draw a flat ring on the floor round its footprint (radius = half the footprint
   diagonal + 0.3 m, white, tick marks every 45 deg, a brass handle at the item's facing). Dragging on the ring turns the item: yaw =
   the pointer's angle round the centre, snapped to 45 deg when the rail's snap is on (90 when off - our stations are grid pieces;
   check `turn_station`'s allowed yaws and snap to what PlacementRules accepts), committed through the same path R uses (refused =
   it springs back with the reason). Two floating round buttons over the selected item: ROTATE (= R) and SELL (= Del).
5. ORBIT (FreeFloorCamera.gd L64-107 `pointer`): middle-drag already turns the view horizontally; ALSO tilt it with the vertical
   motion (wanted_pitch_deg clamped 25..89, PLAN_PITCH_DEG = 89 is the 2D end). Left-drag on EMPTY floor in BUILD with the Select tool
   keeps today's pan (the operator learned it); with the rail's Pan tool it pans everywhere. Do not change gameplay (non-BUILD) input.

## Owned files (line counts at master e23115bf)
Godot/scripts/ui/BuildWindow.gd (585), Godot/scripts/ui/BuildRail.gd (NEW), Godot/scripts/club_rooms/RotateRing.gd (NEW),
Godot/scripts/club_rooms/BuildMode.gd (2602 - only the selection/ring/drag-from-tile hooks; anchors above; never read it whole:
`sed -n` windows), Godot/scripts/club_rooms/FreeFloorCamera.gd (175 - pitch from middle-drag), Godot/tests/build_planner_ui_test.gd (NEW).

## Contract
OWNS: Godot/scripts/ui/BuildWindow.gd, Godot/scripts/ui/BuildRail.gd, Godot/scripts/club_rooms/RotateRing.gd, Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/club_rooms/FreeFloorCamera.gd, Godot/tests/build_planner_ui_test.gd
RED_TEST: Godot/tests/build_planner_ui_test.gd -> BUILD_PLANNER_UI failures=0
REGRESSION: room_draft_flow_test, build_single_piece_test, reception_keeps_gym_test, gym_shell_catalogue_test, bag_mount_test
VISUAL: Claude takes the stills on the PC (below)

## The test (write it FIRST, red on master): Godot/tests/build_planner_ui_test.gd
Setup like tests/build_single_piece_test.gd L20-55 (stripped shell career, GymClub3D with load_models false, `build_mode().enter()`),
plus a training floor drawn (L116-121 there). Checks, each printed `PASS`/`FAIL`, last line `BUILD_PLANNER_UI failures=<n>`:
the window's rect is on the RIGHT half of the viewport; a category OptionButton and a search LineEdit exist; typing "bag" into search
leaves only tiles whose name contains "bag"; the tiles sit in a GridContainer with 3 columns; `Piece_<prop>` tile press -> 
`placing_kind() == "station"`; a simulated drag-from-tile onto a free floor spot buys and places it (Club.places_bought() +1);
the rail exists with 3D/2D, and pressing 2D makes `club.plan_view_on()` true, 3D false again; selecting the placed piece shows a
RotateRing node; a ring drag to +90 deg changes `_station_yaw(pid)` by 90 (snap 45 on -> a 45 deg drag gives 45 if PlacementRules
allows it, else it is refused and the yaw is unchanged - assert whichever the rules say, read them); Esc hides the ring.
Run both arms: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/build_planner_ui_test.gd` and `... -- as_game`
(plain `--script` = the OFF control arm; `as_game` turns GAME_ON on - every new feature reads `GameSwitches.on()`; this one is
always-on UI, no switch needed). Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. Then the REGRESSION tests both arms.
Put `RESULT: tests/build_planner_ui_test.gd -> BUILD_PLANNER_UI failures=0` lines in the PR body (one per arm).

## VISUAL GATE
UI on the gym floor: closes only on stills of the REAL route (new career -> BUILD) on the game camera at 1920x1080, through
`Godot/tools/clean_view.gd` `save_if_clean(..., ui=true)` (the still is ABOUT the BUILD UI): (a) BUILD open, catalogue on the right
with tiles, rail on the left; (b) search "bag"; (c) a piece being dragged from a tile; (d) a selected piece with its ring; (e) 2D.
Claude takes them on the PC (Godot/tools/s287_build_loop_probe.gd is the route driver) and the operator judges them. No feet-only
or mat stills apply here (no fighters). Thumbnails: Claude renders `assets/ui/build_thumbs/*.png` on the PC (GPU); the tiles must
work without them (icon fallback).

## Prior research
`python Tools/prior_research.py build window catalogue planner thumbnail` (no planner study before S287). MGT2 build window study:
research/MGT2_STUDY_S277.md "Build UI" (why the window exists); Two Point camera numbers: research/TWOPOINT_ALIGNMENT.md
(the gym camera, rooms, items - cite it, keep the FOV 17 perspective and the iso yaw steps). Life Fitness stills:
research/planner_study_s287/.

## What would a human do?
A gym owner planning a floor opens the catalogue, scrolls pictures, drags a machine onto the plan, spins it with the ring until it
faces the right way, flips to the top-down plan to check the aisles, and goes back to 3D to see it. That is the whole loop.

## Prefab check
Godot has no built-in planner widget; GridContainer + TextureRect tiles, OptionButton, LineEdit are stock. No Asset Library add-on
does catalogue-drag into a 3D club. Nothing to import.

## The one trap
BuildMode.gd is 2,602 lines and owns all the money and rules: never move a rule into the window; the window only calls BuildMode's
public methods. And keep every node name the existing tests find (list above) - three tests look them up by name.
