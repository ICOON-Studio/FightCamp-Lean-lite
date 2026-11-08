extends SceneTree
## S399 ROKOKO2 joins (operator: "the clips seem fine but what matters is the sequence blending"): one boxer runs a scripted
## sequence at real speed in the fight stage - the walk out, her guard, steps in / back / to the sides, jab, cross, jab-cross,
## a step back - and every JOIN (a clip change) is measured on the drawn pose (bones read inside skeleton_updated): each
## foot's planted slide over the JOIN_S after it, leg snaps, and the lead foot's jump. Run headless under --fixed-fps 30 for
## the numbers, or windowed under the movie writer for the film (a side camera that eases after her; the other boxer stands
## in her guard across the ring; the fight's own range keeping is off so only the script moves her).
##   <godot.exe> --headless --fixed-fps 30 --path . --script res://tools/rokoko_seq.gd [-- glb=mh_boxer_01]
## Prints SEQJOIN <from> -> <to> at <s>: slide L/R m, snaps, and SEQSUM totals.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Footwork := preload("res://scripts/fight3d/Footwork.gd")
const DT := 1.0 / 30.0
const JOIN_S := 0.45
const PLANT_M := 0.03
const SNAP_DEG := 6.0
const LEGS := ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]
## [action, seconds of guard after it]
const SCRIPT := [["walk", 0.0], ["guard", 1.6], ["in", 0.6], ["jab", 0.5], ["cross", 0.7], ["back", 0.8], ["left", 0.6],
	["jab", 0.25], ["cross", 0.9], ["right", 0.6], ["in", 0.4], ["jab", 0.6], ["back", 0.8], ["cross", 0.6], ["left", 0.6],
	["jab", 0.2], ["cross", 0.6], ["back", 1.0], ["guard", 1.5]]


class NoRange extends "res://scripts/fight3d/Footwork.gd":
	func aim_step(_dist: float, _a_far: bool) -> void:
		pass

	func rhythm(_delta: float, _dist: float) -> void:
		pass


var stage: Node3D
var cam: Camera3D
var drawn := {}
var log_frames: Array = []   # [clip, pose]


func _initialize() -> void:
	var glb := "mh_boxer_01"
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("glb="):
			glb = str(a).substr(4)
	stage = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % glb, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var nr := NoRange.new()
	nr.setup(stage)
	stage.feet = nr
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	skel.skeleton_updated.connect(func():
		var x := skel.global_transform
		var out := {}
		for b in LEGS:
			var i := skel.find_bone(b)
			out[b] = x * skel.get_bone_global_pose(i).origin
			out[b + "_q"] = (skel.get_bone_global_pose(skel.get_bone_parent(i)).basis.get_rotation_quaternion().inverse()
				* skel.get_bone_global_pose(i).basis.get_rotation_quaternion()).normalized()
		drawn = out)
	# her start: 2.2 m back from her fight place, so the walk out carries her there
	stage.boxers[0]["pos"] = (stage.boxers[0]["pos"] as Vector3) + Vector3(0, 0, -2.2)
	# the other stands back out of her reach (the script's steps in and the jabs' own travel brought them chest to chest)
	stage.boxers[1]["pos"] = (stage.boxers[1]["pos"] as Vector3) + Vector3(0, 0, 0.9)
	cam = Camera3D.new()
	cam.fov = 40.0
	root.add_child(cam)
	cam.current = true
	stage.camera.set_process(false)
	for row in SCRIPT:
		await _act(str(row[0]))
		await _hold(float(row[1]))
	_report()
	quit(0)


func _act(what: String) -> void:
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	match what:
		"walk":
			stage._start(0, "rk_loc_walk", 1.0, Stage.GUARD_FADE_S)
			var info: Dictionary = preload("res://scripts/fight3d/RkLoco.gd").info(bx["skel"], "rk_loc_walk")
			var secs := float(info.get("loop_s", 1.0)) * 1.0
			for f in int(secs / DT):
				await _frame()
			stage.guard(0)
		"guard":
			if not str(ap.current_animation).begins_with("rk_guard"):
				stage.guard(0)
		"in", "back", "left", "right":
			var clip: String = {"in": "advance", "back": "retreat", "left": "strafe_left", "right": "strafe_right"}[what]
			stage.feet.walk(0, clip, 0.30 / (float(Footwork.STRIDE[clip][0]) * Footwork.WALK_SCALE), Footwork.WALK_SCALE)
			while float(bx["move_left"]) > 0.0:
				await _frame()
		"jab", "cross":
			var clip2 := "rk_" + what
			stage.play(0, clip2, 1.0)
			var n := int(ap.get_animation(clip2).length / DT)
			for f in n:
				await _frame()
				if str(ap.current_animation) != clip2:
					break


func _hold(seconds: float) -> void:
	for f in int(seconds / DT):
		await _frame()


func _frame() -> void:
	stage.aim({"phase": "rest", "who": -1, "move": "jab"})
	stage._process(DT)
	var hips: Vector3 = (stage.boxers[0]["node"] as Node3D).global_position
	var want := hips + Vector3(3.2, 1.1, 0.4)
	cam.global_position = want if log_frames.is_empty() else cam.global_position.lerp(want, 0.08)
	cam.look_at(cam.global_position + (hips + Vector3(0, 0.9, 0) - want).normalized(), Vector3.UP)
	await process_frame
	if not drawn.is_empty():
		log_frames.append([str((stage.boxers[0]["ap"] as AnimationPlayer).current_animation), drawn])


func _report() -> void:
	var joins := 0
	var total := [0.0, 0.0]
	var worst := ""
	var worst_m := 0.0
	var span := int(JOIN_S / DT)
	for i in range(1, log_frames.size()):
		if log_frames[i][0] == log_frames[i - 1][0]:
			continue
		var w: Array = []
		for k in range(i - 1, mini(i + span, log_frames.size())):
			w.append(log_frames[k][1])
		var m := _measure(w)
		joins += 1
		total[0] += float(m["L"])
		total[1] += float(m["R"])
		if float(m["L"]) + float(m["R"]) > worst_m:
			worst_m = float(m["L"]) + float(m["R"])
			worst = "%s -> %s" % [log_frames[i - 1][0], log_frames[i][0]]
		print("SEQJOIN %s -> %s at %.2f s: slide L %.3f R %.3f m, leg snaps %d, worst %.1f deg %s" % [log_frames[i - 1][0], log_frames[i][0],
			i * DT, float(m["L"]), float(m["R"]), int(m["snaps"]), float(m["worst"]), str(m.get("where", ""))])
	var whole := _measure(log_frames.map(func(r): return r[1]))
	# snaps per clip (the run cut into its clips, joins included at each clip's start)
	var seg_start := 0
	var per := {}
	for i in range(1, log_frames.size() + 1):
		if i == log_frames.size() or log_frames[i][0] != log_frames[i - 1][0]:
			var mm := _measure(log_frames.slice(seg_start, i).map(func(r): return r[1]))
			per[log_frames[seg_start][0]] = int(per.get(log_frames[seg_start][0], 0)) + int(mm["snaps"])
			seg_start = i
	print("SEQSNAPS per clip: ", per)
	print("SEQSUM joins=%d join_slide L %.2f R %.2f m (worst %s %.2f) | whole run %.1f s: slide L %.2f R %.2f m, leg snaps %d" % [
		joins, total[0], total[1], worst, worst_m, log_frames.size() * DT, float(whole["L"]), float(whole["R"]), int(whole["snaps"])])


## Planted slide per foot (toe ball within PLANT_M of its lowest in the window), leg snaps (clip_feet_probe definition).
func _measure(frames: Array) -> Dictionary:
	var out := {"L": 0.0, "R": 0.0, "snaps": 0, "worst": 0.0}
	if frames.size() < 3:
		return out
	for toe in ["LeftToes", "RightToes"]:
		var low := INF
		for p in frames:
			low = minf(low, (p[toe] as Vector3).y)
		var s := 0.0
		for i in range(1, frames.size()):
			var a: Vector3 = frames[i - 1][toe]
			var b: Vector3 = frames[i][toe]
			if a.y - low < PLANT_M and b.y - low < PLANT_M:
				s += Vector2(b.x - a.x, b.z - a.z).length()
		out["L" if toe == "LeftToes" else "R"] = s
	for leg in LEGS:
		var prev := Quaternion.IDENTITY
		for i in range(1, frames.size()):
			var turn: Quaternion = (frames[i][leg + "_q"] as Quaternion) * (frames[i - 1][leg + "_q"] as Quaternion).inverse()
			if i >= 2:
				var d := rad_to_deg(turn.angle_to(prev))
				out["snaps"] = int(out["snaps"]) + (1 if d > SNAP_DEG else 0)
				if d > SNAP_DEG:
					out["where"] = str(out.get("where", "")) + " %s@%d:%.0f" % [leg.trim_suffix("Leg").trim_prefix("Left").trim_prefix("Right").left(5) + leg.left(1), i, d]
				out["worst"] = maxf(float(out["worst"]), d)
			prev = turn
	return out
