# TASK WEAR1B - the career-wear meter on the fighter's profile (UI half, only when `career_wear` is on)

Model: cloud Cursor (issue label `cursor`). Branch: the workflow names it. Never master, never HANDOFF.md, never AgentComms/.
Operator S188 ("yes all picks", WEAR1): "Career wear as a VISIBLE meter (wars, hard sparring, concussive damage); spent = a permanently
worse chin". The state is merged (WEAR1A, a3e90edc): `GameState.get_athlete_wear(athlete_id)` -> {wear 0-100, tier
PRISTINE/WEATHERED/BATTLE_WORN/SPENT, effective_chin, stamina_recovery_mult, cut_resistance_mult, retire_prompt};
`GameState.is_career_wear_on()`.

## Owned files
- `Godot/scripts/ProfileRevampPanel.gd` (4,151 lines - windows only). Anchor: `_build_now` (~502) - the CONDITION dial + "LOWEST" label
  (~520-560). The wear meter sits beside/under that dial in the same block.
- `Godot/tests/profile_wear_meter_test.gd` (NEW).

## Prior research
- Operator UI rules: icons over text with a tooltip via `UIKit.tip(...)` (never `tooltip_text` - it is cleared); bright, readable; nothing
  overlaps at 1920x1080 and 1280x720 (see `Godot/tests/camp_setup_no_clip_test.gd` for how overlap is measured).
- Scene scripts reach GameState via `get_node_or_null("/root/GameState")`, never the bare identifier (CLAUDE.md s9).

## What would a human do?
A thin 4-segment bar (Pristine / Weathered / Battle-worn / Spent) with a marker at the fighter's wear, an icon, and a tooltip that says
what it costs him now ("Battle-worn: chin capped at 85, recovers 12% slower, cuts 15% easier").

## Spec
1. Only when `is_career_wear_on()` is true; OFF -> the profile is byte-identical (no node added).
2. The bar + marker + tier word; colours: pristine green, weathered yellow, battle-worn orange, spent red. UIKit.tip with the live numbers
   from `get_athlete_wear` (never hard-coded). SPENT with retire_prompt -> one extra line "Time to talk about retirement" in the tip.
3. Fits inside the existing `_build_now` block at both resolutions; overlaps nothing.

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/tests/profile_wear_meter_test.gd`.
- `profile_wear_meter_test.gd` (headless, builds the panel like `profile_body_map_test.gd`): two DIFFERENT athletes at wear 10 and 85 ->
  tier words PRISTINE / SPENT, tip contains the capped chin number from get_athlete_wear, the meter rect sits inside the block and
  overlaps no sibling at 1920x1080 and 1280x720; switch OFF -> no meter node. RED first on master (paste the count), then green.
- `python Godot/tools/run_tests.py --only profile --jobs 2` -> 0 fails.
Final message: red count, green results.

## The one trap
The profile rebuilds on every refresh: `remove_child(node)` before `queue_free()` (CLAUDE.md s9), or the old meter lingers one frame
under the new one and the overlap test reads a ghost.
