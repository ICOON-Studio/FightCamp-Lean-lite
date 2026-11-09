extends SceneTree
## LOCOSLIDE2: the planted foot creep - which way, how much, and what brings it back to the source.
## For each clip's ONE cycle (second cycle of chained, or only for rk_loc_in): world-space ball every frame
## inside skeleton_updated; PLANTED = ball within PLANT_M of lowest AND speed < SPEED_MAX; consecutive planted
## frames = STRETCH. Per stretch: PATH (summed travel), NET (first-to-last), ALONG (NET along body travel,
## + = with the walk), BODY (body travel), ALONG/BODY. SNAPS: >3cm jumps inside/adjacent to planted only.
## Arms: GAME (default), -- rknocontact, rkxz=0.9, rkxz=1.1.
##   <godot.exe> --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/foot_slide_probe.gd -- [rkxz=1.0]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const RkRetarget := preload("res://scripts/fight3d/RkRetarget.gd")
const DT := 1.0 / 30.0
const PLANT_M := 0.03
const SPEED_MAX := 0.25
const SNAP_M := 0.03
const CLIPS := ["rk_loc_in", "rk_loc_back", "rk_loc_left", "rk_loc_right"]

var current_foot: Dictionary = {}
var leg_length_m := 0.0


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


## Per-stretch metrics: PATH, NET, ALONG (foot NET along body travel), BODY, ALONG/BODY. XZ plane only.
static func _stretch_metrics(foot_ball: Array, body_pos: Array) -> Dictionary:
	var n := foot_ball.size()
	if n < 2:
		return {"path": 0.0, "net": 0.0, "along": 0.0, "body": 0.0, "along_body": 0.0}
	var path := 0.0
	for i in range(1, n):
		var a: Vector3 = foot_ball[i - 1]
		var b: Vector3 = foot_ball[i]
		path += Vector2(b.x - a.x, b.z - a.z).length()
	var first_b: Vector3 = foot_ball[0]
	var last_b: Vector3 = foot_ball[n - 1]
	var foot_net := Vector2(last_b.x - first_b.x, last_b.z - first_b.z)
	var net := foot_net.length()
	var first_body: Vector3 = body_pos[0]
	var last_body: Vector3 = body_pos[n - 1]
	var body_dir := Vector2(last_body.x - first_body.x, last_body.z - first_body.z)
	var body_len := body_dir.length()
	var along := foot_net.dot(body_dir.normalized()) if body_len > 0.001 else 0.0
	var along_body := along / body_len if body_len > 0.001 else 0.0
	return {"path": path, "net": net, "along": along, "body": body_len, "along_body": along_body}


static func _detect_planted(positions: Array) -> Array:
	if positions.is_empty():
		return []
	var min_y: float = INF
	for p in positions:
		min_y = minf(min_y, (p["ball"] as Vector3).y)
	var planted: Array = []
	for i in positions.size():
		var p: Dictionary = positions[i]
		var height_ok: bool = (p["ball"] as Vector3).y - min_y < PLANT_M
		var speed_ok := true
		if i > 0:
			var dist: float = (p["ball"] as Vector3).distance_to((positions[i - 1] as Dictionary)["ball"] as Vector3)
			speed_ok = (dist / DT) < SPEED_MAX
		planted.append(height_ok and speed_ok)
	return planted


static func _find_stretches(planted: Array) -> Array:
	var stretches: Array = []
	var cur: Array = []
	for i in planted.size():
		if planted[i]:
			cur.append(i)
		else:
			if cur.size() > 0:
				stretches.append(cur)
				cur = []
	if cur.size() > 0:
		stretches.append(cur)
	return stretches


## New SNAPS: >3cm jumps on frames inside or adjacent to planted stretches. Loop seam reported separately.
static func _count_snaps(positions: Array, planted: Array) -> Dictionary:
	var near := {}
	for i in planted.size():
		if planted[i]:
			for j in [i - 1, i, i + 1]:
				if j >= 0 and j < planted.size():
					near[j] = true
	var snaps := 0
	for i in range(1, positions.size()):
		if not near.has(i):
			continue
		var dist: float = (positions[i] as Dictionary)["ball"].distance_to(
			(positions[i - 1] as Dictionary)["ball"] as Vector3)
		if dist > SNAP_M:
			snaps += 1
	var loop_seam := 0.0
	if positions.size() > 1:
		loop_seam = (positions[positions.size() - 1] as Dictionary)["ball"].distance_to(
			(positions[0] as Dictionary)["ball"] as Vector3)
	return {"snaps": snaps, "loop_seam": loop_seam}


static func _selftest() -> bool:
	var still: Array = []
	for i in 10:
		still.append({"ball": Vector3(0.1, 0.0, 0.0), "ankle": Vector3(0.1, 0.5, 0.0)})
	var planted := _detect_planted(still)
	var stretches := _find_stretches(planted)
	if stretches.size() != 1 or stretches[0].size() != 10:
		print("FOOTSLIDE_SELFTEST FAIL still stretches=%d" % stretches.size())
		return false
	var body_still: Array = []
	for i in 10:
		body_still.append(Vector3.ZERO)
	var balls_still: Array = []
	for p in still:
		balls_still.append(p["ball"])
	var m0 := _stretch_metrics(balls_still, body_still)
	if float(m0["path"]) != 0.0 or float(m0["net"]) != 0.0 or float(m0["along"]) != 0.0:
		print("FOOTSLIDE_SELFTEST FAIL still path=%.4f net=%.4f along=%.4f" % [
			float(m0["path"]), float(m0["net"]), float(m0["along"])])
		return false
	var creep: Array = []
	var body_creep: Array = []
	for i in 10:
		creep.append({"ball": Vector3(i * 0.005, 0.0, 0.0), "ankle": Vector3(i * 0.005, 0.5, 0.0)})
		body_creep.append(Vector3(i * 0.01, 0.0, 0.0))
	var balls_creep: Array = []
	for p in creep:
		balls_creep.append(p["ball"])
	var m1 := _stretch_metrics(balls_creep, body_creep)
	if float(m1["along"]) <= 0.0:
		print("FOOTSLIDE_SELFTEST FAIL creep along=%.4f expected >0" % float(m1["along"]))
		return false
	var against: Array = []
	var body_against: Array = []
	for i in 10:
		against.append({"ball": Vector3(-i * 0.005, 0.0, 0.0), "ankle": Vector3(-i * 0.005, 0.5, 0.0)})
		body_against.append(Vector3(i * 0.01, 0.0, 0.0))
	var balls_against: Array = []
	for p in against:
		balls_against.append(p["ball"])
	var m2 := _stretch_metrics(balls_against, body_against)
	if float(m2["along"]) >= 0.0:
		print("FOOTSLIDE_SELFTEST FAIL against along=%.4f expected <0" % float(m2["along"]))
		return false
	var snap_pos: Array = []
	var snap_planted: Array = []
	for i in 5:
		snap_pos.append({"ball": Vector3(0.0, 0.0, 0.0)})
		snap_planted.append(true)
	snap_pos.append({"ball": Vector3(0.05, 0.0, 0.0)})
	snap_planted.append(true)
	for i in 4:
		snap_pos.append({"ball": Vector3(0.05, 0.0, 0.0)})
		snap_planted.append(true)
	for i in 5:
		snap_pos.append({"ball": Vector3(0.05 + (i + 1) * 0.001, 0.0, 0.0)})
		snap_planted.append(false)
	snap_pos.append({"ball": Vector3(0.15, 0.0, 0.0)})
	snap_planted.append(false)
	var sn := _count_snaps(snap_pos, snap_planted)
	if int(sn["snaps"]) != 1:
		print("FOOTSLIDE_SELFTEST FAIL snaps=%d expected 1" % int(sn["snaps"]))
		return false
	print("FOOTSLIDE_SELFTEST ok")
	return true


func _label(c: Node) -> String:
	var sc: Variant = c.get_script()
	return str(c.name) if sc == null else (sc as Script).resource_path.get_file().get_basename()


func _switch_off(skel: Skeleton3D, off: String) -> Array:
	var hit: Array = []
	if off == "":
		return hit
	var words := off.split(",", false)
	for c in skel.get_children():
		if not (c is SkeletonModifier3D):
			continue
		var lab := _label(c)
		var match_it := off == "all"
		for w in words:
			match_it = match_it or lab.to_lower().contains(w.to_lower())
		if match_it:
			(c as SkeletonModifier3D).active = false
			hit.append(lab)
	return hit


func _watch(skel: Skeleton3D, rig: Node) -> void:
	skel.skeleton_updated.connect(func():
		var xf := skel.global_transform
		var left_ids: Array = rig._legs[0]["ids"]
		var right_ids: Array = rig._legs[1]["ids"]
		current_foot = {
			"la": xf * skel.get_bone_global_pose(left_ids[2]).origin,
			"lb": xf * skel.get_bone_global_pose(left_ids[3]).origin,
			"ra": xf * skel.get_bone_global_pose(right_ids[2]).origin,
			"rb": xf * skel.get_bone_global_pose(right_ids[3]).origin,
		})


func _initialize() -> void:
	Engine.max_fps = 30
	RkRetarget.xz_gain = float(_arg("rkxz", "1.0"))
	if not _selftest():
		quit(1)
		return
	if OS.get_cmdline_user_args().has("selftest"):
		quit(0)
		return
	var off := _arg("off", "")
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_01.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue", "stance": "southpaw"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Array = stage.boxers
	var skel: Skeleton3D = bx[0]["skel"]
	var rig: Node = bx[0]["rig"]
	var ap: AnimationPlayer = bx[0]["ap"]
	_watch(skel, rig)
	var left_ids: Array = rig._legs[0]["ids"]
	var hip_rest := skel.get_bone_global_rest(left_ids[0]).origin
	var knee_rest := skel.get_bone_global_rest(left_ids[1]).origin
	var ankle_rest := skel.get_bone_global_rest(left_ids[2]).origin
	leg_length_m = hip_rest.distance_to(knee_rest) + knee_rest.distance_to(ankle_rest)
	var arm_label := "GAME"
	if OS.get_cmdline_user_args().has("rknocontact"):
		arm_label = "NOCONTACT"
	elif _arg("rkxz", "1.0") != "1.0":
		arm_label = "RKXZ_" + _arg("rkxz", "1.0")
	print("FOOTSLIDE_LEG leg_left=%.4f arm=%s rkxz=%s" % [leg_length_m, arm_label, _arg("rkxz", "1.0")])
	for clip_name in CLIPS:
		if not ap.has_animation(clip_name):
			print("FOOTSLIDE %s FAIL clip not loaded" % clip_name)
			continue
		var hit := _switch_off(skel, off)
		if off != "":
			print("FOOTSLIDE_OFF %s switched %d: %s" % [clip_name, hit.size(), ", ".join(hit)])
		var w: Dictionary = RkClips.CLIPS.get(clip_name, {})
		var cycles := int(w.get("cycles", 1))
		var anim: Animation = ap.get_animation(clip_name)
		var one_cycle: float = anim.length / float(maxi(cycles, 1))
		var cycle_idx := 1 if cycles > 1 else 0
		var cycle_start: float = one_cycle * float(cycle_idx)
		var cycle_end: float = cycle_start + one_cycle
		var max_frames := int(round(one_cycle / DT)) + 2
		ap.play(clip_name)
		ap.seek(0.0, true)
		var left_pos: Array = []
		var right_pos: Array = []
		var body_pos: Array = []
		var total_frames := 0
		for f in int(anim.length / DT) + 4:
			stage._process(DT)
			await process_frame
			var playing := str(ap.current_animation)
			if playing != clip_name:
				break
			var anim_pos := ap.current_animation_position
			if anim_pos < cycle_start - DT * 0.5:
				continue
			if anim_pos >= cycle_end - DT * 0.5:
				break
			total_frames += 1
			if current_foot.is_empty():
				continue
			left_pos.append({"ball": current_foot["lb"], "ankle": current_foot["la"]})
			right_pos.append({"ball": current_foot["rb"], "ankle": current_foot["ra"]})
			var bp: Variant = bx[0].get("pos", Vector3.ZERO)
			body_pos.append(bp as Vector3)
			if total_frames >= max_frames:
				break
		if total_frames == 0:
			print("FOOTSLIDE %s FAIL 0 frames in cycle %d (start=%.3f end=%.3f)" % [
				clip_name, cycle_idx, cycle_start, cycle_end])
			continue
		print("FOOTSLIDE %s %s cycle=%d frames=%d one_cycle=%.3f" % [
			clip_name, arm_label, cycle_idx, total_frames, one_cycle])
		for foot_name in ["left", "right"]:
			var positions: Array = left_pos if foot_name == "left" else right_pos
			if positions.is_empty():
				continue
			var planted := _detect_planted(positions)
			var stretches := _find_stretches(planted)
			var snap_data := _count_snaps(positions, planted)
			for si in stretches.size():
				var stretch: Array = stretches[si]
				var first_frame: int = stretch[0]
				var stretch_ball: Array = []
				var stretch_body: Array = []
				for idx in stretch:
					stretch_ball.append((positions[idx] as Dictionary)["ball"])
					var bi: int = mini(idx, body_pos.size() - 1)
					stretch_body.append(body_pos[bi])
				var sm := _stretch_metrics(stretch_ball, stretch_body)
				var clip_time := first_frame * DT
				var path_leg := float(sm["path"]) / maxf(leg_length_m, 1e-4)
				var net_leg := float(sm["net"]) / maxf(leg_length_m, 1e-4)
				print("FOOTSLIDE_STRETCH %s %s %s frame=%d t=%.3f frames=%d path=%.4f net=%.4f along=%.4f body=%.4f along_body=%.3f path_leg=%.4f net_leg=%.4f" % [
					clip_name, foot_name, arm_label, first_frame, clip_time, stretch.size(),
					float(sm["path"]), float(sm["net"]), float(sm["along"]), float(sm["body"]),
					float(sm["along_body"]), path_leg, net_leg])
			print("FOOTSLIDE_SNAPS %s %s %s snaps=%d loop_seam=%.4f" % [
				clip_name, foot_name, arm_label, int(snap_data["snaps"]), float(snap_data["loop_seam"])])
	quit(0)
