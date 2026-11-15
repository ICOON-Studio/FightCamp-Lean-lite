extends RefCounted
## BODYLOOK1 (S492, operator on the corner coach: "terrible neck blending"). A staff tee came from the Creator as a shell
## with no collar: in the coach's close-up his neck met the shirt in one bare hard line. A real crew neck has a rib band
## there. This builds it: a flat tube round the shirt's rim, beside the line where the neck goes under (ClothMask's line),
## skinned like the shirt beside it (so it rides the cloth while the neck turns inside it) and wearing the shirt's own
## material - every recolour of "Staff_Shirt" (CornerCrew._shirt, Referee._paint, FighterFace) colours it too.
## And the collar must MOVE with the neck base: the Creator tee's collar band carries no neck or head weight at all
## (tools/bodylook_skin.gd: spine_04 0.40, shoulders and clavicles the rest) while the neck skin inside it carries Head
## 0.32 - when the corner's look turned his neck, the neck left the collar and crossed the shirt in one hard line (the
## coach's close-up). Every mesh of a body shares one Skin, so each shirt vertex within FOLLOW_M of the rim takes the
## weights of the skin vertex nearest it, in full at the rim and fading out down the shirt.
##   add(fighter, line) -> the collar's MeshInstance3D, or null when the line is no closed ring (no outfit, a bare neck)

const ClothMask := preload("res://scripts/fight3d/ClothMask.gd")
const RING := 64               # points around the neck
const SIDES := 8               # points around the rib
const OUT_M := 0.009           # the rib's half width, lying on the shirt
const UP_M := 0.0065           # ... and half height
const LIFT_M := 0.002          # its middle sits this far above the rim
const MIN_FILL := 0.6          # the line must cover this share of the way round
const FOLLOW_M := 0.06         # the shirt follows the neck base this far from its rim (all the way at the rim)
const FOLLOW_FULL_M := 0.012   # ... and wholly within this


static func add(fighter: Node, line: PackedVector3Array) -> MeshInstance3D:
	if line.size() < RING:
		return null
	var outfit: MeshInstance3D = null
	var surf := -1
	for m in fighter.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			if ClothMask._name(mi, s) == "Staff_Shirt":
				outfit = mi
				surf = s
	if outfit == null:
		return null
	var ring := _ring(line)
	if ring.is_empty():
		return null
	var to_root := ClothMask._to(fighter, outfit)
	var inv := to_root.affine_inverse()
	var arr: Array = outfit.mesh.surface_get_arrays(surf)
	var sv: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var suv: PackedVector2Array = arr[Mesh.ARRAY_TEX_UV] if arr[Mesh.ARRAY_TEX_UV] != null else PackedVector2Array()
	var sb: PackedInt32Array = arr[Mesh.ARRAY_BONES]
	var sw: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
	var per: int = sb.size() / sv.size()
	var centre := Vector3.ZERO
	for p in ring:
		centre += p
	centre /= float(ring.size())
	# the shirt's vertices round the collar, in fighter space (the only ones a ring point can be nearest to)
	var cand := PackedInt32Array()
	var cand_p := PackedVector3Array()
	for i in sv.size():
		var p := to_root * sv[i]
		if absf(p.y - centre.y) < 0.09 and Vector2(p.x - centre.x, p.z - centre.z).length() < 0.2:
			cand.append(i)
			cand_p.append(p)
	if cand.is_empty():
		return null
	# The line is on the SKIN, where cloth starts to lie over it; the shirt's rim hangs up to a few cm off that. The rib
	# belongs on the cloth: each ring point goes to the shirt vertex nearest it, and that ring is smoothed again.
	var near := PackedInt32Array()
	var rim: Array = []
	for i in RING:
		var best := 0
		var best_d := INF
		for c in cand.size():
			var d := cand_p[c].distance_squared_to(ring[i])
			if d < best_d:
				best_d = d
				best = c
		near.append(cand[best])
		rim.append(cand_p[best])
	rim = _smooth(rim, 3)
	var neck := _neck_skin(fighter, outfit, rim)
	if _follow(neck, sb, sw, per, cand, cand_p, rim):
		ClothMask._rebuild(outfit, {}, {}, {}, {surf: {Mesh.ARRAY_BONES: sb, Mesh.ARRAY_WEIGHTS: sw}})
	var rib_w := _rib_weights(sb, sw, per, near)   # per ring point: [joints, weights], `per` each
	var pos := PackedVector3Array()
	var nor := PackedVector3Array()
	var uv := PackedVector2Array()
	var bon := PackedInt32Array()
	var wei := PackedFloat32Array()
	var idx := PackedInt32Array()
	var basis_inv := inv.basis
	for i in RING:
		var here: Vector3 = rim[i]
		var tangent: Vector3 = ((rim[(i + 1) % RING] as Vector3) - (rim[(i + RING - 1) % RING] as Vector3)).normalized()
		var radial := Vector3(here.x - centre.x, 0.0, here.z - centre.z)
		var out := (radial - tangent * radial.dot(tangent)).normalized()
		var up := tangent.cross(out).normalized()
		if up.y < 0.0:
			up = -up
		var best: int = near[i]
		var mid := here + up * LIFT_M
		for j in SIDES:
			var a := TAU * float(j) / float(SIDES)
			pos.append(inv * (mid + out * cos(a) * OUT_M + up * sin(a) * UP_M))
			nor.append((basis_inv * (out * cos(a) / OUT_M + up * sin(a) / UP_M)).normalized())
			uv.append(suv[best] if best < suv.size() else Vector2.ZERO)
			bon.append_array(rib_w[i][0])
			wei.append_array(rib_w[i][1])
	for i in RING:
		for j in SIDES:
			var a := i * SIDES + j
			var b := i * SIDES + (j + 1) % SIDES
			var c := ((i + 1) % RING) * SIDES + j
			var d := ((i + 1) % RING) * SIDES + (j + 1) % SIDES
			idx.append_array([a, c, b, b, c, d])
	# Godot draws the side whose winding runs against the normal (measured on every body surface, tools/bodylook_wind.gd)
	if (pos[idx[1]] - pos[idx[0]]).cross(pos[idx[2]] - pos[idx[0]]).dot(nor[idx[0]]) > 0.0:
		for t in range(0, idx.size(), 3):
			var keep := idx[t + 1]
			idx[t + 1] = idx[t + 2]
			idx[t + 2] = keep
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = pos
	arrays[Mesh.ARRAY_NORMAL] = nor
	arrays[Mesh.ARRAY_TEX_UV] = uv
	arrays[Mesh.ARRAY_BONES] = bon
	arrays[Mesh.ARRAY_WEIGHTS] = wei
	arrays[Mesh.ARRAY_INDEX] = idx
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays, [], {}, Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS if per == 8 else 0)
	mesh.surface_set_material(0, outfit.mesh.surface_get_material(surf))
	var collar := MeshInstance3D.new()
	collar.name = "StaffCollar"
	collar.mesh = mesh
	collar.skin = outfit.skin
	collar.transform = outfit.transform
	collar.extra_cull_margin = 0.6
	outfit.get_parent().add_child(collar)
	collar.skeleton = outfit.skeleton
	return collar


## The head mesh round the collar: {grid: 2 cm cells of [place, vertex], bones, weights, per}; empty when the head is
## skinned on other joints than the outfit (nothing can be copied then).
static func _neck_skin(fighter: Node, outfit: MeshInstance3D, rim: Array) -> Dictionary:
	var head: MeshInstance3D = null
	var head_s := -1
	for m in fighter.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			if ClothMask._name(mi, s) == "MH_Skin_Head":
				head = mi
				head_s = s
	if head == null or head.skin != outfit.skin:
		return {}
	var harr: Array = head.mesh.surface_get_arrays(head_s)
	var hv: PackedVector3Array = harr[Mesh.ARRAY_VERTEX]
	var hb: PackedInt32Array = harr[Mesh.ARRAY_BONES]
	var h_root := ClothMask._to(fighter, head)
	var lo := Vector3(INF, INF, INF)
	var hi := -lo
	for p in rim:
		lo = lo.min(p)
		hi = hi.max(p)
	lo -= Vector3.ONE * (FOLLOW_M + 0.04)
	hi += Vector3.ONE * (FOLLOW_M + 0.04)
	var grid := {}
	for i in hv.size():
		var p := h_root * hv[i]
		if p.x < lo.x or p.y < lo.y or p.z < lo.z or p.x > hi.x or p.y > hi.y or p.z > hi.z:
			continue
		var k := Vector3i((p / 0.02).floor())
		if not grid.has(k):
			grid[k] = []
		grid[k].append([p, i])
	return {"grid": grid, "bones": hb, "weights": harr[Mesh.ARRAY_WEIGHTS], "per": hb.size() / hv.size()}


## The head vertex nearest `p` (within 5 cm) as {joint: weight}; empty when none.
static func _skin_at(neck: Dictionary, p: Vector3) -> Dictionary:
	var best := -1
	var best_d := 0.05
	var k := Vector3i((p / 0.02).floor())
	for x in [-2, -1, 0, 1, 2]:
		for y in [-2, -1, 0, 1, 2]:
			for z in [-2, -1, 0, 1, 2]:
				for e in (neck["grid"] as Dictionary).get(k + Vector3i(x, y, z), []):
					var d: float = (e[0] as Vector3).distance_to(p)
					if d < best_d:
						best_d = d
						best = e[1]
	var out := {}
	if best < 0:
		return out
	var hb: PackedInt32Array = neck["bones"]
	var hw: PackedFloat32Array = neck["weights"]
	var hper: int = neck["per"]
	for j in hper:
		if hw[best * hper + j] > 0.0:
			out[hb[best * hper + j]] = float(out.get(hb[best * hper + j], 0.0)) + hw[best * hper + j]
	return out


## {joint: weight} as the `per` strongest joints, weights summing to 1: [PackedInt32Array, PackedFloat32Array].
static func _strongest(mix: Dictionary, per: int) -> Array:
	var order: Array = mix.keys()
	order.sort_custom(func(a, b): return float(mix[a]) > float(mix[b]))
	var total := 0.0
	for j in mini(per, order.size()):
		total += float(mix[order[j]])
	var bones := PackedInt32Array()
	var weights := PackedFloat32Array()
	for j in per:
		bones.append(int(order[j]) if j < order.size() else 0)
		weights.append(float(mix[order[j]]) / maxf(total, 1e-6) if j < order.size() else 0.0)
	return [bones, weights]


## The shirt round the rim takes the neck base's weights (`sb`, `sw` changed in place). True when any vertex changed.
static func _follow(neck: Dictionary, sb: PackedInt32Array, sw: PackedFloat32Array, per: int, cand: PackedInt32Array,
		cand_p: PackedVector3Array, rim: Array) -> bool:
	if neck.is_empty():
		return false
	var changed := false
	for c in cand.size():
		var p := cand_p[c]
		var d := INF
		for r in rim:
			d = minf(d, (r as Vector3).distance_to(p))
		if d >= FOLLOW_M:
			continue
		var skin := _skin_at(neck, p)
		if skin.is_empty():
			continue
		var f := 1.0 - smoothstep(FOLLOW_FULL_M, FOLLOW_M, d)
		var mix := {}
		var i: int = cand[c]
		for j in per:
			if sw[i * per + j] > 0.0:
				mix[sb[i * per + j]] = float(mix.get(sb[i * per + j], 0.0)) + sw[i * per + j] * (1.0 - f)
		for joint in skin:
			mix[joint] = float(mix.get(joint, 0.0)) + float(skin[joint]) * f
		var top := _strongest(mix, per)
		for j in per:
			sb[i * per + j] = top[0][j]
			sw[i * per + j] = top[1][j]
		changed = true
	return changed


## The rib's weights, one set per ring point: the shirt vertex beside it (already following the neck), then eased along
## the ring - a jump between two neighbours kinked the rib in the coach's close-up. (Taken straight from the neck skin
## instead, the rib sank into the neck in that pose.)
static func _rib_weights(sb: PackedInt32Array, sw: PackedFloat32Array, per: int, near: PackedInt32Array) -> Array:
	var sets: Array = []
	for i in RING:
		var mix := {}
		for j in per:
			if sw[near[i] * per + j] > 0.0:
				mix[sb[near[i] * per + j]] = float(mix.get(sb[near[i] * per + j], 0.0)) + sw[near[i] * per + j]
		sets.append(mix)
	for pass_i in 8:
		var nxt: Array = []
		for i in RING:
			var mix := {}
			for step in [[-1, 0.25], [0, 0.5], [1, 0.25]]:
				var other: Dictionary = sets[(i + RING + int(step[0])) % RING]
				for joint in other:
					mix[joint] = float(mix.get(joint, 0.0)) + float(other[joint]) * float(step[1])
			nxt.append(mix)
		sets = nxt
	return sets.map(func(mix): return _strongest(mix, per))


## The loose points of the line as an even ring round the neck: one point per slice of angle, gaps filled from their
## neighbours, the ring smoothed. Empty when the points do not go round.
static func _ring(line: PackedVector3Array) -> Array:
	var centre := Vector3.ZERO
	for p in line:
		centre += p
	centre /= float(line.size())
	var sum: Array = []
	var count := PackedInt32Array()
	sum.resize(RING)
	count.resize(RING)
	for i in RING:
		sum[i] = Vector3.ZERO
	for p in line:
		var a := atan2(p.z - centre.z, p.x - centre.x)
		var bin := int(floor((a + PI) / TAU * RING)) % RING
		sum[bin] += p
		count[bin] += 1
	var filled := 0
	for i in RING:
		if count[i] > 0:
			sum[i] /= float(count[i])
			filled += 1
	if filled < int(RING * MIN_FILL):
		return []
	var ring: Array = []
	ring.resize(RING)
	for i in RING:
		if count[i] > 0:
			ring[i] = sum[i]
			continue
		var back := 1
		while count[(i + RING - back) % RING] == 0:
			back += 1
		var fwd := 1
		while count[(i + fwd) % RING] == 0:
			fwd += 1
		ring[i] = (sum[(i + RING - back) % RING] as Vector3).lerp(sum[(i + fwd) % RING], float(back) / float(back + fwd))
	return _smooth(ring, 4)


static func _smooth(ring: Array, passes: int) -> Array:
	for pass_i in passes:
		var nxt: Array = []
		nxt.resize(RING)
		for i in RING:
			nxt[i] = (ring[(i + RING - 1) % RING] as Vector3) * 0.25 + (ring[i] as Vector3) * 0.5 + (ring[(i + 1) % RING] as Vector3) * 0.25
		ring = nxt
	return ring
