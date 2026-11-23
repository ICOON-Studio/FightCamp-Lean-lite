extends SceneTree
## S543 TURNPROBUILD17: the power edge confidence puts on every round of pro fights 1-6. Part 1: one FIXED edge K for every
## bout (read at -K, 0, +K) - it moves a near-even bout about twice as far as a safe one, so it cannot hold "about 5 points,
## never more" for both. Part 2: the edge SOLVED per bout (ProPair.conf_edge_for, what the game books), at confidence 0
## and 100. Ten boxers (TURNPROBE17's ten types: Data's Lucy and five prospects, four more of other styles, sexes and
## classes; never two identical), each against fight 1's SAFE and RISKY man (ProPair.make).
## Run: godot --headless --audio-driver Dummy --path . --script res://tools/conf_edge_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const ProPair := preload("res://scripts/state/ProPair.gd")
const KS := [2.0, 2.4, 2.6, 2.8, 3.0, 3.4]


func _person(base: Dictionary, over: Dictionary) -> Dictionary:
	var p := base.duplicate(true)
	p.merge(over, true)
	return p


func _people() -> Array:
	var tpl: Dictionary = Data.PROSPECTS[0]
	var lucy := Data.lucy()
	lucy["personality"] = (tpl["personality"] as Dictionary).duplicate()
	var ps: Array = [lucy]
	for p in Data.PROSPECTS:
		ps.append(p.duplicate(true))
	ps.append(_person(tpl, {"id": "nell", "name": "Nell Ward", "first": "Nell", "sex": "f", "age": 27, "wc": "Light middleweight", "div": "wlm", "weight": 70.8,
		"stance": "southpaw", "style": "Counter-puncher", "pot": 72, "stats": {"power": 60.0, "speed": 61.0, "technique": 66.0, "defense": 65.0, "conditioning": 60.0, "fight_iq": 66.0, "chin": 60.0}}))
	ps.append(_person(tpl, {"id": "reece", "name": "Reece Doyle", "first": "Reece", "sex": "m", "age": 19, "wc": "Featherweight", "div": "mfw", "weight": 55.8,
		"stance": "orthodox", "style": "Out-boxer", "pot": 90, "stats": {"power": 52.0, "speed": 63.0, "technique": 56.0, "defense": 55.0, "conditioning": 57.0, "fight_iq": 54.0, "chin": 58.0}}))
	ps.append(_person(tpl, {"id": "bayo", "name": "Bayo Adams", "first": "Bayo", "sex": "m", "age": 29, "wc": "Middleweight", "div": "mmw", "weight": 75.9,
		"stance": "orthodox", "style": "Slugger", "pot": 70, "stats": {"power": 70.0, "speed": 54.0, "technique": 57.0, "defense": 53.0, "conditioning": 58.0, "fight_iq": 57.0, "chin": 70.0}}))
	ps.append(_person(tpl, {"id": "kai", "name": "Kai Turner", "first": "Kai", "sex": "m", "age": 22, "wc": "Light welterweight", "div": "mlm", "weight": 65.8,
		"stance": "orthodox", "style": "Volume puncher", "pot": 80, "stats": {"power": 57.0, "speed": 62.0, "technique": 60.0, "defense": 58.0, "conditioning": 66.0, "fight_iq": 58.0, "chin": 55.0}}))
	return ps


func _initialize() -> void:
	var worst := {}
	var ps := _people()
	for i in ps.size():
		var c := Career.quick_start()
		c.seed = 9100 + i * 37
		c.first_hour = {}
		FirstWeek.skip(c)
		c.applicant = (ps[i] as Dictionary).duplicate(true)
		Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
		Sim.hire(c, "reid")
		var f: Dictionary = c.fighter()
		var coach := float(c.coach.get("rating", 0.0))
		var p := ProPair.make(c, f, 1, 1500)
		for kind in ["safe", "risky"]:
			var opp: Dictionary = p[kind]["opp"]
			var mid := ProPair.read(f, opp, coach, 0.0)
			for k in KS:
				var up := ProPair.read(f, opp, coach, k) - mid
				var down := mid - ProPair.read(f, opp, coach, -k)
				worst[k] = maxf(float(worst.get(k, 0.0)), maxf(absf(up), absf(down)))
				print("CONF %s | %s %s | %s | raw %.3f | K %.1f | conf 100 %+.1f pts | conf 0 %+.1f pts" % [f["name"], f.get("sex", "f"), f["style"], kind, mid, k, up * 100.0, -down * 100.0])
			var e100 := ProPair.conf_edge_for(f, opp, coach, mid, 100)
			var e0 := ProPair.conf_edge_for(f, opp, coach, mid, 0)
			var m100 := ProPair.read(f, opp, coach, e100) - mid
			var m0 := ProPair.read(f, opp, coach, e0) - mid
			worst["solved"] = maxf(float(worst.get("solved", 0.0)), maxf(absf(m100), absf(m0)))
			print("SOLVED | %s | %s %s | %s | raw %.3f | conf 100: edge %+.2f, %+.2f pts | conf 0: edge %+.2f, %+.2f pts" % [f["name"], f.get("sex", "f"), f["style"], kind, mid, e100, m100 * 100.0, e0, m0 * 100.0])
	print("SOLVED_MAX the largest move %.2f points" % (float(worst["solved"]) * 100.0))
	for k in KS:
		print("CONF_MAX K %.1f -> the largest move %.1f points" % [k, float(worst[k]) * 100.0])
	quit(0)
