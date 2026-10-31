extends SceneTree
## S321 preview (operator: "make it in a pc game sense, something that can be a core mechanic ... see the body as the track
## on MSM"): one still of a boxer's own glass body with every part outlined and coloured by how worked it is (blue fresh,
## green, yellow, red burning - read like tyre temperatures) and a red outline where she is hurt. A look test only.
##   python tools/hidden_desktop.py run --timeout=200 <godot.exe> --path . --windowed --script res://tools/preview_body_track.gd \
##       -- stem=mh_boxer_10 out=E:/FightCamp/gen/s321_anatomy/track_a.png states=<json {part: heat}> hurt=ribs_L,head
## Parts: head, deltoid_R/L, biceps_R/L, forearm_R/L, pec_R/L, ribs_R/L, abs, quad_R/L (R/L = HER right/left).

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Flow := preload("res://tools/preview_muscle_flow.gd")

var _args := {}


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := a.split("=", true, 1)
		if kv.size() == 2:
			_args[kv[0]] = kv[1]
	var states: Dictionary = JSON.parse_string(str(_args.get("states", "{}")))
	var hurt: PackedStringArray = str(_args.get("hurt", "")).split(",", false)
	root.size = Vector2i(1280, 1280)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.015, 0.03, 0.07)
	env.environment.glow_enabled = true
	env.environment.glow_intensity = 0.8
	env.environment.glow_bloom = 0.12
	root.add_child(env)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	root.add_child(cam)
	var glass := ShaderMaterial.new()
	glass.shader = Shader.new()
	glass.shader.code = Flow.GLASS
	var flow := Shader.new()
	flow.code = Flow.FLOW.replace("uniform float seed = 0.0;", "uniform float seed = 0.0;\nuniform float taper = 0.45;\nuniform float hurt = 0.0;") \
		.replace("VERTEX.xz *= 1.0 - 0.45 *", "VERTEX.xz *= 1.0 - taper *") \
		.replace("float line = smoothstep(0.80, 0.93,", "float line = smoothstep(0.80 - 0.3 * hurt, 0.93 - 0.2 * hurt,") \
		.replace("ALBEDO = col * k + mix(col, vec3(1.0), 0.35) * line * 1.1;",
			"vec3 lc = mix(mix(col, vec3(1.0), 0.35), vec3(1.0, 0.1, 0.05), hurt);\n\tALBEDO = col * k + lc * line * (1.1 + 1.4 * hurt);")
	await process_frame
	var stem := str(_args.get("stem", "mh_boxer_10"))
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % stem)
	root.add_child(body)
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var mat0: Material = mi.mesh.surface_get_material(0)
		var n := (mi.name + (mat0.resource_name if mat0 != null else "")).to_lower()
		mi.visible = not (n.contains("hair") or n.contains("brow") or n.contains("lash") or n.contains("fuzz")
			or n.contains("teeth") or n.contains("tongue") or n.contains("mouth"))
		mi.material_override = glass
	await process_frame
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var pos := func(b: String) -> Vector3:
		return (skel.global_transform * skel.get_bone_global_pose(skel.find_bone(b))).origin
	var fwd := 1.0 if (pos.call("LeftToes") as Vector3).z > (pos.call("LeftFoot") as Vector3).z else -1.0
	var front := Vector3(0, 0, fwd)
	var head: Vector3 = pos.call("Head")
	var hp: Vector3 = pos.call("Hips")
	var place := func(part: String, a: Vector3, b: Vector3, r: float, taper := 0.45) -> void:
		var mat := ShaderMaterial.new()
		mat.shader = flow
		mat.set_shader_parameter("heat", float(states.get(part, 0.15)))
		mat.set_shader_parameter("t", 0.7)
		mat.set_shader_parameter("seed", float(part.hash() % 97))
		mat.set_shader_parameter("taper", taper)
		mat.set_shader_parameter("hurt", 1.0 if hurt.has(part) else 0.0)
		_ellipsoid(root, a, b, r, mat)
	place.call("head", head + Vector3(0, -0.07, 0.0), head + Vector3(0, 0.15, 0.0), 0.082, 0.1)
	for side in ["Right", "Left"]:
		var k: String = "_R" if side == "Right" else "_L"
		var sh: Vector3 = pos.call(side + "UpperArm")
		var el: Vector3 = pos.call(side + "LowerArm")
		var wr: Vector3 = pos.call(side + "Hand")
		var hip: Vector3 = pos.call(side + "UpperLeg")
		var kn: Vector3 = pos.call(side + "LowerLeg")
		var sx := signf(sh.x)
		var out := Vector3(sx, 0, 0)
		place.call("deltoid" + k, sh + out * 0.012 + Vector3(0, 0.005, 0), sh.lerp(el, 0.42) + out * 0.018, 0.052)
		place.call("biceps" + k, sh.lerp(el, 0.18) + front * 0.022, el + front * 0.018 - (el - sh).normalized() * 0.03, 0.034)
		place.call("forearm" + k, el.lerp(wr, 0.06) + front * 0.012, el.lerp(wr, 0.72), 0.03)
		place.call("pec" + k, Vector3(sx * 0.025, sh.y - 0.095, sh.z), Vector3(sx * 0.15, sh.y - 0.035, sh.z), 0.05)
		place.call("ribs" + k, Vector3(sx * 0.112, sh.y - 0.15, sh.z), Vector3(sx * 0.1, hp.y + 0.1, sh.z), 0.032)
		place.call("quad" + k, hip + Vector3(sx * 0.01, -0.03, 0), kn + Vector3(0, 0.06, 0), 0.062)
	var shy: float = (pos.call("RightUpperArm") as Vector3).y
	place.call("abs", Vector3(0, shy - 0.17, 0), Vector3(0, hp.y + 0.03, 0), 0.04, 0.25)
	# Head to just under the knees.
	var lo: float = (pos.call("LeftLowerLeg") as Vector3).y - 0.08
	var hi := head.y + 0.28
	cam.size = (hi - lo) * 1.02
	cam.position = Vector3(0, (lo + hi) * 0.5, 6.0 * fwd)
	cam.look_at(Vector3(0, (lo + hi) * 0.5, 0), Vector3.UP)
	for i in 8:
		await process_frame
	await RenderingServer.frame_post_draw
	var out_path := str(_args.get("out", "E:/FightCamp/gen/s321_anatomy/track.png"))
	root.get_texture().get_image().save_png(out_path)
	print("TRACK %s -> %s" % [stem, out_path])
	quit(0)


func _ellipsoid(parent: Node, a: Vector3, b: Vector3, r: float, mat: Material) -> void:
	var mi := MeshInstance3D.new()
	var sp := SphereMesh.new()
	sp.radius = 0.5
	sp.height = 1.0
	sp.radial_segments = 48
	sp.rings = 32
	mi.mesh = sp
	mi.material_override = mat
	parent.add_child(mi)
	var y := b - a
	var len := y.length()
	y = y / len
	var x := y.cross(Vector3.FORWARD if absf(y.dot(Vector3.FORWARD)) < 0.9 else Vector3.RIGHT).normalized()
	var z := x.cross(y)
	mi.global_transform = Transform3D(Basis(x * r * 2.0, y * len, z * r * 1.0), (a + b) * 0.5)
