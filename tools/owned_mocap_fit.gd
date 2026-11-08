extends RefCounted
## RETARGET2B, the last steps of tools/owned_mocap_bake.gd on a baked clip: where the feet should be, and the stance width.
##   targets(): each ankle's path is the actor's, scaled to our legs, measured from the point between OUR first-frame ankles,
##     so the stance across the hips is the actor's by construction. A plant holds its run's mean spot; the offset fades in
##     and out over EDGE frames and is low-passed (the same shape as owned_mocap_plant.gd's pin), so no knee jump at a plant's edge.
##   width_fit(): pulls the feet along OUR hip line until the stance is inside ROOM of the actor's, the pull low-passed so it
##     cannot shake a knee; a foot that is planted lends its share to the free foot. One last unsmoothed round only for
##     frames still past HARD_ROOM.

const Plant := preload("res://tools/owned_mocap_plant.gd")
const Smooth := preload("res://tools/owned_mocap_smooth.gd")
const EDGE := 5
const OFF_HZ := 5.0
const ROOM := 0.08
const HARD_ROOM := 0.13
const HARD_HZ := 10.0
const FOLLOW_ROUNDS := 2
## A foot is planted when it is on the floor AND nearly still: an actor shuffling his feet keeps them low but moving (Win clips).
const PLANT_SPEED := 0.35
const PLANT_MIN_RUN := 4
const FPS := 30.0
const SIDES := ["Left", "Right"]
static var room_soft := ROOM
static var room_hard := HARD_ROOM
static var exact_round := false
static var double_pull := true
static var pin_last := false
static var lock_planted := false
static var hard_hz := HARD_HZ
static var still_plants := true
static var pre_smooth := false
static var smooth_target := 0.05


static func targets(anim: Animation, skel: Skeleton3D, tr: Dictionary, bi: Dictionary, frames: Array, S: Quaternion, k: float) -> Dictionary:
	var first_mid: Vector3 = (Plant._glob(skel, anim, tr, bi["LeftFoot"], 0).origin + Plant._glob(skel, anim, tr, bi["RightFoot"], 0).origin) * 0.5
	var source_mid: Vector3 = ((frames[0]["P"]["LeftFoot"] as Vector3) + (frames[0]["P"]["RightFoot"] as Vector3)) * 0.5
	var want := {}
	var on := {}
	for side in SIDES:
		var source_floor := INF
		for frame in frames:
			source_floor = minf(source_floor, (frame["P"][side + "Foot"] as Vector3).y)
		var path: Array = []
		var planted: Array = []
		for frame in frames:
			var at: Vector3 = frame["P"][side + "Foot"]
			path.append(first_mid + S * (at - source_mid) * k)
			planted.append(at.y <= source_floor + 0.03)
		if still_plants:
			planted = _still_only(path, planted)
		var offs := _plant_offsets(path, planted)
		for j in path.size():
			path[j] = (path[j] as Vector3) + (offs[j] as Vector3)
		want[side] = path
		on[side] = planted
	return {"want": want, "on": on}


static func _still_only(path: Array, low: Array) -> Array:
	var n := path.size()
	var out: Array = []
	out.resize(n)
	out.fill(false)
	var a := 0
	while a < n:
		var still: bool = low[a] and _speed(path, a) < PLANT_SPEED
		if not still:
			a += 1
			continue
		var e := a
		while e < n and low[e] and _speed(path, e) < PLANT_SPEED:
			e += 1
		if e - a >= PLANT_MIN_RUN:
			for j in range(a, e):
				out[j] = true
		a = e
	return out


static func _speed(path: Array, i: int) -> float:
	var a: Vector3 = path[maxi(0, i - 1)]
	var b: Vector3 = path[mini(path.size() - 1, i + 1)]
	var d := b - a
	d.y = 0.0
	return d.length() * FPS / maxf(1.0, float(mini(path.size() - 1, i + 1) - maxi(0, i - 1)))


static func _plant_offsets(path: Array, planted: Array) -> Array:
	var n := path.size()
	var off: Array = []
	var weight: Array = []
	var inside: Array = []
	off.resize(n)
	weight.resize(n)
	off.fill(Vector3.ZERO)
	weight.fill(0.0)
	var a := 0
	while a < n:
		if not planted[a]:
			a += 1
			continue
		var e := a
		var mean := Vector3.ZERO
		while e < n and planted[e]:
			mean += path[e]
			e += 1
		mean /= float(e - a)
		for j in range(a, e):
			var d: Vector3 = mean - (path[j] as Vector3)
			d.y = 0.0
			off[j] = d
			weight[j] = 2.0
			if j > a and j < e - 1:
				inside.append([j, d])
		var first: Vector3 = off[a]
		var last: Vector3 = off[e - 1]
		for i in EDGE:
			var w := Plant._ease(float(i + 1) / float(EDGE + 1))
			var before := a - EDGE + i
			var after := e + EDGE - 1 - i
			if before >= 0 and float(weight[before]) < w:
				off[before] = first * w
				weight[before] = w
			if after < n and float(weight[after]) < w:
				off[after] = last * w
				weight[after] = w
		a = e
	var soft := Smooth.filter_vec(off, Smooth.kernel(OFF_HZ))
	# Inside a plant the foot is exactly on its spot: a low-passed offset would hand the actor's fast foot noise back to it.
	for entry in inside:
		soft[entry[0]] = entry[1]
	return soft


## Every planted frame back onto its target, then the stance width.
static func finish(anim: Animation, skel: Skeleton3D, tr: Dictionary, bi: Dictionary, frames: Array, k: float, want: Dictionary, on: Dictionary, follow_rounds: int = FOLLOW_ROUNDS, up: Vector3 = Vector3.UP) -> void:
	for round_i in follow_rounds:
		for side in SIDES:
			var leg := [bi[side + "UpperLeg"], bi[side + "LowerLeg"], bi[side + "Foot"]]
			var deltas: Array = []
			for fi in frames.size():
				deltas.append((want[side][fi] as Vector3) - Plant._glob(skel, anim, tr, leg[2], fi).origin)
			deltas = Smooth.filter_vec(deltas, Smooth.kernel(OFF_HZ))
			for fi in frames.size():
				if (deltas[fi] as Vector3).length() >= 0.0005:
					Plant._leg_ik(anim, skel, tr, side, leg, fi, deltas[fi])
	if pre_smooth:
		Smooth.smooth(anim, ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"], {}, smooth_target)
	var left_share := _left_share(on, frames.size())
	for round_i in 3:
		_width_round(anim, skel, tr, bi, frames, k, left_share, on, round_i < 2, false)
	if pin_last:
		Plant.pin(anim, skel, up)
	if lock_planted:
		for side in SIDES:
			var leg := [bi[side + "UpperLeg"], bi[side + "LowerLeg"], bi[side + "Foot"]]
			for fi in frames.size():
				if on[side][fi]:
					Plant._leg_ik(anim, skel, tr, side, leg, fi, (want[side][fi] as Vector3) - Plant._glob(skel, anim, tr, leg[2], fi).origin)
	if exact_round:
		_width_round(anim, skel, tr, bi, frames, k, left_share, on, false, true)


static func _left_share(on: Dictionary, n: int) -> Array:
	var share: Array = []
	for fi in n:
		var left_on: bool = on["Left"][fi]
		var right_on: bool = on["Right"][fi]
		var value := 0.5
		if left_on != right_on:
			value = 0.0 if left_on else 1.0
		share.append(Vector3(value, 0.0, 0.0))
	return Smooth.filter_vec(share, Smooth.kernel(OFF_HZ))


static func _width_round(anim: Animation, skel: Skeleton3D, tr: Dictionary, bi: Dictionary, frames: Array, k: float, left_share: Array, on: Dictionary, smooth_it: bool, exact: bool) -> void:
	var room := room_soft if smooth_it else room_hard
	var pulls: Array = []
	var lines: Array = []
	for fi in frames.size():
		var sp: Dictionary = frames[fi]["P"]
		var sl: Vector3 = (sp["LeftUpperLeg"] as Vector3) - (sp["RightUpperLeg"] as Vector3)
		sl.y = 0.0
		var ol: Vector3 = Plant._glob(skel, anim, tr, bi["LeftUpperLeg"], fi).origin - Plant._glob(skel, anim, tr, bi["RightUpperLeg"], fi).origin
		ol.y = 0.0
		if sl.length() < 1e-5 or ol.length() < 1e-5:
			pulls.append(Vector3.ZERO)
			lines.append(Vector3.ZERO)
			continue
		sl = sl.normalized()
		ol = ol.normalized()
		var goal: float = ((sp["LeftFoot"] as Vector3) - (sp["RightFoot"] as Vector3)).dot(sl) * k
		var have: float = (Plant._glob(skel, anim, tr, bi["LeftFoot"], fi).origin - Plant._glob(skel, anim, tr, bi["RightFoot"], fi).origin).dot(ol)
		var allowed := room * maxf(absf(goal), 0.02)
		pulls.append(Vector3(goal + clampf(have - goal, -allowed, allowed) - have, 0.0, 0.0))
		lines.append(ol)
	if not exact and (smooth_it or hard_hz > 0.0):
		pulls = Smooth.filter_vec(pulls, Smooth.kernel(OFF_HZ if smooth_it else hard_hz))
	for fi in frames.size():
		var pull: float = (pulls[fi] as Vector3).x
		if absf(pull) < 0.0005 or (lines[fi] as Vector3) == Vector3.ZERO:
			continue
		if not double_pull and on["Left"][fi] and on["Right"][fi]:
			continue
		var share: float = (left_share[fi] as Vector3).x
		var left := [bi["LeftUpperLeg"], bi["LeftLowerLeg"], bi["LeftFoot"]]
		var right := [bi["RightUpperLeg"], bi["RightLowerLeg"], bi["RightFoot"]]
		Plant._leg_ik(anim, skel, tr, "Left", left, fi, (lines[fi] as Vector3) * pull * share)
		Plant._leg_ik(anim, skel, tr, "Right", right, fi, -(lines[fi] as Vector3) * pull * (1.0 - share))
