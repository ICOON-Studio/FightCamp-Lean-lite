extends SceneTree
## KICKTAKE1 (S559): the three Mixamo kicks measured on our MetaHuman, raw from RkRetarget (no turn, no mirror):
## which foot leads at the start, which foot kicks (the one that rises most), when it peaks, the way it goes (deg from the
## boxer's forward), how far the standing foot slides and rises, the hips' travel.
##   <godot> --headless --audio-driver Dummy --path . --script res://tools/kick_probe.gd -- [body=02] [show=teep]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const RkRetarget := preload("res://scripts/fight3d/RkRetarget.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const TAKES := ["teep", "low_kick", "low_kick_return"]

var skel: Skeleton3D
var ap: AnimationPlayer
var node: Node3D


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _w(bone: String) -> Vector3:
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin


func _at(clip: String, t: float) -> void:
	ap.play(clip)
	ap.seek(t, true)


func _initialize() -> void:
	FightClips.untouched = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("body", "02"), "corner": "red", "stance": "orthodox"},
		{"glb": "res://assets/models/metahuman/mh_boxer_01.glb", "corner": "blue", "stance": "orthodox"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	node = bx["node"]
	Orbit.strip_modifiers(skel)
	var fwd := (node.global_transform.basis.z * Vector3(1, 0, 1)).normalized()
	var right := fwd.cross(Vector3.UP).normalized()   # the boxer's own right
	var lib: AnimationLibrary = ap.get_animation_library("")
	var prefix := str(ap.get_node(ap.root_node).get_path_to(skel))
	for nm in TAKES:
		var anim := RkRetarget.build(skel, "res://assets/anim/kicks/%s_mixamo.fbx" % nm, 0.0, 999.0, true)
		if anim == null:
			print("KPROBE MISSING ", nm)
			continue
		for t in anim.get_track_count():
			anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
		var clip := "kx_" + str(nm)
		lib.add_animation(clip, anim)
		var n := int(anim.length * 30.0)
		_at(clip, 0.0)
		var hips0 := _w("Hips")
		var f0 := {"Left": _w("LeftFoot"), "Right": _w("RightFoot")}
		var flat := func(v: Vector3) -> Vector3: return Vector3(v.x, 0.0, v.z)
		var lead := "Left" if (f0["Left"] - f0["Right"]).dot(fwd) > 0.0 else "Right"
		var hi := {"Left": -1.0, "Right": -1.0}
		var hi_t := {"Left": 0.0, "Right": 0.0}
		var far := {"Left": Vector3.ZERO, "Right": Vector3.ZERO}
		for k in n + 1:
			_at(clip, float(k) / 30.0)
			for s in ["Left", "Right"]:
				var y := _w(s + "Foot").y - (f0[s] as Vector3).y
				if y > float(hi[s]):
					hi[s] = y
					hi_t[s] = float(k) / 30.0
					far[s] = _w(s + "Toes")
		var kick := "Left" if float(hi["Left"]) > float(hi["Right"]) else "Right"
		var stand := "Right" if kick == "Left" else "Left"
		var d: Vector3 = flat.call(far[kick] - hips0)
		var yaw := rad_to_deg(atan2(d.dot(right), d.dot(fwd)))
		var slide := 0.0
		var rise := 0.0
		var hips_far := 0.0
		for k in n + 1:
			_at(clip, float(k) / 30.0)
			slide = maxf(slide, (flat.call(_w(stand + "Foot") - f0[stand]) as Vector3).length())
			rise = maxf(rise, _w(stand + "Foot").y - (f0[stand] as Vector3).y)
			hips_far = maxf(hips_far, (flat.call(_w("Hips") - hips0) as Vector3).length())
			if _arg("show", "") == str(nm):
				var h := _w("Hips")
				print("KPROBE   %s %.2f hips fwd %+.2f right %+.2f up %.2f | L foot fwd %+.2f right %+.2f up %.2f | R foot fwd %+.2f right %+.2f up %.2f" % [nm, float(k) / 30.0,
					(h - hips0).dot(fwd), (h - hips0).dot(right), h.y, (_w("LeftFoot") - hips0).dot(fwd), (_w("LeftFoot") - hips0).dot(right), _w("LeftFoot").y,
					(_w("RightFoot") - hips0).dot(fwd), (_w("RightFoot") - hips0).dot(right), _w("RightFoot").y])
		print("KPROBE %s len %.2f s | lead foot %s (L fwd %+.2f, R fwd %+.2f from the hips) | kicks %s, foot up %.2f m at %.2f s, toes at the peak %.2f m out at %+.0f deg (0 = his forward, + = his right), %.2f m high | standing %s: slides %.3f m, rises %.3f m | hips travel up to %.2f m" % [
			nm, anim.length, lead, (f0["Left"] - hips0).dot(fwd), (f0["Right"] - hips0).dot(fwd), kick, hi[kick], hi_t[kick], d.length(), yaw, (far[kick] as Vector3).y, stand, slide, rise, hips_far])
	print("KPROBE done")
	quit(0)
