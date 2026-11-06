extends SceneTree
## S379 CORNERSTART probe (operator: "skip the walk in for the clips, make the clips start when each man is in his corner and
## then walk to center start fighting"). Plays the films' opening (FightIntro.from_corners -> scripts/fight3d/CornerStart.gd)
## on Danny's bout (TestJump men_fight; `fightjump=fight` = Lucy's) and checks it on the pose AS SHOWN (tools/pose_tap.gd,
## the last modifier):
## - the first frame: both boxers within START_M of their own corner marks, facing the centre, nobody on the apron;
## - the walk: each body goes at least WALK_MIN_M to the centre; its planted ankle - the slower of the two over the canvas
##   (FootPlant's steps skim 4 mm high, so the lower ankle is often the stepping one) - slides at most SLIDE_MEAN mean /
##   SLIDE_P90 p90 m/s (knockdown_film's STEPROOT1 bar), while both ankles keep up with the body (each travels at least
##   FEET_KEEP of the body's way: the legs walk, the body does not glide over still feet);
## - every frame of the opening the lens stands inside the ropes (TvShot.inside), its FOV held still while it moves;
## - the round starts within OPEN_MAX_S with both in the middle (within MID_M of the centre), facing each other.
## Headless (`show3d` plays the 3D stage):
##   <godot.exe> --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/corner_start_probe.gd -- show3d
## Prints CORNERSTART lines, "CORNERSTART failures=<n>"; quit(1) on a failure. The bars - never loosen one to pass.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PoseTap := preload("res://tools/pose_tap.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const TvShot := preload("res://scripts/fight3d/TvShot.gd")

const START_M := 0.3
const FACE_DEG := 20.0
const WALK_MIN_M := 1.8
const SLIDE_MEAN := 0.10
const SLIDE_P90 := 0.20
const FEET_KEEP := 0.7
const OPEN_MAX_S := 14.0
const MID_M := 1.0
const DT := 1.0 / 30.0

var main: Node
var failures := 0
var _taps: Array = []


func _initialize() -> void:
	FightIntro.from_corners = true
	var jump := "men_fight"
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("fightjump="):
			jump = str(a).trim_prefix("fightjump=")
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	print("CORNERSTART reached fight night: ", TestJump.run(main, jump))
	for i in 4:
		await process_frame
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	var st: Node = view.stage
	if st == null:
		print("CORNERSTART FAIL no 3D stage (run with -- show3d)")
		quit(1)
		return
	var vp := st.get_viewport() as SubViewport
	if vp != null and DisplayServer.get_name() == "headless":
		if vp.get_parent() is SubViewportContainer:
			(vp.get_parent() as SubViewportContainer).stretch = false
		vp.size = Vector2i(1280, 720)
	var fi: Node = null
	for c in view.get_children():
		if c.get_script() == FightIntro:
			fi = c
	_check(fi != null and fi.get("corners") != null, "the film's intro plays the corner start (CornerStart)")
	if fi == null or fi.get("corners") == null:
		_end()
		return
	var cs: RefCounted = fi.corners
	for i in 2:
		var tap: SkeletonModifier3D = PoseTap.new()
		tap.setup(st.boxers[i]["skel"], ["LeftToes", "RightToes", "Hips"])   # S391: the ball of the foot is the plant; the heel pumps on purpose
		(st.boxers[i]["skel"] as Skeleton3D).add_child(tap)
		_taps.append(tap)
	await process_frame
	await process_frame
	# The first frame: in their corners, facing the centre.
	for i in 2:
		var side := "red" if i == 0 else "blue"
		var c: Dictionary = fi.crew.corner(side)
		var mark: Vector3 = (c["seat"] as Vector3) + (c["d"] as Vector3) * 0.2
		var n: Node3D = st.boxers[i]["node"]
		var off := Vector2(n.position.x - mark.x, n.position.z - mark.z).length()
		var fwd := Vector3(n.global_transform.basis.z.x, 0, n.global_transform.basis.z.z).normalized()
		var to_mid := Vector3(-n.position.x, 0, -n.position.z).normalized()
		var face := rad_to_deg(fwd.angle_to(to_mid))
		var on_canvas := absf(n.position.x) < TvShot.RING_HALF_M and absf(n.position.z) < TvShot.RING_HALF_M
		print("CORNERSTART start %s: (%.2f, %.2f) %.2f m off his corner mark, facing %.0f deg off the centre" % [
			side, n.position.x, n.position.z, off, face])
		_check(off <= START_M and face <= FACE_DEG and on_canvas and n.visible,
			"%s starts in his corner facing the centre (%.2f m off the mark, %.0f deg)" % [side, off, face])
	var slides := [[], []]
	var prev_feet := [[], []]
	var body := [0.0, 0.0]
	var feet_way := [[0.0, 0.0], [0.0, 0.0]]
	var prev_body := [Vector3.INF, Vector3.INF]
	var lens_out := 0
	var lens_max := 0.0
	var fov_moving := 0
	var frames := 0
	var prev_lens := Vector3.INF
	var prev_fov := 0.0
	var phases: Array = []
	var film_t := 0.0
	while not bool(view.playing) and film_t < OPEN_MAX_S + 6.0:
		await process_frame
		film_t += DT
		frames += 1
		var ph := str(cs.get("phase"))
		if phases.is_empty() or phases[-1][0] != ph:
			phases.append([ph, film_t])
		var cam: Camera3D = st.get_viewport().get_camera_3d()
		if cam != null:
			var lp := cam.global_position
			lens_max = maxf(lens_max, maxf(absf(lp.x), absf(lp.z)))
			if not TvShot.inside(Vector3(lp.x, 0, lp.z)):
				lens_out += 1
			if prev_lens.is_finite() and lp.distance_to(prev_lens) < 0.4 and lp.distance_to(prev_lens) > 0.0005 \
					and absf(cam.fov - prev_fov) > 0.01 and absf(cam.fov - prev_fov) < 3.0:
				fov_moving += 1
			prev_lens = lp
			prev_fov = cam.fov
		for i in 2:
			var n: Node3D = st.boxers[i]["node"]
			var feet := [_shown(st, i, "LeftToes"), _shown(st, i, "RightToes")]
			var walking: bool = ph == "walk" and not bool((cs.get("arrived") as Array)[i])
			if walking and (prev_feet[i] as Array).size() == 2 and (prev_body[i] as Vector3).is_finite():
				# The planted foot = the slower of the two ankles over the canvas (FootPlant's steps skim the canvas 4 mm high, so the
				# lower ankle is often the stepping one): it holds when this one stays put.
				var sp := []
				for k in 2:
					var pk: Vector3 = prev_feet[i][k]
					sp.append(Vector2((feet[k] as Vector3).x - pk.x, (feet[k] as Vector3).z - pk.z).length() / DT)
				(slides[i] as Array).append(minf(float(sp[0]), float(sp[1])))
				body[i] += Vector2(n.position.x - prev_body[i].x, n.position.z - prev_body[i].z).length()
				for k in 2:
					var pk: Vector3 = prev_feet[i][k]
					feet_way[i][k] += Vector2((feet[k] as Vector3).x - pk.x, (feet[k] as Vector3).z - pk.z).length()
			prev_feet[i] = feet
			prev_body[i] = n.position
	print("CORNERSTART phases %s" % str(phases.map(func(p): return "%s@%.1f" % [p[0], p[1]])))
	print("CORNERSTART the opening ran %.1f s, the walk %.1f s" % [film_t, float(cs.get("walk_s"))])
	_check(bool(view.playing) and film_t <= OPEN_MAX_S, "the round starts after the opening (%.1f s <= %.0f)" % [film_t, OPEN_MAX_S])
	for i in 2:
		var s: Array = slides[i]
		s.sort()
		var mean := 0.0
		for v in s:
			mean += float(v)
		mean /= maxf(1.0, s.size())
		var p90: float = s[int(s.size() * 0.9)] if not s.is_empty() else 99.0
		var keep := minf(float(feet_way[i][0]), float(feet_way[i][1])) / maxf(0.01, float(body[i]))
		var name := "red" if i == 0 else "blue"
		print("CORNERSTART walk %s: body %.2f m, ankles %.2f / %.2f m, planted ankle slides mean %.3f p90 %.3f max %.3f m/s over %d frames"
			% [name, body[i], feet_way[i][0], feet_way[i][1], mean, p90, float(s[-1]) if not s.is_empty() else 0.0, s.size()])
		_check(float(body[i]) >= WALK_MIN_M and mean <= SLIDE_MEAN and p90 <= SLIDE_P90 and keep >= FEET_KEEP,
			"%s walks to the centre on his feet (%.2f m, slide mean %.3f / p90 %.3f m/s, ankles keep %.0f %% of the way)" % [
			name, body[i], mean, p90, 100.0 * keep])
	print("CORNERSTART lens: %d of %d frames outside the ropes (furthest out %.2f m, the ropes at %.2f), FOV changed while moving %d frames"
		% [lens_out, frames, lens_max, TvShot.RING_HALF_M, fov_moving])
	_check(lens_out == 0 and fov_moving == 0, "every lens of the opening stands inside the ropes, no zoom while it moves")
	var a: Vector3 = (st.boxers[0]["node"] as Node3D).position
	var b: Vector3 = (st.boxers[1]["node"] as Node3D).position
	var mid := (a + b) * 0.5
	var fa := Vector3((st.boxers[0]["node"] as Node3D).global_transform.basis.z.x, 0, (st.boxers[0]["node"] as Node3D).global_transform.basis.z.z)
	var face := rad_to_deg(fa.angle_to(Vector3(b.x - a.x, 0, b.z - a.z)))
	_check(Vector2(mid.x, mid.z).length() <= MID_M and face <= FACE_DEG,
		"round 1 opens in the middle, squared up (%.2f m off the centre, %.2f m apart, red faces %.0f deg off blue)" % [
		Vector2(mid.x, mid.z).length(), Vector2(a.x - b.x, a.z - b.z).length(), face])
	_end()


func _shown(st: Node, i: int, bone: String) -> Vector3:
	var tap: SkeletonModifier3D = _taps[i]
	var skel: Skeleton3D = st.boxers[i]["skel"]
	if tap.shown.has(bone):
		return skel.global_transform * (tap.shown[bone] as Vector3)
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin


func _check(cond: bool, label: String) -> void:
	if cond:
		print("CORNERSTART PASS " + label)
	else:
		failures += 1
		print("CORNERSTART FAIL " + label)


func _end() -> void:
	print("CORNERSTART failures=%d" % failures)
	quit(1 if failures > 0 else 0)
