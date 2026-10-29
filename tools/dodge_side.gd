extends SceneTree
## S305: which way each dodge / weave clip moves her head, in her own frame (sign of x vs her LeftHand's side in guard).
## Headless: <godot.exe> --headless --path . --script res://tools/dodge_side.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const CLIPS := ["strafe_left", "strafe_right", "pro_left_dodge", "pro_right_dodge", "pro_left_weave", "pro_right_weave", "pro_quick_weave", "pro_back_dodge",
	"pro_back_weave"]


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	var bx: Dictionary = stage.boxers[0]
	var left_x: float = Stage.IdleMatch.pose_point(bx, "pro_idle", 0.0, "LeftUpperArm").x
	var head0: Vector3 = Stage.IdleMatch.pose_point(bx, "pro_idle", 0.0, "Head")
	print("DODGE her_left_is_x_sign=%+.0f" % signf(left_x))
	for c in CLIPS:
		if not stage.has_move(c):
			print("DODGE %s missing" % c)
			continue
		var length: float = (bx["ap"] as AnimationPlayer).get_animation(c).length
		var best := Vector3.ZERO
		for k in 40:
			var d: Vector3 = Stage.IdleMatch.pose_point(bx, c, length * k / 40.0, "Head") - head0
			if Vector2(d.x, d.y).length() > Vector2(best.x, best.y).length():
				best = d
		var side := "her LEFT" if signf(best.x) == signf(left_x) else "her RIGHT"
		print("DODGE %s head x=%+.2f y=%+.2f z=%+.2f -> %s" % [c, best.x, best.y, best.z, side])
		# S305 (operator: "sidestep ... returns back to the same point"): the hips and feet across the clip.
		var hip0: Vector3 = Stage.IdleMatch.pose_point(bx, "pro_idle", 0.0, "Hips")
		var line := "HIPS %s len=%.2f" % [c, length]
		for k in 9:
			var t := length * k / 8.0
			var hp: Vector3 = Stage.IdleMatch.pose_point(bx, c, t, "Hips") - hip0
			var lf: Vector3 = Stage.IdleMatch.pose_point(bx, c, t, "LeftFoot")
			line += " | %.2fs x%+.2f z%+.2f Lf%+.2f" % [t, hp.x, hp.z, lf.x]
		print(line)
	quit(0)

