# Q18_DIGEST — FightHudRead: one pure fold

## Delivered

- `Godot/scripts/FightHudRead.gd` — statics only, `const` preloads of Cardio and FightTrauma.
- `Godot/tests/fight_hud_read_test.gd` — 87 checks, synthetic state dicts only.

## Contract

`static func fold(state: Dictionary) -> Dictionary` returns round, rounds_total,
seconds_elapsed, resting, over, per-side reads (id, name, heart_rate, zone,
stamina, condition, trauma, worst_trauma, total_pips, knockdowns), and score
(a, b, rounds_scored from consensus cards).

## R87 forward-compat

Missing `trauma` defaults to `FightTrauma.fresh()`, missing `age_years` to 28.0.
Module works before and after R87 lands.

## Trap avoided

- All Variant returns from `state.get()` typed explicitly (`var x: Dictionary = ...`).
- Trauma deep-copied with `.duplicate(true)` so output never aliases input.
- `worst_trauma.words` uses the worst mark's pips, not total_pips.

## Gates

- Parse: 0 fails.
- Own test: 87 checks, 0 fails.
- Suite: total=205 fails=0.

## Contract notes

None. No disagreements found.
