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
	# Control: the old placement (straight out along the side at 3.0 m) stood outside the ropes from the middle already.
	_check(not RingCamera.inside(Vector3.RIGHT * 3.0), "control: 3.0 m straight out is outside a 5.5 m ring")
	print("ring_lens_test" if _fails == 0 else "ring_lens_test FAILED %d" % _fails)
	quit(1 if _fails > 0 else 0)
