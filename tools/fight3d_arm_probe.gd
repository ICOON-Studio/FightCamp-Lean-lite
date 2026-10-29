extends SceneTree
## Diagnostic: one boxer in the moving guard, seen from her front, her near side and her back, with the tee shown and
## hidden, so a missing or buried limb shows where it really is. Real pictures only (hidden desktop):
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --script res://tools/fight3d_arm_probe.gd -- <out_dir>

const Stage := preload("res://scripts/fight3d/FightStage.gd")

var out_dir := "user://arm_probe"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	var who := "mh_boxer_11"
	for a in args:
		if str(a).begins_with("glb="):
			who = str(a).substr(4)
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % who, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	stage.set_process(false)
	(stage.boxers[1]["node"] as Node3D).visible = false
	var body: Node3D = stage.boxers[0]["node"]
	var skel: Skeleton3D = stage.boxers[0]["skel"]
	var move := "idle"
	var at := 1.0
	for a in args:
		if str(a).begins_with("move="):
			move = str(a).substr(5)
		if str(a).begins_with("at="):
			at = float(str(a).substr(3))
	Stage.IdleMatch.freeze(stage.boxers[0], move, at)
	await _wait(4)
	var c: Vector3 = body.global_position + Vector3(0, 1.15, 0)
	var fwd: Vector3 = body.global_transform.basis.z
	var left: Vector3 = body.global_transform.basis.x
	for tee in [true, false]:
		for m in body.find_children("*", "MeshInstance3D", true, false):
			if str(m.name).contains("Outfit"):
				(m as Node3D).visible = tee
		for view in [["front", fwd], ["frontleft", (fwd + left).normalized()], ["frontright", (fwd - left).normalized()], ["right", -left]]:
			stage.camera.fov = 35.0
			stage.camera.look_at_from_position(c + (view[1] as Vector3) * 2.2 + Vector3(0, 0.15, 0), c, Vector3.UP)
			await _shot("%s_%s" % [view[0], "tee" if tee else "notee"])
	# Where the upper arms are against the chest, metres in her own frame.
	for side in ["Left", "Right"]:
		var ua: Vector3 = body.global_transform.affine_inverse() * skel.global_transform * skel.get_bone_global_pose(skel.find_bone(side + "UpperArm")).origin
		var el: Vector3 = body.global_transform.affine_inverse() * skel.global_transform * skel.get_bone_global_pose(skel.find_bone(side + "LowerArm")).origin
		var ch: Vector3 = body.global_transform.affine_inverse() * skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Chest")).origin
		print("ARM %s shoulder=%s elbow=%s chest=%s elbow_x_from_chest=%.3f" % [side, ua, el, ch, el.x - ch.x])
	quit(0)


func _wait(n: int) -> void:
	for i in n:
		await process_frame


func _shot(name: String) -> void:
	await _wait(3)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
