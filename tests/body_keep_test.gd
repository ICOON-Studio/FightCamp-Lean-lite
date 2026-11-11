extends SceneTree
## S392: shown bodies keep BODY_KEEP_M apart. The floor used to guard the fight's place only, so chests met at 0.23 m.

const RingPlace := preload("res://scripts/fight3d/RingPlace.gd")
const Footwork := preload("res://scripts/fight3d/Footwork.gd")

var fails := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		fails += 1


func _initialize() -> void:
	var keep := RingPlace.BODY_KEEP_M
	_check(keep >= 0.58 and keep <= RingPlace.INSIDE_FLOOR_M + 0.001, "the shown floor sits with the inside floor, under the inside range")
	var a := Vector3(-0.2, 0.0, 0.0)
	var b := Vector3(0.2, 0.0, 0.0)
	var a2 := RingPlace.kept(a, b, keep)
	var b2 := RingPlace.kept(b, a, keep)
	_check(is_equal_approx(a2.distance_to(b2), keep), "two bodies 0.40 m apart end %.3f m apart" % a2.distance_to(b2))
	_check(a2.y == a.y and is_equal_approx(a2.z, a.z), "she gives ground straight back, height untouched")
	_check(RingPlace.room(0.0, 0.0) == 0.0, "nobody folded: no extra room")
	_check(is_equal_approx(RingPlace.room(1.0, 0.0), RingPlace.FOLD_ROOM_M), "a full fold takes the whole room")
	_check(is_equal_approx(RingPlace.room(0.0, 0.5), RingPlace.FOLD_ROOM_M * 0.5), "either boxer's fold counts, and it grows with the fold")
	_check(RingPlace.room(3.0, 0.0) <= RingPlace.FOLD_ROOM_M, "the room stops at its limit")
	var far := Vector3(1.0, 0.0, 0.0)
	_check(RingPlace.kept(far, a, keep) == far, "a body past the floor does not move")
	var just := RingPlace.kept(Vector3(keep - 0.001 - 0.2, 0.0, 0.0), a, keep)
	_check(absf(just.x - (keep - 0.001 - 0.2)) < 0.001, "the push starts from nothing: no pop at the floor")
	_check(RingPlace.kept(a, a, keep) == a, "two bodies on one spot have no way back: left alone")
	# HUMANFIGHT1: the floor moved 0.6 -> 0.76 (bodies overlapped at 0.6); the lunge is measured from the floor, whatever it is
	_check(is_equal_approx(RingPlace.lunge_room(0.3, keep + 0.15, keep), 0.15), "a lunge stops at the floor")
	_check(is_equal_approx(RingPlace.lunge_room(0.1, 1.0, keep), 0.1), "a lunge with room is untouched")
	_check(RingPlace.lunge_room(0.3, 0.5, keep) == 0.0, "no lunge inside the floor")
	_check(Footwork.INSIDE_SIDE_M * 2.0 >= 0.24, "inside, the heads pass ear by ear: %.2f m apart sideways (a head is about 0.2 m)" % (Footwork.INSIDE_SIDE_M * 2.0))
	print("BODY_KEEP failures=%d" % fails)
	quit(0 if fails == 0 else 1)
