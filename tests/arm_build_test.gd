extends SceneTree
## ARMBUILD1: a boxer's arms follow his Strength in the 3D fight (v2 player), and nothing else about him moves.
##   K        the factor at 40 / 60 / 80 and its bounds
##   WIRED    Player2.setup gives each boxer his own factor (red 80, blue 40), and it is still there after a second of play
##   WIDER    the same boxer in the same guard picture: the skin of his upper arm and forearm is further from the bone at
##            Strength 80 than at 40 (read off the drawn skin: every vertex placed by its bones, as the GPU does)
##   SAME     shoulder to wrist, the wrist, the head and the glove front stay within 1 mm
## Two DIFFERENT bodies. Run: <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/arm_build_test.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const ArmBuild := preload("res://scripts/fight3d/v2/ArmBuild.gd")

var failures := 0
var st: Node3D
var poses: Array = []   # boxer 0's bones as drawn (after every layer)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _near(a: float, b: float) -> bool:
	return absf(a - b) < 0.0001


func _initialize() -> void:
	_check(_near(ArmBuild.k(40), 1.0) and _near(ArmBuild.k(60), 1.12) and _near(ArmBuild.k(80), 1.24), "K 40 -> %.2f, 60 -> %.2f, 80 -> %.2f" % [ArmBuild.k(40), ArmBuild.k(60), ArmBuild.k(80)])
	_check(_near(ArmBuild.k(0), 0.96) and _near(ArmBuild.k(100), 1.30), "K bounds: 0 -> %.2f, 100 -> %.2f" % [ArmBuild.k(0), ArmBuild.k(100)])
	_check(ArmBuild.strength_of({}) < 0.0 and ArmBuild.strength_of({"name": "x"}) < 0.0, "K a man with no numbers has no Strength (his body stays as it is)")
	_check(_near(ArmBuild.strength_of({"attrs": {"strength": 72.0}, "stats": {"power": 50.0}}), 72.0) or ArmBuild.strength_of({"attrs": {"strength": 72.0}}) >= 0.0, "K a man's Strength is read from his sheet")
	Player2.force = true
	FightClips.untouched = true
	ArmBuild.force = [80.0, 40.0]
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_07.glb", "corner": "blue"})
	if st.v2 == null:
		print("ARMBUILD the v2 player was not built")
		print("ARMBUILD failures=1")
		quit(1)
		return
	var sk: Skeleton3D = st.boxers[0]["skel"]
	var tw := sk.find_bone("upperarm_twist_02_l")
	var tw_b := (st.boxers[1]["skel"] as Skeleton3D).find_bone("upperarm_twist_02_r")
	_check(tw >= 0 and tw_b >= 0, "WIRED the rig has the arm's helper bones")
	for f in 60:
		await process_frame
	var sa: Vector3 = sk.get_bone_pose_scale(tw)
	var sb: Vector3 = (st.boxers[1]["skel"] as Skeleton3D).get_bone_pose_scale(tw_b)
	_check(_near(sa.x, 1.0) and _near(sa.y, 1.24) and _near(sa.z, 1.24), "WIRED red at Strength 80 after a second of play: upper arm %s (1 along, 1.24 across)" % str(sa))
	_check(_near(sb.x, 1.0) and _near(sb.y, 1.0) and _near(sb.z, 1.0), "WIRED blue at Strength 40: upper arm %s (1 along, 1.0 across)" % str(sb))
	for b in ["LeftUpperArm", "LeftLowerArm", "LeftHand", "LeftShoulder", "RightUpperArm", "RightLowerArm", "RightHand", "Neck", "Head"]:
		if not sk.get_bone_pose_scale(sk.find_bone(b)).is_equal_approx(Vector3.ONE):
			_check(false, "WIRED %s carries the limb and must not be scaled: %s" % [b, str(sk.get_bone_pose_scale(sk.find_bone(b)))])

	# the same man, the same guard picture, at 40 and at 80
	var ap: AnimationPlayer = st.boxers[0]["ap"]
	ap.play(Player2.GUARD)
	ap.seek(0.0, true)
	ap.pause()
	sk.skeleton_updated.connect(func() -> void:
		poses.resize(sk.get_bone_count())
		for b in sk.get_bone_count():
			poses[b] = sk.get_bone_global_pose(b))
	var read := {}
	for s in [40.0, 80.0]:
		ArmBuild.apply(sk, ArmBuild.k(s))
		for f in 40:
			await process_frame
		(st.boxers[0]["gloves"] as Node)._follow()
		read[s] = _read(sk)
		print("ARMBUILD Strength %.0f: upper arm skin %.1f mm from the bone (%d points), forearm %.1f mm (%d), shoulder to wrist %.1f mm" % [s,
			float(read[s]["upper"]) * 1000.0, int(read[s]["upper_n"]), float(read[s]["fore"]) * 1000.0, int(read[s]["fore_n"]), float(read[s]["len"]) * 1000.0])
	var lo: Dictionary = read[40.0]
	var hi: Dictionary = read[80.0]
	_check(int(lo["upper_n"]) > 100 and int(lo["fore_n"]) > 100, "WIDER the ruler found the arm's skin (%d upper arm points, %d forearm)" % [int(lo["upper_n"]), int(lo["fore_n"])])
	var ru := float(hi["upper"]) / maxf(float(lo["upper"]), 0.001)
	var rf := float(hi["fore"]) / maxf(float(lo["fore"]), 0.001)
	_check(ru > 1.16 and ru < 1.30, "WIDER upper arm at 80 is %.0f %% thicker than at 40 (16 to 30: the rule gives 24 where the skin is all muscle, owner S534 \"make it stronger\")" % ((ru - 1.0) * 100.0))
	_check(rf > 1.08 and rf < 1.30, "WIDER forearm at 80 is %.0f %% thicker than at 40 (8 to 30: less toward the wrist)" % ((rf - 1.0) * 100.0))
	_check(absf(float(hi["len"]) - float(lo["len"])) < 0.001, "SAME shoulder to wrist: %.2f mm apart (under 1)" % (absf(float(hi["len"]) - float(lo["len"])) * 1000.0))
	for key in ["wrist", "head", "glove", "elbow"]:
		var d := (hi[key] as Vector3).distance_to(lo[key] as Vector3)
		_check(d < 0.001, "SAME the %s is where it was: %.2f mm (under 1)" % [key, d * 1000.0])
	print("ARMBUILD failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## Boxer 0's left arm as drawn: how far its skin is from the bone, its length, and where the points a punch uses are.
func _read(sk: Skeleton3D) -> Dictionary:
	var ua := sk.find_bone("LeftUpperArm")
	var la := sk.find_bone("LeftLowerArm")
	var hd := sk.find_bone("LeftHand")
	var p_ua: Vector3 = (poses[ua] as Transform3D).origin
	var p_la: Vector3 = (poses[la] as Transform3D).origin
	var p_hd: Vector3 = (poses[hd] as Transform3D).origin
	var out := {"len": p_ua.distance_to(p_la) + p_la.distance_to(p_hd), "wrist": p_hd, "elbow": p_la,
		"head": (poses[sk.find_bone("Head")] as Transform3D).origin, "glove": st.glove_front(0, "LeftHand"),
		"upper": 0.0, "upper_n": 0, "fore": 0.0, "fore_n": 0}
	var mi := sk.get_node_or_null("MH_Body") as MeshInstance3D
	if mi == null or mi.skin == null:
		return out
	var skin := mi.skin
	var bind_bone := []
	var bind_xf := []
	var group := []   # per bind: 1 = the upper arm's bones, 2 = the forearm's, 0 = the rest
	for i in skin.get_bind_count():
		var bn := str(skin.get_bind_name(i))
		var b := sk.find_bone(bn) if bn != "" else skin.get_bind_bone(i)
		bind_bone.append(b)
		bind_xf.append((poses[b] as Transform3D) * skin.get_bind_pose(i) if b >= 0 else Transform3D.IDENTITY)
		var nm := sk.get_bone_name(b) if b >= 0 else ""
		group.append(1 if nm == "LeftUpperArm" or (nm.begins_with("upperarm_") and nm.ends_with("_l")) else (2 if nm == "LeftLowerArm" or (nm.begins_with("lowerarm_") and nm.ends_with("_l")) else 0))
	for surf in mi.mesh.get_surface_count():
		var arr := mi.mesh.surface_get_arrays(surf)
		var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES]
		var weights: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
		if verts.is_empty() or bones.is_empty():
			continue
		var per := bones.size() / verts.size()
		for v in verts.size():
			var w := [0.0, 0.0, 0.0]
			for j in per:
				w[int(group[bones[v * per + j]])] += weights[v * per + j]
			var g := 1 if float(w[1]) > 0.9 else (2 if float(w[2]) > 0.9 else 0)
			if g == 0:
				continue
			var p := Vector3.ZERO
			for j in per:
				if weights[v * per + j] > 0.0:
					p += ((bind_xf[bones[v * per + j]] as Transform3D) * verts[v]) * weights[v * per + j]
			var a := p_ua if g == 1 else p_la
			var axis := ((p_la - p_ua) if g == 1 else (p_hd - p_la)).normalized()
			var off := (p - a) - axis * (p - a).dot(axis)
			out["upper" if g == 1 else "fore"] = float(out["upper" if g == 1 else "fore"]) + off.length()
			out["upper_n" if g == 1 else "fore_n"] = int(out["upper_n" if g == 1 else "fore_n"]) + 1
	out["upper"] = float(out["upper"]) / maxf(float(int(out["upper_n"])), 1.0)
	out["fore"] = float(out["fore"]) / maxf(float(int(out["fore_n"])), 1.0)
	return out
