extends SceneTree

# Blind contract test for TrainingPreview.gd — module may be absent.
#
# Contract (exact names):
#   preview_gain(stats, potential, station, coach_rating, crowd_factor, fraction) -> {stat_key: gain_float}
#   Per stat:
#     headroom = clamp((potential - current) / 25.0, 0.10, 1.25)   (S292 pace, board Q-S289-2; was /20, 0.15-1.0)
#     gain = 1.0 * (0.7 + 0.3 * quality_tier) * (condition / 100.0)
#          * (0.5 + coach_rating / 100.0 * 0.7) * headroom * fraction * crowd_factor
#   Station training_modifiers are stat keys ("strength" aliases "power");
#   a stat counts once even if two tags map to it; a stat the fighter does not
#   have is skipped. Empty station or fraction <= 0 returns {}.
#   progress_to_next(value) -> fractional part in [0, 1).

var checks: int = 0
var bad: int = 0
var M: GDScript

const E4: float = 0.0001

func _initialize() -> void:
	M = load("res://scripts/rules/TrainingPreview.gd") as GDScript
	if M == null:
		print("SKIP: TrainingPreview.gd is absent - this contract test is blind and the module has not been written yet.")
		print("SUITE total=0 fails=0")
		quit(0)
		return
	_rows_headroom()
	_rows_quality_condition()
	_rows_coach_crowd()
	_rows_fraction()
	_rows_edge_cases()
	_rows_dup_tags()
	_rows_mutants()
	_rows_progress()
	_rows_plan()
	print("checks=%d checks_failed=%d" % [checks, bad])
	print("SUITE total=1 fails=%d" % (1 if bad > 0 else 0))
	quit(0 if bad == 0 else 1)

# --- reference implementation (contract formula) ---

func _ref_headroom(current: float, potential: int) -> float:
	var raw: float = (float(potential) - current) / 25.0
	return clampf(raw, 0.10, 1.25)

func _ref_gain(current: float, potential: int, quality_tier: int, condition: int,
		coach: float, crowd: float, frac: float) -> float:
	var hr: float = _ref_headroom(current, potential)
	return 1.0 * (0.7 + 0.3 * float(quality_tier)) * (float(condition) / 100.0) \
		* (0.5 + coach / 100.0 * 0.7) * hr * frac * crowd

# --- helpers ---

func _eq_f(tag: String, got: float, want: float) -> void:
	checks += 1
	if is_nan(got) or is_inf(got) or absf(got - want) > E4:
		bad += 1
		print("BAD %s: expected %.6f got %.6f" % [tag, want, got])

func _eq_i(tag: String, got: int, want: int) -> void:
	checks += 1
	if got != want:
		bad += 1
		print("BAD %s: expected %d got %d" % [tag, want, got])

func _check_gain(tag: String, got: Dictionary, expected: Dictionary) -> void:
	var gk: Array = got.keys()
	var ek: Array = expected.keys()
	checks += 1
	if gk.size() != ek.size():
		bad += 1
		print("BAD %s: key count expected %d got %d" % [tag, ek.size(), gk.size()])
		return
	for k in ek:
		if not got.has(k):
			checks += 1
			bad += 1
			print("BAD %s: missing key %s" % [tag, str(k)])
			continue
		var gv: float = float(got[k])
		var ev: float = float(expected[k])
		_eq_f("%s.%s" % [tag, str(k)], gv, ev)

func _call_preview(stats: Dictionary, potential: int, station: Dictionary,
		coach: float, crowd: float, frac: float) -> Dictionary:
	var result: Variant = Callable(M, "preview_gain").call(
		stats, potential, station, coach, crowd, frac)
	return result as Dictionary

# --- test rows ---

## S292: row values recomputed for rate 1.0 and headroom /25 clamped 0.10-1.25 (q3 1.6, coach 50 0.85). R02 moved 97 -> 99 so it
## still lands on the floor (3/25 = 0.12 is above the new 0.10 floor; 1/25 = 0.04 clamps).
func _rows_headroom() -> void:
	# Row 1: headroom floor. current=10 potential=80 -> raw=3.5 clamped to 1.0
	# gain = 0.6 * 1.6 * 1.0 * 0.85 * 1.0 * 1.0 * 1.0 = 0.816
	var got1: Dictionary = _call_preview(
		{"power": 10.0}, 80,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 100},
		50.0, 1.0, 1.0)
	_check_gain("R01_headroom_floor", got1, {"power": 1.7})

	# Row 2: headroom ceiling. current=97 potential=100 -> raw=0.15 clamped to 0.15
	# gain = 0.6 * 1.6 * 1.0 * 0.85 * 0.15 * 1.0 * 1.0 = 0.1224
	var got2: Dictionary = _call_preview(
		{"power": 99.0}, 100,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 100},
		50.0, 1.0, 1.0)
	_check_gain("R02_headroom_ceil", got2, {"power": 0.136})

func _rows_quality_condition() -> void:
	# Row 3: quality 1 (not 3). headroom 2.5 -> clamped 1.0
	# gain = 0.6 * 1.0 * 1.0 * 0.85 * 1.0 * 1.0 * 1.0 = 0.51
	var got3: Dictionary = _call_preview(
		{"power": 50.0}, 100,
		{"training_modifiers": ["power"], "quality_tier": 1, "condition": 100},
		50.0, 1.0, 1.0)
	_check_gain("R03_quality1", got3, {"power": 1.0625})

	# Row 4: condition 50 (not 100)
	# gain = 0.6 * 1.6 * 0.5 * 0.85 * 1.0 * 1.0 * 1.0 = 0.408
	var got4: Dictionary = _call_preview(
		{"power": 50.0}, 100,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 50},
		50.0, 1.0, 1.0)
	_check_gain("R04_condition50", got4, {"power": 0.85})

func _rows_coach_crowd() -> void:
	# Row 5: coach 0 (not 50)
	# gain = 0.6 * 1.6 * 1.0 * 0.5 * 1.0 * 1.0 * 1.0 = 0.48
	var got5: Dictionary = _call_preview(
		{"power": 50.0}, 100,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 100},
		0.0, 1.0, 1.0)
	_check_gain("R05_coach0", got5, {"power": 1.0})

	# Row 6: crowd 0.7 (not 1.0)
	# gain = 0.6 * 1.6 * 1.0 * 0.85 * 1.0 * 1.0 * 0.7 = 0.5712
	var got6: Dictionary = _call_preview(
		{"power": 50.0}, 100,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 100},
		50.0, 0.7, 1.0)
	_check_gain("R06_crowd07", got6, {"power": 1.19})

func _rows_fraction() -> void:
	# Row 7: fraction 0.5
	# gain = 0.6 * 1.6 * 1.0 * 0.85 * 1.0 * 0.5 * 1.0 = 0.408
	var got7: Dictionary = _call_preview(
		{"power": 50.0}, 80,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 100},
		50.0, 1.0, 0.5)
	_check_gain("R07_fraction_half", got7, {"power": 0.816})

func _rows_edge_cases() -> void:
	# Row 8: fraction 0 -> {}
	var got8: Dictionary = _call_preview(
		{"power": 50.0}, 100,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 100},
		50.0, 1.0, 0.0)
	_check_gain("R08_frac0", got8, {})

	# Row 9: empty station -> {}
	var got9: Dictionary = _call_preview({}, 100, {}, 50.0, 1.0, 1.0)
	_check_gain("R09_empty_station", got9, {})

	# Row 10: stat fighter doesn't have -> skipped -> {}
	var got10: Dictionary = _call_preview(
		{"speed": 50.0}, 100,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 100},
		50.0, 1.0, 1.0)
	_check_gain("R10_missing_stat", got10, {})

func _rows_dup_tags() -> void:
	# Row 11: duplicate tags ["power","strength"] both -> "power"; counted once
	# gain = 0.6 * 1.6 * 1.0 * 0.85 * 0.4 * 1.0 * 1.0 = 0.3264 ... no:
	# headroom = clamp((80-60)/20, 0.15, 1.0) = clamp(1.0, 0.15, 1.0) = 1.0
	# gain = 0.6 * 1.6 * 1.0 * 0.85 * 1.0 * 1.0 * 1.0 = 0.816
	var got11: Dictionary = _call_preview(
		{"power": 60.0}, 80,
		{"training_modifiers": ["power", "strength"], "quality_tier": 3, "condition": 100},
		50.0, 1.0, 1.0)
	_check_gain("R11_dup_tags", got11, {"power": 1.088})

func _rows_mutants() -> void:
	# Row 12: proves headroom clamp. potential=200 current=100 -> raw=5.0 clamped to 1.0
	# Without clamp: gain would be 5x larger (4.08 vs 0.816)
	var got12: Dictionary = _call_preview(
		{"power": 100.0}, 200,
		{"training_modifiers": ["power"], "quality_tier": 3, "condition": 100},
		50.0, 1.0, 1.0)
	_check_gain("R12_high_headroom_clamped", got12, {"power": 1.7})

func _rows_progress() -> void:
	var p1: float = float(Callable(M, "progress_to_next").call(0.0))
	_eq_f("P1_zero", p1, 0.0)
	var p2: float = float(Callable(M, "progress_to_next").call(0.25))
	_eq_f("P2_quarter", p2, 0.25)
	var p3: float = float(Callable(M, "progress_to_next").call(41.999))
	_eq_f("P3_frac", p3, 0.999)
	var p4: float = float(Callable(M, "progress_to_next").call(42.0))
	_eq_f("P4_whole", p4, 0.0)

## Lean additions: the week plan (focus 1.0, partner 0.4, the rest 0.06) and the gold-bar rule.
func _rows_plan() -> void:
	var stats := {"conditioning": 61.6, "chin": 66.0, "power": 58.4}
	var plan: Dictionary = Callable(M, "plan_gain").call(stats, 84, "conditioning", 58.0)
	var cf: float = 0.5 + 0.58 * 0.7
	_eq_f("PL1_focus", float(plan["conditioning"]), 1.0 * cf * _ref_headroom(61.6, 84))
	_eq_f("PL2_partner", float(plan["chin"]), 0.4 * cf * _ref_headroom(66.0, 84))
	_eq_f("PL3_other", float(plan["power"]), 0.06 * cf * _ref_headroom(58.4, 84))
	_eq_i("PL4_crossed", 1 if bool(Callable(M, "crossed_point").call(61.6, 62.4)) else 0, 1)
	_eq_i("PL5_not_crossed", 1 if bool(Callable(M, "crossed_point").call(62.1, 62.9)) else 0, 0)
