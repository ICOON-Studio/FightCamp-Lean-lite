extends SceneTree
## S397 BJJREAL: the grappler's body and mat time (BjjBody), the bell (BjjRef) and the logit levers (BjjTree.odds), unit by unit.

const BjjBody := preload("res://scripts/rules/BjjBody.gd")
const BjjRef := preload("res://scripts/rules/BjjRef.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _edge(move_id: String) -> Dictionary:
	for id in BjjTree.data()["edges"]:
		var e: Dictionary = BjjTree.edge(id)
		if str(e["move"]) == move_id:
			return e
	return {}


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	var even := {}
	for k in BjjBody.ATTRS:
		even[k] = 50.0
	# Every READS row weighs 1.0 a side, so no kind counts more by reading more.
	for key in BjjBody.READS:
		for side in 2:
			var tot := 0.0
			for k in BjjBody.READS[key][side]:
				tot += float(BjjBody.READS[key][side][k])
				_check(BjjBody.ATTRS.has(k), "%s reads a real attribute (%s)" % [key, k])
			_check(is_equal_approx(tot, 1.0), "%s side %d weighs 1.0 (%.2f)" % [key, side, tot])
	# Even bodies cancel; the body reads only what the kind reads.
	var dl := _edge("double_leg")
	var pass_e := _edge("knee_cut_pass")
	var rnc := _edge("rear_naked_choke")
	var heel := _edge("inside_heel_hook")
	_check(not dl.is_empty() and not pass_e.is_empty() and not rnc.is_empty() and not heel.is_empty(), "the test edges exist")
	_check(is_equal_approx(BjjBody.shift(dl, even, even), 0.0), "even bodies: no shift")
	_check(BjjBody.read_key(dl) == "standing" and BjjBody.read_key(pass_e) == "pass", "a double leg reads standing, a pass reads pass")
	_check(BjjBody.read_key(rnc) == "choke" and BjjBody.read_key(heel) == "leg", "submissions read by family")
	var strong := even.duplicate()
	strong["strength"] = 80.0
	var flex := even.duplicate()
	flex["flexibility"] = 80.0
	_check(BjjBody.shift(pass_e, strong, even) > 0.10, "a strong passer passes more (%+.2f)" % BjjBody.shift(pass_e, strong, even))
	_check(BjjBody.shift(pass_e, even, flex) < -0.15, "a flexible guard keeps more (%+.2f)" % BjjBody.shift(pass_e, even, flex))
	_check(is_equal_approx(BjjBody.shift(pass_e, flex, even), 0.0), "the passer's flexibility is not read on a pass")
	var huge := even.duplicate()
	for k in BjjBody.ATTRS:
		huge[k] = 100.0
	var tiny := even.duplicate()
	for k in BjjBody.ATTRS:
		tiny[k] = 0.0
	_check(is_equal_approx(BjjBody.shift(pass_e, huge, tiny), BjjBody.CAP) and is_equal_approx(BjjBody.shift(pass_e, tiny, huge), -BjjBody.CAP),
		"the body is capped both ways")
	var pull := _edge("guard_pull")
	_check(is_equal_approx(BjjTree.odds(pull, 30.0, 30.0, BjjTree.rules_for("white"), false, 0.0, 0.0, 2.0), BjjTree.BASE_P), "a BASE move reads no lever")
	# The levers add on the logit: a zero shift is the GAMETREE1 number exactly; a shift is the same on any base rate.
	var w := BjjTree.rules_for("white")
	_check(is_equal_approx(BjjTree.odds(dl, 30.0, 30.0, w, false, 0.0, 0.0, 0.0), BjjTree.odds(dl, 30.0, 30.0, w)), "shift 0 = the old odds")
	var lo := BjjTree.odds(rnc, 30.0, 30.0, w)
	var lo2 := BjjTree.odds(rnc, 30.0, 30.0, w, false, 0.0, 0.0, 0.5)
	_check(absf(log(lo2 / (1.0 - lo2)) - log(lo / (1.0 - lo)) - 0.5) < 0.001, "a +0.5 shift is +0.5 on the logit (%.3f -> %.3f)" % [lo, lo2])
	# Gas: a tank, drained faster by low cardio; equal tanks cancel.
	_check(BjjBody.spend(1.0, "takedown", true, 30.0) < BjjBody.spend(1.0, "takedown", true, 70.0), "low cardio drains faster")
	_check(BjjBody.spend(1.0, "pass", false, 50.0) < BjjBody.spend(1.0, "pass", true, 50.0), "a miss costs more")
	_check(is_equal_approx(BjjBody.tank(0.4, 0.4), 0.0) and BjjBody.tank(0.9, 0.3) > 0.3, "equal tanks cancel, a fuller one pushes")
	_check(BjjBody.breathe(0.98) == 1.0, "a breath never fills past full")
	# The roll: seeded, shaped by the game, inside 20-90; old dicts read DEFAULT.
	var w1 := BjjBody.roll("Wrestler", 5)
	_check(str(w1) == str(BjjBody.roll("Wrestler", 5)), "the body is seeded")
	var sums := {}
	for st in BjjOpp.STYLE_ORDER:
		var acc := {}
		for s in 200:
			var b := BjjBody.roll(str(st), s)
			for k in b:
				_check(float(b[k]) >= 20.0 and float(b[k]) <= 90.0, "%s %s in 20-90" % [st, k])
				acc[k] = float(acc.get(k, 0.0)) + float(b[k]) / 200.0
		sums[st] = acc
	_check(float(sums["Wrestler"]["explosiveness"]) > float(sums["Guard player"]["explosiveness"]) + 8.0, "Wrestlers are explosive")
	_check(float(sums["Guard player"]["flexibility"]) > float(sums["Passer"]["flexibility"]) + 12.0, "Guard players are flexible")
	_check(float(sums["Passer"]["strength"]) > float(sums["Guard player"]["strength"]) + 12.0, "Passers are strong")
	_check(float(sums["Leg locker"]["aggression"]) > 60.0, "Leg lockers hunt")
	_check(is_equal_approx(BjjBody.attr({}, "flexibility"), 50.0) and BjjBody.attr({"stats": {"strength": 61.0}}, "strength") == 61.0,
		"a dict without the attribute reads 50 (old saves)")
	var cw := {"belt": "white", "stats": {"composure": 50.0}}
	var cb := {"belt": "black", "stats": {"composure": 50.0}}
	_check(float(BjjBody.attrs(cb)["composure"]) - float(BjjBody.attrs(cw)["composure"]) == 13.0, "composure grows with the belt, read time, for everyone")
	_check(float(BjjBody.attrs({"mat_call": "hunt"})["aggression"]) == 75.0 and float(BjjBody.attrs({"mat_call": "hold"})["aggression"]) == 30.0,
		"the player's call moves the aggression")

	# The bell: points, advantages, fewer penalties, then the more offensive side.
	var r := RandomNumberGenerator.new()
	r.seed = 1
	var t := BjjRef.new_tally()
	_check(int(BjjRef.decide([2, 0], [0, 3], t, r)["winner"]) == 0, "points first")
	_check(int(BjjRef.decide([2, 2], [0, 1], t, r)["winner"]) == 1 and str(BjjRef.decide([2, 2], [0, 1], t, r)["by"]) == "advantages", "then advantages")
	t["pen"] = [1, 0]
	_check(int(BjjRef.decide([0, 0], [0, 0], t, r)["winner"]) == 1, "then FEWER penalties")
	t = BjjRef.new_tally()
	BjjRef.attempt(t, 0, "submission")
	BjjRef.attempt(t, 1, "entry")
	var d := BjjRef.decide([0, 0], [0, 0], t, r)
	_check(int(d["winner"]) == 0 and str(d["by"]) == "decision" and not bool(d["call"]), "then the more offensive side, no coin")
	t = BjjRef.new_tally()
	var draws := [0, 0]
	for i in 400:
		draws[int(BjjRef.decide([0, 0], [0, 0], t, r)["winner"])] += 1
	_check(draws[0] > 150 and draws[1] > 150, "only exactly level tallies are a coin")
	# IBJJF ladder: a penalty every 2nd hold off a pin; 1st marked, 2nd an advantage, 3rd two points.
	t = BjjRef.new_tally()
	var got: Array = []
	for i in 6:
		got.append(BjjRef.hold(t, 1, "closed_guard_bottom"))
	_check(str(got) == str(["", "", "", "advantage", "", "points"]), "penalty ladder: %s" % str(got))
	t = BjjRef.new_tally()
	for i in 6:
		_check(BjjRef.hold(t, 0, "mount_top") == "" and BjjRef.hold(t, 1, "back_bottom") == "", "riding mount or defending the back is no stall")
	_check(int(t["pen"][0]) == 0 and int(t["pen"][1]) == 0, "no penalties on pins")
	t = BjjRef.new_tally()
	BjjRef.attempt(t, 0, "pass", false)
	BjjRef.attempt(t, 1, "pass", true)
	_check(float(t["off"][1]) == 2.0 * float(t["off"][0]), "a missed attempt counts half")

	# Mat time: the belt + the classes towards the next one; no jump at a promotion; the steps shrink up the belts.
	_check(is_equal_approx(BjjBody.mat_time({"belt": "white", "mat_classes": 200}), BjjBody.mat_time({"belt": "blue", "mat_classes": 0})),
		"a ready white = a fresh blue (no jump)")
	var blue := BjjBody.level("blue")
	_check(is_equal_approx(BjjBody.mat_time({"belt": "white", "mat_classes": 100}), blue / 2.0), "half way to blue = half the blue level")
	_check(is_equal_approx(BjjBody.mat_time({"belt": "blue", "mat_classes": 450, "mat_debt": 450}), blue), "classes owed do not count")
	var belts := ["white", "blue", "purple", "brown", "black"]
	var steps: Array = []
	for i in range(1, 5):
		steps.append(BjjBody.level(belts[i]) - BjjBody.level(belts[i - 1]))
	# S398 retuned: the probe fit (BJJ_REALISM_S397.md 8) set the steps 0.6 / 0.75 / 0.6 / 0.65 - the white->blue gap is
	# carried mostly by the move list (8-12 owned moves against 25-36), so mat time's own steps no longer shrink; the measured
	# one-belt win shares still do (0.88 / 0.72 / 0.76 / 0.64). Kept: every step real and bounded, the black belt's own the smallest.
	var ok_steps := true
	for x in steps:
		ok_steps = ok_steps and float(x) >= 0.4 and float(x) <= 1.0
	_check(ok_steps and float(BjjTree.T["MAT_TOP"]) <= float(steps.min()), "the steps are 0.4-1.0, black's own the smallest: %s" % str(steps))
	var ana := NoGi.athlete()
	_check(is_equal_approx(BjjBody.mat_time(ana), 0.65 * blue), "Ana: 130 of 200 classes = 0.65 of the white step")
	# The finish gate: a black belt is hard to finish, a white belt's locked choke rarely fails; mat time moves it.
	var am := BjjBody.escape_chance(BjjTree.rules_for("white"), 0.0)
	var pr := BjjBody.escape_chance(BjjTree.rules_for("black"), 0.0)
	_check(am < pr and is_equal_approx(am, float(BjjTree.T["ESC_AM"])), "escapes: white %.2f < black %.2f" % [am, pr])
	_check(BjjBody.escape_chance(BjjTree.rules_for("white"), 2.0) > 3.0 * am, "a black belt caught by a white belt gets out far more often")
	# S398: ESC_PRO 0.35 -> 0.5 (fitted: black even fields 56% by submission); a white belt (mat gap -2.6) still rarely gets out.
	_check(BjjBody.escape_chance(BjjTree.rules_for("black"), -BjjBody.level("black")) < 0.15, "a white belt caught by a black belt rarely does")

	print("BJJ_BODY %s failures=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)
