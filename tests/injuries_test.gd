extends SceneTree
## S325 update 28 injuries and suspensions in the career: a stoppage loss suspends her (England Boxing ladder), an injury
## that runs past her booked bout pulls her out (empty-slot fee), no offers while she is out, she trains at the rest share,
## she is cleared when the days are up; the week's load goes into her history. Control arms: a fit fighter, a bout after the
## injury ends. Prints INJURIES failures=<n>.

const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)


func _career() -> Career:
	var c := Career.quick_start()
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.cash = 1000000
	return c


func _stoppage(c: Career, f: Dictionary) -> Dictionary:
	var m := {"rounds": [{}, {}], "stopped": "RSC", "outcome": "loss", "damage": {"a": 70.0, "b": 10.0}}
	Injuries.after_bout(c, f, m)
	return m


func _initialize() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	_check(not f.is_empty(), "a fighter is signed")
	_check(Injuries.line(c, f) == "None" and not Injuries.out(c, f) and Injuries.gain_mult(c, f) == 1.0, "control: a fit fighter reads None, full gains")

	# A stoppage loss: England Boxing's 30 days, on her record of head stoppages.
	c.day = 50
	var m := _stoppage(c, f)
	_check(str(f["injury"]["type"]) == "ko" and int(f["injury"]["days_out"]) == 30 and int(f["injury"]["until_day"]) == 80, "a stoppage loss suspends her 30 days: %s" % str(f.get("injury")))
	_check(f["ko_history"] == [50], "the stoppage goes on her record: %s" % str(f.get("ko_history")))
	_check(Injuries.line(c, f).begins_with("Suspended 30 days") and str(m.get("injury", "")) == Injuries.line(c, f), "the page and the result page read the suspension: %s" % Injuries.line(c, f))
	_check(Injuries.out(c, f) and is_equal_approx(Injuries.gain_mult(c, f), TrainingLoad.gain("rest")), "out: she trains at the rest share")
	_check(int(f["next_offer_day"]) >= 80, "no offers before she is cleared: next offer day %d" % int(f["next_offer_day"]))
	# A second stoppage inside 90 days: 90 days out.
	c.day = 85
	f["injury"] = {}
	_stoppage(c, f)
	_check(int(f["injury"]["days_out"]) == 90, "a second stoppage inside 90 days: 90 days out (%d)" % int(f["injury"]["days_out"]))

	# A win by stoppage is no suspension for her.
	var w := _career()
	var wf: Dictionary = w.fighter()
	w.day = 30
	Injuries.after_bout(w, wf, {"rounds": [{}], "stopped": "RSC", "outcome": "win", "damage": {"a": 0.0, "b": 60.0}})
	_check((wf.get("ko_history", []) as Array).is_empty() and str((wf.get("injury", {}) as Dictionary).get("type", "")) != "ko", "control: her stoppage win suspends nobody on her side")

	# An injury that runs past her booked bout pulls her out; the club pays for the empty slot.
	var p := _career()
	var pf: Dictionary = p.fighter()
	p.day = 20
	pf["bout"] = {"opp": {"name": "Dana Fox"}, "day": 30, "weighed": false, "made": false, "done": false, "film": 0}
	pf["camp"] = {"focus": "power", "protocol": 2}
	pf["offers"] = [{"id": "x", "answered": false}]
	var cash := p.cash
	Injuries._hurt(p, pf, {"type": "hand", "days_out": 35}, "in training")
	_check((pf["bout"] as Dictionary).is_empty() and (pf["camp"] as Dictionary).is_empty(), "a hand injury inside the bout pulls her out")
	_check(p.cash == cash - BoutRules.MISSED_WEIGHT_COST, "the club pays the empty slot: %d -> %d" % [cash, p.cash])
	_check(bool(pf["offers"][0]["answered"]), "open offers are withdrawn")
	_check(p.news.any(func(x): return str(x["t"]).contains("empty slot")) and p.news.any(func(x): return str(x["t"]).contains("Hand injury")), "the news reports both")
	# Control: an injury that heals before the bout keeps it.
	var k := _career()
	var kf: Dictionary = k.fighter()
	k.day = 20
	kf["bout"] = {"opp": {"name": "Dana Fox"}, "day": 40, "weighed": false, "made": false, "done": false, "film": 0}
	Injuries._hurt(k, kf, {"type": "strain", "days_out": 10}, "in training")
	_check(not (kf["bout"] as Dictionary).is_empty(), "control: a strain that heals before the bout keeps it")

	# No offers while out; cleared when the days are up; offers come again.
	var o := _career()
	var of: Dictionary = o.fighter()
	of["next_offer_day"] = o.day + 1
	Injuries._hurt(o, of, {"type": "ribs", "days_out": 21}, "in training")
	var until := int(of["injury"]["until_day"])
	var offers_while_out := 0
	while o.day < until - 1:
		Sim.step_day(o)
		o.review_pending = false
		offers_while_out += (of["offers"] as Array).size()
	_check(offers_while_out == 0, "no offers while she is out")
	for d in 12:
		Sim.step_day(o)
		o.review_pending = false
	_check((of.get("injury", {}) as Dictionary).is_empty() and o.news.any(func(x): return str(x["t"]).contains("cleared to box")), "cleared when the days are up")
	_check(not (of["offers"] as Array).is_empty(), "offers come again after: %d" % (of["offers"] as Array).size())

	# The week's load: normal 10 h, a hard camp 15 h, a rest week while out.
	var l := _career()
	var lf: Dictionary = l.fighter()
	_check(Injuries.setting(lf) == "normal", "a normal week out of camp")
	lf["camp"] = {"focus": "power", "protocol": 3}
	_check(Injuries.setting(lf) == "hard", "a hard camp trains hard")
	lf["camp"] = {}
	for d in 7:
		Sim.step_day(l)
	var hist: Array = lf.get("load", [])
	_check(hist.size() == TrainingLoad.HISTORY_WEEKS and float(hist[-1]) in [TrainingLoad.hours("normal"), TrainingLoad.hours("rest")], "the week's hours go into her history: %s" % str(hist))
	print("INJURIES failures=%d" % failures)
	quit(1 if failures > 0 else 0)
