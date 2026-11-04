extends RefCounted
## MOVEPICS1 r2 (S381 art review of the BJJ cards: "limb piles, top-down two heads, Ana hidden") - where a ground card's
## camera stands and what it frames, read off the two GrappleMap bodies (23 joints each):
##   score(js, az, el, contact) - the pair drawn as capsules on a coarse grid, nearest body per cell: how much of EACH
##       body's area and outline is its own (not hidden behind, not merged into the other), plus how many of the move's
##       key contact joints show. The card takes the best keyframe and camera by it; the camera is LOW (never top-down).
##   crop(js, b, contact) - a square window round the contact, tight: the far ends of the limbs may leave the card, both
##       heads stay on it.
## Pure: joints in, numbers out.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")

const G := 56                 # grid cells across the drawing (each body ~1500 cells)
const ELEVS := [10.0, 18.0]   # deg: low - a ground pair read from the side, as a coach kneels by the mat
const SEGS := [["LeftAnkle", "LeftKnee", 0.055], ["LeftKnee", "LeftHip", 0.08], ["RightAnkle", "RightKnee", 0.055],
	["RightKnee", "RightHip", 0.08], ["LeftHip", "RightHip", 0.1], ["LeftHip", "Core", 0.12], ["RightHip", "Core", 0.12],
	["Core", "Neck", 0.13], ["LeftShoulder", "RightShoulder", 0.07], ["LeftShoulder", "Core", 0.1],
	["RightShoulder", "Core", 0.1], ["Neck", "Head", 0.05], ["Head", "Head", 0.1], ["LeftShoulder", "LeftElbow", 0.05],
	["LeftElbow", "LeftWrist", 0.04], ["LeftWrist", "LeftHand", 0.035], ["RightShoulder", "RightElbow", 0.05],
	["RightElbow", "RightWrist", 0.04], ["RightWrist", "RightHand", 0.035], ["LeftAnkle", "LeftToe", 0.04],
	["RightAnkle", "RightToe", 0.04]]
const CONTACT_W := 0.45       # weight of the key contacts showing
const EDGE_W := 0.5           # weight of each body's outline against the mat (not against the other body)
const PAD := 0.16             # m round the joints: the flesh outside the bone points
const CROP_W := 0.58          # the window is at most this share of the pair's width (the limbs' far ends may leave it;
                              # S383: 0.78 left a lying pair a thin strip across an empty card)


## Right, up and the direction to the camera for an azimuth / elevation round the pair.
static func view(az: float, el: float) -> Basis:
	var a := deg_to_rad(az)
	var e := deg_to_rad(el)
	var d := Vector3(sin(a) * cos(e), sin(e), cos(a) * cos(e)).normalized()
	var right := (-d).cross(Vector3.UP).normalized()
	return Basis(right, right.cross(-d).normalized(), d)


static func _proj(js: Array, b: Basis) -> Array:
	var out: Array = []
	for m in 2:
		var p := PackedVector3Array()
		for v in (js[m] as PackedVector3Array):
			p.append(Vector3(v.dot(b.x), v.dot(b.y), v.dot(b.z)))
		out.append(p)
	return out


## {who: per cell -1 / 0 / 1, own: the cells each body covers (body 1's after body 0's), lo, hi, cell, depth, P} -
## the nearest capsule per cell.
static func raster(js: Array, b: Basis) -> Dictionary:
	var P := _proj(js, b)
	var lo := Vector2(INF, INF)
	var hi := Vector2(-INF, -INF)
	for m in 2:
		for v in (P[m] as PackedVector3Array):
			lo = lo.min(Vector2(v.x, v.y))
			hi = hi.max(Vector2(v.x, v.y))
	lo -= Vector2(PAD, PAD)
	hi += Vector2(PAD, PAD)
	var cell := maxf(hi.x - lo.x, hi.y - lo.y) / float(G)
	var depth := PackedFloat32Array()
	depth.resize(G * G)
	depth.fill(-INF)
	var who := PackedInt32Array()
	who.resize(G * G)
	who.fill(-1)
	# One array for both bodies (body m's cells at m * G * G): a packed array inside an Array is a copy on write.
	var own := PackedByteArray()
	own.resize(2 * G * G)
	own.fill(0)
	for m in 2:
		var p: PackedVector3Array = P[m]
		for s in SEGS:
			var A := p[DB.joint(s[0])]
			var B := p[DB.joint(s[1])]
			var r: float = s[2]
			var ab := Vector2(B.x - A.x, B.y - A.y)
			var l2 := ab.length_squared()
			var x0 := clampi(int((minf(A.x, B.x) - r - lo.x) / cell), 0, G - 1)
			var x1 := clampi(int((maxf(A.x, B.x) + r - lo.x) / cell), 0, G - 1)
			var y0 := clampi(int((hi.y - maxf(A.y, B.y) - r) / cell), 0, G - 1)
			var y1 := clampi(int((hi.y - minf(A.y, B.y) + r) / cell), 0, G - 1)
			for gy in range(y0, y1 + 1):
				var wy := hi.y - (gy + 0.5) * cell
				for gx in range(x0, x1 + 1):
					var wx := lo.x + (gx + 0.5) * cell
					var u := 0.0 if l2 < 1e-9 else clampf(((wx - A.x) * ab.x + (wy - A.y) * ab.y) / l2, 0.0, 1.0)
					var dx := wx - (A.x + u * ab.x)
					var dy := wy - (A.y + u * ab.y)
					if dx * dx + dy * dy > r * r:
						continue
					var i := gy * G + gx
					own[m * G * G + i] = 1
					var z := A.z + u * (B.z - A.z)
					if z > depth[i]:
						depth[i] = z
						who[i] = m
	return {"who": who, "own": own, "lo": lo, "hi": hi, "cell": cell, "depth": depth, "P": P}


## How well the pair reads from (az, el): each body's own visible area and its outline against the mat (the worse of the
## two bodies counts), plus the share of the key contacts [[body, joint], ...] that are nearest the eye at their cell.
static func score(js: Array, az: float, el: float, contact: Array) -> float:
	var r := raster(js, view(az, el))
	var who: PackedInt32Array = r["who"]
	var vis := [0.0, 0.0]
	var edge := [0.0, 0.0]
	for m in 2:
		var own: PackedByteArray = r["own"]
		var tot := 0
		var mine := 0
		var to_bg := 0
		var to_other := 0
		for i in G * G:
			if own[m * G * G + i] == 0:
				continue
			tot += 1
			if who[i] != m:
				continue
			mine += 1
			var x := i % G
			var y := i / G
			var nb := PackedInt32Array([who[i + 1] if x + 1 < G else -1, who[i - 1] if x > 0 else -1,
				who[i + G] if y + 1 < G else -1, who[i - G] if y > 0 else -1])
			for o in nb:
				if o == -1:
					to_bg += 1
				elif o != m:
					to_other += 1
		vis[m] = float(mine) / maxf(1.0, tot)
		edge[m] = float(to_bg) / maxf(1.0, to_bg + to_other)
	var seen := 0.0
	for c in contact:
		var p: Vector3 = (r["P"][int(c[0])] as PackedVector3Array)[DB.joint(str(c[1]))]
		var gx := clampi(int((p.x - (r["lo"] as Vector2).x) / float(r["cell"])), 0, G - 1)
		var gy := clampi(int(((r["hi"] as Vector2).y - p.y) / float(r["cell"])), 0, G - 1)
		var d: float = (r["depth"] as PackedFloat32Array)[gy * G + gx]
		if who[gy * G + gx] == int(c[0]) or p.z >= d - 0.08:
			seen += 1.0
	var share := seen / float(contact.size()) if not contact.is_empty() else 1.0
	return minf(vis[0], vis[1]) + EDGE_W * minf(edge[0], edge[1]) + CONTACT_W * share


## The square window (world centre, side in m) for the card: tight round the contact, both heads kept.
static func crop(js: Array, b: Basis, contact: Array) -> Dictionary:
	var P := _proj(js, b)
	var lo := Vector2(INF, INF)
	var hi := Vector2(-INF, -INF)
	var depth := 0.0
	for m in 2:
		for v in (P[m] as PackedVector3Array):
			lo = lo.min(Vector2(v.x, v.y))
			hi = hi.max(Vector2(v.x, v.y))
			depth += v.z
	depth /= 2.0 * DB.JOINTS.size()
	var c := (lo + hi) * 0.5
	if not contact.is_empty():
		c = Vector2.ZERO
		for k in contact:
			var p: Vector3 = (P[int(k[0])] as PackedVector3Array)[DB.joint(str(k[1]))]
			c += Vector2(p.x, p.y)
		c /= float(contact.size())
	var ext := hi - lo + Vector2(PAD, PAD) * 2.0
	var side := clampf(ext.x * CROP_W, ext.y + 0.05, maxf(ext.x, ext.y))
	for i in 2:
		var h := side * 0.5
		# No empty band: the window slides back inside the drawing where it would show bare mat on one side only.
		c.x = clampf(c.x, lo.x - PAD + h, hi.x + PAD - h) if side < ext.x else (lo.x + hi.x) * 0.5
		c.y = clampf(c.y, lo.y - PAD + h, hi.y + PAD - h) if side < ext.y else (lo.y + hi.y) * 0.5
		# Both heads on the card, with the skull's own width round each.
		for m in 2:
			var hd: Vector3 = (P[m] as PackedVector3Array)[DB.joint("Head")]
			side = maxf(side, 2.0 * maxf(absf(hd.x - c.x), absf(hd.y - c.y)) + 0.34)
		side = minf(side, maxf(ext.x, ext.y))
	var centre := b.x * c.x + b.y * c.y + b.z * depth
	return {"centre": centre, "size": side, "bleeds": side < maxf(ext.x, ext.y) - 0.01}
