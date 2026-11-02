# TASK GOALNEXT1 - his next goal from two, or one damage-control goal + a walk-out warning (S240, LOOP1, board Q-S237-2)

Seat: Arena (pure module + test). Branch `arena/<chat-id>-fightcamp`, PR to master; Claude merges by diff. Never merge it yourself.
Model: Arena default. Discipline: BOXING (the demo). No kicks, clinch, MMA anywhere in fixtures or text.

## Why
Operator, board Q-S237-2 (Ludo r105 C): "Yes, build both" - note: "no do not invent new cards, this should be done in the office".
Today a settled goal (GymHall3D.goal_settle, MET or MISSED) is followed by an automatic new goal (FighterGoal.pick_for). From now on
the PLAYER chooses the next goal in the office, from two; after a miss that drops his trust under 30 he is offered ONE damage-control
goal and a walk-out warning. This task is the RULES only (no UI, no scene, no preload); Claude wires the office.

## Do - ADD to `Godot/scripts/rules/FighterGoal.gd` (693 lines; static funcs only; do not change any existing function's behaviour)
1. `const WALK_OUT_TRUST: int = 30` and a 5th archetype `damage_control` that is NOT in `ARCHETYPES` (so `pick_for` never returns
   it): `const DAMAGE_CONTROL := {"id": "damage_control", "title": "Damage Control", "days": 3, "targets": {"technique": <start + 2,
   capped at STAT_MAX>}, "persona_line": "Three days of rest and technique. Show me this camp still works."}` - build its technique
   target in `_build_targets` from the fighter's start stats (start + 2.0).
2. `static func goal_for(fighter: Dictionary, archetype_id: String, today_day: int) -> Dictionary` - the same dict shape `pick_for`
   returns ({id, title, start_day, deadline_day, targets, start_stats, persona_line}) for a NAMED archetype (any of the 4 or
   damage_control); start_day = today_day, deadline_day = today_day + days. Unknown id -> {}.
3. `static func walk_out_warning(fighter: Dictionary, settled: Dictionary) -> Dictionary` -> `{"show": bool, "line": String}`.
   show = settled["status"] == "MISSED" and the fighter's trust < WALK_OUT_TRUST. Trust is `fighter["trust_coach"]` (int, default 50
   when absent - GameState.apply_floor_effect's base). Line (show only): "<NAME>'S TRUST IS <n>. MISS THE NEXT DEADLINE AND HE LEAVES
   THE GYM." (name from fighter["name"], upper-case; "HE" when absent). show false -> line "".
4. `static func next_choices(fighter: Dictionary, settled: Dictionary, today_day: int, seed_text: String) -> Array` -> goal dicts
   (built with goal_for), each with an extra `"reward_line"` = outcome(goal, true)["line"]:
   - walk_out_warning(...).show -> exactly ONE choice: damage_control.
   - otherwise exactly TWO distinct choices from the 4 ARCHETYPES that are LEGAL for him now:
     debut_inside_a_month only if _is_amateur_debut(fighter) and not _is_fight_booked(fighter, false);
     make_the_weight only if _is_over_weight_limit(fighter); southpaw_answer and upset_the_gatekeeper always legal.
     Never offer settled["id"] again when another legal archetype exists. If fewer than 2 are legal after that rule, fill from the
     legal set including settled["id"] (always return 2 distinct). Deterministic for the same seed_text (use _seeded_pick).
   - settled = {} (no settled goal, e.g. the first goal) -> two legal choices the same way.

## Tests (red on master first - paste the red line in the PR body)
New `Godot/tests/goal_next_test.gd` (extends SceneTree, `_initialize`, prints `GOAL_NEXT failures=N checks=M`, quit(1) on any fail).
Fixtures: THREE different boxers (never identical: different `stats`, record, weight, trust_coach, name) - a 0-0-0 welterweight debutant,
an 8-2 middleweight over his limit, a 15-1 lightweight. Check at least: next_choices after MET returns 2 distinct legal ids and never the
settled id; after MISSED with trust 45 -> 2 choices, no warning; after MISSED with trust 20 -> exactly [damage_control] and
warning.show with the name in the line; same seed twice -> same ids; different seeds over 20 tries give BOTH orders/pairs at least once
for the 15-1 boxer; goal_for("damage_control") deadline = today + 3 and technique target = start + 2 (capped at 100 for a 99.5 boxer);
pick_for never returns damage_control over 50 seeds; goal_for("nope") == {}; every reward_line non-empty.
Also run the existing `tests/fighter_goal_test.gd` - it must print the same result as on master.
Command: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/goal_next_test.gd` (CI: the repo's headless job).
Parse gate first: `python Godot/tools/check_scripts.py Godot/scripts/rules/FighterGoal.gd Godot/tests/goal_next_test.gd`.

## Rules
research/GDSCRIPT_TRAPS.md (Variant `:=`, typed arrays). Pure static module: no preload, no autoload, no Node. Edit ONLY
FighterGoal.gd and the new test. THE ONE TRAP: never delete or weaken a test (yours or fighter_goal_test) to go green.

## Prior research
research/LUDO_R105_VERDICT_S239.md (section "Your call"), ludo_rx/LUDO_R105_raw.txt lines 225-260 (result + next goal + walk-out),
existing FighterGoal.pick_for/_select_archetype/outcome, tests/fighter_goal_test.gd.

## What would a human do?
A coach sits the fighter down in the office after a deadline: "you did it - what next, power or gas tank?" After a miss that shook him:
"three easy days, sharpen up, and we talk again." One honest choice, not a menu of everything.

## Prefab check
None - a 60-line rules addition to our own module.
