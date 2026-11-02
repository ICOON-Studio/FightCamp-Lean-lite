# TASK PROFILETECH1 - the TECHNIQUES tab's data as a pure module (for PROFILE2C)

Model: Qwen (qwen3-coder, --yolo). Tier: a new pure module + its own test only (parse gate + that one test).

## Why
PROFILE2C adds the TECHNIQUES tab to the fighter profile (Ludo r37 s2.1, approved by the operator, board Q-S201-1). The verdict
(`research/LUDO_ROUND37_VERDICT_S202.md`, "NO INVENTED NUMBERS") allows only data the game holds. The game holds: the boxing
technique catalogue (`Godot/assets/data/technique_catalog.json`, discipline "boxing", 54 nodes in 7 branches, tiers 1-4) and per
athlete `technique_progress` = { technique_id: {"learned": bool, "learned_week": int, "source": str, ...} }. It does NOT hold
mastery %, decay per week or in-bout frequency - none of those may appear.

## Prior research
- `research/LUDO_ROUND37_S202_reply2a.txt` lines 262-288 (Ludo's TECHNIQUES tab - direction only; its columns 3-5 are invented).
- `research/topics/attributes_skill.md` (technique catalogue and progression).
- Catalogue node shape: {"id","name","kind","tier","branch","grade","grade_rank","requires":{"prerequisites":[ids],...},...}.

## What would a human do?
Football Manager's "Traits"/"Positions" page: the full list grouped, what he has lit, what he can learn next - no fake numbers.

## Prefab check
None - Array/Dictionary maths.

## Owned files (create both; edit nothing else)
- `Godot/scripts/rules/ProfileTechniques.gd` - `extends RefCounted`, `class_name ProfileTechniques`, static funcs, PURE (no `preload`,
  `load(`, `FileAccess`, autoload, GameState, RNG, Node).
- `Godot/tests/profile_techniques_test.gd` - `extends SceneTree`; `PASS <name>` / `FAIL <name>: <detail>` per check, final
  `PROFILETECH total=<n> fails=<m>`; `quit(0)` only when fails == 0. The TEST may read the real catalogue JSON with FileAccess.

## API (exact names)
1. `const BRANCH_LABELS := {"fundamentals": "FUNDAMENTALS", "straight_punching": "STRAIGHT PUNCHES", "hooks_bodywork": "HOOKS & BODY",
   "defense_counters": "DEFENCE & COUNTERS", "footwork_ring": "FOOTWORK & RING", "combinations": "COMBINATIONS",
   "infighting": "INSIDE FIGHTING"}` and `const TIER_NAMES := {1: "FOUNDATION", 2: "CORE", 3: "ADVANCED", 4: "SIGNATURE"}`.
2. `groups(nodes: Array, progress: Dictionary, branch_order: Array, certified: Array = []) -> Array` - one Dictionary per branch in
   `branch_order` that has at least one node: {"branch", "label" (BRANCH_LABELS, else the id upper-cased), "learned": int,
   "total": int, "rows": Array}. Nodes whose branch is not in branch_order go to a final group "other" / "OTHER" (only if any).
   Rows sorted by tier ascending, then name. Row = {"id", "name", "tier", "tier_name" (TIER_NAMES, else "TIER <n>"), "grade",
   "learned": bool, "certified": bool (id in certified)}; add "learned_week" ONLY when the progress record holds it.
3. `summary(groups: Array) -> Dictionary` - {"learned": int, "total": int, "line": "LEARNED <l> / <t>"}.
4. `next_unlocks(nodes: Array, progress: Dictionary, limit: int = 3) -> Array` - ids of nodes NOT learned whose every
   `requires.prerequisites` id IS learned; sorted by tier, then name; at most `limit`.

## Test checks (each its own line)
- real catalogue: load technique_catalog.json, take discipline "boxing": groups(nodes, {}, branches) -> 7 groups, totals sum to 54,
  learned 0 everywhere; every catalogue tier number has a TIER_NAMES entry.
- fixture progress (jab + cross + stance learned, jab with learned_week 3): the right groups count 1/1/1 learned; jab row has
  learned_week 3; cross row has NO learned_week key; rows inside a group are tier-then-name ordered.
- certified: passing ["boxing_jab"] marks only that row certified.
- unknown branch node -> lands in a final "OTHER" group; with no unknown nodes there is no OTHER group.
- summary line == "LEARNED 3 / 54" for the fixture.
- next_unlocks: with nothing learned returns only nodes with empty prerequisites; with the fixture it includes a node whose only
  prerequisite is the jab (find one in the catalogue in the test, do not hard-code) and never a learned node; limit respected.
- no row Dictionary has any key outside {id,name,tier,tier_name,grade,learned,certified,learned_week} (no invented fields).
- purity (source): read `res://scripts/rules/ProfileTechniques.gd` as text; FAIL on `preload`, `load(`, `FileAccess`, `GameState`,
  `randf`, `randi`, `RandomNumberGenerator`.
- CAN READ WORSE: a deliberately wrong ordering (sort by name only) built inside the test must fail the tier-then-name check.

## Gates and the one test
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/ProfileTechniques.gd Godot/tests/profile_techniques_test.gd`
- Test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/profile_techniques_test.gd`
  (never `_console.exe`, never open a window). Pass = `PROFILETECH total=<n> fails=0`, exit 0, no `SCRIPT ERROR`.

## The one trap
`var x := <call>` fails on a Variant return - type it (`var n: int = ...`). Dictionary keys from JSON are Strings and numbers are
floats: `int(node.get("tier", 0))`. Never weaken a check to go green.
