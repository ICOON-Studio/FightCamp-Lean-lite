extends RefCounted
## Capsule overlap between two GrappleMap men; push apart without breaking grips. GROUND2A (Cursor, S336) wrote the capsules
## and the test; S337 replaced its whole-body search (rigid shifts tried in 28 directions, hundreds of checks a frame, and a
## mount's two thighs cannot both clear by moving the whole body) with the local push below.
## S371 BJJ9 (Argon: "limbs pass directly through each other"): the capsule set is now sized to our own skin, the FOREARMS
## are in it (they used to be excluded, and the probe caught a forearm buried 0.176 m in a torso), and a pinned grip comes
## along with the body it holds instead of sinking into it.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")

const TRUNK := ["Core", "Neck", "Head", "LeftShoulder", "RightShoulder", "LeftElbow", "RightElbow"]
const GRIP := ["LeftWrist", "RightWrist", "LeftHand", "RightHand", "LeftFingers", "RightFingers"]
## Hands never collide (they hold: GrappleGrip's curl and the pins below); the forearm capsule ends at the wrist and stays in.
const EXCL := ["LeftHand", "RightHand", "LeftFingers", "RightFingers"]

## S371: the pass resolves every contact at once (position-based, averaged) but a pinned end's share goes to its free
## partner instead of being spent on a joint that cannot move - the old version drowned deep single contacts under
## dozens of shallow ones and left 15 cm behind while a gripping arm's midline never cleared. A joint moves at most
## MAX_STEP a pass; grips stay pinned (GrapplePose's IK re-reaches them); a sphere bound rejects far pairs; the loop
## stops once the worst stops falling (PBD's own compromise floor).
const PASSES := 72
const MAX_STEP := 0.07
const DONE_M := 0.003
const FLOOR_Y := 0.0
const SEP_MAX := 0.25


static func penetration(men: Array) -> Dictionary:
	return _best_pair(_capsules(men[0]), _capsules(men[1]))


## The deepest contact of two capsule sets (the sphere bound rejects far pairs before the exact test).
static func _best_pair(c0: Array, c1: Array) -> Dictionary:
	var best := {"depth": 0.0, "normal": Vector3.UP, "a": {}, "b": {}, "pa": Vector3.ZERO, "pb": Vector3.ZERO}
	for a in c0:
		if _excluded(a):
			continue
		for b in c1:
			if _excluded(b):
				continue
			if not _near(a, b):
				continue
			var hit := _capsule_hit(a, b)
			if hit["depth"] > best["depth"]:
				best = hit
	return best


static func separate(men: Array) -> Array:
	var out := _dup(men)
	var orig := _dup(men)   # S371 round 5: a joint may not be pushed further than SEP_MAX from the data's own pose
	var pins := _grip_pins(men)
	var pin := [_pin_mask(pins, 0), _pin_mask(pins, 1)]
	# The capsule sets are built once and refreshed in place for the joints a pass moves (most pairs skip the rebuild).
	var caps := [_capsules(out[0]), _capsules(out[1])]
	var watch := [_watch(caps[0]), _watch(caps[1])]
	var r0 := PackedFloat32Array()
	var r1 := PackedFloat32Array()
	var k0 := PackedByteArray()
	var k1 := PackedByteArray()
	for c in caps[0]:
		r0.append(float(c["r"]))
		k0.append(0 if _excluded(c) else 1)
	for c in caps[1]:
		r1.append(float(c["r"]))
		k1.append(0 if _excluded(c) else 1)
	var prev_worst := 999.0
	var no_gain := 0
	var push := [_zeros(), _zeros()]   # reused every pass (fill beats an allocation: this runs every frame)
	var count := [PackedInt32Array(), PackedInt32Array()]
	for m in 2:
		count[m].resize(DB.JOINTS.size())
	for _pass in PASSES:
		push[0].fill(Vector3.ZERO)
		push[1].fill(Vector3.ZERO)
		count[0].fill(0)
		count[1].fill(0)
		# The broad phase runs on packed copies (a per-pair dictionary read is the hot cost here); the exact test inlines
		# the segment-segment case (no dictionary per contact - this runs every frame), spheres keep the helper.
		var m0 := PackedVector3Array()
		var h0 := PackedFloat32Array()
		for c in caps[0]:
			m0.append(c["mid"])
			h0.append(float(c["hl"]))
		var m1 := PackedVector3Array()
		var h1 := PackedFloat32Array()
		for c in caps[1]:
			m1.append(c["mid"])
			h1.append(float(c["hl"]))
		var worst := 0.0
		var a0: Array = caps[0]
		var a1: Array = caps[1]
		for i in a0.size():
			if k0[i] == 0:
				continue
			var a: Dictionary = a0[i]
			for j in a1.size():
				if k1[j] == 0:
					continue
				var reach := r0[i] + r1[j] + h0[i] + h1[j]
				if m0[i].distance_squared_to(m1[j]) > reach * reach:
					continue
				var b: Dictionary = a1[j]
				var d := 0.0
				var n := Vector3.UP
				var hpa := Vector3.ZERO
				var hpb := Vector3.ZERO
				if bool(a.get("sphere", false)) or bool(b.get("sphere", false)):
					var hit := _capsule_hit(a, b)
					d = float(hit["depth"])
					n = hit["normal"]
					hpa = hit["pa"]
					hpb = hit["pb"]
				else:
					var pts := Geometry3D.get_closest_points_between_segments(a["a"], a["b"], b["a"], b["b"])
					hpa = pts[0]
					hpb = pts[1]
					var dist := hpa.distance_to(hpb)
					d = r0[i] + r1[j] - dist
					if d > 0.0 and dist > 1e-8:
						n = (hpa - hpb) / dist
				if d <= 0.0:
					continue
				worst = maxf(worst, d)
				_spread(push[0], count[0], a, hpa, n * d * 0.5, pin[0])
				_spread(push[1], count[1], b, hpb, -n * d * 0.5, pin[1])
		if worst < DONE_M:
			break
		# PBD settles on the compromise between conflicting contacts; once the worst stops moving (a grip floor, a
		# web of contacts), further passes only burn frames - but never while the worst is still deep enough to show
		# (a forearm buried in a chest converges at ~a millimetre a pass: it gets the whole budget).
		if worst > prev_worst - 0.001:
			no_gain += 1
			if no_gain >= 2 and worst < 0.06:
				break
		else:
			no_gain = 0
		prev_worst = minf(prev_worst, worst)
		for m in 2:
			var p: PackedVector3Array = out[m]
			var pm: PackedByteArray = pin[m]
			var cm: PackedInt32Array = count[m]
			var um: PackedVector3Array = push[m]
			for j in p.size():
				if cm[j] == 0 or pm[j] == 1:
					continue
				var v: Vector3 = um[j] / float(cm[j])
				var q := p[j] + v.limit_length(MAX_STEP)
				# S371 round 3: a joint may press into the mat, never through it (the old per-body window forbade
				# ANY downward push near a lying body and deadlocked the tightest entanglements at a 5-6 cm overlap).
				q.y = maxf(q.y, FLOOR_Y)
				# S371 round 5: a joint deep in a contact web could be walked metres from its data position over the
				# passes (the probe caught a pinned toe 1.9 m out); past SEP_MAX the pose is gone, not resolved.
				if (orig[m] as PackedVector3Array)[j].distance_to(q) > SEP_MAX:
					continue
				p[j] = q
				_refresh(caps[m], watch[m], p, j)
			out[m] = p
	_restore_pins(out, pins)
	return out


## Joint -> the capsules it ends (for refreshing only what a pass moved).
static func _watch(caps: Array) -> Array:
	var w: Array = []
	for j in DB.JOINTS.size():
		var list: Array = []
		for ci in caps.size():
			var c: Dictionary = caps[ci]
			if int(c["ja"]) == j or int(c["jb"]) == j:
				list.append(ci)
		w.append(list)
	return w


static func _refresh(caps: Array, watch: Array, p: PackedVector3Array, j: int) -> void:
	for ci in watch[j]:
		var c: Dictionary = caps[ci]
		var pa: Vector3 = p[int(c["ja"])]
		var pb: Vector3 = p[int(c["jb"])]
		c["a"] = pa
		c["b"] = pb
		c["mid"] = (pa + pb) * 0.5
		c["hl"] = pa.distance_to(pb) * 0.5


static func _pin_mask(pins: Array, m: int) -> PackedByteArray:
	var mask := PackedByteArray()
	mask.resize(DB.JOINTS.size())
	for p in pins:
		if int(p["m"]) == m:
			mask[int(p["j"])] = 1
	return mask


## One contact's push shared between a capsule's two end joints by where along it the contact sits. S371: a pinned end
## takes no share - the free end carries it (a gripping hand swings its elbow out instead of tearing the grip apart).
static func _spread(push: PackedVector3Array, count: PackedInt32Array, c: Dictionary, at: Vector3, v: Vector3,
		pin: PackedByteArray) -> void:
	var ja := int(c["ja"])
	var jb := int(c["jb"])
	var pa: bool = pin[ja] == 1
	var pb: bool = pin[jb] == 1 if ja != jb else pa
	if ja == jb:
		if not pa:
			push[ja] += v
			count[ja] += 1
		return
	if pa and pb:
		return
	var ab: Vector3 = c["b"] - c["a"]
	var t := 0.5 if ab.length_squared() < 1e-10 else clampf((at - c["a"]).dot(ab) / ab.length_squared(), 0.0, 1.0)
	if pa:
		t = 1.0
	elif pb:
		t = 0.0
	# Weights so the contact point itself moves by v (the end nearer the contact moves more).
	var k := 1.0 / ((1.0 - t) * (1.0 - t) + t * t)
	push[ja] += v * (1.0 - t) * k
	push[jb] += v * t * k
	count[ja] += 1
	count[jb] += 1


static func _zeros() -> PackedVector3Array:
	var z := PackedVector3Array()
	z.resize(DB.JOINTS.size())
	return z


static func _floor(p: PackedVector3Array) -> float:
	var lo := INF
	for v in p:
		lo = minf(lo, v.y)
	return lo


static func body_distance(point: Vector3, other: PackedVector3Array) -> float:
	var best := INF
	for c in _capsules(other):
		best = minf(best, _point_capsule(point, c))
	return best


## The skinned mesh as capsules. S371 round 6: every radius below is MEASURED off the real MetaHuman skin (mh_boxer_11,
## top skin weight per vertex, radial of each region from this very segment in the rest pose) and taken at the p90 -
## past it the shell outgrows the local surface (the p98 ribs are 2 cm over the sternum) and the resolver spends its
## budget on conflicts the skin does not have while a pressed hold reads deep. The torso is TWO capsules offset along
## the hip axis (half-width 0.155, front/back 0.12): a real ribcage is an ellipse, one barrel would clip the sides.
static func _capsules(p: PackedVector3Array) -> Array:
	var caps: Array = []
	var seg := func(na: String, nb: String, r: float) -> void:
		var ja := DB.joint(na)
		var jb := DB.joint(nb)
		var pa: Vector3 = p[ja]
		var pb: Vector3 = p[jb]
		caps.append({"a": pa, "b": pb, "r": r, "na": na, "nb": nb, "ja": ja, "jb": jb,
			"mid": (pa + pb) * 0.5, "hl": pa.distance_to(pb) * 0.5})
	# The torso: two capsules offset along the body's own left-right axis (from the hips), twin halves of the ellipse.
	var lat: Vector3 = (p[DB.joint("RightHip")] - p[DB.joint("LeftHip")]).normalized()
	var tc: Vector3 = p[DB.joint("Core")]
	var tn: Vector3 = p[DB.joint("Neck")]
	for s in [1.0, -1.0]:
		caps.append({"a": tc + lat * 0.035 * s, "b": tn + lat * 0.035 * s, "r": 0.12, "na": "Core", "nb": "Neck",
			"ja": DB.joint("Core"), "jb": DB.joint("Neck"), "mid": (tc + tn) * 0.5 + lat * 0.035 * s,
			"hl": tc.distance_to(tn) * 0.5})
	seg.call("Neck", "Head", 0.07)
	seg.call("LeftHip", "RightHip", 0.118)
	seg.call("LeftShoulder", "RightShoulder", 0.085)
	seg.call("LeftHip", "LeftKnee", 0.10)
	seg.call("RightHip", "RightKnee", 0.10)
	seg.call("LeftKnee", "LeftAnkle", 0.065)
	seg.call("RightKnee", "RightAnkle", 0.065)
	seg.call("LeftShoulder", "LeftElbow", 0.06)
	seg.call("RightShoulder", "RightElbow", 0.06)
	seg.call("LeftElbow", "LeftWrist", 0.045)
	seg.call("RightElbow", "RightWrist", 0.045)
	seg.call("LeftAnkle", "LeftToe", 0.068)
	seg.call("RightAnkle", "RightToe", 0.068)
	var hj := DB.joint("Head")
	var hp: Vector3 = p[hj]
	caps.append({"a": hp, "b": hp, "r": 0.11, "na": "Head", "nb": "Head", "ja": hj, "jb": hj, "sphere": true,
		"mid": hp, "hl": 0.0})
	return caps


static func _excluded(c: Dictionary) -> bool:
	if bool(c.get("sphere", false)):
		return false
	return EXCL.has(c["na"]) or EXCL.has(c["nb"])


## The sphere bound: past this the two capsules cannot touch (a cheap reject for the pair scan).
static func _near(a: Dictionary, b: Dictionary) -> bool:
	var reach: float = float(a["r"]) + float(b["r"]) + float(a["hl"]) + float(b["hl"])
	return (a["mid"] as Vector3).distance_squared_to(b["mid"] as Vector3) <= reach * reach


static func _capsule_hit(a: Dictionary, b: Dictionary) -> Dictionary:
	var pa := Vector3.ZERO
	var pb := Vector3.ZERO
	var dist := 0.0
	if bool(a.get("sphere", false)) and bool(b.get("sphere", false)):
		pa = a["a"]
		pb = b["a"]
		dist = pa.distance_to(pb)
	elif bool(a.get("sphere", false)):
		var cc := _closest_point_segment(a["a"], b["a"], b["b"])
		pa = a["a"]
		pb = cc
		dist = pa.distance_to(pb)
	elif bool(b.get("sphere", false)):
		var cc := _closest_point_segment(b["a"], a["a"], a["b"])
		pa = cc
		pb = b["a"]
		dist = pa.distance_to(pb)
	else:
		var pts := Geometry3D.get_closest_points_between_segments(a["a"], a["b"], b["a"], b["b"])
		pa = pts[0]
		pb = pts[1]
		dist = pa.distance_to(pb)
	var depth := float(a["r"]) + float(b["r"]) - dist
	var n := Vector3.UP
	if depth > 0.0 and dist > 1e-8:
		n = (pa - pb) / dist
	return {"depth": maxf(0.0, depth), "normal": n, "a": a, "b": b, "pa": pa, "pb": pb}


static func _point_capsule(p: Vector3, c: Dictionary) -> float:
	if bool(c.get("sphere", false)):
		return maxf(0.0, p.distance_to(c["a"]) - float(c["r"]))
	var q := _closest_point_segment(p, c["a"], c["b"])
	return maxf(0.0, p.distance_to(q) - float(c["r"]))


static func _closest_point_segment(p: Vector3, a: Vector3, b: Vector3) -> Vector3:
	var ab := b - a
	if ab.length_squared() < 1e-12:
		return a
	var t := clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)
	return a + ab * t


static func _dup(men: Array) -> Array:
	var out: Array = []
	for m in 2:
		var p := (men[m] as PackedVector3Array).duplicate()
		out.append(p)
	return out


static func _grip_pins(men: Array) -> Array:
	var pins: Array = []
	for m in 2:
		var other: PackedVector3Array = men[1 - m]
		for name in GRIP:
			var j := DB.joint(name)
			var pos: Vector3 = men[m][j]
			if body_distance(pos, other) <= 0.05:
				pins.append({"m": m, "j": j, "pos": pos})
	return pins


## S371: a pin holds the grip POINT, but the push has moved the body it grips - a pinned hand left at the old spot ends up
## inside the new skin. Outside the other body it stays exactly where it was; buried, it comes out along its own direction
## to the skin, so the hand rides the body it holds.
static func _restore_pins(men: Array, pins: Array) -> void:
	for pin in pins:
		var m := int(pin["m"])
		var j := int(pin["j"])
		var p: PackedVector3Array = men[m]
		p[j] = _snap_to_skin(pin["pos"], men[1 - m])
		men[m] = p


static func _snap_to_skin(at: Vector3, other: PackedVector3Array) -> Vector3:
	var best_d := INF
	var best_q := at
	var best_r := 0.0
	for c in _capsules(other):
		var q := _closest_point_segment(at, c["a"], c["b"])
		var d := at.distance_to(q) - float(c["r"])
		if d < best_d:
			best_d = d
			best_q = q
			best_r = float(c["r"])
	if best_d >= 0.0:
		return at
	var off := at - best_q
	var dir := off.normalized() if off.length() > 1e-5 else Vector3.UP
	return best_q + dir * best_r
