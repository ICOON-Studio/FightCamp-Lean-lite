extends SceneTree
## FP2POSE2 (S536, owner C454 "wtf is that legs doing"): the LEGS of every cross take, as baked (no player, no pose
## layer), and of the Mixamo cross takes as candidates (raw FBX outside the repo, put on our body by RkRetarget, the
## route the step takes came by). One ruler for both: the punch line = from the hips at the start to the rear hand at
## its furthest (a shadow boxer has no opponent), the contact = that furthest picture.
##   feet side (cm, + = each foot on its own side of the punch line, - = crossed) / fwd / apart, at the start and the contact
##   rear heel: how much higher the ankle rides over the ball of the foot than at the start (cm), at the contact and at most
##   rear foot: the toes' turn from the punch line (deg, - = turned out), start -> contact = the pivot
##   rear knee (deg), the hips' turn start -> contact (deg), how far the rear ball travelled (cm)
## <godot> --headless --audio-driver Dummy --path . --script res://tools/fp2pose2_takes.gd -- [dir=E:/FightCamp/packs/mixamo_cross] [body=01] [show=<take>]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const RkRetarget := preload("res://scripts/fight3d/RkRetarget.gd")
const Orbit := preload("res://tools/clip_orbit.gd")

var skel: Skeleton3D
var ap: AnimationPlayer


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _at(clip: String, t: float) -> Dictionary:
	ap.play(clip)
	ap.seek(t, true)
	var out := {}
	for b in ["Hips", "Head", "LeftFoot", "RightFoot", "LeftToes", "RightToes", "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"]:
		out[b] = skel.get_bone_global_pose(skel.find_bone(b))
	return out


func _flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


func _o(p: Dictionary, b: String) -> Vector3:
	return (p[b] as Transform3D).origin


func _measure(clip: String, label: String) -> void:
	var a := ap.get_animation(clip)
	var n := int(a.length * 60.0)
	var p0 := _at(clip, 0.0)
	var face := _flat(_o(p0, "LeftHand") + _o(p0, "RightHand") - _o(p0, "Hips") * 2.0).normalized()   # the hands are held in front
	var rear := "Right" if face.dot(_o(p0, "RightFoot") - _o(p0, "LeftFoot")) < 0.0 else "Left"
	var lead := "Left" if rear == "Right" else "Right"
	var tc := 0.0
	var far := -1.0
	for k in n + 1:
		var p := _at(clip, float(k) / 60.0)
		var d := _flat(_o(p, rear + "Hand") - _o(p, "Head")).length()
		if d > far:
			far = d
			tc = float(k) / 60.0
	var pc := _at(clip, tc)
	var axis := _flat(_o(pc, rear + "Hand") - _o(p0, "Hips")).normalized()
	var side := Vector3.UP.cross(axis) * (1.0 if rear == "Right" else -1.0)   # the lead foot's own side
	var flat0 := _o(p0, rear + "Foot").y - _o(p0, rear + "Toes").y
	var read := func(p: Dictionary) -> Dictionary:
		var lf := _o(p, lead + "Foot")
		var rf := _o(p, rear + "Foot")
		var toe := _flat(_o(p, rear + "Toes") - rf)
		var k := _o(p, rear + "LowerLeg")
		var hz := _flat((p["Hips"] as Transform3D).basis.z)
		return {"side": side.dot(lf - rf) * 100.0, "fwd": axis.dot(lf - rf) * 100.0, "apart": _flat(lf - rf).length() * 100.0,
			"heel": (rf.y - _o(p, rear + "Toes").y - flat0) * 100.0, "yaw": rad_to_deg(atan2(toe.dot(side), toe.dot(axis))),
			"knee": rad_to_deg((_o(p, rear + "UpperLeg") - k).angle_to(rf - k)), "hips": rad_to_deg(atan2(hz.dot(side), hz.dot(axis))),
			"lead_heel": (lf.y - _o(p, lead + "Toes").y) * 100.0}
	var g: Dictionary = read.call(p0)
	var c: Dictionary = read.call(pc)
	var least := 1e9
	var heel_max := -1e9
	var heel_t := 0.0
	var yaw_max := -1e9
	for k in n + 1:
		var t := float(k) / 60.0
		var d: Dictionary = read.call(_at(clip, t))
		least = minf(least, float(d["side"]))
		yaw_max = maxf(yaw_max, float(d["yaw"]))
		if float(d["heel"]) > heel_max:
			heel_max = float(d["heel"])
			heel_t = t
		if _arg("show", "") == clip:
			print("TAKES   %s %.3f side %+.0f fwd %+.0f apart %.0f heel %+.1f yaw %+.0f knee %.0f hips %+.0f" % [clip, t, d["side"], d["fwd"], d["apart"], d["heel"], d["yaw"], d["knee"], d["hips"]])
	var ball := _flat(_o(pc, rear + "Toes") - _o(p0, rear + "Toes")).length() * 100.0
	print("TAKES %-34s %s | %s hand, contact %.2f of %.2f s | feet side/fwd/apart start %+.0f/%+.0f/%.0f contact %+.0f/%+.0f/%.0f least side %+.0f | rear heel contact %+.1f most %+.1f cm at %.2f s | rear foot %+.0f -> %+.0f deg (pivot %+.0f, most %+.0f) | rear knee %.0f -> %.0f | hips turn %+.0f deg | rear ball moved %.0f cm" % [
		clip, label, rear, tc, a.length, g["side"], g["fwd"], g["apart"], c["side"], c["fwd"], c["apart"], least, c["heel"], heel_max, heel_t,
		g["yaw"], c["yaw"], float(c["yaw"]) - float(g["yaw"]), yaw_max - float(g["yaw"]), g["knee"], c["knee"], float(c["hips"]) - float(g["hips"]), ball])


func _initialize() -> void:
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("body", "01"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	Orbit.strip_modifiers(skel)
	var lib: AnimationLibrary = ap.get_animation_library("")
	var prefix := str(ap.get_node(ap.root_node).get_path_to(skel))
	var names: Array = Array(ap.get_animation_list()).filter(func(nm): return str(nm).begins_with("pro_right_cross") or str(nm) == "pro_idle" or str(nm) == _arg("also", "-"))
	names.sort()
	for nm in names:
		_measure(str(nm), "PRO")
	var dir := _arg("dir", "E:/FightCamp/packs/mixamo_cross")
	for f in DirAccess.get_files_at(dir):
		if not str(f).to_lower().ends_with(".fbx"):
			continue
		var anim := RkRetarget.build(skel, dir.path_join(str(f)), 0.0, 999.0, true)
		if anim == null:
			print("TAKES MISSING ", f)
			continue
		for t in anim.get_track_count():
			anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
		var nm := "mx_" + str(f).get_basename().to_lower().replace(" ", "_")
		lib.add_animation(nm, anim)
		_measure(nm, "MIXAMO")
	print("TAKES done")
	quit(0)
