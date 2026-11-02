# TASK DOLA_DAYPLAN1 - C7 Morning Day Plan as pure GDScript modules + tests (S235)

Operator S234 (verbatim): "ask dola to deliver big bunches of code". Ludo (lead designer) round 97: C7 Morning Day Plan - fun 9, KEEP,
"Foundational management architecture. Shifts the floor gameplay from tedious micro-clicking to strategic plan execution and tactical
audible-calling." L3 Coach Bandwidth is MERGED into it. Model: Dola (Cici). Claude integrates, runs the tests, wires it on the floor.

## The idea (Claude C7 + Ludo)
The day's blocks are laid out in the morning like Football Manager's training schedule: station + cue per block, a stamina/strain budget
shown, and which blocks the coach supervises (the coach is ONE person - he can supervise only some blocks). The floor then is about reacting
to events (Form Breakdown, Niggle, Breakthrough, floor events), not re-clicking the same order.

## Hard rules (every file) - same as your Breakthrough.gd / FloorEvents.gd (that style, exactly)
- Godot 4 GDScript. `extends RefCounted`, STATIC functions only, ZERO preloads, NO class_name, NO autoload, NO randomness inside.
- Typed: `var x: float = float(ctx.get("k", 0.0))` - never `var x := ctx.get(...)`. Never write `%%`.
- The engine owns the numbers: functions RETURN plans, multipliers, deltas and words; they never touch the game.
- Each test: `extends SceneTree`, `func _initialize() -> void:`, load the module with `load("res://scripts/rules/<Name>.gd")`, count failures,
  print `<NAME> failures=N`, `quit(0 if failures == 0 else 1)`.

## FILE 1: scripts/rules/DayPlan.gd
- Day = 06:00-20:00 game time, blocks of 30/60/90 min. Cues: "normal", "power_through", "crisp_form" (PACE YOURSELF is gone - REST is a block).
- `const TEMPLATES := {...}` at least 5 named day templates a real coach would use: "fight_week_taper", "camp_heavy", "technique_day",
  "recovery_day", "conditioning_day" - each a list of blocks {"station_kind", "minutes", "cue", "coached": bool}. Station kinds:
  heavy_bag, speed_bag, double_end_bag, pads, ring_spar, shadow, slip_rope, footwork_ladder, strength, cardio, stretch, rest, physio.
  Comment one boxing reason per template.
- `static func suggest(ctx: Dictionary) -> String` - ctx {"days_to_fight": int (-1 none booked), "fatigue": float 0..100, "niggles": [part...],
  "weekday": int 0..6}: picks a template name (taper inside 7 days of a fight, recovery when fatigue > 70 or a sev>=2 niggle, ...).
- `static func cost(plan: Array, stamina: float, strain: float) -> Dictionary` - projected end-of-day {"stamina", "strain", "coach_minutes",
  "warnings": [words]}; warnings when stamina ends < 20, strain > 80, coach_minutes > coach_capacity (240 min a day), two ring_spar blocks.
- `static func validate(plan: Array) -> Array` - problems (unknown station/cue, blocks overlap past 20:00, a block under 30 min); [] = OK.
- `static func audible(plan: Array, block_index: int, change: Dictionary) -> Dictionary` - the player changes ONE upcoming block on the floor
  (station, cue or coached); returns {"ok", "plan", "reason"}; a past or running block cannot change; coached=true refused when the coach is
  already over capacity.
- `static func coach_mods(coached: bool) -> Dictionary` - {"gain_mult", "wear_mult"}: coached = buff + less wear; unsupervised = base (1.0, 1.0).

## FILE 2: scripts/rules/DayPlanBoard.gd (the words the morning card shows - pure)
- `static func rows(plan: Array, ctx: Dictionary) -> Array` - one row per block: {"time": "06:30", "station": "Heavy bag", "cue": "Power
  through", "coached": bool, "badge": short word}; ctx has the boxer's name and the day's warnings from DayPlan.cost.
- `static func headline(template: String, days_to_fight: int) -> String` - e.g. "Fight in 5 days - taper".

## Tests: tests/day_plan_test.gd and tests/day_plan_board_test.gd
Every template validates; suggest picks taper at days_to_fight 3, recovery at fatigue 80, camp_heavy at 21 days and fresh; cost warns on a
3-spar day; coach capacity enforced; audible refuses a past block and a coached block over capacity; coach_mods coached > base; rows times
are ascending and formatted HH:MM; deterministic.

## Prior research
GYMFLOOR_MECHANICS_IDEAS_S234.md (C7, L3, Ludo r97 matrix); your own Breakthrough.gd / FloorEvents.gd (the style); scripts/rules/FormBreakdown.gd.

## What would a human do?
A head coach writes the day on the whiteboard at 7am - rounds on the bag, pads at 10, he takes the pads himself - then adjusts one block when
the fighter walks in heavy-legged.

## Prefab check
No asset; pure rules.

## Deliver
Four files in full, each in its own code block headed by its path. No placeholders, no "...", no TODO.
