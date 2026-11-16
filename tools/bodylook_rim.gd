extends SceneTree
## BODYLOOK1 (S495, operator: "the small steps at the singlet strap tips"). A strap's tip is not the kit's own border: it
## is where the HEAD mesh's open rim lies over the singlet. This measures that rim against the body under it: how many
## rim vertices sit on a body vertex (skin / kit / the kit's open rim, the neck hole), how many rim edges are body edges
## too, and how far each rim vertex over the kit sits off the line between its two rim neighbours (the tooth).
##   godot --headless --path . --script res://tools/bodylook_rim.gd -- [nobodylook] [body ...]
const MH := preload("res://scripts/fight3d/MHRig.gd")
const ClothMask := preload("res://scripts/fight3d/ClothMask.gd")
const KIT := ["MH_Top", "MH_Trim", "MH_Trunks"]


func _initialize() -> void:
	var bodies: Array = []
	for a in OS.get_cmdline_user_args():
		if str(a) != "nobodylook" and not str(a).contains("="):
			bodies.append(str(a))
	if bodies.is_empty():
		bodies = ["mh_boxer_11", "mh_boxer_14", "mh_boxer_01"]
	for b in bodies:
		_body(b)
	quit()


func _body(name: String) -> void:
	var f: Node3D = MH.load_fighter("res://assets/models/metahuman/%s.glb" % name)
	if f == null:
		print("BODYLOOK_RIM FAIL load ", name)
		return
	var mi: MeshInstance3D = null
	for m in f.find_children("*", "MeshInstance3D", true, false):
		if ClothMask._surface(m, "MH_Skin_Head") >= 0:
			mi = m
	var ids := {}
	var pos: Array = []
	var kind := {}          # id -> bits: 1 body skin, 2 kit, 4 head
	var kit_tris: Array = []
	var edges := {}         # surface class ("skin" / "kit" / "head") -> {edge: uses}
	for s in mi.mesh.get_surface_count():
		var nm := ClothMask._name(mi, s)
		var cls := "skin" if nm == "MH_Skin_Body" else ("head" if nm == "MH_Skin_Head" else ("kit" if KIT.any(func(c): return nm.begins_with(c)) else ""))
		if cls == "":
			continue
		var arr: Array = mi.mesh.surface_get_arrays(s)
		var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
		var vid := PackedInt32Array()
		for p in v:
			var k := ClothMask._key(p)
			if not ids.has(k):
				ids[k] = pos.size()
				pos.append(p)
			vid.append(ids[k])
			kind[ids[k]] = int(kind.get(ids[k], 0)) | (1 if cls == "skin" else (2 if cls == "kit" else 4))
		if not edges.has(cls):
			edges[cls] = {}
		for t in range(0, idx.size(), 3):
			for c in 3:
				var a := vid[idx[t + c]]
				var b := vid[idx[t + (c + 1) % 3]]
				var e := mini(a, b) * 1000003 + maxi(a, b)
				edges[cls][e] = int(edges[cls].get(e, 0)) + 1
			if cls == "kit":
				kit_tris.append([vid[idx[t]], vid[idx[t + 1]], vid[idx[t + 2]]])
	# the kit's triangles that stand on the hole's edge: how many are joined to the rest of the kit only by a corner
	# (both other edges border skin) - a lone tooth of cloth on the neckline
	var lone := 0
	var half := 0
	var standing := 0
	var lone_at: Array = []
	for t in kit_tris:
		var on_rim := 0
		var to_skin := 0
		for c in 3:
			var a: int = t[c]
			var b: int = t[(c + 1) % 3]
			var e := mini(a, b) * 1000003 + maxi(a, b)
			if int(edges["kit"][e]) == 1 and not (edges["skin"] as Dictionary).has(e):
				on_rim += 1
			elif (edges["skin"] as Dictionary).has(e):
				to_skin += 1
		if on_rim == 0:
			continue
		standing += 1
		lone += int(to_skin == 2)
		half += int(to_skin == 1)
		if to_skin == 2:
			var c3: Vector3 = ((pos[t[0]] as Vector3) + (pos[t[1]] as Vector3) + (pos[t[2]] as Vector3)) / 3.0
			lone_at.append("(%.2f %.2f %.2f)" % [c3.x, c3.y, c3.z])
	print("BODYLOOK_RIM %s kit triangles standing on the neck hole's edge: %d, lone teeth (both other edges on skin) %d, one edge on skin %d" % [name, standing, lone, half])
	print("BODYLOOK_RIM %s lone teeth at %s" % [name, " ".join(lone_at)])
	var kit_rim := {}
	for e in edges.get("kit", {}):
		if int(edges["kit"][e]) == 1 and not (edges["skin"] as Dictionary).has(e):
			kit_rim[int(e) / 1000003] = true
			kit_rim[int(e) % 1000003] = true
	var near := {}
	var rim_edges := 0
	var on_body_edge := 0
	for e in edges["head"]:
		if int(edges["head"][e]) != 1:
			continue
		var a := int(e) / 1000003
		var b := int(e) % 1000003
		if (int(kind[a]) & 3) == 0 and (int(kind[b]) & 3) == 0:
			continue   # the eyes, the mouth: a rim that touches no body vertex
		rim_edges += 1
		if (edges["skin"] as Dictionary).has(e) or (edges.get("kit", {}) as Dictionary).has(e):
			on_body_edge += 1
		for pair in [[a, b], [b, a]]:
			if not near.has(pair[0]):
				near[pair[0]] = []
			near[pair[0]].append(pair[1])
	var on_skin := 0
	var on_kit := 0
	var on_hole := 0
	var free := 0
	var teeth: Array = []
	for id in near:
		var k := int(kind[id])
		on_skin += int(k & 1 != 0 and k & 2 == 0)
		on_kit += int(k & 2 != 0)
		on_hole += int(kit_rim.has(id))
		free += int(k & 3 == 0)
		if k & 2 != 0 and (near[id] as Array).size() == 2:
			var mid: Vector3 = ((pos[near[id][0]] as Vector3) + (pos[near[id][1]] as Vector3)) * 0.5
			teeth.append((pos[id] as Vector3).distance_to(mid) * 1000.0)
	teeth.sort()
	var mean := 0.0
	for t in teeth:
		mean += float(t)
	mean /= maxf(1.0, float(teeth.size()))
	print("BODYLOOK_RIM %s look=%s head rim: %d edges (%d are body edges too), %d vertices: on skin %d, on kit %d (of those on the neck hole's edge %d), on nothing %d" % [
		name, str(MH.body_look), rim_edges, on_body_edge, near.size(), on_skin, on_kit, on_hole, free])
	print("BODYLOOK_RIM %s rim over the kit, off the line between its neighbours: mean %.2f mm, worst %.2f mm (%d vertices)" % [
		name, mean, float(teeth[-1]) if not teeth.is_empty() else 0.0, teeth.size()])
	f.free()
