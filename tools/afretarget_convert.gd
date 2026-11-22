extends SceneTree
## AFRETARGET1 (S537): ActionForge's retarget of a bought take (a GLB on mh_boxer_01's own skeleton) written in the
## shape of our baked clips, so the game can play it in place of our bake (`-- afretarget`, FightClips.AF_DIR).
## Kept from ActionForge: the LEGS (thigh, shin, foot) and the hips' travel - the part the owner liked there. The rest
## of the body stays our bake of the bought file: ActionForge's hands are turned ~155 deg about the forearm against the
## actor's (tools/afretarget_src.gd palm=1), ours are within 7. `whole=1` keeps every ActionForge rotation. Ours: the facing (turned to stand as our bake of
## the same take stands, so the plan's distances hold), the size (its body is ours at 0.895), the floor (the lowest toe
## joint of the take on the floor), and the toes at rest (ActionForge keys none).
##   <godot> --headless --path . --script res://tools/afretarget_convert.gd -- in=<af.glb> like=<our baked .res> out=<.res>
const MH := preload("res://scripts/fight3d/MHRig.gd")
const AF := preload("res://tools/afretarget_lib.gd")
const LEG := ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"]

func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % _arg("glb", "mh_boxer_01"))
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var af := AF.af_anim(_arg("in", AF.AF_CROSS))
	var like := load(_arg("like", "res://assets/anim/baked/mc_Box1_M3_Right_Cross.res")) as Animation
	var out := _arg("out", "res://assets/anim/af_retarget/mc_Box1_M3_Right_Cross.res")
	if af == null or like == null:
		print("AFCONVERT FAIL a clip did not load")
		quit(1)
		return
	var ta := AF.tracks(af)
	var tl := AF.tracks(like)
	var hb := skel.find_bone("Hips")
	var rest_h := skel.get_bone_global_rest(hb).basis
	var rest_p := skel.get_bone_rest(hb).origin
	var frames := int(round(af.length * 30.0))
	var k := rest_p.y / (af.position_track_interpolate(int(ta["pos"]["Hips"]), 0.0) as Vector3).y
	var fa := Vector3.ZERO
	var fl := Vector3.ZERO
	for fi in frames + 1:
		fa += ((AF.pose(skel, af, ta, fi / 30.0, false)[hb] as Transform3D).basis * rest_h.inverse()) * Vector3(0, 0, 1)
		fl += ((AF.pose(skel, like, tl, minf(fi / 30.0, like.length), true)[hb] as Transform3D).basis * rest_h.inverse()) * Vector3(0, 0, 1)
	var Y := Quaternion(Vector3.UP, atan2(fl.x, fl.z) - atan2(fa.x, fa.z))
	var p0: Vector3 = af.position_track_interpolate(int(ta["pos"]["Hips"]), 0.0)
	var whole := _arg("whole", "0") == "1"
	var anim := Animation.new()
	anim.length = af.length
	anim.step = 1.0 / 30.0
	var hips_pos := -1
	for t in like.get_track_count():
		var nm := str(like.track_get_path(t))
		var nt := anim.add_track(like.track_get_type(t))
		anim.track_set_path(nt, like.track_get_path(t))
		anim.track_set_interpolation_type(nt, like.track_get_interpolation_type(t))
		for fi in frames + 1:
			var time := fi / 30.0
			if like.track_get_type(t) == Animation.TYPE_ROTATION_3D:
				var q := skel.get_bone_rest(skel.find_bone(nm)).basis.get_rotation_quaternion()
				if (ta["rot"] as Dictionary).has(nm) and (whole or LEG.has(nm)):
					q = af.rotation_track_interpolate(int(ta["rot"][nm]), time)
					if nm == "Hips":
						q = (Y * q).normalized()
				elif not whole and not nm.ends_with("Toes"):
					q = like.rotation_track_interpolate(t, minf(time, like.length))
				anim.rotation_track_insert_key(nt, time, q)
			elif like.track_get_type(t) == Animation.TYPE_POSITION_3D:
				hips_pos = nt
				var p: Vector3 = af.position_track_interpolate(int(ta["pos"]["Hips"]), time)
				anim.position_track_insert_key(nt, time, Y * ((p - p0) * k))   # an offset from the body's own rest
	var mended: Array = AF.pops(anim, true, 12.0, [] if whole else LEG)
	for m in mended:
		print("AFCONVERT mended ActionForge's pop: %s at %.2f s" % [str(anim.track_get_path(int(m[0]))), anim.track_get_key_time(int(m[0]), int(m[1]))])
	# the floor: the lowest toe joint of the take sits where the toe joint rests
	var tn := AF.tracks(anim)
	var low := 1e9
	for fi in frames + 1:
		var g := AF.pose(skel, anim, tn, fi / 30.0, true)
		for toe in ["LeftToes", "RightToes"]:
			low = minf(low, (g[skel.find_bone(toe)] as Transform3D).origin.y)
	var lift := skel.get_bone_global_rest(skel.find_bone("LeftToes")).origin.y - low
	for kk in anim.track_get_key_count(hips_pos):
		anim.track_set_key_value(hips_pos, kk, (anim.track_get_key_value(hips_pos, kk) as Vector3) + Vector3(0, lift, 0))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out.get_base_dir()))
	var err := ResourceSaver.save(anim, out)
	print("AFCONVERT %s -> %s (%s): %d pictures, %d tracks, turned %.0f deg, size x%.3f, lifted %.1f cm, save %d" % [_arg("in", AF.AF_CROSS).get_file(), out, "all of ActionForge" if whole else "ActionForge's legs under our bake", frames + 1, anim.get_track_count(), rad_to_deg(Y.get_angle()), k, lift * 100.0, err])
	quit(0 if err == OK else 1)
