extends RefCounted
## BODYLOOK1 (S492, the operator on the S490 build: the coach's "terrible neck blending", the fighters' "shoulders look
## weird", "sometimes you can see through them (they seem like arts poorly stitched together)"). Three mesh faults the
## MetaHuman bodies carry, fixed once at load (tools/bodylook_*.gd measure each):
##
## 1. STAFF: the head mesh runs down the neck onto the collarbones. Under a staff tee ~700 of its vertices lie inside the
##    shirt, 42 within 3 mm of it: as the coach moves they poke through the collar in patches. UE hides covered skin with
##    a body mask; so do we: a skin triangle whose three corners all lie under the outfit is dropped, and the
##    ring of covered skin that stays drawn sits 1 cm inside the collar (no vertex is removed). The line where the neck goes under the shirt is handed to StaffCollar (a rib).
##    NOT on a boxer: there the head's arc IS the singlet's neckline (the body has its neck hole under it).
## 2. BOXERS 14 and 23 (Priya Nair is 14) carry islands of 2-6 skin triangles inside the trunks at the hips: a
##    skin-coloured hole in her shorts. A small skin island that borders cloth becomes that cloth.
## 3. BOXERS: the kit is the body's own triangles painted, so the border between skin and singlet runs along triangle
##    edges - a staircase with ~2 cm teeth around each arm hole. The border's vertices slide onto a smooth line (Taubin
##    smoothing along the border, so the loop does not shrink; every copy of a vertex moves the same, no triangle folds).
##   apply(fighter) -> {"head_dropped", "body_dropped", "island_tris", "edge_moved", "collar": PackedVector3Array}

const CELL := 0.03             # grid for the cloth vertices: +-1 cell covers the 4 cm normal line
const UNDER_MAX := 0.04        # a skin vertex is under cloth when cloth lies along its outward normal within 4 cm
const UNDER_MIN := -0.002      # ... or up to 2 mm behind it
const LINE_R := 0.012          # how far off the normal line a cloth vertex may sit (outfit vertices are ~1 cm apart)
const TUCK := 3                # covered skin stays this many triangle rings in from the rim (tucked under the cloth)
const TUCK_IN_M := 0.010       # ... and the head's covered skin sits this far inside its own surface (inside the collar)
const ISLAND_MAX := 40         # skin islands up to this many triangles can be stray cloth
const EDGE_PASSES := 14        # Taubin passes along a skin/cloth border
const EDGE_LAMBDA := 0.5
const EDGE_MU := -0.53
const EDGE_MAX_M := 0.014      # no border vertex slides further than this
const STAFF_CLOTH := ["Staff_Shirt", "Staff_Shorts"]
const KIT_CLOTH := ["MH_Top", "MH_Trim", "MH_Trunks"]


static func apply(fighter: Node) -> Dictionary:
	var out := {"head_dropped": 0, "body_dropped": 0, "island_tris": 0, "edge_moved": 0, "collar": PackedVector3Array()}
	var body: MeshInstance3D = null
	var kit := false
	var outfit_pts := PackedVector3Array()   # a staff outfit: head and body skin hide under it
	for m in fighter.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		if not mi.mesh is ArrayMesh:
			continue
		var to_root := _to(fighter, mi)
		for s in mi.mesh.get_surface_count():
			var name := _name(mi, s)
			if name == "MH_Skin_Head":
				body = mi
			kit = kit or KIT_CLOTH.any(func(c): return name.begins_with(c))
			if STAFF_CLOTH.any(func(c): return name.begins_with(c)):
				for p in mi.mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]:
					outfit_pts.append(to_root * p)
	if body == null:
		return out
	if kit:
		out["island_tris"] = _fill_islands(body)
		out["edge_moved"] = _smooth_edges(body)
	if not outfit_pts.is_empty():
		var line := PackedVector3Array()
		out["head_dropped"] = _mask(body, "MH_Skin_Head", _to(fighter, body), outfit_pts, line, TUCK_IN_M)
		out["body_dropped"] = _mask(body, "MH_Skin_Body", _to(fighter, body), outfit_pts, PackedVector3Array(), 0.0)
		out["collar"] = line
	return out


## Triangles of skin surface `surf` with all three corners under cloth go; the rest of the surface is untouched.
## `line` takes the middle of every edge that runs from bare skin to covered skin (fighter space): where it goes under.
static func _mask(mi: MeshInstance3D, surf: String, to_root: Transform3D, cloth_pts: PackedVector3Array, line: PackedVector3Array, tuck_in: float) -> int:
	var grid := {}
	var lo := Vector3(INF, INF, INF)
	var hi := -lo
	for p in cloth_pts:
		var k := Vector3i((p / CELL).floor())
		if not grid.has(k):
			grid[k] = PackedVector3Array()
		grid[k].append(p)
		lo = lo.min(p)
		hi = hi.max(p)
	lo -= Vector3.ONE * UNDER_MAX
	hi += Vector3.ONE * UNDER_MAX
	var s := _surface(mi, surf)
	if s < 0:
		return 0
	var arrays: Array = mi.mesh.surface_get_arrays(s)
	var v: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var nr: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
	var basis := to_root.basis
	var under := PackedByteArray()
	under.resize(v.size())
	for i in v.size():
		var p := to_root * v[i]
		if p.x < lo.x or p.y < lo.y or p.z < lo.z or p.x > hi.x or p.y > hi.y or p.z > hi.z:
			continue
		if _under(grid, p, (basis * nr[i]).normalized()):
			under[i] = 1
	var idx: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
	for t in range(0, idx.size(), 3):
		for c in 3:
			var i0 := idx[t + c]
			var i1 := idx[t + (c + 1) % 3]
			if under[i0] != under[i1]:
				line.append(to_root * ((v[i0] + v[i1]) * 0.5))
	# ... and what stays drawn of the covered skin sits INSIDE the cloth: when the coach leans his head forward his neck
	# slid out over the collar (the corner close-up kept its hard line). Every covered vertex steps in along its normal.
	var sunk := false
	if tuck_in > 0.0:
		for i in v.size():
			if under[i] == 1:
				v[i] -= nr[i] * tuck_in
				sunk = true
	# The skin runs on a little way under the cloth (cut AT the rim, a dark gap showed between collar and neck): a vertex
	# beside bare skin counts as bare, TUCK rings deep. Copies of a vertex along a UV seam go together (welded places).
	for ring in TUCK:
		var bare := {}
		for t in range(0, idx.size(), 3):
			if under[idx[t]] == 0 or under[idx[t + 1]] == 0 or under[idx[t + 2]] == 0:
				for c in 3:
					bare[_key(v[idx[t + c]])] = true
		for i in v.size():
			if under[i] == 1 and bare.has(_key(v[i])):
				under[i] = 0
	var keep := PackedInt32Array()
	var dropped := 0
	for t in range(0, idx.size(), 3):
		if under[idx[t]] == 1 and under[idx[t + 1]] == 1 and under[idx[t + 2]] == 1:
			dropped += 1
			continue
		keep.append(idx[t])
		keep.append(idx[t + 1])
		keep.append(idx[t + 2])
	if dropped == 0:
		return 0
	_rebuild(mi, {s: keep}, {}, {s: v} if sunk else {})
	return dropped


static func _under(grid: Dictionary, p: Vector3, nrm: Vector3) -> bool:
	var k := Vector3i((p / CELL).floor())
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			for dz in [-1, 0, 1]:
				var cell: Variant = grid.get(k + Vector3i(dx, dy, dz))
				if cell == null:
					continue
				for c in cell:
					var d: Vector3 = c - p
					var along := d.dot(nrm)
					if along > UNDER_MIN and along < UNDER_MAX and (d - nrm * along).length() < LINE_R:
						return true
	return false


## Small groups of MH_Skin_Body triangles that border a cloth surface move into that surface.
static func _fill_islands(mi: MeshInstance3D) -> int:
	var skin_s := _surface(mi, "MH_Skin_Body")
	if skin_s < 0:
		return 0
	var keyed := {}   # welded position -> surface index, for every kit surface
	for s in mi.mesh.get_surface_count():
		if KIT_CLOTH.any(func(c): return _name(mi, s).begins_with(c)):
			for p in mi.mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]:
				keyed[_key(p)] = s
	if keyed.is_empty():
		return 0
	var arrays: Array = mi.mesh.surface_get_arrays(skin_s)
	var v: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var idx: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
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
	var groups := {}
	for t in nt:
		var r := _find(par, t)
		if not groups.has(r):
			groups[r] = []
		groups[r].append(t)
	var move := {}   # target surface -> [triangles of the skin surface]
	for r in groups:
		var g: Array = groups[r]
		if g.size() > ISLAND_MAX:
			continue
		var target := -1   # the cloth surface it borders (an island bordering no cloth is a real part: left alone)
		for t in g:
			for c in 3:
				var k := _key(v[idx[t * 3 + c]])
				if keyed.has(k) and target < 0:
					target = int(keyed[k])
		if target >= 0:
			if not move.has(target):
				move[target] = []
			move[target].append_array(g)
	if move.is_empty():
		return 0
	var moved := {}
	for target in move:
		for t in move[target]:
			moved[t] = true
	var keep := PackedInt32Array()
	for t in nt:
		if not moved.has(t):
			keep.append_array([idx[t * 3], idx[t * 3 + 1], idx[t * 3 + 2]])
	_rebuild(mi, {skin_s: keep}, {"from": skin_s, "to": move}, {})
	return moved.size()


## The border between MH_Skin_Body and the kit painted on it, slid onto a smooth line. Returns the vertices moved (welded).
static func _smooth_edges(mi: MeshInstance3D) -> int:
	var skin_s := _surface(mi, "MH_Skin_Body")
	if skin_s < 0:
		return 0
	var ids := {}                       # welded position -> id
	var pos: Array = []                 # id -> Vector3
	var tris: Array = []                # [a, b, c] ids, every skin and kit triangle
	var skin_edges := {}                # edge key -> uses by skin triangles
	var cloth_edges := {}
	var surf_ids := {}                  # surface -> PackedInt32Array (vertex -> id)
	for s in mi.mesh.get_surface_count():
		var cloth: bool = KIT_CLOTH.any(func(c): return _name(mi, s).begins_with(c))
		if s != skin_s and not cloth:
			continue
		var arr: Array = mi.mesh.surface_get_arrays(s)
		var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
		var vid := PackedInt32Array()
		vid.resize(v.size())
		for i in v.size():
			var k := _key(v[i])
			if not ids.has(k):
				ids[k] = pos.size()
				pos.append(v[i])
			vid[i] = ids[k]
		surf_ids[s] = vid
		var edges: Dictionary = cloth_edges if cloth else skin_edges
		for t in range(0, idx.size(), 3):
			var tri := [vid[idx[t]], vid[idx[t + 1]], vid[idx[t + 2]]]
			tris.append(tri)
			for c in 3:
				var a: int = tri[c]
				var b: int = tri[(c + 1) % 3]
				var e := mini(a, b) * 1000003 + maxi(a, b)
				edges[e] = int(edges.get(e, 0)) + 1
	var near := {}                      # border id -> its border neighbours
	for e in skin_edges:
		if not cloth_edges.has(e):
			continue
		var a := int(e) / 1000003
		var b := int(e) % 1000003
		for pair in [[a, b], [b, a]]:
			if not near.has(pair[0]):
				near[pair[0]] = []
			near[pair[0]].append(pair[1])
	if near.is_empty():
		return 0
	# The kit's own open rim is the body's neck hole, hidden under the head mesh's arc. A border vertex that is ON that
	# rim stays put: slid, it took the rim out from under the arc and the hole showed as a dark line at the strap's top.
	# (Only those: the straps are 3 cm wide, a wider guard froze the staircase along the whole strap.)
	var pinned := {}
	for e in cloth_edges:
		if int(cloth_edges[e]) == 1 and not skin_edges.has(e):
			pinned[int(e) / 1000003] = true
			pinned[int(e) % 1000003] = true
	var now := {}
	for id in near:
		now[id] = pos[id]
	for pass_i in EDGE_PASSES * 2:
		var f := EDGE_LAMBDA if pass_i % 2 == 0 else EDGE_MU
		var nxt := {}
		for id in near:
			var nb: Array = near[id]
			if nb.size() != 2 or pinned.has(id):
				nxt[id] = now[id]       # the end of a border, a three-way join, the neck hole's edge: stays put
				continue
			nxt[id] = (now[id] as Vector3) + (((now[nb[0]] as Vector3) + (now[nb[1]] as Vector3)) * 0.5 - now[id]) * f
		now = nxt
	var move := {}                      # id -> Vector3 offset
	for id in near:
		var d: Vector3 = (now[id] as Vector3) - (pos[id] as Vector3)
		if d.length() > EDGE_MAX_M:
			d = d.normalized() * EDGE_MAX_M
		if d.length() > 0.0002:
			move[id] = d
	# no triangle may fold over: a triangle that would turn (or nearly) halves the slide of its corners
	for attempt in 5:
		var bad := {}
		for tri in tris:
			if not (move.has(tri[0]) or move.has(tri[1]) or move.has(tri[2])):
				continue
			var p0: Vector3 = pos[tri[0]]
			var p1: Vector3 = pos[tri[1]]
			var p2: Vector3 = pos[tri[2]]
			var n0 := (p1 - p0).cross(p2 - p0)
			var q0: Vector3 = p0 + (move.get(tri[0], Vector3.ZERO) as Vector3)
			var q1: Vector3 = p1 + (move.get(tri[1], Vector3.ZERO) as Vector3)
			var q2: Vector3 = p2 + (move.get(tri[2], Vector3.ZERO) as Vector3)
			var n1 := (q1 - q0).cross(q2 - q0)
			if n1.dot(n0) < 0.25 * n0.length_squared() or n1.length() < 0.2 * n0.length():
				for c in 3:
					bad[tri[c]] = true
		if bad.is_empty():
			break
		for id in bad:
			if move.has(id):
				move[id] = (move[id] as Vector3) * 0.5
	# (The kit's vertices sit exactly on their skin twins with the same bone weights - tools/bodylook_edge.gd: 148 of 148
	# on Lucy, 0 off the spot, 0 weighted differently - so the border needs no weld, only this slide. Every copy moves alike.)
	var verts := {}
	for s in surf_ids:
		var arr: Array = mi.mesh.surface_get_arrays(s)
		var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var vid: PackedInt32Array = surf_ids[s]
		var changed := false
		for i in v.size():
			if move.has(vid[i]):
				v[i] += move[vid[i]]
				changed = true
		if changed:
			verts[s] = v
	if verts.is_empty():
		return 0
	_rebuild(mi, {}, {}, verts)
	return move.size()


## The mesh again with new index lists (`indices`: surface -> PackedInt32Array), in `take` skin triangles copied onto
## cloth surfaces (vertices, attributes and blend shapes copied), and new places (`verts`: surface -> PackedVector3Array;
## blend shapes that store whole positions slide with them; `attrs`: surface -> {array: values} replaces whole arrays).
## Materials and overrides stay.
static func _rebuild(mi: MeshInstance3D, indices: Dictionary, take: Dictionary, verts: Dictionary, attrs: Dictionary = {}) -> void:
	var src := mi.mesh as ArrayMesh
	var out := ArrayMesh.new()
	out.blend_shape_mode = src.blend_shape_mode
	for b in src.get_blend_shape_count():
		out.add_blend_shape(src.get_blend_shape_name(b))
	var from_arr: Array = src.surface_get_arrays(int(take["from"])) if not take.is_empty() else []
	var from_bs: Array = src.surface_get_blend_shape_arrays(int(take["from"])) if not take.is_empty() else []
	var over: Array = []
	for s in src.get_surface_count():
		over.append(mi.get_surface_override_material(s))
		var arr: Array = src.surface_get_arrays(s)
		var bs: Array = src.surface_get_blend_shape_arrays(s)
		if verts.has(s):
			var old: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
			var new: PackedVector3Array = verts[s]
			if src.blend_shape_mode == Mesh.BLEND_SHAPE_MODE_NORMALIZED:
				for b in bs.size():
					var bv: PackedVector3Array = bs[b][Mesh.ARRAY_VERTEX]
					for i in bv.size():
						bv[i] += new[i] - old[i]
					bs[b][Mesh.ARRAY_VERTEX] = bv
			arr[Mesh.ARRAY_VERTEX] = new
		for a in attrs.get(s, {}):
			arr[a] = attrs[s][a]
		if indices.has(s):
			arr[Mesh.ARRAY_INDEX] = indices[s]
		if not take.is_empty() and (take["to"] as Dictionary).has(s):
			var fidx: PackedInt32Array = from_arr[Mesh.ARRAY_INDEX]
			var order := PackedInt32Array()
			for t in take["to"][s]:
				order.append_array([fidx[t * 3], fidx[t * 3 + 1], fidx[t * 3 + 2]])
			var n_from: int = (from_arr[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
			_append(arr, from_arr, order, n_from)
			for b in bs.size():
				_append(bs[b], from_bs[b], order, n_from)
		out.add_surface_from_arrays(src.surface_get_primitive_type(s), arr, bs, {},
			src.surface_get_format(s) & Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS)
		out.surface_set_material(s, src.surface_get_material(s))
		out.surface_set_name(s, src.surface_get_name(s))
	out.resource_name = src.resource_name
	mi.mesh = out
	for s in over.size():
		if over[s] != null:
			mi.set_surface_override_material(s, over[s])


## Copies the vertices in `order` (indices into `from`, three per triangle) onto `to`: every per-vertex array, then (when
## `to` has an index list) the new triangles.
static func _append(to: Array, from: Array, order: PackedInt32Array, n_from: int) -> void:
	var base: int = (to[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	for a in Mesh.ARRAY_INDEX:
		if a >= from.size() or from[a] == null or a >= to.size() or to[a] == null:
			continue
		var per: int = from[a].size() / n_from
		var dst: Variant = to[a]
		for o in order:
			for c in per:
				dst.append(from[a][o * per + c])
		to[a] = dst
	if to.size() > Mesh.ARRAY_INDEX and to[Mesh.ARRAY_INDEX] != null:
		var ti: PackedInt32Array = to[Mesh.ARRAY_INDEX]
		for i in order.size():
			ti.append(base + i)
		to[Mesh.ARRAY_INDEX] = ti


static func _surface(mi: MeshInstance3D, name: String) -> int:
	for s in mi.mesh.get_surface_count():
		if _name(mi, s) == name:
			return s
	return -1


static func _name(mi: MeshInstance3D, s: int) -> String:
	var m := mi.mesh.surface_get_material(s)
	return m.resource_name if m != null else ""


static func _to(root: Node, n: Node) -> Transform3D:
	var t := Transform3D.IDENTITY
	var node: Node = n
	while node != root and node != null:
		if node is Node3D:
			t = (node as Node3D).transform * t
		node = node.get_parent()
	return t


static func _key(p: Vector3) -> Vector3i:
	return Vector3i(roundi(p.x * 10000.0), roundi(p.y * 10000.0), roundi(p.z * 10000.0))


static func _find(par: PackedInt32Array, i: int) -> int:
	while par[i] != i:
		par[i] = par[par[i]]
		i = par[i]
	return i
