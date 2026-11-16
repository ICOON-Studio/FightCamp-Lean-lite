extends SceneTree
## HIT_STEP: a landed punch moves the hit boxer back (pure rule, no wiring).

const HS := preload("res://scripts/fight3d/HitStep.gd")

var failures: int = 0


func _initialize() -> void:
	_check_kind()
	_check_back_m_order()
	_check_room_cap()
	_check_at()
	_check_moved_ends_at_back_m()
	_check_top_speed()
	_check_at_zero_over()
	_report()


func _report() -> void:
	if failures == 0:
		print("HIT_STEP failures=0")
		quit(0)
	else:
		print("HIT_STEP failures=%d" % failures)
		quit(1)


func _check(cond: bool, what: String) -> void:
	if cond:
		print("PASS " + what)
	else:
		failures += 1
		print("FAIL " + what)


func _check_kind() -> void:
	_check(HS.kind("jab", false) == "jab", "kind jab -> jab")
	_check(HS.kind("cross", false) == "power", "kind cross -> power")
	_check(HS.kind("hook", false) == "power", "kind hook -> power")
	_check(HS.kind("uppercut", false) == "power", "kind uppercut -> power")
	_check(HS.kind("body_hook", false) == "body", "kind body_hook -> body")
	_check(HS.kind("pro_kidney_shot", false) == "body", "kind pro_kidney_shot -> body")
	_check(HS.kind("jab", true) == "big", "kind big flag -> big")


func _check_back_m_order() -> void:
	var jab_v: float = HS.back_m("jab", false)
	var pow_v: float = HS.back_m("cross", false)
	var body_v: float = HS.back_m("body_hook", false)
	var big_v: float = HS.back_m("cross", true)
	_check(jab_v < pow_v, "jab < power (%.4f < %.4f)" % [jab_v, pow_v])
	_check(pow_v < body_v, "power < body (%.4f < %.4f)" % [pow_v, body_v])
	_check(body_v < big_v, "body < big (%.4f < %.4f)" % [body_v, big_v])


func _check_room_cap() -> void:
	var tight: float = HS.back_m("cross", true, 0.05)
	_check(absf(tight - 0.05) < 0.0001, "room 0.05 caps big to 0.05 (got %.4f)" % tight)
	var neg: float = HS.back_m("cross", true, -1.0)
	_check(absf(neg) < 0.0001, "room -1 -> 0 (got %.4f)" % neg)


func _check_at() -> void:
	var ov: float = 0.3
	_check(absf(HS.at(0.0, ov)) < 0.0001, "at(0) is 0")
	_check(absf(HS.at(ov * 0.5, ov) - 0.5) < 0.0001, "at(mid) is 0.5")
	_check(absf(HS.at(ov, ov) - 1.0) < 0.0001, "at(over) is 1")
	var prev: float = 0.0
	var mono: bool = true
	for i in range(1, 21):
		var t: float = ov * float(i) / 20.0
		var v: float = HS.at(t, ov)
		if v < prev - 0.0001:
			mono = false
		prev = v
	_check(mono, "at() never decreases over 20 samples")


func _check_moved_ends_at_back_m() -> void:
	var kinds: Array = ["jab", "cross", "body_hook", "cross"]
	var bigs: Array = [false, false, false, true]
	for i in kinds.size():
		var mv: String = kinds[i]
		var bg: bool = bigs[i]
		var bm: float = HS.back_m(mv, bg)
		var ov: float = HS.over_s(mv, bg)
		var end_v: float = HS.moved(mv, bg, ov)
		_check(absf(end_v - bm) < 0.0001, "moved ends at back_m for %s big=%s (got %.6f vs %.6f)" % [mv, str(bg), end_v, bm])


func _check_top_speed() -> void:
	var kinds: Array = ["jab", "cross", "body_hook", "cross"]
	var bigs: Array = [false, false, false, true]
	var dt: float = 1.0 / 60.0
	for i in kinds.size():
		var mv: String = kinds[i]
		var bg: bool = bigs[i]
		var ov: float = HS.over_s(mv, bg)
		var max_step: float = 0.0
		var prev_m: float = HS.moved(mv, bg, 0.0)
		var steps: int = int(ceil(ov / dt)) + 1
		for s in range(1, steps):
			var t: float = float(s) * dt
			var cur_m: float = HS.moved(mv, bg, t)
			var step: float = absf(cur_m - prev_m)
			if step > max_step:
				max_step = step
			prev_m = cur_m
		var top_mps: float = max_step / dt
		_check(top_mps <= HS.MAX_MPS + 0.01, "top speed %.4f <= %.4f for %s big=%s" % [top_mps, HS.MAX_MPS + 0.01, mv, str(bg)])


func _check_at_zero_over() -> void:
	_check(absf(HS.at(0.1, 0.0) - 1.0) < 0.0001, "at(0.1, 0.0) is 1")
