extends RefCounted
## S383 OWNED MOCAP, the planted-foot pin (the last step of tools/owned_mocap_bake.gd, on the baked Animation).
## The bake's hips correction lands OUR ball of the foot where the ACTOR's lands - so the actor's own creep (mocap toe
## markers drift 2-13 cm inside a plant) and what one hips shift cannot fix (two planted feet with different errors) both
## stay. Here each plant of OUR baked foot is pinned: a run of >= 4 frames with the ball within 3 cm of that foot's floor
## and slower than 0.35 m/s along it is held at the run's mean spot (its height untouched) by two-bone leg IK (thigh +
## shin, the knee kept in its own plane, the foot's world rotation kept), blended in and out over the run's edge frames.
## Writes the UpperLeg / LowerLeg / Foot rotation keys again. Returns how many frames were pinned per foot.

const FPS := 30.0
const BAND := 0.03
const SPEED := 0.35
const MIN_RUN := 4
const EDGE := 2.0


static func _tracks(anim: Animation) -> Dictionary:
	var t := {}
	for i in anim.get_track_count():
		var key := str(anim.track_get_path(i))
		if anim.track_get_type(i) == Animation.TYPE_POSITION_3D:
			key += "@pos"
		t[key] = i
	return t


## The bone's global transform at key `k`: tracked bones from the keys, the rest from the skeleton's rest.
static func _glob(skel: Skeleton3D, anim: Animation, tr: Dictionary, b: int, k: int) -> Transform3D:
	var x := Transform3D.IDENTITY
	var cur := b
	while cur >= 0:
		var nm := skel.get_bone_name(cur)
		var local := skel.get_bone_rest(cur)
		if tr.has(nm):
			local = Transform3D(Basis(anim.track_get_key_value(tr[nm], k) as Quaternion), local.origin)
		if tr.has(nm + "@pos"):
			local.origin += anim.track_get_key_value(tr[nm + "@pos"], k) as Vector3
		x = local * x
		cur = skel.get_bone_parent(cur)
	return x


static func pin(anim: Animation, skel: Skeleton3D, up: Vector3) -> Dictionary:
	var tr := _tracks(anim)
	var n := anim.track_get_key_count(tr["Hips"])
	var out := {}
	for side in ["Left", "Right"]:
		var bu := skel.find_bone(side + "UpperLeg")
		var bl := skel.find_bone(side + "LowerLeg")
		var bf := skel.find_bone(side + "Foot")
		var bt := skel.find_bone(side + "Toes")
		if skel.get_bone_parent(bl) != bu or skel.get_bone_parent(bf) != bl:
			print("OWNEDMOCAP PIN skipped %s: the leg chain is not thigh -> shin -> foot" % side)
			continue
		var ball := []
		for k in n:
			ball.append(_glob(skel, anim, tr, bt, k).origin)
		var hs: Array = []
		for p in ball:
			hs.append((p as Vector3).dot(up))
		var sorted := hs.duplicate()
		sorted.sort()
		var fl: float = sorted[int(sorted.size() * 0.05)]
		# Runs of a planted ball.
		var runs: Array = []
		var s := -1
		for k in n + 1:
			var on := false
			if k < n:
				var v: Vector3 = (ball[k] as Vector3) - (ball[maxi(0, k - 1)] as Vector3)
				v -= up * v.dot(up)
				on = float(hs[k]) - fl < BAND and v.length() * FPS < SPEED
			if on and s < 0:
				s = k
			elif not on and s >= 0:
				if k - s >= MIN_RUN:
					runs.append([s, k])
				s = -1
		var pinned := 0
		for r in runs:
			var a: int = r[0]
			var e: int = r[1]
			var mean := Vector3.ZERO
			for k in range(a, e):
				mean += ball[k]
			mean /= float(e - a)
			for k in range(a, e):
				var w := clampf(minf(float(k - a + 1), float(e - k)) / EDGE, 0.0, 1.0)
				var d: Vector3 = mean - (ball[k] as Vector3)
				d -= up * d.dot(up)
				if d.length() < 0.001:
					continue
				_leg_ik(anim, skel, tr, side, [bu, bl, bf], k, d * w)
				pinned += 1
		out[side] = pinned
	return out


## Moves the ankle by `d` (skeleton space): thigh + shin re-aimed, the knee kept on its side, the foot's world turn kept.
static func _leg_ik(anim: Animation, skel: Skeleton3D, tr: Dictionary, side: String, b: Array, k: int, d: Vector3) -> void:
	var gu := _glob(skel, anim, tr, b[0], k)
	var gl := _glob(skel, anim, tr, b[1], k)
	var gf := _glob(skel, anim, tr, b[2], k)
	var H := gu.origin
	var K := gl.origin
	var A := gf.origin
	var l1 := (K - H).length()
	var l2 := (A - K).length()
	var At := A + d
	var dist := clampf((At - H).length(), absf(l1 - l2) + 0.001, (l1 + l2) * 0.995)
	var dir := (At - H).normalized()
	var axis := dir.cross(K - H)
	if axis.length() < 1e-6:
		return
	axis = axis.normalized()
	var cos_a := clampf((l1 * l1 + dist * dist - l2 * l2) / (2.0 * l1 * dist), -1.0, 1.0)
	var Kt := H + dir.rotated(axis, acos(cos_a)) * l1
	At = H + dir * dist
	var q1 := Quaternion((K - H).normalized(), (Kt - H).normalized())
	var shin := (q1 * (A - K)).normalized()
	var q2 := Quaternion(shin, (At - Kt).normalized())
	var ru := (q1 * gu.basis.get_rotation_quaternion()).normalized()
	var rl := (q2 * q1 * gl.basis.get_rotation_quaternion()).normalized()
	var par := skel.get_bone_parent(b[0])
	var pg := _glob(skel, anim, tr, par, k).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
	anim.track_set_key_value(tr[side + "UpperLeg"], k, (pg.inverse() * ru).normalized())
	anim.track_set_key_value(tr[side + "LowerLeg"], k, (ru.inverse() * rl).normalized())
	anim.track_set_key_value(tr[side + "Foot"], k, (rl.inverse() * gf.basis.get_rotation_quaternion()).normalized())
