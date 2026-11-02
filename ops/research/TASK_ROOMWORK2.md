# TASK ROOMWORK2 - wire the office PC, physio table and shelving rules into the career (ROOMWORK1 wire 2)

Model: Arena (cloud, FightCamp-lite, no LFS). Discipline: BOXING (demo) - gym building, GYMBUILD.
Operator Q-S277-1 "Approve all" (Ludo S278 verdict, research/LUDO_S278_ROOMSWORK_VERDICT.md section 1). The pure rules are on
master: Godot/scripts/rules/RoomWorkRules.gd (68 lines) `office_deal(purse, has_pc)`, `injury(base_days, has_table)`,
`breakdown(has_shelving)`. Only member_cap is wired today (GameState.member_cap_live ~L5704). Wire the other three.

## The gate (copy member_cap_live exactly)
Every new branch runs only when `GameSwitches.on("room_work")` (already in GAME_ON) AND `career.has("club_rooms_built")` (an empty-shell
career). Otherwise the code path is byte-identical to today. "Has item X" = an item with id X in any
`career["club_rooms_built"][room]["items"]` (same loop as member_cap_live). Item ids: `office_pc` (room_types.json L71),
`physio_table` (L108, furniture), `shelving` (L219). Add ONE helper `func room_work_has_item(item_id: String) -> bool` beside
member_cap_live and use it for all three.

## Do (Godot/scripts/GameState.gd is 21,395 lines - never read it whole; sed -n windows below)
1. OFFICE PC - purse. `_apply_fight_result` (func at ~L16827; the purse is final at ~L16871 just before
   `FightContract.payee_split(purse + win_bonus + ...)` ~L16872). When gated and NOT room_work_has_item("office_pc"):
   `var deal := RoomWork.office_deal(purse, false)`; purse = deal.to_gym; record `career["clipboard_promoter_cut"]` += deal.to_promoter
   and push one news line "No office PC - the promoter kept $<n> of the purse". With the PC: unchanged.
2. PHYSIO TABLE - injuries. Every injury reaches the athlete through `BodyReadiness.store_injury(athlete, injury)`
   (Godot/scripts/BodyReadiness.gd L596). Find each GameState call site (`grep -n "store_injury" Godot/scripts/GameState.gd`) and route
   them through ONE new `func _room_work_store_injury(athlete, injury) -> Dictionary`: when gated, read the injury's duration field
   (find it in Godot/scripts/Injury.gd `build` - name it in your PR body), apply `RoomWork.injury(days, room_work_has_item("physio_table"))`:
   write the new days back; a fee > 0 comes off `get_gym()["cash"]` with one news line "Hospital visit - $450 (no treatment table)".
3. SHELVING - breakdowns. Station breakdown at ~L4463-L4468 (`if bool(outcome.get("broke", false))`). When gated:
   - has shelving: the station is repaired the same day - do NOT set broken, keep integrity as StationIntegrity.service would leave it
     (call the same service path, no charge); news "The <x> broke - fixed off the shelf the same day".
   - no shelving: `RoomWork.breakdown(false)` -> broken as today PLUS `item["back_day"] = _abs_day() + days_out`, fee off gym cash, news
     "The <x> broke down - out 3 days, $220 call-out". On the day tick, a broken item whose back_day has passed is serviced for free and
     `broken`/`back_day` erased (find the daily advance that calls the station wear pass; one small function `_room_work_return_broken()`).
   `career["station_breakdowns"]` still counts every breakdown (ROOMUNLOCK1 opens Storage on the first one - keep it).

## Test - Godot/tests/room_work_wire2_test.gd (extends SceneTree, no LFS loads, last line `ROOM_WORK_WIRE2 failures=<n>`)
Seed: `begin_new_career(1)` + `finalize_new_career("United Kingdom","London","Wire Gym", generate_starter_boxing_floor("Wire Gym"))`,
`career["club_rooms_built"] = {}` (see Godot/tests/member_cap_chip_test.gd for the exact seeding). Cases:
- room_work_has_item false on an empty shell, true after an office row with an office_pc item.
- office: a purse of 1001 with no PC pays the payee split on 601 (promoter 400); with the PC on 1001. (Call the smallest unit you
  extracted; if you extract `_room_work_purse(purse) -> int`, test that plus one end-to-end `_apply_fight_result` if it seeds without LFS.)
- injury: 7 days, no table -> 7 days + cash -450; with table -> 5 days, cash unchanged.
- breakdown: no shelving -> broken, back_day = day+3, cash -220; after 3 day ticks not broken. With shelving -> never broken, cash same.
- CONTROL ARM: `career.erase("club_rooms_built")` -> all three byte-identical to today (purse, days, broken with no back_day, cash).
RED on master first (the helper does not exist) - say the failing line in the PR body.

## Contract
OWNS: Godot/scripts/GameState.gd, Godot/tests/room_work_wire2_test.gd
RED_TEST: Godot/tests/room_work_wire2_test.gd -> ROOM_WORK_WIRE2 failures=0
REGRESSION: room_work_rules_test, room_work_wire_test, member_cap_chip_test, station_wear_day_test
VISUAL: no

PR body: `RESULT: tests/room_work_wire2_test.gd -> ROOM_WORK_WIRE2 failures=0` plus each regression's last line. Never delete or weaken
a test to go green. Plain `--script` runs are the OFF control arm only when the gate is off; this feature is ON (GAME_ON room_work).

## Prior research
LUDO_S278_ROOMSWORK_VERDICT.md s1 (the table), TASK_ROOMWORK1.md (pure rules + their test), TWOPOINT_ALIGNMENT.md (per-room item
slots), S280_DIGEST.md (member cap wiring = the pattern), STATIONWEAR1E notes at GameState ~L4434, GDSCRIPT_TRAPS.md.

## What would a human do?
Copy member_cap_live's gate, add one helper, change three call sites, and prove each with a with/without pair plus the control arm.

## Prefab check
None needed - pure game rules already on master; no assets.
