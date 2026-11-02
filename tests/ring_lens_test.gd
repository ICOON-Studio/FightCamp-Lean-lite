extends SceneTree
## S347 the broadcast lens stands inside the ropes (operator: "this transparent rope on all your stills start to become
## annoying, why you do not change angle?"): RingCamera.spot_inside for the pair in the middle, on each rope, in each
## corner, every side direction - the spot is inside, no closer than MIN_DIST_M, and the middle keeps its full distance.

const RingCamera := preload("res://scripts/fight3d/RingCamera.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1


## The crane lens's line to the pair's chest (1.1 m) crosses the rope square at least 0.1 m above the top rope.
func _over_rope(sp: Array, mid: Vector3) -> bool:
	var lens := (sp[0] as Vector3) + Vector3.UP * RingCamera.OVER_ROPES_H
	var chest := Vector3(mid.x, 1.1, mid.z)
	var lo := 0.0
	var hi := 1.0
	if maxf(absf(lens.x), absf(lens.z)) <= RingCamera.RING_HALF_M:
		return true   # the crane spot is still inside the ropes: no rope between
	for k in 30:   # where the line leaves the rope square
		var m := (lo + hi) * 0.5
		var p := chest.lerp(lens, m)
		if maxf(absf(p.x), absf(p.z)) <= RingCamera.RING_HALF_M:
			lo = m
		else:
			hi = m
	return chest.lerp(lens, lo).y >= RingCamera.TOP_ROPE_H + 0.1


func _initialize() -> void:
	var h := RingCamera.RING_HALF_M - 0.5   # a pair's middle half a metre in from the ropes
	var mids := {"middle": Vector3.ZERO, "rope +x": Vector3(h, 0, 0), "rope -z": Vector3(0, 0, -h),
		"corner +x+z": Vector3(h, 0, h), "corner -x+z": Vector3(-h, 0, h)}
	for name in mids:
		var worst := 99.0
		var all_in := true
		for k in 16:
			var dir := Basis(Vector3.UP, TAU * k / 16.0) * Vector3.RIGHT
			var sp := RingCamera.spot_inside(mids[name], dir, 3.0)
			all_in = all_in and RingCamera.inside(sp[0])
			worst = minf(worst, float(sp[1]))
		_check(all_in, "%s: every lens spot inside the ropes" % name)
		_check(worst >= RingCamera.MIN_DIST_M - 0.001, "%s: never closer than %.1f m (%.2f)" % [name, RingCamera.MIN_DIST_M, worst])
	# The middle of the ring keeps the shot exactly (no turn, full distance).
	var sp0 := RingCamera.spot_inside(Vector3.ZERO, Vector3.RIGHT, 2.0)
	_check((sp0[0] as Vector3).is_equal_approx(Vector3(2.0, 0, 0)) and is_equal_approx(float(sp0[1]), 2.0), "middle: the shot unchanged")
	# S368 (operator: "many times it is behind the fighter and cant see"): with the broadcast's arc a spot that fits stays
	# within SIDE_ARC_DEG of the side it was asked for, and for every pair position and side either that side or the other
	# one fits - the lens never has to swing round behind a boxer.
	var arc := Vector2(-RingCamera.SIDE_ARC_DEG, RingCamera.SIDE_ARC_DEG)
	for name in mids:
		var in_arc := true
		var one_side := true
		var high := 0
		for k in 16:
			var dir := Basis(Vector3.UP, TAU * k / 16.0) * Vector3.RIGHT
			var c: Vector3 = mids[name]
			var sp := RingCamera.spot_inside(c, dir, 3.0, 0.0, arc)
			if bool(sp[3]):
				in_arc = in_arc and RingCamera.inside(sp[0]) and \
					rad_to_deg(dir.angle_to((sp[0] as Vector3) - Vector3(c.x, 0, c.z))) <= RingCamera.SIDE_ARC_DEG + 0.01
			if not bool(sp[3]) and not bool(RingCamera.spot_inside(c, -dir, 3.0, 0.0, arc)[3]):
				high += 1
				one_side = one_side and _over_rope(RingCamera.high_spot(c, dir, 3.0), c)
		_check(in_arc, "%s: every fitting spot within %.0f deg of side-on" % [name, RingCamera.SIDE_ARC_DEG])
		_check(one_side, "%s: every side direction - this side or the other fits, else the crane lens clears the top rope (%d of 16 craned)" % [name, high])
	# Control: the old placement (straight out along the side at 3.0 m) stood outside the ropes from the middle already.
	_check(not RingCamera.inside(Vector3.RIGHT * 3.0), "control: 3.0 m straight out is outside a 5.5 m ring")
	print("ring_lens_test" if _fails == 0 else "ring_lens_test FAILED %d" % _fails)
	quit(1 if _fails > 0 else 0)
