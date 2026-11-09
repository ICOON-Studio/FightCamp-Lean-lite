extends SceneTree
## LOCOSLIDE1: the walking foot slide, measured on the four loco clips in three arms (SOURCE is the Blender tool).
## For each clip and foot: world-space ankle and ball every frame inside skeleton_updated; a foot is PLANTED when its
## ball sits within PLANT_M of the lowest height it reaches in the clip AND moves under SPEED_MAX m/s; consecutive planted
## frames form a STRETCH whose slide is the frame-to-frame ball travel summed across the stretch; SNAPS counts frames
## where the ball jumps more than SNAP_M in one frame.  Same definition in the Blender tool (tools/loco_slide_raw.py).
##   <godot.exe> --headless --path . --audio-driver Dummy --script res://tools/foot_slide_probe.gd -- [off=all|<names>]
## off=all  = CLIP arm (every SkeletonModifier3D switched off, the raw clip + RkLoco body travel)
## off=     = GAME arm (nothing switched off, the footwork rig and everything else on)
## off=X    = one layer off for isolation (the task's "switch layers off one at a time, one process each")

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const DT := 1.0 / 30.0
const WARMUP := 30
const FRAMES := 150
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


static func _compute_metrics(positions: Array, dt: float) -> Dictionary:
	if positions.is_empty():
		return {"planted_share": 0.0, "slide_mean": 0.0, "slide_worst": 0.0, "snaps": 0,
			"planted_frames": 0, "total_frames": 0, "stretches": 0}
	var min_y: float = INF
	for p in positions:
		min_y = minf(min_y, (p["ball"] as Vector3).y)
	var planted: Array = []
	for i in positions.size():
		var p: Dictionary = positions[i]
		var height_ok: bool = (p["ball"] as Vector3).y - min_y < PLANT_M
		var speed_ok: bool = true
		if i > 0:
			var dist: float = (p["ball"] as Vector3).distance_to((positions[i - 1] as Dictionary)["ball"] as Vector3)
			speed_ok = (dist / dt) < SPEED_MAX
		planted.append(height_ok and speed_ok)
	var stretches: Array = []
	var cur: Array = []
	for i in positions.size():
		if planted[i]:
			cur.append(i)
		else:
			if cur.size() > 0:
				stretches.append(cur)
				cur = []
	if cur.size() > 0:
		stretches.append(cur)
	var slides: Array = []
	for stretch in stretches:
		var slide := 0.0
		for j in range(1, stretch.size()):
			slide += (positions[stretch[j]] as Dictionary)["ball"].distance_to(
				(positions[stretch[j - 1]] as Dictionary)["ball"] as Vector3)
		slides.append(slide)
	var snaps := 0
	for i in range(1, positions.size()):
		if (positions[i] as Dictionary)["ball"].distance_to(
				(positions[i - 1] as Dictionary)["ball"] as Vector3) > SNAP_M:
			snaps += 1
	var planted_count := 0
	for v in planted:
		if v:
			planted_count += 1
	var slide_mean := 0.0
	var slide_worst := 0.0
	if slides.size() > 0:
		var total := 0.0
		for s in slides:
			total += float(s)
			slide_worst = maxf(slide_worst, float(s))
		slide_mean = total / float(slides.size())
	return {"planted_share": float(planted_count) / float(positions.size()),
		"slide_mean": slide_mean, "slide_worst": slide_worst, "snaps": snaps,
		"planted_frames": planted_count, "total_frames": positions.size(), "stretches": slides.size()}


static func _selftest() -> bool:
	var still: Array = []
	for i in 10:
		still.append({"ball": Vector3(0.1, 0.0, 0.0), "ankle": Vector3(0.1, 0.5, 0.0)})
	var m0 := _compute_metrics(still, DT)
	if float(m0["slide_mean"]) != 0.0 or float(m0["slide_worst"]) != 0.0 or int(m0["snaps"]) != 0:
		print("FOOTSLIDE_SELFTEST FAIL still slide_mean=%.4f slide_worst=%.4f snaps=%d" % [
			float(m0["slide_mean"]), float(m0["slide_worst"]), int(m0["snaps"])])
		return false
	if int(m0["planted_frames"]) != 10:
		print("FOOTSLIDE_SELFTEST FAIL still planted=%d expected 10" % int(m0["planted_frames"]))
		return false
	var creep: Array = []
	for i in 10:
		creep.append({"ball": Vector3(i * 0.005, 0.0, 0.0), "ankle": Vector3(i * 0.005, 0.5, 0.0)})
	var m1 := _compute_metrics(creep, DT)
	var expected_slide := 9.0 * 0.005
	if absf(float(m1["slide_worst"]) - expected_slide) > 0.001:
		print("FOOTSLIDE_SELFTEST FAIL creep slide_worst=%.4f expected %.4f" % [float(m1["slide_worst"]), expected_slide])
		return false
	if int(m1["planted_frames"]) != 10:
		print("FOOTSLIDE_SELFTEST FAIL creep planted=%d expected 10" % int(m1["planted_frames"]))
		return false
	var jump: Array = []
	for i in 5:
		jump.append({"ball": Vector3(0.0, 0.0, 0.0), "ankle": Vector3(0.0, 0.5, 0.0)})
	jump.append({"ball": Vector3(0.05, 0.0, 0.0), "ankle": Vector3(0.05, 0.5, 0.0)})
	for i in 4:
		jump.append({"ball": Vector3(0.05, 0.0, 0.0), "ankle": Vector3(0.05, 0.5, 0.0)})
	var m2 := _compute_metrics(jump, DT)
	if int(m2["snaps"]) != 1:
		print("FOOTSLIDE_SELFTEST FAIL jump snaps=%d expected 1" % int(m2["snaps"]))
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
	var right_ids: Array = rig._legs[1]["ids"]
	var rhip_rest := skel.get_bone_global_rest(right_ids[0]).origin
	var rknee_rest := skel.get_bone_global_rest(right_ids[1]).origin
	var rankle_rest := skel.get_bone_global_rest(right_ids[2]).origin
	var leg_r := rhip_rest.distance_to(rknee_rest) + rknee_rest.distance_to(rankle_rest)
	print("FOOTSLIDE_LEG leg_left=%.4f leg_right=%.4f off=%s" % [leg_length_m, leg_r, off])
	for clip_name in CLIPS:
		if not ap.has_animation(clip_name):
			print("FOOTSLIDE %s FAIL clip not loaded" % clip_name)
			continue
		var hit := _switch_off(skel, off)
		if off != "":
			print("FOOTSLIDE_OFF %s switched %d: %s" % [clip_name, hit.size(), ", ".join(hit)])
		ap.play(clip_name)
		ap.seek(0.0, true)
		ap.get_animation(clip_name).loop_mode = Animation.LOOP_LINEAR
		var left_pos: Array = []
		var right_pos: Array = []
		var clip_frames := 0
		var seen_clip := ""
		for f in WARMUP + FRAMES:
			stage._process(DT)
			await process_frame
			if f < WARMUP:
				continue
			var playing := str(ap.current_animation)
			if playing != clip_name:
				continue
			clip_frames += 1
			seen_clip = playing
			if current_foot.is_empty():
				continue
			left_pos.append({"ball": current_foot["lb"], "ankle": current_foot["la"]})
			right_pos.append({"ball": current_foot["rb"], "ankle": current_foot["ra"]})
		if clip_frames == 0:
			print("FOOTSLIDE %s FAIL 0 frames of clip (last=%s)" % [clip_name, str(ap.current_animation)])
			continue
		var ml := _compute_metrics(left_pos, DT)
		var mr := _compute_metrics(right_pos, DT)
		print("FOOTSLIDE %s left clip=%s frames=%d planted=%d/%d share=%.3f slide_mean=%.4f slide_worst=%.4f snaps=%d stretches=%d" % [
			clip_name, seen_clip, clip_frames, int(ml["planted_frames"]), int(ml["total_frames"]),
			float(ml["planted_share"]), float(ml["slide_mean"]), float(ml["slide_worst"]),
			int(ml["snaps"]), int(ml["stretches"])])
		print("FOOTSLIDE %s right clip=%s frames=%d planted=%d/%d share=%.3f slide_mean=%.4f slide_worst=%.4f snaps=%d stretches=%d" % [
			clip_name, seen_clip, clip_frames, int(mr["planted_frames"]), int(mr["total_frames"]),
			float(mr["planted_share"]), float(mr["slide_mean"]), float(mr["slide_worst"]),
			int(mr["snaps"]), int(mr["stretches"])])
	quit(0)
