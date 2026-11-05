extends SceneTree
## S383c OWNED MOCAP tremble bars (operator on the owned reel: "the knees are trembling again"). A baked clip on the body it
## was fitted to (mh_boxer_08), our own FK (no AnimationPlayer, no fight modifiers), every frame at 30 fps:
##   KNEE TREMBLE  the knee bend (deg, 0 = straight) minus its 5-frame quadratic Savitzky-Golay fit, RMS (deg), worse leg.
##                 The fit passes a 2.5 Hz stance bounce whole and a 5 Hz bounce at 91 %, a 10 Hz shake at 23 %: what is
##                 left is the >= 7.5 Hz shake (the S383b diagnosis calls the CMU actors' ~5 Hz knee bounce real, in the
##                 120 fps source - it is motion, kept). BAR: <= 1.2 x the reference idle's (mc_Box1_M3_Idle, our idle).
##                 band5 = the same with the 7-frame fit (the 5-7 Hz band counts too), printed, not a bar.
##                 Also printed (the S383b diagnosis' numbers): d2 = RMS second difference of the bend (deg/frame^2, real
##                 acceleration counts too), zz = reversals of its step within 3 frames per second (a >= 5 Hz zigzag).
##   POLE FLIPS    the knee's direction about the hip-ankle line (from the foot's line), bent > 15 deg: frames where it
##                 turns > 90 deg in one frame. BAR: 0.
##   SLIDE         tools/owned_mocap_measure.gd's plant slide (cm). BAR: <= 3.0.
##   POPS          any animated bone's LOCAL rotation turning > 15 deg in one frame. The punching arm's UpperArm /
##                 LowerArm are exempt while that wrist moves > 1.5 m/s against its shoulder (+-4 frames). BAR: 0.
##   WRIST         the fastest wrist against its shoulder (m/s, L / R) - a punch peak; smoothing must keep it.
##   <godot> --headless --audio-driver Dummy --path . --script res://tools/owned_mocap_bars.gd -- res=<a.res,...> [glb=]
## One OWNEDJIT line per clip, the idle first (its own reference).

const Measure := preload("res://tools/owned_mocap_measure.gd")
const IDLE := "res://assets/anim/baked/mc_Box1_M3_Idle.res"
const FPS := 30.0
const SG7 := [-2.0, 3.0, 6.0, 7.0, 6.0, 3.0, -2.0]   # / 21
const SG5 := [-3.0, 12.0, 17.0, 12.0, -3.0]   # / 35
const POP_DEG := 15.0
const PUNCH_MS := 1.5
const PUNCH_PAD := 4
const TREMBLE_BAR := 1.2
const SLIDE_BAR := 3.0


func _initialize() -> void:
	var paths: Array = []
	var glb := "mh_boxer_08"
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("res="):
			paths = Array(s.substr(4).split(",", false))
		elif s.begins_with("glb="):
			glb = s.substr(4)
	var rig := Measure.rig_for(glb)
	root.add_child(rig["body"])
	var idle := bars(load(IDLE) as Animation, rig)
	print("OWNEDJIT %s %s" % ["idle", line(idle, idle)])
	for p in paths:
		var b := bars(load(str(p)) as Animation, rig)
		print("OWNEDJIT %s %s" % [str(p).get_file().get_basename(), line(b, idle)])
	quit(0)


## The tremble bars of one clip on `rig` (Measure.rig_for).
static func bars(anim: Animation, rig: Dictionary) -> Dictionary:
	var d := Measure.sample(anim, rig)
	var P: Dictionary = d["pos"]
	var n: int = d["n"]
	var out := {"n": n, "secs": (n - 1) / FPS, "nan": d["nan"]}
	var trem := 0.0
	var band5 := 0.0
	var d2w := 0.0
	var zzw := 0.0
	var flips := 0
	var pole_max := 0.0
	for side in ["Left", "Right"]:
		var flex := []
		var pa := []
		for i in n:
			var H: Vector3 = P[side + "UpperLeg"][i]
			var K: Vector3 = P[side + "LowerLeg"][i]
			var A: Vector3 = P[side + "Foot"][i]
			var T: Vector3 = P[side + "Toes"][i]
			var fx := 180.0 - rad_to_deg((H - K).angle_to(A - K))
			flex.append(fx)
			var ax := (A - H).normalized()
			var v0 := (K - H) - ax * (K - H).dot(ax)
			var fd := (T - A) - ax * (T - A).dot(ax)
			pa.append(rad_to_deg(fd.signed_angle_to(v0, ax)) if fx > 15.0 and v0.length() > 0.005 and fd.length() > 0.005 else null)
		trem = maxf(trem, tremble(flex, SG5))
		band5 = maxf(band5, tremble(flex, SG7))
		var d1 := _diff(flex)
		d2w = maxf(d2w, _rms(_diff(d1)))
		zzw = maxf(zzw, _zigzag(d1, 0.1) / maxf(out["secs"], 1e-3))
		for i in range(1, n):
			if pa[i] == null or pa[i - 1] == null:
				continue
			var dd := absf(wrapf(float(pa[i]) - float(pa[i - 1]), -180.0, 180.0))
			pole_max = maxf(pole_max, dd)
			if dd > 90.0:
				flips += 1
	out["tremble"] = trem
	out["band5"] = band5
	out["d2"] = d2w
	out["zz"] = zzw
	out["flips"] = flips
	out["pole_max"] = pole_max
	var st := Measure.stats(d, 0, -1, {})
	out["slide"] = float(st["slide_max"])
	out["knee_p5"] = float(st["knee_p5"])
	out["knee_p95"] = float(st["knee_p95"])
	# Punch frames per arm: the wrist against its shoulder faster than PUNCH_MS, padded.
	var punch := {}
	var wrist := {}
	for side in ["Left", "Right"]:
		var fast := []
		fast.resize(n)
		fast.fill(false)
		var top := 0.0
		for i in range(1, n):
			var r1: Vector3 = (P[side + "Hand"][i] as Vector3) - (P[side + "UpperArm"][i] as Vector3)
			var r0: Vector3 = (P[side + "Hand"][i - 1] as Vector3) - (P[side + "UpperArm"][i - 1] as Vector3)
			var v := (r1 - r0).length() * FPS
			top = maxf(top, v)
			if v > PUNCH_MS:
				for j in range(maxi(0, i - PUNCH_PAD), mini(n, i + PUNCH_PAD + 1)):
					fast[j] = true
		punch[side] = fast
		wrist[side] = top
	out["wrist_l"] = wrist["Left"]
	out["wrist_r"] = wrist["Right"]
	# Local rotation pops (the keys are the bones' local rotations).
	var pops := 0
	var exempt := 0
	var worst := 0.0
	var per := {}
	for t in anim.get_track_count():
		if anim.track_get_type(t) != Animation.TYPE_ROTATION_3D:
			continue
		var bone := str(anim.track_get_path(t))
		var arm := ""
		for side in ["Left", "Right"]:
			if bone == side + "UpperArm" or bone == side + "LowerArm":
				arm = side
		var q0 := anim.rotation_track_interpolate(t, 0.0)
		for i in range(1, n):
			var q1 := anim.rotation_track_interpolate(t, minf(i / FPS, anim.length))
			var a := rad_to_deg(q0.angle_to(q1))
			q0 = q1
			if a <= POP_DEG:
				continue
			if arm != "" and punch[arm][i]:
				exempt += 1
				continue
			pops += 1
			worst = maxf(worst, a)
			per[bone] = int(per.get(bone, 0)) + 1
	out["pops"] = pops
	out["pops_punch"] = exempt
	out["pop_worst"] = worst
	var names: Array = per.keys()
	names.sort_custom(func(x, y): return per[x] > per[y])
	var s := ""
	for b in names.slice(0, 3):
		s += "%s:%d " % [b, per[b]]
	out["pop_top"] = s.strip_edges()
	return out


## RMS of a series minus its quadratic Savitzky-Golay fit `sg` (SG5 or SG7 weights; the end frames without a full
## window are left out).
static func tremble(x: Array, sg: Array) -> float:
	var res := []
	var h: int = sg.size() / 2
	var tot := 0.0
	for c in sg:
		tot += float(c)
	for i in range(h, x.size() - h):
		var s := 0.0
		for j in sg.size():
			s += float(sg[j]) * float(x[i - h + j])
		res.append(float(x[i]) - s / tot)
	return _rms(res)


## Which bars fail (empty = all pass), `idle` = the reference idle's bars.
static func failures(b: Dictionary, idle: Dictionary) -> Array:
	var why: Array = []
	if b["tremble"] > TREMBLE_BAR * float(idle["tremble"]) + 1e-6:
		why.append("knee tremble %.3f > %.3f" % [b["tremble"], TREMBLE_BAR * float(idle["tremble"])])
	if b["flips"] > 0:
		why.append("knee pole flips %d" % b["flips"])
	if b["slide"] > SLIDE_BAR:
		why.append("plant slide %.1f cm" % b["slide"])
	if b["pops"] > 0:
		why.append("pops %d (%s)" % [b["pops"], b["pop_top"]])
	return why


static func line(b: Dictionary, idle: Dictionary) -> String:
	var why := failures(b, idle)
	return "secs=%.1f knee_tremble=%.3f deg (bar %.3f) band5=%.3f d2=%.2f zz=%.2f/s knee_p5-p95=%.0f-%.0f pole_flips=%d (max %.0f deg/frame) slide=%.1f cm pops=%d (worst %.0f; %s; punch-arm exempt %d) wrist_peak L=%.2f R=%.2f m/s %s" % [
		b["secs"], b["tremble"], TREMBLE_BAR * float(idle["tremble"]), b["band5"], b["d2"], b["zz"], b["knee_p5"], b["knee_p95"], b["flips"], b["pole_max"], b["slide"],
		b["pops"], b["pop_worst"], b["pop_top"], b["pops_punch"], b["wrist_l"], b["wrist_r"],
		"PASS" if why.is_empty() else "FAIL " + "; ".join(why)]


static func _diff(x: Array) -> Array:
	var o := []
	for i in range(1, x.size()):
		o.append(float(x[i]) - float(x[i - 1]))
	return o


static func _rms(arr: Array) -> float:
	if arr.is_empty():
		return 0.0
	var s := 0.0
	for v in arr:
		s += float(v) * float(v)
	return sqrt(s / arr.size())


## Reversals of a series' steps (both > eps, opposite signs) within 3 frames of the previous reversal.
static func _zigzag(d1: Array, eps: float) -> int:
	var last := -100
	var cnt := 0
	for i in range(1, d1.size()):
		var a: float = d1[i - 1]
		var b: float = d1[i]
		if a * b < 0.0 and absf(a) > eps and absf(b) > eps:
			if i - last <= 3:
				cnt += 1
			last = i
	return cnt
