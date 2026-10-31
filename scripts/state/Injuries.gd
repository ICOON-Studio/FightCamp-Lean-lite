extends RefCounted
## S325 update 28 injuries and suspensions (make-it-a-game plan decision 2; the rules are InjuryRoll, Qwen INJURYROLL1).
## A bout rolls from its settled damage (the fight model's head damage - the 3D view never decides); a stoppage loss is
## England Boxing's suspension (30 days, longer for repeats); each week rolls a training injury from her load
## (TrainingLoad: the setting the player picks each week, S326 update 29).
## While she is out: no offers, a quarter of the training gains, and an injury that runs past a booked bout pulls her
## out (the club pays for the empty slot). Bouts._finish, Sim.step_day and Sim.end_week call in here.
## Fighter keys: "injury" {type, days_out, until_day} ({} = fit), "ko_history" [days], "load" [last 4 weeks' hours].

const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## The fight model's head damage is one number for the whole bout; InjuryRoll reads the WORST of the body's places. A bout
## between equals carries ~22 damage (each loses ~1.5 rounds: 8-18 a lost round, 2 a won one); x2.2 puts its worst place
## at ~50, where InjuryRoll gives the real ~6 % a bout (Alevras 2022).
const DAMAGE_TO_WORST := 2.2


static func out(c: Career, f: Dictionary) -> bool:
	var inj: Dictionary = f.get("injury", {})
	return not inj.is_empty() and c.day < int(inj["until_day"])


## The fighter page's Injuries row: "None", or InjuryRoll's line for the days still to go.
static func line(c: Career, f: Dictionary) -> String:
	if not out(c, f):
		return "None"
	var inj: Dictionary = f["injury"]
	return InjuryRoll.line({"type": inj["type"], "days_out": int(inj["until_day"]) - c.day})


## Training gains while out: the rest week's share.
static func gain_mult(c: Career, f: Dictionary) -> float:
	return TrainingLoad.gain("rest") if out(c, f) else 1.0


## This week's training setting for her: the player's pick on the Training page (S326 update 29), else Normal (Hard in
## camp). An injured fighter rests whatever the pick.
static func setting(f: Dictionary) -> String:
	var s := str(f.get("load_setting", ""))
	if TrainingLoad.SETTINGS.has(s):
		return s
	return TrainingLoad.default_for(not (f.get("camp", {}) as Dictionary).is_empty())


## Her load this week against her last four weeks (TrainingLoad.ratio): 1.0 = her usual.
static func ratio(f: Dictionary) -> float:
	return TrainingLoad.ratio(setting(f), f.get("load", TrainingLoad.fresh_history()))


## After the scorecards: the bout's roll. The result page reads m["injury"].
static func after_bout(c: Career, f: Dictionary, m: Dictionary) -> void:
	var head_stop := str(m.get("stopped", "")) != "" and str(m.get("outcome", "")) == "loss"
	var dmg := float((m.get("damage", {}) as Dictionary).get("a", 0.0))
	var history: Array = f.get("ko_history", [])
	var roll := InjuryRoll.bout_roll(_seed(c, f, 7), {"places": {"head": clampf(100.0 - dmg * DAMAGE_TO_WORST, 0.0, 100.0)},
		"rounds": (m["rounds"] as Array).size(), "head_stoppage": head_stop, "ko_history": history, "day": c.day})
	if head_stop:
		f["ko_history"] = history + [c.day]
	if bool(roll["injured"]):
		_hurt(c, f, roll, "in the fight")
		m["injury"] = line(c, f)


## At the week's end, per fighter: the training roll from her load, then this week's hours into her history.
static func end_week(c: Career) -> void:
	for f in c.fighters:
		var hist: Array = f.get("load", TrainingLoad.fresh_history())
		if out(c, f):
			f["load"] = TrainingLoad.push(hist, TrainingLoad.hours("rest"))
			continue
		var s := setting(f)
		var roll := InjuryRoll.training_roll(_seed(c, f, 3), TrainingLoad.hours(s), TrainingLoad.ratio(s, hist))
		f["load"] = TrainingLoad.push(hist, TrainingLoad.hours(s))
		if bool(roll["injured"]):
			_hurt(c, f, roll, "in training")


## Each day before the offers: no offers while she is out; back in the gym when the days are up.
static func day_tick(c: Career) -> void:
	for f in c.fighters:
		var inj: Dictionary = f.get("injury", {})
		if inj.is_empty():
			continue
		if out(c, f):
			f["next_offer_day"] = maxi(int(f["next_offer_day"]), int(inj["until_day"]))
		else:
			f["injury"] = {}
			c.add_news("%s is cleared to box again." % f["first"])


static func _hurt(c: Career, f: Dictionary, roll: Dictionary, where: String) -> void:
	var days := int(roll["days_out"])
	f["injury"] = {"type": str(roll["type"]), "days_out": days, "until_day": c.day + days}
	var what := line(c, f)
	c.add_news("%s %s: %s." % [f["first"], "is suspended after the stoppage" if str(roll["type"]) == "ko" else "is hurt " + where, what])
	for o in f["offers"]:
		o["answered"] = true
	var b: Dictionary = f["bout"]
	if not b.is_empty() and not bool(b["done"]) and int(b["day"]) < c.day + days:
		c.pay(-BoutRules.MISSED_WEIGHT_COST, "Empty slot: %s injured" % f["first"])
		c.add_news("%s is out of the %s bout with %s. The club pays $%d for the empty slot." % [f["first"], Clock.fmt(int(b["day"])),
			b["opp"]["name"], BoutRules.MISSED_WEIGHT_COST])
		f["bout"] = {}
		f["camp"] = {}
		f["booked_fight"] = false
		f["opp_index"] = int(f["opp_index"]) + 1
	f["next_offer_day"] = maxi(int(f["next_offer_day"]), c.day + days)


static func _seed(c: Career, f: Dictionary, salt: int) -> int:
	return c.seed * 7919 + c.day * 977 + salt * 31 + absi(hash(str(f.get("id", ""))))
