extends SceneTree
## S409 HITREACT1: do hit reactions move as much as their source capture?
## HEAD: max distance the Head bone moves from where it starts, relative to UpperChest (spine top), metres.
## TRUNK: max change in the angle of the line from Hips to Neck, degrees.
## Two modes: clip (every SkeletonModifier3D off) and game (modifiers on).
##   <godot.exe> --headless --path . --audio-driver Dummy --fixed-fps 30 --script res://tools/hit_react_probe.gd -- [mode=clip|game]
## Same maths on the source take: tools/hit_react_raw.py.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const DT := 1.0 / 30.0
const WARMUP := 4


static func head_disp(head: Vector3, head0: Vector3, chest: Vector3, chest0: Vector3) -> float:
	return (head - chest).distance_to(head0 - chest0)


static func trunk_angle(hips: Vector3, neck: Vector3) -> float:
	var v := neck - hips
	if v.length() < 1e-5:
		return 0.0
	return rad_to_deg(v.angle_to(Vector3.UP))


static func selftest() -> bool:
	var ok := true
	ok = ok and absf(head_disp(Vector3(0, 1.1, 0), Vector3(0, 1.0, 0), Vector3(0, 0.9, 0), Vector3(0, 0.9, 0)) - 0.1) < 1e-4
	var s := Vector3(1, 0, 0)
	ok = ok and absf(head_disp(Vector3(0, 1.1, 0) + s, Vector3(0, 1.0, 0) + s, Vector3(0, 0.9, 0) + s, Vector3(0, 0.9, 0) + s) - 0.1) < 1e-4
	ok = ok and absf(trunk_angle(Vector3(0, 1, 0), Vector3(0, 2, 0))) < 0.1
	var neck_tilt := Vector3(0, cos(deg_to_rad(20)), sin(deg_to_rad(20)))
	ok = ok and absf(trunk_angle(Vector3(0, 1, 0), Vector3(0, 1, 0) + neck_tilt) - 20.0) < 0.5
	var hips_off := Vector3(5, 0, -3)
	ok = ok and absf(trunk_angle(hips_off, hips_off + neck_tilt) - 20.0) < 0.5
	print("HITREACT_SIGN %s" % ("ok" if ok else "FAIL"))
	return ok


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


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


static func _all_react_clips() -> Array:
	var names: Dictionary = {}
	for key in BeatClips.REACT:
		for n in BeatClips.REACT[key]:
			if str(n).begins_with("pro_"):
				names[str(n)] = true
	for n in BeatClips.BIG_REACT:
		if str(n).begins_with("pro_"):
			names[str(n)] = true
	return names.keys()


static func _read_bones(skel: Skeleton3D) -> Dictionary:
	var xf := skel.global_transform
	var head_idx := skel.find_bone("Head")
	var neck_idx := skel.find_bone("Neck")
	var hips_idx := skel.find_bone("Hips")
	var chest_idx := skel.find_bone("UpperChest")
	if head_idx < 0 or neck_idx < 0 or hips_idx < 0 or chest_idx < 0:
		return {}
	return {
		"head": xf * skel.get_bone_global_pose(head_idx).origin,
		"neck": xf * skel.get_bone_global_pose(neck_idx).origin,
		"hips": xf * skel.get_bone_global_pose(hips_idx).origin,
		"chest": xf * skel.get_bone_global_pose(chest_idx).origin,
	}


func _measure_boxer(bx: Dictionary, clips: Array, mode: String, body_idx: int) -> void:
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var body_name := "mh_boxer_01" if body_idx == 0 else "mh_boxer_02"

	for clip in clips:
		if not ap.has_animation(clip):
			continue

		ap.play(clip)
		ap.seek(0.0, true)
		for f in WARMUP:
			await process_frame

		var base_bones := _read_bones(skel)
		if base_bones.is_empty():
			print("HITREACT %s %s %s frames=0 head_m=0.0000 trunk_deg=0.0 NO_BONES" % [mode, clip, body_name])
			continue
		var base_head: Vector3 = base_bones["head"]
		var base_chest: Vector3 = base_bones["chest"]
		var base_ta: float = trunk_angle(base_bones["hips"], base_bones["neck"])
		print("HITREACT_BASE %s %s %s head_y=%.3f" % [mode, clip, body_name, float(base_bones["head"].y)])

		var peak_head := 0.0
		var peak_trunk := 0.0
		var frames_used := 0
		var length: float = ap.get_animation(clip).length

		for fr in range(1, 120):
			var t: float = float(fr) * DT
			if t > length:
				break
			ap.seek(t, true)
			await process_frame
			if str(ap.current_animation) != clip:
				break
			var bones := _read_bones(skel)
			if bones.is_empty():
				continue
			frames_used += 1
			var hd := head_disp(bones["head"], base_head, bones["chest"], base_chest)
			var ta := absf(trunk_angle(bones["hips"], bones["neck"]) - base_ta)
			peak_head = maxf(peak_head, hd)
			peak_trunk = maxf(peak_trunk, ta)

		print("HITREACT %s %s %s frames=%d head_m=%.4f trunk_deg=%.1f" % [mode, clip, body_name, int(frames_used), float(peak_head), float(peak_trunk)])


func _initialize() -> void:
	Engine.max_fps = 30
	if not selftest():
		quit(1)
		return
	var mode := _arg("mode", "clip")

	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame

	var glb0 := "res://assets/models/metahuman/mh_boxer_01.glb"
	var glb1 := "res://assets/models/metahuman/mh_boxer_02.glb"
	stage.setup({"glb": glb0, "corner": "red"}, {"glb": glb1, "corner": "blue", "stance": "southpaw"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT

	var bx: Array = stage.boxers
	for i in 2:
		var skel: Skeleton3D = bx[i]["skel"]
		if mode == "clip":
			_switch_off(skel, "all")
		else:
			if bx[i].get("weave") != null:
				(bx[i]["weave"] as SkeletonModifier3D).active = false

	var clips: Array = _all_react_clips()
	for i in 2:
		var ap: AnimationPlayer = bx[i]["ap"]
		var avail: Array = []
		for c in clips:
			if ap.has_animation(str(c)):
				avail.append(str(c))
		print("HITREACT_AVAIL boxer=%d body=%s clips=%d" % [i, "mh_boxer_01" if i == 0 else "mh_boxer_02", avail.size()])

	for i in 2:
		await _measure_boxer(bx[i], clips, mode, i)
	quit(0)
