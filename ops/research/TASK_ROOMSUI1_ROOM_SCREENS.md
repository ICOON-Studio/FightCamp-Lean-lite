# TASK ROOMSUI1 - the 3D room screens: fixed title, no covering panels, live expand, visible click targets

Model: Claude (UI layout; the spec is as long as the code). Starts the moment TRAIN1 (Cline, TrainingFloorPanel.gd)
is merged - same file. Context: D33 (S151) the eight 3D rooms are the product.

## Operator words (S151, verbatim)
- "i want the items that are clickable highlighted somehow so i knowwhere i can click"
- "thisis very bad the panelson the right overlap each other and hide the 3d scene , this room needs to be bigger and expandable" (training floor screenshot: the station list and THE RING - SPARRING card overlap over the room)
- "the title of the room should be in a fixed place on every screen"

## Spec
1. FIXED TITLE. Every career screen's title sits at the same screen point and style as the menu screens'
   (`UIKit.display(<NAME>, T.SIZE_HEADLINE, T.TEXT)` at the content origin, e.g. StaffHubPanel.gd:152, TrainingHubPanel.gd:162),
   one fact line under it where the menus put theirs. The eight rooms (TrainingFloorPanel, LobbyPanel, OfficeRoomPanel and
   its subclasses Locker/Mat/Staff/Physio/Film) drop their own title plates; the instruction sentences go (hover teaches).
   Title words = what the player calls the room: THE TRAINING FLOOR, THE FRONT DESK, THE OFFICE, ... (SceneRouter labels).
2. NOTHING COVERS THE ROOM. The floor's right side becomes ONE drawer with tabs (STATIONS | SPARRING), collapsible to a slim
   tab; collapsed by default so the 3D room is unobstructed; the spar card never stacks over the station list. Same rule
   for every room's side cards.
3. LIVE EXPAND. The floor's EXPAND ROOM button (TrainingFloorPanel.gd:312, `disabled = true` today, a readout) calls the
   same GameState path GymHubPanel uses (`expand_floor()` at tier 1, `start_wing_build()` at tier 2, quote
   `get_floor_expansion_cost()` / `get_wing_quote()`), with a confirm showing cost and what it buys; refused with the reason
   (cash, builders busy) in its tooltip; the room re-lays at the new size.
4. VISIBLE CLICK TARGETS. Every clickable object and door in the eight rooms: a small always-on gold marker (icon pin)
   so the player sees where to click without hunting, plus on hover a gold outline/rim on the object and a name tooltip
   "<what you see>: <what opens>" (SCENETREE2 names). Hover lives in OfficeRoomPanel._on_view_input (shared) via
   object_at/door_at; the floor has its own input (TrainingFloorPanel ~722).
5. BIGGER FLOOR. The camera frames the floor to fill the freed view; expansion (3) makes the room itself bigger.

## Owned files
TrainingFloorPanel.gd (738 lines + TRAIN1), LobbyPanel.gd, OfficeRoomPanel.gd (+ the Locker/Mat/Staff/Physio/Film
RoomPanel subclasses), the *3D.gd room scripts only for the hover rim/markers, UIKit.gd only for a shared title helper,
new tests/room_screen_layout_test.gd, docs/previews/roomsui1/.

## Acceptance (printed achieved beside wanted)
- room_screen_layout_test: on all 8 rooms + 3 menus, the Title node's global rect is identical; no two side panels'
  rects intersect; with the drawer collapsed no panel covers more than 8% of the 3D view.
- floor expand: a career with cash >= cost presses EXPAND -> floor_w x floor_d grows, cash drops by the quote; a career
  without cash -> button refused with the reason.
- every object/door in the 8 rooms has a marker node and a non-empty tooltip; hover over an object sets its highlight.
- stills of all 8 rooms + floor drawer open/closed, opened before reporting; `--only room,floor,office,locker,mat,staff,physio,film,lobby,shell` green.

## Prior research
SCENETREE2 (Tools/scene_tree_analysis.py), K85/M41/J61, topics/gym_rooms_art.md, ICONS-over-text rule (Glossary 'Icon with tooltip').

## What would a human do?
Two Point Hospital: rooms stay readable because UI lives in one collapsible panel and hovered objects outline.

## Prefab check
Godot built-ins only (StyleBox, Tween, a rim ShaderMaterial / next_pass outline); no asset needed.

## The one trap
OfficeRoomPanel is the base of five rooms: a layout change there moves all five - test each.
