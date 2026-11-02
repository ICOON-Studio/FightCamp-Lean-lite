# TASK GARAGEOUT1 - the garage concept is gone from the game (operator S196 ruling), tiers renumbered

Model: Codex luna (medium). Worktree E:/FightCamp/wt/GARAGEOUT1, branch codex/garageout1. Never master, never HANDOFF.md, never AgentComms/.
Operator S196 (verbatim): "remove the garge concept from everywhere this is not that kind of game". The game is a fight-gym manager with a 450 m2+ start
hall (D45); there is no converted-garage start and no garage look. Ludo.ai invented the "garage -> club -> commercial -> elite" ladder; the ladder is now
THREE tiers: club (start, 30 x 18 m) -> commercial -> elite.

## What to change (game data, code, UI text, tests, tools - NOT history docs)
1. `Godot/assets/data/gym_tiers.json`: delete the "Converted garage" tier. Renumber: old T2 -> T1 ("Established club", 30 x 18, start_tier "T1"),
   old T3 -> T2 ("Commercial gym"), old T4 -> T3 ("Elite centre"). Keep every number of the three surviving rows unchanged. Fix the `note`.
2. `Godot/assets/data/equipment_catalog.json`: every `min_tier` remapped T1->T1, T2->T1, T3->T2, T4->T3 (script it, keep key order and formatting).
3. `Godot/assets/data/club_capacity_rules.json`: `coaches_per_tier` becomes {T1: 2, T2: 4, T3: 8} (the old T2/T3/T4 values, same assumption flags).
   `Godot/scripts/club_capacity/ClubCapacity.gd`: remove the `tier_id == "T1"` garage special case (~line 85) and its comment; `Godot/tools/club_capacity_report.gd`
   text mentioning the garage scale; regenerate `research/GYMCAP1_REPORT.md/.csv` (run the tool). `Godot/scripts/rules/GymTiers.gd`: default start id "T1".
4. `Godot/scripts/TrainingFloor3D.gd` (~300-370 and ~618): delete the garage dressing helpers (`_c225_shell`, `_c225_lived_in`, `_c233_k82_dressing` and the
   "Garage*" nodes) and their call sites; the old room tier 1 then draws the plain club shell tier 2 draws. `TrainingFloorLayout.PRESETS[1]` name "Back-room
   club" stays (it is not a garage). NEVER read TrainingFloor3D.gd whole - grep + `sed -n` windows.
5. `Godot/assets/data/first_hour.json`: screen "Club Registration & Garage Gym Floor" -> "Club Registration & Gym Floor".
6. Anything else the new test finds (below).
7. Do NOT edit `research/*` (history) except nothing; Claude records the ruling in DECISION_LEDGER.

## Prior research
`python Tools/prior_research.py garage tier club gym_tiers` first. Tests that name tiers: grep `"T1"`..`"T4"` in Godot/tests, tools, scripts/rules (e.g. equipment_catalog_full_test,
club_capacity_test, gym_tiers tests if any) and update only what the renumber changed.

## What would a human do?
Search the whole project for the word, delete or rename every hit that is game content, renumber the ladder, and add a test so it cannot come back.

## Spec / Done (tier: scripts + data edited - parse, focused tests, related runs)
- NEW `Godot/tests/no_garage_test.gd`: walks `res://scripts`, `res://assets/data`, `res://tests`, `res://tools` (text files .gd .json .tscn .cfg) and FAILS on any
  case-insensitive "garage" (excluding this test file itself - put the word split as "gar" + "age" in the test source so it does not match itself); also asserts
  gym_tiers.json has exactly 3 tiers T1..T3, start_tier T1, every catalogue `min_tier` is one of them, every `coaches_per_tier` key is a tier id.
  RED first on master (paste the number of hits), then green.
- `python Godot/tools/check_scripts.py <every touched .gd>`.
- Related runs (jobs 2): `--only equipment`, `--only club_capacity`, `--only club_`, `--only gym_floor`, `--only training_floor`, `--only first_hour`, `--only gym_tiers`
  (skip a pattern that matches nothing) -> 0 fails.
- STILL: one training-floor still of the old tier-1 floor on the game camera if a tool exists (`grep -l training_floor Godot/tools`); you cannot see images:
  report the path; Claude opens it. If no tool exists, say so.
Final message: red hit count, green results, list of files changed.

## The one trap
Renumbering collides: a literal "T2" in a test that meant the OLD commercial tier now names the club. Change each test literal by its MEANING (old T2 -> T1 etc.), never
by search-and-replace on the digits, and say which tests you touched.
