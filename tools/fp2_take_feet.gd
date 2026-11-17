extends SceneTree
## FIGHTPLAYER2 (S513): do a take's OWN feet stand still when the v2 player plays it with its hip travel on the body?
## Boxer 0 plays each take alone (no plan, nobody hit), once with no leg layer and once with FootCarry; per take it
## prints the support-foot slip (the stiller foot that stands, as drawn), the body's travel and the worst frame.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/fp2_take_feet.gd -- fightplayer2 [show=<take>] [takes=a,b]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const TAKES := ["pro_left_jab", "pro_left_jab_c", "pro_left_hook_hard", "pro_left_hook_hard_ft", "pro_right_cross_a", "pro_right_uppercut",
	"pro_body_shot", "pro_kidney_shot", "pro_right_dodge", "pro_left_dodge", "pro_hit_by_gutshot_v2", "pro_hit_by_hook_v3", "pro_idle"]


func _initialize() -> void:
	var show := ""
	var takes: Array = TAKES
	for a in OS.get_cmdline_user_args():
		if a.begins_with("show="):
			show = a.substr(5)
		if a.begins_with("takes="):
			takes = Array(a.substr(6).split(","))
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_07.glb", "corner": "blue"})
	var bx: Dictionary = st.boxers[0]
	var sk: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var names := ["LeftToes", "RightToes", "Hips", "LeftFoot", "RightFoot"]
	var ids: Array = names.map(func(n): return sk.find_bone(n))
	var shown: Array = [Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO]
	sk.skeleton_updated.connect(func():
		for k in ids.size():
			shown[k] = sk.global_transform * sk.get_bone_global_pose(int(ids[k])).origin)
	for i in 40:
		await process_frame
	var p2: Node = st.v2
	var fc: SkeletonModifier3D = p2._feet[0]
	var floor_y := [shown[0].y, shown[1].y]
	for take in takes:
		if not ap.has_animation(str(take)):
			print("TAKEFEET %-26s missing" % take)
			continue
		var line := "TAKEFEET %-26s" % take
		for arm in ["none", "carry"]:
			if fc != null:
				fc.active = arm == "carry"
				fc.reset()
			p2.guard(0)
			for i in 30:
				await process_frame
			p2._play(0, str(take), 0.0, "punch", true)
			var n := int(ap.get_animation(str(take)).length * 60.0) - 2
			var prev: Array = []
			var slip := 0.0
			var worst := 0.0
			var worst_f := 0
			var body0: Vector3 = (bx["node"] as Node3D).position
			var far := 0.0
			for f in n:
				await process_frame
				var cur := [shown[0], shown[1]]
				far = maxf(far, ((bx["node"] as Node3D).position - body0).length())
				if not prev.is_empty():
					var vs: Array = []
					for k in 2:
						if (cur[k] as Vector3).y - float(floor_y[k]) < 0.03:
							vs.append(Vector2(cur[k].x - prev[k].x, cur[k].z - prev[k].z).length())
					if not vs.is_empty() and float(vs.min()) * 60.0 > 0.15:
						slip += float(vs.min())
						if float(vs.min()) > worst:
							worst = float(vs.min())
							worst_f = f
				if show == str(take):
					print("  %s f%03d body %+.3f %+.3f  L %+.3f %+.3f y %.3f  R %+.3f %+.3f y %.3f  hips %+.3f %+.3f" % [arm, f, (bx["node"] as Node3D).position.x, (bx["node"] as Node3D).position.z,
						cur[0].x, cur[0].z, cur[0].y - float(floor_y[0]), cur[1].x, cur[1].z, cur[1].y - float(floor_y[1]), shown[2].x, shown[2].z])
				prev = cur
			line += "  %s: slip %.2f m (worst %.1f cm f%d) body %.2f m" % [arm, slip, worst * 100.0, worst_f, far]
		print(line + "  len %.2f s" % ap.get_animation(str(take)).length)
	quit(0)
