extends SceneTree
## BODYLOOK1 (S492): where the head mesh lies on the body. MetaHuman heads run down the neck onto the chest; per body this
## prints how many head vertices sit within 3 mm of each body surface (coincident skin = two surfaces fighting for the same
## pixels), the head's lowest point, and - on staff bodies - how many head and body skin vertices lie UNDER the outfit (a skin
## vertex whose outward normal line meets an outfit vertex within 4 cm: it can only ever poke through the cloth).
##   <godot> --headless --path . --script res://tools/bodylook_overlap.gd -- mh_boxer_11 mh_staff_coach ...
const MH := preload("res://scripts/fight3d/MHRig.gd")
const CELL := 0.01

func _initialize() -> void:
	for n in OS.get_cmdline_user_args():
		if n == "nobodylook":
			continue
		var t0 := Time.get_ticks_msec()
		var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % n)
		var arm := "exported" if OS.get_cmdline_user_args().has("nobodylook") else "fixed"
		print("BODYLOOK_OVERLAP %s %s load_ms=%d" % [arm, n, Time.get_ticks_msec() - t0])
		root.add_child(body)
		var surf := {}   # label -> [verts, normals]
		for m in body.find_children("*", "MeshInstance3D", true, false):
			var mi := m as MeshInstance3D
			for s in mi.mesh.get_surface_count():
				var src := mi.mesh.surface_get_material(s)
				var label: String = src.resource_name if src != null else "?"
				var arr: Array = mi.mesh.surface_get_arrays(s)
				# only the vertices a triangle still uses (ClothMask drops triangles, never vertices)
				var used := {}
				for i in arr[Mesh.ARRAY_INDEX]:
					used[i] = true
				var vv := PackedVector3Array()
				var nn := PackedVector3Array()
				for i in used:
					vv.append(arr[Mesh.ARRAY_VERTEX][i])
					nn.append(arr[Mesh.ARRAY_NORMAL][i])
				surf[label] = [vv, nn, mi.transform]
		var head: PackedVector3Array = surf["MH_Skin_Head"][0]
		var low := 1e9
		for p in head:
			low = minf(low, p.y)
		var grid := {}
		for label in surf:
			if label in ["MH_Skin_Head", "MH_Teeth", "MH_Eye", "MH_Eyelashes", "MH_Hair", "MH_Brows"]:
				continue
			for p in surf[label][0]:
				var k := Vector3i((p / CELL).floor())
				if not grid.has(k):
					grid[k] = []
				grid[k].append([p, label])
		var near := {}
		for p in head:
			var best := 0.003
			var who := ""
			var k := Vector3i((p / CELL).floor())
			for dx in [-1, 0, 1]:
				for dy in [-1, 0, 1]:
					for dz in [-1, 0, 1]:
						for e in grid.get(k + Vector3i(dx, dy, dz), []):
							var d: float = (e[0] as Vector3).distance_to(p)
							if d < best:
								best = d
								who = e[1]
			if who != "":
				near[who] = int(near.get(who, 0)) + 1
		print("BODYLOOK_OVERLAP %s %s head_verts=%d head_low_y=%.3f within3mm=%s" % [arm, n, head.size(), low, str(near)])
		# under the outfit
		var cloth := {}
		for label in surf:
			if not str(label).begins_with("Staff_"):
				continue
			for p in surf[label][0]:
				var k := Vector3i((p / 0.02).floor())
				if not cloth.has(k):
					cloth[k] = []
				cloth[k].append(p)
		if cloth.is_empty():
			continue
		for label in ["MH_Skin_Head", "MH_Skin_Body"]:
			var v: PackedVector3Array = surf[label][0]
			var nr: PackedVector3Array = surf[label][1]
			var under := 0
			var under_low := 1e9
			var under_high := -1e9
			for i in v.size():
				if _covered(cloth, v[i], nr[i]):
					under += 1
					under_high = maxf(under_high, v[i].y)
					under_low = minf(under_low, v[i].y)
			print("BODYLOOK_OVERLAP %s %s %s verts=%d under_outfit=%d y=%.3f..%.3f" % [arm, n, label, v.size(), under, under_low, under_high])
		body.free()
	quit()

static func _covered(cloth: Dictionary, p: Vector3, nrm: Vector3) -> bool:
	var k := Vector3i((p / 0.02).floor())
	for dx in [-2, -1, 0, 1, 2]:
		for dy in [-2, -1, 0, 1, 2]:
			for dz in [-2, -1, 0, 1, 2]:
				for c in cloth.get(k + Vector3i(dx, dy, dz), []):
					var d: Vector3 = c - p
					var along := d.dot(nrm)
					if along > -0.002 and along < 0.04 and (d - nrm * along).length() < 0.012:
						return true
	return false
