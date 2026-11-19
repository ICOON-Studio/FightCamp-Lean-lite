extends SceneTree
## S530 (the owner on film 7: "blues shoes are not stepping normal he is mostly on his toes"): is a take ON ITS TOES by
## itself? Both fight bodies pose each take raw (as bought, every fight layer off) and per foot it prints how high the
## ankle rides over the toes against the guard's own flat boot: the share of the take's pictures with the heel up over
## 3 cm while the toes are within 3 cm of their lowest, and the mean rise then.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/foot_pitch_probe.gd [-- takes=a,b]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const TAKES := ["pro_idle", "st_in_s", "st_in_m", "st_out_s", "st_out_m", "st_l_s", "st_r_s", "st_fwd_s", "st_back_s", "st_left_s", "st_right_s", "st_bounce"]
const HZ := 30.0


func _initialize() -> void:
	var takes: Array = TAKES
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("takes="):
			takes = Array(str(a).trim_prefix("takes=").split(","))
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	for b in 2:
		var skel: Skeleton3D = st.boxers[b]["skel"]
		var ap: AnimationPlayer = st.boxers[b]["ap"]
		Orbit.strip_modifiers(skel)
		var ids := {}
		for n in ["LeftFoot", "RightFoot", "LeftToes", "RightToes", "Hips", "LeftLowerLeg", "RightLowerLeg"]:
			ids[n] = skel.find_bone(n)
		var flat := {}
		var floor := {}
		for s in ["Left", "Right"]:
			ap.play("pro_idle")
			ap.seek(0.0, true)
			var w := skel.global_transform
			flat[s] = (w * skel.get_bone_global_pose(int(ids[s + "Foot"])).origin).y - (w * skel.get_bone_global_pose(int(ids[s + "Toes"])).origin).y
			floor[s] = (w * skel.get_bone_global_pose(int(ids[s + "Toes"])).origin).y
		print("FOOTPITCH boxer %d scale %.3f | guard: ankle over toes L %.3f R %.3f m, toes at %.3f / %.3f, shin L %.3f R %.3f m" % [b, (st.boxers[b]["node"] as Node3D).scale.x,
			float(flat["Left"]), float(flat["Right"]), float(floor["Left"]), float(floor["Right"]),
			skel.get_bone_global_pose(int(ids["LeftLowerLeg"])).origin.distance_to(skel.get_bone_global_pose(int(ids["LeftFoot"])).origin),
			skel.get_bone_global_pose(int(ids["RightLowerLeg"])).origin.distance_to(skel.get_bone_global_pose(int(ids["RightFoot"])).origin)])
		for take in takes:
			if not ap.has_animation(str(take)):
				continue
			var n := maxi(2, int(ap.get_animation(str(take)).length * HZ))
			var line := "FOOTPITCH   %-12s" % str(take)
			for s in ["Left", "Right"]:
				var up := 0
				var rise := 0.0
				var low := 0
				var toe_min := INF
				var poses: Array = []
				for i in n:
					ap.play(str(take))
					ap.seek(i / HZ, true)
					var w := skel.global_transform
					var a: Vector3 = w * skel.get_bone_global_pose(int(ids[s + "Foot"])).origin
					var t: Vector3 = w * skel.get_bone_global_pose(int(ids[s + "Toes"])).origin
					poses.append([a.y, t.y])
					toe_min = minf(toe_min, t.y)
				for p in poses:
					if float(p[1]) - toe_min < 0.03:
						low += 1
						if float(p[0]) - float(p[1]) - float(flat[s]) > 0.03:
							up += 1
							rise += float(p[0]) - float(p[1]) - float(flat[s])
				line += "  %s heel up %3d %% of %2d low pictures (%.0f cm), toes lowest %+.3f" % [s[0], 100 * up / maxi(low, 1), low, 100.0 * rise / maxf(up, 1), toe_min - float(floor[s])]
			print(line)
	quit(0)
