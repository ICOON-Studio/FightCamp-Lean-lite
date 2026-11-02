# TASK L4READY1 - Gameplan Readiness vs the booked opponent, as a pure rules module + test (S235)

Seat: ARENA (pure module + test; CI has no LFS - this task loads no assets). Own `arena/<chat>` branch + PR; never master, never the Merge button.
Claude integrates it on the floor and into fight night afterwards.

## Why (Ludo r97, the lead designer - GYMFLOOR_MECHANICS_IDEAS_S234.md)
L4 "Gameplan Readiness vs Opponent": fun 9, cost 6, KEEP - "Connects the gym floor directly to the fight sim; gives every single station
rep and technique drill an existential purpose." Claude's C4: "the booked opponent's style pinned on the floor; stations/cards that counter
it glow; readiness 0-100% from what he drilled; feeds the fight engine at fight night."

## FILE 1: `Godot/scripts/rules/GameplanReadiness.gd`
`extends RefCounted`, STATIC functions only, ZERO preloads, NO class_name, NO autoload, NO randomness, deterministic.
- `const STYLES := ["swarmer", "out_boxer", "counter_puncher", "brawler", "southpaw", "pressure_fighter"]`
- `const COUNTERS := {style: {"stations": {station_kind: weight}, "cards": [move_id...]}}` - for EACH style, which station kinds drill the
  answer (kinds: heavy_bag, speed_bag, double_end_bag, pads, ring_spar, shadow, slip_rope, footwork_ladder, mirror, strength, cardio,
  defence_drill) and which move ids counter it (ids like "jab", "check_hook", "pivot", "lead_uppercut", "clinch_tie", "lateral_step",
  "counter_right", "body_jab", "shoulder_roll", "step_back_counter"). Comment one boxing reason per style (e.g. swarmer -> lateral_step,
  check_hook, clinch_tie; out_boxer -> cutting the ring footwork, body_jab).
- `static func plan_for(opponent: Dictionary) -> Dictionary` - opponent {"style": String, "stance": "orthodox"|"southpaw"}; a southpaw adds
  the southpaw counters on top of his style. Returns {"style", "stations": {kind: weight}, "cards": [...], "line": one coach sentence}.
  Unknown style -> {} (no gameplan, no glow).
- `static func block_credit(plan: Dictionary, station_kind: String, minutes: int, card_id: String, clean_reps: float) -> float`
  readiness points one finished block adds: 0 when the station is not in the plan; scales with minutes (cap at 90), the station weight,
  +50% when the block drilled a counter card, x clean_reps (0..1, dirty reps from Form Breakdown count less). Justify numbers in comments.
- `static func decay(readiness: float, days_since_drill: int) -> float` - readiness fades when not drilled (0 for 0-1 days, then a few % a day).
- `static func fight_mods(readiness: float) -> Dictionary` - what fight night gets: {"read_bonus": float (0..0.15, the corner reads his
  style sooner), "counter_accuracy": float (0..0.08), "label": "UNPREPARED"|"FAMILIAR"|"READY"|"DIALLED IN"}. Bands 0-24/25-59/60-84/85-100.
  Small numbers: preparation helps, never decides a fight.
- `static func glow(plan: Dictionary, station_kinds: Array) -> Array` - the station kinds on the floor that counter him (for the floor to
  light up), sorted by weight.

## FILE 2: `Godot/tests/gameplan_readiness_test.gd`
`extends SceneTree`, `func _initialize() -> void:`, load the module with `load("res://scripts/rules/GameplanReadiness.gd")`, count failures,
print `GAMEPLAN_READINESS failures=N`, `quit(0 if failures == 0 else 1)`. Assert at least: every STYLE has COUNTERS with >=2 stations and
>=2 cards; unknown style -> {}; southpaw adds counters; off-plan block = 0 credit; counter card beats no card; dirty reps (0.4) < clean (1.0);
minutes capped at 90; decay is 0 for day 1 and >0 by day 4, never below 0; fight_mods bands at 0/24/25/59/60/84/85/100 and read_bonus <= 0.15;
glow sorted by weight; deterministic (same input twice -> same output). A mutant check: comment in the test which assertion catches
"credit ignores clean_reps".

## Gate
CI "Parse gate + changed tests" green. Locally: `godot --headless --path Godot --script tests/gameplan_readiness_test.gd`.

## Rules
- Typed reads: `var x: float = float(d.get("k", 0.0))` - never `var x := d.get(...)`; never write `%%` (research/GDSCRIPT_TRAPS.md).
- Touch ONLY these two files. Never delete or weaken a test.
- New features ship ON: the floor/fight wiring (Claude, later) goes in GameSwitches.GAME_ON; plain --script tests are the OFF control arm.

## Prior research
GYMFLOOR_MECHANICS_IDEAS_S234.md (L4/C4, Ludo r97 matrix); topics/plans_corner.md (fight plans and corner calls).

## What would a human do?
A trainer watches tape of Friday's man, then spends the week on the drills that beat his style - and you can see it in sparring by Thursday.

## Prefab check
None needed - pure rules.

## The one trap
Readiness must NOT become a fight-deciding stat; keep fight_mods small and banded.
