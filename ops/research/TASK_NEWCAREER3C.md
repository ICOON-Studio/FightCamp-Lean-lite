# TASK NEWCAREER3C (S222) - New Career step 3: the player MOVES the zones (wire ZoneEditRules into the live gym preview)

Model: cloud Cursor (label `cursor`). Repo ICOON-Studio/FightCamp, branch `cursor/issue-<n>` from master. Open a PR, never merge.
No Git LFS on the cloud box: the test must not load models (GymPreview already builds the club with `load_models = false`).
Do not delete or shorten any existing test. Approved: operator board Q-S220-1 "Approve, and add resize/rotate" on
`research/LUDO_ROUND57_VERDICT_S220.md` (read it whole - section TAKEN 3, 4, 5 and "Build" are this task).
Product rule (operator S221): new features ship ON - no new opt-in switch; the editor is simply part of step 3.

## Prior research
- `research/LUDO_ROUND57_VERDICT_S220.md` (the approved design), `TASK_NEWCAREER3A.md` (the screen you extend, merged S222),
  `TASK_NEWCAREER3B_RULES.md` + `Godot/scripts/ZoneEditRules.gd` (474 lines, merged S222: ALL the rules - move, swap, blocker,
  resize, rotate90, undo, reset, floor_used_m2; pure static, returns new layouts). Its test `tests/zone_edit_rules_test.gd` pins it.

## What would a human do?
A player in a builder game (Two Point, Jurassic World Evolution) grabs a zone, drags it, sees it snap; a bad drop flashes red with the
reason and springs back; Ctrl+Z undoes; RESET restores. Drop on another zone swaps them.

## Prefab check
Godot's own input events + the existing GymPreview overlay drawing (`_draw_zone_overlay`, `_draw_dashed_poly`). No addon needed.

## Owned files
- `Godot/scripts/creation/GymPreview.gd` (464 lines): `_gui_input` (224-240) gets press/drag/release; overlay draw (385-436) gets the
  gold (selected), cyan (swap target) and red (blocked) outlines + a "BLOCKED: AISLE|WALL|RING|DOOR|OVERLAP" label; zone lookups at
  295/305/391 read the EDITED layout, not `ClubZones.floor_zones()` directly.
- `Godot/scripts/creation/GymStepPanel.gd` (508 lines): bottom strip `_build_strip` (278) gets RESET + UNDO buttons and a
  ROTATE 90 button for the selected zone; resize = drag on a selected zone's edge (8 px grab band); `_floor_used_line` (319) uses
  `ZoneEditRules.floor_used_m2`. Ctrl+Z = undo.
- `Godot/scripts/club_zones/ClubZones.gd`: `floor_zones()` (23) returns a career override when one is set
  (`static set_override(zones: Array)` / `clear_override()`), else the table. GameState sets it from the career's floor on load.
- `Godot/scripts/CreationFlowPanel.gd` (792) and `Godot/scripts/GameState.gd` (20,000+ lines - NEVER read whole; grep
  `finalize_new_career` and read +-40 lines): the edited zones are saved into the new career's floor as `floor["zone_layout"]`
  and ClubZones' override is set when a career with `zone_layout` loads; a career without it behaves exactly as today.
- NEW test `Godot/tests/new_career_zone_edit_test.gd`.

## Do
1. GymPreview holds `_layout := ZoneEditRules.new_layout(ClubZones.floor_zones())` and `_fixed := ZoneEditRules.fixed_rects(room, ring_rect)`
   (room = gym_club.json `room`; ring rect from the club layout). Press on a zone = select; drag = live ghost rect snapped to 1 m;
   release: over another zone -> `swap`, else `move`; if the result reports a blocker, keep the old layout, flash red 0.6 s with the
   label, spring back. Rebuild the 3D club after each accepted edit (zones + their items move together - ZoneEditRules shifts items).
2. UNDO / RESET / ROTATE 90 / edge resize call the matching ZoneEditRules functions. The inspector refreshes after every edit.
3. Sandbox start (empty hall, verdict TAKEN 6) keeps today's behaviour; editing applies to zones that exist.
4. Public test hooks (like 3A's `show_step_for_test`): `drag_zone_for_test(zone_id, dx, dz)`, `drop_on_zone_for_test(a, b)`,
   `resize_for_test(zone_id, edge, delta)`, `rotate_for_test(zone_id)`, `undo_for_test()`, `reset_for_test()`, `layout_for_test()`.

## Acceptance test - `new_career_zone_edit_test.gd` (pattern: `tests/new_career_gym_preview_test.gd`)
Story start, step 3 shown: (a) move a zone +2 m in x into free floor -> its rect moved 2 m, its items moved 2 m; (b) move a zone onto the
middle aisle -> layout unchanged, blocker text contains "AISLE"; (c) swap two zones -> rects exchanged, swap again -> original;
(d) rotate then undo -> original; (e) RESET after 3 edits -> equals the canonical `ClubZones` table; (f) finish the career after one
move -> the saved floor has `zone_layout` and `ClubZones.floor_zones()` returns the moved rect; a fresh career without edits has no
`zone_layout` and the table rects. Also run `tests/new_career_gym_preview_test.gd`, `new_career_finished_test.gd`, `zone_edit_rules_test.gd`.

Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`. Tier: script edited - parse + the tests above.

## The one trap
`ClubZones.floor_zones()` is read by the training floor and club layout rules too: the override must be cleared when a career without
`zone_layout` loads (and in `begin_new_career`), or one career's layout leaks into the next.
