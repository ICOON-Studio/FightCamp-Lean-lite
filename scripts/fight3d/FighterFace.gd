extends RefCounted
## FIGHTERLOOK1: puts one fighter's look (rules/FighterLook.gd) on her MetaHuman body after MHRig.dress and the kit: her
## skin shade and its shine (the glare cut to real skin's), her hair colour, her club's trim, her boots, scar marks from her
## record, and eyes that can look and blink (assets/shaders/mh_eye.gdshader - the bodies have no eye joints). Bodies stay
## MetaHuman; nothing is generated. `-- nolook` on the command line skips all of it (the control arm: the body as on main).
##   apply(body, skel, look, glb) -> {"eyes": [ShaderMaterial]}    crew(crew_node, stage) - the corner team's eyes and skin

const EYE_SHADER := "res://assets/shaders/mh_eye.gdshader"
const SKIN_SHADER := "res://assets/models/metahuman/mh_skin.gdshader"
## Where each scar sits on the face, in the body's rest space (metres; the face looks down +Z, eyes at y 1.587, x +-0.0305).
## Measured from mh_boxer_11's eye surface; each body's own head is close enough at this size (a 2-3 cm mark).
const SCAR_AT := {
	"brow_l": [Vector3(0.036, 1.612, 0.105), -0.35, Vector2(0.026, 0.0045)],
	"brow_r": [Vector3(-0.036, 1.612, 0.105), 0.35, Vector2(0.026, 0.0045)],
	"cheek_l": [Vector3(0.052, 1.556, 0.092), 0.9, Vector2(0.022, 0.004)],
	"cheek_r": [Vector3(-0.052, 1.556, 0.092), -0.9, Vector2(0.022, 0.004)],
	"nose": [Vector3(0.0, 1.578, 0.118), 1.45, Vector2(0.014, 0.004)],
}

static var _scar_tex: Texture2D = null


## The corner team (CornerCrew.actors): each one's skin shine and eyes, and a crew-mode life layer (eyes, blinks, breath,
## the head turn to the boxer) placed before their CornerIK so the hands still reach the props.
static func crew(c: Node, stage: Node) -> void:
	if off() or c == null or not ("actors" in c):
		return
	var consts: Dictionary = (c.get_script() as Script).get_script_constant_map() if c.get_script() != null else {}
	var bodies: Dictionary = consts.get("BODIES", {})
	for role in (c.get("actors") as Dictionary):
		var a: Dictionary = c.get("actors")[role]
		var skel: Skeleton3D = a.get("skel")
		var body: Node3D = a.get("node")
		if skel == null or body == null:
			continue
		var glb := "res://assets/models/metahuman/%s.glb" % str(bodies.get(role, ""))
		var look: Dictionary = (load("res://scripts/rules/FighterLook.gd") as GDScript).look({"name": "crew " + str(role) + glb})
		var face := apply(body, skel, look, glb, true)
		_close_collar(body)
		var life: SkeletonModifier3D = (load("res://scripts/fight3d/FighterLife.gd") as GDScript).new()
		life.name = "FighterLife"
		life.set("crew", true)
		if life.call("setup", skel, a.get("ap"), stage, look, face["eyes"]):
			skel.add_child(life)
			var ik: Node = skel.find_child("CornerIK", false, false)
			var tw: Node = skel.find_child("MetaHumanTwist", false, false)
			if ik != null:
				skel.move_child(life, ik.get_index())
			elif tw != null:
				skel.move_child(life, tw.get_index())
		else:
			life.free()


static func off() -> bool:
	return OS.get_cmdline_user_args().has("nolook")


static func apply(body: Node3D, skel: Skeleton3D, look: Dictionary, glb: String, crew_member: bool = false) -> Dictionary:
	var out := {"eyes": []}
	if body == null or skel == null or look.is_empty():
		return out
	var skin: Dictionary = look["skin"]
	var tint: Color = skin["tint"]
	var tone := _skin_tone(glb)
	var eye_shader: Shader = load(EYE_SHADER) as Shader
	var eyes: Dictionary = look["eyes"]
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		if mi.mesh == null:
			continue
		if mi.has_meta("fighter_kit"):
			_tint_boot(mi, look["boots"])
			continue
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			if src == null:
				continue
			var nm := src.resource_name
			var active := mi.get_active_material(s)
			if active is ShaderMaterial and (active as ShaderMaterial).shader != null \
					and (active as ShaderMaterial).shader.resource_path == SKIN_SHADER:
				var sm := active as ShaderMaterial
				sm.set_shader_parameter("tint", Vector3(tint.r, tint.g, tint.b))
				sm.set_shader_parameter("specular_v", float(skin["specular"]))
				sm.set_shader_parameter("roughness_v", float(skin["roughness"]))
				sm.set_shader_parameter("sss_strength", float(skin["sss"]))
				sm.set_shader_parameter("micro_strength", float(skin["micro"]))
			elif nm.begins_with("MH_Eye") and not nm.begins_with("MH_Eyelashes") and src is BaseMaterial3D:
				var em := ShaderMaterial.new()
				em.shader = eye_shader
				em.set_shader_parameter("albedo_tex", (src as BaseMaterial3D).albedo_texture)
				em.set_shader_parameter("lid", float(eyes["lid"]))
				# A Color, not a Vector3: a source_color uniform converts a Color from sRGB (round 1: a Vector3 skipped it - pale lids).
				em.set_shader_parameter("lid_col", Color(tone.r * tint.r, tone.g * tint.g, tone.b * tint.b) * 0.92)
				_eye_at(skel, mi, s)
				mi.set_surface_override_material(s, em)
				(out["eyes"] as Array).append(em)
			elif (nm.begins_with("MH_Hair") or nm.begins_with("MH_Brows")) and active is BaseMaterial3D and not crew_member:
				var hm := (active as BaseMaterial3D).duplicate() as BaseMaterial3D
				hm.albedo_color = look["hair"]
				mi.set_surface_override_material(s, hm)
			elif nm.begins_with("MH_Trim") and active is BaseMaterial3D:
				var tm := (active as BaseMaterial3D).duplicate() as BaseMaterial3D
				tm.albedo_color = look["trim"]
				mi.set_surface_override_material(s, tm)
	_scars(skel, look.get("scars", []))
	return out


## Between the eyes in the body's rest space (= skeleton space, tools/eye_frame_probe.gd), kept on the skeleton for FighterLife.
static func _eye_at(skel: Skeleton3D, mi: MeshInstance3D, s: int) -> void:
	var v: PackedVector3Array = mi.mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]
	if v.is_empty():
		return
	var c := Vector3.ZERO
	for p in v:
		c += p
	skel.set_meta("eye_at", c / float(v.size()))


## Blind round 1 (both critics, every arm): "a jagged hole where the neck meets the collar" - the shirt is one-sided, so its
## inside is see-through at the neck. Drawn two-sided, the gap shows the shirt's own dark inside: a collar, not a hole.
static func _close_collar(body: Node) -> void:
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		if mi.mesh == null:
			continue
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			var a := mi.get_active_material(s)
			if src != null and src.resource_name.begins_with("Staff_Shirt") and a is BaseMaterial3D:
				var two := (a as BaseMaterial3D).duplicate() as BaseMaterial3D
				two.cull_mode = BaseMaterial3D.CULL_DISABLED
				mi.set_surface_override_material(s, two)


static func _tint_boot(mi: MeshInstance3D, colour: Color) -> void:
	for s in mi.mesh.get_surface_count():
		var a := mi.get_active_material(s)
		if a is BaseMaterial3D:
			var b := (a as BaseMaterial3D).duplicate() as BaseMaterial3D
			b.albedo_color = colour
			b.metallic = 0.0
			mi.set_surface_override_material(s, b)


## Each scar is a small decal on the head bone, placed in the body's rest space (a pale, raised line).
static func _scars(skel: Skeleton3D, spots: Array) -> void:
	var head := skel.find_bone("Head")
	if head < 0 or spots.is_empty():
		return
	var att := BoneAttachment3D.new()
	att.name = "FighterScars"
	att.bone_name = "Head"
	skel.add_child(att)
	var rest_space := Node3D.new()
	att.add_child(rest_space)
	rest_space.transform = skel.get_bone_global_rest(head).affine_inverse()
	for spot in spots:
		var row: Array = SCAR_AT.get(str(spot), [])
		if row.is_empty():
			continue
		var d := Decal.new()
		d.texture_albedo = _scar()
		d.modulate = Color(1.0, 0.86, 0.82, 0.85)
		var sz: Vector2 = row[2]
		d.size = Vector3(sz.x, 0.05, sz.y * 2.2)
		d.upper_fade = 0.2
		d.lower_fade = 0.2
		d.cull_mask = 1
		# Projects along -Y: turn local +Y to the face's +Z, then roll the line about the face normal.
		d.transform = Transform3D(Basis(Vector3.FORWARD, float(row[1])) * Basis(Vector3.RIGHT, PI * 0.5), row[0])
		rest_space.add_child(d)


static func _scar() -> Texture2D:
	if _scar_tex != null:
		return _scar_tex
	var w := 64
	var h := 16
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		for x in w:
			var u := float(x) / float(w - 1) * 2.0 - 1.0
			var v := float(y) / float(h - 1) * 2.0 - 1.0
			var along := 1.0 - pow(absf(u), 3.0)
			var across := exp(-v * v * 9.0)
			var a := clampf(along * across, 0.0, 1.0)
			img.set_pixel(x, y, Color(0.93, 0.78, 0.74, a))
	_scar_tex = ImageTexture.create_from_image(img)
	return _scar_tex


## The body's skin colour from its sidecar json (as MHRig): the closed lid's colour.
static func _skin_tone(glb: String) -> Color:
	var p := glb.get_basename() + ".json"
	if glb.is_empty() or not FileAccess.file_exists(p):
		return Color("#a8704a")
	var d: Variant = JSON.parse_string(FileAccess.get_file_as_string(p))
	if d is Dictionary:
		var rgb: Variant = (d as Dictionary).get("skin_neck_rgb", null)
		if rgb is Array and (rgb as Array).size() == 3:
			return Color8(int(rgb[0]), int(rgb[1]), int(rgb[2]))
		if str((d as Dictionary).get("skin", "")).begins_with("#"):
			return Color(str((d as Dictionary)["skin"]))
	return Color("#a8704a")
