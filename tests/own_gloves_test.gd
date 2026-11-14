extends SceneTree
## S476 CLASH3: a boxer's own two gloves stay out of each other in the guard and its fidgets (no punches thrown). Ruler:
## tools/clash_meter.gd own() - the drawn gloves as capsules (0.17 m glove, Gloves.SIZE 1.2), deepest of her glove x her other
## glove / her other forearm. Guard gloves touch, so the bar allows the meter's 2 cm of padding give (hit_frame_film CLASH_M).
## Red on main S476: boxer 1 (mh_boxer_02 southpaw) 0.068 m in pro_idle, 0.127 m in a fidget; boxer 0 0.021 / 0.100 m.
## Population: mh_boxer_01 orthodox v mh_boxer_02 southpaw. The bar must read worse: a glove moved 10 cm into the other trips it.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const CM := preload("res://tools/clash_meter.gd")
const DT := 1.0 / 30.0
const WARMUP := 60
const FRAMES := 600
const BAR_M := 0.02

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _initialize() -> void:
	Engine.max_fps = 30
	var a := [Vector3.ZERO, Vector3(0, 0, 0.2), 0.075]
	var b := [Vector3(0.2, 0, 0), Vector3(0.2, 0, 0.2), 0.075]
	var b_in := [Vector3(0.1, 0, 0), Vector3(0.1, 0, 0.2), 0.075]
	_check(CM.depth(a, b) <= BAR_M and CM.depth(a, b_in) > BAR_M, "the ruler reads gloves 20 cm apart clear and 10 cm apart inside")
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_01.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue", "stance": "southpaw"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	_check(CM.arms(stage, 0).size() == 2 and CM.arms(stage, 1).size() == 2, "both boxers wear two gloves")
	var worst := [{"depth": -9.0}, {"depth": -9.0}]
	var deep := [0, 0]
	var n := 0
	for f in WARMUP + FRAMES:
		stage._process(DT)
		await process_frame
		if f < WARMUP:
			continue
		n += 1
		for i in 2:
			var one: Dictionary = {"depth": -9.0}
			var arms := CM.arms(stage, i)
			for pair in [["glove", "glove"], ["glove", "fore"], ["fore", "glove"]]:
				var d := CM.depth(arms[0][pair[0]], arms[1][pair[1]])
				if d > float(one["depth"]):
					one = {"depth": d, "pair": "%s x %s" % pair, "anim": str((stage.boxers[i]["ap"] as AnimationPlayer).current_animation)}
			if float(one["depth"]) > BAR_M:
				deep[i] += 1
			if float(one["depth"]) > float(worst[i]["depth"]):
				worst[i] = one
	for i in 2:
		print("OWN_GLOVES boxer=%d worst=%.3f (%s, %s) deep_frames=%d of %d" % [i, float(worst[i]["depth"]), str(worst[i].get("pair", "")), str(worst[i].get("anim", "")), int(deep[i]), n])
		_check(float(worst[i]["depth"]) <= BAR_M, "boxer %d's own gloves stay out of each other (%.3f m, bar %.2f)" % [i, float(worst[i]["depth"]), BAR_M])
	print("OWN_GLOVES failures=%d" % failures)
	quit(1 if failures > 0 else 0)
