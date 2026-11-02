extends SceneTree
## S354 C202 FaceMarks: the body map's cuts, swollen and shut eyes and a hurt nose, placed on her face close-up.

const F := preload("res://scripts/ui/FaceMarks.gd")

var _fails := 0


func _initialize() -> void:
	_check(F.marks({}, {}).is_empty(), "a fresh face: no marks")
	var m := F.marks({"right_eye": 40.0, "left_eye": 90.0}, {"cuts": {"left_eye": true}})
	_check(_kinds(m) == ["swell:right_eye", "cut:left_eye"], "a swollen right eye and a cut over the left (%s)" % str(_kinds(m)))
	var cut: Dictionary = m[1]
	_check((cut["at"] as Vector2).y < (F.AT["left_eye"] as Vector2).y, "the cut sits on the brow, above the eye")
	_check((F.AT["left_eye"] as Vector2).x > (F.AT["right_eye"] as Vector2).x, "front view: her left eye on the viewer's right")
	var sh := F.marks({"left_eye": 20.0, "nose": 50.0}, {"closed": {"left_eye": true}, "cuts": {"nose": true}})
	_check(_kinds(sh) == ["shut:left_eye", "nose:nose", "cut:nose"], "a shut eye (no swell drawn twice), hurt nose, cut nose (%s)" % str(_kinds(sh)))
	var light: float = F.marks({"right_eye": 54.0}, {})[0]["k"]
	var heavy: float = F.marks({"right_eye": 10.0}, {})[0]["k"]
	_check(heavy > light and light >= 0.35 and heavy <= 1.0, "the worse the eye, the darker the swelling (%.2f < %.2f)" % [light, heavy])
	_check(F.marks({"right_eye": 56.0, "nose": 70.0}, {}).is_empty(), "fine places (above HURT 55) draw nothing")
	for m2 in sh:
		var at: Vector2 = m2["at"]
		_check(at.length() < 0.95, "%s stays inside the close-up (%.2f radii)" % [m2["kind"], at.length()])
	print("FACE_MARKS %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(1 if _fails > 0 else 0)


func _kinds(ms: Array) -> Array:
	return ms.map(func(x): return "%s:%s" % [x["kind"], x["place"]])


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])
