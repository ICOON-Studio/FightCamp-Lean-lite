extends SceneTree
## STYLIZED1 (operator S399 "i want whatever is on the image to match the fighter"): under `art=toon` the two bodies with a
## repainted skin (assets/models/metahuman/toon/) wear their paintings and flat-colour hair cards; a body without one keeps
## the shader-only toon; the realistic look (the default) is untouched - the MetaHuman skin shader on the photo textures.

const MHRig := preload("res://scripts/fight3d/MHRig.gd")
const ArtStyleScript := preload("res://scripts/fight3d/ArtStyle.gd")
const SKIN := "res://assets/models/metahuman/mh_skin.gdshader"
const TOON := "res://assets/shaders/toon.gdshader"

var failures := 0


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	_check(ArtStyleScript.mode() == "real" or OS.get_cmdline_user_args().has("art=toon"), "the art style is real unless asked")
	var stage := Node3D.new()
	root.add_child(stage)
	var bodies := {}
	for body in ["mh_boxer_01", "mh_boxer_13", "mh_boxer_11"]:
		var f := MHRig.load_fighter("res://assets/models/metahuman/%s.glb" % body)
		_check(f != null, "%s loads" % body)
		stage.add_child(f)
		bodies[body] = f
		# Realistic (no ArtStyle on the stage): skin on the MetaHuman shader with the GLB's own photo textures.
		for sm in _skins(f):
			var t: Texture2D = sm.get_shader_parameter("albedo_tex")
			_check(sm.shader.resource_path == SKIN and t != null and t.resource_path.is_empty(),
				"%s realistic: skin shader + its own photo texture '%s'" % [body, t.resource_name if t else "-"])
	# STYLIZED2: the brow cards sit over the eyes on every body (10 of 23 were exported on the jaw).
	var d := DirAccess.open("res://assets/models/metahuman")
	var bad := []
	for fn in d.get_files():
		if not fn.ends_with(".glb"):
			continue
		var g := MHRig.load_fighter("res://assets/models/metahuman/" + fn)
		var eye_top := -1e9
		var brow_low := 1e9
		for mi in g.find_children("*", "MeshInstance3D", true, false):
			for s in (mi as MeshInstance3D).mesh.get_surface_count():
				var nm: String = (mi as MeshInstance3D).mesh.surface_get_material(s).resource_name
				if nm == "MH_Eye" or nm.begins_with("MH_Brows"):
					for p in (mi as MeshInstance3D).mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]:
						eye_top = maxf(eye_top, p.y) if nm == "MH_Eye" else eye_top
						brow_low = minf(brow_low, p.y) if nm != "MH_Eye" else brow_low
		if absf(brow_low - eye_top) > 0.02:
			bad.append("%s %.3f" % [fn, brow_low - eye_top])
		g.free()
	_check(bad.is_empty(), "every body's brows sit over its eyes (lowest card within 2 cm of the eye top) %s" % [bad])
	# Every texture painted exists and loads.
	for body in ["mh_boxer_01", "mh_boxer_13"]:
		for atlas in ["mh02_head_albedo", "mh02_body_albedo"]:
			var p := "res://assets/models/metahuman/toon/%s_%s_toon.png" % [body, atlas]
			var tex := load(p) as Texture2D
			_check(tex != null and tex.get_width() == 1024, "%s loads (1024 px, the atlas's own size)" % p.get_file())
	# Toon: the art layer converts the stage.
	var art: Node = ArtStyleScript.new()
	stage.add_child(art)
	for i in 4:
		await process_frame
	for body in bodies:
		var painted: bool = body != "mh_boxer_11"
		var skins := 0
		var hair := 0
		for mi in bodies[body].find_children("*", "MeshInstance3D", true, false):
			for s in (mi as MeshInstance3D).mesh.get_surface_count():
				var m := (mi as MeshInstance3D).get_active_material(s)
				var src := (mi as MeshInstance3D).mesh.surface_get_material(s)
				if not (m is ShaderMaterial) or src == null:
					continue
				var sm := m as ShaderMaterial
				var nm := src.resource_name
				if nm.begins_with("MH_Skin"):
					skins += 1
					var t: Texture2D = sm.get_shader_parameter("albedo_tex")
					var on_paint: bool = t != null and t.resource_path.contains("/toon/")
					_check(sm.shader.resource_path == TOON and on_paint == painted and (float(sm.get_shader_parameter("flat_mix")) == 0.0) == painted,
						"%s %s toon: %s" % [body, nm, "its painting, no wash" if painted else "shader toon on the photo (no painting)"])
				elif nm.begins_with("MH_Hair") or nm.begins_with("MH_Brows"):
					hair += 1
					_check((sm.get_shader_parameter("tex_alpha_only") == true) == painted and float(sm.get_shader_parameter("alpha_cut")) > 0.0,
						"%s %s: %s" % [body, nm, "flat colour cards" if painted else "textured cards"])
		_check(skins == 2, "%s: head and body skin converted (%d)" % [body, skins])
		_check(hair >= 1, "%s: hair/brow cards converted (%d)" % [body, hair])
	print("ART_TOON_PAINT_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _skins(f: Node) -> Array:
	var out := []
	for mi in f.find_children("*", "MeshInstance3D", true, false):
		for s in (mi as MeshInstance3D).mesh.get_surface_count():
			var m := (mi as MeshInstance3D).get_active_material(s)
			var src := (mi as MeshInstance3D).mesh.surface_get_material(s)
			if m is ShaderMaterial and src != null and src.resource_name.begins_with("MH_Skin"):
				out.append(m)
	return out


func _check(ok: bool, what: String) -> void:
	print(("OK  " if ok else "FAIL ") + what)
	if not ok:
		failures += 1
