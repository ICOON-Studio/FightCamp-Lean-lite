extends SceneTree
## BODYLOOK1 (S492) workbench: one MetaHuman body in rest pose, close on the neck and shoulders from four sides, for
## quick looks while a mesh fix is tuned (the proof stills come from the game's own cameras: corner_film / fight3d_play).
##   python tools/hidden_desktop.py run --timeout=120 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --script res://tools/bodylook_still.gd -- <out_dir> mh_staff_coach [nobodylook]
const MH := preload("res://scripts/fight3d/MHRig.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const CornerIK := preload("res://scripts/fight3d/CornerIK.gd")

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out_dir: String = args[0]
	var name: String = args[1]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1280, 720)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.16, 0.17, 0.2)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.57, 0.6)
	env.environment.ambient_light_energy = 0.7
	root.add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-38, 35, 0)
	sun.shadow_enabled = true
	root.add_child(sun)
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % name)
	root.add_child(body)
	if name.begins_with("mh_boxer"):
		MH.colour_trunks(body, Color(0.5, 0.05, 0.05), 0.6)
		FighterKit.colour_vest(body, Color(0.85, 0.12, 0.1), 0.6)
		FighterKit.cloth_normals(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var neck: Vector3 = skel.get_bone_global_rest(skel.find_bone("Neck")).origin
	var lean := 0.0   # `lean=<deg>`: the head leans forward that far (half on the neck, half on the head), as in the corner
	for a in args:
		if str(a).begins_with("lean="):
			lean = float(str(a).substr(5))
	if lean != 0.0:
		for b in ["Neck", "Head"]:
			var id := skel.find_bone(b)
			skel.set_bone_pose_rotation(id, skel.get_bone_pose_rotation(id) * Quaternion(Vector3.RIGHT, deg_to_rad(lean * 0.5)))
		print("BODYLOOK_STILL lean %.0f deg on Neck + Head" % lean)
	# `clip=<name>`: the body held in the middle of that clip (the coach's close-up is af_crouch_idle), the lens round the
	# neck where the clip puts it.
	var clip := ""
	for a in args:
		if str(a).begins_with("clip="):
			clip = str(a).substr(5)
	if clip != "":
		var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		FightClips.load_into(ap, skel, true)
		ap.play(clip)
		ap.seek(ap.get_animation(clip).length * 0.5, true)
		ap.pause()
		for i in 3:
			await process_frame
		neck = skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Neck")).origin
		# `look`: the corner's own aim (CornerIK.look, as CornerMinute.cue_face): he looks at a face 1.1 m in front of him
		# at a sitting boxer's height - out of the crouch that bends his neck back.
		if args.has("look"):
			var ik: Node = CornerIK.attach(skel, body)
			var at := body.global_position + body.global_transform.basis.z * 1.1 + Vector3(0, 1.15, 0)
			ik.look(func(): return at)
			for i in 60:
				await process_frame
	var cam := Camera3D.new()
	cam.fov = 30.0
	root.add_child(cam)
	cam.current = true
	await process_frame   # the lens is in the tree before it is aimed
	var tag := ("exported" if args.has("nobodylook") else "fixed") + ("_lean" if lean != 0.0 else "") + (("_" + clip) if clip != "" else "") + ("_look" if args.has("look") else "")
	for view in [["front", Vector3(0.35, 0.05, 1.0)], ["side", Vector3(1.0, 0.05, 0.25)], ["back", Vector3(-0.4, 0.15, -1.0)], ["top", Vector3(0.3, 0.9, 0.7)]]:
		cam.position = neck + (view[1] as Vector3).normalized() * 0.95 + Vector3(0, -0.02, 0)
		cam.look_at(neck + Vector3(0, -0.04, 0), Vector3.UP)
		for i in 6:
			await process_frame
		await RenderingServer.frame_post_draw
		var path := out_dir.path_join("%s_%s_%s.png" % [name, tag, view[0]])
		root.get_texture().get_image().save_png(path)
		print("BODYLOOK_STILL wrote ", path)
	quit()
