extends Node
## S376 KNOCKDOWN1 (the S375 itch scan, ops/research/S375_ITCH_MMA_SCAN.md: MMA Career Simulator's knockdown - punch at
## 1.8 s, fully down by 2.6 s; Physics MMA replays its finishes in slow motion): after a knockdown's fall has played live
## (LIVE_AFTER_S past the shot), the ring freezes and the shot plays again from LEAD_S before it to TAIL_S after it at
## SLOW speed under a REPLAY banner; then the count goes on where it froze.
## S379 C222 (operator on the FIGHT9 round-9 film at 1:40.5, this replay: "why you keep zooming in and out and rotate all at
## the same time, it is like you try to make the player throw up" - it cut to a lens behind the downed boxer's back that
## orbited 8 deg/s while it followed the pair in and out): shot like TV's replays (docs/TV_CAMERA_RULES.md: "a few fixed
## slow-motion angles joined by straight cuts", 2-4 s each, no camera behind a boxer). ANGLES split the replay into FIXED
## lenses, each placed once from where both boxers stood over its stretch and never moved: the main side wide (the side
## the live lens was on), the punch from the reverse three-quarter (low, toward the puncher, so the hit face shows), the
## fall from high over the canvas on the main side.
## Each boxer's skeleton carries a PoseRecorder (the last modifier: the pose as shown). The freeze is the scene tree's
## pause; this node and the two skeletons (with their modifiers) keep processing so the recorders can draw.
##   var r := KnockdownReplay.new(); view.add_child(r); r.setup(view)   r.knockdown(down_who, shot_view_t)   r.active()

const PoseRecorder := preload("res://scripts/fight3d/PoseRecorder.gd")
const TvShot := preload("res://scripts/fight3d/TvShot.gd")

const LIVE_AFTER_S := 2.3   # S390: was 1.3: the replay cut in mid-fall and back to a body that smeared flat; he lands on camera first
const LEAD_S := 0.3         # the replay starts this long before the shot
const TAIL_S := 2.28        # S390: was 1.2: it stopped mid-fall and cut to him lying flat ("appears upright, then blurs flat"); now it ends where the ring froze
const SLOW := 0.35          # replay speed
const SLOW_UNTIL_S := 0.45  # S390: slow on the punch, then full speed down to the canvas (a TV replay ramp; 2.85 s all slow ran 8 s)
## [from, to] (seconds from the shot on the recorders' clock) and the angle. At SLOW each runs 1.3-2.1 s on screen.
const ANGLES := [[-LEAD_S, -0.1, "main"], [-0.1, 0.45, "reverse"], [0.45, TAIL_S, "fall"]]
const MIN_SHOT_S := 1.2     # screen seconds: a shorter angle (the recording began late) joins the next one
## The framings: main = TV's elevated side camera; reverse = ringside, low, REVERSE_YAW toward the puncher; fall = high over
## the canvas FALL_DIST_M out from where he goes down, his whole fall and where he lands in the frame.
const MAIN := {"dist": 3.1, "h": 1.75, "look_h": 1.0}
const REVERSE := {"dist": 2.5, "h": 1.2, "look_h": 1.25}
const REVERSE_YAW := 25.0
const FALL_H := 2.9
const FALL_DIST_M := 1.7
const FALL_FOV := Vector2(34.0, 66.0)

var view: Node
var recs: Array = []
var cam: Camera3D
var shot_name := ""    # the angle on screen (probes read it)
var _hit := -1.0       # the shot on the recorders' clock (-1 once the replay has begun)
var _shot := 0.0       # the same, kept for the angles
var _who := 0          # the boxer who goes down
var _t := -1.0         # replay time on the recorders' clock (< 0 = not replaying)
var _end := 0.0
var _lenses: Array = []   # [{until, pos, look, fov, name}] on the recorders' clock
var _k := 0
var _was_paused := false
var _was_scale := 1.0
var _was_banner := ""
var count := 0         # replays shown this bout (probes read it)


func setup(v: Node) -> void:
	view = v
	process_mode = Node.PROCESS_MODE_ALWAYS
	for bx in v.stage.boxers:
		var r := PoseRecorder.new()
		r.name = "PoseRecorder"
		r.body = bx["node"]
		(bx["skel"] as Skeleton3D).add_child(r)   # last in the stack: what the viewer saw
		recs.append(r)
	cam = Camera3D.new()
	cam.name = "ReplayCam"
	cam.fov = 38.0
	(v.stage as Node).add_child(cam)


## Boxer `who` goes down from the shot that lands at view time `shot_t`: the replay cuts in once the fall has played.
func knockdown(who: int, shot_t: float) -> void:
	if recs.is_empty():
		return
	_who = who
	_hit = (recs[0] as Node).clock + (shot_t - float(view.t))


func active() -> bool:
	return _t >= 0.0


func _process(delta: float) -> void:
	if recs.is_empty():
		return
	if _t < 0.0:
		if _hit >= 0.0 and float(recs[0].clock) >= _hit + LIVE_AFTER_S:
			_begin()
		return
	_t = minf(_t + delta * (SLOW if _t < _shot + SLOW_UNTIL_S else 1.0), _end)
	for r in recs:
		r.play = _t
	while _k < _lenses.size() - 1 and _t >= float(_lenses[_k]["until"]):
		_k += 1
		_show(_k)
	if _t >= _end:
		_finish()


func _begin() -> void:
	var start := _hit - LEAD_S
	for r in recs:
		start = maxf(start, float(r.oldest()))
	_shot = _hit
	_end = _hit + TAIL_S
	# Where he lies now (the fall has played live), before the recorders draw the replay's first moment.
	var land := _bone(_who, "Hips")
	var land_head := _bone(_who, "Head")
	_t = start
	_hit = -1.0
	count += 1
	var tree := get_tree()
	_was_paused = tree.paused
	_was_scale = Engine.time_scale
	Engine.time_scale = 1.0
	tree.paused = true
	for i in view.stage.boxers.size():
		var bx: Dictionary = view.stage.boxers[i]
		(bx["skel"] as Node).process_mode = Node.PROCESS_MODE_ALWAYS
		recs[i].play = _t
		recs[i]._process_modification()
	_lenses = _plan(start, land, land_head)
	_k = 0
	cam.current = true
	_was_banner = str(view._banner.text)
	view._banner.text = "REPLAY"
	_show(0)


## The angles over [start, _end]: ANGLES clipped to the recording, a stretch too short on screen joined to the next.
func _plan(start: float, land: Vector3, land_head: Vector3) -> Array:
	var parts: Array = []
	for a in ANGLES:
		var from := maxf(_shot + float(a[0]), start)
		var to := minf(_shot + float(a[1]), _end)
		if to <= from:
			continue
		if not parts.is_empty() and (float(parts[-1][1]) - float(parts[-1][0])) / SLOW < MIN_SHOT_S:
			parts[-1] = [parts[-1][0], to, str(a[2])]   # the short one gives its time to this angle
		else:
			parts.append([from, to, str(a[2])])
	if parts.size() > 1 and (float(parts[-1][1]) - float(parts[-1][0])) / SLOW < MIN_SHOT_S:
		parts[-2] = [parts[-2][0], parts[-1][1], str(parts[-2][2])]
		parts.pop_back()
	var live: Camera3D = view.stage.camera
	var out: Array = []
	for p in parts:
		var lens := _angle(str(p[2]), float(p[0]), float(p[1]), land, land_head, live)
		lens["until"] = float(p[1])
		lens["name"] = "replay_" + str(p[2])
		out.append(lens)
	return out


## One fixed lens for the stretch [from, to]: {pos, look, fov}. The puncher is a, the downed boxer b (the recorders'
## roots: where each stood in the ring).
func _angle(kind: String, from: float, to: float, land: Vector3, land_head: Vector3, live: Camera3D) -> Dictionary:
	var a0: Vector3 = recs[1 - _who].root_at(from)
	var b0: Vector3 = recs[_who].root_at(from)
	var a1: Vector3 = recs[1 - _who].root_at(to)
	var b1: Vector3 = recs[_who].root_at(to)
	var mid := (a0 + b0 + a1 + b1) * 0.25
	mid.y = 0.0
	var ax := Vector3(b0.x - a0.x, 0.0, b0.z - a0.z)
	var perp := (ax.normalized() if ax.length() > 0.05 else Vector3.RIGHT).cross(Vector3.UP).normalized()
	if live != null and perp.dot(live.global_position - mid) < 0.0:
		perp = -perp   # the main side: where the live lens was
	var aspect := TvShot.aspect_of(cam)
	var pts: Array = TvShot.pair_points(a0, b0) + TvShot.pair_points(a1, b1)
	if kind == "fall":
		var focus := Vector3((b0.x + land.x) * 0.5, 0.0, (b0.z + land.z) * 0.5)
		var spot := TvShot.clamp_in(focus + perp * FALL_DIST_M)
		if TvShot.flat_gap(spot, focus) < FALL_DIST_M * 0.6:
			spot = TvShot.clamp_in(focus - perp * FALL_DIST_M)
		var pos := spot + Vector3.UP * FALL_H
		var look := focus + Vector3.UP * 0.45
		var fall_pts: Array = [b0 + Vector3.UP * TvShot.HEAD_M, b0, land, land_head, a1, a1 + Vector3.UP * TvShot.HEAD_M]
		var f := TvShot.frame_fov(pos, look, fall_pts, aspect, 0.3) * TvShot.FOV_PAD
		if f > FALL_FOV.y:   # the puncher too far off: the fall alone
			f = TvShot.frame_fov(pos, look, fall_pts.slice(0, 4), aspect, 0.3) * TvShot.FOV_PAD
		return {"pos": pos, "look": look, "fov": clampf(f, FALL_FOV.x, FALL_FOV.y)}
	var spec: Dictionary = MAIN
	var yaw := 0.0
	var prefer := perp
	if kind == "reverse":
		spec = REVERSE
		prefer = -perp
		# Toward the puncher: the hit boxer's face and the glove coming in.
		yaw = REVERSE_YAW if (Basis(Vector3.UP, deg_to_rad(REVERSE_YAW)) * prefer).dot(a0 - b0) > 0.0 else -REVERSE_YAW
	var p := TvShot.place(a0, b0, prefer, float(spec["dist"]), yaw, float(spec["h"]), float(spec["look_h"]), aspect)
	var look := mid + Vector3.UP * float(spec["look_h"])
	var fov := TvShot.frame_fov(p["lens"], look, pts, aspect, 0.35) * TvShot.FOV_PAD
	return {"pos": p["lens"], "look": look, "fov": clampf(fov, TvShot.FOV_MIN, TvShot.FOV_MAX)}


func _show(k: int) -> void:
	var l: Dictionary = _lenses[k]
	cam.fov = float(l["fov"])
	cam.look_at_from_position(l["pos"], l["look"], Vector3.UP)
	shot_name = str(l["name"])


func _bone(i: int, bone: String) -> Vector3:
	var bx: Dictionary = view.stage.boxers[i]
	var skel: Skeleton3D = bx["skel"]
	var id := skel.find_bone(bone)
	if id >= 0:
		return skel.global_transform * skel.get_bone_global_pose(id).origin
	return (bx["node"] as Node3D).global_position + Vector3.UP * (0.9 if bone == "Hips" else 1.6)


func _finish() -> void:
	_t = -1.0
	for r in recs:
		r.play = -1.0
	for bx in view.stage.boxers:
		(bx["skel"] as Node).process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().paused = _was_paused
	Engine.time_scale = _was_scale
	var live: Camera3D = view.stage.camera
	if live != null:
		live.current = true
	view._banner.text = _was_banner
