extends SceneTree
## BODYLOOK1 (S492): how jagged the border between skin and the painted kit is. For every border vertex with two border
## neighbours: how far it sits off the straight line between them (a smooth curve: ~1 mm; a staircase: half a tooth).
## Also the load time and what ClothMask did. Add `nobodylook` for the bodies as exported.
##   <godot> --headless --path . --script res://tools/bodylook_edge.gd -- mh_boxer_11 mh_boxer_14 [nobodylook]
const MH := preload("res://scripts/fight3d/MHRig.gd")
const KIT := ["MH_Top", "MH_Trim", "MH_Trunks"]

func _key(p: Vector3) -> Vector3i:
	return Vector3i(roundi(p.x * 10000.0), roundi(p.y * 10000.0), roundi(p.z * 10000.0))

func _initialize() -> void:
	var arm := "exported" if OS.get_cmdline_user_args().has("nobodylook") else "fixed"
	for n in OS.get_cmdline_user_args():
		if n == "nobodylook":
			continue
		var t0 := Time.get_ticks_msec()
		var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % n)
		var ms := Time.get_ticks_msec() - t0
		root.add_child(body)
		var mi := body.find_child("MH_Body", true, false) as MeshInstance3D
		var ids := {}
		var pos: Array = []
		var skin_e := {}
		var cloth_e := {}
		var skin_w := {}    # welded place -> [bones, weights] of the skin copy
		var skin_cells := {}   # 1 mm cell -> [[place, weights]] of the skin
		var cloth_w: Array = []   # [welded place, bones, weights] of every kit vertex
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			var label: String = src.resource_name if src != null else "?"
			var cloth: bool = KIT.any(func(c): return label.begins_with(c))
			if label != "MH_Skin_Body" and not cloth:
				continue
			var arr: Array = mi.mesh.surface_get_arrays(s)
			var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
			var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
			var e: Dictionary = cloth_e if cloth else skin_e
			var bo: PackedInt32Array = arr[Mesh.ARRAY_BONES]
			var we: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
			var per: int = bo.size() / v.size()
			for i in v.size():
				var bw := {}
				for c in per:
					if we[i * per + c] > 0.0:
						bw[bo[i * per + c]] = float(bw.get(bo[i * per + c], 0.0)) + we[i * per + c]
				if cloth:
					cloth_w.append([v[i], bw])
				else:
					skin_w[_key(v[i])] = bw
					var cell := Vector3i((v[i] / 0.001).floor())
					if not skin_cells.has(cell):
						skin_cells[cell] = []
					skin_cells[cell].append([v[i], bw])
			for t in range(0, idx.size(), 3):
				for c in 3:
					var ka := _key(v[idx[t + c]])
					var kb := _key(v[idx[t + (c + 1) % 3]])
					for k in [ka, kb]:
						if not ids.has(k):
							ids[k] = pos.size()
							pos.append(Vector3(k) / 10000.0)
					var a: int = ids[ka]
					var b: int = ids[kb]
					e[mini(a, b) * 1000003 + maxi(a, b)] = true
		var near := {}
		for k in skin_e:
			if cloth_e.has(k):
				var a := int(k) / 1000003
				var b := int(k) % 1000003
				for pr in [[a, b], [b, a]]:
					if not near.has(pr[0]):
						near[pr[0]] = []
					near[pr[0]].append(pr[1])
		var devs: Array = []
		for id in near:
			if (near[id] as Array).size() == 2:
				devs.append(((pos[id] as Vector3) - ((pos[near[id][0]] as Vector3) + (pos[near[id][1]] as Vector3)) * 0.5).length())
		devs.sort()
		var mean := 0.0
		for d in devs:
			mean += d
		mean /= maxf(1.0, devs.size())
		# kit vertices that sit on a skin vertex but would move differently: the largest weight difference on any bone
		var on_skin := 0
		var differ := 0
		var worst := 0.0
		var apart := 0   # twins that are not on the same spot (a hairline crack)
		for cw in cloth_w:
			# its skin twin: the nearest skin vertex within 0.8 mm (the kit's copies are not quite on the skin's)
			var b: Variant = null
			var best := 0.0008
			var cell := Vector3i(((cw[0] as Vector3) / 0.001).floor())
			for x in [-1, 0, 1]:
				for y in [-1, 0, 1]:
					for z in [-1, 0, 1]:
						for e in skin_cells.get(cell + Vector3i(x, y, z), []):
							var d: float = (e[0] as Vector3).distance_to(cw[0])
							if d < best:
								best = d
								b = e[1]
			if b == null:
				continue
			on_skin += 1
			if best > 0.00005:
				apart += 1
			var a: Dictionary = cw[1]
			var gap := 0.0
			for k in a:
				gap = maxf(gap, absf(float(a[k]) - float((b as Dictionary).get(k, 0.0))))
			for k in (b as Dictionary):
				gap = maxf(gap, absf(float(b[k]) - float(a.get(k, 0.0))))
			worst = maxf(worst, gap)
			if gap > 0.01:
				differ += 1
		var extra := 0
		for m in body.find_children("StaffCollar", "MeshInstance3D", true, false):
			extra += 1
		print("BODYLOOK_EDGE %s %s load_ms=%d border_verts=%d off_line_mm mean=%.2f p90=%.2f max=%.2f kit_on_skin=%d not_on_spot=%d weights_differ=%d worst=%.3f collar=%d" % [arm, n, ms, devs.size(),
			mean * 1000.0, (devs[int(devs.size() * 0.9)] if not devs.is_empty() else 0.0) * 1000.0, (devs[-1] if not devs.is_empty() else 0.0) * 1000.0, on_skin, apart, differ, worst, extra])
		body.free()
	quit()
