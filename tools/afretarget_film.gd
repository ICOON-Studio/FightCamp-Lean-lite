extends SceneTree
## AFRETARGET1 (S537): the same take on the same body, pane by pane, one fixed camera - ActionForge's retarget beside
## our bakes. Each pane is the CLIP ALONE on mh_boxer_01 (no player, no pose layer; the skin's twist joints stay on).
## Every pane is turned to the same facing and stood on the same floor (its lowest toe joint of the take), so only the
## pose differs. Windowed, on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080
##     --script res://tools/afretarget_film.gd -- out=<dir> panes=AF,<a.res>,<b.res> labels=A|B|C [view=side|front|back]
##     [zoom=legs|body] [glb=mh_boxer_01] [name=cross]
## Writes <name>_<view>_<nnn>.jpg per picture of the take (30 a second) and <name>_<view>_contact.png (at= seconds).
const MH := preload("res://scripts/fight3d/MHRig.gd")
const AF := preload("res://tools/afretarget_lib.gd")

func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var out := _arg("out", "user://afretarget")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out))
	var view := _arg("view", "side")
	var zoom := _arg("zoom", "body")
	var GAP := 0.76 if zoom == "legs" else 1.45   # all the panes inside the picture
	var panes := _arg("panes", "AF").split(",", false)
	var labels := _arg("labels", "").split("|", false)
	var world := Node3D.new()
	root.add_child(world)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.78, 0.80, 0.83)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(1, 1, 1)
	env.environment.ambient_light_energy = 0.55
	world.add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, 35 if view != "side" else 115, 0)
	sun.light_energy = 1.1
	world.add_child(sun)
	var floor_mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(12, 12)
	floor_mesh.mesh = plane
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.55, 0.57, 0.60)
	floor_mesh.material_override = mat
	world.add_child(floor_mesh)
	# the panes run along the camera's horizontal: Z for the side camera, X for the front / back one
	var along := Vector3(0, 0, 1) if view == "side" else Vector3(1, 0, 0)
	var bodies: Array = []
	var length := 0.0
	for i in panes.size():
		var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % _arg("glb", "mh_boxer_01"))
		world.add_child(body)
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var is_af := str(panes[i]) == "AF"
		var anim: Animation = AF.af_anim() if is_af else load(str(panes[i])) as Animation
		var tr := AF.tracks(anim)
		length = anim.length if length == 0.0 else minf(length, anim.length)
		bodies.append({"node": body, "skel": skel, "anim": anim, "tr": tr, "af": is_af})
	var hb: int = (bodies[0]["skel"] as Skeleton3D).find_bone("Hips")
	var rest_h := (bodies[0]["skel"] as Skeleton3D).get_bone_global_rest(hb).basis
	var frames := int(round(length * 30.0))
	# every pane: its mean facing over the take turned to +Z, its hips' mean place over the pane's mark, its lowest toe
	# joint of the take on the floor at the toe joint's rest height
	for i in bodies.size():
		var d: Dictionary = bodies[i]
		var skel: Skeleton3D = d["skel"]
		var fwd := Vector3.ZERO
		var mean := Vector3.ZERO
		var low := 1e9
		for fi in frames + 1:
			var g := AF.pose(skel, d["anim"], d["tr"], fi / 30.0, not d["af"])
			if d["af"]:
				g = _af_scaled(skel, d, fi / 30.0)
			fwd += ((g[hb] as Transform3D).basis * rest_h.inverse()) * Vector3(0, 0, 1)
			mean += (g[hb] as Transform3D).origin
			for toe in ["LeftToes", "RightToes"]:
				low = minf(low, (g[skel.find_bone(toe)] as Transform3D).origin.y)
		mean /= float(frames + 1)
		var rest_toe := skel.get_bone_global_rest(skel.find_bone("LeftToes")).origin.y
		var yaw := -atan2(fwd.x, fwd.z)
		var node: Node3D = d["node"]
		node.basis = Basis(Vector3.UP, yaw)
		var at := along * (float(i) - float(bodies.size() - 1) * 0.5) * GAP
		var flat := node.basis * Vector3(mean.x, 0, mean.z)
		node.position = at - flat + Vector3(0, rest_toe - low, 0)
		print("AFFILM pane %d %s: turned %.0f deg, lifted %.1f cm" % [i, str(panes[i]).get_file(), rad_to_deg(yaw), (rest_toe - low) * 100.0])
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 1.25 if zoom == "legs" else 2.6
	var look_y := 0.52 if zoom == "legs" else 0.95
	var from := Vector3(6, look_y, 0) if view == "side" else (Vector3(0, look_y, 6) if view == "front" else Vector3(0, look_y, -6))
	world.add_child(cam)
	cam.look_at_from_position(from, Vector3(0, look_y, 0), Vector3.UP)
	cam.current = true
	var layer := CanvasLayer.new()
	root.add_child(layer)
	var clock := Label.new()
	clock.add_theme_font_size_override("font_size", 26)
	clock.add_theme_color_override("font_color", Color(0.05, 0.05, 0.08))
	clock.position = Vector2(20, 1030)
	layer.add_child(clock)
	var name := _arg("name", "cross")
	var contact := float(_arg("at", "0.30"))
	for f in 8:
		await process_frame
	for i in bodies.size():
		var lab := Label.new()
		lab.text = str(labels[i]) if i < labels.size() else str(panes[i]).get_file()
		lab.add_theme_font_size_override("font_size", 30)
		lab.add_theme_color_override("font_color", Color(0.05, 0.05, 0.08))
		layer.add_child(lab)
		var p := cam.unproject_position(((bodies[i]["node"] as Node3D).position * Vector3(1, 0, 1)) + Vector3(0, look_y + cam.size * 0.46, 0))
		lab.position = Vector2(p.x - 260, 14)
		lab.custom_minimum_size = Vector2(520, 0)
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	for fi in frames + 1:
		var t := fi / 30.0
		for d in bodies:
			_apply(d, t)
		clock.text = "%.2f s%s    %s camera" % [t, "  CONTACT" if absf(t - contact) < 0.017 else "", view]
		await process_frame
		await process_frame
		await RenderingServer.frame_post_draw
		var img := root.get_texture().get_image()
		img.save_jpg(out.path_join("%s_%s_%s_%03d.jpg" % [name, view, zoom, fi]), 0.92)
		if absf(t - contact) < 0.017:
			img.save_png(out.path_join("%s_%s_%s_contact.png" % [name, view, zoom]))
	print("AFFILM done %d pictures -> %s" % [frames + 1, out])
	quit(0)


## ActionForge's body is the same body at another size: its hips key is a place on ITS size - brought to ours.
func _af_scaled(skel: Skeleton3D, d: Dictionary, t: float) -> Array:
	var anim: Animation = d["anim"]
	var hb := skel.find_bone("Hips")
	var k := skel.get_bone_rest(hb).origin.y / (anim.position_track_interpolate(int(d["tr"]["pos"]["Hips"]), 0.0) as Vector3).y
	var g := AF.pose(skel, anim, d["tr"], t, false)
	var want: Vector3 = (g[hb] as Transform3D).origin * k
	var shift: Vector3 = want - (g[hb] as Transform3D).origin
	for i in g.size():
		g[i] = Transform3D((g[i] as Transform3D).basis, (g[i] as Transform3D).origin + shift)
	return g


func _apply(d: Dictionary, t: float) -> void:
	var skel: Skeleton3D = d["skel"]
	var anim: Animation = d["anim"]
	var tr: Dictionary = d["tr"]
	for nm in tr["rot"]:
		var b := skel.find_bone(str(nm))
		if b >= 0:
			skel.set_bone_pose_rotation(b, anim.rotation_track_interpolate(int(tr["rot"][nm]), t))
	var hb := skel.find_bone("Hips")
	if (tr["pos"] as Dictionary).has("Hips"):
		var v: Vector3 = anim.position_track_interpolate(int(tr["pos"]["Hips"]), t)
		if d["af"]:
			v *= skel.get_bone_rest(hb).origin.y / (anim.position_track_interpolate(int(tr["pos"]["Hips"]), 0.0) as Vector3).y
		else:
			v += skel.get_bone_rest(hb).origin
		skel.set_bone_pose_position(hb, v)
