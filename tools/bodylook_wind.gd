extends SceneTree
## BODYLOOK1 (S492): triangles that face the wrong way. Per surface: triangles whose winding normal points against their
## own vertex normals (flipped: with back faces culled the outside of the body is invisible there and the far side shows
## through), triangles that sit exactly on another triangle (duplicates: they z-fight), and where they are (rest pose, m).
##   <godot> --headless --path . --script res://tools/bodylook_wind.gd -- mh_boxer_11 ...
const MH := preload("res://scripts/fight3d/MHRig.gd")

func _key(p: Vector3) -> Vector3i:
	return Vector3i(roundi(p.x * 10000.0), roundi(p.y * 10000.0), roundi(p.z * 10000.0))

func _initialize() -> void:
	var names: Array = OS.get_cmdline_user_args()
	for n in names:
		if n == "nobodylook":
			continue
		var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % n)
		root.add_child(body)
		var seen := {}   # sorted triple of vertex keys -> label
		for m in body.find_children("*", "MeshInstance3D", true, false):
			var mi := m as MeshInstance3D
			if mi.name != "MH_Body":
				continue
			for s in mi.mesh.get_surface_count():
				var src := mi.mesh.surface_get_material(s)
				var label: String = src.resource_name if src != null else "?"
				if label in ["MH_Teeth", "MH_Eye", "MH_Eyelashes"]:
					continue
				var arr: Array = mi.mesh.surface_get_arrays(s)
				var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
				var nr: PackedVector3Array = arr[Mesh.ARRAY_NORMAL]
				var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
				var flipped := 0
				var pos := 0
				var dup := 0
				var where: Array = []
				for t in idx.size() / 3:
					var a := v[idx[t * 3]]
					var b := v[idx[t * 3 + 1]]
					var c := v[idx[t * 3 + 2]]
					var fn := (b - a).cross(c - a)
					if fn.length() < 1e-12:
						continue
					var vn := nr[idx[t * 3]] + nr[idx[t * 3 + 1]] + nr[idx[t * 3 + 2]]
					if fn.dot(vn) > 0.0:
						pos += 1
					else:
						flipped += 1
						if where.size() < 400:
							where.append((a + b + c) / 3.0)
					var ks := [_key(a), _key(b), _key(c)]
					ks.sort()
					var k := str(ks)
					if seen.has(k):
						dup += 1
						print("BODYLOOK_WIND %s DUP %s with %s at %s" % [n, label, seen[k], str((a + b + c) / 3.0)])
					else:
						seen[k] = label
				# report the minority as "flipped" (the winding convention is whichever most triangles use)
				var minority := mini(pos, flipped)
				print("BODYLOOK_WIND %s %s tris=%d agree=%d against=%d dup=%d" % [n, label, idx.size() / 3, pos, flipped, dup])
				if flipped <= pos and flipped > 0:
					var lo := Vector3(1e9, 1e9, 1e9)
					var hi := -lo
					for p in where:
						lo = lo.min(p)
						hi = hi.max(p)
					print("BODYLOOK_WIND %s %s against-box lo=%s hi=%s first=%s" % [n, label, str(lo), str(hi), str(where.slice(0, 6))])
		body.queue_free()
	quit()
