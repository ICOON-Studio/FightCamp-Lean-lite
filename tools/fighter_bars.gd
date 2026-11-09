extends SceneTree
## S398 the fighter model's bars (FIGHTER_MODEL_S397.md v2 section 9), measured on the world's fast path (WorldBout: the
## same ladder, duels, states, form and dice as a watched bout, no corner). Prints BAR lines; the doc's section 10 quotes them.
##   <godot.exe> --headless --path . --script res://tools/fighter_bars.gd [-- quick]

const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const WB := preload("res://scripts/world/WorldBout.gd")

var quick := false


func _initialize() -> void:
	quick = OS.get_cmdline_user_args().has("quick")
	upsets()
	var lv := archetype_levels(6)
	matrix(lv, 6)
	reach()
	steering()
	nonlinear(lv)
	sensitivity(lv)
	optimizer(lv)
	quit(0)


static func arche(name: String, level: float) -> Dictionary:
	var a := {}
	var t := AttrGen.tilt_of(name)
	for k in Attrs.ABILITIES + Attrs.PUNCHES:
		a[k] = level + float(t.get(k, 0.0))
	var d: Array = AttrGen.DIALS[name]
	a["pace"] = float(d[0])
	a["forward"] = float(d[1])
	a["heart"] = 60.0
	return {"attrs": a}


## World upsets: random generated pairs `gap` levels apart, rolled bouts, by rounds.
func upsets() -> void:
	var n := 300 if quick else 1000
	var rng := RandomNumberGenerator.new()
	rng.seed = 398
	for rounds in [3, 6, 10]:
		var row := []
		for gap in [2.0, 5.0, 9.0, 13.0, 18.0]:
			var w := 0
			var dec := 0
			for i in n:
				var pa := AttrGen.generate(rng)
				var pb := AttrGen.generate(rng)
				var a := {"rating": 62.0 + gap, "shape": pa["shape"], "pace": pa["pace"], "forward": pa["forward"], "heart": pa["heart"], "name": "a%d" % i}
				var b := {"rating": 62.0, "shape": pb["shape"], "pace": pb["pace"], "forward": pb["forward"], "heart": pb["heart"], "name": "b%d" % i}
				var r := WB.fight(a, b, rounds, rng)
				if str(r["winner"]) != "":
					dec += 1
					w += 1 if str(r["winner"]) == "a" else 0
			row.append("+%d %.2f" % [int(gap), float(w) / maxf(1.0, float(dec))])
		print("BAR4 upsets rounds=%d n=%d: %s   (targets 3 rounds: +2 ~0.60, +5 ~0.75, +9 ~0.88, never above ~0.95)" % [rounds, n, "  ".join(PackedStringArray(row))])


## Levels that give every archetype an even record against the field (equal MEASURED strength, systems critic).
func archetype_levels(rounds: int) -> Dictionary:
	var lv := {}
	for a in AttrGen.ARCHETYPES:
		lv[a] = 60.0
	for it in 6:
		var avg := {}
		for a in AttrGen.ARCHETYPES:
			var s := 0.0
			for b in AttrGen.ARCHETYPES:
				s += WB.chance(arche(a, float(lv[a])), arche(b, float(lv[b])), rounds)
			avg[a] = s / float(AttrGen.ARCHETYPES.size())
		for a in AttrGen.ARCHETYPES:
			lv[a] = float(lv[a]) + (0.5 - float(avg[a])) * 12.0
	var line := []
	for a in AttrGen.ARCHETYPES:
		line.append("%s %.1f" % [a, float(lv[a])])
	print("BAR1 levels for an even field record: %s" % ", ".join(PackedStringArray(line)))
	return lv


func matrix(lv: Dictionary, rounds: int) -> void:
	var dev := []
	print("BAR1 matrix (row's chance vs column, %d rounds, equal measured strength):" % rounds)
	var names: Array = AttrGen.ARCHETYPES
	print("BAR1      " + " ".join(PackedStringArray(names.map(func(x): return str(x).substr(0, 5)))))
	for a in names:
		var cells := []
		for b in names:
			var c := WB.chance(arche(a, float(lv[a])), arche(b, float(lv[b])), rounds)
			cells.append("%.2f " % c)
			if a != b:
				dev.append(absf(c - 0.5))
		print("BAR1 %-5s %s" % [str(a).substr(0, 5), " ".join(PackedStringArray(cells))])
	dev.sort()
	print("BAR1 matchup spread: median |chance-0.5| %.3f, max %.3f (bar: 0.10-0.15 for some pairs)" % [float(dev[dev.size() / 2]), float(dev[-1])])
	var beats_all := []
	for a in names:
		var all := true
		for b in names:
			if a != b and WB.chance(arche(a, float(lv[a])), arche(b, float(lv[b])), rounds) <= 0.5:
				all = false
		if all:
			beats_all.append(a)
	print("BAR7 profiles beating every archetype: %s (bar: none)" % str(beats_all))
	for a in names:
		var e := WB.edges(arche(a, float(lv[a])), arche("Boxer-puncher", float(lv["Boxer-puncher"])), rounds)
		print("BAR2 %-16s vs Boxer-puncher: places long %.2f pocket %.2f inside %.2f" % [a, float(e["share"][0]), float(e["share"][1]), float(e["share"][2])])


func reach() -> void:
	for pair in [["Out-boxer", "Out-boxer"], ["Swarmer", "Swarmer"], ["Boxer-puncher", "Boxer-puncher"]]:
		var a := arche(pair[0], 60.0)
		var b := arche(pair[1], 60.0)
		a["reach"] = 186.0
		b["reach"] = 170.0
		var c := WB.chance(a, b, 6)
		var e := WB.edges(a, b, 6)
		print("BAR3 reach +16 cm, %s vs %s: %.2f (long share %.2f, inside %.2f) (bar: 0.58-0.64 long fights, ~0.50 inside)" % [pair[0], pair[1], c, float(e["share"][0]), float(e["share"][2])])


func steering() -> void:
	var ob := arche("Out-boxer", 60.0)
	var slow := arche("Swarmer", 60.0)
	slow["attrs"]["speed"] = 50.0
	slow["attrs"]["footwork"] = 52.0
	var fast := arche("Stalker", 60.0)
	fast["attrs"]["speed"] = 66.0
	var e1 := WB.edges(ob, slow, 6)
	var e2 := WB.edges(ob, fast, 6)
	print("BAR9 steering: out-boxer long share vs slow swarmer %.2f (bar >= 0.65), vs fast stalker %.2f (bar <= 0.45)" % [float(e1["share"][0]), float(e2["share"][0])])


func nonlinear(lv: Dictionary) -> void:
	var flat := arche("Boxer-puncher", 60.0)
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
	var line := []
	var diffs := []
	for b in AttrGen.ARCHETYPES:
		var o := arche(b, float(lv[b]))
		var d := WB.chance(spiky, o, 6) - WB.chance(flat, o, 6)
		diffs.append(d)
		line.append("%s %+.2f" % [str(b).substr(0, 7), d])
	diffs.sort()
	print("BAR6 spiky (jab+footwork +12, inside+strength -12) minus flat, same mean: %s (bar: >=0.10 both ways)" % ", ".join(PackedStringArray(line)))


func sensitivity(lv: Dictionary) -> void:
	var base := arche("Boxer-puncher", 60.0)
	var field := []
	for b in AttrGen.ARCHETYPES:
		field.append(arche(b, float(lv[b])))
	var b0 := field_of(base, field)
	var moves := []
	for k in Attrs.ABILITIES + ["heart"]:
		var x := base.duplicate(true)
		x["attrs"][k] = float(x["attrs"][k]) + 10.0
		var best := 0.0
		for o in field:
			best = maxf(best, WB.chance(x, o, 6) - WB.chance(base, o, 6))
		moves.append([k, field_of(x, field) - b0, best])
	moves.sort_custom(func(p, q): return float(p[1]) > float(q[1]))
	var med := float(moves[moves.size() / 2][1])
	var line := []
	for m in moves:
		line.append("%s %+.3f/%+.3f" % [m[0], float(m[1]), float(m[2])])
	print("BAR8 +10 on one attribute (field average / best single matchup): %s" % ", ".join(PackedStringArray(line)))
	print("BAR8 median field move %.3f, top %.3f (bar: top <= 3x median; every attribute >= 0.02 vs some archetype)" % [med, float(moves[0][1])])


func optimizer(lv: Dictionary) -> void:
	var n := 60 if quick else 300
	var rng := RandomNumberGenerator.new()
	rng.seed = 77
	var field := []
	for b in AttrGen.ARCHETYPES:
		field.append(arche(b, float(lv[b])))
	var best_arch := 0.0
	for b in AttrGen.ARCHETYPES:
		best_arch = maxf(best_arch, field_of(arche(b, float(lv[b])), field))
	var builds := []
	for i in n:
		var raw := {}
		for k in Attrs.ABILITIES:
			raw[k] = rng.randfn(0.0, 8.0)
		var mean := Attrs.weighted(raw, 0.0)
		var a := {}
		for k in Attrs.ABILITIES:
			a[k] = 60.0 + float(raw[k]) - mean
		a["pace"] = rng.randf_range(20.0, 90.0)
		a["forward"] = rng.randf_range(15.0, 90.0)
		a["heart"] = 60.0
		builds.append([field_of({"attrs": a}, field), a])
	builds.sort_custom(func(p, q): return float(p[0]) > float(q[0]))
	var tops := {}
	for i in mini(10, builds.size()):
		var a: Dictionary = builds[i][1]
		var ks: Array = Attrs.ABILITIES.duplicate()
		ks.sort_custom(func(p, q): return float(a[p]) > float(a[q]))
		var key := ",".join(PackedStringArray(ks.slice(0, 3)))
		tops[key] = int(tops.get(key, 0)) + 1
	print("BAR7 optimizer: %d random builds at level 60; best %.3f vs best archetype %.3f (bar: <= +0.08); top-10 top-3 sets: %s" % [
		n, float(builds[0][0]), best_arch, str(tops)])


## The levels for an even field record, without printing (tests/fighter_model_bars_test.gd).
func archetype_levels_quiet(rounds: int) -> Dictionary:
	var lv := {}
	for a in AttrGen.ARCHETYPES:
		lv[a] = 60.0
	for it in 6:
		var avg := {}
		for a in AttrGen.ARCHETYPES:
			var s := 0.0
			for b in AttrGen.ARCHETYPES:
				s += WB.chance(arche(a, float(lv[a])), arche(b, float(lv[b])), rounds)
			avg[a] = s / float(AttrGen.ARCHETYPES.size())
		for a in AttrGen.ARCHETYPES:
			lv[a] = float(lv[a]) + (0.5 - float(avg[a])) * 12.0
	return lv


static func field_of(x: Dictionary, field: Array) -> float:
	var s := 0.0
	for o in field:
		s += WB.chance(x, o, 6)
	return s / float(field.size())


## A random build at one level: shape noise sd 8, re-centred, random dials.
static func random_build(rng: RandomNumberGenerator, level: float) -> Dictionary:
	var raw := {}
	for k in Attrs.ABILITIES:
		raw[k] = rng.randfn(0.0, 8.0)
	var mean := Attrs.weighted(raw, 0.0)
	var a := {}
	for k in Attrs.ABILITIES:
		a[k] = level + float(raw[k]) - mean
	a["pace"] = rng.randf_range(20.0, 90.0)
	a["forward"] = rng.randf_range(15.0, 90.0)
	a["heart"] = 60.0
	return {"attrs": a}
