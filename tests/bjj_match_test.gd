extends SceneTree
## BjjMatch (S369 BJJMATCH1): the promises of the belt match rules - classes, scoring kinds, owned-only offers with odds
## and a miss cost, calls only on heavy settles, a submission ends it, the bell decides on points.

const M := preload("res://scripts/rules/BjjMatch.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

var failures := 0


func _initialize() -> void:
	var ana := NoGi.athlete()
	# 1. classes from GrappleMap tags
	_check(M.classify(["side_control", "top_kneeling"]) == "side_control", "side control tags -> side_control")
	_check(M.classify(["closed_guard", "bottom_supine"]) == "guard", "closed guard -> guard")
	_check(M.classify(["standing", "collar_tie"]) == "standing", "standing -> standing")
	_check(M.top_of([0.6, 0.2], "mount") == 0 and M.top_of([0.6, 0.2], "standing") == -1, "top = higher core; none standing")
	_check(M.classify(["bottom_supine", "top_kneeling"]) == "guard", "open guard (no guard tag) -> guard")
	_check(M.classify(["north_south"]) == "side_control" and M.classify(["quarter_guard"]) == "half_guard", "north-south pin, quarter guard")
	_check(not M.scoring_tags(["sacrifice_throw", "kimura", "throw"], ["kimura"]).has("kimura"), "a kimura-grip throw is no sub")
	_check(not M.scoring_tags(["kimura"], ["side_control"]).has("kimura"), "a kimura grip that lands on no kimura is no sub")
	_check(M.scoring_tags(["kimura"], ["kimura", "side_control"]).has("kimura"), "a kimura that lands on the kimura is a sub")
	# 2. kinds, from her side (woman 0)
	_check(M.kind_of([], "standing", "guard", -1, 0, 0) == "takedown", "standing -> ground on top = takedown")
	_check(M.kind_of([], "guard", "guard", 1, 0, 0) == "sweep", "bottom -> top = sweep")
	_check(M.kind_of([], "guard", "side_control", 0, 0, 0) == "pass", "guard -> side control on top = pass")
	_check(M.kind_of([], "side_control", "mount", 0, 0, 0) == "mount", "side control -> mount = mount")
	_check(M.kind_of(["kimura"], "side_control", "side_control", 0, 0, 0) == "sub", "a kimura tag = sub")
	_check(M.kind_of([], "side_control", "half_guard", 1, 1, 0) == "escape", "pinned -> half guard underneath = escape")
	_check(M.kind_of([], "mount", "mount", 0, 0, 0) == "", "an adjustment scores nothing")
	_check(M.points("pass") == 3 and M.points("mount") == 4 and M.points("sweep") == 2, "IBJJF points")
	# 3. offers: owned syllabus moves and plain ones only, best first, odds + miss words
	var st := M.start(ana, {"skill": 30.0})
	var cands := [
		{"i": 1, "title": "kimura from side", "tags": ["kimura"], "to_c": "side_control", "top_after": 0},       # owned 35
		{"i": 2, "title": "rnc", "tags": ["rear_naked_choke"], "to_c": "side_control", "top_after": 0},          # 12: never
		{"i": 3, "title": "step to mount", "tags": [], "to_c": "mount", "top_after": 0},                          # plain
		{"i": 4, "title": "adjust", "tags": [], "to_c": "side_control", "top_after": 0},                          # nothing
		{"i": 5, "title": "knee on belly", "tags": [], "to_c": "back", "top_after": 0}]
	var off := M.offers(st, ana, 0, "side_control", 0, cands)
	var ids := off.map(func(o): return int(o["i"]))
	_check(not ids.has(2), "a syllabus move she has not drilled is never offered")
	_check(not ids.has(4), "a move that does nothing is not offered")
	_check(ids.has(1) and ids.has(3), "owned kimura + plain mount offered")
	_check(off.size() <= M.OFFER_MAX, "at most 3 offers")
	var sorted_ok := true
	for k in range(1, off.size()):
		if float(off[k - 1]["ev"]) < float(off[k]["ev"]):
			sorted_ok = false
	_check(sorted_ok, "best expected points first (her plan's pick)")
	var all_words := true
	for o in off:
		if str(o["miss"]) == "" or float(o["odds"]) < M.ODDS_RANGE.x or float(o["odds"]) > M.ODDS_RANGE.y:
			all_words = false
	_check(all_words, "every offer has odds in range and the cost of a miss")
	var co := M.call_offers(off)
	_check(co.size() >= 2 and str(co.back()["kind"]) == "hold", "a call always has a choice: the moves + hold")
	_check(M.call_offers([]).size() == 1, "no move out: hold only")
	var hs := M.start(ana, {"skill": 30.0})
	hs["gas"][0] = 0.5
	M.resolve(hs, 0, M.HOLD, 0.99, true)
	_check(float(hs["gas"][0]) > 0.5 and int(hs["init"]) == 0 and int(hs["calls"]) == M.CALLS_PER_MATCH - 1, "hold: gas back, initiative kept, a call spent")
	# 4. odds: mastery and gas move them
	_check(M.odds("pass", 60.0, 30, 30, 1.0) > M.odds("pass", 30.0, 30, 30, 1.0), "more mastery, better odds")
	_check(M.odds("pass", 30.0, 30, 30, 0.4) < M.odds("pass", 30.0, 30, 30, 1.0), "tired, worse odds")
	_check(M.odds("pass", 30.0, 30, 30, 1.0, 70.0, 40.0) > M.odds("pass", 30.0, 30, 30, 1.0), "stronger, better pass odds")
	_check(is_equal_approx(M.odds("sub", 30.0, 30, 30, 1.0, 90.0, 10.0), M.odds("sub", 30.0, 30, 30, 1.0)), "strength does not move a sub")
	var fit := M.start({"bjj": {}, "stats": {"cardio": 80.0}}, {"skill": 30.0})
	var unfit := M.start({"bjj": {}, "stats": {"cardio": 30.0}}, {"skill": 30.0})
	for k in 5:
		M.resolve(fit, 0, {"title": "x", "kind": "pass", "odds": 0.0, "pts": 3}, 0.5)
		M.resolve(unfit, 0, {"title": "x", "kind": "pass", "odds": 0.0, "pts": 3}, 0.5)
	_check(float(fit["gas"][0]) > float(unfit["gas"][0]), "better cardio, slower gas drain")
	_check(is_equal_approx(M.stat({}, "strength"), M.STAT_DEFAULT), "no stats -> the default")
	# 5. calls only on a heavy settle held SETTLE_S, her initiative, calls left
	st = M.start(ana, {"skill": 30.0})
	_check(not M.can_call(st, "mount"), "no call before the settle holds")
	M.tick(st, M.SETTLE_S + 0.1, true)
	_check(M.can_call(st, "mount"), "a call on a held mount")
	_check(not M.can_call(st, "standing"), "never a call standing")
	_check(not M.can_call(st, "turtle"), "never a call in a scramble (turtle)")
	st["init"] = 1
	_check(not M.can_call(st, "mount"), "no call on her opponent's initiative")
	st["init"] = 0
	for k in M.CALLS_PER_MATCH:
		M.resolve(st, 0, {"title": "x", "kind": "pass", "odds": 1.0, "pts": 3}, 0.0, true)
	M.tick(st, M.SETTLE_S + 0.1, true)
	_check(int(st["calls"]) == 0 and not M.can_call(st, "mount"), "3 calls a match, then none")
	_check(int(st["pts"][0]) == 9, "three passes = 9 points")
	# 6. a miss costs gas and the initiative; a sub ends it
	st = M.start(ana, {"skill": 30.0})
	var g0 := float(st["gas"][0])
	M.resolve(st, 0, {"title": "x", "kind": "sweep", "odds": 0.0, "pts": 2}, 0.5)
	_check(int(st["init"]) == 1 and float(st["gas"][0]) < g0 - M.MOVE_GAS, "a miss: initiative over, gas spent")
	M.resolve(st, 1, {"title": "Kimura", "kind": "sub", "odds": 1.0, "pts": 0}, 0.0)
	_check(bool(st["over"]) and int(st["winner"]) == 1 and str(st["how"]).begins_with("submission"), "a submission ends it")
	# 7. the bell: white belt 5 min, points decide, level = draw
	st = M.start(ana, {"skill": 30.0})
	_check(is_equal_approx(float(st["limit_s"]), 300.0), "white belt match = 5:00")
	st["pts"] = [4, 2]
	M.tick(st, 301.0, false)
	_check(bool(st["over"]) and int(st["winner"]) == 0 and str(st["how"]) == "points 4-2", "the bell: points 4-2")
	st = M.start(ana, {"skill": 30.0})
	M.tick(st, 301.0, false)
	_check(int(st["winner"]) == -1 and str(st["how"]).begins_with("draw"), "level at the bell = draw")
	# 8. S369 the classes train her body: a year at 3 classes, slower near the ceiling, less while she teaches
	var yr := NoGi.athlete()
	for w in 52:
		NoGi.week(yr, w * 7)
	var cv := float(yr["stats"]["cardio"])
	var sv := float(yr["stats"]["strength"])
	_check(cv > 66.0 and cv < 69.0, "a year of classes: cardio 58 -> %.1f (~67)" % cv)
	_check(sv > 57.0 and sv < 59.5, "a year of classes: strength 52 -> %.1f (~58)" % sv)
	var hi := NoGi.athlete()
	hi["stats"]["cardio"] = 85.0
	_check(NoGi.body_gain(hi, "cardio") < NoGi.body_gain(NoGi.athlete(), "cardio"), "slower near her ceiling")
	var teach := NoGi.athlete()
	teach["teaches"] = true
	_check(NoGi.body_gain(teach, "cardio") < NoGi.body_gain(NoGi.athlete(), "cardio"), "teaching a class = less gain")
	var old_save := NoGi.athlete()
	old_save.erase("stats")
	NoGi.week(old_save, 0)
	_check(float(old_save["stats"]["cardio"]) > NoGi.BODY_START, "a save without stats starts at %d and trains" % int(NoGi.BODY_START))
	# S376 BJJMENU1: the move menu's numbers - gas on a hit / a miss by cardio, a hold gives gas back, risk words by miss
	# chance x what a miss loses (a submission most).
	var gs := M.start({"belt": "white", "bjj": {}, "stats": {"cardio": 50.0}}, {"stats": {"cardio": 80.0}})
	var pass_o := {"kind": "pass", "odds": 0.6, "pts": 3}
	var g := M.gas_cost(gs, 0, pass_o)
	_check(is_equal_approx(g.x, 2.0) and is_equal_approx(g.y, 8.0), "cardio 50: a move takes 2 of 100, a miss 8 (%s)" % str(g))
	var g1 := M.gas_cost(gs, 1, pass_o)
	_check(g1.x < g.x, "a fitter woman pays less gas (%.1f < %.1f)" % [g1.x, g.x])
	_check(M.gas_cost(gs, 0, M.HOLD).x < 0.0, "a hold gives gas back")
	_check(str(M.risk({"kind": "sub", "odds": 0.25})["word"]) == "High", "a 25 % submission is High risk")
	_check(str(M.risk({"kind": "pass", "odds": 0.7})["word"]) == "Low", "a 70 % pass is Low risk")
	_check(str(M.risk({"kind": "takedown", "odds": 0.5})["word"]) == "Medium", "a 50 % takedown is Medium risk")
	_check(str(M.risk(M.HOLD)["word"]) == "None", "a hold has no risk")
	print("BJJ_MATCH failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
