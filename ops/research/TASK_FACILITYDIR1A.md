# TASK FACILITYDIR1A - Facility operational directives: the gym's three house policies (pure module + test) (S200)
Seat: Arena (cloud). Repo ICOON-Studio/FightCamp. Work ONLY on your own new branch and open a PR to master; never merge, never push master.
Model: any. HEADERS2 item 8 (operator approved Q-S196-4). Source: `research/LUDO_ROUND33_S198.txt` lines 372-389.

## Owned files (both NEW; touch nothing else)
- `Godot/scripts/rules/FacilityDirectives.gd`
- `Godot/tests/facility_directives_test.gd`

## Spec
`class_name FacilityDirectives extends RefCounted`, pure static functions only: no RNG, no autoload, no GameState, no preload/load, no Node, no files.
Three directives, each with exactly two options (string ids as named consts):
1. `SPARRING` : `"light_technical"` (16oz + headgear) | `"hard_war"` (10oz, no headgear)
   - light_technical: tissue_wear_mult 0.40, injury_risk_per_session 0.001, card_mastery_xp_mult 1.25, chin_per_week 0.0, composure_mult 1.0
   - hard_war:        tissue_wear_mult 2.00, injury_risk_per_session 0.045, card_mastery_xp_mult 1.0, chin_per_week 0.3, composure_mult 1.40
2. `MEMBERS` : `"members_first"` | `"fighter_priority"`
   - members_first:   member_dues_mult 1.20, station_congestion_mult 1.30, member_churn_mult 1.0
   - fighter_priority: member_dues_mult 1.0, station_congestion_mult 1.0, member_churn_mult 1.15
3. `SANITATION` : `"lean"` | `"hospital_grade"`
   - lean:           monthly_cost 100, infection_risk_per_month 0.08, equipment_wear_mult 1.0
   - hospital_grade: monthly_cost 650, infection_risk_per_month 0.0,  equipment_wear_mult 0.75
Defaults (a new gym): light_technical, fighter_priority, lean.

API:
- `static func defaults() -> Dictionary` -> `{"sparring": "light_technical", "members": "fighter_priority", "sanitation": "lean"}`
- `static func options(directive: String) -> Array` -> the two ids in the order above; unknown directive -> `[]`.
- `static func set_choice(state: Dictionary, directive: String, option: String) -> Dictionary` -> `{ok: true, state: <new copy>}`;
  unknown directive or option not valid for that directive -> `{ok: false, reason: <text>}` and nothing changes. Missing keys in `state` read as the default.
- `static func effects(state: Dictionary) -> Dictionary` -> ONE flat Dictionary merging the three chosen options' numbers above (all keys present, floats except monthly_cost int).
- `static func monthly_cost(state: Dictionary) -> int` -> the sanitation monthly_cost of the current choice.
- `static func label(directive: String, option: String) -> String` -> player-facing text: "Light technical (16oz + headgear)", "Hard gym war (10oz, no headgear)",
  "Members first (open access)", "Fighter priority (curfew)", "Lean ($100/mo)", "Hospital grade ($650/mo)"; unknown -> "".
- `const HEADER := "FACILITY OPERATIONAL DIRECTIVES"`.
- Inputs are NEVER mutated.

## Test `facility_directives_test.gd` (extends SceneTree; prints `FACILITYDIR total=N fails=M`; `quit(1)` on any fail; on pass just `quit()` - never `quit(0)` hard-coded before checks finish)
(a) defaults exact; (b) options order for all 3 + unknown -> []; (c) set_choice valid for each of the 6 options; invalid option for a directive (e.g. "lean" on SPARRING) refused and state unchanged;
unknown directive refused; (d) effects() exact numbers for defaults AND for all-flipped (hard_war, members_first, hospital_grade); every key present in both; (e) monthly_cost 100 vs 650;
(f) labels exact; (g) no input Dictionary mutated (deep compare before/after); (h) empty state {} behaves as defaults.
Write the test FROM THIS SPEC, then state in the PR body 3 real mutants you ran red (e.g. swapped a multiplier, dropped the validity check, mutated input).

## Gates
`python Godot/tools/check_scripts.py Godot/scripts/rules/FacilityDirectives.gd Godot/tests/facility_directives_test.gd`
`Godot --headless --path Godot --script tests/facility_directives_test.gd` -> exit 0, no "FAIL", no "SCRIPT ERROR". CI "Parse gate + changed tests" must be green.
GDScript traps: type every Variant (`var n: int = ...`, never `:=` on a Dictionary read); never reuse a local variable name inside one function; `%` in a format string is `%%`.

## Prior research
LUDO_ROUND33_S198.txt Header 8 (numbers above copied from it). Pattern to copy: `Godot/scripts/rules/FilmIdle.gd` (pure static, returns new copies).
## What would a human do?
A gym owner sets three house rules on the noticeboard: how hard people spar, who gets the floor first, how often the place is cleaned - and lives with the trade-offs.
## Prefab check
None - our own rules.
## The one trap
Do not delete or weaken any existing test. Do not touch any file outside the two owned files. The UI panel is a separate later task.
