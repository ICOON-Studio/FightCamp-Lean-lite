extends SceneTree
## S383d FootPlant frame-rate independence (operator: "the video clip is lagging ... the knees are trembling again";
## tools/owned_mocap_jitter.gd: the films ran FootPlant on the wall-clock delta and a seek ran it twice a frame, so what
## it drew depended on the render speed). Our boxer (mh_boxer_08) plays the idle while his body glides sideways at
## GLIDE_V for GLIDE_S (the fight's footwork: the guard plays, the body moves, FootPlant steps the feet), then stands.
## FootPlant.step runs the same 3 s once at a 1/30 s step and once at a 0.2 s step; read every 0.2 s:
##   both runs' feet travel (sum of the 0.2 s moves) agree within 10 %, and the feet end within 3 cm of each other;
##   the feet still do FootPlant's job at 1/30: while the body stands (before the glide, and from SETTLE_S after it) each
##   foot is held (moves < 2 mm in a frame) at least HELD_SHARE of the frames the clip's own foot is; during the glide it STEPS (its fastest
##   frame tops STEP_X x the body's speed - a skating foot moves at the body's speed); both end within END_M of the clip's
##   feet (before the IK: a plant may sit STEP_M off, and the stance stretch moves each foot ~6 cm). (A fast sideways glide steps both feet nearly all the time - the S376 reach rule, legs near full stretch in
##   this stance; the S383 FootPlant held 3 % / 8 % of that glide, this one 3 % / 3 %.)
##   a repeat pass in the same frame does not run the clock twice (it redoes the frame: same targets).

const Measure := preload("res://tools/owned_mocap_measure.gd")
const FootPlant := preload("res://scripts/fight3d/FootPlant.gd")
const IDLE := "res://assets/anim/baked/mc_Box1_M3_Idle.res"
const TOTAL_S := 3.0
const GLIDE_T0 := 0.4
const GLIDE_S := 1.2
const GLIDE_V := 0.8
const HELD_SHARE := 0.9
const SETTLE_S := 0.6
const STEP_X := 1.5
const END_M := 0.16          # a plant may sit STEP_M off, plus the S314 stance stretch (~6 cm a foot here)

var checks := 0
var failures := 0


func _initialize() -> void:
	var rig := Measure.rig_for("mh_boxer_08")
	var body: Node3D = rig["body"]
	root.add_child(body)
	await process_frame   # the tree is live: global poses and transforms update
	var skel: Skeleton3D = rig["skel"]
	var anim := load(IDLE) as Animation
	var fine := _run(body, skel, anim, 1.0 / 30.0)
	var coarse := _run(body, skel, anim, 0.2)
	var a: Array = fine["at02"]
	var b: Array = coarse["at02"]
	_check(a.size() == b.size() and a.size() >= 15, "both runs read every 0.2 s (%d / %d)" % [a.size(), b.size()])
	for leg in 2:
		var ta := _travel(a, leg)
		var tb := _travel(b, leg)
		var end := _flat((a[a.size() - 1][leg] as Vector3) - (b[b.size() - 1][leg] as Vector3))
		print("FOOT_PLANT leg %d travel 1/30 %.3f m, 0.2 s %.3f m, end apart %.3f m, held standing %.0f %%, held gliding %.0f %%, fastest %.2f m/s, end off clip %.3f m" % [
			leg, ta, tb, end, 100.0 * float(fine["held"][leg]), 100.0 * float(fine["held_glide"][leg]), float(fine["vmax"][leg]), float(fine["end_off"][leg])])
		_check(absf(ta - tb) <= 0.1 * maxf(ta, tb), "leg %d: travel at 1/30 s and 0.2 s steps within 10 %% (%.3f / %.3f m)" % [leg, ta, tb])
		_check(end <= 0.03, "leg %d: the feet end within 3 cm at both steps (%.3f m)" % [leg, end])
		_check(ta >= GLIDE_V * GLIDE_S * 0.8, "leg %d: the foot followed the body (travel %.2f m of %.2f)" % [leg, ta, GLIDE_V * GLIDE_S])
		_check(float(fine["held"][leg]) >= HELD_SHARE * float(fine["held_raw"][leg]), "leg %d: held %.0f %% of the frames the body stands (the clip's own foot %.0f %%, bar %.0f %% of it)" % [
			leg, 100.0 * float(fine["held"][leg]), 100.0 * float(fine["held_raw"][leg]), 100.0 * HELD_SHARE])
		_check(float(fine["vmax"][leg]) >= STEP_X * GLIDE_V, "leg %d: steps during the glide (fastest %.2f m/s, body %.2f)" % [leg, float(fine["vmax"][leg]), GLIDE_V])
		_check(float(fine["end_off"][leg]) <= END_M, "leg %d: ends within %.0f cm of the clip's foot (%.3f m)" % [leg, END_M * 100.0, float(fine["end_off"][leg])])
	# A second pass in the same frame: _process_modification reloads the frame's start state, so the target is the same.
	var fp := FootPlant.new()
	fp.setup(skel, null, body)
	body.position = Vector3.ZERO
	_pose(skel, anim, 0.0)
	fp.step(skel, 1.0 / 30.0)
	var st: Dictionary = fp._save()
	body.position = Vector3(0.05, 0.0, 0.0)
	_pose(skel, anim, 1.0 / 30.0)
	fp.step(skel, 1.0 / 30.0)
	var once: Array = fp.last_target.duplicate()
	fp._load(st)
	_pose(skel, anim, 1.0 / 30.0)
	fp.step(skel, 1.0 / 30.0)
	_check(_flat((once[0] as Vector3) - (fp.last_target[0] as Vector3)) < 1e-4, "a repeat pass redoes the frame (same target)")
	fp.free()
	print("FOOT_PLANT checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


## One run at step `dt`: targets every 0.2 s, the share of glide frames each foot is held, and how far each foot ends
## from the clip's own.
func _run(body: Node3D, skel: Skeleton3D, anim: Animation, dt: float) -> Dictionary:
	var fp := FootPlant.new()
	fp.setup(skel, null, body)
	body.position = Vector3.ZERO
	var n := int(round(TOTAL_S / dt))
	var every := maxi(1, int(round(0.2 / dt)))
	var at02: Array = []
	var held := [0, 0]
	var held_g := [0, 0]
	var vmax := [0.0, 0.0]
	var glide := 0
	var stand := 0
	var held_raw := [0, 0]
	var raw_prev: Array = []
	var last_raw: Array = []
	var prev: Array = []
	for f in n + 1:
		var t := f * dt
		body.position = Vector3(GLIDE_V * clampf(t - GLIDE_T0, 0.0, GLIDE_S), 0.0, 0.0)
		_pose(skel, anim, fmod(t, anim.length))
		# The clip's own feet (before FootPlant's IK), in the body's frame and in the world.
		var raw_now: Array = []
		var raw_w: Array = []
		for leg in 2:
			raw_w.append(skel.global_transform * skel.get_bone_global_pose(skel.find_bone(str(FootPlant.LEGS[leg][2]))).origin)
			raw_now.append((raw_w[leg] as Vector3) - body.position)
		fp.step(skel, dt)
		var tg: Array = fp.last_target.duplicate()
		if f % every == 0:
			at02.append(tg)
		if not prev.is_empty():
			var gliding := t > GLIDE_T0 and t <= GLIDE_T0 + GLIDE_S
			var standing := t <= GLIDE_T0 or t >= GLIDE_T0 + GLIDE_S + SETTLE_S
			glide += 1 if gliding else 0
			stand += 1 if standing else 0
			for leg in 2:
				var mv := _flat((tg[leg] as Vector3) - (prev[leg] as Vector3))
				if gliding:
					vmax[leg] = maxf(float(vmax[leg]), mv / dt)
					held_g[leg] += 1 if mv < 0.002 * dt * 30.0 else 0
				if standing:
					held[leg] += 1 if mv < 0.002 * dt * 30.0 else 0
					held_raw[leg] += 1 if _flat((raw_now[leg] as Vector3) - (raw_prev[leg] as Vector3)) < 0.002 * dt * 30.0 else 0
		prev = tg
		raw_prev = raw_now
		last_raw = raw_w
	var end_off := []
	for leg in 2:
		end_off.append(_flat((prev[leg] as Vector3) - (last_raw[leg] as Vector3)))
	fp.free()
	return {"at02": at02, "held": [held[0] / maxf(1.0, stand), held[1] / maxf(1.0, stand)],
		"held_raw": [held_raw[0] / maxf(1.0, stand), held_raw[1] / maxf(1.0, stand)], "held_glide": [held_g[0] / maxf(1.0, glide), held_g[1] / maxf(1.0, glide)], "vmax": vmax, "end_off": end_off}


static func _travel(at: Array, leg: int) -> float:
	var s := 0.0
	for i in range(1, at.size()):
		s += _flat((at[i][leg] as Vector3) - (at[i - 1][leg] as Vector3))
	return s


## The clip's pose at time t (rotations; the hips offset from rest).
static func _pose(skel: Skeleton3D, anim: Animation, t: float) -> void:
	for k in anim.get_track_count():
		var b := skel.find_bone(str(anim.track_get_path(k)))
		if b < 0:
			continue
		if anim.track_get_type(k) == Animation.TYPE_ROTATION_3D:
			skel.set_bone_pose_rotation(b, anim.rotation_track_interpolate(k, t))
		elif anim.track_get_type(k) == Animation.TYPE_POSITION_3D:
			skel.set_bone_pose_position(b, skel.get_bone_rest(b).origin + anim.position_track_interpolate(k, t))


static func _flat(v: Vector3) -> float:
	return Vector2(v.x, v.z).length()


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
	print(("ok   " if ok else "FAIL ") + what)
