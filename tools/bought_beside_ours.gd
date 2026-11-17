extends SceneTree
## S512 BASELINE (owner S510: "animations looked fine when we bought them, everything got fucked after that so it has to be
## coding mistakes or pipeline"): does retargeting alone already damage a bought clip? Each clip twice in one picture, the
## same clip time in both, one fixed side camera, a grid floor (it shows travel and foot slide):
##   RIGHT the bought file itself (MoCap Online Punch Pro .fbx, loaded here at run time) on its own skeleton and character;
##   LEFT  the same clip as the game loads it (FightClips: baked onto the MetaHuman boxer, hips pinned in place), every
##         fight layer switched off (clip_orbit's strip_modifiers; only the skin's twist helpers run).
## Frames -> <out>/<clip>/f0000.jpg, and one line a clip with both lengths and how far each one's hips and hands travel.
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/bought_beside_ours.gd -- out=<dir> fbx=<folder with the .fbx> clips=Left_Jab,Right_Cross [turn=180]
## Nothing of the pack is copied into the project: the .fbx are read from where they lie (E:/FightCamp/packs, outside the repo).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const FPS := 30
const APART_M := 1.7

var out_dir := "user://retarget_compare"


func _initialize() -> void:
	var fbx_dir := ""
	var clips: Array = []
	var turn := 0.0
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("out="):
			out_dir = s.substr(4)
		elif s.begins_with("fbx="):
			fbx_dir = s.substr(4)
		elif s.begins_with("clips="):
			clips = Array(s.substr(6).split(",", false))
		elif s.begins_with("turn="):
			turn = deg_to_rad(float(s.substr(5)))
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	for n in stage.get_children():
		if n is Node3D and n != stage.boxers[0]["node"] and n != stage.camera:
			(n as Node3D).visible = false
	_studio(stage)
	var bx: Dictionary = stage.boxers[0]
	var body: Node3D = bx["node"]
	var skel: Skeleton3D = bx["skel"]
	print("COMPARE layers off on our boxer: ", ",".join(Orbit.strip_modifiers(skel)))
	var ap: AnimationPlayer = bx["ap"]
	var cam: Camera3D = stage.camera
	cam.set_process(false)
	cam.fov = 40.0
	var fwd: Vector3 = body.global_transform.basis.z.normalized()
	var face: float = body.global_rotation.y
	var label := _labels()
	var done := 0
	for c in clips:
		var stem := str(c)
		var ours := "pro_" + stem.to_lower()
		var path := fbx_dir.path_join("Box1_M3_%s.fbx" % stem)
		if not ap.has_animation(ours) or not FileAccess.file_exists(path):
			print("COMPARE MISSING ", ours, " / ", path)
			continue
		var doc := FBXDocument.new()
		var st := FBXState.new()
		if doc.append_from_file(path, st) != OK:
			print("COMPARE cannot read ", path)
			continue
		var orig := doc.generate_scene(st, 30.0) as Node3D
		root.add_child(orig)
		var oap := orig.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		var oskel := orig.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var oname := ""
		for n in oap.get_animation_list():
			if str(n) != "RESET":
				oname = str(n)
		var olen := oap.get_animation(oname).length
		var len_ours := ap.get_animation(ours).length
		oap.play(oname)
		oap.seek(0.0, true)
		oap.pause()
		await process_frame
		# the bought character at our boxer's size and facing, APART_M behind him on his own line
		var ohips := _bone(oskel, ["Hips", "hips", "pelvis", "Pelvis"])
		var oh0: Vector3 = oskel.global_transform * oskel.get_bone_global_pose(ohips).origin
		var h0: Vector3 = skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips")).origin
		var k := h0.y / maxf(oh0.y, 0.001)
		orig.scale = Vector3.ONE * k
		orig.rotation.y = face + turn
		orig.position = Vector3.ZERO
		await process_frame
		oh0 = oskel.global_transform * oskel.get_bone_global_pose(ohips).origin
		orig.position = Vector3(h0.x - oh0.x, 0.0, h0.z - oh0.z) - fwd * APART_M
		var dir := out_dir.path_join(ours)
		DirAccess.make_dir_recursive_absolute(dir)
		var total := maxf(olen, len_ours) + 0.3
		var mid := body.global_position - fwd * APART_M * 0.5
		mid.y = 0.95
		var ang := face + PI * 0.5
		cam.look_at_from_position(Vector3(mid.x + sin(ang) * 4.6, 1.25, mid.z + cos(ang) * 4.6), mid, Vector3.UP)
		var tr := {"o_hips": 0.0, "u_hips": 0.0, "o_hand": 0.0, "u_hand": 0.0}
		var first := {}
		var ohand := _bone(oskel, ["LeftHand", "lefthand", "hand_l", "L_Hand"] if stem.contains("Left") else ["RightHand", "righthand", "hand_r", "R_Hand"])
		var uhand := skel.find_bone("LeftHand" if stem.contains("Left") else "RightHand")
		for f in int(ceil(total * FPS)):
			var t := float(f) / FPS
			oap.seek(minf(t, olen), true)
			Stage.IdleMatch.freeze(bx, ours, minf(t, len_ours))
			label.text = "%s   %.2f s   frame %d\nLEFT: the same clip on our boxer, no fight layers (%.2f s)        RIGHT: the bought file on its own character (%.2f s)" % [stem, t, f, len_ours, olen]
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_jpg(dir.path_join("f%04d.jpg" % f), 0.9)
			var now := {"o_hips": oskel.global_transform * oskel.get_bone_global_pose(ohips).origin,
				"u_hips": skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips")).origin,
				"o_hand": oskel.global_transform * oskel.get_bone_global_pose(ohand).origin if ohand >= 0 else Vector3.ZERO,
				"u_hand": skel.global_transform * skel.get_bone_global_pose(uhand).origin}
			if first.is_empty():
				first = now
			for key in tr:
				tr[key] = maxf(float(tr[key]), ((now[key] as Vector3) - (first[key] as Vector3)).length())
		print("COMPARE %s bought %.2f s, ours %.2f s | size x%.3f | furthest from the start, bought / ours (m): hips %.2f / %.2f, punching hand %.2f / %.2f | bones %d / %d" % [
			stem, olen, len_ours, k, float(tr["o_hips"]), float(tr["u_hips"]), float(tr["o_hand"]), float(tr["u_hand"]), oskel.get_bone_count(), skel.get_bone_count()])
		orig.queue_free()
		await process_frame
		done += 1
	print("COMPARE DONE %d/%d" % [done, clips.size()])
	quit(0 if done > 0 else 1)


static func _bone(skel: Skeleton3D, names: Array) -> int:
	for n in names:
		if skel.find_bone(str(n)) >= 0:
			return skel.find_bone(str(n))
	for i in skel.get_bone_count():   # a prefixed name (mixamorig:Hips, Bip01 Pelvis)
		for n in names:
			if skel.get_bone_name(i).to_lower().ends_with(str(n).to_lower()):
				return i
	return -1


func _labels() -> Label:
	var layer := CanvasLayer.new()
	root.add_child(layer)
	var l := Label.new()
	l.position = Vector2(40, 24)
	l.add_theme_font_size_override("font_size", 30)
	l.add_theme_color_override("font_color", Color(1, 1, 1))
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	l.add_theme_constant_override("outline_size", 8)
	layer.add_child(l)
	return l


## A studio: grey grid floor, plain backdrop, two lights.
func _studio(stage: Node3D) -> void:
	var floor := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(40, 40)
	floor.mesh = pm
	var sh := Shader.new()
	sh.code = Orbit.GRID_SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	floor.material_override = mat
	stage.add_child(floor)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.62, 0.64, 0.67)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(1, 1, 1)
	env.environment.ambient_light_energy = 0.55
	stage.add_child(env)
	for spec in [[Vector3(-50, -40, 0), 1.3], [Vector3(-30, 140, 0), 0.5]]:
		var sun := DirectionalLight3D.new()
		sun.rotation_degrees = spec[0]
		sun.light_energy = spec[1]
		stage.add_child(sun)
