extends SceneTree
## S335 GrapplePose on a real MetaHuman: across many GrappleMap keyframes (positions and transitions, both men) every
## limb bone points where the data's limb points, the elbows and knees bend the data's way (not inverted), the feet stay
## at the data's height, and the IK puts the wrists on the data's wrists (S335: 8.4 cm median without IK, the aim solve
## alone; limb directions then bend a little to reach, so their bar is loose).

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")

var failures := 0


func _initialize() -> void:
	var db: Array = DB.load_db()
	var body := MH.load_fighter("res://assets/models/metahuman/mh_boxer_11.glb")
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var gp = Pose.attach(skel)
	_check(gp != null, "GrapplePose attaches to a MetaHuman")
	if gp == null:
		quit(1)
		return
	var sw := skel.global_transform
	var leg := (sw * skel.get_bone_global_rest(skel.find_bone("LeftUpperLeg")).origin).distance_to(
		sw * skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin)
	var k := Player.pair_scale([leg])
	_check(k > 0.8 and k < 1.2, "pair scale %.3f (her hip-to-ankle %.3f m)" % [k, leg])
	var limbs := [["LeftUpperArm", "LeftLowerArm", "LeftShoulder", "LeftElbow"], ["LeftLowerArm", "LeftHand", "LeftElbow", "LeftWrist"],
		["RightUpperArm", "RightLowerArm", "RightShoulder", "RightElbow"], ["RightLowerArm", "RightHand", "RightElbow", "RightWrist"],
		["LeftUpperLeg", "LeftLowerLeg", "LeftHip", "LeftKnee"], ["LeftLowerLeg", "LeftFoot", "LeftKnee", "LeftAnkle"],
		["RightUpperLeg", "RightLowerLeg", "RightHip", "RightKnee"], ["RightLowerLeg", "RightFoot", "RightKnee", "RightAnkle"]]
	var angles: Array = []
	var bend_ok := 0
	var bends := 0
	var hand_err: Array = []
	var foot_err: Array = []
	var inv := sw.affine_inverse()
	var n := 0
	for si in range(0, db.size(), 7):
		var f: Array = (db[si]["frames"] as Array)[0]
		for m in 2:
			var j := PackedVector3Array()
			for v in (f[m] as PackedVector3Array):
				j.append(inv * (v * k))
			var g: Dictionary = gp.pose_globals(skel, j)
			var B := func(b: String) -> Vector3: return (g[skel.find_bone(b)] as Transform3D).origin
			var D := func(x: String) -> Vector3: return j[DB.joint(x)]
			for l in limbs:
				var a: Vector3 = B.call(l[1]) - B.call(l[0])
				var d: Vector3 = D.call(l[3]) - D.call(l[2])
				angles.append(rad_to_deg(a.angle_to(d)))
			for s in ["Left", "Right"]:
				for c in [["UpperArm", "LowerArm", "Hand", "Shoulder", "Elbow", "Wrist"], ["UpperLeg", "LowerLeg", "Foot", "Hip", "Knee", "Ankle"]]:
					var dm: Vector3 = D.call(s + c[4]) - (D.call(s + c[3]) + D.call(s + c[5])) * 0.5
					if dm.length() < 0.04:
						continue
					var bm: Vector3 = B.call(s + c[1]) - (B.call(s + c[0]) + B.call(s + c[2])) * 0.5
					bends += 1
					if bm.dot(dm) > 0.0:
						bend_ok += 1
				hand_err.append(B.call(s + "Hand").distance_to(D.call(s + "Wrist")) * sw.basis.get_scale().x)
				foot_err.append(absf(B.call(s + "Foot").y - D.call(s + "Ankle").y) * sw.basis.get_scale().x)
			n += 1
	angles.sort()
	hand_err.sort()
	foot_err.sort()
	var p95 := func(a: Array) -> float: return float(a[int(a.size() * 0.95)])
	var med := func(a: Array) -> float: return float(a[a.size() / 2])
	_check(n >= 500, "%d men posed from %d sequences" % [n, n / 2])
	_check(med.call(angles) < 8.0 and p95.call(angles) < 25.0, "limb bones along the data's limbs: median %.2f deg, 95%% %.2f deg" % [med.call(angles), p95.call(angles)])
	_check(bends > 0 and float(bend_ok) / bends > 0.97, "elbows and knees bend the data's way: %d of %d" % [bend_ok, bends])
	_check(p95.call(hand_err) < 0.03, "wrist (IK) vs the data's wrist: median %.3f m, 95%% %.3f m" % [med.call(hand_err), p95.call(hand_err)])
	_check(p95.call(foot_err) < 0.08, "ankle height vs the data's: median %.3f m, 95%% %.3f m" % [med.call(foot_err), p95.call(foot_err)])
	_continuity(gp, skel, db, k)
	print("FAIL %d" % failures if failures else "PASS grapple_pose_test")
	quit(1 if failures else 0)


## S379 BJJ9R11 (the theatre's 'To 50/50': red's head jumped 0.2 m in one frame, the data 5 cm): the DRAWN pose (`mem`,
## frame after frame at 30 fps) never flips a roll in one frame where the one-off solve / the old rule did.
## 1. Her upper body turned 300 deg about the trunk, 4 deg a frame: the hips-to-shoulders turn passes 180 deg, where the
##    short-way slerp spun Spine/Chest ~120 deg in one frame. 2. An arm swung through straight to bend the other way,
##    2 deg a frame: the old roll (upper x fore, the body's forward under sin 0.15) flips there.
func _continuity(gp: Node, skel: Skeleton3D, db: Array, k: float) -> void:
	var inv := skel.global_transform.affine_inverse()
	var base := PackedVector3Array()
	for v in ((DB.find(db, "mount")["frames"] as Array)[0][0] as PackedVector3Array):
		base.append(inv * (v * k))
	var core: Vector3 = base[DB.joint("Core")]
	var mid: Vector3 = (base[DB.joint("LeftHip")] + base[DB.joint("RightHip")]) * 0.5
	var axis: Vector3 = (base[DB.joint("Neck")] - mid).normalized()
	var top := ["LeftShoulder", "RightShoulder", "LeftElbow", "RightElbow", "LeftWrist", "RightWrist", "LeftHand", "RightHand",
		"LeftFingers", "RightFingers", "Neck", "Head"]
	var worst := {}
	for mode in ["drawn", "one-off"]:
		var mem: Variant = {} if mode == "drawn" else null
		var last := {}
		var w := 0.0
		for step in 76:
			var j := base.duplicate()
			for n in top:
				j[DB.joint(n)] = core + (base[DB.joint(n)] - core).rotated(axis, deg_to_rad(4.0 * step))
			var g: Dictionary = gp.pose_globals(skel, j, mem, 1.0 / 30.0)
			for b in ["Spine", "Chest"]:
				var q := (g[skel.find_bone(b)] as Transform3D).basis.get_rotation_quaternion()
				if last.has(b):
					w = maxf(w, rad_to_deg(q.angle_to(last[b])))
				last[b] = q
		worst[mode] = w
	_check(float(worst["drawn"]) <= 20.0 and float(worst["one-off"]) >= 60.0,
		"trunk turned 300 deg at 4 deg a frame: drawn Spine/Chest turn at most %.1f deg a frame (one-off solve, the control: %.1f)" % [
		worst["drawn"], worst["one-off"]])
	# The left arm: upper arm kept, the forearm swung in one plane from 40 deg bent through straight to 40 deg the other way.
	var sh: Vector3 = base[DB.joint("LeftShoulder")]
	var ua: Vector3 = base[DB.joint("LeftElbow")] - sh
	var fa_len: float = (base[DB.joint("LeftWrist")] - base[DB.joint("LeftElbow")]).length()
	var plane := ua.cross(Vector3.UP if absf(ua.normalized().y) < 0.9 else Vector3.RIGHT).normalized()
	var mem2 := {}
	var last_q := Quaternion.IDENTITY
	var last_old := Vector3.ZERO
	var drawn := 0.0
	var old_flip := 0.0
	for step in 41:
		var fa := ua.normalized().rotated(plane, deg_to_rad(40.0 - 2.0 * step)) * fa_len
		var j := base.duplicate()
		var elbow: Vector3 = sh + ua
		j[DB.joint("LeftWrist")] = elbow + fa
		var hand_off: Vector3 = base[DB.joint("LeftHand")] - base[DB.joint("LeftWrist")]
		j[DB.joint("LeftHand")] = j[DB.joint("LeftWrist")] + fa.normalized() * hand_off.length()
		j[DB.joint("LeftFingers")] = j[DB.joint("LeftHand")] + fa.normalized() * 0.08
		var g: Dictionary = gp.pose_globals(skel, j, mem2, 1.0 / 30.0)
		var q := (g[skel.find_bone("LeftUpperArm")] as Transform3D).basis.get_rotation_quaternion()
		var n_old := ua.normalized().cross(fa.normalized())
		if n_old.length() < 0.15:
			n_old = ua.cross(Vector3.BACK)
		n_old = Pose.square(n_old, ua.normalized())
		if step > 0:
			drawn = maxf(drawn, rad_to_deg(q.angle_to(last_q)))
			old_flip = maxf(old_flip, rad_to_deg(n_old.angle_to(last_old)))
		last_q = q
		last_old = n_old
	_check(drawn <= 30.0 and old_flip >= 90.0,
		"an arm swung through straight at 2 deg a frame: drawn upper arm turns at most %.1f deg a frame (the old roll rule flips %.1f deg)" % [
		drawn, old_flip])


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
