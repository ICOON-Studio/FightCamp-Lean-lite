extends RefCounted
## Capsule overlap between two GrappleMap men; push apart without breaking grips. GROUND2A (Cursor, S336) wrote the capsules
## and the test; S337 replaced its whole-body search (rigid shifts tried in 28 directions, hundreds of checks a frame, and a
## mount's two thighs cannot both clear by moving the whole body) with the local push below.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")

const TRUNK := ["Core", "Neck", "Head", "LeftShoulder", "RightShoulder", "LeftElbow", "RightElbow"]
const GRIP := ["LeftWrist", "RightWrist", "LeftHand", "RightHand", "LeftFingers", "RightFingers"]
const EXCL := ["LeftWrist", "RightWrist", "LeftHand", "RightHand", "LeftFingers", "RightFingers"]

## Local push-out (position-based): every overlapping capsule pair pushes its own end joints apart along the contact,
## half each, PASSES times; a joint moves at most MAX_STEP a pass; grips stay pinned (GrapplePose's IK re-reaches them).
const PASSES := 10
const MAX_STEP := 0.04
const DONE_M := 0.002
const LYING_M := 0.25


static func penetration(men: Array) -> Dictionary:
	var best := {"depth": 0.0, "normal": Vector3.UP, "a": {}, "b": {}}
	var c0 := _capsules(men[0])
	var c1 := _capsules(men[1])
	for a in c0:
		if _excluded(a):
			continue
		for b in c1:
			if _excluded(b):
				continue
			var hit := _capsule_hit(a, b)
			if hit["depth"] > best["depth"]:
				best = hit
	return best


static func separate(men: Array) -> Array:
	var out := _dup(men)
	var pins := _grip_pins(men)
	var pinned := _pin_set(pins)
	var floor_y := [_floor(men[0]), _floor(men[1])]
	for _pass in PASSES:
		var push := [_zeros(), _zeros()]
		var count := [PackedInt32Array(), PackedInt32Array()]
		for m in 2:
			count[m].resize(DB.JOINTS.size())
		var worst := 0.0
		var c0 := _capsules(out[0])
		var c1 := _capsules(out[1])
		for a in c0:
			if _excluded(a):
				continue
			for b in c1:
				if _excluded(b):
					continue
				var hit := _capsule_hit(a, b)
				var d := float(hit["depth"])
				if d <= 0.0:
					continue
				worst = maxf(worst, d)
				var n: Vector3 = hit["normal"]
				_spread(push[0], count[0], a, hit["pa"], n * d * 0.5)
				_spread(push[1], count[1], b, hit["pb"], -n * d * 0.5)
		if worst < DONE_M:
			break
		for m in 2:
			var p: PackedVector3Array = out[m]
			for j in p.size():
				if count[m][j] == 0 or pinned.has("%d:%d" % [m, j]):
					continue
				var v: Vector3 = (push[m] as PackedVector3Array)[j] / float(count[m][j])
				var q := p[j] + v.limit_length(MAX_STEP)
				# A body lying on the mat is not pushed into it: the other body takes the move.
				if p[j].y - float(floor_y[m]) < LYING_M:
					q.y = maxf(q.y, p[j].y)
				p[j] = q
			out[m] = p
	_restore_pins(out, pins)
	return out


## One contact's push shared between a capsule's two end joints by where along it the contact sits.
static func _spread(push: PackedVector3Array, count: PackedInt32Array, c: Dictionary, at: Vector3, v: Vector3) -> void:
	var ja := DB.joint(c["na"])
	var jb := DB.joint(c["nb"])
	if ja == jb:
		push[ja] += v
		count[ja] += 1
		return
	var ab: Vector3 = c["b"] - c["a"]
	var t := 0.5 if ab.length_squared() < 1e-10 else clampf((at - c["a"]).dot(ab) / ab.length_squared(), 0.0, 1.0)
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


static func _pin_set(pins: Array) -> Dictionary:
	var d := {}
	for pin in pins:
		d["%d:%d" % [int(pin["m"]), int(pin["j"])]] = true
	return d


static func body_distance(point: Vector3, other: PackedVector3Array) -> float:
	var best := INF
	for c in _capsules(other):
		best = minf(best, _point_capsule(point, c))
	return best


static func _capsules(p: PackedVector3Array) -> Array:
	var caps: Array = []
	var seg := func(na: String, nb: String, r: float) -> void:
		caps.append({"a": p[DB.joint(na)], "b": p[DB.joint(nb)], "r": r, "na": na, "nb": nb})
	seg.call("Core", "Neck", 0.13)
	seg.call("LeftHip", "RightHip", 0.11)
	seg.call("LeftHip", "LeftKnee", 0.075)
	seg.call("RightHip", "RightKnee", 0.075)
	seg.call("LeftKnee", "LeftAnkle", 0.05)
	seg.call("RightKnee", "RightAnkle", 0.05)
	seg.call("LeftShoulder", "LeftElbow", 0.05)
	seg.call("RightShoulder", "RightElbow", 0.05)
	seg.call("LeftElbow", "LeftWrist", 0.04)
	seg.call("RightElbow", "RightWrist", 0.04)
	caps.append({"a": p[DB.joint("Head")], "b": p[DB.joint("Head")], "r": 0.10, "na": "Head", "nb": "Head", "sphere": true})
	return caps


static func _excluded(c: Dictionary) -> bool:
	if bool(c.get("sphere", false)):
		return false
	return EXCL.has(c["na"]) or EXCL.has(c["nb"])


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


static func _restore_pins(men: Array, pins: Array) -> void:
	for pin in pins:
		var m := int(pin["m"])
		var j := int(pin["j"])
		var p: PackedVector3Array = men[m]
		p[j] = pin["pos"]
		men[m] = p
