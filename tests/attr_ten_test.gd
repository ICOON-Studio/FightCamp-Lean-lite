extends SceneTree
## FIGHTERMODEL4A: the 10 primary attributes and 5 boxing skills. Seeded, headless. Opponents differ in level and style.

const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Data := preload("res://scripts/state/Data.gd")
const WB := preload("res://scripts/world/WorldBout.gd")
const WP := preload("res://scripts/rules/WeekPlan.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const Bars := preload("res://tools/fighter_bars.gd")

const LIST: Array[String] = ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility", "durability",
	"fight_iq", "composure", "heart", "accuracy", "timing", "defence", "footwork", "inside"]
const WIN: Array[String] = ["explosiveness", "speed", "stamina", "strength", "durability", "fight_iq", "accuracy",
	"timing", "defence", "footwork", "inside"]
const TRAINS := {
	"explosiveness": ["heavy_bag"], "speed": ["speed_bag"], "stamina": ["roadwork", "intervals"],
	"strength": ["strength", "heavy_bag"], "durability": ["neck"], "fight_iq": ["sparring"],
	"accuracy": ["shadow", "pads"], "timing": ["pads", "sparring"], "defence": ["slip_rope", "sparring"],
	"footwork": ["shadow"], "inside": ["sparring"], "recovery": ["rest"], "flexibility": ["mobility"],
	"composure": ["sparring"],
}
const PUNCHES: Array[String] = ["jab", "straight", "hooks", "uppercuts", "power", "hand_speed", "foot_speed"]

var failures := 0
var win_line := ""
var life_line := ""


func _initialize() -> void:
	_list()
	_migration()
	_wins()
	_life()
	_training()
	_footwork()
	print("ATTR_TEN win +10: %s" % win_line)
	print("ATTR_TEN life: %s" % life_line)
	print("ATTR_TEN failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL " + label)


func _list() -> void:
	var got: Array = Attrs.PRIMARY + Attrs.SKILLS
	_check(got == LIST, "the ten primary and five skills, in order")
	for p in PUNCHES:
		_check(not LIST.has(p) and not Attrs.ABILITIES.has(p), "no punch or hand key %s" % p)


func _migration() -> void:
	var f := Data.fighter_state(Data.lucy(), 0)
	var before: Dictionary = (f["stats"] as Dictionary).duplicate()
	f.erase("attrs")
	f.erase("footwork")
	Attrs.of(f)
	for k in Attrs.LEGACY:
		_check(absf(float(f["stats"][k]) - float(before[k])) < 0.001, "legacy %s reads back exact" % k)


func _wins() -> void:
	var field: Array = []
	for name in AttrGen.ARCHETYPES:
		field.append(Bars.arche(str(name), 62.0))
	var base := Bars.arche("Out-boxer", 58.0)
	var parts: PackedStringArray = []
	for k in WIN:
		var up: Dictionary = base.duplicate(true)
		up["attrs"][k] = float(up["attrs"][k]) + 10.0
		var sum := 0.0
		for o in field:
			sum += WB.chance(up, o, 6) - WB.chance(base, o, 6)
		var mean := sum / float(field.size())
		parts.append("%s %.4f" % [k, mean])
		_check(mean >= 0.01, "+10 %s field win chance %.4f" % [k, mean])
	win_line = " ".join(parts)


func _life() -> void:
	var low: Dictionary = Bars.arche("Boxer-puncher", 60.0)["attrs"]
	var high: Dictionary = low.duplicate()
	high["recovery"] = float(low["recovery"]) + 10.0
	var opp: Dictionary = Bars.arche("Swarmer", 60.0)["attrs"]
	var e0 := float(WB.tanks(low, opp, 6)[3]["a"][0])
	var e1 := float(WB.tanks(high, opp, 6)[3]["a"][0])
	_check(e1 > e0 + 0.2, "recovery +10 later-round energy %.2f -> %.2f" % [e0, e1])
	var ctx := {"stats": {"conditioning": 58.0, "power": 55.0, "speed": 55.0, "technique": 55.0, "defense": 55.0,
		"fight_iq": 55.0, "chin": 55.0}, "pot": 80, "coach": 60.0, "weight": 61.0, "diet": "hold", "recovery": 55.0}
	var fat0 := float(WP.day("roadwork", "normal", ctx, 40.0)["fatigue"])
	ctx["recovery"] = 65.0
	var fat1 := float(WP.day("roadwork", "normal", ctx, 40.0)["fatigue"])
	_check(fat1 < fat0 - 0.05, "recovery +10 clears fatigue %.2f -> %.2f" % [fat0, fat1])
	var hurt := Bars.arche("Out-boxer", 60.0)
	hurt["attrs"]["durability"] = 46.0
	hurt["attrs"]["composure"] = 48.0
	var slug := Bars.arche("Slugger", 64.0)
	var calm: Dictionary = hurt.duplicate(true)
	calm["attrs"]["composure"] = 58.0
	var c0 := WB.chance(hurt, slug, 6)
	var c1 := WB.chance(calm, slug, 6)
	_check(c1 > c0, "composure +10 when hurt %.4f -> %.4f" % [c0, c1])
	var flex0 := InjuryRoll.training_chance(12.0, 1.2, 40.0, 1.0, 55.0)
	var flex1 := InjuryRoll.training_chance(12.0, 1.2, 40.0, 1.0, 75.0)
	_check(flex1 <= flex0 * 0.9, "flexibility +20 injury chance %.4f -> %.4f" % [flex0, flex1])
	var stood0 := _stood(55.0)
	var stood1 := _stood(65.0)
	_check(stood1 > stood0, "heart +10 standing counts beaten %d -> %d" % [stood0, stood1])
	life_line = "recovery energy %.2f fatigue %.3f composure %.4f flexibility %.3f heart %d" % [e1 - e0, fat0 - fat1, c1 - c0,
		1.0 - flex1 / flex0, stood1 - stood0]


func _stood(heart: float) -> int:
	var sides := {"a": {"power": 78.0, "chin": 48.0, "heart": heart}, "b": {"power": 55.0, "chin": 70.0, "heart": 60.0}}
	var n := 0
	for seed in 240:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed
		var k := Knockdowns.round_counts("clear", "a", sides, {"a": 36.0, "b": 0.0}, {"a": 0, "b": 0}, rng)
		if int(k["counts"]) > 0 and not bool(k["stopped"]):
			n += 1
	return n


func _training() -> void:
	var cards: Array = WP.ORDER.duplicate()
	cards.append("pads")
	cards.append("sparring")
	for k in Attrs.ABILITIES:
		var rose := false
		for sid in TRAINS[k]:
			var f := _box("rise-%s-%s" % [k, sid])
			var was := float(Attrs.of(f)[k])
			_run(f, str(sid), 16)
			rose = rose or float(Attrs.of(f)[k]) > was + 0.02
		_check(rose, "%s rises from its card" % k)
		for sid in cards:
			if (TRAINS[k] as Array).has(sid):
				continue
			var f2 := _box("only-%s-%s" % [k, sid])
			var was2 := float(Attrs.of(f2)[k])
			_run(f2, str(sid), 8)
			_check(float(Attrs.of(f2)[k]) <= was2 + 0.001, "%s does not rise from %s (%.3f)" % [k, sid, float(Attrs.of(f2)[k]) - was2])
	var heart := _box("heart")
	var h0 := float(Attrs.of(heart)["heart"])
	for sid in cards:
		_run(heart, str(sid), 4)
	_check(absf(float(Attrs.of(heart)["heart"]) - h0) < 0.001, "heart is not trained")


func _footwork() -> void:
	var f := _box("feet")
	var a := Attrs.of(f)
	var mean := (float(a["speed"]) + float(a["defence"])) * 0.5
	_run(f, "shadow", 16)
	a = Attrs.of(f)
	_check(absf(float(a["footwork"]) - mean) > 0.05, "footwork leaves the speed/defence mean after shadow (%.2f vs %.2f)" % [float(a["footwork"]), mean])
	var g := _box("feet2")
	var fw := float(Attrs.of(g)["footwork"])
	g["stats"]["speed"] = float(g["stats"]["speed"]) + 5.0
	var a2 := Attrs.of(g)
	_check(absf(float(a2["footwork"]) - fw) < 0.001, "speed alone does not move footwork")
	_check(float(a2["speed"]) > float(a2["defence"]), "the speed change landed")


func _run(f: Dictionary, sid: String, times: int) -> void:
	for _i in times:
		if sid == "pads" or sid == "sparring":
			var r := WP.full_day("rest", "normal", sid, _ctx(f), 20.0)
			Attrs.apply_session(f, sid, str(r.get("stat2", "")), float(r.get("gain2", 0.0)))
		else:
			var d := WP.day(sid, "normal", _ctx(f), 20.0)
			if str(d["stat"]) != "":
				Attrs.apply_session(f, sid, str(d["stat"]), float(d["gain"]))
			elif float(d.get("attr_gain", 0.0)) > 0.0:
				Attrs.apply_session(f, sid, "", float(d["attr_gain"]))


func _ctx(f: Dictionary) -> Dictionary:
	return {"stats": f["stats"], "pot": 80, "coach": 60.0, "weight": 61.0, "diet": "hold"}


func _box(id: String) -> Dictionary:
	var stats := {}
	for k in Attrs.LEGACY:
		stats[k] = 55.0
	return {"id": id, "name": id, "style": "Out-boxer", "stats": stats, "personality": {"heart": 55.0, "temper": 55.0},
		"moves": {"Jab": 55.0, "Cross": 55.0, "Lead hook": 55.0, "Body hook": 55.0, "Uppercut": 55.0}, "footwork": 55.0}
