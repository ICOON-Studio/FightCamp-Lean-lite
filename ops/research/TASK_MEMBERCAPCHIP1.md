# TASK MEMBERCAPCHIP1 - the member counter "9 / 12" in the ONE top bar, its hover tooltip, and the full/zero alert

Model: Cursor (cloud, Godot UI scripts). Discipline: BOXING (demo) - gym building, GYMBUILD (ROOMWORK1 rooms that work).
Operator S280 (chat): "where the member cap shows in the UI/screen ?" then "ask ludo also and check how this is shown on mgt2 and 2pm"
then "ask for the whole implementation code". Ludo's spec: research/ludo_rx/LUDO_S280_MEMBERCAP_UI_raw.txt (Two Point shows
population as icon + "42 / 65" in the HUD chrome, amber near full, red + pulse at full; MGT2 shows it in the room inspector). Ludo's
code: research/ludo_rx/LUDO_S280_MEMBERCAP_CODE_raw.txt FILE 3 (MemberCapChip.gd) + FILE 4 (alert) - start from it, fix it.

## What is already on master (do not rewrite)
- `GameState.member_cap_live() -> int` (-1 = no cap: old career or switch `room_work` off; 0 = no locker bank; else places).
- `GameState.get_front_door()` has "members" and "member_cap".
- `Godot/scripts/rules/MemberCapRead.gd` (pure, tested): `read(members, cap, banks, showers, has_locker_room, prices)` ->
  {"show", "text", "band" normal|near|full|zero, "color", "alert", "tooltip_lines", "next_build"}. USE IT, never re-derive bands.
- Counts: `career["club_rooms_built"][room]["items"]` ids "locker_bank" / "shower_stall"; has_locker_room = "locker_room" in
  club_rooms_built. Prices: room_types.json locker_room key_item price; RoomWorkRules.room_items() shower_stall price.

## Spec
1. New `Godot/scripts/ui/MemberCapChip.gd` (extends Control, NO class_name): icon (LucideIcons.gd "users", 22 px, like the cash
   chip's "banknote") + label "9 / 12" (UIKit.label, 24, A_SEMIBOLD like the cash figure), colour = read()["color"]; band "full" =
   icon pulse 1.0 s loop (tween modulate alpha 1.0 -> 0.55 -> 1.0); hover = UIKit.tip(...) with tooltip_lines (title line 0, rest
   as text) - never a hand-built floating panel. `refresh(game_state)` re-reads; hidden when read()["show"] is false.
2. ShellChrome.gd `_build_top` (line ~573 "the money, the roster, the bell"): the chip sits immediately LEFT of the Cash chip inside
   the same top bar (Ludo: "immediately to the left of the Cash display"); move `pills` left by the chip width so nothing overlaps the
   bell/roster. One top bar only - no new panel, nothing auto-opens (operator S275).
3. Alert: when a week's settlement turns walk-ins away (band "full" or "zero"), the existing notification path the bell uses gets
   ONE line = read()["alert"] ("The lockers are full" / "Nowhere to change - walk-ins turn round"); once per week, not every frame.
4. Plain `--script` tests are the OFF control arm; `as_game` turns `room_work` on (GameSwitches.GAME_ON already has it).

## Contract
OWNS: Godot/scripts/ui/MemberCapChip.gd, Godot/scripts/ShellChrome.gd, Godot/tests/member_cap_chip_test.gd
RED_TEST: Godot/tests/member_cap_chip_test.gd -> MEMBER_CAP_CHIP failures=0
REGRESSION: member_cap_read_test, room_work_wire_test, one_top_bar_test
VISUAL: yes

Test `Godot/tests/member_cap_chip_test.gd` (extends SceneTree, PASS/FAIL, last line `MEMBER_CAP_CHIP failures=<n>`, quit(1)):
new shell career "Chip Gym" (stand-in boxer "Chip Tester", male, boxing), career["room_work"] = true: top bar built by ShellChrome
has a "MemberCap" node LEFT of "Cash" with no overlap; no locker room -> hidden; locker room + 0 banks -> "0 / 0" grey; 1 bank,
11 members -> "11 / 12" amber; 12 -> red + pulse tween running; control: career without club_rooms_built -> no chip. Red on master
(no MemberCap node).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped screen: it must read RED (no member counter in the top bar); paste that in your report.
2. Career-screen stills ONLY via Godot/tools/clean_view.gd `save_if_clean` after `CleanView.clear`, `ui=1` (the still IS about the
   top bar): three stills - grey 0/0, amber 11/12, red 12/12.
3. For every still report: the chip's rect, its distance to Cash, text legible, nothing overlapping, the colour hex read.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. Tier: scripts edited -> parse + the RED test + the 3 regressions.
THE TRAP: ShellChrome lays the bar out by absolute positions (pills at x 1480) - adding a child to `pills` without moving it puts the
chip under the bell. Check rects in the test, not by eye.
PR from cursor/issue-<n> with `RESULT: tests/member_cap_chip_test.gd -> MEMBER_CAP_CHIP failures=0` + regression lines + still paths.

## Prior research
`python Tools/prior_research.py capacity members hud` -> topics/gym_market.md; HUD = ONE top bar + modals (S268/S275 memory);
Ludo S280 spec + code above.

## What would a human do?
A Two Point player glances at the corner of the screen: people icon, "9 / 12", it turns amber then red when the lockers fill.
Hover tells why (1 bank = 12) and what to build next.

## Prefab check
None - our own top bar and our own LucideIcons; Ludo's FILE 3 is the starting point.
