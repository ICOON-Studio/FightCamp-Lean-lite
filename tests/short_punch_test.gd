extends SceneTree
## ShortPunch: 7 tests.
## 1. path_at: interpolation, before/after range, empty path.
## 2. skip: exact sample hit and mid-segment interpolation.
## 3. skip clamp: MIN_WIND_S floor with default and doubled speed.
## 4. skip edge cases: path too short, empty path, zero contact.
## 5. want: range, known moves, unknown move, roll sensitivity.
## 6. merge: later start wins.
## 7. Non-uniform samples: interpolation with irregular time gaps.

const SP := preload("res://scripts/rules/ShortPunch.gd")

var failures := 0


func _initialize() -> void:
	_test1_path_at()
	_test2_skip_basic()
	_test3_skip_clamp()
	_test4_skip_edges()
	_test5_want()
	_test6_merge()
	_test7_nonuniform()
	print("SHORT_PUNCH failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures += 1
		print("  FAIL: " + msg)


func _approx(a: float, b: float, eps: float = 0.001) -> bool:
	return abs(a - b) <= eps


func _test1_path_at() -> void:
	var P := [[0.0, 0.0], [0.1, 0.10], [0.2, 0.30], [0.3, 0.60], [0.4, 0.80], [0.5, 0.85]]
	_check(_approx(SP.path_at(P, 0.25), 0.45), "path_at(P, 0.25) should be 0.45, got %f" % SP.path_at(P, 0.25))
	_check(_approx(SP.path_at(P, -1.0), 0.0), "path_at(P, -1) should be 0.0, got %f" % SP.path_at(P, -1.0))
	_check(_approx(SP.path_at(P, 9.0), 0.85), "path_at(P, 9) should be 0.85, got %f" % SP.path_at(P, 9.0))
	_check(_approx(SP.path_at([], 0.0), 0.0), "path_at([], 0) should be 0.0")


func _test2_skip_basic() -> void:
	var P := [[0.0, 0.0], [0.1, 0.10], [0.2, 0.30], [0.3, 0.60], [0.4, 0.80], [0.5, 0.85]]
	_check(_approx(SP.skip(P, 0.4, 0.20), 0.3), "skip(P, 0.4, 0.20) should be 0.3, got %f" % SP.skip(P, 0.4, 0.20))
	_check(_approx(SP.skip(P, 0.4, 0.30), 0.2667), "skip(P, 0.4, 0.30) should be ~0.2667, got %f" % SP.skip(P, 0.4, 0.30))


func _test3_skip_clamp() -> void:
	var P := [[0.0, 0.0], [0.1, 0.10], [0.2, 0.30], [0.3, 0.60], [0.4, 0.80], [0.5, 0.85]]
	_check(_approx(SP.skip(P, 0.4, 0.01), 0.32), "skip(P, 0.4, 0.01) clamped should be 0.32, got %f" % SP.skip(P, 0.4, 0.01))
	_check(_approx(SP.skip(P, 0.4, 0.01, 2.0), 0.24), "skip(P, 0.4, 0.01, 2.0) clamped should be 0.24, got %f" % SP.skip(P, 0.4, 0.01, 2.0))


func _test4_skip_edges() -> void:
	var P := [[0.0, 0.0], [0.1, 0.10], [0.2, 0.30], [0.3, 0.60], [0.4, 0.80], [0.5, 0.85]]
	_check(_approx(SP.skip(P, 0.4, 0.95), 0.0), "skip(P, 0.4, 0.95) path too short should be 0.0, got %f" % SP.skip(P, 0.4, 0.95))
	_check(_approx(SP.skip([], 0.4, 0.2), 0.0), "skip([], 0.4, 0.2) empty path should be 0.0")
	_check(_approx(SP.skip(P, 0.0, 0.2), 0.0), "skip(P, 0.0, 0.2) zero contact should be 0.0, got %f" % SP.skip(P, 0.0, 0.2))


func _test5_want() -> void:
	for move in SP.TRAVEL_M:
		for roll in [0.0, 0.5, 1.0]:
			var w: float = SP.want(move, roll)
			_check(w >= 0.15 and w <= 0.30, "want(%s, %f) = %f out of [0.15, 0.30]" % [move, roll, w])
	_check(_approx(SP.want("lead_hook", 0.5), 0.25), "want(lead_hook, 0.5) should be 0.25, got %f" % SP.want("lead_hook", 0.5))
	_check(_approx(SP.want("??", 0.5), 0.22), "want(??, 0.5) should be 0.22, got %f" % SP.want("??", 0.5))
	_check(SP.want("lead_hook", 0.0) != SP.want("lead_hook", 1.0), "want(lead_hook, 0.0) should differ from want(lead_hook, 1.0)")


func _test6_merge() -> void:
	_check(_approx(SP.merge(0.1, 0.3), 0.3), "merge(0.1, 0.3) should be 0.3, got %f" % SP.merge(0.1, 0.3))
	_check(_approx(SP.merge(0.3, 0.0), 0.3), "merge(0.3, 0.0) should be 0.3, got %f" % SP.merge(0.3, 0.0))


func _test7_nonuniform() -> void:
	var Q := [[0.0, 0.0], [0.05, 0.02], [0.30, 0.50], [0.35, 0.70]]
	var result: float = SP.skip(Q, 0.35, 0.25)
	_check(_approx(result, 0.2740, 0.005), "skip(Q, 0.35, 0.25) should be ~0.274, got %f" % result)
