extends RefCounted
## S325 update 28 injuries and suspensions (make-it-a-game plan decision 2; the rules are InjuryRoll, Qwen INJURYROLL1).
## A bout rolls from its settled damage (the fight model's head damage - the 3D view never decides); a stoppage loss is
## England Boxing's suspension (30 days, longer for repeats); each week rolls a training injury from her load
## (TrainingLoad: the setting the player picks each week, S326 update 29).
## While she is out: no offers, a quarter of the training gains, and an injury that runs past a booked bout pulls her
## out (the club pays for the empty slot). Bouts._finish, Sim.step_day and Sim.end_week call in here.
## Fighter keys: "injury" {type, days_out, until_day, choice} ({} = fit), "ko_history" [days], "chronic" (her usual weekly hours, TrainingLoad's EWMA; S327 - was "load", the last 4 weeks).
## S327 (operator Q-S294-46: "option on player if he pulls out. needs to be clear to the player about how serious, how many
## weeks it the injury will heal, to judge"): every injury line says how serious and when she is fit; an injury that runs
## past a booked bout asks the player (choice "pending"): pull her out ($300 slot) or let her fight hurt (choice "fight":
## she starts the bout with less in the tank and the injury comes out of the fight worse). A head knock or a stoppage
## suspension is never a choice - no ringside doctor clears a boxer with a head injury (England Boxing medical rules).

const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## The fight model's head damage is one number for the whole bout; InjuryRoll reads the WORST of the body's places. A bout
## between equals carries ~22 damage (each loses ~1.5 rounds: 8-18 a lost round, 2 a won one); x2.2 puts its worst place
## at ~50, where InjuryRoll gives the real ~6 % a bout (Alevras 2022).
const DAMAGE_TO_WORST := 2.2
## S327 the doctor decides these, not the player.
const NO_CHOICE := ["ko", "head"]
## Fighting hurt: energy off her tank at the first bell by how serious it is (a sore hand or ribs = fewer, softer punches),
## and the days still to heal x WORSE_MULT after the bout (fighting on an unhealed injury aggravates it).
const HURT_ENERGY := {"minor": 10.0, "moderate": 15.0, "serious": 20.0}
const WORSE_MULT := 1.5


static func out(c: Career, f: Dictionary) -> bool:
	var inj: Dictionary = f.get("injury", {})
	return not inj.is_empty() and c.day < int(inj["until_day"])


## The fighter page's Injuries row: "None", or InjuryRoll's line for the days still to go.
static func line(c: Career, f: Dictionary) -> String:
	if not out(c, f):
		return "None"
	var inj: Dictionary = f["injury"]
	if str(inj["type"]) == "ko":
		return "%s - cleared on %s" % [InjuryRoll.line({"type": "ko", "days_out": int(inj["days_out"])}), Clock.fmt(int(inj["until_day"]))]
	var w := InjuryRoll.weeks_out(int(inj["until_day"]) - c.day)
	return "%s (%s) - heals in %s, fit on %s" % [InjuryRoll.NAMES[str(inj["type"])], severity(int(inj["days_out"])),
		"1 week" if w == 1 else "%d weeks" % w, Clock.fmt(int(inj["until_day"]))]


## How serious, from the days the injury costs in all: up to 2 weeks minor, up to 4 moderate, longer serious.
static func severity(days: int) -> String:
	if days <= 14:
		return "minor"
	if days <= 28:
		return "moderate"
	return "serious"


## True while the player has to decide: pull her out of the booked bout or let her fight hurt.
static func pending(f: Dictionary) -> bool:
	return str((f.get("injury", {}) as Dictionary).get("choice", "")) == "pending"


## The decision modal: what it is, how serious, when she is fit, the bout it runs past, what each way costs.
static func choice_modal(c: Career, f: Dictionary) -> Dictionary:
	var inj: Dictionary = f["injury"]
	var b: Dictionary = f["bout"]
	var sev := severity(int(inj["days_out"]))
	var weeks := int(ceil((int(b["day"]) - c.day) / 7.0))
	var body := "%s: %s.\n\nThe bout with %s is on %s, %s away - before the injury heals.\n\nPull out: the club pays $%d for the empty slot; rest and heal.\nFight hurt: the bout starts %d %% down on energy, and the %s comes out of the fight worse (%d %% longer to heal)." % [
		f["first"], line(c, f), b["opp"]["name"], Clock.fmt(int(b["day"])), "1 week" if weeks <= 1 else "%d weeks" % weeks,
		BoutRules.MISSED_WEIGHT_COST, int(HURT_ENERGY[sev]), str(InjuryRoll.NAMES[str(inj["type"])]).to_lower(), int((WORSE_MULT - 1.0) * 100)]
	return {"type": "info", "title": "%s is hurt before the bout" % f["first"], "body": body, "locked": true, "fid": f["id"],
		"buttons": [["Pull out ($%d)" % BoutRules.MISSED_WEIGHT_COST, "pullout", str(f["id"])], ["Fight hurt", "fighthurt", str(f["id"])]]}


## The player's call: she fights hurt. The bout keeps; the first bell takes the energy off her tank.
static func fight_hurt(c: Career, f: Dictionary) -> void:
	if not pending(f):
		return
	f["injury"]["choice"] = "fight"
	f["bout"]["hurt"] = HURT_ENERGY[severity(int(f["injury"]["days_out"]))]
	c.add_news("%s will fight %s hurt: %s." % [f["first"], f["bout"]["opp"]["name"], line(c, f)])


## Out of the booked bout: the club pays for the empty slot, the camp ends, the next opponent moves up.
static func pull_out(c: Career, f: Dictionary) -> void:
	var b: Dictionary = f["bout"]
	if b.is_empty() or bool(b["done"]):
		return
	if not (f.get("injury", {}) as Dictionary).is_empty():
		f["injury"]["choice"] = "out"
	if b.has("champ"):
		# S328 out of a championship round: no slot to pay for; Champs ends her run (day_events, or the pull-out action).
		f["champ"]["withdraw"] = true
		f["bout"] = {}
		f["camp"] = {}
		f["booked_fight"] = false
		return
	c.pay(-BoutRules.MISSED_WEIGHT_COST, "Empty slot: %s injured" % f["first"])
	c.add_news("%s is out of the %s bout with %s. The club pays $%d for the empty slot." % [f["first"], Clock.fmt(int(b["day"])),
		b["opp"]["name"], BoutRules.MISSED_WEIGHT_COST])
	f["bout"] = {}
	f["camp"] = {}
	f["booked_fight"] = false
	f["opp_index"] = int(f["opp_index"]) + 1


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


## Her load this week against her usual (TrainingLoad.ratio): 1.0 = her usual.
static func ratio(f: Dictionary) -> float:
	return TrainingLoad.ratio(setting(f), chronic(f))


## Her usual weekly hours; an old save's 4-week history is read once as its average.
static func chronic(f: Dictionary) -> float:
	if f.has("chronic"):
		return float(f["chronic"])
	if f.has("load"):
		return TrainingLoad.chronic_from_history(f["load"])
	return TrainingLoad.fresh_chronic()


## After the scorecards: the bout's roll. The result page reads m["injury"].
static func after_bout(c: Career, f: Dictionary, m: Dictionary) -> void:
	var inj: Dictionary = f.get("injury", {})
	if out(c, f) and str(inj.get("choice", "")) == "fight":
		var worse := roundi(float(int(inj["until_day"]) - c.day) * WORSE_MULT)
		inj["days_out"] = maxi(int(inj["days_out"]), worse)
		inj["until_day"] = c.day + worse
		inj["choice"] = ""
		c.add_news("%s fought hurt and it shows: %s." % [f["first"], line(c, f)])
		m["injury"] = line(c, f)
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


## At the week's end, per fighter: the training roll from her load, then this week's hours into her usual.
static func end_week(c: Career) -> void:
	for f in c.fighters:
		var usual := chronic(f)
		f.erase("load")
		if out(c, f):
			f["chronic"] = TrainingLoad.next_chronic(usual, TrainingLoad.hours("rest"))
			continue
		var s := setting(f)
		var roll := InjuryRoll.training_roll(_seed(c, f, 3), TrainingLoad.hours(s), TrainingLoad.ratio(s, usual))
		f["chronic"] = TrainingLoad.next_chronic(usual, TrainingLoad.hours(s))
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
	var was: Dictionary = f.get("injury", {})
	if out(c, f) and int(was["until_day"]) >= c.day + days:
		return   # S327 she is already out longer (e.g. fought hurt and it got worse): the old injury stands
	f["injury"] = {"type": str(roll["type"]), "days_out": days, "until_day": c.day + days, "choice": ""}
	var what := line(c, f)
	c.add_news("%s %s: %s." % [f["first"], "is suspended after the stoppage" if str(roll["type"]) == "ko" else "is hurt " + where, what])
	for o in f["offers"]:
		o["answered"] = true
	var b: Dictionary = f["bout"]
	if not b.is_empty() and not bool(b["done"]) and int(b["day"]) < c.day + days:
		if NO_CHOICE.has(str(roll["type"])):
			c.add_news("No doctor will clear %s with a head injury." % f["first"])
			pull_out(c, f)
		else:
			f["injury"]["choice"] = "pending"
			c.add_news("%s's bout with %s is on %s, before she is fit: you decide." % [f["first"], b["opp"]["name"], Clock.fmt(int(b["day"]))])
	f["next_offer_day"] = maxi(int(f["next_offer_day"]), c.day + days)


static func _seed(c: Career, f: Dictionary, salt: int) -> int:
	return c.seed * 7919 + c.day * 977 + salt * 31 + absi(hash(str(f.get("id", ""))))
