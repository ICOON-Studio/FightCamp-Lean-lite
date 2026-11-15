extends SceneTree
## BODYLOOK1 (S492): the mesh and material layer of each MetaHuman body, headless. Per surface: triangles, open edges
## (edges one triangle uses, positions welded at 0.1 mm, so split UV/normal seams do not count), edges shared with another
## surface, and the material flags after the game's own dressing (MHRig.dress + kit colours). An open edge INSIDE a garment
## or across the body is a hole: with back faces culled the far side shows through it.
##   <godot> --headless --path . --script res://tools/bodylook_probe.gd -- mh_boxer_01 mh_staff_coach ...
const MH := preload("res://scripts/fight3d/MHRig.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")

func _key(p: Vector3) -> Vector3i:
	return Vector3i(roundi(p.x * 10000.0), roundi(p.y * 10000.0), roundi(p.z * 10000.0))

func _initialize() -> void:
	var names: Array = OS.get_cmdline_user_args()
	if names.is_empty():
		names = ["mh_boxer_01", "mh_staff_coach"]
	for n in names:
		if n == "nobodylook":
			continue
		var path := "res://assets/models/metahuman/%s.glb" % n
		var body := MH.load_fighter(path)
		if body == null:
			print("BODYLOOK %s LOAD FAIL" % n)
			continue
		root.add_child(body)
		MH.colour_trunks(body, Color(0.05, 0.08, 0.35), 0.6)
		FighterKit.colour_vest(body, Color.RED, 0.6)
		FighterKit.cloth_normals(body)
		# edge -> list of surface labels
		var edges := {}
		var surf_tris := {}
		for m in body.find_children("*", "MeshInstance3D", true, false):
			var mi := m as MeshInstance3D
			for s in mi.mesh.get_surface_count():
				var src := mi.mesh.surface_get_material(s)
				var label := "%s/%s" % [mi.name, src.resource_name if src != null else "?"]
				var arr: Array = mi.mesh.surface_get_arrays(s)
				var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
				var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
				var tris := idx.size() / 3
				surf_tris[label] = tris
				for t in tris:
					for e in 3:
						var a := _key(v[idx[t * 3 + e]])
						var b := _key(v[idx[t * 3 + (e + 1) % 3]])
						var k := [a, b] if (a.x < b.x or (a.x == b.x and (a.y < b.y or (a.y == b.y and a.z < b.z)))) else [b, a]
						if not edges.has(k):
							edges[k] = []
						edges[k].append(label)
				var mat := mi.get_active_material(s)
				var flags := ""
				if mat is BaseMaterial3D:
					var bm := mat as BaseMaterial3D
					flags = "Std cull=%d transp=%d depth_draw=%d alpha=%.2f shading=%d" % [bm.cull_mode, bm.transparency, bm.depth_draw_mode, bm.albedo_color.a, bm.shading_mode]
				elif mat is ShaderMaterial:
					flags = "Shader %s" % (mat as ShaderMaterial).shader.resource_path.get_file()
				print("BODYLOOK %s SURF %s tris=%d %s" % [n, label, tris, flags])
		var open := {}
		var shared := {}
		var nonman := {}
		for k in edges:
			var labs: Array = edges[k]
			if labs.size() == 1:
				open[labs[0]] = int(open.get(labs[0], 0)) + 1
			elif labs.size() == 2 and labs[0] != labs[1]:
				var pk := "%s|%s" % [labs[0], labs[1]] if str(labs[0]) < str(labs[1]) else "%s|%s" % [labs[1], labs[0]]
				shared[pk] = int(shared.get(pk, 0)) + 1
			elif labs.size() > 2:
				nonman[labs[0]] = int(nonman.get(labs[0], 0)) + 1
		for l in open:
			print("BODYLOOK %s OPEN %s edges=%d" % [n, l, open[l]])
		for l in shared:
			print("BODYLOOK %s SHARED %s edges=%d" % [n, l, shared[l]])
		for l in nonman:
			print("BODYLOOK %s NONMANIFOLD %s edges=%d" % [n, l, nonman[l]])
		body.queue_free()
	quit()
