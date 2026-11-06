extends SceneTree
## S368 CAMVIEW probe (operator: "the camera in the fight needs fixing many times it is behind the fighter and cant see";
## Gemini 4 Argon on the S367 film: the camera zooms into Blue's hips, a 180-degree orbit mid-exchange). Plays fight night
## like ref_probe.gd and, every frame of the round, looks from the game camera's lens at each boxer's head and chest: a
## target is HIDDEN when the line from the lens to it passes through the other boxer's torso or head (capsules round her
## bones, the pose as shown). Also counts frames the lens stands inside a body, per director shot.
## Run windowed on the never-shown desktop (the camera needs a picture):
##   python tools/hidden_desktop.py run --timeout=600 --log=<f> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/cam_view_probe.gd [-- secs=90]
## S379: `fightjump=men_fight` plays Danny's bout (the films' jump; default Lucy's `fight`); `fromcorners` opens it as the films
## do (FightIntro / CornerStart); `clinch=<s>[,<s>...]` puts a clinch (its tie-up and break, as ClinchBeats places one) at
## those round seconds - natural clinches are rare (S374), the clinch lens needs measuring; headless with `show3d` the
## stage's picture is pinned to the films' 1280 x 720 (as tools/cam_motion_probe.gd). CAMVIEW clinch prints the frames held
## in a tie-up and how often a head was hidden in them.
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
	var jump := "fight"
	var clinch_at: Array = []
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("secs="):
			secs = float(str(a).trim_prefix("secs="))
		if str(a).begins_with("fightjump="):
			jump = str(a).trim_prefix("fightjump=")
		if str(a).begins_with("clinch="):
			for c in str(a).trim_prefix("clinch=").split(","):
				clinch_at.append(float(c))
	root.size = Vector2i(1280, 720)
	## S379 (operator: "the holo head pointer is cut"): the hidden desktop gives a 1920x1009 window, the expanded picture
	## was 2055 wide and the 1920 movie cut ~65 px off each side - keep the picture 16:9 for films.
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("CAMVIEW reached fight night: ", TestJump.run(main, jump))
	await _wait(4)
	main.act("fightstep", "start")
	await _wait(2)
	var view: Node = main._fight_layer.get_child(0)
	var vp := (view.stage as Node).get_viewport() as SubViewport if view.stage != null else null
	if vp != null and DisplayServer.get_name() == "headless":
		if vp.get_parent() is SubViewportContainer:
			(vp.get_parent() as SubViewportContainer).stretch = false
		vp.size = Vector2i(1280, 720)
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
	var held := 0                  # frames the lens frames a tie-up (RingCamera.clinch_heads)
	var held_hid := 0
	var held_shot := 0             # ... of them on the clinch lens
	var held_off := 0.0            # ... the lens's turn off side-on to the pair, summed (deg)
	var t0 := float(view.t)
	while bool(view.playing) and float(view.t) - t0 <= secs:
		await process_frame
		if not clinch_at.is_empty() and float(view.t) >= float(clinch_at[0]) - 1.0:
			put_clinch(view, float(clinch_at.pop_front()))
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
		if (cam.get("clinch_heads") as Array).size() == 2:
			held += 1
			held_hid += 1 if any else 0
			held_shot += 1 if shot == "clinch" else 0
			var ha := _bone(0, "Hips")
			var hb := _bone(1, "Hips")
			var ax := Vector3(hb.x - ha.x, 0, hb.z - ha.z)
			var tl := Vector3(lens.x - (ha.x + hb.x) * 0.5, 0, lens.z - (ha.z + hb.z) * 0.5)
			if ax.length() > 0.01 and tl.length() > 0.01:
				held_off += absf(90.0 - rad_to_deg(ax.angle_to(tl)))
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
	print("CAMVIEW clinch: %d frames held in a tie-up (%.1f s), %d of them on the clinch lens (turned %.0f deg off side-on on average), a head hidden in %.1f %% of them" % [
		held, held / 30.0, held_shot, held_off / maxf(1.0, held), 100.0 * held_hid / maxf(1.0, held)])
	for s in by_shot:
		print("CAMVIEW shot %s: %d frames (%.1f %%), a head hidden %.1f %%, behind a boxer %.1f %% of them" % [s,
			by_shot[s][0], 100.0 * by_shot[s][0] / n, 100.0 * by_shot[s][1] / maxf(1.0, by_shot[s][0]),
			100.0 * by_shot[s][2] / maxf(1.0, by_shot[s][0])])
	var ok: bool = float(either) / n <= HEAD_HIDDEN_MAX and worst_run <= STRETCH_MAX_S and inside == 0 \
		and float(behind) / n <= BEHIND_MAX
	print("CAMVIEW_SUMMARY either_head_hidden=%.3f longest_s=%.2f inside=%d behind=%.3f %s" % [float(either) / n,
		worst_run, inside, float(behind) / n, "PASS" if ok else "FAIL"])
	quit(0 if ok else 1)


## A clinch at round second `at` (ClinchBeats' shape: the tie-up held 2.6 s, both step out at the break), in place of the
## round's own beats there; the view fires it and its range phase walks the holder in (RangeBreath "clinch").
static func put_clinch(view: Node, at: float) -> void:
	var bs: Array = view.beats
	var keep: Array = bs.slice(0, int(view.next))
	for i in range(int(view.next), bs.size()):
		var t := float(bs[i]["t"])
		if t < at - 0.2 or t > at + 3.6:
			keep.append(bs[i])
	var brk := at + 2.6
	keep.append({"t": at, "who": "a", "move": "clinch", "result": "none", "caption": "", "dur": 2.6, "break_t": brk})
	keep.append({"t": brk, "who": "a", "move": "step_out", "result": "none", "caption": "", "ref": true})
	keep.append({"t": brk, "who": "b", "move": "step_out", "result": "none", "caption": "", "ref": true})
	var head: Array = keep.slice(0, int(view.next))
	var tail: Array = keep.slice(int(view.next))
	tail.sort_custom(func(x: Dictionary, y: Dictionary) -> bool: return float(x["t"]) < float(y["t"]))
	view.beats = head + tail
	print("CAMVIEW clinch put in at t=%.1f (view t %.1f)" % [at, float(view.t)])


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
