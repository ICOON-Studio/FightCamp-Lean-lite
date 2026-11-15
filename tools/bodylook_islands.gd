extends SceneTree
## BODYLOOK1 (S492): islands - small connected groups of one surface's triangles (positions welded at 0.1 mm). A patch of
## MH_Skin_Body left inside the trunks or the top (or cloth inside the skin) is a mis-assigned island: it shows as a hole in
## the garment. Prints every island under MAX_TRIS with its size and centre (rest pose, m).
##   <godot> --headless --path . --script res://tools/bodylook_islands.gd -- mh_boxer_11 ...
const MH := preload("res://scripts/fight3d/MHRig.gd")
const MAX_TRIS := 400
const SURFS := ["MH_Skin_Body", "MH_Trunks", "MH_Top", "MH_Trim"]

func _key(p: Vector3) -> Vector3i:
	return Vector3i(roundi(p.x * 10000.0), roundi(p.y * 10000.0), roundi(p.z * 10000.0))

func _find(par: PackedInt32Array, i: int) -> int:
	while par[i] != i:
		par[i] = par[par[i]]
		i = par[i]
	return i

func _initialize() -> void:
	var names: Array = OS.get_cmdline_user_args()
	if names.is_empty():
		for f in DirAccess.get_files_at("res://assets/models/metahuman"):
			if f.begins_with("mh_boxer_") and f.ends_with(".glb"):
				names.append(f.get_basename())
	for n in names:
		if n == "nobodylook":
			continue
		var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % n)
		root.add_child(body)
		var mi := body.find_child("MH_Body", true, false) as MeshInstance3D
		var line := ""
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			var label: String = src.resource_name if src != null else "?"
			if not label in SURFS:
				continue
			var arr: Array = mi.mesh.surface_get_arrays(s)
			var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
			var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
			var nt := idx.size() / 3
			var par := PackedInt32Array()
			par.resize(nt)
			for t in nt:
				par[t] = t
			var owner := {}   # vertex key -> first triangle
			for t in nt:
				for e in 3:
					var k := _key(v[idx[t * 3 + e]])
					if owner.has(k):
						var ra := _find(par, t)
						var rb := _find(par, int(owner[k]))
						if ra != rb:
							par[ra] = rb
					else:
						owner[k] = t
			var groups := {}
			for t in nt:
				var r := _find(par, t)
				if not groups.has(r):
					groups[r] = []
				groups[r].append(t)
			var big := 0
			for r in groups:
				var g: Array = groups[r]
				if g.size() > MAX_TRIS:
					big += 1
					continue
				var c := Vector3.ZERO
				for t in g:
					c += v[idx[t * 3]]
				c /= float(g.size())
				print("BODYLOOK_ISLAND %s %s tris=%d centre=(%.3f, %.3f, %.3f)" % [n, label, g.size(), c.x, c.y, c.z])
			line += " %s:%d groups(%d big)" % [label, groups.size(), big]
		print("BODYLOOK_ISLAND %s SUMMARY%s" % [n, line])
		body.free()
	quit()
