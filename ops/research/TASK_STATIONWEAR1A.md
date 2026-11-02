# TASK STATIONWEAR1A (S218) - station integrity and wear (pure module + test)

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base `master`. Work on your own `arena/...` branch, open a PR, NEVER merge.
No LFS-loading code or tests (CI has no LFS). Do not delete or shorten any existing test.

## Why
Gym stations wear out as boxers and members use them. A worn bag trains worse and can hurt a fighter; a broken machine has to be
serviced or replaced. This is a real money-and-risk decision for the player (queue item STATION-WEAR1). This task builds ONLY the
maths, as one pure module. A later task wires it into the gym behind a switch that is OFF.

## Prior research
- `research/LUDO_ROUND25_S195.md` lines 19-21 (Ludo, our lead designer): wear per athlete-hour, and the integrity bands below.
- `Godot/assets/data/equipment_catalog.json`: each item has `id`, `category` (ring / bags / cardio / strength / recovery / analysis),
  `purchase_cost`, `maintenance_cost`. Service and replace costs come from THESE two fields, not from new numbers.

## What would a human do?
A gym owner checks the bags and machines every week. A worn bag still works but feels dead. A frayed swivel or a slipping belt
gets serviced before somebody gets hurt. A machine that breaks gets replaced.

## Prefab check
No Godot asset or library models gym-equipment wear. It is about 100 lines of arithmetic, so we write it.

## Do - new file `Godot/scripts/StationIntegrity.gd`
`extends RefCounted`. NO preloads, NO autoloads, NO nodes, NO RNG (random numbers are passed in), NO file reads. Integrity is a
float in percent, 0.0..100.0.

### Wear per athlete-hour (percentage points), Ludo r25
Pick the FIRST matching rule, in this order:
| rule | items | wear %/h |
|---|---|---|
| id is `speed_bag` | speed-bag swivel | 0.40 |
| id starts with `treadmill` | slat treadmill | 0.55 |
| id is `deluxe_power_rack`, `squat_stand` or `smith_machine` | power rack | 0.05 |
| id is `modular_combat_mat`, `judo_tatami_area` or `grappling_dummy` | grappling vinyl mats | 0.30 |
| category `bags` | leather heavy bag | 0.25 |
| category `cardio` | air bike | 0.60 |
| category `strength` | barbell and plates | 0.15 |
| category `ring` | ring canvas and ropes | 0.20 |
| anything else (recovery, analysis, unknown) | Ludo gave no number | 0.0 (does not wear yet) |

### Integrity bands, Ludo r25
| integrity | name | gain_mult | injury_chance per session | injury_kind | breakdown_chance per session |
|---|---|---|---|---|---|
| 80..100 | `good` | 1.0 | 0.0005 | `minor` | 0.0 |
| 50..<80 | `worn` | 0.85 | 0.0035 | `minor_strain` | 0.0 |
| 20..<50 | `damaged` | 0.65 | 0.02 | `wrist_sprain` | 0.0 |
| <20 | `failing` | 0.65 | 0.02 | `wrist_sprain` | 0.05 (and a breakdown injures: kind `moderate_or_severe`) |
The edges belong to the higher band: exactly 80 is `good`, 50 is `worn`, 20 is `damaged`.

### API (exact names, all `static func`)
```gdscript
static func wear_per_hour(item: Dictionary) -> float
static func apply_use(integrity: float, item: Dictionary, athlete_hours: float) -> float   # clamp 0..100; negative hours = 0
static func band(integrity: float) -> Dictionary   # {"name","gain_mult","injury_chance","injury_kind","breakdown_chance"}
static func hours_until_below(integrity: float, item: Dictionary, threshold: float) -> float  # INF when wear is 0 or already below
static func service(item: Dictionary) -> Dictionary  # {"integrity": 95.0, "cost": int(item.maintenance_cost)}
static func replace(item: Dictionary) -> Dictionary  # {"integrity": 100.0, "cost": int(item.purchase_cost)}
## roll_a, roll_b in [0,1) come from the caller's RNG. roll_a < breakdown_chance -> broke; else roll_b < injury_chance -> injured.
static func session_outcome(integrity: float, roll_a: float, roll_b: float) -> Dictionary  # {"broke": bool, "injury": String ("" = none)}
```
- A broken session returns `{"broke": true, "injury": "moderate_or_severe"}`.
- NaN or infinite integrity is treated as 100.0 everywhere. Missing `category` / `id` / cost keys never crash (wear 0.0, cost 0).

## Test - new `Godot/tests/station_integrity_test.gd`
`extends SceneTree`. Print `STATION_INTEGRITY_TEST PASS (<n> checks)` or `FAIL ...` lines, then `quit(0)` or `quit(1)`. Load the module
with `load("res://scripts/StationIntegrity.gd")`. Hand-build item dictionaries in the test (do NOT read the catalog file). Write it
blind, from THIS contract only:
1. Every row of the wear table, including rule order: a speed_bag with category `bags` gives 0.40, not 0.25; `treadmill_commercial`
   gives 0.55, not 0.60; a recovery item gives 0.0.
2. apply_use: a heavy bag at 100 used for 80 h gives 80.0; clamps at 0; negative hours change nothing.
3. Band edges: 100, 80, 79.99, 50, 49.99, 20, 19.99, 0 map to the right name and numbers; NaN maps to `good`.
4. hours_until_below(100, heavy bag, 80) = 80.0; INF for a recovery item; INF when the integrity is already below the threshold.
5. service and replace use the item's own costs.
6. session_outcome: at 10 integrity, roll_a 0.04 -> broke; roll_a 0.06 and roll_b 0.01 -> `wrist_sprain`; at 90, roll_a 0.0 never
   breaks; roll_b 0.9 -> no injury.
7. Two mutant checks inside the test: (a) a table with the rule order reversed would give the speed bag 0.25 - assert it is 0.40;
   (b) an edge rule `>` instead of `>=` would give 80 as `worn` - assert `good`.

## Gate (CI runs it)
Parse gate on the 2 new files, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/station_integrity_test.gd`
prints the PASS line. Tier: a new pure file plus its test, nothing else touched.

## The one trap
Do not read `equipment_catalog.json` from the module or the test, and do not invent numbers for recovery/analysis items. Ludo gave
none, so they stay 0.0 until Ludo answers.
