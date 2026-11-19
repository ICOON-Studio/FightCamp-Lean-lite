extends SceneTree
## FIGHTPLAYER2 (S528, C434 "why the fighter do not walk ?"): the walking, pure (no stage, no picture).
##   DB      assets/data/foot_db.json holds the step takes (where each goes, when it travels) and every played take's feet
##   TAKES   each way a man can step has a captured take; the nearest in length is picked
##   SWING   FootTake.swing_at reads a take's table: standing, in the air, how long until it lifts
##   RING    the planner puts ring steps between exchanges: on both tracks, the other man answers a few frames later,
##           never over a punch, a defence or a reaction of either man, never two at once
##   WHOLE   the step out after a burst and the ease back to rest take a whole step's time
##   SAME    the same seed plans the same ring steps
## <godot> --headless --audio-driver Dummy --path . --script res://tests/ring_steps_test.gd

const Choreo := preload("res://scripts/fight3d/v2/Choreographer.gd")
const Drift := preload("res://scripts/fight3d/v2/ChoreoDrift.gd")
const Gap := preload("res://scripts/fight3d/v2/ChoreoGap.gd")
const StepPlay := preload("res://scripts/fight3d/v2/StepPlay.gd")
const FootTake := preload("res://scripts/fight3d/v2/FootTake.gd")
const ClipCensus := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")

var failures := 0


func _initialize() -> void:
	var db: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(ClipCensus.DB_PATH))
	var fdb: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/data/foot_db.json"))
	var steps: Dictionary = fdb.get("steps", {})
	var feet: Dictionary = fdb.get("feet", {})
	# DB
	var missing: Array = []
	for dir in StepPlay.TAKES:
		for c in StepPlay.TAKES[dir]:
			if not steps.has(c) or not feet.has(c) or not ResourceLoader.exists("res://assets/anim/baked/steps/%s.res" % c):
				missing.append(c)
	_check(missing.is_empty(), "DB every step take is baked and measured (missing %s)" % str(missing))
	var unplayed: Array = (db.get("played", []) as Array).filter(func(n): return not feet.has(n))
	_check(unplayed.is_empty(), "DB every played take has its feet table (without one: %s)" % str(unplayed.slice(0, 6)))
	var ways := {"fwd": Vector2(1, 0), "back": Vector2(-1, 0), "left": Vector2(0, 1), "right": Vector2(0, -1)}
	var wrong: Array = []
	for dir in StepPlay.TAKES:
		for c in StepPlay.TAKES[dir]:
			var tr: Array = (steps.get(c, {}) as Dictionary).get("travel", [0, 0])
			var v := Vector2(float(tr[0]), float(tr[1]))
			var mv: Array = (steps.get(c, {}) as Dictionary).get("move_s", [0, 0])
			if v.length() < 0.15 or v.normalized().dot(ways[dir]) < 0.9 or float(mv[1]) - float(mv[0]) < 0.25 or float((steps.get(c, {}) as Dictionary).get("slip_m", 1.0)) > 0.06:
				wrong.append(c)
	_check(wrong.is_empty(), "DB each step take goes its own way, 15 cm or more, over a quarter second, its standing foot still (%s)" % str(wrong))
	# TAKES
	var walk := StepPlay.new(null)
	walk.steps = steps
	var any := func(_c: String) -> bool: return true
	_check(walk.pick("back", 0.20, any) == "st_out_s" and walk.pick("back", 0.33, any) == "st_out_m", "TAKES a short step back and a longer one pick different takes")
	_check(walk.pick("left", 0.20, any) == "st_l_s" and walk.pick("left", 0.25, any) == "st_l_m" and walk.pick("fwd", 0.2, any) == "st_in_s", "TAKES the shortest take that covers the move is picked (never a shorter one stretched)")
	_check(walk.pick("back", 0.60, any) == "st_out_m", "TAKES a move longer than every take gets the longest")
	# S529 one stance per man: the walking takes are refitted onto the guard's stance (tools/step_bake.gd)
	var low: Array = []
	for dir in StepPlay.TAKES:
		for c in StepPlay.TAKES[dir]:
			var hy: Array = (steps.get(c, {}) as Dictionary).get("hips_y", [0, 0])
			var tr2: Array = (steps.get(c, {}) as Dictionary).get("travel", [9, 9])
			if float(hy[0]) < 0.82 or Vector2(float(tr2[0]), float(tr2[1])).length() > 0.40:
				low.append(c)
	_check(low.is_empty(), "STANCE each walking take rides at the guard's height (hips never under 0.82 m, the guard 0.88) and is a boxing step (40 cm at most) (%s)" % str(low))
	_check(walk.pick("fwd", 0.3, func(_c: String) -> bool: return false) == "", "TAKES a take the boxer does not have is never picked")
	# SWING
	var st: Array = [[0.0, 0.2], [0.5, 1.0]]
	_check(FootTake.swing_at(st, 0.1, 1.0).x < 0.0 and absf(FootTake.swing_at(st, 0.1, 1.0).y - 0.1) < 0.001, "SWING a standing foot knows how long until its take lifts it")
	_check(FootTake.swing_at(st, 0.3, 1.0) == Vector2(0.2, 0.5), "SWING between two stands the foot is in the air, from one to the other")
	_check(FootTake.swing_at(st, 0.8, 1.0).x < 0.0 and FootTake.swing_at(st, 0.8, 1.0).y == INF, "SWING the last stand holds to the end")
	_check(FootTake.swing_at([[0.3, 0.6]], 0.1, 1.0) == Vector2(0.0, 0.3) and FootTake.swing_at([[0.3, 0.6]], 0.8, 1.0) == Vector2(0.6, 1.0), "SWING a take may begin and end with the foot in the air")
	_check(FootTake.swing_at([], 0.5, 1.0) == Vector2(0.0, 1.0), "SWING a foot that never stands is the take's own all the way")
	# RING + WHOLE + SAME
	var n_ring := 0
	var over := 0
	var apart := 0
	var lonely := 0
	var late := 0
	var short := 0
	var same := true
	for seed in 12:
		var round := {"n": 1, "won": true, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, "Slugger", "Slugger", 30.0, seed)["beats"]
		var opts := {"t0": 0.0, "t1": 30.0, "gap0": 1.32, "seed": seed, "south": {"a": false, "b": false}, "scale": {"a": 1.0, "b": 1.0}}
		var plan: Dictionary = Choreo.plan(beats, db, opts)
		var again: Dictionary = Choreo.plan(beats, db, opts)
		var rows: Dictionary = db["rows"]
		var by_id := {}
		var busy: Array = []
		for w in ["a", "b"]:
			for e in plan["tracks"][w]:
				if e.has("drift"):
					if not by_id.has(int(e["drift"])):
						by_id[int(e["drift"])] = []
					(by_id[int(e["drift"])] as Array).append(e)
				elif str(e["kind"]) in Drift.BUSY:
					var left: float = float(e.get("until_s", (rows.get(str(e.get("clip", "")), {}) as Dictionary).get("length_s", 1.2))) - float(e.get("from_s", 0.0))
					busy.append([float(e["t"]), maxf(float(e["control_t"]), float(e["t"]) + (left if str(e["kind"]) != "pass" else 2.0))])
		var spans: Array = []
		for id in by_id:
			var pair: Array = by_id[id]
			n_ring += 1
			if pair.size() != 2:
				lonely += 1
				continue
			var lead: Dictionary = pair[0] if bool(pair[0]["lead"]) else pair[1]
			var other: Dictionary = pair[1] if bool(pair[0]["lead"]) else pair[0]
			var d := float(other["t"]) - float(lead["t"])
			if d < Drift.ANSWER_S.x - 0.001 or d > Drift.ANSWER_S.y + 0.001 or bool(other["lead"]):
				late += 1
			for b in busy:
				if float(lead["t"]) < float(b[1]) and float(lead["end_t"]) > float(b[0]) + 0.001:
					over += 1
			for sp in spans:
				if float(lead["t"]) < float(sp[1]) and float(lead["end_t"]) > float(sp[0]):
					apart += 1
			spans.append([float(lead["t"]), float(lead["end_t"])])
		for s in Gap.steps(plan["gap"]):
			if float(s["m"]) > 0.0 and float(s["end_t"]) - float(s["t"]) < Gap.STEP_S - 0.001 and float(s["end_t"]) < 29.0:
				# a step OUT (the gap grows) a viewer can count: the leave and the ease to rest, never the pocket's quick one
				if absf(float(s["m"]) - Gap.STEP_OUT_M) < 0.004:
					short += 1
					print("  short step out: seed %d %s %.2f-%.2f %.2f m" % [seed, str(s["who"]), float(s["t"]), float(s["end_t"]), float(s["m"])])
		same = same and JSON.stringify(plan["tracks"]) == JSON.stringify(again["tracks"])
		if seed == 0:
			var plain: Dictionary = Choreo.plan(beats, db, opts.merged({"drift": false}))
			_check((plain["tracks"]["a"] as Array).filter(func(e): return e.has("drift")).is_empty(), "RING drift off = the plan without ring steps")
	_check(n_ring >= 12 * 4, "RING the pair moves between exchanges (%d ring steps in 12 half-minutes)" % n_ring)
	_check(lonely == 0 and late == 0, "RING both men take every ring step, the other answering 0.06-0.14 s later (alone %d, off time %d)" % [lonely, late])
	_check(over == 0, "RING no ring step plays over a punch, a defence or a reaction (%d)" % over)
	_check(apart == 0, "RING one ring step at a time (%d overlap)" % apart)
	_check(short == 0, "WHOLE the step out after a burst takes a whole step's time (%d shorter than %.2f s)" % [short, Gap.STEP_S])
	_check(same, "SAME the same seed plans the same tracks")
	print("RINGSTEPS failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
