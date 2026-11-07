extends SceneTree
## S395 the boxers' walk (operator: "still walking is terrible"). af_walk limps on a boxer (S377) and her guard's step pairs read
## as a shuffle. This cuts one looping stride cycle out of a real captured walk baked by tools/owned_mocap_bake.gd (CMU 07_01,
## "free for all uses"): the frame pair where the legs repeat best, the seam blended, the walk's forward travel taken out of the
## Hips, so CornerCrew moves the body at the clip's own ground speed.
##   <godot> --headless --path . --script res://tools/walk_cycle.gd -- in=<baked.res> out=res://assets/anim/baked/ow_walk.res
## Prints WALKCYCLE start, period, ground speed (m/s at 1x) and the seam's error.

const FPS := 30.0
const PERIOD_S := Vector2(0.8, 1.4)
const BLEND_FRAMES := 6
const LEGS := ["LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg", "Hips", "LeftFoot", "RightFoot"]


func _initialize() -> void:
	var src_path := ""
	var out_path := ""
	for a in OS.get_cmdline_user_args():
		if a.begins_with("in="):
			src_path = a.trim_prefix("in=")
		elif a.begins_with("out="):
			out_path = a.trim_prefix("out=")
	var src: Animation = ResourceLoader.load(src_path)
	if src == null or out_path == "":
		print("WALKCYCLE needs in= and out=")
		quit(1)
		return
	var n := int(src.length * FPS)
	var rot: Array = []
	var pos := -1
	for t in src.get_track_count():
		if src.track_get_type(t) == Animation.TYPE_ROTATION_3D:
			rot.append(t)
		elif src.track_get_type(t) == Animation.TYPE_POSITION_3D:
			pos = t
	var best := [INF, 0, 0]
	for p in range(int(PERIOD_S.x * FPS), int(PERIOD_S.y * FPS) + 1):
		for s in range(0, n - p):
			var e := _seam(src, rot, s, s + p)
			if e < best[0]:
				best = [e, s, p]
	var s0: int = best[1]
	var p0: int = best[2]
	var length := p0 / FPS
	var anim := Animation.new()
	anim.length = length
	anim.loop_mode = Animation.LOOP_LINEAR
	for t in src.get_track_count():
		var nt := anim.add_track(src.track_get_type(t))
		anim.track_set_path(nt, src.track_get_path(t))
		anim.track_set_interpolation_type(nt, Animation.INTERPOLATION_LINEAR)
		for f in p0 + 1:
			var at := (s0 + f) / FPS
			var w := clampf(float(f - (p0 - BLEND_FRAMES)) / BLEND_FRAMES, 0.0, 1.0)
			if t == pos:
				var a: Vector3 = src.position_track_interpolate(t, s0 / FPS)
				var b: Vector3 = src.position_track_interpolate(t, (s0 + p0) / FPS)
				var line := a.lerp(b, float(f) / p0)
				var here: Vector3 = src.position_track_interpolate(t, at)
				anim.position_track_insert_key(nt, f / FPS, Vector3(here.x - line.x, here.y, here.z - line.z))
			elif src.track_get_type(t) == Animation.TYPE_ROTATION_3D:
				var q: Quaternion = src.rotation_track_interpolate(t, at)
				var q0: Quaternion = src.rotation_track_interpolate(t, s0 / FPS)
				anim.rotation_track_insert_key(nt, f / FPS, q.slerp(q0, w))
	var a0: Vector3 = src.position_track_interpolate(pos, s0 / FPS)
	var a1: Vector3 = src.position_track_interpolate(pos, (s0 + p0) / FPS)
	var speed := Vector2(a1.x - a0.x, a1.z - a0.z).length() / length
	print("WALKCYCLE travel in the clip: ", a1 - a0)
	var err := ResourceSaver.save(anim, out_path)
	print("WALKCYCLE start %.2f s period %.2f s ground %.2f m/s seam %.3f saved %d -> %s" % [s0 / FPS, length, speed, best[0], err, out_path])
	quit(err)


## How far the legs are from repeating between frames a and b (mean angle, radians).
func _seam(src: Animation, rot: Array, a: int, b: int) -> float:
	var sum := 0.0
	var n := 0
	for t in rot:
		var name := str(src.track_get_path(t)).get_slice(":", 1)
		if not name in LEGS:
			continue
		var qa: Quaternion = src.rotation_track_interpolate(t, a / FPS)
		var qb: Quaternion = src.rotation_track_interpolate(t, b / FPS)
		sum += qa.angle_to(qb)
		n += 1
	return sum / maxf(1.0, float(n))
