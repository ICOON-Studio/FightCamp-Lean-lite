extends SceneTree
## S321 preview (operator: "make some previews" of a movie-like muscle/skeleton figure): one boxer's OWN MetaHuman body
## rendered as a TV x-ray - glass skin (fresnel rim), a white skeleton along her real bones and a rib cage at her chest.
## A look test only; nothing in the game reads it.
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 720x1200 \
##       --script res://tools/preview_xray_figure.gd
## Writes E:/FightCamp/gen/s321_anatomy/xray_<stem>.png

const MH := preload("res://scripts/fight3d/MHRig.gd")

const W := 720
const H := 1200
const OUT := "E:/FightCamp/gen/s321_anatomy"
const BODIES := ["mh_boxer_10", "mh_boxer_11"]
const SKELETON := false   # S321: the stick bones + ring ribs read as a toy next to the glass body
const BONES := [["Hips", "Spine"], ["Spine", "Chest"], ["Chest", "UpperChest"], ["UpperChest", "Neck"], ["Neck", "Head"],
	["UpperChest", "LeftShoulder"], ["LeftShoulder", "LeftUpperArm"], ["LeftUpperArm", "LeftLowerArm"], ["LeftLowerArm", "LeftHand"],
	["UpperChest", "RightShoulder"], ["RightShoulder", "RightUpperArm"], ["RightUpperArm", "RightLowerArm"], ["RightLowerArm", "RightHand"],
	["Hips", "LeftUpperLeg"], ["LeftUpperLeg", "LeftLowerLeg"], ["LeftLowerLeg", "LeftFoot"], ["LeftFoot", "LeftToes"],
	["Hips", "RightUpperLeg"], ["RightUpperLeg", "RightLowerLeg"], ["RightLowerLeg", "RightFoot"], ["RightFoot", "RightToes"]]

const GLASS := "shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_back;
uniform vec3 rim = vec3(0.25, 0.72, 1.0);
void fragment() {
	float f = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 2.4);
	ALBEDO = rim * (0.07 + 1.5 * f);
}"


func _initialize() -> void:
	root.size = Vector2i(W, H)
	DirAccess.make_dir_recursive_absolute(OUT)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.02, 0.04, 0.09)
	env.environment.glow_enabled = true
	env.environment.glow_intensity = 0.9
	env.environment.glow_bloom = 0.15
	root.add_child(env)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	root.add_child(cam)
	var glass := ShaderMaterial.new()
	glass.shader = Shader.new()
	glass.shader.code = GLASS
	var bone_mat := StandardMaterial3D.new()
	bone_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	bone_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bone_mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	bone_mat.albedo_color = Color(0.85, 0.93, 1.0, 0.55)
	await process_frame
	for stem in BODIES:
		var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % stem)
		root.add_child(body)
		for m in body.find_children("*", "MeshInstance3D", true, false):
			var mi := m as MeshInstance3D
			var n := (mi.name + str(mi.mesh.surface_get_material(0).resource_name if mi.mesh.surface_get_material(0) else "")).to_lower()
			# Hair, brows and lashes are stacked cards: added up they burn white, so they stay out of the x-ray.
			mi.visible = not (n.contains("hair") or n.contains("brow") or n.contains("lash") or n.contains("fuzz"))
			mi.material_override = glass
		await process_frame
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var pos := func(b: String) -> Vector3:
			return (skel.global_transform * skel.get_bone_global_pose(skel.find_bone(b))).origin
		for pair in (BONES if SKELETON else []):
			if skel.find_bone(pair[0]) < 0 or skel.find_bone(pair[1]) < 0:
				continue
			_bone(root, pos.call(pair[0]), pos.call(pair[1]), bone_mat, 0.014)
		# Rib cage: tori from the chest up, wider in the middle (her real chest bones give the heights).
		var c: Vector3 = pos.call("Chest")
		var u: Vector3 = pos.call("UpperChest")
		for i in (7 if SKELETON else 0):
			var t := float(i) / 6.0
			var ring := MeshInstance3D.new()
			var tm := TorusMesh.new()
			tm.inner_radius = 0.96
			tm.outer_radius = 1.0
			ring.mesh = tm
			ring.material_override = bone_mat
			var w := lerpf(0.105, 0.125, sin(t * PI)) * (1.0 - 0.25 * t * t)
			ring.scale = Vector3(w, 0.4, w * 0.75)
			ring.position = Vector3(c.x, lerpf(c.y - 0.06, u.y + 0.06, t), lerpf(c.z, u.z, t))
			ring.rotation.x = deg_to_rad(-12.0)
			root.add_child(ring)
		var head: Vector3 = pos.call("Head")
		var lo: float = pos.call("LeftToes").y - 0.05
		var hi: float = head.y + 0.2
		cam.size = (hi - lo) * 1.04
		var fwd := 1.0 if (pos.call("LeftToes") as Vector3).z > (pos.call("LeftFoot") as Vector3).z else -1.0
		cam.position = Vector3(0, (lo + hi) * 0.5, 6.0 * fwd)
		cam.look_at(Vector3(0, (lo + hi) * 0.5, 0), Vector3.UP)
		for i in 10:
			await process_frame
		await RenderingServer.frame_post_draw
		var img := root.get_texture().get_image()
		img.save_png(OUT.path_join("xray_%s.png" % stem))
		print("XRAY %s %dx%d" % [stem, img.get_width(), img.get_height()])
		for ch in root.get_children():
			if ch != env and ch != cam:
				ch.queue_free()
		await process_frame
	quit(0)


func _bone(parent: Node, a: Vector3, b: Vector3, mat: Material, r: float) -> void:
	var len := a.distance_to(b)
	if len < 0.01:
		return
	var mi := MeshInstance3D.new()
	var cap := CapsuleMesh.new()
	cap.radius = r
	cap.height = len + r * 2.0
	mi.mesh = cap
	mi.material_override = mat
	parent.add_child(mi)
	var y := (b - a).normalized()
	var x := y.cross(Vector3.FORWARD if absf(y.dot(Vector3.FORWARD)) < 0.9 else Vector3.RIGHT).normalized()
	mi.global_transform = Transform3D(Basis(x, y, x.cross(y) * -1.0).orthonormalized(), (a + b) * 0.5)
