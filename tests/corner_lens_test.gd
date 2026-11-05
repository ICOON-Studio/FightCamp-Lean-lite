extends SceneTree
## S386 CORNERLENS1: the corner minute's lens never sits inside a body.
## Pure headless test with made-up Vector3s - no models, no display.

const CS := preload("res://scripts/fight3d/CornerShots.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1


func _in_ring(p: Vector3) -> bool:
	return absf(p.x) <= CS.HALF_M and absf(p.z) <= CS.HALF_M


func _initialize() -> void:
	# (a) lens 0.24 m from a neck point -> after keep_out >= 0.45 m from every point and _in
	var neck := Vector3(0.0, 1.5, 0.0)
	var fr_a := {"pos": Vector3(0.24, 1.5, 0.0), "look": Vector3(0.0, 1.5, -1.0), "fov": 30.0, "focus": 0.0, "drift": Vector3.ZERO}
	var out_a := CS.keep_out(fr_a, [neck])
	var dist_a: float = (out_a["pos"] as Vector3).distance_to(neck)
	_check(dist_a >= CS.KEEP_M - 0.001, "(a) lens 0.24m from neck -> >= 0.45m (%.3f)" % dist_a)
	_check(_in_ring(out_a["pos"] as Vector3), "(a) pos still inside ropes")

	# (b) lens 0.1 m behind a head -> >= 0.45
	var head := Vector3(0.0, 1.7, 0.0)
	var fr_b := {"pos": Vector3(0.0, 1.7, -0.1), "look": Vector3(0.0, 1.7, 1.0), "fov": 30.0, "focus": 0.0, "drift": Vector3.ZERO}
	var out_b := CS.keep_out(fr_b, [head])
	var dist_b: float = (out_b["pos"] as Vector3).distance_to(head)
	_check(dist_b >= CS.KEEP_M - 0.001, "(b) lens 0.1m behind head -> >= 0.45m (%.3f)" % dist_b)
	_check(_in_ring(out_b["pos"] as Vector3), "(b) pos still inside ropes")

	# (c) lens already clear -> unchanged pos/fov
	var far := Vector3(2.0, 1.5, 0.0)
	var fr_c := {"pos": Vector3(0.0, 1.5, 0.0), "look": Vector3(0.0, 1.5, -1.0), "fov": 30.0, "focus": 0.0, "drift": Vector3.ZERO}
	var out_c := CS.keep_out(fr_c, [far])
	_check((out_c["pos"] as Vector3).is_equal_approx(fr_c["pos"]), "(c) clear lens: pos unchanged")
	_check(is_equal_approx(float(out_c["fov"]), 30.0), "(c) clear lens: fov unchanged")

	# (d) fov narrows (not widens) when the lens backs off
	var close := Vector3(0.15, 1.5, 0.0)
	var fr_d := {"pos": Vector3(0.0, 1.5, 0.0), "look": Vector3(0.0, 1.5, -2.0), "fov": 30.0, "focus": 0.0, "drift": Vector3.ZERO}
	var out_d := CS.keep_out(fr_d, [close])
	_check(float(out_d["fov"]) < 30.0, "(d) fov narrows when lens backs off (%.1f < 30.0)" % float(out_d["fov"]))
	_check(float(out_d["fov"]) >= 15.0, "(d) fov clamped >= 15 (%.1f)" % float(out_d["fov"]))

	# (e) lens boxed in against the ropes -> blocked true, still _in
	var wall_pts := [Vector3(CS.HALF_M - 0.1, 1.5, 0.0), Vector3(CS.HALF_M - 0.1, 1.5, 0.5)]
	var fr_e := {"pos": Vector3(CS.HALF_M - 0.3, 1.5, 0.0), "look": Vector3(0.0, 1.5, 0.0), "fov": 30.0, "focus": 0.0, "drift": Vector3.ZERO}
	var out_e := CS.keep_out(fr_e, wall_pts)
	_check(bool(out_e.get("blocked", false)), "(e) boxed in -> blocked true")
	_check(_in_ring(out_e["pos"] as Vector3), "(e) blocked lens still inside ropes")

	# (f) drift end inside a body -> drift shortened so the end is >= KEEP_M
	var body_f := Vector3(0.5, 1.5, 0.0)
	var fr_f := {"pos": Vector3(0.0, 1.5, 0.0), "look": Vector3(0.0, 1.5, -1.0), "fov": 30.0, "focus": 0.0, "drift": Vector3(0.4, 0.0, 0.0)}
	var out_f := CS.keep_out(fr_f, [body_f])
	var drift_end: Vector3 = (out_f["pos"] as Vector3) + (out_f["drift"] as Vector3)
	var drift_dist: float = drift_end.distance_to(body_f)
	_check(drift_dist >= CS.KEEP_M - 0.001 or (out_f["drift"] as Vector3).length() < 0.01, "(f) drift end >= 0.45m from body (%.3f) or drift zeroed" % drift_dist)

	# Also test inside() with bodies passes through keep_out
	var neck_g := Vector3(0.2, 1.5, 0.0)
	var fr_g := {"pos": Vector3(0.0, 1.5, 0.0), "look": Vector3(0.0, 1.5, -1.0), "fov": 30.0, "focus": 0.0, "drift": Vector3.ZERO}
	var out_g := CS.inside(fr_g, [neck_g])
	var dist_g: float = (out_g["pos"] as Vector3).distance_to(neck_g)
	_check(dist_g >= CS.KEEP_M - 0.001, "(g) inside() with bodies: lens >= 0.45m (%.3f)" % dist_g)

	# inside() with no bodies works as before (backward compatible)
	var fr_h := {"pos": Vector3(0.0, 1.5, 0.0), "look": Vector3(0.0, 1.5, -1.0), "fov": 30.0, "focus": 0.0, "drift": Vector3.ZERO}
	var out_h := CS.inside(fr_h)
	_check((out_h["pos"] as Vector3).is_equal_approx(fr_h["pos"]), "(h) inside() without bodies: unchanged when already inside")

	print("CORNER_LENS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)
