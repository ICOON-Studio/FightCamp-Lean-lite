extends SceneTree
## BODYLOOK1: how a staff outfit is skinned beside the head mesh - the joints each Skin names, and what the shirt's rim
## and the neck base under it are weighted to (the collar must move with the neck base).
##   <godot> --headless --path . --script res://tools/bodylook_skin.gd -- mh_staff_coach
const MH := preload("res://scripts/fight3d/MHRig.gd")

func _initialize() -> void:
	for n in OS.get_cmdline_user_args():
		if n == "nobodylook":
			continue
		var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % n)
		if body == null:
			print("BODYLOOK_SKIN %s load failed" % n)
			continue
		root.add_child(body)
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		for m in body.find_children("*", "MeshInstance3D", true, false):
			var mi := m as MeshInstance3D
			if mi.skin == null:
				print("BODYLOOK_SKIN %s %s no skin" % [n, mi.name])
				continue
			var names: Array = []
			for i in mi.skin.get_bind_count():
				var nm := str(mi.skin.get_bind_name(i))
				if nm == "" and mi.skin.get_bind_bone(i) >= 0:
					nm = skel.get_bone_name(mi.skin.get_bind_bone(i))
				names.append(nm)
			var has := names.filter(func(x): return str(x).to_lower().contains("neck") or str(x) in ["Head", "UpperChest", "Chest", "LeftShoulder", "RightShoulder"] or str(x).begins_with("spine"))
			print("BODYLOOK_SKIN %s %s skin_id=%d binds=%d upper=%s" % [n, mi.name, mi.skin.get_instance_id(), names.size(), str(has)])
			for s in mi.mesh.get_surface_count():
				var mat := mi.mesh.surface_get_material(s)
				var label: String = mat.resource_name if mat != null else "?"
				if not label in ["Staff_Shirt", "MH_Skin_Head"]:
					continue
				var arr: Array = mi.mesh.surface_get_arrays(s)
				var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
				var bo: PackedInt32Array = arr[Mesh.ARRAY_BONES]
				var we: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
				var per: int = bo.size() / v.size()
				# the weights summed over the vertices in the collar band (the 4 cm under the shirt's highest point)
				var top := -1e9
				if label == "Staff_Shirt":
					for p in v:
						top = maxf(top, p.y)
				else:
					top = float(get_meta("shirt_top", 1.5))
				set_meta("shirt_top", top)
				var sum := {}
				var count := 0
				for i in v.size():
					if v[i].y > top or v[i].y < top - 0.04 or absf(v[i].x) > 0.1:
						continue
					count += 1
					for c in per:
						if we[i * per + c] > 0.0:
							var nm: String = names[bo[i * per + c]]
							sum[nm] = float(sum.get(nm, 0.0)) + we[i * per + c]
				var parts: Array = []
				for k in sum:
					parts.append([float(sum[k]) / maxf(1.0, count), k])
				parts.sort()
				parts.reverse()
				print("BODYLOOK_SKIN %s %s per=%d collar_band_verts=%d mean weights: %s" % [n, label, per, count,
					", ".join(parts.slice(0, 8).map(func(x): return "%s %.2f" % [x[1], x[0]]))])
		body.free()
	quit()
