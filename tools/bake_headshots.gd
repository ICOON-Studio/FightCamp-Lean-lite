extends SceneTree
## S334 (operator C152 on HOME's polaroid, the A-pose bust: "looks kind silly"): each boxer's picture on the whiteboard is a
## real fight photo - her in guard in the ring, gloves up, a three-quarter view on a portrait lens, the ring and crowd soft
## behind her (the opponent is hidden). Same ring, kit and guard as the fight (FightStage).
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 600x750 \
##       --script res://tools/bake_headshots.gd [-- stems=mh_boxer_11,mh_boxer_19]
## Writes assets/ui/face/<stem>.jpg (W x H). HomeBoard.portrait shows it; the old body crop is the fallback.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const W := 600
const H := 750
const OUT := "res://assets/ui/face"
const FOV := 21.0          # degrees, vertical: a portrait lens
const DIST_M := 1.6        # camera to her face: head and shoulders fill the photo
const YAW_DEG := -32.0     # three-quarter view from her rear-hand side: the lead glove does not cover her face
const ABOVE_M := 0.04      # camera a little above her eyes
const AIM_DOWN_M := 0.05   # aim just under the eyes: her face sits in the upper middle
const POSE := ["mc_win", 0.8]   # the clip and second she is frozen at: a glove coming up after a win, her face open (the guard hid it; later the raised arm tears the vest)


func _initialize() -> void:
	root.size = Vector2i(W, H)
	root.msaa_3d = Viewport.MSAA_8X   # hair cards (S332)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT))
	var stems: Array = Faces.CM.keys()
	var poses: Array = [POSE]
	for a in OS.get_cmdline_user_args():
		if a.begins_with("stems="):
			stems = Array(a.trim_prefix("stems=").split(","))
		if a.begins_with("poses="):   # clip@seconds,... -> test shots in E:/FightCamp/tmp
			poses = []
			for q in a.trim_prefix("poses=").split(","):
				poses.append([q.get_slice("@", 0), float(q.get_slice("@", 1))])
	var n := 0
	for stem in stems:
		var other: String = "mh_boxer_10" if stem != "mh_boxer_10" else "mh_boxer_11"
		var stage: Node3D = Stage.new()
		root.add_child(stage)
		await process_frame
		stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % stem, "corner": "red"},
			{"glb": "res://assets/models/metahuman/%s.glb" % other, "corner": "blue"})
		(stage.boxers[1]["node"] as Node3D).visible = false
		for i in 20:
			await process_frame
		var cam := Camera3D.new()
		cam.fov = FOV
		stage.add_child(cam)
		for pose in poses:
			Stage.IdleMatch.freeze(stage.boxers[0], str(pose[0]), float(pose[1]))
			for i in 3:
				await process_frame
			_frame(cam, stage)
			cam.make_current()
			for i in 8:
				await process_frame
			await RenderingServer.frame_post_draw
			var img := _photo(root.get_texture().get_image())
			var path := ProjectSettings.globalize_path(OUT.path_join(stem + ".jpg"))
			if poses.size() > 1:
				path = "E:/FightCamp/tmp/headshot_%s_%s_%.1f.jpg" % [stem, pose[0], pose[1]]
			img.save_jpg(path, 0.9)
			print("HEADSHOT %s -> %s" % [stem, path])
			n += 1
		stage.queue_free()
		await process_frame
	print("HEADSHOTS baked=%d" % n)
	quit(0 if n > 0 else 1)


## The camera on her face from her front, turned YAW_DEG toward her lead side, the background far and soft.
func _frame(cam: Camera3D, stage: Node3D) -> void:
	var bx: Dictionary = stage.boxers[0]
	var skel := bx["skel"] as Skeleton3D
	var head: Vector3 = (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head"))).origin
	var other: Vector3 = (stage.boxers[1]["node"] as Node3D).global_position
	var fwd := Vector3(other.x - head.x, 0, other.z - head.z).normalized()
	var dir := fwd.rotated(Vector3.UP, deg_to_rad(YAW_DEG))
	var aim := head - Vector3(0, AIM_DOWN_M, 0)
	cam.position = head + dir * DIST_M + Vector3(0, ABOVE_M, 0)
	cam.look_at(aim, Vector3.UP)
	var attr := CameraAttributesPractical.new()
	attr.dof_blur_far_enabled = true
	attr.dof_blur_far_distance = DIST_M + 0.7
	attr.dof_blur_far_transition = 1.5
	attr.dof_blur_amount = 0.12
	cam.attributes = attr


## The window may not open at W x H: cut the middle 4:5 of what was drawn and scale it to W x H.
func _photo(img: Image) -> Image:
	var w := img.get_width()
	var h := img.get_height()
	var cw := mini(w, int(h * float(W) / H))
	var ch := mini(h, int(cw * float(H) / W))
	var out := img.get_region(Rect2i((w - cw) / 2, (h - ch) / 2, cw, ch))
	out.resize(W, H, Image.INTERPOLATE_LANCZOS)
	return out