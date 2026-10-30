extends RefCounted
## A MetaHuman boxer our clips can play (copied from the old repo's MetaHumanRig.gd, trimmed to what the 3D fight
## view uses: no DNA correctives). The GLB keeps UE5 joint names; the 22 mapped joints are renamed IN THE glTF STATE
## before the scene is generated (so skeleton and skin binds agree), the twist bones turn every frame
## (MetaHumanTwist), and the meshes are dressed: SSS skin, wet eyes, dark lashes, hair cards.
const RawAsset := preload("res://scripts/fight3d/RawAsset.gd")
const Twist := preload("res://scripts/fight3d/MetaHumanTwist.gd")
const Look := preload("res://scripts/rules/MetaHumanLook.gd")

const UE5_TO_OURS := {
	"pelvis": "Hips",
	"spine_01": "Spine",
	"spine_03": "Chest",
	"spine_05": "UpperChest",
	"neck_01": "Neck",
	"head": "Head",
	"clavicle_l": "LeftShoulder",
	"upperarm_l": "LeftUpperArm",
	"lowerarm_l": "LeftLowerArm",
	"hand_l": "LeftHand",
	"clavicle_r": "RightShoulder",
	"upperarm_r": "RightUpperArm",
	"lowerarm_r": "RightLowerArm",
	"hand_r": "RightHand",
	"thigh_l": "LeftUpperLeg",
	"calf_l": "LeftLowerLeg",
	"foot_l": "LeftFoot",
	"ball_l": "LeftToes",
	"thigh_r": "RightUpperLeg",
	"calf_r": "RightLowerLeg",
	"foot_r": "RightFoot",
	"ball_r": "RightToes",
}
## Fingers, for the glove's palm frame (CCFighterSkin.FINGER_HANDS) and FighterFist. No clip carries finger tracks
## (UE4_TO_OURS is 22 rows), so these never enter a retarget; they only name the joints.
const UE5_FINGERS := {
	"thumb_01_l": "LeftThumbMetacarpal", "thumb_02_l": "LeftThumbProximal", "thumb_03_l": "LeftThumbDistal",
	"index_01_l": "LeftIndexProximal", "index_02_l": "LeftIndexIntermediate", "index_03_l": "LeftIndexDistal",
	"middle_01_l": "LeftMiddleProximal", "middle_02_l": "LeftMiddleIntermediate", "middle_03_l": "LeftMiddleDistal",
	"ring_01_l": "LeftRingProximal", "ring_02_l": "LeftRingIntermediate", "ring_03_l": "LeftRingDistal",
	"pinky_01_l": "LeftLittleProximal", "pinky_02_l": "LeftLittleIntermediate", "pinky_03_l": "LeftLittleDistal",
	"thumb_01_r": "RightThumbMetacarpal", "thumb_02_r": "RightThumbProximal", "thumb_03_r": "RightThumbDistal",
	"index_01_r": "RightIndexProximal", "index_02_r": "RightIndexIntermediate", "index_03_r": "RightIndexDistal",
	"middle_01_r": "RightMiddleProximal", "middle_02_r": "RightMiddleIntermediate", "middle_03_r": "RightMiddleDistal",
	"ring_01_r": "RightRingProximal", "ring_02_r": "RightRingIntermediate", "ring_03_r": "RightRingDistal",
	"pinky_01_r": "RightLittleProximal", "pinky_02_r": "RightLittleIntermediate", "pinky_03_r": "RightLittleDistal",
}

const SKIN_SHADER := "res://assets/models/metahuman/mh_skin.gdshader"
const MICRO_NORMAL := "res://assets/models/metahuman/mh_skin_micro_normal.png"


static func load_fighter(glb_path: String) -> Node3D:
	var doc := GLTFDocument.new()
	var state := GLTFState.new()
	if doc.append_from_buffer(RawAsset.read(glb_path), glb_path.get_base_dir(), state) != OK:
		return null
	for node in state.get_nodes():
		var n: GLTFNode = node
		var ours: String = str(UE5_TO_OURS.get(n.resource_name, UE5_FINGERS.get(n.resource_name, "")))
		if not ours.is_empty():
			n.resource_name = ours
			n.original_name = ours
	var fighter := doc.generate_scene(state) as Node3D
	if fighter == null:
		return null
	for skel_value in fighter.find_children("*", "Skeleton3D", true, false):
		var twist := Twist.new()
		twist.name = "MetaHumanTwist"
		if twist.setup(skel_value as Skeleton3D) > 0:
			(skel_value as Skeleton3D).add_child(twist)
		else:
			twist.free()
	if fighter.find_children("*", "AnimationPlayer", true, false).is_empty():
		var ap := AnimationPlayer.new()
		ap.name = "AnimationPlayer"
		ap.add_animation_library("", AnimationLibrary.new())
		fighter.add_child(ap)
	dress(fighter, glb_path)
	return fighter


static func dress(fighter: Node, glb_path: String = "") -> void:
	var shader: Shader = load(SKIN_SHADER) as Shader
	var micro: Texture2D = _png(MICRO_NORMAL)
	## S263 LOOK A/B (Maria S262): skin preset by this body's own skin tone (mh_boxer_<n>.json "skin"), look from
	## MetaHumanLook (DEFAULT_LOOK, or look=<A..D> on a still tool's command line for the operator's A/B sheet).
	var look: String = Look.look_from(OS.get_cmdline_user_args())
	var skin_u: Dictionary = Look.skin_uniforms(look, Look.tone_luma(_skin_tone(glb_path)), Look.sweat_for(look))
	var limiter: Dictionary = Look.roughness_limiter(look)
	if not limiter.is_empty():
		RenderingServer.screen_space_roughness_limiter_set_active(true, float(limiter["amount"]), float(limiter["limit"]))
	for m in fighter.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		# S307: a skinned mesh keeps its standing bounds; seated (the head 0.4 m lower) a close-up culled her hair.
		mi.extra_cull_margin = 0.6
		for s in mi.mesh.get_surface_count():
			var src := mi.get_active_material(s) as BaseMaterial3D
			if src == null:
				continue
			var mname: String = src.resource_name
			if mname.begins_with("MH_Skin"):
				var skin := ShaderMaterial.new()
				skin.shader = shader
				skin.set_shader_parameter("albedo_tex", src.albedo_texture)
				if src.normal_enabled and src.normal_texture != null:   # mh_pilot_02: the synthesized face / body normal
					skin.set_shader_parameter("normal_tex", src.normal_texture)
				skin.set_shader_parameter("micro_normal", micro)
				for key in skin_u:
					skin.set_shader_parameter(key, skin_u[key])
				mi.set_surface_override_material(s, skin)
			elif mname.begins_with("MH_Eye") and not mname.begins_with("MH_Eyelashes"):
				var eye := src.duplicate() as StandardMaterial3D
				eye.roughness = 0.04
				eye.metallic_specular = 0.6
				eye.clearcoat_enabled = true
				eye.clearcoat = 1.0
				eye.clearcoat_roughness = 0.02
				mi.set_surface_override_material(s, eye)
			elif mname.begins_with("MH_Trunks"):
				var tr := StandardMaterial3D.new()
				tr.albedo_color = src.albedo_color
				tr.roughness = 0.38
				tr.metallic_specular = 0.6
				tr.rim_enabled = true
				tr.rim = 0.25
				mi.set_surface_override_material(s, tr)
			elif mname.begins_with("MH_Hair") or mname.begins_with("MH_Brows"):
				# groom CARDS (mh_pilot_02): coverage atlas in alpha. Alpha-to-coverage under MSAA, a hard clip without.
				var hair := StandardMaterial3D.new()
				hair.albedo_texture = src.albedo_texture
				hair.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
				hair.alpha_scissor_threshold = 0.35
				hair.alpha_antialiasing_mode = BaseMaterial3D.ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE
				hair.cull_mode = BaseMaterial3D.CULL_DISABLED
				hair.roughness = 0.55
				hair.metallic_specular = 0.35
				hair.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
				mi.set_surface_override_material(s, hair)
			elif mname.begins_with("MH_Eyelashes"):
				var lash := src.duplicate() as StandardMaterial3D
				lash.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
				lash.albedo_color = Color(0.05, 0.04, 0.03, 0.4)
				lash.cull_mode = BaseMaterial3D.CULL_DISABLED
				## S269 (operator crop: white lashes on a dark face): stacked two-sided cards at default specular 0.5
				## summed the ring lights' sheen into a grey-white fringe. Lashes are matte hair: no specular.
				lash.metallic_specular = 0.0
				lash.roughness = 1.0
				mi.set_surface_override_material(s, lash)


## The body's skin colour from its sidecar mh_boxer_<n>.json ("skin": "#rrggbb"); mid-brown when unknown.
static func _skin_tone(glb_path: String) -> Color:
	var fallback := Color("#a8704a")
	if glb_path.is_empty():
		return fallback
	var json_path: String = glb_path.get_basename() + ".json"
	if not FileAccess.file_exists(json_path):
		return fallback
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(json_path))
	if data is Dictionary and str((data as Dictionary).get("skin", "")).begins_with("#"):
		return Color(str((data as Dictionary)["skin"]))
	return fallback


static func _png(res_path: String) -> Texture2D:
	var img := Image.new()
	if img.load_png_from_buffer(RawAsset.read(res_path)) != OK:
		return null
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## `roughness` >= 0 also makes them matte (S299: satin 0.38 under the ring lights read the maroon trunks as bright red).
static func colour_trunks(fighter: Node, colour: Color, roughness: float = -1.0) -> void:
	for m in fighter.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		# S307: a skinned mesh keeps its standing bounds; seated (the head 0.4 m lower) a close-up culled her hair.
		mi.extra_cull_margin = 0.6
		for s in mi.mesh.get_surface_count():
			var source := mi.mesh.surface_get_material(s)
			if source != null and source.resource_name.begins_with("MH_Trunks"):
				var material := mi.get_active_material(s).duplicate() as StandardMaterial3D
				material.albedo_color = colour
				if roughness >= 0.0:
					material.roughness = roughness
					material.metallic_specular = 0.4
					material.rim_enabled = false
				mi.set_surface_override_material(s, material)


static func height_of(fighter: Node3D) -> Vector2:
	var lo: float = INF
	var hi: float = -INF
	for m in fighter.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var to_fighter := Transform3D.IDENTITY
		var node: Node = mi
		while node != fighter and node != null:
			if node is Node3D:
				to_fighter = (node as Node3D).transform * to_fighter
			node = node.get_parent()
		for surface in mi.mesh.get_surface_count():
			var material: Material = mi.mesh.surface_get_material(surface)
			if material == null or not material.resource_name.begins_with("MH_Skin"):
				continue
			var vertices: PackedVector3Array = mi.mesh.surface_get_arrays(surface)[Mesh.ARRAY_VERTEX]
			for vertex in vertices:
				var y: float = (to_fighter * vertex).y
				lo = minf(lo, y)
				hi = maxf(hi, y)
	return Vector2(lo, hi)


