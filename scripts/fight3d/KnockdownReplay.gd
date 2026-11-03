extends Node
## S376 KNOCKDOWN1 (the S375 itch scan, ops/research/S375_ITCH_MMA_SCAN.md: MMA Career Simulator's knockdown - punch at
## 1.8 s, fully down by 2.6 s; Physics MMA replays its finishes in slow motion): after a knockdown's fall has played live
## (LIVE_AFTER_S past the shot), the ring freezes and the shot plays again from LEAD_S before it to TAIL_S after it at
## SLOW speed, from a low ringside lens on the far side, under a REPLAY banner; then the count goes on where it froze.
## Each boxer's skeleton carries a PoseRecorder (the last modifier: the pose as shown). The freeze is the scene tree's
## pause; this node and the two skeletons (with their modifiers) keep processing so the recorders can draw.
##   var r := KnockdownReplay.new(); view.add_child(r); r.setup(view)   r.knockdown(down_who, shot_view_t)   r.active()

const PoseRecorder := preload("res://scripts/fight3d/PoseRecorder.gd")

const LIVE_AFTER_S := 1.6   # the fall plays live this long after the shot before the replay cuts in
const LEAD_S := 1.0         # the replay starts this long before the shot
const TAIL_S := 1.2         # and runs this long after it
const SLOW := 0.35          # replay speed
const CAM_DIST := 2.4
const CAM_H := 1.05
const ORBIT_DEG_S := 10.0

var view: Node
var recs: Array = []
var cam: Camera3D
var _hit := -1.0       # the shot on the recorders' clock
var _who := 0          # the boxer who goes down
var _t := -1.0         # replay time on the recorders' clock (< 0 = not replaying)
var _end := 0.0
var _yaw := 0.0
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
	cam.fov = 34.0
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
	_t = minf(_t + delta * SLOW, _end)
	for r in recs:
		r.play = _t
	_aim(delta)
	if _t >= _end:
		_finish()


func _begin() -> void:
	var start := _hit - LEAD_S
	for r in recs:
		start = maxf(start, float(r.oldest()))
	_end = _hit + TAIL_S
	_t = start
	_hit = -1.0
	count += 1
	var tree := get_tree()
	_was_paused = tree.paused
	_was_scale = Engine.time_scale
	Engine.time_scale = 1.0
	tree.paused = true
	for bx in view.stage.boxers:
		(bx["skel"] as Node).process_mode = Node.PROCESS_MODE_ALWAYS
	# The far side from the broadcast lens, low at the ropes.
	var a: Vector3 = (view.stage.boxers[0]["node"] as Node3D).global_position
	var b: Vector3 = (view.stage.boxers[1]["node"] as Node3D).global_position
	var side := (b - a).cross(Vector3.UP).normalized()
	var live: Camera3D = view.stage.camera
	if live != null and (live.global_position - (a + b) * 0.5).dot(side) > 0.0:
		side = -side
	_yaw = rad_to_deg(atan2(side.x, side.z))
	cam.current = true
	_was_banner = str(view._banner.text)
	view._banner.text = "REPLAY"
	_aim(0.0)


func _aim(delta: float) -> void:
	_yaw += ORBIT_DEG_S * delta
	var a: Vector3 = (view.stage.boxers[0]["node"] as Node3D).global_position
	var b: Vector3 = (view.stage.boxers[1]["node"] as Node3D).global_position
	var mid := (a + b) * 0.5
	var dir := Vector3(sin(deg_to_rad(_yaw)), 0.0, cos(deg_to_rad(_yaw)))
	cam.global_position = mid + dir * CAM_DIST + Vector3.UP * CAM_H
	cam.look_at(mid + Vector3.UP * 0.95, Vector3.UP)


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
