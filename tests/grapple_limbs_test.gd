extends SceneTree
## S391 GrappleLimbs: the drawn limbs clear a body, relax back, stop at first touch, and a hold is carried from the data to the drawn body.

const Limbs := preload("res://scripts/grapple/GrappleLimbs.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Lens := preload("res://scripts/grapple/FinishLens.gd")

const DT := 1.0 / 30.0
const ARM: Array = ["LeftArm", "Root", "Mid", "End", 0.06, 0.045]
const NONE: Array = [Vector3.ZERO, 0.0, 0.0]

var failures := 0


func _initialize() -> void:
	_swung()
	_clears_and_relaxes()
	_first_touch()
	_hold_carried()
	_lens()
	print("FAIL %d" % failures if failures else "PASS grapple_limbs_test")
	quit(1 if failures else 0)


## A kneeling woman's folded leg pressed by a body swings as one piece: the knee stays forward of the hip (the bug behind "blue doesn t even
## look like a human": knees behind the hips, a foot by the shoulder).
func _swung() -> void:
	var leg: Array = ["LeftLeg", "Root", "Mid", "End", 0.10, 0.065, "Toes"]
	var d := {"Root": Vector3(0, 0.5, 0), "Mid": Vector3(0.4, 0.15, 0), "End": Vector3(0.02, 0.08, 0), "Toes": Vector3(-0.15, 0.05, 0)}
	var rec: Array = [d["Mid"], d["End"], Vector3.BACK]
	var solid: Array = ["trunk", Vector3(0.45, 0.0, -0.05), Vector3(0.45, 0.9, -0.05), 0.12]
	var st := {}
	var fix: Array = []
	for _f in 60:
		fix = Limbs._limb(leg, d, rec, [solid], NONE, st, "k", DT)
	var mid: Vector3 = (d["Root"] as Vector3) + (fix[0] as Vector3)
	_check(mid.x > 0.2, "the knee stays forward of the hip: x %.2f" % mid.x)
	_check(mid.distance_to(rec[0]) < 0.3, "the knee stays near the recording: %.2f" % mid.distance_to(rec[0]))
	_check((fix[1] as Vector3).length() < 0.3, "so does the foot: %.2f" % (fix[1] as Vector3).length())


## An arm from the shoulder straight through a trunk: pushed out by the solve, and back on the recording once the trunk has gone.
func _clears_and_relaxes() -> void:
	var d := {"Root": Vector3(0, 1, 0), "Mid": Vector3(0.3, 1, 0), "End": Vector3(0.6, 1, 0)}
	var rec: Array = [d["Mid"], d["End"], Vector3.BACK]
	var solid: Array = ["trunk", Vector3(0.4, 0.8, 0.08), Vector3(0.4, 1.2, 0.08), 0.12]
	var st := {}
	var fix: Array = []
	for _f in 45:
		fix = Limbs._limb(ARM, d, rec, [solid], NONE, st, "k", DT)
	var end: Vector3 = (rec[1] as Vector3) + (fix[1] as Vector3)
	var dist := Geometry3D.get_closest_point_to_segment(end, solid[1], solid[2]).distance_to(end)
	var mid: Vector3 = (d["Root"] as Vector3) + (fix[0] as Vector3)
	var pts := Geometry3D.get_closest_points_between_segments(mid, end, solid[1], solid[2])
	var depth: float = 0.045 + 0.12 - (pts[0] as Vector3).distance_to(pts[1])
	_check(depth < 0.03, "the forearm clears the trunk: depth %.3f, end %.2f off its axis" % [depth, dist])
	for _f in 150:
		fix = Limbs._limb(ARM, d, rec, [], NONE, st, "k", DT)
	_check((fix[1] as Vector3).length() < 0.03, "free again, it relaxes back to the recording: %.3f" % (fix[1] as Vector3).length())


func _first_touch() -> void:
	var solid: Array = ["trunk", Vector3(0.5, -1, 0), Vector3(0.5, 1, 0), 0.14]
	var to := Limbs._first_touch(Vector3.ZERO, Vector3(1, 0, 0), 0.045, [solid])
	_check(to.x > 0.25 and to.x < 0.36, "a hand on the far side stops at the near skin: x %.3f" % to.x)
	var free := Limbs._first_touch(Vector3.ZERO, Vector3(0, 0, 1), 0.045, [solid])
	_check(free.is_equal_approx(Vector3(0, 0, 1)), "a clear line goes all the way")


## The data's hand on the other's shoulder; her drawn shoulder sits 0.2 m off the data: the hold follows the drawn body.
func _hold_carried() -> void:
	var other := PackedVector3Array()
	other.resize(DB.JOINTS.size())
	var far := Vector3(5, 0, 5)
	other.fill(far)
	other[DB.joint("RightShoulder")] = Vector3(0, 1, 0)
	other[DB.joint("RightElbow")] = Vector3(0.3, 1, 0)
	var mine := PackedVector3Array()
	mine.resize(DB.JOINTS.size())
	mine.fill(Vector3(-5, 0, -5))
	var touch := Vector3(0.15, 1.07, 0)
	mine[DB.joint("LeftWrist")] = touch + Vector3(0, 0.08, 0)
	mine[DB.joint("LeftHand")] = touch + Vector3(0, 0.02, 0)
	mine[DB.joint("LeftFingers")] = touch - Vector3(0, 0.02, 0)
	var shift := Vector3(0, 0, 0.2)
	var od := {}
	for h in Limbs.HOLDS:
		od[h[3]] = far
		od[h[4]] = far
	od["RightUpperArm"] = other[DB.joint("RightShoulder")] + shift
	od["RightLowerArm"] = other[DB.joint("RightElbow")] + shift
	var st := {}
	var got: Array = NONE
	for _f in 30:
		got = Limbs._hold("LeftArm", mine, other, od, st, "k", DT)
	_check(float(got[1]) > 0.7, "the hand on her shoulder holds: %.2f" % float(got[1]))
	var q := Geometry3D.get_closest_point_to_segment(got[0], od["RightUpperArm"], od["RightLowerArm"])
	_check((got[0] as Vector3).distance_to(q) < 0.2, "the hold follows the drawn arm: %.3f off it" % (got[0] as Vector3).distance_to(q))
	mine[DB.joint("LeftHand")] += Vector3(0, 0.5, 0)
	mine[DB.joint("LeftFingers")] += Vector3(0, 0.5, 0)
	for _f in 10:
		got = Limbs._hold("LeftArm", mine, other, od, st, "k", DT)
	_check(float(got[1]) < 0.1, "a hand the data takes away lets go: %.2f" % float(got[1]))


func _lens() -> void:
	var cap := {"a": Vector3(0, 0, 1), "b": Vector3(0, 1, 1), "r": 0.2}
	_check(Lens._clear(Vector3(0, 0.5, 2.5), Vector3(0, 0.5, 0), [cap]) < 0.0, "a body on the line is not clear")
	_check(Lens._clear(Vector3(2.5, 0.5, 0), Vector3(0, 0.5, 0), [cap]) >= Lens.CLEAR_M, "round it is")


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
