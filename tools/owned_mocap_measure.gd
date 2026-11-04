extends SceneTree
## S383 OWNED MOCAP bars: a baked clip (tools/owned_mocap_bake.gd output, the 25 tracks of mc_Box1_M3_Idle) played on the
## body it was fitted to, measured frame by frame (our own FK on the rest pose - no AnimationPlayer, no fight modifiers).
##   <godot> --headless --path . --script res://tools/owned_mocap_measure.gd -- res=<a.res,b.res> [glb=mh_boxer_08] [win=40]
## One OWNEDBAR line per clip (and, past win seconds, the best win-second window as an OWNEDWIN line):
##   secs, plant slide cm (max / mean), knee bend deg (min-max, p5-p95, locked share), stance cm (median ball to ball),
##   hips cm vs our idle (median), elbow deg (min-max), guard down (longest run s, share), pops (frame-to-frame > 15 deg).
## PLANT: a run of >= 0.2 s where the ball of the foot (the toe joint) is within 2.5 cm of that foot's floor (its 5th
## percentile height) and moving slower than 0.25 m/s along the floor; its slide = the farthest the ball gets from where
## the run started (cm). A creeping foot inside a plant shows; a stepping foot is not a plant.
## GUARD DOWN: a wrist more than 30 cm under its shoulder (a hand at the hip or the belt; a body shot is a short run).
## LOCKED KNEE: bend under 8 deg (0 = straight); a run of >= 0.5 s of it counts as locked.
## WALK: feet passing = the line from the right ball to the left (> 15 cm) points > 120 deg away from where it pointed
## 0.5-1.5 s before (a pivot turns it slower). A boxer keeps his stance, a walk passes the feet every step. Reported as
## feet_pass (passes) and the share of frames passed.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const IDLE := "res://assets/anim/baked/mc_Box1_M3_Idle.res"
const FPS := 30.0
const FLOOR_BAND := 0.025
const PLANT_SPEED := 0.25
const PLANT_MIN_S := 0.2
const GUARD_DROP := 0.30
const LOCK_DEG := 8.0
const LOCK_MIN_S := 0.5
const POP_DEG := 15.0
const JOINTS := ["Hips", "Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes", "RightUpperLeg", "RightLowerLeg",
	"RightFoot", "RightToes", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"]


func _initialize() -> void:
	var paths: Array = []
	var glb := "mh_boxer_08"
	var win := 40.0
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("res="):
			paths = Array(s.substr(4).split(",", false))
		elif s.begins_with("glb="):
			glb = s.substr(4)
		elif s.begins_with("win="):
			win = float(s.substr(4))
	var rig := rig_for(glb)
	root.add_child(rig["body"])
	var idle := stats(sample(load(IDLE) as Animation, rig), 0, -1, {})
	print("OWNEDBAR idle %s" % line(idle))
	for p in paths:
		var d := sample(load(str(p)) as Animation, rig)
		var st := stats(d, 0, -1, idle)
		print("OWNEDBAR %s %s" % [str(p).get_file().get_basename(), line(st)])
		if st["secs"] > win + 0.01:
			var best := best_window(d, win, idle)
			print("OWNEDWIN %s %.1f-%.1f s %s" % [str(p).get_file().get_basename(), best["t0"], best["t1"], line(best)])
	quit(0)


## The body the bars are read on: its skeleton, parents, rest locals and its node chain (scale / axis turn).
static func rig_for(glb: String) -> Dictionary:
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % glb)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var xf := Transform3D.IDENTITY
	var cur: Node = skel
	while cur != null:
		if cur is Node3D:
			xf = (cur as Node3D).transform * xf
		cur = cur.get_parent()
	var par := []
	var rest := []
	for i in skel.get_bone_count():
		par.append(skel.get_bone_parent(i))
		rest.append(skel.get_bone_rest(i))
	var ji := {}
	for j in JOINTS:
		ji[j] = skel.find_bone(j)
	return {"body": body, "skel": skel, "xf": xf, "par": par, "rest": rest, "ji": ji}


## Per frame: world joint positions (JOINTS) and the tracked bones' global rotations (for pops).
static func sample(anim: Animation, rig: Dictionary) -> Dictionary:
	var skel: Skeleton3D = rig["skel"]
	var par: Array = rig["par"]
	var rest: Array = rig["rest"]
	var xf: Transform3D = rig["xf"]
	var rot_t := {}
	var pos_t := {}
	for t in anim.get_track_count():
		var b := skel.find_bone(str(anim.track_get_path(t)))
		if b < 0:
			continue
		if anim.track_get_type(t) == Animation.TYPE_ROTATION_3D:
			rot_t[b] = t
		elif anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
			pos_t[b] = t
	var n := int(round(anim.length * FPS)) + 1
	var pos := {}
	for j in JOINTS:
		pos[j] = []
	var grot := []
	var nan := false
	for f in n:
		var t := minf(f / FPS, anim.length)
		var g := []
		g.resize(par.size())
		for i in par.size():
			var r: Transform3D = rest[i]
			var local := r
			if rot_t.has(i):
				var q := anim.rotation_track_interpolate(rot_t[i], t)
				if not q.is_finite():
					nan = true
				local = Transform3D(Basis(q), r.origin)
			if pos_t.has(i):
				var v := anim.position_track_interpolate(pos_t[i], t)
				if not v.is_finite():
					nan = true
				local.origin = r.origin + v
			g[i] = (g[par[i]] as Transform3D) * local if par[i] >= 0 else local
		for j in JOINTS:
			pos[j].append(xf * (g[rig["ji"][j]] as Transform3D).origin)
		var gr := {}
		for b in rot_t:
			gr[b] = (g[b] as Transform3D).basis.get_rotation_quaternion()
		grot.append(gr)
	var names := {}
	for b in rot_t:
		names[b] = skel.get_bone_name(b)
	return {"n": n, "pos": pos, "grot": grot, "nan": nan, "tracks": anim.get_track_count(), "length": anim.length, "names": names}


static func _angle(a: Vector3, j: Vector3, b: Vector3) -> float:
	return rad_to_deg((a - j).angle_to(b - j))


static func _pct(arr: Array, p: float) -> float:
	if arr.is_empty():
		return 0.0
	var s := arr.duplicate()
	s.sort()
	return float(s[clampi(int(s.size() * p), 0, s.size() - 1)])


## The plants of one foot inside frames [i0, i1): [[start frame, slide m], ...].
static func plants(ball: Array, i0: int, i1: int) -> Array:
	var hs: Array = []
	for i in range(i0, i1):
		hs.append((ball[i] as Vector3).y)
	var fl := _pct(hs, 0.05)
	var out: Array = []
	var start := -1
	for i in range(i0, i1 + 1):
		var on := false
		if i < i1 and i > i0:
			var d: Vector3 = (ball[i] as Vector3) - (ball[i - 1] as Vector3)
			on = (ball[i] as Vector3).y - fl < FLOOR_BAND and Vector2(d.x, d.z).length() * FPS < PLANT_SPEED
		if on and start < 0:
			start = i - 1
		elif not on and start >= 0:
			if (i - start) >= int(PLANT_MIN_S * FPS):
				var p0: Vector3 = ball[start]
				var far := 0.0
				for k in range(start, i):
					var d2: Vector3 = (ball[k] as Vector3) - p0
					far = maxf(far, Vector2(d2.x, d2.z).length())
				out.append([start, far])
			start = -1
	return out


## Longest run (frames) of `flag` true inside [i0, i1), and the share of true frames.
static func _runs(flag: Array, i0: int, i1: int) -> Array:
	var best := 0
	var cur := 0
	var on := 0
	for i in range(i0, i1):
		if flag[i]:
			cur += 1
			on += 1
			best = maxi(best, cur)
		else:
			cur = 0
	return [best, float(on) / maxf(1.0, i1 - i0)]


## The bars over frames [i0, i1) (i1 = -1: to the end). `idle` (its stats) gives the hips reference.
static func stats(d: Dictionary, i0: int, i1: int, idle: Dictionary) -> Dictionary:
	var n: int = d["n"]
	if i1 < 0:
		i1 = n
	var P: Dictionary = d["pos"]
	var slides: Array = []
	for side in ["Left", "Right"]:
		for pl in plants(P[side + "Toes"], i0, i1):
			slides.append(pl[1] * 100.0)
	var knees: Array = []
	var locked: Array = []
	var elbows: Array = []
	var down: Array = []
	var stance: Array = []
	var hips: Array = []
	var balls: Array = []
	var lead: Array = []
	locked.resize(n)
	down.resize(n)
	for i in n:
		locked[i] = false
		down[i] = false
	for i in range(i0, i1):
		var lk := false
		for side in ["Left", "Right"]:
			var bend := 180.0 - _angle(P[side + "UpperLeg"][i], P[side + "LowerLeg"][i], P[side + "Foot"][i])
			knees.append(bend)
			lk = lk or bend < LOCK_DEG
			elbows.append(_angle(P[side + "UpperArm"][i], P[side + "LowerArm"][i], P[side + "Hand"][i]))
			if (P[side + "Hand"][i] as Vector3).y < (P[side + "UpperArm"][i] as Vector3).y - GUARD_DROP:
				down[i] = true
			balls.append((P[side + "Toes"][i] as Vector3).y)
		locked[i] = lk
		var dl: Vector3 = (P["LeftToes"][i] as Vector3) - (P["RightToes"][i] as Vector3)
		stance.append(Vector2(dl.x, dl.z).length() * 100.0)
		lead.append(Vector2(dl.x, dl.z))
		hips.append((P["Hips"][i] as Vector3).y)
	var pops := 0
	var worst := 0.0
	var G: Array = d["grot"]
	var per := {}
	for i in range(i0 + 1, i1):
		for b in G[i]:
			var a := rad_to_deg((G[i - 1][b] as Quaternion).angle_to(G[i][b] as Quaternion))
			worst = maxf(worst, a)
			if a > POP_DEG:
				pops += 1
				per[b] = int(per.get(b, 0)) + 1
	var top: Array = per.keys()
	top.sort_custom(func(x, y): return per[x] > per[y])
	var pop_top := ""
	for b in top.slice(0, 3):
		pop_top += "%s:%d " % [d["names"][b], per[b]]
	var lr := _runs(locked, i0, i1)
	var gr := _runs(down, i0, i1)
	var smax := 0.0
	var ssum := 0.0
	var over := 0
	for s in slides:
		smax = maxf(smax, s)
		ssum += s
		if s > 3.0:
			over += 1
	var hips_med := _pct(hips, 0.5)
	# Feet passing: the right-to-left ball line (> 15 cm long) turned > 120 deg from where it pointed 0.5-1.5 s before.
	var swaps := 0
	var off := 0
	var was := false
	for j in lead.size():
		var ref := Vector2.ZERO
		for m in range(maxi(0, j - 45), maxi(0, j - 15)):
			ref += lead[m]
		var v: Vector2 = lead[j]
		var flip := ref.length() > 0.01 and v.length() > 0.15 and absf(rad_to_deg(v.angle_to(ref))) > 120.0
		if flip:
			off += 1
			if not was:
				swaps += 1
		was = flip
	return {
		"secs": (i1 - i0 - 1) / FPS, "plants": slides.size(), "slide_max": smax,
		"slide_mean": ssum / maxf(1.0, slides.size()), "slide_over3": over,
		"knee_min": _pct(knees, 0.0), "knee_max": _pct(knees, 1.0), "knee_p5": _pct(knees, 0.05), "knee_p95": _pct(knees, 0.95),
		"locked_run_s": lr[0] / FPS, "locked_share": lr[1],
		"elbow_min": _pct(elbows, 0.0), "elbow_max": _pct(elbows, 1.0), "elbow_p5": _pct(elbows, 0.05), "elbow_p95": _pct(elbows, 0.95),
		"guard_down_run_s": gr[0] / FPS, "guard_down_share": gr[1],
		"stance_cm": _pct(stance, 0.5), "hips_m": hips_med,
		"hips_vs_idle_cm": (hips_med - float(idle.get("hips_m", hips_med))) * 100.0,
		"ball_floor_p5_cm": _pct(balls, 0.05) * 100.0,
		"lead_swaps": swaps, "lead_off_share": float(off) / maxf(1.0, lead.size()),
		"pops": pops, "worst_pop_deg": worst, "pop_top": pop_top.strip_edges(), "nan": d["nan"], "tracks": d["tracks"],
	}


## Fails the operator's bars: a plant sliding > 3 cm, a knee locked >= 0.5 s, the guard down > 2 s.
static func verdict(st: Dictionary) -> String:
	var why: Array = []
	if st["slide_max"] > 3.0:
		why.append("slide %.1f cm on a plant (%d plants > 3 cm)" % [st["slide_max"], st["slide_over3"]])
	if st["locked_run_s"] >= LOCK_MIN_S:
		why.append("knee locked %.1f s" % st["locked_run_s"])
	if st["guard_down_run_s"] > 2.0:
		why.append("guard down %.1f s" % st["guard_down_run_s"])
	return "PASS" if why.is_empty() else "FAIL " + "; ".join(why)


static func line(st: Dictionary) -> String:
	return "secs=%.1f slide_cm max=%.1f mean=%.1f (%d plants, %d>3) knee=%.0f-%.0f (p5-p95 %.0f-%.0f, locked run %.2f s) stance=%.0f cm hips_vs_idle=%+.1f cm elbow=%.0f-%.0f (p5-p95 %.0f-%.0f) guard_down run=%.1f s share=%.0f%% feet_pass=%d (passed %.0f%%) pops=%d (worst %.0f deg; %s) ball_floor=%.1f cm %s" % [
		st["secs"], st["slide_max"], st["slide_mean"], st["plants"], st["slide_over3"], st["knee_min"], st["knee_max"],
		st["knee_p5"], st["knee_p95"], st["locked_run_s"], st["stance_cm"], st["hips_vs_idle_cm"], st["elbow_min"],
		st["elbow_max"], st["elbow_p5"], st["elbow_p95"], st["guard_down_run_s"], 100.0 * st["guard_down_share"], st["lead_swaps"], 100.0 * st["lead_off_share"], st["pops"],
		st["worst_pop_deg"], st["pop_top"], st["ball_floor_p5_cm"], verdict(st)]


## The best `win`-second window, 1 s steps: fewest plants over 3 cm, then the shortest guard drop, then the lowest slide.
static func best_window(d: Dictionary, win: float, idle: Dictionary) -> Dictionary:
	var n: int = d["n"]
	var w := int(win * FPS) + 1
	var best := {}
	var best_score := INF
	var s := 0
	while s + w <= n:
		var st := stats(d, s, s + w, idle)
		var score: float = st["slide_over3"] * 1000.0 + st["guard_down_run_s"] * 50.0 + st["locked_run_s"] * 50.0 + st["slide_max"]
		if score < best_score:
			best_score = score
			best = st
			best["t0"] = s / FPS
			best["t1"] = (s + w - 1) / FPS
		s += int(FPS)
	return best
