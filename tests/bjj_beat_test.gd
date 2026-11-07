extends SceneTree
## S398 BJJREAL step 3: the two-sided beat (BjjBeat) - both sides choose a beat, the initiative resolves first, a void
## move, grips, the 20-s stall count off a pin only; and the 33-s walk untouched while BEATS2 is off.

const BjjBeat := preload("res://scripts/rules/BjjBeat.gd")
const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _walk(belt: String, seed: int) -> Dictionary:
	var a := BjjOpp.generate(belt, str(BjjOpp.STYLE_ORDER[seed % 5]), hash("%d|beat_a" % seed))
	var b := BjjOpp.generate(belt, str(BjjOpp.STYLE_ORDER[(seed / 5) % 5]), hash("%d|beat_b" % seed))
	var rules := BjjTree.rules_for(belt)
	var r := RandomNumberGenerator.new()
	r.seed = hash("%d|beat_r" % seed)
	return BjjWalk.walk(a, b, [BjjTree.route(str(a["route"])).get("steps", []), BjjTree.route(str(b["route"])).get("steps", [])],
		int(rules["minutes"]), rules, r, {"no_mood": true})


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	# Off: the 33-s walk, no "works" key, the same result twice for a seed.
	var w0 := _walk("blue", 3)
	_check(not w0.has("works"), "BEATS2 off: the 33-s walk runs")
	_check(str(_walk("blue", 3)["how"]) == str(w0["how"]), "the walk is seeded")
	BjjTree.T["BEATS2"] = 1.0
	var keys := w0.keys()
	var works := 0
	var beats_ok := true
	var bell := 0
	var att := 0.0
	for s in 60:
		var w := _walk("white" if s % 2 == 0 else "black", s)
		for k in keys:
			_check(w.has(k), "the beat result has %s" % k)
		works += int(w["works"][0]) + int(w["works"][1])
		att += float(int(w["attempts"][0]) + int(w["attempts"][1])) / 2.0
		var path: Array = w["path"]
		for i in range(1, path.size()):
			# Path times never go back, and at most two rows (one a side) share a beat.
			beats_ok = beats_ok and float(path[i][3]) >= float(path[i - 1][3])
			if i >= 2 and is_equal_approx(float(path[i][3]), float(path[i - 2][3])):
				beats_ok = false
		if str(w["finish"]) == "":
			bell += 1
			_check(float(w["t"]) == float(BjjTree.rules_for("white" if s % 2 == 0 else "black")["minutes"]) * 60.0, "the bell at the match length")
	_check(beats_ok, "beats run forward, at most one move a side a beat")
	_check(works > 0, "sides work the grips (%d)" % works)
	_check(bell > 0, "some matches go to the bell (%d of 60)" % bell)
	print("  info 60 beat matches: %.1f attempts an athlete, %d grip beats, %d to the bell" % [att / 60.0, works, bell])
	# act_p: a grip stack and aggression raise it; clamped.
	var ctx := {"body": [{"aggression": 50.0}, {"aggression": 90.0}]}
	var st := {"grip": [0.0, 0.0]}
	var p0 := BjjBeat.act_p(ctx, st, 0)
	st["grip"][0] = 2.0
	_check(BjjBeat.act_p(ctx, st, 0) > p0, "a grip stack makes an attempt likelier")
	_check(BjjBeat.act_p(ctx, {"grip": [0.0, 0.0]}, 1) > p0, "an aggressive side acts more")
	BjjTree.T["ACT_P"] = 5.0
	_check(BjjBeat.act_p(ctx, st, 1) <= 0.95, "act_p is clamped")
	BjjTree.reset_tuning()
	print("BJJ_BEAT %s failures=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
