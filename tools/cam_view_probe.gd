extends SceneTree
## S368 CAMVIEW probe (operator: "the camera in the fight needs fixing many times it is behind the fighter and cant see";
## Gemini 4 Argon on the S367 film: the camera zooms into Blue's hips, a 180-degree orbit mid-exchange). Plays fight night
## like ref_probe.gd and, every frame of the round, looks from the game camera's lens at each boxer's head and chest: a
## target is HIDDEN when the line from the lens to it passes through the other boxer's torso or head (capsules round her
## bones, the pose as shown). Also counts frames the lens stands inside a body, per director shot.
## Run windowed on the never-shown desktop (the camera needs a picture):
##   python tools/hidden_desktop.py run --timeout=600 --log=<f> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/cam_view_probe.gd [-- secs=90]
## Prints CAMVIEW lines, then CAMVIEW_SUMMARY with PASS/FAIL against the bars below.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PoseTap := preload("res://tools/pose_tap.gd")
const RingCamera := preload("res://scripts/fight3d/RingCamera.gd")

## The bars. Never loosen one to make a line pass.
const HEAD_HIDDEN_MAX := 0.05     # share of frames either boxer's head is hidden
const STRETCH_MAX_S := 1.0        # the longest run of frames a head stays hidden
## "Behind the fighter" (his words): the lens within BEHIND_DEG of straight behind a boxer (on the line from the other
## boxer through her, past her back) - her punches and face are hidden however clear the other's head is.
const BEHIND_DEG := 45.0
const BEHIND_MAX := 0.05
## Body volumes (metres), as tools/ref_break_probe.gd.
const TORSO_R := 0.15
const HEAD_R := 0.11
const HEAD_UP_M := 0.08
const BONES := ["Head", "UpperChest", "Hips"]

var main: Node
var _taps: Array = []


func _initialize() -> void:
	var secs := 90.0
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("secs="):
			secs = float(str(a).trim_prefix("secs="))
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("CAMVIEW reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	var st: Node = view.stage
	for i in 2:
		var tap: SkeletonModifier3D = PoseTap.new()
		tap.setup(st.boxers[i]["skel"], BONES)
		(st.boxers[i]["skel"] as Skeleton3D).add_child(tap)
		_taps.append(tap)
	var frames := 0
	var hid := [0, 0]          # head hidden, per boxer
	var chest_hid := [0, 0]
	var either := 0
	var inside := 0
	var behind := 0
	var by_shot: Dictionary = {}   # name -> [frames, either hidden, behind a boxer]
	var run_s := 0.0
	var worst_run := 0.0
	var worst_at := 0.0
	var worst_shot := ""
	var t0 := float(view.t)
	while bool(view.playing) and float(view.t) - t0 <= secs:
		await process_frame
		if bool(st.get("scene")):
			run_s = 0.0
			continue
		var cam: Camera3D = st.get("camera")
		if cam == null:
			continue
		frames += 1
		var lens := cam.global_position
		var shot := _shot_name(cam)
		if not by_shot.has(shot):
			by_shot[shot] = [0, 0, 0]
		by_shot[shot][0] += 1
		var any := false
		var back := false
		for i in 2:
			var j := 1 - i
			var me := _bone(i, "Hips")
			var them := _bone(j, "Hips")
			var away := Vector3(me.x - them.x, 0, me.z - them.z)
			var to_lens := Vector3(lens.x - me.x, 0, lens.z - me.z)
			if away.length() > 0.01 and to_lens.length() > 0.01 and rad_to_deg(away.angle_to(to_lens)) < BEHIND_DEG:
				back = true
			var head := _bone(i, "Head") + Vector3.UP * HEAD_UP_M
			if _blocked(lens, head, j):
				hid[i] += 1
				any = true
			if _blocked(lens, _bone(i, "UpperChest"), j):
				chest_hid[i] += 1
			if _inside(lens, i):
				inside += 1
		if back:
			behind += 1
			by_shot[shot][2] += 1
		if any:
			either += 1
			by_shot[shot][1] += 1
			run_s += 1.0 / 30.0
			if run_s > worst_run:
				worst_run = run_s
				worst_at = float(view.t)
				worst_shot = shot
		else:
			run_s = 0.0
	var n := maxf(1.0, frames)
	print("CAMVIEW frames %d (%.0f s of the round)" % [frames, float(view.t) - t0])
	print("CAMVIEW head hidden: red %.1f %%, blue %.1f %%, either %.1f %% | chest hidden: red %.1f %%, blue %.1f %%" % [
		100.0 * hid[0] / n, 100.0 * hid[1] / n, 100.0 * either / n, 100.0 * chest_hid[0] / n, 100.0 * chest_hid[1] / n])
	print("CAMVIEW longest hidden stretch %.2f s ending at t=%.1f (shot %s) | lens inside a body %d frames" % [worst_run,
		worst_at, worst_shot, inside])
	print("CAMVIEW behind a boxer (lens within %.0f deg of straight behind her): %.1f %% of frames" % [BEHIND_DEG,
		100.0 * behind / n])
	for s in by_shot:
		print("CAMVIEW shot %s: %d frames (%.1f %%), a head hidden %.1f %%, behind a boxer %.1f %% of them" % [s,
			by_shot[s][0], 100.0 * by_shot[s][0] / n, 100.0 * by_shot[s][1] / maxf(1.0, by_shot[s][0]),
			100.0 * by_shot[s][2] / maxf(1.0, by_shot[s][0])])
	var ok: bool = float(either) / n <= HEAD_HIDDEN_MAX and worst_run <= STRETCH_MAX_S and inside == 0 \
		and float(behind) / n <= BEHIND_MAX
	print("CAMVIEW_SUMMARY either_head_hidden=%.3f longest_s=%.2f inside=%d behind=%.3f %s" % [float(either) / n,
		worst_run, inside, float(behind) / n, "PASS" if ok else "FAIL"])
	quit(0 if ok else 1)


## The line lens -> target passes through boxer j's torso capsule or head sphere (stopped short of the target, so a
## target inside j's volume is not "hidden" by her own body).
func _blocked(lens: Vector3, target: Vector3, j: int) -> bool:
	var to := target - (target - lens).normalized() * 0.05
	var torso := Geometry3D.get_closest_points_between_segments(lens, to, _bone(j, "Hips"), _bone(j, "UpperChest"))
	if torso[0].distance_to(torso[1]) < TORSO_R:
		return true
	var head := _bone(j, "Head") + Vector3.UP * HEAD_UP_M
	var hp := Geometry3D.get_closest_point_to_segment(head, lens, to)
	return hp.distance_to(head) < HEAD_R


func _inside(lens: Vector3, i: int) -> bool:
	var p := Geometry3D.get_closest_point_to_segment(lens, _bone(i, "Hips"), _bone(i, "UpperChest"))
	var head := _bone(i, "Head") + Vector3.UP * HEAD_UP_M
	return p.distance_to(lens) < TORSO_R or head.distance_to(lens) < HEAD_R


func _shot_name(cam: Camera3D) -> String:
	var k := int(cam.get("_shot"))
	if k >= 0 and k < RingCamera.SHOTS.size():
		return str(RingCamera.SHOTS[k]["name"])
	return "close" if k < 0 else str(k)


func _bone(i: int, bone: String) -> Vector3:
	var tap: SkeletonModifier3D = _taps[i]
	var skel := tap.get_skeleton()
	if tap.shown.has(bone) and skel != null:
		return skel.global_transform * (tap.shown[bone] as Vector3)
	return skel.global_position if skel != null else Vector3.ZERO


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
