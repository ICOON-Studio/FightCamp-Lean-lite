extends SceneTree
## S398 the fighter model's pure parts: Attrs (migration, absorb, named training, overall, words), Duels (scale, nonlinear
## best tool, the ladder), AttrGen (shapes, age), WorldBout (a bout runs, chance is a chance). The bars live in
## tests/fighter_model_bars_test.gd.

const Attrs := preload("res://scripts/rules/Attrs.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	_migration()
	_absorb_and_train()
	_duels()
	_ladder()
	_gen()
	_world()
	print("FIGHTER_MODEL failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	if ok:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _flat(v: float) -> Dictionary:
	var a := {}
	for k in Attrs.ABILITIES + Attrs.PUNCHES:
		a[k] = v
	a["guard"] = v
	a["power"] = v
	a["heart"] = 55.0
	a["pace"] = 50.0
	a["forward"] = 50.0
	return a


func _migration() -> void:
	var f := Data.fighter_state(Data.lucy(), 0)
	var before: Dictionary = (f["stats"] as Dictionary).duplicate()
	var a := Attrs.of(f)
	var same := true
	for k in Attrs.LEGACY:
		same = same and absf(float(f["stats"][k]) - float(before[k])) < 0.001
	_check(same, "migration keeps the seven numbers exact (Lucy)")
	_check(a.size() >= Attrs.ABILITIES.size(), "every ability is there (%d)" % a.size())
	_check(float(a["jab"]) > float(a["hooks"]), "an out-boxer's jab sits above the hooks inside technique (%.1f > %.1f)" % [float(a["jab"]), float(a["hooks"])])
	var g := Data.fighter_state(Data.lucy(), 0)
	_check(str(Attrs.of(g)) == str(Attrs.of(f)), "the migration is the same every time (seeded by the id)")


func _absorb_and_train() -> void:
	var f := Data.fighter_state(Data.lucy(), 0)
	var a := Attrs.of(f)
	var acc := float(a["accuracy"])
	var tim := float(a["timing"])
	f["stats"]["technique"] = float(f["stats"]["technique"]) + 1.0   # an old writer (the peak camp, a decay)
	a = Attrs.of(f)
	_check(absf(float(a["accuracy"]) - acc - 1.0) < 0.001 and absf(float(a["timing"]) - tim - 1.0) < 0.001,
		"an old-stat change reaches every child")
	var t0 := float(f["stats"]["technique"])
	var e0 := float(a["stamina"])
	var r0 := float(a["recovery"])
	var got := Attrs.train(f, "conditioning", 0.4, ["stamina"])
	_check(absf(float(f["stats"]["conditioning"]) - (e0 + r0) * 0.5 - 0.4) < 0.001, "a named session still moves the old stat by its gain")
	_check(float(got.get("stamina", 0.0)) > float(got.get("recovery", 0.0)), "the named attribute gains most (%s)" % str(got))
	_check(absf(float(f["stats"]["technique"]) - t0) < 0.001, "other groups untouched")
	var s := Attrs.signature({"explosiveness": 80.0, "durability": 78.0, "accuracy": 40.0, "speed": 55.0, "footwork": 55.0})
	_check(s != "" and s.contains("-"), "signature line: two spikes and a hole (%s)" % s)


func _duels() -> void:
	var a := _flat(60.0)
	var b := _flat(60.0)
	_check(absf(float(Duels.at(a, b, Duels.POCKET, {})["edge"])) < 0.001, "equal profiles: no edge")
	var c := _flat(65.0)
	_check(absf(float(Duels.at(c, b, Duels.POCKET, {})["edge"]) - 5.0) < 0.01, "5 points better everywhere = 5 power points")
	var spiky := _flat(60.0)
	spiky["jab"] = 80.0
	spiky["footwork"] = 70.0
	spiky["timing"] = 45.0
	spiky["straight"] = 45.0
	var e := float(Duels.at(spiky, b, Duels.LONG, {})["edge"])
	_check(e > 3.0, "a spike is a weapon: the jab wins long though the profile is near level (%.1f)" % e)
	var reach := float(Duels.at(a, b, Duels.LONG, {"reach": 16.0})["edge"])
	var reach_in := float(Duels.at(a, b, Duels.INSIDE, {"reach": 16.0})["edge"])
	_check(reach > 1.0 and absf(reach_in) < 0.001, "reach counts long only (%.1f long, %.1f inside)" % [reach, reach_in])
	var tired := Duels.effective(a, 10.0, false, false)
	_check(float(tired["guard"]) < float(a["guard"]) and float(tired["power"]) > float(tired["guard"]), "tired: legs and defence go first")


func _ladder() -> void:
	var out := _flat(60.0)
	out["footwork"] = 75.0
	out["speed"] = 72.0
	out["forward"] = 20.0
	var slow := _flat(60.0)
	slow["speed"] = 48.0
	slow["footwork"] = 50.0
	slow["forward"] = 85.0
	var ex := Duels.expect(out, slow, {}, Duels.wants(out, slow, {}, Duels.LONG), Duels.wants(slow, out, {}, Duels.INSIDE), 6)
	var fast := slow.duplicate()
	fast["speed"] = 72.0
	fast["footwork"] = 78.0
	var ex2 := Duels.expect(out, fast, {}, Duels.wants(out, fast, {}, Duels.LONG), Duels.wants(fast, out, {}, Duels.INSIDE), 6)
	_check(float(ex["share"][0]) > float(ex2["share"][0]) + 0.1, "an out-boxer keeps a slow presser long more than a ring-cutter (%.2f vs %.2f)" % [float(ex["share"][0]), float(ex2["share"][0])])
	var total := 0.0
	for p in 3:
		total += float(ex["share"][p])
	_check(absf(total - 1.0) < 0.001, "the ladder's shares add up")


func _gen() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	var p := AttrGen.generate(rng, "Slugger")
	var mean := Attrs.weighted(p["shape"], 0.0)
	_check(absf(mean) < 0.001, "a shape has measured value 0 (the level is the rating)")
	_check(float(p["shape"]["explosiveness"]) > float(p["shape"]["speed"]), "a slugger hits harder than the hands are fast")
	var opp: Dictionary = Data.OPPONENTS[0]
	var s1 := AttrGen.shape_of(opp)
	_check(str(s1) == str(AttrGen.shape_of(opp)), "a fixed opponent is the same person every time")
	_check(float(s1["stamina"]) < 0.0, "'Fades after round 2' reads as a short engine (%.1f)" % float(s1["stamina"]))
	var a := AttrGen.attrs_of(opp)
	_check(absf(Attrs.overall(a) - float(opp["rating"])) < 1.0, "an opponent's overall is the rating (%.1f vs %.1f)" % [Attrs.overall(a), float(opp["rating"])])
	var old := {"rating": 70.0, "age": 36, "peak_age": 28, "name": "x", "style": "Boxer-puncher"}
	var young := old.duplicate()
	young["age"] = 24
	var ao := AttrGen.attrs_of(old)
	var ay := AttrGen.attrs_of(young)
	_check(float(ao["speed"]) < float(ay["speed"]) and float(ao["fight_iq"]) > float(ay["fight_iq"]), "age: slower hands, more fight IQ")


func _world() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	var a := {"attrs": _flat(65.0)}
	var b := {"attrs": _flat(60.0)}
	var wins := 0
	for i in 200:
		var r := WorldBout.fight(a, b, 6, rng)
		wins += 1 if str(r["winner"]) == "a" else 0
	var c := WorldBout.chance(a, b, 6)
	_check(c > 0.6 and c < 0.97, "a 5-point favourite is likely, never certain (chance %.2f)" % c)
	_check(absf(float(wins) / 200.0 - c) < 0.12, "the rolled bouts agree with the chance (%.2f vs %.2f)" % [float(wins) / 200.0, c])
	# The everyday path stays near the exact walk on real profiles (a slugger against an out-boxer, both generated).
	var g := RandomNumberGenerator.new()
	g.seed = 3
	var worst := 0.0
	for i in 20:
		var pa := AttrGen.generate(g)
		var pb := AttrGen.generate(g)
		var x := {"rating": 62.0, "shape": pa["shape"], "pace": pa["pace"], "forward": pa["forward"], "heart": pa["heart"]}
		var y := {"rating": 62.0 + float(i % 5), "shape": pb["shape"], "pace": pb["pace"], "forward": pb["forward"], "heart": pb["heart"]}
		worst = maxf(worst, absf(WorldBout.chance_of(WorldBout.quick_rows(x, y, 6)) - WorldBout.chance_of(WorldBout.edges(x, y, 6)["rounds"])))
	_check(worst < 0.06, "the everyday path is within 0.06 of the exact walk (worst %.3f over 20 pairs)" % worst)
