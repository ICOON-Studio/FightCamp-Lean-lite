# TASK FIGHTLINK2 - per-move mastery as a pure rules module (boxing)

Model: Arena (cloud). Discipline: BOXING (demo). Fast lane: ADD ONLY two new files, touch nothing else.

## Why
Operator S248 (verbatim): "how skill training impacts how good a move is and how this shown in the fight" and "Go - build FIGHTLINK
in that order: evasion/chin/accuracy, move mastery, ...". Design: Ludo r115 Part 1 (research/ludo_rx/LUDO_R115_raw.txt) - every
punch a fighter knows has a mastery 0-100 that changes how that punch performs. Claude wires the module into training and the fight
afterwards - you only write the module and its test.

## Files you create (only these)
1. `Godot/scripts/rules/MoveMastery.gd` - `extends RefCounted`, ALL functions `static`, NO preloads, NO autoloads, NO scene access.
2. `Godot/tests/move_mastery_test.gd` - `extends SceneTree`, `OK  <label>` / `FAIL <label>` lines, ends with
   `print("MOVE_MASTERY failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`.

## API (exact names; attributes 0-100, mastery m 0-100)
- `static func tier(m: float) -> String` - "UNLEARNED" (m <= 0), "RAW" (<30), "USABLE" (<60), "SHARP" (<85), "SIGNATURE" (>=85).
- `static func cap(technique: float, ring_iq: float) -> float` - clamp(40 + 0.4*technique + 0.2*ring_iq, 50, 100).
- `const GAIN_PER_HOUR := {"pads": 2.1, "heavy_bag": 1.05, "shadowbox": 0.85, "ring_sparring": 1.5, "speed_bag": 0.9, "double_end": 1.2}`
- `static func gain(m: float, station: String, minutes: float, coach_skill: float, station_tier: int, efficiency: float, cap_value: float) -> float`
  returns the NEW mastery: dm = GAIN_PER_HOUR[station] * minutes/60 * (station_tier / 2.0) * (1.0 + 0.40 * coach_skill/100)
  * max(0.0, 1.0 - m / cap_value) * clamp(efficiency, 0, 1); unknown station -> 0 gain; result clamped to [m, cap_value] (never above
  the cap, never below m). An UNLEARNED move (m = 0) drilled for any positive gain starts at least at 1.0.
- `static func decay_week(m: float, drilled_this_week: bool) -> float` - not drilled: m - 0.75, but never below 30 if m was >= 30 and
  never below 0; drilled: unchanged.
- `static func effects(m: float, hand_speed: float, technique: float, ring_iq: float) -> Dictionary` - the punch's performance as
  MULTIPLIERS on today's engine, NORMALISED so a USABLE punch of an average fighter (m 45, hand_speed 50, technique 50, ring_iq 50)
  returns exactly 1.0 for every multiplier (today's balance holds; only differences move fights). Raw formulas (Ludo r115):
  windup = 1.0 - 0.18*hs/100 - 0.22*m/100; power_transfer = 0.50 + 0.25*tech/100 + 0.25*m/100;
  recovery = 1.0 - 0.15*tech/100 - 0.30*m/100; stamina = 1.30 - 0.20*tech/100 - 0.40*m/100;
  telegraph = 1.0 - 0.30*tech/100 - 0.60*m/100 (clamp >= 0.05); select = (0.60*iq + 0.40*m)/100.
  Return {"windup_mult", "power_mult", "recovery_mult", "stamina_mult", "telegraph", "select_mult", "tier"} where each *_mult =
  raw / raw_at_baseline, "telegraph" is the RAW 0..1 value scaled by 0.5 / telegraph_at_baseline (baseline punch reads 0.5), and "tier" = tier(m).
- `static func describe(move_name: String, m: float) -> String` - e.g. "Sharp Jab (M88)", "Raw Rear Uppercut (M18)"; tier word in
  Title case; m rounded.
- `static func fight_note(fighter: String, move_name: String, m: float, landed: bool) -> String` - one quiet line for the fight, e.g.
  "Reyes fires Sharp Jab (M88) - lands clean" / "Reyes throws Raw Jab (M22) - telegraphed, slipped". Never empty.

## The test (from this contract)
- tier boundaries exactly (0, 1, 29.9, 30, 59.9, 60, 84.9, 85, 100).
- cap: tech 50 iq 60 -> 72.0; clamps at 50 and 100.
- gain: 60 min pads, tier 2, coach 0, efficiency 1, m 0, cap 100 -> 2.1 (+-0.01); coach 100 -> 2.94; tier 4 doubles; efficiency 0.5
  halves; never exceeds cap; never decreases; unknown station unchanged; m 0 with tiny gain -> >= 1.0.
- decay: 50 -> 49.25; 30.5 -> 30 floor; 20 -> 19.25; drilled -> unchanged.
- effects at baseline: every *_mult == 1.0 (+-0.0001), telegraph == 0.5. Signature (m 95, hs 85, tech 80, iq 70): windup_mult < 0.85,
  power_mult > 1.15, recovery_mult < 0.85, stamina_mult < 0.80, telegraph < 0.25. Raw (m 10, hs 50, tech 50, iq 50): the opposite
  direction for all five. Monotonic sweep m 0..100: windup/recovery/stamina/telegraph fall, power/select rise.
- describe / fight_note exact examples above.

## Prior research
- research/ludo_rx/LUDO_R115_raw.txt (Part 1 formulas, tiers, gain, cap, decay; Part 2 example wording).
- research/FIGHT_SIM_MAP_S248.md (the engine these multipliers plug into), FIGHTLINK_DIRECTION_S248.md.

## What would a human do?
Normalise everything around today's average punch so wiring it in changes nothing for an average fighter, then let mastery push a
punch better or worse from there - and test the baseline, the extremes and the monotonic sweeps.

## Prefab check
Pure math module; no asset or library applies.

## Gates
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/MoveMastery.gd Godot/tests/move_mastery_test.gd`
- Test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/move_mastery_test.gd` (CI runs it on your PR).
- PR body must contain: `RESULT: tests/move_mastery_test.gd -> MOVE_MASTERY failures=0`

## The one trap
GDScript: `:=` cannot infer a type from a Variant (Dictionary values, `GAIN_PER_HOUR.get(...)`) - type it explicitly. Do not delete
or weaken a check to go green.

## Contract
(S249 machine-readable block - Tools/brief_contract.py; Tools/code_gate.py merges against it.)
OWNS: Godot/scripts/rules/MoveMastery.gd, Godot/tests/move_mastery_test.gd
RED_TEST: tests/move_mastery_test.gd -> MOVE_MASTERY failures=0
REGRESSION: move_mastery_test
VISUAL: no
