extends "res://tools/belt_match_film.gd"
## S390 (every judge: "the pair spins 90 degrees in 0.4 s"): the pair's facing frame by frame; prints each spin with what played.
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
var _prev := 0.0
var _have := false
var _acc := 0.0
var _clock := 0.0


func _process(delta: float) -> bool:
	var done: bool = super._process(delta)
	_clock += delta
	var p: Node = b.get("player")
	if p == null or (p.get("seq") as Dictionary).is_empty():
		return done
	var js: Array = p.call("joints_at", p.call("t"))
	var m: PackedVector3Array = js[0]
	var o: PackedVector3Array = js[1]
	var d: Vector3 = o[DB.joint("Core")] - m[DB.joint("Core")]
	var yaw := rad_to_deg(atan2(d.x, d.z))
	if _have:
		var step := absf(wrapf(yaw - _prev, -180.0, 180.0))
		_acc = _acc * 0.8 + step
		if _acc > 22.0:
			print("SPIN t=%.1f %.0f deg/frames at %s moving %s len=%.2f" % [_clock, _acc, str(b.get("db")[int(b.get("current"))].get("title", "")).left(26), str((b.get("moving") as Dictionary).get("t", {}).get("title", "-")).left(26), float(p.call("length_s"))])
			_acc = 0.0
	_prev = yaw
	_have = true
	return done
