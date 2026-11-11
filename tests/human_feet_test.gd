extends SceneTree
## HUMANFIGHT1 (operator S430: "i see some animations the fighters are off the ground flying"). The ruler the old foot tests
## could not be: they read only frames where the footwork rig has the legs and only the plan's planted foot, but three
## quarters of a round a boxer plays a captured take "pure" (RkPure: every leg layer off), and that is where she leaves
## the canvas - at each return to her guard from a duck, a block, a punch or a reaction her body hops 5-9 cm clear for
## about half a second (tools/human_fight_film.gd on the real bout: 5-13 hops a boxer in two rounds).
## This test plays the stage calls the fight makes (FightStage.play / guard / step / circle, two DIFFERENT bodies, the
## captured clips on as in the game) and reads the DRAWN skeleton every frame (skeleton_updated, after every modifier),
## whoever has the legs. The floor is absolute: the canvas is y 0, a ball or ankle joint stands at its rest height.
##   AIRBORNE  = both feet off the canvas (ball AND ankle of each more than OFF_M over standing) - a boxer never is
##   UNDER     = a ball or an ankle more than SINK_M under its standing height
##   DRAGGED   = a landed punch from out of range: the fight carries her place in by the contact (FightStage.land ->
##               PunchRange.close_in, up to 3 m/s). Her stiller standing foot's travel on the canvas while it stands
##               (ball within LOW_M of the canvas) is a foot dragged, not stepped: more than DRAG_MAX_M is a slide.
## Run at the game's frame step:  <godot> --headless --fixed-fps 30 --audio-driver Dummy --path . --script res://tests/human_feet_test.gd
## (without --fixed-fps the test caps itself at 30 frames a second and takes real time).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const PunchRange := preload("res://scripts/fight3d/PunchRange.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const DT := 1.0 / 30.0
const OFF_M := 0.03
const SINK_M := 0.03
const AIR_RUN_MAX := 2          # frames in a row both feet may read off (a blend's rounding), 0.07 s
const LOW_M := 0.015           # a ball this close to the canvas stands on it (a stepping foot lifts 2.5-6 cm)
const DRAG_MAX_M := 0.27        # one foot length: a step-drag drags the rear foot at most one step (BoxerFootwork.STEP_M 0.26; real 0.27-0.30). Main drags 0.8-1.1 m
const CARRIED := [[0, "rk_jab", 0.27], [1, "rk_cross", 0.40], [0, "rk_jab", 0.27], [1, "rk_jab", 0.27]]
const CARRY_GAP_M := 1.7
const CARRY_M := 0.55
const FEET := [["LeftToes", "LeftFoot"], ["RightToes", "RightFoot"]]
## The moves a round is made of, as the fight starts them: [boxer, clip, speed]. Each is followed by her guard.
const MOVES := [
	[0, "pro_back_dodge", 1.1], [1, "pro_left_dodge", 1.1], [0, "mc_to_block", 1.0], [1, "pro_right_weave", 1.1],
	[0, "pro_body_shot", 1.0], [1, "pro_left_hook_v2", 1.0], [0, "pro_hit_by_jab_v3", 1.0], [1, "pro_right_uppercut", 1.0],
	[0, "rk_jab", 1.0], [1, "rk_cross", 1.0], [0, "pro_right_dodge", 1.1], [1, "pro_hit_by_cross_v2_short", 1.0],
	[1, "pro_back_dodge", 1.1], [0, "pro_left_hook_v2", 1.0], [1, "mc_to_block", 1.0], [0, "pro_right_weave", 1.1],
]

var failures := 0
var stage: Node3D
var floor_y: Array = []         # per boxer [[ball, ankle] per foot] standing heights, world
var seen: Array = [{}, {}]      # per boxer: the drawn feet this frame {bone: Vector3 world}
var st: Array = []              # per boxer tallies
var tag := "start"
var prev: Array = [{}, {}]      # last frame's drawn feet
var _dbg_who := 0


func _initialize() -> void:
	RkClips.enabled = true   # S432: the captured takes are opt-in (`-- rokoko`, Q-183); this ruler measures their feet
	if not OS.get_cmdline_args().has("--fixed-fps"):
		Engine.max_fps = 30
	stage = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_03.glb", "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	for i in 2:
		var bx: Dictionary = stage.boxers[i]
		var skel: Skeleton3D = bx["skel"]
		var sc: float = (bx["node"] as Node3D).scale.x
		var fl: Array = []
		for foot in FEET:
			fl.append([skel.get_bone_global_rest(skel.find_bone(foot[0])).origin.y * sc, skel.get_bone_global_rest(skel.find_bone(foot[1])).origin.y * sc])
		floor_y.append(fl)
		st.append({"frames": 0, "air": 0, "run": 0, "longest": 0, "peak": 0.0, "under": 0, "deep": 0.0, "worst": "", "by": {}, "slip": {}})
		skel.skeleton_updated.connect(_shown.bind(i))
	await _frames(2.0)
	_check(float(stage.boxers[0]["rig"].w) >= 0.0 and bool(stage.feet.rig_on), "the stage is played (the rig may take the legs)")
	for m in MOVES:
		var who := int(m[0])
		var clip := str(m[1])
		var ap: AnimationPlayer = stage.boxers[who]["ap"]
		if not ap.has_animation(clip):
			_check(false, "%s is in the library" % clip)
			continue
		tag = clip
		stage.play(who, clip, float(m[2]))
		var left := 240
		while left > 0 and str(ap.current_animation) == clip:   # to its end: the stage puts her back in her guard
			await _frames(DT)
			left -= 1
		tag = clip + " -> guard"
		await _frames(1.3)
	# Steps: a lunge in, a step out, a circle - the captured step clips carry the body.
	tag = "step in"
	stage.step(0, 1)
	await _frames(1.6)
	tag = "step out"
	stage.step(1, -1)
	await _frames(1.6)
	tag = "circle"
	stage.circle(1, 0.9)
	await _frames(2.0)
	# A landed punch from out of range, as the fight throws it: the punch starts, the stage carries her in by the contact.
	for c in CARRIED:
		var who := int(c[0])
		var a: Vector3 = stage.boxers[0]["pos"]
		var b: Vector3 = stage.boxers[1]["pos"]
		var axis := (b - a).normalized()
		var mid := (a + b) * 0.5
		stage.boxers[0]["pos"] = mid - axis * CARRY_GAP_M * 0.5
		stage.boxers[1]["pos"] = mid + axis * CARRY_GAP_M * 0.5
		tag = "apart"
		for k in 2:
			stage.guard(k)
		await _frames(1.5)
		tag = "carried " + str(c[1])
		var before: Vector3 = stage.boxers[who]["pos"]
		_dbg_who = who
		var drag0 := float(st[who]["slip"].get(tag, 0.0))
		stage.play(who, str(c[1]), 1.0)
		stage.land(who, str(c[1]), false, float(c[2]), float(c[2]))
		PunchRange.close_in(stage, who, CARRY_M, float(c[2]))   # what land() calls when she is this far short (the real bout: 0.65 m)
		await _frames(0.7)
		var went: float = (stage.boxers[who]["pos"] as Vector3).distance_to(before)
		var drag: float = float(st[who]["slip"].get(tag, 0.0)) - drag0
		print("HUMAN_FEET boxer %d %s: her place carried %.2f m, her standing foot dragged %.2f m" % [who, str(c[1]), went, drag])
		_check(went > 0.25, "boxer %d %s: the fight carried her in (%.2f m)" % [who, str(c[1]), went])
		_check(drag <= DRAG_MAX_M, "boxer %d %s carried %.2f m: her feet step, they are not dragged (%.2f m dragged)" % [who, str(c[1]), went, drag])
		tag = "after carry"
		await _frames(1.0)
	for i in 2:
		var d: Dictionary = st[i]
		var n := maxi(1, int(d["frames"]))
		print("HUMAN_FEET boxer %d frames %d | airborne %d frames (%.1f %%), longest %d frames, lowest foot at its highest %.1f cm (%s) | under the canvas %d frames, deepest %.1f cm" % [
			i, n, int(d["air"]), 100.0 * int(d["air"]) / n, int(d["longest"]), 100.0 * float(d["peak"]), str(d["worst"]), int(d["under"]), 100.0 * float(d["deep"])])
		var by: Dictionary = d["by"]
		var keys: Array = by.keys()
		keys.sort_custom(func(a, b): return int(by[a]) > int(by[b]))
		print("HUMAN_FEET boxer %d airborne frames by move: %s" % [i, ", ".join(keys.slice(0, 8).map(func(k): return "%s %d" % [k, int(by[k])]))])
		_check(int(d["frames"]) > 600, "boxer %d was read on every frame (%d frames)" % [i, int(d["frames"])])
		_check(int(d["longest"]) <= AIR_RUN_MAX, "boxer %d never has both feet off the canvas (longest %d frames, peak %.1f cm in %s)" % [
			i, int(d["longest"]), 100.0 * float(d["peak"]), str(d["worst"])])
		_check(float(d["deep"]) <= SINK_M, "boxer %d never stands under the canvas (deepest %.1f cm, %d frames)" % [i, 100.0 * float(d["deep"]), int(d["under"])])
	print("HUMAN_FEET_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The drawn feet of boxer i (after every modifier).
func _shown(i: int) -> void:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var xf := skel.global_transform
	for foot in FEET:
		for b in foot:
			seen[i][b] = xf * skel.get_bone_global_pose(skel.find_bone(str(b))).origin


func _frames(secs: float) -> void:
	for f in maxi(1, int(round(secs / DT))):
		stage.aim({"phase": "rest", "who": -1, "move": "jab"})
		stage._process(DT)
		await process_frame
		_tally()


func _tally() -> void:
	for i in 2:
		if (seen[i] as Dictionary).size() < 4:
			continue
		var d: Dictionary = st[i]
		d["frames"] = int(d["frames"]) + 1
		var clear: Array = []
		for k in 2:
			var ball: float = (seen[i][FEET[k][0]] as Vector3).y - float(floor_y[i][k][0])
			var ankle: float = (seen[i][FEET[k][1]] as Vector3).y - float(floor_y[i][k][1])
			clear.append(minf(ball, ankle))
		var low: float = minf(clear[0], clear[1])
		if low > OFF_M:
			d["air"] = int(d["air"]) + 1
			d["run"] = int(d["run"]) + 1
			d["by"][tag] = int(d["by"].get(tag, 0)) + 1
			d["longest"] = maxi(int(d["longest"]), int(d["run"]))
			if low > float(d["peak"]):
				d["peak"] = low
				d["worst"] = tag
		else:
			d["run"] = 0
		if low < -SINK_M:
			d["under"] = int(d["under"]) + 1
		d["deep"] = maxf(float(d["deep"]), -low)
		# the stiller standing foot's travel on the canvas
		if (prev[i] as Dictionary).size() == 4:
			var still := INF
			for k in 2:
				var ball: Vector3 = seen[i][FEET[k][0]]
				if ball.y - float(floor_y[i][k][0]) < LOW_M:
					var was: Vector3 = prev[i][FEET[k][0]]
					still = minf(still, Vector2(ball.x - was.x, ball.z - was.z).length())
			if still < INF:
				d["slip"][tag] = float(d["slip"].get(tag, 0.0)) + still
		if OS.get_cmdline_user_args().has("dbg") and tag.begins_with("carried") and i == _dbg_who:
			var bx: Dictionary = stage.boxers[i]
			print("DBG %s %s ct %.2f pos %.2f %.2f node %.2f %.2f vel %.1f left %.2f | L %.2f %.2f y %.3f | R %.2f %.2f y %.3f | pure %.2f legs %.2f carry %.2f rigw %.2f held %s" % [tag, str((bx["ap"] as AnimationPlayer).current_animation), (bx["ap"] as AnimationPlayer).current_animation_position,
				bx["pos"].x, bx["pos"].z, (bx["node"] as Node3D).position.x, (bx["node"] as Node3D).position.z, (bx["vel"] as Vector3).length(), float(bx["move_left"]),
				seen[i]["LeftToes"].x, seen[i]["LeftToes"].z, seen[i]["LeftToes"].y, seen[i]["RightToes"].x, seen[i]["RightToes"].z, seen[i]["RightToes"].y,
				float(bx.get("rk_p", 0.0)), float(bx.get("rk_legs", 0.0)), float(bx.get("rk_carry", 0.0)), float(bx["rig"].w), str(bx["lock"].held) if bx.get("lock") != null else "-"])
		prev[i] = (seen[i] as Dictionary).duplicate()


func _check(ok: bool, what: String) -> void:
	print("  %s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1
