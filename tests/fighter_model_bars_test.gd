extends SceneTree
## S398 the fighter model's bars held (FIGHTER_MODEL_S397.md v2.1 section 9; tools/fighter_bars.gd prints the full
## measurement). Light sizes so it runs in the suite: world upsets in bands and never certain (bar 4), reach long not
## inside (3), matchups move the chance at equal measured strength (1), no archetype beats every other (7), spiky and flat
## differ both ways (6), steering tells styles apart (9), random builds do not beat the best archetype by much (11).

const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const WB := preload("res://scripts/world/WorldBout.gd")
const Bars := preload("res://tools/fighter_bars.gd")

var failures := 0


func _initialize() -> void:
	_upsets()
	_reach()
	var lv := Bars.new().archetype_levels_quiet(6)
	_matchups(lv)
	_nonlinear_and_sensitivity(lv)
	_steering()
	_optimizer(lv)
	print("FIGHTER_BARS failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	print(("OK  " if ok else "FAIL ") + label)
	failures += 0 if ok else 1


func _upsets() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 4398
	var rates := {}
	for gap in [2.0, 5.0, 9.0, 18.0]:
		var w := 0
		var dec := 0
		for i in 500:
			var pa := AttrGen.generate(rng)
			var pb := AttrGen.generate(rng)
			var r := WB.fight({"rating": 62.0 + gap, "shape": pa["shape"], "pace": pa["pace"], "forward": pa["forward"], "heart": pa["heart"]},
				{"rating": 62.0, "shape": pb["shape"], "pace": pb["pace"], "forward": pb["forward"], "heart": pb["heart"]}, 3, rng)
			if str(r["winner"]) != "":
				dec += 1
				w += 1 if str(r["winner"]) == "a" else 0
		rates[gap] = float(w) / maxf(1.0, float(dec))
	_check(float(rates[2.0]) >= 0.52 and float(rates[2.0]) <= 0.68, "bar 4: a slight edge (+2) wins %.2f (target ~0.60)" % float(rates[2.0]))
	_check(float(rates[5.0]) >= 0.65 and float(rates[5.0]) <= 0.85, "bar 4: a clear edge (+5) wins %.2f (target ~0.75)" % float(rates[5.0]))
	_check(float(rates[9.0]) >= 0.78 and float(rates[9.0]) <= 0.95, "bar 4: a big edge (+9) wins %.2f (target ~0.88)" % float(rates[9.0]))
	_check(float(rates[18.0]) < 0.995, "bar 4: no gap is a certain win (+18 wins %.3f)" % float(rates[18.0]))


func _reach() -> void:
	var a := Bars.arche("Out-boxer", 60.0)
	var b := Bars.arche("Out-boxer", 60.0)
	a["reach"] = 186.0
	b["reach"] = 170.0
	var long := WB.chance(a, b, 6)
	var s1 := Bars.arche("Swarmer", 60.0)
	var s2 := Bars.arche("Swarmer", 60.0)
	s1["reach"] = 186.0
	s2["reach"] = 170.0
	var inside := WB.chance(s1, s2, 6)
	_check(long >= 0.56 and long <= 0.68, "bar 3: 16 cm of reach in a long fight wins %.2f (target 0.58-0.64)" % long)
	_check(absf(inside - 0.5) < 0.06, "bar 3: inside the reach is near nothing (%.2f)" % inside)


func _matchups(lv: Dictionary) -> void:
	var dev := 0.0
	var beats_all := 0
	for a in AttrGen.ARCHETYPES:
		var all := true
		for b in AttrGen.ARCHETYPES:
			if a == b:
				continue
			var c := WB.chance(Bars.arche(a, float(lv[a])), Bars.arche(b, float(lv[b])), 6)
			dev = maxf(dev, absf(c - 0.5))
			all = all and c > 0.5
		beats_all += 1 if all else 0
	_check(dev >= 0.10 and dev <= 0.15, "bar 1: at equal measured strength an archetype matchup moves the chance 10-15 points (largest %.2f)" % dev)
	_check(beats_all == 0, "bar 7: no archetype beats every other (%d do)" % beats_all)


func _nonlinear_and_sensitivity(lv: Dictionary) -> void:
	var flat := Bars.arche("Boxer-puncher", 60.0)
	for k in Attrs.ABILITIES:
		flat["attrs"][k] = 60.0
	var spiky := flat.duplicate(true)
	spiky["attrs"]["jab"] = 72.0
	spiky["attrs"]["footwork"] = 72.0
	spiky["attrs"]["inside"] = 48.0
	spiky["attrs"]["strength"] = 48.0
	spiky["attrs"]["forward"] = 25.0
	var shift := Attrs.overall(spiky["attrs"]) - 60.0
	for k in Attrs.ABILITIES:
		spiky["attrs"][k] = float(spiky["attrs"][k]) - shift
	var diffs: Array = []
	var field: Array = []
	for b in AttrGen.ARCHETYPES:
		var o := Bars.arche(b, float(lv[b]))
		field.append(o)
		diffs.append(WB.chance(spiky, o, 6) - WB.chance(flat, o, 6))
	diffs.sort()
	_check(float(diffs[0]) <= -0.10 and float(diffs[-1]) >= 0.10,
		"bar 6: a same-level spiky profile moves matchups both ways by 10+ points (%.2f to %+.2f)" % [float(diffs[0]), float(diffs[-1])])
	var base := Bars.arche("Boxer-puncher", 60.0)
	var b0 := Bars.field_of(base, field)
	var moves: Array = []
	var every_live := true
	for k in Attrs.ABILITIES + ["heart"]:
		var x := base.duplicate(true)
		x["attrs"][k] = float(x["attrs"][k]) + 10.0
		var best := 0.0
		for o in field:
			best = maxf(best, WB.chance(x, o, 6) - WB.chance(base, o, 6))
		every_live = every_live and best >= 0.02
		moves.append(Bars.field_of(x, field) - b0)
	moves.sort()
	var median := float(moves[moves.size() / 2])
	_check(every_live and float(moves[-1]) <= median * 3.0,
		"bar 8: every attribute matters and none moves the field over 3x median (median %.3f, top %.3f)" % [median, float(moves[-1])])


func _steering() -> void:
	var ob := Bars.arche("Out-boxer", 60.0)
	var slow := Bars.arche("Swarmer", 60.0)
	slow["attrs"]["speed"] = 50.0
	slow["attrs"]["footwork"] = 52.0
	var fast := Bars.arche("Stalker", 60.0)
	fast["attrs"]["speed"] = 66.0
	var s1 := float(WB.edges(ob, slow, 6)["share"][0])
	var s2 := float(WB.edges(ob, fast, 6)["share"][0])
	_check(s1 >= 0.65 and s2 <= 0.45, "bar 9: an out-boxer is long %.2f against a slow swarmer, %.2f against a fast stalker" % [s1, s2])


func _optimizer(lv: Dictionary) -> void:
	var field: Array = []
	for b in AttrGen.ARCHETYPES:
		field.append(Bars.arche(b, float(lv[b])))
	var best_arch := 0.0
	for b in AttrGen.ARCHETYPES:
		best_arch = maxf(best_arch, Bars.field_of(Bars.arche(b, float(lv[b])), field))
	var rng := RandomNumberGenerator.new()
	rng.seed = 77
	var best := 0.0
	for i in 60:
		var built := Bars.random_build(rng, 60.0)
		best = maxf(best, Bars.field_of(built, field))
	_check(best <= best_arch + 0.08, "bar 11: the best of 60 random builds %.3f vs the best archetype %.3f (<= +0.08)" % [best, best_arch])
