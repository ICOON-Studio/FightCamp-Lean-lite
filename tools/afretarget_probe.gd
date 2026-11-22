extends SceneTree
## AFRETARGET1: ActionForge's retarget of the cross beside our bake, on the same body, clip alone (no player, no layer).
##   <godot> --headless --path . --script res://tools/afretarget_probe.gd -- [res=<baked.res>] [glb=mh_boxer_01] [at=0.30] [all=1]
const MH := preload("res://scripts/fight3d/MHRig.gd")
const KR := preload("res://tools/kneeroot_lib.gd")
const AF := preload("res://tools/afretarget_lib.gd")

func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def

func _initialize() -> void:
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % _arg("glb", "mh_boxer_01"))
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var af := AF.af_anim()
	var ours := load(_arg("res", "res://assets/anim/baked/mc_Box1_M3_Right_Cross.res")) as Animation
	if af == null or ours == null:
		print("AFPROBE FAIL a clip did not load")
		quit(1)
		return
	var ta := AF.tracks(af)
	var to := AF.tracks(ours)
	print("AFPROBE lengths af %.3f ours %.3f | af tracks %d ours %d" % [af.length, ours.length, af.get_track_count(), ours.get_track_count()])
	var at := float(_arg("at", "0.30"))
	var leg := KR.leg_len(AF.pts(skel, AF.pose(skel, af, ta, 0.0, false)))
	var n := int(round(minf(af.length, ours.length) * 30.0))
	var worst := {}
	for fi in n + 1:
		var t := fi / 30.0
		var ga := AF.pose(skel, af, ta, t, false)
		var go := AF.pose(skel, ours, to, t, true)
		var ra := KR.legs(AF.pts(skel, ga), leg, false)
		var ro := KR.legs(AF.pts(skel, go), leg, false)
		var hit := absf(t - at) < 0.017
		if hit or _arg("all", "0") == "1":
			print("AFPROBE t=%.2f AF   %s | arm R %.0f%% L %.0f%%" % [t, KR.line(ra), AF.arm(skel, ga, "Right"), AF.arm(skel, ga, "Left")])
			print("AFPROBE t=%.2f OURS %s | arm R %.0f%% L %.0f%%" % [t, KR.line(ro), AF.arm(skel, go, "Right"), AF.arm(skel, go, "Left")])
		var parts: Array = []
		for nm in AF.LEGS:
			var d := AF.local_diff(af, ta, ours, to, nm, t)
			var gd := rad_to_deg((ga[skel.find_bone(nm)] as Transform3D).basis.get_rotation_quaternion().angle_to((go[skel.find_bone(nm)] as Transform3D).basis.get_rotation_quaternion()))
			parts.append("%s %.0f(tw %+.0f, glob %.0f)" % [nm.replace("Left", "L").replace("Right", "R").replace("UpperLeg", "thigh").replace("LowerLeg", "calf"), d.x, d.y, gd])
			worst[nm] = maxf(float(worst.get(nm, 0.0)), d.x)
		for w in ["lead", "rear"]:
			worst[w] = maxf(float(worst.get(w, 0.0)), absf(float(ra[w]["valgus"]) - float(ro[w]["valgus"])))
		if hit or _arg("all", "0") == "1":
			print("AFPROBE t=%.2f local rot ours-vs-AF deg: %s" % [t, ", ".join(PackedStringArray(parts))])
			var hp_a: Vector3 = (ga[skel.find_bone("Hips")] as Transform3D).origin
			var hp_o: Vector3 = (go[skel.find_bone("Hips")] as Transform3D).origin
			print("AFPROBE t=%.2f hips AF %s ours %s" % [t, hp_a, hp_o])
	print("AFPROBE WORST over the take: ", worst)
	quit(0)
