extends "res://tools/pics2d_anim_more.gd"
## BOUNCE1 (S565, ops/research/TASK_BOUNCE1.md): never still. While the player plans, the page showed the hold run and then
## stood on its last picture - two statues. This makes a short LOOP per hold (and the guard), range and corner:
## <corner>_<hold>_bob[_r1|_r2], the hold's last picture with both men bouncing lightly on the spot.
## HOW (a lower-body layer, not a bake): the hold take stays frozen on its last picture (the arms, the guard, the head as
## authored); a small modifier added LAST on each skeleton (Bob, below) lowers and sways the hips and bends the legs back
## onto where the ankles stood (the two-bone solve of FootLock/FloorStand, the foot keeping its turn). Why not the takes
## on disk: ow_bounce_idle moves the hips 0.19 m and turns 30 deg, st_bounce_guard has its own arms and stance - laid
## under the authored holds they move the feet off the hold's spots (a jump) and the arms with the torso. The layer cannot
## move a foot: the feet are pinned to the hold's own, the loop starts on the hold's last picture (dip 0, sway 0).
## Both men bounce (the other man in his guard), red a fifth of a cycle behind blue: lockstep reads as a machine
## (GuardLife: "bounce correlated 0.92"). The page loops the frames, BOB_CYCLE s round (proto/twohands/ring_ui.js).
## Separate file because pics2d_anim_more.gd is at the 500-line cap. Same command as pics2d_anim_more.gd with
##   --script res://tools/pics2d_bob.gd -- <out_dir> art=toon set=m south=blue [only=...]
## Prints BOB_GATE <run>: head and ankle movement against the hold's last picture, per man (bars below).

const BOB_CYCLE := 0.5                         # s a bounce (about 2 a second)
const BOB_T := [0.0, 0.1, 0.2, 0.3, 0.4]       # the loop's pictures; the page goes from the last back to the first
const BOB_DIP_M := [0.026, 0.026]              # how far the hips sink at the bottom (red, blue)
const BOB_SWAY_M := [0.012, 0.012]             # forward / back over the feet, a light rock
const BOB_PHASE := [0.2, 0.0]                  # of a cycle: red behind blue
const BOB_HEAD_M := 0.03                       # bar: the head inside the hold's height +- this
const BOB_FEET_M := 0.005                      # bar: an ankle this near where the hold has it


class Bob extends SkeletonModifier3D:
	var hips := -1
	var legs: Array = []
	var dip := 0.0           # world m down
	var sway := Vector3.ZERO # world m
	var head := -1
	var seen: Array = []     # world [head, left ankle, right ankle] as drawn (the stage's reads come before the modifiers)

	func _process_modification() -> void:
		var skel := get_skeleton()
		if skel == null or hips < 0:
			return
		var xf := skel.global_transform
		if dip != 0.0 or sway != Vector3.ZERO:
			_bob(skel, xf)
		seen = [xf * skel.get_bone_global_pose(head).origin, xf * skel.get_bone_global_pose(legs[0][2]).origin, xf * skel.get_bone_global_pose(legs[1][2]).origin]

	func _bob(skel: Skeleton3D, xf: Transform3D) -> void:
		var ankles: Array = legs.map(func(ids): return skel.get_bone_global_pose(ids[2]).origin)
		var move := xf.basis.inverse() * (Vector3(0.0, -dip, 0.0) + sway)
		var parent := skel.get_bone_parent(hips)
		var pb := skel.get_bone_global_pose(parent).basis if parent >= 0 else Basis.IDENTITY
		skel.set_bone_pose_position(hips, skel.get_bone_pose_position(hips) + pb.inverse() * move)
		for i in legs.size():
			_reach(skel, legs[i], ankles[i])

	## FootLock._reach: hip ids[0], knee ids[1], ankle ids[2] meets target (skeleton space); the knee in its own plane, the
	## foot keeps its global turn.
	func _reach(skel: Skeleton3D, ids: Array, target: Vector3) -> void:
		var hg := skel.get_bone_global_pose(ids[0])
		var kg := skel.get_bone_global_pose(ids[1])
		var ag := skel.get_bone_global_pose(ids[2])
		var h := hg.origin
		var k := kg.origin
		var a := ag.origin
		var l1 := (k - h).length()
		var l2 := (a - k).length()
		var to := target - h
		if l1 < 1e-5 or l2 < 1e-5 or to.length() < 1e-5:
			return
		var d := clampf(to.length(), absf(l1 - l2) + 1e-3, (l1 + l2) * 0.999)
		var dir := to.normalized()
		var n := (k - h).cross(a - h)
		if n.length() < 1e-6:
			n = hg.basis.x
		n = n.normalized()
		var perp := n.cross(dir).normalized()
		if (k - h).dot(perp) < 0.0:
			perp = -perp
		var ca := clampf((l1 * l1 + d * d - l2 * l2) / (2.0 * l1 * d), -1.0, 1.0)
		var k2 := h + (dir * ca + perp * sqrt(1.0 - ca * ca)) * l1
		var t2 := h + dir * d
		var foot := ag.basis.get_rotation_quaternion()
		var turn := Quaternion((k - h).normalized(), (k2 - h).normalized())
		var q1 := turn * hg.basis.get_rotation_quaternion()
		var shin := (turn * (a - k)).normalized()
		var q2 := Quaternion(shin, (t2 - k2).normalized()) * turn * kg.basis.get_rotation_quaternion()
		var parent := skel.get_bone_parent(ids[0])
		var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
		skel.set_bone_pose_rotation(ids[0], (qp.inverse() * q1).normalized())
		skel.set_bone_pose_rotation(ids[1], (q1.inverse() * q2).normalized())
		skel.set_bone_pose_rotation(ids[2], (q2.inverse() * foot).normalized())


var bobs: Array = []


func _run() -> void:
	if _arg("mask", "on") != "off":
		mask = Mask.new(root, stage, cam, sv)
	for i in 2:   # LAST on each skeleton: after the take, the guard layers, FootTake and FloorStand
		var skel: Skeleton3D = stage.boxers[i]["skel"]
		var b := Bob.new()
		b.name = "BounceBob"
		b.hips = skel.find_bone("Hips")
		b.head = skel.find_bone("Head")
		for leg in [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot"], ["RightUpperLeg", "RightLowerLeg", "RightFoot"]]:
			b.legs.append((leg as Array).map(func(n): return skel.find_bone(str(n))))
		skel.add_child(b)
		bobs.append(b)
	for who in 2:
		var col: String = ["red", "blue"][who]
		for key in ["guard"] + HOLDS.keys():
			for rk in RANGE_IN:
				var name := "%s_%s_bob%s" % [col, key, rk]
				if _want(name):
					await _bob_run(who, str(key), name, float(RANGE_IN[rk]))
	_finish()


func _bob_at(t: float) -> void:
	for i in 2:
		var ph := TAU * (t / BOB_CYCLE + float(BOB_PHASE[i]))
		var fwd: Vector3 = (_node(i).global_transform.basis.z * Vector3(1, 0, 1)).normalized()
		bobs[i].dip = float(BOB_DIP_M[i]) * 0.5 * (1.0 - cos(ph))
		bobs[i].sway = fwd * float(BOB_SWAY_M[i]) * sin(ph)


func _bob_off() -> void:
	for b in bobs:
		b.dip = 0.0
		b.sway = Vector3.ZERO


## The hold run's own build (pics2d_anim_more._hold_run / the guard's _solo), stopped on its last picture; then the loop.
func _bob_run(who: int, key: String, name: String, in_m: float) -> void:
	var clip := "hold_" + key
	if key != "guard":
		_add_hold(who, clip)
		if not _has(who, clip):
			return
	var build := func() -> Array:
		_bob_off()
		await _home_guard(in_m, who)
		return [] if key == "guard" else [[0.0, func() -> void: stage.v2._play(who, clip, 0.0, "block", false)]]
	await _solo_at(build, Callable(), 0.0 if key == "guard" else float(HOLD_T[-1]))
	await process_frame
	_aim([0, 1])
	await process_frame
	var ref := _bob_read()
	var files: Array = []
	var worst := [[0.0, 0.0], [0.0, 0.0]]   # per man: [head up/down m, ankle m]
	for t in BOB_T:
		_bob_at(float(t))
		for _k in 2:
			await process_frame
		var now := _bob_read()
		for i in 2:
			worst[i][0] = maxf(worst[i][0], absf(float(now[i][0]) - float(ref[i][0])))
			worst[i][1] = maxf(worst[i][1], maxf((now[i][1] as Vector3).distance_to(ref[i][1]), (now[i][2] as Vector3).distance_to(ref[i][2])))
		var f := "%s_%d" % [name, files.size()]
		if not await _frame(f):
			refused += 1
			_bob_off()
			return
		files.append(f + ".png")
	_bob_off()
	var fails: Array = []
	for i in 2:
		if worst[i][0] > BOB_HEAD_M + 1e-4:
			fails.append("%s head %.3f m off the hold's height (bar %.2f)" % [["red", "blue"][i], worst[i][0], BOB_HEAD_M])
		if worst[i][1] > BOB_FEET_M:
			fails.append("%s ankle %.3f m off the hold's (bar %.3f)" % [["red", "blue"][i], worst[i][1], BOB_FEET_M])
	print("BOB_GATE %s: red head %.3f ankle %.4f, blue head %.3f ankle %.4f m %s" % [name, worst[0][0], worst[0][1], worst[1][0], worst[1][1], "PASS" if fails.is_empty() else "FAIL " + "; ".join(PackedStringArray(fails))])
	if not fails.is_empty():
		failed.append(name)
	runs[name] = {"files": files, "offs": BOB_T, "contact": -1, "clip": clip + "+bob", "loop": BOB_CYCLE, "gate_fails": fails}
	print("PICS2D_ANIM %s = %s + bob, %d frames" % [name, clip, files.size()])
	_save()


## per man: [head height, left ankle, right ankle] in world m as drawn (Bob.seen, after every layer)
func _bob_read() -> Array:
	var out: Array = []
	for i in 2:
		var sc: float = _node(i).scale.x
		var s: Array = bobs[i].seen
		out.append([(s[0] as Vector3).y / sc, (s[1] as Vector3) / sc, (s[2] as Vector3) / sc])
	return out
