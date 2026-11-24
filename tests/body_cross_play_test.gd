extends SceneTree
## BODYCROSS4 (S548): the rear straight to the body is thrown in the 3D fight, and no bout number knows.
## Pure (no scene, no body): RoundScript.shown / show (the hand a settled body punch is shown with), the v2 plan
## (Choreographer.plan: the take, the hit man's fold, the punch's time), ChoreoRules.is_body, the pick that never gives
## the close body hook where the pair can be set to range, and the table (assets/data/clip_db.json).
## The pictures are tools/bodycross4_ruler.gd's (60 seeds a pair, as drawn). Prints BODY_CROSS_PLAY failures=<n>.

const RS := preload("res://scripts/rules/RoundScript.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const React := preload("res://scripts/fight3d/v2/ChoreoReact.gd")
const Choreo := preload("res://scripts/fight3d/v2/Choreographer.gd")
const Census := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const ROUNDS := 240

var failures := 0
var db: Dictionary = {}


func _initialize() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(Census.DB_PATH))
	db = parsed if parsed is Dictionary else {}
	var rows: Dictionary = db.get("rows", {})
	# 1. THE HAND: the damage map's own side of the ribs, no draw
	var b := {"t": 3.2, "who": "a", "move": "body_hook", "result": "lands", "big": false}
	_check(RS.shown(b.merged({"side": "left"})) == "body_cross" and RS.shown(b.merged({"side": "right"})) == "body_hook", "SHOWN an orthodox boxer's rear hand lands on the other man's left ribs (a carried side wins)")
	_check(RS.shown(b.merged({"side": "left"}), true) == "body_hook" and RS.shown(b.merged({"side": "right"}), true) == "body_cross", "SHOWN a southpaw's rear hand is the liver's")
	_check(RS.shown({"t": 1.0, "who": "a", "move": "cross", "side": "left"}) == "cross" and RS.shown({"move": "body_hook"}) == "body_hook" and RS.shown({"t": 1.0, "who": "b", "move": "step_in"}) == "step_in", "SHOWN only a body punch changes hands")
	var agree := 0
	var body_n := 0
	var cross_n := 0
	for k in 2000:
		var hb := {"t": snappedf(0.37 * k, 0.01), "who": "a" if k % 2 == 0 else "b", "move": "body_hook", "result": "lands", "big": false}
		var place := str((BodyMap._punch_hits(hb, false)[0] as Dictionary)["place"])
		body_n += 1
		cross_n += 1 if RS.shown(hb) == "body_cross" else 0
		agree += 1 if (RS.shown(hb) == "body_cross") == (place == "left_ribs") else 0
	_check(agree == body_n, "SHOWN the picture hurts the side the damage map marks (%d of %d)" % [agree, body_n])
	_check(absf(float(cross_n) / float(body_n) - (1.0 - BodyMap.LIVER_SHARE)) < 0.05, "SHOWN the share is 1 - the liver share (%d of %d)" % [cross_n, body_n])
	# ... and inside a combination the hands alternate
	var combo: Array = [{"t": 1.0, "who": "a", "move": "jab", "result": "lands"}, b.merged({"t": 1.35, "side": "right"}, true), b.merged({"t": 1.7, "side": "left"}, true),
		{"t": 5.0, "who": "a", "move": "cross", "result": "lands"}, b.merged({"t": 5.35, "side": "left"}, true), b.merged({"t": 9.0, "side": "left"}, true), b.merged({"t": 12.0, "side": "left"}, true)]
	_check(RS.show(combo) == ["jab", "body_cross", "body_hook", "cross", "body_hook", "body_cross", "body_hook"], "SHOW after his lead hand the rear, after his rear the lead, never two running: %s" % [RS.show(combo)])
	# 2. THE ROUND IS WHAT IT WAS: 240 rounds as choreographer_test R14 builds them
	var with := 0
	var twice := 0
	var hooks := 0
	var settled := 0
	var counted := true
	for sd in ROUNDS:
		var round := {"n": 1, "won": true, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, "Slugger", "Slugger", 30.0, sd)["beats"]
		var was: Array = beats.duplicate(true)
		var plan: Dictionary = Choreo.plan(beats, db, {"t0": 0.0, "t1": 30.0, "gap0": R.REST_M, "seed": sd, "south": {"a": false, "b": false}})
		counted = counted and beats == was   # the plan never writes on the round
		var got := 0
		for k in beats.size():
			var ob: Dictionary = plan["beats"][k]
			counted = counted and str(ob["move"]) == str(beats[k]["move"]) and str(beats[k]["move"]) != "body_cross"
			settled += 1 if str(beats[k]["move"]) == "body_hook" and str(beats[k]["result"]) == "lands" else 0
		for side in ["a", "b"]:
			var last := ""
			for e in plan["tracks"][side]:
				if str(e.get("kind", "")) != "punch":
					continue
				var mv := str(e.get("move", ""))
				if str(e.get("result", "")) == "lands":
					got += 1 if mv == "body_cross" else 0
					hooks += 1 if mv == "body_hook" else 0
				twice += 1 if mv == "body_cross" and last == "body_cross" else 0
				counted = counted and (mv != "body_cross" or str(e.get("clip", "")) == "pro_body_cross")
				last = mv
		with += 1 if got > 0 else 0
	_check(counted, "CONTROL every beat keeps the move the bout settled; a body cross plays pro_body_cross")
	_check(with * 6 >= ROUNDS, "THROWN a body cross lands in at least 1 round in 6 (%d of %d)" % [with, ROUNDS])
	_check(twice == 0, "THROWN no boxer throws two body crosses running (%d)" % twice)
	_check(hooks * 2 >= settled, "LOOP the body hook keeps at least half its landed count (%d of %d)" % [hooks, settled])
	# 3. THE PLAN: a landed body cross - its take, its time, his fold
	var one: Array = [b.merged({"t": 1.5, "side": "left"}, true)]
	var hook: Array = [b.merged({"t": 1.5, "side": "right"}, true)]
	var px: Dictionary = Choreo.plan(one, db, {"t0": 0.0, "t1": 6.0, "gap0": R.REST_M, "seed": 7, "south": {"a": false, "b": false}})
	var ph: Dictionary = Choreo.plan(hook, db, {"t0": 0.0, "t1": 6.0, "gap0": R.REST_M, "seed": 7, "south": {"a": false, "b": false}})
	var ex := _event(px, "a", "punch")
	var eh := _event(ph, "a", "punch")
	var rx := _event(px, "b", "reaction")
	_check(str(ex.get("move", "")) == "body_cross" and str(ex.get("clip", "")) == "pro_body_cross" and bool(ex.get("own", false)), "PLAN the rear straight to the body, on its own keys: %s %s" % [ex.get("move", ""), ex.get("clip", "")])
	_check(is_equal_approx(float(ex.get("contact_t", 0.0)), float(eh.get("contact_t", -1.0))), "PLAN it lands when the settled body punch lands (%.3f, the hook %.3f)" % [float(ex.get("contact_t", 0.0)), float(eh.get("contact_t", -1.0))])
	_check(str(px["beats"][0].get("shown", "")) == "body_cross" and str(px["beats"][0]["move"]) == "body_hook", "PLAN the beat says what was shown beside what was settled")
	var fold: Array = (rows.get(str(rx.get("clip", "")), {}) as Dictionary).get("fold_g", [])
	_check(str(rx.get("move", "")) == "body_cross" and not fold.is_empty() and React.fold_shown(fold, float(rx.get("from_s", 0.0)), React.BODY_FOLD_S, 30.0) >= React.BODY_FOLD_MIN_DEG, "PLAN he folds on the blow (%s)" % str(rx.get("clip", "")))
	_check(str(eh.get("clip", "")) == "pro_kidney_shot", "PICK from rest a body hook is never the close take (%s)" % str(eh.get("clip", "")))
	# 4. THE RULES AND THE TABLE
	_check(R.is_body("body_hook") and R.is_body("body_cross") and not R.is_body("cross") and R.is_punch("body_cross") and not R.is_left_hand("body_cross") and not R.is_straight("body_cross"), "RULES a body punch is one helper; the body cross is the rear hand's")
	_check(R.range_kind("body_cross") == "body" and is_equal_approx(R.impact_s_for("body_cross"), R.impact_s_for("body_hook")) and R.react_size_for("body_cross", true) == "medium" and is_equal_approx(R.react_peak_s("body_cross"), R.REACT_FOLD_S), "RULES range, time and answer are the body punch's")
	var row: Dictionary = rows.get("pro_body_cross", {})
	_check(bool(row.get("played", false)) and (db.get("played", []) as Array).has("pro_body_cross") and str(row.get("family", "")) == "body_cross" and (row.get("drop", [1]) as Array).is_empty(), "TABLE pro_body_cross is played")
	_check(Census.takes_for(db, "body_cross", 0.9) == ["pro_body_cross"] and not Census.takes_for(db, "cross", 0.9).has("pro_body_cross") and not Census.takes_for(db, "body_hook", 0.9).has("pro_body_cross"), "TABLE its own family: no other pool picks it")
	for n in R.NO_PUNCH_READ + R.OWN_KEYS:
		_check(rows.has(n), "TABLE %s is a take" % n)
	print("BODY_CROSS_PLAY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _event(plan: Dictionary, side: String, kind: String) -> Dictionary:
	for e in plan["tracks"][side]:
		if str(e.get("kind", "")) == kind:
			return e
	return {}


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
