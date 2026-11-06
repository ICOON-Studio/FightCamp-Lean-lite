extends SceneTree
## S377 BJJ9 round 10: GrappleFinish - the called arm lock SHOWS the lock. Argon round 9 (its condition 4, worst moment
## 00:58): "KIM WINS - SUBMISSION (TO ARM LOCK) while Red is on bottom with legs wrapped high around Blue's upper back,
## and Blue is sitting upright in guard with both arms tucked in. Neither fighter is applying an armbar." The finish is
## built from GrappleMap's own arm-lock landing (db "arm lock", the pose film round 9 ended on): the winner sits on the
## loser's shoulder, the loser's near arm is pulled straight across her lap (the elbow on her hip line, the arm at the
## lap between her thighs - the data's own extended relation, db 826: 169 deg, elbow 0.16 m off the hips), her shin
## crosses the loser's face, her hips rise into the extension and the loser slaps the mat twice. This test holds that
## geometry still (the probe measures the same bars live on the match).

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Finish := preload("res://scripts/grapple/GrappleFinish.gd")

const NOT_BELOW_Y := -0.02

var failures := 0


func _initialize() -> void:
	var db: Array = DB.load_db()
	var seq: Dictionary = DB.find(db, "arm lock")
	if seq.is_empty():
		print("FAIL no 'arm lock' in the database")
		quit(1)
		return
	var landing: Array = seq["frames"][0]
	var fin: Dictionary = Finish.build(landing)
	var frames: Array = fin["frames"]
	_check(frames.size() == 8, "the finish is 8 keyframes (%d)" % frames.size())
	_check(is_equal_approx(float((fin["times"] as PackedFloat32Array)[-1]), Finish.TAP2B_S), "it reads to %.2f s" % Finish.TAP2B_S)
	# The landing is untouched: the finish starts exactly where the move left the pair.
	var same := true
	for m in 2:
		for j in DB.JOINTS.size():
			if ((frames[0][m] as PackedVector3Array)[j] - (landing[m] as PackedVector3Array)[j]).length() > 1e-6:
				same = false
	_check(same, "keyframe 0 is the landing pose, untouched")
	# The winner = the man on top of the landing (a submission is the top fighter's: BeltMatch offers them only to her).
	var w := 0 if (landing[0] as PackedVector3Array)[DB.joint("Core")].y >= (landing[1] as PackedVector3Array)[DB.joint("Core")].y else 1
	var side := str(fin["side"])
	# The lock (K2) and the extension (K3): straight arm, elbow on the winner's hips, arm on top, leg across the face.
	for k in [2, 3]:
		var st: Array = frames[k]
		var lock := _lock(st, w, side)
		_check(float(lock["ang"]) >= 150.0, "K%d: the loser's %s arm is straight: %.0f deg" % [k, side.to_lower(), lock["ang"]])
		_check(float(lock["elbow"]) <= 0.28, "K%d: its elbow is on the winner's hips: %.2f m" % [k, lock["elbow"]])
		_check(float(lock["lap"]) <= 0.24, "K%d: the arm lies between the thighs: elbow %.2f m off the lap" % [k, lock["lap"]])
		_check(float(lock["ely"]) >= 0.12, "K%d: the arm is clear of the mat: elbow y %.2f m" % [k, lock["ely"]])
		_check(float(lock["leg"]) <= 0.45, "K%d: the winner's leg is across the loser's face: %.2f m" % [k, lock["leg"]])
	var hip2 := _hip_y(frames[2], w)
	var hip3 := _hip_y(frames[3], w)
	_check(hip3 >= hip2 + 0.02, "the hips rise into the extension: %.3f -> %.3f m" % [hip2, hip3])
	# The tap: the free hand slaps the MAT beside her twice, TAP_OFF above it between slaps.
	var free := "Right" if side == "Left" else "Left"
	var touches := 0
	var releases := 0
	for k in [4, 5, 6, 7]:
		var f: Vector3 = (frames[k][1 - w] as PackedVector3Array)[DB.joint(free + "Fingers")]
		var on := f.y <= Finish.TAP_MAT_Y
		if k % 2 == 0:
			touches += 1 if on else 0
		else:
			releases += 1 if not on and f.y >= 0.10 else 0
	_check(touches == 2 and releases == 2, "the loser taps the mat twice: %d on, %d off (%.2f -> %.2f m)" % [
		touches, releases, Finish.TAP_MAT_Y, Finish.TAP_MAT_Y + Finish.TAP_OFF])
	# Nothing sinks through the mat, on any keyframe (the film's mat-plane bar).
	var low := INF
	for st in frames:
		for m in 2:
			for v in (st[m] as PackedVector3Array):
				low = minf(low, v.y)
	_check(low >= NOT_BELOW_Y, "no joint below the mat: lowest %.3f m" % low)
	print("BJJ_FINISH failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The lock relation of a keyframe from the WINNER's side: the narrowest arm of the loser, its elbow's line to the
## winner's hip segment, the elbow's height over the hip centre, and the closest of the winner's knees/ankles to the
## loser's head.
func _lock(st: Array, w: int, side: String) -> Dictionary:
	var win: PackedVector3Array = st[w]
	var los: PackedVector3Array = st[1 - w]
	var hip_c := (win[DB.joint("LeftHip")] + win[DB.joint("RightHip")]) * 0.5
	var sh: Vector3 = los[DB.joint(side + "Shoulder")]
	var el: Vector3 = los[DB.joint(side + "Elbow")]
	var wr: Vector3 = los[DB.joint(side + "Wrist")]
	var ang := rad_to_deg(acos(clampf((sh - el).normalized().dot((wr - el).normalized()), -1.0, 1.0)))
	var leg := INF
	for s in ["Left", "Right"]:
		leg = minf(leg, los[DB.joint("Head")].distance_to(win[DB.joint(s + "Knee")]))
		leg = minf(leg, los[DB.joint("Head")].distance_to(win[DB.joint(s + "Ankle")]))
	var lap := INF
	for s in ["Left", "Right"]:
		lap = minf(lap, _seg_dist(el, win[DB.joint(s + "Hip")], win[DB.joint(s + "Knee")]))
	return {"ang": ang, "elbow": _seg_dist(el, win[DB.joint("LeftHip")], win[DB.joint("RightHip")]),
		"lap": lap, "ely": el.y, "leg": leg}


func _hip_y(st: Array, w: int) -> float:
	var win: PackedVector3Array = st[w]
	return ((win[DB.joint("LeftHip")] + win[DB.joint("RightHip")]) * 0.5).y


func _seg_dist(p: Vector3, a: Vector3, b: Vector3) -> float:
	return p.distance_to(_closest_on_seg(p, a, b))


func _closest_on_seg(p: Vector3, a: Vector3, b: Vector3) -> Vector3:
	var ab := b - a
	if ab.length_squared() < 1e-12:
		return a
	return a + ab * clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)