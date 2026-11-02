# TASK RECOVERY1B (S217) - Recovery Rate reaches the fight's stamina recovery (engine wiring, behind a switch)

Model: cloud Qwen (label `qwen`). Branch `qwen/issue-<n>` from master. Never master. Depends on RECOVERY1A (RecoveryRate.gd on master).

## Why
Operator approved Ludo r49 (board Q-S212-7, "Approve - build it"): every boxer has a RECOVERY RATE (0-100, 50 = average) that
changes how fast he gets his wind back. RECOVERY1A built the pure module `Godot/scripts/RecoveryRate.gd`
(`static func factor(rate) -> float` = `1.0 + (rate - 50) / 50 * 0.25`, so factor(50) == 1.0, factor(100) == 1.25, factor(0) == 0.75).
This task makes the fight use it.

## Do
1. `Godot/scripts/FightStamina.gd` (159 lines, read whole): add an optional LAST parameter `recovery_factor: float = 1.0` to
   `rest_recovery(stamina, conditioning, rest_seconds, recovery_factor := 1.0)` and
   `in_round_recovery(stamina, round_start_stamina, conditioning, seconds, recovery_factor := 1.0)`.
   Multiply `_recover_scale(conditioning)` by `recovery_factor` in both (clamp the factor to [0.5, 1.5]; NaN/inf -> 1.0).
   With the default 1.0 every existing caller and test is unchanged.
2. `Godot/scripts/FightRealtime.gd` (9,543 lines - NEVER read whole; use `sed -n` windows):
   - near line 1710 (`if bool(options.get("technique_effects", false)):`): add the same pattern for a new switch
     `recovery_rate`: `if bool(options.get("recovery_rate", false)): state["recovery_rate"] = true`.
   - fighter dict build near line 2158 (beside `"conditioning":`): add
     `"recovery_rate": clampf(float(athlete.get("recovery_rate", 50.0)), 0.0, 100.0),`
   - the 3 call sites (lines ~2929 `Stamina.rest_recovery(`, ~5125 `Stamina.in_round_recovery(`, ~8792 clinch holder
     `Stamina.rest_recovery(`): pass `_recovery_factor(state, fighter)` as the new last argument, where
     ```gdscript
     static func _recovery_factor(state: Dictionary, fighter: Dictionary) -> float:
         if not bool(state.get("recovery_rate", false)):
             return 1.0
         return RecoveryRate.factor(float(fighter.get("recovery_rate", 50.0)))
     ```
     (preload RecoveryRate at the top beside the other preloads: `const RecoveryRate := preload("res://scripts/RecoveryRate.gd")`
     - check the name is not already used; GDSCRIPT_TRAPS.md "reused names").
   - add `"recovery_rate": true` to `DEMO_SWITCHES` (line 1194).
3. `Godot/scripts/GameSwitches.gd` (52 lines): add `"recovery_rate": true` to `GAME_ON`.
4. NEW test `Godot/tests/recovery_rate_fight_test.gd` (blind, from this contract):
   a. FightStamina: `rest_recovery(50, 60, 60)` == `rest_recovery(50, 60, 60, 1.0)` exactly; factor 1.25 recovers MORE, 0.75 LESS;
      same for `in_round_recovery`.
   b. Switch OFF control arm: run the same seeded boxing bout twice through FightRealtime (copy the bout setup from
      `Godot/tests/fight_in_round_recovery_test.gd` or `fight_stamina_test.gd`) with athletes whose `recovery_rate` differ
      (A 85, B 20) and the switch OFF: the stamina trace must be byte-identical to the same bout with both at 50 (OFF ignores it).
   c. Switch ON: two DIFFERENT fighters (different stats, NEVER identical - CLAUDE.md s5), same seed, run once with A's rate 85 and
      once with A's rate 20: A's mean stamina at the bell of rounds 2..N is HIGHER with 85 (bound: strictly greater, report both).
   d. Switch ON with both rates 50: byte-identical to switch OFF (factor(50) == 1.0 exactly).
   Print `recovery_rate_fight_test: <n> checks, <f> failure(s)` and the numbers of c.
5. Run (Linux CI image has Godot): parse gate, then
   `godot --headless --path Godot --script tests/recovery_rate_fight_test.gd`, then the existing
   `tests/fight_stamina_test.gd`, `tests/fight_in_round_recovery_test.gd`, `tests/game_switches_test.gd` - all must stay green.
   If game_switches_test lists every switch, add `recovery_rate` where it expects (read it; do not loosen it).

## Owned files
- Godot/scripts/FightStamina.gd
- Godot/scripts/FightRealtime.gd (only the 5 spots above)
- Godot/scripts/GameSwitches.gd
- Godot/tests/recovery_rate_fight_test.gd (new)
- Godot/tests/game_switches_test.gd (only if it enumerates switches)

## Prior research
Ludo r49 (`research/LUDO_*r49*`), TASK_RECOVERY1A.md (the factor curve, scouting ranges), FightStamina.gd S134b comments
(in-round fast share). `python Tools/prior_research.py recovery stamina` lists the rest.

## What would a human do?
Add the multiplier where recovery is computed, default it to neutral so nothing old moves, prove OFF is byte-identical and
ON moves the right way between two different men.

## Prefab check
None - internal stamina model.

## Not this task
Giving athletes a generated `recovery_rate` (RecoveryRate.generate at creation + save) is RECOVERY1D; profile bars and Tale of the
Tape rows are RECOVERY1C. Without 1D every athlete reads 50 -> no change in a career yet; that is expected.

## The one trap
FightRealtime.gd is huge and its names collide easily: grep before adding `RecoveryRate` / `_recovery_factor`; a parse error hangs
every headless test. Run the parse gate first.
