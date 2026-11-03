extends SceneTree
## S376 BJJCOACH1 the coach's steps on Ana's mat: every syllabus move has 4-6 steps; the steps split the film's keyframes
## evenly (by time when the film has fewer gaps than steps); the mat plays a step and holds inside its end, at half speed
## when asked; the step list lights the step the film is on and a click plays that one; the leg locks play leg locks.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const BjjFilm := preload("res://scripts/rules/BjjFilm.gd")
const BjjSteps := preload("res://scripts/rules/BjjSteps.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const MatPlayer := preload("res://scripts/ui/MatPlayer.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const CoachSteps := preload("res://scripts/ui/CoachSteps.gd")

var failures := 0


func _initialize() -> void:
	# 1. Every syllabus move has the coach's 4-6 steps.
	var short: Array = []
	for belt in ["white", "blue", "purple", "brown"]:
		for id in BeltRoad.moves_for(belt):
			var n := BjjSteps.steps(str(id)).size()
			if n < 4 or n > 6:
				short.append("%s:%d" % [id, n])
	_check(short.is_empty(), "every syllabus move has 4-6 coach steps (off: %s)" % str(short))
	for id in BjjFilm.FILM:
		_check(not BjjSteps.steps(str(id)).is_empty(), "filmed %s has steps" % id)

	# 2. The split: keyframes when there are enough gaps, time when not.
	var keys := PackedFloat32Array([0.0, 0.5, 1.0, 1.4, 2.0, 2.5, 3.0])   # 6 gaps
	var at := BjjSteps.starts(keys, 3)
	_check(at == PackedFloat32Array([0.0, 1.0, 2.0]), "6 gaps over 3 steps start on keyframes 0, 2, 4 (%s)" % str(at))
	var few := BjjSteps.starts(PackedFloat32Array([0.0, 0.6, 2.0]), 4)   # 2 gaps, 4 steps
	_check(few == PackedFloat32Array([0.0, 0.5, 1.0, 1.5]), "2 gaps over 4 steps split by time (%s)" % str(few))
	_check(BjjSteps.index_at(at, 0.0) == 0 and BjjSteps.index_at(at, 1.5) == 1 and BjjSteps.index_at(at, 2.9) == 2,
		"the step playing follows the time")
	_check(is_equal_approx(BjjSteps.end_of(at, 0, 3.0), 1.0) and is_equal_approx(BjjSteps.end_of(at, 2, 3.0), 3.0),
		"a step ends where the next starts, the last at the film's end")

	# 3. The leg locks play leg-lock sequences, not the judo trip (S376); the scissor sweep is unfilmed, not a flying scissor.
	var db := DB.load_db()
	for id in ["straight_ankle_lock", "outside_heel_hook", "inside_heel_hook", "saddle_entry"]:
		var i := BjjFilm.find(db, id)
		_check(i >= 0 and not str(db[i]["title"]).to_lower().contains("soto"), "%s plays %s" % [id, str(db[i]["title"]).replace("\n", " ") if i >= 0 else "nothing"])
	_check(BjjFilm.find(db, "scissor_sweep") == -1, "the scissor sweep plays no flying scissor")
	var bi := BjjFilm.find(db, "berimbolo")
	_check(bi >= 0 and (db[bi]["frames"] as Array).size() == 8, "the berimbolo is the 8-keyframe spin to the back")

	# 4. The mat: a step plays to its end and holds, at half speed when set.
	var mat := MatPlayer.new()
	mat.player = Player.new()
	_check(mat.play_move("kimura"), "the mat plays the kimura")
	var kt := mat.key_times()
	var length := kt[kt.size() - 1]
	_check(kt.size() >= 3 and length > 1.0, "the kimura's film has keyframes (%d, %.1f s)" % [kt.size(), length])
	var steps := CoachSteps.new()
	steps.setup(mat)
	steps.show_move("kimura", true)
	_check(steps.step_count() == BjjSteps.steps("kimura").size(), "the list shows the kimura's %d steps" % steps.step_count())
	steps._process(0.0)
	_check(steps.lit() == 0, "the film's start lights step 1")
	mat.set_speed(0.5)
	steps.play_step(1)
	var at_k := BjjSteps.starts(kt, steps.step_count())
	var t0 := mat.time()
	_tick(mat, 0.2)
	_check(is_equal_approx(mat.time() - t0, 0.1), "0.5x: 0.2 s of game time moves the film 0.1 s (%.3f)" % (mat.time() - t0))
	for k in 200:
		_tick(mat, 0.05)
	var end := BjjSteps.end_of(at_k, 1, length)
	_check(mat.paused() and absf(mat.time() - (end - MatPlayer.HOLD_IN_S)) < 0.001, "step 2 holds inside its end (%.3f vs %.3f)" % [mat.time(), end])
	steps._process(0.0)
	_check(steps.lit() == 1, "the held step stays lit (%d)" % steps.lit())
	mat.set_paused(false)
	mat.set_speed(1.0)
	_tick(mat, length)
	_check(not mat.paused() and mat.time() >= end, "Play runs on from the hold")
	_check(mat.play_move("triangle") and not mat.paused(), "watching another move plays it")
	steps.show_move("americana", false)
	steps._process(0.0)
	_check(steps.step_count() == 5 and steps.lit() == -1, "an unfilmed move lists its steps, none lit")
	steps.free()
	mat.player.free()
	mat.free()
	print("BJJ_COACH failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## One frame of the mat's clock: the mat checks its hold, then the film advances (the scene tree's order: parent first).
func _tick(mat: Control, dt: float) -> void:
	mat._process(dt)
	mat.player._process(dt)
	mat._process(0.0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
