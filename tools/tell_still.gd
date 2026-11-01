extends SceneTree
## S343 TELLS1 stills: one 1920x1080 still per tell at its lowest/most-forward moment on the tape's own camera
## (side-on, the other woman's side), both bodies head to feet. Saved under docs/playtest/tells/.
## Prints TELLSTILL bodies 2 in frame per still or TELLSTILL FAIL.
## Windowed: xvfb-run -a -s "-screen 0 1920x1080x24" $GODOT_EXE --path . --windowed --resolution 1920x1080
##     --audio-driver Dummy --fixed-fps 30 --script res://tools/tell_still.gd -- fastdraw

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const TapeClips := preload("res://scripts/rules/TapeClips.gd")
const FastDraw := preload("res://tools/fast_draw.gd")
const RingCamera := preload("res://scripts/fight3d/RingCamera.gd")

const OUT_DIR := "res://docs/playtest/tells"

## Camera setup (copied from TapeFilm): side-on to the pair, both head to feet.
const CAM_DIST := 3.3
const CAM_BACK := 0.8
const CAM_H := 1.35
const CAM_LOOK_H := 0.95
const CAM_FOV := 42.0
const CAM_IN_M := 0.3
const CAM_MIN := 1.9
const CAM_HALF_H := 1.2

## The tells to capture: shape -> (tell_kind, beat_move, time_after_beat).
const TELLS := {
	"hand_drop": {"shape": "drops_right", "move": "jab", "after_s": 0.5},
	"lunge": {"shape": "lunges", "move": "jab", "after_s": 0.3},
	"tired_guard": {"shape": "tiring", "move": "tired", "after_s": 0.8},
	"hands_low": {"shape": "admires", "move": "say", "after_s": 0.6},
}

class View:
	extends Node
	var stage: Node3D
	var _amb_rng: RandomNumberGenerator
	var t := 0.0
	var _profiles := {"a": {}, "b": {}}
	var _stop := ""
	var _close_left := 0.0
	var body: RefCounted
	func pace() -> float:
		return 1.0
	class NoBody:
		extends RefCounted
		func land(_b: Dictionary, _at: float) -> void:
			pass
	func _init(s: Node3D) -> void:
		stage = s
		_amb_rng = RandomNumberGenerator.new()
		body = NoBody.new()

var _stage: Node3D
var _beat: BeatFire


func _initialize() -> void:
	FastDraw.begin()
	root.size = Vector2i(W, H)
	DirAccess.make_dir_recursive_absolute(OUT_DIR)
	_stage = Stage.new()
	root.add_child(_stage)
	await process_frame
	_stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red", "stance": "orthodox"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue", "stance": "orthodox"})
	_beat = BeatFire.new()
	# S347: the ring's director off (TapeFilm does the same): it re-placed the lens every frame, over ours.
	_stage.camera.close = true
	for tell_name in TELLS.keys():
		await _capture_tell(tell_name, TELLS[tell_name])
	print("TELLSTILL done")
	quit(0)


func _capture_tell(tell_name: String, spec: Dictionary) -> void:
	var shape: String = spec["shape"]
	var move: String = spec["move"]
	var after_s: float = spec["after_s"]
	# Build the beats for this shape
	var s: Dictionary = TapeClips.SHAPES[shape]
	var beats: Array = []
	for r in s["beats"]:
		var b := {"t": float(r[0]), "who": str(r[1]), "move": str(r[2]), "result": str(r[3]), "def": str(r[4]),
			"caption": "", "big": false, "knockback": false}
		var pose: Array = TapeClips.TELL_POSES.get(shape, [])
		if not pose.is_empty() and str(r[1]) == "b" and str(r[2]) == str(pose[0]):
			b["tell"] = str(pose[1])
		beats.append(b)
	# Find the beat with the tell
	var tell_idx := -1
	for i in beats.size():
		if str(beats[i]["who"]) == "b" and str(beats[i]["move"]) == move and beats[i].has("tell"):
			tell_idx = i
			break
	if tell_idx < 0:
		print("TELLSTILL FAIL %s (no beat found)" % tell_name)
		return
	var beat_t: float = float(beats[tell_idx]["t"])
	# Reset stage
	_stage.boxers[0]["pos"] = Vector3(0, 0, -_stage.gap_m * 0.5)
	_stage.boxers[1]["pos"] = Vector3(0, 0, _stage.gap_m * 0.5)
	_stage.guard(0)
	_stage.guard(1)
	# Create view
	var view := View.new(_stage)
	root.add_child(view)
	view._amb_rng.seed = hash(shape)
	_beat.reset()
	# Fire beats up to the tell beat
	var next_idx := 0
	while next_idx < beats.size() and float(beats[next_idx]["t"]) <= beat_t:
		_beat.fire(view, beats[next_idx])
		next_idx += 1
	# Step to the capture time. S347: from the tell beat (view.t started at 0, so the still came seconds after the tell
	# ended), on the frame's own time (--fixed-fps 30 made every 1/60 step 1/30 s of motion).
	var capture_t := beat_t + after_s
	view.t = beat_t
	while view.t < capture_t:
		await process_frame
		view.t += root.get_process_delta_time()
	# Position camera. S347: pulled back 0.4 m at a time (up to 1.2 m) until both women stand head to feet - the lunge
	# put the other woman's back foot under the frame.
	for back in [0.0, 0.4, 0.8, 1.2]:
		_position_camera(back)
		if _bodies_in_frame():
			break
	# Wait for render
	await RenderingServer.frame_post_draw
	for i in 3:
		await RenderingServer.frame_post_draw
	# Check bodies in frame (S347: she keeps moving through the waits - pull back again from where she is now)
	for back in [0.4, 0.8, 1.2]:
		if _bodies_in_frame():
			break
		_position_camera(back)
		# the motion-blur pass smears the frame after a camera move: two still frames first
		for i in 3:
			await RenderingServer.frame_post_draw
	if not _bodies_in_frame():
		print("TELLSTILL FAIL %s (bodies not in frame)" % tell_name)
		return
	# Save still
	var img := root.get_texture().get_image()
	var path := OUT_DIR.path_join("%s_tell.png" % tell_name)
	img.save_png(path)
	print("TELLSTILL bodies 2 in frame %s" % path)
	# Clean up view
	view.queue_free()


func _position_camera(back: float = 0.0) -> void:
	var a: Vector3 = _stage.boxers[0]["pos"]
	var b: Vector3 = _stage.boxers[1]["pos"]
	var d := Vector3(b.x - a.x, 0.0, b.z - a.z).normalized()
	if d == Vector3.ZERO:
		d = Vector3.RIGHT
	var perp := Vector3(-d.z, 0.0, d.x)
	var mid := (a + b) * 0.5
	# S347: the lens inside the ropes (a see-through rope crossed both women from outside), the tape room's rule: side-on,
	# on the side with more room, pulled in as far as the ropes need (never turned along the pair: one woman filled it).
	var best := Vector3.ZERO
	var reach := -1.0
	for s: float in [1.0, -1.0]:
		var dir: Vector3 = (perp * s * (CAM_DIST + back) - d * CAM_BACK).normalized()
		var dist := CAM_DIST + back
		while dist > RingCamera.MIN_DIST_M and not RingCamera.inside(mid + dir * dist):
			dist -= 0.1
		if dist > reach:
			reach = dist
			best = mid + dir * dist
	_stage.camera.global_position = Vector3(best.x, CAM_H, best.z)
	_stage.camera.look_at(Vector3(mid.x, CAM_LOOK_H - 0.12, mid.z), Vector3.UP)
	# closer in, wider: CAM_HALF_H above and below their middle
	# (the ropes stop the pull back, so each try widens 8 deg too)
	_stage.camera.fov = maxf(CAM_FOV + back * 20.0, rad_to_deg(2.0 * atan(CAM_HALF_H / maxf(reach, 0.5))))


func _bodies_in_frame() -> bool:
	# S347: both women head to feet (hips let a still through with her feet cut off), 3% inside the edges; the head
	# raised 0.15 m to the crown.
	for who in 2:
		var skel: Skeleton3D = _stage.boxers[who]["skel"]
		for bone in ["Head", "LeftFoot", "RightFoot"]:
			var pos: Vector3 = skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin
			if bone == "Head":
				pos += Vector3.UP * 0.15
			var sp: Vector2 = _stage.camera.unproject_position(pos)
			if sp.x < W * 0.03 or sp.x > W * 0.97 or sp.y < H * 0.03 or sp.y > H * 0.97:
				print("TELLSTILL out of frame: boxer %d %s at %s" % [who, bone, sp])
				return false
	return true
