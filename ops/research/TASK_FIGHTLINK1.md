# TASK FIGHTLINK1 - evasion, chin, accuracy as a pure rules module (boxing)

Model: Arena (cloud). Discipline: BOXING (demo). Fast lane: ADD ONLY two new files, touch nothing else.

## Why
Operator S248 (verbatim): "Go - build FIGHTLINK in that order: evasion/chin/accuracy, move mastery, then the profile, fight notes,
corner report and post-fight why." Direction: research/FIGHTLINK_DIRECTION_S248.md. Today's engine (FIGHT_SIM_MAP_S248.md):
defence only DOWNGRADES a landed punch (a punch can never miss because of the defender), chin does nothing, accuracy is folded into
technique. Claude wires this module into FightRealtime.gd afterwards - you only write the module and its test.

## Files you create (only these)
1. `Godot/scripts/rules/FightLink.gd` - `extends RefCounted`, ALL functions `static`, NO preloads, NO autoloads, NO scene access.
2. `Godot/tests/fight_link_test.gd` - `extends SceneTree`, prints one line per check `OK  <label>` / `FAIL <label>`, ends with
   `print("FIGHT_LINK failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`.

## API (exact names; inputs 0-100 unless said)
- `static func derive_stats(stats: Dictionary) -> Dictionary` - returns a COPY with `accuracy`, `evasion`, `chin` filled when
  missing: accuracy = technique; evasion = round(0.5*speed + 0.5*defense); chin = 50 + round((defense - 50) * 0.2) clamped 30-90.
  Existing keys are never overwritten. Missing source keys default to 50.
- `static func whiff_chance(evasion: float, accuracy: float, distance_fit: float = 1.0, telegraph: float = 0.0) -> float` - the chance the
  DEFENDER makes the punch miss completely. Shape (Ludo r114): grows with evasion, falls with attacker accuracy. Calibrate exactly:
  base = 0.22 * pow(2.0 * e / (e + a), 1.5) with e = max(evasion, 1), a = max(accuracy, 1); then x (1.0 + 0.6 * (1.0 - distance_fit))
  (a wrong-distance punch, fit 0.45, is easier to slip); then + 0.20 * telegraph (telegraph 0..1, how readable the punch was);
  clamp 0.03 .. 0.60. So: 60 vs 60 -> 0.22; 80 vs 40 -> 0.339; 40 vs 80 -> 0.120.
- `static func whiff_cost() -> Dictionary` - `{"stamina_mult": 1.5, "counter_window_s": 0.45}` (the thrower pays 1.5x the punch's
  stamina and the defender gets a 0.45 s counter window - Ludo r114).
- `static func accuracy_mult(accuracy: float) -> float` - multiplies the attacker's clean/glance thresholds: 0.85 + 0.30 * accuracy/100
  (50 -> 1.00, 100 -> 1.15, 0 -> 0.85).
- `static func chin_mult(chin: float) -> float` - multiplies head shock AND the knockdown chance: clamp(1.6 - 1.2 * chin/100, 0.5, 1.4)
  (50 -> 1.00, 80 -> 0.64, 30 -> 1.24).
- `static func head_shock(force: float, chin: float, head_wear: float) -> float` - today's engine is 0.10 * force^2 * (1 + head_wear) capped
  at 0.20; return that times chin_mult(chin), cap 0.20 * 1.4.
- `static func knockdown_chance(head_wear: float, chin: float) -> float` - today (0.09 + 0.12 * head_wear) times chin_mult(chin), clamp 0..0.6.
- `static func why_line(kind: String, data: Dictionary) -> String` - a short plain line for the fight notes, e.g. kind "whiff":
  "Perez slips the jab (evasion 78 vs accuracy 52)"; "chin": "Reyes walks through it (chin 82)"; "clean": "clean (accuracy 74)".
  Use data keys: attacker, defender, punch, evasion, accuracy, chin. Never empty for those three kinds.

## The test (write it from this contract, not from your code)
Check every number in the API section above (equal 60/60 = 0.22 +-0.005; 80/40 in 0.33-0.35; 40/80 in 0.11-0.13; clamps at the ends;
wrong distance raises it; telegraph raises it; chin 50 -> exactly 1.0; chin 80 < chin 30 for shock and knockdown; accuracy 50 -> 1.0;
derive_stats fills missing keys and keeps existing ones; why_line non-empty and names both fighters for "whiff").
Monotonic sweeps: whiff_chance strictly rises with evasion (accuracy fixed) and falls with accuracy (evasion fixed) over 10..100 step 10.

## Prior research
- research/FIGHT_SIM_MAP_S248.md (how damage/defence/knockdown work today - the constants above are copied from it).
- research/ludo_rx/LUDO_R114_raw.txt section 3 (evasion/chin/accuracy), LUDO_R115_raw.txt part 3 (formulas).
- research/FIGHTLINK_DIRECTION_S248.md.

## What would a human do?
Keep the average fighter where he is (50s give multiplier 1.0 and today's constants) so existing balance holds, and let only the
differences between fighters move outcomes - then test the extremes and the sweeps.

## Prefab check
Pure math module; no asset or library applies.

## Gates
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/FightLink.gd Godot/tests/fight_link_test.gd`
- Test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/fight_link_test.gd` (CI runs it on your PR).
- PR body must contain the line: `RESULT: tests/fight_link_test.gd -> FIGHT_LINK failures=0`

## The one trap
GDScript: `:=` cannot infer a type from a Variant (e.g. a Dictionary value) - type it explicitly (`var x: float = d.get("k", 50.0)`).
Do not delete or weaken a check to go green.

## Contract
(S249 machine-readable block - Tools/brief_contract.py; Tools/code_gate.py merges against it.)
OWNS: Godot/scripts/rules/FightLink.gd, Godot/tests/fight_link_test.gd
RED_TEST: tests/fight_link_test.gd -> FIGHT_LINK failures=0
REGRESSION: fight_link_test
VISUAL: no
