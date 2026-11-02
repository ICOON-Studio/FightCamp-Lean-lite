# R21 DIGEST — the GYM hub, the first replacement panel

User decision 2026-09-05: legacy scenes are discarded, not migrated. R21
replaces the first two, `RosterScreen` and `GymFloor`, with one kit panel
hosted by CareerRoot, built on Kalli's K8 boards and Codex's C4 read API.
Prep stage `d472bcb`, C4 `042b572`; this digest ships in the R21 commit.

## What shipped

**One rail item, GYM.** K8's recommendation, taken: `ManagementChrome.NAV_ITEMS`
lost MY GYM and FIGHTERS and gained GYM; the requests badge moved with it
(`ShellChrome`). `OfficeHub._ia_nav_items` mirrors it. The routes `roster` and
`gym_floor` survive as ids (every call site kept working) and land on the
hub's tab: a route entry can now carry `"tab"`, merged into the args exactly
like `"module"` (`SceneRouter`, `describe()` reports it) and applied by
CareerRoot too when a test calls `show_route()` directly. New route `gym`.
`fighter_card` lights GYM.

**`Godot/scripts/GymHubPanel.gd`** (no `.tscn`; CareerRoot mounts it by script
path, standalone it builds its own ShellChrome like THE DAY). It sits at
(402, 120): the shell's free band carries GYM, the gym's line and the
ROSTER / FLOOR / STORE switch; the body starts at 210. One
`get_gym_hub()` read per rebuild; nothing is derived on the screen.

- ROSTER: a banner when the day has one (fight week gold, a hold red, day
  one slate - gold once per screen), state filters with counts (ALL / NEEDS
  YOU / BOOKED / OPEN BOOK) plus one chip per division on the roster, a
  sortable head (condition first by default, NAME A-Z, a second click
  flips), the squad rows, an empty state with the screen's one silhouette.
  A row pushes `fighter_card` through the router's real stack.
- FLOOR: the capacity meter, the room as tiles (cell size fitted to the
  grid), the selected station's panel (quality, condition, safety,
  capacity, space, upkeep, occupancy, FOOTPRINT and REPAIR COST pairs)
  with REPAIR (gold) / ROTATE / MOVE. MOVE arms the next free-cell click;
  a station click while armed keeps the arm; the piece's own tile cancels
  it. Nothing selected: EXPAND TRAINING ROOM.
- STORE: the drawer off FLOOR (never a screen): the nine filters lifted
  from the legacy floor with their 2026-09-01 rulings (`market_matches`,
  static), catalog rows with BUY (gym blue) or NO CASH / NO SPACE, EXPAND
  at the bottom.
- Every mutation goes through GameState (`repair_equipment`,
  `rotate_equipment`, `move_equipment`, `expand_floor`,
  `purchase_equipment`): a refusal is said on the status line, a success
  saves and re-reads.

**The kit, family "gym"** (11 factories, 18 variants, rendered into the book):
`squad_row`, `action_flag`, `filter_strip`, `sort_header`, `capacity_meter`,
`station_tile`, `occupancy_chip`, `floor_grid`, `store_drawer`,
`catalog_row`, `affordability_reason`. `SQUAD_COLUMNS` is the one column
table the head and the rows share. Book: 135 variants across 13 families.

**The profile reads C4.** `ProfileRevampPanel._alerts` no longer derives
the seven conditions; it dresses `get_fighter_flags()` for the strip
(icon, action, target), so the hub's one-flag column and the profile's
NEEDS YOU strip can never disagree.

**Deleted:** `RosterScreen.tscn/.gd`, `GymFloor.tscn/.gd`, `GymFloorGrid.gd`
(and their `.uid`), `tests/equipment_tile_label_test.gd` (it measured the
grid's label layout, nothing else). No `.gd` in `scripts/` names either
scene any more.

**Pictures:** `DesignLibrary/screens/gym_hub/{roster,floor,store,roster_hold}.png`
from `Godot/tools/render_gym_hub.gd` (windowed, not headless).

## Found by building it

- `CareerRoot._rebuild_shell()` removed every shell handle from itself,
  but the day strip, Continue and the bell are children of the top bar:
  an engine error on every rebuild since R20. Only handles parented to
  the root come out now.
- `UIKit.segmented()` fires `on_change` while it is being built: a tab
  handler that rebuilds on every call recurses forever. The hub's
  `_on_tab` ignores the current tab.
- `tests/helpers/roster_operations_checks.gd` preloaded the roster scene;
  a deleted preload is a parse error, and a parse error HANGS the smoke
  test (rc=124 after 600 s) instead of failing it. Grep `tests/helpers/`
  too when a scene dies.

## Tests

New `tests/gym_hub_panel_test.gd` (46 checks): the standalone shell with
GYM lit, rows = roster, the condition sort and the NAME flip, the three
state filters, a hold as the row's one flag and the banner, the profile
push through the router, the floor grid's cells and stations, select,
REPAIR through GameState, MOVE armed then a real move to a free cell,
ROTATE and EXPAND with named refusals, the store's count and every
filter against `market_matches`, a real BUY, and CareerRoot hosting `gym`,
`gym_floor` (FLOOR tab) and `roster` (ROSTER tab).

Ported, every GameState claim kept: `equipment_market_filter_test`
(rewritten on the drawer), `gym_floor_layout_test` (move/rotate/expand/
save/reload unchanged; the grid claims moved to the hub),
`menu_modernization_test` (store count), `office_nav_and_profile_overlay_test`
(the row push), `shared_header_rollout_test`, `ia_v2_polish_test`,
`live_refresh_test` (their legacy-scene blocks dropped),
`ia_v2_navigation_test` (the new rail labels), `scene_router_test` (31
routes, roster hosted, GYM lit), `smoke_test` (the two scene blocks became
hub contract checks), `helpers/roster_operations_checks.gd` (rows agree
with GameState and ManagementOverview). Capture tools and
`text_overflow_audit` dropped their entries.

## Left for the next hubs

- The five legacy `UserSettings` flags still have readers (`EventsBoard`,
  `OfficeHub`, `ScheduleBoard`): they go with the last of them.
- `DIRECT_SCENES` in `ManagementChrome` maps `gym`/`roster`/`gym_floor` to
  CareerRoot only so the legacy header treats them as direct; it dies with
  the chrome.
- The floor's MOVE is click-arm-click, not drag: the K8 board asked for no
  drag and the kit has no drag primitive yet.

## Gate

    python Godot/tools/check_scripts.py Godot/scripts/GymHubPanel.gd Godot/scripts/UIKit.gd Godot/scripts/SceneRouter.gd Godot/scripts/ProfileRevampPanel.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/gym_hub_panel_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
