extends SceneTree
## S390: a downed boxer past the ropes is moved back inside; one inside is left alone.
const KR := preload("res://scripts/fight3d/KnockdownRing.gd")
var fails := 0


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	fails += 0 if ok else 1


func _skel(at: Vector3) -> Skeleton3D:
	var s := Skeleton3D.new()
	for b in KR.BONES:
		var i := s.add_bone(b)
		s.set_bone_rest(i, Transform3D(Basis.IDENTITY, at))
		s.reset_bone_pose(i)
	root.add_child(s)
	return s


func _initialize() -> void:
	var half := 2.75
	_check(KR.back_in(_skel(Vector3(0, 0, 1)), half) == Vector3.ZERO, "inside the ring: left alone")
	var v := KR.back_in(_skel(Vector3(3.0, 0, -3.0)), half)
	_check(v.x < 0.0 and v.z > 0.0 and is_equal_approx(v.x, half - KR.INSIDE_M - 3.0), "past the corner: back in on both axes")
	var down := _skel(Vector3(1, 0, 1))
	var push := KR.away(down, Vector3(1.3, 0, 1))
	_check(push.x > 0.0 and is_equal_approx(push.length(), KR.CLEAR_M - 0.3), "a man standing on the body is pushed clear")
	_check(KR.away(down, Vector3(3, 0, 1)) == Vector3.ZERO, "a man clear of the body is left alone")
	print("KNOCKDOWN_RING failures=%d" % fails)
	quit(1 if fails > 0 else 0)
