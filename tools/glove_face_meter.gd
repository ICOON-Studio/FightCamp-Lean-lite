extends RefCounted
## GLOVEFACE1 (S536, owner C447 on the red boxer's guard glove: "is the glove normal looking ?"): the ruler for a glove
## against the wearer's own face, and for the glove's own size. Read from the bodies AS DRAWN (the glove node after every
## modifier, the head bone's drawn pose handed in), never from a fix's own numbers, so it can read worse than the fix believes.
##   head_cloud(body, skel) -> {pts, nrm}: the skin the head bone and its children carry, in the head bone's frame
##   gap(head_world, cloud, glove) -> {gap, at}: metres from the glove's surface to the face, NEGATIVE = inside the face;
##       at = where on the head (head bone frame, metres). The head's skin is open at the neck: a point is inside only
##       when the nearest skin is under it along that skin's normal (RIM_SIDE_M), so a cuff beside the neck is not "in the face".
##   dims(glove) -> {length, width, depth, behind, ahead, cuff_len, cuff_open, cuff_neck, flare}: the mounted mesh, metres

const CLOUD_MAX := 9000
const GLOVE_STRIDE := 2
const HEAD_W := 0.6
const RIM_SIDE_M := 0.012


static func head_cloud(body: Node, skel: Skeleton3D) -> Dictionary:
	var head := skel.find_bone("Head")
	var pts := PackedVector3Array()
	var nrm := PackedVector3Array()
	if head < 0:
		return {"pts": pts, "nrm": nrm, "surfaces": 0}
	var carried := {}
	for b in skel.get_bone_count():
		var up := b
		while up >= 0:
			if up == head:
				carried[b] = true
				break
			up = skel.get_bone_parent(up)
	var inv := skel.get_bone_global_rest(head).affine_inverse()
	var surfaces := 0
	for pass_n in 2:   # 0: skin surfaces only; 1: any skinned surface, if no skin surface was found
		for found in body.find_children("*", "MeshInstance3D", true, false):
			var mi := found as MeshInstance3D
			if mi.skin == null or not (mi.mesh is ArrayMesh):
				continue
			var binds := {}
			for bi in mi.skin.get_bind_count():
				var nm := str(mi.skin.get_bind_name(bi))
				var bone: int = skel.find_bone(nm) if not nm.is_empty() else mi.skin.get_bind_bone(bi)
				if carried.has(bone):
					binds[bi] = true
			if binds.is_empty():
				continue
			var mesh := mi.mesh as ArrayMesh
			for s in mesh.get_surface_count():
				var mat := mesh.surface_get_material(s)
				if pass_n == 0 and (mat == null or not mat.resource_name.begins_with("MH_Skin")):
					continue
				var arr: Array = mesh.surface_get_arrays(s)
				var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
				var normals: PackedVector3Array = arr[Mesh.ARRAY_NORMAL]
				var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES]
				var weights: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
				if bones.is_empty() or normals.size() != verts.size():
					continue
				var per: int = bones.size() / verts.size()
				var took := 0
				for i in verts.size():
					var w := 0.0
					for k in per:
						if binds.has(bones[i * per + k]):
							w += weights[i * per + k]
					if w >= HEAD_W:
						pts.append(inv * verts[i])
						nrm.append((inv.basis * normals[i]).normalized())
						took += 1
				if took > 0:
					surfaces += 1
		if not pts.is_empty():
			break
	if pts.size() > CLOUD_MAX:
		var step := int(ceil(float(pts.size()) / CLOUD_MAX))
		var p2 := PackedVector3Array()
		var n2 := PackedVector3Array()
		for i in range(0, pts.size(), step):
			p2.append(pts[i])
			n2.append(nrm[i])
		pts = p2
		nrm = n2
	return {"pts": pts, "nrm": nrm, "surfaces": surfaces}


## The glove's surface against the head. head_world = the skeleton's world transform * the head bone's pose as drawn.
static func gap(head_world: Transform3D, cloud: Dictionary, glove: Node3D) -> Dictionary:
	var pts: PackedVector3Array = cloud["pts"]
	var nrm: PackedVector3Array = cloud["nrm"]
	var k := head_world.basis.y.length()
	var inv := head_world.affine_inverse()
	var gv := PackedVector3Array()
	var mid := Vector3.ZERO
	for m in glove.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var xf := inv * mi.global_transform
		for s in mi.mesh.get_surface_count():
			var v: PackedVector3Array = mi.mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]
			for i in range(0, v.size(), GLOVE_STRIDE):
				var q := xf * v[i]
				gv.append(q)
				mid += q
	if gv.is_empty() or pts.is_empty():
		return {"gap": 9.0, "at": Vector3.ZERO}
	mid /= gv.size()
	var reach := 0.0
	for q in gv:
		reach = maxf(reach, q.distance_to(mid))
	var near := PackedInt32Array()
	var lim := (reach + 0.06 / k) * (reach + 0.06 / k)
	for i in pts.size():
		if pts[i].distance_squared_to(mid) < lim:
			near.append(i)
	if near.is_empty():
		var far := 9.0
		for p in pts:
			far = minf(far, p.distance_to(mid))
		return {"gap": (far - reach) * k, "at": Vector3.ZERO}
	var best := 9.0
	var at := Vector3.ZERO
	for q in gv:
		var d2 := 1e9
		var hit := -1
		for i in near:
			var e := pts[i].distance_squared_to(q)
			if e < d2:
				d2 = e
				hit = i
		var d := sqrt(d2)
		var s := (q - pts[hit]).dot(nrm[hit])
		# Inside only when the nearest skin lies under the point along its own normal. At the cloud's open rim (the neck,
		# under the jaw) a cuff beside the neck is "behind" the rim's normal and several cm off to its side: not in the face.
		if s < 0.0 and d2 - s * s < RIM_SIDE_M * RIM_SIDE_M / (k * k) + 0.12 * s * s:
			d = -d
		if d < best:
			best = d
			at = pts[hit]
	return {"gap": best * k, "at": at * k}


## The mounted glove, in its node's frame (x across the knuckles, y wrist to knuckles, z palm to back), metres.
static func dims(glove: Node3D) -> Dictionary:
	var lo := Vector3.INF
	var hi := -Vector3.INF
	var cuff: Array = []
	var inv := glove.global_transform.affine_inverse()
	var k := glove.global_transform.basis.y.length()
	for m in glove.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var xf := inv * mi.global_transform
		for s in mi.mesh.get_surface_count():
			var arr: Array = mi.mesh.surface_get_arrays(s)
			var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
			var c: PackedColorArray = arr[Mesh.ARRAY_COLOR] if arr[Mesh.ARRAY_COLOR] != null else PackedColorArray()
			for i in v.size():
				var q := xf * v[i] * k
				lo = lo.min(q)
				hi = hi.max(q)
				if i < c.size() and c[i].r > 0.5:
					cuff.append(q)
	var out := {"length": hi.y - lo.y, "width": hi.x - lo.x, "depth": hi.z - lo.z, "behind": -lo.y, "ahead": hi.y,
		"cuff_len": 0.0, "cuff_open": 0.0, "cuff_neck": 0.0, "flare": 1.0}
	if cuff.size() > 8:
		var y0 := 9.0
		var y1 := -9.0
		for q in cuff:
			y0 = minf(y0, (q as Vector3).y)
			y1 = maxf(y1, (q as Vector3).y)
		var open := _across(cuff, y0, y0 + (y1 - y0) * 0.15)
		var neck := _across(cuff, y1 - (y1 - y0) * 0.15, y1)
		out["cuff_len"] = y1 - y0
		out["cuff_open"] = open
		out["cuff_neck"] = neck
		out["flare"] = open / maxf(neck, 1e-4)
	return out


static func _across(pts: Array, a: float, b: float) -> float:
	var lo := Vector2(9, 9)
	var hi := Vector2(-9, -9)
	for q in pts:
		var p := q as Vector3
		if p.y >= a and p.y <= b:
			lo = lo.min(Vector2(p.x, p.z))
			hi = hi.max(Vector2(p.x, p.z))
	return maxf(hi.x - lo.x, hi.y - lo.y)
