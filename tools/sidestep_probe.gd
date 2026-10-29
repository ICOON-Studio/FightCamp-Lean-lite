extends SceneTree
## S306 (operator S305: "i can see sidestep but doesnt make sense since it returns back to the same point").
## feet: the feet of each dodge / weave in her own frame (x = her left, y = height, metres) at 30 Hz, both feet, so the
##   step-out moment and its length are read off the clip, not guessed.
## live (default): each dodge / weave played on the stage frame by frame, twice - "old" (SideStep off: the clip walks back)
##   and "new" - logging what the viewer sees (pose_tap, last modifier) in the world: where her hips end up sideways, and
##   how far a planted foot slides (a foot within 3 cm of the floor, moving). Plus the guard alone as the control.
## Headless: <godot.exe> --headless --fixed-fps 60 --path . --script res://tools/sidestep_probe.gd -- [feet] [clips=a,b]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const CLIPS := ["pro_left_dodge", "pro_right_dodge", "pro_left_weave", "pro_right_weave", "pro_quick_weave"]
const CASE_S := 2.2
const FLOOR_M := 0.015     # a foot within this of its own guard height is planted
const WINDOW_S := 0.6

var stage: Node3D
var _plans: Array = [{}, {}]


func _initialize() -> void:
	var clips: Array = CLIPS
	var feet := false
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("clips="):
			clips = str(a).substr(6).split(",")
		feet = feet or str(a) == "feet"
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	for i in 2:
		print("PLAN boxer %d %s" % [i, stage.side.plan(i)])
	if feet:
		stage.set_process(false)
		_feet(clips)
		quit(0)
		return
	var tap: SkeletonModifier3D = load("res://tools/pose_tap.gd").new()
	var skel: Skeleton3D = stage.boxers[0]["skel"]
	tap.setup(skel, ["Hips", "LeftFoot", "RightFoot"])
	skel.add_child(tap)
	await _case("guard", "", tap)
	await _case("step", "strafe_left", tap)
	await _case("step", "strafe_right", tap)
	await _case("step", "advance", tap)
	await _case("step", "retreat", tap)
	var plans: Array = [stage.side.plan(0), stage.side.plan(1)]
	_plans = plans
	for c in clips:
		if not stage.has_move(c):
			continue
		stage.side._plan = [{}, {}]
		await _case("old", c, tap)
		stage.side._plan = plans.duplicate()
		await _case("new", c, tap)
	quit(0)


## One case: both in guard, red plays `clip` at its game speed, CASE_S seconds of what is shown.
func _case(arm: String, clip: String, tap: Node) -> void:
	stage.guard(0)
	stage.guard(1)
	stage.life._quiet = [999.0, 999.0]   # no fidgets: the guard alone is the control
	for k in 30:
		await process_frame
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var across: Vector3 = (bx["node"] as Node3D).global_transform.basis.x.normalized()
	var side0 := _world(skel, tap, "Hips").dot(across)
	var floor_y := {"LeftFoot": _world(skel, tap, "LeftFoot").y, "RightFoot": _world(skel, tap, "RightFoot").y}
	# The window the cut changes: from the cut (clip time / speed) to the end of the guard join after it.
	var sp := BeatClips.speed(clip, "") if clip != "" else 1.0
	var row: Dictionary = (_plans[0] as Dictionary).get(clip, {})
	var w0 := float(row.get("cut", 0.0)) / sp
	if clip.begins_with("strafe_") or clip in ["advance", "retreat"]:
		stage._walk(0, clip, 0.25)   # control: the game's own short step (circle / weave step-off)
	elif clip != "":
		stage.play(0, clip, sp)
	var prev := {}
	var slide := [0.0, 0.0]     # whole case, window
	var worst := [0.0, 0.0]
	var t := 0.0
	while t < CASE_S:
		await process_frame
		var dt := 1.0 / 60.0   # run with --fixed-fps 60
		t += dt
		var inside := 1 if t >= w0 and t <= w0 + WINDOW_S else 0
		for f in ["LeftFoot", "RightFoot"]:
			var p := _world(skel, tap, f)
			if prev.has(f) and p.y - float(floor_y[f]) < FLOOR_M and (prev[f] as Vector3).y - float(floor_y[f]) < FLOOR_M:
				var v := Vector2(p.x - prev[f].x, p.z - prev[f].z).length()
				for k in ([0, 1] if inside else [0]):
					slide[k] += v
					worst[k] = maxf(worst[k], v / dt)
			prev[f] = p
		if OS.get_cmdline_user_args().has("trace") and bx.get("feet") != null:
			var fp: Node = bx["feet"]
			var ln := "TRACE %.3f %s" % [t, (bx["ap"] as AnimationPlayer).current_animation]
			for k in 2:
				var f: String = ["LeftFoot", "RightFoot"][k]
				var p := _world(skel, tap, f)
				var tg: Vector3 = fp.last_target[k]
				ln += " | %s shown(%.2f,%.2f,%.2f) target(%.2f,%.2f,%.2f) err %.3f swing=%s" % [f.left(1), p.x, p.y, p.z, tg.x, tg.y, tg.z, p.distance_to(tg), not (fp._swing[k] as Dictionary).is_empty()]
			print(ln)
	var moved := _world(skel, tap, "Hips").dot(across) - side0
	print("LIVE %s %-16s hips_sideways=%+.2f m | case: planted slide %.2f m, worst %.2f m/s | cut window %.2f-%.2f s: slide %.2f m, worst %.2f m/s" % [
		arm, clip if clip != "" else "-", moved, slide[0], worst[0], w0, w0 + WINDOW_S, slide[1], worst[1]])


func _world(skel: Skeleton3D, tap: Node, bone: String) -> Vector3:
	var shown: Dictionary = tap.shown
	if not shown.has(bone):
		return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin
	return skel.global_transform * (shown[bone] as Vector3)


func _feet(clips: Array) -> void:
	var bx: Dictionary = stage.boxers[0]
	for c in clips:
		if not stage.has_move(c):
			print("FEET %s missing" % c)
			continue
		var length: float = (bx["ap"] as AnimationPlayer).get_animation(c).length
		var n := int(length * 30.0)
		for k in n + 1:
			var t := length * k / n
			var hp: Vector3 = Stage.IdleMatch.pose_point(bx, c, t, "Hips")
			var lf: Vector3 = Stage.IdleMatch.pose_point(bx, c, t, "LeftFoot")
			var rf: Vector3 = Stage.IdleMatch.pose_point(bx, c, t, "RightFoot")
			print("FEET %s t=%.2f hips x%+.2f | L x%+.2f y%.2f z%+.2f | R x%+.2f y%.2f z%+.2f" % [c, t, hp.x, lf.x, lf.y, lf.z, rf.x, rf.y, rf.z])
