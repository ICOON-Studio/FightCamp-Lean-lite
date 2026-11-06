extends "res://tools/belt_match_film.gd"
## S389 (operator, three stills: "the fighters are not even close to each other and also red fighter goes inside the floor"):
## bars on the bodies AS DRAWN, every frame of a belt match, read on Skeleton3D.skeleton_updated. bjj9_probe measures the joints,
## which never showed either fault.
##  - FLOOR: the deepest drawn capsule below the mat.
##  - APART: on the ground, how far apart the two bodies' surfaces are; the longest run apart.
##  - INSIDE: how deep the torsos sit in each other.
## Run: --headless --path . --fixed-fps 30 --script res://tools/bjj_drawn_bars.gd -- match=1 bracket=1 own=armbar_guard secs=310 seed=28
## Prints DRAWN lines and quits 1 on a failed bar.

const GD := preload("res://scripts/grapple/GrappleDrawn.gd")
const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")

const FLOOR_BAR_M := 0.04      # a surface may press this far into the mat
const APART_M := 0.06          # surfaces further than this on the ground are not touching
const APART_RUN_BAR_S := 1.0   # the longest moment on the ground without touching
const INSIDE_BAR_M := 0.10     # torso into torso
const CAPS := [["Hips", "Spine", 0.14], ["Spine", "Neck", 0.13], ["Neck", "Head", 0.09], ["LeftUpperArm", "LeftLowerArm", 0.06],
	["RightUpperArm", "RightLowerArm", 0.06], ["LeftLowerArm", "LeftHand", 0.045], ["RightLowerArm", "RightHand", 0.045],
	["LeftUpperLeg", "LeftLowerLeg", 0.10], ["RightUpperLeg", "RightLowerLeg", 0.10], ["LeftLowerLeg", "LeftFoot", 0.065],
	["RightLowerLeg", "RightFoot", 0.065]]

var _cache: Array = [{}, {}]
var _watching := false
var _frames := 0
var _floor_worst := 0.0
var _floor_t := 0.0
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
	for side in [a, d]:
		for c in CAPS:
			low = minf(low, minf((side[c[0]] as Vector3).y, (side[c[1]] as Vector3).y) - float(c[2]))
	if -low > _floor_worst:
		_floor_worst = -low
		_floor_t = t
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
	if pos_c == "standing":
		_run = 0.0
		return
	_ground += 1
	_gap_worst = maxf(_gap_worst, gap)
	if gap > APART_M:
		_apart += 1
		_run += 1.0 / 30.0
		if _run > _run_worst:
			_run_worst = _run
			_run_t = t
	else:
		_run = 0.0


func _process(delta: float) -> bool:
	if b.get("player") != null and not _watching:
		_watch()
	var m: Node = b.get_node_or_null("BeltMatch")
	if m != null and _watching:
		_measure(_t, BjjMatch.classify(m.call("_tags", int(b.get("current")))))
	var finished: bool = super._process(delta)
	if finished and not _done:
		_done = true
		var fails := 0
		fails += _bar(_floor_worst <= FLOOR_BAR_M, "floor: deepest %.3f m at %.1f s, %d frames over the bar" % [_floor_worst, _floor_t, _below])
		fails += _bar(_run_worst <= APART_RUN_BAR_S, "apart: longest run on the ground %.1f s at %.1f s, %d of %d ground frames, widest %.2f m" % [_run_worst, _run_t, _apart, _ground, _gap_worst])
		fails += _bar(_inside_worst <= INSIDE_BAR_M, "inside: torsos %.3f m deep at %.1f s" % [_inside_worst, _inside_t])
		print("DRAWN frames=%d failures=%d" % [_frames, fails])
	return finished


func _bar(ok: bool, what: String) -> int:
	print("DRAWN %s %s" % ["PASS" if ok else "FAIL", what])
	return 0 if ok else 1
