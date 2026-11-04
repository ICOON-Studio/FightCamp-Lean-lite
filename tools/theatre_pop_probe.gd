extends SceneTree
## S379 BJJ9R11 the Grappling theatre's women AS DRAWN, frame by frame at 30 fps, headless (operator on fifty_fifty.mp4
## 0:14: "not sure what is this ??" - red's head jumped 0.2 m in one frame while the data moved 5 cm). Every bone is read
## on Skeleton3D.skeleton_updated (after GrapplePose; outside it get_bone_global_pose is the clip pose - the S307 trap).
## Per chain and bone: the worst one-frame step (metres) and turn (degrees) of the drawn bone vs the data's own worst
## joint step that frame. `detail=<t0>-<t1>` also logs red's trunk per frame there: the drawn Spine/Chest/Neck/Head
## origins, the data's Core/Neck/Head, and GrapplePose's hip and top frames (the turn between them, the slerp's sign).
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/theatre_pop_probe.gd -- [chain=<id>|all]
##       [detail=14.3-15.1]
## Prints THEATREPOP lines, one THEATREPOP_JSON line, and THEATREPOP worst=<m> at the end.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Chains := preload("res://scripts/grapple/TheatreChains.gd")
const FPS := 30.0
const BONES := ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head", "LeftShoulder", "RightShoulder", "LeftUpperArm",
	"RightUpperArm", "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftFoot", "RightFoot"]
const WHO := ["red", "blue"]

var th: Control
var _cache: Array = [{}, {}]
var _updates := 0


func _initialize() -> void:
	var which := "all"
	var detail := Vector2(-1.0, -1.0)
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("chain="):
			which = s.substr(6)
		elif s.begins_with("detail="):
			var p := s.substr(7).split("-")
			detail = Vector2(float(p[0]), float(p[1]))
	th = load("res://scenes/dev/GrappleTheatre.tscn").instantiate()
	th.set("film", true)
	root.add_child(th)
	for k in 3:
		await process_frame
	var poses: Array = th.get("poses")
	for w in 2:
		_watch((poses[w] as Node).get_parent() as Skeleton3D, w)
	var ids: Array = Chains.ids() if which == "all" else [which]
	var rows := {}
	var worst_all := 0.0
	for id in ids:
		var row: Dictionary = await _chain(str(id), detail)
		rows[id] = row
		worst_all = maxf(worst_all, float(row["worst_trunk"]))
	print("THEATREPOP_JSON " + JSON.stringify(rows))
	print("THEATREPOP worst=%.3f (trunk/head one-frame step, metres, all chains)" % worst_all)
	quit(0)


func _chain(id: String, detail: Vector2) -> Dictionary:
	th.call("load_chain", id)
	th.call("set_playing", false)
	var total: float = th.get("total")
	var n := int(ceil(total * FPS))
	var prev: Array = [{}, {}]
	var prev_data: Array = []
	var worst := {}   # "w bone" -> [step m, turn deg, t, data step that frame]
	var poses: Array = th.get("poses")
	for f in n:
		var t := float(f) / FPS
		var before := _updates
		th.call("seek", t)
		await process_frame
		if _updates == before:
			await process_frame
		var data: Array = th.call("sample", t)
		for w in 2:
			var cur: Dictionary = _cache[w]
			if not (prev[w] as Dictionary).is_empty():
				var dstep := 0.0
				for j in DB.JOINTS.size():
					dstep = maxf(dstep, (data[w] as PackedVector3Array)[j].distance_to((prev_data[w] as PackedVector3Array)[j]))
				for b in BONES:
					var a: Transform3D = prev[w][b]
					var c: Transform3D = cur[b]
					var step := a.origin.distance_to(c.origin)
					var turn := rad_to_deg(a.basis.get_rotation_quaternion().angle_to(c.basis.get_rotation_quaternion()))
					var key := "%s %s" % [WHO[w], b]
					var old: Array = worst.get(key, [0.0, 0.0, 0.0, 0.0, 0.0])
					worst[key] = [maxf(old[0], step), maxf(old[1], turn), t if step > old[0] else old[2], dstep if step > old[0] else old[3],
						t if turn > old[1] else old[4]]
			prev[w] = cur.duplicate()
		prev_data = data
		if t >= detail.x and t <= detail.y:
			_detail(t, data, poses)
	var out := {"length_s": snappedf(total, 0.01), "bones": {}}
	var trunk := 0.0
	var worst_line := ""
	for key in worst.keys():
		var v: Array = worst[key]
		out["bones"][key] = {"step": snappedf(v[0], 0.001), "at": snappedf(v[2], 0.01), "data_step": snappedf(v[3], 0.001),
			"turn": snappedf(v[1], 0.1), "turn_at": snappedf(v[4], 0.01)}
		var bone := str(key).split(" ")[1]
		if bone in ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head"] and v[0] > trunk:
			trunk = v[0]
			worst_line = "%s %.3f m at %.2f s (data %.3f m)" % [key, v[0], v[2], v[3]]
	out["worst_trunk"] = snappedf(trunk, 0.001)
	print("THEATREPOP %-16s %5.1f s | worst trunk/head step %s" % [id, total, worst_line])
	for key in worst.keys():
		var v: Array = worst[key]
		print("THEATREPOP   %-16s %-18s step %.3f m at %5.2f s (data %.3f) | turn %5.1f deg at %5.2f s" % [id, key, v[0], v[2], v[3], v[1], v[4]])
	out["worst_trunk_line"] = worst_line
	return out


## Red's trunk this frame: the drawn bones, the data, and GrapplePose's two trunk frames.
func _detail(t: float, data: Array, poses: Array) -> void:
	var gp: Node = poses[0]
	var skel := gp.get_parent() as Skeleton3D
	var inv := skel.global_transform.affine_inverse()
	var j := PackedVector3Array()
	for v in (data[0] as PackedVector3Array):
		j.append(inv * v)
	var rot: Dictionary = gp.call("solve_rotations", j)
	var qh: Quaternion = (rot["Hips"] as Basis).get_rotation_quaternion()
	var qt: Quaternion = (rot["UpperChest"] as Basis).get_rotation_quaternion()
	var qs: Quaternion = (rot["Spine"] as Basis).get_rotation_quaternion()
	var qc: Quaternion = (rot["Chest"] as Basis).get_rotation_quaternion()
	var D := func(n: String) -> Vector3: return (data[0] as PackedVector3Array)[DB.joint(n)]
	var c: Dictionary = _cache[0]
	var mid: Vector3 = (D.call("LeftHip") + D.call("RightHip")) * 0.5
	print("THEATREPOP detail %.3f | drawn Spine %s Chest %s UpperChest %s Neck %s Head %s | data Core %s Neck %s Head %s hipmid %s" % [
		t, _v(c["Spine"].origin), _v(c["Chest"].origin), _v(c["UpperChest"].origin), _v(c["Neck"].origin), _v(c["Head"].origin),
		_v(D.call("Core")), _v(D.call("Neck")), _v(D.call("Head")), _v(mid)])
	var aim_h: Vector3 = D.call("Core") - mid
	var roll_h: Vector3 = D.call("RightHip") - D.call("LeftHip")
	var aim_t: Vector3 = D.call("Neck") - D.call("Core")
	var roll_t: Vector3 = D.call("RightShoulder") - D.call("LeftShoulder")
	print("THEATREPOP detail %.3f | hip aim %s roll %s (angle %.0f) | top aim %s roll %s (angle %.0f) | hips->top %.1f deg, dot(qh,qt) %+.3f | spine turn %.1f chest turn %.1f from hips" % [
		t, _v(aim_h.normalized()), _v(roll_h.normalized()), rad_to_deg(aim_h.angle_to(roll_h)), _v(aim_t.normalized()),
		_v(roll_t.normalized()), rad_to_deg(aim_t.angle_to(roll_t)), rad_to_deg(qh.angle_to(qt)), qh.dot(qt),
		rad_to_deg(qh.angle_to(qs)), rad_to_deg(qh.angle_to(qc))])


static func _v(v: Vector3) -> String:
	return "(%.2f %.2f %.2f)" % [v.x, v.y, v.z]


func _watch(skel: Skeleton3D, who: int) -> void:
	var ids := {}
	for b in BONES:
		ids[b] = skel.find_bone(b)
	skel.skeleton_updated.connect(func() -> void:
		var d := {}
		var gt := skel.global_transform
		for b in BONES:
			d[b] = gt * skel.get_bone_global_pose(int(ids[b]))
		_cache[who] = d
		_updates += 1)
