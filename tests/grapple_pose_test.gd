extends SceneTree
## S335 GrapplePose on a real MetaHuman: across many GrappleMap keyframes (positions and transitions, both men) every
## limb bone points where the data's limb points, the elbows and knees bend the data's way (not inverted), the feet stay
## at the data's height, and the hands land near the data's hands (our arms are not the data's: bounded, printed).

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
	_check(med.call(angles) < 1.0 and p95.call(angles) < 3.0, "limb bones along the data's limbs: median %.2f deg, 95%% %.2f deg" % [med.call(angles), p95.call(angles)])
	_check(bends > 0 and float(bend_ok) / bends > 0.97, "elbows and knees bend the data's way: %d of %d" % [bend_ok, bends])
	_check(p95.call(hand_err) < 0.12, "wrist vs the data's wrist: median %.3f m, 95%% %.3f m" % [med.call(hand_err), p95.call(hand_err)])
	_check(p95.call(foot_err) < 0.08, "ankle height vs the data's: median %.3f m, 95%% %.3f m" % [med.call(foot_err), p95.call(foot_err)])
	print("FAIL %d" % failures if failures else "PASS grapple_pose_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
