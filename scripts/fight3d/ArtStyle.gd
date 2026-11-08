extends Node
## FIGHTERLOOK1 (operator 2026-11-07: "i dont mind changign to stylized art if this helps with the reviews"): the fight's art
## style as a switch on the SAME rigs, clips and scenes. "real" = the MetaHuman look as built; "toon" = flat colour in three
## hard light bands, no specular (no glare), an ink outline on the people and their kit, a lifted even ambient.
## Where it is chosen: `art=toon|real` on the command line (films, A/B), else `art` in user://settings.cfg [settings], else
## DEFAULT. Added as a child of the 3D stage it converts everything there now and everything added later (the corner team,
## gloves, props); the ring pieces the camera fades keep their StandardMaterial3D (built-in toon modes).
##   mode() -> "real"|"toon"    watch(stage) -> ArtStyle (null when real)

const DEFAULT := "real"
const TOON := "res://assets/shaders/toon.gdshader"
const TOON_2SIDE := "res://assets/shaders/toon_2side.gdshader"
const OUTLINE := "res://assets/shaders/toon_outline.gdshader"
const SKIN := "res://assets/models/metahuman/mh_skin.gdshader"
const EYE := "res://assets/shaders/mh_eye.gdshader"
## Surfaces that get no ink line (inside the head, or cards that would turn into black blobs).
const NO_LINE := ["Eye", "Teeth", "Lash", "Hair", "Brow", "Tongue"]
## STYLIZED1 (operator S399 "i want whatever is on the image to match the fighter"): a body with its skin repainted in the
## portraits' flat comic style (Ludo image edit on the UV atlas, the layout kept; ops/research/STYLIZED1.md) has
## <texture stem>_toon.png here. Its skin then shows the painting as it is (no blur, no mean-tone wash), and its hair and
## brow cards are one flat colour (the atlas keeps only the coverage). Bodies without one keep the shader-only toon.
const PAINTED := "res://assets/models/metahuman/toon/"
## STYLIZED2 retune (blind STYLIZED1: "flat slabs", "pale", "a chin scribble", "washed eyes"): a camera-keyed cel form
## shadow on every toon surface, the light ~12% lower (painted skin measured 25% over the portrait's tone on screen), a
## bolder line that sits 4 cm behind the body (silhouette only), lashes at half strength.
const FORM_SHADE := 0.66
const LIGHT_K := 0.15
const LINE_PX := 2.4
const LINE_BACK := 0.04

var _toon: Shader
var _toon2: Shader
var _line: ShaderMaterial
var _done := {}       # material instance id -> its toon twin


static func mode() -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("art="):
			return "toon" if str(a).substr(4) == "toon" else "real"
	var cf := ConfigFile.new()
	if cf.load("user://settings.cfg") == OK:
		var v := str(cf.get_value("settings", "art", DEFAULT))
		return "toon" if v == "toon" else "real"
	return DEFAULT


static func watch(stage: Node) -> Node:
	if mode() != "toon" or stage == null:
		return null
	var a: Node = (load("res://scripts/fight3d/ArtStyle.gd") as GDScript).new()
	a.name = "ArtStyle"
	stage.add_child(a)
	return a


func _enter_tree() -> void:
	_toon = load(TOON) as Shader
	_toon2 = load(TOON_2SIDE) as Shader
	_line = ShaderMaterial.new()
	_line.shader = load(OUTLINE) as Shader
	_line.set_shader_parameter("width_px", LINE_PX)
	_line.set_shader_parameter("push_back", LINE_BACK)
	get_tree().node_added.connect(_on_added)
	_convert.call_deferred(get_parent())
	_light.call_deferred(get_parent())


func _exit_tree() -> void:
	if get_tree().node_added.is_connected(_on_added):
		get_tree().node_added.disconnect(_on_added)


func _on_added(n: Node) -> void:
	if (n is GeometryInstance3D) and get_parent() != null and get_parent().is_ancestor_of(n):
		_convert.call_deferred(n)


## Even light: more ambient fill (the shadow band reads as colour, not black), the bounce and contact shading softer.
func _light(root: Node) -> void:
	if root == null or not is_instance_valid(root):
		return
	for n in root.find_children("*", "WorldEnvironment", true, false):
		var e: Environment = (n as WorldEnvironment).environment
		if e == null:
			continue
		e.ambient_light_energy = 0.45
		e.ambient_light_color = Color(0.62, 0.62, 0.68)
		e.ssil_enabled = false
		e.ssao_intensity = 0.9
		e.adjustment_contrast = 1.0
		e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
		e.glow_intensity = 0.2
		e.glow_hdr_threshold = 1.4


func _convert(root: Node) -> void:
	if root == null or not is_instance_valid(root):
		return
	var all: Array = [root] if root is GeometryInstance3D else []
	all.append_array(root.find_children("*", "GeometryInstance3D", true, false))
	for g in all:
		if g is MeshInstance3D:
			_mesh(g as MeshInstance3D)
		elif g is GeometryInstance3D and (g as GeometryInstance3D).material_override is BaseMaterial3D:
			_flat((g as GeometryInstance3D).material_override as BaseMaterial3D)


func _mesh(mi: MeshInstance3D) -> void:
	if mi.mesh == null or mi.has_meta("art_toon"):
		return
	mi.set_meta("art_toon", true)
	if mi.material_override != null:
		if mi.material_override is BaseMaterial3D:
			_flat(mi.material_override as BaseMaterial3D)
		return
	for s in mi.mesh.get_surface_count():
		var m := mi.get_active_material(s)
		if m == null:
			continue
		var t := _twin(m, str(mi.get_meta("mh_body", "")))
		if t != null and t != m:
			mi.set_surface_override_material(s, t)


## The ring pieces and props keep their class (the camera fades them): built-in toon light, no specular.
func _flat(m: BaseMaterial3D) -> void:
	if m.shading_mode == BaseMaterial3D.SHADING_MODE_UNSHADED:
		return
	m.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
	m.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	m.roughness = maxf(m.roughness, 0.35)


func _twin(m: Material, body: String = "") -> Material:
	var id := m.get_instance_id()
	if _done.has(id):
		return _done[id]
	var out: Material = null
	var nm := m.resource_name
	if m is ShaderMaterial:
		var sm := m as ShaderMaterial
		var path := sm.shader.resource_path if sm.shader != null else ""
		if path == EYE:
			sm.set_shader_parameter("toon", true)
			out = sm
		elif path == SKIN:
			var tm := _new_toon()
			var src_tex: Variant = sm.get_shader_parameter("albedo_tex")
			var painted := painted_for(src_tex, body)
			tm.set_shader_parameter("use_tex", true)
			if painted != null:
				tm.set_shader_parameter("albedo_tex", painted)
				tm.set_shader_parameter("tex_blur", 0.0)
				tm.set_shader_parameter("flat_mix", 0.0)
			else:
				tm.set_shader_parameter("albedo_tex", src_tex)
				tm.set_shader_parameter("tex_blur", 3.0)
				tm.set_shader_parameter("flat_mix", 0.6)
				tm.set_shader_parameter("flat_col", _mean_tone(src_tex))
			var tint: Variant = sm.get_shader_parameter("tint")
			if tint is Vector3:
				tm.set_shader_parameter("tint", tint)
			tm.next_pass = _line
			out = tm
		elif sm.get_shader_parameter("cuff_colour") != null:   # the gloves (Gloves.gd): flat colour, cuff band, ink line
			var gm := _new_toon()
			gm.set_shader_parameter("albedo_col", sm.get_shader_parameter("colour"))
			gm.set_shader_parameter("use_band", true)
			gm.set_shader_parameter("band_col", sm.get_shader_parameter("cuff_colour"))
			gm.next_pass = _line
			out = gm
		else:
			out = m   # other custom looks (holo, halftone) stay as made
	elif m is BaseMaterial3D:
		var bm := m as BaseMaterial3D
		if bm.shading_mode == BaseMaterial3D.SHADING_MODE_UNSHADED or bm.transparency == BaseMaterial3D.TRANSPARENCY_ALPHA \
				or bm.transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS:
			_flat(bm)
			if nm.contains("Lash") and not bm.has_meta("art_lash"):
				bm.set_meta("art_lash", true)
				bm.albedo_color.a *= 0.5
			out = bm
		else:
			var tm := _new_toon()
			tm.set_shader_parameter("albedo_col", bm.albedo_color)
			if bm.albedo_texture != null:
				tm.set_shader_parameter("use_tex", true)
				tm.set_shader_parameter("albedo_tex", bm.albedo_texture)
				if is_painted_card(bm.albedo_texture, body):   # STYLIZED1: a painted body's hair is flat colour cards
					tm.set_shader_parameter("tex_alpha_only", true)
					tm.set_shader_parameter("albedo_col", _card_tone(bm.albedo_texture) * bm.albedo_color)
			tm.set_shader_parameter("use_vcol", bm.vertex_color_use_as_albedo)
			if bm.transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR:
				tm.set_shader_parameter("alpha_cut", bm.alpha_scissor_threshold)
			if not NO_LINE.any(func(w): return nm.contains(w)) and bm.transparency == BaseMaterial3D.TRANSPARENCY_DISABLED:
				tm.next_pass = _line
			if bm.cull_mode == BaseMaterial3D.CULL_DISABLED:
				tm.shader = _toon2
			out = tm
	_done[id] = out
	return out


## STYLIZED1: the repainted twin of a body's skin texture, or null when that body has none. The GLB's textures are named
## per atlas ("mh02_head_albedo"), the body by MHRig's "mh_body" tag on the mesh: toon/<body>_<atlas>_toon.png.
static func painted_for(tex: Variant, body: String) -> Texture2D:
	if not (tex is Texture2D) or body.is_empty() or OS.get_cmdline_user_args().has("nopaint"):   # `nopaint`: the shader-only toon (A/B)
		return null
	var p := PAINTED + body + "_" + (tex as Texture2D).resource_name + "_toon.png"
	return load(p) as Texture2D if ResourceLoader.exists(p) else null


## STYLIZED1: the hair or brow cards of a body whose skin was repainted.
static func is_painted_card(tex: Texture2D, body: String) -> bool:
	var nm := tex.resource_name
	return not body.is_empty() and not OS.get_cmdline_user_args().has("nopaint") and (nm.contains("hair_cards") or nm.contains("brow_cards")) 			and ResourceLoader.exists(PAINTED + body + "_mh02_head_albedo_toon.png")


## A card atlas's colour where its strands cover (alpha > 0.5): the one flat hair colour.
static func _card_tone(tex: Texture2D) -> Color:
	var img: Image = tex.get_image()
	if img == null:
		return Color(0.1, 0.08, 0.06)
	img = img.duplicate()
	if img.is_compressed():
		img.decompress()
	img.resize(128, 128, Image.INTERPOLATE_BILINEAR)
	var c := Color(0, 0, 0)
	var n := 0
	for y in 128:
		for x in 128:
			var px := img.get_pixel(x, y)
			if px.a > 0.5:
				c += px
				n += 1
	return Color(0.1, 0.08, 0.06) if n == 0 else Color(c.r / n, c.g / n, c.b / n)


## The skin texture's own mean colour (its 4x4 mip): the tone a toon face is painted in.
static func _mean_tone(tex: Variant) -> Color:
	if not (tex is Texture2D):
		return Color(0.6, 0.45, 0.35)
	var img: Image = (tex as Texture2D).get_image()
	if img == null:
		return Color(0.6, 0.45, 0.35)
	img = img.duplicate()
	if img.is_compressed():
		img.decompress()
	img.resize(4, 4, Image.INTERPOLATE_BILINEAR)
	var c := Color(0, 0, 0)
	for y in 4:
		for x in 4:
			c += img.get_pixel(x, y)
	return Color(c.r / 16.0, c.g / 16.0, c.b / 16.0)


func _new_toon() -> ShaderMaterial:
	var tm := ShaderMaterial.new()
	tm.shader = _toon
	tm.set_shader_parameter("form_shade", FORM_SHADE)
	tm.set_shader_parameter("light_k", LIGHT_K)
	return tm
