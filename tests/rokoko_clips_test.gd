extends SceneTree
## S399 ROKOKO2 (operator S399: "these animations are good why you removed them and changed them with crap"): the Rokoko
## captured jab, cross and guard play in the fight, ON, as cleanly as the source take.
##   1. the fight picks them: the guard is the captured one, a plain jab / cross is a captured one (a big shot, a miss, a
##      tired punch keep the Punch PRO takes), and `-- norokoko` is the only way to the Pro set
##   2. each window, built on the boxer (RkRetarget = the old repo's MixamoMotion route), stands ORTHODOX (the actor fights
##      southpaw in most of the takes: those windows are mirrored), its toe balls on the canvas (not under it)
##   3. played in the fight stage, on the DRAWN pose (bones read inside skeleton_updated): every synthetic layer is off while
##      it plays (plays pure; MetaHumanTwist and the JoinSmoother stay), no footwork rhythm step goes in over the captured
##      guard, and after the 0.3 s join the planted toe-ball slide is within SLIDE_OVER_RAW_M of the RAW take's and the leg
##      snaps no more than the raw's (tools/raw_fbx_window.py in Blender 5.2, same definitions, same spans, 30 fps)
## Red on main: no rk_ clip exists there (the S381 owned bake rk_*.res is the broken route: 1.7-6.6 m of slide).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const RkPure := preload("res://scripts/fight3d/RkPure.gd")
const DT := 1.0 / 30.0
const PLANT_M := 0.03
const SNAP_DEG := 6.0
const JOIN_F := 9
const SLIDE_OVER_RAW_M := 0.05
const GUARD_OVER_RAW_M := 0.12   # a 9 s guard window: +0.12 m over the raw's own 0.17 (our feet are not the actor's length)
const LEGS := ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]
## The raw take over the same spans (window start + 0.30 s to its end): [planted slide m, leg snaps]. S399 Blender runs.
const RAW := {
	"rk_jab": [0.016, 0], "rk_cross": [0.069, 0], "rk_cross_b": [0.028, 0],
	"rk_guard_b": [0.174, 0],
}

## S399 locomotion (RkLoco): the fight asks for a step, a captured step clip carries her by its own hip travel. Raw over the
## same span after the 0.3 s join (Blender): [planted slide m, leg snaps]; a side step's raw is per loop (two loops played).
const RAW_LOCO := {"advance:0.40": ["rk_loc_in", 0.488, 8], "retreat:0.50": ["rk_loc_back", 0.631, 5],
	"strafe_left:0.30": ["rk_loc_left", 0.728, 2], "strafe_right:0.30": ["rk_loc_right", 0.209, 3]}

var failures := 0


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	var glb := "res://assets/models/metahuman/mh_boxer_13.glb"
	stage.setup({"glb": glb, "corner": "red"}, {"glb": glb, "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	var skel: Skeleton3D = bx["skel"]
	# 1. the picker
	_check(BeatClips.first(BeatClips.GUARD, stage.has_move) == "rk_guard", "the guard between moves is the captured one")
	for move in ["jab", "cross"]:
		var got := {}
		for i in 10:
			got[BeatClips.punch(move, {"roll": i / 10.0}, stage.has_move)] = true
		_check(got.keys().all(func(n): return str(n).begins_with("rk_")) and got.size() == RkClips.PUNCH[move].size(),
			"a plain %s plays the captured takes (%s)" % [move, ", ".join(got.keys())])
		_check(BeatClips.punch(move, {"roll": 0.5, "big": true}, stage.has_move).begins_with("pro_"), "a big %s keeps its Punch PRO take" % move)
	_check(BeatClips.contact_row("rk_cross").get("hand", "") == "RightHand" and BeatClips.contact("rk_jab", 0.0) > 0.2, "captured punches carry their hand and contact")
	# 2. built clips: orthodox, on the canvas
	var rest_ball := skel.get_bone_global_rest(skel.find_bone("LeftToes")).origin.y
	for name in RkClips.CLIPS:
		_check(ap.has_animation(name), "%s is in the boxer's library" % name)
	# 3. in the fight, the drawn pose: tools/rokoko_feet_probe.gd in a child Godot under --fixed-fps 30 (every clock - the
	# clip, the join's dead blend, the stage - on 1/30 s; a real-time run under load measured the same clip 0 then 11 snaps)
	var out := _probe(["mode=fight", "clips=" + ",".join(RAW.keys())])
	for name in RAW:
		var whole := _row(out, "RKFEET %s (drawn, fight) " % name)
		var after := _row(out, "RKFEET %s (drawn, fight, after the 0.3 s join) " % name)
		var raw: Array = RAW[name]
		var over := GUARD_OVER_RAW_M if name.begins_with("rk_guard") else SLIDE_OVER_RAW_M
		_check(float(whole.get("pure_min_after_0.2s", 0.0)) >= 0.99, "%s plays pure (every layer off but the twist and the join)" % name)
		_check(float(after.get("lead_L_m", 0.0)) > 0.3, "%s stands orthodox (left foot %.2f m ahead)" % [name, float(after.get("lead_L_m", 0.0))])
		_check(absf(float(after.get("toe_low_y", 9.0)) - rest_ball) < 0.02, "%s: toe balls on the canvas (lowest %.3f m, rest %.3f)" % [name, float(after.get("toe_low_y", 9.0)), rest_ball])
		_check(float(after.get("slide_m", 9.0)) <= float(raw[0]) + over, "%s: planted slide %.3f m <= raw %.3f + %.2f" % [name, float(after.get("slide_m", 9.0)), float(raw[0]), over])
		_check(int(after.get("leg_snaps", 99)) <= int(raw[1]), "%s: leg snaps %d <= raw %d" % [name, int(after.get("leg_snaps", 99)), int(raw[1])])
		if name.begins_with("rk_guard"):
			_check(int(whole.get("rig_step_frames", 99)) == 0, "no footwork rhythm step over the captured guard (%d frames stepping)" % int(whole.get("rig_step_frames", 99)))
	var lo := _probe(["mode=fight", "loco"])
	for ask in RAW_LOCO:
		var row: Array = RAW_LOCO[ask]
		var dir := str(ask).get_slice(":", 0)
		var head := _line(lo, "RKLOCO %s %s m asked -> " % [dir, str(ask).get_slice(":", 1)])
		_check(head.contains("-> %s," % str(row[0])), "a %s step plays the captured %s (%s)" % [dir, str(row[0]), head.get_slice("->", 1).get_slice(",", 0)])
		var moved := head.get_slice("moved ", 1).get_slice(" m", 0).to_float()
		_check(moved > str(ask).get_slice(":", 1).to_float() * 0.5, "%s: the clip carried her %.2f m" % [dir, moved])
		var m := _row(lo, "RKLOCO %s after the 0.3 s join: " % str(row[0]))
		_check(float(m.get("slide_m", 9.0)) <= float(row[1]) + SLIDE_OVER_RAW_M, "%s while she travels: planted slide %.3f m <= raw %.3f + %.2f" % [dir, float(m.get("slide_m", 9.0)), float(row[1]), SLIDE_OVER_RAW_M])
		_check(int(m.get("leg_snaps", 99)) <= int(row[2]), "%s: leg snaps %d <= raw %d" % [dir, int(m.get("leg_snaps", 99)), int(row[2])])
	print("ROKOKO_CLIPS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _probe(args: Array) -> String:
	var out: Array = []
	var cmd := ["--headless", "--fixed-fps", "30", "--audio-driver", "Dummy", "--path", ProjectSettings.globalize_path("res://"),
		"--script", "res://tools/rokoko_feet_probe.gd", "--", "noproguard"] + args   # these bars measure the Rokoko guard windows themselves
	OS.execute(OS.get_executable_path(), PackedStringArray(cmd), out, true)
	return "
".join(out)


func _line(text: String, prefix: String) -> String:
	for l in text.split("
"):
		if l.begins_with(prefix):
			return l
	return ""


## key=value pairs of the first line starting with `prefix`.
func _row(text: String, prefix: String) -> Dictionary:
	var d := {}
	for tok in _line(text, prefix).split(" "):
		if tok.contains("="):
			d[tok.get_slice("=", 0)] = tok.get_slice("=", 1)
	return d


func _step(stage: Node3D, _ap: AnimationPlayer, _skel: Skeleton3D) -> void:
	stage.aim({"phase": "rest", "who": -1, "move": "jab"})
	stage._process(DT)
	await process_frame


func _measure(frames: Array) -> Dictionary:
	var slide := 0.0
	var low_all := INF
	for toe in ["LeftToes", "RightToes"]:
		var low := INF
		for p in frames:
			low = minf(low, (p[toe] as Vector3).y)
		low_all = minf(low_all, low)
		for i in range(1, frames.size()):
			var a: Vector3 = frames[i - 1][toe]
			var b: Vector3 = frames[i][toe]
			if a.y - low < PLANT_M and b.y - low < PLANT_M:
				slide += Vector2(b.x - a.x, b.z - a.z).length()
	var snaps := 0
	for leg in LEGS:
		var prev := Quaternion.IDENTITY
		for i in range(1, frames.size()):
			var turn: Quaternion = (frames[i][leg + "_q"] as Quaternion) * (frames[i - 1][leg + "_q"] as Quaternion).inverse()
			if i >= 2 and rad_to_deg(turn.angle_to(prev)) > SNAP_DEG:
				snaps += 1
			prev = turn
	var lead := 0.0
	for p in frames:
		lead += ((p["LeftToes"] as Vector3).z - (p["RightToes"] as Vector3).z) / maxf(frames.size(), 1)
	return {"slide": slide, "snaps": snaps, "low": low_all, "lead": lead}


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
