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
	_check_wire()
	_check_shown_base()
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
	# S502: a clean cross steps back 15-20 cm (blind critics r8); a hook less (it turns the head).
	_check(pow_v >= 0.15 and pow_v <= 0.20, "a cross steps back 15-20 cm (%.3f)" % pow_v)
	_check(HS.back_m("lead_hook", false) < pow_v, "a hook steps back less than a cross")


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


## S500 the wiring: a hit boxer's place goes back along the blow, capped by the ropes; the body rocks first.
func _check_wire() -> void:
	var bx: Dictionary = {"pos": Vector3(0.0, 0.0, 1.0)}
	HS.start(bx, Vector3(0.0, 0.0, 0.0), "body_hook", false, 2.69)
	_check(bx.has("knock"), "a clean body shot starts a step back")
	var at: Vector3 = bx["pos"]
	var worst: float = 0.0
	var mid_speed: float = 0.0
	for f in 60:
		var step: Vector3 = HS.tick(bx, 1.0 / 60.0)
		worst = maxf(worst, step.length() * 60.0)
		at += step
		if f == 5:
			mid_speed = HS.speed(bx)
	_check(absf(at.z - 1.16) < 0.001 and absf(at.x) < 0.001, "the place ends 16 cm straight back (z %.3f)" % at.z)
	_check(worst <= HS.MAX_MPS + 0.01, "never faster than %.1f m/s (worst %.2f)" % [HS.MAX_MPS, worst])
	_check(mid_speed > 0.5, "mid-way the feet are timed on a moving place (%.2f m/s)" % mid_speed)
	_check(not bx.has("knock"), "a second later it is over and gone")
	_check(HS.tick(bx, 1.0 / 60.0) == Vector3.ZERO and HS.speed(bx) == 0.0, "nothing moves with no step back running")
	# the ropes: 5 cm of room caps a big shot to 5 cm
	var roped: Dictionary = {"pos": Vector3(0.0, 0.0, 2.64)}
	HS.start(roped, Vector3(0.0, 0.0, 1.6), "cross", true, 2.69)
	_check(absf(float(roped["knock"]["m"]) - 0.05) < 0.001, "5 cm from the ropes a big shot moves 5 cm (%.3f)" % float(roped["knock"]["m"]))
	var on_ropes: Dictionary = {"pos": Vector3(2.69, 0.0, 0.0)}
	HS.start(on_ropes, Vector3(1.7, 0.0, 0.0), "cross", true, 2.69)
	_check(not on_ropes.has("knock"), "on the ropes nothing starts")
	_check(absf(HS.room(Vector3(1.0, 0.0, 1.0), Vector3(1.0, 0.0, 1.0).normalized(), 2.0) - sqrt(2.0)) < 0.001, "room on a diagonal reads to the nearer rope")
	# S504: a clean blow stops her step toward the hitter, keeps her step sideways
	var walker: Dictionary = {"pos": Vector3(0.0, 0.0, 1.0), "vel": Vector3(0.3, 0.0, -0.8)}
	HS.start(walker, Vector3.ZERO, "cross", false, 2.69)
	_check(absf((walker["vel"] as Vector3).z) < 0.0001 and absf((walker["vel"] as Vector3).x - 0.3) < 0.0001, "a blow stops her step in, keeps her side step: %s" % str(walker["vel"]))
	var leaver: Dictionary = {"pos": Vector3(0.0, 0.0, 1.0), "vel": Vector3(0.0, 0.0, 0.5)}
	HS.start(leaver, Vector3.ZERO, "cross", false, 2.69)
	_check((leaver["vel"] as Vector3).is_equal_approx(Vector3(0.0, 0.0, 0.5)), "a step away is left alone")
	# the rock: the body goes back at once, never past LEAN_MAX_M, never sideways or forward
	var rk: Dictionary = {"pos": Vector3(0.0, 0.0, 1.0)}
	HS.start(rk, Vector3.ZERO, "cross", false, 2.69)
	_check(HS.lean(rk, Vector3(0.0, 0.0, 0.05)).distance_to(Vector3(0.0, 0.0, 0.05)) < 0.0001, "a 5 cm lag is rocked whole")
	# S504: the cap scales with the step (a cross's 0.15 m -> 0.12 m), never under LEAN_MAX_M; still a cap.
	var cap: float = HS.lean_max(rk["knock"])
	_check(cap > HS.LEAN_MAX_M and cap < 0.15, "a cross's rock cap %.3f m sits between 8 cm and its step" % cap)
	_check(absf(HS.lean(rk, Vector3(0.0, 0.0, 0.30)).length() - cap) < 0.0001, "a 30 cm lag rocks only %.2f m" % cap)
	_check(HS.lean(rk, Vector3(0.2, 0.0, -0.1)) == Vector3.ZERO, "a lag forward or sideways rocks nothing")
	# S504: the rock holds while the feet still lag (here they never arrive: 5 cm every frame), then eases out by
	# ROCK_HOLD_MAX_S after the step - 80 frames at 60 fps covers the step, the hold and the ease.
	var last: float = 0.05
	var eased: bool = true
	var held_mid := -1.0
	for f in 80:
		HS.tick(rk, 1.0 / 60.0)
		var l: float = HS.lean(rk, Vector3(0.0, 0.0, 0.05)).length()
		eased = eased and l <= last + 0.0001 and last - l < 0.012
		last = l
		if f == 30:
			held_mid = l
	_check(held_mid > 0.049, "the rock holds after the step while the feet lag (%.4f at 0.5 s)" % held_mid)
	_check(eased and last < 0.001, "the rock eases out after the hold, no pop (ends %.4f)" % last)
	# feet under the place (no lag): the rock eases out right after the step
	var rk2: Dictionary = {"pos": Vector3(0.0, 0.0, 1.0)}
	HS.start(rk2, Vector3.ZERO, "cross", false, 2.69)
	for f in 40:
		HS.tick(rk2, 1.0 / 60.0)
		HS.lean(rk2, Vector3.ZERO)
	_check(not rk2.has("knock"), "with the feet arrived the step ends within 0.67 s")


## S505: a blow on a boxer stepping in - her place 14 cm ahead of her shown feet toward the hitter. The step back is
## measured from where she is shown: 15 + 14 cm for the place, so the body still goes 15 cm back. Old rule (placebase):
## m stays 0.15 and the place only returns to her feet (s505a 133.3 s: body 1.8 cm back).
func _check_shown_base() -> void:
	var bx: Dictionary = {"pos": Vector3(0.0, 0.0, 1.0)}
	HS.start(bx, Vector3(0.0, 0.0, 0.0), "cross", false, 2.69)
	var feet := Vector3(0.0, 0.0, 1.14)   # her shown feet stand 14 cm further back than her place
	HS.lean(bx, (bx["pos"] as Vector3) - feet)
	_check(absf(float(bx["knock"]["m"]) - 0.29) < 0.001, "a place 14 cm ahead of her feet steps 29 cm (%.3f)" % float(bx["knock"]["m"]))
	_check(absf(HS.lean_max(bx["knock"]) - 0.12) < 0.001, "the rock cap stays sized on the blow's 15 cm (%.3f)" % HS.lean_max(bx["knock"]))
	HS.lean(bx, Vector3(0.0, 0.0, -0.30))
	_check(absf(float(bx["knock"]["m"]) - 0.29) < 0.001, "the lead is added once, on the first frame (%.3f)" % float(bx["knock"]["m"]))
	var behind: Dictionary = {"pos": Vector3(0.0, 0.0, 1.0)}
	HS.start(behind, Vector3(0.0, 0.0, 0.0), "cross", false, 2.69)
	HS.lean(behind, Vector3(0.0, 0.0, 0.05))   # place already 5 cm behind her feet: nothing added
	_check(absf(float(behind["knock"]["m"]) - 0.15) < 0.001, "a place behind her feet keeps the 15 cm step (%.3f)" % float(behind["knock"]["m"]))
	var roped: Dictionary = {"pos": Vector3(0.0, 0.0, 2.49)}   # 20 cm of room
	HS.start(roped, Vector3(0.0, 0.0, 1.0), "cross", false, 2.69)
	HS.lean(roped, Vector3(0.0, 0.0, -0.14))
	_check(absf(float(roped["knock"]["m"]) - 0.20) < 0.001, "the lead never steps her through the ropes (%.3f)" % float(roped["knock"]["m"]))
