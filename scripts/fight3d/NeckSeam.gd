extends RefCounted
## BODYTEX2 (S535) the dark dashes across the collarbone and the top of the shoulder: where the head's skin meets the
## body's. The head's open rim has a vertex in the middle of every body edge (92 places against 46) and each rim kept a
## different four of the same bones, so in any pose the rims part by a millimetre and the dark behind shows through.
## weld gives the body's rim the head's extra places (its rim triangles are split) and both rims one set of bones
## and weights: the same place moved by the same bones cannot part. `-- noseamfix` = the rims as exported.
static var on := not OS.get_cmdline_user_args().has("noseamfix")
const ClothMask := preload("res://scripts/fight3d/ClothMask.gd")
const SEAM_ON_EDGE_M := 0.003    # a head rim vertex this near a body rim edge belongs on it (as exported: up to 1.7 mm off)
const SEAM_SAME_M := 0.0003      # ... and this near one of its ends is that end


## Joins the head's open rim to the body's (see above). Returns the head rim vertices joined.
static func weld(fighter: Node) -> int:
	for m in fighter.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var src := mi.mesh as ArrayMesh
		if src == null or src.get_blend_shape_count() > 0:
			continue
		var hs := -1
		var others: Array = []   # the surfaces the head can border: bare skin, and a woman's painted singlet
		for s in src.get_surface_count():
			var mat := src.surface_get_material(s)
			var nm: String = mat.resource_name if mat != null else ""
			if nm == "MH_Skin_Head":
				hs = s
			elif nm == "MH_Skin_Body" or nm == "MH_Top":
				others.append(s)
		if hs >= 0 and not others.is_empty():
			return _weld(mi, src, hs, others)
	return 0


static func _weld(mi: MeshInstance3D, src: ArrayMesh, hs: int, others: Array) -> int:
	var arr := {hs: src.surface_get_arrays(hs)}
	var top := -1e9
	for s: int in others:
		arr[s] = src.surface_get_arrays(s)
		for p in (arr[s][Mesh.ARRAY_VERTEX] as PackedVector3Array):
			top = maxf(top, p.y)
	var edges: Array = []   # the body's open edges under the neck: [surface, a, b, its triangle, where its list ended]
	for s: int in others:
		for e: Vector3i in _open_edges(arr[s], top - 0.25, 1e9):
			edges.append([s, e.x, e.y, e.z, (arr[s][Mesh.ARRAY_INDEX] as PackedInt32Array).size()])
	var h: Array = arr[hs]
	var hv: PackedVector3Array = h[Mesh.ARRAY_VERTEX]
	var rim := {}
	for e: Vector3i in _open_edges(h, -1e9, top + 0.03):
		rim[e.x] = true
		rim[e.y] = true
	var mids := {}   # edge number -> [[how far along it, head vertex], ...]
	var joined := 0
	for hi: int in rim:
		var p: Vector3 = hv[hi]
		var best := -1
		var best_d := SEAM_ON_EDGE_M
		var best_t := 0.0
		var best_len := 0.0
		for n in edges.size():
			var bv: PackedVector3Array = arr[edges[n][0]][Mesh.ARRAY_VERTEX]
			var a: Vector3 = bv[edges[n][1]]
			var ab: Vector3 = bv[edges[n][2]] - a
			var t := clampf((p - a).dot(ab) / maxf(ab.length_squared(), 1e-12), 0.0, 1.0)
			var d := p.distance_to(a + ab * t)
			if d < best_d:
				best_d = d
				best = n
				best_t = t
				best_len = ab.length()
		if best < 0:
			continue
		joined += 1
		if best_t * best_len < SEAM_SAME_M:
			_same_vertex(h, hi, arr[edges[best][0]], int(edges[best][1]))
		elif (1.0 - best_t) * best_len < SEAM_SAME_M:
			_same_vertex(h, hi, arr[edges[best][0]], int(edges[best][2]))
		else:
			if not mids.has(best):
				mids[best] = []
			mids[best].append([best_t, hi, best_len])
	for n: int in mids:
		var e: Array = edges[n]
		var b: Array = arr[e[0]]
		var list: Array = mids[n]
		list.sort_custom(func(x: Array, y: Array) -> bool: return float(x[0]) < float(y[0]))
		var chain: Array = [int(e[1])]
		var last_t := -1.0
		var last_v := -1
		for it: Array in list:
			if last_v < 0 or (float(it[0]) - last_t) * float(it[2]) > SEAM_SAME_M:   # two head copies of one place share it
				last_t = float(it[0])
				last_v = _add_between(b, int(e[1]), int(e[2]), last_t)
				chain.append(last_v)
			_same_vertex(h, int(it[1]), b, last_v)
		chain.append(int(e[2]))
		_split(b, chain, int(e[3]), int(e[4]))
	if joined > 0:
		var attrs := {}
		for s: int in arr:
			attrs[s] = {}
			for a in (arr[s] as Array).size():
				if arr[s][a] != null:
					attrs[s][a] = arr[s][a]
		ClothMask._rebuild(mi, {}, {}, {}, attrs)
	return joined


## The open edges (used by one triangle, places welded) with an end between lo and hi: Vector3i(a, b, triangle start).
static func _open_edges(arr: Array, lo: float, hi: float) -> Array:
	var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
	var place := {}
	var seen := {}
	for t in range(0, idx.size(), 3):
		var near := false
		for c in 3:
			var y := v[idx[t + c]].y
			near = near or (y > lo and y < hi)
		if not near:
			continue
		for c in 3:
			var a := idx[t + c]
			var b := idx[t + (c + 1) % 3]
			var ka := Vector3i((v[a] * 1e5).round())
			var kb := Vector3i((v[b] * 1e5).round())
			if not place.has(ka):
				place[ka] = place.size()
			if not place.has(kb):
				place[kb] = place.size()
			var pa: int = place[ka]
			var pb: int = place[kb]
			var key := mini(pa, pb) * 1000003 + maxi(pa, pb)
			if seen.has(key):
				seen[key][0] += 1
			else:
				seen[key] = [1, Vector3i(a, b, t)]
	var out: Array = []
	for key: int in seen:
		var e: Vector3i = seen[key][1]
		if int(seen[key][0]) == 1 and ((v[e.x].y > lo and v[e.x].y < hi) or (v[e.y].y > lo and v[e.y].y < hi)):
			out.append(e)
	return out


## The k heaviest bones of {bone: weight}, weights summing to 1: [bones, weights], each k long.
static func _heaviest(sum: Dictionary, k: int) -> Array:
	var keys: Array = sum.keys()
	keys.sort_custom(func(x: int, y: int) -> bool: return float(sum[x]) > float(sum[y]) or (float(sum[x]) == float(sum[y]) and x < y))
	var total := 0.0
	for c in mini(k, keys.size()):
		total += float(sum[keys[c]])
	var bones: Array = []
	var weights: Array = []
	for c in k:
		bones.append(int(keys[c]) if c < keys.size() else 0)
		weights.append(float(sum[keys[c]]) / maxf(total, 1e-9) if c < keys.size() else 0.0)
	return [bones, weights]


## Head vertex hi becomes the body's vertex bi: its place, its normal, its bones and weights.
static func _same_vertex(h: Array, hi: int, b: Array, bi: int) -> void:
	for a in [Mesh.ARRAY_VERTEX, Mesh.ARRAY_NORMAL]:
		if h[a] != null and b[a] != null:
			var dst: PackedVector3Array = h[a]
			dst[hi] = (b[a] as PackedVector3Array)[bi]
			h[a] = dst
	if h[Mesh.ARRAY_BONES] == null or b[Mesh.ARRAY_BONES] == null:
		return
	var hb: PackedInt32Array = h[Mesh.ARRAY_BONES]
	var hw: Variant = h[Mesh.ARRAY_WEIGHTS]
	var bb: PackedInt32Array = b[Mesh.ARRAY_BONES]
	var bw: Variant = b[Mesh.ARRAY_WEIGHTS]
	var kh: int = hb.size() / (h[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	var kb: int = bb.size() / (b[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	var sum := {}
	for c in kb:
		if float(bw[bi * kb + c]) > 0.0:
			sum[bb[bi * kb + c]] = float(sum.get(bb[bi * kb + c], 0.0)) + float(bw[bi * kb + c])
	var pack: Array = _heaviest(sum, kh)
	for c in kh:
		hb[hi * kh + c] = int(pack[0][c]) if kh != kb else bb[bi * kb + c]
		hw[hi * kh + c] = float(pack[1][c]) if kh != kb else float(bw[bi * kb + c])
	h[Mesh.ARRAY_BONES] = hb
	h[Mesh.ARRAY_WEIGHTS] = hw


## A new body vertex t of the way from ia to ib (every per-vertex array; bones and weights mixed, the heaviest kept).
static func _add_between(b: Array, ia: int, ib: int, t: float) -> int:
	var n: int = (b[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	for a in Mesh.ARRAY_INDEX:
		if a >= b.size() or b[a] == null or a == Mesh.ARRAY_BONES or a == Mesh.ARRAY_WEIGHTS:
			continue
		var data: Variant = b[a]
		var per: int = int(data.size()) / n
		for c in per:
			var mixed: Variant = lerp(data[ia * per + c], data[ib * per + c], t)
			data.append((mixed as Vector3).normalized() if a == Mesh.ARRAY_NORMAL else mixed)
		b[a] = data
	if b[Mesh.ARRAY_BONES] != null:
		var bones: PackedInt32Array = b[Mesh.ARRAY_BONES]
		var weights: Variant = b[Mesh.ARRAY_WEIGHTS]
		var k: int = bones.size() / n
		var sum := {}
		for c in k:
			sum[bones[ia * k + c]] = float(sum.get(bones[ia * k + c], 0.0)) + float(weights[ia * k + c]) * (1.0 - t)
			sum[bones[ib * k + c]] = float(sum.get(bones[ib * k + c], 0.0)) + float(weights[ib * k + c]) * t
		var pack: Array = _heaviest(sum, k)
		for c in k:
			bones.append(int(pack[0][c]))
			weights.append(float(pack[1][c]))
		b[Mesh.ARRAY_BONES] = bones
		b[Mesh.ARRAY_WEIGHTS] = weights
	return n


## The body triangle on the open edge chain[0] - chain[last] becomes a fan through the chain's new vertices.
static func _split(b: Array, chain: Array, tri: int, tail: int) -> void:
	var idx: PackedInt32Array = b[Mesh.ARRAY_INDEX]
	var a: int = chain[0]
	var z: int = chain[chain.size() - 1]
	for t: int in [tri] + range(tail, idx.size(), 3):   # the triangle itself, or a piece of it an earlier split made
		for c in 3:
			var i0 := idx[t + c]
			var i1 := idx[t + (c + 1) % 3]
			var i2 := idx[t + (c + 2) % 3]
			if not ((i0 == a and i1 == z) or (i0 == z and i1 == a)):
				continue
			for j in chain.size() - 1:
				var p: int = chain[j] if i0 == a else chain[j + 1]
				var q: int = chain[j + 1] if i0 == a else chain[j]
				if j == 0:
					idx[t] = p
					idx[t + 1] = q
					idx[t + 2] = i2
				else:
					idx.append_array(PackedInt32Array([p, q, i2]))
			b[Mesh.ARRAY_INDEX] = idx
			return

