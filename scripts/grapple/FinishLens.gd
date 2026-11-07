extends RefCounted
## S391 (film 2: the tap landed on her thigh, 0.07 m from the skin, measured, and no judge could have seen it: the hand was behind her own body).
## The finish's camera is chosen, not assumed: of a ring of angles round the pair, the one with the clearest line to the tapping hand and to
## the winner's grip. Pure: joints in, a direction out (what GrappleBrowser.finish_lens turns into its yaw).

const Contact := preload("res://scripts/grapple/GrappleContact.gd")
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")

const ANGLES := 16
const CAM_FROM := Vector3(0.0, 0.2, 0.9)   # GrappleBrowser's finish lens, in its own yaw
const CAM_M := 2.4
const CLEAR_M := 0.15   # a line clearer than this is clear; more is no better
const TOUCHING_M := 0.14


## The way the camera should stand from `look`, on the frame `end` ([man0, man1], world) with `loser`'s `free` hand tapping.
static func toward(end: Array, look: Vector3, loser: int, free: String) -> Vector3:
	var hand: Vector3 = (end[loser] as PackedVector3Array)[DB.joint(free + "Hand")]
	var win: PackedVector3Array = end[1 - loser]
	var grip: Vector3 = (win[DB.joint("LeftHand")] + win[DB.joint("RightHand")]) * 0.5
	var caps: Array = []
	for m in 2:
		for c in Contact._capsules(end[m]):
			if m == loser and (str(c["na"]).begins_with(free) or str(c["nb"]).begins_with(free)) and not str(c["nb"]).ends_with("Hip"):
				continue   # the tapping arm itself is what we want to see
			caps.append(c)
	var best := Vector3.BACK
	var best_score := -INF
	for i in ANGLES:
		var dir := Basis(Vector3.UP, TAU * float(i) / float(ANGLES)) * CAM_FROM.normalized()
		var cam := look + dir * CAM_M
		var score := _clear(cam, hand, caps) + 0.4 * _clear(cam, grip, caps)
		if score > best_score:
			best_score = score
			best = dir
	return best


## How clear the line from the camera to `to` runs past every body part not touching `to` itself, capped at CLEAR_M.
static func _clear(cam: Vector3, to: Vector3, caps: Array) -> float:
	var clear := CLEAR_M
	for c in caps:
		var pts := Geometry3D.get_closest_points_between_segments(cam, to, c["a"], c["b"])
		if (c["a"] as Vector3).distance_to(to) < TOUCHING_M or (c["b"] as Vector3).distance_to(to) < TOUCHING_M \
				or (pts[1] as Vector3).distance_to(to) < TOUCHING_M + float(c["r"]):
			continue
		clear = minf(clear, (pts[0] as Vector3).distance_to(pts[1]) - float(c["r"]))
	return clear
