extends RefCounted
## BODYLOOK1 (S492, operator on the corner coach: "terrible neck blending"). A staff tee came from the Creator as a shell
## with no collar: in the coach's close-up his neck met the shirt in one bare hard line. A real crew neck has a rib band
## there. This builds it: a flat tube round the shirt's rim, beside the line where the neck goes under (ClothMask's line),
## wearing the shirt's own material - every recolour of "Staff_Shirt" (CornerCrew._shirt, Referee._paint, FighterFace)
## colours it too.
## And the collar must MOVE with the neck base: the Creator tee's collar band carries no neck or head weight at all
## (tools/bodylook_skin.gd: spine_04 0.40, shoulders and clavicles the rest) while the neck skin inside it carries Head
## 0.32 - when the corner's look turned his neck, the neck left the collar and crossed the shirt in one hard line (the
## coach's close-up). Every mesh of a body shares one Skin, so the shirt round the rim takes the weights of the skin
## under it. S495 (operator: "fix the skin sliver and dark slit at the front of the coach's collar"): taken vertex by
## vertex from the nearest skin vertex, two shirt neighbours got weights from skin 1-2 cm apart in height, where the
## head's share changes fast - in his twisted close-up the rim tore off the rib in flat shards and the skin showed
## through. Now the skin's weights are read as a FIELD: one set per slice of angle round the neck and per band of
## distance down the shirt, eased round the ring; rim, rib and the skin on the line share one set, so they move as one.
## And the neck's own skin beside the line takes that set too (_settle): skin 2-3 cm above the line carries more of the
## head and rolled out over the rib when he craned his neck (the rib vanished under it round the front); now nothing
## within a finger of the collar moves against it - the neck turns higher up, as it does in a real crew neck.
##   add(fighter, line) -> the collar's MeshInstance3D, or null when the line is no closed ring (no outfit, a bare neck)

const ClothMask := preload("res://scripts/fight3d/ClothMask.gd")
const RING := 64               # points around the neck
const SIDES := 8               # points around the rib
const OUT_M := 0.009           # the rib's half width, lying on the shirt
const UP_M := 0.0065           # ... and half height
const LIFT_M := 0.002          # its middle sits this far above the rim
const MIN_FILL := 0.6          # the line must cover this share of the way round
const FOLLOW_M := 0.075        # the shirt follows the skin under it this far from its rim
const FOLLOW_FULL_M := 0.035   # ... and wholly within this (the covered skin stays drawn ~3 cm in: ClothMask.TUCK)
const BAND_M := 0.015          # the field's bands down the shirt
const BANDS := 5
const SETTLE_M := 0.08         # the neck's own skin within this of the line moves with the line (a long fade: a short
const SETTLE_FULL_M := 0.006   # one left a ledge round the neck where it ended) ... wholly within this


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
	var field := _field(neck, cand_p, rim)
	_settle(neck, field, ring)
	if _follow(field, sb, sw, per, cand):
		ClothMask._rebuild(outfit, {}, {}, {}, {surf: {Mesh.ARRAY_BONES: sb, Mesh.ARRAY_WEIGHTS: sw}})
	var rib_w := _rib_weights(field, sb, sw, per, near)   # per ring point: [joints, weights], `per` each
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
	return {"grid": grid, "bones": hb, "weights": harr[Mesh.ARRAY_WEIGHTS], "per": hb.size() / hv.size(), "mi": head, "surf": head_s}


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


## The skin's weights round the collar as a field: {"sets": [band][ring point] -> {joint: weight}, "at": per shirt
## vertex of `cand_p` [ring point, distance to the rim]}. Each shirt vertex near the rim adds the weights of the skin
## vertex nearest it to its slice and band; empty cells take their neighbours'; every band is eased round the ring.
## Empty when the head is skinned apart from the outfit.
static func _field(neck: Dictionary, cand_p: PackedVector3Array, rim: Array) -> Dictionary:
	var at: Array = []
	for c in cand_p.size():
		var best := 0
		var best_d := INF
		for i in RING:
			var d := (rim[i] as Vector3).distance_squared_to(cand_p[c])
			if d < best_d:
				best_d = d
				best = i
		at.append([best, sqrt(best_d)])
	if neck.is_empty():
		return {}
	var sets: Array = []
	for k in BANDS:
		var row: Array = []
		for i in RING:
			row.append({})
		sets.append(row)
	for c in cand_p.size():
		var d: float = at[c][1]
		if d >= FOLLOW_M:
			continue
		var skin := _skin_at(neck, cand_p[c])
		var cell: Dictionary = sets[mini(BANDS - 1, int(d / BAND_M))][int(at[c][0])]
		for joint in skin:
			cell[joint] = float(cell.get(joint, 0.0)) + float(skin[joint])
	for k in BANDS:
		for i in RING:
			if not (sets[k][i] as Dictionary).is_empty():
				continue
			for step in range(1, RING / 2):   # an empty slice: the nearest filled one round the ring, else the band above
				for side in [-step, step]:
					var other: Dictionary = sets[k][(i + RING + side) % RING]
					if (sets[k][i] as Dictionary).is_empty() and not other.is_empty():
						sets[k][i] = other.duplicate()
				if not (sets[k][i] as Dictionary).is_empty():
					break
			if (sets[k][i] as Dictionary).is_empty() and k > 0:
				sets[k][i] = (sets[k - 1][i] as Dictionary).duplicate()
		for i in RING:
			sets[k][i] = _unit(sets[k][i])
		for pass_i in 6:
			var nxt: Array = []
			for i in RING:
				nxt.append(_blend([[sets[k][(i + RING - 1) % RING], 0.25], [sets[k][i], 0.5], [sets[k][(i + 1) % RING], 0.25]]))
			sets[k] = nxt
	return {"sets": sets, "at": at}


## The field at ring point `i`, `d` metres down the shirt from the rim: {joint: weight}, summing to 1.
static func _field_at(field: Dictionary, i: int, d: float) -> Dictionary:
	var b := clampf(d / BAND_M - 0.5, 0.0, float(BANDS - 1))
	var k := mini(int(b), BANDS - 2)
	return _blend([[field["sets"][k][i], 1.0 - (b - float(k))], [field["sets"][k + 1][i], b - float(k)]])


static func _blend(parts: Array) -> Dictionary:
	var mix := {}
	for part in parts:
		for joint in part[0]:
			mix[joint] = float(mix.get(joint, 0.0)) + float(part[0][joint]) * float(part[1])
	return mix


static func _unit(mix: Dictionary) -> Dictionary:
	var total := 0.0
	for joint in mix:
		total += float(mix[joint])
	var out := {}
	for joint in mix:
		out[joint] = float(mix[joint]) / maxf(total, 1e-6)
	return out


## The shirt round the rim takes the field's weights (`sb`, `sw` changed in place): wholly within FOLLOW_FULL_M of the
## rim, fading into its own weights by FOLLOW_M. True when any vertex changed.
static func _follow(field: Dictionary, sb: PackedInt32Array, sw: PackedFloat32Array, per: int, cand: PackedInt32Array) -> bool:
	if field.is_empty():
		return false
	var changed := false
	for c in cand.size():
		var d: float = field["at"][c][1]
		if d >= FOLLOW_M:
			continue
		var skin := _field_at(field, int(field["at"][c][0]), d)
		if skin.is_empty():
			continue
		var held := 1.0 - smoothstep(SETTLE_FULL_M, SETTLE_M, d)   # the skin under it is settled on the line's set
		skin = _blend([[skin, 1.0 - held], [_field_at(field, int(field["at"][c][0]), 0.0), held]])
		var f := 1.0 - smoothstep(FOLLOW_FULL_M, FOLLOW_M, d)
		var own := {}
		var i: int = cand[c]
		for j in per:
			if sw[i * per + j] > 0.0:
				own[sb[i * per + j]] = float(own.get(sb[i * per + j], 0.0)) + sw[i * per + j]
		var top := _strongest(_blend([[own, 1.0 - f], [skin, f]]), per)
		for j in per:
			sb[i * per + j] = top[0][j]
			sw[i * per + j] = top[1][j]
		changed = true
	return changed


## The head mesh's vertices within SETTLE_M of the line (above it, bare; below it, tucked) take the line's own set.
static func _settle(neck: Dictionary, field: Dictionary, ring: Array) -> void:
	if field.is_empty():
		return
	var hb: PackedInt32Array = neck["bones"]
	var hw: PackedFloat32Array = neck["weights"]
	var per: int = neck["per"]
	var changed := false
	for cell in (neck["grid"] as Dictionary).values():
		for e in cell:
			var best := 0
			var best_d := INF
			for i in RING:
				var d2 := (ring[i] as Vector3).distance_squared_to(e[0])
				if d2 < best_d:
					best_d = d2
					best = i
			var d := sqrt(best_d)
			if d >= SETTLE_M:
				continue
			var f := 1.0 - smoothstep(SETTLE_FULL_M, SETTLE_M, d)
			var v: int = e[1]
			var own := {}
			for j in per:
				if hw[v * per + j] > 0.0:
					own[hb[v * per + j]] = float(own.get(hb[v * per + j], 0.0)) + hw[v * per + j]
			var top := _strongest(_blend([[own, 1.0 - f], [_field_at(field, best, 0.0), f]]), per)
			for j in per:
				hb[v * per + j] = top[0][j]
				hw[v * per + j] = top[1][j]
			changed = true
	if changed:
		ClothMask._rebuild(neck["mi"], {}, {}, {}, {neck["surf"]: {Mesh.ARRAY_BONES: hb, Mesh.ARRAY_WEIGHTS: hw}})


## The rib's weights, one set per ring point: the field on the rim itself - the very set the shirt's rim vertices and the
## skin on the line carry, so the rib neither leaves the shirt nor sinks into the neck. (With no field - a head skinned
## apart - the shirt vertex beside it, eased round the ring.)
static func _rib_weights(field: Dictionary, sb: PackedInt32Array, sw: PackedFloat32Array, per: int, near: PackedInt32Array) -> Array:
	var sets: Array = []
	for i in RING:
		if not field.is_empty():
			sets.append(_field_at(field, i, 0.0))
			continue
		var mix := {}
		for j in per:
			if sw[near[i] * per + j] > 0.0:
				mix[sb[near[i] * per + j]] = float(mix.get(sb[near[i] * per + j], 0.0)) + sw[near[i] * per + j]
		sets.append(mix)
	if field.is_empty():
		for pass_i in 8:
			var nxt: Array = []
			for i in RING:
				nxt.append(_blend([[sets[(i + RING - 1) % RING], 0.25], [sets[i], 0.5], [sets[(i + 1) % RING], 0.25]]))
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
