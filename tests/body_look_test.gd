extends SceneTree
## BODYLOOK1 (S492, the operator on the S490 build: the coach's "terrible neck blending", the fighters' "shoulders look
## weird", "sometimes you can see through them (they seem like arts poorly stitched together)"). The three mesh faults
## ClothMask + StaffCollar fix, each read with this test's OWN ruler on two arms: the body as exported (the ruler must
## SEE the fault there, or it proves nothing) and the body the game loads (the fault gone).
##   1. a staff body: head skin lying under the tee - gone but for the ring tucked under the collar; a collar rib that
##      takes the shirt's colour when CornerCrew paints it
##   2. Priya's body (mh_boxer_14): skin islands inside the trunks - gone
##   3. a boxer: the skin/singlet border - straighter, every kit vertex still exactly on its skin twin, same weights
##   and what must NOT change: a boxer's head mesh (its arc is the singlet's neckline), any surface's vertex count.

const ClothMask := preload("res://scripts/fight3d/ClothMask.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")
const KIT := ["MH_Top", "MH_Trim", "MH_Trunks"]
const DIR := "res://assets/models/metahuman/"

var failures := 0


func _initialize() -> void:
	_staff()
	_islands()
	_border()
	print("BODY_LOOK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _load(stem: String, fixed: bool) -> Node3D:
	MH.body_look = fixed
	var body := MH.load_fighter(DIR + stem + ".glb")
	MH.body_look = true
	root.add_child(body)
	return body


func _surface(body: Node, name: String) -> Array:   # [MeshInstance3D, surface] or []
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			var mat := mi.mesh.surface_get_material(s)
			if mat != null and mat.resource_name == name:
				return [mi, s]
	return []


static func _key(p: Vector3) -> Vector3i:
	return Vector3i(roundi(p.x * 10000.0), roundi(p.y * 10000.0), roundi(p.z * 10000.0))


## Head vertices a triangle still draws that lie UNDER the tee: a shirt vertex sits on the vertex's outward normal line
## (within 1.2 cm of it) no more than 4 cm out. Skin there can only ever poke through the cloth.
func _head_under_shirt(body: Node) -> int:
	var head := _surface(body, "MH_Skin_Head")
	var shirt := _surface(body, "Staff_Shirt")
	var grid := {}
	for p in (shirt[0] as MeshInstance3D).mesh.surface_get_arrays(shirt[1])[Mesh.ARRAY_VERTEX]:
		var k := Vector3i((p / 0.03).floor())
		if not grid.has(k):
			grid[k] = PackedVector3Array()
		grid[k].append(p)
	var arr: Array = (head[0] as MeshInstance3D).mesh.surface_get_arrays(head[1])
	var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var nr: PackedVector3Array = arr[Mesh.ARRAY_NORMAL]
	var used := {}
	for i in arr[Mesh.ARRAY_INDEX]:
		used[i] = true
	var n := 0
	for i in used:
		var k := Vector3i((v[i] / 0.03).floor())
		var hit := false
		for dx in [-1, 0, 1]:
			for dy in [-1, 0, 1]:
				for dz in [-1, 0, 1]:
					for c in grid.get(k + Vector3i(dx, dy, dz), PackedVector3Array()):
						var d: Vector3 = c - v[i]
						var along := d.dot(nr[i])
						hit = hit or (along > -0.002 and along < 0.04 and (d - nr[i] * along).length() < 0.012)
		if hit:
			n += 1
	return n


## The share of a surface's bone weight that sits on the head and neck joints, over its vertices within `band` m of its top.
func _neck_share(body: Node, surf: Array, band: float) -> float:
	var mi := surf[0] as MeshInstance3D
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var neck := {}
	for i in mi.skin.get_bind_count():
		var nm := str(mi.skin.get_bind_name(i))
		if nm == "" and mi.skin.get_bind_bone(i) >= 0:
			nm = skel.get_bone_name(mi.skin.get_bind_bone(i))
		if nm in ["Head", "Neck", "neck_02"]:
			neck[i] = true
	var arr: Array = mi.mesh.surface_get_arrays(int(surf[1]))
	var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var bo: PackedInt32Array = arr[Mesh.ARRAY_BONES]
	var we: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
	var per: int = bo.size() / v.size()
	var top := -INF
	for p in v:
		top = maxf(top, p.y)
	var on := 0.0
	var all := 0.0
	for i in v.size():
		if v[i].y < top - band or absf(v[i].x) > 0.1:
			continue
		for c in per:
			all += we[i * per + c]
			if neck.has(bo[i * per + c]):
				on += we[i * per + c]
	return on / maxf(all, 1e-6)


## The largest difference on any one joint between the rib's weights and those of the nearest drawn vertex of the shirt
## and of the head skin: [shirt, skin]. All three meshes share one Skin, so the joint numbers compare.
func _collar_gaps(body: Node, collar: MeshInstance3D) -> Array:
	var worst := [0.0, 0.0]
	var carr: Array = collar.mesh.surface_get_arrays(0)
	var cv: PackedVector3Array = carr[Mesh.ARRAY_VERTEX]
	var box := collar.mesh.get_aabb().grow(0.04)
	for which in 2:
		var surf := _surface(body, ["Staff_Shirt", "MH_Skin_Head"][which])
		var mi := surf[0] as MeshInstance3D
		var arr: Array = mi.mesh.surface_get_arrays(int(surf[1]))
		var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var to_collar := ClothMask._to(body, collar).affine_inverse() * ClothMask._to(body, mi)
		var near := {}
		for i in arr[Mesh.ARRAY_INDEX]:
			if not near.has(i) and box.has_point(to_collar * v[i]):
				near[i] = to_collar * v[i]
		for c in range(0, cv.size(), 8):   # the rib's ring points (8 vertices each, one set of weights)
			var centre := Vector3.ZERO
			for j in 8:
				centre += cv[c + j] / 8.0
			var best := -1
			var best_d := INF
			for i in near:
				var d := (near[i] as Vector3).distance_squared_to(centre)
				if d < best_d:
					best_d = d
					best = i
			if best >= 0:
				worst[which] = maxf(float(worst[which]), _gap(_mix(carr, c), _mix(arr, best)))
	return worst


func _mix(arr: Array, i: int) -> Dictionary:
	var bo: PackedInt32Array = arr[Mesh.ARRAY_BONES]
	var we: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
	var per: int = bo.size() / (arr[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	var out := {}
	for c in per:
		if we[i * per + c] > 0.0:
			out[bo[i * per + c]] = float(out.get(bo[i * per + c], 0.0)) + we[i * per + c]
	return out


func _gap(a: Dictionary, b: Dictionary) -> float:
	var worst := 0.0
	for k in a:
		worst = maxf(worst, absf(float(a[k]) - float(b.get(k, 0.0))))
	for k in b:
		worst = maxf(worst, absf(float(b[k]) - float(a.get(k, 0.0))))
	return worst


## Kit triangles that stand on the kit's open rim (one edge no other triangle shares) with both other edges on skin.
func _lone_teeth(body: Node) -> int:
	var mi := _surface(body, "MH_Skin_Body")[0] as MeshInstance3D
	var uses := {}   # edge (two welded places) -> [skin triangles, kit triangles]
	var kit: Array = []
	for s in mi.mesh.get_surface_count():
		var nm: String = mi.mesh.surface_get_material(s).resource_name
		var cloth: bool = nm.begins_with("MH_Top") or nm.begins_with("MH_Trim") or nm.begins_with("MH_Trunks")
		if nm != "MH_Skin_Body" and not cloth:
			continue
		var arr: Array = mi.mesh.surface_get_arrays(s)
		var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
		for t in range(0, idx.size(), 3):
			var tri := []
			for c in 3:
				var pair := [_key(v[idx[t + c]]), _key(v[idx[t + (c + 1) % 3]])]
				pair.sort()
				if not uses.has(pair):
					uses[pair] = [0, 0]
				uses[pair][int(cloth)] += 1
				tri.append(pair)
			if cloth:
				kit.append(tri)
	var lone := 0
	for tri in kit:
		var on_rim := 0
		var on_skin := 0
		for e in tri:
			on_rim += int(uses[e][0] == 0 and uses[e][1] == 1)
			on_skin += int(uses[e][0] > 0)
		lone += int(on_rim == 1 and on_skin == 2)
	return lone


func _staff() -> void:
	var raw := _load("mh_staff_coach", false)
	var fixed := _load("mh_staff_coach", true)
	var before := _head_under_shirt(raw)
	var after := _head_under_shirt(fixed)
	_check(before >= 400, "the ruler sees the coach's fault: %d head vertices lie under his tee as exported" % before)
	# what stays is the ring tucked under the collar (ClothMask.TUCK): cut at the rim, a dark gap showed round the neck
	_check(after * 2 <= before, "the game draws less than half of that (%d): only the ring tucked under his collar" % after)
	var h0 := _surface(raw, "MH_Skin_Head")
	var h1 := _surface(fixed, "MH_Skin_Head")
	var v0: int = ((h0[0] as MeshInstance3D).mesh.surface_get_arrays(h0[1])[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	var v1: int = ((h1[0] as MeshInstance3D).mesh.surface_get_arrays(h1[1])[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	_check(v0 == v1, "the head keeps every vertex (only covered triangles go): %d = %d" % [v0, v1])
	_check(raw.find_child("StaffCollar", true, false) == null, "the exported coach has no collar")
	var collar := fixed.find_child("StaffCollar", true, false) as MeshInstance3D
	_check(collar != null and collar.mesh.get_surface_count() == 1, "the coach's tee has a collar rib")
	if collar != null:
		_check(collar.skin != null and collar.mesh.surface_get_material(0).resource_name == "Staff_Shirt",
			"the collar is skinned and wears the shirt's own material")
		CornerCrew._shirt(fixed, Color(0.9, 0.1, 0.1))
		var mat := collar.get_active_material(0) as BaseMaterial3D
		_check(mat != null and mat.albedo_color.is_equal_approx(Color(0.9, 0.1, 0.1)), "painting the shirt paints its collar")
		# The collar moves with the neck: the exported tee's collar band carried no head or neck weight at all, so his
		# neck left it when the corner's look turned his head (the close-up's hard line).
		var w0 := _neck_share(raw, _surface(raw, "Staff_Shirt"), 0.04)
		var w1 := _neck_share(fixed, [collar, 0], 10.0)
		_check(w0 < 0.02, "the ruler sees it: the exported tee's collar band has %.2f of its weight on the head and neck" % w0)
		_check(w1 > 0.15, "the collar rib moves with his neck (%.2f of its weight on the head and neck)" % w1)
		# S495 (the coach's close-up: the rim tore off the rib in shards, the neck rolled over it): rib, shirt rim and
		# the neck skin on the line carry one set of weights, so no pose can part them.
		var gaps := _collar_gaps(fixed, collar)
		_check(float(gaps[0]) < 0.03, "the rib and the shirt's rim under it share their weights (worst difference on a joint %.3f)" % gaps[0])
		_check(float(gaps[1]) < 0.08, "... and so does the neck skin beside the rib (worst difference %.3f)" % gaps[1])
		var box := collar.mesh.get_aabb()
		_check(box.size.x > 0.08 and box.size.x < 0.3 and box.size.y < 0.15, "the collar is a ring round a neck (%.2f x %.2f x %.2f m)" % [box.size.x, box.size.y, box.size.z])
	raw.free()
	fixed.free()


## Groups of connected MH_Skin_Body triangles smaller than 40 that touch a kit vertex.
func _small_islands(body: Node) -> int:
	var skin := _surface(body, "MH_Skin_Body")
	var mi := skin[0] as MeshInstance3D
	var kit := {}
	for s in mi.mesh.get_surface_count():
		var mat := mi.mesh.surface_get_material(s)
		if mat != null and KIT.any(func(c): return mat.resource_name.begins_with(c)):
			for p in mi.mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]:
				kit[_key(p)] = true
	var arr: Array = mi.mesh.surface_get_arrays(skin[1])
	var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
	var nt := idx.size() / 3
	var par := PackedInt32Array()
	par.resize(nt)
	for t in nt:
		par[t] = t
	var first := {}
	for t in nt:
		for c in 3:
			var k := _key(v[idx[t * 3 + c]])
			if first.has(k):
				var a := _find(par, t)
				var b := _find(par, int(first[k]))
				if a != b:
					par[a] = b
			else:
				first[k] = t
	var size := {}
	var on_kit := {}
	for t in nt:
		var r := _find(par, t)
		size[r] = int(size.get(r, 0)) + 1
		for c in 3:
			if kit.has(_key(v[idx[t * 3 + c]])):
				on_kit[r] = true
	var n := 0
	for r in size:
		if int(size[r]) < 40 and on_kit.has(r):
			n += 1
	return n


static func _find(par: PackedInt32Array, i: int) -> int:
	while par[i] != i:
		par[i] = par[par[i]]
		i = par[i]
	return i


func _islands() -> void:
	var raw := _load("mh_boxer_14", false)
	var fixed := _load("mh_boxer_14", true)
	var before := _small_islands(raw)
	var after := _small_islands(fixed)
	_check(before >= 1, "the ruler sees Priya's fault: %d skin islands in her kit as exported" % before)
	_check(after == 0, "no skin island is left in Priya's kit (%d)" % after)
	raw.free()
	fixed.free()


## The skin/kit border of a boxer: [mean distance of a border vertex off the line between its two border neighbours (m),
## kit vertices on a skin vertex (within 0.8 mm), how many of those carry other weights (> 1 % on any bone), how many
## are not on the same spot as their twin (a hairline crack)].
func _border_of(body: Node) -> Array:
	var skin := _surface(body, "MH_Skin_Body")
	var mi := skin[0] as MeshInstance3D
	var ids := {}
	var pos: Array = []
	var skin_e := {}
	var kit_e := {}
	var skin_w := {}
	var kit_w: Array = []
	for s in mi.mesh.get_surface_count():
		var mat := mi.mesh.surface_get_material(s)
		var kit: bool = mat != null and KIT.any(func(c): return mat.resource_name.begins_with(c))
		if s != int(skin[1]) and not kit:
			continue
		var arr: Array = mi.mesh.surface_get_arrays(s)
		var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
		var bo: PackedInt32Array = arr[Mesh.ARRAY_BONES]
		var we: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
		var per: int = bo.size() / v.size()
		for i in v.size():
			var bw := {}
			for c in per:
				if we[i * per + c] > 0.0:
					bw[bo[i * per + c]] = float(bw.get(bo[i * per + c], 0.0)) + we[i * per + c]
			if kit:
				kit_w.append([v[i], bw])
			else:
				var cell := Vector3i((v[i] / 0.001).floor())
				if not skin_w.has(cell):
					skin_w[cell] = []
				skin_w[cell].append([v[i], bw])
		var edges: Dictionary = kit_e if kit else skin_e
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
				edges[mini(a, b) * 1000003 + maxi(a, b)] = true
	var near := {}
	for e in skin_e:
		if kit_e.has(e):
			var a := int(e) / 1000003
			var b := int(e) % 1000003
			for pr in [[a, b], [b, a]]:
				if not near.has(pr[0]):
					near[pr[0]] = []
				near[pr[0]].append(pr[1])
	var off := 0.0
	var count := 0
	for id in near:
		if (near[id] as Array).size() == 2:
			off += ((pos[id] as Vector3) - ((pos[near[id][0]] as Vector3) + (pos[near[id][1]] as Vector3)) * 0.5).length()
			count += 1
	var on_skin := 0
	var differ := 0
	var apart := 0
	for kw in kit_w:
		# its skin twin: the nearest skin vertex within 0.8 mm (the kit's copies are not quite on the skin's, S394)
		var b: Variant = null
		var best := 0.0008
		var cell := Vector3i(((kw[0] as Vector3) / 0.001).floor())
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				for z in [-1, 0, 1]:
					for e in skin_w.get(cell + Vector3i(x, y, z), []):
						var d: float = (e[0] as Vector3).distance_to(kw[0])
						if d < best:
							best = d
							b = e[1]
		if b == null:
			continue
		on_skin += 1
		if best > 0.00005:
			apart += 1
		var a: Dictionary = kw[1]
		var gap := 0.0
		for k in a:
			gap = maxf(gap, absf(float(a[k]) - float((b as Dictionary).get(k, 0.0))))
		for k in (b as Dictionary):
			gap = maxf(gap, absf(float(b[k]) - float(a.get(k, 0.0))))
		if gap > 0.01:
			differ += 1
	return [off / maxf(1.0, count), on_skin, differ, apart]


func _border() -> void:
	var raw := _load("mh_boxer_11", false)
	var fixed := _load("mh_boxer_11", true)
	var b0 := _border_of(raw)
	var b1 := _border_of(fixed)
	_check(float(b0[0]) > 0.004, "the ruler sees Lucy's staircase: her kit border sits %.1f mm off a straight line as exported" % (float(b0[0]) * 1000.0))
	_check(float(b1[0]) < float(b0[0]) * 0.7, "Lucy's kit border is a smoother line in the game (%.1f mm, was %.1f)" % [float(b1[0]) * 1000.0, float(b0[0]) * 1000.0])
	# The kit sits exactly on its skin twins with the same weights as exported (a seat's probe read 48 "mismatches": it had
	# compared the singlet to the HEAD mesh, whose ring lies on it by design). The slide must keep it so.
	_check(int(b0[1]) >= 100 and int(b0[2]) == 0 and int(b0[3]) == 0, "as exported the kit is welded to the skin: %d twins, %d weighted differently, %d off the spot" % [b0[1], b0[2], b0[3]])
	_check(int(b1[1]) >= int(b0[1]) and int(b1[2]) == 0 and int(b1[3]) == 0, "... and still is after the border slides: %d twins, %d weighted differently, %d off the spot" % [b1[1], b1[2], b1[3]])
	# S495 ("the small steps at the singlet strap tips"): single kit triangles standing on the neckline beside each strap.
	var teeth0 := _lone_teeth(raw)
	var teeth1 := _lone_teeth(fixed)
	_check(teeth0 >= 4, "the ruler sees the teeth at Lucy's strap tips: %d lone kit triangles on her neckline as exported" % teeth0)
	_check(teeth1 == 0, "no lone kit triangle stands on her neckline in the game (%d)" % teeth1)
	var h0 := _surface(raw, "MH_Skin_Head")
	var h1 := _surface(fixed, "MH_Skin_Head")
	var t0: int = ((h0[0] as MeshInstance3D).mesh.surface_get_arrays(h0[1])[Mesh.ARRAY_INDEX] as PackedInt32Array).size()
	var t1: int = ((h1[0] as MeshInstance3D).mesh.surface_get_arrays(h1[1])[Mesh.ARRAY_INDEX] as PackedInt32Array).size()
	_check(t0 == t1, "a boxer's head mesh is untouched (its arc is the singlet's neckline): %d = %d" % [t0 / 3, t1 / 3])
	_check(fixed.find_child("StaffCollar", true, false) == null, "a boxer gets no collar")
	raw.free()
	fixed.free()
