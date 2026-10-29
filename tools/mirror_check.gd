extends SceneTree
## S302 southpaw check: one body loaded orthodox and the same body loaded southpaw (MirrorClip). At several moments of each
## clip, every limb point of the southpaw must sit where the orthodox one's counterpart sits, reflected across her centre
## plane (x -> -x in her own frame). Prints the worst error per clip in cm; a clean mirror is under 1 cm. Headless:
##   <godot.exe> --headless --path . --script res://tools/mirror_check.gd -- [prefix=pro_left_jab,pro_idle,...] [control=1]
## control=1 loads the second body orthodox too (the control arm: it must read tens of cm off).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const POINTS := ["LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftFoot", "RightFoot", "Head", "Hips"]


func _initialize() -> void:
	var prefix := "pro_left_jab,pro_right_cross,pro_left_hook,pro_idle,advance,strafe_left,pro_hit_by_jab_v1_short"
	var stance := "southpaw"
	for a in OS.get_cmdline_user_args():
		if str(a) == "control=1":
			stance = "orthodox"
		if str(a).begins_with("prefix="):
			prefix = str(a).substr(7)
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	var t0 := Time.get_ticks_msec()
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue", "stance": stance})
	print("MIRROR setup with one southpaw took %d ms" % (Time.get_ticks_msec() - t0))
	stage.set_process(false)
	var ortho: Dictionary = stage.boxers[0]
	var south: Dictionary = stage.boxers[1]
	var ap: AnimationPlayer = ortho["ap"]
	var worst_all := 0.0
	for name in ap.get_animation_list():
		if not Array(prefix.split(",")).any(func(p): return str(name).begins_with(str(p))):
			continue
		var length: float = ap.get_animation(name).length
		var worst := 0.0
		for i in 6:
			var t := length * float(i) / 5.0
			for p in POINTS:
				var a: Vector3 = stage._pose_point(ortho, str(name), t, MirrorClip.counterpart(p))
				var b: Vector3 = stage._pose_point(south, str(name), t, p)
				worst = maxf(worst, Vector3(-a.x, a.y, a.z).distance_to(b))
		worst_all = maxf(worst_all, worst)
		print("MIRROR %-32s worst %.1f cm" % [name, worst * 100.0])
	print("MIRROR DONE worst %.1f cm" % (worst_all * 100.0))
	quit(0)
