extends "res://tools/belt_match_film.gd"
## S389 (operator, three stills: "the fighters are not even close to each other and also red fighter goes inside the floor"):
## bars on the bodies AS DRAWN, every frame of a belt match, read on Skeleton3D.skeleton_updated. bjj9_probe measures the joints,
## which never showed either fault.
##  - FLOOR: the deepest drawn capsule below the mat.
##  - APART: on the ground, how far apart the two bodies' surfaces are; the longest run apart.
##  - INSIDE: how deep the torsos sit in each other.
##  - LIMBS (S391): how deep a limb or head of one woman sits in the other's torso, pelvis or head, on GrappleDrawn.parts, the
##    same capsules the game places by. HEAD, FOREARM and SHIN name the judged defects. RUN is the longest stretch over the bar:
##    a limb sweeping past for a few frames is not what a judge sees, a limb parked in a body is.
##  - HOLDS (S391): of the frames where the data says a hand holds the other woman, how many have the drawn palm off her drawn skin.
##  - HUMAN (S391): how far the drawn limbs sit from the recording. Read it beside LIMBS: without it a limb thrown clear reads as contact fixed.
## Run: --headless --path . --fixed-fps 30 --script res://tools/bjj_drawn_bars.gd -- match=1 bracket=1 own=armbar_guard secs=310 seed=28
## Prints DRAWN lines and quits 1 on a failed bar.

const GD := preload("res://scripts/grapple/GrappleDrawn.gd")
const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")
const Grip := preload("res://scripts/grapple/GrappleGrip.gd")

const FLOOR_BAR_M := 0.04      # a surface may press this far into the mat
const APART_M := 0.06          # surfaces further than this on the ground are not touching
const APART_RUN_BAR_S := 1.0   # the longest moment on the ground without touching
const INSIDE_BAR_M := 0.10     # torso into torso
const LIMB_BAR_M := 0.06       # flesh gives about this much under a real hold (grapple_contact_test's own 6 cm cap)
const LIMB_RUN_BAR_S := 0.5    # the longest a limb may sit past that
const POP_BAR_M := 0.15        # tools/bjj_tremble_probe's own pop bar
const HUMAN_BAR_M := 0.35       # a knee, elbow, hand or foot further than this from the recording is another pose, not a correction
const HOLD_GAP_M := 0.05       # a palm further than this off her skin is holding air
const HOLD_BAR := 0.15         # the share of held hand-frames that may do so
const BODY_PARTS := ["pelvis", "trunk", "head"]
const CAPS := [["Hips", "Spine", 0.14], ["Spine", "Neck", 0.13], ["Neck", "Head", 0.09], ["LeftUpperArm", "LeftLowerArm", 0.06],
	["RightUpperArm", "RightLowerArm", 0.06], ["LeftLowerArm", "LeftHand", 0.045], ["RightLowerArm", "RightHand", 0.045],
	["LeftUpperLeg", "LeftLowerLeg", 0.10], ["RightUpperLeg", "RightLowerLeg", 0.10], ["LeftLowerLeg", "LeftFoot", 0.065],
	["RightLowerLeg", "RightFoot", 0.065]]

var _cache: Array = [{}, {}]
var _watching := false
var _frames := 0
var _floor_worst := 0.0
var _floor_t := 0.0
var _floor_who := ""
var _below := 0
var _inside_worst := 0.0
var _inside_t := 0.0
var _ground := 0
var _apart := 0
var _run := 0.0
var _run_worst := 0.0
var _run_t := 0.0
var _gap_worst := 0.0
var _done := false
var _limb_worst := {}          # part name -> [depth, t, into]
var _limb_over := 0
var _limb_run := 0.0
var _limb_run_worst := 0.0
var _limb_run_t := 0.0
var _limb_run_who := ""
var _limb_sum := 0.0
var _limb_all := PackedFloat32Array()
var _last := {}
var _pop_n := 0
var _pop_worst := 0.0
var _pop_t := 0.0
var _pop_who := ""
var _pop_log := 0
var _human_worst := 0.0
var _human_t := 0.0
var _human_who := ""
var _human_over := 0
var _hold_n := 0
var _hold_off := 0
var _hold_sum := 0.0
var _limb_pairs := {}          # "part>body" -> frames it was the deepest past the bar


func _watch() -> void:
	var men: Array = b.get("player").get("men")
	if men.size() < 2:
		return
	_watching = true
	for i in 2:
		var skel := (men[i] as Node).get_parent() as Skeleton3D
		skel.skeleton_updated.connect(func(): _cache[i] = GD.read_bones(skel))


func _dist(a: Dictionary, c: Array, d: Dictionary, e: Array) -> float:
	var pts := Geometry3D.get_closest_points_between_segments(a[c[0]], a[c[1]], d[e[0]], d[e[1]])
	return (pts[0] as Vector3).distance_to(pts[1]) - float(c[2]) - float(e[2])


func _measure(t: float, pos_c: String) -> void:
	var a: Dictionary = _cache[0]
	var d: Dictionary = _cache[1]
	if a.size() < 10 or d.size() < 10:
		return
	_frames += 1
	var low := INF
	var low_who := ""
	for side in [a, d]:
		for c in CAPS:
			var y := minf((side[c[0]] as Vector3).y, (side[c[1]] as Vector3).y) - float(c[2])
			if y < low:
				low = y
				low_who = str(c[1])
	if -low > _floor_worst:
		_floor_worst = -low
		_floor_t = t
		_floor_who = low_who
	if -low > FLOOR_BAR_M:
		_below += 1
	var gap := INF
	var torso := INF
	for c in CAPS:
		for e in CAPS:
			var x := _dist(a, c, d, e)
			gap = minf(gap, x)
			if str(c[0]) in ["Hips", "Spine"] and str(e[0]) in ["Hips", "Spine"]:
				torso = minf(torso, x)
	if -torso > _inside_worst:
		_inside_worst = -torso
		_inside_t = t
	_limbs(t, a, d)
	_holds(t, a, d)
	_human(t)
	_pops(t, [a, d])
	if pos_c == "standing":
		_run = 0.0
		return
	_ground += 1
	_gap_worst = maxf(_gap_worst, gap)
	if gap > APART_M:
		_apart += 1
		_run += 1.0 / 30.0
		if absf(_run - 1.0) < 0.017:
			print("APART t=%.1f gap=%.2f at %s moving %s" % [t, gap, str(b.get("db")[int(b.get("current"))].get("title", "")).left(30), str((b.get("moving") as Dictionary).get("t", {}).get("title", "-")).left(30)])
		if _run > _run_worst:
			_run_worst = _run
			_run_t = t
	else:
		_run = 0.0


## The deepest limb or head of either woman in the other's torso, pelvis or head this frame, by part.
func _limbs(t: float, a: Dictionary, d: Dictionary) -> void:
	var pa := GD.parts(a)
	var pd := GD.parts(d)
	var deepest := 0.0
	var who := ""
	for pair in [[pa, pd], [pd, pa]]:
		for x in pair[0]["all"]:
			if str(x[0]) in ["pelvis", "trunk"]:
				continue
			for y in pair[1]["all"]:
				if not str(y[0]) in BODY_PARTS:
					continue
				var pts := Geometry3D.get_closest_points_between_segments(x[1], x[2], y[1], y[2])
				var dd: float = float(x[3]) + float(y[3]) - (pts[0] as Vector3).distance_to(pts[1])
				if dd <= 0.0:
					continue
				if dd > deepest:
					deepest = dd
					who = "%s>%s" % [x[0], y[0]]
				var key := str(x[0])
				if dd > float(_limb_worst.get(key, [0.0])[0]):
					_limb_worst[key] = [dd, t, str(y[0])]
	_limb_all.append(deepest)
	_limb_sum += deepest
	if deepest > LIMB_BAR_M:
		_limb_over += 1
		_limb_pairs[who] = int(_limb_pairs.get(who, 0)) + 1
		_limb_run += 1.0 / 30.0
		if _limb_run > _limb_run_worst:
			_limb_run_worst = _limb_run
			_limb_run_t = t
			_limb_run_who = "%s %.3f" % [who, deepest]
	else:
		_limb_run = 0.0


## The worst one-frame steps of the limbs' middles and ends: a swing that jumps is worse than the overlap it cured.
func _pops(t: float, bones: Array) -> void:
	for w in 2:
		for n in ["LeftLowerLeg", "RightLowerLeg", "LeftLowerArm", "RightLowerArm", "LeftFoot", "RightFoot", "LeftHand", "RightHand"]:
			var key := "%d%s" % [w, n]
			var now: Vector3 = bones[w][n]
			if _last.has(key):
				var step: float = now.distance_to(_last[key])
				if step > POP_BAR_M:
					_pop_n += 1
					if step > _pop_worst:
						_pop_worst = step
						_pop_t = t
						_pop_who = key
			_last[key] = now


## S391 (operator on the finish: "blue doesn t even look like a human"): the contact bars read green while GrappleLimbs had folded her knees
## behind her hips and put a foot by her shoulder. A limb may give way to a body; it may not leave the recording this far.
func _human(t: float) -> void:
	var men: Array = b.get("player").get("men")
	var worst := 0.0
	var who := ""
	var bent := false
	for w in 2:
		var pose: Node = men[w]
		var skel := pose.get_parent() as Skeleton3D
		var rec: Dictionary = GD.recorded(pose, skel, pose.get("world_shift"))
		var fix: Dictionary = pose.get("limb_fix")
		for k in rec:
			var r: Array = rec[k]
			var f: Array = fix.get(k, [])
			var end: Vector3 = (r[1] as Vector3) + ((f[1] as Vector3) if not f.is_empty() else Vector3.ZERO)
			var src: String = "Left" if str(k).begins_with("Left") else "Right"
			var part: String = "Lower" + ("Arm" if str(k).ends_with("Arm") else "Leg")
			var mid: Vector3 = _cache[w].get(src + part, r[0])
			var off: float = mid.distance_to(r[0])
			if off > worst:
				worst = off
				who = "%d%s" % [w, k]
			if end.distance_to(r[1]) > worst:
				worst = end.distance_to(r[1])
				who = "%d%s end" % [w, k]
	if worst > _human_worst:
		_human_worst = worst
		_human_t = t
		_human_who = who
	if worst > HUMAN_BAR_M:
		_human_over += 1


## Where the data says a hand holds the other woman, is the drawn hand on her drawn skin?
func _holds(t: float, a: Dictionary, d: Dictionary) -> void:
	var men: Array = b.get("player").get("men")
	var j: Array = [(men[0] as Node).get("joints"), (men[1] as Node).get("joints")]
	var parts := [GD.parts(a), GD.parts(d)]
	var bones := [a, d]
	for w in 2:
		var want: Vector2 = Grip.targets(j[w], j[1 - w])
		for k in 2:
			if want[k] < 0.5:
				continue
			var side: String = ["Left", "Right"][k]
			var wrist: Vector3 = bones[w][side + "Hand"]
			var palm: Vector3 = wrist + (wrist - (bones[w][side + "LowerArm"] as Vector3)).normalized() * 0.08
			var gap := INF
			for c in parts[1 - w]["all"]:
				var q := Geometry3D.get_closest_point_to_segment(palm, c[1], c[2])
				gap = minf(gap, palm.distance_to(q) - float(c[3]))
			_hold_n += 1
			if gap > HOLD_GAP_M:
				_hold_off += 1
				_hold_sum += gap


func _process(delta: float) -> bool:
	if b.get("player") != null and not _watching:
		_watch()
	var m: Node = b.get_node_or_null("BeltMatch")
	if m != null and _watching:
		_measure(_t, BjjMatch.classify(m.call("_tags", int(b.get("current")))))
	var finished: bool = super._process(delta)
	if finished and not _done:
		_done = true
		var fails := 0 if _frames > 0 else 1
		fails += _bar(_floor_worst <= FLOOR_BAR_M, "floor: deepest %.3f m at %.1f s (%s), %d frames over the bar" % [_floor_worst, _floor_t, _floor_who, _below])
		fails += _bar(_run_worst <= APART_RUN_BAR_S, "apart: longest run on the ground %.1f s at %.1f s, %d of %d ground frames, widest %.2f m" % [_run_worst, _run_t, _apart, _ground, _gap_worst])
		fails += _bar(_inside_worst <= INSIDE_BAR_M, "inside: torsos %.3f m deep at %.1f s" % [_inside_worst, _inside_t])
		_limb_all.sort()
		var p95: float = _limb_all[int(_limb_all.size() * 0.95)] if _limb_all.size() > 0 else 0.0
		fails += _bar(_limb_run_worst <= LIMB_RUN_BAR_S, "limbs: longest run past %.2f m %.1f s at %.1f s (%s), %d of %d frames, p95 %.3f m, mean %.3f m" % [
			LIMB_BAR_M, _limb_run_worst, _limb_run_t, _limb_run_who, _limb_over, _frames, p95, _limb_sum / maxf(1.0, _frames)])
		var off: float = float(_hold_off) / maxf(1.0, _hold_n)
		fails += _bar(off <= HOLD_BAR, "holds: %d of %d held hand-frames off her skin (%.0f%%), mean gap %.3f m" % [_hold_off, _hold_n, off * 100.0, _hold_sum / maxf(1.0, _hold_off)])
		fails += _bar(_human_over == 0, "human: limbs off the recording worst %.3f m at %.1f s (%s), %d frames past %.2f m" % [_human_worst, _human_t, _human_who, _human_over, HUMAN_BAR_M])
		print("DRAWN pops: %d steps over %.2f m, worst %.3f m at %.1f s (%s)" % [_pop_n, POP_BAR_M, _pop_worst, _pop_t, _pop_who])
		var keys := _limb_worst.keys()
		keys.sort_custom(func(x, y): return float(_limb_worst[x][0]) > float(_limb_worst[y][0]))
		for k in keys:
			print("DRAWN limb %-10s deepest %.3f m at %.1f s into %s" % [k, float(_limb_worst[k][0]), float(_limb_worst[k][1]), _limb_worst[k][2]])
		print("DRAWN limb frames past the bar by pair: %s" % str(_limb_pairs))
		print("DRAWN frames=%d failures=%d" % [_frames, fails])
	return finished


func _bar(ok: bool, what: String) -> int:
	print("DRAWN %s %s" % ["PASS" if ok else "FAIL", what])
	return 0 if ok else 1
