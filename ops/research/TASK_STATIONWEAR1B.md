# TASK STATIONWEAR1B (S218) - stations wear out in the day loop (engine wiring, switch station_wear OFF)

Model: Grok Dev (Grok Bot coding seat, its own Linux box + Godot 4.7.2). Branch `grok/stationwear1b` from master. Never master.
Open a PR into master; never merge it.

## Why
Gym equipment should wear with use: a worn bag trains worse and can hurt a fighter, a broken machine must be serviced or replaced -
a real money-and-risk decision (queue STATION-WEAR1, Ludo round 25). The maths is on master as a pure module:
`Godot/scripts/StationIntegrity.gd` (read its header): `wear_per_hour(item)`, `apply_use(integrity, item, hours)`, `band(integrity)`
-> {name, gain_mult, injury_chance, injury_kind, breakdown_chance}, `hours_until_below`, `service(item)`, `replace(item)`,
`session_outcome(integrity, roll_a, roll_b)`. This task wires it into the day loop and the gym, behind a NEW switch that stays OFF.

## Prior research
`StationIntegrity.gd` + `tests/station_integrity_test.gd`; `LUDO_ROUND25_S195.md` lines 19-21; `DayLap.gd` (run_day ~l.65, the
existing `area_wear_on` switch is the pattern to copy: OFF = no new key, byte-identical output); `DayLapSplice.gd` (the two run_day
callers); `GameSwitches.gd` (how switches are declared); GameState.gd (19,900 lines - NEVER read whole; grep `purchase_equipment`,
`replace_equipment`, `get_equipment_instance`, and where DayLap/DayLapSplice results are applied to athletes).
## What would a human do?
A gym owner sees a bag go dead after months of use, has it re-stitched, and replaces a treadmill whose belt slips before someone
gets hurt.
## Prefab check
None - wiring our own pure module.

## Do
1. `GameSwitches.gd`: declare `station_wear` (default OFF, described in one line). It must NOT be in FightRealtime.DEMO_SWITCHES.
2. `DayLap.run_day` gains an optional last parameter `station_integrity: Dictionary = {}` ({station_id: integrity 0..100}). When it is
   non-empty: each minute's gain at a station is multiplied by `StationIntegrity.band(integrity)["gain_mult"]` (stations not in the
   dict = 100 = x1.0), and the result carries `"station_hours": {station_id: hours used}`. Empty dict = no new key, every number
   byte-identical to today (the control arm). Pass the parameter through `DayLapSplice` the same way `area_wear_on` is passed.
3. GameState: with `station_wear` ON -
   - each equipment instance carries `"integrity"` (missing = 100.0; never written while the switch is OFF);
   - when a day is applied, map each used station_id to the equipment instance on the floor that provides it (same catalog id or
     category; if several, the most-worn first is NOT required - use the first in floor order and say so in a comment), call
     `apply_use` with that station's hours, and store the new integrity;
   - before a day runs, build the station_integrity dict from the floor for run_day;
   - `service_equipment(instance_id)` and `replace_equipment_worn(instance_id)` (or reuse replace_equipment if it fits): charge
     `StationIntegrity.service(item)["cost"]` / `replace(item)["cost"]` from gym cash (refuse when cash is short, like purchases) and
     set integrity 95 / 100;
   - `get_equipment_integrity(instance_id) -> Dictionary` = {integrity, band name, hours_until_worn (below 80)} for a later UI.
   Breakdown/injury rolls (`session_outcome`) are NOT wired in this task - leave a one-line TODO naming STATIONWEAR1C.
4. Tests - new `Godot/tests/station_wear_day_test.gd` (extends SceneTree; PASS/FAIL lines; quit 0/1):
   a. OFF arm: run_day with and without `station_integrity = {}` -> identical result dicts (var_to_str compare); GameState with the
      switch OFF writes no "integrity" key after a simulated day.
   b. ON arm: a heavy bag at integrity 60 ("worn", 0.85) trains exactly 0.85x the gains of the same plan at 100 (two DIFFERENT
      fighters' stats are fine - compare the same fighter's two runs); station_hours equals the planned minutes / 60.
   c. ON arm through GameState: after a simulated 2-hour heavy-bag day the bag's integrity drops by 2 x 0.25 = 0.5; service costs the
      catalog maintenance_cost and restores 95; a short purse refuses.
   d. A mutant check: a version that ignores gain_mult would give equal gains at 60 and 100 - assert it does not.
5. Run: parse gate on every touched .gd; the new test; then
   `python Godot/tools/run_tests.py --jobs 2 --only day_lap,daylap,station,equip,game_switches,smoke,training_floor`.

## The one trap
OFF must be byte-identical: no new key in any dict while the switch is off (DayLap results, equipment instances, saves). The
area_wear_on pattern in run_day shows exactly how. Report each test's own PASS line in the PR.
