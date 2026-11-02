# TASK ROOMUNLOCK1 - the build window's locked rooms open when their rule is met (pure module + test)

Model: Qwen (cloud, small pure module). Discipline: BOXING (demo) - gym building, GYMBUILD C.
Today `BuildMode.room_types()` (Godot/scripts/club_rooms/BuildMode.gd ~L127) marks a room LOCKED whenever its `unlock` in
`Godot/assets/data/room_types.json` is not "open" - nothing ever evaluates the rule, so Physio, Storage, Strength Room... stay greyed
forever. Write the rule evaluator as a PURE module; Claude wires it into BuildMode and feeds it the career facts.

## Spec - Godot/scripts/rules/RoomUnlockRules.gd (new, extends RefCounted, no preload, no autoload, no file I/O)
- `static func is_open(rule: String, facts: Dictionary) -> bool`
- `static func progress(rule: String, facts: Dictionary) -> Dictionary` -> {"open": bool, "have": int, "need": int, "words": String}
  ("words" = what opens it in plain English, e.g. "2 fighters signed", "15 members", "your first pro win").
- facts keys (all ints, missing = 0): roster, members, pro_wins, longest_bout_rounds, breakdowns, reputation, career_earnings.
- Rules in room_types.json today: "open", "roster_2", "roster_3", "members_15", "members_20", "first_pro_win", "first_8_rounder",
  "first_breakdown", "reputation_2_career_40k". Parse the families generically: roster_<n>, members_<n>; first_pro_win = pro_wins>=1;
  first_8_rounder = longest_bout_rounds>=8; first_breakdown = breakdowns>=1; reputation_<r>_career_<k>k = reputation>=r AND
  career_earnings>=k*1000 (have/need report the earnings part when reputation is met, else the reputation part).
- Unknown rule -> closed, words = the rule with "_" -> " ". "" or "open" -> open.

## Test - Godot/tests/room_unlock_rules_test.gd (extends SceneTree, prints PASS/FAIL lines, last line `ROOM_UNLOCK_RULES failures=<n>`, quit(1) on any failure)
Every rule at need-1 (closed) and at need (open); missing facts; unknown rule; words for each; a mutant check (flip >= to > in your
head - the boundary cases must catch it).

## Contract
OWNS: Godot/scripts/rules/RoomUnlockRules.gd, Godot/tests/room_unlock_rules_test.gd
RED_TEST: Godot/tests/room_unlock_rules_test.gd -> ROOM_UNLOCK_RULES failures=0
REGRESSION: item_palette_test
VISUAL: no

## Prior research
research/MGT2_STUDY_S277.md s"Build Room menu" (MGT2 locks rooms in the Build menu and states the unlock rule on the button);
GYMBUILD_PLAN_S276.md; research/GDSCRIPT_TRAPS.md (Variant `:=`, `%%`).

## What would a human do?
Write the table of rules first, then one boundary test per row, then the code.

## Prefab check
None - a 60-line rule table for our own data.

## The one trap
Pure module only - do NOT touch BuildMode.gd, room_types.json or any scene; plain `--script` test with no preloads of game scripts
except the module itself.

## Output
PR with `RESULT: tests/room_unlock_rules_test.gd -> ROOM_UNLOCK_RULES failures=0`.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/room_unlock_rules_test.gd`.
