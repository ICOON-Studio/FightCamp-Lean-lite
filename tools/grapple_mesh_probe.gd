extends RefCounted
## S399 GRAPPLEFIX1 "bodies merging" (every blind critic, every film): the capsule model (GrappleDrawn.parts) is FATTER than our
## women at rest (tools/grapple_mesh_radii.gd: trunk p90 0.11 vs 0.12, thigh 0.09-0.10 vs 0.10), yet critics see one body inside
## the other where it reads clear. This measures the MESH: a ~2.5 cm voxel subsample of each woman's MH_Body skinned on the CPU
## from the bones as drawn (captured on skeleton_updated), and every vertex of one woman tested against the other's nearest
## vertex and its normal: (a - b) . n_b < 0 = inside. Each vertex carries the capsule it belongs to at rest, so a hit names the
## part ("red thighL in blue trunk").
##   probe := Probe.new(); probe.setup(skel)          once, at rest
##   probe.capture(skel)                              inside skeleton_updated (the drawn pose only exists there)
##   Probe.inside(p_red, p_blue) -> {key: depth}      per frame; key "red.thighL>blue.trunk", depth = 3rd deepest vertex, metres

const GD := preload("res://scripts/grapple/GrappleDrawn.gd")
const VOXEL_M := 0.025
const CELL_M := 0.05
const NEAR_M := 0.09   # a vertex farther than this from every vertex of the other is clear
const MIN_HITS := 3    # a part counts only when at least this many of its vertices are in (one stray vertex is noise)

var rest := PackedVector3Array()
var rest_n := PackedVector3Array()
var vb := PackedInt32Array()     # per vertex 4 bind indices
var vw := PackedFloat32Array()   # per vertex 4 weights
var label := PackedStringArray()
var bind_bone := PackedInt32Array()
var bind_pose: Array = []
var pos := PackedVector3Array()
var nrm := PackedVector3Array()
var _mi_inv := Transform3D.IDENTITY
var ready := false


func setup(skel: Skeleton3D) -> void:
	var mi: MeshInstance3D = null
	for m in skel.find_children("*", "MeshInstance3D", true, false):
		if str(m.name) == "MH_Body" and (m as MeshInstance3D).skin != null:
			mi = m
	if mi == null:
		return
	var skin: Skin = mi.skin
	for i in skin.get_bind_count():
		var b := skin.get_bind_bone(i)
		if b < 0:
			b = skel.find_bone(skin.get_bind_name(i))
		bind_bone.append(b)
		bind_pose.append(skin.get_bind_pose(i))
	# The capsules at rest, to label each vertex.
	var d := {}
	for n in GD.BONES:
		var i := skel.find_bone(n)
		if i >= 0:
			d[n] = skel.global_transform * skel.get_bone_global_rest(i).origin
	d["Face"] = skel.global_transform * (skel.get_bone_global_rest(skel.find_bone("Head")) * GD.face_local(skel))
	var caps: Array = GD.parts(d)["all"]
	var seen := {}
	for sidx in mi.mesh.get_surface_count():
		var arr := mi.mesh.surface_get_arrays(sidx)
		var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var norms: PackedVector3Array = arr[Mesh.ARRAY_NORMAL]
		var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES]
		var wts: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
		if bones.is_empty() or verts.is_empty():
			continue
		var per := bones.size() / verts.size()
		for v in verts.size():
			var wp := mi.global_transform * verts[v]
			var key := Vector3i((wp / VOXEL_M).floor())
			if seen.has(key):
				continue
			seen[key] = true
			# The four heaviest weights, renormalised.
			var pairs: Array = []
			for q in per:
				pairs.append([wts[v * per + q], bones[v * per + q]])
			pairs.sort_custom(func(a, b): return a[0] > b[0])
			var tot := 0.0
			for q in mini(4, pairs.size()):
				tot += float(pairs[q][0])
			for q in 4:
				if q < pairs.size() and tot > 0.0:
					vb.append(int(pairs[q][1]))
					vw.append(float(pairs[q][0]) / tot)
				else:
					vb.append(0)
					vw.append(0.0)
			rest.append(verts[v])
			rest_n.append(norms[v] if v < norms.size() else Vector3.UP)
			var best := ""
			var bs := INF
			for c in caps:
				var dd := wp.distance_to(Geometry3D.get_closest_point_to_segment(wp, c[1], c[2])) - float(c[3])
				if dd < bs:
					bs = dd
					best = str(c[0])
			# Past the wrist it is the hand (a grip on purpose presses there): its own name.
			if best.begins_with("forearm"):
				for c in caps:
					if str(c[0]) == best:
						var ab: Vector3 = (c[2] as Vector3) - (c[1] as Vector3)
						if (wp - (c[1] as Vector3)).dot(ab) > ab.length_squared():
							best = best.replace("forearm", "hand")
			label.append(best)
	_mi_inv = skel.global_transform.affine_inverse() * mi.global_transform
	ready = true


## Skins the subsample with the bones as they are drawn right now (call inside skeleton_updated).
func capture(skel: Skeleton3D) -> void:
	if not ready:
		return
	var gt := skel.global_transform
	var mats: Array = []
	mats.resize(bind_bone.size())
	for i in bind_bone.size():
		var b := bind_bone[i]
		mats[i] = gt * (skel.get_bone_global_pose(b) if b >= 0 else Transform3D.IDENTITY) * (bind_pose[i] as Transform3D)
	var n := rest.size()
	pos.resize(n)
	nrm.resize(n)
	for v in n:
		var p := Vector3.ZERO
		var nn := Vector3.ZERO
		for q in 4:
			var w := vw[v * 4 + q]
			if w <= 0.0:
				continue
			var m: Transform3D = mats[vb[v * 4 + q]]
			p += (m * rest[v]) * w
			nn += (m.basis * rest_n[v]) * w
		pos[v] = p
		nrm[v] = nn.normalized()


## Rest check: the subsample skinned with the rest pose against the mesh as placed (metres, worst vertex).
func rest_error(skel: Skeleton3D) -> float:
	var gt := skel.global_transform
	var worst := 0.0
	for v in mini(rest.size(), 400):
		var p := Vector3.ZERO
		for q in 4:
			var w := vw[v * 4 + q]
			if w > 0.0:
				var bi := vb[v * 4 + q]
				var b := bind_bone[bi]
				p += (gt * skel.get_bone_global_rest(b) * (bind_pose[bi] as Transform3D) * rest[v]) * w
		worst = maxf(worst, p.distance_to(gt * (_mi_inv * rest[v])))
	return worst


static func _grid(pts: PackedVector3Array) -> Dictionary:
	var g := {}
	for i in pts.size():
		var k := Vector3i((pts[i] / CELL_M).floor())
		if g.has(k):
			(g[k] as Array).append(i)
		else:
			g[k] = [i]
	return g


## Both ways: each part of one woman inside the other, the 3rd deepest vertex of that part (metres) and the other's part it is in.
static func inside(a: RefCounted, b: RefCounted) -> Dictionary:
	var out := {}
	if not a.ready or not b.ready or a.pos.is_empty() or b.pos.is_empty():
		return out
	var probes := [a, b]
	var names := ["red", "blue"]
	for w in 2:
		var me: RefCounted = probes[w]
		var ot: RefCounted = probes[1 - w]
		var grid := _grid(ot.pos)
		var hits := {}
		for v in me.pos.size():
			var p: Vector3 = me.pos[v]
			var c := Vector3i((p / CELL_M).floor())
			var best := -1
			var bd := NEAR_M * NEAR_M
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					for dz in range(-1, 2):
						var cell: Variant = grid.get(c + Vector3i(dx, dy, dz))
						if cell == null:
							continue
						for i in (cell as Array):
							var dd: float = p.distance_squared_to(ot.pos[i] as Vector3)
							if dd < bd:
								bd = dd
								best = i
			if best < 0:
				continue
			var depth: float = -(p - (ot.pos[best] as Vector3)).dot(ot.nrm[best] as Vector3)
			if depth <= 0.0:
				continue
			var key: String = "%s.%s>%s.%s" % [names[w], me.label[v], names[1 - w], ot.label[best]]
			if not hits.has(key):
				hits[key] = []
			(hits[key] as Array).append(depth)
		for k in hits:
			var arr: Array = hits[k]
			if arr.size() < MIN_HITS:
				continue
			arr.sort()
			out[k] = arr[arr.size() - MIN_HITS]
	return out
