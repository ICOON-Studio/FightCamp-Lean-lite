extends SceneTree
## S392 CORNERWARM1 test: pick stability, refusal handling, window bounds and duration.

const CornerWarm := preload("res://scripts/fight3d/CornerWarm.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		failures += 1


func _initialize() -> void:
	# 1. Structure: CLIPS list has the 7 expected owned takes in order.
	var expected := [
		"rk_shadowboxing_a",
		"rk_shadowboxing_b",
		"rk_boxing",
		"cmu_13_17",
		"cmu_13_18",
		"cmu_14_01",
		"cmu_14_02",
	]
	_check(CornerWarm.CLIPS == expected, "CLIPS contains the 7 owned takes in exact order")

	# 2. Pick stability: for any seed, pick is stable across multiple calls.
	var has_all := func(_c: String) -> bool: return true
	for s in [0, 1, 2, 6, 7, 13, 42, 999, -1, -7, -100]:
		var first: String = CornerWarm.pick(s, has_all)
		var second: String = CornerWarm.pick(s, has_all)
		_check(first == second, "pick is stable for seed %d (%s)" % [s, first])
		_check(expected.has(first), "picked clip %s is one of the 7 owned takes" % first)

	# 3. Pick cycles through clips when all are available.
	for i in expected.size():
		var clip: String = CornerWarm.pick(i, has_all)
		_check(clip == expected[i], "seed %d picks %s" % [i, expected[i]])

	# 3b. S393: the two corners differ, and the same corner changes from bout to bout.
	var takes := {}
	for bout in 7:
		var red: String = CornerWarm.pick(CornerWarm.seed_for(bout, 0), has_all)
		var blue: String = CornerWarm.pick(CornerWarm.seed_for(bout, 1), has_all)
		_check(red != blue, "bout %d: the corners play different takes" % bout)
		takes[red] = true
	_check(takes.size() >= 5, "red's take changes from bout to bout (%d takes in 7 bouts)" % takes.size())

	# 4. Refusal handling: never returns a clip `has` refuses.
	var has_none := func(_c: String) -> bool: return false
	_check(CornerWarm.pick(0, has_none) == "", "pick returns empty string when has refuses all")
	_check(CornerWarm.pick(42, has_none) == "", "pick returns empty string for seed 42 when all refused")

	# Refuse all except one specific clip.
	for target in expected:
		var has_only := func(c: String) -> bool: return c == target
		for s in [0, 1, 5, 42, -3]:
			var got: String = CornerWarm.pick(s, has_only)
			_check(got == target, "only %s allowed -> got %s for seed %d" % [target, got, s])

	# Refuse one specific clip from the pool.
	for excluded in expected:
		var has_not := func(c: String) -> bool: return c != excluded
		for s in range(20):
			var got: String = CornerWarm.pick(s, has_not)
			_check(got != excluded, "excluded %s is never returned (got %s for seed %d)" % [excluded, got, s])
			_check(expected.has(got), "returned %s is a valid owned take" % got)

	# 5. Window stays inside the take and is want_s long when clip_len > want_s.
	var test_takes := [
		{"name": "rk_shadowboxing_b", "len": 5.80},
		{"name": "rk_shadowboxing_a", "len": 11.87},
		{"name": "rk_boxing", "len": 15.47},
		{"name": "cmu_13_18", "len": 24.97},
		{"name": "cmu_13_17", "len": 40.30},
		{"name": "cmu_14_02", "len": 45.17},
		{"name": "cmu_14_01", "len": 46.60},
	]
	for take in test_takes:
		var clip_len: float = float(take["len"])
		for want_s in [1.0, 1.8, 2.5, 4.0]:
			for s in [0, 1, 7, 42, 100, -1, -50]:
				var win: Vector2 = CornerWarm.window(clip_len, s, want_s)
				_check(win.x >= 0.0, "%s (%.2f s, want %.1f s, seed %d): win.x >= 0 (%.3f)" % [take["name"], clip_len, want_s, s, win.x])
				_check(win.y <= clip_len + 0.0001, "%s (%.2f s, want %.1f s, seed %d): win.y <= len (%.3f <= %.2f)" % [take["name"], clip_len, want_s, s, win.y, clip_len])
				_check(win.x <= win.y, "%s: win.x <= win.y" % take["name"])
				_check(is_equal_approx(win.y - win.x, want_s), "%s: win length is want_s (%.3f approx %.3f)" % [take["name"], win.y - win.x, want_s])

	# Window stability for a seed.
	for s in [0, 42, 99]:
		var w1: Vector2 = CornerWarm.window(15.47, s, 1.8)
		var w2: Vector2 = CornerWarm.window(15.47, s, 1.8)
		_check(w1 == w2, "window is stable for seed %d" % s)

	# 6. Window when clip_len <= want_s: returns the whole take.
	for take in test_takes:
		var clip_len: float = float(take["len"])
		var win_exact: Vector2 = CornerWarm.window(clip_len, 42, clip_len)
		_check(win_exact.x == 0.0 and is_equal_approx(win_exact.y, clip_len),
			"%s: exact len gives whole take [0, %.2f]" % [take["name"], clip_len])
		_check(is_equal_approx(win_exact.y - win_exact.x, clip_len),
			"%s: win length == whole take" % take["name"])

		var win_over: Vector2 = CornerWarm.window(clip_len, 42, clip_len + 10.0)
		_check(win_over.x == 0.0 and is_equal_approx(win_over.y, clip_len),
			"%s: want_s > len gives whole take [0, %.2f]" % [take["name"], clip_len])
		_check(is_equal_approx(win_over.y - win_over.x, clip_len),
			"%s: win length == whole take when want_s > len" % take["name"])

	# Edge cases: want_s <= 0 or clip_len <= 0.
	var win_zero_want: Vector2 = CornerWarm.window(10.0, 42, 0.0)
	_check(win_zero_want.x == 0.0 and is_equal_approx(win_zero_want.y, 10.0), "want_s <= 0 returns whole take")
	var win_zero_clip: Vector2 = CornerWarm.window(0.0, 42, 2.0)
	_check(win_zero_clip == Vector2.ZERO, "clip_len <= 0 returns Vector2.ZERO")

	print("CORNER_WARM_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)
