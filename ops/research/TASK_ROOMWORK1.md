# TASK ROOMWORK1 - rooms that work: the approved key-item rules as a pure module + test

Model: Qwen (cloud, small pure module). Discipline: BOXING (demo) - gym building, GYMBUILD.
The operator approved Ludo's "rooms that work" verdict on the board (Q-S277-1, S279: "Approve all"):
`research/LUDO_S278_ROOMSWORK_VERDICT.md` sections 1-3. Write the numbers as a PURE module; Claude wires it into GameState
(member cap, purse, injuries, repairs) and the BUILD window.

## Spec - Godot/scripts/rules/RoomWorkRules.gd (new, extends RefCounted; no preload, no autoload, no file I/O, no class_name)
1. `static func member_cap(locker_banks: int, shower_stalls: int) -> int` - 0 banks = 0 places (walk-ins turn round). Banks 1-3 give
   12 places each, bank 4 and on give 8 each, at most 6 banks count (a 7th adds nothing). Each shower stall +15. Negative inputs = 0.
   (0->0, 1->12, 3->36, 4->44, 6->60, 7->60; 1 bank + 2 showers -> 42; 0 banks + 1 shower -> 0: showers need a locker bank.)
2. `static func signups(has_desk: bool, cap: int, members: int) -> Dictionary` -> {"ok": bool, "why": String}: no desk ->
   "No front desk - nobody signs up"; cap 0 -> "Nowhere to change - walk-ins turn round"; members >= cap -> "The lockers are full";
   else ok with why "".
3. `static func office_deal(purse: int, has_pc: bool) -> Dictionary` -> {"to_promoter": int, "to_gym": int, "notice_days": int,
   "staff_market": bool}: no PC = "from the clipboard": promoter takes 40% (rounded half away from zero), 7 days' notice, no staff
   market; with PC = 0%, 21 days, staff market true.
4. `static func injury(base_days: int, has_table: bool) -> Dictionary` -> {"days": int, "fee": int}: no table = base_days and a
   $450 hospital fee; with table = round(base_days * 0.65) (35% faster), fee 0. base_days <= 0 -> {0, 0}.
5. `static func breakdown(has_shelving: bool) -> Dictionary` -> {"days_out": int, "fee": int}: no shelving = 3 days + $220
   call-out; with = 0 days, 0 fee.
6. `static func room_items() -> Array` - section 2's nine rows, each {"id", "label", "price", "size": [w, d], "rooms": Array of
   room ids, "effect": String key, "value": number}: framed_poster 120 [1.0,0.1] ["any_wall"] signup_pct 3; trophy_cabinet 600
   [1.8,0.5] ["reception","training_floor"] gym_score 8; vending_machine 850 [1.0,0.8] ["reception","locker_room"] weekly_income
   65; communal_bench 180 [1.8,0.5] ["locker_room","training_floor"] gym_score 10; shower_stall 1100 [1.2,1.2] ["locker_room"]
   member_places 15; water_cooler 350 [0.6,0.6] ["training_floor","reception","locker_room"] fatigue_pct_within_6m -5;
   round_clock 180 [0.8,0.2] ["wall"] drill_gain_pct 5; scouting_pinboard 150 [1.5,0.1] ["office"] hidden_attributes 1;
   ice_barrel 1800 [1.2,1.2] ["physio"] rehydration_pct 25.
7. `static func bag_mounts() -> Array` - section 3: wall_arm_bag 550 [1.4,1.6] mount "wall"; free_standing_bag 950 [2.2,2.2]
   mount "floor"; speed_bag 450 [0.6,0.4] mount "wall"; double_end_bag 380 clear_circle_m 1.6 mount "floor_ceiling". (Beam clamp
   is LATER - not in the table.)

## Test - Godot/tests/room_work_rules_test.gd (extends SceneTree, PASS/FAIL lines, last line `ROOM_WORK_RULES failures=<n>`,
## quit(1) on any failure)
Every number above against the table (a typo goes red); member_cap at 0,1,3,4,6,7 banks and with showers; each signups refusal and
the ok case at members = cap-1 and cap; office_deal 40% rounding on an odd purse (e.g. 1001 -> 400/601); injury rounding (7 days ->
5); breakdown both ways; the nine item rows and four mounts by id. Mutant check: flip the bank-4 boundary in your head - a case
must catch it.

## Contract
OWNS: Godot/scripts/rules/RoomWorkRules.gd, Godot/tests/room_work_rules_test.gd
RED_TEST: Godot/tests/room_work_rules_test.gd -> ROOM_WORK_RULES failures=0
REGRESSION: room_unlock_rules_test
VISUAL: no

## Prior research
research/LUDO_S278_ROOMSWORK_VERDICT.md (the approved numbers - the source of truth), research/topics/gym_market.md
(members, market), Godot/scripts/rules/RoomUnlockRules.gd (the sibling module's style), research/GDSCRIPT_TRAPS.md.

## What would a human do?
Copy the verdict's tables into constants first, write one boundary test per row, then the functions.

## Prefab check
None - our own approved numbers.

## The one trap
Pure module only: do NOT touch GameState.gd, BuildMode.gd, room_types.json or any scene. Plain `--script` test, no preloads of game
scripts except the module itself. Plain tests are the OFF control arm (GameSwitches untouched).

## Output
PR with `RESULT: tests/room_work_rules_test.gd -> ROOM_WORK_RULES failures=0`.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/room_work_rules_test.gd`.
