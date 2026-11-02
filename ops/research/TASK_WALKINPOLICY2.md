# TASK WALKINPOLICY2 - the office walk-in policy toggle + the saved setting (S235)

Seat: QWEN. Worktree given in the launch prompt. Commit on your branch; Claude merges by diff. Model: qwen3-coder.
Follows WALKINPOLICY1 (collected 35415906): `Godot/scripts/rules/WalkInPolicy.gd` exists on master - `POLICIES`, `resolve()`, `summary()`.
The FLOOR side (walk-ins resolving themselves by the policy) is a later step - do NOT touch GymClub3D.gd (another agent owns it now).

## Do
1. `Godot/scripts/GameState.gd` (very large - NEVER read it whole; use `grep -n` / line windows). In `func apply_floor_effect(effect: Dictionary)`
   (line ~5663; its `match` has kinds "station_level" at ~5694 and "reputation" at ~5699) add a kind `"walk_in_policy"`:
   `get_gym()["walk_in_policy"] = <effect.policy>` when the policy is one of WalkInPolicy.POLICIES (load the module with
   `load("res://scripts/rules/WalkInPolicy.gd")`), else return {"ok": false, "reason": "Unknown policy"}. Add `func get_walk_in_policy() -> String`
   next to it returning the saved value or "open_door". Typed reads only (`str(effect.get("policy", ""))`).
2. `Godot/scripts/ui/GymUpgradesPanel.gd` (371 lines; `_build_ui` 63-151, `_refresh` 153+): add a "WALK-IN POLICY" row above the station rows:
   4 buttons (one per policy, label = summary().label), the current one styled primary (`_style_button(btn, true)`), each with a tooltip of
   summary().line + income/noise. Pressing one calls `_game_state.apply_floor_effect({"kind": "walk_in_policy", "policy": id})` then `_refresh()`.
   Keep the panel's colours/fonts (C_GOLD, C_CREAM, C_MUTED, font sizes 14-16).
3. Behind the switch: the row shows only when `GameSwitches.on("walk_in_policy")`; add `"walk_in_policy": true,` to `GameSwitches.GAME_ON`
   (`Godot/scripts/GameSwitches.gd` line ~5-20) with a one-line `##` comment like its neighbours. Plain `--script` tests are the OFF arm.

## Tests (red on master first - paste the red line in your final message)
- New `Godot/tests/walk_in_policy_office_test.gd` (`extends SceneTree`, `_initialize`, print `WALK_IN_POLICY_OFFICE failures=N`, quit 0/1):
  with a GameState instance the way `tests/gym_upgrades_panel_test.gd` builds one (copy its setup), assert: default get_walk_in_policy() ==
  "open_door"; apply_floor_effect walk_in_policy "closed_in_camp" saves it; an unknown policy is refused and leaves the value; with the switch
  forced ON the panel has 4 policy buttons and the current one is marked; with it OFF there is no policy row.
  (Grep tests/ for how other tests force a GAME_ON switch on - copy that pattern, do not invent one.)
- Must stay green: `tests/gym_upgrades_panel_test.gd`, `tests/walk_in_policy_test.gd`, `tests/floor_actions_test.gd`.

## Gate
Parse: `python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/ui/GymUpgradesPanel.gd Godot/scripts/GameSwitches.gd Godot/tests/walk_in_policy_office_test.gd`
Each test: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd` (exactly that exe; no window).

## Rules
GDScript traps: research/GDSCRIPT_TRAPS.md. Touch ONLY the 4 files named. Never delete or weaken a test. Nothing opens on screen.

## Prior research
TASK_WALKINPOLICY1.md; GYMFLOOR_MECHANICS_IDEAS_S234.md (Ludo r97 Cut 1: "a simple passive policy toggle in the office").

## What would a human do?
The owner sets the door rule once in the office; nobody asks him again until he changes it.

## Prefab check
None - Godot built-in Buttons in our existing panel.

## The one trap
GameState.gd is ~29,000 lines: read only the windows you need; one wrong edit there breaks every test.


## CORRECTION (Claude, S235, after launch)
apply_floor_effect reads the effect's TYPE from the key `"type"` (`var kind := str(effect.get("type", ""))`), not `"kind"`. Everywhere this brief says `{"kind": "walk_in_policy", "policy": id}` use `{"type": "walk_in_policy", "policy": id}`.

