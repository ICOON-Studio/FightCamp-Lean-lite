extends SceneTree
## FIXED_CAM (S500, owner: "can you make it so the camera is fixed always and shows clearly the boxers in the fight"):
## the pure parts of the round's one fixed camera (scripts/fight3d/FixedCam.gd).

const FC := preload("res://scripts/fight3d/FixedCam.gd")

var failures: int = 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _initialize() -> void:
	var near: float = FC.fov_for(4.0, 1.0, 16.0 / 9.0)
	var far: float = FC.fov_for(9.0, 1.0, 16.0 / 9.0)
	_check(near > far, "the lens opens as the pair comes near (%.1f > %.1f deg)" % [near, far])
	for d in [4.0, 6.0, 9.0]:
		var tall: float = 2.0 * float(d) * tan(deg_to_rad(FC.fov_for(float(d), 1.0, 16.0 / 9.0)) * 0.5)
		_check(absf(tall - FC.SEE_M) < 0.01, "at %.0f m the picture is %.2f m tall where they stand" % [d, tall])
	var wide: float = FC.fov_for(6.0, 5.0, 16.0 / 9.0)
	_check(2.0 * 6.0 * tan(deg_to_rad(wide) * 0.5) * 16.0 / 9.0 >= 5.0 + FC.SIDE_ROOM_M - 0.01, "a pair 5 m apart across the picture still fits")
	_check(FC.fov_for(0.2, 1.0, 1.78) <= FC.FOV.y and FC.fov_for(60.0, 1.0, 1.78) >= FC.FOV.x, "the lens stays inside its limits")
	var a := Vector3(-0.6, 0.0, 0.2)
	var b := Vector3(0.6, 0.0, -0.1)
	var spot: Vector3 = FC.spot_for(a, b)
	_check(absf(spot.x) < 0.01 and absf(spot.z) > 3.0, "a pair standing along X is filmed from the Z side (side-on)")
	spot = FC.spot_for(Vector3(0.1, 0.0, -0.7), Vector3(-0.1, 0.0, 0.7))
	_check(absf(spot.z) < 0.01 and absf(spot.x) > 3.0, "a pair standing along Z is filmed from the X side")
	# S501 (owner: "Yes, do all three": lower and closer, as Boxing Manager and UFC): the lens may stand below 2 m now; what
	# must hold is that its line to the pair's belt, mid-ring, passes OVER the top rope (1.25 m above the canvas) where it
	# crosses the ropes (2.75 m from the middle), so no rope cuts through the boxers.
	var over: float = spot.y - (spot.y - FC.LOOK_H) * ((absf(spot.x) + absf(spot.z)) - 2.75) / (absf(spot.x) + absf(spot.z))
	_check(spot.y > 1.25 + 0.3 and over > 1.25 + 0.15, "the lens looks over the top rope at the pair (lens %.2f m, line at the ropes %.2f m)" % [spot.y, over])
	_check(FC.look_for(a, b).distance_to(Vector3(0.0, FC.LOOK_H, 0.05)) < 0.001, "it looks at the middle of the pair at belt height")
	# S500 "Boxers stay side-on": the pair turns toward the line across the picture, never faster than the cap
	var cam := FC.spot_for(Vector3(-0.6, 0.0, 0.0), Vector3(0.6, 0.0, 0.0))   # on the Z side: side-on = along X
	_check(FC.square(Vector3(-0.6, 0.0, 0.0), Vector3(0.6, 0.0, 0.0), cam, 1.0 / 60.0) == 0.0, "a pair already side-on is left alone")
	var p := Vector3(0.05, 0.0, -0.6)
	var q := Vector3(-0.05, 0.0, 0.6)
	var gap := p.distance_to(q)
	var most := deg_to_rad(FC.SQUARE_DEG_S) / 60.0
	var worst := 0.0
	for f in 600:
		var turn: float = FC.square(p, q, cam, 1.0 / 60.0)
		worst = maxf(worst, absf(turn))
		p = p.rotated(Vector3.UP, turn)
		q = q.rotated(Vector3.UP, turn)
	_check(worst <= most + 1e-6, "it never turns the pair faster than %.0f degrees a second" % FC.SQUARE_DEG_S)
	_check(absf(q.z - p.z) < gap * sin(deg_to_rad(FC.DEAD_DEG + 1.0)), "a pair in line with the lens is side-on within 10 seconds (z spread %.3f m)" % absf(q.z - p.z))
	_check(absf(p.distance_to(q) - gap) < 0.001, "turning them does not change the gap")
	FC.pick(1, null)
	_check(FC.on and FC.spot_for(p, q).y > cam.y, "the High camera is a higher tripod")
	FC.pick(2, null)
	_check(not FC.on, "the TV camera switches the fixed tripod off")
	FC.pick(0, null)
	_check(FC.on and FC.mode == 0, "and Side brings it back")
	print("FIXED_CAM failures=%d" % failures)
	quit(1 if failures > 0 else 0)
