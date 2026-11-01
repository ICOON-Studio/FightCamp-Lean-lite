extends SceneTree
## GROUND2A: mount / side control / back / full guard keyframes stop sinking through each other (capsule push-out), cheaply
## enough to run every frame (S337).

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Contact := preload("res://scripts/grapple/GrappleContact.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")

const SCALE := 0.97
const REF_BUDGET := 8.0
const REF_REPEATS := 25
const TAGS := ["mount", "side_control", "back", "full_guard"]

var failures := 0


func _initialize() -> void:
	var db: Array = DB.load_db()
	var seqs := _tagged_sequences(db)
	_check(seqs.size() >= 20, "%d sequences in mount / side_control / back / full_guard" % seqs.size())
	var control_deep := 0
	var control_n := 0
	var fixed_depths: Array = []
	var grip_moves: Array = []
	var motion_means: Array = []
	var spent_us := 0
	var ref_us := 0
	for seq in seqs:
		var frames: Array = seq["frames"]
		var f0: Array = frames[0]
		var centre := _pair_centre(f0)
		for f in frames:
			var raw := _scaled_frame(f, centre, SCALE)
			var pen := Contact.penetration(raw)
			control_n += 1
			if float(pen["depth"]) > 0.02:
				control_deep += 1
			var t0 := Time.get_ticks_usec()
			var sep := Contact.separate(raw)
			spent_us += Time.get_ticks_usec() - t0
			# S341: the same fixed workload, timed beside it, so a busy cloud runner slows both.
			var t1 := Time.get_ticks_usec()
			_reference_work(raw)
			ref_us += Time.get_ticks_usec() - t1
			fixed_depths.append(float(Contact.penetration(sep)["depth"]))
			grip_moves.append_array(_grip_motion(raw, sep))
			motion_means.append(_mean_motion(raw, sep))
	var control_share := float(control_deep) / maxf(1.0, control_n)
	# S337: it runs every frame of the browser, so it must be cheap.
	var per_ms := spent_us / 1000.0 / maxf(1.0, control_n)
	# S341: CI runners read 3.8-9.6 ms where this PC reads 1.5, so the bound is in units of the reference workload.
	var cost := float(spent_us) / maxf(1.0, ref_us)
	print("  push-out %.2f ms a frame = %.2f x the reference workload" % [per_ms, cost])
	_check(cost < REF_BUDGET, "push-out costs %.2f x the reference (< %.1f)" % [cost, REF_BUDGET])
	print("  control share deeper than 2 cm: %.1f%% (%d / %d)" % [control_share * 100.0, control_deep, control_n])
	_check(control_share > 0.20, "control instrument reads overlap: %.1f%% > 20%%" % (control_share * 100.0))
	fixed_depths.sort()
	grip_moves.sort()
	motion_means.sort()
	var med := _median(fixed_depths)
	var p95 := _percentile(fixed_depths, 0.95)
	print("  fixed depth median %.4f m, 95%% %.4f m" % [med, p95])
	_check(med < 0.005 and p95 < 0.02, "fixed depth median %.4f m, 95%% %.4f m" % [med, p95])
	var grip_p95 := _percentile(grip_moves, 0.95)
	print("  grip wrist motion 95%% %.4f m (n=%d)" % [grip_p95, grip_moves.size()])
	_check(grip_moves.is_empty() or grip_p95 < 0.03, "gripped wrists stay put: 95%% %.4f m" % grip_p95)
	var motion_p95 := _percentile(motion_means, 0.95)
	var motion_med := _median(motion_means)
	print("  mean joint motion median %.4f m, 95%% %.4f m" % [motion_med, motion_p95])
	_check(motion_med < 0.05 and motion_p95 < 0.05, "motion kept: median %.4f m, 95%% %.4f m" % [motion_med, motion_p95])
	print("FAIL %d" % failures if failures else "PASS grapple_contact_test")
	quit(1 if failures else 0)


func _tagged_sequences(db: Array) -> Array:
	var seen := {}
	var out: Array = []
	for tag in TAGS:
		for s in DB.tagged(db, [tag]):
			var k := int(s["line"])
			if seen.has(k):
				continue
			seen[k] = true
			out.append(s)
	return out


func _pair_centre(f0: Array) -> Vector3:
	var c0: Vector3 = (f0[0] as PackedVector3Array)[DB.joint("Core")]
	var c1: Vector3 = (f0[1] as PackedVector3Array)[DB.joint("Core")]
	var c := (c0 + c1) * 0.5
	return Vector3(c.x, 0.0, c.z)


func _scaled_frame(f: Array, centre: Vector3, scale: float) -> Array:
	var out: Array = []
	for m in 2:
		var p := PackedVector3Array()
		p.resize(DB.JOINTS.size())
		for j in DB.JOINTS.size():
			var v: Vector3 = (f[m] as PackedVector3Array)[j]
			p[j] = (v - centre) * scale
		out.append(p)
	return out


func _grip_motion(before: Array, after: Array) -> Array:
	var moves: Array = []
	for m in 2:
		for side in ["Left", "Right"]:
			var j := DB.joint(side + "Wrist")
			var w: Vector3 = before[m][j]
			if Contact.body_distance(w, before[1 - m]) > 0.05:
				continue
			moves.append(before[m][j].distance_to(after[m][j]))
	return moves


func _mean_motion(before: Array, after: Array) -> float:
	var sum := 0.0
	var n := 0
	for m in 2:
		for j in DB.JOINTS.size():
			sum += before[m][j].distance_to(after[m][j])
			n += 1
	return sum / maxf(1, n)


## Every joint pair of the two bodies, distance only: what a naive full overlap pass would cost.
func _reference_work(frame: Array) -> float:
	var a: PackedVector3Array = frame[0]
	var b: PackedVector3Array = frame[1]
	var s := 0.0
	for _r in REF_REPEATS:
		for i in a.size():
			for j in b.size():
				s += a[i].distance_squared_to(b[j])
	return s


func _median(sorted: Array) -> float:
	if sorted.is_empty():
		return 0.0
	return float(sorted[sorted.size() / 2])


func _percentile(sorted: Array, frac: float) -> float:
	if sorted.is_empty():
		return 0.0
	var pos := frac * float(sorted.size() - 1)
	var lo := int(floor(pos))
	var hi := mini(lo + 1, sorted.size() - 1)
	return lerpf(float(sorted[lo]), float(sorted[hi]), pos - float(lo))


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
